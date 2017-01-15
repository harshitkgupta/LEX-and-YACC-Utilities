%option noyywrap nodefault yylineno case-insensitive
%{
struct symbol
{
	char *name;
	struct ref * reflist;
};
struct ref 
{
	struct ref * next ;
	char *filename;
	int flags;
	int lineno;
};
#define HASH_NO 9999
struct symbol symbol_table[HASH_NO];
struct symbol *lookup(char*);
void addref(int ,char*,char*,int);
void printrefs();
char * curfilename;
%}
%%
[a-z1-9]+ {addref(yylineno,curfilename,yytext,0);}
. {}
%%
int main(int argc,char**argv)
{
	int i;
	if(argc<2)
	{
		curfilename="stdin";
		yylineno=1;
		yylex();
	}
	else
	{	
		for(i=1;i<argc;i++)
		{
			FILE *f =fopen(argv[i],"r");
			if(!f)
			{
				perror(argv[i]);
				return (1);
			}
			curfilename=argv[i];
			yyrestart(f);
			yylineno=1;
			yylex();
			fclose(f);	
		}	
	}
	printrefs();
}
	unsigned symbolhash(char * sym)
	{
		unsigned hash=0,i=0;
		while(i=*sym++)
			hash=hash*9^i;
		return hash;
	}
	struct symbol* lookup(char* sym)
	{
		struct symbol *sp=&symbol_table[symbolhash(sym)%HASH_NO];
		int scount=HASH_NO;
		while(--scount>=0)
		{
			if(sp->name&&!strcmp(sp->name,sym))
				return sp;
			if(!sp->name)
			{
				sp->name=strdup(sym);
				sp->reflist=0;
				return sp;
			}
			if(++sp>=symbol_table+HASH_NO)
				sp=symbol_table;
		}
		fputs("Symbol table Overflow \n",stderr);
		abort();
	}
	void addref(int lineno,char* filename,char* word,int flags)
	{
		struct ref *r;
		struct symbol *sp=lookup(word);
		if(sp->reflist && sp->reflist->lineno==lineno && sp->reflist->filename==filename)
			return;
		r=(struct ref*)malloc(sizeof(struct ref));
		if(!r)
		{
			fputs("out of space \n",stderr);
			abort();
		}
		r->next=sp->reflist;
		r->filename=filename;
		r->lineno=lineno;
		r->flags=flags;
		sp->reflist=r;
	}
	int symbolcompare(const void * xa,const void *xb)
	{
		const struct symbol *a=xa,*b=xb;
		if(!a->name)
		{	if(!b->name)
				return 0;
			return 1;
		}
		if(!b->name)
			return -1;
		return strcmp(a->name,b->name);
	}
	void printrefs()
	{
		struct symbol *sp;
		qsort(symbol_table,HASH_NO,sizeof(struct symbol),symbolcompare);
		for(sp=symbol_table;sp->name&& sp<symbol_table+HASH_NO;sp++)
		{
			char *prevfun=0;
			struct ref *rp=sp->reflist;
			struct ref * rpp=0;
			struct ref *rpn=0;
			do
			{
				rpn=rp->next;	
				rp->next=rpp;
				rpp=rp;
				rp=rpn;
			}while(rp);
			printf("%10s",sp->name);
			for(rp=rpp;rp;rp=rp->next)
			{
				if(rp->filename==prevfun)
					printf("%d",rp->lineno);
				else
				{
					printf("%s:%d",rp->filename,rp->lineno);
					prevfun=rp->filename;
				}
			}
			printf("\n");
		}
	}


