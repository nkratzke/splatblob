part of runner;

class Trigger extends Block {

  /// List of triggaerables to start on contact
  List<Triggerable> triggerables;

  /// Creates Trigger instance
  Trigger(int id, int pos_x, int pos_y, int size_x, int size_y, List<Triggerable> triggerables, [bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "Trigger";
    this.triggerables = triggerables;
  }

  /// Starts triggerables on contact
  @override
  bool onCollisionExternal(Model model, Direction dir) {
    triggerables.forEach((triggerables) => triggerables.start(model));
    return false;
  }
}