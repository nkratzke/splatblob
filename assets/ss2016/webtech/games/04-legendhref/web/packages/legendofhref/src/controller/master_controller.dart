part of legendofhref;

class MasterController {
  DivElement contentDiv, mainmenuDiv, hallofherosDiv, gameDiv, controlsDiv, overlayDiv;
  InputElement loginButton, registerButton, logoutButton, usernameField, passwordField, restartButton;
  InputElement useActionButton, attackActionButton, moveNorthButton, moveEastButton, moveSouthButton, moveWestButton;
  CheckboxInputElement debug;
  
  SpanElement username_display;
  
  Game game;
  GamekeyController gamekeyController = null;
  Map gamesettings;
  
  bool _isEditor = false;
  
  MasterController() {
    contentDiv = querySelector("#content");
    mainmenuDiv = contentDiv.querySelector("#mainmenu");
    hallofherosDiv = contentDiv.querySelector("#hallofheroes");
    gameDiv = contentDiv.querySelector("#game");
    controlsDiv = gameDiv.querySelector("#controls");
    overlayDiv = contentDiv.querySelector("#overlay");
    
    
    
    debug = contentDiv.querySelector("#debug");
    
    HttpRequest.getString(settingsURI).then(loadSettings);
    HttpRequest.getString(unitsURI).then(loadUnits);
    HttpRequest.getString(fieldtypesURI).then(loadFieldTypes);
    HttpRequest.getString(objectsURI).then(loadObjects);
    
    username_display = contentDiv.querySelector("#username_display");
    
    restartButton = querySelector("#take_revenge");
    restartButton.onClick.listen((e) {
      game.pc = null;
      game.loadMap("./level1.json");
      game.view.stopGameover();
      game.unpauseGame();
      });
    
    loginButton = contentDiv.querySelector("#login");
    registerButton = contentDiv.querySelector("#register");
    logoutButton = contentDiv.querySelector("#logout");
    usernameField = contentDiv.querySelector("#username");
    passwordField = contentDiv.querySelector("#password");
    loginButton
        ..onClick.listen(loginListener)
        ..onTouchEnd.listen(loginListener);
    registerButton
        ..onClick.listen(registerListener)
        ..onTouchEnd.listen(registerListener);
    logoutButton
        ..onClick.listen(logoutListener)
        ..onTouchEnd.listen(logoutListener);
    
    mainmenuDiv.querySelector("#start")
    ..onClick.listen(startListener)
    ..onTouchEnd.listen(startListener);
    mainmenuDiv.querySelector("#load")
    ..onClick.listen(loadListener)
    ..onTouchEnd.listen(loadListener);
    contentDiv.querySelector("#save")
    ..onClick.listen(saveListener)
    ..onTouchEnd.listen(saveListener);
    
    useActionButton = controlsDiv.querySelector("#use_action");
    attackActionButton = controlsDiv.querySelector("#attack_action");
    moveNorthButton = controlsDiv.querySelector("#move_north");
    moveEastButton = controlsDiv.querySelector("#move_east");
    moveSouthButton = controlsDiv.querySelector("#move_south");
    moveWestButton = controlsDiv.querySelector("#move_west");
  }
  
  bool get isEditor => _isEditor;
  
  void startListener(e) {
    if(gamesettings["debug"]??false) {
      debug.style.display="block";
      debug.checked = true;
      debug.disabled = false;
      print("Starting im Debug mode!");
      game = new Game(gamesettings, gamekeyController, checkDebug: () => debug.checked);
    } else {
      game = new Game(gamesettings, gamekeyController);
    }
    game.loadMap("./level1.json");
    GameView gv = new GameView(game, gameDiv, overlayDiv, mainmenuDiv);
    GameController gc = new GameController(game);
    window.onKeyDown.listen(gc.keyDownListener);
    attackActionButton.onTouchStart.listen(gc.attackTouchStartListener);
    attackActionButton.onTouchMove.listen(gc.attackTouchMoveListener);
    attackActionButton.onTouchEnd.listen(gc.attackTouchEndListener);
    attackActionButton.onClick.listen(gc.attackClickListener);
    useActionButton.onClick.listen(gc.useListener);
    useActionButton.onTouchEnd.listen(gc.useListener);
    moveNorthButton.onTouchEnd.listen(gc.moveNorthListener);
    moveNorthButton.onClick.listen(gc.moveNorthListener);
    moveEastButton.onTouchEnd.listen(gc.moveEastListener);
    moveEastButton.onClick.listen(gc.moveEastListener);
    moveSouthButton.onTouchEnd.listen(gc.moveSouthListener);
    moveSouthButton.onClick.listen(gc.moveSouthListener);
    moveWestButton.onTouchEnd.listen(gc.moveWestListener);
    moveWestButton.onClick.listen(gc.moveWestListener);
    game.togglePause();
  }
  
  void loadListener(e) {
    if(gamesettings["debug"]??false) {
      debug.hidden = false;;
      debug.checked = true;
      debug.disabled = false;
      print("Starting im Debug mode!");
      game = new Game(gamesettings, gamekeyController, checkDebug: () => debug.checked);
    } else {
      game = new Game(gamesettings, gamekeyController);
    }
    game.loadMapFromJson(JSON.decode(window.localStorage['save']));
    GameView gv = new GameView(game, gameDiv, overlayDiv, mainmenuDiv);
    GameController gc = new GameController(game);
    window.onKeyDown.listen(gc.keyDownListener);
    attackActionButton.onTouchStart.listen(gc.attackTouchStartListener);
    attackActionButton.onTouchMove.listen(gc.attackTouchMoveListener);
    attackActionButton.onTouchEnd.listen(gc.attackTouchEndListener);
    attackActionButton.onClick.listen(gc.attackClickListener);
    useActionButton.onClick.listen(gc.useListener);
    useActionButton.onTouchEnd.listen(gc.useListener);
    moveNorthButton.onTouchEnd.listen(gc.moveNorthListener);
    moveNorthButton.onClick.listen(gc.moveNorthListener);
    moveEastButton.onTouchEnd.listen(gc.moveEastListener);
    moveEastButton.onClick.listen(gc.moveEastListener);
    moveSouthButton.onTouchEnd.listen(gc.moveSouthListener);
    moveSouthButton.onClick.listen(gc.moveSouthListener);
    moveWestButton.onTouchEnd.listen(gc.moveWestListener);
    moveWestButton.onClick.listen(gc.moveWestListener);
    game.togglePause();
  }
  
  void saveListener(e) {
    String json = JSON.encode(game.map);
    window.localStorage['save'] = json;
    print(json);
  }
  
  Future loginListener(e) async {
    switch(await gamekeyController.signInUser(usernameField.value, passwordField.value)) {
      case 1:
        usernameField.hidden = true;
        passwordField.hidden = true;
        loginButton.hidden = true;
        registerButton.hidden = true;
        logoutButton.hidden = false;
        username_display.innerHtml = gamekeyController.user["name"];
        break;
      case 0:
        username_display.innerHtml = "Benutzer unbekannt oder Service offline!";
        break;
      case -1:
        username_display.innerHtml = "Passwort falsch oder Service offline!";
        break;
    }
  }
  
  Future registerListener(e) async {
    switch(await gamekeyController.registerUser(usernameField.value, passwordField.value)) {
      case 1:
        usernameField.hidden = true;
        passwordField.hidden = true;
        loginButton.hidden = true;
        registerButton.hidden = true;
        logoutButton.hidden = false;
        username_display.innerHtml = gamekeyController.user["name"];
        break;
      case 0:
        username_display.innerHtml = "Nutzer bereits registriert oder Service offline!";
        break;
      case -1:
        username_display.innerHtml = "Unbekannter Fehler!";
        break;
    }
  }
  
  Future logoutListener(e) async {
    usernameField.hidden = false;
    passwordField.hidden = false;
    loginButton.hidden = false;
    registerButton.hidden = false;
    logoutButton.hidden = true;
    username_display.innerHtml = "";
  }
  
  updateGamekeyStatus() {
    if(gamekeyController.gamekeyStatus) {
      gamekeyController._gamekey.getStates().then((list) => updateHallOfHeros(list));
    }
  }
  
  updateHallOfHeros(List<Map<String, Object>> list) {
    list.sort((m1, m2) => (m2["state"]["score"] as int).compareTo((m1["state"]["score"] as int)));
    print(list);
    List highscore = list.sublist(0, min(list.length, 5));
    print(highscore);
    hallofherosDiv.children.clear();
    for(Map<String, Object> scoreMap in highscore) {
      ParagraphElement p = new ParagraphElement();
      SpanElement username = new SpanElement(), killcount = new SpanElement(), score = new SpanElement();
      username.text = (scoreMap["username"] as String).replaceAll("<", "&lt;").replaceAll(">", "&gt;");
      killcount.text = ((scoreMap["state"] as Map)["killcount"] as int).toString().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
      score.text = ((scoreMap["state"] as Map)["score"] as int).toString().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
      p.appendText("The mighty hero \"");
      p.append(username);
      p.appendText("\" killed ");
      p.append(killcount);
      p.appendText(" foes! He hath earned ");
      p.append(score);
      p.appendText(" points!");
      hallofherosDiv.children.add(p);
    }
  }
  
  void loadSettings(String json) {
    Map settings = JSON.decode(json);
    gamekeyController = new GamekeyController(this, settings["gamekey"]);
    gamesettings = settings["gamesettings"];
  }
  
  void loadUnits(String json) {
    _Entity.loadUnitsFromJson(JSON.decode(json)["units"]);
  }
  
  void loadObjects(String json) {
    _Entity.loadObjectsFromJson(JSON.decode(json)["objects"]);
  }
  
  void loadFieldTypes(String json) {
    FieldType.loadFieldTypeFromJSON(JSON.decode(json)["fieldtypes"]);
  }
}