%{%}

other_reserved (asm|auto|extern|register|return|union|void|volatile)
decision_reserved (break|case|continue|default|do|else|for|goto|if|switch|while)
type_reserved (char|const|double|enum|float|int|long|short|signed|sizeof|static|struct|typedef|unsigned)
all_reserved (other_reserved|decision_reserved|type_reserved)


/*  */
digit [0-9]
character[a-z]
/* E assim mesmo? */
string [caracter][caracterdigit]*
whitespace [ \n\r\t]+
intenger [digit]+
any_char .

%%
/* Define all reserverd world */
{all_reserved} return(RESERVED_WORLD);


/* Reserved words Portugol */
"algoritmo" 		        {return(ALGORITHM);}
"fimalgoritmo" 		        {return(END_ALGORITHM);}
"constantes" 		        {return(CONSTANTS);}
"variaveis" 		        {return(VARIABLES);}
"inicio" 		        {return(BEGIN);}
"var" 				{return(VAR);}

/* Repeating structure Portugol */
"para" 				{return(FOR);} 
"fim_para" 			{return(END_FOR);}
"de" 				{return(IN);}
"ate" 				{return(UNTIL);}
"faca" 				{return(DO_IT);}
"enquanto" 			{return(WHILE);} 
"fim_enquanto" 		        {return(END_WHILE);}
"repita" 			{return(REPEAT);}
"pare" 				{return(STOP);}

/* Condition structure */
"se" 				{return(IF_IT);}
"fim_se" 			{return(END_IF);}
"entao" 			{return(SO);}
"senao" 			{return(IF_NO);}

/* Data type */
"inteiro" 			{return(INT);}
"real" 				{return(DOUBLE);}
"logico" 			{return(BOOLEAN);}
"caractere" 		        {return(CHAR);}
"literal"                       {return(STRING);}

/* Boolean type */
"verdadeiro" 		        {return(TRUE);}
"falso" 			{return(FALSO);}

/* Symbols */
"+" 				{return(PLUS);}
"-" 				{return(MINUS);}
"*" 				{return(TIMES);}
"/" 				{return(DIVIDE);}
"div" 				{return(DIVIDE);}
"mod"                           {return(MOD);}
"^" 				{return(POWER);}

/*  */
":=" 				{return(ATRIBUICION);}
"!=" 				{return(DIFERENT);}
"&&" 				{return(AND_);}
"||" 				{return(OR_);}

"//" 				{return(COMMENT);}
":" 				{return(COLON);}
";" 				{return(SEMICOLON);}
","				{return(COMMA);}

"(" 				{return(LEFT_PARENTHESIS);}
")" 				{return(RIGHT_PARENTHESIS);}
"{" 				{return(LEFT_KEY);}
"}" 				{return(RIGHT_KEY);}
"[" 				{return(LEFT_BRACKET);}
"]" 				{return(RIGHT_BRACKET);}

"\n" 				{return(END_LINE);}
"\t" 				{return(TABULATION);}

%%