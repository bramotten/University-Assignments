/*
 * File: NameSurferConstants.java
 * ------------------------------
 * This file declares several constants that are shared by the
 * different modules in the NameSurfer application. Any class
 * that implements this interface can use these constants.
 */

public interface NameSurferConstants {

    // Dimensions of the window. Are not true.
    public static final int APPLICATION_WIDTH = 800;
    public static final int APPLICATION_HEIGHT = 600;

    // The name of the file containing the data
    // remove *.class files after switch
    public static final String NAMES_DATA_FILE = "names-data.txt";
    //public static final String NAMES_DATA_FILE = "dutch-names.txt";

    // The first decade in the database
    public static final int START_DECADE = 1900;

    // The number of decades
    public static final int NDECADES = 11;

    // The maximum rank in the database
    public static final int MAX_RANK = 1000;

    // The number of pixels to reserve at the top and bottom
    public static final int GRAPH_MARGIN_SIZE = 20;

    // text field length for the name in the GUI
    public static final int TEXTFIELD_SIZE = APPLICATION_WIDTH / 40;
}
