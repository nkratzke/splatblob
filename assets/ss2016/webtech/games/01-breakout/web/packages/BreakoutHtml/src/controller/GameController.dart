part of breakoutDart;

const gamekeyfile = 'gamekey.json';
const gameSecret = '1d69428cdd6c224d';
const gamekeyCheck = const Duration(seconds: 5);
//number of the level to start with
const startLevel = 1;
const panelSpeed = const Duration(milliseconds: 25);

class GameController {
  //The Connecton to the Game
  BreakoutGame game;
  //The Connection to the View
  View view;
  //The Connection to the levelLoader
  LevelLoaderJSON levelLoader;

  //The speed of the Ball higher => faster
  int ballspeed;
  //The gameID
  String gameID;
  //The score for the hole game
  int score = 0;
  //boolean if you hold the touch input
  bool moveright;
  //boolean if you hold the touch input
  bool moveleft;

  //the time between a Check if the gamekey is available
  Duration gamekeyCheck;
  //the host of the gamekéy
  String gamekeyHost;
  //the port of the gamekey
  int gamekeyPort;

  //the time trigger for the ball
  Timer ballTrigger;
  //the time trigger for the touch input right
  Timer panelrightTrigger;
  //the time trigger for the touch input left
  Timer panelleftTrigger;
  //the time trigger for the gamekey check
  Timer gamekeyTrigger;

  //The list of al Listeners
  List listenerList = new List();

  //The scoreList for all scores
  List<Map>Score_List = new List<Map>();
  //the gamekey connection
  var gamekey = new GameKeyClient('undefined', 8080, 'undefined', 'undefined');


  GameController() {
    this.view = new View(this);
    startGamekey();
    startGame();
  }


  /**
   * Start's the Gamekey Service
   * with the  Parameter's from the gamkey.json file
   * print's Error if failed
   */
  startGamekey() {
    try {
      HttpRequest.getString(gamekeyfile).then((json) {
        final settings = JSON.decode(json);

        //GameKey connection parameters
        this.gamekey = new GameKeyClient(
            settings['host'],
            settings['port'],
            settings['gameid'],
            gameSecret
        );

        this.gamekey.authenticate().then((bool isOnline)
        {
          if (isOnline)
          {
            updateStatus(true);
            return true;
          }
          else
          {
            updateStatus(false);
            return false;
          }
        });
      });

      this.gamekeyTrigger =
      new Timer.periodic(new Duration(seconds: 5), (_) async {
        if (await this.gamekey.authenticate()) {
          updateStatus(true);
          return true;
        } else {
          updateStatus(false);
          return false;
        }
      });
    } catch (error, stacktrace) {
      print("Error in startGamekey(): '$error'");
      print("$stacktrace");
    }
  }


  /**
   * Start's the Game
   * load's the first Level
   */
  startGame() async
  {
    this.levelLoader = new LevelLoaderJSON('levels/','Level',startLevel);
    view.toggleoverlay(false);
    await initNewLevel();
  }


  /**
   *  load's the next Level
   */
  initNewLevel() async
  {
    bool hasNextLevel = await levelLoader.loadNextLevel();
    game = null;
    if (hasNextLevel) {
      game = new BreakoutGame(
          this,
          levelLoader.getfieldSize()[0],
          levelLoader.getfieldSize()[1],
          false,
          true,
          false,
          levelLoader.getLifes(),
          score,
          levelLoader.getLevelNumber()
      );
      view.addNewModelToView(game);
      view.generateField(game);
      game.add_gameParts_JSON("ball", levelLoader.getObjectsOfType("ball"));
      game.add_gameParts_JSON("panelPart", levelLoader.getObjectsOfType("panelPart"));
      game.add_gameParts_JSON("stone", levelLoader.getObjectsOfType("stone"));
      ballspeed = levelLoader.getBallspeed();
      view.update();
      initStartListener(false);
      view.gamePaused(true);
      updateLifes();
      updateScore();
      updateLevel();
    }
    else
    {
      gameOver(true);
    }
  }

  /**
   * initialize the Listener for the space Key
   * panelMoveActive says if the panel is allowed to move
   *
   * sets the gameparameters on game running mode
   *
   */
  void initStartListener(bool panelMoveActiv)
  {
    listenerList.add(window.onKeyDown.listen((KeyboardEvent ev)
    {
      if(ev.keyCode == KeyCode.SPACE  && !game.running)
      {
        if(!panelMoveActiv)
        {
          initListener();
        }
        initTimer();
        game.stopped = false;
        game.running = true;
        view.gamePaused(false);
      }
      else
      {
        if(ev.keyCode == KeyCode.SPACE  && game.running)
        {
          stopTimer();
          cancelAllListeners();
          initStartListener(false);
          game.stopped = true;
          game.running = false;
          view.gamePaused(true);
        }
      }
    }));

    listenerList.add(querySelector("#down").onTouchStart.listen((event){
      if(game.stopped){
        initListener();
        initTimer();
        game.stopped = false;
        game.running = true;
        view.gamePaused(false);
      }
      else
      {
        stopTimer();
        cancelAllListeners();
        initStartListener(false);
        game.stopped = true;
        game.running = false;
        view.gamePaused(true);
      }
    }));
  }


  /**
   * Initialize the panel Listener
   */
  initListener() async
  {
    listenerList.add(window.onKeyDown.listen((KeyboardEvent ev)
    {
      if(ev.keyCode == KeyCode.LEFT)
      {
        movePanelLeft();
      }
      if(ev.keyCode == KeyCode.RIGHT)
      {
        movePanelRight();
      }
    }));

    listenerList.add(querySelector("#right").onTouchStart.listen((event) {
      //Starte Bewegung nach rechts
      moveright = true;
    }));
    listenerList.add(querySelector("#right").onTouchEnd.listen((event) {
      //Beende Bewegung nach rechts
      moveright = false;
    }));
    listenerList.add(querySelector("#left").onTouchStart.listen((event) {
      //Starte Bewegung nach rechts
      moveleft = true;
    }));
    listenerList.add(querySelector("#left").onTouchEnd.listen((event) {
      //Beende Bewegung nach rechts
      moveleft = false;
    }));
  }


  /**
   * initilize the timer vor the Ball and the Panel touch input
   */
  void initTimer() {
    ballTrigger =
    new Timer.periodic(new Duration(milliseconds: ballspeed), moveBall);
    panelrightTrigger =
    new Timer.periodic(panelSpeed, movePanelRightWithTimer);
    panelleftTrigger =
    new Timer.periodic(panelSpeed, movePanelLeftWithTimer);
  }


  /**
   * move panel left one step
   */
  movePanelLeft() async
  {
    await game.movePanel(-1, 0);
    game.load_field_from_Gamepart_List();
    view.update();
  }

  /**
   * move Panel right one step
   */
  movePanelRight() async
  {
    await game.movePanel(1, 0);
    game.load_field_from_Gamepart_List();
    view.update();
  }

  /**
   * move Panel Left while true (to hold the panel)
   */
  movePanelLeftWithTimer(Timer t) async
  {
    if (moveleft) {
      await game.movePanel(-1, 0);
      game.load_field_from_Gamepart_List();
      view.update();
    }
  }

  /**
   * move Panel Right while true (to hold the panel)
   */
  movePanelRightWithTimer(Timer t) async
  {
    if (moveright) {
      await game.movePanel(1, 0);
      game.load_field_from_Gamepart_List();
      view.update();
    }
  }


  /**
   * Move Ball every Trigger Moment
   */
  moveBall(Timer t) async
  {
    await game.moveBall();
    game.load_field_from_Gamepart_List();
    view.update();
  }

  /**
   * strop the Triggers
   */
  void stopTimer()
  {
    ballTrigger.cancel();
    panelrightTrigger.cancel();
    panelleftTrigger.cancel();
  }

  /**
   * stops the timer and pauses the game and whait for the StartListener
   */
  void pauseTimer()
  {
    stopTimer();
    cancelAllListeners();
    initListener();
    initStartListener(true);
    view.gamePaused(true);
  }

  /**
   * cancel all Listener in the ListenerList
   */
  cancelAllListeners()
  {
    for(var listener in listenerList)
    {
      listener.cancel();
    }
    listenerList.clear();
  }

  /**
   * creates the Higscore and shows it on the Overlay
   * schows the game status win (win/loose)
   */
   gameOver(bool win) async
  {
    stopTimer();
    cancelAllListeners();
    view.update();
    view.toggleoverlay(true);
    Score_List = await getHighscores();
    view.showHighscore(Score_List, win,true);

    initSaveListener(win);
  }

  /**
   * Initlize Listener on the Save Button
   * checks the Username and Password
   * trys to register User
   * if User exists you get an error
   */
  initSaveListener(win)
  {
    document.querySelector('#save')?.onClick?.listen((_) async {
      String user = view.user;
      String pwd  = view.password;

      if (user?.isEmpty) {
        view.warn("Please insert Username !");
        return;
      }

      if(pwd?.isEmpty){
        view.warn("Please insert a Password !");
        return;
      }

      String id = await gamekey.getUserId(user);

      if (id == null)
      {
        final usr = await gamekey.registerUser(user, pwd);
        if (usr == null) {
          view.warn(
              "Could not register user $user. "
                  "User might already exist or gamekey service not available."
          );
          return;
        }
      }

      id = await gamekey.getUserId(user);
      // User exists.
      if (id != null) {
        final user = await gamekey.getUser(id, pwd);
        if (user == null) {
          view.warn("User exists !");
          return;
        };
        final stored = await gamekey.storeState(user['id'], {
          'version': '0.0.2',
          'points': game.score
        });
        if (stored) {
          Score_List = await getHighscores();
          view.showHighscore(Score_List, win,false);
          return;
        }
        else {
          view.FailedSave();
          return;
        }
      }
    });
  }

  updateLifes() => view.updateLifes();


  updateScore() => view.updateScore();


  updateLevel() => view.updateLevel();


  updateStatus(bool hasConnection) => view.updateStatus(hasConnection);

  /**
   * load new Level if this Level is done
   */
  levelDone() async
  {
    stopTimer();
    cancelAllListeners();
    score = game.score;
    await initNewLevel();
  }

  /**
   * returns a future List of the Highscore
   */
  Future<List<Map>> getHighscores() async {
    var scoreslist = [];
    try {
      final states = await gamekey.getStates();
      scoreslist = states.map((entry) => {
        'name' : "${entry['username']}",
        'score' : entry['state']['points']
      }).toList();
      scoreslist.sort((a, b) => b['score'] - a['score']);
    } catch (error, stacktrace) {
      print(stacktrace);
    }
    return scoreslist.take(5);
  }
}