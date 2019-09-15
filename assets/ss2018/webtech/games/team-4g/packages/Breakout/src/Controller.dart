part of "../breakout.dart";

/**
 * Controller
 */
class Controller
{
	/**
	 * table width and height in pixel
	 */
	int width = 350;
	int height = 500;

	/**
	 * Game model instance
	 */
	var game;

	/**
	 * View instance
	 */
	var view;

	/**
	 * Current level
	 */
	int level = 1;

	/**
	 * Mobile controls
	 * Can be motion/touch
	 */
	bool motion = true;

	/**
	 * Level config
	 */
	Map levelConfig;

	/**
	 * Tutorial active
	 */
	bool tutorial = false;

	/**
	 * Indicates if the current level is the max level
	 */
	bool maxLevel = false;

	Controller()
	{
		if (window.screen.orientation != null)
			window.screen.orientation.lock("portrait"); // Throws exception in Chrome on Desktop

		this.width = window.screen.width < this.width ? window.screen.width : this.width;
		this.height = window.screen.height < this.height ? window.screen.height : this.height;

		this.view = new View(this);
	}

	/**
	 * Init method
	 */
	void init()
	{
		var url;

		if (tutorial)
			url = "levels/tutorial${this.level}.json";
		else
			url = "levels/level${this.level}.json";

		var nextLevel;

		// Check for max level
		if (tutorial)
			nextLevel = "levels/tutorial${this.level + 1}.json";
		else
			nextLevel = "levels/level${this.level + 1}.json";

		var nlrequest = HttpRequest.getString(nextLevel).then((text) {

		}).catchError((error) {
			this.maxLevel = true;
		});

		// Actual initialization
		var request = HttpRequest.getString(url).then((text) {

			// Get level config as Map
			var level = JSON.decode(text);
			this.levelConfig = level;
			var config = level["config"];

			dynamic createFunction;

			if (this.tutorial)
				createFunction = (item) => this.view.createTutorialItem(item);
			else
				createFunction = (item) => this.view.createItem(item);

			// Instantiate game
			this.game = new Game(
				this.width, this.height, config,
				(item) => this.view.updateItem(item),
				(item) => this.view.removeItem(item),
				createFunction,
				() => this.endGame()
			);

			// Initiate platform
			int platformLength = config['platformLength'];
			int platformPosX = (this.width/2).round()-(platformLength/2).round();
			var platform = new Platform(position: new XYPoint(platformPosX, 17), length:platformLength, game:this.game, thickness:_PLATFORM_HEIGHT);
			this.game.addItem(platform);

			// Initiate ball
			var ballSpeed = config['ballSpeed'];
			var ball = new Ball(position:new XYPoint((this.width/2).round(), platform.position.y+platform.thickness+2), speed:ballSpeed, game:this.game);
			this.game.addItem(ball);

			// Get config
			var bricksPerRow = config['bricksPerRow'];
			var rowsWithBricks = config["rowsWithBricks"];
			var specialsEnabled = config['specialBricksEnabled'];
			Map specials = config['specialBricks'];

			// Generate bricks
			this.game.generateBricks(
				bricksPerRow:bricksPerRow,
				rowsWithBricks:rowsWithBricks,
				specialsEnabled:specialsEnabled,
				specials:specials
			);

			// Add view events
			this.addEvents(platform);

			this.game.startGame(ball, platform);

			// Show tutorial hints or start game
			if (this.tutorial)
			{
				this.view.showTutorialHints();
				this.game.pause();
			}

		});
	}

	/**
	 * Start a new game
	 */
	void initNewgame()
	{
		this.tutorial = false;
		if (_testlevel)
			this.level = 0;
		else
			this.level = 1;
		this.init();
	}

	/**
	 * Start the tutorial
	 */
	void initTutorial()
	{
		this.tutorial = true;
		this.level = 1;
		this.init();
	}

	/**
	 * Add event listeners
	 */
	void addEvents(Platform platform)
	{
		var plat = querySelector("#${platform.itemKey}");

		// Touch event
		if (this.motion == false || _platform_control == "touch")
		{
			plat.onTouchMove.listen((onTouchEvent) {
				platform.moveToWithInvert(onTouchEvent.targetTouches.first.client.x - (platform.length - (platform.length / 3).round()), null);
				this.view.updateItem(platform);
			});
		}

		// Motion event
		if (this.motion == true || _platform_control == "motion")
		{
			window.onDeviceOrientation.listen((event){
				platform.setAcceleration(event.gamma);
			});
		}

		// Mouse movement event
		bool active = false;

		plat.onMouseDown.listen((event) {
			active = true;
		});

		this.view.field.onMouseMove.listen((event) {
			if (active)
			{
				platform.moveFor(event.movement.x);
				this.view.updateItem(platform);
			}
		});

		this.view.field.onMouseUp.listen((event) {
			active = false;
		});
	}

	/**
	 * Reset the game
	 */
	void reset()
	{
		this.game.items.forEach((item){
			this.view.removeItem(item, true);
		});
	}

	/**
	 * Reset level
	 */
	void resetLevel()
	{
		this.level = 1;
	}

	/**
	 * Pause game
	 */
	void pauseGame()
	{
		this.game.pause();
	}

	/**
	 * Unpause game
	 */
	void unpauseGame()
	{
		this.game.unpause();
	}

	/**
	 * Display end game
	 */
	void endGame({bool forced:false, noreset:false})
	{
		this.reset();

		if (this.game.gameOver)
		{
			this.view.displayOverlay("gameover");
		}
		else if (forced)
		{
			this.game.forceEndGame();

			if (!noreset)
				this.resetLevel();
		}
		else
		{
			if (this.maxLevel)
			{
				this.resetLevel();
				this.tutorial = false;
				this.view.displayOverlay("finished");
			}
			else
			{
				this.level++;
				this.view.displayOverlay("continue");
			}
		}
	}
}

