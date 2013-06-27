%{
	#include "code.h"
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
<INITIAL>{RETTYPE}{SPACE}"MAIN("{SEVDEF}"){" {printf("Abro el main\n"); push(1); BEGIN FUNCTION;}
<INITIAL>{RETTYPE}{SPACE}{VARNAME}"("{SEVDEF}"){" {printf("Abro una funcion\n"); push(1); BEGIN FUNCTION;}
<FUNCTION>"}" {printf("Cierro Funcion\n"); BEGIN INITIAL;}

"IF("{COMPARATION}"){" {printf("Comparacion\n"); push(2); BEGIN CONDITION;}
<CONDITION>"}" {printf("Cierro Comparacion\n"); continueExecution();} 

"WHILE("{COMPARATION}"){" {printf("While\n"); push(3); BEGIN CYCLE;}
<CYCLE>"}" {printf("Cierro While\n"); continueExecution();}

"FOR("{VARNAME}{SPACE}"="{SPACE}{ELEMENT}";"{COMPARATION}";"{VARNAME}{VARIABLEOP}"){" {printf("For Cycle\n"); push(4); BEGIN FORCYCLE;}
<FORCYCLE>"}" {printf("Cierro For Cycle\n"); continueExecution();}

{VARTYPE}{SPACE}{VARNAME} {printf("Variable creada\n");}
{VARNAME}{SPACE}"="{SPACE}{FUNCTION} {printf("Variable seteada con Funcion\n");}
{VARNAME}{SPACE}"="{SPACE}{OPERATIONS} {printf("Variable seteada con Operacion\n");}
{VARNAME}{SPACE}"="{SPACE}{ELEMENT} {printf("Variable seteada con Elemento\n");}

\n {count++;}
. {newSyntaxError();}
%%

void newSyntaxError(){
	switch(pop()){
		case 0: printf("Error fuera de las funciones\n"); break;
		case 1: printf("Error dentro de las funciones\n"); break;
		case 2: printf("Error dentro del if\n"); break;
		case 3: printf("Error dentro del while\n"); break;
		case 4: printf("Error dentro del for\n"); break;
		default: printf("Linea: %d\n", count+1); break;
	}
	printf("Linea: %d\n", count+1);
	exit(1);
}

void push(int n){
	Node* aux = malloc(sizeof(Node));
	aux->status = n;
	aux->next = base;
	base = aux;
}

int pop(){
	if(base != NULL){
		Node* aux = base;
		base= base->next;
		return aux->status;
	}
	return 0;
}

void continueExecution(){
	pop(); //pop myself
	switch(pop()){
		case 1: push(1); BEGIN FUNCTION; break;
		case 2: push(2); BEGIN CONDITION; break;
		case 3: push(3); BEGIN CYCLE; break;
		case 4: push(4); BEGIN FORCYCLE; break;
		default: break;
	}
}

