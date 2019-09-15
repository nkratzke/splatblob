part of CaveEscape;

/*
 * Verwaltet die Anzeige in der HTML
 */
class CaveView {
  /*Tabelle in der das Spiel selbst stattfindet*/
  final cavegametable = querySelector("#cavegame");
  /*Titel des Spieles*/
  final titel = querySelector("#titel");
  /*Gibt Informationen über Spielausgang*/
  final info = querySelector("#info");
  /*Gameoveranzeige*/
  final gameover = querySelector("#gameover");
  /*Levelanzeige*/
  final level = querySelector("#level");
  /*Punkte*/
  final points = querySelector("#points");
  /*Multiplizierer*/
  final multiplier = querySelector("#multiplier");
  /*Lebenspunkteanzeige*/
  final life = querySelector("#life");
  /*Start Buttons des Spieles, welcher auf der Stop Button sein kann*/
  HtmlElement get startButton => querySelector("#start");
  /*Pause Button zum pausieren des Spieles, wenn pausiert muss "Weiter" drin stehen*/
  HtmlElement get pauseButton => querySelector("#pause");
  /*Help Button, nur zwischen Levels Clickbar*/
  HtmlElement get helpButton => querySelector("#help");

  /*Verändert den Start Button in einen Stop Button*/
  changeToStopButton() => startButton.innerHtml = "Stop";
  /*Verändert den Stop Button in einen Start Button*/
  changeToStartButton() => startButton.innerHtml = "Start";
  /*Verändert den Pause Button in einen Weiter Button*/
  changePauseToWeiter() => pauseButton.innerHtml = "Weiter";
  /*Verändert den Weiter Button in einen Pause Button*/
  changeWeiterToPause() => pauseButton.innerHtml = "Pause";
  /*Verändert den Hilfe Button in einen Spielfeld Button*/
  changeHelpToSpielfeld() => helpButton.innerHtml = "Spielfeld";
  /*Verändert den Spielfeld Button in einen Hilfe Button*/
  changeSpielfeldToHelp() => helpButton.innerHtml = "Hilfe";

  /*
   *Updatet alle Anzeigeelemente auf der HTML
   */
  void update(CaveGame game) {
    points.innerHtml = "Points: ${game.points}";
    life.innerHtml = "Life: ${game.lifes}";
    level.innerHtml = "Level: ${game.levelname}";
    multiplier.innerHtml = "Multiplier: ${game.multiplier}x";
    updateField(game);
  }
  /*Updatet das Feld mit den neuen Klassen zur Anzeige*/
  void updateField(CaveGame game) {
    final field = game.field;
    for (int row = 0; row < game.rowSize; row++) {
      for (int col = 0; col < game.columnSize; col++) {
        final td = cavegametable.querySelector("#field_${row}_${col}");
        if (td != null) {
          td.classes.clear();
          td.classes.add(symbolToClassString(field[row][col]));
        }
      }
    }
  }
  /*
   * generiert das Spielfeld nach dem im Model eingelesenden Werten
   */
  void generateField(CaveGame game) {
    final field = game.field;
    String table = "";
    for (int row = 0; row < game.rowSize; row++) {
      table += "<tr>";
      for (int col = 0; col < game.columnSize; col++) {
        final pos = "field_${row}_${col}";
        final classtag = field[row][col];
        table += "<td id='$pos' class='${symbolToClassString(classtag)}'></td>";
      }
      table += "</tr>";
    }
    cavegametable.innerHtml = table;
  }
  /*
   * Wandelt ein Symbol so um, dass der Inhalt als Klasse für CSS verwendet werden kann
   * Genau genommen wird Ein String aus dem Wert des Symbols generiert.
   */
  String symbolToClassString(Symbol s) {
    return s.toString().substring(8, s.toString().length - 2);
  }

  /*
   * Zeigt in der Spieltabelle eine Hilfsseite an,
   *  welche einen über die Symbol im Spiel informiert
   */
  void showHelp(CaveGame game) {
    String table = "";
    table += "<tr>";
    table += "<td class='description'>Nach links bewegen</td>";
    table += "<td class='description'>A oder Pfeiltaste Links</td>";
    table += "</tr>";
    table += "<tr>";
    table += "<td class='description'>Nach rechts bewegen</td>";
    table += "<td class='description'>D oder Pfeiltaste Rechts</td>";
    table += "</tr>";
    table += "<tr>";
    table += "<td class='description'>Pausieren</td>";
    table += "<td class='description'>P</td>";
    table += "</tr>";
    table += "<tr>";
    table += "<td class='description'>Hilfe Fenster öffnen</td>";
    table += "<td class='description'>H</td>";
    table += "</tr>";
    for (String s in game.objectNames) {
      table += "<tr>";
      //table+="<td class='label'>${s}</td>";
      table += "<td class='description'>${game.getDescriptionOf(s)}</td>";
      table += "<td class='${s}'></td>";
      table += "</tr>";
    }
    cavegametable.innerHtml = table;
    this.update(game);
  }
  /*
   * Gibt einen GameOver Text wieder
   */
  String gameoverInfoText(CaveGame game) {
    return "Sie sind bis Level ${game.levelname} gekommen und haben folgenden Highscore erreicht: ${game.getHighscore()}!";
  }
  /*
   * Zeigt ein GameOver an, sowie einen zugehörigen GameOver Text
   */
  void setGameOver(CaveGame game) {
    this.gameover.innerHtml = "GAME OVER!";
    this.info.innerHtml = this.gameoverInfoText(game);
  }
  /*
   * Beglückwünscht den Spieler zum Sieg und zeigt einen Siegestext an.
   */
  void setWin(CaveGame game) {
    this.gameover.innerHtml = "Herzlichen Glückwunsch!";
    this.info.innerHtml =
        "Sie haben das Spiel abgeschlossen und alle Level geschafft!\n Ihr erreichter Highscore beträgt: ${game.getHighscore()}";
  }
}
