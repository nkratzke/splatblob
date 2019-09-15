import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'game.dart';
import 'gamekey.dart';
import 'generator.dart';
import 'view.dart';

/**
 * The speed of the game
 */
const gameSpeed = const Duration(milliseconds: 40);

/**
 * The time interval, of how often the game will check for gamekey-service availability.
 */
const gamekeyCheck = const Duration(seconds: 30);

/**
 * The gamekey-service-secret
 */
const gameSecret = "ad596ae475d0183a";

/**
 * The name of the file, where the gamekey login information is stored
 */
const gamekeySettings = "gamekey.json";

/**
 * The warning message that is being displayed, when the game failed to connect to the gamekey-service.
 */
const gamekeyWarningMessage = "Could not connect to GameKey-Service!<br>Highscore will not work properly!";

class Controller {
  Game game;
  View view;
  Timer gameTrigger;
  Timer gameKeyCheck;

  GameKey gamekey = new GameKey("undefined", 0, "undefined", "undefined");

  /**
   * Reads all available levels and tries to log into the gamekey-service and starts a timer
   * to check regularily, if the gamekey-service is available.
   */
  Controller() {
    Generator.readLevelsFromJson();
    view = new View(this);

    try {
      HttpRequest.getString(gamekeySettings).then((json) {
        final settings = JSON.decode(json);
        this.gamekey = new GameKey(settings["host"], settings["port"], settings["gameid"], gameSecret);

        this.gamekey.authenticate();

        this.gameKeyCheck = new Timer.periodic(
            gamekeyCheck, (_) async {
              if (await this.gamekey.authenticate()) {
                this.view.warningoverlay.innerHtml = "";
              } else {
                this.view.warningoverlay.innerHtml = gamekeyWarningMessage;
              }
            }
        );
      });
    } catch(error, stacktrace) {
      print("Error: $error");
      print("$stacktrace");

      this.view.warningoverlay.innerHtml = gamekeyWarningMessage;
    }

    this.view.generateField();
    this.view.startButton.onClick.listen((_) {
      this.view.clearScores();
      this.game = new Game();
      this.game.gameOver = false;
      this.game.running = true;

      if (this.gameTrigger != null) this.gameTrigger.cancel();
      this.gameTrigger = new Timer.periodic(gameSpeed, (_) => loop());

      this.view.update();
    });

    // UP-Key support.
    window.onKeyDown.listen((KeyboardEvent ke) {
      if (!this.game?.running) return;
      switch (ke.keyCode) {
        case KeyCode.UP:
          this.game.playerJump();
          break;
      }
    });

    // Touchscreen support.
    this.view.gameField.onClick.listen((_) {
      if (!this.game?.running) return;
      this.game.playerJump();
    });

    // DOWN-Key support. (Powerup)
    window.onKeyDown.listen((KeyboardEvent ke) {
      if (!this.game?.running) return;
      switch (ke.keyCode) {
        case KeyCode.DOWN:
          this.game.player.usePowerup();
          break;
      }
    });

    // Touchscreen support. (Powerup)
    this.view.powerupButton.onClick.listen((_) {
      if (!this.game?.running) return;
      this.game.player.usePowerup();
    });
  }

  /**
   * Causes one game loop. Checks if the game is over and updates the view.
   */
  void loop() {
    this.game.loop();

    if (this.game.gameOver) {
      this.gameOver();
    }

    this.view.update();
  }

  /**
   * Retrieves the top [amountOfScores] highscores from Gamekey service.
   * Returns a List with max. [amountOfScores] entries. If there is less than [amountOfScores]
   * scores, than all existing scores will be returned.
   * Returns an empty List, if the gamekey-service is not available.
   */
  Future<List<Map>> getHighscores(int amountOfScores) async {
    List<Map> scores = [];
    try {
      final states = await this.gamekey.getStates();
      scores = states.map((entry) => {
        'name' : "${entry['username']}",
        'score' : entry['state']['points']
      }).toList();
      scores.sort((a, b) => b['score'] - a['score']);
    } catch (error, stacktrace) {
      print ("Error: $error");
      print (stacktrace);
    }

    return scores.take(amountOfScores);
  }

  /**
   * Stops the game and displays the "Game Over"-Message and the highscores. Additionally a
   * login/regestration form is being displayed, which allows the user to save his highscore.
   */
  dynamic gameOver() async {
    this.gameTrigger.cancel();

    this.view.gameOver.innerHtml = "Game Over!";

    final highscore = await this.getHighscores(5);
    this.view.showHighscores(highscore);

    document.querySelector('#save')?.onClick?.listen((_) async {
      String user = this.view.user;
      String pwd  = this.view.password;

      if (user?.isEmpty) {
        this.view.warningoverlay.innerHtml = "Please enter a username!";
        return;
      }

      if (pwd?.isEmpty) {
        this.view.warningoverlay.innerHtml = "Please enter a password!";
        return;
      }

      String id = await this.gamekey.getUserId(user);

      if (id == null) {
        final newUser = await this.gamekey.registerUser(user, pwd);
        if (newUser == null) {
          this.view.warningoverlay.innerHtml = "Could not register user $user.<br>User might already exist or gamekey service not available.";

          return;
        }
        this.view.warningoverlay.innerHtml = "";

        final stored = await this.gamekey.storeState(newUser['id'], {
          'version': '0.0.1',
          'points': this.game.score
        });
        if (stored) {
          this.view.clearScores();

          return;
        } else {
          this.view.warningoverlay.innerHtml = "Could not save highscore. Retry?";

          return;
        }
      }

      if (id != null) {
        final user = await this.gamekey.getUser(id, pwd);

        if (user == null) {
          this.view.warningoverlay.innerHtml = "Could not login. The entered password is wrong!";

          return;
        }

        final stored = await this.gamekey.storeState(user['id'], {
            'version': '0.0.1',
            'points': this.game.score
        });
        if (stored) {
          this.view.clearScores();

          return;
        } else {
          this.view.warningoverlay.innerHtml = "Could not save highscore. Retry?";

          return;
        }

        return;
      };
    });

    document.querySelector('#close')?.onClick?.listen((_) => this.view.clearScores());
  }

}
