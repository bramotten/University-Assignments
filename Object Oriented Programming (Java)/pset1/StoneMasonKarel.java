/*
 * File: StoneMasonKarel.java
 * --------------------------
 * Problem set 1.1
 * 
 * Bram Otten, 10992456
 *
 * This program makes Karel build pillars with beepers to support arches 
 * that are four unites apart.
 */
 
import stanford.karel.*;

public class StoneMasonKarel extends SuperKarel {

	public void run() {
	
		// start facing north, finish facing east
		turnLeft();
		while (notFacingEast()) {
			buildPillar();
			toNextBase();
		}
		
	}
	
	private void buildPillar() {
		
		// put down beepers where there are none while going up
	   	while (frontIsClear()) {
			moreBeepers();
			move();
	   	}
	   	
	   	// and also one at the top
	   	moreBeepers();
	}
	
	private void toNextBase() {
		
		// face east, do something only if there's space (and thus, a pillar)
		turnRight();
		
		if (frontIsClear()) {
			// move right to next pillar
			for (int j = 0; j < 4; j++) {
				move();
			}
			// move down along it
			turnRight();
			while (frontIsClear()) {
				move();
			}
			// face north, ready for another buildPillar
			turnAround();
		}
	
	}
	
	private void moreBeepers() {
	
		if (noBeepersPresent()) {
			putBeeper();
		}
		
	}

}





















