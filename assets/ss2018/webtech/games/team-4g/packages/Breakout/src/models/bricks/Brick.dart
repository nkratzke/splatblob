part of "../../../breakout.dart";

/**
 * Brick class
 */
abstract class Brick extends Item
{
	/**
	 * Brick HP
	 */
	int health;

	/**
	 * Brick type
	 */
	String type;

	/**
	 * Trigger special effect
	 */
	bool triggerEffect = true;

	/**
	 * Brick internal coordinates
	 */
	XYPoint<int> coordinates;

	/**
	 * Constructor
	 */
	Brick({
		position:null,
		length:6,
		health:1,
		type:"brick",
		name:"Brick",
		thickness:5,
		game:null,
		coordinates:null
	}):super(
		position:position,
		length:length,
		name:name,
		thickness:thickness,
		game:game
	)
	{
		this.health = health;
		this.type = type;
		this.coordinates = coordinates;
	}

	factory Brick.special(String type, {
		position:null,
		length:6,
		color:"green",
		randomColor:false,
		thickness:5,
		game:null,
		coordinates:null
	})
	{
		switch (type)
		{
			case "heavy":

				return new HeavyBrick(
					position:position,
					length:length,
					thickness:thickness,
					game:game,
					coordinates:coordinates
				);

			case "speed":

				return new SpeedBrick(
					position:position,
					length:length,
					thickness:thickness,
					game:game,
					coordinates:coordinates
				);

			case "slow":

				return new SlowBrick(
					position:position,
					length:length,
					thickness:thickness,
					game:game,
					coordinates:coordinates
				);

			case "explosion":

				return new ExplosionBrick(
					position:position,
					length:length,
					thickness:thickness,
					game:game,
					coordinates:coordinates
				);

			case "teleport":

				return new TeleportBrick(
					position:position,
					length:length,
					thickness:thickness,
					game:game,
					coordinates:coordinates
				);

			case "penetrate":

				return new PenetrateBrick(
					position:position,
					length:length,
					thickness:thickness,
					game:game,
					coordinates:coordinates
				);

			case "split":

				return new SplitBrick(
					position:position,
					length:length,
					thickness:thickness,
					game:game,
					coordinates:coordinates
				);

			case "invert":

				return new InvertBrick(
					position:position,
					length:length,
					thickness:thickness,
					game:game,
					coordinates:coordinates
				);

			default:

			 	break;
		}
	}

	/**
	 * Hit event for Brick
	 */
	void onHit()
	{
		this.health -= 1;
	}
}