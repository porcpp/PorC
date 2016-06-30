#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "transform_types.h"
#include "../simbol_table/simbol_table.h"

#include "../util/log.h"

extern int yyerror(char* errmsg);


char* transform_int_string(int value_tobe_converted) {
    char* destiny_pointer = malloc(MAX_NUMBER_OF_CARACTERS*sizeof (char));

    if (destiny_pointer != NULL) {
        sprintf(destiny_pointer, "%d", value_tobe_converted);
    } else {
        Log_error("\nERROR - Could not alloc memory for int -> str conversion\n");
        yyerror("\nERROR - Could not alloc memory for int -> str conversion\n");
        exit(1);
    }

    return destiny_pointer;
}


char* transform_double_string(double value_tobe_converted) {
    char* destiny_pointer = malloc(MAX_NUMBER_OF_CARACTERS*sizeof (char));

    if (destiny_pointer != NULL) {
        sprintf(destiny_pointer, "%lf", value_tobe_converted);
    } else {
        Log_error("\nERROR - Nao foi possivel alocar memoria\n");
        yyerror("\nERROR - Nao foi possivel alocar memoria\n");
        exit(1);
    }

    return destiny_pointer;
}


char* transform_simbol_comparator(char* simbol_comparator) {
    assert(simbol_comparator != NULL);

    if (simbol_comparator != NULL) {
        if(strcmp(simbol_comparator, "<>") == 0) {
            strcpy(simbol_comparator, "!=");
        } else if(strcmp(simbol_comparator, "=") == 0) {
           strcpy(simbol_comparator, "==");
        } else{
          //Do nothing
        }
    } else {
        Log_error("\nERROR - Nao foi possivel alocar memoria\n");
        yyerror("\nERROR - Nao foi possivel alocar memoria\n");
        exit(1);
    }

    return simbol_comparator;
}


char* transform_type_inital_value(char* type){
    // Only uses cut circuit to not use malloc function
    if (!strcmp(type,"int")){
        return "0";
    }else if(!strcmp(type,"char")){
        return "' '";
    }else if(!strcmp(type,"double")){
        return "0.0";
    }else if(!strcmp(type,"bool")){
        return "0";
    }else if(!strcmp(type,"char*")){
        return "(char*) malloc(sizeof(char)*200)";
    }else{
        Log_error("Invalid type transformation");
        exit(0);
    }

}

char* transform_type_input(SimbolTable* simbols, char* type, char* variable){
    type =  malloc(MAX_NUMBER_OF_CARACTERS*sizeof (char));
    Variable* variable_type = SimbolTable_find(simbols,variable);
    if(variable_type != NULL){
        if(!strcmp(variable_type->type,"int") ){
            type= "\%d";
        } else if(!strcmp(variable_type->type,"char")){
            strcpy(type,"\%c");
        } else if(!strcmp(variable_type->type,"double")){
            strcpy(type,"\%lf");
        } else if(!strcmp(variable_type->type,"char*")){
            strcpy(type,"\%s");
        } else{
            Log_error("Invalid type in variable");
            exit(0);
        }
    }
    return type;
}
