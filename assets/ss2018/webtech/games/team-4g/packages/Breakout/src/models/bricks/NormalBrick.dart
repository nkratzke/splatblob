part of "../../../breakout.dart";

/**
 * Normal Brick
 */
class NormalBrick extends Brick
{
	NormalBrick({
		position:null,
		length:6,
		thickness:5,
		health:1,
		game:null,
		coordinates:null
	}):super(
		position:position,
		length:length,
		health:health,
		name:"Normal Brick",
		thickness:thickness,
		game:game,
		type:"normal",
		coordinates:coordinates
	);
}