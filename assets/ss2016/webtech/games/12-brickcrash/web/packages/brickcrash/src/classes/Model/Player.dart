part of brickcrash;
/**
 * Die Player Klasse ist fuer den Spieler gedacht. Diese setzt seine Lebespunkte
 * und seinen Spielstand im laufe des Spieles und Aktuallisert diese auch
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */
class Player {
  String UID        = "GUEST";      // Die User ID der Spielers
  int score         = 0;            // aktuelle Punktestand
  int lives         = 0;            // Leben
  String username   = "Guest";      // Der Name des Spielers

  /*
    CONSTRUCTOR
   */
  /**
   * Der Name und die User ID werden gesetzt
   * @param uid User ID
   * @param name Name des Users
   */
  Player (String uid, String name) { this.setUID(uid); this.username = name;}

  /*
    GETTER
   */
  int getScore()        { return this.score;    }
  String getUID()       { return this.UID;      }
  int getLives()        { return this.lives;    }
  String getUserName()  { return this.username; }

  /*
    SETTER
   */
  void setScore(int score)          { this.score = score; }
  void setUID(String uid)           { this.UID   = uid;   }
  void setLives(int lives)          { this.lives = lives; }

  /*
    METHODS
   */
  /**
   * Lebenspunkte erhoehen
   * @param lives Leben
   */
  Future addLives(int lives) async    { this.lives += lives; }

  /**
   * Punkte addieren
   * @param points Punkte
   */
  Future addScore(points) async { this.score += points; }

  /**
   * Ein Leben abziehen
   */
  Future reduceLive() async { this.lives--; }
}