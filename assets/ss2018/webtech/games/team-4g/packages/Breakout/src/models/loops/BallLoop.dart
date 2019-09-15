part of "../../../breakout.dart";


class BallLoop extends Loop
{
	/**
	 * Ball instance
	 */
	Ball ball;

	BallLoop(Ball this.ball, Game game):super(game);

	/**
	 * Run the loop
	 */
	void run() async
	{
		this.running = true;

		modelPrint("Running loop for ball ${this.ball.itemKey}");

		while (!this.game.gameOver && this.game.bricks != 0 && this.running)
		{
			int updates = (1000 / this.ball.speed).round();

			// Check if game is paused
			if (!this.paused && !Loop.allPaused)
			{
				// Move and update ball
				await this.ball.move(updates);
				await this.game.updateFunction(this.ball);

				// Collision detection
				var brick;

				brick = await this.collision(this.ball);

				// Check for collision object
				if (brick == "endloop")
				{
					break;
				}
				else if (brick != null)
				{
					if (brick.health <= 0)
					{
						if (brick.triggerEffect)
							brick.onDestruct(ball:this.ball);
						this.game.removeItem(brick);
					}
				}
			}

			await new Future.delayed(new Duration(milliseconds:updates));
		}

		// Remove ball from Game
		await this.game.removeItem(this.ball);

		this.running = false;

		// Remove loop from loops
		this.game.loops.remove(this);

		modelPrint("Stopped loop for ball ${this.ball.itemKey}");
	}

	/**
	 * Collision detection
	 */
	Future collision(ball) async
	{
		Brick brick = null;

		// Get platform
		Platform platform = this.game.getItems((item) => item is Platform)[0];

		if (this.game.noCollision.hasPoint(this.ball.position))
			return brick;

		// Corner collision
		if (ball.middleY() >= this.game.height && (ball.middleX() >= this.game.width || ball.middleX() <= 0 && ball.middleY()))
		{
			ball.invertSlopeX();
			ball.invertSlopeY();
			return brick;
		}
		// Border collision left / right
		else if (ball.middleX() >= this.game.width || ball.middleX() <= 0)
		{
			ball.invertSlopeX();
			return brick;
		}
		// Border collision top
		else if (ball.middleY() >= this.game.height)
		{
			ball.invertSlopeY();
			return brick;
		}
		// Border collision bottom / game over
		else if (ball.middleY() <= platform.middleY())
		{
			ball.onDestruct();
			return "endloop";
		}

		// Brick collision
		this.game.items.forEach((item){
			if (!(item is Ball) && ball.touches(item))
			{
				// Brick collision
				if (item is Brick)
				{
					brick = item;

					if (!ball.canPenetrate)
						ball.invertSlopeY();

					brick.onHit();
				}
				// Platform collision
				else if (item is Platform)
				{
					ball.invertSlopeY();
					int halfLength = item.length / 2;

					// If ball hit right half of Platform
					ball.slope.x = (1.0 / halfLength) * (item.position.x + halfLength - ball.middleX());
					ball.invertSlopeX();
				}
			}
		});

		return brick;
	}
}