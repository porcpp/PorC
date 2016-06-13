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
any_char .
string {letter}+
any_string ("\""{any_char}+"\"")

char_value ("\'"{any_char}"\'")

this_is_a_commit "não estamos tratando strings por enquanto então essa parte embaixo é inutil"
string_value ("\"{letter}\"")

namevar {letter}({integer}|{letter}|"_")*

comparator ("="|"<"|">"|"<="|">="|"<>")
plus "+"
minus "-"
basic_aritimetic ({plus}|{minus})
times "*"
divider "/"

%%
{any_string}          { return(STRING);}
{all_reserved}        { return(RESERVED_WORD_C); }
{portugol_statements} { return(TO_IMPLEMENT); }


"se"                  { return(IF_); }
"então"               { return(THAN_); }
"senão"               { return(ELSE_); }
"fim-se"              { return(END_IF_); }
"e"                   { return(AND_); }
"ou"                  { return(OR_); }

"enquanto"            { return(WHILE); }
"faça"                { return(DO); }
"fim-enquanto"        { return(END_WHILE); }
"para"                { return(FOR); }
"fim-para"            { return(END_FOR); }
"de"                  { return(FROM); }
"até"                 { return(TO); }
"passo"               { return(STEP);  }

"leia"                { return(LEIA); }

"algoritmo"           { return(ALGORITHM); }
"fim-algoritmo"       { return(END_ALGORITHM); }
"constantes"          { return(CONSTANTS); }
"variáveis"           { return(VARIABLES); }
"fim-variáveis"       { return(VARIABLES_END); }
"início"              { return(BEGIN_BODY); }
"fim"                 { return(END_BODY); }

"imprima"             { return(IMPRIMA);}

"inteiro"             { yylval.strval = "int"; return(T_INT);}
"real"                { yylval.strval = "double"; return(T_DOUBLE);}
"lógico"              { yylval.strval = "bool"; return(T_BOOLEAN);}
"caractere"           { yylval.strval = "char"; return(T_CHAR);}
"matriz"	          { return(MATRIX);}

"inteiros"            { yylval.strval = "int"; return(T_INT);}
"reais"               { yylval.strval = "double"; return(T_DOUBLE);}
"lógicos"             { yylval.strval = "bool"; return(T_BOOLEAN);}
"caracteres"          { yylval.strval = "char"; return(T_CHAR);}

":="                  { return(ATTRIBUTION); }

"//"                  { return(COMMENT); }
":"                   { return(COLON); }
";"                   { return(SEMICOLON); }
","                   { return(COMMA); }
"\n"                  { quantity_lines+=1; }

"("                   { return(LEFT_PARENTHESIS); }
")"                   { return(RIGHT_PARENTHESIS); }
"{"                   { return(LEFT_COL); }
"}"                   { return(RIGHT_COL); }
"["                   { return(LEFT_BRACKET);}
"]"                   { return(RIGHT_BRACKET);}

{namevar}             { yylval.strval = strdup(yytext); return(NAMEVAR); }
{integer}             { yylval.ival = atoi(yytext); return(VALUE_INT); }
{real}                { yylval.dval = atof(yytext); return(VALUE_DOUBLE); }
{char_value}          { yylval.strval = strdup(yytext); return(VALUE_CHARACTER); }
{string_value}        { yylval.strval = strdup(yytext); return(VALUE_STRING); }
{comparator}          { yylval.strval = strdup(yytext); return(COMPARATOR); }
{basic_aritimetic}    { yylval.strval = strdup(yytext); return(BASIC_ARITIMETIC); }
{times}               { yylval.strval = strdup(yytext); return(TIMES); }
{divider}             { yylval.strval = strdup(yytext); return(DIVIDER); }

%%
