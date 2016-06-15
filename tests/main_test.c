#include <stdio.h>
#include "variable_test.h"
#include "node_test.h"
#include "simbol_table_test.h"
#include "transform_types_test.h"


int main() {
  printf("\n");

  printf("Testing variable\n");
  execute_all_variable_tests();

  printf("Testing node\n");
  execute_all_node_tests();

  printf("Testing simbol_table\n");
  execute_all_simbol_table_tests();

  printf("Testing transform types\n");
  execute_all_transform_types_tests();

  printf("\nTests ended\n");

  return 0;
}
