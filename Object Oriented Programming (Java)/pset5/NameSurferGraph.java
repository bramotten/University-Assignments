/*
 * File: NameSurferGraph.java
 * ---------------------------
 * This class represents the canvas on which the graph of
 * names is drawn. This class is responsible for updating
 * (redrawing) the graphs whenever the list of entries changes
 * or the window is resized.
 *
 * And yes, it's supposed to have overlapping labels etc.
 */

import acm.graphics.*;
import java.awt.event.*;
import java.util.*;
import java.awt.*;

public class NameSurferGraph extends GCanvas
    implements NameSurferConstants, ComponentListener {

    // private instance variables
    private HashMap<String, int[]> entries;
    private ArrayList<String> namesInEntries;

    private double decadeWidth, rankHeight, bottomMargin;

    public NameSurferGraph() {
        clear(); // less repetition but an unnecessary removeAll()...
        addComponentListener(this);
    }

    public final void clear() {
        removeAll();
        entries = new HashMap<String, int[]>();
        namesInEntries = new ArrayList<String>();
        update();
    }

    public final void addEntry(final NameSurferEntry entry) {
        String name = entry.getName();
        String upperName = name.toUpperCase();

        // only add unique entries
        if (!namesInEntries.contains(upperName)) {
            int[] ranks = new int[NDECADES];
            for (int i = 0; i < NDECADES; i++) {
                ranks[i] = entry.getRank(i);
            }

            namesInEntries.add(upperName);
            entries.put(name, ranks);
            update();
        }
    }

    public final void update() {
        removeAll();

        bottomMargin = getHeight() - GRAPH_MARGIN_SIZE;
        decadeWidth = getWidth() / NDECADES;
        rankHeight = (double) (bottomMargin - GRAPH_MARGIN_SIZE) / MAX_RANK;
        drawGrid();

        // draws lines and labels per decade for all entries
        Iterator it = entries.keySet().iterator();
        while (it.hasNext()) {
            String name = (String) it.next();
            drawDecade(name);
        }
    }

    private void drawGrid() {

        // draw top and bottom borders
        add(new GLine(0, GRAPH_MARGIN_SIZE, getWidth(), GRAPH_MARGIN_SIZE));
        add(new GLine(0, bottomMargin, getWidth(), bottomMargin));

        // draw vertical lines for decades
        for (int i = 0; i < NDECADES; i++) {
            double decadeX = i * decadeWidth;
            add(new GLine(decadeX, 0, decadeX, getHeight()));

            // following magic numbers are decade length in years
            // and some offsets to for nicer looking positions
            int year = START_DECADE + i * 10;
            add(new GLabel("" + year, decadeX + 1, getHeight() - 5));
        }
    }

    private void drawDecade(final String name) {

        // draw line + labels for each decade seperately
        for (int i = 0; i < NDECADES; i++) {
            double x1 = i * decadeWidth;
            double y1 = bottomMargin; // changed if rank != 0 later
            int rank = entries.get(name)[i];

            // rank 0 means the bottom of the graph
            // the +/- 1 are there to seperate label from grid more
            if (rank != 0) {
                y1 = GRAPH_MARGIN_SIZE + rankHeight * rank;
                add(new GLabel((name + " " + rank), x1 + 1, y1 - 1));
            } else {
                add(new GLabel((name + " " + '*'), x1 + 1, y1 - 1));
            }

            // the line stops @ NDECADE - 1
            // the for loop gets this far for the last label
            if (i == NDECADES - 1) {
                break;
            }

            double x2 = x1 + decadeWidth;
            double y2 = bottomMargin; // again, changed if rank != 0
            int nextRank = entries.get(name)[i + 1];

            if (nextRank != 0) {
                y2 = GRAPH_MARGIN_SIZE + rankHeight * nextRank;
            }

            GLine graphLine = new GLine(x1, y1, x2, y2);

            // cycle through 5 colors for some readability
            int nameIndex = namesInEntries.indexOf(name.toUpperCase());
            if (nameIndex % 5 == 1) {
                graphLine.setColor(Color.red);
            } else if (nameIndex % 5 == 2) {
                graphLine.setColor(Color.blue);
            } else if (nameIndex % 5 == 3) {
                graphLine.setColor(Color.green);
            } else if (nameIndex % 5 == 4) {
                graphLine.setColor(Color.orange);
            }

            add(graphLine);
        }
    }

    // implementation of ComponentListener interface
    public final void componentResized(final ComponentEvent e) {
        update();
    }
    public final void componentHidden(final ComponentEvent e) { }
    public final void componentMoved(final ComponentEvent e) { }
    public final void componentShown(final ComponentEvent e) { }
}
