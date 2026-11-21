// msvc/threads: thread_local objects with constructors and destructors on threads the C++
// library starts itself (the TLS callback path: initialisers at thread attach or on demand,
// destructors at thread exit), and four threads racing one function-local static, which must
// be constructed exactly once (thread-safe statics). Each thread is joined before the next
// output, so the order is fixed. docs/tiko-cpp C2.
#include <atomic>
#include <chrono>
#include <string>
#include <thread>
#include <vector>
extern "C" void show_s(const char*, const char*);
extern "C" void show_i(const char*, long long);

namespace {
std::atomic<int> g_built{0};
// Silent until a thread tags it: whether a thread that never touches it constructs one (at
// attach) or not (on demand) is the runtime's choice, and four racing threads would print in
// any order. A constructor that did not run shows as a crash on the unconstructed string.
struct PerThread {
    std::string tag;
    PerThread() : tag("unset") {}
    ~PerThread() { if (tag != "unset") show_s("~PerThread", tag.c_str()); }
};
thread_local PerThread t_obj;

struct Slow { int v; Slow() : v(0) { ++g_built; std::this_thread::sleep_for(std::chrono::milliseconds(50)); v = 7; } };
int shared_value() { static Slow s; return s.v; }
}

extern "C" {
void thr_sequential(int n) {
    for (int i = 0; i < n; ++i) {
        std::thread th([i] { t_obj.tag = "worker-" + std::to_string(i); show_s("in thread", t_obj.tag.c_str()); });
        th.join();
    }
}
int thr_race() {
    std::vector<std::thread> ts;
    std::atomic<int> sum{0};
    for (int i = 0; i < 4; ++i) ts.emplace_back([&sum] { sum += shared_value(); });
    for (auto& t : ts) t.join();
    show_i("constructed", g_built.load());
    return sum.load();
}
}
