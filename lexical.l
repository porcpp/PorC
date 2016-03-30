
OTHERS_RESERVADS = (asm|auto|extern|register|return|union|void|volatile)
DECISION_RESERVADS = (break|case|continue|default|do|else|for|goto|if|switch|while)
TYPE_RESERVADS = (char|const|double|enum|float|int|long|short|signed|sizeof|static|struct|typedef|unsigned)
ALL_RESERVADS = (OTHERS_RESERVADS|DECISION_RESERVADS|TYPE_RESERVADS)




%%
/* Reserved words Portugol */
"leia" return(READ);
"escreva" return(WRITE);
"algoritmo" return(ALGORITHM);
"constantes" return(CONSTANTS);
"variaveis" return(VARIABLES);

// Repeating structure Portugol
"para" return(FOR);
"de" return(IN);
"ate" return(UNTIL);
"passo" return(STEP);
"faca" return(DO_IT);
"fim_para" return(END_FOR);
"enquanto" return(WHILE);
"fim_enquanto" return(END_WHILE);
"repita" return(REPEAT);
"pare" return(STOP);

// Condition structure
"se" return(IF_IT);
"entao" return(SO);
"senao" return(IF_NO);
"fim_se" return(END_IF);



/* Symbols */
"+" return(PLUS);
"-" return(MINUS);
"*" return(TIMES);
"/" return(DIVIDE);
"^" return(POWER);
"(" return(LEFT_PARENTHESIS);
")" return(RIGHT_PARENTHESIS);
"\n" return(END);

%%
