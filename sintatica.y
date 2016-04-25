%{
#include <stdlib.h>
#include <stdio.h>
#include "lib/templates/c_templates.h"
#include "lib/simbol_table/simbol_table.h"
#include "lib/templates/verify_templates.h"

FILE* output_file = NULL;
char * tipo=NULL; 

SimbolTable * simbols ;
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
    int num_int;
    double num_double;
    char* strings;
}

%token <strings> NAMEVAR

/* define types of attribution */
%token ATTRIBUTION

%token <num_int> VALUE_INT
%token <num_double> VALUE_DOUBLE
%token <strings>VALUE_STRING
%token <strings>VALUE_CHARACTER

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

%token COMMENT
%token COLON
%token COMMA
%token SEMICOLON

%start Compile

%error-verbose

%%

Compile:
    Header Body {
        Variable * variables = SimbolTable_get_variables_as_array(simbols);
        int i=0;
        printf("\nDEBUG - Variables insert in simbol table\n");
        for(i =0; i< simbols->size; i++){
            printf("%s %s\n",variables[i].type,variables[i].name);
        }
        SimbolTable_destroy(simbols);
    }
;
Header:
    HeaderAlgorithm HeaderVariables
;
HeaderAlgorithm:
    ALGORITHM NAMEVAR SEMICOLON {
        simbols = SimbolTable_new();
        open_output_file($2);
        write_default_header(output_file);
        write_body_begin(output_file);
    }
;
HeaderVariables:
    VARIABLES MultiVariables VARIABLES_END{fprintf(output_file,";\n");}
;
MultiVariables:
    Variables
    | Variables {fprintf(output_file,";\n");} MultiVariables
;
Variables:
    NAMEVAR COMMA Variables { SimbolTable_insert(simbols,$1,tipo); write_declares_variable_with_comma(output_file, $1); printf(", %s, ",$1);}
    | NAMEVAR COLON Type {tipo=$3;} SEMICOLON {SimbolTable_insert(simbols,$1,$3); write_declares_variable(output_file, $3 , $1); printf("%s %s",$3,$1);}
;
Type:
    T_INT
    |T_DOUBLE
    |T_CHAR
    |T_BOOLEAN
;

AttribuitionVariables:
    NAMEVAR ATTRIBUTION VALUE_INT SEMICOLON { // verify_type(simbols,$1,"inteiro"); 
        write_atribute_variable_int(output_file, $1, $3); 
    }
    | NAMEVAR ATTRIBUTION VALUE_DOUBLE SEMICOLON { write_atribute_variable_double(output_file, $1, $3); }
    | NAMEVAR ATTRIBUTION VALUE_STRING SEMICOLON { write_atribute_variable_string(output_file, $1, $3); }
;
Body:
    BEGIN_BODY END_BODY {
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

int yyerror(char* errmsg) {
    printf("\n*** Erro: %s\n", errmsg);
    return 0;
}


int yywrap() {
  return 1;
}


int main(int argc, char** argv) {
    yyparse();
    return 0;
}

