/*
 * HangmanLexicon
 *
 * Bram Otten, 10992456, 18-11-2016
 *
 * This is the lexicon reading part of Hangman.java.
 * It reads a file into an ArrayList and can return
 * the lenght of or words from that ArrayList, that's it.
 */

import acm.util.*;
import java.util.*;
import java.io.*;

public class HangmanLexicon {
    private static final String LEXICON_FILE = "HangmanLexicon.txt";

    private ArrayList<String> lexicon;
    private BufferedReader rd;

    public HangmanLexicon() {
        lexicon = new ArrayList<String>();

        try {
            rd = new BufferedReader(new FileReader(LEXICON_FILE));

            while (true) {
                String word = rd.readLine();
                if (word == null) break;
                lexicon.add(word);
            }

            rd.close();
        } catch (Exception e) {
            System.out.println();
            System.out.println(" !!! This is wrong with lexicon reading: ");
            System.out.println();
            System.out.println(e);
            System.out.println();
        }
    }

    public int getWordCount()
    {
        return lexicon.size();
    }

    public String getWord(int index) {
        return lexicon.get(index);
    }
}
