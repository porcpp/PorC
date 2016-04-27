%{
#include <stdlib.h>
#include <stdio.h>
#include "lib/templates/c_templates.h"
#include "lib/simbol_table/simbol_table.h"
#include "lib/templates/verify_templates.h"

FILE* output_file = NULL;
char * tipo=NULL; 

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

%token <strings> COMPARATOR

%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS

%token LEFT_COL
%token RIGHT_COL

/* define tokens type */
%token <strings> T_INT
%token <strings> T_DOUBLE
%token <strings> T_BOOLEAN
%token <strings> T_CHAR

/* define function type */
%type <strings> Type
%type <strings> Symbol


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
    NAMEVAR ATTRIBUTION VALUE_INT SEMICOLON { verify_type(simbols,$1,"int"); 
        write_atribute_variable_int(output_file, $1, $3); 
    }
    | NAMEVAR ATTRIBUTION VALUE_DOUBLE SEMICOLON { verify_type(simbols,$1,"double"); 
write_atribute_variable_double(output_file, $1, $3); }
    | NAMEVAR ATTRIBUTION VALUE_STRING SEMICOLON { verify_type(simbols,$1,"string"); 
write_atribute_variable_string(output_file, $1, $3); }
    | NAMEVAR ATTRIBUTION VALUE_CHARACTER SEMICOLON { verify_type(simbols,$1,"char"); 
write_atribute_variable_string(output_file, $1, $3); }
;
Fase01: 
    IF_ NAMEVAR Symbol NAMEVAR { write_condicional_sentece_namevar(output_file, $2, $3, $4); }    
    | IF_ LEFT_PARENTHESIS NAMEVAR Symbol NAMEVAR RIGHT_PARENTHESIS { write_condicional_sentece_namevar(output_file, $3, $4, $5); }    
    
/* VAR with INT */
    | IF_ NAMEVAR Symbol VALUE_INT { write_condicional_sentece_namevar_int(output_file, $2, $3, $4); }    
    | IF_ LEFT_PARENTHESIS NAMEVAR Symbol VALUE_INT RIGHT_PARENTHESIS{ write_condicional_sentece_namevar_int(output_file, $3, $4, $5); }    
/* INT with VAR */ 
    | IF_ VALUE_INT Symbol NAMEVAR { write_condicional_sentece_int_namevar(output_file, $2, $3, $4); }    
    | IF_ LEFT_PARENTHESIS VALUE_INT Symbol NAMEVAR RIGHT_PARENTHESIS{ write_condicional_sentece_int_namevar(output_file, $3, $4, $5); }    

/* DOUBLE with VAR */
    | IF_ NAMEVAR Symbol VALUE_DOUBLE { write_condicional_sentece_namevar_double(output_file, $2, $3, $4); }    
    | IF_ LEFT_PARENTHESIS NAMEVAR Symbol VALUE_DOUBLE RIGHT_PARENTHESIS{ write_condicional_sentece_namevar_double(output_file, $3, $4, $5); }    
/* VAR with DOUBLE */
    | IF_ VALUE_DOUBLE Symbol NAMEVAR { write_condicional_sentece_double_namevar(output_file, $2, $3, $4); }    
    | IF_ LEFT_PARENTHESIS VALUE_DOUBLE Symbol NAMEVAR RIGHT_PARENTHESIS{ write_condicional_sentece_double_namevar(output_file, $3, $4, $5); }


/* STRING with VAR */
    | IF_ NAMEVAR Symbol VALUE_STRING { write_condicional_sentece_namevar_string(output_file, $2, $3, $4); }    
    | IF_ LEFT_PARENTHESIS NAMEVAR Symbol VALUE_STRING RIGHT_PARENTHESIS{ write_condicional_sentece_namevar_string(output_file, $3, $4, $5); }    
/* VAR with STRING */
    | IF_ VALUE_STRING Symbol NAMEVAR { write_condicional_sentece_string_namevar(output_file, $2, $3, $4); }    
    | IF_ LEFT_PARENTHESIS VALUE_STRING Symbol NAMEVAR RIGHT_PARENTHESIS{ write_condicional_sentece_string_namevar(output_file, $3, $4, $5); }


;
Fase02:
    NAMEVAR SEMICOLON
;

Condition:
  NAMEVAR COMPARATOR NAMEVAR
  | AND_ Condition
  | OR_ Condition
;

ConditionalBegin:
    IF_ Condition THAN_
;

ConditionalEnd:
    ELSE_ AlgorithmBody
    | END_IF_
;

ConditionalStruct:
    ConditionalBegin AlgorithmBody ConditionalEnd
;

Symbol:
    EQUAL
    | NOT_EQUAL
    | GREATER_EQUAL
    | GREATER
    | LESS_EQUAL
    | LESS
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

