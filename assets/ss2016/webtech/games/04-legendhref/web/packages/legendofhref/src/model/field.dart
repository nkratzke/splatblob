part of legendofhref;

/**
 * MapFields build up the map and store objects.
 */
class MapField {
  final Position position;
  final AreaMap map;
  FieldType _fieldType;
  FieldType _overlayType;
  List<ObjectEntity> _objects = new List<ObjectEntity>();
  String changeMapTo = null;

  View view;

  MapField(this.position, this._fieldType, this._overlayType, this.map);

  /**
   * load a map field from json
   */
  factory MapField.fromJson(Map json, AreaMap map) {
    MapField f = new MapField(
        new Position.fromJson(json[JSON_POSITION]),
        new FieldType(json[JSON_FIELDTYPE]),
        new FieldType(json[JSON_OVERLAYFIELDTYPE]),
        map);
    if ((json[JSON_OBJECTLIST] as List)?.isNotEmpty ?? false) {
      List<ObjectEntity> objects = (json[JSON_OBJECTLIST] as List)
          .map((o) => new ObjectEntity.fromJson(o, f))
          .toList();
      f._objects.addAll(objects);
    }
    f.changeMapTo = json[JSON_NEXTMAP];
    return f;
  }

  List<ObjectEntity> get objects => _objects;

  FieldType get fieldType => objects.firstWhere((ObjectEntity o) => o.overridesFieldType && !new FieldType(o._fieldType)?.overlay??false, orElse: () => null)?.fieldType??_fieldType;

  FieldType get overlayFieldType => objects.firstWhere((ObjectEntity o) => o.overridesFieldType && new FieldType(o._fieldType)?.overlay??false, orElse: () => null)?.fieldType??_overlayType;

  bool get passable =>
      (fieldType?.passable??true) && (overlayFieldType?.passable??true) &&
      unit == null &&
      (!hasObjects || objects.every((ObjectEntity o) => o.passable));

  Unit get unit => map.getUnitOnPosition(position);

  bool get hasObjects => objects.isNotEmpty;
  
  bool get hasObjectWithView => objects.any((ObjectEntity o) => o.view != null);
  
  int get objectCount => objects.length;
  
  ObjectEntity get firstObject => hasObjects ? objects.first : null;
  
  ObjectEntity get firstObjectWithView => objects
      .firstWhere((ObjectEntity o) => o.view != null, orElse: () => null);
  
  ObjectEntity firstObjectWhere(bool where(ObjectEntity o)) {
    return objects.firstWhere(where, orElse: () => null);
  }

  /**
   * adds an object to this field if the field is passable or the object ignores passability and returns true
   * otherwise it returns false
   */
  bool addObject(ObjectEntity obj) {
    if (passable || obj.ignoresPassability) {
      objects.add(obj);
      return true;
    } else {
      return false;
    }
  }

  void update() {
    view?.update();
  }

  MapField get north => map.getMapFieldOnPosition(position + Vector.NORTH);
  MapField get east => map.getMapFieldOnPosition(position + Vector.EAST);
  MapField get south => map.getMapFieldOnPosition(position + Vector.SOUTH);
  MapField get west => map.getMapFieldOnPosition(position + Vector.WEST);
  MapField getNeighbor(Vector d) => map.getMapFieldOnPosition(position + d);

  bool onAttack(AttackEvent e) {
    if (unit != null) {
      unit.onAttack(e);
    } else {
      ObjectEntity obj = firstObjectWhere((o) => o.healthPercentage > 0);
      if(obj != null) {
        obj.onAttack(e);
      } else {
        return false;
      }
    }
    return true;
  }

  bool onPush(EntityPushEvent e) {
    return unit?.onPush(e) ??
        firstObjectWhere((o) => o.passable == false)?.onPush(e) ??
        false;
  }
  
  /**
   * alerts this field that an unit moved on it.
   * this is used for map changes
   */
  void movedTo() {
    if (unit?.type == map.game.pc.type && changeMapTo != null) {
      map.game.changeMap(changeMapTo);
    }
  }

  String toString() => "${position}: ${fieldType}(${passable}|${objectCount})";

  /**
   * saves this field to json
   */
  Map toJson() {
    Map json = new Map();
    json[JSON_POSITION] = position.toJson();
    json[JSON_FIELDTYPE] = _fieldType.id;
    if(_overlayType != null) {
      json[JSON_OVERLAYFIELDTYPE] = _overlayType.id;
    }
    if (hasObjects) {
      json[JSON_OBJECTLIST] = new List();
      json[JSON_OBJECTLIST].addAll(_objects.map((o) => o.toJson()));
    }
    if(changeMapTo != null) {
      json[JSON_NEXTMAP] = changeMapTo;
    }
    return json;
  }
}

/**
 * a fieldtype with the attributes a field that has this fieldtype has.
 */
class FieldType {
  //STATIC-Part
  /**
   * the field types a field could have
   */
  static Map<int, FieldType> _TYPES;

  static loadFieldTypeFromJSON(List json) {
    if (_TYPES != null) return;
    _TYPES = new Map<int, FieldType>();
    for (Map fieldJson in json) {
      _TYPES[fieldJson[JSON_ID]] = new FieldType._private(
          fieldJson[JSON_ID],
          fieldJson[JSON_FIELDTYPENAME],
          fieldJson[JSON_PASSABLE],
          fieldJson[JSON_OVERLAY],
          fieldJson[JSON_MULTIPART]);
    }
    _TYPES = new Map.unmodifiable(_TYPES);
  }

  //FieldType
  final int id;
  final String name;
  final bool passable;
  final bool overlay;
  /**
   * this is used to create roads or walls
   */
  final Map multipart;

  factory FieldType(int id) {
    if(id == null) return null;
    return _TYPES[id];
  }

  FieldType._private(
      this.id, this.name, this.passable, this.overlay, this.multipart);

  String toString() => JSON.encode(this);

  /**
   * saves this fieldtype to json
   */
  Map toJson() {
    Map json = new Map();
    json[JSON_ID] = id;
    json[JSON_FIELDTYPENAME] = name;
    json[JSON_PASSABLE] = passable;
    json[JSON_OVERLAY] = overlay;
    if (multipart != null) {
      json[JSON_MULTIPART] = multipart;
    }
    return json;
  }
}
