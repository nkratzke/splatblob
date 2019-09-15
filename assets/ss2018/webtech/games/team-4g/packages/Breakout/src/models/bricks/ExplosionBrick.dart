part of "../../../breakout.dart";

class ExplosionBrick extends Brick
{
	/**
	 * How many bricks left and right are destroyed
	 */
	int explosionSizeX = 1;

	/**
	 * How many brick up and down are destroyed
	 */
	int explosionSizeY = 1;

	ExplosionBrick({
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
		name:"Explosion Brick",
		thickness:thickness,
		game:game,
		type:"explosion",
		coordinates:coordinates
	);

	/**
	 * Destruction event
	 */
	void onDestruct({ball:null})
	{
		var items = this.game.getItems((item) {

			// Get items that are...
			// ...a brick
			return item is Brick &&
			(
				(
					// ...on the same X axis with offset
					item.coordinates.x >= this.coordinates.x - this.explosionSizeX &&
					item.coordinates.x <= this.coordinates.x + this.explosionSizeX &&
					item.coordinates.y == this.coordinates.y
				)
				||
				(
					// ...on the same Y axis with offset
					item.coordinates.y >= this.coordinates.y - this.explosionSizeY &&
					item.coordinates.y <= this.coordinates.y + this.explosionSizeY &&
					item.coordinates.x == this.coordinates.x
				)
			)
			// ...not this brick
			&& item.itemKey != this.itemKey;
		});

		items.forEach((item) {
			item.triggerEffect = false;
			this.game.removeItem(item);
		});
	}
}