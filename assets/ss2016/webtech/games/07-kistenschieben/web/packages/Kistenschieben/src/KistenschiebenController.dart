import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'Gamekey.dart';
import 'KistenschiebenModel.dart';
import 'KistenschiebenView.dart';
import 'LevelGenerator.dart';

const gamekeyCheck = const Duration(seconds: 10);   //checks the gamekeyconenction every 10 seconds
const gameSecret = "ad97258677ce8c26";              //the secret code for the gamekey-server
const gamekeySettings = 'gamekey.json';             //path to the gamekey.json

/**
 * The Controller of the Game. Accepts input and converts it to commands for the model or view.
 */
class KistenschiebenController {
  //Periodic trigger controlling availability of gamekey service.
  Timer gamekeyTrigger;

  //var gamekey = new GameKey('127.0.0.1', 8080, 'dac62aa0-9408-4b7d-abca-7104dd701230','2819b92f78114417');
  var gamekey = new GameKey('undefined', 8080, 'undefined', 'undefined');

  //Shows if the gamekey is available or not
  bool gamekeyAvailable = false;

  //The Levelgenerator
  LevelGenerator genLvl;

  //The Model
  KistenschiebenModel ksModel;

  //The View
  KistenschiebenView ksView;

  //The username of the actual user
  String username;

  //The password of the actual user
  String password;

  //The actual statistics
  Map stats;

  //The User-ID
  String userid = "";

  //The User
  String user = "";

  //Shows if the user is logged in or not
  bool logedIn = false;

  //Shows if the user activated the pull-ability for the next round
  int _stickyGloveAmount = 0;

  //Shows if the user increases the push power for the next round
  int _steroidAmount = 0;

  //after 3 wins the user gets 3 new gloves
  int _newGlove = 0;

  //after 3 wins the user gets 3 new steroids
  int _newSteroids = 0;

  //shows if statistics are saved or not
  bool isSaved = false;

//region GAMESTATE BOOLS

  //Shows the running state of the game
  bool gameRunning = false;

  //Shows the state of the game
  bool finishedGame = false;

  //Is the user registered
  bool registered = false;

  //Shows if the authentication succeded
  bool authentication = false;

  //Shows when user is typing
  bool typing = false;

  //The user is on startscreen layout
  bool onStartscreen = false;

  //The user is on registered layout
  bool onLoginscreen = false;

  //The user is on edit setting layer
  bool onEditUserScreen = false;

  //Shows if the buttons to register or login are allowed to use
  bool startscreenbuttons = false;

  //The user is on about layout
  bool onAboutScreen = false;

  //endregion

//region CONSTRUCTOR

  /*
  CONSTRUCTOR
   */
  KistenschiebenController() {
    genLvl = new LevelGenerator();
    ksModel = new KistenschiebenModel();
    ksView = new KistenschiebenView();
    ksView.startScreen();

    //  [-======== GAMEKEY ========-]

    try {
      // Download gamekey settings. Display warning on problems.
      HttpRequest.getString(gamekeySettings).then((json) {
        final settings = JSON.decode(json);

        // Create gamekey client using connection parameters
        this.gamekey = new GameKey(
            settings['host'],
            settings['port'],
            settings['gameid'],
            gameSecret
        );

        querySelector("#registerbutton").style.visibility = "hidden";
        querySelector("#loginbutton").style.visibility = "hidden";
        startscreenListener();
        // Check periodically if gamekey service is reachable. Display warning if not.
        this.gamekeyTrigger = new Timer.periodic(gamekeyCheck, (_) async {
          if (await this.gamekey.authenticate() == true) {
            if (onStartscreen == true) {
              if (authentication != true && gameRunning == false &&
                  onAboutScreen == false) {
                querySelector("#registerbutton").style.visibility = "visible";
                querySelector("#loginbutton").style.visibility = "visible";
                setStartscreenButtons(true);
                setAuthentication(true);
                gamekeyAvailable = true;
              }
            }
            gamekeyAvailable = true;
          } else {
            print("Authentification failed!");
            gamekeyAvailable = false;
          }
          ksView.setGameKeyAvailable(gamekeyAvailable);
        });
      });
    } catch (error, stacktrace) {
      print("KistenschiebenKontroller() caused following error: '$error'");
      print("$stacktrace");
    }

    //  [-======== KEYLISTENER ========-]

    window.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.keyCode) {
        case KeyCode.UP:
          if (gameRunning == true) {
            moveUp();
          }
          break;
        case KeyCode.RIGHT:
          if (gameRunning == true) {
            moveRight();
          }
          break;
        case KeyCode.DOWN:
          if (gameRunning == true) {
            moveDown();
          }
          break;
        case KeyCode.LEFT:
          if (gameRunning == true) {
            moveLeft();
          }
          break;
        case KeyCode.BACKSPACE:
          if (gameRunning || finishedGame) {
            finishedGame = false;
            resetRoutine();
          }
          break;
        case KeyCode.ENTER:
          if (finishedGame) {
            finishedGame = false;
            nextRoutine();
          }
          break;
        case KeyCode.S:
          if (finishedGame && registered) {
            saveRoutine();
          }
          break;
        case KeyCode.P:
          if (!finishedGame) {
            pushRoutine();
          }
          break;
        case KeyCode.G:
          if (!finishedGame) {
            pullRoutine();
          }
          break;

      }
      return "";
    });
  }

  pushRoutine() {
    if (_steroidAmount < ksModel.getSteroids()) {
      _steroidAmount++;
      ksView.setPushButton(_steroidAmount);
    }
  }

  pullRoutine() {
    if (_stickyGloveAmount < ksModel.getGloves()) {
      _stickyGloveAmount++;
      ksView.setPullButton(_stickyGloveAmount);
    }
  }
//endregion

//region LISTENER

  //region STARTSCREEN

  /**
   * Listener for the Startscreen.
   * Has the following buttons:
   *    [REGISTER]
   *    [LOGIN]
   *    [WITHOUT LOGIN]
   *    [RESET]
   */
  startscreenListener() async {
    setStartscreen(true);
    //Startscreen Keyboardlistener
    window.onKeyDown.listen((KeyboardEvent ev) {
      if (gameRunning != true && typing != true && onStartscreen == true) {
        switch (ev.keyCode) {
          case KeyCode.ONE :
            if (startscreenbuttons == true) {
              registerRoutine();
            }
            break;
          case KeyCode.TWO :
            if (startscreenbuttons == true) {
              loginRoutine();
            }
            break;
          case KeyCode.THREE:
            withoutLoginRoutine();
            break;
          case KeyCode.FOUR:
            aboutRoutine();
            break;
        }
        return;
      }
    });
    //Registerbutton Listener
    querySelector('#registerbutton').onMouseDown.listen((MouseEvent e) {
      registerRoutine();
    });

    //Loginbutton listener
    querySelector('#loginbutton').onMouseDown.listen((MouseEvent e) {
      loginRoutine();
    });

    //Without-loginbutton listener
    querySelector('#wObutton').onMouseDown.listen((MouseEvent e) {
      withoutLoginRoutine();
    });

    //Aboutbutton listener
    querySelector('#aboutbutton').onMouseDown.listen((MouseEvent g) {
      aboutRoutine();
    });


    //Resetbutton listener
    querySelector("#resetbutton").onMouseDown.listen((MouseEvent e) {
      resetRoutine();
    });

    //Pullbutton listener
    querySelector("#pullbutton").onMouseDown.listen((MouseEvent e) {
      pullRoutine();
    });

    //Pushbutton listener
    querySelector("#pushbutton").onMouseDown.listen((MouseEvent e) {
      pushRoutine();
    });
    hoverlistener();
  }

  /**
   * Listener for the hoverevent of the buttons
   */
  hoverlistener() async {
    querySelectorAll("button").onMouseEnter.listen((MouseEvent e) {
      (e.target as HtmlElement).className = "buttonhover";
    });

    querySelectorAll("button").onMouseLeave.listen((MouseEvent e) {
      (e.target as HtmlElement).className = "";
    });
  }

  /**
   * Execute the register routine when startscreen is enabled
   */
  void registerRoutine() {
    ksView.userDates("Register");
    setTyping(true);
    if (onStartscreen == true && onLoginscreen == false &&
        onEditUserScreen == false) {
      window.onKeyDown.listen((KeyboardEvent ev) {
        switch (ev.keyCode) {
          case KeyCode.ENTER:
            String username = ksView.username;
            String password = ksView.userPassword;
            print("You are registered now");
            checkRegister(username, password);
            querySelector("#userinput").innerHtml = "";
            setTyping(false);
            break;
          case KeyCode.ESC:
            querySelector("#userinput").innerHtml = "";
            querySelector("#about").innerHtml = "";
            ksView.startScreen();
            startscreenListener();
            setTyping(false);
        }
      });
    }

    //SUBMIT
    querySelector('#submit').onMouseDown.listen((MouseEvent ev) {
      String username = ksView.username;
      String password = ksView.userPassword;
      print("You are registered now");
      checkRegister(username, password);
      querySelector("#userinput").innerHtml = "";
      setTyping(false);
    });

    //BACK
    querySelector("#back").onMouseDown.listen((MouseEvent e) {
      querySelector("#userinput").innerHtml = "";
      querySelector("#about").innerHtml = "";
      ksView.startScreen();
      startscreenListener();
      setTyping(false);
    });
    hoverlistener();
  }

  /**
   * Execute the login routine when startscreen is enabled
   */
  void loginRoutine() {
    ksView.userDates("Login");
    setTyping(true);
    if (onStartscreen == true && onLoginscreen == false &&
        onEditUserScreen == false) {
      window.onKeyDown.listen((KeyboardEvent ev) {
        switch (ev.keyCode) {
          case KeyCode.ENTER:
            String username = ksView.username;
            String password = ksView.userPassword;
            this.user = username;
            querySelector("#userinput").innerHtml = "";
            checklogin(username, password);
            setTyping(false);
            break;
          case KeyCode.ESC:
            querySelector("#userinput").innerHtml = "";
            ksView.startScreen();
            startscreenListener();
            setTyping(false);
        }
      });
    }

    //SUBMIT Listener
    querySelector('#submit').onMouseDown.listen((MouseEvent ev) {
      String username = ksView.username;
      String password = ksView.userPassword;
      this.user = username;
      querySelector("#userinput").innerHtml = "";
      checklogin(username, password);
      setTyping(false);
    });

    //BACK Listener
    querySelector("#back").onMouseDown.listen((MouseEvent e) {
      querySelector("#userinput").innerHtml = "";
      ksView.startScreen();
      startscreenListener();
      setTyping(false);
    });
    hoverlistener();
  }

  /**
   * Allows the user to play the game without functions to store the states if the startscreen is enabled
   */
  void withoutLoginRoutine() {
    setStartscreen(false);
    querySelector('#start').innerHtml = "";
    querySelector("#resetbutton").style.visibility = "visible";
    querySelector("#pushbutton").style.visibility = "visible";
    querySelector("#pullbutton").style.visibility = "visible";
    newGame();
  }

  /**
   * Reset
   */
  void resetRoutine() {
    querySelector("#registered").innerHtml = "";
    querySelector("#win").innerHtml = "";
    querySelector("#resetbutton").style.position = "";
    querySelector("#pullbutton").style.visibility = "visible";
    querySelector("#pushbutton").style.visibility = "visible";
    _stickyGloveAmount = 0;
    _steroidAmount = 0;
    ksView.setPullButton(0);
    ksView.setPushButton(0);
    resetGame();
    setSaved(false);
  }


  //endregion

  //region REGISTER & LOGIN

  /**
   * Checks if registration was succesfull and gives the user feedback about it
   */
  checkRegister(String name, String pw) async {
    Map answer = await gamekey.registerUser(name, pw);
    print("Answer:");
    print(answer);
    if (answer.isNotEmpty && answer != null) {
      querySelector("messagefield").className = "messageanimation";
      querySelector("messagefield").innerHtml = "Register succed";
      ksView.startScreen();
      startscreenListener();
    } else {
      querySelector("messagefield").className = "messageanimation";
      querySelector("messagefield").innerHtml = "Register failed";
    }
  }


  /**
   * Checks if user & password are valid and changes the userstatus
   */
  checklogin(String name, String pw) async {
    Map answer = await gamekey.loginUser(name, pw);
    print("Answer:");
    print(answer);
    if (answer.isNotEmpty) {
      registered = true;
      userid = answer.values.elementAt(2);
      username = answer.values.elementAt(3);
      querySelector("#start").innerHtml = "";
      querySelector("messagefield").className = "greetinganimation";
      querySelector("messagefield").innerHtml = "Hello $user";
      querySelector("#userstatus").innerHtml = "Registered as: $user";
      querySelector("#userstatus").style.color = "green";
      ksView.registeredScreen();
      registeredListener();
    } else {
      querySelector("messagefield").className = "greetinganimation";
      querySelector("messagefield").innerHtml = "Login failed!";
    }
    setTyping(false);
  }

  /*
  listener to the buttons on the "registered" layout
  */
  registeredListener() async {
    setStartscreen(false);
    setLoginscreen(true);
    setRegistered(true);
    window.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.keyCode) {
        case KeyCode.ONE :
          if (gameRunning != true && typing != true &&
              onLoginscreen == true) {
            newGameRoutine();
          }
          break;
        case KeyCode.TWO :
          if (gameRunning != true && typing != true &&
              onLoginscreen == true) {
            editUserRoutine();
          }
          break;
        case KeyCode.THREE:
          if (gameRunning != true && typing != true &&
              onLoginscreen == true) {
            levelCodeRoutine();
          }
          break;
        case KeyCode.FOUR:
          if (gameRunning != true && typing != true &&
              onLoginscreen == true) {
            aboutRoutine();
          }
      }
    });

    //New game listener
    querySelector("#newgame").onMouseDown.listen((MouseEvent f) {
      newGameRoutine();
    });

    //Edit user listener
    querySelector("#edituserbutton").onMouseDown.listen((MouseEvent g) {
      editUserRoutine();
    });

    //Levelcode listener
    querySelector("#levelcodebutton").onMouseDown.listen((MouseEvent e) {
      levelCodeRoutine();
    });

    //About listener
    querySelector('#aboutbutton').onMouseDown.listen((MouseEvent g) {
      aboutRoutine();
    });

    hoverlistener();
  }

  //endregion

  //region REGISTERED SCREEN

  /**
   * changes the view when a new game starts
   */
  void newGameRoutine() {
    newGame();
    querySelector("#registered").innerHtml = "";
    querySelector("#start").innerHtml = "";
    querySelector("#resetbutton").style.visibility = "visible";
    querySelector("#pushbutton").style.visibility = "visible";
    querySelector("#pullbutton").style.visibility = "visible";
  }

  /**
   * allows the user to edit the own setting when the edit user screen is enabled
   */
  void editUserRoutine() {
    querySelector("#registered").innerHtml = "";
    setLoginscreen(false);
    setStartscreen(false);
    setEditUserScreen(true);
    ksView.editUser();
    editUserListener();
  }

  /**
   * allows the user to enter the levelcode when the registered screen is enabled
   */
  levelCodeRoutine() async {
    setTyping(true);
    querySelector("#registered").innerHtml = "";
    ksView.enterLvlCode();
    window.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.keyCode) {
        case KeyCode.ENTER:
          if (onLoginscreen == true) {
            String code = ksView.lvlCode;
            if (_setLevelByCode(code) == true) {
              querySelector("#userinput").innerHtml = "";
        } else {
          //Errorcode

        }

      }
      }
    });

    //SUBMIT
    querySelector("#submit").onMouseDown.listen((MouseEvent e) {
      String code = ksView.lvlCode;
      if (_setLevelByCode(code) == true) {
        querySelector("#userinput").innerHtml = "";
      } else {
        //Errorcode

      }
    });

    //BACK
    querySelector("#back").onMouseDown.listen((MouseEvent e) {
      querySelector("#userinput").innerHtml = "";
      ksView.registeredScreen();
      registeredListener();
    });
    hoverlistener();
  }

//endregion

  //region ABOUT

  /**
   * allows the user to navigate through the instructions with buttons or Keyboard
   * depends on the enabled screen(on login screen or on registered screen ) chooses the about routine
   */
  void aboutRoutine() {
    setTyping(true);
    setAboutScreen(true);
    int instructionNumber = 1;
    if (onStartscreen == true && gameRunning == false) {
      querySelector("#overlay").innerHtml = "";
      ksView.getAbout();
      querySelector("#overlay").className = "instruction1";
      querySelector("#header").innerHtml = "Game objects";
      querySelector("#aboutback").onMouseDown.listen((MouseEvent e) {
        querySelector("#userinput").innerHtml = "";
        querySelector("#about").innerHtml = "";
        ksView.startScreen();
        startscreenListener();
        setAboutScreen(false);
        querySelector("#header").innerHtml = "Kistenschieben";
      });

      //PREVIOUS
      querySelector("#aboutprev").onMouseDown.listen((MouseEvent e) {
        instructionNumber--;
        if (instructionNumber >= 1) {
          querySelector("#overlay").className = "instruction$instructionNumber";
          instructionSet(instructionNumber);
        } else instructionNumber++;
      });

      //NEXT
      querySelector("#aboutnext").onMouseDown.listen((MouseEvent e) {
        instructionNumber++;
        if (instructionNumber <= 6) {
          querySelector("#overlay").className = "instruction$instructionNumber";
          instructionSet(instructionNumber);
        } else instructionNumber--;
      });
      hoverlistener();
    } else if (onLoginscreen == true && gameRunning == false) {
      querySelector("#overlay").innerHtml = "";
      ksView.getAbout();
      querySelector("#overlay").className = "instruction1";
      querySelector("#header").innerHtml = "Game objects";
      querySelector("#aboutback").onMouseDown.listen((MouseEvent e) {
        querySelector("#userinput").innerHtml = "";
        querySelector("#about").innerHtml = "";
        ksView.registeredScreen();
        registeredListener();
        setAboutScreen(false);
        querySelector("#header").innerHtml = "Kistenschieben";
      });
      //PREVIOUS
      querySelector("#aboutprev").onMouseDown.listen((MouseEvent e) {
        instructionNumber--;
        if (instructionNumber >= 1) {
          querySelector("#overlay").className = "instruction$instructionNumber";
          instructionSet(instructionNumber);
        } else instructionNumber++;
      });
      //NEXT
      querySelector("#aboutnext").onMouseDown.listen((MouseEvent e) {
        instructionNumber++;
        if (instructionNumber <= 6) {
          querySelector("#overlay").className = "instruction$instructionNumber";
          instructionSet(instructionNumber);
        } else instructionNumber--;
      });

      hoverlistener();
    } else {}
    window.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.keyCode) {
        case KeyCode.LEFT:
          if (onAboutScreen == true && gameRunning == false) {
            instructionNumber--;
            if (instructionNumber >= 1) {
              querySelector("#overlay").className =
              "instruction$instructionNumber";
              instructionSet(instructionNumber);
            } else instructionNumber++;
          }
          break;
        case KeyCode.RIGHT:
          if (onAboutScreen == true && gameRunning == false) {
            instructionNumber++;
            if (instructionNumber <= 6) {
              querySelector("#overlay").className =
              "instruction$instructionNumber";
              instructionSet(instructionNumber);
            } else instructionNumber--;
          }
          break;
        case KeyCode.BACKSPACE:
          if (onStartscreen == true && typing == true) {
            querySelector("#userinput").innerHtml = "";
            querySelector("#about").innerHtml = "";
            ksView.startScreen();
            startscreenListener();
            setAboutScreen(false);
            setTyping(false);
            querySelector("#header").innerHtml = "Kistenschieben";
          } else if (onLoginscreen == true && typing == true) {
            querySelector("#userinput").innerHtml = "";
            querySelector("#about").innerHtml = "";
            ksView.registeredScreen();
            registeredListener();
            setAboutScreen(false);
            setTyping(false);
            querySelector("#header").innerHtml = "Kistenschieben";
          } else
            break;
      }
    });
  }

  /**
   * Displays the name of the about instructions
   */
  void instructionSet(int instructionNumber) {
    switch (instructionNumber) {
      case 1:
        querySelector("#header").innerHtml = "Game objects";
        break;
      case 2:
        querySelector("#header").innerHtml = "Objective";
        break;
      case 3:
        querySelector("#header").innerHtml = "Controls";
        break;
      case 4:
        querySelector("#header").innerHtml = "Rules";
        break;
      case 5:
        querySelector("#header").innerHtml = "Consumables";
        break;
      case 6:
        querySelector("#header").innerHtml = "Save game";
        break;
      default:
        querySelector("#header").innerHtml = "Kistenschieben";
        break;
    }
  }

  //endregion

  //region EDIT USER

  /**
   * Listener for editing the user.
   * Has the following buttons:
   *    [GET USER]
   *    [GET USER ID]
   *    [CHANGE NAME]
   *    [CHANGE PASSWORD]
   *    [DELETE]
   *    [CLOSE]
   */
  editUserListener() async {
    querySelector("#registered").innerHtml = "";
    window.onKeyDown.listen((KeyboardEvent en) {
      switch (en.keyCode) {
        case KeyCode.ONE :
          if (onEditUserScreen == true && onLoginscreen == false) {
            changeNameRoutine();
          }
          break;
        case KeyCode.TWO:
          if (onEditUserScreen == true && onLoginscreen == false) {
            changePasswordRoutine();
          }
          break;
        case KeyCode.THREE:
          if (onEditUserScreen == true && onLoginscreen == false) {
            deleteUserRoutine();
          }
          break;
      }
    });

    //Change-name button listener
    querySelector("#changename").onMouseDown.listen((MouseEvent f) {
      changeNameRoutine();
    });

    //Change-password button listener
    querySelector("#changepassword").onMouseDown.listen((MouseEvent f) {
      changePasswordRoutine();
    });

    //Deletebutton listener
    querySelector("#delete").onMouseDown.listen((MouseEvent f) {
      deleteUserRoutine();
    });

    //Back to registerlayout listener
    querySelector('#back').onMouseDown.listen((MouseEvent g) {
      backToRegisteredListener();
    });

    hoverlistener();
  }

  /**
   * Enables changing the username
   */
  void changeNameRoutine() {
    setTyping(true);
    querySelector("#edituser").style.visibility = "hidden";
    ksView.changeUserName();
    if (onEditUserScreen == true) {
      window.onKeyDown.listen((KeyboardEvent ev) {
        switch (ev.keyCode) {
          case KeyCode.ENTER:
            String oldName = ksView.oldUserName;
            String password = ksView.userPassword;
            String username = ksView.username;
            if (gamekey.changeUserName(oldName, password, username) != null) {
              querySelector("#edituser").style.visibility = "visible";
              querySelector("messagefield").className = "messageanimation";
              querySelector("messagefield").innerHtml = "Changename succeded";
              querySelector("#userstatus").innerHtml =
              "Userstaus: Registered as:$username";
            } else {
              querySelector("messagefield").className = "messageanimation";
              querySelector("messagefield").innerHtml = "Changename failed";
            }
            querySelector("#userinput").innerHtml = "";
            setTyping(false);
            break;
        }
      });
    }

    //SUBMIT
    querySelector('#submit').onMouseDown.listen((MouseEvent ev) {
      String oldName = ksView.oldUserName;
      String password = ksView.userPassword;
      String username = ksView.username;
      if (gamekey.changeUserName(oldName, password, username) != null) {
        querySelector("#edituser").style.visibility = "visible";
        querySelector("messagefield").className = "messageanimation";
        querySelector("messagefield").innerHtml = "Changename succeded";
        querySelector("#userstatus").innerHtml =
        "Userstaus: Registered as:$username";
      } else {
        querySelector("messagefield").className = "messageanimation";
        querySelector("messagefield").innerHtml = "Changename failed";
      }
      querySelector("#userinput").innerHtml = "";
      setTyping(false);
    });

    //BACK
    querySelector("#back").onMouseDown.listen((MouseEvent e) {
      querySelector("#userinput").innerHtml = "";
      querySelector("#registered").style.visibility = "visible";
      querySelector("#edituser").style.visibility = "visible";
      setTyping(false);
    });
    hoverlistener();
  }

  /**
   * Allows the user to change his password
   */
  void changePasswordRoutine() {
    querySelector("#edituser").style.visibility = "hidden";
    ksView.changeUserPassword();
    setTyping(true);
    if (onEditUserScreen == true) {
      window.onKeyDown.listen((KeyboardEvent ev) {
        switch (ev.keyCode) {
          case KeyCode.ENTER:
            String username = ksView.username;
            String oldpassword = ksView.oldUserPassword;
            String password = ksView.userPassword;
            print(username + " " + password);
            gamekey.changeUserPassword(username, oldpassword, password);
            querySelector("#edituser").style.visibility = "visible";
            querySelector("#userinput").innerHtml = "";
        }
      });
    }

    //SUBMIT
    querySelector('#submit').onMouseDown.listen((MouseEvent ev) {
      String username = ksView.username;
      String oldpassword = ksView.oldUserPassword;
      String password = ksView.userPassword;
      print(username + " " + password);
      gamekey.changeUserPassword(username, oldpassword, password);
      querySelector("#edituser").style.visibility = "visible";
      querySelector("#userinput").innerHtml = "";
      setTyping(false);
    });

    //BACK
    querySelector("#back").onMouseDown.listen((MouseEvent e) {
      querySelector("#userinput").innerHtml = "";
      querySelector("#edituser").style.visibility = "visible";
      setTyping(false);
    });
    hoverlistener();
  }

  /**
   * Allows the user to delete his own account
   */
  void deleteUserRoutine() {
    querySelector("#edituser").style.visibility = "hidden";
    ksView.userDates("Delete");
    setTyping(true);
    if (onEditUserScreen == true) {
      window.onKeyDown.listen((KeyboardEvent ev) {
        switch (ev.keyCode) {
          case KeyCode.ENTER:
            String username = ksView.username;
            String password = ksView.userPassword;
            gamekey.deleteUser(username, password);
            querySelector("#edituser").style.visibility = "visible";
            querySelector("#userinput").innerHtml = "";
        }
      });
    }

    //SUBMIT
    querySelector('#submit').onMouseDown.listen((MouseEvent ev) {
      String username = ksView.username;
      String password = ksView.userPassword;
      gamekey.deleteUser(username, password);
      querySelector("#edituser").style.visibility = "visible";
      querySelector("#userinput").innerHtml = "";
      setTyping(false);
    });

    //BACK
    querySelector("#back").onMouseDown.listen((MouseEvent e) {
      querySelector("#userinput").innerHtml = "";
      querySelector("#edituser").style.visibility = "visible";
      setTyping(false);
    });
    hoverlistener();
  }

  /**
   * Brings the user back to the screen for registered users
   */
  void backToRegisteredListener() {
    querySelector("#edituser").innerHtml = "";
    setLoginscreen(true);
    setEditUserScreen(false);
    ksView.registeredScreen();
    registeredListener();
  }

  //endregion

  //region AFTER GAME

  /**
   * Listener for the Buttons which appear when the user has finished the level
   * [SAVE]
   * [NEXT]
   */
  nextListener() async {
    querySelector("#pullbutton").style.visibility = "hidden";
    querySelector("#pushbutton").style.visibility = "hidden";
    querySelector("#groundlayer").innerHtml = "";
    querySelector("#objectlayer").innerHtml = "";
    if (registered == true) {
      querySelector("#savebutton").style.visibility = "visible";


    //SAVE
    querySelector("#savebutton").onMouseDown.listen((MouseEvent e) {
      saveRoutine();
    });
    }

    //NEXT
    await querySelector("#nextbutton").onMouseDown.listen((MouseEvent e) {
      nextRoutine();
    });
    hoverlistener();
  }

  /**
   * Routine to close the displayed winlayout,buttons and call the nxtlevel logic
   */
  void nextRoutine() {
    querySelector("#win").innerHtml = "";
    querySelector("#resetbutton").style.position = "";
    updateStats();
    nextLvl();
    setSaved(false);
    querySelector("#pullbutton").style.visibility = "visible";
    querySelector("#pushbutton").style.visibility = "visible";
  }

  /**
   * Allows the user to save the current statistics
   */
  saveRoutine() async {
    if (isSaved == false) {
      print("saved");
      gamekey.storeState(userid, ksModel.getStats());
      updateStats();
      querySelector("#winoverlay").innerHtml = "";
      final highscores = await getHighscores();
      ksView.showWin(highscores);
      nextListener();
      setSaved(true);
    } else {
      //Is already saved
    }
  }

//endregion

//endregion

//region MOVES

  /**
   * tells the Player to move up. updates the view if the model returns true
   */
  bool moveUp() {
    List<String> positions = ksModel.moveUp(_stickyGloveAmount, _steroidAmount);
    _stickyGloveAmount = 0;
    ksView.setPullButton(ksModel.getStickyGloveAmount());
    _steroidAmount = 0;
    ksView.setPushButton(ksModel.getSteroidAmount());
    if (positions.isEmpty == false) {
      String playerPos_old = positions.removeLast();
      String playerPos_new = positions.removeLast();
      updateViewPush(playerPos_old, playerPos_new, positions);
      return true;
    }
    return false;
  }

  /**
   * Tells the Player to move right. updates the view if the model returns true
   */
  bool moveRight() {
    List<String> positions = ksModel.moveRight(
        _stickyGloveAmount, _steroidAmount);
    _stickyGloveAmount = 0;
    ksView.setPullButton(ksModel.getStickyGloveAmount());
    _steroidAmount = 0;
    ksView.setPushButton(ksModel.getSteroidAmount());
    if (positions.isEmpty == false) {
      String playerPos_old = positions.removeLast();
      String playerPos_new = positions.removeLast();
      updateViewPush(playerPos_old, playerPos_new, positions);
      return true;
    }
    return false;
  }

  /**
   * tells the Player to move down. updates the view if the model returns true
   */
  bool moveDown() {
    List<String> positions = ksModel.moveDown(
        _stickyGloveAmount, _steroidAmount);
    _stickyGloveAmount = 0;
    ksView.setPullButton(ksModel.getStickyGloveAmount());
    _steroidAmount = 0;
    ksView.setPushButton(ksModel.getSteroidAmount());
    if (positions.isEmpty == false) {
      String playerPos_old = positions.removeLast();
      String playerPos_new = positions.removeLast();
      updateViewPush(playerPos_old, playerPos_new, positions);
      return true;
    }
    return false;
  }

  /**
   * Tells the Player to move left. updates the view if the model returns true
   */
  bool moveLeft() {
    List<String> positions = ksModel.moveLeft(
        _stickyGloveAmount, _steroidAmount);
    _stickyGloveAmount = 0;
    ksView.setPullButton(ksModel.getStickyGloveAmount());
    _steroidAmount = 0;
    ksView.setPushButton(ksModel.getSteroidAmount());
    if (positions.isEmpty == false) {
      String playerPos_old = positions.removeLast();
      String playerPos_new = positions.removeLast();
      updateViewPush(playerPos_old, playerPos_new, positions);
      return true;
    }
    return false;
  }

//endregion

//region TOUCH

  /**
   * enables movement by clicking on the Field. Takes the coordinates and hands them over to the moveTouch
   */
  void reactTouch() {
    querySelectorAll("td").onMouseDown.listen((MouseEvent ev) {
      String id = (ev.target as HtmlElement).id;
      if (id == "") {
        id = (ev.target as HtmlElement).parent.id;
      }
      id = id.replaceAll("pos", "");
      List<String> l = id.split("_");
      int x = int.parse(l[0]);
      int y = int.parse(l[1]);
      moveTouch(x, y);
    });
  }

  /**
   * moves the player to a given position when the touchscreen is used.
   */
  void moveTouch(int targetX, int targetY) {
    int px = ksModel.getPlayerPosX();
    int py = ksModel.getPlayerPosY();
    int dir = checkDirection(targetX, targetY, px, py);
    switch (dir) {
      case 0:
        break;
    //stay
      case 1:
      //up
        touchUp(py - targetY);
        break;
      case 2:
      //right
        touchRight(targetX - px);
        break;
      case 3:
      //down
        touchDown(targetY - py);
        break;
      case 4:
      //left
        touchLeft(px - targetX);
        break;
    }
  }

  /**
   * moves the player up for a given number of fields.
   */
  void touchUp(int count) {
    while (count > 0) {
      if (!moveUp()) count = 1;
      count--;
    }
  }

  /**
   * moves the player to the right for a given number of fields.
   */
  void touchRight(int count) {
    while (count > 0) {
      if (!moveRight()) count = 1;
      count--;
    }
  }

  /**
   * moves the player down for a given number of fields.
   */
  void touchDown(int count) {
    while (count > 0) {
      if (!moveDown()) count = 1;
      count--;
    }
  }

  /**
   * moves the player to the left for a given number of fields.
   */
  void touchLeft(int count) {
    while (count > 0) {
      if (!moveLeft()) count = 1;
      count--;
    }
  }

  /*
  returns an integer as id for the direction the player has to move
  0 - stay
  1 - up
  2 - right
  3 - down
  4 - left
   */
  int checkDirection(int targetX, int targetY, int playerX, int playerY) {
    if (targetX == playerX && targetY == playerY) {
      return 0;
    }
    if (targetX == playerX) {
      if (targetY < playerY) {
        return 1;
      } else {
        return 3;
      }
    }
    if (targetY == playerY) {
      if (targetX < playerX) {
        return 4;
      } else {
        return 2;
      }
    }
    return 0;
  }

//endregion

//region UPDATE

  /*
  takes the positions of the player and the crates
   */
  void updateViewPush(String playerPosOld, String playerPosNew,
      List<String> cratesNew) {
    updateStats();
    ksView.updateView(playerPosOld, playerPosNew, cratesNew);
    checkWin();
  }

  /**
   * Updates the stats in the view
   */
  void updateStats() {
    var actualLvl = genLvl.getLevelValue() + 1;
    ksView.updateStats(ksModel.getStats(), actualLvl.toString());
  }

  /**
   * Updates the code for the actual level in the view
   */
  void updateLvlCode() {
    String code = genLvl.getLvlCode();
    ksView.showLvlCode(code);
  }

//endregion

//region STATISTICS

  /**
   * loads the Stats from the json via the gamekey
   */
  void loadStats() {
    List dummy = gamekey.getStates();
    Map test = dummy.last;
    ksModel.loadStats(test);
  }

  /**
   * Sets the actual level in the statistics to the value i
   */
  void setActualLevel(int i) {
    this.ksModel.setLvl(i);
  }

  /**
   * Retrieves TOP 10 highscore from Gamekey service.
   * - Returns List of max. 10 highscore entries. { 'name': STRING, 'score': INT }
   * - Returns [] if gamekey service is not available.
   * - Returns [] if no highscores are present.
   */
  Future<List<Map>> getHighscores() async {
    var scores = [];
    int amount = 10;
    try {
      final states = await gamekey.getStates();
      scores = states
          .map((entry) => {
        'name': "${entry['username']}",
        'level': entry['state']['actualLevel'],
        'LocalPushes': entry['state']['localPushes'],
        'GlobalPushes': entry['state']['globalPushes'],
        'LocalMoves': entry['state']['localMoves'],
        'GlobalMoves': entry['state']['globalMoves'],
        'UsedGloves': entry['state']['usedGloves'],
        'UsedSteroids': entry['state']['usedSteroids']
      })
          .toList();
      for (int i = 0; i < scores.length; i++)
        scores.sort((a, b) =>
        a['LocalPushes'] -
            b['LocalPushes']); //die niedrigsten localPushes

    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
    }
    List<Map<String, int>> lvlOnly = new List();
    for (Map m in scores) {
      if (m['level'] == genLvl.getCurrentLevel() + 1) {
        lvlOnly.add(m);
      }
    }
    return lvlOnly.take(amount);
  }


//endregion

//region SET GAMESTATUS

  /**
   * sets the status of the game to running or not
   */
  void setGameRunning(bool value) {
    gameRunning = value;
  }

  /**
   * sets the status of typing
   */
  void setTyping(bool value) {
    this.typing = value;
  }

  /**
   * sets the status of startscreen
   */
  void setStartscreen(bool value) {
    onStartscreen = value;
  }

  /**
   * sets the status of login screen
   */
  void setLoginscreen(bool value) {
    onLoginscreen = value;
  }

  /**
   * sets the status of start screen buttons
   */
  void setStartscreenButtons(bool value) {
    startscreenbuttons = value;
  }

  /**
   * sets the status of authentification
   */
  void setAuthentication(bool value) {
    authentication = value;
  }

  /**
   * sets the status of the edit user screen
   */
  void setEditUserScreen(bool value) {
    onEditUserScreen = value;
  }

  /**
   * sets the status of the about screen
   */
  void setAboutScreen(bool value) {
    onAboutScreen = value;
  }

  /**
   * sets the status of saved
   */
  void setSaved(bool value) {
    isSaved = value;
  }

  void setRegistered(bool value) {
    this.registered = value;
  }

//endregion

//region RESET AND NEW GAME

  /*
  Starts the next Level
  */
  void nextLvl() {
    if (genLvl.getLevelValue() <= genLvl.getLevelAmount()) {
      genLvl.nextLvl();
      int saveGloves = ksModel.getGloves();
      if (_newGlove == 3) {
        //adds 3 gloves when the user has won 3 games
        saveGloves = saveGloves+3;
        _newGlove = 0;
      }
      int saveSteroids = ksModel.getSteroids();
      if (_newSteroids == 3) {
        //adds 3 gloves when the user has won 3 games
        saveSteroids = saveSteroids+3;
        _newSteroids = 0;
      }
      ksModel.resetStatsTotal();
      ksModel.setGloves(saveGloves);
      ksModel.setSteroids(saveSteroids);
      genLvl.loadData().whenComplete(newGame);
    }
  }

  /*
  creates the model, starts a new game and creates the map from a String (later from a json)
   */
  void newGame() {
    setGameRunning(true);
    ksModel = new KistenschiebenModel();
    ksModel.loadLvl(genLvl.getLvlList(), genLvl.getColumn(), genLvl.getRow());
    ksView.generateLvl(
        genLvl.getLvlList(), genLvl.getColumn(), genLvl.getRow())
        .whenComplete(reactTouch);
    window.onResize.listen((EventListener) {
      ksView.scaling();
    });
    setActualLevel(genLvl.getCurrentLevel()+1);
    querySelector("#resetbutton").style.visibility = "visible";
    querySelector("#pushbutton").style.visibility = "visible";
    querySelector("#pullbutton").style.visibility = "visible";
    updateStats();
    ksView.showLvlCode(genLvl.getLvlCode());
  }

  /*
  Resets Game and local stats
  */
  void resetGame() {
    setGameRunning(true);
    ksModel.incResets();
    ksModel.loadLvl(genLvl.getLvlList(), genLvl.getColumn(), genLvl.getRow());
    ksView.generateLvl(
        genLvl.getLvlList(), genLvl.getColumn(), genLvl.getRow())
        .whenComplete(reactTouch);
    ksModel.resetStats();
    setActualLevel(genLvl.getCurrentLevel()+1);
    querySelector("#resetbutton").style.visibility = "visible";
    _steroidAmount = 0;
    _stickyGloveAmount = 0;
    ksView.setPullButton(0);
    ksView.setPushButton(0);
    updateStats();
  }

  /**
   * Checks if the User has already won
   */
  checkWin() async {
    if (ksModel.checkWin() == true) {
      _newGlove++;
      _newSteroids++;
      finishedGame = true;
      final highscores = await getHighscores();
      await ksView.showWin(highscores);
      setGameRunning(false);
      nextListener();
    }
  }

//endregion

  /**
   * Starts the level and returns true if the secret code is correct, returns false if not
   */
  bool _setLevelByCode(String code) {
    int level = genLvl.getLevelByCode(code);
    if (level != -1) {
      genLvl.setSelectlevel(level+1);
      genLvl.loadData().whenComplete(newGameRoutine);
      return true;
    }
    return false;
  }
}