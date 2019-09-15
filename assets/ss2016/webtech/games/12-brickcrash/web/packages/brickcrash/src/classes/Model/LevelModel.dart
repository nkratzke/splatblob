part of brickcrash;
/**
 * LevelModel
 *
 * beinhaltet die ganze Logik fuer das Spiel und Level.
 * @version 1.0
 * @author Mihail Usenko, Johann Schnitkov
 */

class LevelModel extends DOMObject {
  // Moegliche Zustaende des Spiels:
  static const EMPTY                = 0;    // Anfangszustand. konstruiert, noch nichts geladen
  static const RUNNING              = 1;    // Der Level it geladen, das Spiel laeuft
  static const FINISHED             = 2;    // der Level ist beendet
  static const GAMEOVER             = 3;    // das Spiel ist verloren
  static const PAUSED               = 4;    // das Spiel ist pausiert

  int levelID                       = 0;    // Levelnummer
  int scoreMultiplier               = 1;    // Punkten-Multiplikator
  int powerUpProbability            = 0;    // Wahrscheinlichkeit, dass ein PowerUp kommt, in %. Einstellbar durch JSON

  int ballSpeed                     = 5;    // Standardgeschwindigkeit fuer den Ball.
  int pointsForLive                 = 1000; // Anzahl der Punkte, wofuer man ein Leben bekommt

  // Standardgroessen ( fuer die moegliche Skalierung gedacht)
  int ballSize                      = 20;   // aktuelle Groesse der Baelle
  int defaultBallSize               = 20;   // standarte Ballgroesse
  int defaultBrickWidth             = 45;   // standarte Breite des Bricks
  int defaultBrickHeight            = 25;   // standarte Hoehe des Bricks
  int defaultBeaterWidth            = 402;  // standarte Breite des Schlaegers
  int defaultBeaterHeight           = 20;   // standarte Hoehe des Schlaegers

  int status                        = EMPTY;

  String background                 = "../web/graphic/bg1.jpg";

  Player player                     = null;             // hier wird der Spieler gespeichert
  BeaterModel beater                = null;             // hier wird der Schlaeger gespeichert
  List<BrickModel> bricks           = <BrickModel>[];   // hier werden alle Bricks gespeichert
  List<BallModel> balls             = <BallModel>[];    // hier werden alle Baelle gespeichert
  List<PowerUpModel> flyingPowerUps = <PowerUpModel>[]; // hier werden die Powerups, die gerade fliegen, gespeichert
  List<PowerUpModel> usedPowerUps   = <PowerUpModel>[]; // hier werden die PowerUps, die gerade in Benutzung ist, gespeichert


  /**
   * CONSTRUCTOR
   */
  /**
   * Der Spieler wird gesetzt
   * @param player der aktuelle Spieler
   */
  LevelModel(Player player)               { this.player = player; }

  /*
   * GETTER
   */
  int getBallSpeed()                      { return this.ballSpeed; }
  int getBallSize()                       { return this.ballSize; }
  int getPowerUpProbability()             { return this.powerUpProbability; }
  int getLevelID()                        { return this.levelID; }
  int getStatus()                         { return this.status; }
  int getScoreMultiplier()                { return this.scoreMultiplier; }
  int getDefaultBallSize()                { return this.defaultBallSize; }

  bool isPaused()                         { return this.getStatus() == PAUSED; }
  bool isRunning()                        { return this.getStatus() == RUNNING; }

  String getBackground()                  { return this.background; }
  BeaterModel getBeater()                 { return this.beater; }
  List<BallModel> getBalls()              { return this.balls; }
  List<BrickModel> getBricks()            { return this.bricks; }
  List<PowerUpModel> getFlyingPowerUps()  { return this.flyingPowerUps; }
  List<PowerUpModel> getUsedPowerUps()    { return this.usedPowerUps; }

  /*
   * SETTER
   */

  Future setPowerUpProbability(int powerUpProbability) async  { this.powerUpProbability = powerUpProbability; }
  Future setScoreMultiplier(int multiplier) async             { this.scoreMultiplier    = multiplier; }
  void setLevel(int levelID)                                  { this.levelID            = levelID; }
  void setBackground(String background)                       { this.background         = background; }

  /**
   * Aktualisiert die Ballgeschwindigkeit
   * Aktualisiert auch gleich alle Timer!
   * ( Aktuell nicht in Verwendung, da es Probleme mit den Timer gab )
   */
  void setBallSpeed(int speed)        {
    this.ballSpeed = speed;                     // neue Geschwindigkeit setzen

    this.getBalls().forEach((ball) {            // Jeden Ball durchgehen
      if (ball.isMoving()){                     // falls der aktuelle Ball sich bewegt
        ball  ..setDuration(this.ballSpeed)     // dann die Geschwindigkeit bei dem Ball anpassen
              ..updateTimer();                  // und die Timer aktualisieren
      }
    });
  }

  /**
   * Die Ballgroessen aendern
   */
  Future setBallSize(int size) async {
    this.ballSize = size;                         // Somit merken wir, dass alle Baelle diese Groesse haben
    this.getBalls().forEach((ball) {
      if(!(ball is BombBall)){
        ball.setSize(size);                     // und dann diese Groesse jeden Ball zuweisen
      }
    });
  }

  /*
    METHODS
   */

  /**
   * Den Level aus den engegebenen Map erstellen
   * @param map die Map
   */
  Future generateMap(String map) async  {
    int startX = (this.getWidth()*3/100).round();         // X - Startposition, ab wann die Bricks generiert werden

    int x = startX;
    int y = (this.getHeight()*3/100).round();             // Y - Startposition

    for(int i=0; i < map.length; i++) {                                     // die Map Zeichen fuer Zeichen durchgehen
      switch(map[i]){                                                       // den Zeichen pruefen
        case " "    : x += this.defaultBrickWidth/3;                break;  // Leerzeichen = Abstand
        case "\n"   : y += this.defaultBrickHeight+10;  x = startX; break;  // Neue Zeile = neue Brickreihe

        default :
          RegExp exp = new RegExp("([\s\nBRYGZWKVO])");                     // erlaubte Zeichen pruefen
          if (exp.hasMatch(map[i])) {                                       // wenn der Zeichen zugelassen ist,
            BrickModel brick =  new BrickModel(this, map[i])                // einen neuen Brick in angegebener Farbe erstellen
              ..setXPosition(x)                                             // nach X - Koordinate positionieren
              ..setYPosition(y)                                             // nach Y - Koordinate positionieren
              ..setWidth(this.defaultBrickWidth)                            // Breite einstellen
              ..setHeight(this.defaultBrickHeight)                          // Hoehe einstellen
              ..setRandomPowerUp(this.powerUpProbability)                   // und vielleicht einen PowerUp zuweisen
            ;

            x += brick.getWidth();
            i += 2;                                                         // weitere 2 Zeichen werden ignoriert (sind nur fuer bequeme Levelerstellung da)
            bricks.add(brick);                                              // den Brick zu der Brickliste hinzufuegen
          }
          break;
      }
    }
  }

  /**
   * Setzt den Level zurueck:
   * loescht alle benutzte PowerUps, skalliert alle Objekte,
   * Setzt den Schlaeger zurueck, fuegt einen neuen Ball hinzu und platziert den auf den Beater
   *
   * Diese Methode kann z.b. beim Level-Start benutzt werden
   */
  void reset() {
    if (this.player.getLives() > 0) {                 // es gibt noch Leben
      this.resetUsedPowerUps();                       // alle PowerUps loeschen
      this.setScale();                                // skallieren
      this.resetBeater();                             // den Schlaeger ruecksetzen
      this.addBall().setSize(this.defaultBallSize);   // einen neuen Ball erzeugen
      this.placeBallOnBeater(this.getBalls()[0]);     // und diesen auf den Schlaeger platzieren
    }
  }

  // ----------------- ADD-Methoden ---------------------------

  /**
   * einen neuen Ball erzeugen
   * @return erzeugte Ball
   */
  BallModel addBall()  {
    BallModel ball = new BallModel(this)            // neuen Ball erzeugen,
                    ..setSize(this.ballSize)        // ihn gleich die aktuelle Ballgroesse vergeben
                    ..setDuration(this.ballSpeed);  // und die Gescwindigkeit wird auch angepasst
    this.balls.add(ball);                           // den erzeugten Ball hinzufuegen
    return ball;
  }
  BombBall addBombBall(){
    BombBall bomb = new BombBall(this)
                  ..setSize(30)
                  ..setDuration(this.ballSpeed)
                  ..setAngle(0)
    ;
    this.placeBallOnBeater(bomb);
    this.balls.add(bomb);
    return bomb;
  }

  /**
   * Die Punkte hinzufuegen
   * @param score Punktezahl
   */
  void addScore(int score) {
    int oldScore = this.player.getScore();                            // aktuelle Score merken
    this.player.addScore(score * this.getScoreMultiplier());          // den Spieler neue Punkte adieren

    // hiermit wird berechnet, ob es der Punktestand erreicht wurde, bei den das Leben adiert wird
    int oldX = (oldScore / this.pointsForLive).floor();
    int newX = (this.player.getScore() / this.pointsForLive).floor();

    // ist dieser Punktespand erreicht, so wird ein Leben addiert
    if (oldX != newX) { this.player.addLives(1); }
  }

  void addFlyingPowerUp(PowerUpModel powerUp)   { this.flyingPowerUps.add(powerUp); }
  void addUsedPowerUp(PowerUpModel powerUp)     { this.usedPowerUps.add(powerUp);   }


  // --------------- REMOVE - Methoden -------------------------------

  /**
   * den Brick von der Map loeschen
   * @param brick der zu loeschende Brick.
   */
  void removeBrick(BrickModel brick)                {
    this.bricks.remove(brick);                // den Brick aus der Liste der Bricks loeschen
    if (this.getBricks().length == 0) {       // und falls es keine Bricks mehr gibt
      this.status = FINISHED;                 // ist der Level beendet!
    }
  }

  /**
   * Den Ball loeschen
   * @param ball der zu loeschende Ball
   */
  Future removeBall (BallModel ball) async {
    ball.stop();
    this.balls.remove(ball);                  // den Ball aus der Liste loeschen
    if (this.getBalls().length == 0) {        // wenn es keine Baelle mehr in der Liste gibt
      this.reduceLive();
      this.reset();                           // den Level ruecksetzen
    }
  }

  /**
   * einen fliegenden PowerUp-Objekt loeschen
   */
  void removeFlyingPowerUp(PowerUpModel powerUp)    { this.flyingPowerUps.remove(powerUp); }

  /**
   * den angegebenen benutzten PowerUp loeschen
   */
  Future removeUsedPowerUp(PowerUpModel powerUp) async   { this.usedPowerUps.remove(powerUp);  }

  /**
   * unterbrecht alle Timer bei allen bewegenden Objekten
   */
  void stopEverything() {
    this.getBalls().forEach((ball)              { ball.stop(); });
    this.getFlyingPowerUps().forEach((powerUp)  { powerUp.stop(); });
    this.getUsedPowerUps().forEach((powerUp)   { powerUp.stopUse(); });
  }

  /**
   * das Spiel pausieren
   */
  void pause()                                  {   this.stopEverything();     this.status = PAUSED; }

  /**
   * Das Spiel fortsetzen
   */
  void resume() {
    this.getBalls().forEach((ball)              { ball.startMoving(ball.move); });
    this.getFlyingPowerUps().forEach((powerUp)  { powerUp.startMoving(powerUp.move); });
    this.getUsedPowerUps().forEach((powerUp)    { powerUp.updateUseTimer(); });
    this.status = RUNNING;
  }

  /**
   * Den Level saeubern
   */
  void clear() {
    this.status         = EMPTY;          // merken, dass der Lever leer ist
    this.stopEverything();                // alle Timer unterbrechen
    this.beater         = null;           // den Schlaeger loeschen
    this.balls          = [];             // alle Baelle loeschen
    this.bricks         = [];             // alle Bricks loeschen
    this.flyingPowerUps = [];             // alle fliegende Powerups loeschen
    this.usedPowerUps   = [];             // alle benutzende Powerups loeschen
  }

  /**
   * den Beater zuruecksetzten und in der Mitte platzieren
   */
  void resetBeater()              {
    this.beater = new BeaterModel(this)
                ..setWidth(this.defaultBeaterWidth)
                ..setHeight(this.defaultBeaterHeight);
    this.placeBeaterInTheMiddle();
  }

  /**
   * Setzt alle Baelle, die auf dem Feld sind, in Bewegung.
   */
  void startMoveBalls()     {
    if (this.isRunning()) {
      this.getBalls().forEach((ball) {
        ball.startMoving(ball.move);
        //ball.move(null);
      });
    }
  }

  /**
   * Den Ball auf den Schlaeger platzieren
   */
  Future placeBallOnBeater(BallModel ball) async {
    ball..setXPosition((this.getBeater().getXPosition() + this.getBeater().getXMiddle() - ball.getXMiddle()).round())
        ..setYPosition(this.getBeater().getYPosition() - ball.getSize());
  }

  /**
   * platziert den Schlaeger in der Mitte des Spielfeldes
   */
  void placeBeaterInTheMiddle() {
    this.getBeater()
      ..setXPosition(this.getXMiddle()  - this.getBeater().getXMiddle())
      ..setYPosition(this.getHeight()   - this.getBeater().getHeight() - 25);
  }

  /**
   * Alle gerade benutzte PowerUps loeschen
   */
  Future resetUsedPowerUps  () async {
    this.usedPowerUps.forEach((powerUp){ powerUp.remove(); });
  }

  /**
   * den Level aus den JSON und MAP-Dateien laden
   */
  Future loadLevel()  async {
    try {
      // Einstellungen laden
      await HttpRequest.getString("../web/level/level"+this.levelID.toString()+"/settings.json").then((json) async {
        final settings = JSON.decode(json);

        this.setPowerUpProbability(settings['powerUpProbability']);     // die PowerUp-Wahrscheinlichkeit einstellen
        this.player.addLives(settings['additionalLives']);              // zusaetzliche Leben addieren
        this.setBackground(settings['background']);                     // den Hintergrund anpassen

        // die Map laden
        await HttpRequest.getString("../web/level/level"+this.levelID.toString()+"/map.txt").then((map) async{
          this.generateMap(map);                                        // die Map generieren
          this.status = RUNNING;                                        // Das Spiel ist ab jetzt gestartet
        });
      });
    } catch (error) {  }
  }

  /**
   * Die View skallieren
   */
  void setScale()             {
    if(this.getWidth()>this.getHeight()){
      this.defaultBeaterWidth   = (this.getWidth()*20/100).round();
      this.defaultBeaterHeight  = (this.getHeight()*5/100).round();

      this.defaultBrickWidth    = (this.getWidth()*5/100).round();
      this.defaultBrickHeight   = (this.getHeight()*4/100).round();
      this.ballSize             = (this.getWidth()*2/100).round();
    } else {
      this.defaultBeaterWidth   = (this.getWidth()*20/100).round();
      this.defaultBeaterHeight  = (this.getHeight()*3/100).round();

      this.defaultBrickWidth    = (this.getWidth()*5/100).round();
      this.defaultBrickHeight   = (this.getHeight()*5/100).round();
      this.ballSize             = (this.getHeight()*2/100).round();
    }
    this.defaultBallSize = ballSize;
  }

  /**
   * Das Leben abziehen.
   * Wenn man keine Leben mehr hat, aendert sich der Status auf GAMEOVER
   */
  Future reduceLive()async {
    await this.player.reduceLive();                               // das Leben von den Spieler abziehen
    if ( this.player.getLives() == 0 && this.getBricks().length > 0) { this.status = GAMEOVER; this.stopEverything(); }  // hat man keine Leben => das Spiel ist verloren
  }
}