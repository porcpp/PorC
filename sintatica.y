%{
#include <stdlib.h>
#include <stdio.h>
#include "lib/templates/c_templates.h"
#include "lib/templates/transform_types.h"
#include "lib/simbol_table/simbol_table.h"
#include "lib/templates/verify_templates.h"
#include "lib/util/log.h"
#include "lib/util/string_builder.h"
#include <string.h>

FILE* output_file = NULL;
char* type=NULL;
char* value=NULL;
char* variableToFor=NULL;
extern int quantity_lines;
extern unsigned short MAX_LOG_MESSAGE_SIZE;
int counter_tabulation=1;
int counter_loop=1;
SimbolTable* simbols = NULL;
StrList* strList = NULL;

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
%token <strval> BASIC_ARITIMETIC
%token <strval> TIMES
%token <strval> DIVIDER

%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS
%token LEFT_COL
%token RIGHT_COL
%token LEFT_BRACKET
%token RIGHT_BRACKET

/* define tokens type */
%token <strval> T_INT
%token <strval> T_DOUBLE
%token <strval> T_BOOLEAN
%token <strval> T_CHAR
%token <strval> T_STRING
%token MATRIX

/* define function type */
%type <strval> Type
%type <strval> ValuesNumber
%type <strval> ValuesString
%type <strval> Operations
%type <strval> Aritmetic
%type <strval> Parenthesis
%type <strval> Operator
%type <strval> DimensionMatrix
%type <strval> PrintBody

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

%token WHILE
%token END_WHILE
%token DO
%token END_FOR
%token FOR
%token FROM
%token TO
%token STEP

%token LEIA
%token IMPRIMA
%token STRING

%start Compile

%error-verbose

%%

Compile:
    Header Body {
        Variable* variables = SimbolTable_get_variables_as_array(simbols);
        int i = 0;
        char log_message[MAX_LOG_MESSAGE_SIZE];

        Log_info("Variables insert in simbol table");

        for(i =0; i< simbols->size; i++) {
            sprintf(log_message, "Variable: %s %s", variables[i].type, variables[i].name);
            Log_info(log_message);
        }

        SimbolTable_destroy(simbols);
        Log_destroy();
        free(variables);
    }
;
Header:
    HeaderAlgorithm
    | HeaderAlgorithm HeaderVariables
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
    VARIABLES VARIABLES_END
    | VARIABLES MultiVariables VARIABLES_END{write_to_file(output_file,";\n");}
;
MultiVariables:
    Variables
    | Variables{write_to_file(output_file,";\n");}MultiVariables
;
Variables:
    NAMEVAR COMMA Variables {
        verify_before_insert(simbols,$1,type);
        write_tabulation(output_file,counter_tabulation);
        write_declares_variable_with_comma(output_file, $1,transform_type_inital_value(type));
    }
    | NAMEVAR COLON Type {type=$3;} SEMICOLON {
        verify_before_insert(simbols,$1,$3);
        write_tabulation(output_file,counter_tabulation);
        write_declares_variable(output_file, $3 , $1,transform_type_inital_value(type));
    }
    | NAMEVAR COLON MATRIX DimensionMatrix FROM Type SEMICOLON {
	verify_before_insert(simbols,$1,$6);
        write_tabulation(output_file,counter_tabulation);
    	write_declares_vector_type(output_file,$1,$4,$6);    
	write_tabulation(output_file,counter_tabulation);  	    	
	write_initialize_matrix(output_file,$1,$4,$6);
    }
    | NAMEVAR COLON MATRIX DimensionMatrix DimensionMatrix FROM Type SEMICOLON {
        SimbolTable_insert(simbols,$1,$7);
        write_to_file(output_file,$7);
        write_tabulation(output_file,counter_tabulation);
        write_declares_matrix(output_file, $1, $4, $5);
    }
;
DimensionMatrix:
    LEFT_BRACKET VALUE_INT RIGHT_BRACKET { $$ = transform_int_string($2); }
;
Type:
    T_INT
    |T_DOUBLE
    |T_CHAR
    |T_BOOLEAN
    |T_STRING
;

AttribuitionVariables:
    NAMEVAR ATTRIBUTION VALUE_STRING SEMICOLON {
        write_tabulation(output_file,counter_tabulation);
        verify_type(simbols,$1,"char*");
        write_atribute_variable_string(output_file, $1, $3);
    }

    | NAMEVAR ATTRIBUTION VALUE_CHARACTER SEMICOLON {
        write_tabulation(output_file,counter_tabulation);
        verify_type(simbols,$1,"char");
        write_atribute_variable(output_file, $1, $3);
    }

    | NAMEVAR ATTRIBUTION {
        write_tabulation(output_file,counter_tabulation);
        write_valid_aritmetic(output_file,simbols,$1);
    } Operations SEMICOLON { write_to_file(output_file,";\n"); }

    | NAMEVAR DimensionMatrix {
        write_tabulation(output_file,counter_tabulation);
        write_declares_vector(output_file, $1, $2);
    } ATTRIBUTION {
        write_to_file(output_file, " = ");
    } Operations SEMICOLON { write_to_file(output_file,";"); }

    | NAMEVAR DimensionMatrix DimensionMatrix {
        write_tabulation(output_file,counter_tabulation);
        write_declares_matrix(output_file, $1, $2,$3);
    } ATTRIBUTION {
        write_to_file(output_file, " = ");
    } Operations SEMICOLON{ write_to_file(output_file,";");}
;

ValuesNumber:
  VALUE_INT { $$ = transform_int_string($1); }
  | VALUE_DOUBLE { $$ = transform_double_string($1); }
;
ValuesString:
  VALUE_STRING
  | VALUE_CHARACTER
;


Values:
  NAMEVAR COMPARATOR NAMEVAR {
       transform_simbol_comparator($2);
       write_condicional_sentece(output_file, $1, $2, $3);
  }
  | NAMEVAR COMPARATOR ValuesNumber { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesNumber COMPARATOR NAMEVAR { write_condicional_sentece(output_file, $1, $2, $3); }
  | NAMEVAR COMPARATOR ValuesString { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesString COMPARATOR NAMEVAR { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesNumber COMPARATOR ValuesNumber { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesString COMPARATOR ValuesString { write_condicional_sentece(output_file, $1, $2, $3); }
  | NAMEVAR DimensionMatrix COMPARATOR ValuesNumber {
        write_declares_vector(output_file, $1,$2);
        write_condicional_sentece(output_file," ",$3,$4);
  }
  | ValuesNumber COMPARATOR NAMEVAR DimensionMatrix {
        write_declares_vector(output_file, $1,$2);
        write_condicional_sentece(output_file," ",$3,$4);
  }
  | NAMEVAR DimensionMatrix COMPARATOR ValuesString {
        write_declares_vector(output_file, $1,$2);
        write_condicional_sentece(output_file," ",$3,$4);
  }
  | ValuesString COMPARATOR NAMEVAR DimensionMatrix {
        write_declares_vector(output_file, $1,$2);
        write_condicional_sentece(output_file," ",$3,$4);
  }
  | NAMEVAR DimensionMatrix DimensionMatrix COMPARATOR ValuesNumber {
        write_declares_matrix(output_file, $1,$2,$3);
        write_condicional_sentece(output_file," ",$4,$5);
  }
  | NAMEVAR DimensionMatrix DimensionMatrix COMPARATOR ValuesString {
        write_declares_matrix(output_file, $1,$2,$3);
        write_condicional_sentece(output_file," ",$4,$5);
  }
  | ValuesNumber COMPARATOR  NAMEVAR DimensionMatrix DimensionMatrix {
        write_declares_matrix(output_file, $1,$2,$3);
        write_condicional_sentece(output_file," ",$4,$5);
  }
  | ValuesString COMPARATOR  NAMEVAR DimensionMatrix DimensionMatrix {
        write_declares_matrix(output_file, $1,$2,$3);
        write_condicional_sentece(output_file," ",$4,$5);
  }
;

Operator:
    BASIC_ARITIMETIC
    | TIMES
    | DIVIDER
;

Aritmetic:
    NAMEVAR { write_variable_if_valid(output_file, simbols, $1); }
    | ValuesNumber { write_to_file(output_file, $1); }
    | BASIC_ARITIMETIC NAMEVAR {
        write_operator_variable_valid(output_file,simbols,$1,$2);
    }
    | BASIC_ARITIMETIC ValuesNumber {
        write_aritmetic(output_file,$1,$2);
    }
    | Aritmetic Operator {write_to_file(output_file,$2); } Aritmetic
    | Aritmetic Operator {write_to_file(output_file,$2); } Parenthesis
;

Parenthesis:
    LEFT_PARENTHESIS {
      write_to_file(output_file,"(");
    } Operations RIGHT_PARENTHESIS { write_to_file(output_file,")"); }
;
Operations:
    Aritmetic
    | Parenthesis
    | Parenthesis Operator { write_to_file(output_file,$2); } Operations
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
    IF_ {
        write_tabulation(output_file,counter_tabulation);
        write_to_file(output_file, "if (");
    } Condition THAN_{
        write_to_file(output_file, ") {\n");
        counter_tabulation++;
    }
;

ConditionalEnd:
    ELSE_ {
        counter_tabulation--;
        write_tabulation(output_file,counter_tabulation);
        counter_tabulation++;
        write_to_file(output_file, "} else{\n");
    } AlgorithmBody ConditionalEnd
    | END_IF_ {
        counter_tabulation--;
        write_tabulation(output_file,counter_tabulation);
        write_to_file(output_file, "}\n");
    }
;

ConditionalStruct:
    ConditionalBegin  AlgorithmBody  ConditionalEnd
    | ConditionalBegin ConditionalStruct ConditionalEnd
;

LoopStruct:
    WHILE {
        write_tabulation(output_file,counter_tabulation);
        write_to_file(output_file,"while (");
    }
    Condition DO {
        counter_loop++;
        write_to_file(output_file,") {\n");
        counter_loop--;
        write_tabulation(output_file,counter_loop);
        counter_loop++;
     } AlgorithmBody END_WHILE {
        counter_loop--;
        write_tabulation(output_file,counter_loop);
        write_to_file(output_file,"}\n");
    }
    | FOR NAMEVAR FROM {
        verify_type(simbols,$2,"int");
        variableToFor = $2;
        write_tabulation(output_file,counter_tabulation);
        write_to_file(output_file,"for(");
    } ForStep DO { counter_tabulation++; }
    AlgorithmBody { counter_tabulation--; }
    END_FOR {
        write_tabulation(output_file,counter_tabulation);
        write_to_file(output_file,"}\n");
    }
;

ForStatement:
    VALUE_INT TO VALUE_INT{
        char *aux;
        value = transform_int_string($3);
        aux = transform_int_string($1);
        write_for_statement(output_file,aux,value,variableToFor);
        free(aux);
    }
    | VALUE_INT TO NAMEVAR{
        value = transform_int_string($1);
        write_for_statement(output_file,value,$3,variableToFor);
    }
    | NAMEVAR TO VALUE_INT{
        value = transform_int_string($3);
        write_for_statement(output_file,$1,value,variableToFor);
    }
    | NAMEVAR TO NAMEVAR{
        verify_type(simbols,$1,"int");
        verify_type(simbols,$3,"int");
        write_for_statement(output_file,$1,$3,variableToFor);
    }
;

ForStep:
    ForStatement{
        write_for_statement_end(output_file,variableToFor,1);
    }
    | ForStatement STEP VALUE_INT{
        write_for_statement_end(output_file,variableToFor,$3);
    }
    |ForStatement STEP BASIC_ARITIMETIC VALUE_INT {
        write_for_statement_end(output_file,variableToFor,-$4);
    }
;

InputFunction:
    NAMEVAR ATTRIBUTION LEIA LEFT_PARENTHESIS RIGHT_PARENTHESIS SEMICOLON { 
        write_tabulation(output_file,counter_tabulation);
        char* type = NULL;
        type = transform_type_input(simbols,type,$1);
        write_input_file(output_file,$1,type);
    }
;

PrintBody:
    VALUE_STRING { StrList_add(strList, $1, "string"); }
    | NAMEVAR { StrList_add(strList, $1, "variable"); }
    | VALUE_STRING COMMA PrintBody {  StrList_add(strList, $1, "string"); }
    | NAMEVAR COMMA PrintBody { StrList_add(strList, $1, "variable"); }
;

PrintStep:
    IMPRIMA LEFT_PARENTHESIS { strList = StrList_new(); } PrintBody RIGHT_PARENTHESIS SEMICOLON {
        char* printfStr = StrList_makePrint(strList, simbols);
        write_tabulation(output_file,counter_tabulation);
        write_print(output_file, printfStr);
        StrList_destroy(strList);
        free(printfStr);
    }

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
    | InputFunction
    | ConditionalStruct
    | LoopStruct
    | InputFunction AlgorithmBody
    | PrintStep
    | AttribuitionVariables AlgorithmBody
    | ConditionalStruct AlgorithmBody
    | LoopStruct AlgorithmBody
    | PrintStep AlgorithmBody
;

%%

int yyerror(char* errmsg) {
    printf("\nErro: '%s' na linha: %d\n", errmsg, quantity_lines);
    return 0;
}


int yywrap() {
  return 1;
}


int main(int argc, char** argv) {
    yyparse();
    return 0;
}

