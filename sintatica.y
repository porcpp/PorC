%{

#include <stdio.h>

%}

%union{
    char* s;
}

%token <s> NAMEVAR

%token RESERVED_WORD_C
%token TO_IMPLEMENT
%token ALGORITHM
%token END_ALGORITHM
%token CONSTANTS
%token VARIABLES
%token BEGIN_
%token VAR

%token T_INT
%token T_DOUBLE
%token T_BOOLEAN
%token T_CHAR
%token T_STRING


%token COMMENT
%token COLON
%token SEMICOLON
%token COMMA

%token END_LINE
%token TABULATION

%start Compile

%error-verbose
 
%%

Compile:
    VAR END_LINE Variables Algorithm END_LINE    
;

Variables:   
    NAMEVAR COLON Type END_LINE {printf("%s",$1);}
    | NAMEVAR COLON Type END_LINE Variables
    | NAMEVAR COMMA Variables 
;

Type: 
    |T_INT {return "int";}
    |T_DOUBLE
    |T_CHAR
    |T_STRING
    |T_BOOLEAN	
;

Algorithm:
    ALGORITHM END_LINE END_ALGORITHM 
;

%%
 
void yyerror(char* errmsg)
{
	printf("\n*** Erro: %s\n", errmsg);
}
 
int yywrap() { return 1; }
 
int main(int argc, char** argv)
{
     yyparse();
     return 0;
}
