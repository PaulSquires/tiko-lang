'' Thirty levels of a doubling macro is 620 bytes and nests no deeper than thirty, and it
'' expands to 2^30 tokens. The preprocessor stops at PP_MAX_TOKENS with TKO0372.
#define M0 x x
#define M1 M0 M0
#define M2 M1 M1
#define M3 M2 M2
#define M4 M3 M3
#define M5 M4 M4
#define M6 M5 M5
#define M7 M6 M6
#define M8 M7 M7
#define M9 M8 M8
#define M10 M9 M9
#define M11 M10 M10
#define M12 M11 M11
#define M13 M12 M12
#define M14 M13 M13
#define M15 M14 M14
#define M16 M15 M15
#define M17 M16 M16
#define M18 M17 M17
#define M19 M18 M18
#define M20 M19 M19
#define M21 M20 M20
#define M22 M21 M21
#define M23 M22 M22
#define M24 M23 M23
#define M25 M24 M24
#define M26 M25 M25
#define M27 M26 M26
#define M28 M27 M27
#define M29 M28 M28
M29
