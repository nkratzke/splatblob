part of "../breakout.dart";

class View
{
	/**
	 * Controller instance
	 */
	var controller;

	/**
	 * Field selector
	 */
	var field = querySelector(".field");

	/**
	 * List of tutorial items
	 */
	List tutorialItems = new List();

	View(Controller this.controller)
	{
		this.field.style.width = "${this.controller.width}px";
		this.field.style.height = "${this.controller.height}px";
		this.showMenu();

	}

	/**
	 * Create an element and insert into DOM Tree
	 */
	void createItem(Item item)
	{
		var element = new DivElement();

		// Set classes
		if (item.itemKey != null)
			element.id = item.itemKey;

		if (item is Brick)
		{
			// Random colors might be changed in the future

			element.classes.add("brick");
			element.classes.add("brick-${item.type}");
		}
		else if (item is Ball)
		{
			element.classes.add("ball");
		}
		else if (item is Platform)
		{
			element.classes.add("platform");
		}

		this.field.children.add(element);

		element = querySelector("#${item.itemKey}");

		element.style.width = "${item.length}px";
		element.style.height = "${item.thickness}px";
		element.style.bottom = "${item.position.y}px";
		element.style.left = "${item.position.x}px";
	}

	/**
	 * Create an item for the tutorial
	 */
	void createTutorialItem(Item item)
	{
		this.createItem(item);
		if (item is Brick && item.type != "normal")
			this.tutorialItems.add(item);
	}

	/**
	 * Update the position of an item
	 */
	void updateItem(Item item) async
	{
		var element = querySelector("#${item.itemKey}");

		if (element != null)
		{
			element.style.left = "${item.position.x}px";
			element.style.bottom = "${item.position.y}px";

			if (item is Brick)
			{
				if (item.type == "heavy")
				{
					if (element.classes.contains("broken1"))
					{
						element.classes.remove("broken1");
						element.classes.add("broken2");
					}
					else
					{
						element.classes.add("broken1");
					}
				}
			}
		}
	}

	/**
	 * Remove an item from field
	 */
	void removeItem(Item item, [bool reset = false])
	{
		if (item is Brick && item.type != "normal" && item.type != "heavy" && !reset && item.triggerEffect)
			this.showPowerup(item.type);

		var element = querySelector("#${item.itemKey}");

		if (element != null)
			element.remove();
	}

	/**
	 * Show powerup text
	 */
	void showPowerup(String text)
	{
		var element = new Element.p();
		element.classes.add("powerup");
		element.classes.add(text);
		element.style.display = "block";
		element.text = text;
		this.field.children.add(element);

		var timer = new Timer(new Duration(milliseconds:2000), (){
			element.remove();
		});
	}

	/**
	 * Show the game menu
	 */
	void showMenu()
	{
		this.removeOverlay();
		this.removeIngameMenuButton();
		List elements = new List();

		// Menu div
		var menu = new DivElement();
		menu.classes.add("menu");

		// Menu title
		var title = new Element.p();
		title.text = "Breakout";
		title.classes.add("title");
		title.classes.add("breakout");

		menu.children.add(title);

		// Menu new game button
		var newgame = new ButtonElement();
		newgame.text = "New Game";
		newgame.classes.add("newgame");
		newgame.onClick.listen((event){
			this.displayOverlay("newgame");
		});

		menu.children.add(newgame);

		// Menu tutorial button
		var tutorial = new ButtonElement();
		tutorial.text = "Tutorial";
		tutorial.classes.add("tutorial");
		tutorial.onClick.listen((event){
			this.showIngameMenuButton();
			this.removeOverlay();
			this.controller.initTutorial();
		});

		menu.children.add(tutorial);


		//Menu Controlls button
		var controlls = new ButtonElement();
		controlls.text = "Controls";
		controlls.classes.add("controlls");
		controlls.onClick.listen((event) {
		this.showControlls();
		});

		menu.children.add(controlls);

		// Menu credits button
		var credits = new ButtonElement();
		credits.text = "Credits";
		credits.classes.add("credits");
		credits.onClick.listen((event) {
			this.showCredits();
		});

		menu.children.add(credits);

		// Create overlay
		elements.add(menu);
		this.createOverlay(elements);
	}

	/**
	 * Display an overlay
	 * @param type String
	 */
	void displayOverlay(String type)
	{
		this.removeIngameMenuButton();
		this.removeOverlay();
		List elements = new List();

		var button = new ButtonElement();
		var p = new Element.p();
		var back = new ButtonElement();

		p.classes.add("title");
		back.classes.add("back");
		var level = this.controller.level - 1;

		switch (type)
		{
			// New game overlay
			case "newgame":

				button.onClick.listen((event){
					this.removeOverlay();
					this.controller.initNewgame();
					this.showIngameMenuButton();
				});

				button.text = "Start";
				button.classes.add("newgame");
				p.text = "New Game";
				back.text = "Back";

				break;

			// Continue overlay
			case "continue":

				button.onClick.listen((event){
					this.removeOverlay();
					this.controller.init();
					this.showIngameMenuButton();
				});

				button.text = "Continue";
				button.classes.add("continue");
				p.text = "${this.controller.levelConfig['name']} complete!";
				back.text = "Main Menu";

				break;

			// Finished overlay
			case "finished":

				button.onClick.listen((event){
					this.removeOverlay();
					this.controller.initNewgame();
					this.showIngameMenuButton();
				});

				button.text = "New Game";
				button.classes.add("newgame");
				p.text = "Game Finished!";
				back.text = "Main Menu";

				break;

			// Game over overlay
			case "gameover":

				button.onClick.listen((event){
					this.removeOverlay();
					this.controller.init();
					this.showIngameMenuButton();
				});

				button.text = "Try again";
				button.classes.add("retry");
				p.text = "Game Over!";
				back.text = "Main Menu";

				break;
		}

		back.onClick.listen((event){
			this.controller.resetLevel();
			this.showMenu();
		});

		elements.add(p);
		elements.add(button);
		elements.add(back);

		this.createOverlay(elements);
	}

	/**
	 * Create an overlay with given elements
	 */
	void createOverlay(List elements, [List classes = null])
	{
		var powerups = querySelectorAll('.powerup');
		if (powerups.isNotEmpty)
			powerups.forEach((elem) => elem.remove());

		var overlay = new DivElement();

		if (classes != null)
			classes.forEach((item) => overlay.classes.add(item));

		overlay.classes.add("overlay");

		elements.forEach((elem) => overlay.children.add(elem));

		this.field.children.add(overlay);
	}

	/**
	 * Remove current overlay if exists
	 */
	void removeOverlay()
	{
		var overlay = querySelector(".overlay");
		if (overlay != null)
			overlay.remove();
	}

	/**
	 * Show the credits page
	 */
	void showCredits()
	{
		this.removeOverlay();

		List elements = new List();

		// Headline
		var headline = new Element.p();
		headline.text = "Credits";
		headline.classes.add("title");

		elements.add(headline);

		// Text
		var text = new Element.p();
		text.appendHtml("Created by:<br><br>Florian Steiner<br><br>and<br><br>Ruben Schlonsak");
		text.classes.add("textfield");
		text.classes.add("credits");

		elements.add(text);

		// Back button
		var button = new ButtonElement();
		button.text = "Back";
		button.classes.add("back");
		button.onClick.listen((event) {
			this.showMenu();
		});

		elements.add(button);

		this.createOverlay(elements);
	}

	/**
	 * Show the Ingame menu button
	 */
	void showIngameMenuButton()
	{
		var button = new ButtonElement();
		button.text = "Menu";
		button.classes.add("menubutton");
		button.onClick.listen((event) {
			this.controller.pauseGame();
			this.showIngameMenu();
		});
		this.field.children.add(button);
	}

	/**
	 * Remove the ingame menu button
	 */
	void removeIngameMenuButton()
	{
		var button = querySelector(".menubutton"); 
		if (button != null)
			button.remove();
	}

	/**
	 * Show the ingame menu
	 */
	void showIngameMenu()
	{
		this.removeIngameMenuButton();
		List elements = new List();

		// Continue button
		var cont  = new ButtonElement();
		cont.text = "Continue";
		cont.classes.add("continue");
		cont.onClick.listen((event){
			this.removeOverlay();
			this.showTimerNumber(3);
			new Timer(new Duration(seconds:1), (){
				this.showTimerNumber(2);
				new Timer(new Duration(seconds:1), () {
					this.showTimerNumber(1);
					new Timer(new Duration(seconds:1), () {
						this.showTimerNumber(0);
						this.controller.unpauseGame();
						this.showIngameMenuButton();
					});
				});
			});
		});

		elements.add(cont);

		// Retry button
		var retry = new ButtonElement();
		retry.classes.add("retry");
		retry.text = "Restart";
		retry.onClick.listen((event) {
			this.removeOverlay();
			this.controller.unpauseGame();
			this.controller.endGame(forced:true, noreset:true);
			this.controller.init();
			this.removeOverlay();
		});

		elements.add(retry);

		// Skip level button only used for debugging
		if (_skiplevelbutton)
		{
			var skiplevel = new ButtonElement();
			skiplevel.text = "Skip Level";
			skiplevel.classes.add("skiplevel");
			skiplevel.onClick.listen((event) {
				this.removeOverlay();
				this.controller.unpauseGame();
				this.controller.game.bricks = 0; // Actually this should not be allowed
			});

			elements.add(skiplevel);
		}

		// Main Menu button
		var menu = new ButtonElement();
		menu.text = "Main Menu";
		menu.classes.add("back");
		menu.onClick.listen((event) {
			this.controller.unpauseGame();
			this.controller.endGame(forced:true);
			this.showMenu();
		});

		elements.add(menu);

		this.createOverlay(elements, ["ingame-menu"]);
	}

	/**
	 * Show a timer number after pause
	 */
	void showTimerNumber(int number)
	{
		var element = querySelector(".timernumber");

		if (number == 0)
		{
			if (element != null)
			{
				element.remove();
			}
		}
		else
		{
			if (element == null)
			{
				element = new Element.p();
				element.classes.add("timernumber");
				this.field.children.add(element);
			}

			element.text = number.toString();
		}

	}

	/**
	 * Show controlls page
	 */
	void showControlls()
	{
		this.removeOverlay();

		List elements = new List();

		// Headline
		var headline1 = new Element.p();
		headline1.text = "Controls";
		headline1.classes.add("title");

		elements.add(headline1);

		// Checkbox
		var checkbox = new CheckboxInputElement();
		checkbox.classes.add("checkbox");

		if(this.controller.motion == false)
		{
			checkbox.checked = true;
		}

		checkbox.onClick.listen((e) {
      		InputElement clicked = e.target;

			if (checkbox.checked)
			{
	      		this.controller.motion = false;
	    	}
	    	else
	    	{
	      		this.controller.motion = true;
	    	}
    	});


		elements.add(checkbox);

		var text = new Element.p();
		text.text = "Change to Touch-Control";
		text.classes.add("textfield");

		elements.add(text);

		// Back button
		var button = new ButtonElement();
		button.text = "Back";
		button.classes.add("back");
		button.onClick.listen((event) {
			this.showMenu();
		});

		elements.add(button);

		this.createOverlay(elements);
	}

	/**
	 * Show tutorial hints
	 */
	void showTutorialHints()
	{
		this.removeIngameMenuButton();

		// Get current tutorial item
		var item = this.tutorialItems[0];

		var tutorial = new DivElement();
		tutorial.classes.add("tutorial-container");

		// Arrow
		var arrow = new DivElement();
		arrow.appendHtml("&#8593;");
		arrow.classes.add("arrow");
		arrow.style.left = "${item.middleX() - 10}px";
		tutorial.children.add(arrow);

		// Text
		var hint = new Element.p();
		hint.classes.add("text");
		hint.text = this.getHint(item.type);
		tutorial.children.add(hint);

		// Button
		var button = new ButtonElement();
		button.text = "OK";
		button.classes.add("nexthint");
		tutorial.children.add(button);

		// Button click
		button.onClick.listen((event){
			querySelector(".tutorial-container").remove();
			this.tutorialItems.remove(item);

			if (this.tutorialItems.isEmpty)
			{
				this.showIngameMenuButton();
				this.controller.unpauseGame();
			}
			else
			{
				this.showTutorialHints();
			}
		});

		this.field.children.add(tutorial);
	}

	/**
	 * Tutorial brick hints list
	 */
	String getHint(String type)
	{
		Map hints = {
			"slow":      "This is a Slow-Brick. It will temporarly slow down the Balls speed. This effect stacks.",
			"speed":     "This is a Speed-Brick. It will temporarly speed up the Ball. This effect stacks.",
			"heavy":     "This Brick is heavier than the others. It will take 3 hits to break it.",
			"explosion": "This brick will explode, causing its surrounding bricks to destroy. Their effects are not triggered in the process.",
			"teleport":  "This \"Teleport-Brick\" teleports the Ball to another random Teleport-Brick.",
			"invert":    "Be aware of the Invert-Brick. It will temporarly invert the Platform controls.",
			"split":     "Destroying this Brick will split the ball in half, creating a second ball to play with.",
			"penetrate": "This Brick will make the Ball harder and cause it to penetrate all Bricks."
		};

		return hints[type];
	}
}