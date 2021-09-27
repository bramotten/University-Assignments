// javac -cp .:acm.jar CountNames && java -cp .:acm.jar CountNames

import acm.program.*;
import java.awt.event.*;
import javax.swing.*;
import java.io.*;

public class CountNames extends ConsoleProgram {
	public void run {
		ArrayList<String> names = new ArrayList<String>();
		while (true) {
			print("Enter name: ");
			String name = readLine();

			if (name == "") break;
			names.put(name);
		}

		Iterator it = new Iterator();
		while (it.HasNext()) {

		}
	}
}
