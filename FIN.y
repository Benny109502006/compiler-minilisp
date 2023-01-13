%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
void yyerror(const char *msg);
int count = 0;
char* varname[100];
int var_value_table[100];
int varcount = 0;


 
%}

%code requires{
typedef struct{
        int ival;
        int bval;
        char* sval;
}EXP;
}

%union{
    int ival;
    int bval;
    char* sval;
    EXP e;
}


%token <ival> NUMBER
%token <sval> ID
%token <bval> BOOL_VAL
%token IF 
%token DEFINE 
%token AND 
%token OR 
%token NOT 
%token PRINT_NUM 
%token PRINT_BOOL
%token '>'
%token'<'
%token '='
%type <e> exp num_op logical_op if_exp 
%type <e> minus plus multiply divide modulus greater smaller equal plusexp mulsexp equsexp
%type <e> and_op not_op or_op andsexp orsexp
%type <e> variable 



%left  '='
%left '>' '<'
%left '+' '-' 
%left '*' '/' MOD
%left '(' ')'
%%

program
	: stmts 
	;

stmts 
	: stmt stmts
	| stmt
	;

stmt
	: exp 
	| def_stmt 
	| print_stmt
	;

print_stmt 
	: '(' PRINT_NUM exp ')'     { printf("%d\n", $3.ival); }
	| '(' PRINT_BOOL exp ')'    { if ($3.bval == 1)
					  printf("#t\n");
	                              else
	                                  printf("#f\n");
	}
	;

exp
	: BOOL_VAL { $$.bval = $1; }
	| NUMBER { $$.ival = $1; }
	| variable  {$$=$1; }
	| num_op  { $$ = $1; }
	| logical_op  { $$ = $1; }
	| if_exp  { $$ = $1; }
	;

num_op
	: plus { $$ = $1; }
	| minus { $$ = $1; }
	| multiply { $$ = $1; }
	| divide { $$ = $1; }
	| modulus { $$ = $1; }
	| greater { $$ = $1; }
	| smaller { $$ = $1; }
	| equal { $$ = $1; }
	;

plus
	: '(' '+' exp plusexp ')' { $$.ival = $3.ival + $4.ival; }
	;

plusexp
	: exp plusexp { $$.ival = $1.ival + $2.ival; }
	| exp { $$ = $1; }
	;

minus
	: '(' '-' exp exp ')' { $$.ival = $3.ival - $4.ival; }
	;

multiply
	: '(' '*' exp mulsexp ')' { $$.ival = $3.ival * $4.ival; }
	;

mulsexp : exp mulsexp { $$.ival = $1.ival * $2.ival; }
	        | exp { $$ = $1; }
	         ;

divide
	: '(' '/' exp exp ')' { $$.ival = $3.ival / $4.ival; }
	;

modulus
	: '(' MOD exp exp ')' { $$.ival = $3.ival % $4.ival; }
	;

greater
	: '(' '>' exp exp ')' { $$.bval = ($3.ival > $4.ival); }
	;

smaller
	: '(' '<' exp exp ')' { $$.bval = ($3.ival < $4.ival); }
	;

equal
	: '(' '=' exp equsexp ')' { $$.bval = ($3.ival == $4.ival); }
	;

equsexp
	: exp equsexp { $$.bval = ($1.ival == $2.ival); }
	| exp { $$ = $1; }
	;

logical_op
	: and_op { $$ = $1; }
	| or_op { $$ = $1; }
	| not_op { $$ = $1; }
	;

and_op
	: '(' AND exp andsexp ')' { $$.bval = ($3.bval && $4.bval); }
	;

andsexp
	: exp andsexp { $$.bval = ($1.bval && $2.bval); }
	| exp { $$ = $1; }
	;

or_op
	: '(' OR exp orsexp ')' { $$.bval = ($3.bval || $4.bval); }
	;

orsexp
	: exp orsexp { $$.bval = ($1.bval || $2.bval); }
	| exp { $$ = $1; }
	;

not_op
	: '(' NOT exp ')' { $$.bval = !($3.bval); }
	;

if_exp
	: '(' IF exp exp exp')' {
		if ($3.bval == 0) {
			$$.bval = $5.bval;
			$$.ival = $5.ival;
		}
		else {
			$$.bval = $4.bval;
			$$.ival = $4.ival;
		}
	}
	;

def_stmt
	: '(' DEFINE variable exp ')'   {varname[varcount] = $3.sval;
		var_value_table[varcount++] = $4.ival;
}
	;

variable
	: ID {	int i;
		for (i = 0; i < varcount; i++) {
			if (strcmp(varname[i], $1) == 0) { //var have been declare
				$$.sval = $1;
				$$.ival = var_value_table[i];
				break;
			}
		}
		if (i >= varcount)  //not fount in var table
			$$.sval = $1;

}
	;

%%

void yyerror(const char *msg) {
    printf("syntax error\n");
    exit(0);
}

int main(void) {

    yyparse();

    return 0;
}
