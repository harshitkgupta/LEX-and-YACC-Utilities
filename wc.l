%{
int chars=0,words=0,lines=0,tchars=0,twords=0,tlines=0;
%}
%%
[^ \t\n\r\v]+ {words++;chars+=yyleng;}
\n {lines++;chars++;}
. chars++;
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
	yylex();
	printf("%d chars %d words %d lines\n",chars,words,lines);
	tchars+=chars;twords+=words;tlines+=lines;
	}
	printf("%d chars %d words %d lines\n",tchars,twords,tlines);
}
