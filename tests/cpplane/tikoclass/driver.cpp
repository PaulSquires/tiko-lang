// tikoclass, with the class defined in C++: the output tiko's driver must reproduce.
extern "C" void show_s(const char*, const char*);
extern "C" void show_d(const char*, double);

struct Shape {
    double w;
    virtual ~Shape();
    virtual double area() const;
};
Shape::~Shape() { show_s("~Shape", "deleted"); }
double Shape::area() const { return w * w; }
double measure(const Shape& s);
void destroy(Shape* s);

int main() {
    Shape* s = new Shape;
    s->w = 3;
    show_d("measure", measure(*s));
    destroy(s);
    show_s("end", "ok");
    return 0;
}
