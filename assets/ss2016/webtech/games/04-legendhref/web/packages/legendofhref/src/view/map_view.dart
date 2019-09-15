part of legendofhref;

/**
 * view for the area map
 */
class AreaMapView extends View {
  final int viewRadius;
  
  /**
   * creates an areamap view, with an areamap and an divelement to hook in
   * the viewport has a default radius of 2 fields creating a 5x5 field of view for the pc
   */
  AreaMapView(AreaMap map, DivElement mapArea, {this.viewRadius: 2})
      : super(map, new TableElement()) {
    mapArea.children
      ..clear()
      ..add(dom);
    dom
      ..setAttribute("border", "0")
      ..setAttribute("cellspacing", "0")
      ..setAttribute("cellpadding", "0");
  }
  
  /**
   * the dom element of the map view is an TableElement
   */
  TableElement get dom => super.dom as TableElement;
  
  /**
   * the model of an areamap view has to be an area map
   */
  AreaMap get model => super.model as AreaMap;

  /**
   * updates the viewport of the map
   */
  void update() {
    dom.children.clear();
    TableRowElement row;
    int firstX = -1;
    model.forEachField((MapField f) {
      //saves for which X a new row should be started
      if (firstX == -1) firstX = f.position.x;
      if (f.position.x == firstX) row = dom.addRow();
      row.children.add(f.view.dom);
      f.view.update();
    }, map: model.getSubmapAroundPosition(model.game.pc.position, viewRadius));
  }
}