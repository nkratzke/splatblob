part of runner;

class Finish extends Block {

  /// Creates Finish instance
  Finish(int id, int pos_x, int pos_y, int size_x, int size_y, [bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "Finish";
  }

  /// Win Game on Collision
  @override
  bool onCollisionExternal(Model model, Direction dir) {
    model.finish();
    return true; //landed
  }
}