// msvc/iface: the COM-style idiom -- a C factory hands out a pointer to an abstract C++
// interface, the caller dispatches through its vtable (no C++ names involved), and the C++
// side deletes. On the MSVC ABI a virtual destructor is ONE slot (the vector deleting
// destructor), which is the layout a tiko 'extends object' type already has. docs/tiko-cpp C2.
#include <string>
#include <vector>
extern "C" void show_s(const char*, const char*);

struct ICounter {
    virtual ~ICounter() = default;
    virtual void add(int v) = 0;
    virtual int scaled(int k) const = 0;
    virtual const char* name() const = 0;
};

namespace {
class Counter : public ICounter {
    std::string name_;
    std::vector<int> v_;
public:
    explicit Counter(const char* n) : name_(n) {}
    ~Counter() override { show_s("~Counter", name_.c_str()); }
    void add(int v) override { v_.push_back(v); }
    int scaled(int k) const override { int t = 0; for (int x : v_) t += x; return t * k; }
    const char* name() const override { return name_.c_str(); }
};
}

extern "C" ICounter* counter_new(const char* name) { return new Counter(name); }
extern "C" void counter_free(ICounter* c) { delete c; }
