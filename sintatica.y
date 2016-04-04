%{

#include <stdio.h>

%}

%token RESERVED_WORD_C
%token ALGORITHM
%token END_ALGORITHM
%token CONSTANTS
%token VARIABLES
%token BEGIN_
%token VAR

%token INT
%token DOUBLE
%token BOOLEAN
%token CHAR
%token STRING


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
    | Compile Expression
;
Expression:
    END_LINE
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
