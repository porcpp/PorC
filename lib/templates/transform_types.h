#include "../simbol_table/simbol_table.h"
#ifndef TRANSFORM_TYPES
#define TRANSFORM_TYPES

#define MAX_NUMBER_OF_CARACTERS 60

char* transform_int_string(int value_tobe_converted);
char* transform_double_string(double value_tobe_converted);
char* transform_simbol_comparator(char* simbol_comparator);
char* transform_type_inital_value(char* type);
char* transform_type_input(SimbolTable* simbols, char* type, char* variable);

#endif
