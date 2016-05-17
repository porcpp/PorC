#ifndef VERIFY_TEMPLATES
#define VERIFY_TEMPLATES
#include "../simbol_table/simbol_table.h"

#define VALID_TYPE 2
//const char[] INT = "inteiro";
//const char[] DOUBLE = "real";
//const char[] CHAR = "caractere";
//const char[] STRING = "literal";

//const int NOT_FOUND = 0;
//const int INVALID_TYPE = 1;
//const int VALID_TYPE = 2;
int verify_type(SimbolTable* simbols, char* name, char* type);
#endif
