// classes: a C++ class with standard-library members -- constructed, used and destroyed from
// the other language. Virtual destructor first, so its two Itanium slots (D1, D0) sit before
// 'scaled': a one-slot table calls the deleting destructor instead (FEASIBILITY 2.4).
#include <string>
#include <vector>
extern "C" void show_s(const char*, const char*);
extern "C" void show_i(const char*, long long);

namespace geo {
class Counter {
public:
    Counter(const char* name);
    virtual ~Counter();
    void add(int v);
    int total() const;
    const char* name() const;
    static int instances();
    virtual int scaled(int k) const;
private:
    std::string name_;
    std::vector<int> v_;
    static int count_;
};
int Counter::count_ = 0;
Counter::Counter(const char* name) : name_(name) { ++count_; }
Counter::~Counter() { --count_; show_s("~Counter", name_.c_str()); }
void Counter::add(int v) { v_.push_back(v); }
int Counter::total() const { int t = 0; for (int x : v_) t += x; return t; }
const char* Counter::name() const { return name_.c_str(); }
int Counter::instances() { return count_; }
int Counter::scaled(int k) const { return total() * k; }

// A derived class whose override a call through the base must reach.
class Doubler : public Counter {
public:
    Doubler(const char* name);
    ~Doubler() override;
    int scaled(int k) const override;
};
Doubler::Doubler(const char* name) : Counter(name) {}
Doubler::~Doubler() { show_s("~Doubler", name()); }
int Doubler::scaled(int k) const { return Counter::scaled(k) * 2; }
Counter* make_doubler(const char* name) { return new Doubler(name); }
void destroy(Counter* c) { delete c; }
}
extern "C" int counter_sizeof() { return (int)sizeof(geo::Counter); }
