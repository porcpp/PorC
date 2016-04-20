/*simbol_table.h
The data struct implemented is a binary tree with basic operations without
the operations of remove.
*/


// The content of each node, witch receive the data from compiler
typedef struct data{
    char*  name; // Name of variable identify by compiler 
    char*  type; // The type of variable 
} var;

typedef struct node{
    var  content;
    int size ;
    struct node * node_left;
    struct node * node_right;
} Node;

// The root node of the tree
Node * root;

int insert(var variable);
var *find(char* name);
void destroy();
var new_data(char* name, char* type);
var * array_iterator();


