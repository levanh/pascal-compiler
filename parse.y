%{
#include <stdio.h>
#include <stdlib.h>
#include "sym_table.h"
#define YYERROR_VERBOSE 1
extern int line;

%}

%token PROG PROC _FUNC _BEGIN END
%token VAR INT REAL BOOL 
%token ASSIGN DIV MOD LT LEQ GT GEQ EQ NEQ
%token IF THEN ELSE DO
%token READLN WRITELN
%token LBRACE RBRACE
%token COMMA COLON SEMIC DOT
%token NUMBER IDENTIFIER

%%
program : program_header declarations main_block
				;
program_header : PROG IDENTIFIER SEMIC
							 ;
declarations : /* empty */
						 | VAR declaration_list
						 ;
declaration_list : declaration_list declaration
								 | declaration
								 ;
declaration : identifier_list COLON type SEMIC
						;
identifier_list : identifier_list COMMA IDENTIFIER
								| IDENTIFIER
								;
type : INT
		 | REAL
		 | BOOL
		 ;
main_block : _BEGIN END DOT { printf("Done.\n"); }
					 ;
%%
int main(void) {
	return yyparse();
}
