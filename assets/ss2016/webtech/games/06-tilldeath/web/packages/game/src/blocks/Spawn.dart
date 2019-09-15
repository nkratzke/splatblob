part of runner;

class Spawn extends Block {

  /// Creates Spawn instance
  Spawn(int id, int pos_x, int pos_y, int size_x, int size_y, [bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "Spawn";
    this.canCollide = canCollide ?? false;
    this.isDeadly = isDeadly ?? false;
    this.isVisible = isVisible ?? false;
  }

}