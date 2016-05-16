#include "../simbol_table/simbol_table.h"


#ifndef VERIFY_TEMPLATES

#define VERIFY_TEMPLATES

//const char[] INT = "inteiro";
//const char[] DOUBLE = "real";
//const char[] CHAR = "caractere";
//const char[] STRING = "literal";

int verify_type(SimbolTable * simbols,char * name, char * type);
void verify_variable_already_added(SimbolTable* simbol_table, Variable* variable);
#endif
