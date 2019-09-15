part of "../../../breakout.dart";

/**
 * Heavy Brick
 */
class SplitBrick extends Brick
{
	SplitBrick({
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
		name:"Split Brick",
		thickness:thickness,
		game:game,
		type:"split",
		coordinates:coordinates
	);

	/**
	 * Destruction event
	 */
	void onDestruct({ball:null})
	{
		Ball split = new Ball(
			position: new XYPoint(ball.position.x, ball.position.y),
			speed: ball.baseSpeed - 5,
			game:this.game,
			slope: new XYPoint(ball.slope.x - 0.5, ball.slope.y)
		);

		split.invertSlopeX();

		this.game.addItem(split);

		this.game.addLoop(new BallLoop(split, this.game));
	}
}