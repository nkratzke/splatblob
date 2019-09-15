part of brickcrash;
/**
 * Das BeaterModel ist fuer den Schlaeger und seine Aktionen zustaendig
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */
class BeaterModel extends MovableObject {
  bool canShoot   = false;      //Wird eingesetzt um zu gucken ob der Schlaeger schiessen kann (Nicht im Spiel umgesetzt)
  bool magnetic   = false;      //Wird benutzt, um die Baelle auf den Schlaeger zu magnetisieren

  /**
   * Constructor
   */
  /**
   * Die LevelModel Instanz wird hier gesetzt und es werden Skalierbare Groessen,
   * die Geschwindigkeit und die Position des Schlaegers gesetzt
   * @param level LevelModel - Instanz
   */
  BeaterModel(LevelModel level) : super(level) {
    this.level = level;
    this.setYPosition((this.level.getHeight()*20/100).round());
    this.setWidth((this.level.getWidth()*20/100).round());
    this.setHeight((this.level.getHeight()*4/100).round());
    this.setSpeed((this.level.getWidth()*1/100).round());
  }

  /*
    SETTER
   */
  Future setMagnetic() async    { this.magnetic = true; }
  Future setUnMagnetic() async  { this.magnetic = false; }

  /*
    GETTER
   */
  bool isMagnetic()     { return this.magnetic; }

  /*
   * METHODS
   */
  bool canMoveLeft()  { return this.getLeft()   >= this.level.getLeft()+5   ? true : false;  }
  bool canMoveRight() { return this.getRight()  <= this.level.getRight()-5  ? true : false;  }

  /**
   * Der Schlaeger bewegt sich nach links, um die anzahl der parameter uebergabe,
   * bis er eine Kollision der linken Wand erkennt
   * @param speed Gibt die Bewegung des Schlaegers in Anzahl von Pixeln an
   */
  Future moveLeft(double speed) async     {
    // wenn der Schlaeger nach links bewegen kann
    if (this.canMoveLeft() && this.level.isRunning()) {
      // erst alle Baelle bewegen, dann den Beater!
      if (level.getBalls().length > 0) {
        this.level.getBalls().forEach((ball){
          if (ball.onBeater()) { ball.moveLeft(this.getSpeed().toDouble()); }
        });
      }
      super.moveLeft(this.getSpeed().toDouble());
    }
  }
  /**
   * Der Schlaeger bewegt sich nach rechts, um die anzahl der parameter uebergabe,
   * bis er eine Kollision der rechten Wand erkennt
   * @param speed Gibt die Bewegung des Schlaegers in Anzahl von Pixeln an
   */
  Future moveRight(double speed) async {
    // wenn der Schlaeger nach rechts bewegen kann
    if (this.canMoveRight() && this.level.isRunning()) {
      // erst alle Baelle bewegen, dann den Beater!
      if (level.getBalls().length > 0) {
        this.level.getBalls().forEach((ball){
          if (ball.onBeater()) { ball.moveRight(this.getSpeed().toDouble()); }
        });
      }
      super.moveRight(this.getSpeed().toDouble());
    }
  }

  /**
   * Aktuallisiert die Breite des Schlaegers
   * Wenn Baelle auf den Schlaeger magnetiesiert sind, so aendern sie ihre Position
   * auch im falle einer Vergroesserung/Verkleinerung auch
   * @param width Gibt die Breite des Schlaegers an
   */
  Future updateWidth(int width) async {
    int lenDifference   = (width-this.getWidth()).abs();

    this.level.getBalls().forEach((ball) {
      if(ball.onBeater()){
        if (ball.getLeft() > this.getXPosition() + this.getXMiddle()) {
          ball.moveLeft(lenDifference.toDouble());
        } else if (ball.getRight() < this.getXPosition() + this.getXMiddle()){
          ball.moveRight(lenDifference.toDouble());
        }
      }
    });
    this.setWidth(width);
  }

  /**
   * Falls der Beater sich nach oben bewegen wuerde, koennte man hier eine Collision mit dem Brick ueberpruefen
   */
  void reactOnBrickCollision(BrickModel brick)  { }
}