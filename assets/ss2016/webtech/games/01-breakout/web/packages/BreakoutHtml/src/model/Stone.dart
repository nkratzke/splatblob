part of breakoutDart;

/**
 * Defines a [Stone] of the [BreakoutGame].
 */

class Stein extends GamePart{


    /**
     * [Stone] constructor .
     */
    Stein(BreakoutGame game, int dirX, int dirY,List<Cell> list, String type, String powerup, int powerupVal, int changeX,int changeY, int destructionInfo, int score)
                : super(game, dirX, dirY, list, type, powerup, powerupVal, changeX, changeY, destructionInfo, score)
    {

    }
}