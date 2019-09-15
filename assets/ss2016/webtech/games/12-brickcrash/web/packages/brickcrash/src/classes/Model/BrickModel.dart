part of brickcrash;
/**
 * Im BrickModel wird ein Stein mit einer Farbe und einer Staerke ersellt.
 * Dieser kann auch per Zufall ein PowerUp erhalten.
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */
class BrickModel extends DOMObject {
  LevelModel level;
  PowerUpModel powerUp = null;
  int strength;               // Staerke des Steines
  String color  = "Y";
  int powerUpNum = 8;         // Anzahl der PowerUps, die es gibt
  int points;                 //Punkte die man durch die Zerstoerung bekommen kann
  Random random         = new Random();
  bool destroyed        = false;

  /*
    CONSTRUCTOR
   */
  /**
   * BrickModel-Konstruktor<br>
   * @param LevelModel LevelModel - Instanz
   * @param String color Farbe: <br>
   *   B = blue<br>
   *   Y = yellow<br>
   *   R = red<br>
   *   G = green<br>
   *   Z = gray
   *   K = Black
   *   V = Violet
   *   O = Orange
   *   W = White
   */
  BrickModel(LevelModel level,String color){
    this.level  = level;
    this.color  = color;
    this  ..setHeight(25)
          ..setWidth(45);

    // Default-Staerke einstellen
    switch(this.color) {
      case "Y" :      this.strength = 1;      this.points = 2;      break;
      case "W" :      this.strength = 1;      this.points = 2;      break;
      case "K" :      this.strength = 1;      this.points = 2;      break;
      case "V" :      this.strength = 1;      this.points = 2;      break;
      case "O" :      this.strength = 1;      this.points = 2;      break;
      case "G" :      this.strength = 2;      this.points = 6;      break;
      case "R" :      this.strength = 3;      this.points = 12;     break;
      case "B" :      this.strength = 4;      this.points = 16;     break;
      case "Z" :      this.strength = 5;      this.points = 20;     break;
    }
  }

  /*
    SETTER
   */
  void setPoints(int points)                      { this.points = points; }
  void setPowerUp(PowerUpModel powerUp)           { this.powerUp = powerUp; }
  void setStrength(int strength)                  { this.strength=strength; }
  /*
    GETTER
   */
  int getPoints()                                 { return this.points; }
  PowerUpModel getPowerUp()                       { return this.powerUp; }
  String getColor()                               { return this.color; }
  int getStrength()                               { return this.strength; }

  /**
   * diesen Brick einen zufaelligen PowerUp zuweisen
   * @param probability Wahrscheinlichkeit fuer ein PowerUp
   */
  void setRandomPowerUp(int probability) {
    if (this.random.nextInt(100) + 1 <= probability) {
      this.setPowerUp(
          new PowerUpModel(this.level, this.random.nextInt(this.powerUpNum))
            ..setXPosition(x)
            ..setYPosition(y)
      );
    }
  }

  /**
   * Auf die Kollision wird mit dieser Methode entsprechend reagiert
   * @param int strength Kollision-Staerke
   */
  Future reactOnCollision(int strength) async {
    if (strength > this.strength) {
      strength = this.strength;
    }

    this.destroyed = true;

    this.level.addScore(strength * (this.points / this.strength).floor());
    this.strength -= strength;

    if (this.strength == 0) {
      // der Brick wird zerstoert
      this.level.removeBrick(this);

      if (this.powerUp != null) {
        level.addFlyingPowerUp(this.powerUp);
        this.powerUp.startMoving(powerUp.move);
      }
    }
  }
}