part of breakoutDart;



/**
 * A GamePart can be every Object on the Game field
 *
 */

abstract class GamePart {
  // Connection to the Breakout Game
  BreakoutGame game;
  // Direction X for moveable GamePart's
  int dirX;
  // Direction Y for moveable GamePart's
  int dirY;
  // List of the Cells form wicht it is
  List<Cell> cellList;
  // Type designation
  String type;
  // PowerUP descriotion (for future expansion)
  String powerup;
  // Value for PowerUP
  int powerupVal;
  // for Panel Part the new angle by a hit for the ball
  int changeX;
  // for Panel Part the new angle by a hit for the ball
  int changeY;
  // number of live's from a GamePart (Stone)
  int destructionInfo;
  // Score of a Stone
  int score;

  GamePart(BreakoutGame game, int dirX, int dirY, List<Cell> list, String type,
      String powerup, int powerupVal,
      int changeX, int changeY, int destructionInfo, int score) {
    this.game = game;
    this.dirX = dirX;
    this.dirY = dirY;
    this.cellList = list;
    this.type = type;
    this.powerup = powerup;
    this.powerupVal = powerupVal;
    this.changeX = changeX;
    this.changeY = changeY;
    this.destructionInfo = destructionInfo;
    this.score = score;
  }

  /**
   *Add's a CellOwner for every Cell
   * Have to be done after creating a Gamepart because the Owener does'nt exists at the Point of the Creating
   *
   */
  void addCellOwner() {
    for (Cell cl in cellList) {
      cl.setGamePart(this);
    }
  }

  /**
   *Execute by an hit of the Ball
   *Switch - Case for extensions in the Future
   *Executes the powerup on the gp
   */
  void hit(GamePart gp) {
    if (this.powerup != null) {
      activatePowerUp(gp);
    }
    switch (type) {
      case "desS":
        destructionInfo--;
        game.updateScore(this.score);
        if (destructionInfo < 1) {
          destroyBlock(game.gamePartList_desStein);
          if (game.gamePartList_desStein.length <= 0) {
            game.levelDone();
          }
        }
        break;
      default:
        break;
    }
  }

  /**
   * returns the cell of the corner in the direction of the Ball
   *
   */
  Cell chooseCell() {
    Cell checkingCell;
    // +X und +Y
    if (dirX > 0 && dirY > 0) {
      checkingCell = cellList[cellList.length - 1];
    }
    // +X und -Y
    if (dirX >= 0 && dirY <= 0) {
      checkingCell = cellList[(sqrt(cellList.length).floor()) - 1];
    }
    // -X und +Y
    if (dirX <= 0 && dirY >= 0) {
      checkingCell = cellList[cellList.length - sqrt(cellList.length).floor()];
    }
    // -X und -Y
    if (dirX < 0 && dirY < 0) {
      checkingCell = cellList[0];
    }
    return checkingCell;
  }


  /**
   * return's the caclulate Cell's witch has to be checked for a collison
   * needs checkingCell for the Calcualtion
   */
  List<Cell> calculateCells(Cell checkingCell) {
    List<Cell> retList = new List<Cell>();

    int iModifier;
    int jModifier;
    int iVal;
    int limitY;
    int jVal;
    int limitX;
    int posXown = checkingCell.posX;
    int posYown = checkingCell.posY;
    int ballLength = sqrt(cellList.length).round();

    if (dirY < 0) {
      iVal = posYown + (ballLength - 1);
      limitY = posYown + dirY - 1;
      iModifier = -1;
    }
    else {
      iVal = posYown - (ballLength - 1);
      limitY = posYown + dirY + 1;
      iModifier = 1;
      if (dirY == 0 && dirX > 0) {
        iVal = posYown + (ballLength - 1);
        limitY = posYown + dirY - 1;
        iModifier = -1;
      }
    }

    if (dirX < 0) {
      jVal = posXown + (ballLength - 1);
      limitX = posXown + dirX - 1;
      jModifier = -1;
    }
    else {
      jVal = posXown - (ballLength - 1);
      limitX = posXown + dirX + 1;
      jModifier = 1;
      if (dirX == 0 && dirY > 0) {
        jVal = posXown + (ballLength - 1);
        limitX = posXown + dirX - 1;
        jModifier = -1;
      }
    }

    if (dirY.abs() >= dirX.abs()) {
      for (int i = iVal; i != limitY; i = i + iModifier) {
        for (int j = jVal; j != limitX; j = j + jModifier) {
          if ((game.field[i][j] == null ||
              (game.field[i][j].owner != checkingCell.owner))) {
            retList.add(game.field[i][j]);
          }
        }
      }
    } else {
      for (int j = jVal; j != limitX; j = j + jModifier) {
        for (int i = iVal; i != limitY; i = i + iModifier) {
          if ((game.field[i][j] == null ||
              game.field[i][j].owner != checkingCell.owner)) {
            retList.add(game.field[i][j]);
          }
        }
      }
    }
    return retList;
  }


  /**
   * checks the Cell's calculatet by calculateCells
   * and moves the ball gradually to the new postion
   *
   * returns true if the Ball is under the Panel
   * returns false if the Ball is above the Panel and the Move is done
   * returns false if the Ball is above the Panel and a Collison is detectet (dirX and dirY is previously changed
   */
  bool move() {
    if (this.cellList[2].posY >= game.field.length - 2) {
      return true;
    }
    int bewegung_Step_in_X;
    int bewegung_Step_in_Y;
    int zwischen_Speicher_DirX;
    int zwischen_Speicher_DirY;
    int longTime_zwischen_Speicher_DirX;
    int longTime_zwischen_Speicher_DirY;



    zwischen_Speicher_DirX = this.dirX;
    zwischen_Speicher_DirY = this.dirY;
    longTime_zwischen_Speicher_DirX = this.dirX;
    longTime_zwischen_Speicher_DirY = this.dirY;

    List<Cell> hitCells = new List<Cell>();
    List<GamePart> hitGameParts = new List<GamePart>();

    bool x = true;
    bool collison = false;

    //The Gamepart is moving step by step as long as the hole step is done
    while (x) {
      if (zwischen_Speicher_DirX == 0 && zwischen_Speicher_DirY == 0) x = false;


      if (this.dirX == 2)
        bewegung_Step_in_X = 1;
      if (this.dirX == 1)
        bewegung_Step_in_X = 1;
      if (this.dirX == 0)
        bewegung_Step_in_X = 0;
      if (this.dirX == -1)
        bewegung_Step_in_X = -1;
      if (this.dirX == -2)
        bewegung_Step_in_X = -1;

      if (this.dirY == 2)
        bewegung_Step_in_Y = 1;
      if (this.dirY == 1)
        bewegung_Step_in_Y = 1;
      if (this.dirY == 0)
        bewegung_Step_in_Y = 0;
      if (this.dirY == -1)
        bewegung_Step_in_Y = -1;
      if (this.dirY == -2)
        bewegung_Step_in_Y = -1;


      this.dirX = bewegung_Step_in_X;
      this.dirY = bewegung_Step_in_Y;

      Cell checkCell = chooseCell();
      List cellsToCheck = null;
      cellsToCheck = calculateCells(checkCell);


      this.dirX = zwischen_Speicher_DirX;
      this.dirY = zwischen_Speicher_DirY;


      if (cellsToCheck.length == 2 && (cellsToCheck[0] != null || cellsToCheck[1] != null) ) {


        if (longTime_zwischen_Speicher_DirY.abs() > longTime_zwischen_Speicher_DirX.abs()) {
          dirY = dirY * (-1);
          longTime_zwischen_Speicher_DirY = longTime_zwischen_Speicher_DirY * (-1);
          collison = true;
        }else
        {
          dirX = dirX * (-1);
          longTime_zwischen_Speicher_DirX = longTime_zwischen_Speicher_DirX * (-1);
          collison = true;
        }



        if (cellsToCheck[0] != null) {
          hitCells.add(cellsToCheck[0]);
        }
        if (cellsToCheck[1] != null) {
          hitCells.add(cellsToCheck[1]);
        }
      }


      if (cellsToCheck.length == 5) {


        if ((cellsToCheck[0] != null || cellsToCheck[1] != null) &&
            (cellsToCheck[2] != null || cellsToCheck[3] != null)) {
          dirX = dirX * (-1);
          dirY = dirY * (-1);
          longTime_zwischen_Speicher_DirX =
              longTime_zwischen_Speicher_DirX * (-1);
          longTime_zwischen_Speicher_DirY =
              longTime_zwischen_Speicher_DirY * (-1);

          collison = true;


          for (int i = 0; i <= 3; i++) {
            (cellsToCheck[i] != null) ? hitCells.add(cellsToCheck[i]) : {};
          }



        } else if ((cellsToCheck[0] != null || cellsToCheck[1] != null) &&
            (cellsToCheck[2] == null || cellsToCheck[3] == null)) {


          dirX = dirX * (-1);

          longTime_zwischen_Speicher_DirX = longTime_zwischen_Speicher_DirX * (-1);


          collison = true;


          for (int i = 0; i <= 3; i++) {
            (cellsToCheck[i] != null) ? hitCells.add(cellsToCheck[i]) : {};
          }




        } else if ((cellsToCheck[0] == null || cellsToCheck[1] == null) &&
            (cellsToCheck[2] != null || cellsToCheck[3] != null)) {

          dirY = dirY * (-1);
          longTime_zwischen_Speicher_DirY =
              longTime_zwischen_Speicher_DirY * (-1);
          collison = true;


          for (int i = 0; i <= 3; i++) {
            (cellsToCheck[i] != null) ? hitCells.add(cellsToCheck[i]) : {};
          }



        } else if (cellsToCheck[4] != null) {
          dirX = dirX * (-1);
          dirY = dirY * (-1);
          longTime_zwischen_Speicher_DirX =
              longTime_zwischen_Speicher_DirX * (-1);
          longTime_zwischen_Speicher_DirY =
              longTime_zwischen_Speicher_DirY * (-1);


          collison = true;
          (cellsToCheck[4] != null) ? hitCells.add(cellsToCheck[4]) : {};
        }
      }

      if (collison) {
        for (Cell c in hitCells) {
          hitGameParts.contains(c.owner) ? {} : hitGameParts.add(c.owner);
        }

        for (GamePart gp in hitGameParts) {
          if (gp.type == "panelPart") {


            longTime_zwischen_Speicher_DirX = gp.changeX;
            longTime_zwischen_Speicher_DirY = gp.changeY;
          }
          gp.hit(this);
        }

        this.dirX = longTime_zwischen_Speicher_DirX;
        this.dirY = longTime_zwischen_Speicher_DirY;

        return false;
      } else {

        moveStep(bewegung_Step_in_X, bewegung_Step_in_Y);



        if (zwischen_Speicher_DirX != 0) {

          zwischen_Speicher_DirX = zwischen_Speicher_DirX - bewegung_Step_in_X;



        } else {
          bewegung_Step_in_X = 0;
        }
        if (zwischen_Speicher_DirY != 0) {

          zwischen_Speicher_DirY = zwischen_Speicher_DirY - bewegung_Step_in_Y;
        } else {
          bewegung_Step_in_Y = 0;
        }
      }
    }
    this.dirX = longTime_zwischen_Speicher_DirX;
    this.dirY = longTime_zwischen_Speicher_DirY;
    return false;
  }

  /**
   * gives the Ball a new Positon with the direction x and y
   */
  moveStep(int x, int y) {
    List<Cell> oldPos = new List<Cell>();
    List<Cell> newPos = new List<Cell> ();

    for (Cell cl in cellList) {
      Cell tmp = new Cell(cl.posX, cl.posY);
      cl.posX = null;
      cl.posY = null;
      cl.posY = tmp.posY + y;
      cl.posX = tmp.posX + x;
      oldPos.add(tmp);
      newPos.add(cl);
    }

    for (Cell c in oldPos) {
      game.field[c.posY][c.posX] = null;
    }
    for (Cell c in newPos) {
      game.field[c.posY][c.posX] = c;
    }
    return;
  }

  /**
   * activates the PowerUP of gp
   * switch case for future expansion
   *
   */
  void activatePowerUp(var gp) {
    switch (this.powerup) {
      case "ballExploder":
        if (gp.type == "ball") {
          gp.explode(this.powerupVal);
        }
        break;
      default:
        break;
    }
  }

  /**
   * Generate Ball's for the ball Exploader expansion
   * powerUpVal for the number of Ball to add on the field
   */
  explode(int powerUpVal) {
    List newDirs = [
      {"x":0, "y":-1},
      {"x":0, "y":1},

      {"x":-2, "y":-1},
      {"x":2, "y":-1},

      {"x":2, "y":1},
      {"x":-2, "y":1},

      {"x":-1, "y":-1},
      {"x":1, "y":-1},

      {"x":-1, "y":-2},
      {"x":1, "y":-2},

      {"x":1, "y":1},
      {"x":-1, "y":1},

      {"x":1, "y":2},
      {"x":-1, "y":2},


    ];
    List<Ball> list = new List();
    this.destroyBlock(game.getManagementList(this.type));
    for (int i = 0; i < powerUpVal; i++) {
      List<Cell> newCellList = new List();
      for (Cell c in this.cellList) {
        newCellList.add(new Cell(c.posX, c.posY));
      }
      Ball newBall = new Ball(
          this.game,
          newDirs[i]["x"],
          newDirs[i]["y"],
          newCellList,
          "${this.type}",
          "${this.powerup}",
          this.powerupVal,
          this.changeX,
          this.changeY,
          this.destructionInfo,
          this.score);
      for (Cell c in newBall.cellList) {
        c.owner = newBall;
      }
      list.add(newBall);
    }
    game.newBallsAddedDuringMove.addAll(list);
  }


  /**
   * destroys a Block and sets the Postion's in the game field null
   * list is the GamePartList_XXX
   */
  void destroyBlock(List list) {
    for (Cell c in cellList) {
      game.field[c.posY][c.posX] = null;
    }
    list.remove(this);
    for (Cell cl in cellList) {
      cl.owner = null;
    }
  }
}