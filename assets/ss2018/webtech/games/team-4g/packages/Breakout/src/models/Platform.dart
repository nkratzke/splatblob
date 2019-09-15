part of "../../breakout.dart";

class Platform extends Item
{
	/**
	 * Invert platform controls
	 */
	bool invert = false;

	/**
	 * Platform acceleration for motion control
	 */
	int acceleration = 0;

	Platform({
		position:null,
		length:30,
		thickness:10,
		game:null
	}):super(
		position:position,
		length:length,
		thickness:thickness,
		name:"Platform",
		game:game
	);

	/**
	 * Move the platform by acceleration
	 */
	void move()
	{
		int acc = this.acceleration;
		if (this.invert)
			acc = 0-acc;
		this.moveTo(this.position.x + acc, null);
	}

	/**
	 * Set the platform acceleration
	 */
	void setAcceleration(int acceleration)
	{
		this.acceleration = (acceleration / 4).round();
	}

	/**
	 * Move the platform for increments
	 */
	void moveFor(int increments)
	{
		if (this.invert)
			increments = 0-increments;

		this.moveTo(this.position.x + increments, null);
	}

	/**
	 * Move platform to a position regarding invert
	 */
	void moveToWithInvert(int x, int y)
	{
		if (this.invert)
			x = this.game.width - x;

		this.moveTo(x, y);
	}

	/**
	 * Move the platform to a given position
	 */
	void moveTo(int x, int y)
	{
		if (x <= 0)
			this.position.x = 0;
		else if (x+this.length >= this.game.width - 1)
			this.position.x = this.game.width - this.length - 1;
		else
			this.position.x = x;
	}
}