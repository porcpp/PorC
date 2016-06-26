#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "node_link.h"
#include "stack.h"

Stack* Stack_new() {
  Stack* stack = (Stack*) malloc(sizeof(Stack));

  stack->head = NULL;
  stack->tail = NULL;

  return stack;
}


void Stack_add(Stack* stack, char* type, char* value) {
  assert(stack != NULL);
  NodeLink* node = NodeLink_new(type, value);

  if (stack->tail == NULL) {
    stack->head = node;
    stack->tail = node;
  } else {
    stack->tail->next = node;
    node->prev = stack->tail;
    stack->tail = node;
  }
}


NodeLink* Stack_pop(Stack* stack) {
  assert(stack != NULL);
  NodeLink* node = stack->tail;

  if (stack->tail != NULL) {
    stack->tail = stack->tail->prev;
  }

  if (node != NULL) {
    node->next = NULL;
    node->prev = NULL;
  }

  return node;
}


void Stack_destroy(Stack* stack) {
  assert(stack != NULL);

  NodeLink* actual = Stack_pop(stack);

  while (actual != NULL) {
    free(actual);
    actual = Stack_pop(stack);
  }

  actual = NULL;
  free(stack);
  stack = NULL;
}
