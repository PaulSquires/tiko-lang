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
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
#define fb_D2L( value ) ((int64)__builtin_nearbyint( value ))
FBSTRING* fb_StrInit( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
static void fb_ctor__anonzintrinsic( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
int64 _ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC8TESTPROCEv( void );
void _ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC3ALLEv( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC8ALL_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC13SUITE_CTOR111Ev( void ) __attribute__(( constructor ));

int64 _ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC8TESTPROCEv( void )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2:;
	fb$result$1 = 123ll;
	label$3:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC3ALLEv( void )
{
	label$4:;
	{
		int64 I$2;
		I$2 = 2ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(I$2 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 12, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(i = cint( 1.5 ))" );
	}
	{
		int64 I$2;
		I$2 = 3ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(I$2 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 17, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(i = 3)" );
	}
	{
		int64 TMP$22$2;
		int64 TMP$27$2;
		float TMP$32$2;
		float TMP$37$2;
		double TMP$39$2;
		double TMP$44$2;
		int64 TMP$46$2;
		double TMP$51$2;
		int64 TMP$53$2;
		int64 TMP$58$2;
		int64 I$2;
		__builtin_memset( &I$2, 0, 8ll );
		double D$2;
		__builtin_memset( &D$2, 0, 8ll );
		float F$2;
		__builtin_memset( &F$2, 0, 4ll );
		TMP$22$2 = 123ll;
		I$2 = TMP$22$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(I$2 == 123ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 26, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(i = 123)" );
		TMP$27$2 = 456ll;
		I$2 = TMP$27$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(I$2 == 456ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 29, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(i = 456)" );
		TMP$32$2 = 0x1.8p+0f;
		F$2 = TMP$32$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((double)F$2 == 0x1.8p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 32, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(f = 1.5)" );
		TMP$37$2 = 0x1.8p+0f;
		F$2 = TMP$37$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((double)F$2 == 0x1.8p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 35, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(f = 1.5)" );
		TMP$39$2 = 0x1.8p+0;
		D$2 = TMP$39$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(D$2 == 0x1.8p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 38, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(d = 1.5)" );
		TMP$44$2 = 0x1.8p+0;
		D$2 = TMP$44$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(D$2 == 0x1.8p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 41, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(d = 1.5)" );
		TMP$46$2 = 1ll;
		I$2 = TMP$46$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(I$2 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 45, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(i = 1)" );
		TMP$51$2 = 0x1.199999999999Ap+0;
		I$2 = fb_D2L( TMP$51$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(I$2 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 49, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(i = 1)" );
		TMP$53$2 = 123ll;
		D$2 = (double)TMP$53$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(D$2 == 0x1.ECp+6) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 53, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(d = 123)" );
		TMP$58$2 = 1ll;
		D$2 = (double)TMP$58$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(D$2 == 0x1.p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 56, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(d = 1)" );
	}
	{
		typedef int64 $N5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC3E$1E;
		$N5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC3E$1E TMP$63$2;
		$N5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC3E$1E TMP$68$2;
		$N5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC3E$1E I$2;
		I$2 = 1ll;
		TMP$63$2 = 2ll;
		I$2 = TMP$63$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(I$2 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 68, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(i = B)" );
		I$2 = 1ll;
		TMP$68$2 = 2ll;
		I$2 = TMP$68$2;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(I$2 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 72, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(i = B)" );
	}
	{
		typedef void (*_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$69Ev)( void );
		_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$69Ev TMP$71$2;
		_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$69Ev TMP$73$2;
		typedef int64 (*_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$74Ev)( void );
		_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$74Ev TMP$76$2;
		_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$74Ev TMP$81$2;
		_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$69Ev P1$2;
		__builtin_memset( &P1$2, 0, 8ll );
		TMP$71$2 = (_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$69Ev)0ull;
		P1$2 = TMP$71$2;
		TMP$73$2 = (_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$69Ev)0ull;
		P1$2 = TMP$73$2;
		_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$74Ev P2$2;
		__builtin_memset( &P2$2, 0, 8ll );
		TMP$76$2 = (_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$74Ev)&_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC8TESTPROCEv;
		P2$2 = TMP$76$2;
		int64 vr$38 = (P2$2)(  );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$38 == 123ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 82, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(p2( ) = 123)" );
		TMP$81$2 = (_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC6tmp$74Ev)&_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC8TESTPROCEv;
		P2$2 = TMP$81$2;
		int64 vr$41 = (P2$2)(  );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$41 == 123ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 84, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(p2( ) = 123)" );
	}
	{
		FBSTRING TMP$87$2;
		FBSTRING TMP$91$2;
		FBSTRING TMP$95$2;
		FBSTRING TMP$99$2;
		FBSTRING TMP$103$2;
		FBSTRING TMP$106$2;
		FBSTRING TMP$107$2;
		FBSTRING TMP$111$2;
		FBSTRING TMP$116$2;
		FBSTRING TMP$118$2;
		FBSTRING TMP$122$2;
		FBSTRING TMP$124$2;
		FBSTRING TMP$128$2;
		FBSTRING TMP$130$2;
		FBSTRING TMP$131$2;
		FBSTRING TMP$135$2;
		FBSTRING TMP$141$2;
		FBSTRING TMP$145$2;
		FBSTRING TMP$148$2;
		FBSTRING TMP$152$2;
		FBSTRING TMP$155$2;
		FBSTRING TMP$156$2;
		FBSTRING TMP$160$2;
		FBSTRING TMP$162$2;
		FBSTRING TMP$166$2;
		FBSTRING TMP$168$2;
		FBSTRING TMP$172$2;
		FBSTRING TMP$174$2;
		FBSTRING TMP$175$2;
		FBSTRING TMP$179$2;
		FBSTRING S$2;
		fb_StrInit( (void*)&S$2, -1ll, (void*)"abc", 4ll, 0 );
		fb_StrInit( (void*)&TMP$87$2, -1ll, (void*)"abc", 4ll, 0 );
		int32 vr$47 = fb_StrCompare( (void*)&TMP$87$2, -1ll, (void*)"abc", 4ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$47 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 91, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT((type<string>( \x22" "abc\x22 ))       = \x22" "abc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$87$2 );
		fb_StrInit( (void*)&TMP$95$2, -1ll, (void*)"abc", 4ll, 0 );
		__builtin_memset( &TMP$91$2, 0, 24ll );
		FBSTRING* vr$56 = fb_StrConcat( &TMP$91$2, (void*)"a", 2ll, (void*)&TMP$95$2, -1ll );
		int32 vr$57 = fb_StrCompare( (void*)vr$56, -1ll, (void*)"aabc", 5ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$57 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 92, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(\x22" "a\x22 + (type<string>( \x22" "abc\x22 ))       = \x22" "aabc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$95$2 );
		fb_StrInit( (void*)&TMP$103$2, -1ll, (void*)"abc", 4ll, 0 );
		__builtin_memset( &TMP$99$2, 0, 24ll );
		FBSTRING* vr$66 = fb_StrConcat( &TMP$99$2, (void*)&TMP$103$2, -1ll, (void*)"c", 2ll );
		int32 vr$67 = fb_StrCompare( (void*)vr$66, -1ll, (void*)"abcc", 5ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$67 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 93, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT((type<string>( \x22" "abc\x22 )) + \x22" "c\x22 = \x22" "abcc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$103$2 );
		fb_StrInit( (void*)&TMP$111$2, -1ll, (void*)"abc", 4ll, 0 );
		__builtin_memset( &TMP$106$2, 0, 24ll );
		FBSTRING* vr$76 = fb_StrConcat( &TMP$106$2, (void*)"a", 2ll, (void*)&TMP$111$2, -1ll );
		__builtin_memset( &TMP$107$2, 0, 24ll );
		FBSTRING* vr$79 = fb_StrConcat( &TMP$107$2, (void*)vr$76, -1ll, (void*)"c", 2ll );
		int32 vr$80 = fb_StrCompare( (void*)vr$79, -1ll, (void*)"aabcc", 6ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$80 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 94, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(\x22" "a\x22 + (type<string>( \x22" "abc\x22 )) + \x22" "c\x22 = \x22" "aabcc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$111$2 );
		fb_StrInit( (void*)&TMP$116$2, -1ll, (void*)&S$2, -1ll, 0 );
		int32 vr$88 = fb_StrCompare( (void*)&TMP$116$2, -1ll, (void*)"abc", 4ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$88 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 95, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT((type<string>( s     ))       = \x22" "abc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$116$2 );
		fb_StrInit( (void*)&TMP$122$2, -1ll, (void*)&S$2, -1ll, 0 );
		__builtin_memset( &TMP$118$2, 0, 24ll );
		FBSTRING* vr$98 = fb_StrConcat( &TMP$118$2, (void*)"a", 2ll, (void*)&TMP$122$2, -1ll );
		int32 vr$99 = fb_StrCompare( (void*)vr$98, -1ll, (void*)"aabc", 5ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$99 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 96, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(\x22" "a\x22 + (type<string>( s     ))       = \x22" "aabc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$122$2 );
		fb_StrInit( (void*)&TMP$128$2, -1ll, (void*)&S$2, -1ll, 0 );
		__builtin_memset( &TMP$124$2, 0, 24ll );
		FBSTRING* vr$109 = fb_StrConcat( &TMP$124$2, (void*)&TMP$128$2, -1ll, (void*)"c", 2ll );
		int32 vr$110 = fb_StrCompare( (void*)vr$109, -1ll, (void*)"abcc", 5ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$110 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 97, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT((type<string>( s     )) + \x22" "c\x22 = \x22" "abcc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$128$2 );
		fb_StrInit( (void*)&TMP$135$2, -1ll, (void*)&S$2, -1ll, 0 );
		__builtin_memset( &TMP$130$2, 0, 24ll );
		FBSTRING* vr$120 = fb_StrConcat( &TMP$130$2, (void*)"a", 2ll, (void*)&TMP$135$2, -1ll );
		__builtin_memset( &TMP$131$2, 0, 24ll );
		FBSTRING* vr$123 = fb_StrConcat( &TMP$131$2, (void*)vr$120, -1ll, (void*)"c", 2ll );
		int32 vr$124 = fb_StrCompare( (void*)vr$123, -1ll, (void*)"aabcc", 6ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$124 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 98, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(\x22" "a\x22 + (type<string>( s     )) + \x22" "c\x22 = \x22" "aabcc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$135$2 );
		FBSTRING A$2;
		fb_StrInit( (void*)&A$2, -1ll, (void*)"aaa", 4ll, 0 );
		FBSTRING B$2;
		fb_StrInit( (void*)&B$2, -1ll, (void*)"bbb", 4ll, 0 );
		FBSTRING C$2;
		fb_StrInit( (void*)&C$2, -1ll, (void*)"ccc", 4ll, 0 );
		fb_StrInit( (void*)&TMP$145$2, -1ll, (void*)"bbb", 4ll, 0 );
		__builtin_memset( &TMP$141$2, 0, 24ll );
		FBSTRING* vr$137 = fb_StrConcat( &TMP$141$2, (void*)&A$2, -1ll, (void*)&TMP$145$2, -1ll );
		int32 vr$138 = fb_StrCompare( (void*)vr$137, -1ll, (void*)"aaabbb", 7ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$138 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 101, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(a + (type<string>( \x22" "bbb\x22 ))     = \x22" "aaabbb\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$145$2 );
		fb_StrInit( (void*)&TMP$152$2, -1ll, (void*)"bbb", 4ll, 0 );
		__builtin_memset( &TMP$148$2, 0, 24ll );
		FBSTRING* vr$148 = fb_StrConcat( &TMP$148$2, (void*)&TMP$152$2, -1ll, (void*)&C$2, -1ll );
		int32 vr$149 = fb_StrCompare( (void*)vr$148, -1ll, (void*)"bbbccc", 7ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$149 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 102, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT((type<string>( \x22" "bbb\x22 )) + c = \x22" "bbbccc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$152$2 );
		fb_StrInit( (void*)&TMP$160$2, -1ll, (void*)"bbb", 4ll, 0 );
		__builtin_memset( &TMP$155$2, 0, 24ll );
		FBSTRING* vr$160 = fb_StrConcat( &TMP$155$2, (void*)&A$2, -1ll, (void*)&TMP$160$2, -1ll );
		__builtin_memset( &TMP$156$2, 0, 24ll );
		FBSTRING* vr$163 = fb_StrConcat( &TMP$156$2, (void*)vr$160, -1ll, (void*)&C$2, -1ll );
		int32 vr$164 = fb_StrCompare( (void*)vr$163, -1ll, (void*)"aaabbbccc", 10ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$164 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 103, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(a + (type<string>( \x22" "bbb\x22 )) + c = \x22" "aaabbbccc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$160$2 );
		fb_StrInit( (void*)&TMP$166$2, -1ll, (void*)&B$2, -1ll, 0 );
		__builtin_memset( &TMP$162$2, 0, 24ll );
		FBSTRING* vr$175 = fb_StrConcat( &TMP$162$2, (void*)&A$2, -1ll, (void*)&TMP$166$2, -1ll );
		int32 vr$176 = fb_StrCompare( (void*)vr$175, -1ll, (void*)"aaabbb", 7ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$176 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 104, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(a + (type<string>( b     ))     = \x22" "aaabbb\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$166$2 );
		fb_StrInit( (void*)&TMP$172$2, -1ll, (void*)&B$2, -1ll, 0 );
		__builtin_memset( &TMP$168$2, 0, 24ll );
		FBSTRING* vr$187 = fb_StrConcat( &TMP$168$2, (void*)&TMP$172$2, -1ll, (void*)&C$2, -1ll );
		int32 vr$188 = fb_StrCompare( (void*)vr$187, -1ll, (void*)"bbbccc", 7ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$188 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 105, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT((type<string>( b     )) + c = \x22" "bbbccc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$172$2 );
		fb_StrInit( (void*)&TMP$179$2, -1ll, (void*)&B$2, -1ll, 0 );
		__builtin_memset( &TMP$174$2, 0, 24ll );
		FBSTRING* vr$200 = fb_StrConcat( &TMP$174$2, (void*)&A$2, -1ll, (void*)&TMP$179$2, -1ll );
		__builtin_memset( &TMP$175$2, 0, 24ll );
		FBSTRING* vr$203 = fb_StrConcat( &TMP$175$2, (void*)vr$200, -1ll, (void*)&C$2, -1ll );
		int32 vr$204 = fb_StrCompare( (void*)vr$203, -1ll, (void*)"aaabbbccc", 10ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$204 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "anon-intrinsic.bas", 106, (char*)"TESTS.FBC_TESTS.STRUCTS.ANON_INTRINSIC.ALL", (char*)"CU_ASSERT(a + (type<string>( b     )) + c = \x22" "aaabbbccc\x22)" );
		fb_StrDelete( (FBSTRING*)&TMP$179$2 );
		fb_StrDelete( (FBSTRING*)&C$2 );
		fb_StrDelete( (FBSTRING*)&B$2 );
		fb_StrDelete( (FBSTRING*)&A$2 );
		fb_StrDelete( (FBSTRING*)&S$2 );
	}
	label$5:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC8ALL_CTOREv( void )
{
	label$6:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.anon_intrinsic", (char*)"all", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC3ALLEv, (boolean)0ll );
	label$7:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS14ANON_INTRINSIC13SUITE_CTOR111Ev( void )
{
	label$8:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.structs.anon_intrinsic", (tmp$4)0ull, (tmp$4)0ull );
	label$9:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
