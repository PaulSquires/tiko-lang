/* tests/abi/apple/sig.c -- the C side of build/aapcsig.sh: every shape by value, both ways. */
typedef struct { char a; } C1;
typedef struct { char a,b,c; } C3;
typedef struct { short a; char b; } S3;
typedef struct { int a; } I1;
typedef struct { int a; char b; } I5;
typedef struct { int a,b; } I2;
typedef struct { int a,b,c; } I3;
typedef struct { long long a,b; } L2;
typedef struct { long long a; int b; } L12;
typedef struct { long long a,b,c; } L3;
typedef struct { float a; } F1;
typedef struct { float a,b; } F2;
typedef struct { float a,b,c; } F3;
typedef struct { float a,b,c,d; } F4;
typedef struct { float a,b,c,d,e; } F5;
typedef struct { double a; } D1;
typedef struct { double a,b; } D2;
typedef struct { double a,b,c; } D3;
typedef struct { double a,b,c,d; } D4;
typedef struct { double a,b,c,d,e; } D5;
typedef struct { float a; double b; } FD;
typedef struct { float a; int b; } FI;
typedef struct { float a[3]; } FA3;
typedef struct { F2 x; F2 y; } NF4;
typedef struct { double a[2]; } DA2;
typedef union { float a; float b; } UF;
typedef struct { char a[13]; } B13;
typedef struct { char a[17]; } B17;
C1 f_C1(C1 x); void g_C1(int i, C1 x);
C1 k_C1(C1 x);
C1 call_C1(C1 *p) { g_C1(1, *p); k_C1(*p); return f_C1(*p); }
C3 f_C3(C3 x); void g_C3(int i, C3 x);
C3 k_C3(C3 x);
C3 call_C3(C3 *p) { g_C3(1, *p); k_C3(*p); return f_C3(*p); }
S3 f_S3(S3 x); void g_S3(int i, S3 x);
S3 k_S3(S3 x);
S3 call_S3(S3 *p) { g_S3(1, *p); k_S3(*p); return f_S3(*p); }
I1 f_I1(I1 x); void g_I1(int i, I1 x);
I1 k_I1(I1 x);
I1 call_I1(I1 *p) { g_I1(1, *p); k_I1(*p); return f_I1(*p); }
I5 f_I5(I5 x); void g_I5(int i, I5 x);
I5 k_I5(I5 x);
I5 call_I5(I5 *p) { g_I5(1, *p); k_I5(*p); return f_I5(*p); }
I2 f_I2(I2 x); void g_I2(int i, I2 x);
I2 k_I2(I2 x);
I2 call_I2(I2 *p) { g_I2(1, *p); k_I2(*p); return f_I2(*p); }
I3 f_I3(I3 x); void g_I3(int i, I3 x);
I3 k_I3(I3 x);
I3 call_I3(I3 *p) { g_I3(1, *p); k_I3(*p); return f_I3(*p); }
L2 f_L2(L2 x); void g_L2(int i, L2 x);
L2 k_L2(L2 x);
L2 call_L2(L2 *p) { g_L2(1, *p); k_L2(*p); return f_L2(*p); }
L12 f_L12(L12 x); void g_L12(int i, L12 x);
L12 k_L12(L12 x);
L12 call_L12(L12 *p) { g_L12(1, *p); k_L12(*p); return f_L12(*p); }
L3 f_L3(L3 x); void g_L3(int i, L3 x);
L3 k_L3(L3 x);
L3 call_L3(L3 *p) { g_L3(1, *p); k_L3(*p); return f_L3(*p); }
F1 f_F1(F1 x); void g_F1(int i, F1 x);
F1 k_F1(F1 x);
F1 call_F1(F1 *p) { g_F1(1, *p); k_F1(*p); return f_F1(*p); }
F2 f_F2(F2 x); void g_F2(int i, F2 x);
F2 k_F2(F2 x);
F2 call_F2(F2 *p) { g_F2(1, *p); k_F2(*p); return f_F2(*p); }
F3 f_F3(F3 x); void g_F3(int i, F3 x);
F3 k_F3(F3 x);
F3 call_F3(F3 *p) { g_F3(1, *p); k_F3(*p); return f_F3(*p); }
F4 f_F4(F4 x); void g_F4(int i, F4 x);
F4 k_F4(F4 x);
F4 call_F4(F4 *p) { g_F4(1, *p); k_F4(*p); return f_F4(*p); }
F5 f_F5(F5 x); void g_F5(int i, F5 x);
F5 k_F5(F5 x);
F5 call_F5(F5 *p) { g_F5(1, *p); k_F5(*p); return f_F5(*p); }
D1 f_D1(D1 x); void g_D1(int i, D1 x);
D1 k_D1(D1 x);
D1 call_D1(D1 *p) { g_D1(1, *p); k_D1(*p); return f_D1(*p); }
D2 f_D2(D2 x); void g_D2(int i, D2 x);
D2 k_D2(D2 x);
D2 call_D2(D2 *p) { g_D2(1, *p); k_D2(*p); return f_D2(*p); }
D3 f_D3(D3 x); void g_D3(int i, D3 x);
D3 k_D3(D3 x);
D3 call_D3(D3 *p) { g_D3(1, *p); k_D3(*p); return f_D3(*p); }
D4 f_D4(D4 x); void g_D4(int i, D4 x);
D4 k_D4(D4 x);
D4 call_D4(D4 *p) { g_D4(1, *p); k_D4(*p); return f_D4(*p); }
D5 f_D5(D5 x); void g_D5(int i, D5 x);
D5 k_D5(D5 x);
D5 call_D5(D5 *p) { g_D5(1, *p); k_D5(*p); return f_D5(*p); }
FD f_FD(FD x); void g_FD(int i, FD x);
FD k_FD(FD x);
FD call_FD(FD *p) { g_FD(1, *p); k_FD(*p); return f_FD(*p); }
FI f_FI(FI x); void g_FI(int i, FI x);
FI k_FI(FI x);
FI call_FI(FI *p) { g_FI(1, *p); k_FI(*p); return f_FI(*p); }
FA3 f_FA3(FA3 x); void g_FA3(int i, FA3 x);
FA3 k_FA3(FA3 x);
FA3 call_FA3(FA3 *p) { g_FA3(1, *p); k_FA3(*p); return f_FA3(*p); }
NF4 f_NF4(NF4 x); void g_NF4(int i, NF4 x);
NF4 k_NF4(NF4 x);
NF4 call_NF4(NF4 *p) { g_NF4(1, *p); k_NF4(*p); return f_NF4(*p); }
DA2 f_DA2(DA2 x); void g_DA2(int i, DA2 x);
DA2 k_DA2(DA2 x);
DA2 call_DA2(DA2 *p) { g_DA2(1, *p); k_DA2(*p); return f_DA2(*p); }
UF f_UF(UF x); void g_UF(int i, UF x);
UF k_UF(UF x);
UF call_UF(UF *p) { g_UF(1, *p); k_UF(*p); return f_UF(*p); }
B13 f_B13(B13 x); void g_B13(int i, B13 x);
B13 k_B13(B13 x);
B13 call_B13(B13 *p) { g_B13(1, *p); k_B13(*p); return f_B13(*p); }
B17 f_B17(B17 x); void g_B17(int i, B17 x);
B17 k_B17(B17 x);
B17 call_B17(B17 *p) { g_B17(1, *p); k_B17(*p); return f_B17(*p); }
void hfa9(double a, double b, double c, double d, double e, double f, D3 x, double g);
void callhfa9(D3 *p) { hfa9(1, 2, 3, 4, 5, 6, *p, 7); }
void gpr7(long long a, long long b, long long c, long long d, long long e, long long f, long long g, L2 x, long long h);
void callgpr7(L2 *p) { gpr7(1, 2, 3, 4, 5, 6, 7, *p, 8); }
