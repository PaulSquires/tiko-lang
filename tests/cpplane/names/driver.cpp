// names, called from C++: the output tiko's driver must reproduce.
#include <cstddef>
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);

namespace nm {
int take_char(char c);
int take_schar(signed char c);
int take_uchar(unsigned char c);
int take_charptr(const char* s, unsigned char* out);
long take_long(long v);
unsigned long take_ulong(unsigned long v);
long long take_llong(long long v);
std::size_t take_size(std::size_t n, const char* s);
std::ptrdiff_t take_diff(const char* a, const char* b);
struct Outer { int a; struct Inner { int b; }; };
int take_inner(Outer::Inner x);
int take_inner_ref(const Outer::Inner& x);
}
struct V { int x; };
V operator+(const V& l, const V& r);

int main() {
    show_i("take_char", nm::take_char('A'));
    show_i("take_schar", nm::take_schar(-5));
    show_i("take_uchar", nm::take_uchar(250));
    unsigned char o = 0;
    show_i("take_charptr", nm::take_charptr("xy", &o));
    show_i("take_charptr.out", o);
    show_i("take_long", nm::take_long(1234567890123LL));
    show_u("take_ulong", nm::take_ulong(4000000000ULL));
    show_i("take_llong", nm::take_llong(-9000000000LL));
    show_u("take_size", nm::take_size(41, "x"));
    const char* s = "hello";
    show_i("take_diff", nm::take_diff(s, s + 4));
    nm::Outer::Inner in{7};
    show_i("take_inner", nm::take_inner(in));
    show_i("take_inner_ref", nm::take_inner_ref(in));
    V a{20}, b{22};
    show_i("operator+", (a + b).x);
    return 0;
}
