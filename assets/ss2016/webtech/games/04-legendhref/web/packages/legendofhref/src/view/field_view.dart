part of legendofhref;

/**
 * view for the mapfields
 */
class MapFieldView extends View {
  static const int N = 1,
      E = 2,
      S = 4,
      W = 8,
      NE = N + E,
      NS = N + S,
      NW = N + W,
      SE = S + E,
      SW = S + W,
      EW = W + E,
      NSE = NE + S,
      NSW = NW + S,
      NEW = NE + W,
      SEW = SE + W,
      NSEW = NS + EW;

  SpanElement overlay;
  
  MapFieldView(MapField field) : super(field, new TableCellElement()) {
    dom.id = model.position.toString();
    overlay = new SpanElement();
    dom.children.add(overlay);
    overlay.classes.add("path_layer");
  }

  MapField get model => super.model as MapField;

  /**
   * updates the view of this field
   */
  update() {
    dom.style.background =
        "url(\"./imgs/fields/${model.fieldType.name}.png\")";
    if (model.overlayFieldType != null) {
      overlay.style.background =
          "url(\"./imgs/fields/${model._overlayType.name}_${model.overlayFieldType.multipart[suffix()]['suffix']}.png\")";
      overlay.classes
        ..removeWhere((s) => s.startsWith("rotate"))
        ..add("rotate${getRotation()}");
      overlay.style.display = "";
    } else {
      overlay.style.display = "none";
    }
    if (model.unit != null) {
      dom.children.add(model.unit.view.dom);
    }
    if (model.hasObjectWithView) {
      dom.children.add(model.firstObjectWithView.view.dom);
    }
  }

  /**
   * check if the the neighbor has the same overlay field type
   */
  bool neighbor(Vector direction) =>
      model.getNeighbor(direction)?.overlayFieldType ==
      model.overlayFieldType;
  
  String part(String s) => model.overlayFieldType.multipart.containsKey(s)
      ? model.overlayFieldType.multipart[s]["suffix"] != null ? s : null
      : null;

  /**
   * get suffix for this field
   */
  String suffix() {
    int type = 0;
    if (neighbor(Vector.NORTH)) type += N;
    if (neighbor(Vector.EAST)) type += E;
    if (neighbor(Vector.SOUTH)) type += S;
    if (neighbor(Vector.WEST)) type += W;
    switch (type) {
      case N:
        return part("e0") ?? part("e") ?? part("|") ?? part("-");
      case E:
        return part("e1") ?? part("e") ?? part("-") ?? part("|");
      case S:
        return part("e2") ?? part("e") ?? part("|") ?? part("-");
      case W:
        return part("e3") ?? part("e") ?? part("-") ?? part("|");
      case NE:
        return part("c0") ?? part("c");
      case NS:
        return part("|") ?? part("-");
      case NW:
        return part("c3") ?? part("c");
      case SE:
        return part("c1") ?? part("c");
      case EW:
        return part("-") ?? part("|");
      case SW:
        return part("c2") ?? part("c");
      case NSE:
        return part("t0") ?? part("t");
      case NSW:
        return part("t2") ?? part("t");
      case NEW:
        return part("t3") ?? part("t");
      case SEW:
        return part("t1") ?? part("t");
      case NSEW:
        return part("x");
      default:
        return "";
    }
  }

  int getRotationForPart(String s) =>
      model.overlayFieldType.multipart.containsKey(s)
          ? model.overlayFieldType.multipart[s]["rotation"] ?? 0
          : 0;

  /**
   * get rotation for this field
   */
  int getRotation() {
    String s = suffix();
    if (s.length != 1) {
      return getRotationForPart(s);
    } else if (s == "x") {
      return 0;
    } else {
      int type = 0;
      if (neighbor(Vector.NORTH)) type += N;
      if (neighbor(Vector.EAST)) type += E;
      if (neighbor(Vector.SOUTH)) type += S;
      if (neighbor(Vector.WEST)) type += W;
      switch (type) {
        case N:
          return s == "-" ? 90 : getRotationForPart(s);
        case E:
          return s == "e" ? 90 : s == "|" ? 90 : getRotationForPart(s);
        case S:
          return s == "e" ? 180 : s == "-" ? 90 : getRotationForPart(s);
        case W:
          return s == "e" ? 270 : s == "-" ? 90 : getRotationForPart(s);
        case NS:
          return s == "-" ? 90 : getRotationForPart(s);
        case EW:
          return s == "|" ? 90 : getRotationForPart(s);
        case NW:
        case NEW:
          return 270;
        case SE:
        case SEW:
          return 90;
        case SW:
        case NSW:
          return 180;
        case NE:
        case NSE:
        case NSEW:
        default:
          return getRotationForPart(s);
      }
    }
  }
}
