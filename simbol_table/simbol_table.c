#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "simbol_table.h"

Node * tree;

var new_data (char* name, char* type, void* value){
    var data;
    data.name = name;
    data.type = type;
    data.value = value;
    return data;
}

// Create a new node
Node * new_node(var variable) {
    Node * treeLeft = (Node *) malloc(sizeof(Node));

    if(treeLeft != NULL) {
        treeLeft->content=variable;
        treeLeft->node_left=NULL;
        treeLeft->node_right=NULL;
    }else{
        printf("fails create a new node");
    }
    return treeLeft;
}

// Search the node with value of k
Node * search(char* name, Node * node){
    Node * find_node = NULL;
    if(node != NULL){
        int cmp = strcmp(name, node->content.name); 

        if(cmp == 0){
            find_node = node;
        }else if(cmp > 0){
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
var * find(char* name){
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
            int cmp = strcmp(variable.name, actual_node->content.name);

            if (cmp < 0) {
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

// remove an entire tree from the memory
void free_node(Node* node) {
    if (node != NULL) {
        free_node(node->node_left);
        free_node(node->node_right);
        free(node);
    }
}


int main(){
    int i[] = {1,2,3,4,5};
    insert(new_data("foo", "int", (void*) &i[0]));
    insert(new_data("bar", "int", (void*) &i[1]));
    insert(new_data("foobar", "int", (void*) &i[2]));
    insert(new_data("token", "int", (void*) &i[3]));
    insert(new_data("hadouken", "int", (void*) &i[4]));
    
    printf("%d\n", (find("foo") != NULL) ? *(int* )find("foo")->value : 0);
    printf("%d\n", (find("bar") != NULL) ? *(int* )find("bar")->value : 0);
    printf("%d\n", (find("foobar") != NULL) ? *(int* )find("foobar")->value : 0);
    printf("%d\n", (find("token") != NULL) ? *(int* )find("token")->value : 0);
    printf("%d\n", (find("hadouken") != NULL) ? *(int* )find("hadouken")->value : 0);
    printf("%d\n", (find("hey joe") != NULL) ? *(int* )find("hey joe")->value : 0);

    free_node(tree);
    //    printf("%c %c %d\n%d\n%p %p %p",x.name,x.type,x.value,tree->content,&tree,tree->node_left,tree->node_right);
}
