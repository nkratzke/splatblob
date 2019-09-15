part of brickGame;

///
/// How often it will check for a Gamekey connection
///
const gameKeyCheck = const Duration(seconds: 3);

///
/// Responsible for controlling timers and user input
/// [Ball] will move when the periodic timer triggers the move method
/// [Player] is controlled via listeners.
///
class GameController {
  ///
  /// Creates a new game
  ///
  Game game = new Game();

  ///
  /// Creates the view
  ///
  final View view = new View();

  ///
  /// Initializes the gamekey connection
  ///
  GameKey gameKey = new GameKey("212.201.22.169", 50001);

  ///
  /// Triggers the move method of [Ball]
  ///
  Timer _ballTrigger;

  ///
  /// For checking if gamekey is available
  ///
  Timer _gameKeyTrigger;

  ///
  /// Decides how often the ball will move (configured for milliseconds, default 100ms)
  ///
  Duration ballSpeed;

  ///
  /// Contains all methods required to control timers and user input
  /// The controller is deeply connected with the [Game] and [View]
  ///
  GameController() {
    readSettings();

    try {
      _gameKeyTrigger = new Timer.periodic(gameKeyCheck, (_) async {
        if (await this.gameKey.authenticate()) {
          view.warningoverlay.innerHtml = "";
        } else {
          view.warningoverlay.innerHtml =
          "Could not connect to gamekey service. "
              "Highscore will not work properly.";
        }
      });
    }catch (error, stacktrace) {
      print("GameController() caused following error: '$error'");
      print("$stacktrace");
      view.warningoverlay.innerHtml =
      "Could not get gamekey settings. "
          "Highscore will not work properly.";
    }

    ///
    /// Start button to start a new game
    ///
    view.startButton.onClick.listen((_) {
      newGame();
    });

    ///
    /// Button to start the level
    ///
    view.startGameButton.onClick.listen((_) {
      view.menuView.style.display = "none";
      view.gameView.style.display = "block";
    });

    ///
    /// Button to go back to menu
    ///
    view.backMenuButton.onClick.listen((_) {
      view.menuView.style.display = "block";
      view.gameView.style.display = "none";
    });

    ///
    /// Button to show the rules and controls of the game
    ///
    view.helpButton.onClick.listen((_) {
      view.menuView.style.display = "none";
      view.help.style.display = "block";
    });

    ///
    /// Button to go back to start menu
    ///
    view.cancelButton.onClick.listen((_) {
      view.menuView.style.display = "block";
      view.help.style.display = "none";
    });

    ///
    /// Button for mobile users to move the player to the right
    ///
    view.rightButton.onClick.listen((_) {
      if (game.gameOver()) return;
      game.movePlayer(Direction.right, this);
    });

    ///
    /// Button for mobile users to move the player to the left
    ///
    view.leftButton.onClick.listen((_) {
      if (game.gameOver()) return;
      game.movePlayer(Direction.left, this);
    });

    ///
    /// Listener who reacts when the player presses the left or right arrow key
    ///
    window.onKeyUp.listen((event) {
      if (game.gameOver()) return;
      if (event.keyCode == KeyCode.LEFT) {
        game.movePlayer(Direction.left, this);
      } else if (event.keyCode == KeyCode.RIGHT) {
        game.movePlayer(Direction.right, this);
      }
    });

    ///
    /// Button to show highscore
    ///
    view.highscore.onClick.listen((_){
      gameKey.getStates().then((contetn){
        view.showHighscore(game,contetn);
        // Handle cancel button
        document.querySelector('#close')?.onClick?.listen((_){
          view.closeForm();
          document.querySelector('#title').innerHtml='Brick Break';
        });
      });
    });

    view.generateField(game);
  }

  ///
  /// Resets the game
  ///
  void resetGame(){
    game = new Game();
  }

  ///
  /// Creates a new game
  ///
  void newGame(){
    _ballTrigger=new Timer.periodic(ballSpeed, (_)=> game.moveBall(this));
    view.closeForm();
    view.generateField(game);
  }

  ///
  /// Updates the view if something happened (e.g. a brick was destroyed)
  ///
  void updateView(List<List<GameObject>> gameField) {
    game.gameFields[game.countLevel].gameField=gameField;
    if((game.gameOver()||game.gameEnds())){
      _gameOver();
    }else{
      view.update(game);
    }
  }

  ///
  ///Handles Game Over.
  ///
  dynamic _gameOver() async {
    _ballTrigger.cancel();
    view.update(game);

    // Show TOP 10 Highscore
    final List<Map> highscore = await gameKey.getStates();
    view.showHighscore(game, highscore);

    // Handle save button
    document.querySelector('#save')?.onClick?.listen((_) async {

      String user = view.user;
      String pwd  = view.password;
      if (user?.isEmpty) { view.highscoreMessage("Please provide user name."); return; }

      String id = await gameKey.getUserId(user);
      if (id == null) {
        view.highscoreMessage(
            "User $user not found. Shall we create it?"
                "<button id='create'>Create</button>"
                "<button id='cancel' class='discard'>Cancel</button>"
        );
        document.querySelector('#cancel')?.onClick?.listen((_) => newGame());
        document.querySelector('#create')?.onClick?.listen((_) async {
          final usr = await gameKey.registerUser(user, pwd);
          if (usr == null) {
            view.highscoreMessage(
                "Could not register user $user. "
                    "User might already exist or gamekey service not available."
            );
            return;
          }
          view.highscoreMessage("");
          final stored = await gameKey.storeState(usr['id'], {
            'version': '0.0.2',
            'points': game.points
          });
          if (stored) {
            view.highscoreMessage("${game.points} points stored for $user");
            newGame();
            return;
          } else {
            view.highscoreMessage("Could not save highscore. Retry?");
            return;
          }
        });
      }

      // User exists.
      if (id != null) {
        final user = await gameKey.getUser(id, pwd);
        if (user == null) { view.highscoreMessage("Wrong access credentials."); return; };
        final stored = await gameKey.storeState(user['id'], {
          'version': '0.0.2',
          'points': game.points
        });
        if (stored) {
          view.highscoreMessage("${game.points} points stored for ${user['name']}");
          view.closeForm();
          resetGame();
          newGame();
          return;
        } else {
          view.highscoreMessage("Could not save highscore. Retry?");
          return;
        }
      }
    });

    // Handle cancel button
    document.querySelector('#close')?.onClick?.listen((_){
      resetGame();
      view.closeForm();
    });
    document.querySelector('#title').innerHtml='';
  }
  ///
  /// Will read the JSON file to get the ball speed
  ///
  Future<bool> readSettings() async {
    String json = await HttpRequest.getString('controller_settings.json');
    Map set = JSON.decode(json);
    int speed = int.parse(set['ballspeed'].toString());
    ballSpeed = new Duration(milliseconds: speed);
  }
}
