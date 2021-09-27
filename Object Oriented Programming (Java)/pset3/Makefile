CLASSPATH = acm.jar
CFLAGS = -cp .:$(CLASSPATH)

JAVA_FILES = Hangman.java HangmanCanvas.java HangmanLexicon.java
CLASS_FILES = $(JAVA_FILES:.java=.class)

all: hangman

hangman: $(CLASS_FILES)

%.class: %.java
	javac $(CFLAGS) $<

clean:
	rm -f *.class

submit: pset3.zip

pset3.zip: $(JAVA_FILES) acm.jar Makefile HangmanLexicon.txt ShorterLexicon.txt
	zip $@ $^
