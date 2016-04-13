%{
    #include "sintatica.tab.h"
    #define YYSTYPE char *
%}

other_reserved (asm|auto|extern|register|return|union|void|volatile)
decision_reserved (break|case|continue|default|do|else|for|goto|if|switch|while)
type_reserved (char|const|double|enum|float|int|long|short|signed|sizeof|static|struct|typedef|unsigned)
all_reserved (other_reserved|decision_reserved|type_reserved)

portugol_header (algoritmo|variáveis|fim-variáveis|início|fim)
portugol_types (inteiro|real|caractere|literal|lógico)
portugol_statements (e|ou|não|se|então|senão|fim-se|enquanto|fim-enquanto|para|de|até|faça|fim-para|verdadeiro|falso)

digit [0-9]
integer {digit}+
real {integer}("."{integer})

character_min [a-z]
character_mai [A-Z]
character ({character_min}|{character_mai})
string {character}+

namevar {character}({integer}|{character}|"_")*

%%
{all_reserved}        { return(RESERVED_WORD_C); }
{portugol_statements} { return(TO_IMPLEMENT); }

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

"//"            	  { return(COMMENT); }
":"             	  { return(COLON); }
";"             	  { return(SEMICOLON); }
","             	  { return(COMMA); }
	
{namevar} 			  { yylval.strings = strdup(yytext); return(NAMEVAR); }

{integer}			  { yylval.num = atoi(yytext); return(VALUE_INT); }
{character}			  { return(VALUE_CHARACTER); }

%%
