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
uint16* fb_WstrAssign( uint16*, int64, uint16* );
void fb_WstrDelete( uint16* );
uint16* fb_WstrConcat( uint16*, uint16* );
int32 fb_WstrCompare( uint16*, uint16* );
int64 fb_WstrLen( uint16* );
uint32 fb_WstrAsc( uint16*, int64 );
uint16* fb_WstrChr( int32, ... );
static void fb_ctor__wchr( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_8RUN_TESTEPwS3_( uint16*, uint16* );
void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_12MAXIMUM_ARGSEv( void );
static void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_17MAXIMUM_ARGS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_15HIGH_CODEPOINTSEv( void );
static void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_20HIGH_CODEPOINTS_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_13SUITE_CTOR126Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_7DEFAULTEv( void )
{
	label$2:;
	uint16 S$1[32];
	__builtin_memset( (uint16*)S$1, 0, 64ll );
	uint16* PS$1;
	__builtin_memset( &PS$1, 0, 8ll );
	fb_WstrAssign( (uint16*)S$1, 32ll, (uint16*)L"ABC" );
	_ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_8RUN_TESTEPwS3_( (uint16*)S$1, (uint16*)L"ABC" );
	fb_WstrAssign( (uint16*)S$1, 32ll, (uint16*)L"\x0100\x0101\x0102" );
	_ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_8RUN_TESTEPwS3_( (uint16*)S$1, (uint16*)L"\x0100\x0101\x0102" );
	label$3:;
}

void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_8RUN_TESTEPwS3_( uint16* S1$1, uint16* S2$1 )
{
	label$6:;
	int64 vr$0 = fb_WstrLen( (uint16*)S1$1 );
	int64 vr$1 = fb_WstrLen( (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$0 == vr$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cwstring\x5Cwchr.bas", 25, (char*)"TESTS.FBC_TESTS.WSTRING_.WCHR_.RUN_TEST", (char*)"CU_ASSERT(len( *s1 ) = len( *s2 ))" );
	int32 vr$4 = fb_WstrCompare( (uint16*)S1$1, (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$4 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cwstring\x5Cwchr.bas", 27, (char*)"TESTS.FBC_TESTS.WSTRING_.WCHR_.RUN_TEST", (char*)"CU_ASSERT(*s1 = *s2)" );
	label$7:;
}

void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_12MAXIMUM_ARGSEv( void )
{
	label$8:;
	uint16 CONST_WSTR_LONG$1[33];
	fb_WstrAssign( (uint16*)CONST_WSTR_LONG$1, 33ll, (uint16*)L"0123456789:;<=>?@ABCDEFGHIJKLMNO" );
	int32 vr$2 = fb_WstrCompare( (uint16*)CONST_WSTR_LONG$1, (uint16*)L"0123456789:;<=>?@ABCDEFGHIJKLMNO" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$2 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cwstring\x5Cwchr.bas", 38, (char*)"TESTS.FBC_TESTS.WSTRING_.WCHR_.MAXIMUM_ARGS", (char*)"CU_ASSERT_EQUAL(const_wstr_long,\x22" "0123456789:;<=>?@ABCDEFGHIJKLMNO\x22)" );
	{
		uint16* TMP$38$2;
		uint16* TMP$39$2;
		uint16* TMP$40$2;
		uint16* TMP$41$2;
		uint16* TMP$42$2;
		uint16 CONST_WSTR_LONG$2[33];
		fb_WstrAssign( (uint16*)CONST_WSTR_LONG$2, 33ll, (uint16*)L"\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF\xFFFF" );
		uint16 CORRECT$2[33];
		__builtin_memset( (uint16*)CORRECT$2, 0, 66ll );
		*(uint16*)CORRECT$2 = (uint16)65535u;
		uint16* vr$10 = fb_WstrConcat( (uint16*)CORRECT$2, (uint16*)CORRECT$2 );
		TMP$38$2 = vr$10;
		fb_WstrAssign( (uint16*)CORRECT$2, 33ll, (uint16*)TMP$38$2 );
		fb_WstrDelete( (uint16*)TMP$38$2 );
		uint16* vr$14 = fb_WstrConcat( (uint16*)CORRECT$2, (uint16*)CORRECT$2 );
		TMP$39$2 = vr$14;
		fb_WstrAssign( (uint16*)CORRECT$2, 33ll, (uint16*)TMP$39$2 );
		fb_WstrDelete( (uint16*)TMP$39$2 );
		uint16* vr$18 = fb_WstrConcat( (uint16*)CORRECT$2, (uint16*)CORRECT$2 );
		TMP$40$2 = vr$18;
		fb_WstrAssign( (uint16*)CORRECT$2, 33ll, (uint16*)TMP$40$2 );
		fb_WstrDelete( (uint16*)TMP$40$2 );
		uint16* vr$22 = fb_WstrConcat( (uint16*)CORRECT$2, (uint16*)CORRECT$2 );
		TMP$41$2 = vr$22;
		fb_WstrAssign( (uint16*)CORRECT$2, 33ll, (uint16*)TMP$41$2 );
		fb_WstrDelete( (uint16*)TMP$41$2 );
		uint16* vr$26 = fb_WstrConcat( (uint16*)CORRECT$2, (uint16*)CORRECT$2 );
		TMP$42$2 = vr$26;
		fb_WstrAssign( (uint16*)CORRECT$2, 33ll, (uint16*)TMP$42$2 );
		fb_WstrDelete( (uint16*)TMP$42$2 );
		int32 vr$30 = fb_WstrCompare( (uint16*)CONST_WSTR_LONG$2, (uint16*)CORRECT$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$30 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cwstring\x5Cwchr.bas", 60, (char*)"TESTS.FBC_TESTS.WSTRING_.WCHR_.MAXIMUM_ARGS", (char*)"CU_ASSERT_EQUAL(const_wstr_long,correct)" );
	}
	label$9:;
}

void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_15HIGH_CODEPOINTSEv( void )
{
	uint16* TMP$56$1;
	uint16* TMP$60$1;
	label$12:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cwstring\x5Cwchr.bas", 93, (char*)"TESTS.FBC_TESTS.WSTRING_.WCHR_.HIGH_CODEPOINTS", (char*)"CU_ASSERT(asc( wchr( &hffff ) ) = &hffff)" );
	uint16 WS1$1[3];
	fb_WstrAssign( (uint16*)WS1$1, 3ll, (uint16*)L"\xFFFF" );
	uint32 vr$2 = fb_WstrAsc( (uint16*)WS1$1, 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$2 == 65535ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cwstring\x5Cwchr.bas", 96, (char*)"TESTS.FBC_TESTS.WSTRING_.WCHR_.HIGH_CODEPOINTS", (char*)"CU_ASSERT(asc( ws1 ) = &hffff)" );
	int64 TEMP$1;
	__builtin_memset( &TEMP$1, 0, 8ll );
	TEMP$1 = 65535ll;
	uint16* vr$7 = fb_WstrChr( 1, TEMP$1 );
	TMP$56$1 = vr$7;
	int32 vr$8 = fb_WstrCompare( (uint16*)TMP$56$1, (uint16*)L"\xFFFF" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$8 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cwstring\x5Cwchr.bas", 114, (char*)"TESTS.FBC_TESTS.WSTRING_.WCHR_.HIGH_CODEPOINTS", (char*)"CU_ASSERT(wchr( temp ) = !\x22\x5Cuffff\x22)" );
	fb_WstrDelete( (uint16*)TMP$56$1 );
	uint16* vr$12 = fb_WstrChr( 1, TEMP$1 );
	TMP$60$1 = vr$12;
	uint32 vr$13 = fb_WstrAsc( (uint16*)TMP$60$1, 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$13 == 65535ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cwstring\x5Cwchr.bas", 115, (char*)"TESTS.FBC_TESTS.WSTRING_.WCHR_.HIGH_CODEPOINTS", (char*)"CU_ASSERT(asc( wchr( temp ) ) = &hffff)" );
	fb_WstrDelete( (uint16*)TMP$60$1 );
	label$13:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_12DEFAULT_CTOREv( void )
{
	label$4:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.wstring_.wchr_", (char*)"default", (tmp$5)&_ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_7DEFAULTEv, (boolean)0ll );
	label$5:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_17MAXIMUM_ARGS_CTOREv( void )
{
	label$10:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.wstring_.wchr_", (char*)"maximum_args", (tmp$5)&_ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_12MAXIMUM_ARGSEv, (boolean)0ll );
	label$11:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_20HIGH_CODEPOINTS_CTOREv( void )
{
	label$14:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.wstring_.wchr_", (char*)"high_codepoints", (tmp$5)&_ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_15HIGH_CODEPOINTSEv, (boolean)0ll );
	label$15:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8WSTRING_5WCHR_13SUITE_CTOR126Ev( void )
{
	label$16:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.wstring_.wchr_", (tmp$4)0ull, (tmp$4)0ull );
	label$17:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
