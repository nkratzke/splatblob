part of runner;

class Block extends Rect {

  /// Block ID
  int id;

  /// Block class name, thanks dart2js
  String name = "Block";

  //if object is moving, set speed_x != 0 or speed_y != 0
  /// speed
  int speed_x;
  int speed_y;

  /// if true kills player on contact
  bool isDeadly;

  /// if true can have contact with player
  bool canCollide;

  /// if true block is visible
  bool isVisible;


  /// Creates a block instance
  Block(int id, int pos_x, int pos_y, int size_x, int size_y, [bool isDeadly, bool canCollide, bool isVisible]) {
    this.id = id;
    this.pos_x = pos_x ?? 0;
    this.pos_y = pos_y ?? 0;
    this.size_x = size_x ?? 0;
    this.size_y = size_y ?? 0;
    this.isVisible = isVisible ?? true;
    this.canCollide = canCollide ?? true;
    this.isDeadly = isDeadly ?? false;
    speed_x = 0;
    speed_y = 0;
  }

  /// handles collision
  ///
  /// override this for block specific behaviour
  bool onCollisionExternal(Model model, Direction dir) {
    log("${name} ${id} missing onCollisionExternal");
    return true;
  }

  /// handles collision
  ///
  /// returns [true] if player landed
  bool onCollision(Model model, Direction dir) {
    if (isDeadly) {
      model.fail();
      log("${name} ${id} killed player, coming from ${dir}");
      return false;
    } else {
      return onCollisionExternal(model, dir);
    }
  }

  /// updates block
  ///
  /// called every tick, updates block
  void onUpdate() {
    pos_x += speed_x;
    pos_y += speed_y;
  }

  /// Create String
  String toString() {
    var buffer = new StringBuffer();
    buffer.write(name);
    buffer.write(" ");
    buffer.write(id);
    buffer.write(" ");
    buffer.write(size_x);
    buffer.write(" ");
    buffer.write(size_y);
    buffer.write(" ");
    buffer.write(pos_x);
    buffer.write(" ");
    buffer.write(pos_y);
    buffer.write(" ");
    buffer.write(speed_x);
    return buffer.toString();
  }

}