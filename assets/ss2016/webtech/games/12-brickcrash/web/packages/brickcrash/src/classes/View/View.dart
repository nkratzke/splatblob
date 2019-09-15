part of brickcrash;
/**
 * Die View steuert die DOM-Elemente des Spiels
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */
class View {
  Player player;

  Element mainFrame           = querySelector("#mainFrame");
  Element mainWrap           = querySelector("#mainWrap");
  Element debugFrame          = querySelector("#debug");
  Element gameKeyStatus       = querySelector("#gameKeyStatus");
  Element usernamePlaceholder = querySelector("#usernamePlaceholder");
  Element powerUpsFrame       = querySelector("#powerups");
  Element levelInformation    = querySelector("#levelInformation");

  /**
   * Constructor
   */
  /**
   * Im Konstruktor wird der Spieler gesetzt
   * @param player Spieler
   */
  View (Player player) { this.setPlayer(player); }

  /*
    GETTER
   */
  /**
   * Die Breite des Spielfeldes
   * @return die Breite
   */
  int getWidth()              { return mainFrame.clientWidth;  }

  /**
   * Die Hoehe des Spielfeldes
   * @return die Hoehe
   */
  int getHeight()             { return mainFrame.clientHeight; }

  /**
   * Die Breite der Grenze
   * @return die Breite der Grenze
   */
  int getBorderWidth()        { return 10; }//double.parse(mainFrame.getComputedStyle().borderWidth.replaceAll("px","")).floor(); }

  /*
    SETTER
   */
  /**
   * Setzt den Spieler
   * @param player Spieler
   */
  void setPlayer(Player player) { this.player = player; }

  /*
    METHODS
   */
  /**
   * Fuegt das Element zum Spielfeld hinzu
   * @param element Das hinzuzufuegende Element
   */
  void add(Element element)                       { mainFrame.append(element);                        }

  /**
   * Ist nur zum Testen gedacht
   */
  void debug(String str)                          { querySelector("#debug").innerHtml += str+"<br>";  }

  /**
   * Platziert das Objekt im Spielfeld
   * @param model Das Objekt
   * @param element Das Element
   */
  Future  place(model, element) async {
      element.style.left = model.getXPosition().toString()+"px";
      element.style.top  = model.getYPosition().toString()+"px";
  }

  /**
   * Aktuallisiert die Groesse des Objektes
   * @param model Das Objekt
   * @param element Das Element
   */
  Future updateSize(model, element) async {
    element.style.width   = model.getWidth().toString()+"px";
    element.style.height  = model.getHeight().toString()+"px";
  }

  /**
   * Hier wird das Objekt platziert und Aktuallisiert
   * @param model Das Objekt
   * @param element Das Element
   */
  Future updateElement(model, element) async {
    if(model != null && element != null){
      this.place(model, element);
      this.updateSize(model, element);
    }
  }

  /**
   * Aktuallisiert den Spielernamen auf dem Informationsfeld rechts
   */
  void updatePlayer() { this.usernamePlaceholder.text = this.player.getUserName(); }

  /**
   * Entfernt ein Element aus dem Spielfeld
   * @param model Das Objekt
   * @param elements Die Elemente
   */
  void removeElement(DOMObject model, elements)   {
    if(elements[model] != null) {
      elements[model].remove();
      elements.remove(model);
    }
  }

  /**
   * Hier werden alle Elemente aktuallisiert
   * @param models Die Objekte
   * @param elements Die Elemente
   */
  Future updateEach(List models, Map elements) async {
    if (elements.length > 0) {
      elements.forEach((model,element) async {
        if (!models.contains(model)){ this.removeElement(model, elements); }
        await this.updateElement(model, elements[model]);
      });
    }
  }

  /**
   * Aktuallisiert den Status zur Verbindung mit dem Gamekey Service
   * @param status Der aktuelle Status
   */
  Future updateGameKeyStatus(int status)async {
    this.gameKeyStatus.classes.clear();

    switch (status) {
      case 0 :
        this.gameKeyStatus
          ..classes.add("offline")
          ..text = "Offline"
        ;
        break;

      case 1 :
        this.gameKeyStatus
          ..classes.add("connecting")
          ..text = "Connecting.."
        ;
        break;

      case 2 :
        this.gameKeyStatus
          ..classes.add("online")
          ..text = "Online"
        ;
        break;
    }
  }

  /**
   * Eine Methode, die benutzt wird, damit die Kinder diese Erben koennen
   */
  void drawDefault() {}

  /**
   * Entfernt die Kinderelemente
   * @elem Das Kinderelement
   */
  void removeAllChildren(Element elem) {
      elem.children.forEach((element) async { await element.remove(); });
  }

  /**
   * Saeubert das Spielfeld, damit ein neues Spiel gemacht werden kann
   */
  void clear() {
    this.removeAllChildren(this.mainFrame);
    this.removeAllChildren(this.powerUpsFrame);
    this.usernamePlaceholder.text = "";
  }

  /**
   * Wenn ein neues Spiel geladen wird, so wird das Spielfeld gesaeubert und
   * dann neu erstellt
   */
  Future load() async {
    this.clear();
    this.drawDefault();
  }

  /**
   * Aktuallisiert den Spielernamen, falls dieser Existiert
   */
  Future update() async {
    if (this.player != null) {
      this.updatePlayer();
    }
  }
}