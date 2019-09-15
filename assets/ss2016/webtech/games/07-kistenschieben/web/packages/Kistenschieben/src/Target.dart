import 'FieldObject.dart';

/**
 * Inherit from fieldObject, decides if the game is won if every there is a crate on every target
 * can be passed, can contain crates
 */
class Target extends FieldObject {
  Target _prevTarget = null;      //Pointer to the next target, the targets need to be able to communicate with each other to check if every target has a crate
  Target _nextTarget = null;
  bool _won = false;              //will be set true if every target has a crate

  /**
   * Constructor, sets the Pointer to the given Target and the pointer of the given target
   */
  Target(Target prevTarget) {
    this._prevTarget = prevTarget;
    if (this._prevTarget != null) {
      this._prevTarget._nextTarget = this;
    }
  }

  /**
   * returns true if won
   */
  bool getWon() {
    return this._won;
  }

  //askes the neigbour-targets if the game is won - this method gets triggered when by a crate
  bool checkOutNeighbours() {
    bool ret = false;
    ret = checkOutNeighboursPrev() && checkOutNeighboursNext();
    setPrevWon(ret);
    setNextWon(ret);
    return ret;
  }

  /**
   * ask only the prev neighbour if won
   */
  bool checkOutNeighboursPrev() {
    bool ret = false;
    if ((this._prevTarget == null ||
        this._prevTarget.checkOutNeighboursPrev() == true) &&
        this.hasCrate()) {
      ret = true;
    } else {
      ret = false;
    }
    return ret;
  }

  /**
   * ask only the next neighbour if won
   */
  bool checkOutNeighboursNext() {
    bool ret = false;
    if ((this._nextTarget == null ||
        this._nextTarget.checkOutNeighboursNext() == true) &&
        this.hasCrate()) {
      ret = true;
    } else {
      ret = false;
    }
    return ret;
  }

  /**
   * if this target noticed that the game is won every target hat to be set to won because we dont know which target will be asked
   */
  void setPrevWon(bool won) {
    this._won = won;
    if (this._prevTarget != null) {
      this._prevTarget.setPrevWon(_won);
    }
  }

  /**
   * if this target noticed that the game is won every target hat to be set to won because we dont know which target will be asked
   */
  void setNextWon(bool won) {
    this._won = won;
    if (this._nextTarget != null) {
      this._nextTarget.setNextWon(_won);
    }
  }
}
