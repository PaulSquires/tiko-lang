// cppinclude/templates: the library.
#include "lib.hpp"

namespace tpl {

Box<double> make_box(double v) { return Box<double>(v); }
Pair<int, std::string> make_pair_(int a, const std::string& b) { return Pair<int, std::string>(a, b); }
double sum(const Box<double>& a, const Box<double>& b) { return a.value + b.value; }
Arr<int, 3> iota3() { return Arr<int, 3>{{1, 2, 3}}; }

std::vector<int> range(int n) { std::vector<int> v; for (int i = 0; i < n; ++i) v.push_back(i * i); return v; }
double total(const std::vector<double>& v) { double s = 0; for (double d : v) s += d; return s; }
std::vector<std::string> split(const std::string& s, char sep) {
    std::vector<std::string> r;
    std::string cur;
    for (char c : s) { if (c == sep) { r.push_back(cur); cur.clear(); } else cur += c; }
    r.push_back(cur);
    return r;
}
std::string join(const std::vector<std::string>& parts, const std::string& sep) {
    std::string r;
    for (std::size_t i = 0; i < parts.size(); ++i) { if (i) r += sep; r += parts[i]; }
    return r;
}
std::vector<Pt> square_pts(double s) { return { {0, 0}, {s, 0}, {s, s}, {0, s} }; }
std::vector<Tag> tags(const std::vector<std::string>& names) {
    std::vector<Tag> r;
    for (const auto& n : names) r.emplace_back("#" + n);
    return r;
}
void double_all(std::vector<int>& v) { for (int& i : v) i *= 2; v.push_back(-1); }

static int g_live = 0;
Shape::~Shape() { --g_live; }
namespace {
struct Square : Shape {
    double s;
    explicit Square(double s_) : s(s_) { ++g_live; }
    double area() const override { return s * s; }
    std::string kind() const override { return "square"; }
};
struct Circle : Shape {
    double r;
    explicit Circle(double r_) : r(r_) { ++g_live; }
    double area() const override { return 3 * r * r; }
    std::string kind() const override { return "circle"; }
};
}
std::unique_ptr<Shape> make_square(double side) { return std::make_unique<Square>(side); }
std::shared_ptr<Shape> make_circle(double r) { return std::make_shared<Circle>(r); }
std::string consume(std::unique_ptr<Shape> s) { return "consumed " + s->kind(); }
long uses(const std::shared_ptr<Shape>& s) { return s.use_count(); }
int live_shapes() { return g_live; }

}
