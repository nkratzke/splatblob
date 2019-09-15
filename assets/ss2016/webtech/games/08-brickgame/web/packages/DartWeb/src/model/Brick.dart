part of brickGame;

///
/// [Brick] object
/// Destroy all bricks to finish the level
///
class Brick extends GameObject {


  ///
  /// The [Item] this brick holds
  ///
  Item _item;





  ///
  /// Health of [Brick]
  ///
  Health health;

  Brick(int xPosition, int yPosition, int width, int height, String health)
      : super(xPosition, yPosition, width, height) {
    this.health = generateHealth(health);
  }

  ///
  /// Decreases health by the amount of damage the brick took
  /// Will destroy the brick if health hits zero (grey)
  ///
  void decHealth(int damage, List<List<GameObject>> gameField) {
    health = getHealth(damage, health);
    if (health == Health.grey) {
      destroy(gameField);

    }

  }

  ///
  /// Destroys the [Brick] and checks if it contained an [Item]
  /// Activates the [Item] if it exists
  ///
  void destroy(List<List<GameObject>> gameField) {
    gameField[xPosition][yPosition] = new Field.second(xPosition,yPosition);
    if(_item!=null){
      _item.activateItem();
    }
  }


  ///
  /// collision for [Brick]
  ///
  @override
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    if (collisionObject is Ball) {

      decHealth(collisionObject.damage, gameField);
    } else
      return;
  }

  ///
  /// used to choose health
  /// returns health as a string
  /// color of the brick depends on health
  ///
  String toString() {
    String buffer="";
    //if it is an item, choose a different color
    if(_item!=null){
      return "item";
    }
    switch(health){
      case Health.green:
        buffer="greenBrick";
        break;
      case Health.grey:
        buffer="greyBrick";
        break;
      case Health.red:
        buffer="redBrick";
        break;
      case Health.yellow:
        buffer="yellowBrick";
        break;
    }
    return buffer;
  }


}
