// msvc/stl, called from C++: the output tiko's driver must reproduce.
extern "C" {
void show_i(const char*, long long);
void show_d(const char*, double);
void show_s(const char*, const char*);
int stl_sum(const char*);
int stl_parse(const char*);
const char* stl_last();
double stl_poly();
const char* stl_banner();
int stl_arrays();
}

int main() {
    show_i("sum", stl_sum("5,3,9,3"));
    show_s("last.before", stl_last());
    show_i("parse.ok", stl_parse("42"));
    show_s("last.ok", stl_last());
    show_i("parse.bad", stl_parse("4x"));
    show_s("last.bad", stl_last());
    show_i("parse.range", stl_parse("99999999999999999999"));
    show_s("last.range", stl_last());
    show_d("poly", stl_poly());
    show_s("banner", stl_banner());
    show_s("banner.again", stl_banner());
    show_i("arrays.aligned", stl_arrays());
    return 0;
}
