/* vin.h -- a library header with a C99 inline function the library also exports (as raylib's
   raymath.h does), a static inline one it cannot, and an ordinary one. */
inline int vin_add( int a, int b ) { return a + b + 100; }
static inline int vin_static( int a ) { return a; }
int vin_plain( int a );
