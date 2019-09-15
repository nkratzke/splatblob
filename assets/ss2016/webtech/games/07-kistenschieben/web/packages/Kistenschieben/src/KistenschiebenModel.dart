import 'Crate.dart';
import 'Ground.dart';
import 'Player.dart';
import 'QuattroLinkedList.dart';
import 'Statistics.dart';
import 'Target.dart';
import 'Wall.dart';

/**
 * This class is the interface for the Controller.
 *  It Provides all necessary informations and model-methods.
 */
class KistenschiebenModel {

  QuattroLinkedList _qlList = null;   //this will bne the level after loadLvl() // List of FieldObjecks
  Player _player = null;              //The player that stands on a FieldObjeck in the _qlList
  Target _target = null;              //The last created Target, it can be asked if the game is won, it´ll know
  Statistics _stats = null;           //Will be an instance of Statistiks, Statistics aer the players inventory and the players stats for this level
  bool _playerExists = false;         //only one player is allowed on in the level, if the imput is wrong and there is more than one player, the others have to be sortet out
  int _countCrates = 0;               //The amount of the crates have to be at least bigger than the amout of targets, so we have to count them both
  int _countTargets = 0;

  /*
    Konstructor, gets an instance of statistics
   */
  KistenschiebenModel() {
    _stats = Statistics.getInstance();
  }

//region LOAD AND BUILD LEVEL

  /**
   * Manages the constuction of the level
   * uses the List of maps from the JSON
   */
  void loadLvl(List<Map> levelList, int row, int column) {
    bool firstLine = true;
    _target = null;
    _qlList = null;
    _qlList = new QuattroLinkedList();
    _playerExists = false;
    for (var map in levelList) {
      firstLine = addNewLine(firstLine, map["r"].toUpperCase()); // first in line is the Fieldobject where the next line will be connected to
    }
  }

  /**
   * disassembles the line and adds uses other methods to add the right Fieldobject to the _qlList
   */
  bool addNewLine(bool firstLine, String line) {
    if (firstLine == true) {                    //if the first line is to be added there is nothing to add down to
      addRight(line);
      firstLine = false;
    } else {
      String firstChar = "";
      if (line.length > 0) {
        firstChar = line.substring(0, 1);
        line = line.substring(1);
      } else {
        firstChar = "G";
      }
      addDown(firstChar);
      addRight(line);
    }
    return firstLine;
  }

  /**
   * Adds a Fieldobject to the right
   */
  void addRight(String line) {
    Crate crate = null;
    int length = line.length;
    for (int i = 0; i < length; i++) {
      String firstChar = "";
      if (line.length > 0) {
        firstChar = line.substring(0, 1);
        line = line.substring(1);
      } else {
        firstChar = "G";          //just in case the Line String is to short we add grounds, therefore the level will be at least loadable
      }
      switch (firstChar) {
        case 'W' :
          _qlList.addRight(new Wall());   //Adds a wall to the right
          break;
        case 'G' :
          _qlList.addRight(new Ground()); //Adds a ground to the right
          break;
        case 'P' :
          if (_playerExists == false) {
            _player = new Player(_qlList.addRight(new Ground())); //Adds a Ground to the right, creates the player and sets the player on the ground
            _playerExists = true;
          } else {                                                //In case a player already exists, just add a groundobject
            _qlList.addRight(new Ground());
          }
          break;
        case 'C' :
          crate = new Crate(_qlList.addRight(new Ground()));      //Adds a Ground and creates a Crate, puts the crate on the Ground
          crate.getStaysOn().setCrate(crate);
          _countCrates++;
          break;
        case 'T' :
          _target = _qlList.addRight(new Target(_target));        //Adds a target to the right
          _countTargets++;
          break;
        case 'S' :                                                //Adds a target to the right, creates a crate and puts the crate on the target
          _target = new Target(_target);
          crate = new Crate(_qlList.addRight(_target));
          crate.getStaysOn().setCrate(crate);
          _countCrates++;
          _countTargets++;
          break;
        default:
          _qlList.addRight(new Ground());
          break;
      }
    }
  }

  /**
   * First Fieldobjekt in the Line, has to be added under the first Fieldobject of the last line
   */
  void addDown(String firstChar) {
    Crate crate = null;
    switch (firstChar) {
      case 'W' :
        _qlList.addDown(new Wall());
        break;
      case 'G' :
        _qlList.addDown(new Ground());
        break;
      case 'P' :
        if (_playerExists == false) {
          _player = new Player(_qlList.addRight(new Ground()));
          _playerExists = true;
        } else {
          _qlList.addRight(new Ground());
        }
        break;
      case 'C' :
        crate = new Crate(_qlList.addDown(new Ground()));
        crate.getStaysOn().setCrate(crate);
        _countCrates++;
        break;
      case 'T' :
        _target = _qlList.addDown(new Target(_target));
        _countTargets++;
        break;
      case 'S' :
        _target = new Target(_target);
        crate = new Crate(_qlList.addDown(_target));
        crate.getStaysOn().setCrate(crate);
        _countCrates++;
        _countTargets++;
        break;
      default:
        _qlList.addRight(new Ground());
        break;
    }
  }

//endregion

//region MOVE

  /*
   * tells the player to go up. Returns a List of changed positions, if it is not possible to move the list will be empty
   */
  List<String> moveUp(int pullAmount, int pushAmount) {
    return _player.moveUp(pullAmount, pushAmount);
  }

  /*
   * tells the player to go right. Returns a List of changed positions, if it is not possible to move the list will be empty
   */
  List<String> moveRight(int pullAmount, int pushAmount) {
    return _player.moveRight(pullAmount, pushAmount);
  }

  /*
   * tells the player to go down. Returns a List of changed positions, if it is not possible to move the list will be empty
   */
  List<String> moveDown(int pullAmount, int pushAmount) {
    return _player.moveDown(pullAmount, pushAmount);
  }

  /*
   * tells the player to go Left. Returns a List of changed positions, if it is not possible to move the list will be empty
   */
  List<String> moveLeft(int pullAmount, int pushAmount) {
    return _player.moveLeft(pullAmount, pushAmount);
  }

//endregion

//region GETTER & SETTER

  /**
   * returns the X value of the position of the player, needed for the moveTouch method
   */
  int getPlayerPosX() {
    return this._player.getPosX();
  }

  /**
   * returns the Y value of the position of the player, needed for the moveTouch method
   */
  int getPlayerPosY() {
    return this._player.getPosY();
  }

  /**
   * sets the actual level in the statistics to the new value
   */
  void setLvl(int lvlNr) {
    this._stats.setCurrentLvl(lvlNr);
  }

  /**
   * returns the amount of steroids the player has at the moment
   */
  int getSteroidAmount() {
    return _player.getSteroidAmount();
  }

  /**
   * returns the the amount of Stikygloves the play has at the moment
   */
  int getStickyGloveAmount() {
    return _player.getStickyGloveAmount();
  }

//endregion

//region STATS

  /**
   * resets the local stats and the level by loading it again
   */
  void resetStats() {
    //loadLvl(actualLevel, row, column);
    _stats.resetLocal();
  }

  /**
   * resets all stats and the game
   */
  void resetStatsTotal() {
    int gloves = _stats.getGloves();
    _stats.resetAll();
    _stats.setGloves(gloves);
  }

  /**
   * sets the stats to the given values
   */
  void loadStats(Map<String, int> save) {
    _stats.loadStats(save);
  }

  /**
   * returns the statistics as a Map
   */
  Map<String, int> getStats() {
    return _stats.getStats();
  }

  /**
   * returns the number of left gloves
   */
  int getGloves() {
    return _stats.getGloves();
  }

  /**
   * Sets the number of gloves in the statistics to the value n
   */
  void setGloves(int gloves) {
    _stats.setGloves(gloves);
  }

  /**
   * returns the number of left steroids
   */
  int getSteroids() {
    return _stats.getSteroids();
  }

  /**
   * Sets the number of steroids in the statistics to the value n
   */
  void setSteroids(int steroids) {
    _stats.setSteroids(steroids);
  }

  /**
   * increments the number of resets
   */
  void incResets() {
    this._stats.incResets();
  }

//endregion

  /**
   * asks the target if the game is won.
   */
  bool checkWin() {
    bool ret = false;
    if (_countCrates < _countTargets) { //if tehere are more targets than crates for whatever reason, win the game, so the game can go on
      ret = true;
    } else {
      ret = _target.getWon();
    }
    return ret;
  }
}
