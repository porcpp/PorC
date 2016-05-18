#ifndef C_TEMPLATES
#define C_TEMPLATES

#define MAX_STRING_SIZE 80

void write_to_file(FILE* file, const char* content);

void write_declares_variable(FILE* file, const char* content, const char* content01);

void write_atribute_variable(FILE* file, const char* content, const char* content01);

void write_declares_variable_with_comma(FILE* file, const char* content);

void write_end_line(FILE* file);

void write_default_header(FILE* file);

void write_body_begin(FILE* file);

void write_body_end(FILE* file);

void write_condicional_sentece(FILE* file, const char* content, const char* content01, const char* content02);

void write_declares_vector(FILE* file, const char* content, const char* content01);

void write_declares_matrix(FILE* file, const char* content, const char* content01, const char* content02);

#endif

