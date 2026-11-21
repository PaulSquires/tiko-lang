// msvc/iface, called from C++: the output tiko's driver must reproduce.
extern "C" void show_i(const char*, long long);
extern "C" void show_s(const char*, const char*);

struct ICounter {
    virtual ~ICounter() = default;
    virtual void add(int v) = 0;
    virtual int scaled(int k) const = 0;
    virtual const char* name() const = 0;
};
extern "C" ICounter* counter_new(const char* name);
extern "C" void counter_free(ICounter* c);

int main() {
    ICounter* a = counter_new("alpha");
    ICounter* b = counter_new("beta");
    a->add(3); a->add(4); b->add(10);
    show_s("a.name", a->name());
    show_i("a.scaled", a->scaled(10));
    show_i("b.scaled", b->scaled(2));
    counter_free(b);
    counter_free(a);
    show_s("end", "ok");
    return 0;
}
