part of tankgame;
/// Die [TankGame] Klasse verwaltet alle Entitaeten.
class TankGame {

  /// Status des Spiels
  ///
  /// [#stopped] - Spiel wurde noch nicht gestart.
  /// [#running] - Spiel läuft.
  /// [#pause]   - Spiel wurde pausiert.
  Symbol _gamestate;

  /// HashMap über alle aktiven GameObjects
  HashMap<Position, GameObject> _gameObjectsMap =
      new HashMap<Position, GameObject>();


  /// Liste über alle Positionsobjekte
  List<Position> gamePositions = [];


  /// Groesse des Spielfeldes
  final int _size;

  /// Anzahl der Enemys die zur Zeit auf dem Spielfeld sind
  int _anzahlAktiverGegner = 0;

  /// Anzahl der bereits erstellen Enemys
  int _bereitsErstellteGegner = 0;

  /// Gibt die Anzahl der bereits Zerstörten Gegner zurück
  int get bereitsZerstoert => zerstoerteEnemys.length;

  /// Set für die errechnung des Highscores um Mehrfachzählung zu vermeiden
  Set<GameObject> countForHighscore = new Set<GameObject>();

  /// Set für die Anzahl der bereits zerstoerten Gegner.
  /// Wird bei Levelabschluss zurueckgesetzt.
  Set<GameObject> zerstoerteEnemys = new Set<GameObject>();

  /// Errechnet den Highscore und gibt ihn zurueck
  int get highscore {
    int ret = 0;
    countForHighscore.forEach((obj) => ret += (100 * obj.level));
    return ret;
  }

  /// Nummer des aktuellen Level
  int _aktuelleLevelNummer;

  /// Aktuelles Levelobjekt
  Level aktuellesLevelObjekt;

  /// Prueft ob das Level geschafft wurde und gibt entsprechen true oder false zurueck
  bool get levelGeschafft {
    return bereitsZerstoert == aktuellesLevelObjekt.anzahlgegner;
  }

  /// Prueft ob ein neuer Gegner auf dem Spielfeld erstellt werden darf
  /// und gibt dementsprechend true oder false zurueck
  bool get neuerGegner =>
      _anzahlAktiverGegner < aktuellesLevelObjekt.concurrentlyEnemysOnField &&
      _bereitsErstellteGegner < aktuellesLevelObjekt.anzahlgegner;

  /// Gibt die für das aktuelle Level die noch verbleibenden Gegner zurueck
  int get verbleibendeGegner {
    return aktuellesLevelObjekt.anzahlgegner - bereitsZerstoert;
  }

  /// Setzt den Status des Spiels auf [#running]
  void start() {
    _gamestate = #running;
  }

  /// Setzt den Status des Spiels auf [#paused]
  void pause() {
    _gamestate = #paused;
  }

  /// Referenz zum Playerobject fuer direkten Zugriff.
  GameObject _player;

  /// Referenz zum Baseobject fuer direkten Zugriff
  GameObject _base;

  /// Gibt das Playerobject zurueck
  GameObject get player => _player;

  /// Konstruktor für das TankGame
  ///
  /// Setzt den Status auf [#stopped]
  /// Setzt die Levelnummer auf 1
  /// befuellt die [gamePositions] Liste
  TankGame(this._size) {
    _gamestate = #stopped;
    this._aktuelleLevelNummer = 1;
    generatePositionsObjects();
  }

  /// Erstellt einen neuen Spieler mit den uebergebenen Parametern.
  ///
  /// Erwartet wird [playerleben], [shoottimer], und [playerspeed].
  GameObject generatePlayer(playerLeben, shoottimer, playerspeed) {
    _player = new GameObject.Player(playerLeben, shoottimer, playerspeed, this);
    return player;
  }

  /// Prueft ob das Spiel verloren wurde
  /// und gibt dem entsprechend true oder false zurueck
  bool get gameover {
    bool returnvalue = false;
    if (player.leben < 1 || _base.leben < 1) {
      returnvalue = true;
    }
    return returnvalue;
  }


  /// Gibt die [gameObjectsMap] zurueck
  HashMap<Position, GameObject> get gameObjectsMap => _gameObjectsMap;


  set gameObjectsMap(HashMap<Position, GameObject> value) =>
      _gameObjectsMap = value;


  /// Durchläuft die Map und erstellt fuer den View
  /// eine List<Symbol> um das Spielfeld darzustellen.
  List<List<Symbol>> get field {
    var _field = new Iterable.generate(_size, (row) {
      return new Iterable.generate(_size, (col) => #empty).toList();
    }).toList();

    gameObjectsMap.forEach((pos, obj) {
      if (obj.type == GameObjectType.WALL) {
        _field[pos.row][pos.col] = #wall;
      }

      if (obj.type == GameObjectType.PLAYER) {
        List<Position> style = makeTank(obj);

        Position a = style.first;
        Position b = style.last;

        if ((pos.row == a.row && pos.col == a.col) ||
            (pos.row == b.row && pos.col == b.col)) {
          _field[pos.row][pos.col] = #empty;
        } else {
          _field[pos.row][pos.col] = #playerTank;
        }
      }
      if (obj.type == GameObjectType.ENEMY) {
        List<Position> style = makeTank(obj);

        Position a = style.first;
        Position b = style.last;

        if ((pos.row == a.row && pos.col == a.col) ||
            (pos.row == b.row && pos.col == b.col)) {
          _field[pos.row][pos.col] = #empty;
        } else {
          _field[pos.row][pos.col] = #enemyTank;
        }
      }
      if (obj.type == GameObjectType.BASE) {
        _field[pos.row][pos.col] = #base;
      }
      if (obj.type == GameObjectType.BULLET) {
        _field[pos.row][pos.col] = #bullet;
      }
      if (obj.type == GameObjectType.LENKRAKETE) {
        _field[pos.row][pos.col] = #lenkrakete;
      }
    });

    return _field;
  }

  /// Errechnet 2 Positionen die dem View dann als #empty uebergeben werden
  /// damit das GameObject aussieht wie ein Panzer
  List<Position> makeTank(GameObject obj) {
    List<Position> retList = [];

    switch (obj.ausrichtung) {
      case Alignment.NORTH:
        retList.add(gamePositions.singleWhere((posi) =>
            posi.row == obj.mittelpunkt.row - 1 &&
            posi.col == obj.mittelpunkt.col - 1));
        retList.add(gamePositions.singleWhere((posi) =>
            posi.row == obj.mittelpunkt.row - 1 &&
            posi.col == obj.mittelpunkt.col + 1));
        break;
      case Alignment.EAST:
        retList.add(gamePositions.singleWhere((posi) =>
            posi.row == obj.mittelpunkt.row - 1 &&
            posi.col == obj.mittelpunkt.col + 1));
        retList.add(gamePositions.singleWhere((posi) =>
            posi.row == obj.mittelpunkt.row + 1 &&
            posi.col == obj.mittelpunkt.col + 1));
        break;
      case Alignment.SOUTH:
        retList.add(gamePositions.singleWhere((posi) =>
            posi.row == obj.mittelpunkt.row + 1 &&
            posi.col == obj.mittelpunkt.col - 1));
        retList.add(gamePositions.singleWhere((posi) =>
            posi.row == obj.mittelpunkt.row + 1 &&
            posi.col == obj.mittelpunkt.col + 1));
        break;
      case Alignment.WEST:
        retList.add(gamePositions.singleWhere((posi) =>
            posi.row == obj.mittelpunkt.row - 1 &&
            posi.col == obj.mittelpunkt.col - 1));
        retList.add(gamePositions.singleWhere((posi) =>
            posi.row == obj.mittelpunkt.row + 1 &&
            posi.col == obj.mittelpunkt.col - 1));
        break;
    }

    return retList;
  }

  /// Generiert alle Positions Objekte und trägt sie in die [gamePostitions] List ein.
  void generatePositionsObjects() {
    for (int row = 0; row < gamesize; row++) {
      for (int col = 0; col < gamesize; col++) {
        gamePositions.add(new Position(row, col));
      }
    }
  }

  /// Setzt das Spiel auf den Ursprungszustand zurueck,
  /// damit ein neues Spiel gestartet werden kann
  void resetGame() {
    _aktuelleLevelNummer = 1;
    aktuellesLevelObjekt = levels.singleWhere((level) => level.levelnumber == _aktuelleLevelNummer);
    countForHighscore.clear();
    zerstoerteEnemys.clear();
    _anzahlAktiverGegner = 0;
    _bereitsErstellteGegner = 0;
    _gamestate = #stopped;
  }

  /// Errechnet die zu einem GameObject gehoerenden Positionen und sucht das
  /// entsprechende Objekt aus der [gamePositions] Liste, fuegt es einer
  /// temp Liste hinzu und gibt die am ende zurueck
  List<Position> generatePositions(int row, int col) {
    List<Position> temp = [];
    int limit_row = row + 1;
    int limit_col = col + 1;
    for (int i = col - 1; i <= limit_col; i++) {
      for (int j = row - 1; j <= limit_row; j++) {
        //print(" ${j} : ${i} \n");
        temp.add(gamePositions
            .singleWhere((posi) => posi.row == j && posi.col == i));
      }
    }
    return temp;
  }

  /// Durchlauft die [gameObjectsMap] und bewegt alle Objekte die vom Typ [GameObjectType.BULLET] sind.
  /// Wird ein anderes Objekt getroffen wird entsprechend das Leben verringert.
  /// Abschließend wir die Methode [deleteDeadObjects] aufgerufen.
  void moveBullets() {
    List<GameObject> bullets = [];
    bullets.addAll(gameObjectsMap.values.where((obj) => obj.type == GameObjectType.BULLET));

    bullets.toSet().forEach((obj) {
      if (!(obj.CollisionDetection())) {
        gameObjectsMap[getNextBulletPosition(obj)] = obj;
        gameObjectsMap.remove(obj.mittelpunkt);
        obj.mittelpunkt = getNextBulletPosition(obj);
      } else {
        obj.decrementHealth();
        print("BOOM!");
        gameObjectsMap[getNextBulletPosition(obj)].decrementHealth();
      }
    });
    deleteDeadObjects();
  }
  ///Bewegt alle Lenkrakten die sich auf dem Spielfeld befinden.
  ///Trifft die Rakete einen Gegner wird ihm ein Leben abgezogen.
  ///Abschließend wird die Methode [deleteDeadObjects] aufgerufen.
  void moveLenkrakete() {
    List<GameObject> lenkrakete = [];
    lenkrakete.addAll(gameObjectsMap.values.where((obj) => obj.type == GameObjectType.LENKRAKETE));
    bool gegnerPosiErreicht = false;

    lenkrakete.forEach((obj) {

      if(gegnerPosiErreicht == false) {
        generatePositions(obj.gegnerPositionen.first.row, obj.gegnerPositionen.first.col).forEach((posi) {
          if(posi == obj.mittelpunkt) {
            gegnerPosiErreicht = true;
          }
        });
      }

      if(obj.gegnerPositionen.first.row < obj.mittelpunkt.row) obj.ausrichtung = Alignment.NORTH;
      if(obj.gegnerPositionen.first.row > obj.mittelpunkt.row) obj.ausrichtung = Alignment.SOUTH;
      if(obj.gegnerPositionen.first.col < obj.mittelpunkt.col) obj.ausrichtung = Alignment.WEST;
      if(obj.gegnerPositionen.first.col > obj.mittelpunkt.col) obj.ausrichtung = Alignment.EAST;

      if (!(obj.CollisionDetection()) && gegnerPosiErreicht == false) {
        print("position noch nicht erreicht");
        gameObjectsMap[getNextBulletPosition(obj)] = obj;
        gameObjectsMap.remove(obj.mittelpunkt);
        obj.mittelpunkt = getNextBulletPosition(obj);
      } else if (!(obj.CollisionDetection()) && gegnerPosiErreicht) {
        print("gegner verfolgen");
        gameObjectsMap[obj.gegnerPositionen.first] = obj;
        gameObjectsMap.remove(obj.mittelpunkt);
        obj.mittelpunkt = obj.gegnerPositionen.first;
        obj.gegnerPositionen.removeAt(0);
      } else if(obj.CollisionDetection() && gegnerPosiErreicht) {
        gameObjectsMap[obj._lenkraketeZiel.mittelpunkt].decrementHealth();
        obj.decrementHealth();
        print("gegner getroffen");
      } else {
        gameObjectsMap[getNextBulletPosition(obj)].decrementHealth();
        obj.decrementHealth();
        print("else");
      }
    });
    deleteDeadObjects();
  }

  /// Durchlaeuft [gameObjectsMap] und löscht alle Objekte die kein Leben mehr haben
  ///
  /// Handelt es dich bei dem zu loeschenden Object um ein [GameObjectType.ENEMY]
  /// wird das GameObject in [countForHighscore] und [zerstoerteEnemys] eingefuegt
  void deleteDeadObjects() {
    List<GameObject> objects = [];
    objects.addAll(gameObjectsMap.values);

    objects.forEach((obj) {
      //wenn das Objekt "tot" ist dann löschen.
      if (obj.leben == 0 || obj.leben < 1) {
        if (obj.type == GameObjectType.ENEMY) {
          // anzahlaktive reduzieren wenn das objekt noch nicht im set ist.
          if (!zerstoerteEnemys.contains(obj)) _anzahlAktiverGegner -= 1;
          // in zwei sets hinzufügen.
          countForHighscore.add(obj);
          zerstoerteEnemys.add(obj);
          obj.coords.forEach((f) {
            gameObjectsMap.remove(f);
          });
        }
        else if(obj.type == GameObjectType.BULLET || obj.type == GameObjectType.LENKRAKETE){
          gameObjectsMap.remove(obj.mittelpunkt);
        }
        else {
          obj.coords.forEach((f) {
            gameObjectsMap.remove(f);
          });
        }
      }
    });
  }

  /// Errechnet die naechste Position der [bullet] und gibt sie zurueck.
  /// Trifft die Kugel auf den Spielfeldrand wird die letzte Position zurueckgegeben
  Position getNextBulletPosition(bullet) {
    var collisionPosition = bullet.mittelpunkt;
    switch (bullet.ausrichtung) {
      case Alignment.NORTH:
      //abfrage ob die kugel auf den rand zufliegt,
      //dann gibt es kein element => break;
        if (bullet.mittelpunkt.row - 1 < 0) break;
        //ansonsten posi errechnen
        collisionPosition = gamePositions.singleWhere((posi) =>
        posi.row == bullet.mittelpunkt.row - 1 &&
            posi.col == bullet.mittelpunkt.col);
        break;
      case Alignment.EAST:
      //siehe oben
        if (bullet.mittelpunkt.col + 1 > gamesize - 1) break;
        collisionPosition = gamePositions.singleWhere((posi) =>
        posi.row == bullet.mittelpunkt.row &&
            posi.col == bullet.mittelpunkt.col + 1);
        break;
      case Alignment.SOUTH:
      //siehe oben
        if (bullet.mittelpunkt.row + 1 > gamesize - 1) break;
        collisionPosition = gamePositions.singleWhere((posi) =>
        posi.row == bullet.mittelpunkt.row + 1 &&
            posi.col == bullet.mittelpunkt.col);
        break;
      case Alignment.WEST:
      //siehe oben
        if (bullet.mittelpunkt.col - 1 < 0) break;
        collisionPosition = gamePositions.singleWhere((posi) =>
        posi.row == bullet.mittelpunkt.row &&
            posi.col == bullet.mittelpunkt.col - 1);
        break;
    }
    return collisionPosition;
  }

  /// Durchlaeuft [gameObjectsMap] und bewegt alle Objecte des Typs [GameObjectType.ENEMY]
  void moveEnemys() {
    List<GameObject> enemys = [];
    enemys.addAll(
        gameObjectsMap.values.where((obj) => obj.type == GameObjectType.ENEMY));
    enemys.toSet().forEach((f) {
      errechneNaechstenSchritt(f);
    });
  }

  /// Fuegt, sofern nicht die maximale Anzahl an gleichzeigt auf dem Spielfeld
  /// aktiven Gegner erreicht wurde, ein neues Object des Typs [GameObjectType.ENEMY]
  /// an einer zufaellig errechneten freien Position in der oberen Haelfte des Feldes dem Spiel hinzu.
  /// Erwartet [shootspeed] und [movespeed] als Parameter
  void addEnemyTank(shootspeed, movespeed) {
    if (neuerGegner) {
      bool erfolg = false;
      while (!erfolg) {
        var r = new Random();
        int random_row = r.nextInt(20) + 2;
        int random_col = r.nextInt(37) + 2;

        List<Position> koordinaten = generatePositions(random_row, random_col);

        for (int i = 0; i < koordinaten.length; i++) {
          if (!gameObjectsMap.containsKey(gamePositions.singleWhere((pos) =>
              pos.row == koordinaten[i].row &&
              pos._col == koordinaten[i].col))) {
            erfolg = true;
          } else {
            erfolg = false;
            break;
          }
        }
        if (erfolg) {
          new GameObject.Enemy(
              gamePositions.singleWhere(
                  (pos) => pos.row == random_row && pos.col == random_col),
              aktuellesLevelObjekt.enemyLeben,
              shootspeed,
              movespeed,
              this);
          _anzahlAktiverGegner += 1;
          _bereitsErstellteGegner += 1;
        }
      }
    }
  }

  /// Stellt die KI der gegnerischen Spieler dar.
  ///
  /// Errechnet für ein GameObject des Typs [GameObjectType.ENEMY]
  /// welcher Schritt als nächstes ausgefuehrt werden soll.
  /// Erwartet ein [GameObject] als Parameter.
  void errechneNaechstenSchritt(GameObject obj) {
    var basePosition = _base.mittelpunkt;
    var playerPosition = player.mittelpunkt;
    var enemyPosition = obj.mittelpunkt;

    if (obj.CollisionDetection()) {
      var r = new Random();
      if(enemyPosition.row == basePosition.row) {
        // baseline erreicht
        obj.enemyEntscheidung = 6;
      } else if(obj.mittelpunkt.row == 1 && obj.mittelpunkt.col == 1) {
        // wenn oben links nur unten und rechts zur auswahl
        var choice = r.nextInt(3);
        if(choice == 1) obj.enemyEntscheidung = 1;
        else obj.enemyEntscheidung = 3;
      } else if(obj.mittelpunkt.row == 1 && obj.mittelpunkt.col == 40) {
        // wenn oben rechts nur unten und links zur auswahl
        var choice = r.nextInt(3);
        if(choice == 1) obj.enemyEntscheidung = 1;
        else obj.enemyEntscheidung = 4;
      } else {
        // ansonsten alles zur auswahl.
        obj.enemyEntscheidung = r.nextInt(5);
      }

    }

    switch (obj.enemyEntscheidung) {
      case 1:
        obj.moveDown();
        if(obj._isTargetFrom != null) {
          obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
        }
        if (enemyPosition.col == playerPosition.col &&
            (playerPosition.row < enemyPosition.row + 15 &&
                playerPosition.row > enemyPosition.row)) {
          obj.shoot();
        }
        if (enemyPosition.col == playerPosition.col &&
            (playerPosition.row > enemyPosition.row - 9 &&
                playerPosition.row < enemyPosition.row)) {
          if(obj.ausrichtung != Alignment.NORTH) obj.moveUp();
          if(obj._isTargetFrom != null) {
            obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
          }
          obj.shoot();
          obj.enemyEntscheidung = 2;
        }
        if(findeAbzweigung(obj)) obj.enemyEntscheidung = 4;


        break;
      case 2:
        obj.moveUp();
        if(obj._isTargetFrom != null) {
          obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
        }
        if (enemyPosition.col == playerPosition.col &&
            (playerPosition.row > enemyPosition.row - 15 &&
                playerPosition.row < enemyPosition.row)) {
          obj.shoot();
        }
        if (enemyPosition.col == playerPosition.col &&
            (playerPosition.row < enemyPosition.row + 9 &&
                playerPosition.row > enemyPosition.row)) {
          if(obj.ausrichtung != Alignment.SOUTH) obj.moveDown();
          if(obj._isTargetFrom != null) {
            obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
          }
          obj.shoot();
          obj.enemyEntscheidung = 1;
        }
        if(findeAbzweigung(obj)) obj.enemyEntscheidung = 3;

        break;
      case 3:
        obj.moveRight();
        if(obj._isTargetFrom != null) {
          obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
        }
        if (enemyPosition.row == playerPosition.row &&
            (playerPosition.col < enemyPosition.col + 15 &&
                playerPosition.col > enemyPosition.col)) {
          obj.shoot();
        }
        if (enemyPosition.row == playerPosition.row &&
            (playerPosition.col > enemyPosition.col - 9 &&
                playerPosition.col < enemyPosition.col)) {
          if(obj.ausrichtung != Alignment.WEST) obj.moveLeft();
          if(obj._isTargetFrom != null) {
            obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
          }
          obj.shoot();
          obj.enemyEntscheidung = 4;
        }
        if(findeAbzweigung(obj)) obj.enemyEntscheidung = 1;

        break;
      case 4:
        obj.moveLeft();
        if(obj._isTargetFrom != null) {
          obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
        }
        if (enemyPosition.row == playerPosition.row &&
            (playerPosition.col > enemyPosition.col - 15 &&
                playerPosition.col < enemyPosition.col)) {
          obj.shoot();
        }
        if (enemyPosition.row == playerPosition.row &&
            (playerPosition.col < enemyPosition.col + 9 &&
                playerPosition.col > enemyPosition.col)) {
          if(obj.ausrichtung != Alignment.EAST) obj.moveRight();
          if(obj._isTargetFrom != null) {
            obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
          }
          obj.shoot();
          obj.enemyEntscheidung = 3;
        }
        if(findeAbzweigung(obj)) obj.enemyEntscheidung = 2;

        break;
      case 6:
        if(enemyPosition.col < basePosition.col) {
          obj.moveRight();
          if(obj._isTargetFrom != null) {
            obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
          }
          obj.shoot();
        } else {
          obj.moveLeft();
          if(obj._isTargetFrom != null) {
            obj._isTargetFrom.gegnerPositionen.add(obj.mittelpunkt);
          }
          obj.shoot();
        }
        break;
    }
  }

  /// Errechnet für ein [GameObject] des Typs [GameObjectType.ENEMY]
  /// ob es von des aktuellen Position aus eine Abzweigung im Labyrinth gibt
  /// Erwartet ein [GameObject] als Parameter
  bool findeAbzweigung(GameObject obj) {
    bool returnvalue = false;
    var r = new Random();
    var choice = r.nextInt(3);

    switch(obj.ausrichtung) {
      case Alignment.NORTH:

        if(obj.mittelpunkt.col - 4 < 1) choice = 1;
        else if(obj.mittelpunkt.col + 4 > gamesize - 1) choice = 2;

        if(choice == 1) {
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 2 && posi.col == obj.mittelpunkt.col + 4))) return false;

          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row && posi.col == obj.mittelpunkt.col + 4)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 1 && posi.col == obj.mittelpunkt.col + 4)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 1 && posi.col  == obj.mittelpunkt.col + 4))) {
            returnvalue = true;
          } else {
            returnvalue = false;
          }
        }else {
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 2 && posi.col == obj.mittelpunkt.col - 4))) return false;

          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row && posi.col == obj.mittelpunkt.col - 4)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 1 && posi.col == obj.mittelpunkt.col - 4)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 1 && posi.col  == obj.mittelpunkt.col - 4))) {
            returnvalue = true;
          } else {
            returnvalue = false;
          }
        }
        break;
      case Alignment.EAST:

        if(obj.mittelpunkt.row - 4 < 1) choice = 2;
        else if(obj.mittelpunkt.row + 4 > gamesize - 1) choice = 1;

        if(choice == 1) {
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 4 && posi.col == obj.mittelpunkt.col - 2))) return false;

          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 4 && posi.col == obj.mittelpunkt.col + 1)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 4 && posi.col == obj.mittelpunkt.col - 1)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 4 && posi.col  == obj.mittelpunkt.col))) {
            returnvalue = true;
          } else {
            returnvalue = false;
          }
        }else {
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 4 && posi.col == obj.mittelpunkt.col - 2))) return false;
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 4 && posi.col == obj.mittelpunkt.col + 1)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 4 && posi.col == obj.mittelpunkt.col - 1)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 4 && posi.col  == obj.mittelpunkt.col))) {
            returnvalue = true;
          } else {
            returnvalue = false;
          }
        }
        break;
      case Alignment.SOUTH:

        if(obj.mittelpunkt.col - 4 < 1) choice = 2;
        else if(obj.mittelpunkt.col + 4 > gamesize - 1) choice = 1;

        if(choice == 1) {
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 2 && posi.col == obj.mittelpunkt.col - 4))) return false;
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row && posi.col == obj.mittelpunkt.col - 4)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 1 && posi.col == obj.mittelpunkt.col - 4)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 1 && posi.col  == obj.mittelpunkt.col - 4))) {
            returnvalue = true;
          } else {
            returnvalue = false;
          }
        }else {
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 2 && posi.col == obj.mittelpunkt.col + 4))) return false;
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row && posi.col == obj.mittelpunkt.col + 4)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 1 && posi.col == obj.mittelpunkt.col + 4)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 1 && posi.col  == obj.mittelpunkt.col + 4))) {
            returnvalue = true;
          } else {
            returnvalue = false;
          }
        }

        break;
      case Alignment.WEST:

        if(obj.mittelpunkt.row - 4 < 1) choice = 2;
        else if(obj.mittelpunkt.row + 4 > gamesize - 1) choice = 1;

        if(choice == 1) {
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 4 && posi.col == obj.mittelpunkt.col + 2))) return false;

          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 4 && posi.col == obj.mittelpunkt.col + 1)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 4 && posi.col == obj.mittelpunkt.col - 1)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row - 4 && posi.col  == obj.mittelpunkt.col))) {
            returnvalue = true;
          } else {
            returnvalue = false;
          }
        }else {
          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 4 && posi.col == obj.mittelpunkt.col + 2))) return false;

          if(!gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 4 && posi.col == obj.mittelpunkt.col + 1)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 4 && posi.col == obj.mittelpunkt.col - 1)) &&
              !gameObjectsMap.containsKey(gamePositions.singleWhere((posi) => posi.row == obj.mittelpunkt.row + 4 && posi.col  == obj.mittelpunkt.col))) {
            returnvalue = true;
          } else {
            returnvalue = false;
          }
        }
        break;
    }
    return returnvalue;
  }
}
/// Objekte der Klasse [GameObject] nehmen die Rolle der Entitaeten ein.
class GameObject {
  /// Mittelpunkt des [GameObject]
  Position _mittelpunkt;

  /// Gibt den Mittelpunkt des [GameObject] zurueck.
  Position get mittelpunkt => _mittelpunkt;

  /// Liste über alle Positionen, die zu dem [GameObject] gehören
  List<Position> _coords = [];

  /// Gibt die Liste der zum [GameObject] gehoerenden Positionen zurueck
  List<Position> get coords => _coords;

  set coords(List<Position> value) => _coords = value;


  /// Ausrichtung des GameObject. [Alignment.NORTH], [Alignment.EAST], [Alignment.SOUTH], [Alignment.WEST].
  /// Default: [Alignment.NORTH].
  Alignment _ausrichtung = Alignment.NORTH;

  /// Typ des GameObject
  /// [GameObjectType.PLAYER],
  /// [GameObjectType.ENEMY],
  /// [GameObjectType.WALL],
  /// [GameObjectType.BULLET],
  /// [GameObjectType.BASE].
  GameObjectType _type;

  /// Speichert die durch die KI getroffene Entscheidung eines Gegners.
  /// Default: 1
  int enemyEntscheidung = 1;

  /// Speichert das Ziel der Lenkrakete
  GameObject _lenkraketeZiel;

  /// Speichert das Objekt von dem dieses Objekt anvisiert wurde
  /// Gilt nur für EnemyTanks.
  GameObject _isTargetFrom = null;

  /// List in der die Schritte des Enemys nach dem anvisieren gespeichert werden.
  List<Position> gegnerPositionen = [];

  /// Gibt an ob die Zeit zwischen den Schuessen verstrichen ist.
  bool _schussbereit = true;

  /// Gibt an ob die Zeit zwischen den Schritten verstrichen ist.
  bool _fahrbereit = true;

  /// Timer für die Zeit zwischen den Schuessen.
  Timer _shootTimer;
  /// Gibt den [shootTimer] zurueck
  Timer get shootTimer => _shootTimer;

  set shootTimer(Timer value) => _shootTimer = value;

  /// Timer für die Zeit zwischen den Schritten.
  Timer _moveTimer;

  /// Gibt den [moveTimer] zurueck
  Timer get moveTimer => _moveTimer;

  set moveTimer(Timer value) => _moveTimer = value;

  /// Referenz zum TankGame
  final TankGame _game;

  /// Leben des GameObject
  int _leben;

  /// Level des GameObject
  /// Ergibt sich aus dem beim Erstellen angegebenen Leben.
  int _level;

  /// Gibt die verbleibende Anzahl an Lenkraketen Munition an.
  int _lenkraketenMunition;

  /// Gibt [_lenkraketenMunition] zurück.
  int get lenkraketenMunition => _lenkraketenMunition;

  /// Gibt das [level] des GameObject zurueck
  int get level => _level;


  set level(int value) => _level = value;

  set leben(int value) => _leben = value;

  /// Gibt das [leben] des GameObject zurueck
  int get leben => _leben;

  /// Prueft ob sich das GameObject noch auf dem Spielfeld befindet
  bool get onField {
    if (this.mittelpunkt.row + 2 < gamesize || this.mittelpunkt.row - 2 > 0) {
      return true;
    }
    if (this.mittelpunkt.col + 2 < gamesize || this.mittelpunkt.col - 2 > 0) {
      return true;
    } else {
      return false;
    }
  }

  /// Konstruktor für ein GameObject vom Typ [GameObjectType.WALL]
  /// Erwartet
  /// [mittel] Mittelpunkt des Object,
  /// [coords] Liste über alles Positionen des Object,
  /// [leben] Leben des Object,
  /// [game] Referenz zum [TankGame] Object
  /// als Parameter.
  GameObject.Wall(
      Position mittel, List<Position> coords, this._leben, this._game) {
    this._type = GameObjectType.WALL;
    this._mittelpunkt = mittel;
    this._coords = coords;
  }

  /// Konstruktor für ein GameObject vom Typ [GameObjectType.BULLET]
  /// Erwartet
  /// [mittel] Mittelpunkt des Object,
  /// [leben] Leben des Object,
  /// [game] Referenz zum [TankGame] Object
  /// als Parameter.
  GameObject.Bullet(Position mittel, this._leben, this._game) {
    this._type = GameObjectType.BULLET;
    this._mittelpunkt = mittel;
  }

  /// Konstruktor für ein GameObject vom Typ [GameObjectType.ENEMY]
  /// Erwartet
  /// [mittel] Mittelpunkt des Object,
  /// [leben] Leben des Object,
  /// [shoottimer] Abklingzeit zwischen den Schuessen
  /// [enemySpeed] Abklingzeit zwischen den Schritten
  /// [game] Referenz zum [TankGame] Object
  /// als Parameter.
  GameObject.Enemy(Position mittel, this._leben, shoottimer, enemySpeed, this._game) {
    this._type = GameObjectType.ENEMY;
    this._mittelpunkt = mittel;
    this._level = _leben;
    this._coords = game.generatePositions(mittelpunkt.row, mittelpunkt.col);
    coords.forEach((pos) => game._gameObjectsMap[pos] = this);
    this.shootTimer = shootTimer =
    new Timer.periodic(shoottimer, (_) => this._schussbereit = true);
    moveTimer = new Timer.periodic(enemySpeed, (_) => this._fahrbereit = true);
  }

  /// Konstruktor für ein GameObject vom Typ [GameObjectType.PLAYER]
  /// Erwartet
  /// [leben] Leben des Object,
  /// [shoottimer] Abklingzeit zwischen den Schuessen
  /// [playerSpeed] Abklingzeit zwischen den Schritten
  /// [game] Referenz zum [TankGame] Object
  /// als Parameter.
  GameObject.Player(leben, shoottimer, playerSpeed, this._game) {
    this._lenkraketenMunition = 3;
    this._leben = leben;
    this._type = GameObjectType.PLAYER;
    shootTimer =
        new Timer.periodic(shoottimer, (_) => this._schussbereit = true);
    moveTimer = new Timer.periodic(playerSpeed, (_) => this._fahrbereit = true);
  }
  /// Konstruktor für ein GameObject vom Typ [GameObjectType.BASE]
  /// Erwartet
  /// [mittel] Mittelpunkt des Object,
  /// [coords] Liste über alles Positionen des Object,
  /// [leben] Leben des Object,
  /// [game] Referenz zum [TankGame] Object
  /// als Parameter.
  GameObject.Base(
      Position mittel, List<Position> coords, this._leben, this._game) {
    this._type = GameObjectType.BASE;
    this._mittelpunkt = mittel;
    this._coords = coords;
  }

  GameObject.Lenkrakete(Position mittel, this._leben, GameObject target, this._game){
    this._type = GameObjectType.LENKRAKETE;
    this._mittelpunkt = mittel;
    this._lenkraketeZiel = target;
  }

  /// Gibt das [Alignment] des GameObject zurueck
  Alignment get ausrichtung => _ausrichtung;

  set ausrichtung(Alignment value) => _ausrichtung = value;

  /// Gibt den [GameObjectType] des GameObject zurueck
  GameObjectType get type => _type;

  /// Gibt das [TankGame] des GameObject zurueck
  TankGame get game => _game;

  /// Verringer das Leben des GameObject um 1
  bool decrementHealth() {
    this.leben = this.leben - 1;
    if(this.leben < 1) return true;
    return false;
  }

  /// Bewegt das GameObject einen Schritt nach rechts und
  /// aktualisiert die [gameObjectsMap] des [TankGame].
  void moveRight() {
    ausrichtung = Alignment.EAST;
    if (_fahrbereit == false) return;
    if (CollisionDetection() == true) {
      print("Collission!");
    } else {
      var mittel = mittelpunkt;
      mittelpunkt = game.gamePositions.singleWhere((posi) =>
          posi.row == mittel.row &&
          posi.col == mittel.col + 1); // mittelpunkt mit verschieben

      coords.forEach((pos) {
        game.gameObjectsMap.remove(pos);
      });
      //coords.clear();
      coords = game.generatePositions(mittelpunkt.row, mittelpunkt.col);
      coords.forEach((pos) => game._gameObjectsMap[pos] = this);
      _fahrbereit = false;
    }
  }

  set mittelpunkt(Position value) => _mittelpunkt = value;

  /// Bewegt das GameObject einen Schritt nach links und
  /// aktualisiert die [gameObjectsMap] des [TankGame].
  void moveLeft() {
    ausrichtung = Alignment.WEST;
    if (_fahrbereit == false) return;
    if (CollisionDetection() == true) {
      print("Collission!");
    } else {
      var mittel = mittelpunkt;
      mittelpunkt = game.gamePositions.singleWhere((posi) =>
          posi.row == mittel.row &&
          posi.col == mittel.col - 1); // mittelpunkt mit verschieben

      coords.forEach((pos) {
        game.gameObjectsMap.remove(pos);
      });
      //coords.clear();
      coords = game.generatePositions(mittelpunkt.row, mittelpunkt.col);
      coords.forEach((pos) => game._gameObjectsMap[pos] = this);
      _fahrbereit = false;
    }
  }

  /// Bewegt das GameObject einen Schritt nach oben und
  /// aktualisiert die [gameObjectsMap] des [TankGame].
  void moveUp() {
    ausrichtung = Alignment.NORTH;
    if (_fahrbereit == false) return;
    if (CollisionDetection() == true) {
      print("Collission!");
    } else {
      var mittel = mittelpunkt;
      mittelpunkt = game.gamePositions.singleWhere((posi) =>
          posi.row == mittel.row - 1 &&
          posi.col == mittel.col); // mittelpunkt mit verschieben

      coords.forEach((pos) {
        game.gameObjectsMap.remove(pos);
      });
      //coords.clear();
      coords = game.generatePositions(mittelpunkt.row, mittelpunkt.col);
      coords.forEach((pos) => game._gameObjectsMap[pos] = this);
      _fahrbereit = false;
    }
  }

  /// Bewegt das GameObject einen Schritt nach unten und
  /// aktualisiert die [gameObjectsMap] des [TankGame].
  void moveDown() {
    ausrichtung = Alignment.SOUTH;
    if (_fahrbereit == false) return;
    if (CollisionDetection() == true) {
      print("Collission!");
    } else {
      var mittel = mittelpunkt;
      mittelpunkt = game.gamePositions.singleWhere((posi) =>
          posi.row == mittel.row + 1 &&
          posi.col == mittel.col); // mittelpunkt mit verschieben

      coords.forEach((pos) {
        game.gameObjectsMap.remove(pos);
      });
      //coords.clear();
      coords = game.generatePositions(mittelpunkt.row, mittelpunkt.col);
      coords.forEach((pos) => game._gameObjectsMap[pos] = this);
      _fahrbereit = false;
    }
  }


  void shoot() {
    GameObject bullet;

    if (_schussbereit == true) {
      switch (ausrichtung) {
        case Alignment.NORTH:
          //pruefen ob man direkt am rand oder an einem Ojekt steht und schießen will.
          if (mittelpunkt.row - 2 < 0) break;
          // ansonsten wird die bullet erstellt und die Ausrichtugn entsprechend dem Panzer gesetzt.
          bullet = new GameObject.Bullet(
              game.gamePositions.singleWhere((posi) =>
                  posi.row == mittelpunkt.row - 2 &&
                  posi.col == mittelpunkt.col),
              1,
              game);
          bullet.ausrichtung = Alignment.NORTH;
          break;
        case Alignment.EAST:
          //siehe oben
          if (mittelpunkt.col + 2 > gamesize - 1) break;
          bullet = new GameObject.Bullet(
              game.gamePositions.singleWhere((posi) =>
                  posi.row == mittelpunkt.row &&
                  posi.col == mittelpunkt.col + 2),
              1,
              game);
          bullet.ausrichtung = Alignment.EAST;
          break;
        case Alignment.SOUTH:
          //siehe oben
          if (mittelpunkt.row + 2 > gamesize - 1) break;
          bullet = new GameObject.Bullet(
              game.gamePositions.singleWhere((posi) =>
                  posi.row == mittelpunkt.row + 2 &&
                  posi.col == mittelpunkt.col),
              1,
              game);
          bullet.ausrichtung = Alignment.SOUTH;
          break;
        case Alignment.WEST:
          //siehe oben
          if (mittelpunkt.col - 2 < 0) break;
          bullet = new GameObject.Bullet(
              game.gamePositions.singleWhere((posi) =>
                  posi.row == mittelpunkt.row &&
                  posi.col == mittelpunkt.col - 2),
              1,
              game);
          bullet.ausrichtung = Alignment.WEST;
          break;
      }
      //wenn bullet nicht gesetzt wird dann abbrechen.
      if (bullet == null) return;
      //ansonsten weiter ^^
      if (game.gameObjectsMap.containsKey(bullet.mittelpunkt)) {
        game.gameObjectsMap[bullet.mittelpunkt].decrementHealth();
      } else {
        game.gameObjectsMap[bullet.mittelpunkt] = bullet;
      }
      _schussbereit = false;
    }
  }
  /// Feuert eine Lenkrakete auf einen im Sichtfeld befindlichen Gegner ab.
  void lenkrakete() {
    if(lenkraketenMunition < 1) return;
    GameObject bullet;
    GameObject ziel;
    bool wandImWeg = false;

    List<GameObject> waende = [];
    waende.addAll(game.gameObjectsMap.values.where((obj) => obj.type == GameObjectType.WALL));

    List<GameObject> alleziele = [];
    alleziele.addAll(game.gameObjectsMap.values.where((obj) => obj.type == GameObjectType.ENEMY));

    alleziele.toSet().forEach((enemys) {
      switch (this.ausrichtung) {
        case Alignment.NORTH:
          if(enemys.mittelpunkt.row < this.mittelpunkt.row && (enemys.mittelpunkt.col == this.mittelpunkt.col || enemys.mittelpunkt.col - 1 == this.mittelpunkt.col || enemys.mittelpunkt.col + 1 == this.mittelpunkt.col)) {
            waende.toSet().forEach((wand) {

                if((wand.mittelpunkt.row > enemys.mittelpunkt.row && wand.mittelpunkt.row < this.mittelpunkt.row) &&
                    (wand.mittelpunkt.col == this.mittelpunkt.col ||
                    wand.mittelpunkt.col + 1 == this.mittelpunkt.col ||
                    wand.mittelpunkt.col - 1 == this.mittelpunkt.col)) {
                  wandImWeg = true;
                  print("wand im weg");
                }else {
                  ziel = enemys;

                }
            });
          }
          break;
        case Alignment.WEST:
          if(enemys.mittelpunkt.col < this.mittelpunkt.col && (enemys.mittelpunkt.row == this.mittelpunkt.row || enemys.mittelpunkt.row - 1 == this.mittelpunkt.row || enemys.mittelpunkt.row + 1 == this.mittelpunkt.row)) {

            waende.toSet().forEach((wand) {
              if((wand.mittelpunkt.col > enemys.mittelpunkt.col && wand.mittelpunkt.col < this.mittelpunkt.col) &&
                  (wand.mittelpunkt.row == this.mittelpunkt.row ||
                      wand.mittelpunkt.row + 1 == this.mittelpunkt.row ||
                      wand.mittelpunkt.row - 1 == this.mittelpunkt.row)) {
                wandImWeg = true;
                print("wand im weg");
              }else {
                ziel = enemys;

              }
            });
          }
          break;
        case Alignment.SOUTH:
          if(enemys.mittelpunkt.row > this.mittelpunkt.row && (enemys.mittelpunkt.col == this.mittelpunkt.col || enemys.mittelpunkt.col + 1 == this.mittelpunkt.col || enemys.mittelpunkt.col - 1 == this.mittelpunkt.col)) {

            waende.toSet().forEach((wand) {
              if((wand.mittelpunkt.row < enemys.mittelpunkt.row && wand.mittelpunkt.row > this.mittelpunkt.row) &&
                  (wand.mittelpunkt.col == this.mittelpunkt.col ||
                      wand.mittelpunkt.col + 1 == this.mittelpunkt.col ||
                      wand.mittelpunkt.col - 1 == this.mittelpunkt.col)) {
                wandImWeg = true;
                print("wand im weg");
              }else {
                ziel = enemys;

              }
            });
          }
          break;
        case Alignment.EAST:
          if(enemys.mittelpunkt.col > this.mittelpunkt.col && (enemys.mittelpunkt.row == this.mittelpunkt.row || enemys.mittelpunkt.row + 1 == this.mittelpunkt.row || enemys.mittelpunkt.row - 1 == this.mittelpunkt.row)) {

            waende.toSet().forEach((wand) {
              if((wand.mittelpunkt.col < enemys.mittelpunkt.col && wand.mittelpunkt.col > this.mittelpunkt.col) &&
                  (wand.mittelpunkt.row == this.mittelpunkt.row ||
                      wand.mittelpunkt.row + 1 == this.mittelpunkt.row ||
                      wand.mittelpunkt.row - 1 == this.mittelpunkt.row)) {
                wandImWeg = true;
                print("wand im weg");
              }else {
                ziel = enemys;
              }
            });
          }
          break;
      }
    });



   // openlist.add(new Wegpunkt(this.mittelpunkt.row, this.mittelpunkt.col, 1, schaetzwert(this._mittelpunkt.row,this.mittelpunkt.col,ziele[0].mittelpunkt.row,ziele[0].mittelpunkt.col), null));

    if (_schussbereit == true) {
      switch (ausrichtung) {
        case Alignment.NORTH:
        //pruefen ob man direkt am rand steht und schießen will.
          if (mittelpunkt.row - 2 < 0) break;
          // ansonsten wird die bullet erstellt und die Ausrichtugn entsprechend dem Panzer gesetzt.
          bullet = new GameObject.Lenkrakete(
              game.gamePositions.singleWhere((posi) =>
              posi.row == mittelpunkt.row - 2 &&
                  posi.col == mittelpunkt.col),
              1,
              ziel,
              game);
          bullet.ausrichtung = Alignment.NORTH;
          if(ziel != null) {
            bullet.gegnerPositionen.add(ziel.mittelpunkt);
            ziel._isTargetFrom = bullet;
          }
          break;
        case Alignment.EAST:
        //siehe oben
          if (mittelpunkt.col + 2 > gamesize - 1) break;
          bullet = new GameObject.Lenkrakete(
              game.gamePositions.singleWhere((posi) =>
              posi.row == mittelpunkt.row &&
                  posi.col == mittelpunkt.col + 2),
              1,
              ziel,
              game);
          bullet.ausrichtung = Alignment.EAST;
          if(ziel != null) {
            bullet.gegnerPositionen.add(ziel.mittelpunkt);
            ziel._isTargetFrom = bullet;
          }
          break;
        case Alignment.SOUTH:
        //siehe oben
          if (mittelpunkt.row + 2 > gamesize - 1) break;
          bullet = new GameObject.Lenkrakete(
              game.gamePositions.singleWhere((posi) =>
              posi.row == mittelpunkt.row + 2 &&
                  posi.col == mittelpunkt.col),
              1,
              ziel,
              game);
          bullet.ausrichtung = Alignment.SOUTH;
          if(ziel != null) {
            bullet.gegnerPositionen.add(ziel.mittelpunkt);
            ziel._isTargetFrom = bullet;
          }
          break;
        case Alignment.WEST:
        //siehe oben
          if (mittelpunkt.col - 2 < 0) break;
          bullet = new GameObject.Lenkrakete(
              game.gamePositions.singleWhere((posi) =>
              posi.row == mittelpunkt.row &&
                  posi.col == mittelpunkt.col - 2),
              1,
              ziel,
              game);
          bullet.ausrichtung = Alignment.WEST;
          if(ziel != null) {
            bullet.gegnerPositionen.add(ziel.mittelpunkt);
            ziel._isTargetFrom = bullet;
          }
          break;
      }
      //wenn bullet nicht gesetzt wird dann abbrechen.
      if (bullet == null) return;
      if(wandImWeg == true || ziel == null) return;

      if (game.gameObjectsMap.containsKey(bullet.mittelpunkt)) {
        game.gameObjectsMap[bullet.mittelpunkt].decrementHealth();
      } else {
        game.gameObjectsMap[bullet.mittelpunkt] = bullet;
      }
      _schussbereit = false;
      _lenkraketenMunition -= 1;
    }
  }

  bool CollisionDetection() {
    Position futureBulletPosition;
    List<Position> futurePositions = [];
    bool returnvalue = false;

    if (this.type == GameObjectType.BULLET || this._type == GameObjectType.LENKRAKETE) {
      switch (ausrichtung) {
        case Alignment.EAST:
          if (this.mittelpunkt.col + 1 >= gamesize) {
            return true;
          } else {
            futureBulletPosition = game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row && posi.col == mittelpunkt.col + 1);

            if (game.gameObjectsMap.containsKey(futureBulletPosition)) {
              returnvalue = true;
            }

            return returnvalue;
          }
          break;
        case Alignment.WEST:
          if (this.mittelpunkt.col - 1 < 0) {
            return true;
          } else {
            futureBulletPosition = game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row && posi.col == mittelpunkt.col - 1);

            if (game.gameObjectsMap.containsKey(futureBulletPosition)) {
              returnvalue = true;
            }
            return returnvalue;
          }
          break;
        case Alignment.NORTH:
          if (this.mittelpunkt.row - 1 < 0) {
            returnvalue = true;
          } else {
            futureBulletPosition = game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row - 1 && posi.col == mittelpunkt.col);

            if (game.gameObjectsMap.containsKey(futureBulletPosition)) {
              returnvalue = true;
            }

            return returnvalue;
          }
          break;
        case Alignment.SOUTH:
          if (this.mittelpunkt.row + 1 >= gamesize) {
            return true;
          } else {
            futureBulletPosition = game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row + 1 && posi.col == mittelpunkt.col);
            if (game.gameObjectsMap.containsKey(futureBulletPosition)) {
              returnvalue = true;
            }
            return returnvalue;
          }
          break;
      }
      return returnvalue;
    } else {
      switch (ausrichtung) {
        case Alignment.EAST:
          if (this.mittelpunkt.col + 2 >= gamesize) {
            return true;
          } else {
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row - 1 &&
                posi.col == mittelpunkt.col + 2));
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row &&
                posi.col == mittelpunkt.col + 2));
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row + 1 &&
                posi.col == mittelpunkt.col + 2));

            for (int i = 0; i < futurePositions.length; i++) {
              if (game.gameObjectsMap
                  .containsKey(futurePositions.elementAt(i))) {
                returnvalue = true;
              }
            }
            return returnvalue;
          }
          break;
        case Alignment.WEST:
          if (this.mittelpunkt.col - 2 < 0) {
            return true;
          } else {
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row - 1 &&
                posi.col == mittelpunkt.col - 2));
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row &&
                posi.col == mittelpunkt.col - 2));
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row + 1 &&
                posi.col == mittelpunkt.col - 2));

            for (int i = 0; i < futurePositions.length; i++) {
              if (game.gameObjectsMap
                  .containsKey(futurePositions.elementAt(i))) {
                returnvalue = true;
              }
            }
            return returnvalue;
          }
          break;
        case Alignment.NORTH:
          if (this.mittelpunkt.row - 2 < 0) {
            return true;
          } else {
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row - 2 &&
                posi.col == mittelpunkt.col - 1));
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row - 2 &&
                posi.col == mittelpunkt.col));
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row - 2 &&
                posi.col == mittelpunkt.col + 1));

            for (int i = 0; i < futurePositions.length; i++) {
              if (game.gameObjectsMap
                  .containsKey(futurePositions.elementAt(i))) {
                returnvalue = true;
              }
            }
            return returnvalue;
          }
          break;
        case Alignment.SOUTH:
          if (this.mittelpunkt.row + 2 >= gamesize) {
            return true;
          } else {
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row + 2 &&
                posi.col == mittelpunkt.col - 1));
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row + 2 &&
                posi.col == mittelpunkt.col));
            futurePositions.add(game.gamePositions.singleWhere((posi) =>
                posi.row == mittelpunkt.row + 2 &&
                posi.col == mittelpunkt.col + 1));

            for (int i = 0; i < futurePositions.length; i++) {
              if (game.gameObjectsMap
                  .containsKey(futurePositions.elementAt(i))) {
                returnvalue = true;
              }
            }
            return returnvalue;
          }
          break;
      }
    }
    return returnvalue;
  }
}
/// Objekte der Klasse [Level] beinhalten alle wichtigen
class Level {
  int levelnumber;
  int anzahlgegner;
  int concurrentlyEnemysOnField;
  int enemyLeben;
  List<Position> wallpositions = [];
  Position startpositionPlayer;
  Position basis;

  Level();
}
/// Repraesentiert die Postition auf dem Spielfeld.
/// x (row) und y (col) Koordinaten.
class Position {
  int _row;

  int _col;

  Position(this._row, this._col);

  int get row => _row;

  set row(int value) => _row = value;

  int get col => _col;

  set col(int value) => _col = value;


  String toString() {
    return "( ${row} / ${col} )\n";
  }
}
/// Enumerator fuer die Ausrichtung der [GameObject] Objekte.
enum Alignment { NORTH, EAST, SOUTH, WEST }

/// Enumerator fuer den Typ der [GameObject] Objekte.
enum GameObjectType { PLAYER, ENEMY, WALL, BULLET, BASE, LENKRAKETE }
