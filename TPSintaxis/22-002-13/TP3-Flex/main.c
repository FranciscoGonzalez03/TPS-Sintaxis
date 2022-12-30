#include <stdio.h>
#include <stdlib.h>
#include "archivo.h"
#include "tokens.h"

char *token_names[] = {"", "NUMERO", "IDENTIFICADOR", "FUNCION", "CONSTANTE", "SALIR", "VAR", "ASIGMAS", "ASIGMENOS", "ASIGPOR", "ASIGDIV"};
int main() {
	enum token t;
	while ((t = yylex()) != FDT)
		printf("Token: %s\t\tlexema: %s\n", token_names[t], yytext);
	printf("Fin de archivo");
	return 0;
}