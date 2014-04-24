%{
#include <stdio.h>
#include "parse.tab.h"
int comment_line;
int line_no = 1;
extern int errors_count;
%}

DIGIT          [0-9]
LETTER         [a-zA-Z]
%x COMMENT

%option case-insensitive
%option noyywrap

%%

"//"[^\n]*
"{" {
  comment_line = line_no;
  BEGIN(COMMENT);
}
<COMMENT>{
  "}" { BEGIN(INITIAL); }
  <<EOF>> { yyerror("Unended comment!");
            return EOF; }
	.
}															

"PROGRAM"                     { yylval.string = strdup(yytext); return (PROGRAM); }
"PROCEDURE"                   { yylval.string = strdup(yytext); return (PROCEDURE); }
"FUNCTION"                    { yylval.string = strdup(yytext); return (_FUNCTION); }
"BEGIN"                       { yylval.string = strdup(yytext); return (_BEGIN); }
"END"                         { yylval.string = strdup(yytext); return (END); }

"("                           { yylval.string = strdup(yytext); return (LBRACE); }
")"                           { yylval.string = strdup(yytext); return (RBRACE); }

"VAR"                         { yylval.string = strdup(yytext); return (VAR); }
"REAL"                        { yylval.string = strdup(yytext); return (REAL); }
"INTEGER"                     { yylval.string = strdup(yytext); return (INT); }
"BOOLEAN"                     { yylval.string = strdup(yytext); return (BOOL); }

"IF"                          { yylval.string = strdup(yytext); return (IF); }
"NOT"                         { yylval.string = strdup(yytext); return (NOT); }
"THEN"                        { yylval.string = strdup(yytext); return (THEN); }
"ELSE"                        { yylval.string = strdup(yytext); return (ELSE); }
"WHILE"                       { yylval.string = strdup(yytext); return (WHILE); }
"DO"                          { yylval.string = strdup(yytext); return (DO); }

"READLN"                      { yylval.string = strdup(yytext); return (READLN); }
"WRITELN"                     { yylval.string = strdup(yytext); return (WRITELN); }

":="                          { yylval.string = strdup(yytext); return (ASSIGN); }
"+"                           { yylval.string = strdup(yytext); return (PLUS); }
"-"                           { yylval.string = strdup(yytext); return (MINUS); }
"/"                           { yylval.string = strdup(yytext); return (DIV); }
"*"                           { yylval.string = strdup(yytext); return (TIMES); }
"MOD"                         { yylval.string = strdup(yytext); return (MOD); }

"<"                           { yylval.string = strdup(yytext); return (LT); }
">"                           { yylval.string = strdup(yytext); return (GT); }
"="              	            { yylval.string = strdup(yytext); return (EQ); }
"<="                          { yylval.string = strdup(yytext); return (LEQ); }
">="                          { yylval.string = strdup(yytext); return (GEQ); }
"<>"                          { yylval.string = strdup(yytext); return (NEQ); }

","                           { yylval.string = strdup(yytext); return (COMMA); }
":"                           { yylval.string = strdup(yytext); return (COLON); }
";"                           { yylval.string = strdup(yytext); return (SEMIC); }
"."                           { yylval.string = strdup(yytext); return (DOT); }

{DIGIT}+											{ yylval.string = strdup(yytext); return(INT_NBR); }
({DIGIT}+"."{DIGIT}+)					{ yylval.string = strdup(yytext); return(FLOAT_NBR); }
{LETTER}({DIGIT}|{LETTER})*   { yylval.string = strdup(yytext); return(IDENTIFIER); }

[ \t]*                        
\n 														{ line_no++; }
.                             { yyerror("Unrecognized input"); }

%%

int yyerror(char *message) {
  printf("\nError: %s (l: %d).\n", message, line_no);
}
