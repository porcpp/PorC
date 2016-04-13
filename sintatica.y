%{
#include <stdlib.h>
#include <stdio.h>
#include "c_templates.h"

FILE* output_file = NULL;

void open_output_file(char* algorithm_name) {
    if (!output_file) {
        char file_name[60];
        sprintf(file_name, "%s.c", algorithm_name);
        output_file = fopen(file_name, "w");
    }
}

void close_output_file() {
    if (output_file != NULL) {
        fclose(output_file);
    }
}

%}

%union {
    char* strings;
    int num;
    char characters;
}

%token <strings> NAMEVAR

/* define types of attribution */
%token ATTRIBUTION
%token <num> VALUE_INT
%token <characters> VALUE_CHARACTER

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
%token <strings> T_INT
%token <strings> T_DOUBLE
%token <strings> T_BOOLEAN
%token <strings> T_CHAR

/* define function type */
%type <strings> Type
/* How change type of function */
%type <num> ValueInt
%type <characters> ValueChar

%token COMMENT
%token COLON
%token SEMICOLON
%token COMMA

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
    ALGORITHM NAMEVAR {
        open_output_file($2);
        write_default_header(output_file);
        write_body_begin(output_file);
    }
;

HeaderVariables:
    VARIABLES Variables VARIABLES_END
;

Variables:
    NAMEVAR COLON Type { printf("%s %s;\n",$3, $1); }
    | NAMEVAR COLON Type Variables { printf("%s %s;\n", $3, $1); }
    | NAMEVAR COMMA Variables { printf("%s, ",$1); }
;
AttribuitionVariables:
    NAMEVAR ATTRIBUTION ValueInt SEMICOLON { printf("%s = %d;\n", $1, $3); }
;
ValueInt:
    VALUE_INT 
;

Type:
    T_INT
    |T_DOUBLE
    |T_CHAR
    |T_BOOLEAN
;
Body:
    BEGIN_BODY END_BODY {
        write_body_end(output_file);
        close_output_file();
    }
    | BEGIN_BODY END_BODY {
        write_body_end(output_file);
        close_output_file();
    }
    | BEGIN_BODY AlgorithmBody END_BODY {
        write_body_end(output_file);
        close_output_file();
    } 
;
AlgorithmBody:
    AttribuitionVariables
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
