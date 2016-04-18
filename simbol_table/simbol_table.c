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
        treeLeft->node_right=NULL;
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
            find_node = search(k, node->node_right);
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

// Add a new data to the tree
int insert(int k) {
    Node* actual_node = tree;
    Node* node = new_node(k);
    int node_added = 0;

    if (tree == NULL) {
        tree = node;
        node_added = 1;
    } else {
        do {
            if (k < actual_node->content) {
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

int main(){
    insert(5);
    insert(2);
    insert(7);
    insert(3);
    insert(8);
    insert(1);

    printf("%d\n", find(15));
    printf("%d\n", find(5));
    printf("%d\n", find(1));
    printf("%d\n", find(9));
//    printf("%c %c %d\n%d\n%p %p %p",x.name,x.type,x.value,tree->content,&tree,tree->node_left,tree->node_right);
}
