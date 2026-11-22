// cppinclude/survey16: what the C++ import survey's slice 16 binds (docs/tiko-cpp/SURVEY.md).
#pragma once
#include <cstddef>
#include <ostream>
#include <string>
#include <string_view>
#include <variant>
#include <vector>

namespace s16 {

// A char pack in a specialization's name: Reader<2> is Reader_2_Trim_32_9.
template <char... C> struct Trim { static constexpr int count = sizeof...(C); };
template <int N, class T = Trim<' ', '\t'>> class Reader {
public:
    explicit Reader(int base) : base_(base) {}
    int value() const { return base_ * N + T::count; }
    // Declared, never defined (the C++03 idiom, public): 'let' raises instead of linking it.
    Reader& operator=(const Reader&);
private:
    int base_;
};

// A specialization's member declared and never defined: not bound.
template <class T> class Val {
public:
    explicit Val(int x) : x_(x) {}
    explicit Val(void* trap);
    int get() const { return x_; }
private:
    int x_;
};

// A vector of variants with a std::string alternative: an Array of ustring.
std::string join(const std::vector<std::variant<std::string, int>>& v);

// A parameter named like its type's namespace.
struct Opt { int k; };
int pick(Opt s16);

// A specialization's constructor keeping a reference to its vector argument.
template <class V> class View {
public:
    explicit View(const V& v) : v_(v) {}
    std::size_t size() const { return v_.size(); }
    double at(std::size_t i) const { return v_[i]; }
private:
    const V& v_;
};

// A std::ostream& to write to: a cpp.ostringstream.
void print_to(std::ostream& os, int x);

// A base of a base: RingSink<int> converts to Sink through BaseSink<int>.
struct Sink {
    virtual ~Sink() {}
    virtual int id() const { return 1; }
};
template <class M> struct BaseSink : Sink { int base_id() const { return 2; } };
template <class M> struct RingSink : BaseSink<M> { int id() const override { return 3; } };
int sink_id(Sink& s);
class Logger {
public:
    Logger(const std::string& name, Sink& s) : name_(name), id_(s.id()) {}
    std::string tag() const { return name_ + "#" + std::to_string(id_); }
private:
    std::string name_;
    int id_;
};

// A class converting to a string view and to a class built from a string: the class conversion wins.
class PView {
public:
    explicit PView(const std::string& s) : len_(s.size()), pad_(0) {}
    PView(const char* p, std::size_t n, std::size_t cap) : len_(n), pad_(cap - n) { (void)p; }
    std::size_t padding() const { return pad_; }
private:
    std::size_t len_, pad_;
};
class Padded {
public:
    explicit Padded(const std::string& s) : s_(s) {}
    operator std::string_view() const { return s_; }
    operator PView() const { return PView(s_.data(), s_.size(), s_.size() + 64); }
private:
    std::string s_;
};
std::size_t padding_of(PView v);

}  // namespace s16
