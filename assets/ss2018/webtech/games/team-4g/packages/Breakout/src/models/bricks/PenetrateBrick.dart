part of "../../../breakout.dart";

class PenetrateBrick extends Brick
{
	/**
	 * Duration of penetration
	 */
	int duration = 15;

	PenetrateBrick({
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
		name:"Penetrate Brick",
		thickness:thickness,
		game:game,
		type:"penetrate",
		coordinates:coordinates
	);

	/**
	 * Destruction event
	 */
	void onDestruct({ball:null})
	{
		ball.canPenetrate = true;
		ball.invertSlopeY();

		this.game.addTimer("penetrate", new Timer(new Duration(seconds:this.duration), () {
			ball.canPenetrate = false;
		}));
	}
}