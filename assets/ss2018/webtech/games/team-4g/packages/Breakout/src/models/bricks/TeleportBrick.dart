part of "../../../breakout.dart";

/**
 * Teleportation brick
 * There there should always be an even number of
 * This type of brick on the field for it to work properly
 */
class TeleportBrick extends Brick
{
	TeleportBrick({
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
		name:"Teleport Brick",
		thickness:thickness,
		game:game,
		type:"teleport",
		coordinates:coordinates
	);

	/**
	 * Destruction event
	 */
	void onDestruct({ball:null})
	{
		List tele = this.game.getItems((item) => item is TeleportBrick && !identical(item, this));

		if (tele.isNotEmpty)
		{
			var brick = tele[_random.nextInt(tele.length)];
			this.game.removeItem(brick);

			ball.moveTo(brick.middleX(), brick.middleY());
		}
	}
}