part of brickcrash;
/*
  Diese Klasse ist fuer alle bewegbare Objekte verantwortlich.
  Jeder Objekt, der sich bewegt, hat einen eigenen Timer, durch den er
  seine Positionen aktualisiert.

  Die Richtung des Objektes kann durch den Winkel eingestellt werden.
  Fuer jeden Objekt ist es moeglich, eigene Bewegungsstrategie anzugeben,
  mittels der uebergabe der Methode, der die Bewegungslogik beschreibt

  Jeder bewegbare Objekt kann die Kollisionen mit den Bricks, mit den Waenden und
  mit den Schlaeger erkennen.
  Die weitere Logik, was bei jeweilige Kollision getan wird, ist auch pro Objekt
  einstellbar.

  @author Mihail Usenko, Johann Schnitkov
  @version 1.0
 */

abstract class  MovableObject extends DOMObject {
  LevelModel level;
  Timer timer             = null;
  Random random           = new Random();
  Function moveFunction   = null;

  int duration      = 5;              //Zeitintevall fuer den Timer
  int angle         = 0;
  int speed         = 2;
  double directionX = 0.0;
  double directionY = 0.0;
  bool moving       = false;

  /*
    CONSTRUCTOR
   */
  /**
   * Die LevelModel Instanz wird gesetzt
   * @param level LevelModel - Instanz
   */
  MovableObject(LevelModel level) { this.level = level; }

  /*
    GETTER
   */
  int getSpeed()            { return this.speed; }
  int getDuration()         { return this.duration; }
  bool isMoving()           { return this.moving; }
  /*
    SETTER
   */
  void setSpeed(int speed)              { this.speed  = speed; }
  void setMoveFunction(Function func)   { this.moveFunction = func; }
  void setDuration(int duration)        { this.duration = duration; }

  /**
   * den Bewegungswinkel einstellen
   */
  void setAngle(int angle)              {
    this.angle  = angle;
    this.directionX = sin(angle * PI / 180)*this.speed;
    this.directionY = cos(angle * PI / 180)*this.speed;
  }

  /**
   * stellt eine zufaellige Richtung fuer den Objekt ein.
   */
  void setRandomDirection(int min, int max) {
    int direction    = this.random.nextInt(21) > 10 ? 1 : -1;       // positive / negative Winkel
    this.setAngle((this.random.nextInt(max-min)+min) * direction);  // diesen Winkel setzen
  }

  /*
    METHODS
   */

  /**
   * Das Objekt nach X-Koordinate bewegen
   * @param speed Pixelanzahl, um den das Objekt bewegt wird
   */
  void moveX(double speed)              { this.x += speed; }

  /**
   * Das Objekt nach Y-Koordinate bewegen
   * @param speed Pixelanzahl, um den das Objekt bewegt wird
   */
  void moveY(double speed)              { this.y -= speed; }

  /**
   * Das Objekt nach Links bewegen
   * @param speed Pixelanzahl, um den das Objekt bewegt wird
   */
  Future moveLeft(double speed) async   { this.moveX(-speed); }

  /**
   * Das Objekt nach Rechts bewegen
   * @param speed Pixelanzahl, um den das Objekt bewegt wird
   */
  Future moveRight(double speed) async  { this.moveX(speed); }

  /**
   * Das Objekt nach Oben bewegen
   * @param speed Pixelanzahl, um den das Objekt bewegt wird
   */
  void moveUp(double speed)             { this.moveY(speed); }

  /**
   * Allgemeine Bewegungsstrategie, kann in Unterklassen ueberladen werden!
   * @param timer wird von Timer selbst vergeben
   */
  void move(Timer timer) {
    // Die Kollisionen mit den Waenden erkennen und darauf reagieren
    if (!this.canMoveLeft())  { this.reactOnLeftWallCollision();  }   // Kollision mit den linken Wand
    if (!this.canMoveRight()) { this.reactOnRightWallCollision(); }   // Kollision mit den rechten Wand
    if (!this.canMoveUp())    { this.reactOnTopWallCollision();   }   // Kollision mit den oberen Wand

    // die Koordinaten erneuern
    this.moveY(this.directionY);
    this.moveX(this.directionX);

    // die Kollisionen mit den Bricks pruefen
    this.checkBeater();
  }

  /**
   * Das Objekt in Bewegung setzen
   * @param callback die Bewegungsstrategie
   */
  void startMoving(Function callback) {
    if (!this.isMoving()) {               // falls das Objekt sich noch nicht bewegt
      this.setMoveFunction(callback);     // die Bewegungsstrategie merken
      this.updateTimer();                 // und den Timer starten
      this.moving = true;                 // Ab jetzt ist das Objekt in Bewegung. Das wird gemerkt
    }
  }

  /**
   * den Timer aktualisieren
   */
  void updateTimer() {
    this.stop();    // den aktuellen Timer anhalten
    this.timer = new Timer.periodic(new Duration(milliseconds:  this.duration), this.moveFunction);
  }

  /**
   * Den Bewegungstimer unterbrechen
   */
  void stop() {
    if (this.isMoving()) {    // falls das Objekt sich bewegt
      this.moving = false;    // merken, dass das Objekt ab jetzt nicht mehr bewegen soll
      this.timer.cancel();    // und den Timer abbrechen
    }
  }

  /**
   * Den Objekt auf den Schlaeger platzieren
   */
  void placeOnBeater() {
    BeaterModel beater = this.level.getBeater();              // der Schlaeger
    int xMiddlePosition = this.getXPosition()+getXMiddle();   // Mitte von den Levelframe
    this.setYPosition(beater.getTop() - this.getHeight());    // Das Objekt soll mit untere Kante die obere Kante des Schlaegers beruehren!

    // Falls das Objekt zu weit links ist
    if (xMiddlePosition < beater.getLeft())   { this.setXPosition(beater.getXPosition()); }

    // falls das Objekt zu weitrechts ist
    if (xMiddlePosition > beater.getRight())  { this.setXPosition(beater.getRight()-this.getWidth()); }
  }

  /**
   * Pruefen, ob das Objekt auf den Schlaeger ist
   * @return true, wenn ja. false, wenn nicht
   */
  bool onBeater()       {
    if (this.getBottom() >= this.level.getBeater().getTop() &&                        // das Objekt hat die obere Schlaegerkante beruehrt,
        this.getBottom()-this.directionY.abs() <= this.level.getBeater().getTop() &&  // kleine Toleranz erlauben
        this.getRight() >= this.level.getBeater().getLeft() &&
        this.getLeft() <= this.level.getBeater().getRight()
    ) {
      this.placeOnBeater();     // um kleine ungenauigkeiten zu beheben (fuer bessere Kollisionserkennung)!
      return true;
    }
    return false;
  }

  /**
   * Kann das Objekt sich nach oben bewegen?
   * @return true, wenn ja. false, wenn nicht
   */
  bool canMoveUp()               { return this.getTop()     >  this.level.getTop() ? true : false;  }

  /**
   * Kann das Objekt sich nach links bewegen?
   * @return true, wenn ja. false, wenn nicht
   */
  bool canMoveLeft()             { return this.getLeft()    >  this.level.getLeft() ? true : false;  }

  /**
   * Kann das Objekt sich nach rechts bewegen?
   * @return true, wenn ja. false, wenn nicht
   */
  bool canMoveRight()            { return this.getRight()   <= this.level.getRight() ? true : false;  }

  /**
   * Kann das Objekt sich nach unten bewegen?
   * @return true, wenn ja. false, wenn nicht
   */
  bool canMoveDown()             { return this.getBottom()  <= this.level.getBottom() ? true : false;  }

  /**
   * Bewegt sich das Objekt gerade nach oben?
   * @return true, wenn ja. false, wenn nicht
   */
  bool isMovingUp()             { return this.directionY > 0; }

  /**
   * Bewegt sich das Objekt gerade nach unten?
   * @return true, wenn ja. false, wenn nicht
   */
  bool isMovingDown()           { return !this.isMovingUp(); }

  /**
   * Bewegt sich das Objekt gerade nach links?
   * @return true, wenn ja. false, wenn nicht
   */
  bool isMovingLeft()           { return this.directionX < 0; }


  /**
   * Bewegt sich das Objekt gerade nach rechts?
   * @return true, wenn ja. false, wenn nicht
   */
  bool isMovingRight()          { return !this.isMovingLeft(); }

  /**
   * Die X-Richtung spiegeln
   */
  void toggleXDirection()       { this.directionX *= -1; }

  /**
   * Die Y-Richtung spiegeln
   */
  void toggleYDirection()       { this.directionY *= -1; }


  /**
   *  die Kollision mit den Brick  von unten erkennen
   *  @param brick Brick, mit dem geprueft wird
   *  @return true, falls die Kollision erkannt wurde. false sonst
   */
  bool brickCollisionBottom(brick) {
    return (
        this.getTop() <= brick.getBottom() && (                // untere Grenze des Bricks erreicht
            (this.getRight()  >= brick.getLeft() &&  this.getRight()  <= brick.getRight()) ||
                (this.getLeft()   >= brick.getLeft() &&  this.getLeft()   <= brick.getRight())
        ) && this.getTop()    > brick.getBottom() -3                // der Ball befindet sich wirklich UNTER dem Brick!
    );
  }

  /**
   * Die Kollision mit den Brick  von Links erkennen
   *  @param brick Brick, mit dem geprueft wird
   *  @return true, falls die Kollision erkannt wurde. false sonst
   */
  bool brickCollisionLeft(brick) {
    return (
        this.getRight()    >= brick.getLeft() && (          // rechte Seite von Ball hat die linke Seite von Brick erreicht
            (this.getTop()     <= brick.getBottom()  &&  this.getTop()    >= brick.getTop()) ||
            (this.getBottom()  >= brick.getTop()     &&  this.getBottom() <= brick.getBottom()) ||
            (this.getTop()  <= brick.getTop() && this.getBottom() >= brick.getBottom())
        )&& this.getRight()    < brick.getRight()
    );
  }

  /**
   * Die Kollision mit den Brick  von Rechts erkennen
   *  @param brick Brick, mit dem geprueft wird
   *  @return true, falls die Kollision erkannt wurde. false sonst
   */
  bool brickCollisionRight(brick) {
    return (
        this.getLeft() <= brick.getRight() && (
            (this.getTop()     <= brick.getBottom()  &&  this.getTop()    >= brick.getTop()) ||
            (this.getBottom()  >= brick.getTop()     &&  this.getBottom() <= brick.getBottom()) ||
            (this.getTop() <= brick.getTop() && this.getBottom() >= brick.getBottom())
        ) && this.getLeft() > brick.getLeft()
    );
  }

  /**
   * Die Kollision mit den Brick von Oben erkennen
   *  @param brick Brick, mit dem geprueft wird
   *  @return true, falls die Kollision erkannt wurde. false sonst
   */
  bool brickCollisionTop(brick) {
    return (
        this.getBottom()   >= brick.getTop() && (
            (this.getRight()  >= brick.getLeft() &&  this.getRight()  <= brick.getRight()) ||
                (this.getLeft()   >= brick.getLeft() &&  this.getLeft()   <= brick.getRight())
        ) && this.getBottom() < brick.getTop() + 3
    );
  }

  /**
   * Die Kollision mit dem Schlaeger ueberpruefen
   */
  void checkBeater()  {
    BeaterModel beater = this.level.getBeater();

    if (this.getBottom() >= beater.getTop() &&
        this.getLeft() <= beater.getRight() &&
        this.getRight() >= beater.getLeft()
    ) {
      if (this.getLeft() >= beater.getRight()-5 || this.getRight() <= beater.getLeft() + 5 ){
        this.toggleXDirection();
      } else if (this.getTop() <= beater.getBottom()) {
        this.reactOnBeaterCollisionFromTop(beater);
      }
    }
  }

  /**
   * Diese Methode prueft, ob der Ball sich gerade mit irgendeinen Brick auf dem Feld kollidiert
   */
  void checkBricks() {
    List<BrickModel> bricks = this.level.bricks;

    // falls der Ball von Unten fliegt, werden die Baelle von unten durchgegangen
    if (this.isMovingUp()) { bricks = bricks.reversed; }

    bricks.forEach((brick){                     // jeden Brick durchgehen
      bool collision          = false;          // merken: bei dem Brick noch keine Kollision erkannt!

      if (!collision && this.isMovingUp() && this.brickCollisionBottom(brick))  {
        this.reactOnBrickCollisionFromBottom(brick);
        collision = true;
      } else if (!collision && this.isMovingDown() && this.brickCollisionTop(brick))   {
        this.reactOnBrickCollisionFromTop(brick);
        collision = true;
      } else if (!collision && this.isMovingLeft() && this.brickCollisionRight(brick))   {
        this.reactOnBrickCollisionFromRight(brick);
        collision = true;
      } else if (!collision && this.isMovingRight() && this.brickCollisionLeft(brick))   {
        this.reactOnBrickCollisionFromLeft(brick);
        collision = true;
      }

      if (collision) { this.reactOnBrickCollision(brick); }
    });
  }

  // Alle Kollisionen
  // koennen natuerlich ueberladen werden ( pro Objekt eigene Strategie )

  /**
   * Aktion, der bei jede Brick-Kollision ausgefuehrt wird
   */
  void reactOnBrickCollision(BrickModel);

  /**
   * Aktion, der bei Brick-Kollision von unten ausgefuehrt wird
   */
  void reactOnBrickCollisionFromBottom(BrickModel brick) { this.reactOnCollisionFromBottom(brick); }

  /**
   * Aktion, der bei Brick-Kollision von oben ausgefuehrt wird
   */
  void reactOnBrickCollisionFromTop(BrickModel brick) { this.reactOnCollisionFromTop(brick); }

  /**
   * Aktion, der bei Brick-Kollision von links ausgefuehrt wird
   */
  void reactOnBrickCollisionFromLeft(BrickModel brick) { this.reactOnCollisionFromLeft(brick); }

  /**
   * Aktion, der bei Brick-Kollision von rechts ausgefuehrt wird
   */
  void reactOnBrickCollisionFromRight(BrickModel brick) { this.reactOnCollisionFromRight(brick); }

  /**
   * Aktion, der bei Brick-Kollision von oben ausgefuehrt wird
   */
  void reactOnBeaterCollisionFromTop(BeaterModel beater) { this.reactOnCollisionFromTop(beater); }

  /**
   * Aktion, der bei Brick-Kollision von links ausgefuehrt wird
   */
  void reactOnBeaterCollisionFromLeft(BeaterModel beater) { this.reactOnCollisionFromLeft(beater); }

  /**
   * Aktion, der bei Brick-Kollision von rechts ausgefuehrt wird
   */
  void reactOnBeaterCollisionFromRight(BeaterModel beater) { this.reactOnCollisionFromRight(beater); }

  /**
   * Aktion, die bei der Kollision mit den linken Grenze ausgefuehrt wird
   */
  void reactOnLeftWallCollision() {
    this.setXPosition(this.level.getLeft());
    this.toggleXDirection();
  }

  /**
   * Aktion, die bei der Kollision mit den rechten Grenze ausgefuehrt wird
   */
  void reactOnRightWallCollision() {
    this.setXPosition(this.level.getRight()-this.getWidth());
    this.toggleXDirection();
  }

  /**
   * Aktion, die bei der Kollision mit den oberen Grenze ausgefuehrt wird
   * Normalerweise aendert das Objekt einfach seine Y-Richtung
   */
  void reactOnTopWallCollision() {
    this.setYPosition(this.level.getTop());
    this.toggleYDirection();
  }

  /**
   * Reaktion auf Kollision mit dem Objekt von Links
   * @param collisonObject Getroffenes Objekt
   */
  void reactOnCollisionFromLeft(DOMObject collisionObject)    { this.setXPosition(collisionObject.getLeft()-this.getWidth()); }

  /**
   * Reaktion auf Kollision mit dem Objekt von Rechts
   * @param collisonObject Getroffenes Objekt
   */
  void reactOnCollisionFromRight(DOMObject collisionObject)   { this.setXPosition(collisionObject.getRight()); }

  /**
   * Reaktion auf Kollision mit dem Objekt von Oben
   * @param collisonObject Getroffenes Objekt
   */
  void reactOnCollisionFromTop(DOMObject collisionObject)     { this.setYPosition(collisionObject.getTop()-this.getHeight()); }

  /**
   * Reaktion auf Kollision mit dem Objekt von Unten
   * @param collisonObject Getroffenes Objekt
   */
  void reactOnCollisionFromBottom(DOMObject collisionObject)  { this.setYPosition(collisionObject.getBottom()); }
}
