part of "../../../breakout.dart";

class SlowBrick extends Brick
{
	/**
	 * Speed boost increase
	 */
	int slowDown = 10;

	/**
	 * Duration of speed boost
	 */
	int duration = 10;

	SlowBrick({
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
		name:"Slow Brick",
		thickness:thickness,
		game:game,
		type:"slow",
		coordinates:coordinates
	);

	/**
	 * Destruction event
	 */
	void onDestruct({ball:null})
	{
		ball.speed -= this.slowDown;

		modelPrint("Slowed down the Speed of the Ball by " + this.slowDown.toString());

		this.game.addTimer(this.itemKey, new Timer(new Duration(seconds:this.duration), (){
			ball.speed += this.slowDown;
				modelPrint("Sped up the Speed of the Ball by " + this.slowDown.toString());
		}));
	}
}