#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "../lib/util/translate.h"

void should_translate_syntax_error(){
    char yymessage[]={"syntax error, unexpected ENTAO, expected OR or AND"};
    char* message=NULL;
    assert(strcmp(translate_message(yymessage,message),"sintaxe inválida, não era esperado ENTAO") == 0);
    printf(".");
}
void should_pass_yyerror_message(){
    char yymessage[]={"Variavel 'numero' já foi declarada"};
    char* message=NULL;
    assert(strcmp(translate_message(yymessage,message),yymessage) == 0);
    printf(".");
}
void execute_all_translate_tests() {
  should_translate_syntax_error();
  should_pass_yyerror_message();

  printf("\n");
}

