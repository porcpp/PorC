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
    int num;
}

%token <s> NAMEVAR

%token ATTRIBUTION
%token <num> VALUE_INT
%token <num> VALUE_DOUBLE
%token VALUE_STRING
%token VALUE_CHARACTER

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
    ALGORITHM NAMEVAR END_LINE {
        open_output_file($2);
        write_default_header(output_file);
        write_body_begin(output_file);
    }
;

HeaderVariables:
    VARIABLES END_LINE Variables VARIABLES_END END_LINE
;

Variables:
    NAMEVAR COLON Type END_LINE { printf("%s %s;\n",$3, $1); }
    | NAMEVAR COLON Type END_LINE Variables { printf("%s %s;\n", $3, $1); }
    | NAMEVAR COMMA Variables { printf("%s, ",$1); }
;
AttribuitionVariables:
    NAMEVAR ATTRIBUTION Value SEMICOLON 
;
Value:
    VALUE_INT {printf("int\n");}
    | VALUE_DOUBLE {printf("double\n");}
    | VALUE_CHARACTER {printf("character\n");}
    | VALUE_STRING {printf("string\n");}
;
Type:
    T_INT
    |T_DOUBLE
    |T_CHAR
    |T_STRING
    |T_BOOLEAN
;
Body:
    BEGIN_BODY END_LINE END_BODY {
        write_body_end(output_file);
        close_output_file();
    }
    | BEGIN_BODY END_LINE END_BODY END_LINE {
        write_body_end(output_file);
        close_output_file();
    }
    | BEGIN_BODY END_LINE AttribuitionVariables END_LINE END_BODY {
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
