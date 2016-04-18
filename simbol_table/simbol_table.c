#include <stdio.h>
#include <stdlib.h>
#include "simbol_table.h"

Node * tree;
// Create a new node with value K
Node * new_node(var variable){
    Node * treeLeft = (Node *) malloc(sizeof(Node));
    if( treeLeft !=NULL){

        treeLeft->content=variable;
        treeLeft->node_left=NULL;
        treeLeft->node_right=NULL;
    }else{
        printf("fails create a new node");
    }
    return treeLeft;
}
var new_data (char name, char type, int value){
    var data;
    data.name = name;
    data.type = type;
    data.value = value;
    return data;
}
// Search the node with value of k
Node * search(char name, Node * node){
    Node * find_node = NULL;
    if(node != NULL){
        if(name == node->content.name){
            find_node = node;
        }else if(name> node->content.name){
            find_node = search(name, node->node_right);
        }else{
            find_node = search(name, node->node_left);
        }
    }else{
        find_node =NULL;
    }
    return find_node;
}
// Search for the data with value k
var * find(char name){
    Node * node_result =search(name,tree);
    var * result = NULL;
    if (node_result != NULL){
        result = &node_result->content;
    }else{
       result = NULL; 
    }
    return result;
}

// Add a new data to the tree
int insert(var variable) {
    Node* actual_node = tree;
    Node* node = new_node(variable);
    int node_added = 0;

    if (tree == NULL) {
        tree = node;
        node_added = 1;
    } else {
        do {
            if (variable.name < actual_node->content.name) {
                if (actual_node->node_left == NULL) {
                    actual_node->node_left = node;
                    node_added = 1;
                } else {
                    actual_node = actual_node->node_left;
                }
            } else {
                if (actual_node->node_right == NULL) {
                    actual_node->node_right = node;
                    node_added = 1;
                } else {
                    actual_node = actual_node->node_right;
                }
            }
        } while(!node_added);
    }

    return node_added;
}

void free_dfs(){
    
}
int main(){
    insert(new_data('m','c',10));
    insert(new_data('c','c',11));
    insert(new_data('p','c',12));
    insert(new_data('a','c',13));
    insert(new_data('n','c',14));
    insert(new_data('d','c',15));
    
    printf("%d\n", (find('d') != NULL) ? find('d')->value : 0);
    printf("%d\n", (find('a') != NULL) ? find('a')->value : 0);
    printf("%d\n", (find('c') != NULL) ? find('c')->value : 0);
    printf("%d\n", (find('i') != NULL) ? find('i')->value : 0);
    printf("%d\n", (find('n') != NULL) ? find('n')->value : 0);
    printf("%d\n", (find('z') != NULL) ? find('z')->value : 0);
    printf("%p\n", (void*) find('z'));
    //    printf("%c %c %d\n%d\n%p %p %p",x.name,x.type,x.value,tree->content,&tree,tree->node_left,tree->node_right);
}
