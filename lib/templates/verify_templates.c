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

        sprintf(string_to_file,"Variable {%s} already declared", variable->name);
        yyerror(string_to_file);
        exit(0);
    }else{
        printf("DEBUG - Variable %s is permited\n", variable->name);
    }
}

int verify_type(SimbolTable * simbols,char * name, char * type){
    printf("\nDEBUG - Params of input %s %s\n",name,type);

    Variable * variable = SimbolTable_find(simbols,name); // Get the variable if exist in simbol table
    int valid = 0;

    if( variable != NULL){
        printf("\nDEBUG - Value of type %s \n",variable->type);

        if( !strcmp(type,variable->type) ){
            printf("\nDEBUG - Type is equals");
            // Verify if the type os value is the same of variable
            valid = 1;
        }else{
            yyerror("Type of variable is different of value");
            exit(0);
        }
    }else{
        yyerror("Variable name not found");
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
