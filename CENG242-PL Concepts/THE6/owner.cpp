#include <iostream>
#include <string>
#include <vector>
#include "owner.h"

using namespace std;

Owner::Owner()
{
}

Owner::Owner(const string &name, float balance)
{
  this->name = name;
  this->balance = balance;
}

void Owner::print_info()
{
}

string &Owner::get_name()
{
  return this->name;
}

void Owner::add_property(Property *property)
{
  properties.push_back(property);
}

void Owner::buy(Property *property, Owner *seller)
{
    cout << "[BUY] Property: " << property->get_name() << " Value: " << property->valuate() << "$ "<<seller->name << "--->" << this->name <<endl;
  bool flag1 = false;
  bool flag2 = true;
  //for (auto it = seller->properties.begin(); it != seller->properties.end(); ++it) {

  int i = 0;
  for(vector<Property *>::iterator it = seller->properties.begin(); it != seller->properties.end(); ++it) {
    if (*(it) == property) {
      flag1 = true;
      break;
    }
    i++;
  }
  /*for (const auto &item : seller->properties){
    if (item == property) {
      flag1 = true;
      break;
    }
    i++;
  }*/
  if (flag1 == false){
    cout << "[ERROR] Transaction  on  unowned  property" << endl;
  }
  if (flag1 && (this->balance < property->valuate())){
    flag2 = false;
    cout << "[ERROR] Unaffordable  property" << endl;
  }
  if (flag1 && flag2){
    vector<Property *>::iterator sold_property = seller->properties.begin()+i;
    //cout << i <<endl;
    seller->properties.erase(sold_property);
    seller->balance += property->valuate();
    this->balance -= property->valuate();
    this->add_property(property);
    property->set_owner(this);
  }

}

void Owner::sell(Property *property, Owner *owner)
{
    cout << "[SELL] Property: " << property->get_name() << " Value: " << property->valuate() <<"$ " << this->name << "--->" << owner->name <<endl;
  bool flag1 = false;
  bool flag2 = true;
  //for (auto it = seller->properties.begin(); it != seller->properties.end(); ++it) {
  int i = 0;
  for(vector<Property *>::iterator it =properties.begin(); it != properties.end(); ++it) {
    if (*(it) == property) {
      flag1 = true;
      break;
    }
    i++;
  }
  if (flag1 == false){
    cout << "[ERROR] Transaction  on  unowned  property" << endl;
  }
  if (flag1 && (owner->balance < property->valuate())){
    flag2 = false;
    cout << "[ERROR] Unaffordable  property" << endl;
  }

  if (flag1 && flag2){
    vector<Property *>::iterator sold_property = properties.begin()+i;
    properties.erase(sold_property);
    this->balance += property->valuate();
    owner->balance -= property->valuate();
    owner->add_property(property);
    property->set_owner(owner);
  }
}

void Owner::list_properties()
{
  cout << "Properties of " << this->name << ":" << endl;
  cout << "Balance: " << this->balance << "$" << endl;
  int i = 1;
  for(vector<Property *>::iterator it =properties.begin(); it != properties.end(); ++it) {  
    cout << i << ". " << (*it)->get_name() << endl;
    i++;
  }
}