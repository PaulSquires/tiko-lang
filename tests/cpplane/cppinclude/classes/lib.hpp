// cppinclude/classes: C++ classes as tiko -cppimport binds them -- handle types. Overloaded
// constructors, a user default constructor and an implicit one, const / static / virtual methods,
// std::string and std::vector members, a class by value, by const&, by & and by pointer as
// parameters, a class result by value (an owned copy) and by reference / pointer (borrowed), an
// abstract class reached through references, a class that cannot be copied, a method that
// throws, and default arguments. Point counts its live objects, so a leaked or doubly-deleted
// handle shows in the output.
// docs/tiko-cpp C3a-2.
#pragma once
#include <cstddef>
#include <string>
#include <string_view>
#include <vector>

namespace geo {

class Point {
public:
    Point();
    Point(double x, double y);
    Point(const Point& o);
    Point& operator=(const Point& o);
    ~Point();
    double x() const;
    double y() const;
    void move(double dx, double dy = 0);
    Point plus(const Point& o) const;
    double dist(Point o) const;
    std::string str() const;
    static Point origin();
    static int live();
private:
    double x_, y_;
};

class Polygon {
public:
    explicit Polygon(std::string name);
    virtual ~Polygon();
    void add(const Point& p);
    void add(double x, double y);
    std::size_t size() const;
    Point& at(std::size_t i);                 // throws std::out_of_range
    const Point* first() const;
    std::string name() const;
    void rename(std::string_view n);
    double perimeter() const;
    virtual std::string describe() const;
private:
    std::string name_;
    std::vector<Point> pts_;
};

// An interface: no constructor, reached through references.
class Shape {
public:
    virtual ~Shape();
    virtual double area() const = 0;
    virtual std::string kind() const = 0;
};

Shape& shape_at(int i);                       // a library-owned shape
double total_area(const Shape& a, const Shape& b);

// Cannot be copied: a copy from tiko raises.
class Counter {
public:
    explicit Counter(int start = 100);
    Counter(const Counter&) = delete;
    Counter& operator=(const Counter&) = delete;
    int next();
    int peek() const;
private:
    int n_;
};

// No constructor of its own: the implicit default one.
struct Tally {
    void bump(int by);
    int total() const;
private:
    int t_ = 0;
};

Point midpoint(const Point& a, const Point& b);
void scale(Polygon& p, double f);
void nudge(Point* p);
Polygon square(double side = 1.5);

}
