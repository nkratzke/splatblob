part of legendofhref;

/**
 * typedef for the callback function used in the turn method.
 */
typedef void CallbackFunc();

/**
 * the game itself containing the main loop
 */
class Game {
  final Duration _turnDuration;
  final GamekeyController gkc;

  Unit pc;
  AreaMap map;
  int _turnNumber = 0;
  bool _enemyTurnDone = true;
  bool _isTurnbased;
  bool _debug = false;

  bool ready = true;
  Timer _turnTimer;
  
  GameView view;

  
  Map<int, List<CallbackFunc>> callbackMap = new Map();
  
  bool get enemyTurnDone => _enemyTurnDone;
  bool get isTurnbased => _isTurnbased;
  bool get isRunning => _turnTimer?.isActive??false;
  bool get debug => _debug;

  final _checkDebugMethod;
  bool checkDebug() => _checkDebugMethod();
  
  /**
   * creates a new game based on the settings and the gamekeycontroller
   */
  Game(Map settings, this.gkc, {bool checkDebug()}) : _turnDuration = new Duration(milliseconds: settings["duration"]??500), _checkDebugMethod = checkDebug??(()=>true) {
    //loadMap("./testmap.json");
    _isTurnbased = settings["turnbased"]??false;
    _debug = settings["debug"]??false;
  }
  
  /**
   * pauses the game
   */
  void pauseGame() {
    _turnTimer.cancel();
  }
  
  /**
   * unpauses the game
   */
  void unpauseGame() {
    _turnTimer = new Timer.periodic(_turnDuration, (_) async {
      ready = true;
      if (!isTurnbased) turn();
    });
  }
  
  /**
   * pause method used from game to bring up the menu
   */
  void togglePause() {
    if(isRunning) {
      pauseGame();
      view.showMenu();
    } else {
      view.hideMenu();
      unpauseGame();
    }
  }

  Future loadMap(String url) async {
    HttpRequest request = await HttpRequest.request(url);
    if(request.status != 200) return null;
    Map json = JSON.decode(request.responseText);
    loadMapFromJson(json);
    return null;
  }
  
  void loadMapFromJson(Map json) {
    map = new AreaMap.fromJson(json, this);
    AreaMapView mapview = new AreaMapView(map, querySelector("#map"));
    map.forEachField((f) {
      new MapFieldView(f);
      f.objects.forEach((o) {
        new ObjectEntityView(o);
        new EntityEventListener(o);
      });
    });
    map.forEachUnit((u) {
      if (u.type == "href") {
        if(pc == null) {
          pc = u;
          new PCView(u, querySelector("#pc_health"));
          new PCEventListener(u);
        } else {
          Position p = u.position;
          Vector facing = u.facing;
          map.removeUnit(u);
          pc._facing = facing;
          map.moveUnit(pc, p);
          pc._position = p;
          pc.updateView();
        }
      } else {
        new UnitView(u);
        new UnitEventListener(u);
      }
    });
    mapview.update();
  }
  
  /**
   * switches the map
   */
  void changeMap(String mapName) {
    pauseGame();
    loadMap("./${mapName}.json");
    unpauseGame();
  }
  
  /**
   * ends the game, saves and shows the score
   */
  void gameover() {
    wipeSave();
    Map json = new Map();
    json["score"] = pc.score;
    json["killcount"] = pc.killcount;
    gkc.storeState(json);
    view.gameover();
  }
  
  /**
   * wipes the local save
   */
  void wipeSave() {
    window.localStorage.remove("save");
  }

  /**
   * the turn method - called by the turn timer or in turnbased mode by end of every player turn
   * thsi method processes all ai moves and turn-timed events
   */
  void turn() {
    if(debug && checkDebug()) return;
    _enemyTurnDone = false;
    _turnNumber++;
    if(debug) {
      print("Turn $_turnNumber");
    }
    map.units.forEach((u) {
      if (u.type != "href") {
        u.turn();
      }
    });
    if(callbackMap[turnNumber] != null) {
      while(callbackMap[turnNumber].isNotEmpty) {
        //Execute CALLBACK
        (callbackMap[turnNumber].removeLast())();
      }
      callbackMap.remove(turnNumber);
    }
    _enemyTurnDone = true;
  }
  
  int get turnNumber => _turnNumber;
  
  /**
   * method to register a turn callback.
   */
  void registerTurnCallback(CallbackFunc callback, int turn) {
    if(turn < turnNumber) {
      turn = turnNumber+1;
    }
    if(callbackMap[turn] == null) {
      callbackMap[turn] = new List();
    }
    callbackMap[turn].add(callback);
  }
}
