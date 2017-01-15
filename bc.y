%{
    #include <stdio.h>

    int regs[26];
    int base;

    %}

    %start list

    %union { int a; 
	     double b;
	     char ch[32];	}

    %type <a> expr number IDENTIFIER DIGIT
    %type <ch> STRING	

    %token DIGIT LETTER

    %left '|'
    %left '&'
    %left '+' '-'
    %left '*' '/' '%'
    %left UMINUS  /*supplies precedence for unary minus */
%token    EOF NEWLINE STRING IDENTIFIER NUMBER


%token    ARITHMATIC_OP
/*        '*', '/', '%' ,'+','-'                          */

%token    ASSIGNMENT_OP
/*        '=', '+=', '-=', '*=', '/=', '%=', '^=' */

%token    RELATIONAL_OP
/*        '==', '<=', '>=', '!=', '<', '>'        */


%token    INCR_DECR
/*        '++', '--'                              */

%token    EXPONENT
/*        ^                                      */

%token    DEFINE    BREAK    QUIT    LENGTH
/*        'define', 'break', 'quit', 'length'     */


%token    RETURN    FOR    IF  ELSE  WHILE    SQRT
/*        'return', 'for', 'if', 'while', 'sqrt'  */


%token    SCALE    
/*        'scale', 'ibase', 'obase', 'auto'       */


%start    program


%%


program              : EOF
                     | input_item program
                     ;


input_item           : semicolon_list NEWLINE
                     | function
                     ;


semicolon_list       : /* empty */
                     | statement
                     | semicolon_list ';' statement
                     | semicolon_list ';'
                     ;


statement_list       : /* empty */
                     | statement
                     | statement_list NEWLINE
                     | statement_list NEWLINE statement
                     | statement_list ';'
                     | statement_list ';' statement
                     ;


statement            : expression
                     | STRING
                     | BREAK
                     | QUIT
                     | RETURN
                     | RETURN '(' return_expression ')'
                     | FOR '(' expression ';'
                           relational_expression ';'
                           expression ')' statement
                     | If '(' relational_expression ')' statement
                     | While '(' relational_expression ')' statement
                     | '{' statement_list '}'
                     ;


function             : DEFINE IDENTIFIER '(' opt_parameter_list ')'
                       NEWLINE     '{' opt_auto_define_list
                           statement_list '}'
                     ;


opt_parameter_list   : /* empty */
                     | parameter_list
                     ;


parameter_list       : IDENTIFIER
                     | define_list ',' IDENTIFIER
                     ;


opt_auto_define_list : /* empty */
                     | Auto define_list NEWLINE
                     | Auto define_list ';'
                     ;


define_list          : IDENTIFIER
                     | IDENTIFIER'[' ']'
                     | define_list ',' IDENTIFIER
                     | define_list ',' IDENTIFIER '[' ']'
                     ;


opt_argument_list    : /* empty */
                     | argument_list
                     ;


argument_list        : expression
		     | expression  ',' argument_list 
                     | IDENTIFIER '[' ']' ',' argument_list
                     ;


relational_expression : expression
                     | expression RELATION_OP expression
                     ;


return_expression    : /* empty */
                     | expression
                     ;


expression        : id_expression
                     | NUMBER
                     | '(' expression ')'
                     | IDENTIFIER '(' argument_list ')'
                     | '-' expression
                     | expression ADD_OP expression
                     | expression MUL_OP expression
                     | expression '^' expression
                     | INCR_DECR id_expression
                     | id_expression INCR_DECR
                     | id_expression ASSIGN_OP expression
                     | LENGTH '(' expression ')'
                     | SQRT '(' expression ')'
                     | SCALE '(' expression ')'
                     ;


id_expression     : IDENTIFIER
                     | IDENTIFIER '[' expression ']'
                     
                     ;
