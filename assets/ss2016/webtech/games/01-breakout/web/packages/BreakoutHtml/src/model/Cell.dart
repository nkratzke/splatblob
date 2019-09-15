part of breakoutDart;

/**
 *  Defines a [Cell] in the Gamefield.
 */



class Cell
{
  // Postion X
  int posX;
  // Positon Y
  int posY;
  // GamePart Owner
  GamePart owner;


  Cell(int posX,int posY)
  {
    this.posX = posX;
    this.posY = posY;
  }

  /**
   * Set's the GamePart Owner after creating the [GamePart]
   */

  void setGamePart(GamePart gp){
    this.owner = gp;
  }

  /**
   * For debug Reasons ;)
   */
  String toString(){
    return "X : $posX Y : $posY ";
  }
}