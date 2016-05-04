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
/* define tokens off operations */

%token <strval> COMPARATOR
%token <strval> ARITIMETIC

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
%type <strval> ValuesNumber
%type <strval> ValuesString

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

ValuesNumber:
  VALUE_INT { $$ = transform_int_string(value,$1); }
  | VALUE_DOUBLE { $$ = transform_double_string(value,$1); } 
;
ValuesString:
  VALUE_STRING 
  | VALUE_CHARACTER  
;

Values:
  NAMEVAR COMPARATOR NAMEVAR { write_condicional_sentece(output_file, $1, $2, $3); }

  | NAMEVAR COMPARATOR ValuesNumber { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesNumber COMPARATOR NAMEVAR { write_condicional_sentece(output_file, $1, $2, $3); }
  | NAMEVAR COMPARATOR ValuesString { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesString COMPARATOR NAMEVAR { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesNumber COMPARATOR ValuesNumber { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesString COMPARATOR ValuesString { write_condicional_sentece(output_file, $1, $2, $3); }
;

Aritmetic:
    NAMEVAR ARITIMETIC NAMEVAR { printf("%s %s %s",$1, $2, $3); }
    | ValuesNumber ARITIMETIC ValuesNumber { printf("%s %s %s",$1, $2, $3); }
    | NAMEVAR ARITIMETIC ValuesNumber  { printf("%s %s %s",$1, $2, $3); }
    | ValuesNumber ARITIMETIC NAMEVAR { printf("%s %s %s",$1, $2, $3); }
    | Values
;
Operations:
    Aritmetic
    | Aritmetic ARITIMETIC Operations { printf("%s",$2); }
    | LEFT_PARENTHESIS Operations RIGHT_PARENTHESIS { printf("( )"); }
    | LEFT_PARENTHESIS Operations RIGHT_PARENTHESIS ARITIMETIC Operations { printf("() +"); }

;

AttribuitionVariables:
    NAMEVAR ATTRIBUTION Operations SEMICOLON { printf("Operation: " ); }
    | NAMEVAR ATTRIBUTION VALUE_INT SEMICOLON { verify_type(simbols,$1,"int"); value = transform_int_string(value,$3);
write_atribute_variable(output_file, $1, value); }
    | NAMEVAR ATTRIBUTION VALUE_DOUBLE SEMICOLON { verify_type(simbols,$1,"double"); value = transform_double_string(value,$3); 
write_atribute_variable(output_file, $1, value); }
    | NAMEVAR ATTRIBUTION VALUE_STRING SEMICOLON { verify_type(simbols,$1,"string"); 
write_atribute_variable(output_file, $1, $3); }
    | NAMEVAR ATTRIBUTION VALUE_CHARACTER SEMICOLON { verify_type(simbols,$1,"char"); 
write_atribute_variable(output_file, $1, $3); }
    ;


AndOr:
  AND_ { write_to_file(output_file, " && "); } Condition
  | OR_ { write_to_file(output_file, " || "); } Condition
;
Condition:
  Values
  | Values AndOr
;

ConditionalBegin:
    IF_ { write_to_file(output_file, "\tif"); } Condition THAN_{ write_to_file(output_file, " {"); }
;

ConditionalEnd:
    ELSE_ { write_to_file(output_file, "}else {"); } AlgorithmBody ConditionalEnd
    | END_IF_ { write_to_file(output_file, "}"); }
;

ConditionalStruct:
    ConditionalBegin  AlgorithmBody {write_to_file(output_file,"\t");} ConditionalEnd
    | ConditionalBegin ConditionalStruct ConditionalEnd
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
    AttribuitionVariables{write_to_file(output_file,"\t");}
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

