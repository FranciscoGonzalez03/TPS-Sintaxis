%{
#include <stdio.h>
#include "tokens.h"
%}

%option yylineno
%option noinput
%option nounput
%option header-file="archivo.h"
%option outfile="scanner.c"

identificador {identificador_noDigito}({digito}|{identificador_noDigito})*
digito [0-9]
identificador_noDigito [a-zA-Z]
digitoNoCero [1-9]
funcion sin|cos|tan|asin|acos|atan|sqrt|log
constante {constante_decimal}|{constante_real}
constante_decimal {digitoNoCero}({digito})*
constante_real {constante_fraccionaria}{parte_exponencial}?|{constante_entera}{parte_exponencial}
constante_fraccionaria {constante_entera}?\.{constante_entera}|{constante_entera}\.
parte_exponencial e[+-]?{constante_entera}|E[+-]?{constante_entera}
constante_entera {digito}+
operador_asignacion ({operador_aditivo}|{operador_multiplicativo})?=
operador_aditivo [+-]
operador_multiplicativo [*/]
caracter_invalido [@#$%;]
inval   [0-9.]
espacio [[:space:]]

%%

var return VAR;
cte return CONSTANTE;
salir return SALIR;
{constante} return NUMERO;
{funcion} return FUNCION;
{identificador} return IDENTIFICADOR;
"("															return PARA;
")"															return PARC;
"+"															return MAS;
"-"															return MENOS;
"*"															return MULT;
"/"															return DIV;
"^"															return EXP;
({digitoNoCero}({digito}|{identificador_noDigito})*)|({constante_fraccionaria}{inval}+({constante_fraccionaria}|{identificador_noDigito})*) {printf("Error léxico: constante inválida: %s", yytext);}
{identificador_noDigito}({identificador_noDigito}|{caracter_invalido})+ {printf("Error léxico: identificador inválido: %s", yytext);}
({identificador_noDigito}|{caracter_invalido})({identificador_noDigito}|{caracter_invalido}|{constante})* {printf("Error léxico: cadena desconocida: %s", yytext);}
"="	return IGUAL;
"+="	return ASIGMAS;
"-="	return ASIGMENOS;
"*="	return ASIGPOR;
"/="	return ASIGDIV;
\n      {printf("\n"); return NL;}
. ; 

%%