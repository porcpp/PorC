#ifndef __DEBUG
#define __DEBUG

#include <stdio.h>
#include <stdlib.h>

#define DEBUG_FILE "debug.log"
#define MAX_MESSAGE_SIZE 140

typedef struct _debug_ {
  FILE* output_file;
} Debug;

static Debug* Debug_new(); // In a singleton the constructor is private

void Debug_destroy();

Debug* Debug_get_instance();

void Debug_write(const char* text);


#endif
