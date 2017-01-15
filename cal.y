%{
    	#include <stdio.h>
	#include<math.h>
	#include<string.h>
	#include<stdlib.h>
        #define PI 3.141592653589793	
      	
    	double symbol_table[26];
        int i,j;
        long l=1;
        int yywrap();
	long fact(int n);
    	char * yyerror(char *s);
%}

%start st_list
%token IDENTIFIER NUMBER
%token INCR DECR AND OR
%token LT GT LE GE EQ NE
%token SQRT POW EXP LN LOG
%token SIN COS TAN
%token NPR NCR ABS FACT
%union { int a; 
       double b;
	}

%type <a> IDENTIFIER
%type <b>  NUMBER expression statement st_list

%right '='
%left OR
%left AND
%left NOT
%left '|'
%left '&'

%left EQ NE
%left LT GT LE GE
%left '+' '-'
%left '*' '/' '%'
%right '^'
%right UMINUS
%right INCR DECR 
%left SQRT  SIN COS TAN POW EXP LOG LN NPR NCR ABS FACT

%%                   
st_list: |st_list statement '\n'{printf(">>>>%lf\n\t",$2);}
	|st_list error '\n' {
		yyerror("Renter Last Line ");		
		yyerrok;}
         |st_list '\n'
         ;

statement : expression
	  |    IDENTIFIER '=' expression
             {	
               symbol_table[$1] = $3;
		$$=$3;
             }
	   ;
expression:    '(' expression ')' {
               $$ = $2;
             }
             |expression '*' expression {
               $$ = $1 * $3;
             }
              |expression '/' expression {
               $$ = $1 / $3;
             }
             |expression '%' expression {
               $$ = fmod($1 , $3);
             }
             | expression '+' expression {
               $$ = $1 + $3;
		
             }
             |expression '-' expression {
               $$ = $1 - $3;
             }
	     	
             |expression '&' expression {
               $$ = (int)$1 & (int)$3;
             }
             |expression '|' expression {
               $$ = (int)$1 | (int)$3;
             }
             |'-' expression %prec UMINUS {
               $$ = -$2;
             }	
	    |   expression OR expression 
	    {
		$$=$1 || $3;
	    }
	     |  NOT expression  
	    {
		$$=!$2 ;
	    } 	
	     |   expression AND expression 
	    {
		$$=$1 && $3;
	    } 
	     |   expression LT expression 
	    {
		$$=$1 < $3;
	    }
	     |   expression GT expression 
	    {
		$$=$1 > $3;
	    }
	     |   expression LE expression 
	    {
		$$=$1 <= $3;
	    }
	     |   expression GE expression 
	    {
		$$=$1 >= $3;
	    }  
	     |   expression EQ expression 
	    {
		$$=$1 == $3;
	    } 
	     |   expression NE expression 
	    {
		$$=$1 != $3;
	    } 
	    |IDENTIFIER INCR
		{
			$$=symbol_table[$1]++;	
		}
		|INCR IDENTIFIER 
		{
			$$=++symbol_table[$2];	
		}
	    |IDENTIFIER DECR
		{
			$$=symbol_table[$1]--;	
		} 
	     |DECR IDENTIFIER 
		{
			$$=--symbol_table[$2];	
		}
            | expression '^' expression {
		$$=pow($1,$3);
	   }
           | SQRT '(' expression ')' {
		$$=sqrt($3);
	   }
	   | POW '(' expression','expression ')' {
		$$=pow($3,$5);
           }
	   | EXP '(' expression ')' {
		$$=exp($3);
           }
	   |LN '(' expression ')' {
		$$=log($3);
           }
	   |LOG '(' expression ')' {
		$$=log10($3);
           }
	   |ABS'(' expression ')' {
		$$=fabs($3);
           }
	   |FACT'(' expression ')' {
		$$=fact($3);
           }
	   | SIN '(' expression ')' {
		$$=sin($3*PI/(float)180);
           }
	   | COS '(' expression ')' {
		$$=cos($3*PI/(float)180);
           }
	   | TAN'(' expression ')' {
		$$=tan($3*PI/(float)180);
           }
	   |expression NPR expression {
		$$=fact($1)/fact($1-$3);
	   }
           |expression NCR expression {
		$$=fact($1)/(fact($3)*fact($1-$3));
	   }	
              |IDENTIFIER {
               $$ = symbol_table[$1];
		}
             | NUMBER {$$=$1;}
	;
    

%%
int main(int argc,char * *argv)
{
	int i;
	FILE* f;
	for( i=1;i<argc;i++)
	{f=fopen(argv[i],"r");
	if(!f){
	perror(argv[i]);
	return(1);}
	yyrestart(f);
	printf("\t");	
        yyparse(); 
	}
	f=stdin;
	yyrestart(f);
	printf("\t");	
        yyparse(); 
}
long fact(int n)
{
	long l=1;
	int i=1;
	for(i=1;i<=n;i++)
	l=l*i;
	return l;
}
char *yyerror(char *s)
{
      fprintf(stderr, "%s\n\t",s);
}
int yywrap()
{
      return(1);
}
    
