CC = gcc
FLEX = flex
FILES = lex.yy.c
LEXFILES = code.l
OUT_EXE=tp
COPTS= -Wall -g -lfl

tp:
	$(FLEX) $(LEXFILES)
	$(CC) $(COPTS) -o $(OUT_EXE) $(FILES)
	-rm -f *.yy.c

clean:
	-rm -f *.o core
	-rm -f $(OUT_EXE)

#rebuild: clean build