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
static void fb_ctor__selfzbop( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP3ALLEv( void );
static void _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP8ALL_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP12SUITE_CTOR54Ev( void ) __attribute__(( constructor ));
static int64 _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E;

void _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP3ALLEv( void )
{
	label$2:;
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ll;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 9, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 1)" );
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ll;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 18, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 2)" );
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ll;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 21, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 3)" );
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = (uint64)(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ll);
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 24, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 4)" );
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ll;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 5ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 31, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 5)" );
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = (int64)((uint64)_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ull);
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 6ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 34, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 6)" );
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = 255ll;
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = (int64)(int8)(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ll);
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 39, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 0)" );
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = 255ll;
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = (int64)(uint8)(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ll);
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 43, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 0)" );
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = 256ll;
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = (int64)(int8)(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ll);
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 47, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 1)" );
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = 256ll;
	_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E = (int64)(int8)_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E + 1ll;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP2I$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Coptimizations\x5Cself-bop.bas", 51, (char*)"TESTS.FBC_TESTS.OPTIMIZATIONS.SELF_BOP.ALL", (char*)"CU_ASSERT(i = 1)" );
	label$3:;
}

__attribute__(( constructor )) static void fb_ctor__selfzbop( void )
{
	label$0:;
	label$1:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP8ALL_CTOREv( void )
{
	label$4:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.optimizations.self_bop", (char*)"all", (tmp$5)&_ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP3ALLEv, (boolean)0ll );
	label$5:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS13OPTIMIZATIONS8SELF_BOP12SUITE_CTOR54Ev( void )
{
	label$6:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.optimizations.self_bop", (tmp$4)0ull, (tmp$4)0ull );
	label$7:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
