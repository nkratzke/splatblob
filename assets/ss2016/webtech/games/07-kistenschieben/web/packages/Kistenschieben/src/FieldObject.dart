import 'Crate.dart';
import 'Position.dart';
/**
 * the level persist of fieldObjects
 */
class FieldObject {
  Crate crate = null;
  //Position
  Position _position = new Position(0, 0);
  //pointer
  FieldObject rightPointer;     //every fieldObject knows its neighbours
  FieldObject leftPointer;
  FieldObject upPointer;
  FieldObject downPointer;

  /**
   * Constructor, sets all pointer null, QuattroLinkedList will manage them
   */
  FieldObject() {
    this.upPointer = null;
    this.rightPointer = null;
    this.downPointer = null;
    this.leftPointer = null;
  }

  /**
   * returns the position
   */
  Position getPosition() {
    return _position;
  }

  /**
   * returns the crate
   */
  Crate getCrate() {
    return this.crate;
  }

  /**
   * Sets the crate
   */
  void setCrate(Crate crate) {
    this.crate = crate;
  }

  /**
   * checks if the fieldObject has a crate
   */
  bool hasCrate() {
    bool ret = false;
    if (this.crate != null) {
      ret = true;
    }
    return ret;
  }

  /**
   * determents if the fieldObject is passeble
   * returns the list of changed Positions
   */
  List isPassable(FieldObject whereActorStaysOn, int pushPower) {
    if (this.crate == null) {     //if the fieldObject is empty the field is passeble
      List changedPositions = new List();
      changedPositions.add(this.getPositionAsString());
      return changedPositions;
    } else if (pushPower > 0) {   //if the field contains a crate, the crate has to go. Crate will can only be moved if there is enough pushPower left
      return crate.move(whereActorStaysOn, pushPower);
    } else {
      return new List();
    }
  }

  /**
   * Returns the position as a String "#posX_Y"
   */
  String getPositionAsString() {
    String str = this._position.getX().toString() + "_" +
        this._position.getY().toString();
    return str;
  }
}
