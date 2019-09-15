part of legendofhref;

/**
 * Attack event
 */
class AttackEvent {
  final Unit unit;
  final int damage;
  final int type;
  final int chanceToHit;
  AttackEvent(this.unit, this.damage, {int type: ATTACKTYPE_MEELE, int chanceToHit: 100}) : type = type, chanceToHit = chanceToHit;
}

/**
 * Area of attention update event - unused
 */
class AOAUpdateEvent {
  final _Entity entity;
  final MapField fieldSrc;
  final MapField fieldDst;
  AOAUpdateEvent(this.entity, this.fieldSrc, this.fieldDst);
}

/**
 * Push event
 */
class EntityPushEvent {
  final Unit unit;
  final Vector direction;
  EntityPushEvent(this.unit, this.direction);
}

/**
 * Eventlistener for Entities
 */
class EntityEventListener {
  static Random R = new Random();
  final _Entity entity;
  
  /**
   * saves the entity and registers this listener
   */
  EntityEventListener(this.entity) {
    entity.addEntityEventListener(this);
  }

  /**
   * simple percent check
   * chance should be between 1 and 99 otherwise it is not really a chance...
   */
  static bool checkChance(int chance) {
    if(chance < 1) return false;
    if(chance > 99) return true;
    int roll = R.nextInt(100);
    print("$chance > $roll = ${chance > roll}");
    return chance > roll;
  }

  /**
   * onAttack event handling.
   * Processes drop chances, killcounter, score and everything else.
   */
  void onAttack(AttackEvent e) {
    entity.showHit(e.unit);
    if (entity._maxHP != 0 && checkChance(e.chanceToHit) && !(entity.immune[e.type]??false)) {
      entity._HP -= e.damage;
      if (entity._HP <= 0) {
        entity.onDeath();
        print(entity.type);
        if(entity.type == "flying_flask") {
          e.unit.ignoresPassability = true;
          print(entity._game._turnNumber);
          entity._game.registerTurnCallback(() {
            print(e.unit._game._turnNumber);
            e.unit.ignoresPassability = false;
          }, entity._game._turnNumber+30);
        }
        if(e.unit == entity) {
          e.unit.score -= e.unit.score_value;
        } else {
          e.unit.killcount += (entity is Unit)?(entity as Unit).score_value>0?1:0:0;
          e.unit.score += (entity is Unit)?(entity as Unit).score_value:0;
          e.unit.arrows += checkChance(entity.arrow_dropchance)?(R.nextInt(5)+1):0;
          e.unit.healpotions += checkChance(entity.healpotion_dropchance)?1:0;
          print(e.unit.toFullJson());
        }
      }
    }
    entity.updateView();
  }

  /**
   * Processes pushing of this entity
   */
  bool onPush(EntityPushEvent e) {
    if (entity.pushable) {
      return entity.move(e.direction);
    }
    return false;
  }

  /**
   * processes death of this entity
   */
  void onDeath() {
    entity.die();
  }

  /**
   * this should handle changes in the area of attention - functionality is not included due to lack of time
   * maybe implemented in later version
   */
  void onAreaOfAttentionUpdate(AOAUpdateEvent e) {
    //TODO
  }
}

/**
 * listener for units to process turns and attacks
 */
class UnitEventListener extends EntityEventListener {
  EnemyController ai;
  
  UnitEventListener(Unit u) : super(u) {
    ai = new EnemyController(u, u.aimode);
  }
  
  Unit get unit => entity as Unit;
  
  void onAttack(AttackEvent e) {
    if(unit.aimode == AI_NEUTRAL && e.unit == unit._game.pc) {
      unit._aimode = AI_HOSTILE;
      ai.mode = unit.aimode;
    }
    super.onAttack(e);
  }

  /**
   * processes ai turn
   */
  void turn() {
    ai.turn();
  }
}

/**
 * special unit event listner to process gameover and disable ai for pc
 */
class PCEventListener extends UnitEventListener {
  PCEventListener(Unit pc) : super(pc) {
    
  }
  
  void onAttack(AttackEvent e) {
    super.onAttack(e);
    if(!unit.alive) {
      unit._game.pauseGame();
      unit._game.gameover();
    }
  }
  
  /**
   * does not process ai turn (this is effectively a "NOP")
   */
  void turn() {}
}