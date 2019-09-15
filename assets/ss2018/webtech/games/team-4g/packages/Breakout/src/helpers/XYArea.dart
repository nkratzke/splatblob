part of "../../breakout.dart";

/**
 * Custom Point class because math.Point cannot edit x/y
 */
class XYArea
{
	/**
	 * Bottom left, bottom right, top left, top right coordinates
	 */
	XYPoint<int> bl, br, tl, tr;

	XYArea([XYPoint bl=null, XYPoint br=null, XYPoint tl=null, XYPoint tr=null])
	{
		this.bl = bl;
		this.br = br;
		this.tl = tl;
		this.tr = tr;
	}

	/**
	 * Check if Area has a point
	 */
	bool hasPoint(XYPoint<int> point)
	{
		return point.x >= this.bl.x && point.x <= this.br.x && point.y >= this.bl.y && point.y <= this.tl.y;
	}

	/**
	 * String representation
	 */
	String toString()
	{
		return "(${this.bl}, ${this.br}, ${this.tl}, ${this.tr})";
	}
}