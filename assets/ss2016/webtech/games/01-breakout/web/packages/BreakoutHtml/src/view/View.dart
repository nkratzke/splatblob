part of breakoutDart;


/**
 * A [View] object interacts with the DOM tree
 * to reflect actual [BreakoutGame] state to the user.
 */
class View {

  /**
   * Element with id '#status' of the DOM tree.
   * Used to display the availability of the [Gamekey].
   * Status: Online/Offline
   */
  final status = querySelector('#status');

  /**
   * Element with id '#overlay' of the DOM tree.
   * Used to display overlay forms.
   */
  final overlay = querySelector('#overlay');

  /**
   * Element with id '#life' of the DOM tree.
   * Used to indicate how many life a user actually has.
   */
  final life = querySelector('#life');

  /**
   * Element with id '#score' of the DOM tree.
   * Used to indicate how much points a user actually has.
   */
  final score = querySelector('#score');

  /**
   * Element with id '#level' of the DOM tree.
   * Used to show in which level the user is.
   */
  final level = querySelector('#level');

  /**
   * Element with id '#down' of the DOM tree.
   * Used to show if the user wants to pause the [Game].
   * (e.g. Game running: Hit SPACE to pause!).
   */
  final down = querySelector('#down');

  /**
   * Element with id '#breakoutgame' of the DOM tree.
   * Used to visualize the field of a [BreakoutGame] as a HTML table.
   */
  final gameTable = querySelector('#breakoutgame');

  /**
   * Contains all TD Elements of the field.
   */
  List<List<HtmlElement>> fields;
  var allFields;
  BreakoutGame gameModel;
  GameController gameController;

  /**
   * Adding a new Controller to View according [GameController].
   */
  View(GameController gameController) {
    this.gameController = gameController;
  }

  /**
   * Adding a new Model to View according [BreakoutGame].
   */
  void addNewModelToView(BreakoutGame gameModel) {
    this.gameModel = gameModel;
  }


  /**
   * Generates the field according to [gameModel] state.
   * A HTML table (n x m) is generated and inserted
   * into the [game] element of the DOM tree.
   */
  void generateField(BreakoutGame gameModel) {
    gameTable.innerHtml = "";
    String table = "";

    // generate the columns and rows
    for (int i = 0; i < gameModel.sizeY; i++) {
      table += "<tr>";
      for (int j = 0; j < gameModel.sizeX; j++) {
        final pos = "field_${j}_${i}";
        table += "<td id='$pos'></td>";
      }
      table += "</tr>";
    }

    gameTable.innerHtml = table;

    // Saves all generated TD elements in field to
    // avoid time intensive querySelector calls in update().
    fields = new List<List<HtmlElement>>(gameModel.sizeX);
    for (int x = 0; x < gameModel.sizeX; x++) {
      fields[x] = [];
      for (int y = 0; y < gameModel.sizeY; y++) {
        fields[x].add(querySelector("#field_${x}_${y}"));
      }
    }
    allFields = querySelectorAll("#breakoutgame td");
  }


  /**
   * Generates if Game is paused according [isPaused].
   */
  void gamePaused(bool isPaused) {
    if (!isPaused) {
      down.innerHtml = "Game running: Hit SPACE to pause!";
    } else {
      down.innerHtml = "Game paused: Hit SPACE to continue!";
    }
  }



  /**
   * Updates the view state.
   *
   * - [des] destroyable Stone will be loaded and updated.
   * - [ides] indestroyable Stone will be loaded and updated.
   * - [Panel] will be added and shown.
   * - [Ball] will be added and shown.
   * - Update the Destuction Color of the Stone's.
   */
  void update() {
    allFields.classes.clear();
    for (List<Cell> lC in gameModel.field) {
      for (Cell c in lC) {
        if (c != null) {
          var htmlElement = fields[c.posX][c.posY];
          htmlElement.classes.clear();
          switch (c.owner.type) {
            case "desS":
              switch (c.owner
                  .destructionInfo)
              {
                case 6:
                  htmlElement.classes.add("Stone6");
                  break;
                case 5:
                  htmlElement.classes.add("Stone5");
                  break;
                case 4:
                  htmlElement.classes.add("Stone4");
                  break;
                case 3:
                  htmlElement.classes.add("Stone3");
                  break;
                case 2:
                  htmlElement.classes.add("Stone2");
                  break;
                case 1:
                  htmlElement.classes.add("Stone1");
                  break;
                default:
                  htmlElement.classes.add("Stone7");
              }
              break;
            case "ideS":
              htmlElement.classes.add("InDesStone");
              break;
            case "panelPart":
              htmlElement.classes.add("Panel");
              break;
            case "ball":
              htmlElement.classes.add("Ball");
              break;
            default:
              break;
          }
        }
      }
    }
  }


  /**
   * Sets the Life counter in top of the Game-Field.
   */
  updateLifes() => life.innerHtml = "Life: (${gameModel.lifeCounter})";


  /**
   * Sets the Score in top of the Game-Field.
   */
  updateScore() => score.innerHtml = "Points: ${gameModel.score}";


  /**
   * Sets the Level counter in top of the Game-Field.
   */
  updateLevel() => level.innerHtml = "Level: (${gameModel.level})";


  /**
   * Sets a Connection Status text in top of the Game-Field.
   */
  updateStatus(bool hasConnection) =>
      hasConnection ? status.innerHtml = "Status: Online" : status.innerHtml =
      "Status: Offline";


  /**
   * Sets a warning text in the highscore form.
   */
  FailedSave() => querySelector('#failedsave').innerHtml =
  "Save failed! Please check your Status!";


  /**
   * Gets the user input from the highscore form.
   */
  String get user => (document.querySelector('#user') as InputElement).value;


  /**
   * Gets the password input from the highscore form.
   */
  String get password => (document.querySelector('#pwd') as InputElement).value;


  /*
  * Sets a warning text in the highscore form.
  */
  warn(String warning) => document.querySelector('#warning').innerHtml = warning;



  /**
   * Generates HTML snippet to present the highscore.
   */

  String generateHighscore(List<Map> scores, { int score: 0 }) {
    final list = scores.map((
        entry) => "<li>${entry['name']}: ${entry['score']}</li>").join("");
    final points = "You got $score points";

    return "<div id='scorelist'>${ score == 0 ? "" : points }${ list.isEmpty
        ? ""
        : "<ul>$list</ul>"}</div>";
  }




  /**
   * Shows the highscore form and save option for the user.
   */

  void showHighscore(List<Map> scores, bool win, bool showLogin) {
    final score = gameModel.score;

    overlay.innerHtml =
    "<div id='highscore3'>"
        "<h1>Highscore</h1>"
        "</div>";

    if ((scores.isEmpty || score > scores.last['score'] || scores.length < 5) && showLogin) {
      overlay.appendHtml((win ? "Win" : "GameOver") +
          this.generateHighscore(scores, score: score) +
          "<form id='highscoreform'>"
              "<input type='text' id='user' placeholder='user'>"
              "<input type='password' id='pwd' placeholder='password'>"
              "<button type='button' id='save'>Save</button>"
              "<a type='button' id='close'href='index.html' class='discard'>Close</a>"
              "<div id='failedsave'></div>"
              "<div id='warning'></div>"
              "</form>"
      );
    }
    else
    {
      overlay.appendHtml(this.generateHighscore(scores, score: score));
      overlay.appendHtml(
          "<a type='button' id='close'href='index.html' class='discard'>Close</a>");
    }
  }




  /**
   * Used to show if overlay will be visible or hidden.
   */
  toggleoverlay(bool vis) {
    overlay.classes.clear();
    if (vis) {
      overlay.classes.add("visible");
    } else {
      overlay.classes.add("hidden");
    }
  }
}