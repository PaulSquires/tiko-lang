// show.cpp -- the C++ lane's only output. Both drivers of a case, the C++ one and the
// tiko one, print through these, so their output is the same text exactly when the same
// values reached them. build/cpplane.sh.
#include <cstdio>

extern "C" {
void show_i(const char* k, long long v) { std::printf("%s = %lld\n", k, v); std::fflush(stdout); }
void show_u(const char* k, unsigned long long v) { std::printf("%s = %llu\n", k, v); std::fflush(stdout); }
void show_d(const char* k, double v) { std::printf("%s = %.17g\n", k, v); std::fflush(stdout); }
void show_s(const char* k, const char* v) { std::printf("%s = %s\n", k, v ? v : "(null)"); std::fflush(stdout); }
}
