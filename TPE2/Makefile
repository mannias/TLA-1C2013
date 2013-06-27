CC = gcc
FLEX = flex
FILES = lex.yy.c y.tab.c
LEXFILES = code.l
OUT_EXE=tp
COPTS= -Wall -g -lfl

all:
	yacc -d -v code.y
	lex code.l
	gcc -o parser lex.yy.c y.tab.c -ly

clean:
	-rm -f *.o core
	-rm -f $(OUT_EXE)	

