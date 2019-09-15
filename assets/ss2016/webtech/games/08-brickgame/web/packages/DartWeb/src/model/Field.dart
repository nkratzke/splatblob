part of brickGame;


class Field extends GameObject{

  static int _widthField;
  static int _heightField;

  ///
  /// creates an empty field in the game field
  ///
  Field(int xPosition, int yPosition, int width, int height):super(xPosition,yPosition,width,height){
    _widthField=width;
    _heightField=height;
  }

  Field.second(int xPosition,int yPosition) : super(xPosition, yPosition, _widthField, _heightField);


  ///
  /// no collision for an empty field
  ///
  @override
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    return;
  }

  ///
  /// returns string
  ///
  String toString() {
    return "field";
  }


}