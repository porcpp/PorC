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
    char* s;
    int num_int;
    double num_double;
}

%token <s> NAMEVAR

%token ATTRIBUTION
%token <num_int> VALUE_INT
%token <num_double> VALUE_DOUBLE
%token <s>VALUE_STRING
%token <s>VALUE_CHARACTER

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
%token COMMA

%token SEMICOLON

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
    ALGORITHM NAMEVAR SEMICOLON {
        open_output_file($2);
        write_default_header(output_file);
        write_body_begin(output_file);
    }
;

HeaderVariables:
    VARIABLES Variables VARIABLES_END
;

Variables:
    NAMEVAR COLON Type SEMICOLON { printf("%s %s;\n",$3, $1); }
    | NAMEVAR COLON Type SEMICOLON Variables { printf("%s %s;\n", $3, $1); }
    | NAMEVAR COMMA Variables { printf("%s, ",$1); }
;
Type:
    T_INT
    |T_DOUBLE
    |T_CHAR
    |T_STRING
    |T_BOOLEAN
;
AttribuitionVariables:
    NAMEVAR ATTRIBUTION VALUE_INT SEMICOLON { printf("%s = %d;", $1, $3); } 
    | NAMEVAR ATTRIBUTION VALUE_DOUBLE SEMICOLON { printf("%s = %lf;", $1, $3); }
    | NAMEVAR ATTRIBUTION VALUE_STRING SEMICOLON { printf("%s = %s;", $1, $3); }
;
Body:
    BEGIN_BODY END_BODY {
        write_body_end(output_file);
        close_output_file();
    }
    | BEGIN_BODY AttribuitionVariables END_BODY {
        write_body_end(output_file);
        close_output_file();
    } 
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
