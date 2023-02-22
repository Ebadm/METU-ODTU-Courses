#include <iostream>
#include "property.h"
#include "owner.h"

using namespace std;

Property::Property()
{
}

Property::Property(const string &property_name, int area, Owner *owner)
{
  this->property_name =  property_name;
  this->area = area;
  this->owner = owner;

}

void Property::set_owner(Owner *owner)
{
  this->owner = owner;
}

float Property::valuate()
{
    return 0;
}

string &Property::get_name()
{
  return property_name;
}

void Property::print_info()
{
  if (owner != NULL){ cout << property_name << " (" << area << " m2)" << " Owner: " << owner->get_name() << endl;}
  else { cout << property_name << " (" << area << " m2)" << " Owner: " << "No owner" << endl;}

}