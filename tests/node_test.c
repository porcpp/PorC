#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "../lib/simbol_table/variable.h"
#include "../lib/simbol_table/node.h"
#include "node_test.h"


void should_create_a_new_node() {
  Variable* variable = Variable_new("test", "char");
  Node* node = Node_new(variable);

  assert(node != NULL);

  free(node);
  free(variable);

  printf(".");
}


/*
* FIXME: C free points the pointer to a memory trash, how to test it ?
* In a post check with valgrind says(valgrind --leak-check=full ./execute_tests):
*
* ==7839== All heap blocks were freed -- no leaks are possible
* ==7839==
* ==7839== For counts of detected and suppressed errors, rerun with: -v
* ==7839== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
*/
void should_destroy_a_node_and_its_children() {
  Variable* v1 = Variable_new("test_v1", "char");
  Variable* v2 = Variable_new("test_v2", "char");
  Variable* v3 = Variable_new("test_v3", "char");

  Node* node = Node_new(v1);

  node->node_left = Node_new(v2);
  node->node_right = Node_new(v3);

  Node_destroy(node);
  printf(".");
}


void should_create_a_array_of_variables() {
  Variable* v1 = Variable_new("test_v1", "char");
  Variable* v2 = Variable_new("test_v2", "char");
  Variable* v3 = Variable_new("test_v3", "char");

  Node* node = Node_new(v1);

  node->node_left = Node_new(v2);
  node->node_right = Node_new(v3);

  Variable* variable_array = (Variable*) malloc(sizeof(Variable)*3);

  unsigned int last_added_index = Node_add_variable_to_array(node, variable_array, 0);

  assert(last_added_index == 2);
  assert(variable_array != NULL);

  free(variable_array);
  free(node->node_left);
  free(node->node_right);
  free(node);
  free(v1);
  free(v2);
  free(v3);

  printf(".");
}


void execute_all_node_tests() {
  should_create_a_new_node();
  should_destroy_a_node_and_its_children();
  should_create_a_array_of_variables();

  printf("\n");
}

