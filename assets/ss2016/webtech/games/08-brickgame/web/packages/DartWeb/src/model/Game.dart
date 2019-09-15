part of brickGame;

///
/// contains all objects and methods necessary to play the game
/// for detailed information check the respective classes
///
class Game {

  ///
  /// current [Level]
  ///
  int countLevel;

  ///
  /// amount of levels
  /// will increase if there are more json files to read
  ///
  int checkLevel = 1;

  ///
  /// points the player currently has
  ///
  int points=0;

  ///
  /// list of all levels
  ///
  List<Level> gameFields;

  ///
  /// Creates game field list and reads the JSON file to get every level
  ///
  Game() {
    gameFields = new List();
    countLevel = 0;
    _readConfig();
  }

  ///
  /// moves [Ball]
  /// [direction] the direction in which the [Ball] will move
  ///
  void moveBall(GameController controller) {
    List balls = gameFields[countLevel].balls;
        balls.forEach((ball) {
          //only activated balls will move
          if (ball.activated) {
            ball.move(
                ball.direction, gameFields[countLevel].gameField, controller);
            if (ball.destroyed) {
              ball.activated=false;
              controller.updateView(gameFields[countLevel].gameField);
              return;
            }
          }
          if (won()) newLevel();
        });
  }

  ///
  /// moves the player in the direction that is given
  /// [direction] the direction in which the player will move
  ///
  void movePlayer(Direction direction, GameController controller) {
    Player player = _getPlayer();
    if (!gameOver()) {
      for (int i = player.moveSpeed; i > 0; i--) {
        player.move(direction, gameFields[countLevel].gameField, controller);
      }
    }
  }

  ///
  /// returns [Player]
  ///
  Player _getPlayer() {
    return gameFields[countLevel].player;
  }
  ///
  /// check if the game is lost
  ///
  bool gameOver() {
    bool gameOver=true;
    gameFields[countLevel].balls.forEach((b){
      if(!b.destroyed&&b.activated){
        gameOver=false;
      }
    });
    return gameOver;
  }
  ///
  /// check if the level is successfully won
  ///
  bool won() {
    return !gameFields[countLevel].bricks.any((brick)=> brick.health!=Health.grey);
  }

  ///
  /// prepare the next level
  ///
  void newLevel() {
    if(countLevel != gameFields.length - 1) {
      gameFields[countLevel].balls.forEach((ball){
        ball.activated=false;
        ball.destroyed=true;
      });
      countLevel++;
    }

  }

  ///
  /// increase points for every hit against a brick
  ///
  void increasePoints(Health health){
    points += 10;
  }
  ///
  /// checks if the entire game is over
  ///
  bool gameEnds(){
    if(countLevel==gameFields.length-1){
        if(won()){
          return true;
        }
      }
      return false;
  }


  ///
  /// reads the json files to get every level
  ///
  Future<bool> _readConfig() async {
    // reads .json in a string
    for(int i = 0; i < checkLevel; i++) {
      final answer = await HttpRequest.getString('level${i}.json');

      String jsonLevel = answer;
      Level level = new Level();
      level.readLevel(jsonLevel);
      gameFields.add(level);
      checkLevel++;
    }
  }
}
