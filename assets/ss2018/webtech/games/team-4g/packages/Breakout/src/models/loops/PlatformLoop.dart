part of "../../../breakout.dart";

class PlatformLoop extends Loop
{
	/**
	 * Update rate per second
	 * Do not go above 50
	 */
	int tickrate = 50;

	/**
	 * Platform instance
	 */
	Platform platform;

	PlatformLoop(Platform this.platform, Game game):super(game);

	/**
	 * Run the loop
	 */
	void run() async
	{
		this.running = true;

		while (!this.game.gameOver && this.game.bricks != 0 && this.running)
		{
			int updates = (1000/this.tickrate).round();

			if (!this.paused && !Loop.allPaused)
			{
				// Only move if acceleration is not 0
				if (platform.acceleration != 0)
				{
					await this.platform.move();
					await this.game.updateFunction(this.platform);
				}
			}

			await new Future.delayed(new Duration(milliseconds:updates));
		}

		// Remove loop from game
		this.game.loops.remove(this);

		this.running = false;
	}
}