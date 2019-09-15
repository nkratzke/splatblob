part of brickGame;

///
/// [Item] only possible item is the ball explosion which is currently not active
///
class Item extends MoveableObject {
  ///
  /// is [Effect] positive
  ///
  bool _isPositive;



  ///
  /// list to save extra balls
  ///
  List<Ball> ballBomb=[];

  ///
  /// what kind of item
  ///
  Effect effect;
  ///
  /// is item released
  ///
  bool _released=false;

  Item(int xPosition, int yPosition, int width, int length,this.effect)
      : super(xPosition, yPosition, width, length, Direction.down);

  Item.withBall(int xPosition,int yPosition, int width, int length,this.effect,this.ballBomb):
    super(xPosition,yPosition,width,length,Direction.down);



  ///
  /// is the item positive
  ///
  bool isPositive() {
    return _isPositive;
  }
  ///
  /// item is released and can move
  ///
  void release(){
    _released=true;
  }

  bool get released => _released;

  ///
  /// activates the item
  ///
  void activateItem([Player player]) {
    switch (effect) {
      case Effect.secondBall:
        {
          ballBomb.forEach((e)=>e.activated=true);
        }
        break;
    }
  }

  @override
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    if (collisionObject is Player) {
      activateItem(collisionObject);
      gameField[xPosition][yPosition] =
      new Field(xPosition, yPosition, width, height);
      destroyed=true;
    }
  }

  @override
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller) {
    if(_released) {
      var movement = getValuesForDirection(direction);
      var respond = collisionAhead(direction, gameField, movement["Y"]);
      if (respond.containsKey(true)) {
        if (respond[true] != null) {
          activateItem(respond[true]);
        }
        gameField[xPosition][yPosition] =
        new Field(xPosition, yPosition, width, height);
        gameField[xPosition][yPosition].itemsBuffer.remove(this);
      } else {
        gameField[xPosition][yPosition].itemsBuffer.remove(this);
        respond[false].itemsBuffer.add(this);
        yPosition += movement["Y"];
      }
      controller.updateView(gameField);
    }
  }

  @override
  String toString() {
    return '$effect';
  }


}