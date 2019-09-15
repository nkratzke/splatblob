part of breakoutDart;

/**
* An instance of the class LevelLoaderJSON loads three Files
* per Level from the path parameters it was initialized with
*/
class LevelLoaderJSON
{
  String filePath;
  String fileName;
  int fileNumber;
  String fileEnding = '.json';
  Map map;
  String jsonString;

  /**
   * constructor
   */
  LevelLoaderJSON(String filePath, String fileName, int levelNr)
  {
    this.filePath = filePath;
    this.fileName = fileName;
    this.fileNumber = levelNr;
  }

  /**
  * loads the level with the levelnumber the loader was initialized with
  */
  loadNewLevel() async
  {
    await loadNextLevel();
  }

  /**
   * loads the trys to load 3 files paralell from the given path with the levelnumber
   * that match the field levelNr and adds there values to the map that
   * represtents the initial state of the new level,
   * if one or more of these files arent available it returns false
   * after a successful call of this method the fileNr is incremented so that
    * the next call of this method will automaticlly load the next level
   */
  Future<bool> loadNextLevel() async
  {
    bool ret = false;
    map = new Map();
    await Future.wait([loadJsonFileToMap("Settings"),loadJsonFileToMap("Stones"),loadJsonFileToMap("MoveableParts")]).then((List<Map> ml)
    {
      for(Map m in ml)
      {
        if(m != null)
        {
          map.addAll(m);
          ret = true;
        }
        else
        {
          ret = false;
        }
      }
    });
    if(ret)fileNumber++;
    return ret;
  }

  /**
  * according to the given fileType parameter this method trys to load a file
  * from the given path, which it builds of the fields
  * filePath+filePath+fileName+fileNumber+fileType+fileEnding
  * if the file doesnt exist the return value is null
  */
  Future<Map> loadJsonFileToMap(String fileType) async
  {
    String ret;
    try
    {
      await HttpRequest.getString(filePath+fileName+"${fileNumber}"+fileType+fileEnding).then((json)
      {
         ret = json;
      });
      return JSON.decode(ret);
    }
    catch(exception)
    {
      return null;
    }
  }

  int getPanelspeed() => map["panelspeed"];


  int getBallspeed() => map["ballspeed"];


  List getfieldSize() => map["fieldSize"];


  int getLevelNumber() => map["level"];


  int getLifes() => map["lifes"];

  /**
  * returns the element of the map that are of the type that is specified
  * by the parameter type
  */
  List getObjectsOfType(String type) => map[type];

}