import 'Crate.dart';
import 'FieldObject.dart';
/**
 * Inherit from fieldObject, cant do much
 */
class Wall extends FieldObject {

  Wall() {
  }

  List<String> isPassable(FieldObject player, int pushPower) { //always return an empty list, walls cant be passed
    return new List();
  }

  void setCrate(Crate crate) { //walls cant contain crates
  }
}

