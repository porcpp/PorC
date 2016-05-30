#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "c_templates.h"

int i;

void write_to_file(FILE* file, const char* content) {
    if (file != NULL) {
        fprintf(file, "%s", content);
    } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}

void write_declares_variable_with_comma(FILE* file, const char* content) {
    char data[MAX_STRING_SIZE];

    sprintf(data, ", %s", content);
    write_to_file(file, data);
}


void write_declares_variable(FILE* file, const char* content, const char* content01) {
    char data[MAX_STRING_SIZE];

    sprintf(data, "%s %s",content, content01);
    write_to_file(file, data);
}


void write_atribute_variable(FILE* file, const char* content, const char* content01) {
    char data[MAX_STRING_SIZE];

    sprintf(data, "%s = %s;\n", content, content01);
    write_to_file(file, data);
}


void write_tabulation(FILE* file,int counter){
    for(i=0;i<counter;i++){
        write_to_file(file,"    ");
    }
}

void write_default_header(FILE* file) {
    write_to_file(file, "#include <stdlib.h>\n");
    write_to_file(file, "#include <stdio.h>\n");
}


void write_body_begin(FILE* file) {
    write_to_file(file, "\nint main() {\n");
}


void write_body_end(FILE* file) {
    write_to_file(file, "\nreturn 0;\n}");
}


void write_condicional_sentece(FILE* file, const char* content, const char* content01, const char* content02) {
    char string_to_file[MAX_STRING_SIZE];

    sprintf(string_to_file,"%s %s %s", content, content01, content02);
    write_to_file(file,string_to_file);
}


void write_declares_vector(FILE* file, const char* content, const char* content01) {
    char string_to_file[MAX_STRING_SIZE];

    sprintf(string_to_file," %s[%s]", content, content01);
    write_to_file(file,string_to_file);
}

void write_declares_matrix(FILE* file, const char* content, const char* content01, const char* content02) {
    char string_to_file[MAX_STRING_SIZE];

    sprintf(string_to_file," %s[%s][%s]", content, content01, content02);
    write_to_file(file,string_to_file);
}
void write_aritmetic(FILE* file, char* operator, char* variable_number){
    char string_to_file[MAX_STRING_SIZE];
    sprintf(string_to_file,"%s %s",operator, variable_number);
    write_to_file(file,string_to_file);
}
void write_for_struct(){
}
