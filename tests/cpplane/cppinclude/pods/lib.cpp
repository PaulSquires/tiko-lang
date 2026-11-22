// cppinclude/pods: the library.
#include "lib.hpp"
#include <cmath>
#include <cstring>

namespace vm {

double Vec3::length() const { return std::sqrt(x * x + y * y + z * z); }
Vec3 Vec3::normalized() const { double l = length(); return Vec3(x / l, y / l, z / l); }
Vec3& Vec3::operator+=(const Vec3& o) { x += o.x; y += o.y; z += o.z; return *this; }
Vec3& Vec3::operator*=(double s) { x *= s; y *= s; z *= s; return *this; }
Vec3 Vec3::operator-() const { return Vec3(-x, -y, -z); }
double& Vec3::operator[](int i) { return i == 0 ? x : i == 1 ? y : z; }
bool Vec3::operator==(const Vec3& o) const { return x == o.x && y == o.y && z == o.z; }
bool Vec3::operator!=(const Vec3& o) const { return !(*this == o); }
Vec3::operator bool() const { return x != 0 || y != 0 || z != 0; }

Vec3 operator+(const Vec3& a, const Vec3& b) { return Vec3(a.x + b.x, a.y + b.y, a.z + b.z); }
Vec3 operator-(const Vec3& a, const Vec3& b) { return Vec3(a.x - b.x, a.y - b.y, a.z - b.z); }
Vec3 operator*(const Vec3& a, double s) { return Vec3(a.x * s, a.y * s, a.z * s); }
Vec3 operator*(double s, const Vec3& a) { return a * s; }
double dot(const Vec3& a, const Vec3& b) { return a.x * b.x + a.y * b.y + a.z * b.z; }
Vec3 cross(Vec3 a, Vec3 b) { return Vec3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x); }

Rect make_rect(int id, double w, double h) {
    Rect r{};
    r.lo = Vec2{0, 0};
    r.hi = Vec2{w, h};
    r.id = id;
    std::strcpy(r.tag, "rect");
    r.flags = 0x81;
    r.color = Color::Green;
    r.weights[0] = 0.5; r.weights[1] = 0.25; r.weights[2] = 0.125;
    return r;
}
void grow(Rect& r, double by) { r.lo.x -= by; r.lo.y -= by; r.hi.x += by; r.hi.y += by; }
const Rect* find(const Rect* rs, int n, int id) {
    for (int i = 0; i < n; ++i) if (rs[i].id == id) return &rs[i];
    return nullptr;
}
double area(const Rect& r) { return (r.hi.x - r.lo.x) * (r.hi.y - r.lo.y); }

Packed make_packed(double d) { Packed p; p.c = 'p'; p.d = d; return p; }

void Mesh::add(const Vec3& p) { pts_.push_back(p); }
std::size_t Mesh::size() const { return pts_.size(); }
Vec3 Mesh::at(std::size_t i) const { return pts_.at(i); }
Vec3& Mesh::front() { return pts_.front(); }
Vec3 Mesh::centroid() const {
    Vec3 c;
    for (const Vec3& p : pts_) c += p;
    if (!pts_.empty()) c *= 1.0 / pts_.size();
    return c + origin;
}
bool Mesh::operator<(const Mesh& o) const { return size() < o.size(); }
bool Mesh::operator!() const { return pts_.empty(); }
const Vec3& Mesh::operator[](std::size_t i) const { return pts_[i]; }

Mesh operator+(const Mesh& a, const Mesh& b) {
    Mesh m = a;
    for (std::size_t i = 0; i < b.size(); ++i) m.add(b.at(i));
    return m;
}

}
