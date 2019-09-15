part of legendofhref;

class GameController {
  final Game _game;

  int _act1X, _act1XStart, _act1Y, _act1YStart;
  
  GameController(this._game);
  
  void playerTurn(int action, [var param]) {
    if((!_game.isTurnbased || _game.enemyTurnDone) && _game.ready && _game.isRunning) {
      _game.ready = false;
      switch(action) {
        case ACTION_MOVE:
          _game.pc.move(param);
          break;
        case ACTION_SWITCH_ATTACK:
          _game.pc.attackAction = param;
          break;
        case ACTION_ATTACK:
          _game.pc.attack();
          break;
        case ACTION_USE:
          _game.pc.useHealpotion();
          break;
      }
      _game.map.view.update();
      if (_game.isTurnbased && _game.isRunning) {
        _game.turn();
      }
    }
  }

  void keyDownListener(KeyboardEvent e) {
    String s = new String.fromCharCode(e.keyCode);
    switch (s) {
      case 'P':
      case 'M':
        _game.togglePause();
        break;
      default:
        if (!_game.isRunning) return;
        switch (s) {
          case '1':
            playerTurn(ACTION_SWITCH_ATTACK, 0);
            break;
          case '2':
            playerTurn(ACTION_SWITCH_ATTACK, 1);
            break;
          case '3':
            playerTurn(ACTION_SWITCH_ATTACK, 2);
            break;
          case '4':
            playerTurn(ACTION_SWITCH_ATTACK, 3);
            break;
          case 'W':
            playerTurn(ACTION_MOVE, Vector.NORTH);
            break;
          case 'A':
            playerTurn(ACTION_MOVE, Vector.WEST);
            break;
          case 'S':
            playerTurn(ACTION_MOVE, Vector.SOUTH);
            break;
          case 'D':
            playerTurn(ACTION_MOVE, Vector.EAST);
            break;
          case 'J':
            playerTurn(ACTION_ATTACK);
            break;
          case 'K':
            playerTurn(ACTION_USE);
            break;
          default:
            return;
        }
        break;
    }
  }

  void attackTouchStartListener(TouchEvent e) {
    _act1XStart = e.touches.first.page.x;
    _act1YStart = e.touches.first.page.y;
    _act1X = e.touches.last.page.x;
    _act1Y = e.touches.last.page.y;
  }

  void attackTouchMoveListener(TouchEvent e) {
    _act1X = e.touches.last.page.x;
    _act1Y = e.touches.last.page.y;
  }

  void attackTouchEndListener(TouchEvent e) {
    int diffX = _act1X - _act1XStart;
    int diffY = _act1Y - _act1YStart;
    if (diffX.abs() < MOTION_TOLERANCE &&
        diffY.abs() < MOTION_TOLERANCE &&
        (diffX.abs() - diffY.abs()).abs() < MOTION_TOLERANCE) {
      playerTurn(ACTION_ATTACK);
      return;
    } else {
      if (diffX.abs() < diffY.abs()) {
        if (diffY.isNegative) {
          playerTurn(ACTION_SWITCH_ATTACK, 0);
        } else {
          playerTurn(ACTION_SWITCH_ATTACK, 2);
        }
      } else {
        if (diffX.isNegative) {
          playerTurn(ACTION_SWITCH_ATTACK, 3);
        } else {
          playerTurn(ACTION_SWITCH_ATTACK, 1);
        }
      }
    }
  }
  
  void attackClickListener(MouseEvent e) {
    playerTurn(ACTION_ATTACK);
  }

  void useListener(e) {
    playerTurn(ACTION_USE);
  }
  
  void moveNorthListener(e) {
    playerTurn(ACTION_MOVE, Vector.NORTH);
  }
  
  void moveEastListener(e) {
    playerTurn(ACTION_MOVE, Vector.EAST);
  }
  
  void moveSouthListener(e) {
    playerTurn(ACTION_MOVE, Vector.SOUTH);
  }
  
  void moveWestListener(e) {
    playerTurn(ACTION_MOVE, Vector.WEST);
  }
}
