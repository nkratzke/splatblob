part of brickGame;
///
/// Object that moves through the gamefield
/// Can damage [Brick] when both collide
///
class Ball extends MoveableObject {
  ///
  /// Damage that the ball will deal
  ///
  int _damage;

  ///
  /// Ball already in game?
  ///
  bool activated=false;


  Ball(int xPosition, int yPosition, int width, int length)
      : super(xPosition, yPosition, width, length, Direction.down) {
    _damage = 1;
  }

  Ball.withDirection(int xPosition, int yPosition, int width, int length, Direction direction)
      : super(xPosition, yPosition, width, length, direction) {
    _damage = 1;
  }




  ///
  /// Changes damage the [Ball] will deal to a [Brick]
  ///
  void changeDamage(int damage) {
    _damage = damage;
  }

  int get damage => _damage;

  ///
  /// Used by objects that collide with [Ball]
  ///
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    if(collisionObject is Ball){
      collisionObject._direction=getOpposite(collisionObject._direction);
      this._direction=getOpposite(this._direction);
    }
    if (collisionObject is Player) {
      _getCollsionWithPlayer(collisionObject);
    } else if (collisionObject == null) {
      if (direction == Direction.up) {
        direction = Direction.down;
      } else if (direction == Direction.leftUp) {
        if (xPosition == 0) direction = Direction.rightUp;
        if (yPosition == 0) direction = Direction.leftDown;
      } else if (direction == Direction.rightUp) {
        if (xPosition == gameField.length - 1) direction = Direction.leftUp;
        if (yPosition == 0) direction = Direction.rightDown;
      } else if (direction == Direction.leftDown) {
        direction = Direction.rightDown;
      } else if (direction == Direction.rightDown) {
        direction = Direction.leftDown;
      }
    } else
      direction = collisionObject.getCollison(this);
  }

  ///
  /// Only used by move and collision
  /// Changes the direction of [Ball]
  /// [Ball] will have a different behavior depending on [collisionObject]
  ///
  void _changeDirection(Direction direction, GameObject collisionObject,
      List<List<GameObject>> gameField, Map<String, int> step) {
    collision(gameField, collisionObject);
  }

  ///
  /// Decides the direction of [Ball] when it hits [Player]
  /// dependent on the side where the [Ball] will collide
  /// left side -> fly to the upper left, right side -> fly to the upper right
  /// center -> fly straight upwards
  ///
  void _getCollsionWithPlayer(Player object) {
    //[Player] is split into three parts
    int playerPieces = (object.width / 3).round();
    //current center + 1 because of possible rounding errors
    int playerMiddle = ((object.xPosition * this.width) + 1);
    //size of the ball
    int ballPosition = this.xPosition * this.width;
    if (ballPosition >= playerMiddle &&
        ballPosition <= playerMiddle + playerPieces) {
      direction = Direction.up;
    } else if ((ballPosition >= playerMiddle - playerPieces &&
        ballPosition < playerMiddle)|| ballPosition == playerMiddle-playerPieces) {
      direction = Direction.leftUp;
    } else direction = Direction.rightUp;
  }

  ///
  /// moves the player in a direction on the game field
  ///
  @override
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller) {
    if (yPosition == gameField[0].length - 1) {
      gameField[xPosition][yPosition] =
      new Field.second(xPosition,yPosition);
      destroyed=true;
      controller.updateView(gameField);
      return;
    }
    Map coordinates = getValuesForDirection(direction);


    Map response = collisionAhead(
        direction, gameField, coordinates["Y"], coordinates["X"]);
    //Collision ahead? If not, keep moving. Else call collision method depending on the object
    if (!response.keys.first) {
      switchObjects(gameField, this, response.values.first);
      controller.updateView(gameField);
      return;
    } else {
      _changeDirection(direction, response[true], gameField, coordinates);
      if (response[true] != null) {
        response[true].collision(gameField, this);
        if(response[true] is Brick){
          controller.game.increasePoints(response[true].health);
        }
      }
      //move in new direction
      move(this.direction, gameField, controller);
    }
  }

  ///
  /// returns string
  ///
  String toString() {
    return "ball";
  }


}
