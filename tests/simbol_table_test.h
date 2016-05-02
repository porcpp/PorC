#ifndef SIMBOL_TABLE_TEST
#define SIMBOL_TABLE_TEST

#include "../lib/simbol_table/simbol_table.h"

void should_create_a_new_simbol_table();

void should_insert_variables();

void should_insert_data();

void should_search_for_a_node();

void should_find_by_a_variable_name();

void should_get_an_array_of_variables();

void execute_all_simbol_table_tests();

static SimbolTable* build_simbol_table_for_tests();

#endif
