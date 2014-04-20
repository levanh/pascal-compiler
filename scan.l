/***** DEFINITION SECTION *****/
%{
#include <stdio.h>
#include "parse.tab.h";
#include "sym_table.h"
int comment_line;
%}

DIGIT					[0-9]
LETTER        [a-zA-Z]
%x COMMENT

%option noyywrap
%option yylineno
%% /***** RULES SECTION *****/
"//"[^\n]* /* Eat up one-line // comments */
"{" { /* Match { comments }, possibly spanning over several lines */
	comment_line = yylineno;
	BEGIN(COMMENT);
}
<COMMENT>{
	"}" { BEGIN(INITIAL); }
	<<EOF>> { yyerror("Unended comment!", comment_line);
						return EOF;}
}




"PROGRAM" 										return (PROG);
"PROCEDURE" 									return (PROC);
"FUNCTION" 										return (_FUNC);
"BEGIN" 											return (_BEGIN);
"END" 												return (END);

"VAR" 												return (VAR);
"REAL"												return (REAL);
"INTEGER" 										return (INT);
"BOOLEAN" 										return (BOOL);

":="			 										return (ASSIGN);
"DIV" 												return (DIV);
"MOD" 												return (MOD);
"LEQ"													return (LEQ);
"GEQ"													return (GEQ);
"NEQ"													return (NEQ);

"IF"													return (IF);
"THEN"												return (THEN);
"ELSE"												return (ELSE);
"DO"													return (DO);

"READLN"											return (READLN);
"WRITELN"											return (WRITELN);


"(" 													return (LBRACE);
")" 													return (RBRACE);
","														return (COMMA);
":"														return (COLON);
";"														return (SEMIC);
"."														return (DOT);




{DIGIT}+  									  return(NUMBER);

{LETTER}({DIGIT}|{LETTER})*	  return(IDENTIFIER);

[ \t]*												/* Ignore white space */

. 														return(yytext[0]); /* Match all single otherwise unmatched characters, (mainly operators) */
%% /***** C CODE SECTION *****/
int yyerror(char *message) {
  printf("Error: %s (l: %d).\n", message, yylineno);
}
