// cppinclude/funcs: a C++ header as tiko -cppimport sees it -- free functions in namespaces,
// fundamentals, size_t, std::string and std::string_view both ways, a scoped and an unscoped
// enum, overloads, a name that is a tiko keyword, pointer and reference parameters, inline
// (header-only) functions, and a function that throws. docs/tiko-cpp C3a-1.
#pragma once
#include <cstddef>
#include <string>
#include <string_view>

namespace txt {

enum class Mode { Upper = 1, Lower = 2, Title = 3 };
enum Level { Quiet, Normal, Loud = 10 };

std::string transform(const std::string& s, Mode m);
std::size_t count_words(std::string_view s);
std::string repeat(const std::string& s, int n);          // throws std::invalid_argument for n < 0
int parse_int(const std::string& s);                      // throws (std::stoi)
const char* level_name(Level l);
Level louder(Level l);

// overloads, one of which tiko spells the same way as another would not
int add(int a, int b);
double add(double a, double b);
long long add(long long a, long long b, long long c);

// 'swap' is a tiko keyword
void swap(int& a, int& b);
void fill(int* out, std::size_t n, int value);

// header-only: no symbol exists in any library
inline int square(int x) { return x * x; }
inline std::string greet(std::string_view who) { return "hello, " + std::string(who) + "!"; }
inline bool is_even(unsigned long long v) { return (v % 2) == 0; }

namespace detail {
inline char first_char(const char* s) { return s && *s ? *s : '?'; }
}

}
