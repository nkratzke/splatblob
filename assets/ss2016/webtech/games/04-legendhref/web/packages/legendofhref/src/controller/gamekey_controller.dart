part of legendofhref;

class GamekeyController {
  /**
   * Constants necessary for the gamekey connection.
   */
  static const String _gameSecret = 'a55bef2f9808d292';

  Gamekey _gamekey;
  Timer _gamekeyTrigger;
  bool _gamekeyStatus = false;

  GamekeyController(MasterController mc, Map gamekeySettings) {
    _gamekey = new Gamekey(gamekeySettings['host'], gamekeySettings['port'],
        gamekeySettings['id'], _gameSecret);

    // Check periodically if gamekey service is reachable. Display warning if not.
    _gamekeyTrigger = new Timer.periodic(gamekeyCheck, (_) async {
      bool newGamekeyStatus;
      if (await this._gamekey.authenticate()) {
        newGamekeyStatus = true;
      } else {
        newGamekeyStatus = false;
      }
      if(newGamekeyStatus != gamekeyStatus) {
        _gamekeyStatus = newGamekeyStatus;
        mc.updateGamekeyStatus();
      }
    });
    _gamekey.authenticate().then((b){
      if(b) {
        mc.updateGamekeyStatus();
      }
    });
  }

  Map user = null;
  bool signedIn = false;
  bool get gamekeyStatus => _gamekeyStatus;
  
  /**
   * Registers user and signs them in
   * returns 0 if user already exists or service is unavailable
   * returns -1 if user couldn't be registered
   * returns 1 if user was successfully registered
   */
  Future<int> registerUser(String name, String password) async {
    String id = await _gamekey.getUserId(name);
    if (id != null)
      return 0;
    else {
      user = await _gamekey.registerUser(name, password);
      if (user == null)
        return -1;
      else {
        signedIn = true;
        return 1;
      }
    }
  }

  /**
   * Authenticates user
   * returns 0 if user not found or service is unavailable
   * returns -1 if the password was incorrect or service is unavailable
   * returns 1 if user was signed in successfully
   */
  Future<int> signInUser(String name, String password) async {
    String id = await _gamekey.getUserId(name);
    if (id == null)
      return 0;
    else {
      user = await _gamekey.getUser(id, password);
      if (user == null)
        return -1;
      else {
        signedIn = true;
        return 1;
      }
    }
  }
  
  void signOutUser() {
    user = null;
  }
  
  Future<bool> storeState(Map json) async {
    if(user != null) {
      return await _gamekey.storeState(user["id"], json);
    }
    return false;
  }
}
