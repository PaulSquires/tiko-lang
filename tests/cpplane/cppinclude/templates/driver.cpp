// cppinclude/templates, called from C++: the output the tiko driver must reproduce.
#include "lib.hpp"
#include <utility>
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

using namespace tpl;

int main() {
    // class templates, instantiated by the API
    Box<double> b = make_box(2.5);
    show_d("box.get", b.get());
    show_d("box.twice", b.twice().value);
    b.set(4);
    show_d("box.sum", sum(b, Box<double>(1.5)));
    Pair<int, std::string> p = make_pair_(7, "seven");
    show_i("pair.first", p.first());
    show_s("pair.second", p.second().c_str());
    show_s("pair.describe", p.describe().c_str());
    Arr<int, 3> a = iota3();
    show_i("arr.size", a.size());
    show_i("arr.at", a.at(2) + a.v[0]);
    // #cppinstantiate
    show_i("clamp.int", clamp(15, 0, 10));
    show_d("clamp.double", clamp(-0.5, 0.0, 1.0));
    Stack<std::string> st;
    st.push("a"); st.push("b"); st.push("c");
    show_u("stack.size", st.size());
    show_s("stack.pop", st.pop().c_str());
    show_i("stack.empty", st.empty());

    // std::vector <-> containers.Array
    std::vector<int> r = range(5);
    long long rs = 0; for (int v : r) rs += v;
    show_i("range.count", (long long)r.size());
    show_i("range.sum", rs);
    show_d("total", total({ 1.5, 2.5, 3.0 }));
    std::vector<std::string> parts = split("a,bb,,ccc", ',');
    show_i("split.count", (long long)parts.size());
    show_s("split.3", parts[3].c_str());
    show_s("join", join(parts, "+").c_str());
    std::vector<Pt> sq = square_pts(2);
    show_d("square.2", sq[2].x + sq[2].y);
    std::vector<Tag> tg = tags({ "x", "yy" });
    show_s("tags.1", tg[1].name().c_str());
    std::vector<int> dd = { 1, 2, 3 };
    double_all(dd);
    show_i("double_all.count", (long long)dd.size());
    show_i("double_all.2", dd[2]);
    Shelf sh;
    sh.add("Dune"); sh.add("Emma");
    show_i("shelf.titles", (long long)sh.titles().size());
    std::string all;
    for (const std::string& t : sh) all += t + ";";
    show_s("shelf.each", all.c_str());

    // unique_ptr / shared_ptr
    {
        std::unique_ptr<Shape> s = make_square(3);
        show_s("square.kind", s->kind().c_str());
        show_d("square.area", s->area());
        show_i("live.1", live_shapes());
        show_s("consume", consume(std::move(s)).c_str());
        show_i("live.0", live_shapes());
        std::shared_ptr<Shape> c = make_circle(1);
        show_i("uses.1", uses(c));
        std::shared_ptr<Shape> c2 = c;
        show_i("uses.2", uses(c2));
        show_d("circle.area", c2->area());
        show_i("live.circle", live_shapes());
    }
    show_i("live.end", live_shapes());
    return 0;
}
