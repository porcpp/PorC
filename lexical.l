%{
    #include "sintatica.tab.h"
    #define YYSTYPE char *
    int lines = 0;
%}

other_reserved (asm|auto|extern|register|return|union|void|volatile)
decision_reserved (break|case|continue|default|do|else|for|goto|if|switch|while)
type_reserved (char|const|double|enum|float|int|long|short|signed|sizeof|static|struct|typedef|unsigned)
all_reserved (other_reserved|decision_reserved|type_reserved)

portugol_header (algoritmo|variáveis|fim-variáveis|início|fim)
portugol_types (inteiro|real|caractere|literal|lógico)
portugol_statements (não|enquanto|fim-enquanto|para|de|até|faça|fim-para|verdadeiro|falso)

digit [0-9]
integer {digit}+
real {integer}("."{integer})

letter_min [a-z]
letter_mai [A-Z]

letter ({letter_min}|{letter_mai})
any_char .
string {letter}+

char_value ("\'"{any_char}"\'")

string_value ("\""({any_char}+)"\"")
semicolon [";"]+

namevar {letter}({integer}|{letter}|"_")*

comparator ("="|"<"|">"|"<="|">="|"<>")

%%
{all_reserved}        { return(RESERVED_WORD_C); }
{portugol_statements} { return(TO_IMPLEMENT); }


"se"				  { return(IF_); }
"então"               { return(THAN_); }
"senão"               { return(ELSE_); }
"fim-se"              { return(END_IF_); }
"e"                   { return(AND_); }
"ou"                  { return(OR_); }

"algoritmo"           { return(ALGORITHM); }
"fim-algoritmo"       { return(END_ALGORITHM); }
"constantes"          { return(CONSTANTS); }
"variáveis"           { return(VARIABLES); }
"fim-variáveis"       { return(VARIABLES_END); }
"início"              { return(BEGIN_BODY); }
"fim"                 { return(END_BODY); }

"inteiro"             { yylval.strval = "int"; return(T_INT);}
"real"                { yylval.strval = "double"; return(T_DOUBLE);}
"logico"              { yylval.strval = "bool"; return(T_BOOLEAN);}
"caractere"           { yylval.strval = "char"; return(T_CHAR);}

":="				  { return(ATTRIBUTION); }

"//"          	 	  { return(COMMENT); }
":"             	  { return(COLON); }
{semicolon} 		  { return(SEMICOLON); }
","             	  { return(COMMA); }
"\n"				  { lines+=1; }

{comparator}        { yylval.strval = strdup(yytext); return(COMPARATOR); }

"(" 				  { return(LEFT_PARENTHESIS); }
")" 				  { return(RIGHT_PARENTHESIS); }
"{" 				  { return(LEFT_COL); }
"}" 				  { return(RIGHT_COL); }


{namevar} 			  { yylval.strval = strdup(yytext); 	return(NAMEVAR); }
{integer}			  { yylval.ival = atoi(yytext); 		return(VALUE_INT); }
{real} 				  { yylval.dval = atof(yytext); 		return(VALUE_DOUBLE); }
{char_value}                      { yylval.strval = strdup(yytext); 	return(VALUE_CHARACTER); }
{string_value}		         { yylval.strval = strdup(yytext);		return(VALUE_STRING); }


%%
