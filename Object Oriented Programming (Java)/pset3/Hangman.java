import acm.graphics.*;
import acm.program.*;
import java.awt.event.*;

public class Hangman extends GraphicsProgram {

    int clicks;
    int lineX0;
    int lineX1;
    int lineY0;
    int lineY1;

    public void run() {
        clicks = 0;
        addMouseListeners();
    }

    public void mouseClicked(MouseEvent e) {
        clicks++;
        if (clicks % 2 == 1) {
            lineX0 = e.getX();
            lineY0 = e.getY();
        } else {
            lineX1 = e.getX();
            lineY1 = e.getY();
            add(new GLine(lineX0, lineY0,
                    lineX1, lineY1));
        }
    }
}
