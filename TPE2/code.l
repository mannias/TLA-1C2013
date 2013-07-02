%{
#include <stdio.h>
#include "y.tab.h"
int varindex(char* name);
%}


%%
"int"							{yylval.type = strdup(yytext); return VARTYPE;}
"char"							{yylval.type = strdup(yytext); return VARTYPE;}
"print"							{return PRINT;}
"=="							{return EQQ;}
"!="							{return NEQ;}
"&"								{return MILL;}
"if"						    {yylval.type = strdup(yytext); return IF;}
"while"							{yylval.type = strdup(yytext); return WHILE;}
"getc"							{return GETC;}
"return"						{return RETURN;}
"++"							{return SUMM;}
"--"							{return LESS;}
[ \t]+							/* ignorar espacios */;
\n 								/* ignorar saltos de linea */;
[A-Z|a-z][a-z|0-9]*				{yylval.num = varindex(yytext); return NAME;}
[0-9]+ 							{yylval.num = atoi(yytext); return NUMBER;}
.								{return yytext[0];}

%%


