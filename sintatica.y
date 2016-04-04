%{

#include <stdio.h>

%}

%token RESERVED_WORD_C
/* Reserved words Portugol */
%token ALGORITHM
%token END_ALGORITHM
%token CONSTANTS
%token VARIABLES
%token BEGIN
%token VAR

/* Repeating structure Portugol */
%token FOR
%token END_FOR
%token IN
%token UNTIL
%token DO_IT
%token WHILE
%token END_WHILE
%token REPEAT
%token STOP

/* Condition structure */
%token IF_IT
%token END_IF
%token SO
%token IF_NO

%token INT
%token DOUBLE
%token BOOLEAN
%token CHAR
%token STRING

/* Boolean type */
%token TRUE
%token FALSO

/* Symbols */
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token MOD
%token POWER

/*  */
%token ATRIBUICION
%token DIFERENT
%token AND_
%token OR_

%token COMMENT
%token COLON
%token SEMICOLON
%token COMMA

%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS
%token LEFT_KEY
%token RIGHT_KEY
%token LEFT_BRACKET
%token RIGHT_BRACKET

%token END_LINE
%token TABULATION
 
%start Compile

%error-verbose
 
%%

Compile:
    | Compile Expression
;
Expression:
    END
    | NUM PLUS NUM END_LINE { printf("a+b"); }
    | NUM MINUS NUM END_LINE { printf("a-b"); }
    | NUM TIMES NUM END_LINE { printf("a*b"); }
    | NUM DIVIDE NUM END_LINE { printf("a/b"); }

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
