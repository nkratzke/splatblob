part of legendofhref;

/**
 * basic view component contains an untyped model and a html element
 */
abstract class View {
  final model;
  final Element element;
  
  /**
   * creates the view with an model and an element
   */
  View(this.model, this.element) {
    model.view = this;
  }
  
  /**
   * returns the html element
   */
  Element get dom => element;

  /**
   * abstract update method - should be overwritten by child classes
   */
  void update();

  /**
   * removes this view from the dom tree
   */
  void remove() {
    dom.remove();
  }
}