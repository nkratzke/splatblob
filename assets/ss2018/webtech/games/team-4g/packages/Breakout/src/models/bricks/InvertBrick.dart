part of "../../../breakout.dart";

class InvertBrick extends Brick
{
	/**
	 * Duration of speed boost
	 */
	int duration = 15;

	InvertBrick({
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
		name:"Invert Brick",
		thickness:thickness,
		game:game,
		type:"invert",
		coordinates:coordinates
	);

	/**
	 * Destruction event
	 */
	void onDestruct({ball:null})
	{
		var platforms = this.game.getItems((item) => item is Platform);

		platforms.forEach((plat) {
			plat.invert = true;

			this.game.addTimer("invert", new Timer(new Duration(seconds:this.duration), () {
				plat.invert = false;
			}));
		});
	}
}