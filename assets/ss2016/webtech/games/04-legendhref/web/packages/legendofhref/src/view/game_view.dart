part of legendofhref;

class GameView {
  Game game;
  DivElement gameDiv, overlayDiv, mainmenuDiv, _gameoverDiv;
  SpanElement _scoreSpan, _killcountSpan;
  GameView(this.game, this.gameDiv, this.overlayDiv, this.mainmenuDiv) {
    game.view = this;
  }
  
  DivElement get gameoverDiv => _gameoverDiv??(_gameoverDiv = overlayDiv.querySelector("#gameover"));
  SpanElement get scoreSpan => _scoreSpan??(_scoreSpan = gameoverDiv.querySelector("#score"));
  SpanElement get killcountSpan => _killcountSpan??(_killcountSpan = gameoverDiv.querySelector("#killcount"));
  
  void update() {
    
  }
  
  void gameover() {
    querySelector("#game").classes.add("blurred");
    querySelector("#title").classes.add("blurred");
    querySelector("#overlay").classes.add("focussed");
    overlayDiv.hidden = false;
    gameoverDiv.hidden = false;
    scoreSpan.innerHtml = game.pc.score.toString();
    killcountSpan.innerHtml = game.pc.killcount.toString();
  }
  
  void stopGameover() {
    querySelector("#game").classes.remove("blurred");
    querySelector("#title").classes.remove("blurred");
    querySelector("#overlay").classes.remove("focussed");
    overlayDiv.hidden = true;
    gameoverDiv.hidden = true;
    
  }
  
  void showMenu() {
    gameDiv.hidden = true;
    mainmenuDiv.hidden = false;
  }
  
  void hideMenu() {
    mainmenuDiv.hidden = true;
    gameDiv.hidden = false;
  }
}