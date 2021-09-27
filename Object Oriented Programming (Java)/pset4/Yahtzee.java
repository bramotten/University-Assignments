/*
 * File: Yahtzee.java
 * ------------------
 * Bram Otten, UvA ID 10992456.
 * 
 * This program plays the Yahtzee game.
 * I haven't found any bugs in this version.
 * It uses rules listed on https://progki.mprog.nl/
 * I've made use how limited those rules are at some
 * points, so you'll see I use for example a 3 instead
 * of AMOUNT_OF_A_KIND_IN_THREE_OF_A_KIND or something.
 */

import acm.io.*;
import acm.program.*;
import acm.util.*;
import java.util.Arrays;

public class Yahtzee extends GraphicsProgram implements YahtzeeConstants {

	// instance variables
	private int nPlayers;
	private String[] playerNames;
	private YahtzeeDisplay display;
	private RandomGenerator rgen = new RandomGenerator();
	private int[] diceValues;
	private int[] totalScores;
	private int[][] scoresPerCategory;
	private boolean[][] chosenCategories;

	public static void main(String[] args) {
		new Yahtzee().start(args);
	}

	public void run() {

		// user interaction for intitialization
		IODialog dialog = getDialog();
		nPlayers = dialog.readInt("Enter number of players");
		while (nPlayers > MAX_PLAYERS || nPlayers < 1) {
			nPlayers = dialog.readInt("By default just 1-4 players, please");
		}

		playerNames = new String[nPlayers];
		for (int i = 0; i < nPlayers; i++) {
			playerNames[i] = dialog.readLine(
				"Enter name for player " + (i + 1));
		}

		scoresPerCategory = new int[nPlayers][TOTAL];
		totalScores = new int[nPlayers];
		chosenCategories = new boolean[nPlayers][TOTAL];

		display = new YahtzeeDisplay(getGCanvas(), playerNames);
		playGame();
	}

	private void playGame() {

		// cycle through rounds
		for (int round = 1; round <= N_SCORING_CATEGORIES; round ++) {

			// cycle through turns for each player
			for (int player = 0; player < nPlayers; player ++) {
				display.printMessage(playerNames[player] + "'s turn.");

				// cycle through rolls for each turn
				for (int roll = 1; roll <= N_ROLLS; roll ++) {
					rollDice(roll, player); // update diceValues
					display.displayDice(diceValues);
				}

				// let user pick category, handle resulting scores
				scoreCategory(player);
			}
		}

		scoreFinalizing();
		declareWinner();
	}

	private void rollDice(int roll, int player) {

		// roll 1 is the starting dice config
		if (roll == 1) {
			
			// display methods start counting @ 1, player starts @ 0
			// prevention possible, means more - 1's somewhere else
			display.waitForPlayerToClickRoll(player + 1);

			diceValues = new int[N_DICE];
			for (int dice = 0; dice < N_DICE; dice ++) {

				// just for testing: input your own dice values
				if (GOD_MODE == true) {
					IODialog dialog = getDialog();
					while (diceValues[dice] < 1 || diceValues[dice] > N_DIES) {
						diceValues[dice] = dialog.readInt(
							"Give proper value for dice #" + (dice + 1));
					}
				}

				// normally, the dice values will be random
				else {
					diceValues[dice] = rgen.nextInt(1, N_DIES);
				}
			}
		}

		// the other rolls should only change selected dices
		else {
			display.printMessage("You get another roll this turn.");
			display.waitForPlayerToSelectDice();

			for (int i = 0; i < N_DICE; i ++) {
				if (display.isDieSelected(i)) {
					diceValues[i] = rgen.nextInt(1,N_DIES);
				}
			}
		}
	}

	private int scoreThisCategory(int category) {
		if (category <= SIXES) {
			return sumOfJustThisDie(category);
		}

		// could use else if's for all of these
		// a switch too, but the constant names are a little too long
		if (category == CHANCE) {
			return sumOfAllDices();
		}
		
		if (category == THREE_OF_A_KIND) {

			// the false because more than 3 of a kind is also okay
			if (occurenceCheck(3, false)) {
				return sumOfAllDices();
			}
			return 0;
		}

		if (category == FOUR_OF_A_KIND) {
			if (occurenceCheck(4, false)) {
				return sumOfAllDices();
			}
			return 0;
		}

		if (category == FULL_HOUSE) {
			if (occurenceCheck(3, true) && occurenceCheck(2, true)) {
				return 25;
			}
			return 0;
		}

		if (category == SMALL_STRAIGHT) {
			if (sequenceCheck(4)) {
				return 30;
			} else {
				return 0;
			}
		}

		if (category == LARGE_STRAIGHT) {
			if (sequenceCheck(5)) {
				return 40;
			} else {
				return 0;
			}
		}

		if (category == YAHTZEE) {
			if (occurenceCheck(5, true)) {
				return 50;
			}
			return 0;
		}

		return -1;
	}

	private int sumOfJustThisDie(int die) {
		int score = 0;
		for (int dice : diceValues) {
			if (dice == die) {
				score += die;
			}
		}
		return score;
	}

	private int sumOfAllDices() {
		int score = 0;
		for (int dice : diceValues) {
			score += dice;
		}
		return score;
	}

	private int[] occurenceCounter() {
		int[] occurencePerDie = new int[N_DIES];

		for (int diceValue : diceValues) {
			occurencePerDie[diceValue - 1] += 1;
		}

		return occurencePerDie;
	}

	private boolean occurenceCheck(int numberOfDices, boolean exact) {
		int[] occurencePerDie = occurenceCounter();

		for (int i = 0; i < N_DIES; i ++) {
			if (occurencePerDie[i] == numberOfDices) {
				return true;
			} else if (occurencePerDie[i] > numberOfDices && !exact) {
				return true;
			}
		}

		return false;
	}

	private boolean sequenceCheck(int sequenceLength) {
		Arrays.sort(diceValues);
		boolean straight = false;

		// create a new array without repeats if necessary
		// exact could be true with the current rules, but I'm
		// keeping some generality.
		if (occurenceCheck(2, false)) {
			repeatRemover();
		}

		// the sequence must start at least its length from the sorted dice end
		for (int i = 0; i <= (diceValues.length - sequenceLength); i ++) {
			int start = diceValues[i];
			int j = 0;

			// and it must continue counting up from there
			while (j < sequenceLength) {
				if (diceValues[i + j] == (start + j)) {
					straight = true;
					j ++;
				} else {
					straight = false;
					j = sequenceLength;
				}
			}

			if (straight) return true;
		}

		return false;
	}

	private void repeatRemover() {
		
		/*
		 * Create a new array, copy diceValues into it only if not
		 * the same as the previous value. If it is, the new position
		 * counter starts trailing behind the old one, so duplicates
		 * don't get copied. Later the the old diceValues is replaced.
		 */

		int[] newDiceValues = new int[diceValues.length - 1];	
		newDiceValues[0] = diceValues[0];
		int j = 1;

		for (int i = 1; i < diceValues.length; i ++) {
			
			if (diceValues[i] != diceValues[i - 1]) {
				newDiceValues[j] = diceValues[i];
				j ++;
			}
		}

		diceValues = newDiceValues;
	}

	private void scoreCategory(int player) {

		// let user choose a yet unchosen category
		display.printMessage("Please pick a category, " + playerNames[player]);
		int category = display.waitForPlayerToSelectCategory();
		while (alreadyChosen(player, category)) {
			display.printMessage("You've chosen that category already.");
			category = display.waitForPlayerToSelectCategory();
		}

		// figure out the score for this round
		int score = scoreThisCategory(category);
		display.updateScorecard(category, (player + 1), score);
		scoresPerCategory[player][category] = score;

		// update the total too
		totalScores[player] += score;
		display.updateScorecard(TOTAL, (player + 1), totalScores[player]);
	}

	private boolean alreadyChosen(int player, int category) {
		
		// the default boolean array value is false
		if (chosenCategories[player][category]) {
			return true;
		} else {
			chosenCategories[player][category] = true;
			return false;
		}
	}

	private void scoreFinalizing() {

		// once again, for each player
		for (int player = 0; player < nPlayers; player ++) {

			// count up everything in the upper categories
			int upperScore = 0;
			for (int i = 0; i < UPPER_SCORE; i ++) {
				upperScore += scoresPerCategory[player][i];
			}
			display.updateScorecard(UPPER_SCORE, (player + 1), upperScore);

			// assign a bonus if one is deserved
			if (upperScore > 63) {
				display.updateScorecard(UPPER_BONUS, (player + 1), 35);
				totalScores[player] += 35;
				display.updateScorecard(TOTAL, (player + 1),
					totalScores[player]);
			} else {
				display.updateScorecard(UPPER_BONUS, (player + 1), 0);
			}

			// count up everything in the lower categories
			int lowerScore = 0;
			for (int i = (UPPER_BONUS + 1); i < LOWER_SCORE; i ++) {
				lowerScore += scoresPerCategory[player][i];
			}
			display.updateScorecard(LOWER_SCORE, (player + 1), lowerScore);
		}
	}

	private void declareWinner() {
		int maxScore = -1;
		String winner = "Everybody";

		// keep track of a 'best so far'
		for (int player = 0; player < nPlayers; player ++) {
			if (totalScores[player] >= maxScore) {
				maxScore = totalScores[player];
				winner = playerNames[player];
			}
		}

		display.printMessage(winner + " won with " + maxScore + " points!");
	}
}
