// cppinclude/nested: types nested in classes, static data members, constructors taking a
// std::vector, rvalue-reference parameters (the cpp-import survey, docs/tiko-cpp/SURVEY.md).
#pragma once
#include <string>
#include <vector>

namespace nest {

class Code {
public:
    enum class Level { LOW, MEDIUM = 5, HIGH };     // a scoped enum in a class
    enum Shape { SQUARE = 1, ROUND = 2 };            // an unscoped one
    class Mode {                                     // a class in a class, with static instances
    public:
        explicit Mode(int bits);
        int bits() const;
        static const Mode NUMERIC;
        static const Mode TEXT;
    private:
        int bits_;
    };
    struct Cell { int x; int y; };                   // a POD in a class
    static constexpr int MIN_SIZE = 1;               // constants
    static constexpr bool STRICT = true;
    static const long long BIG;                      // defined in lib.cpp
    static int created;                              // a static variable: get and set
    static double scale;

    Code(Level lv, const std::vector<int>& data);    // a std::vector in a constructor
    Code(std::string&& name, int n);                 // an rvalue reference
    Level level() const;
    Shape shape() const;
    const Mode& mode() const;                        // 'mode' and 'Mode' are one tiko name
    int total() const;
    std::string name() const;
    Cell at(int i) const;
    static Code make(Level lv);
    int sink(std::vector<int>&& v);                  // an rvalue std::vector
private:
    Level level_;
    std::vector<int> data_;
    std::string name_;
};

int count_level(Code::Level lv, Code::Shape sh);     // nested enums from outside the class
std::string mode_name(const Code::Mode& m);           // a nested class from outside

}  // namespace nest
