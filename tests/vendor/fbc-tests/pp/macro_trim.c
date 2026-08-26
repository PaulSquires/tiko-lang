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
static void fb_ctor__macro_trim( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM9NOARGTESTEv( void );
static void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM14NOARGTEST_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM11WITHARGTESTEv( void );
static void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM16WITHARGTEST_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM12SUITE_CTOR47Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM9NOARGTESTEv( void )
{
	label$2:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cpp\x5Cmacro_trim.bas", 37, (char*)"TESTS.FBC_TESTS.PP.MACRO_TRIM.NOARGTEST", (char*)"CU_ASSERT_EQUAL(\x22hello\x22 + \x22world!\x22,\x22helloworld!\x22)" );
	label$3:;
}

void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM11WITHARGTESTEv( void )
{
	label$6:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cpp\x5Cmacro_trim.bas", 43, (char*)"TESTS.FBC_TESTS.PP.MACRO_TRIM.WITHARGTEST", (char*)"CU_ASSERT_EQUAL(\x22hello\x22 + \x22world!\x22,\x22helloworld!\x22)" );
	label$7:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM14NOARGTEST_CTOREv( void )
{
	label$4:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.pp.macro_trim", (char*)"noArgTest", (tmp$5)&_ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM9NOARGTESTEv, (boolean)0ll );
	label$5:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM16WITHARGTEST_CTOREv( void )
{
	label$8:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.pp.macro_trim", (char*)"withArgTest", (tmp$5)&_ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM11WITHARGTESTEv, (boolean)0ll );
	label$9:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS2PP10MACRO_TRIM12SUITE_CTOR47Ev( void )
{
	label$10:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.pp.macro_trim", (tmp$4)0ull, (tmp$4)0ull );
	label$11:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
