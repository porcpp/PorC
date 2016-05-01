#include <stdlib.h>
#include <stdio.h>
#include "transform_types.h"

char* transform_int_string(char* content01, int content02){
	// 11 = Number of characters
	content01 = malloc(11*sizeof (int));
	if (content01 != NULL) {
		sprintf(content01, "%i", content02);
   	}
   	else{ 
    	printf("\nERROR - Nao foi possivel alocar memoria\n");
      	exit (1);
	}
	return content01;
}

char* transform_double_string(char* content01, double content02){
	content01 = malloc(sizeof (double));
	if (content01 != NULL) {
 		snprintf(content01, 50,"%lf", content02);
   	}
   	else{ 
 		printf("\nERROR - Nao foi possivel alocar memoria\n");
      	exit (1);
 	}
	return content01;
}