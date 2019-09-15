part of brickcrash;
/**
 * Die LoginView wird am Anfang des Spiels angezeigt(nur Online).
 * Dort werden zwei Textfelder fuer Name und Passwort erzeugt und ein Login-Button
 */
class LoginView extends FrameView {

  InputElement loginInput;
  InputElement passwordInput;
  DivElement errorPlaceHolder;
  FormElement form;

  /**
   * Constructor
   */
  LoginView(Player player, String title) : super(player, title){   }

  /**
   * GETTER
   */
  InputElement getLoginInput()      { return this.loginInput; }
  InputElement getPasswordInput()   { return this.passwordInput; }
  DivElement getErrorPlaceHolder()  { return this.errorPlaceHolder; }
  FormElement getLoginForm()        { return this.form; }

  /**
   * Erstellt ein Login Element, fuer die Eingabe des Names im Loginfenster
   * @return das Login Element
   */
  InputElement createLoginInput() {
    this.loginInput = new InputElement();
    loginInput.id = "loginInput";
    loginInput.placeholder = "Login";
    return this.loginInput;
  }

  /**
   * Erstellt ein PassWort Element, fuer die Eingabe des Passwortes, im Loginfenster
   * @return das Passwort Element
   */
  InputElement createPasswordInput() {
    this.passwordInput = new InputElement();
    passwordInput.type="password";
    passwordInput.id = "passwordInput";
    passwordInput.placeholder = "Password";
    return this.passwordInput;
  }

  /**
   * Erstellt das Fenster und legt einen Button fuer den Login oder das
   * Registrieren an
   * @return Form
   */
  FormElement createForm() {
    this.form = new FormElement();
    this.form.id = "loginForm";

    ButtonElement submit = new ButtonElement();
    submit.type = "submit";
    submit.id="loginButton";
    submit.innerHtml = "Login!";

    this.form  ..append(this.createLoginInput())
          ..append(this.createPasswordInput())
          ..append(submit)
          ..appendHtml("<br><small>Wenn der User nicht existiert, wird er angelegt!</small>");
    return this.form;
  }

  /**
   * Ein Platzhalter fuer Fehler wird erstell, falls Probleme beim Login entstehen
   * @return Error Element
   */
  DivElement createErrorPlaceHolder() {
    this.errorPlaceHolder = new DivElement();
    this.errorPlaceHolder.id = "error";
    return this.errorPlaceHolder;
  }

  /**
   * Zeigt den Fehler im Loginfenster an
   * @param error Fehlerinhalt
   */
  void showError(String error) { this.getErrorPlaceHolder().text = error; }

  /**
   * Loescht das levelfenster
   */
  void clear() {
    super.clear();
    this.levelInformation.style.display = "none";
  }

  /**
   * Erzeugt das Levelfenster
   */
  void drawDefault()  {
    super.drawDefault();
    this.createForm();

    this.frame  ..append(this.createErrorPlaceHolder())
                ..append(this.form);
    this.add(this.frame);
  }
}