part of CaveEscape;
/*
 * Geschwindkeit mit der sich die Objekte bewegen
 */
const moveSpeed = const Duration(milliseconds: 500);
/*
 * Geschwindikeit mit der die View geupdatet wird
 */
const updateSpeed = const Duration(milliseconds: 50);
/*
 * Fängt Benutzereingaben ab und leitet sie an das Model weiter.
 * Verwaltet das Model und die View sowie die Kommunikation zwischen diesen.
 */
class CaveGameController {
  /*View des Spieles*/
  CaveView view = new CaveView();

  /*Model des Spieles*/
  var game = new CaveGame();

  /*Info ob sich das Spiel im Help Bildschirm befindet*/
  bool help = false;

  /*
   * Trigger zum bewegen und auslösen aller beweglichen
   * Objecte im Model.
   */
  Timer moveTrigger;
  /*
   * Trigger zum Updaten der View.
   */
  Timer updateTrigger;
  /*Kontructor*/
  CaveGameController() {
    //Spiel starten oder beenden.
    view.startButton.onClick.listen((_) {
      //Spiel läuft und der Start button ist
      //somit ein Stop button und spiel wird beendet.
      if (!game.running && !game.paused) {
        if (moveTrigger != null) moveTrigger.cancel();
        if (updateTrigger != null) updateTrigger.cancel();
        game.clear();
        view.generateField(game);
        moveTrigger = new Timer.periodic(moveSpeed, (_) => moveAll());
        updateTrigger =
            new Timer.periodic(updateSpeed, (_) => view.update(game));
        game.start();
        view.changeToStopButton();
      } /*Spiel läuft und wird gestoppt*/
      else {
        if (moveTrigger != null) moveTrigger.cancel();
        game.stop();
        view.changeToStartButton();
      }
      view.changeSpielfeldToHelp();
      view.changeWeiterToPause();
      help = false;
      view.update(game);
    });

    //Pausiert das Spiel
    view.pauseButton.onClick.listen((_) {
      pause();
    });
    //Zeigt Hilfe an
    view.helpButton.onClick.listen((_) {
      this.goTohelp();
    });
    //Tastatureingaben abfangen
    window.onKeyDown.listen((KeyboardEvent ev) {
      if (game.stopped) return;
      switch (ev.keyCode) {
        case KeyCode.A:
          game.movePlayerLeft();
          break;
        case KeyCode.D:
          game.movePlayerRight();
          break;
        case KeyCode.P:
          pause();
          break;
        case KeyCode.RIGHT:
          game.movePlayerRight();
          break;
        case KeyCode.LEFT:
          game.movePlayerLeft();
          break;
        case KeyCode.H:
          this.goTohelp();
          break;
      }
      view.update(game);
    });
  }

  //Bewegt alle Objecte im Model und updatetet die View
  void moveAll() {
    //Falls Model meldet, das Spiel vorbei ist, enstsprechend weiter an User geben
    if (game.gameOver) {
      game.stop();
      view.changeToStartButton();
      this.moveTrigger.cancel();
      view.setGameOver(game);
      this.updateTrigger.cancel();
      view.update(game);
      return;
    }
    //Falls Punkte voll sind, nächstes Level starten oder Spiel als beendet erklären
    if (game.pointsfull) {
      if (!game.hasNextLevel()) {
        game.stop();
        view.changeToStartButton();
        this.moveTrigger.cancel();
        this.updateTrigger.cancel();
        view.setWin(game);
        return;
      }
      try{
      game.loadNextLevel();
      this.goTohelp();
      }catch(Exception){
        this.moveTrigger.cancel();
        this.updateTrigger.cancel();
        view.changeToStartButton();
        game.stop();
        view.gameover.innerHtml = "LADEFEHLER";
        view.info.innerHtml = "Fehler beim Laden des nächsten Levels. Option Datei fehlerhaft!";
        view.update(game);
      
      }
    }
    game.movePlayer();
    game.moveObjects();
    game.generateObjects();
    newTimerSpeed();
  }
  //Setzt den Timer Speed in abhängigkeit vom Muliplier des CaveGame Objects
  void newTimerSpeed() {
    if (moveTrigger != null) moveTrigger.cancel();
    final newSpeed = moveSpeed * pow(0.99, game.multiplier);
    moveTrigger = new Timer.periodic(newSpeed, (_) => moveAll());
  }
  //Pausiert das Spiel oder setzt es wieder in den Spiel Modus.
  void pause() {
    if (game.paused) {
      game.start();
      help=false;
      view.generateField(game);
      newTimerSpeed();
      updateTrigger = new Timer.periodic(updateSpeed, (_) => view.update(game));
      view.changeWeiterToPause();
      view.update(game);
    } else {
      if (game.running) {
        game.pause();
        if (moveTrigger != null) moveTrigger.cancel();
        if (updateTrigger != null) updateTrigger.cancel();
        view.changePauseToWeiter();
      }
    }
  }
  /*
   * Zeigt einen Hilfemodus an, welcher die Symbole des Spieles einen erklärenden Namen
   */
  void goTohelp() {
    if (!game.paused) {
      pause();
    }
    if (!help) {
      view.showHelp(game);
      help = true;
      view.changeHelpToSpielfeld();
    } else {
      view.generateField(game);
      view.update(game);
      help = false;
      view.changeSpielfeldToHelp();
    }
  }
}
