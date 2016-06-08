#ifndef __LOG
#define __LOG

#include <stdio.h>
#include <stdlib.h>

#define LOG_ERROR_FILE "error.log"
#define LOG_INFO_FILE "info.log"
#define LOG_WARMING_FILE "warming.log"

#define MAX_MESSAGE_SIZE 200

typedef struct _log_ {
  FILE* file_error;
  FILE* file_info;
  FILE* file_warning;
} Log;

typedef enum {
  ERROR, INFO, WARMING
} log_type;

static Log* Log_new(); // In a singleton the constructor is private

void Log_destroy();

Log* Log_get_instance();

static void Log_write(const log_type type, const char* text);

void Log_info(const char* text);

void Log_warning(const char* text);

void Log_error(const char* text);

#endif
