%{

#define NVARS 100
char* vars[NVARS];
int vals[NVARS];
int nvars = 0;
%}

%token NAME

%%

head: VARTYPE NAME '(' variables ')' '{' body return '}' { printf("%d\n", $8);}

body:   body assignation
	  |	body loop

return:   RETURN NAME { $$ = vars[$2];}
		| RETURN NUMBER {$$ = $1;}

assignation : NAME '=' expression {printf("%s = %d", $1, $3);}

expression:   '(' expression '+' expression ')' {$$ = $1 + $2;}
			| '(' expression '-' expression ')' {$$ = $1 - $2;}
			| '(' expression '/' expression ')' {$$ = $1 / $2;}
			| '(' expression '*' expression ')' {$$ = $1 * $2;}
			| '(' expression '%' expression ')' {$$ = $1 % $2;}
			| MILL expression					{$$ = miller_rabin($2);}
			| NUMBER 							{$$ = $1;}
			| NAME								{$$ = vars[$1]}

condition:   '(' expression EQQ expression ')' { $$ = ($1 == $3); }
  	 	   | '(' expression '>' expression ')' { $$ = ($1 > $3); }
           | '(' expression '<' expression ')' { $$ = ($1 < $3); }
           | '(' expression NEQ expression ')' { $$ = ($1 == $3); }

simpleop: 	  NAME SUMM {$$ = vars[$1]+1;}
			| NAME LESS {$$ = vars[$1]-1;}

loop:	  IF condition '{' body '}'
		| WHILE condition '{' body '}'
		| FOR '('assignation ';' condition ';' simpleop ')''{' body '}'

variables	  VARTYPE NAME {printf("%s %s;\n", $1, $2);}
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
  while (
    i < sizeof a / sizeof a[0] &&
    a[i] < n &&
    1 == millertime(a[i++], n - 1, n)
  );
  return sizeof a / sizeof a[0] == i || a[i] >= n;
}