part of brickGame;

/**
 *  Implementation of the client connection to the GameKey Server
 *
 */

/*
  Contains the GameKey REST API for BrickGame
 */
class GameKey{

  //Uri of the GameKey Service
  Uri _uri;

  //Id of the Game
  String _gameid = "c1b8f208-1e57-4431-bc7e-82f9db6e2780";

  //Secret of the game, need to authenticate the current game with the GameKey service
  String _secret = "DontWorryAboutaT23";

  //Name of the Game
  String _nameofGame = "BrickGame1";

  ///
  ///Uri of GameKey REST API
  ///
  Uri get uri => this._uri;

  ///
  ///Game ID of the current Game
  ///
  String get getGameId => this._gameid;

  ///
  ///Game secret of the current Game
  ///
  String get getSecret => this._secret;

  ///
  ///Helper method to generate parameter body for REST requests
  ///
  static String parameter(Map<String, String> p) => (new Uri(queryParameters: p)).query;

  ///
  ///Constructor
  ///
  GameKey(String host, int port){
    _uri = new Uri.http("$host:$port","");
  }

  ///
  ///Registers a non existing game with the GameKey service
  ///Returns a map with the new registered game on succes
  ///Return null on failure
  ///
  Future<Map> registerGame(String secret, String name) async{
    try {
      final answer = await HttpRequest.request(
          "${this._uri.resolve("/user")}",
          method: 'POST',
          sendData: parameter({
            'name' : "$name",
            'secret' : "$secret"
          }),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
      );
      return answer.status == 200 ? JSON.decode(answer.responseText) : throw answer.responseText;
    } catch (error) {
      print("GameKey.registerGame() caused an error: '$error'");
      return null;
    }
  }

  ///
  ///Registers a non existing user with the GameKey service
  ///Returns a map with the new registered users on succes
  ///Returns null on failure
  ///
  Future<Map> registerUser(String name, String password) async{
    try {
      final answer = await HttpRequest.request(
          "${this._uri.resolve("/user")}",
          method: 'POST',
          sendData: parameter({
            'name' : "$name",
            'pwd' : "$password"
          }),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
      );
      return answer.status == 200 ? JSON.decode(answer.responseText) : throw answer.responseText;
    } catch (error) {
      print("GameKey.registerUser() caused an error: '$error'");
      return null;
    }
  }

  ///
  ///Returns a map with all information about the given user on succes
  ///Returns null on failure
  ///
  Future<Map> getUser(String name, String password) async{
    try {
      final uri = this._uri.resolve("/user/$name").resolveUri(new Uri(queryParameters: { 'pwd' : "$password" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      return answer.status == 200 ? JSON.decode(answer.responseText) : throw answer.responseText;
    } catch (error) {
      print("GameKey.getUser() caused an error: '$error'");
      return null;
    }
  }

  ///
  ///This method can be used to authenticate the current game
  ///and to check weather the gamekey service
  ///is available or not
  ///
  Future<bool> authenticate() async{
    try {
      final uri = this._uri.resolve("/game/$getGameId").resolveUri(new Uri(queryParameters: { 'secret' : "$getSecret" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      return answer.status == 200 ? true : false;
    } catch (error) {
      print("GameKey.authenticate() caused an error: '$error");
      return false;
    }
  }

  ///
  ///Returns the user id of the given name
  ///Returns null on failure
  ///
  Future<String> getUserId(String name) async{
    try {
      final listusers = await listUsers();
      if (listusers == null) return null;
      final user = listusers.firstWhere((user) => user['name'] == name, orElse : null );
      return user == null ? null :user['id'];
    } catch (error) {
      print("GameKey.getUserId() caused an error: '$error'");
      return null;
    }
  }

  ///
  ///Returns a JSON list with all registered users with the GameKey service
  ///Returns null on failure
  ///
  Future<List<Map>> listUsers() async{
    try {
      final answer = await HttpRequest.request("${this._uri.resolve("/users")}", method: 'GET');
      return JSON.decode(answer.responseText);
    } catch (error) {
      print("GameKey.listUsers() caused an error: '$error'");
      return null;
    }
  }

  ///
  ///Returns a JSON list with all registered games with the GameKey service
  ///Returns null on failure
  ///
  Future<List<Map>> listGames() async{
    try {
      final answer = await HttpRequest.request("${this._uri.resolve("/games")}", method: 'GET');
      return JSON.decode(answer.responseText);
    } catch (error) {
      print("GameKey.listGames() caused an error: '$error'");
      return null;
    }
  }

  ///
  ///Returns a JSON list with all stored states for this game
  ///Returns null if no game states exist for this game
  ///
  Future<List<Map>> getStates() async{
    try {
      final uri = this._uri.resolve("/gamestate/$getGameId").resolveUri(new Uri(queryParameters: { 'secret' : "$getSecret" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      return JSON.decode(answer.responseText);
    } catch (error) {
      print("GameKey.getStates() caused an error: '$error'");
      return null;
    }
  }

  ///
  ///Returns a JSON list with the saved states of this user
  ///
  Future<bool> storeState(String id, Map state) async{
    try {
      final answer = await HttpRequest.request(
          "${this._uri.resolve("/gamestate/$getGameId/$id")}",
          method: 'POST',
          sendData: parameter({
            'secret' : "$_secret",
            'state' : "${JSON.encode(state)}",
          }),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
      );
      return answer.status == 200 ? true : throw answer.responseText;
    } catch (error) {
      print("GameKey.storeState() caught an error: '$error'");
      return false;
    }
  }
}