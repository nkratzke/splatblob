part of legendofhref;

/**
 * Ingame map of the area
 */
class AreaMap {
  Map<Position, MapField> _map;
  Map<Position, Unit> _units;
  final int width, height;
  final Game game;
  View view;

  /**
   * a simple field generator that generate fields for a given map. The fields are empty grass or dirt fields.
   */
  static MapField defaultMapGenerator(AreaMap areamap, Position p, Random r) {
    return new MapField(p, new FieldType(r.nextInt(2)), null, areamap);
  }

  /**
   * default constructor to create an empty map.
   */
  AreaMap(this.width, this.height, this.game) {
    _map = new SplayTreeMap<Position, MapField>(Position.sortInPrintOrder);
    _units = new SplayTreeMap<Position, Unit>(Position.sortInPrintOrder);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        _map[new Position(x, y)] = null;
      }
    }
  }
  
  /**
   * factory for creating an map with randomly generate fields
   */
  factory AreaMap.randomMap(int width, int height, Game game, [MapField mapGenerator(AreaMap areamap, Position p, Random r), Random r]) {
    r = r??new Random();
    mapGenerator = mapGenerator??defaultMapGenerator;
    AreaMap map = new AreaMap(width, height, game);
    for (Position p in (map._map).keys) {
      map._map[p] = mapGenerator(map, p, r);
    }
    return map;
  }
  
  /**
   * factory to load an Areamap from a json file.
   */
  factory AreaMap.fromJson(Map json, Game game) {
    AreaMap map = new AreaMap(json[JSON_MAPWIDTH], json[JSON_MAPHEIGHT], game);
    if(json[JSON_FIELDLIST] is List) {
      MapField f;
      Unit u;
      for(Map fieldJson in json[JSON_FIELDLIST]) {
        f = new MapField.fromJson(fieldJson, map);
        map._map[f.position] = f;
      }
      for(Map unitJson in json[JSON_UNITLIST]) {
        u = new Unit.fromJson(unitJson, game);
        map._units[u.position] = u;
      }
    } else {
      for (Position p in (map._map).keys) {
        map._map[p] = new MapField.fromJson(json[JSON_FIELDLIST][p.toString()], map);
        if(json[JSON_UNITLIST].containsKey(p.toString())) map._units[p] = new Unit.fromJson(json[JSON_UNITLIST][p.toString()], game);
      }
    }
    return map;
  }

  /**
   * check field for passability
   */
  bool passable(Position p) {
    return (_map[p]?.passable ?? false);
  }

  /**
   * check if position is within bounds
   */
  bool checkBoundary(Position p) =>
      p.x >= 0 && p.x < width && p.y >= 0 && p.y < height;

  /**
   * get field for position
   */
  MapField getMapFieldOnPosition(Position p) {
    return _map[p];
  }

  /**
   * get unit on position
   */
  Unit getUnitOnPosition(Position p) {
    return _units[p];
  }

  /**
   * move an unit to a position
   */
  bool moveUnit(Unit u, Position p) {
    if(u.ignoresPassability) {
      if(_units[p] != null) return false;
    } else if(!passable(p)) {
      return false;
    }
    if (u.position != null) _units.remove(u.position);
    _units[p] = u;
    getMapFieldOnPosition(p).movedTo();
    return true;
  }

  /**
   * move an object to a position
   */
  bool moveObject(ObjectEntity o, Position p) {
    if (_map[p]?.addObject(o) ?? false) {
      _map[o.position]?.objects?.remove(o);
      return true;
    }
    return false;
  }
  
  /**
   * removes an unit from the map
   */
  void removeUnit(Unit u) {
    _units.remove(u.position);
    u._position = null;
  }
  
  /**
   * returns an unmodifiable list of units
   */
  List<Unit> get units => new List.unmodifiable(_units.values);

  /**
   * returns a submap of this map between the two given positions
   */
  Map<Position, MapField> getSubmap(Position p1, Position p2) {
    return new SplayTreeMap.fromIterable(
        _map.keys.where((p) => p >= p1).where((p) => p <= p2),
        key: (p) => p,
        value: (p) => _map[p],
        compare: Position.sortInPrintOrder);
  }

  /**
   * executes an action on every mapfield in an optional given map with an optinal given filter
   * if no map is given the whole map is processed and if no filter is given the filter is expected to be true
   */
  void forEachField(void fieldProcessor(MapField f), {
      Map<Position, MapField> map: null, bool filter(MapField f)}) {
    for (MapField f in (map ?? _map).values.where(filter??(f)=>true)) {
      fieldProcessor(f);
    }
  }
  
  /**
   * returns a submap around a position - the radius is the higher weight argument if the position is to close to the map boarder the function returns still the same size and moves the center to a better location
   */
  Map<Position, MapField> getSubmapAroundPosition(Position p, int radius) {
    Position p1, p2;
    Vector correction1 = Vector.NULL, correction2 = Vector.NULL;
    p1 = p-(Vector.ONE*radius);
    if(!checkBoundary(p1)) {
      if(p1.x < 0) {
        correction1 = new Vector(1, 0);
        correction1 *= 0-p1.x;
      } else {
        correction1 = Vector.NULL;
      }
      if(p1.y < 0) {
        correction2 = new Vector(0, 1);
        correction2 *= 0-p1.y;
      } else {
        correction2 = Vector.NULL;
      }
      p1 += correction1;
      p1 += correction2;
    }
    p2 = p1+(Vector.ONE*(radius*2));
    if (!checkBoundary(p2)) {
      if(p2.x >= width) {
        correction1 = new Vector(1, 0);
        correction1 *= width-1-p2.x;
      } else {
        correction1 = Vector.NULL;
      }
      if(p2.y >= height) {
        correction2 = new Vector(0, 1);
        correction2 *= height-1-p2.y;
      } else {
        correction2 = Vector.NULL;
      }
      p2 += correction1;
      p2 += correction2;
      p1 = p2-(Vector.ONE*(radius*2));
      if(!checkBoundary(p1)) {
        if(p1.x < 0) {
          correction1 = new Vector(1, 0);
          correction1 *= 0-p1.x;
        } else {
          correction1 = Vector.NULL;
        }
        if(p1.y < 0) {
          correction2 = new Vector(0, 1);
          correction2 *= 0-p1.y;
        } else {
          correction2 = Vector.NULL;
        }
        p1 += correction1;
        p1 += correction2;
      }
    }
    return getSubmap(p1, p2);
  }

  /**
   * executes an action on every unit an optional filter can be applied and is processed as 'true' if not given.
   */
  void forEachUnit(void unitProcessor(Unit u), {bool filter(Unit u)}) {
    for (Unit u in units.where(filter??(u)=>true)) {
      unitProcessor(u);
    }
  }
  
  /**
   * returns the json string of this map
   */
  String toString() => JSON.encode(toJson());
  
  /**
   * generates an json map for this area map
   */
  Map toJson() {
    Map json = new Map();
    json[JSON_MAPWIDTH] = width;
    json[JSON_MAPHEIGHT] = height;
    json[JSON_FIELDLIST] = new List();
    this.forEachField((MapField f) {
      json[JSON_FIELDLIST].add(f.toJson());
    });
    json[JSON_UNITLIST] = new List();
    this.forEachUnit((Unit u) {
      json[JSON_UNITLIST].add(u.toJson());
    });
    return json;
  }
}
