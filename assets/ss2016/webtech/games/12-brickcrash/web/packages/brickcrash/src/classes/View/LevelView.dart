part of brickcrash;
/**
 * Die LevelView wird fuer alle Objekte des Spielfeldes verwendet, diese
 * werden hier als Elemente erstellt und werden dauerhaft aktualliesiert.
 * Zum Platzieren von diesen, erbt diese Klasse von der View.
 * @version 1.2
 * @author Johann Schnitkov, Mihail Usenko
 */
class LevelView extends View {
  LevelModel model;
  Element levelIDPlaceholder = querySelector("#levelId");     //Die Levelnummer
  Element scorePlaceHolder = querySelector("#currentScore");  //Der aktuelle Score
  Element livesPlaceHolder = querySelector("#lives");         //Die aktuellen Leben

  DivElement moveLeftButton;
  DivElement moveRightButton;
  DivElement startButton;

  // hier werden spaeter alle Elemente gespeichert
  ImageElement beaterElement = null;

  Map<BallModel, ImageElement> balls;
  Map<BrickModel, ImageElement> bricks;
  Map<PowerUpModel, ImageElement> flyingPowerUps;
  Map<PowerUpModel, ImageElement> usedPowerUps;

  /*
   CONSTRUCTOR
   */

  /**
   * Die LevelModel Instanz wird hier gesetzt und es werden alle Objekte fuer alle
   * Typen(Baelle,Steine, usw...) neu gesetzt
   * Der Spieler wird an die View weitergeleitet
   * @param player Der aktuelle Spieler
   * @param model Die LevelModel Instanz
   */
  LevelView(Player player, LevelModel model) : super(player) {
    this.model = model;
    this.balls = new Map<BallModel, ImageElement>();
    this.bricks = new Map<BrickModel, ImageElement>();
    this.usedPowerUps = new Map<PowerUpModel, ImageElement>();
    this.flyingPowerUps = new Map<PowerUpModel, ImageElement>();
    this.beaterElement = null;
  }

  /**
   * GETTER
   */
  DivElement getMoveLeftButton() {
    return this.moveLeftButton;
  }

  DivElement getMoveRightButton() {
    return this.moveRightButton;
  }

  DivElement getStartButton() {
    return this.startButton;
  }

  /**
   * METHODS
   */
  /**
   * Setzt die Levelnummer
   * @param id Levelnummer
   */
  void setLevelNumber(int id) {
    this.levelIDPlaceholder.text = "$id";
  }

  /**
   * Entfernt den Ball
   * @param ball Ball
   */
  void removeBall(BallModel ball) {
    this.removeElement(ball, this.balls);
  }

  /**
   * Entfernt das PowerUp
   * @param powerUp PowerUp
   */
  void removePowerUp(PowerUpModel powerUp) {
    this.removeElement(powerUp, this.flyingPowerUps);
  }

  /**
   * Entfernt den Stein
   * @param brick Stein
   */
  void removeBrick(BrickModel brick) {
    this.removeElement(brick, this.bricks);
  }

  /**
   * Aktuallisiert alle Elemente der LevelView in einem Zeitintervall
   */
  Future update() async {
    super.update();
    this
      ..setBackground()
      ..updateBeater()
      ..updateBalls()
      ..updateFlyingPowerUps()
      ..updateUsedPowerUps()
      ..updateBrick()
      ..setLevelNumber(this.model.levelID)
      ..setScore(this.player.getScore())
      ..setLives(this.player.getLives())
    ;
  }

  /**
   * Alle Steine werden im Spielfeld platziert
   */
  void placeBricks() {
    this.model.getBricks().forEach((brick) {
      if (!this.bricks.containsKey(brick)) {
        // den Ball gibt es nicht als Element!
        this.add(this.createBrickElement(brick));
      }
    });
  }

  /**
   * Aktuallisiert die fallenden PowerUps
   */
  Future updateFlyingPowerUps() async {
    this.model.getFlyingPowerUps().forEach((powerUp) {
      if (!this.flyingPowerUps.containsKey(powerUp)) {
        // den Ball gibt es nicht als Element!
        this.add(this.createFlyingPowerUpElement(powerUp));
      }
    });
    await this.updateEach(this.model.getFlyingPowerUps(), this.flyingPowerUps);
  }

  /**
   * Aktuallisiert die benutzten PowerUps
   */
  void updateUsedPowerUps() {
    this.model.getUsedPowerUps().forEach((powerUp) {
      if (!this.usedPowerUps.containsKey(powerUp)) {
        // den Ball gibt es nicht als Element!
        this.powerUpsFrame.append(this.createUsedPowerUpElement(powerUp));
      }
    });
    this.updateEach(this.model.getUsedPowerUps(), this.usedPowerUps);
  }

  /**
   * Aktuallisiert die Position und die Groesse des Schlaegers
   */
  void updateBeater() {
    if (this.model.getBeater() != null && this.beaterElement != null) {
      this.place(this.model.getBeater(), this.beaterElement);
      this.updateSize(this.model.getBeater(), this.beaterElement);
    }
  }

  /**
   * Aktuallisiert die Baelle
   */
  void updateBalls() {
    this.model.getBalls().forEach((ball) {
      if (!this.balls.containsKey(ball)) {
        // den Ball gibt es nicht als Element!
        this.add(this.createBallElement(ball));
      }
    });

    this.updateEach(this.model.getBalls(), this.balls);
  }

  /**
   * Aktuallisiert die Steine, um bei treffern eine Reaktion zu erkennen
   */
  Future updateBrick() async {
    this.model.getBricks().forEach((brick) async {
      if (brick.destroyed) {
        this.bricks[brick].src = "graphic/brick_" + brick.getColor() + "_" +
            brick.getStrength().toString() + ".png";
        brick.destroyed = false;
      }
    });
    this.bricks.forEach((brick, brickElement) async {
      if (!this.model.getBricks().contains(brick)) {
        await this.removeBrick(brick);
      }
    });
  }

  /**
   * Erstellt einen Schlaeger
   * @return Das Schlaegerelement
   */
  ImageElement createBeaterElement() {
    this.beaterElement = document.createElement("img");
    this.beaterElement.src = "graphic/plattform.png";
    this.beaterElement.id = "plattform";
    this.updateElement(this.model.getBeater(), this.beaterElement);
    return this.beaterElement;
  }

  /**
   * Erstellt ein Steinelement
   * @param brick Stein
   * @return Das Steinelement
   */
  ImageElement createBrickElement(BrickModel brick) {
    ImageElement brickElement = document.createElement("img");

    brickElement.src = "graphic/brick_" + brick.getColor() + "_" +
        brick.getStrength().toString() + ".png";
    brickElement.className = "brick";
    this.updateElement(brick, brickElement);
    this.bricks.putIfAbsent(brick, () => brickElement);
    return brickElement;
  }

  /**
   * Erstellt ein Ballelement
   * @param ball Ball
   * @return Das Ballelement
   */
  ImageElement createBallElement(BallModel ball) {
    ImageElement ballElement = document.createElement("img");
    if (ball is BombBall) {
      ballElement.src = "graphic/bombBall.png";
    } else {
      ballElement.src = "graphic/ball.png";
    }

    ballElement.id = "ball";
    this.balls.putIfAbsent(ball, () => ballElement);
    return ballElement;
  }

  /**
   * Erstellt einen Button zum Bewegen des Schlaegers nach links
   * @return Das Buttonelement
   */
  DivElement createMoveLeftButton() {
    this.moveLeftButton = new DivElement();
    this.moveLeftButton.classes.add("touchButton");
    this.moveLeftButton.id = "moveLeftButton";
    return this.moveLeftButton;
  }

  /**
   * Erstellt einen Button zum Bewegen des Schlaegers nach rechts
   * @return Das Buttonelement
   */
  DivElement createMoveRightButton() {
    this.moveRightButton = new DivElement();
    this.moveRightButton.classes.add("touchButton");
    this.moveRightButton.id = "moveRightButton";
    return this.moveRightButton;
  }

  /**
   * Erstellt einen Button zum Starten des Spieles
   * @return Das StartButtonelement
   */
  DivElement createStartButton() {
    this.startButton = new DivElement();
    this.startButton.classes.add("touchButton");
    this.startButton.id = "startButton";
    return this.startButton;
  }

  /**
   * Erstellt ein fallendes PowerUpElement
   * @param powerUp PowerUp
   * @return das PowerUpElement
   */
  ImageElement createFlyingPowerUpElement(PowerUpModel powerUp) {
    ImageElement powerUpElement = document.createElement("img");
    powerUpElement.src = this.getPowerUpSrc(powerUp);
    powerUpElement.className = "brick";
    place(powerUp, powerUpElement);

    this.flyingPowerUps.putIfAbsent(powerUp, () => powerUpElement);
    return powerUpElement;
  }

  /**
   * Gibt die BildDatei des PowerUps zurueck
   * @param powerUp PowerUp
   * @return Das Verzeichnis des Bildes
   */
  String getPowerUpSrc(PowerUpModel powerUp) {
    switch (powerUp.getKey()) {
      case PowerUpModel.BIGGER_BEATER :
        return "graphic/biggerBeaterPowerUp.gif";
      case PowerUpModel.MAGNETIC_BEATER :
        return "graphic/magnetBeaterPowerUp.png";
      case PowerUpModel.BALL_x3 :
        return "graphic/ball3PowerUp.png";
      case PowerUpModel.LIVE :
        return "graphic/livePowerUp.png";
      case PowerUpModel.BIGGER_BALL :
        return "graphic/biggerBallPowerUp.png";
      case PowerUpModel.DOUBLE_SCORE :
        return "graphic/doubleScorePowerUp.png";
      case PowerUpModel.REMOVELIVE :
        return "graphic/reduceLivesPowerUp.png";
      case PowerUpModel.BOMB_BALL :
        return "graphic/bombBallPowerUp.png";
      default :
        return "";
    }
  }

  /**
   * Erstellt ein PowerUp das benutzt wird
   * @param powerUp PowerUp
   * @return Das PowerUpElement
   *
   */
  ImageElement createUsedPowerUpElement(PowerUpModel powerUp) {
    ImageElement powerUpElement = document.createElement("img");
    powerUpElement.src = this.getPowerUpSrc(powerUp);
    this.usedPowerUps.putIfAbsent(powerUp, () => powerUpElement);
    return powerUpElement;
  }

  /**
   * Zeichnet auf dem Spielfeld die Buttons, Steine und den Schlaeger
   */
  void drawDefault() {
    this.levelInformation.style.display = "block";

    DivElement touchButtons = new DivElement();
    touchButtons.id = "touchButtons";
    touchButtons.style.width = this.getWidth().toString() + "px";
    touchButtons.style.height = this.getHeight().toString() + "px";
    touchButtons..append(this.createMoveLeftButton())..append(
        this.createMoveRightButton())..append(this.createStartButton());

    this
      ..placeBricks()
      ..add(this.createBeaterElement())..add(touchButtons)
    ;
  }

  /**
   * Setzt den Punktestand
   * @param score Punktestand
   */
  void setScore(int score) {
    scorePlaceHolder.text = score.toString();
  }

  /**
   * Setzt die Lebenspunkte
   * @param lives Leben
   */
  void setLives(int lives) {
    livesPlaceHolder.text = lives.toString();
  }

  /**
   * die Map leeren und fuer den neuen Level vorbereiten
   */

  void setBackground() {
    this.mainFrame.style.backgroundImage = "url(" + this.model.background + ")";
  }
}