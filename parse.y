%{
#include <stdio.h>
#include <stdlib.h>
#include "sym_table.h"
#define YYERROR_VERBOSE 1
%}

%start program
%token PROGRAM PROCEDURE _FUNCTION _BEGIN END
%token VAR INT REAL BOOL 
%token ASSIGN MOD LEQ GEQ NEQ
%token IF NOT THEN ELSE WHILE DO
%token READLN WRITELN
%token LBRACE RBRACE
%token COMMA COLON SEMIC DOT
%token NUMBER IDENTIFIER

%left '<' '>' '=' LEQ GEQ NEQ
%left '+' '-'
%left '*' '/'

%%
program : program_header procedures_and_functions declaration_block main_block
				;
program_header : PROGRAM IDENTIFIER SEMIC
							 ;
declaration_block : /* empty */
									| VAR declaration_list declaration
									;
declaration_list : /* empty */
								 | declaration_list declaration
								 ;
declaration : identifier_list COLON type SEMIC
						;
identifier_list : identifier_list COMMA IDENTIFIER
								| IDENTIFIER
								;
procedures_and_functions : /* empty */
												 | procedures_and_functions procedure
												 | procedures_and_functions function
												 ;

procedure : procedure_header declaration_block instruction_block
					;
procedure_header : PROCEDURE IDENTIFIER LBRACE parameter_list RBRACE SEMIC
								 ;
function : function_header declaration_block instruction_block
         ;
function_header : _FUNCTION IDENTIFIER LBRACE parameter_list RBRACE COLON type SEMIC
								;
parameter_list : /* empty */
							 | parameter_list SEMIC parameter  
							 | parameter
							 ;
parameter : identifier_list COLON type
					;
instruction_block : _BEGIN instruction_list END SEMIC
		  ;
main_block : _BEGIN instruction_list END DOT { printf("\n Done parsing. Program recognized as syntaxically correct.\n"); }
					 ;
instruction_list : /* empty */
								 | instruction_list instruction SEMIC
								 ;





control_structure : if_then_else_block
									| if_then_block
									| while_loop
									;

if_then_else_block : IF condition THEN instruction_block ELSE instruction_block
									 | IF condition THEN instruction ELSE instruction_block
									 | IF condition THEN instruction_block ELSE instruction
									 | IF condition THEN instruction ELSE instruction
									 ;
if_then_block : IF condition THEN instruction_block
							| IF condition THEN instruction
							;
condition : test
					| NOT LBRACE test RBRACE
					;
test : expression cmp_oper expression
		 ;
while_loop : WHILE condition DO instruction_block
					 | WHILE condition DO instruction
					 ;





write_smth : WRITELN LBRACE function_call RBRACE
					 | WRITELN LBRACE IDENTIFIER RBRACE
					 ;

read_smth : READLN LBRACE IDENTIFIER RBRACE
					;





instruction : assignment
						| control_structure
						| function_call
						| write_smth
						| read_smth
						;
assignment : IDENTIFIER ASSIGN expression
					 ;
function_call : IDENTIFIER LBRACE identifier_list RBRACE
							;
expression : expression oper expression
					 | IDENTIFIER
					 | NUMBER
					 ;
oper : '+'
		 | '-'
		 | '*'
		 | '/'
		 | MOD
		 ;
cmp_oper : '<'
				 | LEQ
				 | '>'
				 | GEQ
				 | '='
				 | NEQ
				 ;
type : INT
		 | REAL
		 | BOOL
		 ;
%%
int main(void) {
	printf("Parsing... ");
	return yyparse();
}

