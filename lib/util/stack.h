#ifndef STACK
#define STACK

#include "node_link.h"

typedef struct __stack {
  NodeLink* head;
  NodeLink* tail;
} Stack;

Stack* Stack_new();

void Stack_add(Stack* stack, char* type, char* value);

NodeLink* Stack_pop(Stack* stack);

void Stack_destroy(Stack* stack);

#endif
