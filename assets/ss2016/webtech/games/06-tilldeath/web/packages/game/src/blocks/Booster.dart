part of runner;

class Booster extends Triggerable {

  /// Enable or disable boost
  bool boost;

  /// Remember if we've been used
  bool collected;

  /// Creates Booster instance
  Booster(int id, int pos_x, int pos_y, int size_x, int size_y, bool boost, [bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "Booster";
    this.boost = boost;
    this.isVisible = isVisible ?? false;
    collected = false;
    print(this.boost);
  }

  /// Set boost state on start
  @override
  void start(Model model) {
    if (!collected) {
      collected = true;
      boost == true ? model.player.enableBoosting() : model.player.disableBoosting();
    }
  }
}