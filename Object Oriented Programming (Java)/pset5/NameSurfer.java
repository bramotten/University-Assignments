/*
 * File: NameSurfer.java
 * ---------------------
 * By Bram Otten, UvA ID 10992456
 *
 * This class creates a GUI that lets users find out how popular names
 * were through the last decades. The default US data comes from:
 * https://www.ssa.gov/OACT/babynames/. If a name was not one of the 1000
 * most popular ones in that decade,not it's rank but a '*' is displayed.
 *
 * There is a problem with the US data: every gender gets seperate ranks.
 * So there are two #1's etc.
 */

// https://progki.mprog.nl/psets/namesurfer
// java -cp .:acm.jar NameSurfer

import acm.program.*;
import java.awt.event.*;
import javax.swing.*;
import java.io.*;

public class NameSurfer extends Program implements NameSurferConstants {

    // private instance variables
    private JTextField nameField;
    private JButton graphButton;
    private JButton clearButton;
    private NameSurferGraph graph;

    public final void init() {
        makeGUI();
        addActionListeners();
    }

    private void makeGUI() {
        add(new JLabel("Name: "), SOUTH);
        nameField = new JTextField(TEXTFIELD_SIZE);
        add(nameField, SOUTH);
        nameField.addActionListener(this);

        graphButton = new JButton("Graph");
        add(graphButton, SOUTH);

        clearButton = new JButton("Clear");
        add(clearButton, SOUTH);

        graph = new NameSurferGraph();
        add(graph);
    }

    public final void actionPerformed(final ActionEvent e) {

        if (e.getSource() == graphButton || e.getSource() == nameField) {
            graphName(nameField.getText());
        } else if (e.getSource() == clearButton) {
            graph.clear();
        }
    }

    private void graphName(final String name) {

        NameSurferDataBase namesDB = new NameSurferDataBase(NAMES_DATA_FILE);
        NameSurferEntry entry = namesDB.findEntry(name);

        // replace entry if name's never in the top 1000
        if (entry == null) {

            String zeroes = "";
            for (int i = 0; i < NDECADES; i++) {
                zeroes += " 0";
            }

            entry = new NameSurferEntry(name + zeroes);
        }

        graph.addEntry(entry);
    }
}
