// cppinclude/glm, called from C++: GLM's own README example -- the camera() function -- and
// vector arithmetic. The tiko driver must print the same.
#include "lib.hpp"
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

// From GLM's README.md.
static glm::mat4 camera(float Translate, glm::vec2 const& Rotate)
{
    glm::mat4 Projection = glm::perspective(glm::pi<float>() * 0.25f, 4.0f / 3.0f, 0.1f, 100.f);
    glm::mat4 View = glm::translate(glm::mat4(1.0f), glm::vec3(0.0f, 0.0f, -Translate));
    View = glm::rotate(View, Rotate.y, glm::vec3(-1.0f, 0.0f, 0.0f));
    View = glm::rotate(View, Rotate.x, glm::vec3(0.0f, 1.0f, 0.0f));
    glm::mat4 Model = glm::scale(glm::mat4(1.0f), glm::vec3(0.5f));
    return Projection * View * Model;
}

int main() {
    glm::mat4 m = camera(2.0f, glm::vec2(0.5f, 0.25f));
    for (int c = 0; c < 4; ++c) {
        char k[16];
        for (int r = 0; r < 4; ++r) { k[0] = 'm'; k[1] = '0' + c; k[2] = '0' + r; k[3] = 0; show_d(k, m[c][r]); }
    }
    glm::vec4 p = m * glm::vec4(1.0f, 2.0f, 3.0f, 1.0f);
    show_d("p.x", p.x); show_d("p.y", p.y); show_d("p.z", p.z); show_d("p.w", p.w);
    glm::vec3 a(1.0f, 2.0f, 3.0f), b(4.0f, 5.0f, 6.0f);
    glm::vec3 s = a + b;
    show_d("sum.y", s.y);
    show_d("dot", glm::dot(a, b));
    glm::vec3 c = glm::cross(a, b);
    show_d("cross", c.x * 100 + c.y * 10 + c.z);
    show_d("length", glm::length(a));
    show_d("normalize.z", glm::normalize(b).z);
    show_d("pi", glm::pi<float>());
    a[1] = 9.0f;
    show_d("index", a.y);
    show_i("vec3.length", glm::vec3::length());
    return 0;
}
