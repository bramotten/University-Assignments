CLASSPATH = acm.jar
CFLAGS = -cp .:$(CLASSPATH)

JAVA_FILES = NameSurferConstants.java NameSurferEntry.java NameSurferDataBase.java NameSurferGraph.java NameSurfer.java
CLASS_FILES = $(JAVA_FILES:.java=.class)

all: namesurfer

namesurfer: $(CLASS_FILES)

%.class: %.java
	javac $(CFLAGS) $<

clean:
	rm -f *.class

submit: pset5.zip

pset5.zip: $(JAVA_FILES) acm.jar Makefile
	zip $@ $^
