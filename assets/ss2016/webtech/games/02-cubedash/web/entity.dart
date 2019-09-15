
abstract class Entity {
  int _posX;
  int _posY;
  int _width;
  int _height;
  int _powerupDuration;
  bool _isJumping;
  bool _isFalling;

  Entity(this._posX, this._posY, this._width, this._height) {
    this._powerupDuration = 0;

    this.isJumping = false;
    this.isFalling = false;
  }

  int get posX => this._posX;
  int get posY => this._posY;
  int get width => this._width;
  int get height => this._height;
  int get powerupDuration => this._powerupDuration;
  bool get isJumping => this._isJumping;
  bool get isFalling => this._isFalling;

  set posX(int posX) => this._posX = posX;
  set posY(int posY) => this._posY = posY;
  set width(int width) => this._width = width;
  set height(int height) => this._height = height;
  set powerupDuration(int powerupDuration) => this._powerupDuration = powerupDuration;
  set isJumping(bool isJumping) => this._isJumping = isJumping;
  set isFalling(bool isFalling) => this._isFalling = isFalling;

  /**
   * Causes the entity to jump.
   */
  void jump();

  /**
   * Causes the entity to move.
   */
  void move();

  /**
   * When jumping, it causes the entity to move up or down, depending if the entity
   * is supposed to fall down again or not.
   */
  void jumpAction();

  /**
   * Checks if there is an collision.
   */
  bool checkCollision();

  /**
   * Checks if an powerup was picked up.
   */
  void collectPowerup();

  /**
   * Makes the Entity use its Powerup-Ability.
   */
  void usePowerup();
}
