%{

%}

VARTYPE "INT"|"CHAR"|"STRING"|"FLOAT"|"BOOLEAN"
VARNAME [A-Z|a-z][A-Z|a-z|0-9]*
VARIABLE [A-Z|a-z]+|{DIGIT}
SPACE " "+
RETTYPE {VARTYPE}|"VOID"
VARDEF {VARTYPE}{SPACE}{VARNAME}
MOREVARS ","{SPACE}{VARDEF}
SEVDEF {VARDEF}{MOREVARS}*|"VOID"|""
BOPERATORS "+"|"-"|"*"|"/"|"%"
ELEMENT {DIGIT}|{VARNAME}
OPERATIONS {ELEMENT}{SPACE}{BOPERATORS}{SPACE}{ELEMENT}
MOREELEMS ","{SPACE}{ELEMENT}
SEVVAR {ELEMENT}{MOREELEMS}*|""
FUNCTION {VARNAME}"("{SEVVAR}")"
COMPARATOR ">"|"<"|"=="|">="|"<="|"!="
COMPARATION {ELEMENT}{SPACE}{COMPARATOR}{SPACE}{ELEMENT}|{VARNAME}
VARIABLEOP "++"|"--"
DIGIT [0-9]+



%s FUNCTION
%s CONDITION
%s CYCLE
%s FORCYCLE

%%
<INITIAL>{RETTYPE}{SPACE}"MAIN("{SEVDEF}"){" {printf("Abro el main"); BEGIN FUNCTION;}
<INITIAL>{RETTYPE}{SPACE}{VARNAME}"("{SEVDEF}"){" {printf("Abro una funcion"); BEGIN FUNCTION;}
<FUNCTION>"}" {printf("Cierro Funcion"); BEGIN INITIAL;}

"IF("{COMPARATION}"){" {printf("Comparacion"); BEGIN CONDITION;}
<CONDITION>"}" {printf("Cierro Condicion"); BEGIN FUNCTION;} 

"WHILE("{COMPARATION}"){" {printf("While"); BEGIN CYCLE;}
<CYCLE>"}" {printf("Cierro Ciclo"); BEGIN FUNCTION;}

"FOR("{VARNAME}{SPACE}"="{SPACE}{ELEMENT}";"{COMPARATION}";"{VARNAME}{VARIABLEOP}"){" {printf("For Cycle"); BEGIN FORCYCLE;}
<FORCYCLE>"}" {printf("Cierro For"); BEGIN FUNCTION;}

{VARTYPE}{SPACE}{VARNAME} {printf("Variable creada");}
{VARNAME}{SPACE}"="{SPACE}{FUNCTION} {printf("Variable seteada con Funcion");}
{VARNAME}{SPACE}"="{SPACE}{OPERATIONS} {printf("Variable seteada con Operacion");}
{VARNAME}{SPACE}"="{SPACE}{ELEMENT} {printf("Variable seteada con Elemento");}
%%