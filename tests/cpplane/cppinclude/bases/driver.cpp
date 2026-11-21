// cppinclude/bases, called from C++: the output the tiko driver must reproduce.
#include "lib.hpp"
#include <cstddef>
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

int main() {
    shp::Rect r(3, 4);
    r.name = "box";                                   // a base's field
    r.id = 9;
    show_d("area", r.area());                         // own virtual
    show_i("sides", r.sides());                       // a base's method
    show_i("code", r.code());                         // hides both bases'
    show_s("tag", r.tag().c_str());                   // the other base's method
    show_s("describe", shp::describe(r).c_str());     // as const Named&
    show_d("area_of", shp::area_of(r));               // as const Shape&
    shp::rename(r, "crate");                          // as Named&
    show_s("renamed", r.name.c_str());
    show_i("named.offset", (const char*)shp::named_address(r) - (const char*)shp::rect_address(r));
    r.w = 5;
    show_d("w", r.w);
    show_d("area.after", r.area());
    show_i("color", (long long)r.color);
    r.color = shp::Color::Green;
    show_i("color.after", (long long)r.color);
    show_i("kind", r.kind);
    shp::Square sq(2.5);
    show_d("square.side", sq.side());
    show_d("square.area", shp::area_of(sq));          // two levels up
    show_i("square.code", sq.code());
    sq.name = "sq";
    show_s("square.describe", shp::describe(sq).c_str());
    shp::Frame f;
    f.label.name = "frame";                           // through the borrowed field
    f.label.id = 3;
    show_s("frame.tag", f.label.tag().c_str());
    f.inner.w = 6;
    show_d("frame.inner", f.inner.area());
    show_d("frame.margin", f.margin);
    shp::Named& alias = f.label;                      // tiko: 'dim' from a reference result binds
    alias.id = 4;
    show_i("frame.alias", f.label.id);
    shp::Named copy(f.label);                         // tiko: an explicit copy constructor call
    copy.name = "other";
    show_s("frame.after", f.label.name.c_str());
    shp::Named other;
    other = f.label;                                  // tiko: '=' is operator let, a copy
    other.name = "third";
    show_s("frame.let", f.label.name.c_str());
    return 0;
}
