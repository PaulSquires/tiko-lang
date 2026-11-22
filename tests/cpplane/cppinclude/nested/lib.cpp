// cppinclude/nested: the library.
#include "lib.hpp"

namespace nest {

Code::Mode::Mode(int bits) : bits_(bits) {}
int Code::Mode::bits() const { return bits_; }
const Code::Mode Code::Mode::NUMERIC(1);
const Code::Mode Code::Mode::TEXT(4);
const long long Code::BIG = 1LL << 40;
int Code::created = 0;
double Code::scale = 1.5;

Code::Code(Level lv, const std::vector<int>& data) : level_(lv), data_(data), name_("data") { ++created; }
Code::Code(std::string&& name, int n) : level_(Level::LOW), data_(n, 1), name_(std::move(name)) { ++created; }
Code::Level Code::level() const { return level_; }
Code::Shape Code::shape() const { return data_.size() % 2 ? ROUND : SQUARE; }
const Code::Mode& Code::mode() const { return level_ == Level::HIGH ? Mode::TEXT : Mode::NUMERIC; }
int Code::total() const { int t = 0; for (int v : data_) t += v; return t; }
std::string Code::name() const { return name_; }
Code::Cell Code::at(int i) const { return Cell{ i, data_.empty() ? 0 : data_[i % data_.size()] }; }
Code Code::make(Level lv) { return Code(lv, std::vector<int>{ 1, 2, 3 }); }
int Code::sink(std::vector<int>&& v) { int n = (int)v.size(); data_ = std::move(v); return n; }

int count_level(Code::Level lv, Code::Shape sh) { return (int)lv * 10 + (int)sh; }
std::string mode_name(const Code::Mode& m) { return m.bits() == 1 ? "numeric" : "text"; }

std::vector<std::vector<int>> grid(int n) {
    std::vector<std::vector<int>> g;
    for (int r = 0; r < n; ++r) { g.emplace_back(); for (int c = 0; c <= r; ++c) g.back().push_back(r * 10 + c); }
    return g;
}
int sum2(const std::vector<std::vector<int>>& g) { int t = 0; for (auto& r : g) for (int v : r) t += v; return t; }
std::array<double, 3> cross(const std::array<double, 3>& a, const std::array<double, 3>& b) {
    return { a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0] };
}
std::vector<std::array<double, 2>> ring(int n) {
    std::vector<std::array<double, 2>> r;
    for (int i = 0; i < n; ++i) r.push_back({ (double)i, (double)(i * i) });
    return r;
}
std::optional<int> find(const std::vector<int>& v, int x) {
    for (std::size_t i = 0; i < v.size(); ++i) if (v[i] == x) return (int)i;
    return std::nullopt;
}
std::optional<std::string> label(int i) { if (i > 0) return "L" + std::to_string(i); return std::nullopt; }
void decorate(std::string& s) { s = "[" + s + "]"; }
const char* const GREETING = "hello";
std::string bytes(int n) { std::string s; for (int i = 0; i < n; ++i) s += (char)(i * 37 + 200); s += "â¬"; return s; }
std::map<std::string, int> counts(const std::string& text) {
    std::map<std::string, int> m; std::string w;
    for (char c : text + " ") { if (c == ' ') { if (!w.empty()) ++m[w]; w.clear(); } else w += c; }
    return m;
}
std::unordered_map<int, std::string> names(int n) { std::unordered_map<int, std::string> m; for (int i = n; i > 0; --i) m[i * 7] = "n" + std::to_string(i); return m; }
int total(const std::map<std::string, int>& m) { int t = 0; for (auto& e : m) t += e.second * (int)e.first.size(); return t; }
bool parse_num(const std::string& s, int* out, std::string* err) {
    try { *out = std::stoi(s); return true; } catch (...) { if (err) *err = "not a number: " + s; return false; }
}
int apply(int (*f)(int), int x) { return f(f(x)); }
double fold(const std::vector<double>& v, std::function<double(double, double)> op, double init) { for (double d : v) init = op(init, d); return init; }
long long checksum(const std::string& s) { long long t = 0; for (unsigned char c : s) t = t * 257 + c; return t; }

}  // namespace nest
