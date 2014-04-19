# 'make' builds the compiler executable
# 'make clean' cleans up all generated files and executable

LEX = flex
# Define the C compiler to use
CC = gcc
# Define the parser generator to use
YACC = bison 
YFLAGS = -d

# Target entries
all: pascal_compiler

pascal_compiler: parse.o scan.o sym_table.o
	$(CC) -o $@ $^
	@echo "> built $@ executable"

parse.o: parse.tab.c parse.tab.h
	$(CC) -o $@ -c parse.tab.c
	@echo "> built $@"

parse.tab.c parse.tab.h: parse.y sym_table.o
	$(YACC)$(YFLAGS) parse.y
	@echo "> generated parse.tab.c"
	@echo "> generated parse.tab.h"

scan.o: scan.c
	$(CC) -o $@ -c $^ -lfl
	@echo "> built $@"

scan.c: scan.l parse.tab.h
	$(LEX) -o $@ -i $^
	@echo "> generated $@"

sym_table.o: sym_table.c sym_table.h
	$(CC) -o $@ -c sym_table.c
	@echo "> built $@"

clean:
	-rm -f *~ *.o scan.c *.tab.* *.output pascal_compiler
	@echo "> cleaned up"
