/**
 * The position of a fieldObject. Contains the values x and y
 */
class Position {
  int _x = 0;
  int _y = 0;

  /**
   * Constructor
   */
  Position(int x, int y) {
    this._x = x;
    this._y = y;
  }

  /**
   * returns the x-value
   */
  int getX() {
    return this._x;
  }

  /**
   * returns the y-value
   */
  int getY() {
    return this._y;
  }

  /**
   * sets the x-value of the position
   */
  void setX(int x) {
    this._x = x;
  }

  /**
   * sets the y-value of the position
   */
  void setY(int y) {
    this._y = y;
  }
}
