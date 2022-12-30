%code top{
#include <stdio.h>
#include <math.h>
#include "archivo.h"
#include "calc.h"

symrec *aux;

}

%code provides{
void yyerror(const char *);
extern int yylexerrs;

struct YYSTYPE{
	double dval;
	struct symrec *idval;
};

}

%defines "parser.h"
%output "parser.c"
%define api.value.type {struct YYSTYPE}
%define parse.error verbose
%start programa

%token NL
%token<dval> NUMERO 
%token<idval> IDENTIFICADOR 
%token<idval> FUNCION
%type<dval> expresion
%type<dval> declaracion

%token VAR CONSTANTE SALIR

%token ASIGMAS "+="
%token ASIGMENOS "-="
%token ASIGPOR "*="
%token ASIGDIV "/="

%precedence '=' 
%right "+=" "-=" "*=" "/="
%left '+' '-'
%left '*' '/'
%precedence NEG
%right '^'



%%

programa		: lista-de-sentencias { if (yynerrs || yylexerrs) YYABORT; else YYACCEPT; }
			;
lista-de-sentencias	: lista-de-sentencias sentencia
			| %empty
			;
sentencia 		: NL
			| declaracion NL 
			| expresion NL
			| error NL
			| SALIR NL
			;
declaracion		: CONSTANTE IDENTIFICADOR '=' expresion  { aux=getsym($2->nombre); if (aux) { printf("Es una constante, no se puede redeclarar"); YYERROR;} else { printf("%s: %f",$2->nombre,$4->valor.nro); aux=putsym($2->nombre,TYP_CTE); $$=($2->valor.nro)=$4->valor.nro ;} }
			| VAR IDENTIFICADOR 		   	 { aux=getsym($<idval>2); if (aux) { $$=(aux->valor.nro)    ;} else { printf("%s: 0 \n",$2); $$=0; } }
			
			//{ aux=getsym($2->nombre); if (aux) { printf("Se esta redeclarando la variable"); YYERROR;} else { printf("%s: 0",$2); $$=0; } }
			| VAR IDENTIFICADOR '=' expresion 	 { aux=getsym($<idval>2); if (aux) { $$=(aux->valor.nro)=$4 ;} else { printf("%d: %f \n",$2,$4); aux=putsym(strdup($2),TYP_VAR); $$=(aux->valor.nro)=$4 ;} }
			
			//{ aux=getsym($2->nombre); if (aux) { printf("Se esta redeclarando la variable") ; YYERROR;} else { printf("%s: %f",$2,$4); aux=putsym($2->nombre,TYP_VAR); $$=($2->valor.nro)=$4 ;} }
			;


			// Gramatica Achatada //
expresion		: expresion '+' expresion 		{ $$ = $1 + $3;                    }
			| expresion '-' expresion 		{ $$ = $1 - $3;                    }
			| expresion '*' expresion 		{ $$ = $1 * $3;                    }
			| expresion '/' expresion 		{ $$ = $1 / $3;                    }
			| expresion '^' expresion 		{ $$ = pow ($1, $3);               }
			| '-' expresion %prec NEG 		{ $$ = -$2;                        }
			| '(' expresion ')' 	  		{ $$ = $2;                         }
			| FUNCION '(' expresion ')'		{ $$ = $1->valor.func($3);         }
			| IDENTIFICADOR 	  		{ aux=getsym($1->nombre); if (aux) { $$ = (aux->valor.nro)    ;} else {printf("error no esta declarado\n> "); YYERROR;}}
			| NUMERO 		  		{ $$ = $1; }
			| IDENTIFICADOR '=' expresion  	

			| IDENTIFICADOR ASIGMAS expresion	{aux = getsym($1->nombre); if (! aux) {printf("error\n> "); YYERROR;} if (! aux->tipo) $$ = aux->valor.nro = aux->valor.nro + $3;} 
			| IDENTIFICADOR ASIGMENOS expresion	

			| IDENTIFICADOR ASIGPOR expresion	

			| IDENTIFICADOR ASIGDIV expresion	

			;
//{aux = getsym($1); if (! aux) {printf("error\n> "); YYERROR;} if (! aux->tipo) $$ = aux->valor.nro = aux->valor - $3;} 
%%