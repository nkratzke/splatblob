part of breakoutDart;


/**
 * Breakout Game is the main Game it includes the main Game physics
 *
 */
class BreakoutGame {
  //The Connection to the Controller
  GameController control;
  // The Size of the field in X Direction
  int sizeX;
  // The Size of the field in Y Direction
  int sizeY;
  // An Boolean if the game is running
  bool running;
  // An Boolean if the game is stopped
  bool stopped;
  // An Boolean if the Game is over
  bool gameOver;
  // The lifeCounter of the Level reduced if no ball is on the field
  int lifeCounter;
  // The Score you make in the Game
  int score;
  // The Level youn are in
  int level;

  // the double linkes List of the Field
  List<List<Cell>> field = new List();
  // List of the Destroyable Stones
  List<Stein> gamePartList_desStein = new List();
  // List of indestroyable Stones
  List<Stein> gamePartList_indesStein = new List();
  // List of Balls
  List<Ball> gamePartList_Ball = new List();
  // List of PanelParts witch are together the Panel
  List<PanelPart> gamePartList_PanelPart = new List();
  // Balls witch are added during the Game (PowerUp)
  List<Ball> newBallsAddedDuringMove = new List();



  BreakoutGame(GameController control, int sizeX, int sizeY, bool running,
      bool stopped, bool gameover, int lifeCounter, int score, int level) {
    this.control = control;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.running = running;
    this.stopped = stopped;
    this.gameOver = gameover;
    this.score = score;
    this.level = level;
    this.lifeCounter = lifeCounter;
    field = initList(sizeY, sizeX);

    generateBorders();
  }

  /**
   * adds the GamePart from the JSON File to the gamePartList_XXX
   * params partType is the type of the GamePart (Stones, Balls usw.)
   * params objectList is the Map of the Parameters from the JSON File
   */
  add_gameParts_JSON(String partType, List<Map> objectList) {
    for (Map m in objectList) {
      int dirX = m["dirX"];
      int dirY = m["dirY"];
      String type = m["type"];
      String powerup = m["powerup"];
      int powerupVal;
      powerup != null?powerupVal = m["powerupVal"]:powerupVal = 0;
      int changex = m["changeX"];
      int changey = m["changeY"];
      int destrInfo = m["destructionInfo"];
      int score = m["score"];
      List<Cell> cl = new List<Cell>();

      for (Map JSON_cell in m["cell"]) {
        cl.add(new Cell(JSON_cell["posX"], JSON_cell["posY"]));
      }

      switch(type) {
        case "ball" :
                      Ball ball = new Ball(this, dirX, dirY, cl, type, powerup, powerupVal, changex, changey, destrInfo, score);
                      ball.addCellOwner();
                      gamePartList_Ball.add(ball);
                      break;
        case "desS" :
                      Stein stein = new Stein(this, dirX, dirY, cl, type, powerup, powerupVal, changex, changey, destrInfo, score);
                      stein.addCellOwner();
                      gamePartList_desStein.add(stein);
                      break;
        case "idesS" :
                      Stein stein = new Stein(this, dirX, dirY, cl, type, powerup, powerupVal, changex, changey, destrInfo, score);
                      stein.addCellOwner();
                      gamePartList_indesStein.add(stein);
                      break;
        case "panelPart" :
                      PanelPart panel = new PanelPart(this, dirX, dirY, cl, type, powerup, powerupVal, changex, changey, destrInfo, score);
                      panel.addCellOwner();
                      gamePartList_PanelPart.add(panel);
                      break;
        default :
                      print("Error Type not definied");
      }
    }
    load_field_from_Gamepart_List();
  }


  /**
   * generats the field from the gamePartList_XXX
   */
  void load_field_from_Gamepart_List() {
    for (Ball bl in gamePartList_Ball) {
      for (Cell cl in bl.cellList) {
        field[cl.posY][cl.posX] = cl;
      }
    }
    for (Stein sti in gamePartList_indesStein) {
      for (Cell clis in sti.cellList) {
        field[clis.posY][clis.posX] = clis;
      }
    }
    for (Stein std in gamePartList_desStein) {
      for (Cell clds in std.cellList) {
        field[clds.posY][clds.posX] = clds;
      }
    }
    for (PanelPart pnl in gamePartList_PanelPart) {
      for (Cell clpnl in pnl.cellList) {
        field[clpnl.posY][clpnl.posX] = clpnl;
      }
    }
  }

  /**
   * Moves Panel in X Direction if possible
   * params dirX for the step size
   * params dirY for the step size (normaly zero)
   */
  void movePanel(int dirX, int dirY) {
    PanelPart pP;
    if (dirX < 0) {
      if (gamePartList_PanelPart[0].panelCheck(dirX, dirY)) {
        for (int i = 0; i < gamePartList_PanelPart.length; i++) {
          pP = gamePartList_PanelPart[i];
          pP.movePanel(dirX, dirY);
        }
      }
    }
    else {
      if (dirX > 0) {
        if (gamePartList_PanelPart[gamePartList_PanelPart.length - 1]
            .panelCheck(dirX, dirY)) {
          for (int i = gamePartList_PanelPart.length - 1; i >= 0; i--) {
            pP = gamePartList_PanelPart[i];
            pP.movePanel(dirX, dirY);
          }
        }
      }
    }
  }


  /**
   * executes on all the balls in the field the move method in GamePart
   * if there are no more balls in the field the game end's and is over
   *
   */
  void moveBall() {
    List<Ball> tmp = new List<Ball>();
    for (Ball bll in gamePartList_Ball) {
      if (bll.move()) {
        tmp.add(bll);
      }
    }
    for (Ball bl in tmp) {
      bl.destroyBlock(gamePartList_Ball);
    }
    if(newBallsAddedDuringMove.isNotEmpty)
    {
      gamePartList_Ball.addAll(newBallsAddedDuringMove);
      newBallsAddedDuringMove = new List();
    }
    if (0 == gamePartList_Ball.length) {
      GameOver();
    }
  }


  /**
   * initialize the List for the field with the dimensions tableHeight and tbaleWidth
   * return's the List
   */
  List initList(int tableHeight, int tableWidth) {
    List ret = new List();
    List oneDList;
    for (int i = 0; i < tableHeight; i++) {
      oneDList = new List(tableWidth);
      ret.add(oneDList);
    }
    return ret;
  }

  void levelDone() {
    control.levelDone();
  }

  /**
   * if there is any Life left in the Level this Methode generates a new Ball
   * if there is no Life left the Game terminates
   */
  void GameOver() {
    if (1 < lifeCounter) {
      control.game.add_gameParts_JSON("ball", control.levelLoader.getObjectsOfType("ball"));
      running = false;
      stopped = true;
      decrementLifecounter();
      control.pauseTimer();
    }
    else {
      decrementLifecounter();
      running = false;
      gameOver = true;
      control.gameOver(false);
    }
  }


  /**
   * increment Lifes and updates them
   */
  void incrementLifecounter() {
    lifeCounter++;
    updateLifes();
  }

  /**
   * decrement Lifes and updates them
   */
  void decrementLifecounter() {
    lifeCounter--;
    updateLifes();
  }


  /**
   * generats Borders on the top, left and right side of the field
   */
  void generateBorders() {
    generateBorder("top");
    generateBorder("left");
    generateBorder("right");
    load_field_from_Gamepart_List();
  }


  /**
   * generates on the orientation side an 2 * n or m * 2 block of indes Stones
   */
  void generateBorder(String orientation) {
    int dirX = 0;
    int dirY = 0;
    String type = "ideS";
    String powerup = null;
    int powerupVal = 0;
    int changex = -1;
    int changey = -1;
    int destrInfo = -1;
    int score = 0;
    List<Cell> cellList = new List<Cell>();

    int iVal = 0;
    int iLimit = 0;
    int jVal = 0;
    int jLimit = 0;
    switch (orientation) {
      case "top":
        iVal = 0;
        iLimit = 2;
        jVal = 0;
        jLimit = this.sizeX;
        break;

      case "left":
        iVal = 2;
        iLimit = this.sizeY;
        jVal = 0;
        jLimit = 2;
        break;

      case "right":
        iVal = 2;
        iLimit = this.sizeY;
        jVal = this.sizeX - 2;
        jLimit = this.sizeX;
        break;

      default:
        print("Error while generating Border! Default reached!");
        break;
    }
    for (int i = iVal; i < iLimit; i++) {
      for (int j = jVal; j < jLimit; j++) {
        cellList.add(new Cell(j, i));
      }
    }
    Stein stein = new Stein(this, dirX, dirY, cellList, type, powerup, powerupVal, changex, changey, destrInfo, score);
    stein.addCellOwner();
    gamePartList_indesStein.add(stein);
  }

  /**
   * returns the gamePartList_XXX(objectType)
   */
  List getManagementList(String objectType)
  {
    switch(objectType)
    {
      case "desS":
        return gamePartList_desStein;
      case "ball":
        return gamePartList_Ball;
      case "idesS":
        return gamePartList_indesStein;
      case "panelPart":
        return gamePartList_PanelPart;
      default:
        return null;
    }
  }


  /**
   * updates the Lifes on the Breakout Controller
   */
  updateLifes() => control.updateLifes();


  /**
   * add's score to this.score and updates the Score in Breakout Controller
   */
  updateScore(int score) {
    this.score += score;
    control.updateScore();
  }

  /**
   * update Level on Breakout Controller
   */
  updateLevel() => control.updateLevel();

}