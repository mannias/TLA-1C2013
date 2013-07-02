%{
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <inttypes.h>
#define NVARS 100
char* vars[NVARS];
int vals[NVARS];
int nvars = 0;
%}
%error-verbose
%union{
	char* type;
	int num;
}
%token NAME EQQ SUMM NUMBER NEQ RETURN LESS MILL VARTYPE IF WHILE PRINT GETC
%type <type> VARTYPE IF WHILE
%type <num> NUMBER NAME expression condition
%start head


%%
head:	  head header
		| header
		;

header: vtype vname bopen variables bclose open body return close
		;

body:   body assignation
	  |	body loop statements
	  | body simpleop
	  |	body function
	  | body print
	  | print
	  | function
	  | assignation
	  | loop statements
	  | simpleop
	  ;


print: 	PRINT NAME {printf("printf(\"%%d\",%s);\n", vars[$2]);}
		;	  

function:   vname bopen arguments bclose {printf(";\n");}
			;

arguments: 	  vname coma arguments
			| vname
			;

return:   RETURN NAME { printf("return %s;\n", vars[$2]);}
		| RETURN NUMBER {printf("return %d;\n", $2);}
		;

assignation : 	  NAME '=' expression {printf("%s = %d;\n", vars[$1], $3); vals[$1] = $3;}
				| NAME '=' GETC '(' ')' {printf("%s = getchar();\n", vars[$1]);} 
				| VARTYPE NAME '=' GETC '(' ')' {printf("%s %s = getchar();\n", $1, vars[$2]);} 
				| VARTYPE NAME '=' expression {printf("%s %s = %d;\n", $1, vars[$2], $4); vals[$2] = $4;}
				| VARTYPE NAME {printf("%s %s;\n", $1, vars[$2]);}
				;

expression:   '(' expression '+' expression ')' {$$ = $2 + $4;}
			| '(' expression '-' expression ')' {$$ = $2 - $4;}
			| '(' expression '/' expression ')' {$$ = $2 / $4;}
			| '(' expression '*' expression ')' {$$ = $2 * $4;}
			| '(' expression '%' expression ')' {$$ = $2 % $4;}
			| MILL expression					{$$ = miller_rabin($2);}
			| NUMBER 							{$$ = $1;}
			| NAME								{$$ = vals[$1];}
			;

condition:   '(' expression EQQ expression ')' { $$ = ($2 == $4); }
  	 	   | '(' expression '>' expression ')' { $$ = ($2 > $4); }
           | '(' expression '<' expression ')' { $$ = ($2 < $4); }
           | '(' expression NEQ expression ')' { $$ = ($2 == $4); }
           ;

loop:	  IF condition    	{printf("if(%d)", $2);}
		| WHILE condition	{printf("while(%d)", $2);}

simpleop:	  NAME SUMM {printf("%s++;", vars[$1]);}
			| NAME LESS {printf("%s--;", vars[$1]);}
			;

variables:	  vtype vname     
			| vtype vname coma variables
			| {/* sin vars */}
			;

statements: 	open body close
				;

open:	'{' 	{printf("{\n");}
		;

close:	'}'		{printf("}\n");}
		;

bopen: 	'('		{printf("(");}
		;

bclose:	')'		{printf(")");}
		;
 
vtype: 	VARTYPE {printf("%s ", $1);}
		;

vname: 	NAME {printf("%s ", vars[$1]);}
		;

coma:   ',' {printf(",");}
%%

int varindex(char *var)
{
	int i;
	for (i=0; i<nvars; i++)
		if (strcmp(var,vars[i])==0) return i;
	vars[nvars] = strdup(var);
	return nvars++;
}

/**
 * recursive, very simple version of the Miller-Rabin primality test.
 */
static uint32_t millertime(uint32_t a, uint32_t i, uint32_t n)
{
  uint32_t x, y;
  if (i == 0)
    return 1;
  x = millertime(a, i / 2, n);
  if (x == 0)
    return 0;
  y = ((uint64_t)x * x) % n;
  if (y == 1 && x != 1 && x != n - 1)
    return 0;
  if ((i & 1))
    y = ((uint64_t)a * y) % n;
  return y;
}

/**
 * multiple Rabin tests using the first 7 primes (using 8 gives no improvement)
 * are valid for every number up to 3.4e10(sic)
 * @ref http://mathworld.wolfram.com/Rabin-MillerStrongPseudoprimeTest.html
 */
int miller_rabin(uint32_t n)
{
  static const uint32_t a[] = { 2, 3, 5, 7, 11, 13 };
  unsigned i = 0;
  while ( i < sizeof a / sizeof a[0] && a[i] < n && 1 == millertime(a[i++], n - 1, n));
  return sizeof a / sizeof a[0] == i || a[i] >= n;
}

int yywrap()
{
        return 1;
} 
  
main()
{
	printf("#include <stdio.h>\n");
    yyparse();
} 