part of legendofhref;

/**
 * entity view basic view for entities
 */
class EntityView extends View {
  SpanElement _healthbar;

  EntityView(_Entity entity) : super(entity, new SpanElement()) {
    if (entity._maxHP > 0) {
      _healthbar = new SpanElement();
      _healthbar.classes.add("healthbar");
      dom.children.add(_healthbar);
      _updateHealth();
    }
  }

  _Entity get model => super.model as _Entity;

  /**
   * updates the position and health of this entity on the view
   */
  void update() {
    if(model.alive) {
      if (_healthbar != null) {
        _updateHealth();
      }
      model.field?.update();
    } else {
      remove();
    }
  }

  void _updateHealth() {
    _healthbar.style.width = "${model.healthPercentage}%";
  }
  
  void showHit(Unit attacker) {
    hitmarker.remove();
    dom.children.add(hitmarker);
  }
}

/**
 * view for units which handles facings
 */
class UnitView extends EntityView {
  
  bool ignoresPassability;
  UnitView(Unit u) : super(u) {
    dom.classes.add("unit_layer");
    dom.style.background =
        "url(\"./imgs/units/${u.type}_${u.getFacingAsString()}.png\")";
  }

  Unit get model => super.model as Unit;

  void update() {
    dom.style.background =
        "url(\"./imgs/units/${model.type}_${model.getFacingAsString()}.png\")";
    if(ignoresPassability != model.ignoresPassability) {
      ignoresPassability = model.ignoresPassability;
      if(ignoresPassability) {
        dom.classes.remove("unit_layer");
        dom.classes.add("flying_unit_layer");
      } else {
        dom.classes.remove("flying_unit_layer");
        dom.classes.add("unit_layer");
      }
    }
    super.update();
  }
}

/**
 * object entity view handles object layer
 */
class ObjectEntityView extends EntityView {
  ObjectEntityView(ObjectEntity o) : super(o) {
    dom.style.background = "url(\"./imgs/objects/${o.type}.png\")";
    if (o.passable) {
      dom.classes.add("loot_layer");
    } else {
      dom.classes.add("obstacles_layer");
    }
  }
}

/**
 * pc view handles external health meter
 */
class PCView extends UnitView {
  PCView(Unit pc, SpanElement pc_health) : super(pc) {
    if (pc._maxHP > 0) {
      _healthbar.remove();
      _healthbar = pc_health;
      _updateHealth();
    }
  }
  
  void update() {
    super.update();
    (querySelector("#use_action") as InputElement).value = model.healpotions.toString();
  }
  
  void _updateHealth() {
    _healthbar.style.height = "${(model.healthPercentage)}%";
    _healthbar.style.paddingTop = "${(100-model.healthPercentage)}%";
    _healthbar.innerHtml = "${(model.healthPercentage)}%";
  }
  
  void remove() {
    super.remove();
    _updateHealth();
  }
}
