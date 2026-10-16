/* reclit.h -- struct values: C compound literals, as raylib.h writes its colours. */
typedef struct Color { unsigned char r, g, b, a; } Color;
typedef struct Vec2 { float x; float y; } Vec2;
typedef union Either { int i; float f; } Either;
typedef struct Named { const char *name; int id; } Named;

#define CLITERAL(type) (type)

#define LIGHTGRAY CLITERAL(Color){ 200, 200, 200, 255 }   // Light Gray
#define HALF      (Vec2){ .y = 0.5f }                     // x omitted: 0
#define SUM       (Vec2){ 1 + 2, 3 * 4 }
#define ONE_OF    (Either){ 5 }
#define NAMED     (Named){ "n", 1 }
