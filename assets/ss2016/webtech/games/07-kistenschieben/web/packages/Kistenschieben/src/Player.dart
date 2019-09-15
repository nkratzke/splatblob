import 'dart:core';

import 'FieldObject.dart';
import 'Statistics.dart';

class Player {
  FieldObject _staysOn = null;                  //the fieldObject on which the player stays on
  static const _stdPushPower = 1;               //standard Pushpower
  int _pushPower = _stdPushPower;               //sets the PushPower to the standard Pushpower
  int _stickyGloveAmount = 0;                   //number of left sticky gloves
  int _steroidAmount = 0;                       //number of left steroids

  Statistics _stats = Statistics.getInstance(); //An instance of the statistics
  List<String> _noPositionChanges = new List(); //an empty list

  /**
   * Constructor, sets the player on the given Ground
   */
  Player(FieldObject staysOn) {
    this._staysOn = staysOn;
  }

  /**
   * returns the left Sticky Gloves
   */
  int getStickyGloveAmount() {
    return _stickyGloveAmount;
  }

  /**
   * returns the number of left steroids
   */
  int getSteroidAmount() {
    return _steroidAmount;
  }

  /*
		Returns the x value of the position
	*/
  int getPosX() {
    return this._staysOn.getPosition().getX();
  }

  /*
		Returns the y value of the position
	*/
  int getPosY() {
    return this._staysOn.getPosition().getY();
  }

  /*
  Tries to move the player up,
  returns a list of changed positions
   */
  List<String> moveUp(int stickyGloveAmount, int steroidAmount) {
    List changedPositions = new List();                           //empty default list, in case the player cant move it doesnt has to be created. -> ok because there is only one player.
    _stickyGloveAmount = _stickyGloveAmount + stickyGloveAmount;  //store the given sticky gloves until they are used
    _steroidAmount = steroidAmount;                               //set the Amount of steroids the player was given
    _pushPower = _pushPower + _steroidAmount;                     //convert the steroids to pushpower
    bool cratePulled = false;                                     //escape var, the player cant pull and push at the same time
    if (_staysOn.upPointer != null) {                             //you cant move on something that doesnt exist
      if (_stickyGloveAmount > 0 && _staysOn.downPointer.hasCrate() &&
          _staysOn.upPointer.hasCrate() == false && _staysOn.upPointer
          .isPassable(_staysOn, _pushPower)
          .isEmpty == false) {                                    //Check if the player can pull a crate
        changedPositions.add(_staysOn.downPointer.getPositionAsString());
        _staysOn.downPointer.crate.moveUp(_pushPower);            //move the crate
        _stickyGloveAmount--;                                     //one of the stick gloves is used
        _stats.decGloves();                                       //for the stats
        _stats.incUsedGloves();
        cratePulled = true;                                       //player cant push anymore in this move
      }
      changedPositions.addAll(
          _staysOn.upPointer.isPassable(_staysOn, _pushPower));
      if (changedPositions.isEmpty == false) {                    //if the list is not empty it means the crate got pulled
        changedPositions.add(this._staysOn.getPositionAsString());
        if (cratePulled == true) {                                //the List has to be sortet because the view doesnt know the difference between push and pull, the list has to be in the right order
          sortList(changedPositions);
        }
        _staysOn = _staysOn.upPointer;                            //move the player
        _stats.incMoves();
        if (steroidAmount > 0) {                                  //take care of the stats
          _stats.decSteroids(steroidAmount);
          _stats.incUsedSteroids(steroidAmount);
        }
        _pushPower = _stdPushPower;
        _steroidAmount = 0;
        return changedPositions;                                  //the player was able to move
      } else {
        return _noPositionChanges;                                //the player wasn´t able to move
      }
    } else {
      return _noPositionChanges;                                  //the player wasn´t able to move
    }
  }

  /*
  Tries to move the player to the right,
  returns a list of changed positions
   */
  List<String> moveRight(int stickyGloveAmount, int steroidAmount) {
    List changedPositions = new List();
    _stickyGloveAmount = _stickyGloveAmount + stickyGloveAmount;
    _steroidAmount = steroidAmount;
    _pushPower = _pushPower + _steroidAmount;
    bool cratePulled = false;
    if (_staysOn.rightPointer != null) {
      if (_stickyGloveAmount > 0 && _staysOn.leftPointer.hasCrate() &&
          _staysOn.rightPointer.hasCrate() == false && _staysOn.rightPointer
          .isPassable(_staysOn, _pushPower)
          .isEmpty == false) {
        changedPositions.add(_staysOn.leftPointer.getPositionAsString());
        _staysOn.leftPointer.crate.moveRight(_pushPower);
        _stickyGloveAmount--;
        _stats.decGloves();
        _stats.incUsedGloves();
        cratePulled = true;
      }
      changedPositions.addAll(
          _staysOn.rightPointer.isPassable(_staysOn, _pushPower));
      if (changedPositions.isEmpty == false) {
        changedPositions.add(this._staysOn.getPositionAsString());
        if (cratePulled == true) {
          sortList(changedPositions);
        }
        _staysOn = _staysOn.rightPointer;
        _stats.incMoves();
        if (steroidAmount > 0) {
          _stats.decSteroids(steroidAmount);
          _stats.incUsedSteroids(steroidAmount);
        }
        _pushPower = _stdPushPower;
        _steroidAmount = 0;
        return changedPositions;
      } else {
        return _noPositionChanges;
      }
    } else {
      return _noPositionChanges;
    }
  }

  /*
  Tries to move the player down,
  returns a list of changed positions
   */
  List<String> moveDown(int stickyGloveAmount, int steroidAmount) {
    List changedPositions = new List();
    _stickyGloveAmount = _stickyGloveAmount + stickyGloveAmount;
    _steroidAmount = steroidAmount;
    _pushPower = _pushPower + _steroidAmount;
    bool cratePulled = false;
    if (_staysOn.downPointer != null) {
      if (_stickyGloveAmount > 0 && _staysOn.upPointer.hasCrate() &&
          _staysOn.downPointer.hasCrate() == false && _staysOn.downPointer
          .isPassable(_staysOn, _pushPower)
          .isEmpty == false) {
        changedPositions.add(_staysOn.upPointer.getPositionAsString());
        _staysOn.upPointer.crate.moveDown(_pushPower);
        _stickyGloveAmount--;
        _stats.decGloves();
        _stats.incUsedGloves();
        cratePulled = true;
      }
      changedPositions.addAll(
          _staysOn.downPointer.isPassable(_staysOn, _pushPower));
      if (changedPositions.isEmpty == false) {
        changedPositions.add(this._staysOn.getPositionAsString());
        if (cratePulled == true) {
          sortList(changedPositions);
        }
        _staysOn = _staysOn.downPointer;
        _stats.incMoves();
        if (steroidAmount > 0) {
          _stats.decSteroids(steroidAmount);
          _stats.incUsedSteroids(steroidAmount);
        }
        _pushPower = _stdPushPower;
        _steroidAmount = 0;
        return changedPositions;
      } else {
        return _noPositionChanges;
      }
    } else {
      return _noPositionChanges;
    }
  }

  /*
Tries to move the player to the left,
  returns a list of changed positions
   */
  List<String> moveLeft(int stickyGloveAmount, int steroidAmount) {
    List changedPositions = new List();
    _stickyGloveAmount = _stickyGloveAmount + stickyGloveAmount;
    _steroidAmount = steroidAmount;
    _pushPower = _pushPower + _steroidAmount;
    bool cratePulled = false;
    if (_staysOn.leftPointer != null) {
      if (_stickyGloveAmount > 0 && _staysOn.rightPointer.hasCrate() &&
          _staysOn.leftPointer.hasCrate() == false && _staysOn.leftPointer
          .isPassable(_staysOn, _pushPower)
          .isEmpty == false) {
        changedPositions.add(_staysOn.rightPointer.getPositionAsString());
        _staysOn.rightPointer.crate.moveLeft(_pushPower);
        _stickyGloveAmount--;
        _stats.decGloves();
        _stats.incUsedGloves();
        cratePulled = true;
      }
      changedPositions.addAll(
          _staysOn.leftPointer.isPassable(_staysOn, _pushPower));
      if (changedPositions.isEmpty == false) {
        changedPositions.add(this._staysOn.getPositionAsString());
        if (cratePulled == true) {
          sortList(changedPositions);
        }
        _staysOn = _staysOn.leftPointer;
        _stats.incMoves();
        if (steroidAmount > 0) {
          _stats.decSteroids(steroidAmount);
          _stats.incUsedSteroids(steroidAmount);
        }
        _pushPower = _stdPushPower;
        _steroidAmount = 0;
        return changedPositions;
      } else {
        return _noPositionChanges;
      }
    } else {
      return _noPositionChanges;
    }
  }

  /*
  sorts the List for the view,
  because the order after pull is different to the order after push
   */
  List<String> sortList(List<String> changedPositions) {
    String temp = changedPositions[0];
    changedPositions[0] = changedPositions[2];
    changedPositions[2] = temp;
    return changedPositions;
  }
}