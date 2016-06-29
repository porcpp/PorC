#include <stdio.h>
#include <stdlib.h>
#include "translate.h"
#include "log.h"
#include "../templates/transform_types.h"
#include <string.h>

const unsigned short MAX_MESSAGE_SIZE = 1000;
char* translate_message(const char* yymessage,char* message){

    char token_error[MAX_MESSAGE_SIZE];
    char new_message[MAX_MESSAGE_SIZE];
    memset(token_error,' ',sizeof(char)*MAX_MESSAGE_SIZE);
    
    int count_token=is_syntax_error(yymessage,token_error);

    if(count_token>1){
        int count_wtoken = 0;
        int k = 37;
        strcpy(new_message,"sintaxe inválida, não era esperado ");
        while(count_wtoken < count_token){
           new_message[k++] = token_error[count_wtoken++];
        }
        message = (char*) malloc(sizeof(char)*MAX_MESSAGE_SIZE);
        strcpy(message,new_message);
    }else{
        message = yymessage;
    }
    return message;
}

int is_syntax_error(const char* yymessage,char* token_error){
    
    char error_message[]={"syntax error, unexpected "};
    int count_token = 0;
    int end = 0;
    int k = 0;
    while(yymessage[k]!='\0' && !end ){
        if(yymessage[k] == error_message[k]){
            k++;
        } else if((yymessage[k] >= 'A' && yymessage[k] <= 'Z' 
                   || yymessage[k] == '_' ) && k>23){
            token_error[count_token++] = yymessage[k++];
        }else{
            token_error[count_token++]='\0';
            end = 1; 
        }
    }
    return count_token;
}

