import 'FieldObject.dart';
import 'Statistics.dart';

/**
 * A Crate can stay on a fieldObject of the type ground or target.
 */
class Crate {   //a crate has to report to the statistics if it moves
  Statistics _stats = Statistics.getInstance();

  //The FieldObject on which the crate stays on
  var _staysOn = null;

  /**
   * Constructor, sets the fieldObjekt the crate stays on
   */
  Crate(FieldObject _staysOn) {
    this._staysOn = _staysOn;
  }

  /**
   * returns the FieldObject on which the crate stays on
   */
  FieldObject getStaysOn() {
    return this._staysOn;
  }

  /*
   *  move method, determans where the crate has to move
   */
  List move(FieldObject whereActorStaysOn, int pushPower) {
    List ret = new List();
    if (whereActorStaysOn == _staysOn.upPointer) {
      ret = moveDown(pushPower);
    } else if (whereActorStaysOn == _staysOn.rightPointer) {
      ret = moveLeft(pushPower);
    } else if (whereActorStaysOn == _staysOn.downPointer) {
      ret = moveUp(pushPower);
    } else if (whereActorStaysOn == _staysOn.leftPointer) {
      ret = moveRight(pushPower);
    }
    return ret;
  }

  /**
   * Tries to move the crate up, returns a list of changed Positions
   */
  List moveUp(int pushPower) {
    pushPower--;        //one pushpower is consumed if a crate is pushed
    if (_staysOn.upPointer != null) {   //don´t go anywhere if there is nowhere to go
      List changedPositions = _staysOn.upPointer.isPassable(
          _staysOn, pushPower);
      if (changedPositions.isEmpty == false) {    //the crate can move
        changedPositions.add(this._staysOn.getPositionAsString());
        _staysOn = _staysOn.upPointer;            //move the crate
        _staysOn.downPointer.crate = null;
        _staysOn.crate = this;
        if (_staysOn.runtimeType.toString().contains("Target")) { //crate was pushed onto a target, check if the game is won
          _staysOn.checkOutNeighbours();
        }
        if (_staysOn.downPointer.runtimeType.toString().contains("Target")) {
          _staysOn.downPointer.checkOutNeighbours();
        }
        _stats.incPushes();
        return changedPositions;
      } else {
        return new List();
      }
    } else {
      return new List();
    }
  }

  /**
   * Tries to move the crate to the right, returns a list of changed Positions
   */
  List moveRight(int pushPower) {
    pushPower--;
    if (_staysOn.rightPointer != null) {
      List changedPositions = _staysOn.rightPointer.isPassable(
          _staysOn, pushPower);
      if (changedPositions.isEmpty == false) {
        changedPositions.add(this._staysOn.getPositionAsString());
        _staysOn = _staysOn.rightPointer;
        _staysOn.leftPointer.crate = null;
        _staysOn.crate = this;
        if (_staysOn.runtimeType.toString().contains("Target")) {
          _staysOn.checkOutNeighbours();
        }
        if (_staysOn.leftPointer.runtimeType.toString().contains("Target")) {
          _staysOn.leftPointer.checkOutNeighbours();
        }
        _stats.incPushes();
        return changedPositions;
      } else {
        return new List();
      }
    } else {
      return new List();
    }
  }

  /**
   * Tries to move the crate down, returns a list of changed Positions
   */
  List moveDown(int pushPower) {
    pushPower--;
    if (_staysOn.downPointer != null) {
      List changedPositions = _staysOn.downPointer.isPassable(
          _staysOn, pushPower);
      if (changedPositions.isEmpty == false) {
        changedPositions.add(this._staysOn.getPositionAsString());
        _staysOn = _staysOn.downPointer;
        _staysOn.upPointer.crate = null;
        _staysOn.crate = this;
        if (_staysOn.runtimeType.toString().contains("Target")) {
          _staysOn.checkOutNeighbours();
        }
        if (_staysOn.upPointer.runtimeType.toString().contains("Target")) {
          _staysOn.upPointer.checkOutNeighbours();
        }
        _stats.incPushes();
        return changedPositions;
      } else {
        return new List();
      }
    } else {
      return new List();
    }
  }

  /**
   * Tries to move the crate to the left, returns a list of changed Positions
   */
  List moveLeft(int pushPower) {
    pushPower--;
    if (_staysOn.leftPointer != null) {
      List changedPositions = _staysOn.leftPointer.isPassable(
          _staysOn, pushPower);
      if (changedPositions.isEmpty == false) {
        changedPositions.add(this._staysOn.getPositionAsString());
        _staysOn = _staysOn.leftPointer;
        _staysOn.rightPointer.crate = null;
        _staysOn.crate = this;
        if (_staysOn.runtimeType.toString().contains("Target")) {
          _staysOn.checkOutNeighbours();
        }
        if (_staysOn.rightPointer.runtimeType.toString().contains("Target")) {
          _staysOn.rightPointer.checkOutNeighbours();
        }
        _stats.incPushes();
        return changedPositions;
      } else {
        return new List();
      }
    } else {
      return new List();
    }
  }
}
