part of legendofhref;

/**
 * 2d vector class for use in positions, directions and movement.
 */
class Vector {
  /**
   * x and y coordinates from this vector.
   */
  final int x, y;
  /**
   * vector pointing to the NORTH (upper side of the monitor)
   */
  static const Vector NORTH = const Vector(0, -1);
  /**
   * vector pointing to the EAST (right side of the monitor)
   */
  static const Vector EAST = const Vector(1, 0);
  /**
   * vector pointing to the SOUTH (lower side of the monitor)
   */
  static const Vector SOUTH = const Vector(0, 1);
  /**
   * vector pointing to the WEST (left side of the monitor)
   */
  static const Vector WEST = const Vector(-1, 0);
  /**
   * vector pointing to the FRONT in use for attack rotation (upper side of the monitor)
   */
  static const Vector FRONT = NORTH;
  /**
   * vector pointing to the LEFT in use for attack rotation (right side of the monitor) - this is due to the fact that our default looking direction from the hero is "south" and the rotation of the weapons is FRONT (north)
   */
  static const Vector LEFT = EAST;
  /**
   * vector pointing to the BACK in use for attack rotation (lower side of the monitor)
   */
  static const Vector BACK = SOUTH;
  /**
   * vector pointing to the RIGHT in use for attack rotation (left side of the monitor) - this is due to the fact that our default looking direction from the hero is "south" and the rotation of the weapons is FRONT (north)
   */
  static const Vector RIGHT = WEST;
  /**
   * 0 vector - mathematical constant (all fields 0)
   */
  static const Vector NULL = const Vector(0, 0);
  /**
   * 1 vector - mathematical constant (all fields 1)
   */
  static const Vector ONE = const Vector(1, 1);

  /**
   * Default constructor to create a new (constant) 2d vector
   */
  const Vector(this.x, this.y);
  
  /**
   * Factory to parse a vector from a json map
   */
  factory Vector.fromJson(Map json) {
    return new Vector(json["x"], json["y"]);
  }

  /**
   * length of this vector
   */
  double abs() {
    return scalar(this);
  }

  /**
   * distance between to point vectors
   */
  double scalar(Vector v) {
    return sqrt(x * v.x + y * v.y);
  }

  /**
   * multiplication with a scalar - resulting vector uses rounded values. This does not change the vector it is called with but returns a new vector!
   */
  Vector operator *(num o) {
    return new Vector((x * o).round(), (y * o).round());
  }

  /**
   * divides with a scalar - resulting vector uses rounded values. This does not change the vector it is called with but returns a new vector!
   */
  Vector operator /(num o) {
    return new Vector((x / o).round(), (y / o).round());
  }

  /**
   * returns a new vector with the sum of this and the given vector
   */
  Vector operator +(Vector o) {
    return new Vector(x + o.x, y + o.y);
  }

  /**
   * returns a new vector with the position of this vector substracted by the given vector.
   */
  Vector operator -(Vector o) {
    return new Vector(x - o.x, y - o.y);
  }
  
  /**
   * returns a new clockwise rotated vector
   */
  Vector rotateRight() {
    return _rotate(false);
  }
  
  
  /**
   * returns a new counter clockwise rotated vector
   */
  Vector rotateLeft() {
    return _rotate(true);
  }
  
  /**
   * returns a new vector with the rotate values of this vector if left is false the rotation will be clockwise otherwise counterclockwise
   */
  Vector _rotate(bool left) {
    int rx, ry;
    rx = -y * (left?1:-1);
    ry = x * (left?1:-1);
    return new Vector(rx, ry);
  }

  /**
   * returns true if x and y of this vector are less than x and y of the given vector
   */
  bool operator <(Vector o) {
    return (x < o.x && y < o.y);
  }
  
  /**
   * returns true if x and y of this vector are greater than x and y of the given vector
   */
  bool operator >(Vector o) {
    return (x > o.x && y > o.y);
  }
  
  /**
   * returns true if x and y of this vector are less than or equals x and y of the given vector
   */
  bool operator <=(Vector o) {
    return (x <= o.x && y <= o.y);
  }

  /**
   * returns true if x and y of this vector are greater than or equals x and y of the given vector
   */
  bool operator >=(Vector o) {
    return (x >= o.x && y >= o.y);
  }
  
  /**
   * returns true if x and y of this vector are equals x and y of the given vector 
   */
  bool operator ==(var o) => o is Vector && x == o.x && y == o.y;
  
  /**
   * sorting function that sorts in order with 0|0 to 0|N column by column
   */
  static int sortInOrder(Vector v1, Vector v2) {
    if(v1.x < v2.x) {
      return -1;
    } else if(v1.x > v2.x) {
      return 1;
    } else {
      if(v1.y < v2.y) {
        return -1;
      } else if(v1.y > v2.y) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  /**
   * returns a short and human readable representation of the vector - use is for debugging AND use in keys of JSON-Arrays do not change!
   */
  String toString() => "V${x}_${y}";
  
  /**
   * creates the json representation for this vector
   */
  Map toJson() {
    Map json = new Map();
    json["x"] = x;
    json["y"] = y;
    return json;
  }
}

/**
 * Position class for keys in the gamemap and storage of the position of objects and units
 * functions are mainly used in pathfinding
 * this class has a static list with already created objects for caching and will return the cached object if it exists.
 * for sanety it is advised to use only not negative coordinates - the implementation can use negative vectors but is not tested and it is officially not defined what to expect if one uses negative values in a position vector.
 */
class Position {
  /**
   * static cache - should not be interacted with
   */
  static Map<int, Map<int, Position>> _cache =
      new Map<int, Map<int, Position>>();

  /**
   * function to empty the cache - this function is currently unused and could be used if one switches from a very large map to a smaller
   * exampel:
   * old map is 1.000x1.000 - that would mean there are 1.000.000 objects in the cache
   * new map is 10x10 - we would only need 100 objects - cleaning of the cache is highly adviseable
   * if old an new map have identical or nearly identical the same size using this functions does no harm but wasting cpu time
   */
  static emptyCache() {
    _cache.values.forEach((m) {
      m.clear();
      m = null;
    });
    _cache.clear();
  }

  /**
   * position vector of this position - should always have not negative x and y values - otherwise behavior of this class is undefined!
   */
  final Vector positionVector;

  /**
   * factory to create positions or load them from cache using x and y
   */
  factory Position(int x, int y) {
    if (_cache.containsKey(x)) {
      if (_cache[x].containsKey(y)) {
        return _cache[x][y];
      }
    } else {
      _cache[x] = new Map<int, Position>();
    }
    final Position pos = new Position._internal(new Vector(x, y));
    _cache[x][y] = pos;
    return pos;
  }

  /**
   * factory to create positions or load them from cache using a vector
   */
  factory Position.vector(Vector v) {
    if (_cache.containsKey(v.x)) {
      if (_cache[v.x].containsKey(v.y)) {
        return _cache[v.x][v.y];
      }
    } else {
      _cache[v.x] = new Map<int, Position>();
    }
    final Position pos = new Position._internal(v);
    _cache[v.x][v.y] = pos;
    return pos;
  }
  
  /**
   * factory to load positions from json either by creating them or loading them from cache - both forms (with vector or with direct coordinates) are usable
   */
  factory Position.fromJson(Map json) {
    if(json[JSON_VECTOR] == null) {
      return new Position(json["x"], json["y"]);
    } else {
      return new Position.vector(new Vector.fromJson(json[JSON_VECTOR]));
    }
  }

  ///Creates a new position from a vector this vector should not have negative values for x or y otherwise behavior of this class is undefined
  Position._internal(this.positionVector);

  ///returns a new position with this positionVector + given vector
  Position operator +(Vector v) => new Position.vector(positionVector + v);
  ///returns a new position with this positionVector - given vector
  Position operator -(Vector v) => new Position.vector(positionVector - v);

  ///returns x
  int get x => positionVector.x;
  ///returns y
  int get y => positionVector.y;

  bool operator <(Position p) {
    return (positionVector < p.positionVector);
  }
  
  bool operator >(Position p) {
    return (positionVector > p.positionVector);
  }
  
  bool operator <=(Position p) {
    return (positionVector <= p.positionVector);
  }

  bool operator >=(Position p) {
    return (positionVector >= p.positionVector);
  }

  /**
   * checks if given object is the same position object or if the object is a vector that is identically to the this positionVector
   */
  bool operator ==(var o) =>
      (o is Position && (positionVector == (o as Position)?.positionVector)) ||
      (o is Vector && (positionVector == (o as Vector)));

  int get hashCode => positionVector.hashCode;
  String toString() => "Px${positionVector.x}y${positionVector.y}";
  
  /**
   * sorts positions in print order left to right top to bottom
   */
  static int sortInPrintOrder(Position p1, Position p2) {
    if(p1.y < p2.y) {
      return -1;
    } else if(p1.y > p2.y) {
      return 1;
    } else {
      if(p1.x < p2.x) {
        return -1;
      } else if(p1.x > p2.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }
  
  /**
   * returns json representain of this position
   */
  Map toJson() {
    Map json = new Map();
    json["x"] = x;
    json["y"] = y;
    return json;
  }
  
  /**
   * returns the distance on the x-axis to the given position
   */
  int getXDistanceTo(Position p) => (x-p.x).abs();
  /**
   * returns the distance on the y-axis to the given position
   */
  int getYDistanceTo(Position p) => (y-p.y).abs();
  
  /**
   * returns the sum of the distance on both axis to the given position
   */
  int getLDistanceTo(Position p) => getXDistanceTo(p)+getYDistanceTo(p);
  /**
   * returns the direct distance (scalar between the position vectors)
   */
  double getSDistanceTo(Position p) => positionVector.scalar(p.positionVector);
  
  /**
   * returns a vector that has the direction and length of the way from this position to the target position
   */
  Vector getDirectionVector(Position target) => target.positionVector - positionVector;
}
