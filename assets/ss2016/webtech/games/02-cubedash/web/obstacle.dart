import 'entity.dart';

class Obstacle extends Entity {

  Obstacle(posX, posY, width, height) : super(posX, posY, width, height);

  /**
   * Obstacles can't jump. This method does nothing.
   */
  void jump() {}

  /**
   * Obstacles can't jump. This method does nothing.
   */
  void jumpAction() {}

  /**
   * Moves the obstacle by 1 block to the left.
   */
  void move() {
    // The move value must be 1, because any higher value will lead
    // to a "teleporting" obstacle
    this.posX--;
  }

  /**
   * Obstacles don't collide. Returns always false.
   */
  bool checkCollision() {
    return false;
  }

  /**
   * Obstacles can't pickup powerups. This method does nothing.
   */
  void collectPowerup() {}

  /**
   * Obstacles have no Powerup-Ability. This method does nothing.
   */
  void usePowerup() {}
}
