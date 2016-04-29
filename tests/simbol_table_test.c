#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
//#include "../lib/simbol_table/variable.h"
#include "../lib/simbol_table/simbol_table.h"
#include "simbol_table_test.h"

// SimbolTable_new
void should_create_a_new_simbol_table() {
  SimbolTable* simbol_table = SimbolTable_new();

  assert(simbol_table->size == 0);
  assert(simbol_table->root == NULL);

  SimbolTable_destroy(simbol_table);
  printf(".");
}

// SimbolTable_insert_variable
void should_insert_variables() {
  SimbolTable* simbol_table = SimbolTable_new();
  Variable* v1 = Variable_new("v1", "int");
  Variable* v2 = Variable_new("v2", "int");
  Variable* v3 = Variable_new("v3", "int");

  SimbolTable_insert_variable(simbol_table, v1);
  SimbolTable_insert_variable(simbol_table, v2);
  SimbolTable_insert_variable(simbol_table, v3);

  Node* n_left = simbol_table->root->node_left;
  Node* n_right = simbol_table->root->node_right;

  assert(simbol_table->size == 3);
  assert(strcmp(simbol_table->root->variable->name, v1->name) == 0);
  assert(strcmp(n_right->variable->name, v2->name) == 0);
  assert(strcmp(n_right->node_right->variable->name, v3->name) == 0);

  assert(simbol_table->root->node_left == NULL);
  assert(n_right->node_left == NULL);

  SimbolTable_destroy(simbol_table);
  printf(".");
}

// SimbolTable_insert
void should_insert_data() {
  SimbolTable* simbol_table = build_simbol_table_for_tests();

  assert(simbol_table->size == 4);
  assert(strcmp(simbol_table->root->variable->name, "b") == 0);
  assert(strcmp(simbol_table->root->node_left->variable->name, "a") == 0);
  assert(strcmp(simbol_table->root->node_right->variable->name, "c") == 0);

  SimbolTable_destroy(simbol_table);
  printf(".");
}

// SimbolTable_search_node
void should_search_for_a_node() {
  SimbolTable* simbol_table = build_simbol_table_for_tests();

  Node* d_int = SimbolTable_search_node(simbol_table, "d");

  assert(simbol_table->size == 4);
  assert(d_int != NULL);
  assert(strcmp(d_int->variable->name, "d") == 0);

  SimbolTable_destroy(simbol_table);
  printf(".");
}

// SimbolTable_find
void should_find_by_a_variable_name() {
  SimbolTable* simbol_table = build_simbol_table_for_tests();

  Variable* d_int = SimbolTable_find(simbol_table, "d");

  assert(simbol_table->size == 4);
  assert(d_int != NULL);
  assert(strcmp(d_int->name, "d") == 0);

  SimbolTable_destroy(simbol_table);
  printf(".");
}

// SimbolTable_get_variables_as_array
void should_get_an_array_of_variables() {
  SimbolTable* simbol_table = build_simbol_table_for_tests();

  assert(simbol_table->size == 4);
  Variable* variables_array = SimbolTable_get_variables_as_array(simbol_table);

  assert(strcmp(variables_array[0].name, "a") == 0);
  assert(strcmp(variables_array[1].name, "b") == 0);
  assert(strcmp(variables_array[2].name, "c") == 0);
  assert(strcmp(variables_array[3].name, "d") == 0);

  SimbolTable_destroy(simbol_table);
  free(variables_array);

  printf(".");
}


void execute_all_simbol_table_tests() {
  should_create_a_new_simbol_table();
  should_insert_variables();
  should_insert_data();
  should_search_for_a_node();
  should_find_by_a_variable_name();
  should_get_an_array_of_variables();

  printf("\n");
}


static SimbolTable* build_simbol_table_for_tests() {
  SimbolTable* simbol_table = SimbolTable_new();
  SimbolTable_insert(simbol_table, "b", "int"); // root
  SimbolTable_insert(simbol_table, "a", "int"); // left
  SimbolTable_insert(simbol_table, "c", "int"); // right
  SimbolTable_insert(simbol_table, "d", "int"); // left -> right

  return simbol_table;
}
