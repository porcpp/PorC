#ifndef C_TEMPLATES
#define C_TEMPLATES

static void write_to_file_or_die(FILE* file, char* content);

void write_default_header(FILE* file);

void write_body_begin(FILE* file);

void write_body_end(FILE* file);

#endif
