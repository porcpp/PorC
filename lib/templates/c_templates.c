#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "c_templates.h"


void write_to_file_or_die(FILE* file, char* content) {
    if (file != NULL) {
        fprintf(file, "%s", content);
    } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}

void write_declares_variable_with_comma(FILE* file, char* content) {
    char string_to_file[60];

    sprintf(string_to_file,", %s",content);
    write_to_file_or_die(file,string_to_file);
}

void write_declares_variable(FILE* file, char* content, char* content01) {
    char string_to_file[60];

    sprintf(string_to_file,"\t%s %s",content,content01);
    write_to_file_or_die(file,string_to_file);
}


void write_atribute_variable_int(FILE* file, char* content, int content01) {
    char string_to_file[60];

    sprintf(string_to_file,"\n\t%s = %d;\n",content,content01);
    write_to_file_or_die(file,string_to_file);
}


void write_atribute_variable_string(FILE* file, char* content, char* content01) {
    char string_to_file[60];

    sprintf(string_to_file,"\n\t%s = %s;\n",content,content01);
    write_to_file_or_die(file,string_to_file);
}


void write_atribute_variable_double(FILE* file, char* content, double content01) {
    char string_to_file[60];

    sprintf(string_to_file,"\n\t%s = %lf;\n",content,content01);
    write_to_file_or_die(file,string_to_file);
}

void write_default_header(FILE* file) {
    write_to_file_or_die(file, "#include <stdlib.h>\n");
    write_to_file_or_die(file, "#include <stdio.h>\n");
}


void write_body_begin(FILE* file) {
    write_to_file_or_die(file, "\nint main() {\n");
}


void write_body_end(FILE* file) {
    write_to_file_or_die(file, "\nreturn 0;\n}");
}



void write_to_file_open_close_conditional(FILE* file, char* content) {
    if (file != NULL) {
        fprintf(file, "\n\t%s\n\t\t", content);
    } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}

void write_condicional_sentece_namevar(FILE* file, char* content, char* content01, char* content02) {
    if (file != NULL) {
        fprintf(file, "\tif(%s %s %s)", content, content01, content02);
   } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}
void write_condicional_sentece_double(FILE* file, double content, char* content01, double content02){
    if (file != NULL) {
        fprintf(file, "\tif(%lf %s %lf)", content, content01, content02);
    } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }   
}
void write_condicional_sentece_int(FILE* file, int content, char* content01, int content02){
    if (file != NULL) {
        fprintf(file, "\tif(%d %s %d)", content, content01, content02);
    } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}


void write_condicional_sentece_namevar_int(FILE* file, char* content, char* content01, int content02) {
    if (file != NULL) {
        fprintf(file, "\tif(%s %s %d)", content, content01, content02);
   } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}
void write_condicional_sentece_int_namevar(FILE* file, int content, char* content01, char* content02) {
    if (file != NULL) {
        fprintf(file, "\tif(%d %s %s)", content, content01, content02);
   } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}
void write_condicional_sentece_double_namevar(FILE* file, double content, char* content01, char* content02) {
    if (file != NULL) {
        fprintf(file, "\tif(%lf %s %s)", content, content01, content02);
   } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}

void write_condicional_sentece_namevar_double(FILE* file, char* content, char* content01, double content02) {
    if (file != NULL) {
        fprintf(file, "\tif(%s %s %lf)", content, content01, content02);
   } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}

void write_condicional_sentece_string_namevar(FILE* file, char* content, char* content01, char* content02) {
    if (file != NULL) {
        fprintf(file, "\tif(%s %s %s)", content, content01, content02);
   } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}

void write_condicional_sentece_namevar_string(FILE* file, char* content, char* content01, char* content02) {
    if (file != NULL) {
        fprintf(file, "\tif(%s %s %s)", content, content01, content02);
   } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
}
