part of "../../breakout.dart";

/**
 * Game
 */
class Game
{
	/**
	 * Raster width/height
	 */
	int width, height;

	/**
	 * Bricks
	 */
	List items;

	/**
	 * Amount of bricks left
	 */
	int bricks = 0;

	/**
	 * Determine if the game is over
	 */
	bool gameOver;

	/**
	 * List of loops
	 * Mostly instanced of Loops
	 */
	List loops;

	/**
	 * List of timers
	 */
	Map timers;

	/**
	 * Level config
	 */
	Map config;

	/**
	 * Controller notify function
	 */
	dynamic updateFunction, removeFunction, addFunction, gameOverFunction;

	/**
	 * Zone without any collision objects
	 */
	XYArea noCollision = new XYArea();

	/**
	 * Indicates if the game has been forced to stop
	 */
	bool forcedStop = false;

	/**
	 * Constructor
	 */
	Game(int this.width, int this.height, Map this.config, dynamic this.updateFunction, dynamic this.removeFunction, dynamic this.addFunction, dynamic this.gameOverFunction)
	{
		this.items = new List();
		this.loops = new List();
		this.timers = new Map();
	}

	/**
	 * Generate random bricks
	 * Needs to be cleaned due to
	 * Config being in model
	 */
	List generateBricks({
		bricksPerRow:8,
		rowsWithBricks:3,
		brickThickness:10,
		specialsEnabled:false,
		Map specials:null
	})
	{
		// These should not be changed
		int gapSize = 2;
		int brickLength = (this.width/bricksPerRow).round() - gapSize - 1;
		int gapY = this.height-2-gapSize;
		int gapX;
		Map specialBricks;

		// SPECIAL BRICKS
		// Calculate positions of special bricks
		if (specialsEnabled)
		{
			specialBricks = this.generateSpecialBricksPositions(specials, rowsWithBricks, bricksPerRow);
		}

		// Brick generation
		for (int i = 1; i <= rowsWithBricks; i++)
		{
			gapX = gapSize;

			for (int j = 0;j < bricksPerRow;j++)
			{
				var brick;

				// SPECIAL BRICKS
				if (specialsEnabled && specialBricks["$j-$i"] != null)
				{
					var type = specialBricks["$j-$i"];

					brick = new Brick.special(type,
						position: new XYPoint(gapX + (j*brickLength), gapY - (i*brickThickness)),
						length:brickLength,
						thickness:brickThickness,
						coordinates: new XYPoint(j, i),
						game:this
					);
				}
				// NORMAL BRICKS
				else
				{
					brick = new NormalBrick(
						position: new XYPoint(gapX + (j*brickLength), gapY - (i*brickThickness)),
						length:brickLength,
						thickness:brickThickness,
						coordinates: new XYPoint(j, i),
						game:this
					);
				}

				this.addItem(brick);
				this.bricks++;

				gapX += gapSize;
			}

			gapY -= gapSize;
		}

		// Non collision area
		this.noCollision.tl = new XYPoint(2, (rowsWithBricks*brickThickness) + (rowsWithBricks*gapSize) - 2);
		this.noCollision.tr = new XYPoint(this.width-2, (rowsWithBricks*brickThickness) + (rowsWithBricks*gapSize) - 2);
	}

	/**
	 * Generate position values for special bricks
	 */
	Map generateSpecialBricksPositions(Map specials, int rowsWithBricks, int bricksPerRow)
	{
		Map specialBricks = new Map();
		int maxPosition = (rowsWithBricks * bricksPerRow) - 1;
		var random = new Random(new DateTime.now().millisecondsSinceEpoch);
		List without = new List();

		// Create matrix with positions
		var matrix = new NumberMatrix(range(0, maxPosition), bricksPerRow, rowsWithBricks);

		// Iterate special bricks map
		specials.forEach((type, amount) {


			// Iterate amounts of current brick
			for (int i = 0; i < amount; i++)
			{
				// Calculate position for brick
				List range = rangeWithout(0, maxPosition, without);
				int position = range[random.nextInt(range.length)];

				var m = matrix.getNumber(position);

				// Calculate Y position
				int posY = matrix.getNumber(position).getY() + 1;

				// Calculate X position
				int posX = matrix.getNumber(position).getX();

				// Add brick to specials Map
				specialBricks["$posX-$posY"] = type;

				// Add position to without List
				without.add(position);
			}

		});

		return specialBricks;
	}

	/**
	 * Add an event loop
	 */
	void addLoop(Loop loop)
	{
		this.loops.add(loop);
	}

	void addTimer(String name, Timer timer)
	{
		if (this.timers.containsKey(name))
			this.timers[name].cancel();

		this.timers[name] = timer;
	}

	/**
	 * Add an item in grid
	 * @param item Item
	 */
	void addItem(Item item)
	{
		// Non collision area
		if (item is Platform)
		{
			this.noCollision.bl = new XYPoint(2, item.position.y+item.thickness+2);
			this.noCollision.br = new XYPoint(this.width - 2, item.position.y+item.thickness);
		}

		this.addFunction(item);
		this.items.add(item);
	}

	/**
	 * Remove brick from list
	 */
	void removeItem(Item item)
	{
		if (item is Brick)
		{
			this.bricks--;
		}

		this.items.remove(item);
		this.removeFunction(item);
	}

	/**
	 * Get items by filter
	 */
	List getItems(dynamic filter)
	{
		List items = new List();

		this.items.forEach((i) {
			if (filter(i))
				items.add(i);
		});

		return items;
	}

	/**
	 * Start the game
	 */
	void startGame(Ball ball, Platform platform) async
	{
		// DEBUG
		if (!_platformloop && !_ballLoop)
			return;

		if (_ballLoop)
			this.addLoop(new BallLoop(ball, this));

		if ((_platform_control == "motion" || _platform_control == "user") && _platformloop)
			this.addLoop(new PlatformLoop(platform, this));

		// Wait for loops to complete
		while (this.loops.isNotEmpty)
		{
			await Future.wait(Loop.futures);
		}

		if (!this.forcedStop)
		{
			// Cancel all timers
			this.stopTimers();

			// Stop remaining loops
			this.stopLoops();
			this.gameOverFunction();
		}
	}

	/**
	 * Forced the game to end
	 */
	void forceEndGame()
	{
		this.forcedStop = true;
		this.stopLoops();
		this.stopTimers();
	}

	/**
	 * Stop all loops
	 */
	void stopLoops()
	{
		this.loops.forEach((loop) => loop.stop());
		this.loops.clear();
	}

	/**
	 * Stop all timers
	 */
	void stopTimers()
	{
		this.timers.forEach((name, timer) {
			timer.cancel();
		});
	}

	/**
	 * Pause the game
	 */
	void pause()
	{
		Loop.pauseAll();
	}

	/**
	 * Unpause the game
	 */
	void unpause()
	{
		Loop.unpauseAll();
	}
}