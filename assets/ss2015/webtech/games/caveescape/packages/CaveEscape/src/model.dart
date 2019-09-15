part of CaveEscape;

/**Die Klasse GameObject enthält alles, was Objekte im Spiel allgemein benötigen. */
abstract class GameObject {
  final CaveGame _game;

  /**Field Row*/
  num _row;
  num get row => _row;

  void setRow(int n) {
    _row = n;
  }

  /**Field Column*/
  num _column;
  num get column => _column;

  void setColumn(int n) {
    _column = n;
  }

  /**Object Style*/
  Symbol _style;
  Symbol get style => _style;

  GameObject.on(this._game);

  /**
   * Methode, um das Objekt auf dem Spielfeld zu bewegen.
   */
  move();
}

/**
 * Die Klasse MoveableObject erweitert GameObject um Methoden, die nur für Gegenstände des Spiels verwendet werden.
 */
abstract class MoveableObject extends GameObject {
  MoveableObject.on(CaveGame game) : super.on(game) {
    _row = 0;
  }
  /**
   * Methode, um die objektspezifische Aktion auszulösen.
   */
  action();

  /**
   * Factory zum Erzeugen eines MoveableObjects über einen String.
   */
  static MoveableObject getInstanceOf(String name, CaveGame game) {
    switch (name) {
      case ("YellowCoin"):
        return new YellowCoin.on(game);
      case ("BlueCoin"):
        return new BlueCoin.on(game);
      case ("RedCoin"):
        return new RedCoin.on(game);
      case ("PurpleCoin"):
        return new PurpleCoin.on(game);
      case ("Rock"):
        return new Rock.on(game);
      case ("Hole"):
        return new Hole.on(game);
      case ("Bat"):
        return new Bat.on(game);
      case ("Rat"):
        return new Rat.on(game);
      case ("DrunkenRat"):
        return new DrunkenRat.on(game);
      case ("PowerUp_Multiplier"):
        return new PowerUp_Multiplier.on(game);
      case ("PowerUp_LifeUp"):
        return new PowerUp_LifeUp.on(game);
      case ("PowerUp_CoinGathering"):
        return new PowerUp_CoinGathering.on(game);
      case ("PowerUp_OnlyCoins"):
        return new PowerUp_OnlyCoins.on(game);
      case ("PowerUp_CoinMagnet"):
        return new PowerUp_CoinMagnet.on(game);
      case ("PowerDown_Multiplier"):
        return new PowerDown_Multiplier.on(game);
      default:
        return null;
    }
  }

  /**
   * Factory zum Abrufen der Objektbeschreibung über einen String.
   */
  static String getDescriptionOf(String name) {
    var ret;
    switch (name) {
      case ("YellowCoin"):
        ret = YellowCoin.description();
        break;
      case ("BlueCoin"):
        ret = BlueCoin.description();
        break;
      case ("RedCoin"):
        ret = RedCoin.description();
        break;
      case ("PurpleCoin"):
        ret = PurpleCoin.description();
        break;
      case ("Rock"):
        ret = Rock.description();
        break;
      case ("Hole"):
        ret = Hole.description();
        break;
      case ("Bat"):
        ret = Bat.description();
        break;
      case ("Rat"):
        ret = Rat.description();
        break;
      case ("DrunkenRat"):
        ret = DrunkenRat.description();
        break;
      case ("PowerUp_Multiplier"):
        ret = PowerUp_Multiplier.description();
        break;
      case ("PowerUp_LifeUp"):
        ret = PowerUp_LifeUp.description();
        break;
      case ("PowerUp_CoinGathering"):
        ret = PowerUp_CoinGathering.description();
        break;
      case ("PowerUp_OnlyCoins"):
        ret = PowerUp_OnlyCoins.description();
        break;
      case ("PowerUp_CoinMagnet"):
        ret = PowerUp_CoinMagnet.description();
        break;
      case ("PowerDown_Multiplier"):
        ret = PowerDown_Multiplier.description();
        break;
      default:
        ret = "TEXT_MUST_BE_WRITTEN";
        break;
    }
    return ret != null ? ret.toString() : "description() is missing";
  }

  /**
   * Methode zum Entfernen eines MoveableObjects vom CaveGame
   */
  static void kickMeOut(MoveableObject mo, CaveGame game) {
    game.moveableObjects.removeWhere((object) {
      return object == mo;
    });
  }
  /**
   * Methode zum Aufrufen der action()-Methode eines MoveableObjects vom CaveGame.
   * action() wird nur bei Collision mit einem Player-Objekt ausgeführt.
   */
  static void actionIfNecessary(MoveableObject mo, CaveGame game) {
    if (mo.row == game.player.row && mo.column == game.player.column) {
      mo.action();
      MoveableObject.kickMeOut(mo, game);
    }
  }
}

/**
 * Die Klasse PlayableObject erweitert GameObject um Methoden für spielbare Charaktere.
 */
abstract class PlayableObject extends GameObject {
  PlayableObject.on(CaveGame game) : super.on(game) {
    _style = #Player;
  }

  /**
   * Bewegt das Objekt nach rechts.
   */
  moveLeft();
  /**
   * Bewegt das Objekt nach links.
   */
  moveRight();
}

/**
 * ##########################################################################################
 *                                        Player Implementationen
 * ##########################################################################################
 */

/**
 * PlayableObject-Implementation, die sich indirekt bewegen kann.
 * Für die Bewegung wird eine Richtung gesetzt und mit einem Timer ausgelöst.
 */
class IndirectlyPlayer extends PlayableObject {
  IndirectlyPlayer.on(CaveGame game) : super.on(game) {
    final r = _game.rowSize - 1;
    final c = _game.columnSize - 1;
    _row = r;
    _column = c ~/ 2;
  }

  /* Movement direction #none #left or #right*/
  Symbol _direction = #none;

  @override
  moveLeft() {
    if (_column > 1) _direction = #left;
    else _direction = #none;
  }

  @override
  moveRight() {
    if (_column < _game.columnSize - 2) _direction = #right;
    else _direction = #none;
  }

  @override
  move() {
    if (_direction == #none) return;
    else if (_direction == #left) {
      _column -= 1;
      _direction = #none;
    } else if (_direction == #right) {
      _column += 1;
      _direction = #none;
    } else {
      _direction = #none;
    }
  }
}
/*Spieler welcher sich direkt bewegt*/
class DirectlyPlayer extends PlayableObject {
  DirectlyPlayer.on(CaveGame game) : super.on(game) {
    final r = _game.rowSize - 1;
    final c = _game.columnSize - 1;
    _row = r;
    _column = c ~/ 2;
  }

  /**
   * Getriggerte Bewegung bewirkt nichts.
   */
  move() {}

  /**
   * Bewegt den Spieler direkt nach rechts.
   */
  moveRight() {
    if (!this._game.running) return;
    if (_column < _game.columnSize - 2) _column += 1;
    actionAfterMove();
  }
  /**
   * Bewegt den Spieler direkt nach links.
   */
  moveLeft() {
    if (!this._game.running) return;
    if (_column > 1) _column -= 1;
    actionAfterMove();
  }
  /**
   * Überprüft auf Collision mit MoveableObjects.
   */
  actionAfterMove() {
    var list = new List.from(this._game._moveableObjects);
    list.forEach((object) {
      if (object.row == _row && object.column == _column) {
        object.action();
      }
    });
    _game.moveableObjects.removeWhere((object) {
      return object.row == _row && object.column == _column;
    });
  }
}

/**
 * ##########################################################################################
 *                                        Coins
 * ##########################################################################################
 */

/**
 * Die Klasse Coin erweitert MoveableObject um Methoden und Datenfelder, die für alle Coins benötigt werden.
 */
abstract class Coin extends MoveableObject {
  Coin.on(CaveGame game) : super.on(game);
  int _pvalue;

  @override
  /**
   * Erhöht die Punkte um den Punktewert der Coin, multipliziert mit dem Multiplier.
   */
  action() {
    _game.incPoints(_pvalue * _game.multiplier);
  }
}

/**
 * Coin-Implementation mit einem Value von 1.
 * Bewegt sich um 1 Reihe vertikal nach unten.
 */
class YellowCoin extends Coin {
  YellowCoin.on(CaveGame game) : super.on(game) {
    _style = #YellowCoin;
    _pvalue = 1;
  }

  @override
  /**
   * Vertikale Bewegung um eine Reihe nach unten.
   */
  move() {
    if (this._game.isEmpty(this.row + 1, this._column)) _row += 1;
    MoveableObject.actionIfNecessary(this, _game);
  }

  /**
   * Beschreibung
   */
  static String description() {
    return "A yellow coin with a value of 1 point.";
  }
}

/**
 * Coin-Implementation mit einem Value von 3.
 * Bewegt sich diagonal nach unten.
 */
class BlueCoin extends Coin {
  BlueCoin.on(CaveGame game) : super.on(game) {
    _style = #BlueCoin;
    _pvalue = 3;
  }

  Symbol direction = #right;

  @override
  /**
   * Diagonale Bewegung
   */
  move() {
    //im unteren Bereich nichtmehr diagonal bewegen, damit Spieler chance hat einzusammeln
    if (this.row > this._game.rowSize - 6) {
      this._row++;
      MoveableObject.actionIfNecessary(this, _game);
      return;
    }

    //diagnonal Bewegung wenn möglich
    if (this.direction == #rechts) {
      if (this._game.isEmpty(this.row + 1, this._column + 1) &&
          !(this._column + 1 >= this._game._columnSize - 1)) {
        this.moveRight();
        MoveableObject.actionIfNecessary(this, _game);
        return;
      } else if (this._game.isEmpty(this.row + 1, this._column - 1)) {
        this.direction = #links;
        this.moveLeft();
        MoveableObject.actionIfNecessary(this, _game);
        return;
      }
    } else {
      if (this._game.isEmpty(this.row + 1, this._column - 1) &&
          !(this._column - 1 <= 0)) {
        this.moveLeft();
        MoveableObject.actionIfNecessary(this, _game);
        return;
      } else if (this._game.isEmpty(this.row + 1, this._column + 1)) {
        this.direction = #rechts;
        this.moveRight();
        MoveableObject.actionIfNecessary(this, _game);
        return;
      }
    }
    //Falls diagonal nicht klappte, dann versuch runter, sonst beweg dich garnicht.
    if (this._game.isEmpty(this.row + 1, this._column)) {
      this._row++;
      MoveableObject.actionIfNecessary(this, _game);
      return;
    }
  }

  /**
   * Bewegung nach links
   */
  void moveLeft() {
    this._column--;
    this._row++;
  }
  /**
   * Bewegung nach rechts
   */
  void moveRight() {
    this._column++;
    this._row++;
  }

  /**
   * Beschreibung
   */
  static String description() {
    return "A blue coin with a value of 3 points.";
  }
}

/**
 * Coin-Implementation mit einem Value von 5.
 * Bewegt sich um 2 Reihen vertikal nach unten.
 */
class RedCoin extends Coin {
  RedCoin.on(CaveGame game) : super.on(game) {
    _style = #RedCoin;
    _pvalue = 5;
  }

  @override
  /**
   * Vertikale Bewegung. Überspringt eine Reihe wenn möglich.
   */
  move() {
    //Bewegt sich wenn möglich 2 Felder statt nur einem nach unten
    if (this.row > this._game.rowSize - 6) {
      this._row++;
      MoveableObject.actionIfNecessary(this, _game);
      return;
    }
    if (this._game.isEmpty(this.row + 2, this._column)) _row += 2;
    else if (this._game.isEmpty(this.row + 1, this._column)) _row++;
    MoveableObject.actionIfNecessary(this, _game);
  }

  /**
   * Beschreibung
   */
  static String description() {
    return "A red coin with a value of 5 points.";
  }
}

/**
 * Coin-Implementation mit einem Value von 10.
 * Bewegt sich nach unten. Versucht dem Spieler auszuweichen.
 */
class PurpleCoin extends Coin {
  PurpleCoin.on(CaveGame game) : super.on(game) {
    _style = #PurpleCoin;
    _pvalue = 10;
  }

  @override
  /**
   * Bewegt sich ausweichend.
   */
  move() {
    //Spieler ausweichend verhaltent
    if (this.row > this._game.rowSize - 6) {
      this._row++;
      MoveableObject.actionIfNecessary(this, _game);
      return;
    }
    if (this._column > this._game._player._column &&
        this._game.isEmpty(this._row + 1, this._column + 1)) {
      this._column++;
      this._row++;
    } else if (this._column < this._game._player._column &&
        this._game.isEmpty(this._row + 1, this._column - 1)) {
      this._column--;
      this._row++;
    } else if (this._column < this._game._columnSize / 2 &&
        this._game.isEmpty(this._row + 1, this._column + 1)) {
      this._column++;
      this._row++;
    } else if (this._game.isEmpty(this._row + 1, this._column - 1)) {
      this._column--;
      this._row++;
    } else if (this._game.isEmpty(this._row + 1, this._column)) {
      this._row++;
    }
    MoveableObject.actionIfNecessary(this, _game);
  }

  /**
   * Beschreibung.
   */
  static String description() {
    return "A purple coin with a value of 10 points.";
  }
}

/**
 * ##########################################################################################
 *                                        Hindernisse
 * ##########################################################################################
 */

/**
 * Die Klasse Barrier erweitert MoveableObject um Methoden, die für alle Hindernisse benötigt werden.
 */
abstract class Barrier extends MoveableObject {
  Barrier.on(CaveGame game) : super.on(game);

  /**
   * Die action() Methode verringert das Leben des Spielers um 1
   */
  @override
  action() {
    _game.decLifes(1);
  }
}

/**
 * Barrier-Implementation. Bewegt sicht vertikal nach unten.
 */
class Rock extends Barrier {
  Rock.on(CaveGame game) : super.on(game) {
    _style = #Rock;
  }

  @override
  move() {
    if (this._game.isEmpty(this.row + 1, this._column)) _row += 1;
    MoveableObject.actionIfNecessary(this, _game);
  }

  static String description() {
    return "A rock. A collision with it hurts. Autsch!";
  }
}

/**
 * Barrier-Implementation. Bewegt sicht vertikal nach unten.
 * Die action()-Methode ist überschrieben, es werden die Leben auf 0 gesetzt.
 */
class Hole extends Barrier {
  Hole.on(CaveGame game) : super.on(game) {
    _style = #Hole;
  }

  @override
  action() {
    _game._lifes = 0;
  }

  @override
  move() {
    if (this._game.isEmpty(this.row + 1, this._column)) _row += 1;
    MoveableObject.actionIfNecessary(this, _game);
  }

  static String description() {
    return "A hole in the ground. A friend has entered one. Never heard of him again.";
  }
}

/**
 * Barrier-Implementation. Bewegt sich ausweichend nach unten.
 */
class Bat extends Barrier {
  Bat.on(CaveGame game) : super.on(game) {
    _style = #Bat;
  }

  @override
  move() {
/**
 * Spieler ausweichend verhaltent
 */
    if (this.row > this._game.rowSize - 6) {
      this._row++;
      MoveableObject.actionIfNecessary(this, _game);
      return;
    }
    if (this._column > this._game._player._column &&
        this._game.isEmpty(this._row + 1, this._column + 1)) {
      this._column++;
      this._row++;
    } else if (this._column < this._game._player._column &&
        this._game.isEmpty(this._row + 1, this._column - 1)) {
      this._column--;
      this._row++;
    } else if (this._column < this._game._columnSize / 2 &&
        this._game.isEmpty(this._row + 1, this._column + 1)) {
      this._column++;
      this._row++;
    } else if (this._game.isEmpty(this._row + 1, this._column - 1)) {
      this._column--;
      this._row++;
    } else if (this._game.isEmpty(this._row + 1, this._column)) {
      this._row++;
    }
    MoveableObject.actionIfNecessary(this, _game);
  }

  static String description() {
    return "A bat. It tries to avoid you. You should try it too.";
  }
}

/**
 * Barrier-Implementation. Bewegt sich nach unten und auf den Spieler zu.
 */
class Rat extends Barrier {
  Rat.on(CaveGame game) : super.on(game) {
    _style = #Rat;
  }

  @override
  move() {
    /**
     * verhählt sich auf den spieler zu
     */
    if (this.row > this._game.rowSize - 6) {
      this._row++;
      MoveableObject.actionIfNecessary(this, _game);
      return;
    }
    if (this._column > this._game._player._column &&
        this._game.isEmpty(this._row + 1, this._column - 1)) {
      this._column--;
      this._row++;
    } else if (this._column < this._game._player._column &&
        this._game.isEmpty(this._row + 1, this._column + 1)) {
      this._column++;
      this._row++;
    } else if (this._game.isEmpty(this._row + 1, this._column)) {
      this._row++;
    }
    MoveableObject.actionIfNecessary(this, _game);
  }

  static String description() {
    return "A rat. Looks like he got rabies! Run!";
  }
}

/**
 * Barrier-Implementation. Bewegt sich nach links , rechts oder garnicht.
 */
class DrunkenRat extends Barrier {
  DrunkenRat.on(CaveGame game) : super.on(game) {
    _style = #DrunkenRat;
  }

  @override
  move() {
    if (this.row > this._game.rowSize - 6) {
      this._row++;
      MoveableObject.actionIfNecessary(this, _game);
      return;
    }
    //Bewegt sich random nach Links, Rechts oder garnicht
    int rand = new Random().nextInt(3);
    switch (rand) {
      case 1:
        this.moveLeftIfPossible();
        break;
      case 2:
        if (this._game.isEmpty(this.row + 1, this._column)) this._row++;
        break;
      case 3:
        this.moveRightIfPossible();
        break;
    }
    MoveableObject.actionIfNecessary(this, _game);
  }
  moveLeftIfPossible() {
    if (this._game.isEmpty(this._row + 1, this._column - 1)) {
      this._row++;
      this._column--;
    } else if (this._game.isEmpty(this._row + 1, this._column)) this._row++;
  }
  moveRightIfPossible() {
    if (this._game.isEmpty(this._row + 1, this._column + 1)) {
      this._row++;
      this._column++;
    } else if (this._game.isEmpty(this._row + 1, this._column)) this._row++;
  }

  static String description() {
    return "A drunken rat that is lurching around. Its way is unpredictable.  ";
  }
}

/**
 * ##########################################################################################
 *                                        Power - abstract classes
 * ##########################################################################################
 */

/**
 * Die Klasse Power erweitert MoveableObjects um Methoden, die für alle Power-Implementationen benötigt werden.
 * PowerUp's und PowerDown's bewegen sich vertikal um eine Reihe nach unten.
 */
abstract class Power extends MoveableObject {
  Power.on(CaveGame game) : super.on(game);

  @override
  /**
   * vertikale Bewegung um eine eine nach unten.
   */
  move() {
    if (this._game.isEmpty(this.row + 1, this._column)) _row += 1;
    MoveableObject.actionIfNecessary(this, _game);
  }
}

/**
 * Schnittstelle für PowerUp's
 */
abstract class PowerUp extends Power {
  PowerUp.on(CaveGame game) : super.on(game);
}

/**
 * Schnittstelle für PowerDown's
 */
abstract class PowerDown extends Power {
  PowerDown.on(CaveGame game) : super.on(game);
}

/**
 * ##########################################################################################
 *                                        PowerUp's
 * ##########################################################################################
 */

/**
 * PowerUp-Implementation. Erhöht den Multiplier.
 */
class PowerUp_Multiplier extends PowerUp {
  PowerUp_Multiplier.on(CaveGame game) : super.on(game) {
    _style = #PowerUp_Multiplier;
  }

  @override
  /**
   * Multiplier um 1 erhöhen
   */
  action() {
    _game.incMultiplier(1);
  }

  static String description() {
    return "A mystic power that increases the multiplier and your speed.";
  }
}

/**
 * PowerUp-Implementation. Erhöht die Leben.
 */
class PowerUp_LifeUp extends PowerUp {
  PowerUp_LifeUp.on(CaveGame game) : super.on(game) {
    _style = #PowerUp_LifeUp;
  }

  @override
  /**
   * Leben um 1 erhöhen.
   */
  action() {
    _game.incLifes(1);
  }

  static String description() {
    return "A mystic power that increases your chances to survive.";
  }
}

/**
 * PowerUp-Implementation. Ersetzt alles, was nicht Coin ist, durch YellowCoin-Objekte.
 */
class PowerUp_OnlyCoins extends PowerUp {
  PowerUp_OnlyCoins.on(CaveGame game) : super.on(game) {
    _style = #PowerUp_OnlyCoins;
  }

  @override
  /**
   * Ersetze alles !Coin mit YellowCoin.
   */
  action() {
    final list = new List.from(this._game._moveableObjects);
    list.forEach((object) {
      if (!(object is Coin) && !(object is PowerUp)) {
        final row = object.row;
        final col = object.column;
        YellowCoin coin = new YellowCoin.on(_game);
        coin.setColumn(col);
        coin.setRow(row);
        this._game._moveableObjects.add(coin);
      }
    });
    this._game._moveableObjects.removeWhere((object) {
      return !(object is Coin);
    });
  }

  static String description() {
    return "A mystic power that transforms foes into coins.";
  }
}

/**
 * PowerUp-Implementation. Sammelt alle Coin-Objekte ein.
 */
class PowerUp_CoinGathering extends PowerUp {
  PowerUp_CoinGathering.on(CaveGame game) : super.on(game) {
    _style = #PowerUp_CoinGathering;
  }

  @override
  /**
   * Löst für alle Coin-Objekte die action()-Methode aus.
   * Entfernt diese danach.
   */
  action() {
    final list = new List.from(this._game._moveableObjects);
    list.forEach((object) {
      if ((object is Coin)) {
        object.action();
      }
    });
    this._game._moveableObjects.removeWhere((object) {
      return object is Coin;
    });
  }

  static String description() {
    return "A mystic power that gathers all coins for you. Jackpot! ";
  }
}

/**
 * PowerUp-Implementation. Sammelt Coin in einem Radius von 1/6 der Spielfeld-Breite ein.
 * Alles, was nicht Coin ist, wird entfernt.
 * Aufgabe Praktikum.
 */
class PowerUp_CoinMagnet extends PowerUp {
  PowerUp_CoinMagnet.on(CaveGame game) : super.on(game) {
    _style = #PowerUp_CoinMagnet;
  }

  @override
  /**
   * Spanne ein Rechteck auf mit maximaler Kantenlänge von 1/3 der Breite des Spielfeldes.
   * Mittelpunkt ist der Spieler.
   * Löse für Coin's die action()-Methode aus. Entferne danach alle Objekte in dem Rechteck.
   */
  action() {
    int radius = (_game.columnSize - 2) ~/ 6;

    int min_row = (_game.player.row) - radius;
    int max_row = (_game.player.row) + radius;
    int min_col = (_game.player.column) - radius;
    int max_col = (_game.player.column) + radius;

    min_row = min_row < 0 ? 0 : min_row;
    max_row = max_row > _game.rowSize - 1 ? _game.rowSize - 1 : max_row;
    min_col = min_col < 1 ? 1 : min_col;
    max_col = max_col > _game.columnSize - 2 ? _game.columnSize - 2 : max_col;

    final list = new List.from(this._game._moveableObjects);
    list.retainWhere((object) => object.row >= min_row &&
        object.row <= max_row &&
        object.column >= min_col &&
        object.column <= max_col);
    list.forEach((object) {
      if (object is Coin) {
        object.action();
      }
    });
    _game.moveableObjects.removeWhere((object) => list.contains(object));
  }

  static String description() {
    return "A mystic power that gathers all coins around you and eliminates all foes.";
  }
}

/**
 * ##########################################################################################
 *                                        PowerDown's
 * ##########################################################################################
 */

/**
 * PowerDown-Implementation. Verringert den Multiplier.
 */
class PowerDown_Multiplier extends PowerDown {
  PowerDown_Multiplier.on(CaveGame game) : super.on(game) {
    _style = #PowerDown_Multiplier;
  }

  @override
  /**
   * Verringert den Multiplier um 1.
   */
  action() {
    _game.decMultiplier(1);
  }

  static String description() {
    return "A mystic power that decreases your muliplier and speed.";
  }
}

/**
 * ##########################################################################################
 *                                        CaveGame
 * ##########################################################################################
 */

/**
 * Die Klasse CaveGame hält alle Zustände des Modells.
 * Hat Methoden und Datenfelder, die für das Verwalten und zugreifen auf das Spiel notwendig sind.
 */
class CaveGame {
  /* playable instance */
  PlayableObject _player;
  /* list of moveable instances */
  var _moveableObjects = [];

  /**
   * Anzahl rows
   */
  int _rowSize;
  int get rowSize => _rowSize;
  /**
   * Anzahl Columns
   */
  int _columnSize;
  int get columnSize => _columnSize;

  /*#running , #stopped */
  Symbol _gamestate = #stopped;

  //Levelangaben
  List<Level> _levels = [];
  int _levelIndex = 0;
  int maxLevel;
  Level _level;

  ///Punkte
  int _points = 0;
  //Leben
  int _lifes = 0;
  //Multiplier
  int _multiplier = 1;

  //Gamestates
  bool get stopped => _gamestate == #stopped;
  bool get running => _gamestate == #running;
  bool get paused => _gamestate == #paused;
  bool get gameOver => lifes <= 0;
  void start() {
    _gamestate = #running;
  }
  void stop() {
    _gamestate = #stopped;
  }
  void pause() {
    _gamestate = #paused;
  }

  /**
  * Konstruktor. Lädt Level, setzt Spieler und das erste Level.
  */
  CaveGame() {
    this.loadData().then((_) {
      _player = new DirectlyPlayer.on(this);
      _level = this._levels[this._levelIndex];
    });
  }

  /**
    * Leert das Spiel und macht es so für einen Neustart bereit
    */
  void clear() {
    this.stop();
    this.loadData().then((_) {
      _player = new DirectlyPlayer.on(this);
      this._levelIndex = 0;
      this._moveableObjects.clear();
      this._points = 0;
      this._multiplier = 1;
      _level = this._levels[this._levelIndex];
    });
  }

  /**
   * True, wenn das Maximum an Punkten für das aktuelle Level erreicht ist
   */
  bool get pointsfull => this._points >= this._level._max_points;

  /** Zeigt auf die SpielerInstanz
   *
   */
  PlayableObject get player => _player;
  /**
   * Zeigt auf die MoveableObjects
   */
  List get moveableObjects => _moveableObjects;

  /**
   * Stellt das Spielfeld als 2D-Liste von Symbolen dar.
   */
  List<List<Symbol>> get field {
    var _field = new Iterable.generate(rowSize, (row) {
      return new Iterable.generate(columnSize,
          (col) => (0 < col && col < columnSize - 1) ? #Empty : #Wall).toList();
    }).toList();
    moveableObjects
        .forEach((object) => _field[object.row][object.column] = object.style);
    _field[player.row][player.column] = player.style;

    return _field;
  }

  /**
   * Setter für Punkte, Leben und Multiplier
   */
  void incPoints(int n) {
    if (running) _points += n;
  }

  void incLifes(int n) {
    if (running) _lifes += n;
  }

  void decLifes(int n) {
    if (running) _lifes -= n;
    if (_lifes <= 0) _lifes = 0;
  }

  void incMultiplier(int n) {
    if (running) _multiplier += n;
  }

  void decMultiplier(int n) {
    if (running) _multiplier -= n;
  }

  /**
   * Getter für Levelname, Punkte, Leben und Multiplier
   */
  String get levelname => _level.name;
  int get points => _points;
  int get lifes => _lifes;
  int get multiplier => _multiplier;

  /**
   * Bewegt SPieler nach links
   */
  void movePlayerLeft() {
    if (running) player.moveLeft();
  }
  /**
   * Bewegt Spieler nach Rechts.
   */
  void movePlayerRight() {
    if (running) player.moveRight();
  }
  /**
   * Bewegt den Spieler
   */
  void movePlayer() {
    if (running) player.move();
  }

  /**
   * Bewegt die Objekte
   */
  void moveObjects() {
    if (running) {
      var moveList = new List<MoveableObject>.from(moveableObjects);
      moveList.forEach((object) => object.move());
      moveableObjects.removeWhere((object) {
        return object.row >= this.rowSize;
      });
    }
  }
  //Prüft ob das gegebene Feld leer ist.
  bool isEmpty(int row, int col) {
    bool empty = true;
    this._moveableObjects.forEach((object) {
      if (object.row == row && object.column == col) {
        empty = false;
      }
    });
    if (this._columnSize - 1 == col ||
        this._rowSize < row ||
        col == 0) empty = false;
    return empty;
  }

  /**
   * Erzeugt zufällig neue Objekte. Die Wahrscheinlichkeit, dass ein bestimmtes Objekt auftritt, ist im aktuellen Level festgelegt.
   */
  void generateObjects() {
    //Überprüft, ob die Zeile 0 gefüllt ist
    //dann sollen keine neuen Objekte generiert werden
    if (!isRowEmpty(0)) {
      return;
    }
    List<MoveableObject> _newObjects = [];
    final r = new Random();
    var data = _level.objectFrequenzy;
    final int max = _level._max_frequenzy;
    var columns = new List();

    //Liste über Columns
    for (int i = 1; i < columnSize - 1; i++) {
      columns.add(i);
    }
    //Zufällig Spalten aussortieren, die sicher kein Objekt bekommen
    //Hälfte aufgerundet bleibt sicher frei
    int len = columns.length ~/ 2;
    for (int i = 0; i < len; i++) {
      columns.removeAt(r.nextInt(columns.length));
    }

    //iteriere über die verbliebenen Spalten.
    //Erzeuge zufällig für diese Objekte. Die Wahrscheinlichkeiten sind verrechnet.
    for (int i in columns) {
      int rand = r.nextInt(max);
      int current = 0;
      var iter = data.iterator;

      bool doing = true;
      while (doing) {
        if (iter.moveNext() == true) {
          current += iter.current.value;
          if (rand <= current) {
            MoveableObject object =
                MoveableObject.getInstanceOf(iter.current.name, this);

            if (object != null) {
              object.setColumn(i);
              _newObjects.add(object);
            }

            doing = false;
          }
        } else {
          doing = false;
        }
      }
    }

    //Füge die neuen Objekte hinzu
    moveableObjects.addAll(_newObjects);
  }

  /**
   * Liste der Namen der Objekte, die im Level verfügbar sind
   */
  List<String> get objectNames {
    return _level.objectNames;
  }

  /**
   * Beschreibung der Klasse name
   */
  String getDescriptionOf(String name) {
    return MoveableObject.getDescriptionOf(name);
  }

  /*Prüft ob eine Row leer von MoveableObjects ist*/
  bool isRowEmpty(int row) {
    var ret = moveableObjects.where((object) => object.row == row).toList();
    //print("@rowEmpty: $ret , row('$row').isEmpty: ${ret.isEmpty}");
    return ret.isEmpty;
  }

  /*Läd alle Constanten Einstellungen sowie die Liste der Level*/
  Future loadData() async {
    String path = await HttpRequest.getString('preferences/option.json');
    Map datas = JSON.decode(path);
    this._lifes = datas["STARTLIFES"];
    this.maxLevel = datas["LEVELZAHL"];
    this._rowSize = datas["ROWSIZE"];
    this._columnSize = datas["COLUMSIZE"];

    for (int i = 1; i <= this.maxLevel; i++) {
      try {
        String levelpath =
            await HttpRequest.getString("preferences/levels/Level$i.json");
        //print(levelpath);
        Map datas = JSON.decode(levelpath);
        //print(datas);
        this._levels.add(Level.loadLevel(datas));
      } catch (Exception) {
        this.maxLevel = i;
        break;
      }
    }
  }
  /*Läd das nächste Level*/
  void loadNextLevel() {
    this._levelIndex++;
    this._level = this._levels[this._levelIndex];
  }
  /*Gibt an, ob ein weiteres Level existiert*/
  bool hasNextLevel() {
    return (this.maxLevel > this._levelIndex + 1);
  }
  int getHighscore() {
    return (this._multiplier + this._lifes * 2) * this.points;
  }

  /**
   * String Repräsentation des Spielfeldes.
   */
  String toString() => field.map((row) => row.join(" ")).join("\n");
}
/**
 * ##########################################################################################
 *                                        Level
 * ##########################################################################################
 */

/**
 * Die Klasse Level enthält Datenfelder und Methoden,
 * die Informationen über das Level aus einer JSON-Datei enthalten und wiedergeben.
 */
class Level {
  String _name;
  int _max_points;
  int _max_frequenzy;
  String get name => _name;

  List<LevelObject> _objectFrequenzy = new List<LevelObject>();
  List<LevelObject> get objectFrequenzy => _objectFrequenzy;

  //Level(this._name, this._max_points, this._max_frequenzy);
  Level(String n, int p, int f) {
    this._name = n;
    this._max_points = p;
    this._max_frequenzy = f;
  }

  /**
   * Test-Konstruktor. Deprecated.
   */
  Level.test() {
    _name = "Test";
    _max_frequenzy = 100;
    _max_points = 5000;
    addLevelObject("YellowCoin", 20);
    //addLevelObject("RedCoin", 5);
    addLevelObject("Rock", 5);
    addLevelObject("Hole", 1);
    addLevelObject("PowerUp_Multiplier", 1);
    addLevelObject("PowerUp_LifeUp", 1);
  }

  /**
   * Liste der Namen von Objekten, die im Level verfügbar sind.
   */
  List<String> get objectNames {
    List<String> _objectNames = new List();
    objectFrequenzy.forEach((object) => _objectNames.add(object.name));
    return _objectNames;
  }

  /**
   * neues Level-Objekt mit name und value hinzufügen.
   */
  void addLevelObject(String name, int value) {
    _objectFrequenzy.add(new LevelObject(name, value));
  }

  /**
   * neues Level aus einer Map erzeugen. (Bsp. geparste JSON-Datei)
   */
  static Level loadLevel(Map map) {
    String levelname = map["NAME"];
    int levelpoints = map["MAXPOINTS"];
    int levelfrequenz = map["MAXFREQUENZ"];
    Level l = new Level(levelname, levelpoints, levelfrequenz);
    if (map["Rock"] != null) {
      l.addLevelObject("Rock", map["Rock"]);
    }
    if (map["Hole"] != null) {
      l.addLevelObject("Hole", map["Hole"]);
    }
    if (map["Bat"] != null) {
      l.addLevelObject("Bat", map["Bat"]);
    }
    if (map["Rat"] != null) {
      l.addLevelObject("Rat", map["Rat"]);
    }
    if (map["DrunkenRat"] != null) {
      l.addLevelObject("DrunkenRat", map["DrunkenRat"]);
    }
    if (map["BlueCoin"] != null) {
      l.addLevelObject("BlueCoin", map["BlueCoin"]);
    }
    if (map["YellowCoin"] != null) {
      l.addLevelObject("YellowCoin", map["YellowCoin"]);
    }
    if (map["RedCoin"] != null) {
      l.addLevelObject("RedCoin", map["RedCoin"]);
    }
    if (map["PurpleCoin"] != null) {
      l.addLevelObject("PurpleCoin", map["PurpleCoin"]);
    }
    if (map["PowerUp_CoinGathering"] != null) {
      l.addLevelObject("PowerUp_CoinGathering", map["PowerUp_CoinGathering"]);
    }
    if (map["PowerUp_OnlyCoins"] != null) {
      l.addLevelObject("PowerUp_OnlyCoins", map["PowerUp_OnlyCoins"]);
    }
    if (map["PowerUp_LifeUp"] != null) {
      l.addLevelObject("PowerUp_LifeUp", map["PowerUp_LifeUp"]);
    }
    if (map["PowerUp_Multiplier"] != null) {
      l.addLevelObject("PowerUp_Multiplier", map["PowerUp_Multiplier"]);
    }
    if (map["PowerUp_CoinMagnet"] != null) {
      l.addLevelObject("PowerUp_CoinMagnet", map["PowerUp_CoinMagnet"]);
    }
    if (map["PowerDown_Multiplier"] != null) {
      l.addLevelObject("PowerDown_Multiplier", map["PowerDown_Multiplier"]);
    }
    return l;
  }
}

/**
 * Enthält name und value für ein Objekt, dass im einer Level-Instanz verwendet sein kann.
 */
class LevelObject {
  String _name;
  String get name => _name;
  int _value;
  int get value => _value;
  LevelObject(this._name, this._value);
}
