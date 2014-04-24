%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sym_table.h"
#define YYDEBUG 1

extern symbol *sym_table;
char *code_string;
char *return_type;
int current_scope = 0;
char *current_indent;

// Prototypes
extern int yylex();
extern int yyerror(char *message);
char *concat_3(char *s1, char *s2, char *s3);
void set_indent(int scope);

%}

%union
{
	char *string;
}

%start program
%token<string>
PROGRAM PROCEDURE _FUNCTION _BEGIN END
LBRACE RBRACE VAR INT REAL BOOL
IF NOT THEN ELSE WHILE DO
READLN WRITELN
ASSIGN PLUS MINUS DIV TIMES MOD
LT GT EQ LEQ GEQ NEQ
COMMA COLON SEMIC DOT
INT_NBR FLOAT_NBR IDENTIFIER

%left LT GT EQ LEQ GEQ NEQ 
%left PLUS MINUS
%left TIMES DIV MOD
%right THEN ELSE

%type<string>
program program_header procedures_and_functions global_declaration_block main_block
declaration_block declaration_list declaration identifier_list
procedure function procedure_header function_header parameter_list parameter
instruction_block instruction_list instruction
control_structure if_stmt else_stmt condition test
while_loop write_function read_function assignment function_call
expression cmp_oper type

%%
program : program_header procedures_and_functions global_declaration_block main_block
{ char *tmp = "#include <stdio.h>\n#include <stdlib.h>";
	$$ =  concat_3($2, $3, $4);
	code_string = concat_3(tmp, "\n", $$); };

program_header : PROGRAM IDENTIFIER SEMIC ;

procedures_and_functions : /* empty */ { $$ = " "; }
												 | procedures_and_functions procedure { $$ = concat_3($1, "\n", $2); }
												 | procedures_and_functions function { $$ = concat_3($1, "\n", $2); }
												 ;

procedure : procedure_header declaration_block instruction_block
{ char *tmp = concat_3($1, $2, $3);
	char *tmp2 = "}\n";
	$$ = concat_3(tmp, "", tmp2); };


function : function_header declaration_block instruction_block
{ char *tmp = concat_3($1, $2, $3);
	char *tmp2 = concat_3("return ", return_type, ";\n}\n");
	set_indent(++current_scope);
	$$ = concat_3(tmp, current_indent, tmp2);
	set_indent(--current_scope); };

procedure_header : PROCEDURE IDENTIFIER LBRACE parameter_list RBRACE SEMIC
{ char *tmp = concat_3("(", $4, ") {\n");
	char *tmp2 = concat_3("void", " ", $2);
	$$ = concat_3(tmp2, "", tmp); };

function_header : _FUNCTION IDENTIFIER LBRACE parameter_list RBRACE COLON type SEMIC
{ char *tmp = concat_3("(", $4, ") {\n");
	char *tmp2 = concat_3($7, " ", $2);
	$$ = concat_3(tmp2, "", tmp);

	return_type = $2; };

parameter_list : /* empty */ { $$ = " "; }
							 | parameter_list SEMIC parameter { $$ = concat_3($1, "; ", $3); }
							 | parameter
							 ;

parameter : identifier_list COLON type
{ $$ = concat_3($3, " ", $1); } ;

identifier_list : identifier_list COMMA IDENTIFIER { $$ = concat_3($1, ", ", $3); }
								| IDENTIFIER 
								;

declaration_block : /* empty */ { $$ = ""; };
									| VAR declaration_list { $$ = $2; };

declaration_list : declaration_list declaration { $$ = concat_3($1, $2, ";\n"); }
								 | declaration { $$ = concat_3($1, "", ";\n"); }
								 ;

declaration : identifier_list COLON type SEMIC
{ set_indent(++current_scope);
	char *tmp = concat_3($3, " ", $1); 
	$$ = concat_3(current_indent, "", tmp); 
	set_indent(--current_scope); }; 

instruction_block : BEGIN_TOK instruction_list END_TOK SEMIC
{ $$ = $2; };

BEGIN_TOK : _BEGIN { set_indent(++current_scope); };
END_TOK : END { set_indent(--current_scope); };

global_declaration_block : /* empty */ { $$ = "\nint main(int argc, char *argv[]) {\n"; };
												 | VAR declaration_list
{ $$ = concat_3("\nint main(int argc, char *argv[]) {\n", "", $2); };

main_block : BEGIN_TOK instruction_list END_TOK DOT
{	set_indent(++current_scope);
	char *tmp = concat_3("\n", current_indent, "return EXIT_SUCCESS;\n}");
	$$ = concat_3($2, "", tmp); };



instruction_list : /* empty */ { $$ = ""; };
								 | instruction_list instruction SEMIC
{ $$ = concat_3($1, $2, "\n"); };

instruction : assignment { $$ = concat_3(current_indent, $1, ";"); }
						| control_structure { $$ = concat_3(current_indent, $1, ""); }
						| write_function { $$ = concat_3(current_indent, $1, ";"); }
						| read_function { $$ = concat_3(current_indent, $1, ";"); }
						| function_call { $$ = concat_3(current_indent, $1, ";"); }
						;

assignment : IDENTIFIER ASSIGN expression
{ $$ = concat_3($1, " = ", $3); };

expression : expression PLUS expression { $$ = concat_3($1, " + ", $3); }
					 | expression MINUS expression { $$ = concat_3($1, " - ", $3); }
					 | expression DIV expression { $$ = concat_3($1, " / ", $3); }
					 | expression TIMES expression { $$ = concat_3($1, " * ", $3); }
					 | expression MOD expression { $$ = concat_3($1, " % ", $3); }
					 | IDENTIFIER
					 | INT_NBR
					 | FLOAT_NBR
					 ;

control_structure : if_stmt
									| while_loop
									;

if_stmt : IF condition THEN instruction_block else_stmt
{ char *tmp = concat_3("if", $2, " {\n"); 
	char *tmp2 = concat_3(current_indent, $4, "");
	char *tmp3 = concat_3(tmp2, current_indent, "}\n");
	$$ = concat_3(tmp, tmp3, $5); }
				| IF condition THEN instruction else_stmt
{ char *tmp = concat_3("if", $2, "\n"); 
	char *tmp2 = concat_3(current_indent, $4, "\n");
	$$ = concat_3(tmp, tmp2, $5); }
				| IF condition THEN instruction_block
{ char *tmp = concat_3("if", $2, " {\n"); 
	char *tmp2 = concat_3(current_indent, $4, "");
	char *tmp3 = concat_3(tmp2, current_indent, "}\n");
	$$ = concat_3(tmp, tmp3, ""); }
				| IF condition THEN instruction
{ char *tmp = concat_3("if", $2, "\n"); 
	char *tmp2 = concat_3(current_indent, $4, "\n");
	$$ = concat_3(tmp, tmp2, ""); };

else_stmt : ELSE instruction_block
{ char *tmp = concat_3("else {\n", "", $2);
	char *tmp2 = concat_3(current_indent, "", "}\n");
	$$ = concat_3(current_indent, tmp, tmp2); }
					| ELSE instruction
{ char *tmp = concat_3("else\n", "", $2);
	$$ = concat_3(current_indent, "", tmp); };

condition : test {$$ = concat_3("(", $1, ")"); }
					| NOT LBRACE test RBRACE {$$ = concat_3("(!", $3, ")"); };

test : expression cmp_oper expression { $$ = concat_3($1, $2, $3); };

while_loop : WHILE condition DO instruction_block
{ char *tmp = concat_3("while ", $2, " {\n");
	char *tmp2 = concat_3($4, "", current_indent);
	$$ = concat_3(tmp, tmp2, "}\n"); }
					 | WHILE condition DO instruction
{ char *tmp = concat_3("while ", $2, "\n");
	char *tmp2 = concat_3(current_indent, $4, "\n");
	$$ = concat_3(tmp, tmp2, ""); };


write_function : WRITELN LBRACE function_call RBRACE
{ $$ = concat_3("printf(\"%d\", ", $3, ")"); }
					 | WRITELN LBRACE IDENTIFIER RBRACE
{ $$ = concat_3("printf(\"%d\", ", $3, ")"); };

read_function : READLN LBRACE IDENTIFIER RBRACE
{ $$ = concat_3("scanf(\"%d\", &", $3, ")"); };

function_call : IDENTIFIER LBRACE identifier_list RBRACE
{ char *tmp = concat_3("(", $3, ")");
	$$ = concat_3($1, "", tmp); };

cmp_oper : LT  { $$ = " < "; }
				 | LEQ { $$ = " <= "; }
				 | GT  { $$ = " > "; }
				 | GEQ { $$ = " >= "; }
				 | EQ  { $$ = " == "; }
				 | NEQ { $$ = " != "; }
				 ;

type : INT  { $$ = "int"; }
		 | REAL { $$ = "double"; }
		 | BOOL { $$ = "bool"; }
		 ;

%%
// Allocates new memory space and concatenates 3 strings
char *concat_3(char *s1, char *s2, char *s3) {
	char *s = malloc(strlen(s1) + strlen(s2) + strlen(s3) + 1);

	strcat(s, s1);
	strcat(s, s2);
	strcat(s, s3);

	return s;
}

// Sets indentation string
void set_indent(int scope) {
	int size = 2*scope;
	char *s = malloc(size + 1);

	for(int i = 0; i < size; i++)
		strcat(s, " ");
	strcat(s, "\0");

	current_indent = malloc(strlen(s));
	strcpy(current_indent, s);
}

// Creates a file and writes content of C program code into it
void write_into_file(char *name, char *string) {
	FILE *output;

	// Sets output file extension to .c
	char *filename = malloc(strlen(name));
	strncpy(filename, name, strlen(name) - 4);
	strcat(filename, ".c\0");

	// Writing into file
	if(code_string != NULL) {
		printf("Writing into file...\n");
		output = fopen(filename, "w");
		fprintf(output, "%s", code_string);
		printf("Done writing into '%s'.\n", filename);
	}
	else
		exit(1);
	fclose(output);
}

// main
int main(int argc, char *argv[]) {
	extern FILE *yyin;

	// Opening input file
	if (argc > 1) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL) {
			printf("Couldn't open file.\n");
			return -1;
		}
	}

	// Parsing input file
	printf("\n--------------------------------------------------\n");
	printf("Parsing '%s'...\n", argv[1]);
	yyparse();
  printf("Done parsing.");
	printf("\n--------------------------------------------------\n");

	// Printing code
	if(yynerrs == 0) {
		//print_sym_table();
		write_into_file(argv[1], code_string);
		printf("Generated code:");
		printf("\n--------------------------------------------------\n");
		printf("%s\n", code_string);
		printf("\n--------------------------------------------------\n");
	}
}
