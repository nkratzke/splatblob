import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'game.dart';
import 'obstacle.dart';
import 'powerup.dart';

class Generator {
  Random _rnd = new Random();
  Game _game;
  static List<int> _levels = new List();
  static List<int> _nextObstacleDistances = new List();
  int _nextObstacleDistance = 60;
  static List<List<List<Obstacle>>> _possibleObstacles = new List();

  Generator(this._game);

  static List<int> get levels => Generator._levels;
  static List<List<List<Obstacle>>> get possibleObstacles => Generator._possibleObstacles;

  /**
   * Starts the process to read the levels.
   */
  static void readLevelsFromJson() {
    _readLevelFromJson(1);
  }

  /**
   * Checks if "lvl[level].json" exists, and if so it reads the level.
   */
  static void _readLevelFromJson(int level) {
    try {
      HttpRequest.request("lvl$level.json",
          method: "GET").then((req) {
        if(req.status == 200) {
          final settings = JSON.decode(req.responseText);

          Generator._levels.add(settings["neededPoints"]);
          Generator._nextObstacleDistances.add(settings["nextObstacleDistance"]);

          if ((settings["possibleObstacles"] as List<List>)?.isNotEmpty ??
              false) {
            _possibleObstacles.add((settings["possibleObstacles"] as List)
                .map((l) => (l as List<Map>).map((m) => new Obstacle(
                m["posX"], m["posY"], m["width"], m["height"])))
                .toList());
          }
          _readLevelFromJson(level+1);
        }
      });
    } catch (error, stacktrace) {
      print("Error: $error");
      print(stacktrace);
    }
  }

  /**
   * Checks if an obstacle should be spawned and if so, a new random obstacle of
   * the current level will be spawned.
   */
  void generateObstacle() {
    if (this._nextObstacleDistance == 0) {
      if (Generator._possibleObstacles.length > this._game.level) {
        if (Generator._possibleObstacles[this._game.level].length > 0) {
          List<Obstacle> nextGeneration = _possibleObstacles[this._game.level]
              [_rnd.nextInt(_possibleObstacles[this._game.level].length)];

          for (Obstacle o in nextGeneration) {
            this._game.obstacles.add(new Obstacle(
                o.posX + Game.fieldSizeX, o.posY, o.width, o.height));
          }
        }
      }

      this._nextObstacleDistance =
          Generator._nextObstacleDistances[this._game.level];
    } else {
      this._nextObstacleDistance--;
    }
  }

  void generatePowerup() {
    this._game.powerups.add(new Powerup(Game.fieldSizeX, 2, 2, 2));
  }

  /**
   * Deletes all obstacles which are behind the player and out of the screen.
   */
  void deleteObstacles() {
    for (int i = 0; i < this._game.obstacles.length; i++) {
      if (this._game.obstacles[i].posX + this._game.obstacles[i].width < 0) {
        this._game.obstacles.removeAt(i);
      }
    }
  }

  /**
   * Deletes all powerups which are behind the player and out of the screen.
   */
  void deletePowerups() {
    for (int i = 0; i < this._game.powerups.length; i++) {
      if (this._game.powerups[i].posX + this._game.powerups[i].width < 0) {
        this._game.powerups.removeAt(i);
      }
    }
  }
}
