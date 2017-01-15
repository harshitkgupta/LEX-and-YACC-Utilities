# A Makefile for simple lex and yacc examples

# Write the proper lines below according to the scanner and
# parser generators available in your system

LEX = lex
YACC = yacc -d 
CC = cc

# calc is the final object that we will generate, it is produced by
# the C compiler from the y.tab.o and from the lex.yy.o

calc: y.tab.c lex.yy.c
	$(CC) -o calc y.tab.c lex.yy.c -ly -ll -lm 



## This rule will use yacc to generate the files y.tab.c and y.tab.h
## from our file calc.y

y.tab.c y.tab.h: calc.y
	$(YACC) -v calc.y

## this is the make rule to use lex to generate the file lex.yy.c from
## our file calc.l

lex.yy.c: calc.l
	$(LEX) calc.l

## Make clean will delete all of the generated files so we can start
## from scratch

clean:
	-rm -f *.o lex.yy.c *.tab.*  calc *.output

