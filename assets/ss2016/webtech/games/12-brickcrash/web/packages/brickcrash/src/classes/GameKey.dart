part of brickcrash;
/**
 * Provides parts of the GameKey REST API necessary for the SnakeGame.
 * Original Code: Nane Kratzke
 * Extension: Mihail Usenko, Johann Schnitkov
 */
class GameKey {
  static const OFFLINE    = 0;
  static const CONNECTING = 1;
  static const ONLINE     = 2;

  Uri _uri;                         // URI of GameKey Service
  String _gid = "";                 // Game ID
  String _secret = "";              // Game secret
  String settingsPath = "";

  int status              = OFFLINE;

  Timer gamekeyTrigger    = null;
  Duration gamekeyCheck   = new Duration(milliseconds: 30);

  String get gameId => this._gid;
  Uri get uri       => this._uri;

  /**
   * Constructor
   */
  GameKey(this.settingsPath) { }


  /*
    SETTER
   */
  Future setStatus(status) async { this.status = status; }

  /*
   * GETTER
   */

  bool isOnline()   { return this.status == ONLINE; }
  bool isOffline()  { return this.status == OFFLINE; }
  int  getStatus()  { return this.status; }

  /**
   * Helper method to generate parameter body for REST requests.
   */
  static String parameter(Map<String, String> p) => (new Uri(queryParameters: p)).query;

  Future<bool> connect() async {
    try {
      await HttpRequest.getString(settingsPath).then((json) async {
      final settings = JSON.decode(json);
      this._secret = settings["secret"];
      this._uri = new Uri.http(settings["host"] + ":" + settings["port"].toString(), "/");
      this._gid = settings['gameid'];
      });
      bool status = false;
      status = await this.authenticate();
      return  status;

    } catch(error) {
      print(error);
    }

  }

  /**
   * anmelden oder registrieren.
   * @return String UID, falls Anmeldung erfolgreich. "-1", falls Passwort nicht ueberienstimmt und "-2", falls der Passwort zu kurz ist
   */
  Future<String> login(String username, String password) async {
    try{
      String uid = await this.getUserId(username);
      if (uid != null) {                      // falls der User existiert
        return await this.getUser(uid, password) != null ? uid : "-1";
      } else {                                // falls der User nicht existiert
        if (password.length >= 6) {           // und die Laenge des Passworts ausreichend ist
          Map userData = await this.registerUser(username, password);
          return userData["id"];
        } else {
          return "-2";
        }
      }
      return uid;
    } catch(error){
      print(error);
    }

  }

  /**
   * ruft die TOP-10 - Liste auf.
   * @return Liste aus den Maps, wobei als Key der Username, und als Wert der erreichte Punktestand steht.
   */
  Future<List<Map<String, int>>> getHighScore() async {
    List<Map<String, int>> top10 = [];

    if (this.isOnline()) {
      await this.getStates().then((list) {
        Map<int,List<Map>> sortedScores = new Map<int,List<Map>>();

        list.forEach((map)  {
          int points = map["state"]["points"];

          if (sortedScores[points] == null) { sortedScores[points] = []; }
          sortedScores[points].add(map);
        });

        int counter = 0;
        List keys = sortedScores.keys.toList();
        List sortedKeys = keys..sort();

        sortedKeys.reversed.forEach((points){
          sortedScores[points].forEach((map){
            if (counter < 10) { top10.add(map); }
            counter++;
          });
        });
      });
    }
    return top10;
  }

  /**
   * Registers a non existing user with the gamekey service.
   * - Returns user map with stored values on success
   * - Returns null if user could not be stored (due to several reasons, gamekey service not reachable, user already existing)
   */
  Future<Map> registerUser(String name, String pwd) async {
    if (this.isOffline()) return new Future.value(null);
    try {
      final answer = await HttpRequest.request(
          "${this._uri.resolve("/user")}",
          method: 'POST',
          sendData: parameter({
            'name'   : "$name",
            'pwd' : "$pwd",
          }),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
      );
      return answer.status == 200 ? JSON.decode(answer.responseText) : throw answer.responseText;
    } catch (error, stacktrace) {
      print ("GameKey.registerUser() caused following error: '$error'");
      print ("$stacktrace");
      return null;
    }
  }

  /**
   * Returns detailed user information as Map.
   * Additionally, this method can be used to authenticate a user.
   * A user must know his [id] and his [password].
   */
  Future<Map> getUser(String id, String pwd) async {
    if (this.isOffline()) return new Future.value(null);
    try {
      final uri = this._uri.resolve("/user/$id").resolveUri(new Uri(queryParameters: { 'pwd' : "$pwd" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      return answer.status == 200 ? JSON.decode(answer.responseText) : throw answer.responseText;
    } catch (error, stacktrace) {
      print ("GameKey.getUser() caused following error: '$error'");
      print ("$stacktrace");
      return null;
    }
  }

  /**
   * This method can be used to authenticate a game.
   * A game must know its [id] and its [secret].
   * This method is used to check periodically gamekey service availability
   * and sets _available flag accordingly.
   */
  Future<bool> authenticate() async {
    try {
      final uri = this._uri.resolve("/game/$_gid")
          .resolveUri(new Uri(queryParameters: { 'secret' : "$_secret" }));

      if (this.status == OFFLINE) { this.setStatus(CONNECTING); }
      final answer = await HttpRequest.request("$uri", method: 'GET').timeout(new Duration(seconds: 5));
      if (answer.status == 200) { this.setStatus(ONLINE); }
      return answer.status == 200 ? true : throw answer.responseText;
    } catch (error,Stacktrace) {
      print(error);
      print(Stacktrace);
      this.setStatus(OFFLINE);
      return false;
    }
  }

  /**
   * Returns the user id of a given name.
   * Returns null if name is not present or on error.
   */
  Future<String> getUserId(String name) async {
    if (this.isOffline()) return new Future.value(null);
    try {
      final users = await listUsers();
      if (users == null) return null;
      final user = users.firstWhere((user) => user['name'] == name, orElse: null);
      return user == null ? null : user['id'];
    } catch (error, stacktrace) {
      print ("GameKey.getUserId() caused following error: '$error'");
      print ("$stacktrace");
      return null;
    }
  }

  /**
   * Lists all users registered with the gamekey service.
   */
  Future<List<Map>> listUsers() async {
    if (this.isOffline()) return new Future.value([]);
    try {
      final answer = await HttpRequest.request("${this._uri.resolve("/users")}", method: 'GET');
      return JSON.decode(answer.responseText);
    } catch (error, stacktrace) {
      print ("GameKey.listUsers() caused following error: '$error'");
      print ("$stacktrace");
      return null;
    }
  }

  /**
   * Den Spieler loeschen.
   * @param username Spielername
   * @param pwd Passwort
   * @return
   */
  Future<List<Map>> deleteUser(String username,String pwd) async {
    if (this.isOffline()) return new Future.value([]);
    try {
      Future<List<Map>> users = this.listUsers();
      this.getUserId(username).then(await (userID) {
        HttpRequest.request(
            "${this._uri.resolve("/user/"+userID)}",
            method: 'DELETE',
            sendData: parameter({
              'pwd' : "$pwd",
            }),
            requestHeaders: {
              'content-type': 'application/x-www-form-urlencoded'
            }
        );
      });
      return users;
    } catch (error, stacktrace) {
      print ("GameKey.listUsers() caused following error: '$error'");
      print ("$stacktrace");
      return null;
    }
  }
  /**
   * Retrieves all states stored for this game.
   */
  Future<List<Map>> getStates() async {
    if (this.isOffline()) return new Future.value([]);
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

  /**
   * Stores an arbitrary state encoded as map for a user with identifier [uid]
   * for this game.
   */
  Future<bool> storeState(String uid, Map state) async {
    if (this.isOffline()) return new Future.value(false);
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
      print ("GameKey.storeState() caused following error: '$error'");
      print ("$stacktrace");
      return false;
    }
  }
}