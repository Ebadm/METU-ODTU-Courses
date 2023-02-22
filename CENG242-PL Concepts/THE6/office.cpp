#include <iostream>
#include "office.h"
#include "owner.h"

using namespace std;

Office::Office(const string &property_name, int area, Owner *owner, bool having_wifi, bool having_reception)
{
  this->property_name =  property_name;
  this->area = area;
  this->owner = owner;
  this->having_reception = having_reception;
  this->having_wifi = having_wifi;
  if (owner != NULL){
    owner->add_property(this);
  }
}

float Office::valuate()
{
  float multiplier = 1;
  if (having_wifi) { multiplier *= 1.3; }
  if (having_reception) { multiplier *= 1.5; }
  return area * 5 * multiplier;

  //area × 5. If there is a provided Wi-Fi, multiply the value by 1.3. If there is a provided reception service, multiply the value by 1.5. Multiply with both, if both of them are provided
}