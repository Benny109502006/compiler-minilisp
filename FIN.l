
%{
    #include "FIN.tab.h"
%}
separator [\t\n\r ]
letter [a-z]
digit [0-9]

number (0|[1-9]{digit}*|-[1-9]{digit}*)
id {letter}({letter}|{digit}|'-')*

%%

{number} {yylval.ival = atoi(yytext); return(NUMBER);}
"+"|"-"|"*"|"/"|">"|"<"|"="|"("|")"  {return yytext[0];}
"mod" {return(MOD);}
"and" {return(AND);}
"or" {return(OR);}
"not" {return(NOT);}
"if" {return(IF);}
"define" {return(DEFINE);}
"print-num" {return(PRINT_NUM);}
"print-bool" {return(PRINT_BOOL);}
{id} {yylval.sval = strdup(yytext); return(ID);}
"#t" {yylval.bval = 1; return(BOOL_VAL);}
"#f" {yylval.bval = 0; return(BOOL_VAL);}
\n {}
{separator} { }
. { }
%%
