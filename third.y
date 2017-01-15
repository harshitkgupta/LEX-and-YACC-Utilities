%{
	#include<ctype.h>
	#include<stdio.h>
	#define YYSTYPE double
%}
%token NUMBER
%left '+' '-'
%left '*' '/'
%right UMINUS
%%
lines :lines expr '\n' {printf("%g\n",$2);}
	|lines '\n'
	|
	|error '\n' {yyerror("reenter previous line");yyerrok;}
	;
expr : expr '+' expr {$$=$1+$3;}
	|expr '-' expr {$$=$1-$3;}
	|expr '*' expr {$$=$1*$3;}
	|expr '/' expr {$$=$1/$3;}
	|'('expr')' {$$=$2;}
	|'-' expr %prec UMINUS {$$=-$2;}
	|NUMBER
	;
%%
#include "yy.lex.c"
