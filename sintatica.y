%{

#include <stdio.h>

%}

%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token NUM
%token END

%start Compile

%error-verbose
 
%%

Compile:
    | Compile Expression
;
Expression:
    END
    | NUM PLUS NUM END { printf("a+b"); }
    | NUM MINUS NUM END { printf("a-b"); }
    | NUM TIMES NUM END { printf("a*b"); }
    | NUM DIVIDE NUM END { printf("a/b"); }

;

%%
 
void yyerror(char* errmsg)
{
	printf("\n*** Erro: %s\n", errmsg);
}
 
int yywrap() { return 1; }
 
int main(int argc, char** argv)
{
     yyparse();
     return 0;
}
