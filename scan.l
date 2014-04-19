/***** DEFINITION SECTION *****/
%{
#include <stdio.h>
#include "parse.tab.h";
#include "sym_table.h"
int comment_line;
%}

DIGIT					[0-9]
LETTER        [a-zA-Z]
ID						(LETTER|_)(LETTER|DIGIT|_)*
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

{DIGIT}+ {					yylval = atoi( yytext );
										return(NUMBER); }




"PROGRAM" 					return (PROG);
"PROCEDURE" 				return (PROC);
"FUNCTION" 					return (_FUNC);
"BEGIN" 						return (_BEGIN);
"END" 							return (END);

"VAR" 							return (VAR);
"INTEGER" 					return (INT);
"BOOLEAN" 					return (BOOL);
":="			 					return (ASSIGN);

"DIV" 							return (DIV);
"MOD" 							return (MOD);
"LEQ"								return (LEQ);
"GEQ"								return (GEQ);
"NEQ"								return (NEQ);

"IF"								return (IF);
"THEN"							return (THEN);
"ELSE"							return (ELSE);
"DO"								return (DO);

"READLN"						return (READLN);
"WRITELN"						return (WRITELN);

"LBRACE" 						return (LBRACE);
"RBRACE" 						return (RBRACE);
"COMMA"							return (COMMA);
"COLON"							return (COLON);
"SEMI"							return (SEMI);




[ \n]+ 							/* Eat up white space */
. 									return(yytext[0]);
%%
