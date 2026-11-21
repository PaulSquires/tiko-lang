// cppinclude/classes, called from C++: the output the tiko driver must reproduce through the
// handle types tiko -cppimport generated.
#include "lib.hpp"
#include <exception>
#include <string>
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

static void points() {
    geo::Point a;
    geo::Point b(3, 4);
    show_s("a", a.str().c_str());
    show_s("b", b.str().c_str());
    show_d("dist", a.dist(b));
    geo::Point c = a.plus(b);
    c.move(1, 1);
    show_s("c", c.str().c_str());
    show_i("live.3", geo::Point::live());
    geo::Point d = c;                 // a copy
    d.move(10, 0);
    show_s("c.after", c.str().c_str());
    show_s("d", d.str().c_str());
    d = b;                            // assignment
    show_s("d.let", d.str().c_str());
    show_s("origin", geo::Point::origin().str().c_str());
    show_s("mid", geo::midpoint(b, c).str().c_str());
    geo::nudge(&b);
    show_s("nudge", b.str().c_str());
    show_i("live.4", geo::Point::live());
}

static void polygons() {
    geo::Polygon p("tri");
    p.add(geo::Point(0, 0));
    p.add(4, 0);
    p.add(4, 3);
    show_u("size", p.size());
    show_d("perimeter", p.perimeter());
    show_s("describe", p.describe().c_str());
    p.at(1).move(0, 1);               // through the borrowed reference
    show_s("at.1", p.at(1).str().c_str());
    show_s("first", p.first()->str().c_str());
    try { p.at(9); show_s("at.9", "no throw"); }
    catch (const std::exception& e) { show_s("at.9", (std::string("C++ exception: ") + e.what()).c_str()); }
    p.rename("tr\xc3\xaf");
    show_s("name", p.name().c_str());
    geo::scale(p, 2);
    show_s("scaled", p.at(2).str().c_str());
    geo::Polygon s = geo::square(2);
    show_s("square", s.describe().c_str());
    show_d("square.perimeter", s.perimeter());
    show_i("live.7", geo::Point::live());
}

static void shapes() {
    geo::Shape& c = geo::shape_at(0);
    geo::Shape& r = geo::shape_at(1);
    show_s("kind.0", c.kind().c_str());
    show_d("area.0", c.area());
    show_s("kind.1", r.kind().c_str());
    show_d("total", geo::total_area(c, r));
    try { geo::shape_at(5); show_s("shape.5", "no throw"); }
    catch (const std::exception& e) { show_s("shape.5", (std::string("C++ exception: ") + e.what()).c_str()); }
}

static void counters() {
    geo::Counter k(10);
    k.next();
    show_i("next", k.next());
    show_i("peek", k.peek());
    show_s("copy", "C++ exception: this C++ class cannot be copied");
    geo::Tally t;
    t.bump(5);
    t.bump(7);
    show_i("tally", t.total());
    geo::Counter k0;                  // default arguments
    show_i("default.ctor", k0.next());
    geo::Point m(1, 1);
    m.move(2);
    show_s("default.method", m.str().c_str());
    show_d("default.free", geo::square().perimeter());
}

int main() {
    points();
    show_i("live.after.points", geo::Point::live());
    polygons();
    show_i("live.after.polygons", geo::Point::live());
    shapes();
    counters();
    return 0;
}
