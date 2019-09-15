part of breakoutDart;

/*
    GameKeyClient
 */
class GameKeyClient {

  Uri _uri;
  String _secret;
  String _gid;
  bool GameKey_available = false;
  
  Uri get uri => this._uri;
  String get gameID => this._gid;
  static String parameter(Map<String, String> p) => (new Uri(queryParameters: p)).query;
  
  
  GameKeyClient(String host, int port, this._gid, this._secret) {
    this._uri = new Uri.http("$host:$port","/");
  }

  /*
     check's if the gamekey is connected
   */
  Future<bool> authenticate() async {
    try {
      final uri = this._uri.resolve("/game/$_gid").resolveUri(new Uri(queryParameters: { 'secret' : "$_secret" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');
     
      if (answer.status == 200) { 
        this.GameKey_available = true; 
      }
      
      return answer.status == 200 ? true : throw answer.responseText;
    
    } catch (error, stacktrace) {
      print ("GameKey.getGame() caused following error: '$error'");
      print ("$stacktrace");
      this.GameKey_available = false;
      return false;
    }
  }

  /*
      get's all states of the game
   */
  Future<List<Map>> getStates() async {
    if (!GameKey_available) 
      return new Future.value([]);
    try {
      final uri = this._uri.resolve("/gamestate/$_gid").resolveUri(new Uri(queryParameters: { 'secret' : "$_secret" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      return JSON.decode(answer.responseText);
    } catch (error, stacktrace) {
      print ("GameKey.getStates() caused following error: '$error'");
      print ("$stacktrace");
      return null;
    }
  }

  /*
      post's and register a new User
      this function needs two parameters (name of the User)
      and the (pwd : password)
   */
  Future<Map> registerUser(String name, String pwd) async {
    if (!GameKey_available)
      return new Future.value(null);
    try {

      final answer = await HttpRequest.request(
          "${this._uri.resolve("/user")}",
          method: 'POST',
          sendData: parameter({
            'name' : "$name",
            'pwd' : "$pwd",
          }),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
      );

      return answer.status == 200 ? JSON.decode(answer.responseText) : throw answer.responseText;

    } catch (error, stacktrace) {
      print("GameKey.registerUser() caused following error: '$error'");
      print("$stacktrace");
      return null;
    }
  }
  /*
      get's the List of all Users
   */
  Future<List<Map>> listUsers() async {
    if (!GameKey_available)
      return new Future.value([]);

    try {

      final answer = await HttpRequest.request("${this._uri.resolve("/users")}", method: 'GET');

      return JSON.decode(answer.responseText);

    } catch (error, stacktrace) {
      print("GameKey.listUsers() caused following error: '$error'");
      print("$stacktrace");
      return null;
    }
  }

  /*
      get's the UserId of a User
      this function needs the parameter (name) of the User
   */
  Future<String> getUserId(String name) async {
    if (!GameKey_available)
      return new Future.value(null);

    try {
      var user = null;
      final users = await listUsers();
      if (users == null)
        return null;
      for(var u in users)
      {
        if(u["name"] == name)
        {
          user = u;
          break;
        }
      }
      return user == null ? null : user['id'];

    } catch (error, stacktrace) {
      print("GameKey.getUserId() caused following error: '$error'");
      print("$stacktrace");
      return null;
    }
  }

  /*
      get's only one User
      this function needs two parameter the (id) and the (pw:password)
       of the User
   */
  Future<Map> getUser(String id, String pwd) async {
    if (!GameKey_available)
      return new Future.value(null);

    try {

      final uri = this._uri.resolve("/user/$id").resolveUri(new Uri(queryParameters: { 'pwd' : "$pwd"}));
      final answer = await HttpRequest.request("$uri", method: 'GET');

      return answer.status == 200 ? JSON.decode(answer.responseText) : throw answer.responseText;

    } catch (error, stacktrace) {
      print("GameKey.getUser() caused following error: '$error'");
      print("$stacktrace");
      return null;
    }
  }

  /*
      store's the State in  (state) for a
      User with identifier (uid) for this game

   */
  Future<bool> storeState(String uid, Map state) async {
    if (!GameKey_available)
      return new Future.value(false);

    try {

      final answer = await HttpRequest.request(
          "${this._uri.resolve("/gamestate/$_gid/$uid")}",
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

    } catch (error, stacktrace) {
      print("GameKey.storeState() caused following error: '$error'");
      print("$stacktrace");
      return false;
    }
  }

  /*
      change's the Username of a User
      function needs three parameter's (oldName), (newName) and (pwd)
      of the User
   */
  Future<bool> changeUsername(String oldName, String newName, String pwd) async
  {
    if (!GameKey_available)
      return new Future.value(false);

    try {

      final userID = await getUserId(oldName);

      if(userID == null)
          return false;

      final answer = await HttpRequest.request(
          "${this._uri.resolve("/user/$userID")}",
          method: 'PUT',
          sendData: parameter(
              {
            'id' : "$userID",
            'pwd' : "$pwd",
            'name' : "$newName",
          }),
          requestHeaders:
          {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
          );

          return answer.status == 200 ? true : throw answer.responseText;
    }
      catch (error, stacktrace)
      {
        print("GameKey.storeState() caused following error: '$error'");
        print("$stacktrace");
        return false;
      }
  }

  /*
      change's the User password
      this function needs three parameter's (name), (oldPW) and (newPW)
   */
  Future<bool> changeUserPassword(String name, String oldPW, String newPW) async {
    if (!GameKey_available)
      return new Future.value(false);

    try{

      final userID = await getUserId(name);

      if (userID == null)
      return false;

      final answer = await HttpRequest.request(
        "${this._uri.resolve("/user/$userID")}",
        method: 'PUT',
        sendData: parameter(
            {
              'id' : "$userID",
              'pwd' : "$oldPW",
              'newpwd' : "$newPW",
            }),
        requestHeaders:
        {
          'content-type': 'application/x-www-form-urlencoded',
          'charset': 'UTF-8'
        }
    );

      return answer.status == 200 ? true : throw answer.responseText;
    }
    catch (error, stacktrace)
    {
      print("GameKey.storeState() caused following error: '$error'");
      print("$stacktrace");
      return false;
    }
  }

  /*
       delete's the User
       this function needs two parameter the (userID) of the User and (pwd)
   */
  Future<bool> deleteUser(String userID,String pwd) async {
    if (!GameKey_available)
      return new Future.value(null);

    try {

      final answer = await HttpRequest.request(
          "${this._uri.resolve("/user/$userID")}",
          method: 'DELETE',
          sendData: parameter({
          'id' : "$userID",
          'pwd' : "$pwd",
          }),
          requestHeaders:
          {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
      );
      return answer.status == 200 ? true : throw answer.responseText;

    } catch (error, stacktrace) {
      print("GameKey.deleteUser() caused following error: '$error'");
      print("$stacktrace");
      return null;
    }
  }
}

