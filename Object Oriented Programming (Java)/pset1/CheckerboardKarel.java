/*
 * File: CheckerboardKarel.java
 * ----------------------------
 * Problem set 1.1
 *
 * Bram Otten, 10992456
 *
 * This program makes Karel create a checkerboard pattern of beepers
 * inside an empty rectangular world.
 */

import stanford.karel.*;

public class CheckerboardKarel extends SuperKarel
{
	public void run()
	{
		// finish when facing north
		while (notFacingNorth())
		{
			while (facingEast())
			{
				goEast();
			}

			while (facingWest())
			{
				goWest();
			}
		}
	}

	private void goEast()
	{
		// if the path is clear, put down a beeper and 
		// try moving on but turn if the row is done
		if (frontIsClear())
		{
			beepAndGo();

			if (frontIsClear())
			{
				move();
			}

			else
			{
				turnLeft();

				if (frontIsClear())
				{
					move();
					turnLeft();
					// and now he's facing west
				}
			}
		}

		// if facing a wall put down a beeper there and turn
		else
		{
			putBeeper();
			turnLeft();

			if (frontIsClear())
			{
				move();
				turnLeft();

				// and make sure there's not one above it
				if (frontIsClear())
				{
					move();
				}

				// if that's not possible, it's a 1xX grid, so go up
				else
				{
					turnRight();

					if (frontIsClear())
					{
						move();
						turnLeft();
					}
				}
			}
		}
	}

	// the while facing west part is practically the same
	// with turnLeft replaced by turnRight etc.
	private void goWest()
	{
		if (frontIsClear())
		{
			beepAndGo();

			if (frontIsClear())
			{
				move();
			} 
			else
			{
				turnRight();

				if (frontIsClear())
				{
					move();
					turnRight();
				}
			}
		}
		else
		{
			putBeeper();
			turnRight();

			if (frontIsClear())
			{
				move();
				turnRight();

				if (frontIsClear())
				{
					move();
				}

				else
				{
					turnLeft();

					if (frontIsClear())
					{
						move();
						turnRight();
					}
				}
			}
		}
	}

	private void beepAndGo()
	{
		putBeeper();
		move();
	}
}
