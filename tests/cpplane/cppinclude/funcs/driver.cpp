// cppinclude/funcs, called from C++: the output the tiko driver must reproduce through the
// binding tiko -cppimport generated.
#include "lib.hpp"
#include <exception>
#include <string>
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

int main() {
    show_s("transform.upper", txt::transform("hello world", txt::Mode::Upper).c_str());
    show_s("transform.title", txt::transform("the QUICK fox", txt::Mode::Title).c_str());
    show_s("transform.utf8", txt::transform("stra\xc3\x9f" "e caf\xc3\xa9", txt::Mode::Upper).c_str());
    show_u("count_words", txt::count_words("  one two  three "));
    show_s("repeat", txt::repeat("ab", 3).c_str());
    try { txt::repeat("x", -1); show_s("repeat.neg", "no throw"); }
    catch (const std::exception& e) { show_s("repeat.neg", e.what()); }
    show_i("parse_int", txt::parse_int("1234"));
    try { txt::parse_int("nope"); show_s("parse_int.bad", "no throw"); }
    catch (const std::exception& e) { show_s("parse_int.bad", "caught"); }
    show_s("level_name", txt::level_name(txt::Loud));
    show_i("louder", (long long)txt::louder(txt::Quiet));
    show_i("add.int", txt::add(2, 3));
    show_d("add.double", txt::add(1.5, 2.25));
    show_i("add.3", txt::add(1LL, 2LL, 4000000000LL));
    int a = 1, b = 2;
    txt::swap(a, b);
    show_i("swap.a", a);
    show_i("swap.b", b);
    int buf[4] = {0, 0, 0, 0};
    txt::fill(buf, 3, 7);
    show_i("fill", buf[0] + buf[1] + buf[2] + buf[3]);
    show_i("square", txt::square(12));
    show_s("greet", txt::greet("w\xc3\xb6rld").c_str());
    show_i("is_even", txt::is_even(10) ? 1 : 0);
    show_i("first_char", txt::detail::first_char("zed"));
    return 0;
}
