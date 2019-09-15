import 'entity.dart';
import 'game.dart';

class Player extends Entity {
  static const jumpHeight = 10;
  static const powerupDurationInLoops = 250;

  Game _game;

  Player(posX, posY, width, height, this._game) : super(posX, posY, width, height);

  /**
   * Starts the jump sequence of the player.
   */
  void jump() {
    if (this.powerupDuration > 0) {
      if (this.posY < Game.fieldSizeY - this.height) {
        this.posY++;
      }

      // Make the player falling, because we want him to fall down, when the powerup ends.
      this.isFalling = true;
      this.isJumping = true;
    } else {
      this.isJumping = true;
    }
  }

  /**
   * Executes the jump sequence. The player is moving upwards, till he reaches
   * [jumpHeight]. As soon as [jumpHeight] is reached the player starts falling
   * to the ground again.
   */
  void jumpAction() {
    if (this.powerupDuration == 0) {
      if (this.isJumping && !this.isFalling && this.posY < Player.jumpHeight) {
        this.posY++;
      } else if (this.isJumping && !this.isFalling &&
          this.posY == Player.jumpHeight) {
        this.isFalling = true;
      } else if (this.isJumping && this.isFalling && this.posY > 0) {
        this.posY--;
      } else if (this.isJumping && this.isFalling && this.posY == 0) {
        this.isJumping = false;
        this.isFalling = false;
      }
    } else {
      this.powerupDuration--;
    }
  }

  /**
   * The player does not move. Obstacles move towards the player.
   */
  void move() {}

  /**
   * Checks if the player collided with an obstacle. If so, true will be returned.
   * Otherwise false will be returned.
   */
  bool checkCollision() {
    for(Entity e in this._game.obstacles) {
      if (
          this.posX < e.posX + e.width &&
          this.posX + this.width > e.posX &&
          this.posY < e.posY + e.height &&
          this.posY + this.height > e.posY
      ) {
        return true;
      }
    }

    return false;
  }

/**
 * Checks if the player collided with a powerup. If so, true the powerup will be
 * removed and true will be returned. Otherwise false will be returned.
 */
  void collectPowerup() {
    for(Entity e in this._game.powerups) {
      if (
      this.posX < e.posX + e.width &&
          this.posX + this.width > e.posX &&
          this.posY < e.posY + e.height &&
          this.posY + this.height > e.posY
      ) {
        this._game.powerups.remove(e);

        this.powerupDuration = Player.powerupDurationInLoops;
      }
    }
  }

  /**
   * Makes the player move towards the ground.
   */
  void usePowerup() {
    if(this.powerupDuration > 0 && this.posY > 0) {
      this.posY--;
    }
  }

}
