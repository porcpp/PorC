#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "simbol_table.h"

var new_data (char* name, char* type){
    var data;
    data.name = name;
    data.type = type;
    return data;
}

// Create a new node
Node * new_node(var variable) {
    Node * treeLeft = (Node *) malloc(sizeof(Node));

    if( treeLeft != NULL ) {

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
    Node * node_result =search(name,root);
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
    Node* actual_node = root;
    Node* node = new_node(variable);
    int node_added = 0;

    if (root == NULL) {
        root = node;
        node_added = 1;
        root -> size=0;
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
            } else if (cmp >0) {
                if (actual_node->node_right == NULL) {
                    actual_node->node_right = node;
                    node_added = 1;
                } else {
                    actual_node = actual_node->node_right;
                }
            } else {
                // Variable already declared
            }

        } while(!node_added);
    }
    if(node_added){
        root->size++;
    }else{
        // Node don't added
    }
    return node_added;
}



// remove an entire tree from the memory
void free_node(Node* node) {
    if (node != NULL) {
        node->size --;
        free_node(node->node_left);
        free_node(node->node_right);
        free(node);
    }
}

void destroy(){
    free_node(root);
}

var * array_iterator(){
    
    var * all_data =  NULL; // Array with all data of nodes in the tree
    if( root!=NULL){

        all_data = (var *) malloc(sizeof(var)*root->size+1);
        Node * all_nodes = (Node *) malloc(sizeof(Node)*root->size+1);

        all_data[0] = root->content;
        all_nodes[0] = *root;
        int i,actual_index=1;
 
        // Travessing the tree using BFS algorithm
        for(i=0; i<root->size; i++){
            // Add the left node
            if(all_nodes[i].node_left != NULL){
                all_nodes[actual_index] = *all_nodes[i].node_left;
                all_data[actual_index] = all_nodes[i].node_left->content;
                actual_index++;
            }
            // Add the right node
            if(all_nodes[i].node_right!= NULL){
                all_nodes[actual_index] = *all_nodes[i].node_right;
                all_data[actual_index] = all_nodes[i].node_right->content;
                actual_index++;
            }
        }
    }else{
        // The tree doesn't have nodes 
    }
    return all_data;
}
