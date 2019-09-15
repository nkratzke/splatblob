part of "../../breakout.dart";

/**
 * Ball class
 */
class Ball extends Item
{
	/**
	 * Velocity the ball travels
	 */
	int speed;

	/**
	 * Base speed of ball
	 */
	int baseSpeed;

	/**
	 * Bal slope
	 */
	XYPoint<double> slope = new XYPoint(0.5, 1.0);

	/**
	 * Ball can penetrate bricks
	 */
	bool canPenetrate = false;

	/**
	 * Constructor
	 */
	Ball({
		position:null,
		length:7,
		thickness:7,
		speed:50,
		game:null,
		slope:null
	}):super(
		position:position,
		length:length,
		thickness:thickness,
		name:"Ball",
		game:game
	)
	{
		this.speed = speed;
		this.baseSpeed = speed;
		if (slope != null)
			this.slope = slope;
	}

	/**
	 * Move the ball
	 */
	void move(int timeElapsed)
	{
		this.position.x = this.position.x + (this.slope.x*(speed/timeElapsed)).round();
		this.position.y = this.position.y + (this.slope.y*(speed/timeElapsed)).round();
	}

	/**
	 * Invert the X slope
	 */
	void invertSlopeX()
	{
		if (this.slope.x < 0)
			this.slope.x = this.slope.x.abs();
		else
			this.slope.x = 0 - this.slope.x;
	}

	/**
	 * Invert the Y slope
	 */
	void invertSlopeY()
	{
		if (this.slope.y < 0)
			this.slope.y = this.slope.y.abs();
		else
			this.slope.y = 0 - this.slope.y;
	}

	/**
	 * Check if ball touches an item
	 */
	bool touches(Item item)
	{
		int posX = this.middleX();
		int posY = this.middleY();

		return posX >= item.position.x && posX <= item.position.x+item.length && posY >= item.position.y && posY <= item.position.y+item.thickness;
	}

	/**
	 * Ball destruction event
	 */
	void onDestruct({ball:null})
	{
		List balls = this.game.getItems((item) => item is Ball && item.itemKey != this.itemKey);

		if (balls.isEmpty)
			this.game.gameOver = true;
	}
}