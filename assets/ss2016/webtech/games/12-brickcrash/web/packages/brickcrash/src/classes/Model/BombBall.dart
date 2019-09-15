part of brickcrash;
/**
 * Der BombBall ist eine Erweiterung des normalen Balles. Deswegen erbt er auch
 * vom Ballmodel. Dieser Explodiert im falle einer Kollision mit einem Stein und
 * zerstoert auch andere Steine im Umfeld
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */
class BombBall extends BallModel {
  int radius = 100;       //Der Radius der Explosion
  /**
   * Constructor
   */
  /**
   * Die LevelModel Instanz wird gesetzt und der Ball bekommt eine Staerke von 3
   * @param level LevelModel - Instanz
   */
  BombBall(LevelModel level) : super(level) {
    this.strength = 3;
  }

  /**
   * Reaktion auf die Kollision mit der unteren Seite des Steines.
   * Fuer die Explosion gibt dieser Ball seine Positon mit.
   * @param brick der getroffene Stein
   */
  void reactOnBrickCollisionFromBottom(BrickModel brick) {
    this.explode(brick.getXMiddlePosition(), brick.getYMiddlePosition());
  }

  /**
   * Wenn der Ball die obere Wand trifft, so explodiert dieser Auch
   */
  void reactOnTopWallCollision() { this.explode(this.getXMiddlePosition(), 0);}

  /**
   *  Der Ball wird geloescht und es werden alle Balle im Radius angegriffen
   *  @param x X-Koordinate des Balles
   *  @param y Y-Koordinate des Balles
   */
  void explode(int x, int y) {
    this.level.removeBall(this);

    this.level.getBricks().forEach((brick){
      if (brick.getXMiddlePosition() >= x-radius &&
          brick.getXMiddlePosition() <= x+radius &&
          brick.getYMiddlePosition() >= y-radius &&
          brick.getYMiddlePosition() <= y+radius
      ) {
        brick.reactOnCollision(this.strength);
      }
    });
  }
}