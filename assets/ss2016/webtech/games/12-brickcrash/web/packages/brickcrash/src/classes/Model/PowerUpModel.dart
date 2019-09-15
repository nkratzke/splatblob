part of brickcrash;
/**
 * Das PowerUpModel wird zur Verwendung von PowerUps benutzt.
 * Diese koennen den Spieleinfluss veraendern
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */
class PowerUpModel extends MovableObject {
  static const BIGGER_BEATER    = 0;
  static const BALL_x3          = 1;
  static const MAGNETIC_BEATER  = 2;
  static const LIVE             = 3;
  static const BIGGER_BALL      = 4;
  static const DOUBLE_SCORE     = 5;
  static const REMOVELIVE       = 6;
  static const BOMB_BALL        = 7;

  int key             = null;       //Die nummer fuer das PowerUp
  int useDuration     = 10;         //Zeitintervall des Timers

  int alreadyUsedDuration = 0;
  Function stopMethod;

  Timer useTimer;

  /**
   * Constructor
   */
  /**
   * Die Nummer und die Groesse fuer das PowerUp werden gesetzt.
   * Dann bekommt dieser eine zufallige Bewegungsrichtung
   */
  PowerUpModel(LevelModel level, int key) : super(level) {
    this.key = key;
    this..setHeight(30)
      ..setWidth(30)
      ..setDuration(10)
    ;
    this.setRandomDirection(130,180);
  }

  /*
    GETTER
   */
  int getKey() { return this.key; }

  /*
    METHODS
   */
  /**
   * Das PowerUp bewegt sich solange nach unten, bis es am Boden ankommt oder
   * der Schlaeger dieses auffaengt
   * @param timer Timer
   */
  Future move(Timer timer) async{
    if (this.canMoveDown() && !this.onBeater()) {
      super.move(timer);
    } else {
      this.stop();
      if (this.onBeater()) {
        this.use();
      }
      this.level.removeFlyingPowerUp(this);
    }
  }

  /**
   * Entfernt das PowerUp und stoppt seinen Timer
   */
  Future remove() async {
    this.level.removeUsedPowerUp(this);
    this.stopUse();
  }

  /**
   * Aktuallisiert den Benutzen Timer
   */
  void updateUseTimer() {
    this.useTimer = new Timer.periodic(
        new Duration(seconds: 1),  (_) {
      if (this.alreadyUsedDuration < 10) {
        this.alreadyUsedDuration++;
      } else {
        this.stopMethod();
        this.remove();
      }
    }
    );
  }

  /**
   * Hier wird je nach Key ein bestimmtes PowerUp gesetzt und nach einer
   * bestimmten Zeit wieder zurueckgesetzt
   */
  Future use() async{
    BeaterModel beater = this.level.getBeater();

    switch(this.key){
      case BIGGER_BEATER :
        int oldLen          = beater.getWidth();                        // Aktuelle Laenge
        int newLen          = (oldLen*120/100).round();                 // die neue moegliche Laenge

        // der Schlaeger darf nicht groesser als die Map selbst sein
        // werden weitere aufgenommen => werden die ignoriert..
        if (newLen <= this.level.getWidth()) {                        // Alles OK
          this.level.addUsedPowerUp(this);                            // merken, dass wir diesen PowerUp benutzen
          int lenDifference   = newLen-oldLen;                        // Laengendifferenz berechnen
          int newBeaterRight  = beater.getLeft()+newLen;              // neue rechte Grenze
          int difference = this.level.getRight() - newBeaterRight;

          //damit der Schlaeger nicht die rechte Wand ueberschreitet..
          if (difference < 0) { beater.setXPosition(beater.getXPosition()+difference); }

          // erst die Baelle bewegen, dann den Beater verkleinern! (sonst wird onBeater nicht mehr erkannt!)
          beater.updateWidth(newLen);

          this.stopMethod = () { beater.updateWidth((beater.getWidth()*100/120).round());};
          this.updateUseTimer();
        }
        break;

      case MAGNETIC_BEATER :
        if (beater.isMagnetic()) {    // bereits magnetisiert
          this.level.usedPowerUps.forEach((powerUp) {
            if (powerUp.getKey() == MAGNETIC_BEATER) {
              powerUp.remove();
            }
          });
        }

        this.level.addUsedPowerUp(this);
        beater.setMagnetic();

        this.stopMethod = () { beater.setUnMagnetic(); } ;
        this.updateUseTimer();
        break;

      case BALL_x3 :
        BallModel lastBall = this.level.getBalls().last;      // der letzte Ball
        int lastBallX = lastBall.getXPosition();              // und seine Positionen
        int lastBallY = lastBall.getYPosition();

        for (int i=0; i<3; i++) {
          BallModel ball = this.level.addBall()
            ..setXPosition(lastBallX)        // und den genau da erzeugen, wo sich der
            ..setYPosition(lastBallY);       // zuletzt erzeugte Ball gerade befindet
          if(lastBall.onBeater()){
            ball.placeOnBeater();
          }
          if (lastBall.isMoving()) {            // wenn der letzte Ball sich bewegt
            ball.startMoving(ball.move);        // auch den neu erzeugten bewegen!
          }
        }
        break;

      case BIGGER_BALL:
        if (this.level.getBallSize() == this.level.getDefaultBallSize()*2) {    // bereits aufgenommen
          this.level.usedPowerUps.forEach((powerUp) {                           // den aufgenommenen Powerup finden
            if (powerUp.getKey() ==  BIGGER_BALL) {
              powerUp.remove();                                                // und beenden
            }
          });
        }

        this.level.addUsedPowerUp(this);
        this.level.setBallSize(this.level.getDefaultBallSize() * 2);

        this.stopMethod = () { this.level.setBallSize(this.level.getDefaultBallSize()); };
        this.updateUseTimer();

        break;

      case DOUBLE_SCORE :
        this.level.addUsedPowerUp(this);
        this.level.setScoreMultiplier(this.level.getScoreMultiplier() * 2);

        this.stopMethod = () => this.level.setScoreMultiplier((this.level.getScoreMultiplier() / 2).round());
        this.updateUseTimer();

        break;

      case LIVE         : this.level.player.addLives(1); break;
      case REMOVELIVE   : this.level.reduceLive(); break;
      case BOMB_BALL    : this.level.addBombBall(); break;
    }
  }

  /**
   * Stoppt den Timer
   */
  void stopUse() {
    this.useTimer.cancel();
  }

  // Die PowerUps reagieren nicht auf die Kollisionen!
  void reactOnBrickCollision(BrickModel brick)                  { }
  void reactOnBrickCollisionFromBottom(BrickModel brick)        { }
  void reactOnBrickCollisionFromTop(BrickModel brick)           { }
  void reactOnBrickCollisionFromLeft(BrickModel brick)          { }
  void reactOnBrickCollisionFromRight(BrickModel brick)         { }
}