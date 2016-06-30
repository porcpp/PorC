%{
    #include "sintatica.tab.h"
    #define YYSTYPE char *
    int quantity_lines = 0;
%}

other_reserved (asm|auto|extern|register|return|union|void|volatile)
decision_reserved (break|case|continue|default|do|else|for|goto|if|switch|while)
type_reserved (char|const|double|enum|float|int|long|short|signed|sizeof|static|struct|typedef|unsigned)
all_reserved (other_reserved|decision_reserved|type_reserved)

portugol_header (algoritmo|variáveis|fim-variáveis|início|fim)
portugol_types (inteiro|real|caractere|literal|lógico)
portugol_statements (não|verdadeiro|falso)

digit [0-9]
integer {digit}+
real {integer}("."{integer})

letter_min [a-z]
letter_mai [A-Z]

letter ({letter_min}|{letter_mai})
any_char [^"]+
string {letter}+
any_string ("\""{any_char}*"\"")

char_value ("\'"{any_char}"\'")

namevar {letter}({integer}|{letter}|"_")*

comparator ("="|"<"|">"|"<="|">="|"<>")
plus "+"
minus "-"
basic_aritimetic ({plus}|{minus})
times "*"
divider "/"

%%
{all_reserved}        { return(PALAVRA_RESERVADA_C); }
{portugol_statements} { return(PARA_IMPLEMENTAR); }


"se"                  { return(SE_); }
"então"               { return(ENTAO); }
"senão"               { return(SENAO); }
"fim-se"              { return(FIM_SE); }
"e"                   { return(E_); }
"ou"                  { return(OU_); }

"enquanto"            { return(ENQUANTO); }
"faça"                { return(FACA); }
"fim-enquanto"        { return(FIM_ENQUANTO); }
"para"                { return(PARA); }
"fim-para"            { return(FIM_PARA); }
"de"                  { return(DE_); }
"até"                 { return(ATE_); }
"passo"               { return(PASSO);  }

"leia"                { return(LEIA); }

"algoritmo"           { return(ALGORITMO); }
"fim-algoritmo"       { return(FIM_ALGORITMO); }
"constantes"          { return(CONSTANTE); }
"variáveis"           { return(VARIAVEIS); }
"fim-variáveis"       { return(FIM_VARIAVEIS); }
"início"              { return(INICIO_); }
"fim"                 { return(FIM_); }

"imprima"             { return(IMPRIMA);}

"inteiro"             { yylval.strval = "int"; return(TIPO_INTEIRO);}
"real"                { yylval.strval = "double"; return(TIPO_REAL);}
"lógico"              { yylval.strval = "bool"; return(TIPO_BOOLEANO);}
"caractere"           { yylval.strval = "char"; return(TIPO_CARACTERE);}
"literal"             { yylval.strval = "char*"; return(TIPO_LITERAL);}
"matriz"              { return(MATRIZ);}

"inteiros"            { yylval.strval = "int"; return(TIPO_INTEIRO);}
"reais"               { yylval.strval = "double"; return(TIPO_REAL);}
"lógicos"             { yylval.strval = "bool"; return(TIPO_BOOLEANO);}
"caracteres"          { yylval.strval = "char"; return(TIPO_CARACTERE);}

":="                  { return(ATRIBUICAO); }

"//"                  { return(COMENTARIO); }
":"                   { return(VIRGULA); }
";"                   { return(PONTO_VIRGULA); }
","                   { return(PONTO); }
"\n"                  { quantity_lines+=1; }

"("                   { return(PARENTESE_ESQUERDO); }
")"                   { return(PARENTESE_DIREITO); }
"{"                   { return(CHAVE_ESQUERDA); }
"}"                   { return(CHAVE_DIREITA); }
"["                   { return(COLCHETE_ESQUERDA);}
"]"                   { return(COLCHETE_DIREITA);}

{namevar}             { yylval.strval = strdup(yytext); return(NOME_VARIAVEL); }
{integer}             { yylval.ival = atoi(yytext); return(VALOR_INTEIRO); }
{real}                { yylval.dval = atof(yytext); return(VALOR_REAL); }
{char_value}          { yylval.strval = strdup(yytext); return(VALOR_CARACTERE); }
{any_string}          { yylval.strval = strdup(yytext);	return(VALOR_LITERAL); }
{comparator}          { yylval.strval = strdup(yytext); return(COMPARADOR); }
{basic_aritimetic}    { yylval.strval = strdup(yytext); return(ARITMETICA_BASICA); }
{times}               { yylval.strval = strdup(yytext); return(VEZES); }
{divider}             { yylval.strval = strdup(yytext); return(DIVISAO); }

%%
