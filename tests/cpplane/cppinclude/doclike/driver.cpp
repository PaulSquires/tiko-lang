// cppinclude/doclike, called from C++. The tiko driver must print the same.
#include "lib.hpp"
extern "C" void show_i(const char*, long long);
extern "C" void show_s(const char*, const char*);

int main() {
    dl::Document d;
    d.Parse("7");
    show_i("doc", d.Get());
    d["a"].Set(1);
    d["b"]["c"].Set(2);
    d["a"].Set(d["a"].Get() + 10);
    show_i("a", d["a"].Get());
    show_i("count", d.Count());
    const dl::Value& v = d;                  // the document as its base
    show_i("value", v.Get());
    show_i("view", v.GetView().Get());
    dl::Buffer b;
    dl::Printer<dl::Buffer> p(b);
    d.Accept(p);
    show_s("printed", b.Get());
    p.Key("k");
    show_s("key", b.Get());
    return 0;
}
