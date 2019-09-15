part of runner;

class Triggerable extends Block {

  /// Creates Triggerable instance
  ///
  /// This is just a class from which subclasses inherit their start behaviour
  Triggerable(int id, int pos_x, int pos_y, int size_x, int size_y, [bool isDeadly, bool canCollide, bool isVisible])
      : super(id, pos_x, pos_y, size_x, size_y, isDeadly, canCollide, isVisible) {
    name = "Trigger";
  }

  /// method called by trigger on collision
  void start(Model model) {
    log("Triggerable ${id} not set!");
  }

}