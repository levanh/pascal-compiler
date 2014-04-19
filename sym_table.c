#include <stdlib.h>
#include <string.h>
#include "sym_table.h"
     
/*
     symbol *
     addsym (char const *sym_name, int sym_type)
     {
       symbol *ptr = (symbol *) malloc (sizeof (symbol));
       ptr->name = (char *) malloc (strlen (sym_name) + 1);
       strcpy (ptr->name,sym_name);
       ptr->type = sym_type;
       ptr->next = (struct symbol *)sym_table;
       sym_table = ptr;
       return ptr;
     }
     
     symbol *
     getsym (char const *sym_name)
     {
       symbol *ptr;
       for (ptr = sym_table; ptr != (symbol *) 0;
            ptr = (symbol *)ptr->next)
         if (strcmp (ptr->name, sym_name) == 0)
           return ptr;
       return 0;
     }
*/
