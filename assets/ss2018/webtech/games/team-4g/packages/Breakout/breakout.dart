library breakout;

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:convert';

// Helpers
part "src/helpers/helpers.dart";
part "src/helpers/Matrix.dart";
part "src/helpers/XYPoint.dart";
part "src/helpers/XYArea.dart";

// Controller/View
part "src/Controller.dart";
part "src/View.dart";

// Models
part "src/models/Game.dart";
part "src/models/Item.dart";
part "src/models/Ball.dart";
part "src/models/Platform.dart";

// Loops
part "src/models/loops/Loop.dart";
part "src/models/loops/BallLoop.dart";
part "src/models/loops/PlatformLoop.dart";

// Bricks
part "src/models/bricks/Brick.dart";
part "src/models/bricks/NormalBrick.dart";
part "src/models/bricks/HeavyBrick.dart";
part "src/models/bricks/SpeedBrick.dart";
part "src/models/bricks/SlowBrick.dart";
part "src/models/bricks/ExplosionBrick.dart";
part "src/models/bricks/TeleportBrick.dart";
part "src/models/bricks/PenetrateBrick.dart";
part "src/models/bricks/SplitBrick.dart";
part "src/models/bricks/InvertBrick.dart";

/**
 * Breakout - by Florian S. and Ruben S.
 */

// BASE CONFIGURATION
const String _platform_control = "user";	// Sets Platform control. Options: user, motion, touch
const bool _testlevel = false;				// Enables or disables test level
const bool _ballLoop = true;				// Enables or disables ball movement
const bool _platformloop = true;			// Enables or disables platform motion movement
const bool _modeldebug = false;				// Enables or disables debug prints for models
const bool _skiplevelbutton = false;		// Enables or disables skip level button in menu

const int _PLATFORM_HEIGHT = 30;			// Platform height