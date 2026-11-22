// cppinclude/nested: types nested in classes, static data members, constructors taking a
// std::vector, rvalue-reference parameters (the cpp-import survey, docs/tiko-cpp/SURVEY.md).
#pragma once
#include <array>
#include <optional>
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

// Standard library shapes the survey needed.
std::vector<std::vector<int>> grid(int n);            // nested vectors
int sum2(const std::vector<std::vector<int>>& g);
std::array<double, 3> cross(const std::array<double, 3>& a, const std::array<double, 3>& b);
std::vector<std::array<double, 2>> ring(int n);       // a vector of arrays
std::optional<int> find(const std::vector<int>& v, int x);
std::optional<std::string> label(int i);
void decorate(std::string& s);                        // a std::string& to fill
struct Adder { int base = 0; int operator()(int a, int b = 1) const { return base + a + b; } };
constexpr int ANSWER = 42;                            // namespace constants and variables
extern const char* const GREETING;
enum { FLAG_A = 1, FLAG_B = 4 };
std::string bytes(int n);                             // binary data in a std::string
long long checksum(const std::string& s);

}  // namespace nest
