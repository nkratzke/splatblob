part of breakoutDart;



/**
 *  PanelPart is one out of the 7 Part's from the Panel
 *
 */

class PanelPart extends  GamePart {


  PanelPart(BreakoutGame game, int dirX, int dirY,List<Cell> list, String type, String powerup, int powerupVal, int changeX,int changeY, int destructionInfo, int score)
             : super(game, dirX, dirY, list, type, powerup, powerupVal, changeX, changeY, destructionInfo, score)
  {}


  /**
   * move's the panel in two directions
   * function needs two parameter
   * (dirX) direction X
   * (dirY) direction Y
   */
  void movePanel(int dirX, int dirY) {
    this.dirX = dirX;
    this.dirY = dirY;

    List<Cell> oldPos = new List<Cell>();
    List<Cell> newPos = new List<Cell> ();

    for(Cell cl in cellList){
      Cell tmp = new Cell(cl.posX,cl.posY);
      cl.posY = tmp.posY + this.dirY;
      cl.posX = tmp.posX + this.dirX;

      oldPos.add(tmp);
      newPos.add(cl);
    }

    for(Cell c in oldPos)
    {
      game.field[c.posY][c.posX] = null;
    }
    for(Cell c in newPos)
    {
      game.field[c.posY][c.posX] = c;
    }
  }

  /**
   * check's if Panel Move is legal
   * this function needs two parameter
   * (dirX) direction X
   * (dirY) direction Y
   */
  bool panelCheck(int dirX, int dirY)
  {
    this.dirX = dirX;
    this.dirY = dirY;

    Cell checkCell = chooseCell();
    List cellsToCheck = calculateCells(checkCell);
    bool free = true;
    for(Cell c in cellsToCheck)
    {
      if(c != null)
      {
        free = false;
      }
    }
    return free;
  }
}