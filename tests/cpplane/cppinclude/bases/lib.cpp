// cppinclude/bases: the library.
#include "lib.hpp"

namespace shp {

Rect::Rect(double w_, double h_) : w(w_), h(h_) { sides_ = 4; }
double Rect::area() const { return w * h; }
Square::Square(double s) : Rect(s, s) {}

std::string describe(const Named& n) { return n.tag(); }
double area_of(const Shape& s) { return s.area(); }
void rename(Named& n, const std::string& to) { n.name = to; }
const void* named_address(const Named& n) { return &n; }
const void* rect_address(const Rect& r) { return &r; }

}
