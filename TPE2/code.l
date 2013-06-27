%{
#include <stdio.h>
#include "y.tab.h"
int varindex(char* name);
%}

vartype "int"|"char"|"string"|"float"|"boolean"
retype {vartype}|"void"
cycletype "if"|"while"

%%
vartype							{yylval.type = strdup(yytext); return VARTYPE;}
retype							{yylval.type = strdup(yytext); return RETYPE;}
"=="							{return EQQ;}
"!="							{return NEQ;}
"&"								{return MILL;}
cycletype						{yylval.type = strdup(yytext); return CYCLE;}
"return"						{return RETURN;}
"++"							{return SUMM;}
"--"							{return LESS;}
[ \t]+							/* ignorar espacios */;
\n 								/* ignorar saltos de linea */;
[A-Z|a-z][A-Z|a-z|0-9]*			{yylval.num = varindex(yytext); return NAME;}
[0-9]+ 							{yylval.num = atoi(yytext); return NUMBER;}
.								{return yytext[0];}

%%


