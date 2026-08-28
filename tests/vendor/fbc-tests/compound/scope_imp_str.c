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
FBSTRING* fb_StrInit( void*, int64, void*, int64, int32 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_StrConcatAssign( void*, int64, void*, int64, int32 );
static void fb_ctor__scope_imp_str( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR12TEST_ZSTRINGEv( void );
static void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR17TEST_ZSTRING_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR11TEST_STRINGEv( void );
static void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR16TEST_STRING_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR12SUITE_CTOR38Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR12TEST_ZSTRINGEv( void )
{
	label$2:;
	char* ZS1$1;
	ZS1$1 = (char*)"foobar";
	char* ZS2$1;
	ZS2$1 = (char*)"1234";
	FBSTRING RES$1;
	__builtin_memset( &RES$1, 0, 24ll );
	{
		FBSTRING TMP$10$2;
		__builtin_memset( &TMP$10$2, 0, 24ll );
		FBSTRING* vr$3 = fb_StrConcat( &TMP$10$2, (void*)ZS1$1, 0ll, (void*)ZS2$1, 0ll );
		fb_StrAssign( (void*)&RES$1, -1ll, (void*)vr$3, -1ll, 0 );
	}
	label$5:;
	label$4:;
	int32 vr$6 = fb_StrCompare( (void*)&RES$1, -1ll, (void*)"foobar1234", 11ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$6 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "compound\x5Cscope_imp_str.bas", 19, (char*)"TESTS.FBC_TESTS.COMPOUND.SCOPE_IMP_STR.TEST_ZSTRING", (char*)"CU_ASSERT(res = TEST_STR1 + TEST_STR2)" );
	fb_StrDelete( (FBSTRING*)&RES$1 );
	label$3:;
}

void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR11TEST_STRINGEv( void )
{
	label$8:;
	FBSTRING S1$1;
	fb_StrInit( (void*)&S1$1, -1ll, (void*)"foobar", 7ll, 0 );
	FBSTRING S2$1;
	fb_StrInit( (void*)&S2$1, -1ll, (void*)"1234", 5ll, 0 );
	FBSTRING RES$1;
	__builtin_memset( &RES$1, 0, 24ll );
	{
		fb_StrAssign( (void*)&RES$1, -1ll, (void*)&S1$1, -1ll, 0 );
		fb_StrConcatAssign( (void*)&RES$1, -1ll, (void*)&S2$1, -1ll, 0 );
	}
	label$11:;
	label$10:;
	int32 vr$8 = fb_StrCompare( (void*)&RES$1, -1ll, (void*)"foobar1234", 11ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$8 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "compound\x5Cscope_imp_str.bas", 34, (char*)"TESTS.FBC_TESTS.COMPOUND.SCOPE_IMP_STR.TEST_STRING", (char*)"CU_ASSERT(res = TEST_STR1 + TEST_STR2)" );
	fb_StrDelete( (FBSTRING*)&RES$1 );
	fb_StrDelete( (FBSTRING*)&S2$1 );
	fb_StrDelete( (FBSTRING*)&S1$1 );
	label$9:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR17TEST_ZSTRING_CTOREv( void )
{
	label$6:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.compound.scope_imp_str", (char*)"test_zstring", (tmp$5)&_ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR12TEST_ZSTRINGEv, (boolean)0ll );
	label$7:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR16TEST_STRING_CTOREv( void )
{
	label$12:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.compound.scope_imp_str", (char*)"test_string", (tmp$5)&_ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR11TEST_STRINGEv, (boolean)0ll );
	label$13:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8COMPOUND13SCOPE_IMP_STR12SUITE_CTOR38Ev( void )
{
	label$14:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.compound.scope_imp_str", (tmp$4)0ull, (tmp$4)0ull );
	label$15:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
