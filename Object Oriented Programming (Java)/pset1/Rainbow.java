/*
 * File: Rainbow.java (use with java -cp .:acm.jar Rainbow)
 * ------------------
 * Problem set 1.4
 *
 * Bram Otten
 * 10992456
 * 
 * Draws a rainbow! Sky + six colors. It uses circles, of which 
 * the top of the bow must be visible, and it should 
 * 'disappear' in the sides.
 */

import acm.program.*;
import acm.graphics.*;
import java.awt.*;

public class Rainbow extends GraphicsProgram {

	public void run() {
	
		// gather some intel on the graphics window
		double canvasWidth = getWidth(); 
		double canvasBottom = getHeight() - 1;
		
		// make the background of the entire window blue
		GRect sky = new GRect(0, 0, canvasWidth, canvasBottom);
		sky.setColor(Color.CYAN);
		sky.setFilled(true);
		sky.setFillColor(Color.CYAN);
		add(sky);
		
		// draw 120 arcs, outward
		// the first 20 are magenta, the last 20 are red, etc.
		for (int i = 0; i < 120; i++) {
			
			// the innermost circle has the smallest i
			// and therefore the smallest width, etc.
			double leftBorder = canvasWidth * - 0.5 - i; 
			double maxHeight = 158 - i; // that's 42 pixels of space
			double bowWidth = canvasWidth * 2 + 2 * i;
			double minHeight = canvasBottom * 5; 
			
			GOval currentArc = new GOval(leftBorder, maxHeight, bowWidth, minHeight);
			
			if (i < 20) {
				currentArc.setColor(Color.MAGENTA);				
			} else if (i < 40) {
				currentArc.setColor(Color.BLUE);
			} else if (i < 60) {
				currentArc.setColor(Color.GREEN);
			} else if (i < 80) {
				currentArc.setColor(Color.YELLOW);
			} else if (i < 100) {
				currentArc.setColor(Color.ORANGE);
			} else {
				currentArc.setColor(Color.RED);	
			}
			
			add(currentArc);
		}
	}
	
}
















// The end.
