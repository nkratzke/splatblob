part of brickcrash;
/**
 * Die EndView zeigt dem Spieler im Falle eines Sieges des gesamten Spieles oder
 * einer Niederlage ein Sicht.Hat der Spieler sich im Online Modus befunden,
 * so wird auch eine Top-ten liste angezeigt.
 * Ein Retry Button ermoeglicht es, das Spiel von vorne zu starten
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */
class EndView extends FrameView {

  DivElement highScorePlaceHolder;        //das Element fuer den Highscore
  ButtonElement retryButton;              //das Element fuer einen Button, mit dem man das Spiel neustartet

  /**
   * Constructor
   */
  EndView(Player player, String title) : super(player, title) {  }

  /**
   * Getter
   */
  ButtonElement getRetryButton() { return this.retryButton; }

  /**
   * Erstellt einen platzhalter fuer den Highscore
   * @return das highscore platzhalter Element
   */
  DivElement createHighScorePlaceHolder() {
    this.highScorePlaceHolder = new DivElement();
    this.highScorePlaceHolder.id = "highScore";
    return this.highScorePlaceHolder;
  }

  /**
   * Ertellt einen Retry Button
   * @return das Retry Button Element
   */
  ButtonElement createRetryButton() {
    this.retryButton = new ButtonElement();
    this.retryButton.id = "retryButton";
    this.retryButton.text = "Retry";
    return this.retryButton;
  }

  /**
   * Zeigt den Highscore(falls online) und den Retrybutton in der Mitte des Spielfeldes in einem Fenster an
   */
  void drawDefault()  {
    super.drawDefault();

    this.frame  ..append(this.createHighScorePlaceHolder())
                ..appendHtml("<br>")
                ..append(this.createRetryButton());
    this.add(this.frame);
  }

  /**
   * Setzt die Highscores. Falls der Spieler einen Score erreicht hat,
   * der in der Top Ten ist, so wird dieser Dicker dargestellt
   * @param highScore HighScore Liste
   */
  void setHighScore(List<Map> highScore) {
    bool highlighted = false;
    highScore.forEach((map) {
      String row = map["username"].toString()+": "+map["state"]["points"].toString();
      if (!highlighted && this.player != null && this.player.getUID() == map["userid"] && this.player.getScore() == map["state"]["points"]) {
        highlighted = true;
        row = "<span class='yourScore'>"+row+"</span>";
      }
      this.highScorePlaceHolder.innerHtml += row+"<br>";
    });
  }
  }