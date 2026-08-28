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
struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN1TE {
	int16 A;
	int64 B;
	float C[2];
	double D;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN1TE ) == 32 );
struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTE {
	int64 I;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTE ) == 8 );
struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AE {
	int64 I;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AE ) == 8 );
struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1BE {
	int64 I;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1BE ) == 8 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
static void fb_ctor__anonzassign( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST1Ev( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN10TEST1_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST2Ev( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN10TEST2_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST3Ev( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN10TEST3_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST4Ev( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN10TEST4_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTC1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTE* );
void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AC1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AE* );
int64 _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1B1FERNS3_1AE( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1BE*, struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AE* );
void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN13SUITE_CTOR114Ev( void ) __attribute__(( constructor ));
static int64 _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS6CTORS$E;

void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST1Ev( void )
{
	label$2:;
	struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN1TE UDT$1;
	*(int16*)&UDT$1 = (int16)1;
	__builtin_memset( (void*)((uint8*)&UDT$1 + 2ll), 0, 6ll );
	*(int64*)((uint8*)&UDT$1 + 8ll) = 2ll;
	*(float*)((uint8*)&UDT$1 + 16ll) = 0x1.8p+1f;
	*(float*)((uint8*)&UDT$1 + 20ll) = 0x1.p+2f;
	*(double*)((uint8*)&UDT$1 + 24ll) = 0x1.4p+2;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int16*)&UDT$1 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 15, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST1", (char*)"CU_ASSERT_EQUAL(udt.a,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&UDT$1 + 8ll) == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 16, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST1", (char*)"CU_ASSERT_EQUAL(udt.b,2)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(float*)((uint8*)&UDT$1 + 16ll) == 0x1.8p+1f) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 17, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST1", (char*)"CU_ASSERT_EQUAL(udt.c(0),3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(float*)((uint8*)&UDT$1 + 20ll) == 0x1.p+2f) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 18, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST1", (char*)"CU_ASSERT_EQUAL(udt.c(1),4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&UDT$1 + 24ll) == 0x1.4p+2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 19, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST1", (char*)"CU_ASSERT_EQUAL(udt.d,5)" );
	label$3:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST2Ev( void )
{
	label$6:;
	static struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN1TE UDT$1 = { (int16)1, 2ll, { 0x1.8p+1f, 0x1.p+2f }, 0x1.4p+2 };
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int16*)&UDT$1 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 25, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST2", (char*)"CU_ASSERT_EQUAL(udt.a,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&UDT$1 + 8ll) == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 26, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST2", (char*)"CU_ASSERT_EQUAL(udt.b,2)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(float*)((uint8*)&UDT$1 + 16ll) == 0x1.8p+1f) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 27, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST2", (char*)"CU_ASSERT_EQUAL(udt.c(0),3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(float*)((uint8*)&UDT$1 + 20ll) == 0x1.p+2f) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 28, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST2", (char*)"CU_ASSERT_EQUAL(udt.c(1),4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&UDT$1 + 24ll) == 0x1.4p+2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 29, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST2", (char*)"CU_ASSERT_EQUAL(udt.d,5)" );
	label$7:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST3Ev( void )
{
	label$10:;
	struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN1TE UDT$1;
	__builtin_memset( &UDT$1, 0, 32ll );
	*(int16*)&UDT$1 = (int16)-1;
	__builtin_memset( (void*)((uint8*)&UDT$1 + 2ll), 0, 6ll );
	*(int64*)((uint8*)&UDT$1 + 8ll) = -2ll;
	*(float*)((uint8*)&UDT$1 + 16ll) = -0x1.8p+1f;
	*(float*)((uint8*)&UDT$1 + 20ll) = -0x1.p+2f;
	*(double*)((uint8*)&UDT$1 + 24ll) = -0x1.4p+2;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int16*)&UDT$1 == -1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 37, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST3", (char*)"CU_ASSERT_EQUAL(udt.a,-1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&UDT$1 + 8ll) == -2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 38, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST3", (char*)"CU_ASSERT_EQUAL(udt.b,-2)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(float*)((uint8*)&UDT$1 + 16ll) == -0x1.8p+1f) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 39, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST3", (char*)"CU_ASSERT_EQUAL(udt.c(0),-3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(float*)((uint8*)&UDT$1 + 20ll) == -0x1.p+2f) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 40, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST3", (char*)"CU_ASSERT_EQUAL(udt.c(1),-4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&UDT$1 + 24ll) == -0x1.4p+2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 41, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST3", (char*)"CU_ASSERT_EQUAL(udt.d,-5)" );
	label$11:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST4Ev( void )
{
	label$14:;
	static struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN1TE UDT$1;
	*(int16*)&UDT$1 = (int16)-1;
	__builtin_memset( (void*)((uint8*)&UDT$1 + 2ll), 0, 6ll );
	*(int64*)((uint8*)&UDT$1 + 8ll) = -2ll;
	*(float*)((uint8*)&UDT$1 + 16ll) = -0x1.8p+1f;
	*(float*)((uint8*)&UDT$1 + 20ll) = -0x1.p+2f;
	*(double*)((uint8*)&UDT$1 + 24ll) = -0x1.4p+2;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int16*)&UDT$1 == -1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 49, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST4", (char*)"CU_ASSERT_EQUAL(udt.a,-1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&UDT$1 + 8ll) == -2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 50, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST4", (char*)"CU_ASSERT_EQUAL(udt.b,-2)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(float*)((uint8*)&UDT$1 + 16ll) == -0x1.8p+1f) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 51, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST4", (char*)"CU_ASSERT_EQUAL(udt.c(0),-3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(float*)((uint8*)&UDT$1 + 20ll) == -0x1.p+2f) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 52, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST4", (char*)"CU_ASSERT_EQUAL(udt.c(1),-4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&UDT$1 + 24ll) == -0x1.4p+2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 53, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.TEST4", (char*)"CU_ASSERT_EQUAL(udt.d,-5)" );
	label$15:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTC1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTE* THIS$1 )
{
	label$18:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS6CTORS$E = _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS6CTORS$E + 1ll;
	label$19:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS7DEFAULTEv( void )
{
	struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTE TMP$80$1;
	label$20:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS6CTORS$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 70, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.CTORCALLDESPITECONSTBITS.DEFAULT", (char*)"CU_ASSERT(ctors = 0)" );
	struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTE X$1;
	_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTC1Ev( &X$1 );
	*(int64*)&X$1 = 123ll;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS6CTORS$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 74, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.CTORCALLDESPITECONSTBITS.DEFAULT", (char*)"CU_ASSERT(ctors = 1)" );
	_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS3UDTC1Ev( &TMP$80$1 );
	__builtin_memcpy( &X$1, &TMP$80$1, 8 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&X$1 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 80, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.CTORCALLDESPITECONSTBITS.DEFAULT", (char*)"CU_ASSERT(x.i = 0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS6CTORS$E == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 81, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.CTORCALLDESPITECONSTBITS.DEFAULT", (char*)"CU_ASSERT(ctors = 2)" );
	label$21:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AC1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AE* THIS$1 )
{
	label$24:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	*(int64*)THIS$1 = 123ll;
	label$25:;
}

int64 _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1B1FERNS3_1AE( struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1BE* THIS$1, struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AE* X$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$26:;
	fb$result$1 = *(int64*)X$1;
	label$27:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT7DEFAULTEv( void )
{
	struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AE TMP$98$1;
	label$28:;
	struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AE XA$1;
	_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AC1Ev( &XA$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&XA$1 == 123ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 107, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.ANONCTORCALLINIT.DEFAULT", (char*)"CU_ASSERT(xa.i = 123)" );
	struct $N5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1BE XB$1;
	__builtin_memset( &XB$1, 0, 8ll );
	_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1AC1Ev( &TMP$98$1 );
	int64 vr$7 = _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT1B1FERNS3_1AE( &XB$1, &TMP$98$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$7 == 123ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-assign.bas", 110, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_ASSIGN.ANONCTORCALLINIT.DEFAULT", (char*)"CU_ASSERT(xb.f( ) = 123)" );
	label$29:;
}

__attribute__(( constructor )) static void fb_ctor__anonzassign( void )
{
	label$0:;
	label$1:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN10TEST1_CTOREv( void )
{
	label$4:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.anon_assign", (char*)"test1", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST1Ev, (boolean)0ll );
	label$5:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN10TEST2_CTOREv( void )
{
	label$8:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.anon_assign", (char*)"test2", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST2Ev, (boolean)0ll );
	label$9:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN10TEST3_CTOREv( void )
{
	label$12:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.anon_assign", (char*)"test3", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST3Ev, (boolean)0ll );
	label$13:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN10TEST4_CTOREv( void )
{
	label$16:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.anon_assign", (char*)"test4", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN5TEST4Ev, (boolean)0ll );
	label$17:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS12DEFAULT_CTOREv( void )
{
	label$22:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.anon_assign", (char*)"ctorcallDespiteConstBits.default", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN24CTORCALLDESPITECONSTBITS7DEFAULTEv, (boolean)0ll );
	label$23:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT12DEFAULT_CTOREv( void )
{
	label$30:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.anon_assign", (char*)"anonCtorCallInit.default", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN16ANONCTORCALLINIT7DEFAULTEv, (boolean)0ll );
	label$31:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11ANON_ASSIGN13SUITE_CTOR114Ev( void )
{
	label$32:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.structs.anon_assign", (tmp$4)0ull, (tmp$4)0ull );
	label$33:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
