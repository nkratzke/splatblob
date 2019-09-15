import 'entity.dart';
import 'game.dart';

class Powerup extends Entity {
  Game game;

  Powerup(posX, posY, width, height) : super(posX, posY, width, height);

  /**
   * Powerups can't jump. This method does nothing.
   */
  void jump() {}

  /**
   * Powerups can't jump. This method does nothing.
   */
  void jumpAction() {}

  /**
   * Moves the powerup by 1 block to the left.
   */
  void move() {
    // The move value must be 1, because any higher value will lead
    // to a "teleporting" powerup
    this.posX--;
  }

  /**
   * Powerups don't collide. Returns always false.
   */
  bool checkCollision() {
    return false;
  }

  /**
   * Powerups can't pickup other powerups. This method does nothing.
   */
  void collectPowerup() {}

  /**
   * Powerups have no Powerup-Ability. This method does nothing.
   */
  void usePowerup() {}

}
