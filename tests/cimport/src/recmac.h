/* Record-valued macros: raylib's colours, and the shapes that are refused. */
typedef struct Color { unsigned char r, g, b, a; } Color;
typedef struct Vec2 { float x, y; } Vec2;
typedef struct Pair { int lo; long long hi; } Pair;
typedef union Num { int i; float f; } Num;
typedef struct Outer { Vec2 at; int n; } Outer;
typedef struct Bits { unsigned int k : 3; } Bits;
typedef struct Named { const char *s; } Named;

#define CLITERAL(type) (type)
#define LIGHTGRAY  CLITERAL(Color){ 200, 200, 200, 255 }
#define HALF_UP    ((Vec2){ .y = 0.5f })
#define NEG_PAIR   ((Pair){ -1 - 2, 1LL << 40 })
#define NUM_ONE    ((Num){ 1 })
#define OUTER0     ((Outer){ { 1, 2 }, 3 })
#define BITS1      ((Bits){ 1 })
#define NAMED      ((Named){ "x" })
