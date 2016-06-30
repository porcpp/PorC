#include <stdio.h>
#ifndef C_TEMPLATES
#define C_TEMPLATES

#define MAX_STRING_SIZE 80

void write_to_file(FILE* file, const char* content);

void write_declares_variable(FILE* file, const char* content, const char* content01, const char* initial_value);

void write_atribute_variable(FILE* file, const char* content, const char* content01);

void write_atribute_variable_string(FILE* file, const char* content, const char* content01);

void write_declares_variable_with_comma(FILE* file, const char* content, const char* initial_value);

void write_end_line(FILE* file);

void write_default_header(FILE* file);

void write_body_begin(FILE* file);

void write_body_end(FILE* file);

void write_condicional_sentece(FILE* file, const char* content, const char* content01, const char* content02);

void write_tabulation(FILE* file,int counter);

void write_declares_vector(FILE* file, const char* content, const char* content01);
void write_declares_vector_type(FILE* file, const char* content, const char* size_vector, const char* type);
void write_initialize_vector(FILE* file, const char* content, const char* size_vector, const char* type);
void write_declares_matrix_type(FILE* file, const char* content, const char* size_vector_n,const char* size_vector_m, const char* type);
void write_initialize_matrix(FILE* file, const char* content, const char* size_vector_n, const char* size_vector_m, const char* type);  
  
//Aritimetic sentenses

void write_declares_matrix(FILE* file, const char* content, const char* content01, const char* content02);

void write_aritmetic(FILE* file, char* operator, char* name_variable);

void write_for_statement(FILE* file, const char* content, const char* content01,const char* content02);

void write_for_statement_end(FILE* file, const char* content, int step);

void write_input_file(FILE* file, const char* name, const char* type);

void write_print(FILE* file, const char* content);

#endif

