%{

#include "common.h"
#include <stdio.h>

%}

%token RESERVED_WORLD
%token END
%start Compile
%error-verbose
 
%%

Compile:
	END { printf("FIM\n"); }
;

%%
 
void yyerror(const char* errmsg)
{
	printf("\n*** Erro: %s\n", errmsg);
}
 
int yywrap(void) { return 1; }
 
int main(int argc, char** argv)
{
     yyparse();
     return 0;
}
