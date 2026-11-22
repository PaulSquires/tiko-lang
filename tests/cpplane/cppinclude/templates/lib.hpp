// cppinclude/templates: class templates bound where the API instantiates them (Box<double> as a
// POD, Pair<int, std::string> as a handle, Arr<int, 3> with a non-type argument), a class template
// and a function template bound only through #cppinstantiate (Stack<std::string>, clamp<int> and
// clamp<double>), std::vector parameters and results as containers.Array, unique_ptr / shared_ptr
// as owning handles, and a range class tiko iterates with 'for each'. docs/tiko-cpp C3b-2.
#pragma once
#include <cstddef>
#include <memory>
#include <string>
#include <vector>

namespace tpl {

template <class T> struct Box {
    T value;
    Box() : value() {}
    explicit Box(T v) : value(v) {}
    T get() const { return value; }
    void set(T v) { value = v; }
    Box<T> twice() const { return Box<T>(value + value); }
};

template <class A, class B> class Pair {
public:
    Pair(A a, B b) : a_(a), b_(b) {}
    A first() const { return a_; }
    B second() const { return b_; }
    std::string describe() const { return std::to_string(a_) + ":" + b_; }
private:
    A a_;
    B b_;
};

template <class T, int N> struct Arr {
    T v[N];
    int size() const { return N; }
    T at(int i) const { return v[i]; }
};

template <class T> T clamp(T v, T lo, T hi) { return v < lo ? lo : (v > hi ? hi : v); }

template <class T> class Stack {
public:
    void push(const T& v) { items_.push_back(v); }
    T pop() { T v = items_.back(); items_.pop_back(); return v; }
    bool empty() const { return items_.empty(); }
    std::size_t size() const { return items_.size(); }
private:
    std::vector<T> items_;
};

Box<double> make_box(double v);
Pair<int, std::string> make_pair_(int a, const std::string& b);
double sum(const Box<double>& a, const Box<double>& b);
Arr<int, 3> iota3();

// std::vector <-> containers.Array, copied at the call
struct Pt { double x, y; };
class Tag {
public:
    explicit Tag(std::string n) : n_(std::move(n)) {}
    std::string name() const { return n_; }
private:
    std::string n_;
};
std::vector<int> range(int n);
double total(const std::vector<double>& v);
std::vector<std::string> split(const std::string& s, char sep);
std::string join(const std::vector<std::string>& parts, const std::string& sep);
std::vector<Pt> square_pts(double side);
std::vector<Tag> tags(const std::vector<std::string>& names);
void double_all(std::vector<int>& v);          // in and out

class Shelf {
public:
    void add(const std::string& t) { titles_.push_back(t); }
    std::vector<std::string> titles() const { return titles_; }
    std::size_t count() const { return titles_.size(); }
    // a range: begin() / end() make it something tiko iterates
    std::vector<std::string>::const_iterator begin() const { return titles_.begin(); }
    std::vector<std::string>::const_iterator end() const { return titles_.end(); }
private:
    std::vector<std::string> titles_;
};

// owning results and arguments
class Shape {
public:
    virtual ~Shape();
    virtual double area() const = 0;
    virtual std::string kind() const = 0;
};
std::unique_ptr<Shape> make_square(double side);
std::shared_ptr<Shape> make_circle(double r);
std::string consume(std::unique_ptr<Shape> s);   // takes ownership
long uses(const std::shared_ptr<Shape>& s);      // the shared count it sees
int live_shapes();

}
