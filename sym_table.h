/* symbol type enum */
enum sym_type{
	UNDEFINED_T,
	FUNCTION_T,
	PROCEDURE_T,
	INT_T,
	FLOAT_T,
	BOOL_T,
	CHAR_T
};
typedef enum sym_type sym_type;

/* symbol data type */
struct symbol {
	char *name;
	union{
		char* value;
		char* parameters; /* if symbol is a function/procedure */
	}data;
	sym_type type;
	int scope;
	int line_declaration;
  struct symbol *next;
};
typedef struct symbol symbol;

/* symbol insertion method */
void add_sym (char *sym_name, char *sym_value);

/* symbol table print method */
void print_sym_table();
