#ifndef NODE_LINK
#define NODE_LINK

typedef struct __node_link {
  struct __node_link* next;
  struct __node_link* prev;
  char* type;
  char* value;
} NodeLink;

NodeLink* NodeLink_new(char* type, char* value);

#endif
