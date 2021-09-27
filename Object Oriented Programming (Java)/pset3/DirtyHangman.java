/*
 * Hangman
 *
 * Bram Otten, 10992456, 18-11-2016
 *
 * The hangman game. Look at HangmanCanvas.java and HangmanLexicon.java as well.
 *
 * TODO: make work, write description, see other TODO's.
 */

import acm.graphics.*;
import acm.program.*;
import acm.util.*;

import java.awt.*;
import java.util.ArrayList;
//import java.util.Scanner; // TODO

public class Hangman extends ConsoleProgram {

    private static final int TOTAL_GUESSES = 8;

    public void run() {

        displayWelcome();

        // choose a word from the lexicon randomly
        // - 1 because it mixes up the 0 inclusion in counting
        secretString = lexicon.getWord
            (rgen.nextInt(0, lexicon.getWordCount() - 1));
        secretLength = secretString.length();

        // prep and fill the ArrayLists
        secretLetters = new ArrayList();
        currentStatus = new ArrayList();
        for (int i = 0; i < secretLength; i++) {
            secretLetters.add(secretString.charAt(i));
            currentStatus.add('_');
        }

        // the user gets TOTAL_GUESSES tries at the game
        for (int guessesLeft = TOTAL_GUESSES; guessesLeft > 0; guessesLeft--) {

            displayCurrentStatus();

            char guess = askGuess(guessesLeft); // TODO

            //updateStatus(guess); // TODO
        }

    }

    // stuff I need everywhere (instance variables?)
    String secretString;
    int secretLength;
    ArrayList secretLetters;
    ArrayList currentStatus;
    char guess;

    private HangmanLexicon lexicon = new HangmanLexicon();

    private RandomGenerator rgen = RandomGenerator.getInstance();

    //private Scanner s = new Scanner(System.in); // TODO

    private void displayWelcome() {
        println("Welcome to Hangman!");
    }

    private void displayCurrentStatus() {
        print("The word now looks like this: ");
        for (int i = 0; i < secretLength; i++) {
            print(currentStatus.get(i));
            print(" ");
        }
        println();
    }

    private char askGuess(int guessesLeft) {
        println("You have " + guessesLeft + " guess left.");
        print("Your guess: ");
        return 'c';
        /*guess = ''; // TODO
        addKeyListener(keyListener);
        if (guess != '') {
            println(guess);
        }
        println(guess);
        return guess;*/

        //return s.next().charAt(0); // TODO: System.in of s must be something like externalCanvas, or I have to use a keyListener and remove it later. Or keep it and print whatever the user gave.
    }
    /* TODO
    public void keyPressed(KeyEvent e) {
        guess = e.getKeyChar();
    }
    */
}
