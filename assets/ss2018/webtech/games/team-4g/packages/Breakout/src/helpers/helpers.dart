part of "../../breakout.dart";

/**
 * Custom helper functions
 */

/**
 * Random instance
 */
var _random = new Random(new DateTime.now().millisecondsSinceEpoch);

/**
 * Print multiple lines from list
 */
void multiPrint(List list)
{
	for (int i = 0; i<list.length;i++)
	{
		print(list[i]);
	}
}

/**
 * Create a list with integers ranging from start to end
 * @param start in
 * @param end int
 * @return List
 */
List range(int start, int end)
{
	List range = new List();

	for (int i = start; i <= end; i++)
	{
		range.add(i);
	}

	return range;
}

/**
 * Convert integer digits to alphabet chars
 */
String randomString(int length)
{
	const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVQXYZ";

	String str = "";

	for (int i = 0; i < length; i++)
	{
		str += chars[_random.nextInt(chars.length)];
	}

	return str;
}

/**
 * Create a list with integers
 * ranging from start to end
 * excluding numbers from another list
 *
 * @param start in
 * @param end int
 * @param without List
 * @return List
 */
List rangeWithout(int start, int end, List without)
{
	List range = new List();

	for (int i = start; i <= end; i++)
	{
		if (!without.contains(i))
			range.add(i);
	}

	return range;
}

/**
 * End the application
 */
void die([String msg=null])
{
	if (msg != null)
		print(msg);
	throw new Exception("Application terminated by user!");
}

/**
 * Print something in model
 */
void modelPrint(String str)
{
	if (_modeldebug)
		print(str);
}