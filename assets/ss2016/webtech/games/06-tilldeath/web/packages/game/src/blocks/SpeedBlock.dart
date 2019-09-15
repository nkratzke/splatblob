part of runner;

class SpeedBlock extends Triggerable {

  /// Value to add onto current speed
  int speedIncrease;

  /// Remember if collected
  bool collected;

  /// Creates SpeedBlock instance
  SpeedBlock(int id, int pos_x, int pos_y, int size_x, int size_y, [int speed, bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "SpeedBlock";
    this.isVisible = isVisible ?? false;
    this.speedIncrease = speed ?? 0;
    collected = false;
  }

  /// Increase or decrease speed depending on [speedIncrease]
  @override
  void start(Model model) {
    if (!collected) {
      collected = true;
      model.speed += speedIncrease;
    }
  }
}