#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "../lib/simbol_table/variable.h"
#include "variable_test.h"

void should_create_a_new_variable() {
  Variable* variable = Variable_new("test", "int");

  assert(variable != NULL);

  free(variable);

  printf(".");
}


void execute_all_variable_tests() {
  should_create_a_new_variable();

  printf("\n");
}

