part of brickGame;

///
/// directions a [Ball] can take
///
enum Direction { leftUp, leftDown, rightUp, rightDown, up, down, left, right }


///
/// returns the opposite direction that was given
///
Direction getOpposite(Direction direction){
  Direction newDirection;
  switch(direction){
    case Direction.down:
      newDirection=Direction.up;
      break;
    case Direction.up:
      newDirection=Direction.down;
      break;
    case Direction.leftDown:
      newDirection=Direction.rightUp;
      break;
    case Direction.leftUp:
      newDirection=Direction.rightDown;
      break;
    case Direction.rightUp:
      newDirection=Direction.leftDown;
      break;
    case Direction.rightDown:
      newDirection=Direction.leftUp;
      break;
    default:
      break;
  }
  return newDirection;
}

///
/// Returns x and y coordinates from a direction as a map
///
/// ["X"] gives the x value as an int
/// ["Y"] gives the y value as an int
///
Map<String, int> getValuesForDirection(Direction direction) {
  int x = 0;
  int y = 0;
  switch (direction) {
    case Direction.down:
      y = -1;
      break;
    case Direction.up:
      y = 1;
      break;
    case Direction.rightDown:
      x = 1;
      y = -1;
      break;
    case Direction.rightUp:
      x = 1;
      y = 1;
      break;
    case Direction.leftDown:
      x = -1;
      y = -1;
      break;
    case Direction.leftUp:
      x = -1;
      y = 1;
      break;
    case Direction.left:
      x = -1;
      break;
    case Direction.right:
      x = 1;
      break;
  }
  return {"X": x, "Y": y==0?0:y*-1};
}

///
/// Effects used by items
///
enum Effect {
  ///
  /// Creates another [Ball]
  ///
  secondBall
}
///
/// Health of a [Brick]
/// grey = destroyed
/// green = 1 hit
/// yellow = 2 hits
/// red = 3 hits
///
enum Health { grey, green, yellow, red }

///
/// Calculates the health decrease
/// [damage] damage the object will take
/// [health] current health of the object
///
Health getHealth(int damage, Health health) {
  List values = Health.values;
  int index = health.index - damage;
  if (index <= 0) {
    return Health.grey;
  } else
    return values[index];
}
///
/// Decides the health a brick will get
///
Health generateHealth(String health) {
  Health buffer;
  if (health == "gb") {
    buffer = Health.green;
  } else if (health == "gyb") {
    buffer = Health.grey;
  } else if (health == "yb") {
    buffer = Health.yellow;
  } else if (health == "rb") {
    buffer = Health.red;
  }
  return buffer;
}
