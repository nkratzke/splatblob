import 'dart:async';
import 'dart:convert';
import 'dart:html';

/**
 * A levelgenerator, used to generate the level from a json
 */
class LevelGenerator {
  //Anzahl der Gesamtlevel
  int _lvlNumberSum = 0;
  //the current levelnumber
  int _currentLvl = 0;
  //levelnumber, value of the first level to load
  int _lvlNumber = 0;

  //number of columns
  int _column = 0;

  //number of rows
  int _row = 0;

  //used for the code
  String _code = "";

  //list of levels
  List<Map> _lvls = new List<Map>();

  //list of available levels
  List<Map> _lvlList = new List<Map>();

  /**
   * Constructor
   */
  LevelGenerator() {
    loadData(); //Reading Level from Json
  }

  //region LOAD JSON

  /**
   * Loads the levels from the json from the server
   */
  Future loadData() async {
    // call the web server asynchronously
    await HttpRequest.getString("../web/level.json").then(onDataLoaded);
  }

  /**
   * takes the raw json response text from the server
   */
  void onDataLoaded(String responseText) {
    var jsonString = JSON.decode(responseText);
    var lvl = jsonString.values.toList().elementAt(0);

    _lvls = lvl; //Anzahl der Level
    Map str2 = lvl.elementAt(_lvlNumber); // LevelIndex
    levelformatter(str2);
    this._lvlNumberSum = _lvls.length; //Anzahl der Level
  }

  /**
   * reads the values from the map and saves them in variables
   */
  levelformatter(Map level) {
    if (level.values.elementAt(0) != null &&
        level.values.elementAt(1) != null &&
        level.values.elementAt(2) != null &&
        level.values.elementAt(3) != null && level.values.elementAt(4) != null) {
      this._currentLvl = level.values.elementAt(0);
      this._row = level.values.elementAt(1);
      this._column = level.values.elementAt(2);
      this._code = level.values.elementAt(3);
      _lvlList = level.values.elementAt(4);
    } else {
      print("The game was unable to load the level");
    }
  }

  //endregion

  //region SETTER

  void setSelectlevel(int lvlValue) {
    this._lvlNumber = lvlValue;
  }

  /**
   * sets the current level to the value i
   */
  setCurrentLevel(int i) {
    this._currentLvl = i;
  }

  //endregion

  //region GETTER

  /**
   * returns the number of columns
   */
  int getColumn() {
    return this._column;
  }

  /**
   * returns the number of rows
   */
  int getRow() {
    return this._row;
  }

  /**
   * returns the levelList
   */
  List<Map> getLvlList() {
    return this._lvlList;
  }

  /**
   * returns the number of the actual level
   */
  int getLevelValue() {
    return this._lvlNumber;
  }

  /**
   * returns the total number of levels
   */
  int getLevelAmount() {
    return this._lvlNumberSum;
  }

  /**
   * returns the current level
   */
  int getCurrentLevel() {
    return this._currentLvl;
  }


  //endregion

  //region LEVELCODE

  /**
   * returns the secret code for the actual level
   */
  String getLvlCode() {
    return this._code;
  }

  /**
   * Returns the level that matches the secret code. returns -1 if code not valid
   */
  int getLevelByCode(String str) {
    int lvlnr = -1;
    for (int i = 0; i < _lvls.length; i++) {
      if (str == _lvls.elementAt(i)['code']) {
        return _lvls.elementAt(i)['level'];
      }
    }
    return lvlnr;
  }

  //endregion

  /**
   * increments the number of the level
   */
  void nextLvl() {
    this._lvlNumber++;
  }
}