part of "../../../breakout.dart";

class SpeedBrick extends Brick
{
	/**
	 * Speed boost increase
	 */
	int speedBoost = 10;

	/**
	 * Duration of speed boost
	 */
	int duration = 10;

	SpeedBrick({
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
		name:"Speed Brick",
		thickness:thickness,
		game:game,
		type:"speed",
		coordinates:coordinates
	);

	/**
	 * Destruction event
	 */
	void onDestruct({ball:null})
	{
		ball.speed += this.speedBoost;

		modelPrint("Increased the Speed of the Ball by " + this.speedBoost.toString());

		this.game.addTimer(this.itemKey, new Timer(new Duration(seconds:this.duration), (){
			ball.speed -= this.speedBoost;
				modelPrint("Decreased the Speed of the Ball by " + this.speedBoost.toString());
		}));
	}
}