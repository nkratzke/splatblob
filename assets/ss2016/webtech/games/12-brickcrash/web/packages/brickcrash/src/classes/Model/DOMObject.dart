part of brickcrash;
/*
  DOMObject ist die allgemeine Klasse fuer alle Objekte, die das Spiel nutzt.
  Diese beinhaltet alle Methoden, die sowohl fuer bewegbare als auch
  fuer statische Objekte gelten. z.B Koordinaten und Groessen.

   Durch die Methoden, die diese Klasse anbietet, kann man schnell die Koorninaten
   von allen Grenzen des Objektes berechnen.

   @version 1.0
   @author Mihail Usenko, Johann Schnitkov
 */

abstract class DOMObject {
  int width         = 0;
  int height        = 0;
  int x             = 0;
  int y             = 0;

  /**
   * SETTER
   */
  void setWidth(int width)      { this.width  = width; }
  void setHeight(int height)    { this.height = height; }
  void setXPosition(int x)      { this.x      = x; }
  void setYPosition(int y)      { this.y      = y; }

  /**
   * GETTER
   */
  int getWidth()                { return this.width; }
  int getHeight()               { return this.height; }
  int getXPosition()            { return this.x; }
  int getYPosition()            { return this.y; }

  /**
   * die X-Koordinate der rechten Grenze des Objektes
   */
  int getRight()                { return this.getLeft() + this.getWidth(); }

  /**
   * die X-Koordinate der linken Grenze des Objektes
   */
  int getLeft()                 { return this.getXPosition(); }

  /**
   * die Y-Koordinate der oberen Grenze des Objektes
   */
  int getTop()                  { return this.getYPosition(); }

  /**
   * die Y-Koordinate der unteren Grenze des Objektes
   */
  int getBottom()               { return this.getTop() + this.getHeight(); }

  /**
   * die Haelfte der Breite
   */
  int getXMiddle()              { return (this.getWidth()/2).round();}

  /**
   * die Haelfte der Hoehe
   */
  int getYMiddle()              { return (this.getHeight()/2).round();}

  /**
   * Die Mitte des Objektes in der X-Koordinate
   */
  int getXMiddlePosition()      { return this.getXPosition() + this.getXMiddle(); }

  /**
   * Die Mitte des Objektes in der Y-Koordinate
   */
  int getYMiddlePosition()      { return this.getYPosition() + this.getYMiddle(); }
}