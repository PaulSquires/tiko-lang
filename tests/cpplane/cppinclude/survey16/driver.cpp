// cppinclude/survey16, called from C++: the output the tiko driver must reproduce.
#include "lib.hpp"
#include "lib2.hpp"
#include <sstream>
extern "C" void show_i(const char*, long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

int main() {
    s16::Reader<2> r(5);
    show_i("reader", r.value());
    s16::Val<int> v(9);
    show_i("val", v.get());
    std::vector<std::variant<std::string, int>> row = { std::string("a"), std::string("bc") };
    show_s("join", s16::join(row).c_str());
    s16::Opt o{ 4 };
    show_i("pick", s16::pick(o));
    show_i("twice", s16::twice(o));
    std::vector<double>* d = new std::vector<double>{ 1.5, 2.5, 3.5 };
    s16::View<std::vector<double>> view(*d);
    show_i("view.size", (long long)view.size());
    show_d("view.at2", view.at(2));
    delete d;                                // tiko's view keeps its own copy; C++'s is not read again
    std::ostringstream oss;
    s16::print_to(oss, 7);
    s16::print_to(oss, 8);
    show_s("oss", oss.str().c_str());
    s16::RingSink<int> ring;
    show_i("sink_id", s16::sink_id(ring));
    s16::Logger lg("log", ring);
    show_s("logger", lg.tag().c_str());
    s16::Padded p("abc");
    s16::PView pv = p;
    show_i("padding", (long long)pv.padding());
    show_i("padding_of", (long long)s16::padding_of(p));
    return 0;
}
