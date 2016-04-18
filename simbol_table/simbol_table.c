#include <stdio.h>
#include <stdlib.h>
#include "simbol_table.h"

Node * tree;
// Create a new node with value K
Node * new_node(int k){
    Node * treeLeft = (Node *) malloc(sizeof(Node));
    if( treeLeft !=NULL){

        treeLeft->content=k;
        treeLeft->node_left=NULL;
        treeLeft->node_rigth=NULL;
    }else{
        printf("fails create a new node");
    }
    return treeLeft;
}
// Search the node with value of k
Node * search(int k, Node * node){
    Node * find_node = NULL;
    if(node != NULL){
        if(k == node->content){
            find_node = node;
        }else if(k> node->content){
            find_node = search(k, node->node_rigth);
        }else{
            find_node = search(k, node->node_left);
        }
    }else{
        find_node =NULL;
    }
    return find_node;
}
// Search for the data with value k
int find(int k){
    Node * node_result =search(k,tree);
    int result = 0;
    if (node_result != NULL){
        result = node_result->content;
    }else{
       result = 0; 
    }
    return result;
}

int main(){
    tree = new_node(10);
    tree->node_left = new_node(1); 
    tree->node_rigth = new_node(15);
    struct data x;
    x.name = 'c';
    x.type = 'd';    
    x.value= 100;
    
    printf("%d\n",find(15))  ;
//    printf("%c %c %d\n%d\n%p %p %p",x.name,x.type,x.value,tree->content,&tree,tree->node_left,tree->node_rigth);
}
