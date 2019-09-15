part of brickcrash;

/**
 * Der Conroller steuert alle auftretende Erreignisse, aendert bei Bedarf die Werte in Models
 * und aktualisiert die Views
 *
 * Hier laeuft auch ein Timer, der alle 10ms die View komplett aktualisiert
 *
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */

class LevelController {
  // Level
  LevelModel level        = null;                 // Level-Logik
  Player player           = null;                 // Spieler-Daten
  View  view              = null;                 // View: Level, Login oder Gameover

  Timer timer             = null;                 // View-Update-Timer
  int duration            = 30;                   // Update-Timer-intervall in ms
  int levelNum            = 12;
  int startByLevel        = 1;                    // Levelnummer, bei dem gestartet wird

  String gamekeySettings  = "../web/gamekey_reference.json";    // Gamekey-Einstellung
  GameKey gamekey         = null;                 // Gamekey-Instanz
  var bodyKeyDownListener;
  /**
   * Eingangspunkt des Programms.
   */
  LevelController() { this.chooseView();  }       // Als Erstes die View aussuchen

  /**
   * Die View wird ausgewaehlt.
   *
   * Es kommt drauf an, ob Gamekeyservice online ist oder nicht.
   * Ist es online, wird Login-Fenster angezeigt.
   * sonst startet das Spiel in Offline-Modus
   */
  void chooseView() {
    this.view = new View(this.player);            // standarte Einstellung
    this.gamekey = new GameKey(gamekeySettings);  // Gamekey einstellen
    this.startUpdateTimer();                      // Update-Timer starten
    //this.startCheckGamekey();
    this.gamekey.connect().then((online){           // Versuchen, mit Gamekey zu verbinden
      if (online) {                                 // Wenn Verbindung erfolgreich war,
        this.showLogin();                           // dann das Loginfenster anzeigen
      } else {
        this.player = new Player("GUEST", "Guest"); // Als Offline-Spieler wird der Gast eingestellt
        this.startGame();                           // das Spiel offline starten
      }
    });
  }

  /**
   * Das Loginfenster anzeigen,
   * hier wird auch der User angemeldet und das Spiel ggf gestartet
   */
  void showLogin()  {
    this.view = new LoginView(this.player, "Login");

    this.view.load().then((_){

      (this.view as LoginView).getLoginForm().onSubmit.listen((Event e) async {           // wird das Login-Formular verschickt,
        e.preventDefault();   // standarte Abschicken-Funktion abbrechen
        e.stopPropagation();
        String login      = (this.view as LoginView).getLoginInput().value;
        String password   = (this.view as LoginView).getPasswordInput().value;

        //gameKeyController.deleteUser(login,password);

        this.gamekey.login(login,password).then((UID) {                // versuchen, einzuloggen
          switch (UID) {
            // Login und Passwort stimmen nicht ueberein
            case "-1" : (this.view as LoginView).showError("Login und Passwort stimmen nicht ueberein!");            break;

            // Passwort nicht korrekt
            case "-2" : (this.view as LoginView).showError("Bitte geben Sie Ihr Passwort ein! (mind. 6 Zeichen)");  break;

            // Login OK
            default   : this.player = new Player(UID, login);     this.startGame();                                 break;
          }
        });
      });
    });
  }

  /**
   * das Level starten
   */
  void startGame() {
    if (this.level == null) {
      this.player.setLives(3);                                          // Der Spieler hat von Anfang an 3 Leben
      this.level        = new LevelModel(this.player);                  // neuen Level generieren
      this.startLevel(this.startByLevel);                                    // und das Level starten

      // Hier ein Paar Listener, damit der User im Spiel interagieren kann..
      this.bodyKeyDownListener = querySelector('body').onKeyDown.listen((KeyboardEvent e) async {
        switch (e.keyCode) {
          case KeyCode.SPACE  :  await this.level.startMoveBalls();         break;

          case KeyCode.P      :
            if(this.level.isPaused()) { this.level.resume();    }     // ist der Level bereits pausiert => fortsetzen
            else                      { this.level.pause();     }     // sonst pausieren
            break;

          default             :
            if (this.level.isRunning()) {
              if      (e.keyCode == KeyCode.LEFT  || e.keyCode == KeyCode.A)  { this.level.getBeater().moveLeft(10.0);  }
              else if (e.keyCode == KeyCode.RIGHT || e.keyCode == KeyCode.D)  { this.level.getBeater().moveRight(10.0); }
            }
            break;
        }
      });
    }
  }

  /**
   * Das Level starten.
   * Das Level wird geladen, generiert und die Groessen werden eingestellt
   * @param int levelID Levelnummer
   */
  void startLevel (int levelID)  {
    this.level.setLevel(levelID);

    this.level.loadLevel().then((_){  // sobald der Level geladen wurde
      this.view         = new LevelView(this.player, this.level);     // die View erstellen
      // Nach der View-Erstellung wird das Model mit den generierten Werten gefuellt
      // (Hoehen, Breiten) => so ist das Model nicht mehr  abhaengig von der View!

      this.level.setWidth(this.view.getWidth());
      this.level.setHeight(this.view.getHeight());
      this.level.setYPosition(this.view.getBorderWidth());
      this.level.setXPosition(this.view.getBorderWidth());

      // dann den Schlaeger zuruecksetzen, den Ball richtig platzieren..
      // (das waere nicht moeglich, wenn die Breiten und Hoehen noch nicht festgelegt wuerden)
      this.level.reset();

      // anschliessend die View laden
      this.view.load().then((_){
        (this.view as LevelView).getMoveLeftButton().onClick.listen((Event e) { this.level.getBeater().moveLeft(10.0); });
        (this.view as LevelView).getMoveRightButton().onClick.listen((Event e){ this.level.getBeater().moveRight(10.0); });
        (this.view as LevelView).getStartButton().onClick.listen((Event e)    { this.level.startMoveBalls(); });
      });
    });
  }

  /**
   * Game Over - Frame anzeigen
   */
  void showGameOver() {
   this.view = new EndView(this.player, "Game Over :(");

    this.view.load().then((_) {
      // sobald die View geladen wurde
      this.loadEndView();
    });
  }

  /**
   * einen periodischen Timer starten, der alle 30ms die Erreichbarkeit des Gamekey-Services ueberprueft.
   */
  void startCheckGamekey() {
    new Timer.periodic(new Duration(milliseconds: 30), (_) { this.gamekey.connect();});
  }

  /**
   * Online:
   *    Speichert den Punktestand des Spielers und zeigt die Top-10 liste an
   * Offline:
   *    Es wird nur der Retry-Button angezeigt
   */
  void loadEndView() {
    this.gamekey.storeState(this.player.getUID(), {            // versuchen, die erreichte Pukte auf den Gamekey-Server zu speichern
      'points': this.player.getScore()
    }).then((_) {
      this.gamekey.getHighScore().then((highScore){       // dann die Highscores laden
        (this.view as EndView).setHighScore(highScore);   // und in den View anzeigen ( falls moeglich )
      });
    });

    this.player = null;                                   // der Spieler wird jetzt rueckgesetzt
    this.bodyKeyDownListener.cancel();
    // beim Klicken auf "Retry" faengt alles wieder von vorne an.
    (this.view as EndView).getRetryButton().onClick.listen((Event e) {
      (this.view as EndView).getRetryButton().disabled = true;
      this.chooseView();
    });
  }

  /**
   * startet einen Timer, der alle 10 millisekunden (einstellbar) die View updatet.
   * Der Timer wird unterbrochen, wenn der Level durch ist.
   */
  void startUpdateTimer()   {
    this.timer = new Timer.periodic(new Duration(milliseconds: duration),(_) async {

      if (this.level != null) {
        switch (this.level.getStatus()) {
          case LevelModel.FINISHED :                        // der Level ist beendet:
            this.level.clear();                             // Den Level beenden, sprich alle Timer unterbrechen.
            int newLevel = this.level.getLevelID()+1;       // neue (moegliche) Level

            // Es gibt noch weitere Level => einfach neuen Level starten!
            if (newLevel <= this.levelNum)  { this.startLevel(newLevel);                            }
            // es gibt keine Level mehr => das Spiel ist gewonnen!
            else                            {
              this.view = new EndView(this.player, "You Won! :)");
              this.view.load().then((_){
                this.loadEndView();
              });
            }
            break;

          case LevelModel.GAMEOVER:                         // das Spiel ist verloren:
            this.view.update();
            this.showGameOver();                            // GameOver-View anzeigen
            this.level = null;                              // und den Level loeschen (damit es nicht mehr in diesen Switch reingeht!)
            break;
        }
      }

      this.view.update();                                       // die View wird immer aktualisiert!
      this.view.updateGameKeyStatus(this.gamekey.getStatus());  // den Gamekey Status auch aktualisieren
    });
  }
}