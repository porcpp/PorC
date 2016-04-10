#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "c_templates.h"


static void write_to_file_or_die(FILE* file, char* content) {
    if (file != NULL) {
        fprintf(file, "%s", content);
    } else {
        printf("COULD NOT WRITE IN FILE !\n");
        exit(0);
    }
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

