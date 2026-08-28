typedef   signed char       int8;
typedef unsigned char      uint8;
typedef   signed short      int16;
typedef unsigned short     uint16;
typedef   signed int        int32;
typedef unsigned int       uint32;
typedef   signed long long  int64;
typedef unsigned long long uint64;
typedef struct { char *data; int64 len; int64 size; } FBSTRING;
typedef struct { uint16 *data; int64 len; int64 size; } FBUSTRING;
typedef int8 boolean;
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE {
	int64 NUM;
	int64 DEN;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE ) == 16 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE {
	int64 A;
	int64 B;
	int16 C[3];
	int8 D;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE ) == 24 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING4TUDTE {
	int64 F0;
	int64 F1;
	int64 F2;
	int64 F3;
	int64 F4;
	int64 F5;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING4TUDTE ) == 48 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT1TE {
	int64 I;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT1TE ) == 8 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE {
	int64 I;
	int64 J;
	int64 K;
	int64 L;
	int64 M;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE ) == 40 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE {
	int64 I;
	int64 J;
	int64 K;
	int64 L;
	int64 M;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE ) == 40 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE {
	int64 I;
	int64 J;
	int64 K;
	int64 L;
	int64 M;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE ) == 40 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT1E {
	int64 I11;
	int64 I12;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT1E ) == 16 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT2E {
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT1E BASE$;
	int64 I21;
	int64 I22;
	int64 I23;
	int64 I24;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT2E ) == 48 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT3E {
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT2E BASE$;
	int64 I31;
	int64 I32;
	int64 I33;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT3E ) == 72 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT4E {
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT3E BASE$;
	int64 I41;
	int64 I42;
	int64 I43;
	int64 I44;
	int64 I45;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT4E ) == 112 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT5E {
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT4E BASE$;
	int64 I51;
	int64 I52;
	int64 I53;
	int64 I54;
	int64 I55;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT5E ) == 152 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTE {
	int64 I;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTE ) == 8 );
static struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTE tmp$279 = { 123ll };
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
int32 atexit( void* );
static void fb_ctor__udtzinit( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT3ADDERNS3_8RATIONALES5_( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*, struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE* );
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10INITSTATICEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT15INITSTATIC_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8INITAUTOEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT13INITAUTO_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING8PADDING1Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING13PADDING1_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING8PADDING2Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING13PADDING2_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT1TC1Ev( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT1TE* );
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TC1Eu7INTEGER( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE*, int64 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11FEv( void );
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ17DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ112DEFAULT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TC1Eu7INTEGER( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE*, int64 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21FEv( void );
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ27DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ212DEFAULT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TC1Eu7INTEGER( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE*, int64 );
struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31FEv( void );
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ37DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ312DEFAULT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTD1Ev( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTE* );
void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY8LABEL$82Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT13SUITE_CTOR307Ev( void ) __attribute__(( constructor ));
static void _GLOBAL__D( void ) __attribute__(( destructor ));
static int64 _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT11CTOR_COUNT$E;
static struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTE _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY9GLOBALX1$E = { 123ll };

struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT3ADDERNS3_8RATIONALES5_( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE* LHS$1, struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE* RHS$1 )
{
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$2:;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE RES$1;
	__builtin_memset( &RES$1, 0, 16ll );
	*(int64*)&RES$1 = (*(int64*)LHS$1 * *(int64*)((uint8*)RHS$1 + 8ll)) + (*(int64*)((uint8*)LHS$1 + 8ll) * *(int64*)RHS$1);
	*(int64*)((uint8*)&RES$1 + 8ll) = *(int64*)((uint8*)LHS$1 + 8ll) * *(int64*)((uint8*)RHS$1 + 8ll);
	__builtin_memcpy( &fb$result$1, &RES$1, 16 );
	label$3:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT7DEFAULTEv( void )
{
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE TMP$14$1;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE TMP$15$1;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE TMP$16$1;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE TMP$17$1;
	label$4:;
	*(int64*)&TMP$17$1 = 3ll;
	*(int64*)((uint8*)&TMP$17$1 + 8ll) = 4ll;
	*(int64*)&TMP$16$1 = 1ll;
	*(int64*)((uint8*)&TMP$16$1 + 8ll) = 2ll;
	*(int64*)&TMP$15$1 = -3ll;
	*(int64*)((uint8*)&TMP$15$1 + 8ll) = -4ll;
	*(int64*)&TMP$14$1 = -1ll;
	*(int64*)((uint8*)&TMP$14$1 + 8ll) = -2ll;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE RT$1[2];
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$1INS3_8RATIONALEEE {
		struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$1INS3_8RATIONALEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$1INS3_8RATIONALEEE tmp$9$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE**)&tmp$9$1 = (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)RT$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE**)((uint8*)&tmp$9$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)RT$1;
	*(int64*)((uint8*)&tmp$9$1 + 16ll) = 32ll;
	*(int64*)((uint8*)&tmp$9$1 + 24ll) = 16ll;
	*(int64*)((uint8*)&tmp$9$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$9$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$9$1 + 48ll) = 2ll;
	*(int64*)((uint8*)&tmp$9$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$9$1 + 64ll) = 1ll;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE vr$4 = _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT3ADDERNS3_8RATIONALES5_( &TMP$16$1, &TMP$17$1 );
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)RT$1 = vr$4;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE vr$7 = _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT3ADDERNS3_8RATIONALES5_( &TMP$14$1, &TMP$15$1 );
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)RT$1 + 16ll) = vr$7;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE L$1[2];
	__builtin_memset( (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1, 0, 32ll );
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$1INS3_8RATIONALEEE tmp$18$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE**)&tmp$18$1 = (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE**)((uint8*)&tmp$18$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1;
	*(int64*)((uint8*)&tmp$18$1 + 16ll) = 32ll;
	*(int64*)((uint8*)&tmp$18$1 + 24ll) = 16ll;
	*(int64*)((uint8*)&tmp$18$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$18$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$18$1 + 48ll) = 2ll;
	*(int64*)((uint8*)&tmp$18$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$18$1 + 64ll) = 1ll;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE R$1[2];
	__builtin_memset( (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1, 0, 32ll );
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$1INS3_8RATIONALEEE tmp$19$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE**)&tmp$19$1 = (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE**)((uint8*)&tmp$19$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1;
	*(int64*)((uint8*)&tmp$19$1 + 16ll) = 32ll;
	*(int64*)((uint8*)&tmp$19$1 + 24ll) = 16ll;
	*(int64*)((uint8*)&tmp$19$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$19$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$19$1 + 48ll) = 2ll;
	*(int64*)((uint8*)&tmp$19$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$19$1 + 64ll) = 1ll;
	*(int64*)L$1 = 1ll;
	*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1 + 8ll) = 2ll;
	*(int64*)R$1 = 3ll;
	*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1 + 8ll) = 4ll;
	*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1 + 16ll) = -1ll;
	*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1 + 24ll) = -2ll;
	*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1 + 16ll) = -3ll;
	*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1 + 24ll) = -4ll;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)RT$1 == ((*(int64*)L$1 * *(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1 + 8ll)) + (*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1 + 8ll) * *(int64*)R$1))) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 37, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.DEFAULT", (char*)"CU_ASSERT(rt(0).num = ((l(0).num * r(0).den) + (l(0).den * r(0).num)))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)RT$1 + 8ll) == (*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1 + 8ll) * *(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1 + 8ll))) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 38, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.DEFAULT", (char*)"CU_ASSERT(rt(0).den = ((l(0).den * r(0).den)))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)RT$1 + 16ll) == ((*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1 + 16ll) * *(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1 + 24ll)) + (*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1 + 24ll) * *(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1 + 16ll)))) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 39, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.DEFAULT", (char*)"CU_ASSERT(rt(1).num = ((l(1).num * r(1).den) + (l(1).den * r(1).num)))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)RT$1 + 24ll) == (*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)L$1 + 24ll) * *(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8RATIONALE*)R$1 + 24ll))) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 40, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.DEFAULT", (char*)"CU_ASSERT(rt(1).den = ((l(1).den * r(1).den)))" );
	label$5:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10INITSTATICEv( void )
{
	label$8:;
	static struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE ARRAYTYPE$1[11] = { { 1ll, 2ll, { (int16)3, (int16)4, (int16)5 }, (int8)6 }, { 2ll, 4ll, { (int16)6, (int16)8, (int16)10 }, (int8)12 } };
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$2INS3_6MYTYPEEEE {
		struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$2INS3_6MYTYPEEEE ) == 72 );
	static struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$2INS3_6MYTYPEEEE tmp$41$1 = { (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1, (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1, 264ll, 24ll, 1ll, 49ll, { { 11ll, 0ll, 10ll } } };
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 18ll) == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 51, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.INITSTATIC", (char*)"CU_ASSERT(arraytype(0).c(1) = 4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int8*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 22ll) == 6ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 52, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.INITSTATIC", (char*)"CU_ASSERT(arraytype(0).d = 6)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 42ll) == 8ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 53, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.INITSTATIC", (char*)"CU_ASSERT(arraytype(1).c(1) = 4*2)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int8*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 46ll) == 12ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 54, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.INITSTATIC", (char*)"CU_ASSERT(arraytype(1).d = 6*2)" );
	label$9:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8INITAUTOEv( void )
{
	label$12:;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE ARRAYTYPE$1[11];
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$3INS3_6MYTYPEEEE {
		struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$3INS3_6MYTYPEEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10FBARRAY1$3INS3_6MYTYPEEEE tmp$58$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE**)&tmp$58$1 = (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE**)((uint8*)&tmp$58$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1;
	*(int64*)((uint8*)&tmp$58$1 + 16ll) = 264ll;
	*(int64*)((uint8*)&tmp$58$1 + 24ll) = 24ll;
	*(int64*)((uint8*)&tmp$58$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$58$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$58$1 + 48ll) = 11ll;
	*(int64*)((uint8*)&tmp$58$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$58$1 + 64ll) = 10ll;
	*(int64*)ARRAYTYPE$1 = 1ll;
	*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 8ll) = 2ll;
	*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 16ll) = (int16)3;
	*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 18ll) = (int16)4;
	*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 20ll) = (int16)5;
	*(int8*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 22ll) = (int8)6;
	__builtin_memset( (void*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 23ll), 0, 1ll );
	*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 24ll) = 2ll;
	*(int64*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 32ll) = 4ll;
	*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 40ll) = (int16)6;
	*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 42ll) = (int16)8;
	*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 44ll) = (int16)10;
	*(int8*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 46ll) = (int8)12;
	__builtin_memset( (void*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 47ll), 0, 1ll );
	__builtin_memset( (void*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 48ll), 0, 216ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 18ll) == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 59, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.INITAUTO", (char*)"CU_ASSERT(arraytype(0).c(1) = 4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int8*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 22ll) == 6ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 60, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.INITAUTO", (char*)"CU_ASSERT(arraytype(0).d = 6)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int16*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 42ll) == 8ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 61, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.INITAUTO", (char*)"CU_ASSERT(arraytype(1).c(1) = 4*2)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int8*)((int64)(struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT6MYTYPEE*)ARRAYTYPE$1 + 46ll) == 12ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 62, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.INITOBJECT.INITAUTO", (char*)"CU_ASSERT(arraytype(1).d = 6*2)" );
	label$13:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING8PADDING1Ev( void )
{
	label$16:;
	int64 ARRAY$1[10];
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING10FBARRAY1$4Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING10FBARRAY1$4Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING10FBARRAY1$4Iu7INTEGEREE tmp$64$1;
	*(int64**)&tmp$64$1 = (int64*)ARRAY$1;
	*(int64**)((uint8*)&tmp$64$1 + 8ll) = (int64*)ARRAY$1;
	*(int64*)((uint8*)&tmp$64$1 + 16ll) = 80ll;
	*(int64*)((uint8*)&tmp$64$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&tmp$64$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$64$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$64$1 + 48ll) = 10ll;
	*(int64*)((uint8*)&tmp$64$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$64$1 + 64ll) = 9ll;
	*(int64*)ARRAY$1 = 0ll;
	*(int64*)((int64)(int64*)ARRAY$1 + 8ll) = 1ll;
	*(int64*)((int64)(int64*)ARRAY$1 + 16ll) = 2ll;
	*(int64*)((int64)(int64*)ARRAY$1 + 24ll) = 3ll;
	*(int64*)((int64)(int64*)ARRAY$1 + 32ll) = 4ll;
	__builtin_memset( (void*)((int64)(int64*)ARRAY$1 + 40ll), 0, 40ll );
	int64 I$1;
	__builtin_memset( &I$1, 0, 8ll );
	{
		I$1 = 0ll;
		label$21:;
		{
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(int64*)ARRAY$1 + (I$1 << (3ll & 63ll))) == I$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 71, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.PADDING.PADDING1", (char*)"CU_ASSERT(array(i) = i)" );
		}
		label$19:;
		I$1 = I$1 + 1ll;
		label$18:;
		if( I$1 <= 4ll) goto label$21;
		label$20:;
	}
	{
		I$1 = 5ll;
		label$25:;
		{
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(int64*)ARRAY$1 + (I$1 << (3ll & 63ll))) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 74, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.PADDING.PADDING1", (char*)"CU_ASSERT(array(i) = 0)" );
		}
		label$23:;
		I$1 = I$1 + 1ll;
		label$22:;
		if( I$1 <= 9ll) goto label$25;
		label$24:;
	}
	label$17:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING8PADDING2Ev( void )
{
	label$28:;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING4TUDTE UDT$1;
	*(int64*)&UDT$1 = 0ll;
	*(int64*)((uint8*)&UDT$1 + 8ll) = 1ll;
	*(int64*)((uint8*)&UDT$1 + 16ll) = 2ll;
	__builtin_memset( (void*)((uint8*)&UDT$1 + 24ll), 0, 24ll );
	{
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&UDT$1 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 85, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.PADDING.PADDING2", (char*)"CU_ASSERT(.f0 = 0)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&UDT$1 + 8ll) == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 86, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.PADDING.PADDING2", (char*)"CU_ASSERT(.f1 = 1)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&UDT$1 + 16ll) == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 87, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.PADDING.PADDING2", (char*)"CU_ASSERT(.f2 = 2)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&UDT$1 + 24ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 88, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.PADDING.PADDING2", (char*)"CU_ASSERT(.f3 = 0)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&UDT$1 + 32ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 89, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.PADDING.PADDING2", (char*)"CU_ASSERT(.f4 = 0)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&UDT$1 + 40ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 90, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.PADDING.PADDING2", (char*)"CU_ASSERT(.f5 = 0)" );
	}
	label$29:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT1TC1Ev( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT1TE* THIS$1 )
{
	label$32:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT11CTOR_COUNT$E = _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT11CTOR_COUNT$E + 1ll;
	label$33:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT7DEFAULTEv( void )
{
	label$34:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT11CTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 109, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.ANYINIT.DEFAULT", (char*)"CU_ASSERT(ctor_count = 0)" );
	{
		struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT1TE X$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT11CTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 112, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.ANYINIT.DEFAULT", (char*)"CU_ASSERT(ctor_count = 0)" );
		_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT1TC1Ev( &X$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT11CTOR_COUNT$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 114, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.ANYINIT.DEFAULT", (char*)"CU_ASSERT(ctor_count = 1)" );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT11CTOR_COUNT$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 116, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.ANYINIT.DEFAULT", (char*)"CU_ASSERT(ctor_count = 1)" );
	label$35:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TC1Ev( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE* THIS$1 )
{
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 16ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 24ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 32ll), 0, 8ll );
	label$38:;
	label$39:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TC1Eu7INTEGER( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE* THIS$1, int64 I$1 )
{
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 16ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 24ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 32ll), 0, 8ll );
	label$40:;
	label$41:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TaSERS4_( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE* THIS$1, struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE* X$1 )
{
	label$42:;
	label$43:;
}

struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11FEv( void )
{
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE fb$result$1;
	label$44:;
	_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TC1Eu7INTEGER( &fb$result$1, 420ll );
	goto label$45;
	label$45:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ17DEFAULTEv( void )
{
	label$46:;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE X$1;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11TE vr$0 = _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ11FEv(  );
	X$1 = vr$0;
	{
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((((*(int64*)&X$1 | *(int64*)((uint8*)&X$1 + 8ll)) | *(int64*)((uint8*)&X$1 + 16ll)) | *(int64*)((uint8*)&X$1 + 24ll)) | *(int64*)((uint8*)&X$1 + 32ll)) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 144, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.OBJ1.DEFAULT", (char*)"CU_ASSERT((.i or .j or .k or .l or .m) = 0)" );
	}
	label$47:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TC1Ev( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE* THIS$1 )
{
	*(int64*)THIS$1 = 1ll;
	*(int64*)((uint8*)THIS$1 + 8ll) = 2ll;
	*(int64*)((uint8*)THIS$1 + 16ll) = 3ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 4ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 5ll;
	label$50:;
	label$51:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TC1Eu7INTEGER( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE* THIS$1, int64 I$1 )
{
	*(int64*)THIS$1 = 1ll;
	*(int64*)((uint8*)THIS$1 + 8ll) = 2ll;
	*(int64*)((uint8*)THIS$1 + 16ll) = 3ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 4ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 5ll;
	label$52:;
	label$53:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TaSERS4_( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE* THIS$1, struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE* X$1 )
{
	label$54:;
	label$55:;
}

struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21FEv( void )
{
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE fb$result$1;
	label$56:;
	_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TC1Eu7INTEGER( &fb$result$1, 420ll );
	goto label$57;
	label$57:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ27DEFAULTEv( void )
{
	label$58:;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE X$1;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21TE vr$0 = _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ21FEv(  );
	X$1 = vr$0;
	{
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((((*(int64*)&X$1 + *(int64*)((uint8*)&X$1 + 8ll)) + *(int64*)((uint8*)&X$1 + 16ll)) + *(int64*)((uint8*)&X$1 + 24ll)) + *(int64*)((uint8*)&X$1 + 32ll)) == 15ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 173, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.OBJ2.DEFAULT", (char*)"CU_ASSERT((.i + .j + .k + .l + .m) = 15)" );
	}
	label$59:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TC1Ev( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE* THIS$1 )
{
	label$62:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 16ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 24ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 32ll), 0, 8ll );
	*(int64*)THIS$1 = 12345ll;
	label$63:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TC1Eu7INTEGER( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE* THIS$1, int64 I$1 )
{
	label$64:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 16ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 24ll), 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 32ll), 0, 8ll );
	*(int64*)THIS$1 = I$1;
	label$65:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TaSERS4_( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE* THIS$1, struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE* X$1 )
{
	label$66:;
	label$67:;
}

struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31FEv( void )
{
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE fb$result$1;
	label$68:;
	_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TC1Eu7INTEGER( &fb$result$1, 420ll );
	goto label$69;
	label$69:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ37DEFAULTEv( void )
{
	label$70:;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE X$1;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31TE vr$0 = _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ31FEv(  );
	X$1 = vr$0;
	{
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&X$1 == 420ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 204, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.OBJ3.DEFAULT", (char*)"CU_ASSERT(( .i = 420 ))" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&X$1 + 8ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 205, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.OBJ3.DEFAULT", (char*)"CU_ASSERT(( .j = 0 ))" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&X$1 + 16ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 206, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.OBJ3.DEFAULT", (char*)"CU_ASSERT(( .k = 0 ))" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&X$1 + 24ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 207, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.OBJ3.DEFAULT", (char*)"CU_ASSERT(( .l = 0 ))" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&X$1 + 32ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 208, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.OBJ3.DEFAULT", (char*)"CU_ASSERT(( .m = 0 ))" );
	}
	label$71:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED7DEFAULTEv( void )
{
	label$74:;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT5E U1$1;
	*(int64*)&U1$1 = 1ll;
	*(int64*)((uint8*)&U1$1 + 8ll) = 2ll;
	*(int64*)((uint8*)&U1$1 + 16ll) = 3ll;
	*(int64*)((uint8*)&U1$1 + 24ll) = 4ll;
	*(int64*)((uint8*)&U1$1 + 32ll) = 5ll;
	*(int64*)((uint8*)&U1$1 + 40ll) = 6ll;
	*(int64*)((uint8*)&U1$1 + 48ll) = 7ll;
	*(int64*)((uint8*)&U1$1 + 56ll) = 8ll;
	*(int64*)((uint8*)&U1$1 + 64ll) = 9ll;
	__builtin_memset( (void*)((uint8*)&U1$1 + 72ll), 0, 40ll );
	__builtin_memset( (void*)((uint8*)&U1$1 + 112ll), 0, 40ll );
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED4UDT5E U2$1;
	__builtin_memset( &U2$1, 0, 152ll );
	*(int64*)&U2$1 = 1ll;
	*(int64*)((uint8*)&U2$1 + 8ll) = 2ll;
	*(int64*)((uint8*)&U2$1 + 16ll) = 3ll;
	*(int64*)((uint8*)&U2$1 + 24ll) = 4ll;
	*(int64*)((uint8*)&U2$1 + 32ll) = 5ll;
	*(int64*)((uint8*)&U2$1 + 40ll) = 6ll;
	*(int64*)((uint8*)&U2$1 + 48ll) = 7ll;
	*(int64*)((uint8*)&U2$1 + 56ll) = 8ll;
	*(int64*)((uint8*)&U2$1 + 64ll) = 9ll;
	__builtin_memset( (void*)((uint8*)&U2$1 + 72ll), 0, 40ll );
	__builtin_memset( (void*)((uint8*)&U2$1 + 112ll), 0, 40ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&U1$1 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 239, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i11 = 1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 8ll) == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 240, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i12 = 2)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 16ll) == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 241, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i21 = 3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 24ll) == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 242, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i22 = 4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 32ll) == 5ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 243, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i23 = 5)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 40ll) == 6ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 244, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i24 = 6)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 48ll) == 7ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 245, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i31 = 7)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 56ll) == 8ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 246, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i32 = 8)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 64ll) == 9ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 247, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i33 = 9)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 72ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 248, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i41 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 80ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 249, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i42 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 88ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 250, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i43 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 96ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 251, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i44 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 104ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 252, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i45 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 112ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 253, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i51 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 120ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 254, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i52 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 128ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 255, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i53 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 136ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 256, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i54 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$1 + 144ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 257, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u1.i55 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&U2$1 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 259, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i11 = 1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 8ll) == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 260, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i12 = 2)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 16ll) == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 261, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i21 = 3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 24ll) == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 262, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i22 = 4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 32ll) == 5ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 263, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i23 = 5)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 40ll) == 6ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 264, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i24 = 6)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 48ll) == 7ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 265, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i31 = 7)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 56ll) == 8ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 266, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i32 = 8)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 64ll) == 9ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 267, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i33 = 9)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 72ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 268, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i41 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 80ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 269, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i42 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 88ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 270, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i43 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 96ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 271, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i44 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 104ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 272, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i45 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 112ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 273, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i51 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 120ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 274, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i52 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 128ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 275, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i53 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 136ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 276, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i54 = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$1 + 144ll) == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 277, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DERIVED.DEFAULT", (char*)"CU_ASSERT(u2.i55 = 0)" );
	label$75:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTD1Ev( struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTE* THIS$1 )
{
	label$78:;
	label$79:;
}

static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY8LABEL$82Ev( void )
{
	label$85:;
	_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTD1Ev( &tmp$279 );
	label$86:;
}

void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DEFAULTEv( void )
{
	label$80:;
	static int64 LABEL$83$1;
	if( LABEL$83$1 != 0ll) goto label$84;
	LABEL$83$1 = 1ll;
	atexit( (void*)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY8LABEL$82Ev );
	label$84:;
	struct $N5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTE LOCALX1$1;
	*(int64*)&LOCALX1$1 = 123ll;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY9GLOBALX1$E == 123ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 301, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DTORONLY.DEFAULT", (char*)"CU_ASSERT(globalx1.i = 123)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&tmp$279 == 123ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 302, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DTORONLY.DEFAULT", (char*)"CU_ASSERT(staticx1.i = 123)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&LOCALX1$1 == 123ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cudt-init.bas", 303, (char*)"TESTS.FBC_TESTS.DIM_.UDT_INIT.DTORONLY.DEFAULT", (char*)"CU_ASSERT(localx1.i = 123)" );
	_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTD1Ev( &LOCALX1$1 );
	label$81:;
}

__attribute__(( constructor )) static void fb_ctor__udtzinit( void )
{
	label$0:;
	label$1:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT12DEFAULT_CTOREv( void )
{
	label$6:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"initObject.default", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT7DEFAULTEv, (boolean)0ll );
	label$7:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT15INITSTATIC_CTOREv( void )
{
	label$10:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"initObject.initStatic", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT10INITSTATICEv, (boolean)0ll );
	label$11:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT13INITAUTO_CTOREv( void )
{
	label$14:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"initObject.initAuto", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT10INITOBJECT8INITAUTOEv, (boolean)0ll );
	label$15:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING13PADDING1_CTOREv( void )
{
	label$26:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"padding.padding1", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING8PADDING1Ev, (boolean)0ll );
	label$27:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING13PADDING2_CTOREv( void )
{
	label$30:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"padding.padding2", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7PADDING8PADDING2Ev, (boolean)0ll );
	label$31:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT12DEFAULT_CTOREv( void )
{
	label$36:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"anyinit.default", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7ANYINIT7DEFAULTEv, (boolean)0ll );
	label$37:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ112DEFAULT_CTOREv( void )
{
	label$48:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"obj1.default", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ17DEFAULTEv, (boolean)0ll );
	label$49:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ212DEFAULT_CTOREv( void )
{
	label$60:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"obj2.default", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ27DEFAULTEv, (boolean)0ll );
	label$61:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ312DEFAULT_CTOREv( void )
{
	label$72:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"obj3.default", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT4OBJ37DEFAULTEv, (boolean)0ll );
	label$73:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED12DEFAULT_CTOREv( void )
{
	label$76:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"derived.default", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT7DERIVED7DEFAULTEv, (boolean)0ll );
	label$77:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY12DEFAULT_CTOREv( void )
{
	label$87:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.udt_init", (char*)"dtorOnly.default", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DEFAULTEv, (boolean)0ll );
	label$88:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT13SUITE_CTOR307Ev( void )
{
	label$89:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.dim_.udt_init", (tmp$4)0ull, (tmp$4)0ull );
	label$90:;
}

__attribute__(( destructor )) static void _GLOBAL__D( void )
{
	label$92:;
	_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY7DTORUDTD1Ev( &_ZN5TESTS9FBC_TESTS4DIM_8UDT_INIT8DTORONLY9GLOBALX1$E );
	label$93:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
