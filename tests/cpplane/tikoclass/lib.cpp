// tikoclass: C++ code that USES a class it does not define -- the driver's language defines
// it. The virtual call reaches the definer's 'area' through the vtable, and 'delete' calls the
// Itanium DELETING destructor (D0), so a tiko-defined class must put D1, D0 in its table and
// define D0 itself (FEASIBILITY 2.4).
struct Shape {
    double w;
    virtual ~Shape();
    virtual double area() const;
};
double measure(const Shape& s) { return s.area(); }
void destroy(Shape* s) { delete s; }
