#include "Node.h"

// // // THE FRIEND METHODS ARE ALREADY IMPLEMENTED. // // //
// // // // // // // DO NOT CHANGE THEM! // // // // // // //


Node::Node(int id) {
  //cout<<"Node int const"<<endl;
  this->id = id;
}

Node::~Node() {
  std:: vector<Node*> del;
  for(int i=0; i < children.size(); ){
    del.push_back(children[i]);
    children.erase(children.begin()+i);
  }

  for(int i=0; !del.empty() ; ){
    Node* temp = del[i];
    del.erase(del.begin()+i);
    delete temp;
  }
}

Node::Node(const Node& node) {
  id = node.id;
  for(int i=0; i < node.children.size(); i++){
	try {
    //cout << *node.children[i] << endl;
		node.children[i]->getData();
    //cout << "Found ch"<< endl;
    DataNode* n1 = new DataNode(*node.children[i],'a');
    children.push_back(n1);
	}
	catch (InvalidRequest e) {
    Node* n1 = new Node(*node.children[i]);
    children.push_back(n1);
	}
  }
}

int Node::getId() const {
	return id;
}

char Node::getData() const {
  throw InvalidRequest();
}

vector<Node*>& Node::getChildren() {
  return children;
}

void Node::operator+=(Node& childNode) {
	children.push_back(&childNode);
}

Node* Node::operator&(const Node& node) const {
	try {
		this->getData();
    Node *res = new Node(*this);//DataNode *res = new DataNode(*this);
    return res;
	}
	catch (InvalidRequest e) {
    try{  
      node.getData();
      Node *res = new Node(node); //DataNode *res = new DataNode(node);
      return res;
      }
	  catch (InvalidRequest e) {
        Node *res = new Node(*this);
        return res;
	  }

	}

}

// This is already implemented for you, do NOT change it!
ostream& operator<<(ostream& os, const Node& node) {
	try {
		node.getData();
		os << *(DataNode*)&node;
	}
	catch (InvalidRequest e) {
		os << "[" << node.id;
		for (int i = 0; i < node.children.size(); i++)
			os << ", " << *node.children[i];
		os << "]";
	}
	return os;
}

/*************** DataNode *****************/

DataNode::DataNode(int id, char data) : Node(id), data(data) {
  //cout<<"DataNode int const"<<endl;
}


DataNode::~DataNode() {
	//??
}

DataNode::DataNode(const DataNode& dataNode): Node(dataNode) {
  this->data = dataNode.getData();
}

DataNode::DataNode(const Node& node, char data) : Node(node){
  try  {this->getData(); this->data = node.getData(); }
	catch (InvalidRequest e) {
		this->data = data;
	}
}

char DataNode::getData() const {
	return data;
}

// This is already implemented for you, do NOT change it!
ostream& operator<<(ostream& os, const DataNode& dataNode) {
	os << "[" << "(" << dataNode.id << ", \'" << dataNode.data << "\')";
	for (int i = 0; i < dataNode.children.size(); i++)
		os << ", " << *dataNode.children[i];
	os << "]";
	return os;
}



