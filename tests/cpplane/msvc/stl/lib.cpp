// msvc/stl: a C++ library behind a C API, everything a real one leans on from the C++
// runtime -- STL containers and strings, iostreams, exceptions thrown and caught inside,
// RTTI, shared_ptr, a mutex, a function-local static (thread-safe init), a thread_local
// std::string (dynamic TLS init and destructor), array and aligned new. docs/tiko-cpp C2.
#include <algorithm>
#include <cstdint>
#include <map>
#include <memory>
#include <mutex>
#include <new>
#include <sstream>
#include <stdexcept>
#include <string>
#include <typeinfo>
#include <vector>

extern "C" void show_s(const char*, const char*);

namespace {
struct Shape { virtual ~Shape() = default; virtual double area() const = 0; };
struct Sq : Shape { double s; explicit Sq(double v) : s(v) {} double area() const override { return s * s; } };
struct Tracer { std::string n; explicit Tracer(const char* s) : n(s) {} ~Tracer() { show_s("~Tracer", n.c_str()); } };
struct alignas(64) Wide { char b[64]; };

thread_local std::string t_last = "none";
std::mutex g_mu;
const std::string& banner() { static std::string s("banner-once"); return s; }
}

extern "C" {
int stl_sum(const char* csv) {
    std::vector<int> v;
    std::stringstream ss(csv);
    for (std::string item; std::getline(ss, item, ',');) v.push_back(std::stoi(item));
    std::sort(v.begin(), v.end());
    std::map<int, int> freq;
    for (int x : v) ++freq[x];
    return v.empty() ? 0 : v.back() * 100 + (int)freq.size();
}
int stl_parse(const char* s) {
    try {
        size_t used = 0;
        int n = std::stoi(s, &used);
        if (used != std::string(s).size()) throw std::invalid_argument("trailing junk");
        t_last = "ok";
        return n;
    } catch (const std::exception& e) {
        t_last = std::string(typeid(e).name()) + ": " + e.what();
        return -1;
    }
}
const char* stl_last() { return t_last.c_str(); }
double stl_poly() {
    std::shared_ptr<Shape> a = std::make_shared<Sq>(3);
    std::unique_ptr<Shape> b(new Sq(4));
    Sq* c = dynamic_cast<Sq*>(b.get());
    return a->area() + b->area() + (c ? c->s : -1);
}
const char* stl_banner() { std::lock_guard<std::mutex> g(g_mu); return banner().c_str(); }
int stl_arrays() {
    Tracer* t = new Tracer[2]{Tracer("a0"), Tracer("a1")};
    delete[] t;
    Wide* w = new Wide[3];
    int aligned = ((reinterpret_cast<uintptr_t>(w) & 63) == 0);
    delete[] w;
    int* nt = new (std::nothrow) int[4];
    delete[] nt;
    return aligned;
}
}
