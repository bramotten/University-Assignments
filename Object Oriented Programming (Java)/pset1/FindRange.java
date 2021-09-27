/*
 * File: FindRange.java ( java -cp .:acm.jar FindRange )
 * --------------------
 * 
 * Problem set 1.5
 *
 * Bram Otten
 * 10992456
 * 
 * This program asks the users for some integers and a termination.
 * It returns the smallest and largest of the ints.
 * 
 */

import acm.program.*;

public class FindRange extends ConsoleProgram {

    private static final int SENTINEL = 0;
    
    public void run() {
    
        println("This program finds the smallest and largest integers");
        println("in a list. Enter values, one per line, using a 0");
        println("to signal the end of the list.");
        
        // a sentinel value can't be the only input
        // characters, doubles etc. are handled by Java already
        int val = readInt("? ");
		while (val == SENTINEL) {
			println("Please input at least one non-sentinel integer first.");
			val = readInt("? ");
		}
		
		// the smallest of the inputs becomes min, the biggest max
		int min = val;
		int max = val;

        // take inputs as long as the last input wasn't the sentinel        
        while (val != SENTINEL) {
    	   	val = readInt("? ");
    	   	
        	if (val < min && val != SENTINEL) {
        		min = val;
        	} else if (val > max && val != SENTINEL) {
        		max = val;
        	}
        }
        
        println("The smallest value is " + min);
        println("The largest value is " + max);
    }
    
}
