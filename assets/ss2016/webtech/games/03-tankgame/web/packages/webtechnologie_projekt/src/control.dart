// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

part of tankgame;

const gamekeyCheck = const Duration(seconds: 5);

const updateStats = const Duration(milliseconds: 500);

// const gameSecret = '908a0338bfcd8060'; // localhost Referenzimplementierung
const gameSecret = '13c0fc7472b3cc0b'; // online Referenzimplementierung

const gamekeySettings = 'gamekey.json';

const levelSettings = 'level.json';

const parameter = 'parameter.json';

List<Level> levels = [];

class TankGameController {
  final TankView view = new TankView();

  final TankGame game = new TankGame(gamesize);

  // Bewegungsgeschwindigkeit der Geschosse
  Duration bulletSpeed = new Duration();

  Duration lenkraketenSpeed = new Duration();

  // Bewegungsgeschwindigkeit der Gegner
  Duration enemySpeed = new Duration();

  // Zeitabstände in der neue Gegner erstellt werden
  Duration addNewEnemySpeed = new Duration();

  // Zeitabstand der verstreichen muss damit erneut geschossen werden kann.
  Duration shoottimer = new Duration();

  // Bewegungsgeschwindigkeit des Spielers
  Duration playerSpeed = new Duration();

  int playerLeben;

  var gamekey;

  GameObject _player;

  Timer bulletTrigger;

  Timer lenkraketenTrigger;

  Timer enemyTrigger;

  Timer gamekeyTrigger;

  Timer addEnemyTrigger;

  Timer update;

  TankGameController() {
    try {
      HttpRequest.getString(parameter).then((json) {
        Map parsed = JSON.decode(json);

        bulletSpeed = new Duration(milliseconds: parsed['bulletSpeed']);
        lenkraketenSpeed = new Duration(milliseconds: parsed['lenkraketenSpeed']);
        enemySpeed = new Duration(milliseconds: parsed['enemySpeed']);
        addNewEnemySpeed = new Duration(seconds: parsed['addNewEnemySpeed']);
        shoottimer = new Duration(seconds: parsed['shootTimer']);
        playerSpeed = new Duration(milliseconds: parsed['playerSpeed']);
        playerLeben = parsed['playerLifes'];
        // player wird hier erstellt, damit sichergestellt ist, dass alle parameter geladen wurden.
      }).then((_) =>  _player = game.generatePlayer(playerLeben, shoottimer, playerSpeed));
    } catch (error, stacktrace) {
      print("TankeGameController() caused following error: '$error'");
      print("$stacktrace");
      view.warningoverlay.innerHtml =
      "Parameter konnten nicht geladen werden. Versuche es bitte Später erneut.";
    }
    try {
      HttpRequest.getString(levelSettings).then((json) {
        Map parsed = JSON.decode(json);

        parsed['levels'].forEach((levelnummer, inhalt) {
          Level temp = new Level();
          temp.levelnumber = int.parse(levelnummer);
          temp.anzahlgegner = inhalt['anzahlGegner'];
          temp.concurrentlyEnemysOnField = inhalt['concurrentlyEnemysOnField'];
          temp.enemyLeben = inhalt['enemyLeben'];
          temp.startpositionPlayer = new Position(inhalt['startpositionPlayer']['row'], inhalt['startpositionPlayer']['col']);
          temp.basis = new Position(inhalt['basis']['row'], inhalt['basis']['col']);
          inhalt['wallPositionen'].forEach((key){
            temp.wallpositions.add(new Position(key['row'], key['col']));
          });
          levels.add(temp);
        });
      });
    } catch (error, stacktrace) {
      print("TankeGameController() caused following error: '$error'");
      print("$stacktrace");
      view.warningoverlay.innerHtml =
      "Level konnten nicht geladen werden. Versuche es bitte Später erneut.";
    }
    try {
      HttpRequest.getString(gamekeySettings).then((json) {
        final settings = JSON.decode(json);
        this.gamekey = new GameKey(
            settings['host'], settings['port'], settings['gameid'], gameSecret);

        this.gamekeyTrigger = new Timer.periodic(gamekeyCheck, (_) async {
          if (await this.gamekey.authenticate()) {
            view.warningoverlay.innerHtml = "";
          } else {
            view.warningoverlay.innerHtml =
            "Could not connect to gamekey service. "
                "Highscore will not working properly.";
          }
        });
      });
    } catch (error, stacktrace) {
      print("TankeGameController() caused following error: '$error'");
      print("$stacktrace");
      view.warningoverlay.innerHtml = "Could not get gamekey settings. "
          "Highscore will not working properly.";
    }

    view.generateField(game);

    view.startbutton.onClick.listen((_) {
      game.gameObjectsMap.clear();
      game.gameObjectsMap = _loadLevel(game._aktuelleLevelNummer);
      if (bulletTrigger != null) bulletTrigger.cancel();
      if (enemyTrigger != null) enemyTrigger.cancel();
      if (addEnemyTrigger != null) addEnemyTrigger.cancel();
      if (update != null) update.cancel();
      if (lenkraketenTrigger != null) lenkraketenTrigger.cancel();
      lenkraketenTrigger = new Timer.periodic(lenkraketenSpeed, (_) => _moveLenkrakete());
      bulletTrigger = new Timer.periodic(bulletSpeed, (_) => _moveBullet());
      enemyTrigger = new Timer.periodic(enemySpeed, (_) => _moveEnemy());
      addEnemyTrigger =
      new Timer.periodic(addNewEnemySpeed, (_) => _addEnemyTank());
      update = new Timer.periodic(updateStats, (_) => view.updateStats(game, _player));
      game.start();
      view.stats.style.display = "block";
      view.updateStats(game, _player);
      view.startbutton.style.display = "none";
      view.update(game, _player);
    });


    view._nextLevelButton.onClick.listen((_) {
      _startNextLevel();
    });

    window.onKeyDown.listen((KeyboardEvent ev) {

      if(ev.keyCode == KeyCode.P) {
        if(game._gamestate == #changeLevel);
        else if(game._gamestate == #running) {
          game.pause();
          view.overlay.innerHtml = "PAUSE";
        }
        else if(game._gamestate == #stopped) {
          // tue nichts damit über p das spiel nicht gestartet wird.
        } else {
          game.start();
          view.overlay.innerHtml = "";
        }
      }

      if (game._gamestate == #running) {
        if (game.gameover) {
          _gameOver();
          return;
        }
        switch (ev.keyCode) {
          case KeyCode.L:
            _player.lenkrakete();
            view.update(game, _player);
            break;
          case KeyCode.RIGHT:
            _player.moveRight();

            view.update(game, _player);
            break;
          case KeyCode.LEFT:
            _player.moveLeft();

            view.update(game, _player);
            break;
          case KeyCode.UP:
            _player.moveUp();

            view.update(game, _player);
            break;
          case KeyCode.DOWN:
            _player.moveDown();

            view.update(game, _player);
            break;
          case KeyCode.SPACE:
            _player.shoot();
            view.update(game, _player);
            break;
        }

      }
    });

    window.onTouchStart.listen((TouchEvent ev) {

      if(game._gamestate == #running) {
        HtmlElement test = ev.target;
        if(test.id == 'buttonUp') {
          _player.moveUp();
          view.update(game, _player);
        }
        if(test.id == 'buttonDown') {
          _player.moveDown();
          view.update(game, _player);
        }
        if(test.id == 'buttonLeft') {
          _player.moveLeft();
          view.update(game, _player);

        }
        if(test.id == 'buttonRight') {
          _player.moveRight();
          view.update(game, _player);

        }
        if(test.id == 'buttonShoot') {
          _player.shoot();
          view.update(game, _player);

        }
        if(test.id == 'buttonLenkrakete') {
          _player.lenkrakete();
          view.update(game, _player);

        }
      }

    });
  }

  void _moveLenkrakete() {
    if(game._gamestate == #running) {
      if (game.gameover) {
        _gameOver();
        return;
      }

      if(game.levelGeschafft) _showNextLevelButton();
      game.moveLenkrakete();
      view.update(game, _player);
    }
  }

  void _moveBullet() {
    if(game._gamestate == #running) {
      if (game.gameover) {
        _gameOver();
        return;
      }

      if(game.levelGeschafft) _showNextLevelButton();
      game.moveBullets();
      view.update(game, _player);
    }

  }

  /**
   * Retrieves TOP 10 highscore from Gamekey service.
   * - Returns List of max. 10 highscore entries. { 'name': STRING, 'score': INT }
   * - Returns [] if gamekey service is not available.
   * - Returns [] if no highscores are present.
   */
  Future<List<Map>> getHighscores() async {
    var scores = [];
    try {
      final states = await gamekey.getStates();
      scores = states
          .map((entry) => {
        'name': "${entry['username']}",
        'score': entry['state']['points']
      })
          .toList();
      scores.sort((a, b) => b['score'] - a['score']);
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
    }
    return scores.take(10);
  }

  dynamic _gameOver() async {
    game._gamestate = #gameover;
    enemyTrigger.cancel();
    bulletTrigger.cancel();
    addEnemyTrigger.cancel();
    update.cancel();
    game.gameObjectsMap.clear();
    view.nextLevelButton.style.display = "none";
    view.update(game, _player);

    // Show TOP 10 Highscore
    final highscore = await getHighscores();
    view.showHighscore(game, highscore);

    document
        .querySelector('#save')
        ?.onClick
        ?.listen((_) async {
      String user = view.user;
      String pwd = view.password;

      if (user.isEmpty) {
        view.warn("Please provide user name.");
        return;
      }

      String id = await gamekey.getUserId(user);
      if (id == null) {
        view.warn("User $user not found. Shall we create it?"
            "<button id='create'>Create</button>"
            "<button id='cancel' class='discard'>Cancel</button>");
        document.querySelector('#cancel')?.onClick?.listen((_) => _newGame());
        document
            .querySelector('#create')
            ?.onClick
            ?.listen((_) async {
          final usr = await gamekey.registerUser(user, pwd);
          if (usr == null) {
            view.warn("Could not register user $user. "
                "User might already exist or gamekey service not available.");
            return;
          }
          view.warn("");
          final stored = await gamekey.storeState(usr['id'], {
            'version': '0.0.2',
            'points': game.highscore //game.miceCounter
          });
          if (stored) {
            print("test");
            // view.warn("${game.miceCounter} mice stored for $user");
            view.closeForm();
            final newHighscore = await getHighscores();
            view.showOnlyHighscore(game, newHighscore);
            document.querySelector('#close').onClick.listen((_) {
              _newGame();
            });
            // _newGame();
          } else {
            view.warn("Could not save highscore. Retry?");
            return;
          }
        });
      }

      // User exists.
      if (id != null) {
        final user = await gamekey.getUser(id, pwd);
        if (user == null) {
          view.warn("Wrong access credentials.");
          return;
        }
        ;
        final stored = await gamekey.storeState(user['id'], {
          'version': '0.0.2',
          'points': game.highscore //game.miceCounter
        });
        if (stored) {

          view.closeForm();

          final newHighscore = await getHighscores();
          view.showOnlyHighscore(game, newHighscore);
          document.querySelector('#close').onClick.listen((_) {
            _newGame();
          });
        } else {
          view.warn("Could not save highscore. Retry?");
          return;
        }
      }
    });

    // Handle cancel button
    document.querySelector('#close').onClick.listen((_) {
      _newGame();
    });
  }



  void _showNextLevelButton() {
    game._gamestate = #changeLevel;
    update.cancel();
    addEnemyTrigger.cancel();
    bulletTrigger.cancel();
    enemyTrigger.cancel();
    view.nextLevelButton.style.display = "block";
    view.updateStats(game, _player);
    }

  void _startNextLevel() {
    if (levels.length > game._aktuelleLevelNummer) {
      game._bereitsErstellteGegner = 0;
      game._anzahlAktiverGegner = 0;
      _player._lenkraketenMunition += 1;
      game.zerstoerteEnemys.clear();
      game.gameObjectsMap = _loadLevel(game._aktuelleLevelNummer + 1);
      addEnemyTrigger = new Timer.periodic(addNewEnemySpeed, (_) => _addEnemyTank());
      bulletTrigger = new Timer.periodic(bulletSpeed, (_) => _moveBullet());
      enemyTrigger = new Timer.periodic(enemySpeed, (_) => _moveEnemy());
      update = new Timer.periodic(updateStats, (_) => view.updateStats(game, _player));
      view.nextLevelButton.style.display = "none";
      game.start();
      view.update(game, _player);

    } else {
      _gameOver();
    }

  }




  void _moveEnemy() {
    if(game._gamestate == #running) {
      if (game.gameover) {
        _gameOver();
        return;
      }

      game.moveEnemys();
      view.update(game, _player);
    }

  }

  HashMap<Position, GameObject> _loadLevel(int levelnumber) {
    game.gameObjectsMap.clear();
    HashMap<Position, GameObject> nextLevelMap =
    new HashMap<Position, GameObject>();

    Level nextLevel =
    levels.singleWhere((lev) => lev.levelnumber == levelnumber);

    game.aktuellesLevelObjekt = nextLevel;
    game._aktuelleLevelNummer = levelnumber;

    nextLevel.wallpositions.forEach((wandposition) {
      var posis = game.generatePositions(wandposition.row, wandposition.col);
      var wall = new GameObject.Wall(wandposition, posis, 3, game);
      posis.forEach((pos) {
        nextLevelMap[pos] = wall;
      });
    });

    var baseposis = game.generatePositions(nextLevel.basis.row, nextLevel.basis.col);
    var base = new GameObject.Base(nextLevel.basis, baseposis, 1, game);

    baseposis.forEach((posi) {
      nextLevelMap[posi] = base;
    });

    game._base = base;

    _player.mittelpunkt = game.gamePositions.singleWhere((posi) =>
    posi.row == nextLevel.startpositionPlayer.row &&
        posi.col == nextLevel.startpositionPlayer.col);
    _player.coords = _player.game.generatePositions(
        _player.mittelpunkt.row, _player.mittelpunkt.col);

    _player.coords.forEach((pos) {
      nextLevelMap[pos] = _player;
    });

    return nextLevelMap;
  }

  void _addEnemyTank() {
    if(game._gamestate == #running) {
      game.addEnemyTank(shoottimer, enemySpeed);
    }

  }

  void _newGame() {
    view.closeForm();
    game.resetGame();
    _player = game.generatePlayer(playerLeben, shoottimer, playerSpeed);
    view.nextLevelButton.style.display = "none";
    view.startbutton.style.display = "block";
    view.stats.style.display = "none";
    view.update(game, _player);

  }



}
