part of brickcrash;
/**
 * Das BallModel ist fuer die Baelle gedacht.
 * Diese haben eine bestimmte Staerke und koennen sich in jede Richtung bewegen.
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */
class BallModel extends MovableObject {
  int strength    = 1;      //Die Staerke des Balles
  /*
    CONSTRUCTOR
   */
  /**
   * Die Instanz vom LevelModel wird im BallModel gesetzt und eine zufaellige
   * Richtung wir fuer den Ball gesetzt
   * @param level LevelModel - Instanz
   */
  BallModel(LevelModel level) : super(level) {
    this.level      = level;
    this.setRandomDirection(10,70);           //Setzt einen zufaelligen Winkel im bereich 10-70 Grad oder (-10) bis (-70)
  }

  /*
    GETTER
   */
  int getSize()                   { return this.getWidth(); }

  /*
   * SETTER
   */
  Future setSize(int size) async {
    bool wasOnBeater = false;
    if (this.onBeater()) { wasOnBeater = true; }
    this..setWidth(size)..setHeight(size);
    if (wasOnBeater) { this.placeOnBeater(); }
  }


  /*
    METHODS
   */

  /**
   * Mittels eines Timers bewegt sich der Ball automatisch in seine
   * aktuelle Richtung. Dieser prueft auch Kollisionen mit Steinen und den
   * Waenden.
   * @param timer Timer
   */
  Future move(Timer timer) async {
    if (this.canMoveDown())                           {
      super.move(timer);
      this.checkBricks();

      // kollidiert der Ball gerade mit den Schlaeger?
      if (this.onBeater()){
        if (this.level.getBeater().isMagnetic()) {
          this.stop();
        }
        this.level.addScore(1);
      }
    } else {
      // der Ball ist runtergefallen
      this.stop();
      this.level.removeBall(this);
    }
  }

  /**
   * Reaktion auf die Kollision mit dem Stein, der getroffen wurde
   */
  void reactOnBrickCollision(BrickModel brick)            { brick.reactOnCollision(this.strength); }

  /**
   * Reaktion auf die Kollision mit der unteren Seite des Steines,
   * wo er seine Richtung spiegelt
   * @param brick Der getroffene Stein
   */
  void reactOnBrickCollisionFromBottom(BrickModel brick)  { super.reactOnBrickCollisionFromBottom(brick); this.toggleYDirection(); }

  /**
   * Reaktion auf die Kollision mit der oberen Seite des Steines,
   * wo er seine Richtung spiegelt
   * @param brick Der getroffene Stein
   */
  void reactOnBrickCollisionFromTop(BrickModel brick)     { super.reactOnBrickCollisionFromTop(brick);    this.toggleYDirection(); }

  /**
   * Reaktion auf die Kollision mit der linken Seite des Steines,
   * wo er seine Richtung spiegelt
   * @param brick Der getroffene Stein
   */
  void reactOnBrickCollisionFromLeft(BrickModel brick)    { super.reactOnBrickCollisionFromLeft(brick);   this.toggleXDirection(); }

  /**
   * Reaktion auf die Kollision mit der rechten Seite des Steines,
   * wo er seine Richtung spiegelt
   * @param brick Der getroffene Stein
   */
  void reactOnBrickCollisionFromRight(BrickModel brick)   { super.reactOnBrickCollisionFromRight(brick);  this.toggleXDirection(); }

  /**
   * Reaktion auf die Kollision mit der oberen Seite des Schlaegers,
   * wo er seine Richtung spiegelt
   * @param beater Der Schlaeger
   */
  void reactOnBeaterCollisionFromTop(BeaterModel beater)  { super.reactOnBeaterCollisionFromTop(beater); this.toggleYDirection(); }
}