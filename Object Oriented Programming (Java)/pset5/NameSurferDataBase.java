/*
 * File: NameSurferDataBase.java
 * -----------------------------
 * This class keeps track of the complete database of names.
 * The constructor reads in the database from a file, and
 * the only public method makes it possible to look up a
 * name and get back the corresponding NameSurferEntry.
 * Names are matched independent of case, so that "Eric"
 * and "ERIC" are the same names.
 */

import java.util.*; // for hashmap
import java.io.*; // for Readers

public class NameSurferDataBase implements NameSurferConstants {

    // private instance variables
    private HashMap<String, int[]> namesDB;

    public NameSurferDataBase(final String filename) {
        namesDB = new HashMap<String, int[]>();

        try {
            BufferedReader rd = new BufferedReader(new FileReader(filename));
            while (true) {
                String line = rd.readLine();
                if (line == null) {
                    break;
                }

                dataEntry(line);
            }

            rd.close();
        } catch (Throwable t) {
            throw new Error("Error: " + t.getMessage(), t);
        }
        // catch (Exception ex) { println(e); }
    }

    private void dataEntry(final String line) {
        NameSurferEntry entry = new NameSurferEntry(line);

        int[] ranks = new int[NDECADES];
        for (int i = 0; i < NDECADES; i++) {
            ranks[i] = entry.getRank(i);
        }

        // store name in upper to allow user to type anything
        String upperName = entry.getName().toUpperCase();
        namesDB.put(upperName, ranks);
    }

    public final NameSurferEntry findEntry(final String typedName) {

        // iterate through and try every key in the database
        Iterator it = namesDB.keySet().iterator();
        while (it.hasNext()) {

            // match input case to keys, which are upper
            String upperName = typedName.toUpperCase();
            String keyName = (String) it.next();

            if (upperName.equals(keyName)) {

                // create the kind of string NameSurferEntry needs as input
                int[] ranks = namesDB.get(upperName);
                String ranksForString = "";
                for (int i = 0; i < ranks.length; i++) {
                    ranksForString += (" " + ranks[i]);
                }

                // return original spelling
                return new NameSurferEntry(typedName + ranksForString);
            }
        }

        /*
         * End of the data file without finding typedName.
         * Returning NameSurferEntry with name + zeroes here
         * would look nicer in NameSurfer.java, but I got
         * the impression this is how it should be done.
         */

        return null;
    }
}

