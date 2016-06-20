#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../lib/templates/transform_types.h"
#include "transform_types_test.h"


void should_transform_int_to_string() {
  int n1 = 123;
  int n2 = -369;
  char* n1_as_string;
  char* n2_as_string;

  n1_as_string = transform_int_string(n1);
  n2_as_string = transform_int_string(n2);

  assert(strcmp(n1_as_string, "123") == 0);
  printf(".");

  assert(strcmp(n2_as_string, "-369") == 0);
  printf(".");

  free(n1_as_string); n1_as_string = NULL;
  free(n2_as_string); n2_as_string = NULL;
}


void should_transform_double_to_string() {
  double d1 = 12.3;
  double d2 = -96.3;
  char* d1_as_string;
  char* d2_as_string;

  d1_as_string = transform_double_string(d1);
  d2_as_string = transform_double_string(d2);

  assert(strcmp(d1_as_string, "12.300000") == 0);
  printf(".");

  assert(strcmp(d2_as_string, "-96.300000") == 0);
  printf(".");

  free(d1_as_string);
  free(d2_as_string);
}


void should_transform_simbol_comparator() {
  char* comparator = malloc(sizeof(char)*3);
  strcpy(comparator, "<>");

  comparator = transform_simbol_comparator(comparator);
  assert(strcmp(comparator, "!=") == 0);
  printf(".");

  strcpy(comparator, "=");
  comparator = transform_simbol_comparator(comparator);
  assert(strcmp(comparator, "==") == 0);
  printf(".");

  free(comparator);
}


void should_given_a_type_return_the_initial_value_of_this_type() {
  char* initial_value;

  initial_value = transform_type_inital_value("int");
  assert(strcmp(initial_value, "0") == 0);
  printf(".");

  initial_value = transform_type_inital_value("char");
  assert(strcmp(initial_value, "' '") == 0);
  printf(".");

  initial_value = transform_type_inital_value("double");
  assert(strcmp(initial_value, "0.0") == 0);
  printf(".");

  initial_value = transform_type_inital_value("bool");
  assert(strcmp(initial_value, "0") == 0);
  printf(".");
}


void execute_all_transform_types_tests() {
  should_transform_int_to_string();
  should_transform_double_to_string();
  should_transform_simbol_comparator();
  should_given_a_type_return_the_initial_value_of_this_type();
  printf("\n");
}
