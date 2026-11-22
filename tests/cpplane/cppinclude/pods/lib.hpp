// cppinclude/pods: PODs as tiko value types and C++ operators as tiko operators. Vec2 is a bare
// aggregate, Vec3 has field initialisers, constructors, methods and member operators, Rect nests
// PODs and holds an array, a fixed string and a one-byte enum; Packed is '#pragma pack(1)', so it
// stays a handle. Mesh is a handle with a POD field and operators of its own. docs/tiko-cpp C3b-1.
#pragma once
#include <cstddef>
#include <vector>

namespace vm {

enum class Color : unsigned char { Red = 1, Green = 2 };

struct Vec2 { double x, y; };

struct Vec3 {
    double x = 0, y = 0, z = 0;
    Vec3() = default;
    Vec3(double x_, double y_, double z_) : x(x_), y(y_), z(z_) {}
    double length() const;
    Vec3 normalized() const;
    Vec3& operator+=(const Vec3& o);
    Vec3& operator*=(double s);
    Vec3 operator-() const;
    double& operator[](int i);
    bool operator==(const Vec3& o) const;
    bool operator!=(const Vec3& o) const;
    explicit operator bool() const;             // not the zero vector
};

Vec3 operator+(const Vec3& a, const Vec3& b);
Vec3 operator-(const Vec3& a, const Vec3& b);
Vec3 operator*(const Vec3& a, double s);
Vec3 operator*(double s, const Vec3& a);
double dot(const Vec3& a, const Vec3& b);
Vec3 cross(Vec3 a, Vec3 b);                     // by value

struct Rect {
    Vec2 lo, hi;
    int id;
    char tag[8];
    unsigned char flags;
    Color color;
    double weights[3];
};

Rect make_rect(int id, double w, double h);
void grow(Rect& r, double by);
const Rect* find(const Rect* rs, int n, int id);
double area(const Rect& r);

#pragma pack(push, 1)
struct Packed { char c; double d; };
#pragma pack(pop)
Packed make_packed(double d);

class Mesh {
public:
    Vec3 origin;                                // a POD field of a handle
    void add(const Vec3& p);
    std::size_t size() const;
    Vec3 at(std::size_t i) const;
    Vec3& front();
    Vec3 centroid() const;
    bool operator<(const Mesh& o) const;        // by size
    bool operator!() const;                     // empty
    const Vec3& operator[](std::size_t i) const;
private:
    std::vector<Vec3> pts_;
};

Mesh operator+(const Mesh& a, const Mesh& b);

}
