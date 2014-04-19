/* data type representing a symbol */
struct symbol {
  char *name;
	char *value;
	int type;
	int scope;
  struct symbol *next;
};
typedef struct symbol symbol;

/* the symbol table */
symbol *sym_table;

/* methods to insert and retrieve a symbol */
symbol *addsym (char const *, int);
symbol *getsym (char const *);
