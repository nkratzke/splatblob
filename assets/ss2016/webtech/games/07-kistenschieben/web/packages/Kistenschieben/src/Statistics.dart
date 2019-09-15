class Statistics {

  //moves this round, 0 after reset
  static var _localMoves;
  //moves this round total
  static int _globalMoves;
  //pushes this round, 0 after reset
  static int _localPushes;
  //pushes this round total
  static int _globalPushes;
  //number of resets
  static int _resets;
  //the actual level
  static int _actualLevel;
  //an instance of the static Statistics
  static Statistics _instance;
  //number of sticky gloves, used to pull a crate
  static int _gloves;
  //number of used sticky gloves
  static int _usedGloves;
  //number of steroids, used to improve PushPower
  static int _steroids;
  //number of used steroids
  static int _usedSteroids;

  /**
   * Constructor
   */
  Statistics() {
    _localMoves = 0;
    _globalMoves = 0;
    _localPushes = 0;
    _globalPushes = 0;
    _resets = 0;
    _actualLevel = 0;
    _usedGloves = 0;
    _gloves = 3;
    _steroids = 3;
    _usedSteroids = 0;
  }


  //region GETTER

  /**
   * returns an instance of the statistics
   */
  static Statistics getInstance() {
    if (_instance == null) {
      _instance = new Statistics();
    }
    return _instance;
  }

  /**
   * returns the number of resets
   */
  int getResets() {
    return _resets;
  }

  /**
   * returns the local Moves
   */
  int getLocalMoves() {
    return _localMoves;
  }

  /**
   * returns the global Moves
   */
  int getGlobalMoves() {
    return _globalMoves;
  }

  /**
   * returns the local Pushes
   */
  int getLocalPushes() {
    return _localPushes;
  }

  /**
   * returns the global Pushes
   */
  int getGlobalPushes() {
    return _globalPushes;
  }

  /**
   * returns the number of used gloves
   */
  int getUsedGloves() {
    return _usedGloves;
  }

  /**
   * returns the number of gloves
   */
  int getGloves() {
    return _gloves;
  }

  /**
   * returns the number of steroids
   */
  int getSteroids() {
    return _steroids;
  }

  /**
   * returns the number of used Steroids
   */
  int getUsedSteroids() {
    return _usedSteroids;
  }

  //endregion

  //region SETTER

  /**
   * Sets the value of the total Moves used in this round
   */
  void setGlobalMoves(int moves) {
    _globalMoves = moves;
  }

  /**
   * Sets the value of the total Pushes used in this round
   */
  void setGlobalPushes(int pushes) {
    _globalPushes = pushes;
  }

  /**
   * sets the resets to the value res
   */
  void setResets(int res) {
    _resets = res;
  }

  /**
   * sets the actual level
   */
  void setCurrentLvl(int lvl) {
    _actualLevel = lvl;
  }

  /**
   * sets the number of gloves to the new value
   */
  void setGloves(int val) {
    _gloves = val;
  }

  /**
   * sets the number of steroids to the new value
   */
  setSteroids(int val) {
    _steroids = val;
  }

  //endregion

  //region INC & DEC

  /**
   * Increments the resets
   */
  void incResets() {
    _resets++;
  }

  /**
   * increments Pushes
   */
  void incPushes() {
    _localPushes++;
    _globalPushes++;
  }

  /**
   * increments Moves
   */
  void incMoves() {
    _localMoves++;
    _globalMoves++;
  }

  /**
   * increments the number of gloves
   */
  void incGloves() {
    _gloves++;
  }

  /**
   * increments the number of used Gloves by 1
   */
  void incUsedGloves() {
    _usedGloves++;
  }

  /**
   * increments the number of steroids by 1
   */
  incSteroids() {
    _steroids++;
  }

  /**
   * increments the number of used steroids by 1
   */
  incUsedSteroids(int usedSteroids) {
    _usedSteroids = _usedSteroids + usedSteroids;
  }

  /**
   * decrements the number of steroids if possible and returns true. Returns false if not
   */
  decSteroids(int usedSteroids) {
    for (int i = 0; i<usedSteroids; i++) {
      if (_steroids >= 0 && _steroids - usedSteroids >= 0) {
        _steroids = _steroids - usedSteroids;
      }
    }
  }

  /**
   * decrements the number of gloves if possible and returns true. Returns false if not
   */
  decGloves() {
    if (_gloves > 0) {
      _gloves--;
    }
  }

  //endregion

  //region RESET

  /**
   *  Resets all values
   */
  void resetAll() {
    resetLocal();
    resetGlobal();
  }

  /*
  resets all "local" values, used if reset
   */
  void resetLocal() {
    _localMoves = 0;
    _localPushes = 0;
  }

  /*
  resets all "global" values
   */
  void resetGlobal() {
    _globalMoves = 0;
    _globalPushes = 0;
    _resets = 0;
    _usedGloves = 0;
    _usedSteroids = 0;
  }

  /**
   * sets the number of gloves to 0
   */
  void resetGloves() {
    _gloves = 0;
  }

  //endregion

  /*
   *sets the statistics to the given values. Used when loading from a savegame
   */
  void loadStats(Map<String, int> stats) {
    _actualLevel = stats.remove("actualLevel");
    _localMoves = stats.remove("localMoves");
    _globalMoves = stats.remove("globalMoves");
    _localPushes = stats.remove("localPushes");
    _globalPushes = stats.remove("globalPushes");
    _gloves = stats.remove("gloves");
    _usedGloves = stats.remove("usedGloves");
    _steroids = stats.remove("steroids");
    _usedSteroids = stats.remove("usedSteroids");
  }

  /*
    Returns a Map with all stats
    1. local moves
    2. global moves
    3. local pushes
    4. global pushes
    5. local time
    6. global time
    7. resets
    8. actual level
    9. gloves
   */
  Map<String, int> getStats() {
    Map<String, int> out = new Map();
    out['localMoves'] = _localMoves;
    out['globalMoves'] = _globalMoves;
    out['localPushes'] = _localPushes;
    out['globalPushes'] = _globalPushes;
    out['resets'] = _resets;
    out['actualLevel'] = _actualLevel;
    out['gloves'] = _gloves;
    out['usedGloves'] = _usedGloves;
    out['steroids'] = _steroids;
    out['usedSteroids'] = _usedSteroids;
    return out;
  }
}
