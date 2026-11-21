// cppinclude/funcs: the out-of-line half of lib.hpp, compiled as an ordinary C++ library.
#include "lib.hpp"
#include <algorithm>
#include <cctype>
#include <stdexcept>

namespace txt {

std::string transform(const std::string& s, Mode m) {
    std::string r = s;
    bool start = true;
    for (char& c : r) {
        unsigned char u = (unsigned char)c;
        if (u >= 0x80) { start = false; continue; }      // leave UTF-8 bytes alone
        switch (m) {
        case Mode::Upper: c = (char)std::toupper(u); break;
        case Mode::Lower: c = (char)std::tolower(u); break;
        case Mode::Title: c = (char)(start ? std::toupper(u) : std::tolower(u)); break;
        }
        start = (c == ' ');
    }
    return r;
}

std::size_t count_words(std::string_view s) {
    std::size_t n = 0;
    bool in = false;
    for (char c : s) {
        bool sp = (c == ' ');
        if (!sp && !in) ++n;
        in = !sp;
    }
    return n;
}

std::string repeat(const std::string& s, int n) {
    if (n < 0) throw std::invalid_argument("repeat: negative count");
    std::string r;
    for (int i = 0; i < n; ++i) r += s;
    return r;
}

int parse_int(const std::string& s) { return std::stoi(s); }

const char* level_name(Level l) {
    switch (l) { case Quiet: return "quiet"; case Normal: return "normal"; case Loud: return "loud"; }
    return "?";
}
Level louder(Level l) { return l == Quiet ? Normal : Loud; }

int add(int a, int b) { return a + b; }
double add(double a, double b) { return a + b; }
long long add(long long a, long long b, long long c) { return a + b + c; }

void swap(int& a, int& b) { int t = a; a = b; b = t; }
void fill(int* out, std::size_t n, int value) { std::fill(out, out + n, value); }

}
