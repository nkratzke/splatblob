// Big thanks to Nane Kratzke. Most of the code in this file is written by him.

import 'dart:async';
import 'dart:convert';
import 'dart:html';

class GameKey {
  Uri _uri;
  String _gameId;
  String _secret;
  bool _available = false;

  GameKey(String host, int port, this._gameId, this._secret) {
    this._uri = new Uri.http("$host:$port", "/");
  }

  String get gameId => this._gameId;
  Uri get uri => this._uri;

  /**
   * Helper method to generate parameter body for REST requests.
   */
  static String parameter(Map<String, String> p) => (new Uri(queryParameters: p)).query;

  /**
   * Registers a non existing user with the gamekey service.
   * - Returns user map with stored values on success
   * - Returns null if user could not be stored (due to several reasons, gamekey service not reachable, user already existing)
   */
  Future<Map> registerUser(String name, String pwd) async {
    if (!this._available) {
      return new Future.value(null);
    }

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
    } catch(error, stacktrace) {
      print("Error: '$error'");
      print("$stacktrace");

      return null;
    }
  }

  /**
   * Returns detailed user information as Map.
   * Additionally, this method can be used to authenticate a user.
   * A user must know his [id] and his [password].
   */
  Future<Map> getUser(String id, String pwd) async {
    if (!this._available) {
      return new Future.value(null);
    }

    try {
      final uri = this._uri.resolve("/user/$id").resolveUri(new Uri(queryParameters: { 'pwd' : "$pwd" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      return answer.status == 200 ? JSON.decode(answer.responseText) : throw answer.responseText;
    } catch(error, stacktrace) {
      print("Error: '$error'");
      print("$stacktrace");

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
      final uri = this._uri.resolve("/game/${this._gameId}").resolveUri(new Uri(queryParameters: { 'secret' : "${this._secret}" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');

      if (answer.status == 200) {
        this._available = true;
      }

      return answer.status == 200 ? true : throw answer.responseText;
    } catch(error, stacktrace) {
      this._available = false;

      print("Error: '$error'");
      print("$stacktrace");

      return false;
    }
  }

  /**
   * Lists all users registered with the gamekey service.
   */
  Future<List<Map>> listUsers() async {
    if (!this._available) {
      return new Future.value([]);
    }

    try {
      final answer = await HttpRequest.request("${this._uri.resolve("/users")}", method: 'GET');
      return JSON.decode(answer.responseText);
    } catch(error, stacktrace) {
      print("Error: '$error'");
      print("$stacktrace");

      return null;
    }
  }

  /**
   * Returns the user id of a given name.
   * Returns null if name is not present or on error.
   */
  Future<String> getUserId(String name) async {
    if (!this._available) {
      return new Future.value(null);
    }

    try {
      final users = await this.listUsers();
      if (users == null) {
        return null;
      }

      final user = users.firstWhere((user) => user['name'] == name, orElse: null);
      return user == null ? null : user['id'];
    } catch(error, stacktrace) {
      print("Error: '$error'");
      print("$stacktrace");

      return null;
    }
  }

  /**
   * Retrieves all states stored for this game.
   */
  Future<List<Map>> getStates() async {
    if (!this._available) {
      return new Future.value([]);
    }

    try {
      final uri = this._uri.resolve("/gamestate/${this._gameId}").resolveUri(new Uri(queryParameters: { 'secret' : "${this._secret}" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      return JSON.decode(answer.responseText);
    } catch(error, stacktrace) {
      print("Error: '$error'");
      print("$stacktrace");

      return null;
    }
  }

  /**
   * Stores an arbitrary state encoded as map for a user with identifier [uid]
   * for this game.
   */
  Future<bool> storeState(String uid, Map state) async {
    if (!this._available) {
      return new Future.value(false);
    }

    try {
      final answer = await HttpRequest.request(
          "${this._uri.resolve("/gamestate/${this._gameId}/$uid")}",
          method: 'POST',
          sendData: parameter({
            'secret' : "${this._secret}",
            'state' : "${JSON.encode(state)}",
          }),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
      );
      return answer.status == 200 ? true : throw answer.responseText;
    } catch(error, stacktrace) {
      print("Error: '$error'");
      print("$stacktrace");

      return false;
    }
  }
}
