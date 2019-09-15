part of breakoutDart;

/**
 * Defines a [Ball] of the [BreakoutGame].
 */
class Ball extends GamePart {

  /**
   * [Ball] constructor .
   */
  Ball(BreakoutGame game, int dirX, int dirY, List<Cell> list, String type, String powerup, int powerupVal, int changeX, int changeY, int destructionInfo, int score)
      : super (game, dirX, dirY, list, type, powerup, powerupVal, changeX, changeY, destructionInfo, score)
  {

  }



}