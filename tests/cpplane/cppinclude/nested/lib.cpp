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

}  // namespace nest
