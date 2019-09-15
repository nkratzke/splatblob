part of runner;

enum Direction {
  TOP,
  BOTTOM,
  LEFT,
  RIGHT
}

enum State {
  MENU,
  RUNNING,
  WON,
  FAIL
}

class Model {


  /// Player instance
  Player player;

  /// List of levels
  Map<String, String> levels;

  /// Currently loaded level state
  Level currentLevel;

  /// Currently loaded level name
  String currentLevelName;

  /// Current level hash
  String currentLevelHash;

  /// Highscores for current level
  List<Map<String, String>> highscores;

  /// running state
  State state;

  /// First visible block index
  int visibleIndex;

  /// Distance traveled by player
  int distance;

  /// Current Score
  int score;

  /// Current extra point, eg from coins
  int points;

  /// List of Blocks currently in viewport
  List<Block> visibleBlocks;

  /// Viewport
  int viewport_x;
  int viewport_y;

  /// Horizontal speed
  int speed;

  /// Creates Model instance
  Model(this.viewport_x, this.viewport_y) {
    visibleBlocks = new List<Block>(20);
    levels = new Map<String, String>();
    highscores = new List<Map<String, String>>();

    speed = 5;

    state = State.MENU;

    player = new Player();
  }

  /// Updates the model
  ///
  /// Updates the position of every object, detects collisions and increases score
  void update() {

    if (state != State.RUNNING) {
      return;
    }

    getVisibleBlocks();

    // update vertical position
    player.update();

    visibleBlocks.where((b) => b != null).forEach((b) => b.onUpdate());
    player.pos_x += speed;
    detectCollisions();

    if (player.pos_y < 0) {
      fail();
    }
    distance += 1; // tick = point
    score = distance + points;

    log("Model: update() tick");

  }

  /// Sets game to fail state
  void fail() {
    state = State.FAIL;
  }

  /// Sets game to won state
  void finish() {
    state = State.WON;
  }

  /// Sets game to running state on current level
  void start() {
    player.reset();
    resetVisibleIndex();
    clearVisibleBlocks();
    player.pos_x = currentLevel.spawn.pos_x;
    player.pos_y = currentLevel.spawn.pos_y;
    points = 0;
    score = 0;
    distance = 0;
    state = State.RUNNING;
  }

  /// Sets game state to main menu
  void mainMenu() {

    state = State.MENU;

  }

  /// Detects players collision with objects
  ///
  /// Detects the players collision with objects in the game world.
  /// The first detection uses [Rect.intersects] to detect a collision,
  /// the second detection uses [collisionDirectionRewind] to find its direction
  void detectCollisions() {
    bool onGround = false;
    for (Block b in visibleBlocks) {
      if (b != null && b.canCollide) {
        if (player.intersects(b)) {
          Direction dir = collisionDirectionRewind(b);
          if (b.onCollision(this, dir)) {
            player.landed();
            player.pos_y = b.pos_y + b.size_y;
            onGround = true;
          }
        }
      }
    }
    if (!onGround) {
      player.fall();
    }
  }

  /// Makes player jump
  void jump() {
    if (state == State.RUNNING) {
      log("Model: jump()");
      player.jump();
    }
  }

  /// Detects collision direction
  ///
  /// Detects collision direction by rewinding the last tick in steps of 1/5.
  /// Splits the rewind into horizontal and vertical steps.
  /// If moving the player back on the y axis stopped the collision, the player collided from either
  /// [Direction.TOP] or [Direction.BOTTOM], depending on [Player.velocity_y]
  /// Similar, if moving the player back on the x axis stopped the collision,
  /// the player collided from either [Direction.LEFT] or [Direction.RIGHT].
  /// Returns [Direction]
  Direction collisionDirectionRewind(Rect rect) {
    final int rewindFactor = 5;

    //player sliding on the floor
    if (player.pos_y == (rect.pos_y + rect.size_y) && player.velocity_y == 0.0) {
      log("Model: collisionDirectionRewind() player sliding");
      return Direction.TOP;
    }

    //save player position
    int saved_pos_x = player.pos_x;
    int saved_pos_y = player.pos_y;

    //rewind time to find collision
    int rewind_x = player.pos_x;
    int rewind_y = player.pos_y;
    int rewindCounter = 0;


    while(rewindCounter < rewindFactor) { // don't rewind past last event
      player.pos_y -= ((player.velocity_y/rewindFactor).round()).toInt();
      if (!player.intersects(rect)) {
        player.pos_x = saved_pos_x;
        player.pos_y = saved_pos_y;
        return player.velocity_y <= 0 ? Direction.TOP : Direction.BOTTOM;
      }
      log("Model: collisionDirectionRewind() rewind_y $rewind_y");

      player.pos_x -= speed ~/ rewindFactor;
      if (!player.intersects(rect)) {
        player.pos_x = saved_pos_x;
        player.pos_y = saved_pos_y;
        return Direction.LEFT;
      }
      log("Model: collisionDirectionRewind() rewind_x $rewind_x");

      rewindCounter++;
    }

    // well this isn't elegant...
    player.pos_y -= ((player.velocity_y).ceil()).toInt();
    if (!player.intersects(rect)) {
      player.pos_x = saved_pos_x;
      player.pos_y = saved_pos_y;
      return player.velocity_y <= 0 ? Direction.TOP : Direction.BOTTOM;
    }
    log("Model: collisionDirectionRewind() rewind_y $rewind_y - LAST RESORT!");

    player.pos_x = saved_pos_x;
    player.pos_y = saved_pos_y;
    // insane default
    return Direction.RIGHT;

  }

  /// Clears all blocks from visibleBlocks Array
  void clearVisibleBlocks() {
    for (int i = 0; i < visibleBlocks.length; i++) {
      visibleBlocks[i] = null;
    }
  }

  /// Adds Block to first free slot in visibleBlocks
  void addToVisibleBlocks(Block b) {
    for (int i = 0; i < visibleBlocks.length; i++) {
      if (visibleBlocks[i] == null) {
        visibleBlocks[i] = b;
        break;
      }
    }
  }

  /// Calculates if [b] is within viewport
  bool isBlockVisible(Block b) {
    if (((b.pos_x + b.size_x) > (player.pos_x - Player.player_offset) && (b.pos_x) < ((player.pos_x - Player.player_offset) + viewport_x)) && (b.isVisible || b.canCollide)) {
      return true;
    }
    return false;
  }

  /// Resets the visiblityIndex, causing next [getVisibleBlocks] call to do a full search
  void resetVisibleIndex() {
    visibleIndex = 0;
  }

  /// Sets [visibleBlocks] to currently visible Blocks
  void getVisibleBlocks() {
    clearVisibleBlocks();
    bool visibleSet = false;
    int countFails = 0;
    const int upperTolerance = 10;
    const int lowerTolerance = 5;
    //get all visible blocks, break when we reach invisible blocks
    for (int i = visibleIndex; i < currentLevel.blockList_static.length; i++) {
      Block b = currentLevel.blockList_static[i];
      if (isBlockVisible(b)) {
        addToVisibleBlocks(b);
        if (!visibleSet) {
          visibleIndex = i - lowerTolerance;
          visibleSet = true;
          countFails = 0;
          if ( visibleIndex.isNegative ) {
            visibleIndex = 0;
            continue;
          }
        }
      } else if (visibleBlocks.length > 0 && countFails >= upperTolerance && visibleSet) {
        // we've most likely passed the visible blocks, break
        log("Model: getVisibleBlocks() breaking after ${countFails} misses");
        break;
      } else {
        countFails++;
      }
    }
    for (Block b in currentLevel.blockList_dynamic) {
      if (isBlockVisible(b)) {
        addToVisibleBlocks(b);
      }
    }
    log(visibleBlocks.toString());
  }

  /// Hashes Strings based on sha256
  String hash(String s) {
    List<int> bytes = UTF8.encode(s);

    return sha256.convert(bytes).toString();
  }

  /// Sets [currentLevel] to JSON [level]
  void setLevel(String level) {
    currentLevel = new Level(level);
    currentLevelHash = hash(level);
    speed = currentLevel.speed ?? 5;
  }

  /// Sets [levels] to levels listed in [jsonString]
  void setLevelList(String jsonString) {
    levels.clear();

    try {
      var jsonData = JSON.decode(jsonString);
      for (Map m in jsonData) {
        levels[m["name"]] = m["filename"];
      }
    } catch(error, stacktrace) {
      print("Model: setLevelList() Error: ${error}");
      print(stacktrace);
    }

  }


}