part of legendofhref;

///Zeit zwischen zwei gamekey checks: 30sec
const Duration gamekeyCheck = const Duration(seconds: 30);

const String settingsURI = 'settings.json';
const String unitsURI = 'units.json';
const String objectsURI = 'objects.json';
const String fieldtypesURI = 'fieldtypes.json';
///15px
const int MOTION_TOLERANCE = 15;

//All JSON_ constants are for easier use in code and smaller use of space in map files
///p
const String JSON_POSITION = "p";
///fa
const String JSON_FACING = "fa";
///fs
const String JSON_FIELDLIST = "fs";
///ft
const String JSON_FIELDTYPE = "ft";
///olft
const String JSON_OVERLAYFIELDTYPE = "olft";
///oft
const String JSON_OVERRIDE_FIELDTYPE = "oft";
///w
const String JSON_MAPWIDTH = "w";
///h
const String JSON_MAPHEIGHT = "h";
///us
const String JSON_UNITLIST = "us";
///os
const String JSON_OBJECTLIST = "os";
///t
const String JSON_ENTITYTYPE = "t";
///pa
const String JSON_PASSABLE = "pa";
///ipa
const String JSON_IGNORE_PASSABLE = "ipa";
///pu
const String JSON_PUSHABLE = "pu";
///mhp
const String JSON_MAXHP = "mhp";
///hp
const String JSON_HP = "hp";
///id
const String JSON_ID = "id";
///aa
const String JSON_ATTACKACTION = "aa";
///as
const String JSON_ATTACKACTIONS = "as";
///av
const String JSON_ATTACKVECTOR = "av";
///name
const String JSON_FIELDTYPENAME = "name";
///vs
const String JSON_VECTORLIST = "vs";
///overlay
const String JSON_OVERLAY = "overlay";
///multipart
const String JSON_MULTIPART = "multipart";
///ai
const String JSON_AIMODE = "ai";
///nextMap
const String JSON_NEXTMAP = "nextMap";
///kc
const String JSON_KILLCOUNT = "kc";
///sc
const String JSON_SCORE = "sc";
///scv
const String JSON_SCORE_VALUE = "scv";
///hlp
const String JSON_HEALPOTIONS = "hlp";
///hlpdc
const String JSON_HEALPOTIONS_DROPCHANCE = "hlpdc";
///ar
const String JSON_ARROWS = "ar";
///ardc
const String JSON_ARROW_DROPCHANCE = "ardc";
///im
const String JSON_IMMUNE = "im";
///cth
const String JSON_CHANCE_TO_HIT = "cth";
///dmg
const String JSON_DAMAGE = "dmg";
///v
const String JSON_VECTOR = "v";
///at
const String JSON_ATTACKTYPE = "at";
///at
const String JSON_PIERCING_TIMES = "pt";
 

///PASSIVE AI (int: 0)
///does not move nor attack even if provoked
const int AI_PASSIVE = 0; 
///RANDOM  AI (int: 1)
///does move randomly over the map, may attack on direct contact, will not chase even if provoked
const int AI_RANDOM  = 1; 
///NEUTRAL AI (int: 2)
///may move randomly over the map, will not attack, may turn to HOSTILE if provoked
const int AI_NEUTRAL = 2; 
///HOSTILE AI (int: 3)
///does move to the PC using pathfinding with A* and will attack even unprovoked 
const int AI_HOSTILE = 3; 

final ImageElement hitmarker = new ImageElement(src: "./imgs/attack.gif");

const int ACTION_MOVE = 0;
const int ACTION_SWITCH_ATTACK = 1;
const int ACTION_ATTACK = 2;
const int ACTION_USE = 3;

const int ATTACKTYPE_MEELE = 0;
const int ATTACKTYPE_RANGE = 1;
const int ATTACKTYPE_SUMMON = 2;
const int ATTACKTYPE_EXPLOSION = 3;
