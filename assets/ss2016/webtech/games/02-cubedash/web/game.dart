import 'entity.dart';
import 'generator.dart';
import 'player.dart';

class Game {
  bool running = false;
  bool gameOver = false;
  int _score = 0;
  int _level = 0;

  static const int fieldSizeX = 40;
  static const int fieldSizeY = 28;

  List<Entity> obstacles = [];
  List<Entity> powerups = [];
  Entity _player;
  Generator _generator;

  int get score => this._score;
  int get level => this._level;
  Entity get player => this._player;

  set score (int score) {this._score = score;}
  set level (int level) => this._level;

  Game() {
    this._player = new Player(4, 0, 4, 4, this);
    this._generator = new Generator(this);
  }

  /**
   * Checks if the player collided with an obstacle. Increases the score by 1.
   * Also the player-jump is being executed, when the player jumped.
   * Tells the generator to eventually generate a new obstacle and clear all obstacles,
   * which are no longer in the game. If the [score] of the player is high enough,
   * the next level will be started.
   */
  void loop() {
    if(this._player.checkCollision()) {
      this._gameOver();

      return;
    }

    this._score += 1;

    this._player.collectPowerup();
    this._player.jumpAction();

    for(var o in this.obstacles) {
      o.move();
    }

    for(var p in this.powerups) {
      p.move();
    }

    this._generator.generateObstacle();

    this._generator.deleteObstacles();
    this._generator.deletePowerups();

    if(this._score > Generator.levels[_level] && this._level < Generator.levels.length - 1) {
      this._level++;

      this._generator.generatePowerup(); // Generate a powerup on new level
    }
  }

  /**
   * Makes the player jump
   */
  void playerJump() {
    this._player.jump();
  }

  /**
   * Stops the game and sets [gameOver] to true.
   */
  void _gameOver() {
    this.running = false;
    this.gameOver = true;
  }
}
