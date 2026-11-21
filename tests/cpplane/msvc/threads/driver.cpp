// msvc/threads, called from C++: the output tiko's driver must reproduce.
extern "C" void show_i(const char*, long long);
extern "C" void thr_sequential(int n);
extern "C" int thr_race();

int main() {
    thr_sequential(2);
    show_i("race.sum", thr_race());
    return 0;
}
