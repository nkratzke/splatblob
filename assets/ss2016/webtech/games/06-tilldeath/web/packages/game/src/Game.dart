part of runner;

enum Quality { LOW, MEDIUM, HIGH }


// Controller
class Game {

  /// Constant defining game size
  static const int viewport_x = 600;
  static const int viewport_y = 330;

  /// Constant of the relative path which stores the GameKey settings.
  static const gamekeySettings = 'gamekey.json';

  /// Defines the time between periodic GameKey availability checks
  static const gamekeyCheck = const Duration(seconds: 30);

  /// Stores model
  Model model;

  /// Stores controller
  View view;

  /// GameKey communicator used for storing highscores
  HighscoreGamekey gamekey;

  /// Timer used for periodic GameKey availability checks
  Timer gamekeyTrigger;

  bool limitFramerate;
  Quality quality;

  Storage localStorage;

  /// Creates Game instance
  /// Launches Main Menu
  Game() {

    // instantiate model and view
    model = new Model(viewport_x, viewport_y);
    view = new View(viewport_x, viewport_y);

    try {
      // Download gamekey settings. Display warning on problems.
      HttpRequest.getString(gamekeySettings).then((json) {
        final settings = JSON.decode(json);

        // Create gamekey client using connection parameters
        gamekey = new HighscoreGamekey(
            settings['host'],
            settings['port'],
            settings['id'],
            settings['secret']
        );

        gamekey.authenticate();

        // Check periodically if GameKey service is reachable. Display warning if not.
        gamekeyTrigger = new Timer.periodic(gamekeyCheck, (_) async {
          if (await gamekey.authenticate()) {
            view.statusMessage.text = '';
          } else {
            view.statusMessage.text = 'Highscores unavailable';
            print("Game: Game() Gamekey not connected");
          }
        });
      });
    } catch (error, stacktrace) {
      log("Game: Game() Error: '$error'");
      log("$stacktrace");
    }

    // get local storage
    localStorage =  window.localStorage;

    // get stored quality setting
    quality = localStorage["quality"] == null ?
    Quality.MEDIUM :
    Quality.values[int.parse(localStorage["quality"])];

    view.updateQuality(quality);

    limitFramerate = localStorage["limit"] == "on" ? true : false;
    view.updateLimiter(limitFramerate);

    log("Limit Framerate: $limitFramerate");

    // register keyboard input
    window.onKeyDown.listen((KeyboardEvent ev) async {
      switch (ev.keyCode) {
        case KeyCode.UP:    jump(); break;
        case KeyCode.SPACE: jump(); break;
        case KeyCode.ESC:   restartGame(); break;
      }
    });


    // register touchscreen input
    window.onTouchStart.listen((TouchEvent ev) async {
      jump();
    });

    window.onResize.listen((Event ev) {
      resizeGame();
    });

    // register click on restart button
    view.restartButtonStartNext.onClick.listen(
        (event) => startNextLevel());


    // register click on restart button
    view.restartButtonRestart.onClick.listen(
        (event) => restartGame());


    // register click on return to main menu button
    view.restartButtonMenu.onClick.listen((event) => mainMenu());

    // register click on start button in main menu
    view.menuButtonStart.onClick.listen((event) {

      String level = view.menuLevelSelect.selectedOptions[0].value;
      startGame(level);

    });

    view.menuButtonLimiter.onClick.listen((event) {
      if (limitFramerate) {
        limitFramerate = false;
        localStorage["limit"] = "off";
      } else {
        limitFramerate = true;
        localStorage["limit"] = "on";
      }
      view.updateLimiter(limitFramerate);
    });

    view.menuButtonQuality.onClick.listen((event) {
      switch (quality) {
        case Quality.HIGH:
          quality = Quality.LOW;
          localStorage["quality"] = Quality.LOW.index.toString();
          break;
        case Quality.MEDIUM:
          quality = Quality.HIGH;
          localStorage["quality"] = Quality.HIGH.index.toString();
          break;
        case Quality.LOW:
          quality = Quality.MEDIUM;
          localStorage["quality"] = Quality.MEDIUM.index.toString();
          break;

      }
      view.updateQuality(quality);
      resizeGame();
    });


    // register click on submit highscore button
    view.restartButtonSubmit.onClick.listen((event) => showLogin());

    // register click on login button
    view.restartLoginSubmit.onClick.listen((event) => submitScore());

    resizeGame();

  }

  /// Call resize on View
  void resizeGame() {
    int win_x = window.innerWidth;
    int win_y = window.innerHeight;

    view.rescale(win_x, win_y, quality);
  }

  /// Retrieves Level
  ///
  /// Returns the Level for [levelName] in JSON format
  Future<String> getLevel(String levelName) async {
    var level = "levels/" + levelName;

    return await HttpRequest.getString(level).asStream().join();
  }

  /// Jumps.
  ///
  /// Performs the jump action for the current game state
  void jump() {
      model.jump();
  }


  /// Alternate Update method called by update when limitFramrate is set
  void skipUpdate(int num) {
    view.update(model);
    window.animationFrame.then(update);
  }

  /// Updates the game
  ///
  /// Updates the model and view due to Timer [t] call
  void update(int num) {
    log("Game: update()");
    if (model.state == State.RUNNING) {
      log("Game: update() - running");

      model.update();
      if (limitFramerate) {
        model.update();
        window.animationFrame.then(skipUpdate);
      } else {
        view.update(model);
        window.animationFrame.then(update);
      }
    } else {
      setHighscores();

      view.update(model);
    }
  }

  /// Retrieves TOP 10 highscore from Gamekey service.
  ///
  /// Returns List of up to 10 highscore entries. { 'name': STRING, 'created': STRING, 'score': INT }
  /// Returns [] if gamekey service is not available.
  /// Returns [] if no highscores are present.
  Future<List<Map>> getHighscores() async {
    var scores = [];
    var levels;
    try {
      final states = await gamekey.getStates();

      levels = states.map((entry) => {
        'username' : "${entry['username']}",
        'date' : "${entry['created']}",
        'scores' : entry['state']['scores']
      });

      scores = levels.where((entry) => (entry["scores"]["${model.currentLevelHash}"] != null)).map((entry) => {
        'name' : "${entry['username']}",
        'date' : "${entry['date']}",
        'score' : entry["scores"]["${model.currentLevelHash}"]
      }).toList();

      scores.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
      scores.sort((a, b) => b['score'] - a['score']);
    } catch (error, stacktrace) {
      print("Game: getHighscores() Error: ${error}");
      print(stacktrace);
    }
    return scores.take(10);
  }

  /// Stores current score as highscore
  ///
  /// Stores the current score as a highscore for the user and password in the view.
  storeHighscore() async {
    String user = view.restartLoginUser.value;
    String pwd  = view.restartLoginPassword.value;

    if (user.length == 0) {
      window.alert('Invalid Username');
      return;
    }

    String id = await gamekey.getUserId(user);
    // create new user and store
    if (id == null) {
      final usr = await gamekey.registerUser(user, pwd);
      if (usr == null) {
        window.alert('Error creating user');
        print("Error creating user");
        return;
      }
      final stored = await gamekey.storeState(usr['id'], {
        "scores": {
          "${model.currentLevelHash}" : model.score
        },
        'version': '0.0.1'
      });
      if (stored) {
        view.hideHighscoreLogin();
        setHighscores();
        return;
      } else {
        view.statusMessage.text = "Error";
        return;
      }
    }

    // retrieve user and store
    if (id != null) {
      final user = await gamekey.getUser(id, pwd);

      if (user == null) {
        window.alert('Invalid User/Password');
        return;
      }

      final stored = await gamekey.storeState(user['id'], {
        "scores": {
          "${model.currentLevelHash}" : model.score
        },
        'version': '0.0.1'
      });
      if (stored) {
        view.hideHighscoreLogin();
        view.hideHighscoreSubmit();
        setHighscores();
        return;
      } else {
        view.statusMessage.text = "Error";
        return;
      }
    }
  }

  /// Causes score to be stored and returns the user to main menu
  submitScore() async {
    storeHighscore();

    model.highscores = await getHighscores();
    view.update(model); // update as soon as we have scores
  }

  /// Shows the login mask
  void showLogin() {
    view.showHighscoreLogin();
  }

  /// Updates the highscores for the current level
  setHighscores() async {

    model.highscores =  await getHighscores();
    view.update(model); // update as soon as we have scores

  }

  /// Restarts the current level
  ///
  /// Very hacky way to restart the game
  restartGame() async {
    if (model.state != State.MENU) {
      model.fail();
      update(0);

      // wait 10ms to make sure the Futures have completed...
      await new Future.delayed(const Duration(milliseconds: 10), () => "1");
      startGame(model.currentLevelName);
    }
  }

  /// Starts next level relative to current level
  ///
  /// Start nextLevel stored in curentLevel, shows alert if invalid
  void startNextLevel() {
    String next = model.currentLevel.nextLevel;
    if (next != null) {
      try {
        startGame(next);
      } catch (error, stacktrace) {
        window.alert("Invalid next level!");
      }
    } else {
      window.alert("No next level set!");
    }
  }

  /// Starts the game.
  ///
  /// Starts the game on the given [level]
  startGame(String level) async {

    await getLevel(level).then((levelJson) => model.setLevel(levelJson));
    model.currentLevelName = level;

    model.start();
    view.onStart(model);
    view.update(model);

    window.animationFrame.then(update);
  }

  /// Opens the main menu
  ///
  /// Opens the main menu and updates the list of available levels
  mainMenu() async {

    var levels = "levels/levels.json";

    var request = await HttpRequest.getString(levels).asStream().join();

    model.setLevelList(request);
    model.mainMenu();

    view.update(model);


  }
}