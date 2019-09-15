part of runner;

class Level {

  /// Level Speed
  int speed;

  /// List of static elements in level, grounds etc.
  List<Block> blockList_static;

  /// List of dynamic elements that may change positions, bullets etc.
  List<Block> blockList_dynamic;

  /// Level entry point
  Spawn spawn;

  /// filename of the following level
  String nextLevel;

  /// Creates new Level
  ///
  /// Creates a new Level from a String containing a JSON Formatted Level
  Level(String jsonString) {
    List<Block> blockList_static = new List<Block>();
    List<Block> blockList_dynamic = new List<Block>();

    try {
      // decode json
      Map jsonData = JSON.decode(jsonString);

      speed = jsonData["speed"] ?? 5;
      var levelSpawn = jsonData["spawn"];
      spawn = new Spawn(
          0,
          levelSpawn["pos_x"],
          levelSpawn["pos_y"],
          levelSpawn["size_x"],
          levelSpawn["size_y"]
      );
      nextLevel = jsonData["nextLevel"];

      var blocks = jsonData["blocks"];
      if (blocks != null) {
        for (Map m in jsonData["blocks"]) {

          if (m["pos_x"] == null || m["pos_y"] == null || m["size_x"] == null || m["size_y"] == null) {
            print('${m["id"]} is invalid');
            continue;
          }

          switch (m["type"]) {

            //
            // Ground-like elements
            //
            case "Ground":
                Block block = new Ground(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(block);
              break;

            case "Wall":
              Block block = new Wall(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(block);
              break;

            case "Cobble":
              Block block = new Cobble(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(block);
              break;

            //
            // Finish
            //

            case "Finish":
              Block block = new Finish(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(block);
              break;

            //
            // Valuables
            //

            case "Coin":
              Block block = new Coin(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  m["value"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_dynamic.add(block);
              break;


            //
            // obstacles
            //

            case "Water":
              Block block = new Water(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(block);
              break;

            case "SpikesTop":
              Block block = new SpikesTop(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(block);
              break;

            case "SpikesBottom":
              Block block = new SpikesBottom(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(block);
              break;

            //
            // Teleporters
            //

            case "Teleport":
              var b = m["target"];

              Block target = new Spawn(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  b["pos_x"],
                  b["pos_y"],
                  b["size_x"],
                  b["size_y"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(target);

              Block block = new Teleport(blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  target,
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(block);
              break;

            case "TeleportSpeed":
              var b = m["target"];

              Block target = new Spawn(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  b["pos_x"],
                  b["pos_y"],
                  b["size_x"],
                  b["size_y"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(target);

              Block block = new TeleportSpeed(blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  target,
                  m["speedIncrease"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              blockList_static.add(block);
              break;

            //
            // Trigger && Triggerables
            //

            case "Trigger":
              var triggerables = m["triggerables"];

              List<Triggerable> triggerableList = new List<Triggerable>();

              for (Map b in triggerables) {
                switch(b["type"]) {
                  case "Bullet":
                    Block triggerable = new Bullet(
                        blockList_static.length + (blockList_dynamic.length ?? 0),
                        b["pos_x"],
                        b["pos_y"],
                        b["size_x"],
                        b["size_y"],
                        b["isDeadly"],
                        b["canCollide"],
                        b['isVisible']
                    );
                    log(triggerable.toString());
                    triggerableList.add(triggerable);
                    blockList_dynamic.add(triggerable);
                    break;

                  case "Booster":
                    Block triggerable = new Booster(
                        blockList_static.length + (blockList_dynamic.length ?? 0),
                        b["pos_x"],
                        b["pos_y"],
                        b["size_x"],
                        b["size_y"],
                        b["boost"],
                        b["isDeadly"],
                        b["canCollide"],
                        b['isVisible']
                    );
                    log(triggerable.toString());
                    triggerableList.add(triggerable);
                    blockList_static.add(triggerable);
                    break;

                  case "SpeedBlock":
                    Block triggerable = new SpeedBlock(
                        blockList_static.length + (blockList_dynamic.length ?? 0),
                        b["pos_x"],
                        b["pos_y"],
                        b["size_x"],
                        b["size_y"],
                        b["speedIncrease"],
                        b["isDeadly"],
                        b["canCollide"],
                        b['isVisible']
                    );
                    log(triggerable.toString());
                    triggerableList.add(triggerable);
                    blockList_static.add(triggerable);
                    break;

                }


              }


              Block block = new Trigger(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  triggerableList,
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              log(block.toString());
              blockList_static.add(block);
              break;

            //
            // misc
            //
            case "Message":
              Block block = new Message(
                  blockList_static.length + (blockList_dynamic.length ?? 0),
                  m["pos_x"],
                  m["pos_y"],
                  m["size_x"],
                  m["size_y"],
                  m["message"],
                  m["isDeadly"],
                  m["canCollide"],
                  m['isVisible']
              );
              log(block.toString());
              blockList_static.add(block);
              break;


          }
        }
      }

      // sort this to "accept" bad ordering in levels
      blockList_static.sort((a, b) => a.pos_x.compareTo(b.pos_x));
      blockList_dynamic.sort((a, b) => a.pos_x.compareTo(b.pos_x));
      this.blockList_static = new List<Block>.from(blockList_static, growable: false);
      this.blockList_dynamic = new List<Block>.from(blockList_dynamic, growable: false);
      blockList_dynamic = null;
      blockList_static = null;
    } catch (e, ex) {
      print(e);
      print(ex);
    }

  }

}