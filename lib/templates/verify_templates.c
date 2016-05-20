#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../simbol_table/variable.h"
#include "../simbol_table/simbol_table.h"
#include "verify_templates.h"


void verify_variable_already_added(SimbolTable* simbol_table, Variable* variable){
    Variable* variable_already_added = SimbolTable_find(simbol_table, variable->name);

    if(variable_already_added != NULL){
        char string_to_file[60];

        sprintf(string_to_file,"Variavel {%s} ja foi declarada", variable->name);
        yyerror(string_to_file);
        exit(0);
    }else{
        printf("DEBUG - Variavel %s e permitida\n", variable->name);
    }
}

int verify_type(SimbolTable * simbols,char * name, char * type){
    printf("\nDEBUG - Parametro da entrada %s %s\n",name,type);

    Variable * variable = SimbolTable_find(simbols,name); // Get the variable if exist in simbol table
    int valid = 0;

    if( variable != NULL){
        printf("\nDEBUG - Valor do tipo %s \n",variable->type);

        if( !strcmp(type,variable->type) ){
            printf("\nDEBUG - Tipo e igual");
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
