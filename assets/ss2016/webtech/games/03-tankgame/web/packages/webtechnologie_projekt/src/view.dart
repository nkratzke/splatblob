part of tankgame;

class TankView {

  final _gameTable = querySelector('#tanktable');

  get gameTable => _gameTable;
  final _warningoverlay = querySelector("#warningoverlay");
  final _highscore = querySelector("#highscore");
  final _overlay = querySelector("#overlaycontent");
  final _levelanzeige = querySelector("#level");
  final _lenkMunition = querySelector('#lenkMunition');
  final _verbleibendeGegener = querySelector("#verbleibendeGegner");
  final _nextLevelButton = querySelector("#nextLevelButton");
  final _startbutton = querySelector('#startButton');
  final _playerleben = querySelector('#playerleben');
  final _stats = querySelector('#stats');

  HtmlElement get stats => _stats;
  HtmlElement get lenkmunition => _lenkMunition;
  HtmlElement get startbutton => _startbutton;
  HtmlElement get nextLevelButton => _nextLevelButton;
  HtmlElement get playerleben => _playerleben;
  HtmlElement get warningoverlay => _warningoverlay;
  HtmlElement get highscore => _highscore;
  HtmlElement get overlay => _overlay;
  HtmlElement get levelanzeige => _levelanzeige;
  HtmlElement get verbleibendeGegener => _verbleibendeGegener;


  List<List<HtmlElement>> htmlField;

  /**
   * Generiert die HTML-Tabelle und speichert alles zusätzlich in einer Liste
   * über Listen.
   */

  void generateField(TankGame game) {
    final field = game.field;
    var table = "";
    for (int row = 0; row <= field.length - 1; row++) {
      table += "<tr>";
      for (int col = 0; col <= field[row].length - 1; col++) {
        final pos = "field_${row}_${col}";
        table += "<td id='$pos'></td>";
      }
      table += "</tr>\n";
    }
    gameTable.innerHtml = table;


    // Saves all generated TD elements in field to
    // avoid time intensive querySelector calls in update().
    // Thanks to Johannes Gosch, SoSe 2015.
    htmlField = new List<List<HtmlElement>>(field.length);
    for (int row = 0; row < field.length; row++) {
      htmlField[row] = [];
      for (int col = 0; col < field[row].length; col++) {
        htmlField[row].add(gameTable.querySelector("#field_${row}_${col}"));
      }
    }
  }

  /**
   * Updatet das View
   */

  void update (TankGame game, GameObject player) {
    final field = game.field;
    for(int row = 0; row < field.length; row++) {
      for(int col = 0; col < field[row].length; col++) {
        final td = htmlField[row][col];
        if(td != null) {
          td.classes.clear();
          if(field[row][col] == #wall) td.classes.add('wall');
          else if(field[row][col] == #bullet) td.classes.add('bullet');
          else if(field[row][col] == #playerTank) td.classes.add('playerTank');
          else if(field[row][col] == #enemyTank) td.classes.add('enemyTank');
          else if(field[row][col] == #base) td.classes.add('base');
          else if(field[row][col] == #lenkrakete) td.classes.add('lenkrakete');
        }
      }
    }


  }

  void updateStats(TankGame game, GameObject player) {
    var leben = player.leben.toString();
    var high = game.highscore.toString();
    var level = game._aktuelleLevelNummer.toString();
    var verbleibende = game.verbleibendeGegner.toString();
    var lenkMunition = game._player._lenkraketenMunition.toString();
    playerleben.innerHtml = "Leben: $leben";
    lenkmunition.innerHtml = "Lenkraketen Munition: $lenkMunition";
    highscore.innerHtml = "Highscore: $high";
    levelanzeige.innerHtml = "Level: $level";
    verbleibendeGegener.innerHtml = "Verbleibende Gegner: $verbleibende";
  }

  /**
   * Generates HTML snippet to present the highscore.
   */
  String generateHighscore(List<Map> scores, { int score: 0 }) {
    final list = scores.map((entry) => "<li>${entry['name']}: ${entry['score']}</li>").join("");
    final points = "Du hast $score Punkte erreicht!";
    return "<div id='scorelist'>${ score == 0 ? "" : points }${ list.isEmpty? "" : "<ul>$list</ul>"}</div>";
  }

  /**
   * Shows the highscore form and save option for the user.
   */
  void showHighscore(TankGame model, List<Map> scores) {

    if (overlay.innerHtml != "") return;

    // final score = model.miceCounter;
    final score = model.highscore;

    overlay.innerHtml =
    "<div id='highscore'>"
        "   <h1>Highscore</h1>"
        "</div>"
        "<div id='highscorewarning'></div>";

    if (scores.isEmpty || score > scores.last['score'] || scores.length < 10) {
      overlay.appendHtml(
          this.generateHighscore(scores, score: score) +
              "<form id='highscoreform'>"
                  "<input type='text' id='user' placeholder='user'>"
                  "<input type='password' id='pwd' placeholder='password'>"
                  "<button type='button' id='save'>Save</button>"
                  "<button type='button' id='close' class='discard'>Close</button>"
                  "</form>"
      );
    } else {
      overlay.appendHtml(this.generateHighscore(scores, score: score));
      overlay.appendHtml("<button type='button' id='close' class='discard'>Close</button>");
    }

  }

  void showOnlyHighscore(TankGame model, List<Map> scores) {

    if (overlay.innerHtml != "") return;

    // final score = model.miceCounter;
    final score = model.highscore;

    overlay.innerHtml =
    "<div id='highscore'>"
        "   <h1>Highscore</h1>"
        "</div>"
        "<div id='highscorewarning'></div>";
      overlay.appendHtml(this.generateHighscore(scores, score: score));
      overlay.appendHtml("<button type='button' id='close' class='discard'>Close</button>");

  }

  /**
   * Closes a form (e.g. highscore form).
   */
  closeForm() => overlay.innerHtml = "";

  /**
   * Gets the user input from the highscore form.
   */
  String get user => (document.querySelector('#user') as InputElement).value;

  /**
   * Gets the password input from the highscore form.
   */
  String get password => (document.querySelector('#pwd') as InputElement).value;

  /**
   * Sets a warning text in the highscore form.
   */
  void warn(String message) {
    document.querySelector('#highscorewarning').innerHtml = message;
  }


}