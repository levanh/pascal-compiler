# 'make' builds the compiler executable
# 'make clean' cleans up all generated files and executable

LEX = flex
# Define the C compiler to use
CC = gcc
CFLAGS = -std=c99
# Define the parser generator to use
YACC = bison 
YFLAGS = -d -v

# Target entries
all: pascal_compiler

pascal_compiler: parse.o scan.o sym_table.o
	$(CC) -o $@ $^
	@echo "> built $@ executable"

parse.o: parse.tab.c parse.tab.h
	$(CC) $(CFLAGS) -o $@ -c parse.tab.c

parse.tab.c parse.tab.h: parse.y sym_table.o
	$(YACC) $(YFLAGS) parse.y

scan.o: scan.c
	$(CC) -o $@ -c $^

scan.c: scan.l parse.tab.h
	$(LEX) -o $@ $^

sym_table.o: sym_table.c sym_table.h
	$(CC) $(CFLAGS) -o $@ -c sym_table.c

clean:
	rm -f *~ *.o *.output
	rm -f scan.c *.tab.* output.c pascal_compiler
	rm -f test/*.c
	@echo "> cleaned up"
