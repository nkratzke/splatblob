part of brickGame;
abstract class GameObject {
  ///
  /// x position of [GameObject] on the game field
  ///
  int xPosition;

  ///
  /// Y position of [GameObject] on the game field
  ///
  int yPosition;

  ///
  /// width of [GameObject]
  ///
  int width;

  ///
  /// height of [GameObject]
  ///
  int height;

  ///
  /// is [GameObject] still on the game field or not
  ///
  bool destroyed=false;

  ///
  /// contains all items that are currently on the game field
  ///
  List<Item> itemsBuffer;

  ///
  /// creates a [GameObject]
  ///
  GameObject(this.xPosition, this.yPosition, this.width, this.height) {
    itemsBuffer = new List();
  }

  ///
  /// gets called if an object collides with another object
  ///
  void collision(List<List<GameObject>> gameField, GameObject collisionObject);

  Direction getCollison(MoveableObject object) {
    int differenceX = xPosition - object.xPosition;
    int differenceY = yPosition - object.yPosition;
    Direction buffer;
    if (differenceX == 0 && differenceY <= 0) {
      buffer = Direction.down;
    } else if (differenceX >= 0 && differenceY == 0) {
      if (object._direction == Direction.leftUp) {
        buffer = Direction.rightUp;
      } else if (object._direction == Direction.rightUp) {
        buffer = Direction.leftUp;
      } else if (object._direction == Direction.leftDown) {
        buffer = Direction.rightDown;
      } else if (object._direction == Direction.rightDown) {
        buffer = Direction.leftDown;
      }
    } else if (differenceX == 0 && differenceY >= 0) {
      buffer = Direction.up;
    }
    return buffer;
  }

}

///
/// every object that is able to move
///
abstract class MoveableObject extends GameObject {

  ///
  /// current direction of an object
  ///
  Direction _direction;


  Direction get direction => _direction;
  set direction(Direction newDirection) => _direction = newDirection;

  ///
  /// creates a [MoveableObject]
  ///
  MoveableObject(int xPosition, int yPosition, int width, int length, this._direction)
      : super(xPosition, yPosition, width, length);

  ///
  /// moves a [MoveableObject]
  /// [direction] direction in which the object will go
  /// [gameField] contains necessary information for [collision]
  ///
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller);

  /// decides if the object will collide on the next field
  ///
  /// if it collides, the first part of the map will be true und the second part
  /// will be a [GameObject]. If there's no collision, the first part will be false
  /// and the second part will be a [Field].
  /// If the object will collide with a wall, it will return Map<true, null>
  /// `null` will show that we won't collide with a real object
  ///
  Map<bool, GameObject> collisionAhead(Direction direction,
      List<List<GameObject>> gameField,
      [int y = 0, int x = 0]) {
    GameObject buffer;

    int xVert=0;
    int yVert=0;
    var response;
    //collision for the item
    if(this is Item){
      if(gameField[xPosition][yPosition+y]==Player){
        response = {true: gameField[xPosition][yPosition+y]};
        //no need to further check the collision with a player
        return response;
      }else return {false:gameField[xPosition][yPosition+y]};
    }
    //look in multiple directions if it will collide
    if(direction==Direction.rightDown){
      response = getValuesForDirection(Direction.right);
    }else if(direction==Direction.leftDown){
      response=getValuesForDirection(Direction.left);
    }else if(direction==Direction.leftUp){
      response=getValuesForDirection(Direction.left);
    }else if(direction==Direction.rightUp){
      response=getValuesForDirection(Direction.right);
    }
    if(response!=null){
      xVert=response["X"];
      yVert=response["Y"];
      if(!_isOutofMap(yVert,xVert,gameField)){
        buffer=gameField[xPosition+xVert][yPosition+yVert];
        if(buffer is Field){
          buffer = null;
        }
      }
    }


    // reached limit of the game field
    if (!_isOutofMap(y,x,gameField)) {

      try{
        buffer = buffer==null?gameField[xPosition + x][yPosition + y]:buffer;
      }catch(e){
        print(e);
      }
      //balls collide
      if(this is Ball && buffer is Ball){
        return {true: buffer};
      }
      //player ahead?
      if (buffer is Field && (_direction == Direction.down|| _direction==Direction.rightDown||_direction==Direction.leftDown)) {
        if (buffer.yPosition == gameField[0].length - 1) {
          int wallDifference = (xPosition+1) * width;
          Player player;
          GameObject bufferPlayer;
          for (int i =  0; i < gameField.length; i++) {
            bufferPlayer = gameField[i][gameField[i].length - 1];
            if (bufferPlayer is Player) {
              player = bufferPlayer;
              break;
            }
          }
          int playerPosition;
          try{
            playerPosition = (((player.xPosition+1) * buffer.width) -
                player.width / 3).round();
          }catch(e){

          }

          if (wallDifference >= playerPosition &&
              wallDifference <= playerPosition + player.width) {
            buffer = player;
          }
        }
      }
    } else return {true: buffer};

    // empty field, so no problems
    if (buffer is Field) {
      return {false: buffer};
    }
    if (this is Player && buffer is Ball) {
      return {false: buffer};
    }
    return {true: buffer};
  }

  bool _isOutofMap(int y,int x,List<List<GameObject>> gameField){

    if ((xPosition + x < gameField.length && xPosition + x >= 0) &&
        (yPosition + y < gameField[xPosition].length && yPosition + y >= 0))
      return false;
    else return true;
  }

  ///
  /// Switch two [GameObject] in [gameField]
  ///
  ///
  /// [x] current position of [GameObject] that will switch places
  /// [y] current y position of [GameObject]
  ///
  ///
  void switchObjects(List<List<GameObject>> gameField, GameObject object1,
      GameObject object2) {
    if (object1 == null || object2 == null) return;
    final int x = object1.xPosition;
    final int y = object1.yPosition;
    gameField[object1.xPosition][object1.yPosition] = object2;
    gameField[object2.xPosition][object2.yPosition] = object1;
    object1.xPosition = object2.xPosition;
    object1.yPosition = object2.yPosition;
    object2.xPosition = x;
    object2.yPosition = y;
  }




}
