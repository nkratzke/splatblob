library runner;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

part 'src/Game.dart';
part 'src/Level.dart';
part 'src/Model.dart';
part 'src/Rect.dart';
part 'src/Player.dart';
part 'src/View.dart';
part 'src/HighscoreGamekey.dart';

part 'src/blocks/Block.dart';
part 'src/blocks/Ground.dart';
part 'src/blocks/Water.dart';
part 'src/blocks/Trigger.dart';
part 'src/blocks/Bullet.dart';
part 'src/blocks/Finish.dart';
part 'src/blocks/Spawn.dart';
part 'src/blocks/Coin.dart';
part 'src/blocks/Teleport.dart';
part 'src/blocks/Wall.dart';
part 'src/blocks/Cobble.dart';
part 'src/blocks/SpikesTop.dart';
part 'src/blocks/SpikesBottom.dart';
part 'src/blocks/SpeedBlock.dart';
part 'src/blocks/TeleportSpeed.dart';
part 'src/blocks/Message.dart';
part 'src/blocks/Booster.dart';
part 'src/blocks/Triggerable.dart';

log(String msg) {
  if (false) {
    print('debug: $msg');
  }
}
