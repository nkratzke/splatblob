part of runner;

class Player extends Rect {

  /// Gravity by which falling is accelerated
  static const double gravity = 0.8;

  /// maximum falling velocity, basically terminal velocity
  double maxVelocity = 8.0;

  /// Speed to begin jumping on
  static const int jumpSpeed = 5;

  /// distance from left game border
  static const int player_offset = 100;

  /// Current Player velocity
  double velocity_y;

  /// Player is jumping
  bool jumping;

  /// Player is double jumping
  bool doubleJump;

  /// Player is on the ground
  bool grounded;

  /// Player can boost/jump forever
  bool booster;


  /// Initialize Player instance
  Player() {
    pos_y = 50;
    pos_x = player_offset; // move slightly to the right

    size_x = 20;
    size_y = 50;

    velocity_y = -1.0;

    jumping = true;
    doubleJump = false;
    grounded = false;
    booster = false;
  }

  /// Process jump request
  ///
  /// Either jumps, doublejumps, boosts or does absolutely nothing, based on states
  void jump() {
    if (booster) {
      log("Player: jump() boost");
      velocity_y = jumpSpeed * 2.0;
      grounded = false;
      jumping = true;
      doubleJump = true;
    } else {
      log("Player: jump()");
      if (jumping && !doubleJump) {
        log("Player: jump() Double Jump");
        doubleJump = true;
        velocity_y = jumpSpeed * 2.0;
      }
      if (!jumping && grounded) {
        log("Player: jump() Jumping");
        jumping = true;
        grounded = false;
        velocity_y = jumpSpeed * 2.0;
      }
    }
  }

  /// Enables Boosting for Player
  void enableBoosting() {
    booster = true;
  }

  /// Disables Boosting for Player
  void disableBoosting() {
    booster = false;
  }

  /// Set Player to fall
  ///
  /// Player is falling when leaving the ground, either when jumping or simply falling of the floor
  void fall() {
    grounded = false;
  }


  /// Player "hit his head"
  ///
  /// Sets player to fall as he just hit something with his head
  void hitRoof() {
    jumping = true;
    doubleJump = true;
    velocity_y = -1.0;
  }

  /// Update Player vertical position
  ///
  /// Updates the Players vertical position based on velocity and state
  void update() {
    if (!grounded) {
      pos_y = (pos_y + velocity_y).round();
      velocity_y -= gravity;
      if (velocity_y < -maxVelocity) { // don't accelerate to stupid falling speeds
        velocity_y = -maxVelocity;
      }
    }
    log("Player: update() ${pos_x} ${pos_y}");
  }

  /// Set Player to grounded
  ///
  /// Resets jumping state as the player landed and can jump again
  void landed() {
    velocity_y = 0.0;
    grounded = true;
    jumping = false;
    doubleJump = false;
  }

  /// Reset player Position to somewhat sane default and reset the states
  void reset() {
    pos_y = 50;
    pos_x = 50;
    booster = false;
    landed();
  }
}