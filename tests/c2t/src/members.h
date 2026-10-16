/* members.h -- macros that read a struct's fields: '.', '->', a field of a field, and the field
   of a returned value, as raymath.h's MatrixToFloat. */
typedef struct Vec3 { float x, y, z; } Vec3;
typedef struct Box { Vec3 min; Vec3 max; } Box;
Vec3 make(float a);

#define VX(v)        (v).x
#define PX(p)        (p)->x
#define BOX_MAXZ(b)  ((b).max.z)
#define MAKE_Y(a)    (make(a).y)
#define AT(p, i)     (p)[i]
#define TYPE_OF(r)   (r).type
