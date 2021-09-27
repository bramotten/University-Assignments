/*
 * HangmanCanvas
 *
 * Bram Otten, 10992456, 18-11-2016
 *
 * This is the graphical/canvas part of Hangman.java.
 * A lot of GObject's are created, and edited/drawn
 * according to input from that Hangman.java or counting.
 */

import acm.graphics.*;
import java.awt.*;

public class HangmanCanvas extends GCanvas {
    private static final int X_ORIGIN = 42;
    private static final int Y_ORIGIN = 42;
    private static final int SCAFFOLD_HEIGHT = 300;
    private static final int SCAFFOLD_WIDTH = 250;
    private static final int BEAM_LENGTH = SCAFFOLD_WIDTH / 2;
    private static final int ROPE_LENGTH = 18;

    private static final int HEAD_RADIUS = 25;
    private static final int BODY_WIDTH = 42;
    private static final int BODY_HEIGHT = 100;
    private static final int ARM_OFFSET_FROM_HEAD = 35;
    private static final int LIMB_WIDTH = 50;
    private static final int LIMB_HEIGHT = 50;
    private static final int LIMB_OFFSET_FROM_SPINE = 15;
    private static final double LEG_OFFSET_FROM_HEAD = BODY_HEIGHT * 0.5
        + ARM_OFFSET_FROM_HEAD;
    private static final int SHOE_SIZE = 20;

    private static final int POLE_HEIGHT = ROPE_LENGTH + HEAD_RADIUS;
    private static final int FLAG_HEIGHT = POLE_HEIGHT/2;
    private static final int FLAG_WIDTH = POLE_HEIGHT;

    private static final int WIN_TEXT_HEIGHT = Y_ORIGIN + SCAFFOLD_HEIGHT + 5;
    private static final int FAIL_TEXT_HEIGHT = Y_ORIGIN + SCAFFOLD_HEIGHT + 25;

    private GOval head;
    private GOval body;
    private GLine leftArm;
    private GLine rightArm;
    private GLine flagPole;
    private GRect flag;
    private GLine leftLeg;
    private GLine rightLeg;
    private GLine leftFoot;
    private GLine rightFoot;

    private String incorrectGuesses;
    private int guessCounter;
    private GLabel winText;
    private GLabel failText;

    public void reset() {
        removeAll();
        addScaffold();

        // also use this reset() as practically an init()
        incorrectGuesses = "Incorrect guess history: ";
        guessCounter = 0;
        graphicsCollection();

        winText = new GLabel("");
        add(winText, X_ORIGIN, WIN_TEXT_HEIGHT);
        failText = new GLabel(incorrectGuesses);
        add(failText, X_ORIGIN, FAIL_TEXT_HEIGHT);
    }

    public void displayWord(String discoveredWord) {
        winText.setLabel(discoveredWord);
    }

    public void noteIncorrectGuess(char guess) {
        incorrectGuesses += guess;
        failText.setLabel(incorrectGuesses);

        drawExtraBodypart();
        guessCounter++; // could use the length of incorrectGuesses
    }

    private void addScaffold() {
        // draw the base
        add(new GLine(X_ORIGIN, SCAFFOLD_HEIGHT,
            SCAFFOLD_WIDTH, SCAFFOLD_HEIGHT));

        // the pillar
        add(new GLine(X_ORIGIN, Y_ORIGIN, X_ORIGIN, SCAFFOLD_HEIGHT));

        // the beam
        add(new GLine(X_ORIGIN, Y_ORIGIN, (X_ORIGIN + BEAM_LENGTH), Y_ORIGIN));

        // and the rope
        add(new GLine((X_ORIGIN + BEAM_LENGTH), Y_ORIGIN,
            (X_ORIGIN + BEAM_LENGTH), (Y_ORIGIN + ROPE_LENGTH)));
    }

    private void drawExtraBodypart() {
        switch(guessCounter) {
            case 0:     add(head);
                        break;

            case 1:     add(body);
                        break;

            case 2:     add(leftArm);
                        break;

            case 3:     add(rightArm);
                        add(flagPole);
                        add(flag);
                        break;

            case 4:     add(leftLeg);
                        break;

            case 5:     add(rightLeg);
                        break;

            case 6:     add(leftFoot);
                        break;

            case 7:     add(rightFoot);
                        break;

            default:    System.out.println();
                        System.out.println("Thats your more than eighth or");
                        System.out.println("less than zeroth guess.");
                        System.out.println();
                        break;
        }
    }

    private void graphicsCollection() {
        double ropeEndX = X_ORIGIN + BEAM_LENGTH;
        double ropeEndY = Y_ORIGIN + ROPE_LENGTH;

        double armsY0 = ropeEndY + HEAD_RADIUS * 2 + ARM_OFFSET_FROM_HEAD;
        double armsY1 = armsY0 - LIMB_HEIGHT;
        double legsY0 = ropeEndY + HEAD_RADIUS * 2 + LEG_OFFSET_FROM_HEAD;
        double legsY1 = legsY0 + LIMB_HEIGHT;

        head = new GOval((ropeEndX - HEAD_RADIUS * 0.75), ropeEndY,
            (HEAD_RADIUS * 1.5), (HEAD_RADIUS * 2));
        head.setFilled(true);

        body = new GOval((ropeEndX - BODY_WIDTH / 2),
            (ropeEndY + HEAD_RADIUS * 2), BODY_WIDTH, BODY_HEIGHT);
        body.setFilled(true);

        leftArm = new GLine((ropeEndX - LIMB_OFFSET_FROM_SPINE), armsY0,
            ropeEndX - LIMB_WIDTH, armsY1);

        rightArm = new GLine((ropeEndX + LIMB_OFFSET_FROM_SPINE), armsY0,
            (ropeEndX + LIMB_WIDTH), armsY1);

        flagPole = new GLine((ropeEndX + LIMB_WIDTH), armsY1,
            (ropeEndX + LIMB_WIDTH), (armsY1 - POLE_HEIGHT));
        flag = new GRect((ropeEndX + LIMB_WIDTH), (armsY1 - POLE_HEIGHT),
            FLAG_WIDTH, FLAG_HEIGHT);
        flag.setFilled(true);
        flag.setFillColor(Color.RED);

        leftLeg = new GLine((ropeEndX - LIMB_OFFSET_FROM_SPINE), legsY0,
            (ropeEndX - LIMB_WIDTH), legsY1);

        rightLeg = new GLine((ropeEndX + LIMB_OFFSET_FROM_SPINE), legsY0,
            (ropeEndX + LIMB_WIDTH), legsY1);

        leftFoot = new GLine((ropeEndX - LIMB_WIDTH), legsY1,
            (ropeEndX - LIMB_WIDTH - SHOE_SIZE), legsY1);

        rightFoot = new GLine((ropeEndX + LIMB_WIDTH), legsY1,
            (ropeEndX + LIMB_WIDTH + SHOE_SIZE), legsY1);
    }
}
