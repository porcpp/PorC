#include "verify_templates.h"
#include <stdio.h>
#include <string.h>


int verify_type(SimbolTable * simbols,char * name, char * type){

    Variables * variable = SimbolTable_find(simbols,name); // Get the variable if exist in simbol table

    int valid = 0;
    
    if( variable != NULL){
        if( !strcmp(type,variable->type) ){ 
            // Verify if the type os value is the same of variable
            valid = 1;
        }else{
            printf("DEBUG - Type of variable is different of value\n");
        }
    }else{
        printf("DEBUG - Variable name not found\n");
        // Variable not found
    }
    return valid;   
}


