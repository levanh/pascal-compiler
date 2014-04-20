/***** DEFINITION SECTION *****/
%{
#include <stdio.h>
#include "parse.tab.h";
#include "sym_table.h"
int comment_line;
int line = 1;
%}

DIGIT          [0-9]
LETTER        [a-zA-Z]
%x COMMENT

%option noyywrap
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
	.
}




"PROGRAM"                     return (PROGRAM);
"PROCEDURE"                   return (PROCEDURE);
"FUNCTION"                    return (_FUNCTION);
"BEGIN"                       return (_BEGIN);
"END"                         return (END);

"VAR"                         return (VAR);
"REAL"                        return (REAL);
"INTEGER"                     return (INT);
"BOOLEAN"                     return (BOOL);

":="                          return (ASSIGN);
"MOD"                         return (MOD);
"LEQ"                         return (LEQ);
"GEQ"                         return (GEQ);
"NEQ"                         return (NEQ);

"IF"                          return (IF);
"NOT"                         return (NOT);
"THEN"                        return (THEN);
"ELSE"                        return (ELSE);
"WHILE"                       return (WHILE);
"DO"                          return (DO);

"READLN"                      return (READLN);
"WRITELN"                     return (WRITELN);

"("                           return (LBRACE);
")"                           return (RBRACE);

","                           return (COMMA);
":"                           return (COLON);
";"                           return (SEMIC);
"."                           return (DOT);




{DIGIT}+                      return(NUMBER);

{LETTER}({DIGIT}|{LETTER})*   return(IDENTIFIER);

[ \t]*                        /* Ignore white space */
\n 														{ printf("l%d ", line); line++; }
.                             return(yytext[0]); /* Match all single otherwise unmatched characters, (mainly operators) */
%% /***** C CODE SECTION *****/
int yyerror(char *message) {
  printf("\nError: %s (l: %d).\n", message, line);
}
