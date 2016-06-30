#include <stdio.h>
#include <stdlib.h>
#include "log.h"

const unsigned short MAX_LOG_MESSAGE_SIZE = 200;

static Log* __log_instance = NULL;


static Log* Log_new() {
  Log* log = (Log*) malloc(sizeof(Log));

  log->file_error = fopen(LOG_ERROR_FILE, "w");
  log->file_info = fopen(LOG_INFO_FILE, "w");
  log->file_warning = fopen(LOG_WARMING_FILE, "w");

  return log;
}


void Log_destroy() {
  if (__log_instance != NULL) {

    fclose(__log_instance->file_error);
    fclose(__log_instance->file_info);
    fclose(__log_instance->file_warning);

    free(__log_instance);
    __log_instance = NULL;
  }
}


Log* Log_get_instance() {
  if (__log_instance == NULL) {
    __log_instance = Log_new();
  }

  return __log_instance;
}


static void Log_write(const log_type type, const char* text) {
  Log* log = Log_get_instance();

  char message[MAX_LOG_MESSAGE_SIZE];

  sprintf(message, "%s %s\n\n", "Log: ", text);

  FILE* output_file = NULL;

  switch(type) {
    case ERROR:
      output_file = log->file_error;
    break;

    case INFO:
      output_file = log->file_info;
    break;

    case WARMING:
      output_file = log->file_warning;
    break;
  }

  if (output_file != NULL) {
    fprintf(output_file, "%s", message);
  } else {
    yyerror("\n\t\tERROR ! COULD NOT OPEN THE DEBUG FILE !\n");
    exit(0);
  }
}


void Log_info(const char* text) {
  Log_write(INFO, text);
}


void Log_warning(const char* text) {
  Log_write(WARMING, text);
}


void Log_error(const char* text) {
  Log_write(ERROR, text);
}

