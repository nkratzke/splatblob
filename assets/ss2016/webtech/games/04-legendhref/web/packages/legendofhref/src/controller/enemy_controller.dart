part of legendofhref;

class EnemyController {
  /// Unit Object of self.
  Unit _me;

  /// Defines the mode the AI runs in.
  int _mode;

  /// Defines whether the AI is hostile towards the player or not.
  bool hostile = false;

  /// Random generator.
  var _random = new Random();

  /// Distance in Nodes to target location.
  int _distance = 0;

  /// Queue of directions to target. The Queue is used like a Stack.
  Queue directions = new Queue();

  /// Moves to do before re-calculate route.
  int _deltaTime = 0;

  /// Last Position on field.
  Position _lastPos;

  /// Getter for deltaTime.
  int get deltaTime => _deltaTime;

  /// Getter for distance.
  int get distance => _distance;

  /// Getter for AI-Mode.
  int get mode => _mode;

  /// Getter for Monster-Object (itself).
  Unit get me => _me;

  /// Setter for AI-Mode.
  void set mode(int aimode) {
    _mode = aimode;
  }

  /// Lambda for Random Generator.
  int next(int min, int max) => min + _random.nextInt(max - min);

  /// Constructor for Enemy-Controller.
  ///
  /// unit is the Unit this Controller will handle.
  /// modeAI is the mode which decides how the AI behaves.
  /// 0 is passive, 1 is random movement with attack, 2 is Random movement until attacked
  /// 3 is hostile to the player.
  EnemyController(Unit unit, int modeAI) {
    this._lastPos = unit._position;
    this._me = unit;
    this._mode = modeAI;
    if (modeAI == 3) hostile = true;
  }

  /// Method called every turn.
  ///
  /// Signals the Controller that it's his turn and he is allowed
  /// to perform actions.
  void turn() {
    if (_mode == 0) return;
    if (_mode == 3) movementBehaviour(me._game.pc.position);
    else movementBehaviour(getRandomTargetMovement());
  }

  /// Method that determines which action to do on this turn.
  ///
  /// Decides based on mode, deltaTime and distance.
  /// If the deltaTime is <= 0, the Controller will call A*-Algorithm
  /// to calculate a new route to the target position.
  /// If deltaTime is not equal or less 0, then it means that a route has been
  /// calculated in one of the previous turns and it is not efficient to calculate a new route
  /// just yet.
  /// target is the position of the target.
  void movementBehaviour(Position _target) {
    ANode _tempContainer;
    int _choseAction;
    if (mode == 1) {
      if (me._game.map.getUnitOnPosition((me.position + me.facing)) != null) me.attack();
    }
    if (_deltaTime > 0) _choseAction = 2;
    if (_deltaTime <= 0) _choseAction = actionSelector(_target, me);
    else _choseAction = 2;

    // Switch deciding what the action is.
    // -1 means there was no route found and the Unit will idle.
    // 1 means that the target is in a adjacent tile,
    // which means the monster will either attack the player or turn
    // to face to player.
    // 2 means that the target is to far away to be attack so if deltaTime is larger than 0,
    // he will perform the next step stored in the directions-Queue, or if deltaTime is less than or
    // equal 0, calculate a new rout to the specified target.
    switch (_choseAction) {
      case -1:
        print("could not calculate a route. IDLE");
        break;

      case 1:
        if (me._game.pc.position == me.position + me.facing) me.attack();
        else me.move(me.position.getDirectionVector(me._game.pc.position));
        print("Action ATTACK");
        break;


    // To make movement efficient we check before every move certain conditions.
    // The first one is if the distance is greater then 3 and if the route has just been calculated.
    // If so, we set deltaTime to 4 to at least make 4 Actions before re-calculating the route to the target.
    // Then, we see if we have reduced the distance between us and the target below 3. If so, we make sure to calculate the
    // route to target after every turn so we don't run past our target.
    // Next, we have to make sure that we actually have any directions in our Queue, and check right after if the
    // acquired position is the equal to our. If it is, we need to fetch a new direction to go from the Queue.
    // If all check's turned out good, we lastly check if our current position is equal to the last known position of our monster.
    // If they match, we can make our move. If they don't then we can't guarantee anymore that the directions we have
    // are correct and we have to re-calculate the route to the target.
      case 2:
        if ((distance > 3) && (_deltaTime <= 0)) _deltaTime = 4;
        if (distance < 3) _deltaTime = 0;
        if (directions.isNotEmpty) _tempContainer = directions.removeLast();
        if (directions.isNotEmpty && (me.position == _tempContainer._position)) _tempContainer = directions.removeLast();
        if (_tempContainer != null) {
          if (me._position == _lastPos) {
            print("Moving FROM: " + me._position.x.toString() + "|" + me._position.y.toString() + " TO: " + _tempContainer._position.x.toString() + "|" + _tempContainer._position.y.toString());
            me.move(me.position.getDirectionVector(_tempContainer._position));
            _lastPos = _tempContainer._position;
          } else {
            _deltaTime = 0;
            _lastPos = me._position;
          }
        }
        else _deltaTime = 0;
        print("Action MOVE");
        _deltaTime--;
        break;
    }
  }

  /// Tries to targets a random map-tile for a monster to go to.
  ///
  /// Generates a random X and Y value which is then checked if it is a valid tile on the map.
  /// If it is a valid tile, we return the position of the field as the target location.
  /// If the field is not a valid tile on the map, we generate new X and Y values.
  /// This method tries no more then 5 times to find a valid tile. If it does not find
  /// a valid location, the current location is simply returned and the monster will idle for 1 turn.
  Position getRandomTargetMovement() {
    Position _targetDummy;
    int _tries = 0;
    int _x, _y;
    while (_tries != 5) {
      _x = next(me._position.x - 4, me._position.x + 4);
      _y = next(me._position.y - 4, me._position.y + 4);
      // Make sure X and Y are inbounds.
      if ((_x >= 0 && _x < me._game.map.width) && (_y >= 0 && _y < me._game.map.height)) _targetDummy = new Position(_x, _y);
      if (me._game.map.passable(_targetDummy)) {
        if (me.position.getLDistanceTo(_targetDummy) > 1) return _targetDummy;
      }
      _tries++;
    }
    return me.position;
  }

  /// Decides if the monster is going to idle (-1), possible attack (1) or definitely move (2).
  ///
  /// A distance of -1 signals us that A* could not calculate any route to the target.
  /// A distance of 1 means we either attack or turn.
  /// And a distance greater then 1 means we have to definitely move.
  /// target is the position of the target.
  /// me is the monster that is going to execute the action.
  int actionSelector(Position target, Unit me) {
    _deltaTime = 0;
    print("Calling A*");
    AStarSearch pathfinding = new AStarSearch();
    _distance = pathfinding.calculateRoute(target, me.position, me, directions);
    print("Distance: " + _distance.toString());
    if (distance == -1) return -1;
    if (distance == 1) return 1;
    else return 2;
  }
}

class ANode {
  /// The Position of the Node on the Game-Map.
  Position _position;

  /// The movementCost to reach this Node. (G-Value)
  int _movementCost = 0;

  /// The relative distance to the target. (H-Value)
  int _distanceToTarget;

  /// The summed value of the Node. (F-Value)
  int _nodeValue;

  /// The Parent-Node via which one this node is reached.
  ANode _parent;

  /// Getter for the X-Position of the Node.
  int get x => _position.x;

  /// Getter for the Y-Position of the Node.
  int get y => _position.y;

  /// Getter for the movementCost.
  int get movementCost => _movementCost;

  /// Getter for the distanceToTarget.
  int get distanceToTarget => _distanceToTarget;

  /// Getter for the nodeValue.
  int get nodeValue => _nodeValue;

  /// Getter for the Parent-Node.
  ANode get parent => _parent;
}

class AStarSearch {
  /// A List of Lists containing ANode's.
  List<List<ANode>> _overworld;

  /// A List of Nodes that are adjacent to already reached nodes and need to be checked.
  List<ANode> _openList;

  /// A List of Nodes that have already been checked.
  List<ANode> _closedList;

  /// Set true of the route has been found.
  bool _foundRoute;

  /// The distance to the target, if found.
  int _distance = 0;

  /// Method to calculate the route.
  ///
  /// Init's the A* Algorithm and calls it as well.
  /// Returns the distance to the target, if a route has been found, else -1.
  /// target is the position of the target.
  /// start is the position of starting tile.
  /// me is the monster that executes this search.
  /// directions is the Queue which will contain the directions if a route will be found.
  int calculateRoute(Position target, Position start, Unit me, Queue directions) {
    initSearch(target, start, me);
    if (searchForRoute(target, start, me, directions) == 1) return _distance;
    else return -1;
  }

  /// Method to initialize the A*-Algorithm.
  ///
  /// Creates the Lists that contain the ANode's and set's the ANode's to the init values.
  /// The relative distance to the target is going to be calculated, which means it does not
  /// take into account if there are any obstacles that are impassable in between them.
  /// Also it does not calculate the value for ANode's that are impassable, as they will not
  /// be visited anyway.
  /// target is the position of the target.
  /// start is the position starting tile.
  /// me is the monster that executes this search.
  void initSearch(Position target, Position start, Unit me) {
    _overworld = new List<List<ANode>>();
    List<ANode> rowList = new List<ANode>();
    for (int tempY = 0; tempY < me._game.map.height; tempY++) {
      for (int tempX = 0; tempX < me._game.map.width; tempX++) {
        ANode node = new ANode();
        node._position = new Position(tempX, tempY);
        if (me._game.map
            .getMapFieldOnPosition(new Position(tempX, tempY))
            .passable)
          node._distanceToTarget = target.getLDistanceTo(node._position);

        rowList.add(node);
      }
      _overworld.add(rowList);
      rowList = new List<ANode>();
    }
    _openList = new List<ANode>();
    _closedList = new List<ANode>();
  }

  /// Method that executes the A*-Algorithm and calculates a route to the designated target.
  ///
  /// This method checks if the a route has been found now and starts checks as long as there are ANode's
  /// in the openList.
  /// If a route has been found, the directions-Queue will be filled according to the tiles that lead to the target in reverse order
  /// starting from the target Node.
  /// target is the position of the target.
  /// start is the position of the starting-tile.
  /// me is the monster that called the algorithm.
  /// directions is the queue which will contain the directions to the target, if a route has been found.
  int searchForRoute(Position target, Position start, Unit me, Queue directions) {
    ANode currentNode;
    // run A* once manually to catch special cases.
    _openList.add((_overworld.elementAt(start.y).elementAt(start.x)));
    currentNode = _openList.removeLast();
    currentNode._movementCost = 0;
    currentNode._distanceToTarget = target.getXDistanceTo(start) + target.getYDistanceTo(start);
    checkNeighbours(currentNode, me._game.map);
    do {
      if (_foundRoute) {
        int temp = 1;
        print("Route Found!");
        while (currentNode.parent != null) {
          print("Step " + temp.toString() + ": X->" + currentNode.x.toString() + "  Y->" + currentNode.y.toString());
          // Twice because if we have to turn and move, we need to target the same tile twice.
          directions.add(currentNode);
          directions.add(currentNode);
          currentNode = currentNode.parent;
          temp++;
        }
        _distance = temp;
        return 1;
      }
      // Sort the list so the Nodes with the lowest F-Vaule are last.
      _openList.sort((a, b) => (a.nodeValue > b.nodeValue ? -1 : 1));
      if (_openList.isNotEmpty) currentNode = _openList.removeLast();
      checkNeighbours(currentNode, me._game.map);
    } while (!_openList.isEmpty);
    print("No Route Found!");
    return -1;
  }

  /// Method that check's the neighbouring Nodes for not yet traversed Nodes or the target Node.
  ///
  /// The method check's all adjacent Node (Left,Right,Up,Down).
  /// If the current Node is already on the closedList, ignore this node, else add it to the closedList and check its neighbours.
  /// If a neighbour is the target, stop A* and set routeFound to true.
  /// currentNode is the node whom neighbours we check.
  /// map is the whole gameMap.
  int checkNeighbours(ANode currentNode, AreaMap map) {
    ANode tempNode;
    if (_closedList.contains(currentNode)) return -1;
    _closedList.add(currentNode);
    if (currentNode == null) return -1;
    else if (currentNode.distanceToTarget == 1) {
      _foundRoute = true;
      return 0;
    }
    // Checks if a node can be to the left of the currentNode.
    if ((currentNode.x - 1) >= 0) {
      tempNode = _overworld.elementAt(currentNode.y).elementAt(currentNode.x - 1);
      if (_closedList.contains(tempNode));
      // If the distanceToTarget == NULL, then it means that th node is marked as impassible, hence we
      // don't need to check any further.
      else if (tempNode.distanceToTarget == null) {
        _closedList.add((tempNode));
      }
      // else if the node has yet to receive a parent, set us as parent and adjust values according to
      // A*
      else if (tempNode.parent == null) {
        tempNode._parent = currentNode;
        tempNode._movementCost = (currentNode.movementCost + 1);
        tempNode._nodeValue = (tempNode.distanceToTarget + tempNode.movementCost);
        _openList.add(tempNode);
      }
      // If it has a parent, check if going through our Node is a faster route then the previous one.
      else if (tempNode.nodeValue > (currentNode.nodeValue + 1)) {
        tempNode._parent = currentNode;
        tempNode._movementCost = (currentNode.movementCost + 1);
        tempNode._nodeValue = (tempNode.distanceToTarget + tempNode.movementCost);
      }
    }
    // Checks if a node can be below the currentNode.
    if ((currentNode.y + 1) < map.height) {
      tempNode = _overworld.elementAt(currentNode.y + 1).elementAt(currentNode.x);
      if (_closedList.contains(tempNode));
      // If the distanceToTarget == NULL, then it means that th node is marked as impassible, hence we
      // don't need to check any further.
      else if (tempNode._distanceToTarget == null) {
        _closedList.add((tempNode));
      }
      // else if the node has yet to receive a parent, set us as parent and adjust values according to
      // A*
      else if (tempNode.parent == null) {
        tempNode._parent = currentNode;
        tempNode._movementCost = (currentNode.movementCost + 1);
        tempNode._nodeValue = (tempNode.distanceToTarget + tempNode.movementCost);
        _openList.add(tempNode);
      }
      // If it has a parent, check if going through our Node is a faster route then the previous one.
      else if (tempNode.nodeValue > (currentNode.nodeValue + 1)) {
        tempNode._parent = currentNode;
        tempNode._movementCost = (currentNode.movementCost + 1);
        tempNode._nodeValue = (tempNode.distanceToTarget + tempNode.movementCost);
      }
    }
    // Checks if a node can be above the currentNode.
    if ((currentNode.y - 1) >= 0) {
      tempNode = _overworld.elementAt(currentNode.y - 1).elementAt(currentNode.x);
      if (_closedList.contains(tempNode));
      // If the distanceToTarget == NULL, then it means that th node is marked as impassible, hence we
      // don't need to check any further.
      else if (tempNode._distanceToTarget == null) {
        _closedList.add((tempNode));
      }
      // else if the node has yet to receive a parent, set us as parent and adjust values according to
      // A*
      else if (tempNode.parent == null) {
        tempNode._parent = currentNode;
        tempNode._movementCost = (currentNode.movementCost + 1);
        tempNode._nodeValue = (tempNode.distanceToTarget + tempNode.movementCost);
        _openList.add(tempNode);
      }
      // If it has a parent, check if going through our Node is a faster route then the previous one.
      else if (tempNode.nodeValue > (currentNode.nodeValue + 1)) {
        tempNode._parent = currentNode;
        tempNode._movementCost = (currentNode.movementCost + 1);
        tempNode._nodeValue = (tempNode.distanceToTarget + tempNode.movementCost);
      }
    }
    // Checks if a node can be to the right of the currentNode.
    if ((currentNode.x + 1) < map.width) {
      tempNode = _overworld.elementAt(currentNode.y).elementAt(currentNode.x + 1);
      if (_closedList.contains(tempNode));
      // If the distanceToTarget == NULL, then it means that th node is marked as impassible, hence we
      // don't need to check any further.
      else if (tempNode._distanceToTarget == null) {
        _closedList.add((tempNode));
      }
      // else if the node has yet to receive a parent, set us as parent and adjust values according to
      // A*
      else if (tempNode.parent == null) {
        tempNode._parent = currentNode;
        tempNode._movementCost = (currentNode.movementCost + 1);
        tempNode._nodeValue = (tempNode.distanceToTarget + tempNode.movementCost);
        _openList.add(tempNode);
      }
      // If it has a parent, check if going through our Node is a faster route then the previous one.
      else if (tempNode.nodeValue > (currentNode.nodeValue + 1)) {
        tempNode._parent = currentNode;
        tempNode._movementCost = (currentNode.movementCost + 1);
        tempNode._nodeValue = (tempNode.distanceToTarget + tempNode.movementCost);
      }
    }
    return 0;
  }
}