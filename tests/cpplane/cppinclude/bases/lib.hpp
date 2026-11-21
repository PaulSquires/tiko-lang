// cppinclude/bases: base classes and public fields. Rect has two bases, and Named -- not
// polymorphic, after the polymorphic Shape -- sits at a non-zero offset inside it, so a handle
// converted to its base must be C++'s conversion, not the same pointer. A name a derived class
// declares hides the base's. Fields of a fundamental, std::string, enum and class type, and a
// const one (no setter). docs/tiko-cpp C3a-3.
#pragma once
#include <string>

namespace shp {

enum class Color { Red = 1, Green = 2 };

struct Named {
    std::string name;
    int id = 0;
    int code() const { return 1; }
    std::string tag() const { return "#" + std::to_string(id) + " " + name; }
};

class Shape {
public:
    virtual ~Shape() {}
    virtual double area() const = 0;
    int code() const { return 2; }
    int sides() const { return sides_; }
protected:
    int sides_ = 0;
};

class Rect : public Shape, public Named {
public:
    Rect(double w, double h);
    double w, h;
    Color color = Color::Red;
    const int kind = 7;
    double area() const override;
    int code() const { return 3; }            // hides both bases' code()
};

class Square : public Rect {
public:
    explicit Square(double s);
    double side() const { return w; }
};

struct Frame {
    Named label;                              // a class-typed field
    Rect inner{1, 1};
    double margin = 0.5;
};

std::string describe(const Named& n);
double area_of(const Shape& s);
void rename(Named& n, const std::string& to);
const void* named_address(const Named& n);   // where C++ sees the Named subobject
const void* rect_address(const Rect& r);

}
