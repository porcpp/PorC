#include "../simbol_table/simbol_table.h"
#include <stdio.h>


#ifndef VERIFY_TEMPLATES
#define VERIFY_TEMPLATES

#define VALID_TYPE 2
//const char[] INT = "inteiro";
//const char[] DOUBLE = "real";
//const char[] CHAR = "caractere";
//const char[] STRING = "literal";

//const int NOT_FOUND = 0;
//const int INVALID_TYPE = 1;
//const int VALID_TYPE = 2;

int verify_type(SimbolTable * simbols,char * name, char * type);

unsigned short is_number(SimbolTable* simbols, char* name);

static unsigned short valid_types(char* type);

//Aritmetic methods
void write_variable_if_valid(FILE* file, SimbolTable* simbols, char* name);
void verify_variable_already_added(SimbolTable* simbol_table, Variable* variable);
void write_operator_variable_valid(FILE* file, SimbolTable* simbols, char* operator, char* variable);

#endif
