// byvalue: a NON-TRIVIALLY-COPYABLE class passed and returned by value (Itanium: the copy
// by address, the result through a hidden pointer), a trivial one (registers), and a const
// reference. The copy constructor and the destructor report, so their ORDER is compared too.
extern "C" void show_i(const char*, long long);

struct Box { int v; Box(int x); Box(const Box& o); ~Box(); };
Box::Box(int x) : v(x) {}
Box::Box(const Box& o) : v(o.v + 1000) { show_i("Box(copy)", v); }
Box::~Box() { show_i("~Box", v); }

struct Pod { int a, b; };
struct Big { long long a, b, c; };   // 24 bytes: memory class, returned through sret

Box twice(Box b) { return Box(b.v * 2); }
Pod swappod(Pod p) { return Pod{p.b, p.a}; }
Big bigsum(Big x, Big y) { return Big{x.a + y.a, x.b + y.b, x.c + y.c}; }
int peekbox(const Box& b) { return b.v; }
