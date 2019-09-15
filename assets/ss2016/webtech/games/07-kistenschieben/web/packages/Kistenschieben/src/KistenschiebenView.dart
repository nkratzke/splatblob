import 'dart:async';
import 'dart:html';

/**
 * The View of the game Kistenschieben. Is used to display the game
 */
class KistenschiebenView {

  List<List<HtmlElement>> _field;

  int _tableH = 0;        //amount of fieldobjects vertical
  int _tableW = 0;        //amount of fieldobjects horizontal
  bool _changed = false;  //needed if a mobile device is used to enable widescreen after portrait mode

  /*
  Constructor
  */
  KistenschiebenView() {
    print("running view...");
  }

  /*
  Generetes the Overlay with Startbuttons
  */
  void startScreen() {
    querySelector('#start').innerHtml =
    "<div id=\"overlay\">"
        "<div>"
        "<button id=\"registerbutton\" class=\"option\">Register(1)</button>"
        "</div>"
        "<div>"
        "<button id=\"loginbutton\" class=\"option\">Login(2)</button>"
        "</div>"
        "<div>"
        "<button id=\"wObutton\" class=\"option\">Without login(3)</button>"
        "</div>"
        "<div>"
        "<button id=\"aboutbutton\" class=\"option\">About(4)</button>"
        "</div>"
        "</div>";
  }

  /*
  Generates the Inputelements
  */
  void userDates(String fromLayer) {
    querySelector('#userinput').innerHtml =
    "<div id =\"overlay\" >"
        "<form id=\"inputdates\">"
        "<input type=\"text\" id=\"username\" placeholder=\"Username\">"
        "<input type=\"password\" id=\"userpassword\" placeholder=\"Password\">"
        "<button type =\"button\" id=\"submit\">$fromLayer(&#x21b5)</button>"
        "<button type =\"button\" id=\"back\">Back</button>"
        "</form>"
        "</div>";
  }

  /*
  Generates the buttons to access the Game
  */
  Future registeredScreen() async {
    querySelector('#registered').innerHtml =
    "<div id=\"overlay\">"
        "<div>"
        "<button id=\"newgame\" class=\"option\">New Game(1)</button>"
        "</div>"
        "<div>"
        "<button id=\"edituserbutton\" class=\"option\">Edit User(2)</button>"
        "</div>"
        "<div>"
        "<button id=\"levelcodebutton\" class=\"option\">Enter Levelcode(3)</button>"
        "</div>"
        "<div>"
        "<button id=\"aboutbutton\" class=\"option\">About(4)</button>"
        "</div>"
        "</div>";
  }

  /*
  Generates the button to edit the user data
  */
  void editUser() {
    querySelector('#edituser').innerHtml =
    "<div id=\"overlay\">"
        "<div>"
        "<button id=\"changename\" class=\"option\">Change Name(1)</button>"
        "</div>"
        "<div>"
        "<button id=\"changepassword\" class=\"option\">Change Password(2)</button>"
        "</div>"
        "<div>"
        "<button id=\"delete\" class=\"option\">Delete User(3)</button>"
        "</div>"
        "<div>"
        "<button id=\"back\" class=\"option\">Back(&#x2190)</button>"
        "</div>"
        "</div>";
  }

  /**
   * Shows the options to change the username
   */
  void changeUserName() {
    querySelector('#userinput').innerHtml =
    "<div id =\"overlay\" >"
        "<form id=\"inputdates\">"
        "<input type=\"text\" id=\"oldusername\" placeholder=\"old Username\">"
        "<input type=\"password\" id=\"userpassword\" placeholder=\"Password\">"
        "<input type=\"text\" id=\"username\" placeholder=\"new Username\">"
        "<button type =\"button\" id=\"submit\">Change Name(&#x21b5)</button>"
        "<button type =\"button\" id=\"back\">Back</button>"
        "</form>"
        "</div>";
  }

  /**
   * Shows the options to change the password
   */
  void changeUserPassword() {
    querySelector('#userinput').innerHtml =
    "<div id =\"overlay\" >"
        "<form id=\"inputdates\">"
        "<input type=\"text\" id=\"username\" placeholder=\"Username\">"
        "<input type=\"password\" id=\"olduserpassword\" placeholder=\"old Password\">"
        "<input type=\"password\" id=\"userpassword\" placeholder=\"new Password\">"
        "<button type =\"button\" id=\"submit\">Change Password(&#x21b5)</button>"
        "<button type =\"button\" id=\"back\">Back</button>"
        "</form>"
        "</div>";
  }

  /**
   * Shows the options to enter the levelcode
   */


  void enterLvlCode() {
    querySelector('#userinput').innerHtml =
    "<div id =\"overlay\" >"
        "<form id=\"inputdates\">"
        "<input type=\"text\" id=\"levelCode\" placeholder=\"Enter Code\">"
        "<button type =\"button\" id=\"submit\">Enter(&#x21b5)</button>"
        "<button type =\"button\" id=\"back\">Back</button>"
        "</form>"
        "</div>";
  }

  /**
   * generates the aboutcontent and the buttons to navigate
   */
  getAbout() {
    querySelector("#about").innerHtml =
    "<div><aboutcontent id=\"overlay\ class=\"instructions\"></aboutcontent><span id=\"aboutbuttonposition\"><button id=\"aboutprev\">(&#x21d0)Previous</button><button id=\"aboutback\">Back(&#x2190)</button><button id=\"aboutnext\">Next(&#x21d2)</button></span></div>";
  }

  /**
   * Generates the win-overlay and the button to access the next level
   */
  Future showWin(var highscores) async {
    String str = "<table border = 1; width=\"60%\">" +
        "<colgroup><col width=\"2*\"><col width=\"1*\"><col width=\"1*\"><col width=\"1*\"><col width=\"1*\"></colgroup>" +
        "<tr><th>Name</th><th>Pushes</th><th>Moves</th><th>Pushes Total</th><th>Moves Total</th></tr>";
    for (Map m in highscores) {
      String n = m['name'];
      int lp = m['LocalPushes'];
      int lm = m['LocalMoves'];
      int gp = m['GlobalPushes'];
      int gm = m['GlobalMoves'];
      str +=
      "<tr><td>$n</td><td>$lp</td><td>$lm</td><td>$gp</td><td>$gm</td></tr>";
    }
    str += "</table>";
    String ret = "<div id=\"highscore\"><dt>$str</dt><div>";
    querySelector("#win").innerHtml =
    "<div id=\"winoverlay\"><div>$ret</div><div id=\"stattablebuttons\"><button id=\"nextbutton\">Next Level(&#x21b5)</button><button id=\"savebutton\">Save Statistics(S)</button></div></div>";
    querySelector("#resetbutton").style.position = "relative";
  }

  //endregion

  //region INPUT

  /**
   * Gets the Name from UserInput
   */
  String get username =>
      (document.querySelector('#username') as InputElement).value;

  /*
  Gets the userPassword from UserInput
  */
  String get userPassword =>
      (document.querySelector('#userpassword') as InputElement).value;

  /*
  Gets the "ID" from UserInput
  */
  String get userId =>
      (document.querySelector('#userid') as InputElement).value;

  /*
  Gets the "oldname" from UserInput
  */
  String get oldUserName =>
      (document.querySelector('#oldusername') as InputElement).value;

  /**
   * gets the user's old password from userinput
   */
  String get oldUserPassword =>
      (document.querySelector('#olduserpassword') as InputElement).value;


  /**
   * gets the levelcode from userinput
   */

  String get lvlCode =>
      (document.querySelector('#levelCode') as InputElement).value;

  //endregion

  //region UPDATE

  /**
   * Updates the position of the player and the crates
   * Receives old and new positions as Strings and updates the html
   */
  void updateView(String playerPosition_old, String playerPosition_new,
      List<String>cratePosition_new) {
    int pox = getPosition(playerPosition_old)[1];
    int poy = getPosition(playerPosition_old)[0];
    _field[pox][poy].className = "";
    int pnx = getPosition(playerPosition_new)[1];
    int pny = getPosition(playerPosition_new)[0];
    _field[pnx][pny].className = "player";
    if (!cratePosition_new.isEmpty) {
      int dummy = 0;
      do {
        List<int> cratepos = getPosition(cratePosition_new.removeLast());
        int pcx = cratepos[1];
        int pcy = cratepos[0];
        _field[pcx][pcy].className = "crate";
      } while (dummy < cratePosition_new.length);
    }
    scaling();
  }

  /**
   * used to update the stats
   */
  void updateStats(Map<String, int> stats, var actualLvl) {
    String localPushes = stats.remove("localPushes").toString();
    String globalPushes = stats.remove("globalPushes").toString();
    String localMoves = stats.remove("localMoves").toString();
    String globalMoves = stats.remove("globalMoves").toString();
    String resets = stats.remove("resets").toString();
    String usedGloves = stats.remove("usedGloves").toString();
    String gloves = stats.remove("gloves").toString();
    String steroids = stats.remove("steroids").toString();
    String usedSteroids = stats.remove("usedSteroids").toString();
    querySelector("#statistics").innerHtml =
    "Level:<em>$actualLvl</em>&nbsp&nbsp|&nbsp&nbsp"
        "Resets:<em>$resets</em>&nbsp&nbsp|&nbsp&nbsp"
        "Pushes:<em>$localPushes ($globalPushes)</em>&nbsp&nbsp|&nbsp&nbsp"
        "Moves:<em>$localMoves ($globalMoves)</em>&nbsp&nbsp|&nbsp&nbsp"
        "Gloves: <em>$gloves (Used: $usedGloves)</em>&nbsp&nbsp|&nbsp&nbsp"
        "Steroids: <em>$steroids (Used: $usedSteroids)</em>";
  }

  /**
   * returns the x- and y-position as interger-values in a list
   */
  List<int> getPosition(String pos) {
    List<String> values = pos.split("_");
    List<int> positions = new List();
    positions.clear();
    positions.add(int.parse(values[0]));
    positions.add(int.parse(values[1]));
    return positions;
  }

  //endregion

  //region SETTER

  /**
   * Changes the status of the Gamekey to "Verbunden" in green if true or "nicht verbunden" in red if false
   */
  void setGameKeyAvailable(bool value) {
    if (value == true) {
      querySelector("#gamekeystatus").style.color = "green";
      querySelector("#gamekeystatus").innerHtml = "Gamekeystatus: Connected";
    } else {
      querySelector("#gamekeystatus").style.color = "red";
      querySelector("#gamekeystatus").innerHtml =
      "Gamekeystatus: Not connected";
    }
  }

  /**
   * Sets the Content of the Pull Button
   */
  setPullButton(int amount) {
    querySelector("#pullbutton").innerHtml = "Sticky gloves($amount)(G)";
  }

  /**
   * Sets the Content of the Push Button
   */
  setPushButton(int amount) {
    querySelector("#pushbutton").innerHtml = "Steroids($amount)(P)";
  }

  //endregion

  //region SCALING

  /**
   * Scales the elements of the table and enables support for every resolution
   */
  void scaling() {
    int resoWidth = (window.innerWidth * 0.9).toInt();
    int resoHeight = (window.innerHeight * 0.75).toInt();
    String oS;
    int px;
    double x = resoWidth / _tableW;
    double y = resoHeight / _tableH;
    if (x <= y) {
      px = x.toInt();
    } else {
      px = y.toInt();
    }
    oS = px.toString() + "px";
    querySelectorAll(".player").style.height = oS;
    querySelectorAll(".player").style.width = oS;
    querySelectorAll(".crate").style.height = oS;
    querySelectorAll(".crate").style.width = oS;
    querySelectorAll(".ground").style.height = oS;
    querySelectorAll(".ground").style.width = oS;
    querySelectorAll(".target").style.height = oS;
    querySelectorAll(".target").style.width = oS;
    querySelectorAll(".wall").style.height = oS;
    querySelectorAll(".wall").style.width = oS;

    //for mobile devices
    if(resoWidth < resoHeight){
      _changed = true;
      double bWidth = resoWidth / 3;
      String bw = bWidth.toInt().toString() + "px";
      double bHeight = bWidth/4;
      String bh = bHeight.toInt().toString() + "px";
      querySelectorAll("button").style.maxWidth = bw;
      querySelectorAll("button").style.maxHeight = bh;
      querySelectorAll("#resetbutton").style.fontSize = "0.8em";
      querySelectorAll("#pullbutton").style.fontSize = "0.8em";
      querySelectorAll("#pushbutton").style.fontSize = "0.8em";
      querySelectorAll("#userstatus").style.visibility = "hidden";
      querySelectorAll("#gamekeystatus").style.visibility = "hidden";
      querySelector("#statistics").style.fontSize = "1em";
    }else{
      //if the mobile device is turned to widescreen
      if(_changed){
        _changed = false;
        querySelector("#statistics").style.fontSize = "1em";
        querySelectorAll("#resetbutton").style.fontSize = "1em";
        querySelectorAll("#pullbutton").style.fontSize = "1em";
        querySelectorAll("#pushbutton").style.fontSize = "1em";
        querySelectorAll("#userstatus").style.visibility = "visible";
        querySelectorAll("#gamekeystatus").style.visibility = "visible";
      }
    }
  }

  //endregion

  //region GENERATE LEVEL

  /**
   * Creates the level in html from a List
   */
  Future<String> generateLvl(List<Map> levelList, int column,
      int row) async {
    this._tableH = row;
    this._tableW = column;
    List<Map>tempList = new List<Map>();
    tempList = levelList;
    String level = "";
    bool onePlayer = false;
    for (var map in tempList) {
      level += map["r"].toUpperCase();
    }
    String formatlevel = "";
    for (int j = 0; j < row; j++) {
      //Spalten
      formatlevel += "<tr>";
      for (int i = 0; i < column; i++) {
        //Zeilen
        if (level.length > 0) {
          String firstChar = level.substring(0, 1);
          level = level.substring(1);
          switch (firstChar) {
            case 'W' :
              formatlevel += "<td id=\"pos$i\_$j\" class=\"wall\" ></td>";
              break;
            case 'G' :
              formatlevel += "<td id=\"pos$i\_$j\" class=\"ground\" ></td>";
              break;
            case 'P' :
              if (onePlayer == false) {
                formatlevel +=
                "<td id=\"pos$i\_$j\" class=\"player\"></td>";
                onePlayer = true;
              } else {
                formatlevel += "<td id=\"pos$i\_$j\" class=\"ground\" ></td>";
              }
              break;
            case 'C' :
              formatlevel +=
              "<td id=\"pos$i\_$j\" class=\"crate\"></td>";
              break;
            case 'T' :
              formatlevel += "<td id=\"pos$i\_$j\" class=\"target\"></td>";
              break;
            case 'S' :
              formatlevel +=
              "<td id=\"pos$i\_$j\" class=\"special\"></td>";
              break;
          }
        } else {
          formatlevel += "<td id=\"pos$i\_$j\" class=\"ground\" ></td>";
        }
      }
      formatlevel += "</tr>\n";
    }
    formatlevel = "<table><tbody>\n$formatlevel</tbody></table>";
    String objectlayer = formatlevel;
    String groundLayer = formatlevel;
    String groundlayer = groundLayer.replaceAll(
        "class=\"crate\"", "class=\"ground\"");
    groundlayer =
        groundlayer.replaceAll("class=\"player\"", "class=\"ground\"");
    groundlayer =
        groundlayer.replaceAll("class=\"special\"", "class=\"target\"");

    objectlayer = objectlayer.replaceAll("class=\"wall\"", "class=\"ground\"");
    objectlayer =
        objectlayer.replaceAll("class=\"target\"", "class=\"ground\"");
    objectlayer =
        objectlayer.replaceAll("class=\"special\"", "class=\"crate\"");

    querySelector("#groundlayer").innerHtml = groundlayer;
    querySelector("#objectlayer").innerHtml = objectlayer;
    _field = new List<List<HtmlElement>>(row);
    for (int rows = 0; rows < row; rows++) {
      _field[rows] = [];
      for (int col = 0; col < column; col++) {
        _field[rows].add(querySelector("#pos${col}_${rows}"));
      }
    }
    await scaling();
    return formatlevel;
  }

  //endregion

  /**
   * Displays the Code for the actual level
   */
  void showLvlCode(String code) {
    querySelector("#header").innerHtml = "Levelcode: $code";
  }
}