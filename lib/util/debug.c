#include <stdio.h>
#include <stdlib.h>
#include "debug.h"


static Debug* __debug_instance = NULL;


static Debug* Debug_new() {
  Debug* debug = (Debug*) malloc(sizeof(Debug));

  debug->output_file = fopen(DEBUG_FILE, "w");

  return debug;
}


void Debug_destroy() {
  if (__debug_instance != NULL) {
    free(__debug_instance);
    __debug_instance = NULL;
  }
}


Debug* Debug_get_instance() {
  if (__debug_instance == NULL) {
    __debug_instance = Debug_new();
  }

  return __debug_instance;
}


void Debug_write(const char* text) {
  Debug* debug = Debug_get_instance();

  char message[MAX_MESSAGE_SIZE];

  sprintf(message, "%s %s\n", "DEBUG: ", text);

  if (!debug->output_file) {
    fprintf(debug->output_file, "%s", message);
  } else {
    printf("\n\t\tERROR ! COULD NOT OPEN THE DEBUG FILE !\n");
    exit(0);
  }
}
