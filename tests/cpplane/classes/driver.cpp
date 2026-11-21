// classes, called from C++: the output tiko's driver must reproduce.
extern "C" void show_s(const char*, const char*);
extern "C" void show_i(const char*, long long);
extern "C" int counter_sizeof();

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
    alignas(8) unsigned char opaque_[56];
};
Counter* make_doubler(const char* name);
void destroy(Counter* c);
}

int main() {
    show_i("sizeof", counter_sizeof());
    {
        geo::Counter c("stack");
        c.add(3); c.add(4);
        show_s("name", c.name());
        show_i("total", c.total());
        show_i("instances", geo::Counter::instances());
        show_i("scaled", c.scaled(10));
    }
    show_i("instances", geo::Counter::instances());
    geo::Counter* h = new geo::Counter("heap");
    h->add(5);
    show_i("heap.scaled", h->scaled(2));
    delete h;
    geo::Counter* d = geo::make_doubler("derived");
    d->add(6);
    show_i("derived.scaled", d->scaled(3));
    geo::destroy(d);
    show_i("instances", geo::Counter::instances());
    return 0;
}
