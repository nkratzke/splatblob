part of "../../../breakout.dart";

/**
 * Heavy Brick
 */
class HeavyBrick extends Brick
{
	HeavyBrick({
		position:null,
		length:6,
		thickness:5,
		health:3,
		game:null,
		coordinates:null
	}):super(
		position:position,
		length:length,
		health:health,
		name:"Heavy Brick",
		thickness:thickness,
		game:game,
		type:"heavy",
		coordinates:coordinates
	);

	/**
	 * Hit event
	 */
	void onHit()
	{
		super.onHit();
		if (this.health != 0)
			this.game.updateFunction(this);
	}
}