#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../simbol_table/variable.h"
#include "../simbol_table/simbol_table.h"
#include "verify_templates.h"

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

    Variable * variable = SimbolTable_find(simbols,name); // Get the variable if exist in simbol table
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
        }
    }else{
        yyerror("O nome da variavel nao for encontrada");
        exit(0);
        // Variable not found
    }
    return valid;
}


void verify_before_insert(SimbolTable* simbol_table, char* name, char* type) {
    Variable* variable = Variable_new(name, type);

    verify_variable_already_added(simbol_table, variable);
    SimbolTable_insert(simbol_table, name,type);
    free(variable);
}
