/*
 * File: Pyramid.java (use with java -cp .:acm.jar Pyramid)
 * ------------------
 * Problem set 1.3
 *
 * Bram Otten
 * 10992456
 * 
 * This programs draws a pyramid. The number of bricks per row 
 * decreases with one per row, starting from a max at the base.
 */

import acm.graphics.*;
import acm.program.*;

public class Pyramid extends GraphicsProgram {

	static final int BRICK_WIDTH = 30;
	static final int BRICK_HEIGHT = 12;
	static final int BRICK_IN_BASE = 12;
	
	public void run() {
		
		// gather some intel on the graphics window
		double canvasWidth = getWidth();
		double canvasBottom = getHeight() - 1;
		
		// go through the rows, starting at the bottom of the canvas
		for (int i = BRICK_IN_BASE; i > 0; i--) { // TODO:
			
			// figure out where this row should appear
			double startingX = (canvasWidth / 2) - ((BRICK_WIDTH * i) / 2); 
			double currentY = canvasBottom - ((BRICK_IN_BASE - i + 1) * BRICK_HEIGHT);
			
			// draw the bricks one by one, starting at the left
			for (int j = 0; j < i; j++) {
				double currentX = startingX + (j * BRICK_WIDTH);
				add(new GRect(currentX, currentY, BRICK_WIDTH, BRICK_HEIGHT));
			}		
		}
	}
	
}
