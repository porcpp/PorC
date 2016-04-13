#include <stdio.h>
#include <stdlib.h>
#include "simbol_table.h"



int main(){
    struct data x;
    x.name = 'c';
    x.type = 'd';    
    x.value= 100;
    
    struct node y;
    y.content = x;
    y.node_left = &y;
    y.node_rigth = &y;

    printf("%c %c %d\n%p %p\n %p %p %p",x.name,x.type,x.value,&y.content,&x,&y,y.node_left,y.node_rigth);
}
