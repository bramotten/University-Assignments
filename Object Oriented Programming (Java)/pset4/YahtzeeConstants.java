/*
 * File: YahtzeeConstants.java
 * ---------------------------
 * This file declares several constants that are shared by the
 * different modules in the Yahtzee game.
 */

public interface YahtzeeConstants {

	// probably unused window dimensions
	public static final int APP_WIDTH = 600;
	public static final int APP_HEIGHT = 350;

	// game rule constants
	public static final int N_DICE = 5;
	public static final int N_DIES = 6;
	public static final int MAX_PLAYERS = 4;
	public static final int N_ROLLS = 3;
	public static final int N_CATEGORIES = 17;
	public static final int N_SCORING_CATEGORIES = 13;

	// category specifiers
	public static final int ONES = 1;
	public static final int TWOS = 2;
	public static final int THREES = 3;
	public static final int FOURS = 4;
	public static final int FIVES = 5;
	public static final int SIXES = 6;
	public static final int UPPER_SCORE = 7;
	public static final int UPPER_BONUS = 8;
	public static final int THREE_OF_A_KIND = 9;
	public static final int FOUR_OF_A_KIND = 10;
	public static final int FULL_HOUSE = 11;
	public static final int SMALL_STRAIGHT = 12;
	public static final int LARGE_STRAIGHT = 13;
	public static final int YAHTZEE = 14;
	public static final int CHANCE = 15;
	public static final int LOWER_SCORE = 16;
	public static final int TOTAL = 17;

	// choose your own dice on roll 1 if true
	public static final boolean GOD_MODE = false;
}
