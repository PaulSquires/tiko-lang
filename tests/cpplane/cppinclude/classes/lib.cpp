// cppinclude/classes: the library.
#include "lib.hpp"
#include <cmath>
#include <cstdio>
#include <stdexcept>

namespace geo {

static int g_live = 0;

Point::Point() : x_(0), y_(0) { ++g_live; }
Point::Point(double x, double y) : x_(x), y_(y) { ++g_live; }
Point::Point(const Point& o) : x_(o.x_), y_(o.y_) { ++g_live; }
Point& Point::operator=(const Point& o) { x_ = o.x_; y_ = o.y_; return *this; }
Point::~Point() { --g_live; }
double Point::x() const { return x_; }
double Point::y() const { return y_; }
void Point::move(double dx, double dy) { x_ += dx; y_ += dy; }
Point Point::plus(const Point& o) const { return Point(x_ + o.x_, y_ + o.y_); }
double Point::dist(Point o) const { return std::hypot(o.x_ - x_, o.y_ - y_); }
std::string Point::str() const {
    char b[64];
    std::snprintf(b, sizeof b, "(%g, %g)", x_, y_);
    return b;
}
Point Point::origin() { return Point(); }
int Point::live() { return g_live; }

Polygon::Polygon(std::string name) : name_(std::move(name)) {}
Polygon::~Polygon() {}
void Polygon::add(const Point& p) { pts_.push_back(p); }
void Polygon::add(double x, double y) { pts_.emplace_back(x, y); }
std::size_t Polygon::size() const { return pts_.size(); }
Point& Polygon::at(std::size_t i) {
    if (i >= pts_.size()) throw std::out_of_range("Polygon::at: no point " + std::to_string(i));
    return pts_[i];
}
const Point* Polygon::first() const { return pts_.empty() ? nullptr : &pts_[0]; }
std::string Polygon::name() const { return name_; }
void Polygon::rename(std::string_view n) { name_ = std::string(n); }
double Polygon::perimeter() const {
    double s = 0;
    for (std::size_t i = 0; i < pts_.size(); ++i) s += pts_[i].dist(pts_[(i + 1) % pts_.size()]);
    return s;
}
std::string Polygon::describe() const { return name_ + " with " + std::to_string(pts_.size()) + " points"; }

Shape::~Shape() {}
namespace {
struct Circle : Shape {
    double r;
    explicit Circle(double r) : r(r) {}
    double area() const override { return 3.25 * r * r; }
    std::string kind() const override { return "circle"; }
};
struct Rect : Shape {
    double w, h;
    Rect(double w, double h) : w(w), h(h) {}
    double area() const override { return w * h; }
    std::string kind() const override { return "rect"; }
};
Circle g_circle(2);
Rect g_rect(3, 4);
}
Shape& shape_at(int i) {
    if (i == 0) return g_circle;
    if (i == 1) return g_rect;
    throw std::out_of_range("shape_at: no shape " + std::to_string(i));
}
double total_area(const Shape& a, const Shape& b) { return a.area() + b.area(); }

Counter::Counter(int start) : n_(start) {}
int Counter::next() { return ++n_; }
int Counter::peek() const { return n_; }

void Tally::bump(int by) { t_ += by; }
int Tally::total() const { return t_; }

Point midpoint(const Point& a, const Point& b) { return Point((a.x() + b.x()) / 2, (a.y() + b.y()) / 2); }
void scale(Polygon& p, double f) {
    for (std::size_t i = 0; i < p.size(); ++i) {
        Point& q = p.at(i);
        q.move(q.x() * (f - 1), q.y() * (f - 1));
    }
}
void nudge(Point* p) { p->move(0.5, 0.5); }
Polygon square(double side) {
    Polygon p("square");
    p.add(0, 0); p.add(side, 0); p.add(side, side); p.add(0, side);
    return p;
}

}
