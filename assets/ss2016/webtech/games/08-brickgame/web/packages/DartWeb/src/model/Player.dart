part of brickGame;
/// User controls the [Player]. Collide with [Ball] to destroy all bricks
///
class Player extends MoveableObject {


  ///
  /// last direction of the player
  ///
  Direction lastMove;

  ///
  /// current distance the player will move with every key press
  ///
  int _moveSpeed;

  ///
  /// creates a player
  ///
  Player(int xPosition, int yPosition, int width, int length, this._moveSpeed)
      : super(xPosition, yPosition, width, length, null);


  int get moveSpeed => _moveSpeed;


  ///
  /// moves the player
  ///
  @override
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller) {
    final int gameLength = (gameField.length) *
        gameField[xPosition][yPosition - 1].width;
    final playerLength = (1 + xPosition) *
        gameField[xPosition][yPosition - 1].width;
    if (direction == Direction.right) {
      if (gameLength - (playerLength) < (playerLength / 3).floor()) return;
    }
    int x = getValuesForDirection(direction)["X"];
    Map response = collisionAhead(direction, gameField, 0, x);
    if (!response.keys.first) {
      if (response[false] != null) {
        response[false].collision(gameField, this);
      }
      switchObjects(gameField, this, response.values.first);
      controller.updateView(gameField);
    }
  }

  ///
  /// no special collision necessary
  ///
  @override
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
  }

  ///
  /// returns string
  ///
  String toString() {
    return "player";
  }


}
