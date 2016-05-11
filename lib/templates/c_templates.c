#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "c_templates.h"


void write_to_file(FILE* file, char* content) {
    if (file != NULL) {
        fprintf(file, "%s", content);
    } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}

void write_declares_variable_with_comma(FILE* file, char* content) {
    if (file != NULL) {
        fprintf(file, ", %s", content);
    } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}

void write_declares_variable(FILE* file, char* content, char* content01) {
    if (file != NULL) {
        fprintf(file, "\t%s %s", content, content01);
   } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}

void write_atribute_variable(FILE* file, char* content, char* content01) {
    if (file != NULL) {
        fprintf(file, "\n\t%s = %s;\n", content, content01);
   } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
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


void write_condicional_sentece(FILE* file, char* content, char* content01, char* content02) {
    char string_to_file[60];
    
    sprintf(string_to_file,"(%s %s %s)",content,content01,content02);
    write_to_file(file,string_to_file);
}
void write_declares_vector(FILE* file, char* content, char* content01, char* content02){
    char string_to_file[60];
    sprintf(string_to_file,"%s %s[%s]",content,content01,content02);
    write_to_file(file,string_to_file);
}
void write_declares_matrix(FILE* file, char* content, char* content01, char* content02, char* content03){
    char string_to_file[60];
    sprintf(string_to_file,"%s %s[%s][%s]",content,content01,content02,content03);
    write_to_file(file,string_to_file);
}

