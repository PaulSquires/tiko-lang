// cppinclude/pods, called from C++: the output the tiko driver must reproduce.
#include "lib.hpp"
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

using namespace vm;

int main() {
    Vec2 p{1.5, 2.5};                              // an aggregate, fields set directly
    show_d("vec2.sum", p.x + p.y);
    Vec3 z;                                        // field initialisers
    show_d("vec3.default", z.length());
    show_i("vec3.default.bool", static_cast<bool>(z));
    Vec3 a(3, 4, 0), b(1, 2, 3);
    show_d("length", a.length());
    show_d("normalized.x", a.normalized().x);
    Vec3 c = a + b;                                // free operator
    show_d("plus", c.x * 100 + c.y * 10 + c.z);
    Vec3 d = a - b;
    show_d("minus", d.x * 100 + d.y * 10 + d.z);
    show_d("scale.right", (a * 2.0).x);
    show_d("scale.left", (0.5 * a).y);
    Vec3 n = -b;                                   // member unary
    show_d("neg", n.z);
    a += b;                                        // compound
    show_d("pluseq", a.x);
    a *= 2;
    show_d("muleq", a.y);
    a[2] = 9.5;                                    // operator[] assigns through
    show_d("index", a[2] + a.z);
    show_i("eq", a == a);
    show_i("ne", a != b);
    show_i("bool", static_cast<bool>(a));
    show_d("dot", dot(b, b));
    Vec3 x = cross(Vec3(1, 0, 0), Vec3(0, 1, 0));  // by value
    show_d("cross.z", x.z);

    Rect r = make_rect(7, 2, 3);
    show_d("rect.hi.y", r.hi.y);
    show_s("rect.tag", r.tag);
    show_u("rect.flags", r.flags);
    show_i("rect.color", (int)r.color);
    show_d("rect.w2", r.weights[2]);
    grow(r, 1);
    show_d("rect.area", area(r));
    Rect rs[3] = { make_rect(1, 1, 1), make_rect(2, 2, 2), make_rect(3, 3, 3) };
    const Rect* f = find(rs, 3, 2);
    show_d("find", area(*f));
    show_i("find.none", find(rs, 3, 9) == nullptr);

    Packed pk = make_packed(6.25);
    (void)pk;
    show_s("packed", "a handle");

    Mesh m;
    m.add(Vec3(1, 1, 1));
    m.add(Vec3(3, 3, 3));
    m.origin = Vec3(10, 0, 0);                     // a POD field of a handle
    m.origin.y = 5;
    show_d("centroid.x", m.centroid().x);
    show_d("centroid.y", m.centroid().y);
    m.front().z = 7;                               // through a reference to a POD
    show_d("front.z", m.at(0).z);
    show_d("index.mesh", m[1].x);
    Mesh e;
    show_i("mesh.empty", !e);
    show_i("mesh.lt", e < m);
    Mesh s = m + m;
    show_u("mesh.sum", s.size());
    return 0;
}
