CLASSPATH = acm.jar
CFLAGS = -cp $(CLASSPATH)

JAVA_FILES = Breakout.java
CLASS_FILES = $(JAVA_FILES:.java=.class)


all: breakout

breakout: Breakout.class

%.class: %.java
	javac $(CFLAGS) $<


submit: pset2.zip

pset2.zip: $(JAVA_FILES)
	zip $@ $^


clean:
	rm -f *.class
