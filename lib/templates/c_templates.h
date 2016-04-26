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


//Conditional senteces
void write_condicional_sentece_namevar(FILE* file, char* content, char* content01, char* content02);

void write_condicional_sentece_namevar_int(FILE* file, char* content, char* content01, int content02);

void write_condicional_sentece_int_namevar(FILE* file, int content, char* content01, char* content02);

void write_condicional_sentece_double_namevar(FILE* file, double content, char* content01, char* content02);

void write_condicional_sentece_namevar_double(FILE* file, char* content, char* content01, double content02);

void write_condicional_sentece_string_namevar(FILE* file, char* content, char* content01, char* content02);

void write_condicional_sentece_namevar_string(FILE* file, char* content, char* content01, char* content02);


void write_condicional_sentece_int(FILE* file, int content, char* content01, int content02);

void write_condicional_sentece_double(FILE* file, double content, char* content01, double content02);


#endif
