#include <iostream>
#include "villa.h"
#include "owner.h"

using namespace std;

Villa::Villa(const string &property_name, int area, Owner *owner, int number_of_floors, bool having_garden)
{
  this->property_name =  property_name;
  this->area = area;
  this->owner = owner;
  this->number_of_floors = number_of_floors;
  this->having_garden = having_garden;
  if (owner != NULL){
    owner->add_property(this);
  }
}

float Villa::valuate()
{
  float multiplier = 1;
  if (having_garden){ multiplier = 2; }
  return (area*10 * (number_of_floors) * (multiplier));
}