part of runner;

class Bullet extends Triggerable {

  /// Creates Bullet instance
  Bullet(int id, int pos_x, int pos_y, int size_x, int size_y, [int speed_x, int speed_y, bool isDeadly, bool canCollide, bool isVisible]) : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "Bullet";
    this.speed_x = speed_x ?? 0;
    this.speed_y = speed_y ?? 0;
    this.isDeadly = isDeadly ?? true;
  }

  /// Start bullet movement
  void start(Model model) {
    speed_x = -2;
  }

}