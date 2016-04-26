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
portugol_statements (e|ou|não|então|senão|fim-se|enquanto|fim-enquanto|para|de|até|faça|fim-para|verdadeiro|falso)

digit [0-9]
integer {digit}+
real {integer}("."{integer})

letter_min [a-z]
letter_mai [A-Z]

letter ({letter_min}|{letter_mai})
any_char .
string {letter}+

string_value (("\""|"\'")({any_char}+)("\""|"\'"))
semicolon [";"]+

namevar {letter}({integer}|{letter}|"_")*

%%
{all_reserved}        { return(RESERVED_WORD_C); }
{portugol_statements} { return(TO_IMPLEMENT); }


"se"				  { return(IF_); }

"algoritmo"           { return(ALGORITHM); }
"fim-algoritmo"       { return(END_ALGORITHM); }
"constantes"          { return(CONSTANTS); }
"variáveis"           { return(VARIABLES); }
"fim-variáveis"       { return(VARIABLES_END); }
"início"              { return(BEGIN_BODY); }
"fim"                 { return(END_BODY); }

"inteiro"             { yylval.strings = "int"; return(T_INT);}
"real"                { yylval.strings = "double"; return(T_DOUBLE);}
"logico"              { yylval.strings = "bool"; return(T_BOOLEAN);}
"caractere"           { yylval.strings = "char"; return(T_CHAR);}

":="				  { return(ATTRIBUTION); }

"//"          	 	  { return(COMMENT); }
":"             	  { return(COLON); }
{semicolon} 		  { return(SEMICOLON); }
","             	  { return(COMMA); }
"\n"				  { lines+=1; }

"="					  { yylval.strings = "=="; return(EQUAL); }
"<>"				  { yylval.strings = "!="; return(NOT_EQUAL); }
"<="				  { yylval.strings = "<="; return(GREATER_EQUAL); }
"<"					  { yylval.strings = "<"; return(GREATER); }
">="				  { yylval.strings = ">="; return(LESS_EQUAL); }
">"					  { yylval.strings = ">"; return(LESS); }
"(" 				  { return(LEFT_PARENTHESIS); }
")" 				  { return(RIGHT_PARENTHESIS); }
"{" 				  { return(LEFT_COL); }
"}" 				  { return(RIGHT_COL); }


{namevar} 			  { yylval.strings = strdup(yytext); return(NAMEVAR); }
{integer}			  { yylval.num_int = atoi(yytext); return(VALUE_INT); }
{real} 				  { yylval.num_double = atof(yytext); return(VALUE_DOUBLE); }
{string_value}		  { yylval.strings = strdup(yytext); return(VALUE_STRING); }

%%