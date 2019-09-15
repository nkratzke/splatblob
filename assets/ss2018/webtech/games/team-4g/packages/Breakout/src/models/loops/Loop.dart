part of "../../../breakout.dart";

abstract class Loop
{
	/**
	 * Game instance
	 */
	Game game;

	/**
	 * Loop is running
	 */
	bool running = false;

	/**
	 * Loop is paused
	 */
	bool paused = false;

	/**
	 * All loops are paused
	 */
	static bool allPaused = false;

	/**
	 * Loop instances
	 */
	static List futures = new List();

	Loop(Game this.game)
	{
		futures.add(this.run());
	}

	/**
	 * Run the Loop
	 */
	void run();

	/**
	 * Stop the loop
	 */
	void stop()
	{
		this.running = false;
	}

	/**
	 * Pause the loop
	 */
	void pause()
	{
		this.paused = true;
	}

	/**
	 * Pause all loops
	 */
	static void pauseAll()
	{
		allPaused = true;
	}

	/**
	 * Unpause all loops
	 */
	static void unpauseAll()
	{
		allPaused = false;
	}

	/**
	 * Unpause the loop
	 */
	void unpause()
	{
		this.paused = false;
	}
}