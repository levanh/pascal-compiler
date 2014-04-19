A basic Pascal-to-C converter
=============================

About
-----
This program scans an easy Pascal program (more complex data types such as strings and arrays, or control structures such as while or for loops are not considered here) and translates it into a syntaxically equivalent C program. It makes use of both lex (or flex) and yacc (or bison) to generate an analyzer and parser, respectively.

Running
-------
+ See makefile to compile
+ Once you have the executable, you can run it with one of the test Pascal files as such:
./pascal_compiler < test/program_name.pas
