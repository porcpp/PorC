%{
    #include "sintatica.tab.h"
    #define YYSTYPE char *
%}

other_reserved (asm|auto|extern|register|return|union|void|volatile)
decision_reserved (break|case|continue|default|do|else|for|goto|if|switch|while)
type_reserved (char|const|double|enum|float|int|long|short|signed|sizeof|static|struct|typedef|unsigned)
all_reserved (other_reserved|decision_reserved|type_reserved)

reserved_portugol (para|fim_para|de|ate|faca|enquanto|fim_enquanto|repita|pare|se|fim_se|entao|senao|verdadeiro|falso)

digit [0-9]
intenger {digit}+

character_min [a-z]
character_mai [A-Z]
character ({character_min}|{character_mai})
string character+
namevar {character}({intenger}|{character}|"_")* 

%%
{all_reserved} {return(RESERVED_WORD_C);}
{reserved_portugol} {return(TO_IMPLEMENT);}

"algoritmo" 		        {return(ALGORITHM);}
"fimalgoritmo" 		        {return(END_ALGORITHM);}
"constantes" 		        {return(CONSTANTS);}
"variaveis" 		        {return(VARIABLES);}
"inicio"	 		        {return(BEGIN_);}
"var" 						{return(VAR);}

"inteiro" 					{ yylval.s = "int"; return(T_INT);}
"real" 						{ yylval.s = "double"; return(T_DOUBLE);}
"logico" 					{ yylval.s = "bool"; return(T_BOOLEAN);}
"caractere" 		        { yylval.s = "char"; return(T_CHAR);}
"literal"                   { yylval.s = "string"; return(T_STRING);}

"//" 						{return(COMMENT);}
":" 						{return(COLON);}
";" 						{return(SEMICOLON);}
","							{return(COMMA);}

"\n" 						{return(END_LINE);}
"\t" 						{return(TABULATION);}

{namevar} {	yylval.s = strdup(yytext); {return(NAMEVAR);} }

%%
