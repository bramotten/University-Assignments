/*
 * File: NameSurferEntry.java
 * --------------------------
 * This class represents a single entry in the database.  Each
 * NameSurferEntry contains a name and a list giving the popularity
 * of that name for each decade stretching back to 1900.
 *
 * Input lines look like: "Sam 58 69 99 131 168 236 278 380 467 408 466"
 */

import acm.util.*;
import java.util.*;

public class NameSurferEntry implements NameSurferConstants {

    // private instance variables
    private String name;
    private int[] rank;
    private String readableString;

    public NameSurferEntry(final String line) {

        // the line begins with name, then a space
        int nameEnd = line.indexOf(" ");
        name = line.substring(0, nameEnd);

        int numBegin = nameEnd + 1;
        rankFiller(numBegin, line);

        readableString = name + " [" + line.substring(numBegin) + "]";
    }

    private void rankFiller(int numBegin, final String line) {

        // ranks per decade after that name, separated by spaces
        rank = new int[NDECADES];
        for (int i = 0; i < NDECADES - 1; i++) {
            int numEnd = line.indexOf(" ", numBegin);
            rank[i] = Integer.parseInt(line.substring(numBegin, numEnd));
            numBegin = numEnd + 1;
        }

        // there's no space after the last rank, so this one manually
        rank[NDECADES - 1] = Integer.parseInt(line.substring(numBegin));
    }

    public final String getName() {
        return name;
    }

    public final int getRank(final int decade) {
        return rank[decade];
    }

    public final String toString() {
        return readableString;
    }
}
