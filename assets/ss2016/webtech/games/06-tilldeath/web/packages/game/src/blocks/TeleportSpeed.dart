part of runner;

class TeleportSpeed extends Teleport {

  /// Spawn to which to teleport the player
  Spawn spawn;

  /// Value by which speed is modified
  int speedIncrease;

  /// Creates TeleportSpeed instance
  TeleportSpeed(int id, int pos_x, int pos_y, int size_x, int size_y, Spawn s, [int speedIncrease, bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, s, isDeadly, canCollide, isVisible) {
    name = "Teleport";
    this.speedIncrease = speedIncrease ?? 0;
  }

  /// Teleport player and modify level speed
  @override
  bool onCollisionExternal(Model model, Direction dir) {
    model.speed += speedIncrease;
    model.player.reset();
    model.resetVisibleIndex();
    model.player.pos_x = spawn.pos_x;
    model.player.pos_y = spawn.pos_y;
    return false;
  }
}