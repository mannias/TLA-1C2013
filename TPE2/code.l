%{
#include <stdio.h>
#include "y.tab.h"
int varindex(char* name);
%}

vartype "int"|"char"|"string"|"float"|"boolean"
retype {vartype}|"void"

%%
vartype							{yylval = yytext; return VARTYPE;}
retype							{yyval = yytext; return RETYPE;}
[A-Z|a-z][A-Z|a-z|0-9]*			{yylval = varindex(yytext);; retuen NAME;}
[0-9]+ 							{yylval = atoi(yytext); return NUMBER; }
"=="							{return EQQ;}
"!="							{return NEQ;}
"&"								{return MILL;}
cycletype						{yylval = yytext; return CYCLE;}
","								{return COMA;}
return							{return RETURN;}
.								{return yytext[0];}
"if"							{return IF;}
"while"							{return WHILE;}
"for"							{return FOR;}
"++"							{return SUMM;}
"--"							{return LESS;}
[ \t]+							/* ignorar espacios */;
\n 								/* ignorar saltos de linea */;


%%


