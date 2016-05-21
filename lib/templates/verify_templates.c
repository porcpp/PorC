#include "../simbol_table/simbol_table.h"
#include "../simbol_table/variable.h"
#include "c_templates.h"
#include "verify_templates.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//const int NOT_FOUND = 0;
//const int INVALID_TYPE = 1;
//const int VALID_TYPE = 2;
char valid_types_list[4][10] = {
    "int", "double", "string", "char"
};
extern int quantity_lines;


void verify_variable_already_added(SimbolTable* simbol_table, Variable* variable){
    Variable* variable_already_added = SimbolTable_find(simbol_table, variable->name);

    if(variable_already_added != NULL){
        char string_to_file[60];

        sprintf(string_to_file,"Variavel '%s' ja foi declarada", variable->name);
        yyerror(string_to_file);
        exit(0);
    }else{
        printf("DEBUG DECLARACAO DE VARIAVEL - Variavel '%s' na linha:'%d' e permitida\n", variable->name,quantity_lines);
    }
}

int verify_type(SimbolTable * simbols,char * name, char * type){
    printf("\nDEBUG ATRIBUICAO - Parametro da entrada '%s %s' na linha:'%d' \n",type,name,quantity_lines);

    Variable* variable = SimbolTable_find(simbols, name); // Get the variable if exist in simbol table
    int valid = 0;

    if( variable != NULL){
        printf("DEBUG ATRIBUICAO - Valor do tipo '%s' na linha:'%d' \n",variable->type,quantity_lines);

        if( !strcmp(type,variable->type) ){
            printf("DEBUG ATRIBUICAO - Tipo e igual na linha:'%d' \n",quantity_lines);
            // Verify if the type os value is the same of variable
            valid = 1;
        }else{
            yyerror("Tipo da variavel e diferente do valor");
            exit(0);
           //valid = INVALID_TYPE;
        }
    }else{
        yyerror("O nome da variavel nao for encontrada");
        exit(0);
        //valid = NOT_FOUND;
        //Variable not found
    }

    return valid;
}


unsigned short is_number(SimbolTable* simbols, char* name) {
    assert(name != NULL);
    unsigned short valid_number = 0;

    Variable* variable = SimbolTable_find(simbols, name);

    if (variable != NULL) {
        if (strcmp(variable->type, valid_types_list[0]) == 0 ||
            strcmp(variable->type, valid_types_list[1]) == 0) {
            valid_number = 1;
        }
    }

    return valid_number;
}


static unsigned short valid_types(char* type) {
    assert(type != NULL);
    unsigned short is_a_valid_type = 0;

    for (int i = 0; i < 4; ++i) {
        if (strcmp(type, valid_types_list[i]) == 0) {
            is_a_valid_type = 1;
            break;
        }
    }

    return is_a_valid_type;
}


void write_variable_if_valid(FILE* file, SimbolTable* simbols, char* name) {
    assert(file != NULL);
    assert(simbols != NULL);

    if(is_number(simbols, name)) {
        write_to_file(file, name);
    } else {
        printf("\nDEBUG: invalid aritmetic %s is not int or double", name);
        exit(0);
    }
}

void write_operator_variable_valid(FILE* file, SimbolTable* simbols,
    char* operator, char* name){
    assert(file != NULL);
    assert(simbols != NULL);
    assert(name != NULL);
    
    if(is_number(simbols, name)){
        write_aritmetic(file, operator, name);
    } else {
        printf("\nERROR: invalid operation with variable, %s is not int or double",name);
        exit(0);
    }
}
void write_valid_aritmetic(FILE* file, SimbolTable* simbols, char* name){
    assert(file != NULL);
    assert(simbols != NULL);
    assert(name != NULL);

    if(is_number(simbols,name)){
        write_aritmetic(file,name, "= ");
    } else {
        printf("ERROR: can't make aritmetic attributions to %s with types: char or string",name);
        exit(0);
    }
}
void verify_before_insert(SimbolTable* simbol_table, char* name, char* type) {
    Variable* variable = Variable_new(name, type);

    verify_variable_already_added(simbol_table, variable);
    SimbolTable_insert(simbol_table, name,type);
    free(variable);
}
