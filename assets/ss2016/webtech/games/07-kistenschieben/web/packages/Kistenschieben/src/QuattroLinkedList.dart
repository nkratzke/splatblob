import 'FieldObject.dart';

class QuattroLinkedList {
  FieldObject _root = null;       //The very first fieldObject in the level
  FieldObject _lastAdded = null;  //The last added fieldObject
  FieldObject _firstInRow = null; //The First fieldObject in the last added Row //the first fieldObjekt of the next line will be added down to this one

  QuattroLinkedList() {
  }

  /**
   * Adds a new Fieldobject in the actual row
   */
  FieldObject addRight(FieldObject fieldObject) {
    if (_root == null) {                          //remember the root
      _root = fieldObject;
      _root.getPosition().setX(0);
      _root.getPosition().setY(0);
      _firstInRow = _root;                        //firstInRow is root in this case
    } else {
      fieldObject.leftPointer = _lastAdded;
      _lastAdded.rightPointer = fieldObject;

      //set getPosition()
      fieldObject.getPosition().setX(                               //set all the pointers of all the fieldObjects
          fieldObject.leftPointer.getPosition().getX() + 1);
      fieldObject.getPosition().setY(
          fieldObject.leftPointer.getPosition().getY());
      if (fieldObject.leftPointer.upPointer != null &&
          fieldObject.leftPointer.upPointer.rightPointer != null) {
        fieldObject.upPointer = fieldObject.leftPointer.upPointer.rightPointer;
        fieldObject.leftPointer.upPointer.rightPointer.downPointer =
            fieldObject;
      } else {
        fieldObject.upPointer = null;
      }
    }
    _lastAdded = fieldObject;      //remember the last added fieldObject
    return _lastAdded;
  }

  /**
   * Adds a new Fieldobject under the first fieldObject of the last Line
   */
  FieldObject addDown(FieldObject fieldObject) {
    fieldObject.upPointer = _firstInRow;
    _firstInRow.downPointer = fieldObject;

    //set getPosition()
    fieldObject.getPosition().setX(fieldObject.upPointer.getPosition().getX());
    fieldObject.getPosition().setY(
        fieldObject.upPointer.getPosition().getY() + 1);
    _firstInRow = fieldObject;
    _lastAdded = _firstInRow;
    return _lastAdded;
  }
}
