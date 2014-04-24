A basic Pascal-to-C compiler
=============================

About
-----
This program scans an easy Pascal program (more complex data types such as strings and arrays, or control structures such as for loops are not considered here for the sake of simplicity) and translates it into a syntaxically equivalent C program.

It makes use of both [flex](http://en.wikipedia.org/wiki/Flex_lexical_analyser) and yacc/[bison](http://en.wikipedia.org/wiki/GNU_bison) to generate an analyzer and parser, respectively.

The parser should be able to tell whether the Pascal program is syntaxically correct according to its grammar rules, and whether it's semantically correct, with the help of a symbol table.

Running
-------
+ See makefile for how to compile and clean source files
+ Once you have the executable, you can run it with one of the test Pascal files as such:

> ./pascal\_compiler test/program\_name.pas

Issues / TODO
-------------
+ Semantic analysis
