

typedef struct _node{
	int status;
	struct _node* next;
}Node;

Node* base = NULL;
unsigned int count = 0;

void continueExecution();
void newSyntaxError();
void push(int n);
int pop();