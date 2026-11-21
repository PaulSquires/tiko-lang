// names: one function per C++ spelling a tiko declaration has to reach -- the three char
// types, long and unsigned long (size_t, ptrdiff_t), long long, a type nested in a class,
// and a non-member operator. docs/tiko-cpp FEASIBILITY 2.3.
#include <cstddef>

namespace nm {
int take_char(char c) { return c + 1; }
int take_schar(signed char c) { return c - 1; }
int take_uchar(unsigned char c) { return c + 2; }
int take_charptr(const char* s, unsigned char* out) { *out = (unsigned char)s[0]; return s[1]; }
long take_long(long v) { return v * 2; }
unsigned long take_ulong(unsigned long v) { return v + 3; }
long long take_llong(long long v) { return v - 4; }
std::size_t take_size(std::size_t n, const char* s) { return n + (s[0] == 'x' ? 1 : 0); }
std::ptrdiff_t take_diff(const char* a, const char* b) { return b - a; }
struct Outer { int a; struct Inner { int b; }; };
int take_inner(Outer::Inner x) { return x.b * 10; }
int take_inner_ref(const Outer::Inner& x) { return x.b * 100; }
}

struct V { int x; };
V operator+(const V& l, const V& r) { return V{l.x + r.x}; }
