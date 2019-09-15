part of "../../breakout.dart";

class Item
{
	/**
	 * Name of the item
	 */
	String name;

	/**
	 * Length of item
	 */
	int length;

	/**
	 * Thickness of item
	 */
	int thickness;

	/**
	 * Position of item
	 */
	XYPoint<int> position;

	/**
	 * Generate unique key for item
	 * Used for comparison
	 */
	String itemKey = randomString(10);

	/**
	 * game instance
	 */
	Game game;

	Item({game:null, position:null, length:null, this.thickness:1, name:null})
	{
		this.position = position;
		this.length = length;
		this.thickness = thickness;
		this.name = name;
		this.game = game;
	}

	/**
	 * Get the X middle point
	 */
	int middleX()
	{
		return this.position.x + (this.length / 2).round();
	}

	/**
	 * Get the Y middle point
	 */
	int middleY()
	{
		return this.position.y + (this.thickness / 2).round();
	}

	/**
	 * Get the middle point as coordinate
	 */
	XYPoint middle()
	{
		return new XYPoint(this.middleX(), this.middleY());
	}

	/**
	 * String representation
	 */
	String toString()
	{
		return this.name;
	}

	/**
	 * Move the item to a given location
	 */
	void moveTo(int x, int y)
	{
		this.position.x = x;
		this.position.y = y;
	}

	/**
	 * Destruction event
	 */
	void onDestruct({ball:null})
	{
		//
	}
}