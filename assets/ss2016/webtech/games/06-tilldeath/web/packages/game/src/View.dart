part of runner;

class View {


  /// game container
  DivElement gameElement;

  /// Restart overlay container
  DivElement restartOverlay;
  DivElement restartMessage;

  /// Restart clickables container
  DivElement restartContainer;
  DivElement restartButtonStartNext;
  DivElement restartButtonRestart;
  DivElement restartButtonSubmit;
  DivElement restartButtonMenu;

  /// Restart highscore list container
  DivElement restartHighscoreContainer;
  UListElement restartHighscoreList;

  /// Restart login container
  DivElement restartLogin;
  InputElement restartLoginUser;
  InputElement restartLoginPassword;
  DivElement restartLoginSubmit;


  /// Main menu overlay container
  DivElement menuOverlay;
  DivElement menuTitle;

  /// Menu clickables container
  DivElement menuContainer;
  DivElement menuButtonStart;
  SelectElement menuLevelSelect;
  DivElement menuButtonLimiter;
  DivElement menuButtonQuality;

  /// Score Element
  DivElement score;
  DivElement statusMessage;

  /// Game Size
  int viewport_x;
  int viewport_y;

  /// Storage for divs, avoids creating divs all the time
  List<DivElement> divs;

  /// Player element
  DivElement player;

  /// Map for current quality class settings
  Map<String, String> qualityClass;


  /// Creates View instance
  ///
  /// Creates the instance for View and adds all the necessary game elements to the DOM
  View(this.viewport_x, this.viewport_y) {
    log("View: View() instance created");

    divs = new List<DivElement>(20);

    // create 20 divs and store them for use, avoid expensive creation while running
    for (int i = 0; i < 20; i++) {
      divs[i] = new DivElement();
    }



//    usedDivs = new Map<int, DivElement>();

    qualityClass = new Map<String, String>();

    gameElement = querySelector('#game');
    gameElement.style.width  = "${viewport_x}px";
    gameElement.style.height = "${viewport_y}px";
    gameElement.style.marginLeft = "-${(viewport_x/2)+5}px";

    for (DivElement d in divs) {
      gameElement.children.add(d);
      d.style.display = "none";
      d.dataset["id"] = "none";
    }

    player = new DivElement();
    player.id = "Player";
    player.className = "Player block";
    player.style.display = "block";
    gameElement.children.add(player);


    restartOverlay = querySelector('#restart-overlay');
    restartHighscoreContainer = querySelector('#restart-overlay-highscores');
    restartHighscoreList = querySelector('#restart-overlay-highscores-list');

    restartContainer = querySelector('#restart-overlay-button-container');
    restartButtonStartNext = querySelector("#restart-overlay-button-startnext");
    restartButtonRestart = querySelector("#restart-overlay-button-restart");
    restartButtonSubmit = querySelector('#restart-overlay-button-highscore');
    restartButtonMenu = querySelector('#restart-overlay-button-menu');


    restartLogin = querySelector('#restart-overlay-login');
    restartLoginUser = querySelector("#restart-overlay-login-user");
    restartLoginPassword = querySelector("#restart-overlay-login-password");
    restartLoginSubmit = querySelector("#restart-overlay-login-submit");

    restartMessage = querySelector('#restart-overlay-message');

    score = querySelector("#score");

    statusMessage = querySelector('#status-message');

    menuOverlay = querySelector("#menu-overlay");
    menuTitle = querySelector("#menu-overlay-title");

    menuContainer = querySelector("#menu-overlay-button-container");
    menuButtonStart = querySelector("#menu-overlay-button-start");
    menuLevelSelect = querySelector("#menu-overlay-level-select");
    menuButtonLimiter = querySelector("#menu-overlay-button-limiter");
    menuButtonQuality = querySelector("#menu-overlay-button-quality");

    menuButtonStart.text = "Start";
    menuButtonLimiter.text = "30fps - ✕";
    menuButtonQuality.text = "Quality: Bad";

    restartButtonStartNext.text = "Next Level";
    restartButtonRestart.text = "Restart";
    restartButtonSubmit.text = "Submit Highscore";
    restartButtonMenu.text = "Return to Menu";
    restartLoginSubmit.text = "Submit";

    preloadImages();

  }

  /// Preloads textures to avoid pop-in
  void preloadImages() {
    List<String> classList = ["Bullet", "Cobble", "Coin", "Finish", "Ground", "Guy", "SpikesBottom", "SpikesTop", "Wall"];

    for (int i = 0; i < classList.length; i++) {
      divs[i].className = classList[i];
      // show element for just a moment, thanks firefox...
      divs[i].style.display = "block";
      divs[i].style.display = "none";
    }

  }


  /// Scales View based on window size
  void rescale(int x, int y, Quality q) {
    double scale;
    if (q != Quality.LOW) {
      int vx = viewport_x + 10; // add border for calculation
      int vy = viewport_y + 10;
      scale = (x / vx) < (y / vy) ? (x / vx) : y / vy;
    } else {
      scale = 1.0;
    }
    document.body.style.transform = "scale(${scale})";
  }

  /// Updates the View based on [Model]
  void update(Model m) {
    log("View update()");
    if (m.state == State.RUNNING) {
      log("View update()  - running");
      updateGame(m);
    } else if (m.state == State.MENU) {
      log("View update() - inMenu");
      showMenu(m);
    } else { // fail/won
      log("View update() - endscreen");
      onStop(m);
    }
  }

  /// Draw visible Blocks
  ///
  /// Updates all Blocks to fit their counterpart in the visibleBlocks
  void drawBlocks(Model model) {
    for (int i = 0; i < model.visibleBlocks.length; i++) {
      Block b = model.visibleBlocks[i];
      DivElement d = divs[i];
      if ((b == null || !b.isVisible) && d.style.display != "none") {
        d.style.display = "none";
        d.dataset["id"] = "none";
      } else if (b != null && b.isVisible && ( (d.style.display == "none") || (d.dataset["id"] != b.id.toString()) )) {
        d.style.display = "block";
        d.className = qualityClass[b.name];
        d.dataset["id"] = b.id.toString();
        if (b.name == "Message") {
          d.text = (b as Message).message;
        } else {
          d.text = "";
        }

        d.style.width = "${b.size_x}px";
        d.style.height = "${b.size_y}px";

        d.style.left = "${b.pos_x  - model.player.pos_x + Player.player_offset}px";
        d.style.bottom = "${b.pos_y}px";
      } else if (b != null && b.isVisible) {
        d.style.left = "${b.pos_x  - model.player.pos_x + Player.player_offset}px";
        d.style.bottom = "${b.pos_y}px";
      }
    }
  }

  /// Update Game Elements
  void updateGame(Model model) {

    drawBlocks(model);

    player.style.bottom = "${model.player.pos_y}px";

    score.text = "Score: ${model.score}";

  }

  /// Updates visual quality
  void updateQuality(Quality quality) {
    switch (quality) {
      case Quality.HIGH:
        player.className = "Player block";
        qualityClass["Bullet"] = "Bullet block";
        qualityClass["Cobble"] = "Cobble block";
        qualityClass["Coin"] = "Coin block";
        qualityClass["Finish"] = "Finish block";
        qualityClass["Ground"] = "Ground block";
        qualityClass["Message"] = "Message block";
        qualityClass["SpikesBottom"] = "SpikesBottom block";
        qualityClass["SpikesTop"] = "SpikesTop block";
        qualityClass["Teleport"] = "Teleport block";
        qualityClass["Trigger"] = "";
        qualityClass["Wall"] = "Wall block";
        qualityClass["Water"] = "Water block";

        menuButtonQuality.text = "Quality: High";
        break;
      case Quality.MEDIUM:
        player.className = "Player-low block-med";
        qualityClass["Bullet"] = "Bullet-low block-med";
        qualityClass["Cobble"] = "Cobble-low block-med";
        qualityClass["Coin"] = "Coin-low block-med";
        qualityClass["Finish"] = "Finish-low block-med";
        qualityClass["Ground"] = "Ground-low block-med";
        qualityClass["Message"] = "Message block";
        qualityClass["SpeedBlock"] = "Trigger block-med";
        qualityClass["SpikesBottom"] = "SpikesBottom-low block-med";
        qualityClass["SpikesTop"] = "SpikesTop-low block-med";
        qualityClass["Teleport"] = "Teleport-low block-med";
        qualityClass["Trigger"] = "";
        qualityClass["Wall"] = "Wall-low block-med";
        qualityClass["Water"] = "Water-low block-med";

        menuButtonQuality.text = "Quality: Medium";
        break;
      case Quality.LOW:
        player.className = "Player-low block-low";
        qualityClass["Bullet"] = "Bullet-low block-low";
        qualityClass["Cobble"] = "Cobble-low block-low";
        qualityClass["Coin"] = "Coin-low block-low";
        qualityClass["Finish"] = "Finish-low block-low";
        qualityClass["Ground"] = "Ground-low block-low";
        qualityClass["Message"] = "Message block";
        qualityClass["SpikesBottom"] = "SpikesBottom-low block-low";
        qualityClass["SpikesTop"] = "SpikesTop-low block-low";
        qualityClass["Teleport"] = "Teleport-low block-low";
        qualityClass["Trigger"] = "";
        qualityClass["Wall"] = "Wall-low block-low";
        qualityClass["Water"] = "Water-low block-low";

        menuButtonQuality.text = "Quality: Low";
        break;
    }
  }

  /// Update text on limiter button
  void updateLimiter(bool limited) {
    if (!limited) {
      menuButtonLimiter.text = "Framerate: 60fps";
    } else {
      menuButtonLimiter.text = "Framerate: 30fps";
    }
  }

  /// Hides menus to display game
  void onStart(Model m) {
    restartOverlay.style.display = "none";
    menuOverlay.style.display = "none";
    player.style.display = "block";
    score.style.display = "inline";

    player.style.height = "${m.player.size_y}px";
    player.style.width = "${m.player.size_x}px";
    player.style.left = "${Player.player_offset}px";

    showHighscoreSubmit();
  }

  /// Displays the main menu
  void showMenu(Model m) {
    menuOverlay.style.display = "inline";
    restartOverlay.style.display = "none";
    score.style.display = "none";

    menuLevelSelect.nodes.clear();
    m.levels.forEach((k, v) {
      OptionElement option = new Element.tag("option");
      option.text = k;
      option.value = v;
      menuLevelSelect.add(option,null);
    });

  }

  /// Displays login mask
  void showHighscoreLogin() {
    restartLogin.style.display = "inline";
  }

  /// Hides login mask
  void hideHighscoreLogin() {
    restartLogin.style.display = "none";
  }

  /// Hides submit button in login mask
  void hideHighscoreSubmit() {
    restartButtonSubmit.style.display = "none";
  }

  /// Shows submit button in login mask
  void showHighscoreSubmit() {
    restartButtonSubmit.style.display = "inline-block";
  }


  /// Updates the highscore table
  void showHighscore(Model m) {
    restartHighscoreList.children.clear();
    LIElement lientry;

    m.highscores.forEach((entry) {
        lientry = new LIElement();
        lientry.text = "${entry["score"]} ${entry["name"]}";
        restartHighscoreList.children.add(lientry);
    });
  }

  /// Displays the won/fail menu
  void onStop(Model m) {
    divs.forEach((div) {
      div.style.display = "none";
      div.dataset["id"] = "none";
    });

    player.style.display = "none";

    restartOverlay.style.display = "inline";

    score.text = "Score: ${m.score}";

    hideHighscoreLogin();

    if (m.state == State.WON) {
      restartMessage.text = "Well done";
    } else {
      restartMessage.text = "You fail";
    }

    showHighscore(m);

  }

}