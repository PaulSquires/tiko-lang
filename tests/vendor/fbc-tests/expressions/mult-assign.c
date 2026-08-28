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
struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE {
	int16 A;
	int16 B;
	FBSTRING C;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE ) == 32 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
int32 fb_StrCompare( void*, int64, void*, int64 );
static void fb_ctor__multzassign( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETC1EssPc( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE*, int16, int16, char* );
void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETD1Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* );
static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETaSERKS3_( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE*, struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* );
struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC1Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* );
struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC2Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* );
struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC3Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* );
struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC4Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* );
void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN12LETVARIABLESEv( void );
static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN17LETVARIABLES_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN14LETARRAYACCESSEv( void );
static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN19LETARRAYACCESS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN12LETUDTFIELDSEv( void );
static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN17LETUDTFIELDS_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN13SUITE_CTOR105Ev( void ) __attribute__(( constructor ));
static int64 _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN8DTORCNT$E = 0ll;

void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETC1EssPc( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* THIS$1, int16 A$1, int16 B$1, char* C$1 )
{
	label$6:;
	__builtin_memset( (FBSTRING*)((uint8*)THIS$1 + 8ll), 0, 24ll );
	*(int16*)THIS$1 = A$1;
	*(int16*)((uint8*)THIS$1 + 2ll) = B$1;
	fb_StrAssign( (void*)((uint8*)THIS$1 + 8ll), -1ll, (void*)C$1, 0ll, 0 );
	label$7:;
}

void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETD1Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* THIS$1 )
{
	label$8:;
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN8DTORCNT$E = _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN8DTORCNT$E + 1ll;
	label$9:;
	fb_StrDelete( (FBSTRING*)((uint8*)THIS$1 + 8ll) );
}

struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC1Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* tmp$7$1 )
{
	label$10:;
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETC1EssPc( tmp$7$1, (int16)1, (int16)2, (char*)"3" );
	goto label$11;
	label$11:;
	return tmp$7$1;
}

struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC2Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* tmp$10$1 )
{
	label$12:;
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETC1EssPc( tmp$10$1, (int16)-1, (int16)-2, (char*)"-3" );
	goto label$13;
	label$13:;
	return tmp$10$1;
}

struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC3Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* tmp$13$1 )
{
	label$14:;
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETC1EssPc( tmp$13$1, (int16)10, (int16)11, (char*)"12" );
	goto label$15;
	label$15:;
	return tmp$13$1;
}

struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC4Ev( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* tmp$16$1 )
{
	label$16:;
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETC1EssPc( tmp$16$1, (int16)-10, (int16)-11, (char*)"-12" );
	goto label$17;
	label$17:;
	return tmp$16$1;
}

void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN12LETVARIABLESEv( void )
{
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE TMP$20$1;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* TMP$21$1;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE TMP$35$1;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* TMP$36$1;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE TMP$43$1;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* TMP$44$1;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE TMP$48$1;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* TMP$49$1;
	label$18:;
	int64 FOO$1;
	__builtin_memset( &FOO$1, 0, 8ll );
	int64 BAR$1;
	__builtin_memset( &BAR$1, 0, 8ll );
	FBSTRING BAZ$1;
	__builtin_memset( &BAZ$1, 0, 24ll );
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC1Ev( &TMP$20$1 );
	TMP$21$1 = &TMP$20$1;
	FOO$1 = (int64)*(int16*)TMP$21$1;
	BAR$1 = (int64)*(int16*)((uint8*)TMP$21$1 + 2ll);
	fb_StrAssign( (void*)&BAZ$1, -1ll, (void*)((uint8*)TMP$21$1 + 8ll), -1ll, 0 );
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETD1Ev( &TMP$20$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(FOO$1 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 45, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(foo = 1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(BAR$1 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 46, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(bar = 2)" );
	int32 vr$18 = fb_StrCompare( (void*)&BAZ$1, -1ll, (void*)"3", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$18 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 47, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(baz = \x22" "3\x22)" );
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC2Ev( &TMP$35$1 );
	TMP$36$1 = &TMP$35$1;
	FOO$1 = (int64)*(int16*)TMP$36$1;
	fb_StrAssign( (void*)&BAZ$1, -1ll, (void*)((uint8*)TMP$36$1 + 8ll), -1ll, 0 );
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETD1Ev( &TMP$35$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(FOO$1 == -1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 50, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(foo = -1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(BAR$1 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 51, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(bar = 2)" );
	int32 vr$35 = fb_StrCompare( (void*)&BAZ$1, -1ll, (void*)"-3", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$35 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 52, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(baz = \x22-3\x22)" );
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC3Ev( &TMP$43$1 );
	TMP$44$1 = &TMP$43$1;
	FOO$1 = (int64)*(int16*)TMP$44$1;
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETD1Ev( &TMP$43$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(FOO$1 == 10ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 55, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(foo = 10)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(BAR$1 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 56, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(bar = 2)" );
	int32 vr$49 = fb_StrCompare( (void*)&BAZ$1, -1ll, (void*)"-3", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$49 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 57, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(baz = \x22-3\x22)" );
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5FUNC4Ev( &TMP$48$1 );
	TMP$49$1 = &TMP$48$1;
	fb_StrAssign( (void*)&BAZ$1, -1ll, (void*)((uint8*)TMP$49$1 + 8ll), -1ll, 0 );
	_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETD1Ev( &TMP$48$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(FOO$1 == 10ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 60, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(foo = 10)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(BAR$1 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 61, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(bar = 2)" );
	int32 vr$64 = fb_StrCompare( (void*)&BAZ$1, -1ll, (void*)"-12", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$64 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 62, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(baz = \x22-12\x22)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN8DTORCNT$E == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 64, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETVARIABLES", (char*)"CU_ASSERT(dtorcnt = 4)" );
	fb_StrDelete( (FBSTRING*)&BAZ$1 );
	label$19:;
}

void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN14LETARRAYACCESSEv( void )
{
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E {
		double A;
		double B;
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E ) == 16 );
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E* TMP$60$1;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E TMP$61$1;
	label$22:;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E Z$1[1];
	__builtin_memset( (struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E*)Z$1, 0, 16ll );
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN10FBARRAY1$3INS2_5BAZ$4EEE {
		struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E* DATA;
		struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN10FBARRAY1$3INS2_5BAZ$4EEE ) == 72 );
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN10FBARRAY1$3INS2_5BAZ$4EEE tmp$58$1;
	*(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E**)&tmp$58$1 = (struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E*)Z$1;
	*(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E**)((uint8*)&tmp$58$1 + 8ll) = (struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E*)Z$1;
	*(int64*)((uint8*)&tmp$58$1 + 16ll) = 16ll;
	*(int64*)((uint8*)&tmp$58$1 + 24ll) = 16ll;
	*(int64*)((uint8*)&tmp$58$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$58$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$58$1 + 48ll) = 1ll;
	*(int64*)((uint8*)&tmp$58$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$58$1 + 64ll) = 0ll;
	int64 I$1;
	I$1 = 0ll;
	*(double*)&TMP$61$1 = -0x1.p+0;
	*(double*)((uint8*)&TMP$61$1 + 8ll) = -0x1.p+1;
	TMP$60$1 = &TMP$61$1;
	*(double*)((int64)(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E*)Z$1 + (I$1 << (4ll & 63ll))) = *(double*)TMP$60$1;
	*(double*)(((int64)(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E*)Z$1 + (I$1 << (4ll & 63ll))) + 8ll) = *(double*)((uint8*)TMP$60$1 + 8ll);
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((int64)(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E*)Z$1 + (I$1 << (4ll & 63ll))) == -0x1.p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 77, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETARRAYACCESS", (char*)"CU_ASSERT_EQUAL(z(i).a,-1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)(((int64)(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$2E*)Z$1 + (I$1 << (4ll & 63ll))) + 8ll) == -0x1.p+1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 78, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETARRAYACCESS", (char*)"CU_ASSERT_EQUAL(z(i).b,-2)" );
	label$23:;
}

void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN12LETUDTFIELDSEv( void )
{
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E {
		int16 A;
		int16 B;
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E ) == 4 );
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E* TMP$80$1;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E* TMP$94$1;
	label$26:;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E Z$1[1];
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN10FBARRAY1$7INS2_5BAZ$8EEE {
		struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E* DATA;
		struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN10FBARRAY1$7INS2_5BAZ$8EEE ) == 72 );
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN10FBARRAY1$7INS2_5BAZ$8EEE tmp$79$1;
	*(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E**)&tmp$79$1 = (struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E*)Z$1;
	*(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E**)((uint8*)&tmp$79$1 + 8ll) = (struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E*)Z$1;
	*(int64*)((uint8*)&tmp$79$1 + 16ll) = 4ll;
	*(int64*)((uint8*)&tmp$79$1 + 24ll) = 4ll;
	*(int64*)((uint8*)&tmp$79$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$79$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$79$1 + 48ll) = 1ll;
	*(int64*)((uint8*)&tmp$79$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$79$1 + 64ll) = 0ll;
	*(int16*)Z$1 = (int16)-1234;
	*(int16*)((int64)(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E*)Z$1 + 2ll) = (int16)-5678;
	int64 FOO$1;
	__builtin_memset( &FOO$1, 0, 8ll );
	int64 BAR$1;
	__builtin_memset( &BAR$1, 0, 8ll );
	int64 I$1;
	I$1 = 0ll;
	TMP$80$1 = (struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E*)((int64)(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E*)Z$1 + (I$1 << (2ll & 63ll)));
	FOO$1 = (int64)*(int16*)TMP$80$1;
	BAR$1 = (int64)*(int16*)((uint8*)TMP$80$1 + 2ll);
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(FOO$1 == -1234ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 91, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETUDTFIELDS", (char*)"CU_ASSERT_EQUAL(foo,-1234)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(BAR$1 == -5678ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 92, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETUDTFIELDS", (char*)"CU_ASSERT_EQUAL(bar,-5678)" );
	*(int16*)Z$1 = (int16)1234;
	*(int16*)((int64)(struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E*)Z$1 + 2ll) = (int16)5678;
	struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E* P$1;
	P$1 = (struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN5BAZ$6E*)Z$1;
	TMP$94$1 = P$1;
	FOO$1 = (int64)*(int16*)TMP$94$1;
	BAR$1 = (int64)*(int16*)((uint8*)TMP$94$1 + 2ll);
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(FOO$1 == 1234ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 101, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETUDTFIELDS", (char*)"CU_ASSERT_EQUAL(foo,1234)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(BAR$1 == 5678ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "expressions\x5Cmult-assign.bas", 102, (char*)"TESTS.FBC_TESTS.EXPRESSIONS.MULT_ASSIGN.LETUDTFIELDS", (char*)"CU_ASSERT_EQUAL(bar,5678)" );
	label$27:;
}

__attribute__(( constructor )) static void fb_ctor__multzassign( void )
{
	label$0:;
	label$1:;
}

static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETaSERKS3_( struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* THIS$1, struct $N5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN7TRIPLETE* __FB_RHS__$1 )
{
	label$2:;
	*(int16*)THIS$1 = *(int16*)__FB_RHS__$1;
	*(int16*)((uint8*)THIS$1 + 2ll) = *(int16*)((uint8*)__FB_RHS__$1 + 2ll);
	fb_StrAssign( (void*)((uint8*)THIS$1 + 8ll), -1ll, (void*)((uint8*)__FB_RHS__$1 + 8ll), -1ll, 0 );
	label$3:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN17LETVARIABLES_CTOREv( void )
{
	label$20:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.expressions.mult_assign", (char*)"letVariables", (tmp$5)&_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN12LETVARIABLESEv, (boolean)0ll );
	label$21:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN19LETARRAYACCESS_CTOREv( void )
{
	label$24:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.expressions.mult_assign", (char*)"letArrayAccess", (tmp$5)&_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN14LETARRAYACCESSEv, (boolean)0ll );
	label$25:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN17LETUDTFIELDS_CTOREv( void )
{
	label$28:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.expressions.mult_assign", (char*)"letUdtFields", (tmp$5)&_ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN12LETUDTFIELDSEv, (boolean)0ll );
	label$29:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11EXPRESSIONS11MULT_ASSIGN13SUITE_CTOR105Ev( void )
{
	label$30:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.expressions.mult_assign", (tmp$4)0ull, (tmp$4)0ull );
	label$31:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
