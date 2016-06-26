#ifndef STRING_BUILDER
#define STRING_BUILDER

#include "../simbol_table/simbol_table.h"
#include "node_link.h"
#include "stack.h"

typedef struct __str_list {
  Stack* stack;
} StrList;


StrList* StrList_new();

void StrList_add(StrList* list, char* value, char* type);

char* StrList_makePrint(StrList* list, SimbolTable* simbols);

char* StrList_percentage(char* type);

void StrList_destroy(StrList* list);

static char *StrList_replace(const char *s, char ch, const char *repl);

#endif
