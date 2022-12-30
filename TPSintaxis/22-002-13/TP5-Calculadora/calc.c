#include "calc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


symrec *putsym (char const *sym_name, int sym_type)
{
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->nombre = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->nombre,sym_name);
  ptr->tipo = sym_type;
  ptr->valor.nro = 0;
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}


symrec *getsym (char const *sym_name)
{
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->nombre, sym_name) == 0)
      return ptr;
  return 0;
}


symrec *findsym (char const *sym_name, symrec *sym_table) {
	symrec *aux = sym_table; 
	while (aux && strcmp(aux->nombre, sym_name)){
		aux = aux->next;
	}
	if(aux){
		return aux;
	}
	else
		return 0;
}