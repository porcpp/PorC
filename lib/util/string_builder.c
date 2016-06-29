#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "../simbol_table/simbol_table.h"
#include "node_link.h"
#include "stack.h"
#include "string_builder.h"


StrList* StrList_new() {
  StrList* list = malloc(sizeof(StrList));

  list->stack = Stack_new();

  return list;
}


void StrList_add(StrList* list, char* value, char* type) {
  char* data = StrList_replace(value, '"', "");
  Stack_add(list->stack, type, data);
}


char* StrList_makePrint(StrList* list, SimbolTable* simbols) {
  assert(list != NULL);
  assert(simbols != NULL);

  char* printfBuild = (char*) malloc(sizeof(char)*200);
  char* percentage;
  char variables[100] = "";
  NodeLink* actual = Stack_pop(list->stack);

  strcpy(printfBuild, "\"");

  while (actual != NULL) {
    if ( strcmp(actual->type, "variable") == 0) {
      Variable* variable = SimbolTable_find(simbols, actual->value);

      if (variable != NULL) {
        strcat(variables, actual->value);
        strcat(variables, ",");
        percentage = StrList_percentage(variable->type);
        strcat(printfBuild, percentage);
      }
    } else { // its a raw string
      strcat(printfBuild, actual->value);
    }
    free(actual);
    actual = Stack_pop(list->stack);
  }

  strcat(printfBuild, "\",");
  strcat(printfBuild, variables);

  size_t size = strlen(printfBuild);

  printfBuild[size-1] = '\0';

  return printfBuild;
}

char* StrList_percentage(char* type) {
  char* percentage = (char*) malloc(sizeof(char)*3);

  if (strcmp(type, "int") == 0) {
     strcpy(percentage, "%d");
  } else if (strcmp(type, "double") == 0) {
     strcpy(percentage, "%f");
  } else if (strcmp(type, "char") == 0) {
     strcpy(percentage, "%c");
  } else if (strcmp(type, "char*") == 0) {
     strcpy(percentage, "%s");
  } else {
     strcpy(percentage, "");
  }

  return percentage;
}

void StrList_destroy(StrList* list) {
  assert(list != NULL);
  Stack_destroy(list->stack);
  free(list);
  list = NULL;
}

// Font: http://stackoverflow.com/questions/12890008/replacing-character-in-a-string
static char *StrList_replace(const char *s, char ch, const char *repl) {
    int count = 0;
    const char *t;
    for(t=s; *t; t++)
        count += (*t == ch);

    size_t rlen = strlen(repl);
    char *res = malloc(strlen(s) + (rlen-1)*count + 1);
    char *ptr = res;
    for(t=s; *t; t++) {
        if(*t == ch) {
            memcpy(ptr, repl, rlen);
            ptr += rlen;
        } else {
            *ptr++ = *t;
        }
    }
    *ptr = 0;
    return res;
}
