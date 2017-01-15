%{
	#include<stdio.h>
	#include<math.h>
	#include<stdlib.h>
	int c;
	extern YYSTYPE yylval;

%}

%%
"define"	{return DEFINE;}
"quit"		{return QUIT;}
"break" 	{return BREAK;}
"length"	{return LENGTH;}
"return"	{return RETURN;}
"for"           {return FOR;}
"if"		{return IF;}
"else"		{return ELSE;}
"while"		{return WHILE;}
"sqrt"		{return SQRT;}
"scale"         {return SCALE;}
"+"|"-"|"*"|"/"|"%"		
		{return ARITHMATIC_OP;}
"^"		{return EXPONENT;}
"&&"|"||"|"!"   
		{return LOGICAL_OP;}
"&"|"|"|"~" 	{return BITWISE_OP;}
"<"|">"|">="|"<="|"=="|"!="		
		{return RELATIONAL_OP;}
"="|"+="|"-+"|"*="|"/="|"%="|"^="
		{return ASSIGNMENT_OP;}
"++"|"--"       {return INCR_DECR;}
[a-z]		{yylval.a=yytext[0]-'a';
		return IDENTIFIER;}
[0-9]+		{yylval.a=atoi(yytext);
		return NUMBER;}
"\""[a-zA-Z0-9]+"\"" 
		{for(yytext++;*yytext!="\"";yytext++)
		yylval.ch=*yylval;
		return STRING;}
"\n"		{return NEWLINE;}
<<EOF>>		{return EOF;}
.
%%
