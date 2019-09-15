part of "../../breakout.dart";

/**
 * Class NumberMatrix
 * Used for Brick generation
 */
class NumberMatrix
{
	/**
	 * List of Items
	 */
	List<List<MatrixItem>> items;

	/**
	 * Constructor
	 */
	NumberMatrix(List<int> numbers, width, height)
	{
		this.items = new List<List<MatrixItem>>();
		int index = 0;

		for (int y = 0; y < height; y++)
		{
			List list = new List<MatrixItem>();

			for (int x = 0; x < width; x++)
			{
				list.add(new MatrixItem(numbers[index], x, y));
				index++;
			}

			this.items.add(list);
		}
	}

	/**
	 * Get a Number as Matrix Item
	 */
	MatrixItem getNumber(int number)
	{
		var mItem = null;

		this.items.forEach((y) {
			y.forEach((item) {
				if (item.value == number)
				{
					mItem = item;
				}
			});
		});

		return mItem;
	}

	/**
	 * String representation
	 */
	String toString()
	{
		return this.items.toString();
	}
}

/**
 * Class MatrixItem
 */
class MatrixItem
{
	/**
	 * Value of item
	 */
	int value;

	/**
	 * X Coordinate of item in Matrix
	 */
	int x;

	/**
	 * Y Coordinate of item in Matrix
	 */
	int y;

	MatrixItem(this.value, this.x, this.y);

	/**
	 * Get Y Position
	 */
	int getY()
	{
		return this.y;
	}

	/**
	 * Get X position
	 */
	int getX()
	{
		return this.x;
	}

	/**
	 * String representation
	 */
	String toString()
	{
		return "${this.value} => X(${this.x}) : Y(${this.y})";
	}
}