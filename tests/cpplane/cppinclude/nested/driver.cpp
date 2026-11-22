// cppinclude/nested, called from C++: the output the tiko driver must reproduce.
#include "lib.hpp"
extern "C" void show_i(const char*, long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

int main() {
    using nest::Code;
    Code a(Code::Level::HIGH, std::vector<int>{ 4, 5, 6 });
    show_i("a.level", (long long)a.level());
    show_i("a.shape", (long long)a.shape());
    show_i("a.total", a.total());
    show_i("a.mode", a.mode().bits());
    show_s("a.mode.name", nest::mode_name(a.mode()).c_str());
    Code b(std::string("named"), 4);
    show_s("b.name", b.name().c_str());
    show_i("b.total", b.total());
    std::vector<int> v{ 7, 8 };
    show_i("b.sink", b.sink(std::vector<int>(v)));
    show_i("b.total2", b.total());
    show_i("v.size", (long long)v.size());
    Code c = Code::make(Code::Level::MEDIUM);
    show_i("c.level", (long long)c.level());
    Code::Cell cell = c.at(4);
    show_i("cell.x", cell.x);
    show_i("cell.y", cell.y);
    show_i("numeric", Code::Mode::NUMERIC.bits());
    show_i("text", Code::Mode::TEXT.bits());
    Code::Mode m(9);
    show_i("m", m.bits());
    show_i("count", nest::count_level(Code::Level::HIGH, Code::ROUND));
    show_i("MIN_SIZE", Code::MIN_SIZE);
    show_i("STRICT", Code::STRICT ? 1 : 0);
    show_i("BIG", Code::BIG);
    show_i("created", Code::created);
    Code::created = 100;
    show_i("created.set", Code::created);
    show_d("scale", Code::scale);
    return 0;
}
