// cppinclude/survey16: a second header over the first -- its classes are declared once.
#pragma once
#include "lib.hpp"
namespace s16 {
inline int twice(const Opt& o) { return 2 * o.k; }
}
