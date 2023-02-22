#ifndef __NODEMANAGER_H__
#define __NODEMANAGER_H__

#include "Node.h"
#include <vector>
using namespace std;

////////////////////////////////////////////////////////////////
// // // // // DO NOT CHANGE "PUBLIC PARTS" FILE! // // // // //
///////////////////////////////////////////////////////////////
class NodeManager {

private:
  vector<Node*> trees;
  Node* SearchNodeinTree1(Node* node,int id) {
      std:: vector<Node*> *children = &node->getChildren();
      Node * result = NULL;
      if (node->getId() == id) { result = node;  return result;}
      else if (!children->empty()){
          for(int i=0; i < children->size(); i++){
          result = SearchNodeinTree1((*children)[i],id);
          if ((result)) {  return result; }
        }
        return NULL;
      }
      else {
        return NULL;  
      }
    }
    
    
  Node* SearchParentNodeinTree1(Node* node,int id) {
      std:: vector<Node*> *children = &node->getChildren();
      Node * result = NULL;
      if (node->getId() == id) { result = node;  return result;}
      else if (!children->empty()){
          for(int i=0; i < children->size(); i++){
          result = SearchNodeinTree1((*children)[i],id);
          if ((result)) {  return node; }
        }
        return NULL;
      }
      else {
        return NULL;  
      }
  }

  Node* getParentNodeNoncons(int id) {
    Node * res = NULL;
    for(vector<Node*>::iterator it = this->trees.begin(); it != this->trees.end(); ++it) {
      res =  SearchParentNodeinTree1(*it,id);
      if (res) { return (*it); }
    }
    return NULL;
  }
    Node* getNodeNoncons(int id) {
    Node * res = NULL;
    for(vector<Node*>::iterator it = this->trees.begin(); it != this->trees.end(); ++it) {
      res = SearchNodeinTree1(*it,id);
      if (res) {break;}
    }
    return res;
  }



	// DO NOT MODIFY BELOW
public:
	// Contsructor : You can initialize your variables depending on your implementation
	NodeManager();

	// Destructor  : totally depends on your implementation
	// Note that it is responsible of destroying any tree (node) it contains
	~NodeManager();

	// It takes 2 integer such that
	//    - the first one is parent node id
	//    - the second one is child node id
	// If there does not exist any node with the given id(s), you should construct it (them) first in the type of Node.
	// Later, you should attach the given <parent-child> to the correct position in your collection
	// Note that the given nodes may already exist, yet their parent-child relationship is not constructed yet.
	// It is ensured that you are not given an existing relationship.
	void addRelation(int, int);

	// This converts the Node object whose id is given in the first argument into DataNode
	// Node whose id is given may not exist among the current trees!
	// However, if the node whose id is given exists, then it is ensured that its type is Node, not DataNode.
	// Whatever the case is, you are expected to create a new DataNode object.
	// It assigns the given char value in the second argument to the constructed DataNode object.
	// If there was a corresponding Node object previously, you are expected to destroy only that Node.
	// Apply the destruction carefully since there has been replaced a DataNode object at that position.
	// Do not forget to attach the new DataNode object into the position of the destroyed Node object!
	void setDataToNode(int, char);

	// It returns the reference for the node whose id is given in the argument
	// It should search the stated node among all the current trees
	// It is ensured that the node whose id is given exists.
	const Node& getNode(int);
};

#endif