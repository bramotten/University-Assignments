/*
 * File: MazeSolvingKarel.java
 * --------------------------
 * Problem set 1.hacker
 *
 * Bram Otten
 * 10992456
 * 
 * Karel solves mazes. DOES NOT WORK!!!
 * 
 */

import stanford.karel.*;

public class MazeSolvingKarel extends SuperKarel {
	public void run() {
		while (notFacingNorth() || frontIsClear() || rightIsClear() || leftIsClear()) {
			clearFront();
			move();
		}
	}
	private void clearFront() {
		if (frontIsBlocked()) {
			turnLeft();
			if (frontIsBlocked()) {
				turnAround();
				if (frontIsBlocked()) {
					turnRight();
				}
			}
		}
	}
}
