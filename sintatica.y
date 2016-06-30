%{
#include <stdlib.h>
#include <stdio.h>
#include "lib/templates/c_templates.h"
#include "lib/templates/transform_types.h"
#include "lib/simbol_table/simbol_table.h"
#include "lib/templates/verify_templates.h"
#include "lib/util/log.h"
#include "lib/util/string_builder.h"
#include "lib/util/translate.h"
#include <string.h>

FILE* output_file = NULL;
char* type=NULL;
char* value=NULL;
char* variableToFor=NULL;
extern int quantity_lines;
const unsigned short MAX_LOG_MESSAGE_SIZE;
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

%token <strval> NOME_VARIAVEL

/* define types of attribution */
%token ATRIBUICAO

%token <ival> VALOR_INTEIRO
%token <dval> VALOR_REAL
%token <strval> VALOR_LITERAL
%token <strval> VALOR_CARACTERE


%token PALAVRA_RESERVADA_C
%token PARA_IMPLEMENTAR
%token ALGORITMO
%token FIM_ALGORITMO
%token CONSTANTE
%token VARIAVEIS
%token FIM_VARIAVEIS
%token INICIO_
%token FIM_
/* define tokens off operations */

%token <strval> COMPARADOR
%token <strval> ARITMETICA_BASICA
%token <strval> VEZES
%token <strval> DIVISAO

%token PARENTESE_ESQUERDO
%token PARENTESE_DIREITO
%token CHAVE_ESQUERDA
%token CHAVE_DIREITA
%token COLCHETE_ESQUERDA
%token COLCHETE_DIREITA

/* define tokens type */
%token <strval> TIPO_INTEIRO
%token <strval> TIPO_REAL
%token <strval> TIPO_BOOLEANO
%token <strval> TIPO_CARACTERE
%token <strval> TIPO_LITERAL
%token MATRIZ

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

%token COMENTARIO
%token VIRGULA
%token PONTO
%token PONTO_VIRGULA

%token SE_
%token ENTAO
%token SENAO
%token FIM_SE
%token E_
%token OU_

%token ENQUANTO
%token FIM_ENQUANTO
%token FACA
%token FIM_PARA
%token PARA
%token DE_
%token ATE_
%token PASSO

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
    ALGORITMO NOME_VARIAVEL PONTO_VIRGULA {
        simbols = SimbolTable_new();
        open_output_file($2);
        write_default_header(output_file);
        write_body_begin(output_file);
    }
;
HeaderVariables:
    VARIAVEIS FIM_VARIAVEIS
    | VARIAVEIS MultiVariables FIM_VARIAVEIS{write_to_file(output_file,";\n");}
;
MultiVariables:
    Variables
    | Variables{write_to_file(output_file,";\n");}MultiVariables
;
Variables:
    NOME_VARIAVEL PONTO Variables {
        verify_before_insert(simbols,$1,type);
        write_tabulation(output_file,counter_tabulation);
        write_declares_variable_with_comma(output_file, $1,transform_type_inital_value(type));
    }
    | NOME_VARIAVEL VIRGULA Type {type=$3;} PONTO_VIRGULA {
        verify_before_insert(simbols,$1,$3);
        write_tabulation(output_file,counter_tabulation);
        write_declares_variable(output_file, $3 , $1,transform_type_inital_value(type));
    }
    | NOME_VARIAVEL VIRGULA MATRIZ DimensionMatrix DE_ Type PONTO_VIRGULA {
	verify_before_insert(simbols,$1,$6);
        write_tabulation(output_file,counter_tabulation);
    	write_declares_vector_type(output_file,$1,$4,$6);    
	write_tabulation(output_file,counter_tabulation);  	    	
	write_initialize_vector(output_file,$1,$4,$6);
    }
    | NOME_VARIAVEL VIRGULA MATRIZ DimensionMatrix DimensionMatrix DE_ Type PONTO_VIRGULA {
        verify_before_insert(simbols,$1,$7);
        write_tabulation(output_file,counter_tabulation);
        write_declares_matrix_type(output_file, $1, $4, $5, $7);   
	write_tabulation(output_file,counter_tabulation);  	    	
	write_initialize_matrix(output_file,$1,$4,$5,$7);
    }
;
DimensionMatrix:
    COLCHETE_ESQUERDA VALOR_INTEIRO COLCHETE_DIREITA { $$ = transform_int_string($2); }
;
Type:
    TIPO_INTEIRO
    |TIPO_REAL
    |TIPO_CARACTERE
    |TIPO_BOOLEANO
    |TIPO_LITERAL
;

AttribuitionVariables:
    NOME_VARIAVEL ATRIBUICAO VALOR_LITERAL PONTO_VIRGULA {
        write_tabulation(output_file,counter_tabulation);
        verify_type(simbols,$1,"char*");
        write_atribute_variable_string(output_file, $1, $3);
    }

    | NOME_VARIAVEL ATRIBUICAO VALOR_CARACTERE PONTO_VIRGULA {
        write_tabulation(output_file,counter_tabulation);
        verify_type(simbols,$1,"char");
        write_atribute_variable(output_file, $1, $3);
    }

    | NOME_VARIAVEL ATRIBUICAO {
        write_tabulation(output_file,counter_tabulation);
        write_valid_aritmetic(output_file,simbols,$1);
    } Operations PONTO_VIRGULA { write_to_file(output_file,";\n"); }

    | NOME_VARIAVEL DimensionMatrix ATRIBUICAO{
        write_tabulation(output_file,counter_tabulation);
        write_declares_vector(output_file, $1, $2);
	write_to_file(output_file, " = ");
     } Operations PONTO_VIRGULA { write_to_file(output_file,";\n"); }
     
     | NOME_VARIAVEL DimensionMatrix ATRIBUICAO VALOR_CARACTERE{
        write_tabulation(output_file,counter_tabulation);
        write_declares_vector(output_file, $1, $2);
	verify_type(simbols,$1,"char"); 
        write_to_file(output_file, " = ");
        write_to_file(output_file, $4);
     } PONTO_VIRGULA { write_to_file(output_file,";\n"); }

    | NOME_VARIAVEL DimensionMatrix DimensionMatrix ATRIBUICAO {
        write_tabulation(output_file,counter_tabulation);
        write_declares_matrix(output_file, $1, $2,$3);
        write_to_file(output_file, " = ");
    } Operations PONTO_VIRGULA{ write_to_file(output_file,";\n"); }

    | NOME_VARIAVEL DimensionMatrix DimensionMatrix ATRIBUICAO VALOR_CARACTERE{
        write_tabulation(output_file,counter_tabulation);
        write_declares_matrix(output_file, $1, $2,$3);
	verify_type(simbols,$1,"char"); 
	write_to_file(output_file, " = ");    
        write_to_file(output_file, $5); 
     } PONTO_VIRGULA { write_to_file(output_file,";\n");}

;

ValuesNumber:
  VALOR_INTEIRO { $$ = transform_int_string($1); }
  | VALOR_REAL { $$ = transform_double_string($1); }
;
ValuesString:
  VALOR_LITERAL
  | VALOR_CARACTERE
;


Values:
  NOME_VARIAVEL COMPARADOR NOME_VARIAVEL {
       transform_simbol_comparator($2);
       write_condicional_sentece(output_file, $1, $2, $3);
  }
  | NOME_VARIAVEL COMPARADOR ValuesNumber { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesNumber COMPARADOR NOME_VARIAVEL { write_condicional_sentece(output_file, $1, $2, $3); }
  | NOME_VARIAVEL COMPARADOR ValuesString { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesString COMPARADOR NOME_VARIAVEL { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesNumber COMPARADOR ValuesNumber { write_condicional_sentece(output_file, $1, $2, $3); }
  | ValuesString COMPARADOR ValuesString { write_condicional_sentece(output_file, $1, $2, $3); }
  | NOME_VARIAVEL DimensionMatrix COMPARADOR ValuesNumber {
        write_declares_vector(output_file, $1,$2);
        write_condicional_sentece(output_file," ",$3,$4);
  }
  | ValuesNumber COMPARADOR NOME_VARIAVEL DimensionMatrix {
        write_declares_vector(output_file, $1,$2);
        write_condicional_sentece(output_file," ",$3,$4);
  }
  | NOME_VARIAVEL DimensionMatrix COMPARADOR ValuesString {
        write_declares_vector(output_file, $1,$2);
        write_condicional_sentece(output_file," ",$3,$4);
  }
  | ValuesString COMPARADOR NOME_VARIAVEL DimensionMatrix {
        write_declares_vector(output_file, $1,$2);
        write_condicional_sentece(output_file," ",$3,$4);
  }
  | NOME_VARIAVEL DimensionMatrix DimensionMatrix COMPARADOR ValuesNumber {
        write_declares_matrix(output_file, $1,$2,$3);
        write_condicional_sentece(output_file," ",$4,$5);
  }
  | NOME_VARIAVEL DimensionMatrix DimensionMatrix COMPARADOR ValuesString {
        write_declares_matrix(output_file, $1,$2,$3);
        write_condicional_sentece(output_file," ",$4,$5);
  }
  | ValuesNumber COMPARADOR  NOME_VARIAVEL DimensionMatrix DimensionMatrix {
        write_declares_matrix(output_file, $1,$2,$3);
        write_condicional_sentece(output_file," ",$4,$5);
  }
  | ValuesString COMPARADOR  NOME_VARIAVEL DimensionMatrix DimensionMatrix {
        write_declares_matrix(output_file, $1,$2,$3);
        write_condicional_sentece(output_file," ",$4,$5);
  }
;

Operator:
    ARITMETICA_BASICA
    | VEZES
    | DIVISAO
;

Aritmetic:
    NOME_VARIAVEL { write_variable_if_valid(output_file, simbols, $1); }
    | ValuesNumber { write_to_file(output_file, $1); }
    | ARITMETICA_BASICA NOME_VARIAVEL {
        write_operator_variable_valid(output_file,simbols,$1,$2);
    }
    | ARITMETICA_BASICA ValuesNumber {
        write_aritmetic(output_file,$1,$2);
    }
    | Aritmetic Operator {write_to_file(output_file,$2); } Aritmetic
    | Aritmetic Operator {write_to_file(output_file,$2); } Parenthesis
;

Parenthesis:
    PARENTESE_ESQUERDO {
      write_to_file(output_file,"(");
    } Operations PARENTESE_DIREITO { write_to_file(output_file,")"); }
;
Operations:
    Aritmetic
    | Parenthesis
    | Parenthesis Operator { write_to_file(output_file,$2); } Operations
;

AndOr:
  E_ { write_to_file(output_file, " && "); } Condition
  | OU_ { write_to_file(output_file, " || "); } Condition
;

Condition:
  Values
  | Values AndOr

;

ConditionalBegin:
    SE_ {
        write_tabulation(output_file,counter_tabulation);
        write_to_file(output_file, "if (");
    } Condition ENTAO{
        write_to_file(output_file, ") {\n");
        counter_tabulation++;
    }
;

ConditionalEnd:
    SENAO {
        counter_tabulation--;
        write_tabulation(output_file,counter_tabulation);
        counter_tabulation++;
        write_to_file(output_file, "} else{\n");
    } AlgorithmBody ConditionalEnd
    | FIM_SE {
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
    ENQUANTO {
        write_tabulation(output_file,counter_tabulation);
        write_to_file(output_file,"while (");
    }
    Condition FACA {
        counter_loop++;
        write_to_file(output_file,") {\n");
        counter_loop--;
        write_tabulation(output_file,counter_loop);
        counter_loop++;
     } AlgorithmBody FIM_ENQUANTO {
        counter_loop--;
        write_tabulation(output_file,counter_loop);
        write_to_file(output_file,"}\n");
    }
    | PARA NOME_VARIAVEL DE_ {
        verify_type(simbols,$2,"int");
        variableToFor = $2;
        write_tabulation(output_file,counter_tabulation);
        write_to_file(output_file,"for(");
    } ForStep FACA { counter_tabulation++; }
    AlgorithmBody { counter_tabulation--; }
    FIM_PARA {
        write_tabulation(output_file,counter_tabulation);
        write_to_file(output_file,"}\n");
    }
;

ForStatement:
    VALOR_INTEIRO ATE_ VALOR_INTEIRO{
        char *aux;
        value = transform_int_string($3);
        aux = transform_int_string($1);
        write_for_statement(output_file,aux,value,variableToFor);
        free(aux);
    }
    | VALOR_INTEIRO ATE_ NOME_VARIAVEL{
        value = transform_int_string($1);
        write_for_statement(output_file,value,$3,variableToFor);
    }
    | NOME_VARIAVEL ATE_ VALOR_INTEIRO{
        value = transform_int_string($3);
        write_for_statement(output_file,$1,value,variableToFor);
    }
    | NOME_VARIAVEL ATE_ NOME_VARIAVEL{
        verify_type(simbols,$1,"int");
        verify_type(simbols,$3,"int");
        write_for_statement(output_file,$1,$3,variableToFor);
    }
;

ForStep:
    ForStatement{
        write_for_statement_end(output_file,variableToFor,1);
    }
    | ForStatement PASSO VALOR_INTEIRO{
        write_for_statement_end(output_file,variableToFor,$3);
    }
    |ForStatement PASSO ARITMETICA_BASICA VALOR_INTEIRO {
        write_for_statement_end(output_file,variableToFor,-$4);
    }
;

InputFunction:
    NOME_VARIAVEL ATRIBUICAO LEIA PARENTESE_ESQUERDO PARENTESE_DIREITO PONTO_VIRGULA { 
        write_tabulation(output_file,counter_tabulation);
        char* type = NULL;
        type = transform_type_input(simbols,type,$1);
        write_input_file(output_file,$1,type);
    }
;

PrintBody:
    VALOR_LITERAL { StrList_add(strList, $1, "string"); }
    | NOME_VARIAVEL { StrList_add(strList, $1, "variable"); }
    | VALOR_LITERAL PONTO PrintBody {  StrList_add(strList, $1, "string"); }
    | NOME_VARIAVEL PONTO PrintBody { StrList_add(strList, $1, "variable"); }
;

PrintStep:
    IMPRIMA PARENTESE_ESQUERDO { strList = StrList_new(); } PrintBody PARENTESE_DIREITO PONTO_VIRGULA {
        char* printfStr = StrList_makePrint(strList, simbols);
        write_tabulation(output_file,counter_tabulation);
        write_print(output_file, printfStr);
        StrList_destroy(strList);
        free(printfStr);
    }

;

Body:
    INICIO_ FIM_ {
        write_body_end(output_file);
        close_output_file();
    }
    | INICIO_ AlgorithmBody FIM_ {
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
    char* message = (char*) malloc(sizeof(char)*1000);
    sprintf(message,"\nErro: %s na linha: %d\n", translate_message(errmsg,message), quantity_lines);
    printf("%s",message);
    Log_error(message);
    free(message);
    return 0;
}


int yywrap() {
  return 1;
}


int main(int argc, char** argv) {
    yyparse();
    return 0;
}

