part of "../../breakout.dart";

/**
 * Custom Point class because math:Point class cannot edit x/y
 */
class XYPoint<T>
{
	/**
	 * X Position
	 */
	T x;

	/**
	 * Y Position
	 */
	T y;

	XYPoint([T this.x=null, T this.y=null]);

	/**
	 * String representation
	 */
	String toString()
	{
		return "(${this.x}, ${this.y})";
	}
}