part of brickcrash;
/**
 * @version 1.0
 * @author Johann Schnitkov, Mihail Usenko
 */
class FrameView extends View {
  DivElement frame;
  DivElement header;
  String title;

  /**
   * Contructor
   */
  FrameView(Player player, String header) : super(player) { this.title = header; }

  /**
   * den ueberschrift der Frame setzen
   */
  void setHeader(String header)  { this.header.text = header; }

  /**
   * den Element erstellen, wo spaeter der ueberschrift gespeichert wird.
   */
  DivElement createHeaderElement() {
    this.header = new DivElement();
    this.header.id = "header";
    this.header.text = this.title;
    return this.header;
  }

  /**
   * zeichnet die View.
   */
  void drawDefault()  {
    this.frame = new DivElement();
    this.frame.id = "informationFrame";
    this.frame.append(this.createHeaderElement());
  }
}