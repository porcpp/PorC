%{

#include <stdio.h>

%}

%union {
    char* s;
}

%token <s> NAMEVAR

%token RESERVED_WORD_C
%token TO_IMPLEMENT
%token ALGORITHM
%token END_ALGORITHM
%token CONSTANTS
%token VARIABLES
%token VARIABLES_END
%token BEGIN_BODY
%token END_BODY

/* define tokens type */
%token <s> T_INT
%token <s> T_DOUBLE
%token <s> T_BOOLEAN
%token <s> T_CHAR
%token <s> T_STRING

/* define function type */
%type <s> Type

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
    Header Body
;

Header:
    HeaderAlgorithm HeaderVariables
;

HeaderAlgorithm:
    ALGORITHM NAMEVAR END_LINE
;

HeaderVariables:
    VARIABLES END_LINE Variables VARIABLES_END END_LINE
;

Body:
    BEGIN_BODY END_LINE END_BODY
    | BEGIN_BODY END_LINE END_BODY END_LINE
;

Variables:
    NAMEVAR COLON Type END_LINE { printf("%s %s;\n",$3, $1); }
    | NAMEVAR COLON Type END_LINE Variables { printf("%s %s;\n", $3, $1); }
    | NAMEVAR COMMA Variables { printf("%s, ",$1); }
;

Type:
    T_INT
    |T_DOUBLE
    |T_CHAR
    |T_STRING
    |T_BOOLEAN
;

%%

int yyerror(char* errmsg)
{
    printf("\n*** Erro: %s\n", errmsg);
    return 0;
}

int yywrap() { return 1; }

int main(int argc, char** argv)
{
    yyparse();
    return 0;
}
