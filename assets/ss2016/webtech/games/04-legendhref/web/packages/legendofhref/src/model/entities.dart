part of legendofhref;

/**
 * common basis for all entities (player character, units and objects)
 */
abstract class _Entity {
  /**
   * prototypes for units and objects
   */
  static Map<String, _Entity> _TYPES;

  /**
   * load object prototypes
   */
  static void loadObjectsFromJson(List json) {
    if (_TYPES == null) {
      _TYPES = new Map<String, _Entity>();
    }
    ObjectEntity o;
    for (Map objectJson in json) {
      o = new ObjectEntity(null, objectJson[JSON_ENTITYTYPE]);
      o.loadJson(objectJson);
      _TYPES[objectJson[JSON_ENTITYTYPE]] = o;
    }
  }

  /**
   * load unit prototypes
   */
  static void loadUnitsFromJson(List json) {
    if (_TYPES == null) {
      _TYPES = new Map<String, _Entity>();
    }
    Unit u;
    for (Map unitJson in json) {
      u = new Unit.fromJson(unitJson, null);
      _TYPES[unitJson[JSON_ENTITYTYPE]] = u;
    }
  }

  Position _position;
  final String type;
  int _maxHP = 0;
  int _HP = 0;
  Game _game;
  View _view;
  int arrow_dropchance;
  int healpotion_dropchance;
  /**
   * Map of damage types a unit is immun - immunity is implemented damagetypes are not implement at this state
   */
  Map<int, bool> immune;
  bool ignoresPassability = false;

  List<EntityEventListener> _eventListener = new List<EntityEventListener>();

  /**
   * basic constructor the create an entity with a game and a type 
   */
  _Entity(this._game, this.type);

  Position get position => _position;

  bool get alive => (_HP > 0 || _maxHP == 0);

  bool moveToPosition(Position p);

  /**
   * spawns an entity on a position if the entity is not already on a position.
   */
  bool spawnAtPosition(Position p) {
    if (_position == null) {
      return moveToPosition(p);
    } else {
      return false;
    }
  }

  EntityView get view => _view;
  void set view(EntityView view) {
    _view = view;
    updateView();
  }

  updateView() {
    view?.update();
  }

  /**
   * function to display hit animation
   */
  void showHit(Unit attacker) {
    //TODO fixme - animation is only executed once
    view.showHit(attacker);
  }

  void addEntityEventListener(EntityEventListener evtListener) {
    _eventListener.add(evtListener);
  }

  void onAttack(AttackEvent e) {
    _eventListener.forEach((EntityEventListener l) => l.onAttack(e));
  }

  void onDeath() {
    _eventListener.forEach((EntityEventListener l) => l.onDeath());
  }

  void onAreaOfAttentionUpdate(AOAUpdateEvent e) {
    _eventListener
        .forEach((EntityEventListener l) => l.onAreaOfAttentionUpdate(e));
  }

  bool onPush(EntityPushEvent e) {
    return _eventListener.fold(
        false, (bool state, EntityEventListener l) => l.onPush(e) || state);
  }

  bool move(Vector direction) {
    return moveToPosition(_position + direction);
  }

  num get healthPercentage =>
      ((_maxHP ?? 0) > 0) ? ((((_HP ?? 0) > 0 ? _HP : 0) * 100) / _maxHP) : 0;

  void die();

  bool get passable;
  bool get pushable;

  MapField get field {
    return _game.map.getMapFieldOnPosition(_position);
  }

  void set field(MapField field) {
    _position = field?.position;
  }

  String toString() {
    return type;
  }

  /**
   * load the entity part of an json map to an entity
   */
  void loadJson(Map json) {
    if (json[JSON_POSITION] != null) {
      _position = new Position.fromJson(json[JSON_POSITION]);
    }
    _maxHP = json[JSON_MAXHP] ?? _TYPES[type]?._maxHP ?? 0;
    _HP = json[JSON_HP] ?? _maxHP;
    arrow_dropchance =
        json[JSON_ARROW_DROPCHANCE] ?? _TYPES[type]?.arrow_dropchance ?? 0;
    healpotion_dropchance = json[JSON_HEALPOTIONS_DROPCHANCE] ??
        _TYPES[type]?.healpotion_dropchance ??
        0;
    immune = (json[JSON_IMMUNE] != null)
        ? new Map.fromIterable(json[JSON_IMMUNE].keys, key: (k) {
            return int.parse(k);
          }, value: (k) {
            return json[JSON_IMMUNE][k];
          })
        : new Map.from(_TYPES[type]?.immune?? new Map());
    ignoresPassability =
        json[JSON_IGNORE_PASSABLE] ?? _TYPES[type]?.ignoresPassability ?? false;
  }

  /**
   * saves the changed parts of an entity to json
   * changed means values other than in the TYPE-Default
   */
  Map toJson() {
    Map json = new Map();
    json[JSON_ENTITYTYPE] = type;
    if (_position != null) {
      json[JSON_POSITION] = _position;
    }
    if (_maxHP != _TYPES[type]?._maxHP) {
      json[JSON_MAXHP] = _maxHP;
    }
    if (_HP != _maxHP) {
      json[JSON_HP] = _HP;
    }
    if (arrow_dropchance != _TYPES[type]?.arrow_dropchance) {
      json[JSON_ARROW_DROPCHANCE] = arrow_dropchance;
    }
    if (healpotion_dropchance != _TYPES[type]?.healpotion_dropchance) {
      json[JSON_HEALPOTIONS_DROPCHANCE] = healpotion_dropchance;
    }
    if (immune.isNotEmpty) {
      if (_TYPES[type]?.immune?.length != immune.length ||
          !immune.keys.fold(
              true, (v, k) => v && (_TYPES[type].immune[k] == immune[k]))) {
        json[JSON_IMMUNE] = new Map.fromIterables(
            immune.keys.map((i) => i.toString()), immune.values);
      }
    }
    if (ignoresPassability != _TYPES[type]?.ignoresPassability) {
      json[JSON_IGNORE_PASSABLE] = ignoresPassability;
    }
    return json;
  }

  /**
   * saves the full entity to json even unchanged parts
   */
  Map toFullJson() {
    Map json = new Map();
    json[JSON_ENTITYTYPE] = type;
    if (_position != null) {
      json[JSON_POSITION] = JSON.encode(_position);
    }
    json[JSON_MAXHP] = _maxHP;
    json[JSON_HP] = _HP;
    json[JSON_ARROW_DROPCHANCE] = arrow_dropchance;
    json[JSON_HEALPOTIONS_DROPCHANCE] = healpotion_dropchance;
    if (immune.isNotEmpty) {
      json[JSON_IMMUNE] = new Map.fromIterables(
          immune.keys.map((i) => i.toString()), immune.values);
    }
    json[JSON_IGNORE_PASSABLE] = ignoresPassability;
    return json;
  }
}

/**
 * Units are all entitys that can move on there own, they can process turns and attack other entities.
 * units have a facing and a score value
 */
class Unit extends _Entity {
  Vector _facing;
  int attackAction = 0;
  List<AttackAction> attacks = new List<AttackAction>();
  int _aimode = AI_NEUTRAL;
  int arrows;
  int healpotions;
  int score;
  int score_value;
  int killcount;

  /**
   * Creates a new unit, if possiple from a TYPE otherwise an empty default unit.
   */
  factory Unit(Game game, String type) {
    Unit u;
    if (_Entity._TYPES[type] is Unit) {
      u = new Unit._fromUnit(game, type, _Entity._TYPES[type]);
    } else if (_Entity._TYPES[type] == null) {
      u = new Unit._private(game, type);
    } else {
      throw type;
    }
    return u;
  }

  Unit._private(Game game, String type) : super(game, type) {
    _facing = Vector.SOUTH;
  }

  /**
   * clones an unit
   */
  factory Unit._fromUnit(Game game, String type, Unit u) {
    String json = JSON.encode(u, toEncodable: (u) => u.toFullJson());
    return new Unit.fromJson(JSON.decode(json), game);
  }

  /**
   * creates an unit from json
   */
  factory Unit.fromJson(Map json, Game game) {
    Unit u = new Unit._private(game, json[JSON_ENTITYTYPE]);
    u.loadJson(json);
    return u;
  }

  int get aimode => _aimode;

  /**
   * moves this unit to a position and tries to push entities if possible
   */
  bool moveToPosition(Position p) {
    bool state = _game.map.moveUnit(this, p);
    if (!state) {
      if (field
              .getNeighbor(facing)
              ?.onPush(new EntityPushEvent(this, facing)) ??
          false) {
        state = _game.map.moveUnit(this, p);
      }
    }
    if (state) {
      _position = p;
      updateView();
    }
    return state;
  }

  /**
   * Moves this unit in a give direction - the direction vector must have a length of 1
   */
  bool move(Vector direction) {
    if (direction.abs() != 1) {
      direction = direction / direction.abs();
    }
    if(direction == Vector.NULL) direction = facing;
    if (direction != facing) {
      facing = direction;
      return true;
    }
    return super.move(direction);
  }

  /**
   * this unit attacks with its selected weapon
   */
  void attack() {
    attacks[attackAction]?.attack(this);
  }

  /**
   * uses a healpotion
   */
  void useHealpotion() {
    if(healpotions > 0) {
      healpotions--;
      _HP = _maxHP;
      updateView();
    }
  }

  void set facing(Vector facing) {
    _facing = facing;
    updateView();
  }

  /**
   * this unit is dead after this method
   */
  void die() {
    _game.map.removeUnit(this);
    _HP = 0;
    updateView();
  }

  Vector get facing => _facing;

  /**
   * returns the word representation of the facing for this unit
   */
  String getFacingAsString() {
    if (facing == Vector.NORTH) {
      return "north";
    } else if (facing == Vector.EAST) {
      return "east";
    } else if (facing == Vector.WEST) {
      return "west";
    } else {
      return "south";
    }
  }

  bool get passable => false;
  bool get pushable => false;

  /**
   * this is called from the game loop when ever this unit has its turn
   */
  void turn() {
    _eventListener
        .forEach((EntityEventListener l) => (l as UnitEventListener)?.turn());
  }

  String toString() => JSON.encode(this, toEncodable: (u) => u.toFullJson());

  /**
   * get the TYPE for this unit.
   */
  Unit get _BLUEPRINT => (_Entity._TYPES[type] as Unit);

  /**
   * load the attributes for this unit from json using the entity loadJson method for the basis.
   */
  void loadJson(Map json) {
    super.loadJson(json);
    _facing = json[JSON_FACING] != null
        ? new Vector.fromJson(json[JSON_FACING])
        : Vector.SOUTH;
    attackAction = json[JSON_ATTACKACTION] ?? _BLUEPRINT?.attackAction ?? 0;
    _aimode = json[JSON_AIMODE] ?? _BLUEPRINT?._aimode ?? AI_NEUTRAL;
    if (json[JSON_ATTACKACTIONS] != null) {
      attacks.addAll(json[JSON_ATTACKACTIONS]
          .map((attack) => new AttackAction.fromJson(attack)));
    } else {
      if (_BLUEPRINT != null) {
        attacks.addAll(_BLUEPRINT.attacks);
      } else {
        attacks.add(new AttackAction({Vector.FRONT: 1}));
      }
    }
    arrows = json[JSON_ARROWS] ?? _BLUEPRINT?.arrows ?? 0;
    healpotions = json[JSON_HEALPOTIONS] ?? _BLUEPRINT?.healpotions ?? 0;
    killcount = json[JSON_KILLCOUNT] ?? _BLUEPRINT?.killcount ?? 0;
    score = json[JSON_SCORE] ?? _BLUEPRINT?.score ?? 0;
    score_value = json[JSON_SCORE_VALUE] ?? _BLUEPRINT?.score_value ?? 0;
  }

  /**
   * saves changes of this unit to json using the entity toJson method for the basis.
   * changed means values other than in the TYPE-Default
   */
  Map toJson() {
    Map json = super.toJson();
    json[JSON_FACING] = _facing;
    if (attackAction != _BLUEPRINT?.attackAction) {
      json[JSON_ATTACKACTION] = attackAction;
    }
    if (JSON.encode(attacks) != JSON.encode(_BLUEPRINT?.attacks)) {
      json[JSON_ATTACKACTIONS] = attacks;
    }
    if (aimode != _BLUEPRINT.aimode) {
      json[JSON_AIMODE] = aimode;
    }
    if (arrows != _BLUEPRINT.arrows) {
      json[JSON_ARROWS] = arrows;
    }
    if (healpotions != _BLUEPRINT.healpotions) {
      json[JSON_HEALPOTIONS] = healpotions;
    }
    if (killcount != _BLUEPRINT.killcount) {
      json[JSON_KILLCOUNT] = killcount;
    }
    if (score != _BLUEPRINT.score) {
      json[JSON_SCORE] = score;
    }
    if (score_value != _BLUEPRINT.score_value) {
      json[JSON_SCORE_VALUE] = score_value;
    }
    return json;
  }

  /**
   * saves this unit complitly to json using the entity toJson method for the basis.
   */
  Map toFullJson() {
    Map json = super.toFullJson();
    json[JSON_FACING] = JSON.encode(_facing);
    json[JSON_ATTACKACTION] = attackAction;
    json[JSON_ATTACKACTIONS] = JSON.encode(attacks);
    json[JSON_AIMODE] = aimode;
    json[JSON_ARROWS] = arrows;
    json[JSON_HEALPOTIONS] = healpotions;
    json[JSON_KILLCOUNT] = killcount;
    json[JSON_SCORE] = score;
    json[JSON_SCORE_VALUE] = score_value;
    return json;
  }

  /**
   * an unit is equal to this unit if it is on the same position - there is always only one unit on one position
   */
  bool operator ==(_Entity e) {
    return (e is Unit) && e?.position != null && e.position == position;
  }
}

/**
 * Objects on the map like flasks and rocks
 * objects do not have an ai and can not do anything on their own.
 */
class ObjectEntity extends _Entity {
  bool _overrideFieldType = false;
  int _fieldType = null;
  bool _passable = false;
  bool pushable = true;

  /**
   * Creates a new object, if possiple from a TYPE otherwise an empty default object.
   */
  factory ObjectEntity(MapField field, String type) {
    ObjectEntity o;
    if (_Entity._TYPES[type] == null) {
      o = new ObjectEntity._private(field, type);
    } else if (_Entity._TYPES[type] is ObjectEntity) {
      o = new ObjectEntity._fromObjectEntity(field, type, _Entity._TYPES[type]);
    } else {
      throw type;
    }
    return o;
  }

  ObjectEntity._private(MapField field, String type)
      : super(field?.map?.game, type) {
    this.field = field;
  }

  ObjectEntity._fromObjectEntity(MapField field, String type, ObjectEntity o)
      : super(field?.map?.game, type) {
    this.field = field;
    this.loadJson(
        JSON.decode(JSON.encode(o, toEncodable: (o) => o.toFullJson())));
  }

  /**
   * creates an object entity from json
   */
  factory ObjectEntity.fromJson(Map json, MapField field) {
    ObjectEntity o = new ObjectEntity._private(field, json[JSON_ENTITYTYPE]);
    o.loadJson(json);
    return o;
  }

  /**
   * moves this object to a positon
   */
  bool moveToPosition(Position p) {
    if (_game.map.moveObject(this, p)) {
      _position = p;
      updateView();
      return true;
    }
    return false;
  }

  bool get overridesFieldType =>
      (_fieldType != null) ? _overrideFieldType : false;
  void set overridesFieldType(bool overrides) {
    _overrideFieldType = overrides;
    updateView();
  }

  FieldType get fieldType =>
      _fieldType == null ? null : new FieldType(_fieldType);

  void changeFieldType(int fieldType) {
    _fieldType = fieldType;
    overridesFieldType = true;
  }

  bool get passable => overridesFieldType ? fieldType.passable : _passable;

  /**
   * after complition of this method the object is definitly dead.
   */
  void die() {
    field.objects.remove(this);
    _HP = 0;
    updateView();
  }

  String toString() => JSON.encode(this, toEncodable: (o) => o.toFullJson());

  ObjectEntity get _BLUEPRINT => (_Entity._TYPES[type] as ObjectEntity);

  /**
   * load the attributes of this object from json using the entity loadJson method for the basis.
   */
  void loadJson(Map json) {
    super.loadJson(json);
    _overrideFieldType = json[JSON_OVERRIDE_FIELDTYPE] ??
        _BLUEPRINT?._overrideFieldType ??
        false;
    _fieldType = json[JSON_FIELDTYPE] ?? _BLUEPRINT?._fieldType;
    _passable = json[JSON_PASSABLE] ?? _BLUEPRINT?._passable ?? false;
    pushable = json[JSON_PUSHABLE] ?? _BLUEPRINT?.pushable ?? false;
  }

  /**
   * saves changes of this object to json using the entity toJson method for the basis.
   * changed means values other than in the TYPE-Default
   */
  Map toJson() {
    Map json = super.toJson();
    //Remove position -> this information is stored hierachicaly
    json.remove(JSON_POSITION);

    if (_overrideFieldType != _BLUEPRINT?._overrideFieldType) {
      json[JSON_OVERRIDE_FIELDTYPE] = _overrideFieldType;
    }
    if (_fieldType != _BLUEPRINT?._fieldType) {
      json[JSON_FIELDTYPE] = _fieldType;
    }
    if (_passable != _BLUEPRINT?._passable) {
      json[JSON_PASSABLE] = _passable;
    }
    if (pushable != _BLUEPRINT?.pushable) {
      json[JSON_PUSHABLE] = pushable;
    }
    return json;
  }

  /**
   * saves this object complitly to json using the entity toJson method for the basis.
   */
  Map toFullJson() {
    Map json = super.toFullJson();
    //Remove position -> this information is stored hierachicaly
    json.remove(JSON_POSITION);

    json[JSON_OVERRIDE_FIELDTYPE] = _overrideFieldType;
    json[JSON_FIELDTYPE] = _fieldType;
    json[JSON_PASSABLE] = _passable;
    json[JSON_PUSHABLE] = pushable;
    return json;
  }
}

/**
 * an attackaction could be a weapon or an attack from an enemy like a brawler
 * it contains multiple attack verctors and damage values.
 * with one attack gets every attackvector the damage that is saved for this vector.
 */
class AttackAction {
  Map<Vector, int> attackVectors = new Map();
  
  AttackAction(Map<Vector, int> attackVectors) {
    this.attackVectors.addAll(attackVectors);
  }

  factory AttackAction.fromJson(Map json) {
    List<Vector> vectors =
        json[JSON_VECTORLIST].map((v) => new Vector.fromJson(v));
    Map<Vector, int> attackVectors = new Map();
    for (Vector v in vectors) {
      attackVectors[v] = json[JSON_ATTACKVECTOR][v.toString()];
    }
    return new AttackAction(attackVectors);
  }

  Map toJson() {
    Map json = new Map();
    json[JSON_VECTORLIST] = attackVectors.keys.toList();
    json[JSON_ATTACKVECTOR] = new Map();
    for (Vector v in attackVectors.keys) {
      json[JSON_ATTACKVECTOR][v.toString()] = attackVectors[v];
    }
    return json;
  }

  String toString() => JSON.encode(this);

  /**
   * attack method calculates the vectors for the facing of the unit and triggers the attackevents on all possible targets.
   */
  void attack(Unit attacker) {
    if (attacker.facing == Vector.FRONT) {
      for (Vector attackVector in attackVectors.keys) {
        attacker.field
            .getNeighbor(attackVector)
            ?.onAttack(new AttackEvent(attacker, attackVectors[attackVector]));
      }
    } else if (attacker.facing == Vector.LEFT) {
      for (Vector attackVector in attackVectors.keys) {
        attacker.field
            .getNeighbor(attackVector.rotateLeft())
            ?.onAttack(new AttackEvent(attacker, attackVectors[attackVector]));
      }
    } else if (attacker.facing == Vector.BACK) {
      for (Vector attackVector in attackVectors.keys) {
        attacker.field
            .getNeighbor(attackVector * -1)
            ?.onAttack(new AttackEvent(attacker, attackVectors[attackVector]));
      }
    } else if (attacker.facing == Vector.RIGHT) {
      for (Vector attackVector in attackVectors.keys) {
        attacker.field
            .getNeighbor(attackVector.rotateRight())
            ?.onAttack(new AttackEvent(attacker, attackVectors[attackVector]));
      }
    }
  }
}

/**
 * class for a planned overhaul of the attack system - currently unused  
 */
class Attack {
  final Vector attackVector;
  final int dmg, type, chanceToHit, piercingTimes;
  final String summonType;
  
  Attack({this.attackVector: Vector.FRONT, this.type: ATTACKTYPE_MEELE, this.chanceToHit: 100, this.dmg: 0, this.piercingTimes: null, this.summonType: null});
  
  factory Attack.fromJson(Map json) {
    switch(json[JSON_ATTACKTYPE]) {
      case ATTACKTYPE_MEELE:
        return new Attack(attackVector: new Vector.fromJson(json[JSON_VECTOR]), type: json[JSON_ATTACKTYPE], chanceToHit: json[JSON_CHANCE_TO_HIT], dmg: json[JSON_DAMAGE]);
      case ATTACKTYPE_RANGE:
        return new Attack(attackVector: new Vector.fromJson(json[JSON_VECTOR]), type: json[JSON_ATTACKTYPE], chanceToHit: json[JSON_CHANCE_TO_HIT], dmg: json[JSON_DAMAGE], piercingTimes: json[JSON_PIERCING_TIMES]);
      case ATTACKTYPE_SUMMON:
        return new Attack(attackVector: new Vector.fromJson(json[JSON_VECTOR]), type: json[JSON_ATTACKTYPE], summonType: json[JSON_ENTITYTYPE]);
      case ATTACKTYPE_EXPLOSION:
        return new Attack(attackVector: new Vector.fromJson(json[JSON_VECTOR]), type: json[JSON_ATTACKTYPE], chanceToHit: json[JSON_CHANCE_TO_HIT], dmg: json[JSON_DAMAGE]);
      default:
        return null;
    }
  }
  
  AttackEvent call(Unit u) {
    switch(type) {
      case ATTACKTYPE_MEELE:
        return new AttackEvent(u, dmg, chanceToHit: chanceToHit, type: type);
      case ATTACKTYPE_RANGE:
        return new AttackEvent(u, dmg, chanceToHit: chanceToHit, type: type);
      case ATTACKTYPE_SUMMON:
        //TODO SUMMON
        return null;
      case ATTACKTYPE_EXPLOSION:
        return new AttackEvent(u, dmg, chanceToHit: chanceToHit, type: type);
      default:
        return null;
    }
  }
  
  bool operator ==(Attack a) => dmg == a.dmg && type == a.type && chanceToHit == a.chanceToHit;
  Map toJson() {
    Map json = new Map();
    json[JSON_DAMAGE] = dmg;
    json[JSON_ATTACKTYPE] = type;
    json[JSON_CHANCE_TO_HIT] = chanceToHit;
    return json;
  }
}
