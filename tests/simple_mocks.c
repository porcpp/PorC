#include <stdio.h>

int quantity_lines = 0;

int yyerror(char* errmsg) {
  printf("TEST ERROR: %s\n", errmsg);
  return 0;
}

