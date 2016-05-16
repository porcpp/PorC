#include "verify_templates.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//const int NOT_FOUND = 0;
//const int INVALID_TYPE = 1;

int verify_type(SimbolTable* simbols, char* name, char* type) {
    printf("\nDEBUG - Params of input %s %s\n", name, type);

    Variable* variable = SimbolTable_find(simbols, name); // Get the variable if exist in simbol table
    int valid = 0;

    if(variable != NULL) {
        printf("\nDEBUG - Value of type %s\n", variable->type);

        if(strcmp(type, variable->type) == 0) {
            printf("\nDEBUG - Type is equals");
            // Verify if the type os value is the same of variable
            valid = 1;
        }else{
            yyerror("Type of variable is different of value");
            exit(0);
           //valid = INVALID_TYPE;
        }
    }else{
        yyerror("Variable name not found");
        exit(0);
        //valid = NOT_FOUND;
        //Variable not found
    }

    return valid;
}

