%{
#include <stdlib.h>
#include <stdio.h>
#include "lib/templates/c_templates.h"
#include "lib/templates/transform_types.h"
#include "lib/simbol_table/simbol_table.h"
#include "lib/templates/verify_templates.h"

FILE* output_file = NULL;
char * tipo=NULL; 
char * value=NULL; 

SimbolTable * simbols =NULL;
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
    int ival;
    double dval;
    char* strval;
}

%token <strval> NAMEVAR

/* define types of attribution */
%token ATTRIBUTION

%token <ival> VALUE_INT
%token <dval> VALUE_DOUBLE
%token <strval> VALUE_STRING
%token <strval> VALUE_CHARACTER

%token <strval> TEST_INT 


%token RESERVED_WORD_C
%token TO_IMPLEMENT
%token ALGORITHM
%token END_ALGORITHM
%token CONSTANTS
%token VARIABLES
%token VARIABLES_END
%token BEGIN_BODY
%token END_BODY

%token <strval> COMPARATOR

%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS

%token LEFT_COL
%token RIGHT_COL

/* define tokens type */
%token <strval> T_INT
%token <strval> T_DOUBLE
%token <strval> T_BOOLEAN
%token <strval> T_CHAR

/* define function type */
%type <strval> Type
%type <strval> Values

%token COMMENT
%token COLON
%token COMMA
%token SEMICOLON

%token IF_
%token THAN_
%token ELSE_
%token END_IF_
%token AND_
%token OR_

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
    NAMEVAR ATTRIBUTION VALUE_INT SEMICOLON { verify_type(simbols,$1,"int"); value = transform_int_string(value,$3);
write_atribute_variable(output_file, $1, value); }
    | NAMEVAR ATTRIBUTION VALUE_DOUBLE SEMICOLON { verify_type(simbols,$1,"double"); value = transform_double_string(value,$3); 
write_atribute_variable(output_file, $1, value); }
    | NAMEVAR ATTRIBUTION VALUE_STRING SEMICOLON { verify_type(simbols,$1,"string"); 
write_atribute_variable(output_file, $1, $3); }
    | NAMEVAR ATTRIBUTION VALUE_CHARACTER SEMICOLON { verify_type(simbols,$1,"char"); 
write_atribute_variable(output_file, $1, $3); }
;

Values:
  NAMEVAR { $$ = $1; } 
  | VALUE_INT { $$ = transform_int_string(value,$1); }
  | VALUE_DOUBLE { $$ = transform_double_string(value,$1); } 
  | VALUE_STRING { $$ = $1;} /* ERROR for string COMPARATOR string */
  | VALUE_CHARACTER { $$ = $1;} /* ERROR for char COMPARATOR char, talvez seja o $$ */ 
;

Condition:
  Values COMPARATOR Values { write_condicional_sentece(output_file, $1, $2, $3); }
  | AND_ Condition
  | OR_ Condition
;

ConditionalBegin:
    IF_ Condition THAN_
;

ConditionalEnd:
    ELSE_ AlgorithmBody
    | END_IF_ { write_to_file_or_die(output_file, "\t}"); }
;

ConditionalStruct:
    ConditionalBegin AlgorithmBody ConditionalEnd
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
    | ConditionalStruct
    | AttribuitionVariables AlgorithmBody
    | ConditionalStruct AlgorithmBody
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

