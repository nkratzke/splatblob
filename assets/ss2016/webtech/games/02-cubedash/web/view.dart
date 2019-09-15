import 'dart:html';

import 'entity.dart';
import 'controller.dart';
import 'game.dart';

class View {
  Controller _controller;
  final HtmlElement _score = querySelector("#score");
  final HtmlElement _highscoreform = querySelector("#highscoreform");
  final HtmlElement _scorelist = querySelector("#scorelist");
  final HtmlElement warningoverlay = querySelector("#warningoverlay");
  final HtmlElement highscore = querySelector("#highscore");
  final HtmlElement startButton = querySelector("#startButton");
  final HtmlElement gameOver = querySelector("#gameover");
  final HtmlElement gameField = querySelector("#field");
  final HtmlElement powerupButton = querySelector("#powerupbutton");
  List<List<HtmlElement>> _fields = new List();

  View(this._controller);

  /**
   * Generates the field of the game. And stores them in [_fields]
   */
  void generateField() {
    String table = "";

    for (int i = 0; i < Game.fieldSizeY; i++) {
      table += "<tr>";
      for (int j = 0; j < Game.fieldSizeX; j++) {
        table += "<td id='field_${Game.fieldSizeY - i - 1}_${j}'></td>";
      }

      table += "</tr>";
    }

    this.gameField.innerHtml += table;

    for (int i = 0; i < Game.fieldSizeY; i++) {
      this._fields.add(new List());
      for (int j = 0; j < Game.fieldSizeX; j++) {
        this._fields[i].add(this.gameField.querySelector("#field_${i}_${j}"));
      }
    }
  }

  /**
   * Causes the view to update the positions of all Entities.
   */
  void update() {
    for (List<HtmlElement> ls in this._fields) {
      for (HtmlElement he in ls) {
        he.classes.clear();
        he.classes.add("empty");
      }
    }
    for (int i = 0; i < this._controller.game.player.height; i++) {
      for (int j = 0; j < this._controller.game.player.width; j++) {
        this._fields[this._controller.game.player.posY + i][this._controller.game.player.posX + j].classes.add("player");
      }
    }

    for (Entity e in _controller.game.obstacles) {
      for (int i = 0; i < e.height; i++) {
        for (int j = 0; j < e.width; j++) {
          if (this._fields.length > e.posY + i && 0 <= e.posY + i) {
            if (this._fields[e.posY + i].length > e.posX + j && 0 <= e.posX + j) {
              this._fields[e.posY + i][e.posX + j].classes.add("obstacle");
            }
          }
        }
      }
    }

    for (Entity e in _controller.game.powerups) {
      for (int i = 0; i < e.height; i++) {
        for (int j = 0; j < e.width; j++) {
          if (this._fields.length > e.posY + i && 0 <= e.posY + i) {
            if (this._fields[e.posY + i].length > e.posX + j && 0 <= e.posX + j) {
              this._fields[e.posY + i][e.posX + j].classes.add("powerup");
            }
          }
        }
      }
    }

    this._score.setInnerHtml("Score: ${this._controller.game.score}");
    this.gameOver.setInnerHtml(this._controller.game.gameOver ? "Game Over!" : "");
  }

  /**
   * Shows the highscores and the login-form to store the highscore
   */
  void showHighscores(List<Map> scores) {
    final list = scores.map((entry) => "<li>${entry['name']}: ${entry['score']}</li>").join("");

    this._highscoreform.appendHtml(
      "<input type='text' id='user' placeholder='user'>"
      "<input type='password' id='pwd' placeholder='password'>"
      "<button type='button' id='save'>Save</button>"
      "<button type='button' id='close'>Close</button>"
    );

    this._scorelist.appendHtml("<ol>$list</ol>");
  }

  /**
   * Hides the highscores and the login-form to store the highscore
   */
  void clearScores() {
    this._highscoreform.innerHtml = "";
    this._scorelist.innerHtml = "";
  }

  String get user => (document.querySelector('#user') as InputElement).value;
  String get password => (document.querySelector('#pwd') as InputElement).value;
}
