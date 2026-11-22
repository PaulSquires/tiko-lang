#include "lib.hpp"
namespace s16 {
std::string join(const std::vector<std::variant<std::string, int>>& v) {
    std::string r;
    for (const auto& e : v) {
        if (const std::string* s = std::get_if<std::string>(&e)) r += *s; else r += std::to_string(std::get<int>(e));
        r += ",";
    }
    return r;
}
int pick(Opt s16) { return s16.k + 1; }
void print_to(std::ostream& os, int x) { os << "x=" << x << ";"; }
int sink_id(Sink& s) { return s.id(); }
std::size_t padding_of(PView v) { return v.padding(); }
}  // namespace s16
