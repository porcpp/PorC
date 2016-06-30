#include <stdlib.h>
#include "node_link.h"


NodeLink* NodeLink_new(char* type, char* value) {
  NodeLink* node = (NodeLink*) malloc(sizeof(NodeLink));

  node->type = type;
  node->value = value;
  node->next = NULL;
  node->prev = NULL;

  return node;
}
