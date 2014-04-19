%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "sym_table.h"

%}

%token NUMBER
%token PROG PROC _FUNC _BEGIN END
%token VAR INT REAL BOOL ASSIGN
%token DIV MOD LT LEQ GT GEQ EQ NEQ
%token IF THEN ELSE DO
%token READLN WRITELN
%token LBRACE RBRACE COMMA COLON SEMI

%%
	empty : ;
%%
int main(void) {
  yyparse();
}

int yyerror(char *message, int line) {
  printf("Error: %s (line: %d).\n", message, line);
}


