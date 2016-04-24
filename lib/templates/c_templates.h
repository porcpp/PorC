#ifndef C_TEMPLATES
#define C_TEMPLATES

void write_to_file_or_die(FILE* file, char* content);

void write_declares_variable(FILE* file, char* content, char* content01);

void write_atribute_variable_int(FILE* file, char* content, int content01);

void write_atribute_variable_double(FILE* file, char* content, double content01);

void write_atribute_variable_string(FILE* file, char* content, char* content01);

void write_declares_variable_with_comma(FILE* file, char* content);

void write_end_line(FILE* file);

void write_default_header(FILE* file);

void write_body_begin(FILE* file);

void write_body_end(FILE* file);

#endif
