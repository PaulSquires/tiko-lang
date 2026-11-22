// cppinclude/doclike: the shapes RapidJSON's API has, without RapidJSON -- a class template whose
// document derives from its value, both reached through typedefs; a member template operator[];
// a member template taking the handler; a 'const char* const&' parameter; a const view whose
// operator= does not compile for its const instance. docs/tiko-cpp TUTORIAL-rapidjson.md.
#pragma once
#include <string>
#include <type_traits>
#include <utility>
#include <vector>

namespace dl {

template <bool Const, class V> class View;

template <class Ch>
class Node {
public:
    Node() : v_(0) {}
    explicit Node(int v) : v_(v) {}
    ~Node() { for (auto& k : kids_) delete k.second; }
    int Get() const { return v_; }
    void Set(int v) { v_ = v; }
    std::size_t Count() const { return kids_.size(); }
    // a member template: tiko binds it for the argument types a call shape names
    template <class T> Node& operator[](T* name) {
        for (auto& k : kids_) if (k.first == name) return *k.second;
        kids_.push_back(std::make_pair(std::string(name), new Node()));
        return *kids_.back().second;
    }
    template <class Handler> bool Accept(Handler& h) const {
        h.Number(v_);
        for (auto& k : kids_) { h.Key(k.first.c_str()); k.second->Accept(h); }
        return true;
    }
    View<true, Node> GetView() const;
private:
    Node(const Node&);                       // not copyable, as RapidJSON's GenericValue
    Node& operator=(const Node&);
    int v_;
    std::vector<std::pair<std::string, Node*>> kids_;
};

template <class Ch>
class Doc : public Node<Ch> {
public:
    Doc& Parse(const Ch* s) { this->Set(std::stoi(s)); return *this; }
};

typedef Node<char> Value;
typedef Doc<char> Document;

// a view whose operator= assigns through a reference: ill-formed for the const instance
template <bool Const, class V>
class View {
    typedef typename std::conditional<Const, const V, V>::type T;
public:
    explicit View(T& v) : v_(v) {}
    View(const View& o) : v_(o.v_) {}
    View& operator=(const View& r) { v_ = r.v_; return *this; }
    int Get() const { return v_.Get(); }
private:
    T& v_;
};
template <class Ch> View<true, Node<Ch>> Node<Ch>::GetView() const { return View<true, Node<Ch>>(*this); }

class Buffer {
public:
    void Put(const std::string& s) { s_ += s; }
    const char* Get() const { return s_.c_str(); }
private:
    std::string s_;
};

template <class Out>
class Printer {
public:
    explicit Printer(Out& o) : o_(o) {}
    void Number(int v) { o_.Put(std::to_string(v) + ";"); }
    void Key(const char* const& k) { o_.Put(std::string(k) + "="); }   // a const reference to a pointer
private:
    Out& o_;
};

}
