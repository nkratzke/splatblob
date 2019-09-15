part of brickGame;

///
/// A [View] object interacts with the DOM tree
/// to reflect the actual game state to the user.
class View {

  ///
  /// Element with id '#warningoverlay' of the DOM tree
  /// Used to display general warnings
  final warningoverlay = querySelector("#warningoverlay");

  ///
  /// Element with id '#overlay' of the DOM tree
  /// Used to display the highscore overlay.
  final overlay = querySelector("#overlay");

  ///
  /// Element with id '#title' of the DOM tree
  /// The title of the game
  final title = querySelector("#title");

  ///
  /// Element with id '#level' of the DOM tree
  /// current game level
  final level = querySelector("#level");

  ///
  /// Element with id '#gameover' of the DOM tree
  /// Indicates that the game is over
  final gameover = querySelector("#gameover");

  ///
  /// Element with id '#game' of the DOM tree
  /// Used to visualize the field of [Game] as a HTML table
  final game = querySelector("#game");

  ///
  /// Element with id '#points' of the DOM tree
  /// Used to indicate how many points a user has actually collected
  final points = querySelector("#points");

  ///
  /// Element with id '#score' of the DOM tree
  /// Shown only if game is not running
  final highscore = querySelector("#score");

  ///
  /// Element with id '#beforeaftergame' of the DOM tree
  /// Shown only if game is not running.
  final startHigh = querySelector("#startHigh");

  ///
  /// Element with id '#menuview' of the DOM tree
  /// Start menu of the game
  final menuView = querySelector("#menuview");

  ///
  /// Element with id 'gameview' of the DOM tree
  /// Game menu of the game
  /// Shown only if user activates 'Game' button in [menuView]
  final gameView = querySelector("#gameview");

  ///
  /// Element with id 'back' of the DOM tree
  /// 'Menu' button [BackMenuButton] in [gameView] to change to [menuView]
  /// Shown only game is not running
  final backMenu = querySelector("#back");

  ///
  /// Element with id '#help' of the DOM tree
  /// Help menu of the game
  /// Shown only if user activates 'How To' button [helpButton]
  final help = querySelector("#help");

  ///
  /// Element with id '#button' of the DOM tree
  /// Shows only left/right button if the game is running
  final vanishedLeftRightButton = querySelector("#button");

  ///
  /// Button to change from [menuView] to [gameView]
  HtmlElement get startGameButton => querySelector("#startgame");

  ///
  /// Start button of the game
  HtmlElement get startButton => querySelector("#start");

  ///
  /// Button to change from [gameView] to [menuView]
  HtmlElement get backMenuButton => querySelector("#backmenu");

  ///
  /// Button to change from [menuView] to [help]
  HtmlElement get helpButton => querySelector("#howto");

  ///
  /// Button to change from [help] to [menuView]
  HtmlElement get cancelButton => querySelector("#cancelbutton");

  ///
  /// Button to move the player right
  HtmlElement get rightButton => querySelector("#rightbutton");

  ///
  /// Button to move the player left
  HtmlElement get leftButton => querySelector("#leftbutton");

  ///
  /// Contains all TD Elements of the field
  List<List<HtmlElement>> gameFields;

  ///
  ///Generates the field acording to [model] state.
  ///A HTML table (n x m) is generated and inserted
  /// into the [game] element of the DOM tree
  ///
  void generateField(Game model) {
    final List<List<GameObject>> field = model.gameFields[model.countLevel]
        .gameField;

    String table = "";

    for (int row = 0; row < field[0].length; row++) {
      table += "<tr>";
      for (int col = 0; col < field.length; col++) {
        final assignment = field[col][row].toString();
        final pos = "field_${col}_${row}";
        table +=
        "<td id='$pos' class='$assignment'  ></td>";
      }
      table += "</tr>";
    }
    game.innerHtml = table;

    // Saves all generated TD elements in field to
    // avoid time intensive querySelector calls in update().
    // Thanks to Johannes Gosch.
    gameFields = new List<List<HtmlElement>>(field.length);
    for (int row = 0; row < field.length; row++) {
      gameFields[row] = [];
      for (int col = 0; col < field[row].length; col++) {
        gameFields[row].add(game.querySelector("#field_${row}_${col}"));
        _setWidthAndLength(gameFields[row][col],field[row][col]);

      }
    }
  }

  /// Updates the view according ot the [model] state
  ///
  /// [level] are updated according to the [model] state.
  /// [points] are updated according to the [model] state.
  /// [startButton] is shown according to the stopped/running state of the [model].
  /// [gameover] is shown when [model] indicates game over state.
  /// [highscore] is presented to scores, per default no highscore is shown.
  /// [startHigh] is shown according to the stopped/running state of the [model].
  /// [backMenuButton] is shown according to the stopped/running state of the [model].
  /// [vanishedLeftRightButton] is shown according to the stopped/running state of the [model].
  /// Field is shown according to actual field state of [model].
  ///
  void update(Game model, {List<Map> scores: const []}) {
    gameover.innerHtml = model.gameOver() ? "Game Over!" : "";

    startHigh.style.display = model.gameOver() ? "block" : "none";
    backMenu.style.display = model.gameOver() ? "block" : "none";
    vanishedLeftRightButton.style.display = model.gameOver() ? "none" : "block";

    level.innerHtml="Level: ${model.countLevel + 1}";
    points.innerHtml = "Points: ${model.points}";

    // Updates the field
    final field = model.gameFields[model.countLevel].gameField;

    for (int row = 0; row < field.length; row++) {
      for (int col = 0; col < field[row].length; col++) {
        var td = gameFields[row][col];
        td.classes.clear();
        GameObject object = field[row][col];
        td.classes.add(object.toString());
        td = _setWidthAndLength(td,object);

      }
    }
  }

  ///
  /// Adjusts the width and height of [HtmlElement] in css
  ///
  HtmlElement _setWidthAndLength(HtmlElement element,GameObject gameObject){
    if(element==null|| gameObject==null) return null;
    var width = gameObject.width;
    if(gameObject is Player){
      width = (gameObject.width/3);
      element.style..setProperty("padding-right","${width}px")
        ..setProperty("padding-left","${width}px")
        ..setProperty("width","${width}px")
        ..setProperty("height","${gameObject.height}px");
    }else{
      element.style..setProperty("width","${width}px")
        ..setProperty("height","${gameObject.height}px")
        ..setProperty("padding-right","0px")
        ..setProperty("padding-left","0px");
    }
    return element;

  }

  ///
  /// Used to display general warnings
  ///
  void warning(String message) {
    document
        .querySelector('#warningoverlay')
        .innerHtml = message;
  }

  ///
  /// Used to display highscore warnings
  ///
  void highscoreMessage(String message){
    document.querySelector('#highscorewarning')
        .innerHtml=message;
  }

  ///
  /// Generates HTML snippet to present the highscore
  ///
  String generateHighscore(List<Map> scores, { int score: 0 }) {
    final list = scores.map((entry) => "<li>${entry['username']}: ${entry['state']['points']}</li>").join("");
    final points = "You got $score points!";
    return "<div id='scorelist'>${ score == 0 ? "" : points }${ list.isEmpty? "" : "<ul>$list</ul>"}</div>";
  }

  ///
  /// Shows the highscore form and save option for the user
  ///
  void showHighscore(Game model, List<Map> scores) {

    if (overlay.innerHtml != "") return;
    final score = model.points;
    document.querySelector('#title').innerHtml='';
    overlay.innerHtml =
    "<div id='highscore'>"
        "   <h3>Highscore</h3>"
        "</div>"
        "<div id='highscorewarning'></div>";
    print(scores);
    if(score>0&&scores!=null&&(scores.isEmpty || scores.last['state']['points']<score || scores.length < 10)) {
      overlay.appendHtml(
          this.generateHighscore(scores, score: score) +
              "<form id='highscoreform'>"
                  "<input type='text' id='user' placeholder='user'>"
                  "<input type='password' id='password' placeholder='password'>"
                  "<button type='button' id='save'>Save</button>"
                  "<button type='button' id='close' class='discard'>Close</button>"
                  "</form>"
      );
    } else {
      overlay.appendHtml(this.generateHighscore(scores, score: score));
      overlay.appendHtml("<button type='button' id='close' class='discard'>Close</button>");
    }
  }

  ///
  /// Closes a form (e.g. highscore form)
  ///
  closeForm() => overlay.innerHtml = "";

  ///
  ///  Gets the user input from the highscore form.
  ///
  String get user => (document.querySelector('#user') as InputElement).value;

  ///
  /// Gets the password input from the highscore form.
  ///
  String get password => (document.querySelector('#password') as InputElement).value;

}