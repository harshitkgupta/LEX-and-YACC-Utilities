%{
	#include<stdio.h>
	#include<stdlib.h>
	#include"y.tab.h"
	int c;
	extern YYSTYPE yylval;
	
%}
%%
"sqrt"|"SQRT" {return SQRT;}  
"pow"|"POW"   {return POW;}
"sin"|"SIN"   {return SIN;}
"cos"|"COS"   {return COS;}
"tan"|"TAN"   {return TAN;}
"ln"|"LN"    {return LN;}
"log"|"LOG"  {return LOG;}
"exp"|"EXP"    {return EXP;}
"fact"|"FACT"  {return FACT;}
"npr"|"NPR"     {return NPR;}
"ncr"|"NCR"      {return NCR;}
"abs"|"ABS"    {return ABS;}
"<"	      {return LT; }
">"	      {return GT;}
"<="	       {return LE;}	
">="	      {return GE;}
"=="		{return EQ;}
"!="		{return NE;}
"++"     {return INCR;}
"--"	  {return DECR;}
"||"	  {return OR;}
"&&"	  {return AND;}	
"!"       {return NOT;}
" "       ;
[a-z]     {
            c = yytext[0];
            yylval.a = c - 'a';
            return(IDENTIFIER);
          }
(([0-9]+(\.[0-9]*)?)|([0-9]*\.[0-9]+)) {
            yylval.b=atof(yytext);
            return(NUMBER);
          }

[^a-z0-9\b]	{return (int)yytext[0];}
%%

