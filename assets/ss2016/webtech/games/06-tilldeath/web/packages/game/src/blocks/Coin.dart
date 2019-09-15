part of runner;

class Coin extends Block {

  /// Points the coin is worth
  int value;

  /// Has coin been collected
  bool collected;

  /// Creates Coin instance
  Coin(int id, int pos_x, int pos_y, int size_x, int size_y, [int value, bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "Coin";
    this.value = value ?? 0;
    collected = false;
  }

  /// Increases Score by [value]
  @override
  bool onCollisionExternal(Model model, Direction dir) {
    log("Coin collision!");
    if (!collected) {

      collected = true; // set collected
      isVisible = false;
      model.points += value; // add value

    }
    return false;
  }

}