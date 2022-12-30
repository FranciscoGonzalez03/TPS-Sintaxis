%code top{
#include <stdio.h>
#include <math.h>
#include "archivo.h"
}

%code provides{
void yyerror(const char *);
extern int yylexerrs;
}

%defines "parser.h"
%output "parser.c"
%define api.value.type {char *}
%define parse.error verbose
%start programa

%token NL
%token NUMERO IDENTIFICADOR FUNCION

%token VAR CONSTANTE SALIR

%token ASIGMAS "+="
%token ASIGMENOS "-="
%token ASIGPOR "*="
%token ASIGDIV "/="

%right '=' 
%right ASIGMAS ASIGMENOS ASIGPOR ASIGDIV
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
			| expresion NL			 {printf("Expresion \n");}
			| error NL
			| SALIR NL
			;
declaracion		: CONSTANTE IDENTIFICADOR '=' expresion  {printf("Define ID como Constante\n");}
			| VAR IDENTIFICADOR 		   	 {printf("Define ID como Variable\n");}
			| VAR IDENTIFICADOR '=' expresion 	 {printf("Define ID como Variable con valor inicial\n");}
			;

			// Gramatica Achatada //
expresion		: expresion '+' expresion 		{printf("Suma\n");}
			| expresion '-' expresion 		{printf("Resta\n");}
			| expresion '*' expresion 		{printf("Multiplicacion\n");}
			| expresion '/' expresion 		{printf("Division\n");}
			| expresion '^' expresion 		{printf("Potenciacion\n");}
			| '-' expresion %prec NEG 		{printf("Cambio Signo\n");}
			| '(' expresion ')' 	  		{printf("Cierra Parentesis\n");}
			| FUNCION '(' expresion ')'		{printf("Funcion\n");}
			| IDENTIFICADOR 	  		{printf("ID\n");}
			| NUMERO 		  		{printf("Numero\n");}
			| IDENTIFICADOR '=' expresion	  	{printf("Asignacion\n");}
			| IDENTIFICADOR ASIGMAS expresion	{printf("Asignacion con Suma\n");}
			| IDENTIFICADOR ASIGMENOS expresion	{printf("Asignacion con Resta\n");}
			| IDENTIFICADOR ASIGPOR expresion	{printf("Asignacion con Mult\n");}
			| IDENTIFICADOR ASIGDIV expresion	{printf("Asignacion con Div\n");}
			;

%%
/* Informar ocurrencia de un error */
void yyerror(const char *s){ // si no hubiese estado definido, directamente el yyerror imprimiría: "syntax error" solamente
    printf("Línea #%d: %s\n", yylineno, s);
    return;
}