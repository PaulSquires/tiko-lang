// byvalue, called from C++: the output tiko's driver must reproduce.
extern "C" void show_i(const char*, long long);

struct Box { int v; Box(int x); Box(const Box& o); ~Box(); };
struct Pod { int a, b; };
struct Big { long long a, b, c; };
Box twice(Box b);
Pod swappod(Pod p);
Big bigsum(Big x, Big y);
int peekbox(const Box& b);

int main() {
    Pod q = swappod(Pod{1, 2});
    show_i("swappod.a", q.a);
    show_i("swappod.b", q.b);
    Big s = bigsum(Big{1, 2, 3}, Big{10, 20, 30});
    show_i("bigsum.c", s.c);
    {
        Box b(21);
        show_i("peekbox", peekbox(b));
        Box r = twice(b);
        show_i("twice", r.v);
    }
    show_i("end", 0);
    return 0;
}
