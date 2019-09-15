part of runner;

class Teleport extends Block {

  /// Spawn to which to Teleport
  Spawn spawn;

  /// Creates Teleport instance
  Teleport(int id, int pos_x, int pos_y, int size_x, int size_y, Spawn s, [bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "Teleport";
    this.spawn = s;
  }

  /// Teleports Player on collision
  @override
  bool onCollisionExternal(Model model, Direction dir) {
    model.player.reset(); // reset any momentum
    model.resetVisibleIndex(); // reset any known position
    model.player.pos_x = spawn.pos_x;
    model.player.pos_y = spawn.pos_y;
    return false;
  }
}