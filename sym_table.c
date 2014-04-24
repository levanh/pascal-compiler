#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "sym_table.h"

symbol *sym_table = NULL;
extern int line_no;

// Adds a symbol into the table
void add_sym (char *sym_name, char *sym_value) {
	symbol *tmp = malloc (sizeof(symbol));

	tmp->name = malloc (strlen(sym_name) + 1);
	strcpy (tmp->name, sym_name);

	tmp->data.value = malloc (strlen(sym_value) + 1);
	strcpy (tmp->data.value, sym_value);

	tmp->line_declaration = line_no;

	tmp->next = NULL;

	// Loop through list until we arrive at its end, then add new symbol
	if(sym_table == NULL)
		sym_table = tmp;
	else {
		symbol *cursor = sym_table;
		while(cursor->next)
			cursor = cursor->next;
		cursor->next = tmp;
	}
}

// Prints the symbol table
void print_sym_table() {
	printf("\nSymbol table:\n");
	symbol *cursor = sym_table;
	while(cursor) {
		printf("[name = %s, value = %s, scope = %d, line = %d]\n", cursor->name, cursor->data.value, cursor->scope, cursor->line_declaration);
		cursor = cursor->next;
	}
}
