/*
 * Breakout.java
 *
 * Bram Otten, 10992456, 11-11-2016.
 *
 * This program implements the game of Breakout.
 * It's simple, it really only has a "bounce in same
 * direction when hitting edge" as non-essential feature.
 *
 * I've tried to limit my commenting to explaining my decisions.
 *
 * I usually haven't done things like:
 * double midBallY = ball.getY() - BALL_RADIUS;
 * I'm sorry if this makes the longer comparisons hard to read.
 */

import acm.graphics.*;
import acm.program.*;
import acm.util.*;
import java.applet.*;
import java.awt.*;
import java.awt.event.*;

public class Breakout extends GraphicsProgram {
    // width and height of application window in pixels
    public static final int APPLICATION_WIDTH = 400;
    public static final int APPLICATION_HEIGHT = 600;

    // dimensions of game board (usually the same)
    private static final int WIDTH = APPLICATION_WIDTH;
    private static final int HEIGHT = APPLICATION_HEIGHT;

    // dimensions of the paddle
    private static final int PADDLE_WIDTH = 60;
    private static final int PADDLE_HEIGHT = 10;

    // offset of the paddle up from the bottom
    private static final int PADDLE_Y_OFFSET = 30;

    // offset op paddle down from top
    private static final int PADDLE_TOP_Y = HEIGHT - PADDLE_Y_OFFSET;

    // amount of pixels the paddle should move per key press
    private static final double PADDLE_MOVE = PADDLE_WIDTH / 4;

    // number of bricks per row
    private static final int NBRICKS_PER_ROW = 5;

    // number of rows of bricks
    private static final int NBRICK_ROWS = 10;

    // total number of bricks
    private static int ORIGINAL_NBRICKS = NBRICK_ROWS * NBRICKS_PER_ROW;

    // width of a brick
    private static final int BRICK_WIDTH = WIDTH / (NBRICKS_PER_ROW * 2);

    // height of a brick
    private static final int BRICK_HEIGHT = 8;

    // radius of the ball in pixels
    private static final int BALL_RADIUS = 10;

    // diameter of the ball in pixels
    private static final int BALL_DIAMETER = BALL_RADIUS * 2;

    // offset of the top brick row from the top
    private static final int BRICK_Y_OFFSET = 80; //

    // number of tries the user gets
    private static final int NTURNS = 3;

    // amount of ms between moves of the ball
    private static final int DELAY = 25;

    // amount of ms between turns
    private static final int NEXT_GAME_DELAY = 100 * DELAY;

    // percentage of speed the ball gains per paddle bounce
    private static final int DIFFICULTY = 2; //

    // pre-turn message for the player (these comments seem redundant)
    private static final String PRE_TURN_MESSAGE =
        "Dwerg";

    // ranges for ball speeds (pixel per DELAY)
    private static final double MIN_VX = 1.0;
    private static final double MAX_VX = 3.0;
    private static final double MIN_VY = -4;
    private static final double MAX_VY = -8;

    // always accessible stuff that will be assigned later
    private boolean won;
    private boolean gameOver;
    private int numberOfBricksLeft;
    private GRect paddle;
    private GOval ball;
    private double vx;
    private double vy;

    public void run() {

        // the only things that don't have to be done before every turn
        addMouseListeners();
        addKeyListeners();

        for (int curTurn = 0; curTurn < NTURNS; curTurn++) {

            if (won == true) {
                break;
            }

            setup();

            // A simple break could have been used to signal end of turn, but
            // gameOver is also used to block paddle movement when not playing.

            gameOver = false;

            while (gameOver == false) {

                if (numberOfBricksLeft == 0) {
                    won = true;
                    break;
                }

                ball.move(vx, vy);
                bounceWalls();

                GObject collider = getCollidingObject();
                if (collider == paddle) {

                    hitPaddleEdge();

                    // Swap vertical direction if top half of ball is still
                    // above paddle. (Don't like getCollidingObject
                    // practically making the paddle wider.) Now the ball can
                    // also hit the side and go down. vy > 0 makes sure
                    // the paddle can only make the ball bounce up. Also
                    // increase vertical speed with DIFFICULTY % per bounce

                    if (ball.getY() + BALL_RADIUS < PADDLE_TOP_Y && vy > 0) {
                        vy = -vy * (1 + DIFFICULTY * 0.01);
                    }
                }

                // Any other GRect's (or GObject's even) must be bricks by now.
                // If other GRect's are implemented, && getDimension could
                // be used to check if this is a brick.

                else if (collider instanceof GRect ) {

                    hitBrickEdge(collider);

                    // Correct for getCollidingObject in both directions.
                    // A || could also have been used.
                    // A vy comparison is not necessary because the
                    // brick is about to be removed (so no getting stuck).

                    if ((ball.getY() - BALL_RADIUS <= collider.getY()) ||
                            (ball.getY() + BALL_RADIUS >= collider.getY())) {
                        vy = -vy;
                    }

                    remove(collider);
                    numberOfBricksLeft--;
                }

                // hit the bottom? Next turn or lose
                if (ball.getY() > HEIGHT) {

                    gameOver = true;

                    if (curTurn + 1 < NTURNS) {
                        nextTurnMessage(curTurn + 1);
                    }
                }

                // give user some time before the next ball move
                pause(DELAY);
            }
        }

        if (won == true) {
            winScreen();
        } else {
            loseScreen();
        }
    }

    private void setup() {

        setupBricks();
        numberOfBricksLeft = ORIGINAL_NBRICKS;

        createPaddle();
        add(paddle, (WIDTH / 2 - PADDLE_WIDTH / 2), PADDLE_TOP_Y);

        createBall();
        add(ball, (WIDTH / 2 - BALL_DIAMETER / 2),
            PADDLE_TOP_Y - BALL_DIAMETER);

        // generate sort of random movement speeds/directions for the ball
        vx = rgen.nextDouble(MIN_VX, MAX_VX);
        if (rgen.nextBoolean(0.5)) {
            vx = -vx;
        }
        vy = rgen.nextDouble(MIN_VY, MAX_VY);

        writeMidScreen(PRE_TURN_MESSAGE);
        waitForClick();

        // remove that PRE_TURN_MESSAGE again
        GObject instructions = getElementAt(WIDTH / 2, HEIGHT / 2);
        remove(instructions);
    }

    private RandomGenerator rgen = RandomGenerator.getInstance();

    private void setupBricks() {

        // cycle through five colors, creating two rows with each one
        for (int curRow = 0; curRow < NBRICK_ROWS; curRow++) {

            if ((curRow % 10) < 2) {
                createBrickRows(Color.RED, curRow);
            }

            else if ((curRow % 10) < 4) {
                createBrickRows(Color.ORANGE, curRow);
            }

            else if ((curRow % 10) < 6) {
                createBrickRows(Color.YELLOW, curRow);
            }

            else if ((curRow % 10) < 8) {
                createBrickRows(Color.GREEN, curRow);
            }

            else {
                createBrickRows(Color.CYAN, curRow);
            }
        }
    }

    private void createBrickRows(Color color, int rowNumber) {

        int curRowY = rowNumber * BRICK_HEIGHT;

        // uneven rows start BRICK_WIDTH from the wall (start counting @ 0)
        if (rowNumber % 2 == 0) {

            for (int curBrickN = 0; curBrickN < NBRICKS_PER_ROW; curBrickN++) {
                int curBrickX = BRICK_WIDTH + (curBrickN * BRICK_WIDTH * 2);
                createBricks(color, curBrickX, curRowY);
            }
        } else {

            for (int curBrickN = 0; curBrickN < NBRICKS_PER_ROW; curBrickN++) {
                int curBrickX = curBrickN * BRICK_WIDTH * 2;
                createBricks(color, curBrickX, curRowY);
            }
        }
    }

    private void createBricks(Color color, int curBrickX, int curRowY) {

        GRect curBrick = new GRect(BRICK_WIDTH, BRICK_HEIGHT);
        curBrick.setFilled(true);
        curBrick.setColor(color);

        add(curBrick, curBrickX, curRowY + BRICK_Y_OFFSET);
    }

    private void createPaddle() {
        paddle = new GRect(PADDLE_WIDTH, PADDLE_HEIGHT);
        paddle.setFilled(true);
    }

    public void keyPressed(KeyEvent e) {

        // Move left/right on left/right arrow keys, only while the game is on.
        // If the paddle is in range of a wall, a last move will just put it
        // against the wall.

        if (e.getKeyCode() == KeyEvent.VK_LEFT && gameOver == false) {

            if (paddle.getX() <= 0 + PADDLE_MOVE) {
                paddle.setLocation(0, PADDLE_TOP_Y);
            } else {
                paddle.move(-PADDLE_MOVE, 0);
            }
        } else if (e.getKeyCode() == KeyEvent.VK_RIGHT && gameOver == false) {

            if (paddle.getX() + PADDLE_WIDTH >= WIDTH - PADDLE_MOVE) {
                paddle.setLocation(WIDTH - PADDLE_WIDTH, PADDLE_TOP_Y);
            } else {
                paddle.move(PADDLE_MOVE, 0);
            }
        }
    }

    private void createBall() {
        ball = new GOval(BALL_DIAMETER, BALL_DIAMETER);
        ball.setFilled(true);
    }

    private void bounceWalls() {

        // The ball's horizontal changes when hitting(/within) a wall.
        // Comparison with 0 is there to prevent getting stuck in a wall,
        // the left wall can only make ball go right etc.

        if (ball.getX() <= 0 && vx < 0) {
            vx = -vx;
        } else if ((ball.getX() >= WIDTH - BALL_DIAMETER) && vx > 0) {
            vx = -vx;
        }

        else if (ball.getY() <= 0 && vy < 0) {
            vy = -vy;
        }
    }


    private void hitPaddleEdge() {

        // Swap horizontal direction if hitting within BALL_RADIUS
        // of a right or left paddle edge. The vx 0 comparison prevents
        // bouncing back on a far corner of the paddle.

        boolean rightPaddleEdge = (ball.getX() >=
                                   (paddle.getX() + PADDLE_WIDTH - BALL_RADIUS));
        boolean leftPaddleEdge = (ball.getX() + BALL_DIAMETER <=
                                  (paddle.getX() + BALL_RADIUS));

        if ((rightPaddleEdge && vx < 0) || (leftPaddleEdge && vx > 0)) {
            vx = -vx;
        }
    }

    private void hitBrickEdge(GObject brick) {

        // Swap horizontal direction if hitting within BALL_RADIUS/3 of a right
        // or left brick edge. /3 because a brick is generally smaller than a
        // paddle.

        boolean rightBrickEdge = (ball.getX()  >=
                                  (brick.getX() + PADDLE_WIDTH - BALL_RADIUS / 3));
        boolean leftBrickEdge = (ball.getX() <= (brick.getX() - BALL_RADIUS / 3));

        if ((rightBrickEdge && vx < 0) || (leftBrickEdge && vx > 0)) {
            vx = -vx;
        }
    }

    // returns objects that collide with the ball
    private GObject getCollidingObject() {

        // get the current center of the ball
        int x = (int) ball.getX() + BALL_RADIUS;
        int rowNumber = (int) ball.getY() + BALL_RADIUS;

        // the number of points to check around the ball
        int points = 16;
        for (int i = 0; i < points; i++) {

            // compute the x and rowNumber offset based on (co)sine of angle
            double angle = 2 * Math.PI * i / points;
            int dx = (int) Math.ceil(Math.cos(angle) * (BALL_RADIUS + 2));
            int dy = (int) Math.ceil(Math.sin(angle) * (BALL_RADIUS + 2));

            // check if there is an object at the computed point
            GObject collider = getElementAt(x + dx, rowNumber + dy);
            if (collider != null) {
                return collider;
            }
        }
        return null;
    }

    private void nextTurnMessage(int lastTurn) {

        writeMidScreen("Fail #" + (lastTurn) + "...");
        pause(NEXT_GAME_DELAY);

        //canvas is cleared because full setup before each turn
        removeAll();
    }

    private void winScreen() {
        removeAll();

        GRect winBackground = new GRect(WIDTH, HEIGHT);
        winBackground.setFilled(true);
        winBackground.setColor(Color.GREEN);
        add(winBackground);

        writeMidScreen("Yeah, that was all.");
    }

    private void loseScreen() {

        GRect loseBackground = new GRect(WIDTH, HEIGHT);
        loseBackground.setFilled(true);
        loseBackground.setColor(Color.RED);
        add(loseBackground);

        writeMidScreen("FAIL #" + NTURNS + ". GAME OVER!");
    }

    private void writeMidScreen(String messageText) {

        // The middle of this message is also the middle of
        // the screen, (necessary for later removal). Font
        // size will start becoming unreasonable at some WIDTHs
        // but less than with a static 20.

        GLabel message = new GLabel(messageText);
        message.setFont("Arial-" + WIDTH / 20);

        add(message, (WIDTH / 2 - message.getWidth() / 2), HEIGHT / 2);
    }
}

