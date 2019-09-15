part of runner;

class SpikesTop extends Block {

  /// Creates SpikesTop instance
  SpikesTop(int id, int pos_x, int pos_y, int size_x, int size_y, [bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "SpikesTop";
  }

  /// Kills player if collisiom from top, as there are spikes, as well as left and right
  @override
  bool onCollisionExternal(Model model, Direction dir) {
    log("${name} ${id} collision with player, coming from ${dir}");
    if (dir == Direction.LEFT || dir == Direction.RIGHT || dir == Direction.TOP) {
      log("${name} ${id} killed player, coming from ${dir}");
      model.fail();
      return false; //didn't land
    }
    else {
      model.player.hitRoof();
      model.player.pos_y = pos_y - model.player.size_y - 1;
      return false;
    }
    return true; //landed
  }
}