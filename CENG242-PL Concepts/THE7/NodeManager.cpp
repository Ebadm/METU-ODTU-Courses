
#include "NodeManager.h"

NodeManager::NodeManager() {
	
}

NodeManager::~NodeManager() {
	std:: vector<Node*> del;
  for(int i=0; i < trees.size(); ){
    del.push_back(trees[i]);
    trees.erase(trees.begin()+i);
  }

  for(int i=0; !del.empty() ; ){
    Node* temp = del[i];
    del.erase(del.begin()+i);
    delete temp;
  }
}

void NodeManager::addRelation(int parent, int child) {
  Node * p1 = NULL;
  Node * c1 = NULL;
	for(vector<Node*>::iterator it = this->trees.begin(); it != this->trees.end(); ++it) {
    p1 = SearchNodeinTree1(*it,parent);
    if (p1) {break;}
  }
	for(vector<Node*>::iterator it = this->trees.begin(); it != this->trees.end(); ++it) {
    c1 = SearchNodeinTree1(*it,child);
    if (c1) {break;}
  }
  if (c1 && p1) { 
    *p1  += *c1;  
    for(int i=0; i < trees.size(); i++){
      if(trees[i]->getId() == child) {
        trees.erase(trees.begin()+i);
      }
    } 
    }
  else if (!c1 && p1) { 
    c1 = new Node(child);
    *p1  += *c1;
    }
  else if (c1 && !p1) {
    p1 = new Node(parent);
    *p1  += *c1;
    for(int i=0; i < trees.size(); i++){
      if(trees[i]->getId() == child) {
        trees.erase(trees.begin()+i);
      }
    }
    trees.push_back(p1);
    }
  else {
    p1 = new Node(parent); c1 = new Node(child);
    *p1  += *c1;
    trees.push_back(p1);
  }
}

void NodeManager::setDataToNode(int id, char data) {
  Node * res = NULL;
	for(vector<Node*>::iterator it = this->trees.begin(); it != this->trees.end(); ++it) {
    res = SearchNodeinTree1(*it,id);
    if (res) {break;}
  }
  if(res) {
    DataNode *neWNode= new DataNode(*res,data);
    Node* mynode = getNodeNoncons(id);
    Node* parentnode = getParentNodeNoncons(id);
    std:: vector<Node*> *Parentchildren = &parentnode->getChildren();
    if (parentnode) {
      *parentnode += *neWNode; 
    }
    for(int i=0; i < Parentchildren->size(); i++){
      if ((*Parentchildren)[i]->getId() == id) {
        Parentchildren->erase(Parentchildren->begin()+i);
        delete mynode;
      }
    }
    }

  else { 
    DataNode *res = new DataNode(*res,'a');
    trees.push_back(res);
  }
}

const Node& NodeManager::getNode(int id) {
  Node * res = NULL;
	for(vector<Node*>::iterator it = this->trees.begin(); it != this->trees.end(); ++it) {
    res = SearchNodeinTree1(*it,id);
    if (res) {break;}
  }
  return *res;
}