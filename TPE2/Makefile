CC = gcc
YACC = yacc
FLEX = flex
FILES = lex.yy.c y.tab.c
LEXFILES = code.l
YACCFILES = code.y
OUT_EXE=tp
YACCFLAGS = -dv

all:
	$(YACC) $(YACCFLAGS) $(YACCFILES)
	$(FLEX) $(LEXFILES)
	$(CC) -o $(OUT_EXE) $(FILES) -ly
	-rm -f *.yy.c *.tab.c *.tab.h

clean:
	-rm -f y.output
	-rm -f $(OUT_EXE)	
