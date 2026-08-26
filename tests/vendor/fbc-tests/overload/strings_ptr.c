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
typedef int64 $N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE;
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
void fb_WstrDelete( uint16* );
uint16* fb_ULongintToWstr( uint64 );
uint16* fb_StrToWstr( char* );
static void fb_ctor__strings_ptr( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcS3_( char*, char* );
$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcPw( char*, uint16* );
$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwPc( uint16*, char* );
$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( uint16*, uint16* );
$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPc( char* );
$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( uint16* );
void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR8LITERALSEv( void );
static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR13LITERALS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR7STRINGSEv( void );
static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12STRINGS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR13FIXED_STRINGSEv( void );
static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR18FIXED_STRINGS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR8ZSTRINGSEv( void );
static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR13ZSTRINGS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12ZSTRING_PTRSEv( void );
static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR17ZSTRING_PTRS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR14FIXED_WSTRINGSEv( void );
static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR19FIXED_WSTRINGS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12WSTRING_PTRSEv( void );
static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR17WSTRING_PTRS_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12SUITE_CTOR97Ev( void ) __attribute__(( constructor ));

$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcS3_( char* BAR$1, char* BAZ$1 )
{
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2:;
	fb$result$1 = 5ll;
	label$3:;
	return fb$result$1;
}

$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcPw( char* BAR$1, uint16* BAZ$1 )
{
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$4:;
	fb$result$1 = 4ll;
	label$5:;
	return fb$result$1;
}

$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwPc( uint16* BAR$1, char* BAZ$1 )
{
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$6:;
	fb$result$1 = 2ll;
	label$7:;
	return fb$result$1;
}

$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( uint16* BAR$1, uint16* BAZ$1 )
{
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$8:;
	fb$result$1 = 1ll;
	label$9:;
	return fb$result$1;
}

$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPc( char* BAR$1 )
{
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$10:;
	fb$result$1 = 3ll;
	label$11:;
	return fb$result$1;
}

$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( uint16* BAR$1 )
{
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$12:;
	fb$result$1 = 0ll;
	label$13:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR8LITERALSEv( void )
{
	label$14:;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$0 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcS3_( (char*)"123", (char*)"123" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$0 == 5ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 48, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.LITERALS", (char*)"CU_ASSERT_EQUAL(RESULT_ZZ,proc( \x22" "123\x22, \x22" "123\x22 ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$3 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcPw( (char*)"123", (uint16*)L"123" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$3 == 4ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 48, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.LITERALS", (char*)"CU_ASSERT_EQUAL(RESULT_ZW,proc( \x22" "123\x22, wstr(\x22" "123\x22) ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$6 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwPc( (uint16*)L"123", (char*)"123" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$6 == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 48, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.LITERALS", (char*)"CU_ASSERT_EQUAL(RESULT_WZ,proc( wstr(\x22" "123\x22), \x22" "123\x22 ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$9 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( (uint16*)L"123", (uint16*)L"123" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$9 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 48, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.LITERALS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wstr(\x22" "123\x22), wstr(\x22" "123\x22) ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$12 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( (uint16*)L"123" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$12 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 48, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.LITERALS", (char*)"CU_ASSERT_EQUAL(RESULT_W,proc( wstr(\x22" "123\x22) ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$15 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPc( (char*)"123" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$15 == 3ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 48, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.LITERALS", (char*)"CU_ASSERT_EQUAL(RESULT_Z,proc( \x22" "123\x22 ))" );
	label$15:;
}

void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR7STRINGSEv( void )
{
	uint16* TMP$57$1;
	uint16* TMP$61$1;
	uint16* TMP$65$1;
	uint16* TMP$66$1;
	uint16* TMP$70$1;
	label$18:;
	FBSTRING S$1;
	__builtin_memset( &S$1, 0, 24ll );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$1 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcS3_( (char*)*(char**)&S$1, (char*)*(char**)&S$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1 == 5ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 54, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_ZZ,proc( s, s ))" );
	uint16* vr$4 = fb_StrToWstr( (char*)*(char**)&S$1 );
	TMP$57$1 = vr$4;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$5 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcPw( (char*)*(char**)&S$1, TMP$57$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$5 == 4ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 54, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_ZW,proc( s, wstr(s) ))" );
	fb_WstrDelete( (uint16*)TMP$57$1 );
	uint16* vr$8 = fb_StrToWstr( (char*)*(char**)&S$1 );
	TMP$61$1 = vr$8;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$9 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwPc( TMP$61$1, (char*)*(char**)&S$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$9 == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 54, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WZ,proc( wstr(s), s ))" );
	fb_WstrDelete( (uint16*)TMP$61$1 );
	uint16* vr$12 = fb_StrToWstr( (char*)*(char**)&S$1 );
	TMP$66$1 = vr$12;
	uint16* vr$13 = fb_StrToWstr( (char*)*(char**)&S$1 );
	TMP$65$1 = vr$13;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$14 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( TMP$65$1, TMP$66$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$14 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 54, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wstr(s), wstr(s) ))" );
	fb_WstrDelete( (uint16*)TMP$66$1 );
	fb_WstrDelete( (uint16*)TMP$65$1 );
	uint16* vr$17 = fb_StrToWstr( (char*)*(char**)&S$1 );
	TMP$70$1 = vr$17;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$18 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( TMP$70$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$18 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 54, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_W,proc( wstr(s) ))" );
	fb_WstrDelete( (uint16*)TMP$70$1 );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$21 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPc( (char*)*(char**)&S$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$21 == 3ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 54, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_Z,proc( s ))" );
	fb_StrDelete( (FBSTRING*)&S$1 );
	label$19:;
}

void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR13FIXED_STRINGSEv( void )
{
	FBSTRING TMP$79$1;
	FBSTRING TMP$80$1;
	FBSTRING TMP$85$1;
	FBSTRING TMP$86$1;
	uint16* TMP$87$1;
	FBSTRING TMP$91$1;
	uint16* TMP$92$1;
	FBSTRING TMP$93$1;
	FBSTRING TMP$97$1;
	FBSTRING TMP$98$1;
	uint16* TMP$99$1;
	uint16* TMP$100$1;
	FBSTRING TMP$104$1;
	uint16* TMP$105$1;
	FBSTRING TMP$109$1;
	label$22:;
	uint8 FS$1[10];
	__builtin_memset( (uint8*)FS$1, 32, 10ll );
	__builtin_memset( &TMP$80$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$80$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	__builtin_memset( &TMP$79$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$79$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$7 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcS3_( (char*)*(char**)&TMP$79$1, (char*)*(char**)&TMP$80$1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$80$1, -1ll, -1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$79$1, -1ll, -1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$7 == 5ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 60, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_ZZ,proc( fs, fs ))" );
	fb_StrDelete( (FBSTRING*)&TMP$80$1 );
	fb_StrDelete( (FBSTRING*)&TMP$79$1 );
	__builtin_memset( &TMP$85$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$85$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	uint16* vr$19 = fb_StrToWstr( (char*)*(char**)&TMP$85$1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$85$1, -1ll, -1 );
	TMP$87$1 = vr$19;
	__builtin_memset( &TMP$86$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$86$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$25 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcPw( (char*)*(char**)&TMP$86$1, TMP$87$1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$86$1, -1ll, -1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$25 == 4ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 60, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_ZW,proc( fs, wstr(fs) ))" );
	fb_WstrDelete( (uint16*)TMP$87$1 );
	fb_StrDelete( (FBSTRING*)&TMP$86$1 );
	fb_StrDelete( (FBSTRING*)&TMP$85$1 );
	__builtin_memset( &TMP$93$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$93$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	__builtin_memset( &TMP$91$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$91$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	uint16* vr$38 = fb_StrToWstr( (char*)*(char**)&TMP$91$1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$91$1, -1ll, -1 );
	TMP$92$1 = vr$38;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$41 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwPc( TMP$92$1, (char*)*(char**)&TMP$93$1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$93$1, -1ll, -1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$41 == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 60, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WZ,proc( wstr(fs), fs ))" );
	fb_StrDelete( (FBSTRING*)&TMP$93$1 );
	fb_WstrDelete( (uint16*)TMP$92$1 );
	fb_StrDelete( (FBSTRING*)&TMP$91$1 );
	__builtin_memset( &TMP$98$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$98$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	uint16* vr$51 = fb_StrToWstr( (char*)*(char**)&TMP$98$1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$98$1, -1ll, -1 );
	TMP$100$1 = vr$51;
	__builtin_memset( &TMP$97$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$97$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	uint16* vr$57 = fb_StrToWstr( (char*)*(char**)&TMP$97$1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$97$1, -1ll, -1 );
	TMP$99$1 = vr$57;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$60 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( TMP$99$1, TMP$100$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$60 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 60, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wstr(fs), wstr(fs) ))" );
	fb_WstrDelete( (uint16*)TMP$100$1 );
	fb_WstrDelete( (uint16*)TMP$99$1 );
	fb_StrDelete( (FBSTRING*)&TMP$98$1 );
	fb_StrDelete( (FBSTRING*)&TMP$97$1 );
	__builtin_memset( &TMP$104$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$104$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	uint16* vr$68 = fb_StrToWstr( (char*)*(char**)&TMP$104$1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$104$1, -1ll, -1 );
	TMP$105$1 = vr$68;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$71 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( TMP$105$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$71 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 60, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_W,proc( wstr(fs) ))" );
	fb_WstrDelete( (uint16*)TMP$105$1 );
	fb_StrDelete( (FBSTRING*)&TMP$104$1 );
	__builtin_memset( &TMP$109$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$109$1, -1ll, (void*)FS$1, -9223372036854775798ll, 0 );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$78 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPc( (char*)*(char**)&TMP$109$1 );
	fb_StrAssign( (void*)FS$1, -9223372036854775798ll, (void*)&TMP$109$1, -1ll, -1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$78 == 3ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 60, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_STRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_Z,proc( fs ))" );
	fb_StrDelete( (FBSTRING*)&TMP$109$1 );
	label$23:;
}

void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR8ZSTRINGSEv( void )
{
	uint16* TMP$119$1;
	uint16* TMP$123$1;
	uint16* TMP$127$1;
	uint16* TMP$128$1;
	uint16* TMP$132$1;
	label$26:;
	char ZS$1[10];
	__builtin_memset( (char*)ZS$1, 0, 10ll );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$3 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcS3_( (char*)ZS$1, (char*)ZS$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$3 == 5ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 66, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_ZZ,proc( zs, zs ))" );
	uint16* vr$7 = fb_StrToWstr( (char*)ZS$1 );
	TMP$119$1 = vr$7;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$9 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcPw( (char*)ZS$1, TMP$119$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$9 == 4ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 66, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_ZW,proc( zs, wstr(zs) ))" );
	fb_WstrDelete( (uint16*)TMP$119$1 );
	uint16* vr$14 = fb_StrToWstr( (char*)ZS$1 );
	TMP$123$1 = vr$14;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$15 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwPc( TMP$123$1, (char*)ZS$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$15 == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 66, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WZ,proc( wstr(zs), zs ))" );
	fb_WstrDelete( (uint16*)TMP$123$1 );
	uint16* vr$19 = fb_StrToWstr( (char*)ZS$1 );
	TMP$128$1 = vr$19;
	uint16* vr$21 = fb_StrToWstr( (char*)ZS$1 );
	TMP$127$1 = vr$21;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$22 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( TMP$127$1, TMP$128$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$22 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 66, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wstr(zs), wstr(zs) ))" );
	fb_WstrDelete( (uint16*)TMP$128$1 );
	fb_WstrDelete( (uint16*)TMP$127$1 );
	uint16* vr$26 = fb_StrToWstr( (char*)ZS$1 );
	TMP$132$1 = vr$26;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$27 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( TMP$132$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$27 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 66, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_W,proc( wstr(zs) ))" );
	fb_WstrDelete( (uint16*)TMP$132$1 );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$31 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPc( (char*)ZS$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$31 == 3ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 66, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_Z,proc( zs ))" );
	label$27:;
}

void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12ZSTRING_PTRSEv( void )
{
	uint16* TMP$145$1;
	uint16* TMP$149$1;
	uint16* TMP$153$1;
	uint16* TMP$154$1;
	uint16* TMP$158$1;
	label$30:;
	char* ZSP$1;
	__builtin_memset( &ZSP$1, 0, 8ll );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$1 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcS3_( ZSP$1, ZSP$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1 == 5ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 72, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_ZZ,proc( zsp, zsp ))" );
	uint16* vr$4 = fb_ULongintToWstr( (uint64)ZSP$1 );
	TMP$145$1 = vr$4;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$5 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPcPw( ZSP$1, TMP$145$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$5 == 4ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 72, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_ZW,proc( zsp, wstr(zsp) ))" );
	fb_WstrDelete( (uint16*)TMP$145$1 );
	uint16* vr$8 = fb_ULongintToWstr( (uint64)ZSP$1 );
	TMP$149$1 = vr$8;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$9 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwPc( TMP$149$1, ZSP$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$9 == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 72, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_WZ,proc( wstr(zsp), zsp ))" );
	fb_WstrDelete( (uint16*)TMP$149$1 );
	uint16* vr$12 = fb_ULongintToWstr( (uint64)ZSP$1 );
	TMP$154$1 = vr$12;
	uint16* vr$13 = fb_ULongintToWstr( (uint64)ZSP$1 );
	TMP$153$1 = vr$13;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$14 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( TMP$153$1, TMP$154$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$14 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 72, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wstr(zsp), wstr(zsp) ))" );
	fb_WstrDelete( (uint16*)TMP$154$1 );
	fb_WstrDelete( (uint16*)TMP$153$1 );
	uint16* vr$17 = fb_ULongintToWstr( (uint64)ZSP$1 );
	TMP$158$1 = vr$17;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$18 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( TMP$158$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$18 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 72, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_W,proc( wstr(zsp) ))" );
	fb_WstrDelete( (uint16*)TMP$158$1 );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$21 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPc( ZSP$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$21 == 3ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 72, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.ZSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_Z,proc( zsp ))" );
	label$31:;
}

void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR14FIXED_WSTRINGSEv( void )
{
	label$34:;
	uint16 FWS$1[10];
	__builtin_memset( (uint16*)FWS$1, 0, 20ll );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$3 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( (uint16*)FWS$1, (uint16*)FWS$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$3 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 78, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_WSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( fws, fws ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$8 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( (uint16*)FWS$1, (uint16*)FWS$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$8 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 79, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_WSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( fws, wstr(fws) ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$13 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( (uint16*)FWS$1, (uint16*)FWS$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$13 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 80, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_WSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wstr(fws), fws ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$18 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( (uint16*)FWS$1, (uint16*)FWS$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$18 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 81, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_WSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wstr(fws), wstr(fws) ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$22 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( (uint16*)FWS$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$22 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 82, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_WSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_W,proc( wstr(fws) ))" );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$26 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( (uint16*)FWS$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$26 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 83, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.FIXED_WSTRINGS", (char*)"CU_ASSERT_EQUAL(RESULT_W,proc( fws ))" );
	label$35:;
}

void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12WSTRING_PTRSEv( void )
{
	uint16* TMP$192$1;
	uint16* TMP$196$1;
	uint16* TMP$200$1;
	uint16* TMP$201$1;
	uint16* TMP$205$1;
	label$38:;
	uint16* WSP$1;
	__builtin_memset( &WSP$1, 0, 8ll );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$1 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( WSP$1, WSP$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 89, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.WSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wsp, wsp ))" );
	uint16* vr$4 = fb_ULongintToWstr( (uint64)WSP$1 );
	TMP$192$1 = vr$4;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$5 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( WSP$1, TMP$192$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$5 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 90, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.WSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wsp, wstr(wsp) ))" );
	fb_WstrDelete( (uint16*)TMP$192$1 );
	uint16* vr$8 = fb_ULongintToWstr( (uint64)WSP$1 );
	TMP$196$1 = vr$8;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$9 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( TMP$196$1, WSP$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$9 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 91, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.WSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wstr(wsp), wsp ))" );
	fb_WstrDelete( (uint16*)TMP$196$1 );
	uint16* vr$12 = fb_ULongintToWstr( (uint64)WSP$1 );
	TMP$201$1 = vr$12;
	uint16* vr$13 = fb_ULongintToWstr( (uint64)WSP$1 );
	TMP$200$1 = vr$13;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$14 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPwS3_( TMP$200$1, TMP$201$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$14 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 92, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.WSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_WW,proc( wstr(wsp), wstr(wsp) ))" );
	fb_WstrDelete( (uint16*)TMP$201$1 );
	fb_WstrDelete( (uint16*)TMP$200$1 );
	uint16* vr$17 = fb_ULongintToWstr( (uint64)WSP$1 );
	TMP$205$1 = vr$17;
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$18 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( TMP$205$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$18 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 93, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.WSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_W,proc( wstr(wsp) ))" );
	fb_WstrDelete( (uint16*)TMP$205$1 );
	$N5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR6RESULTE vr$21 = _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR4PROCEPw( WSP$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$21 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Coverload\x5Cstrings_ptr.bas", 94, (char*)"TESTS.FBC_TESTS.OVERLOAD_.STRINGS_PTR.WSTRING_PTRS", (char*)"CU_ASSERT_EQUAL(RESULT_W,proc( wsp ))" );
	label$39:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR13LITERALS_CTOREv( void )
{
	label$16:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.overload_.strings_ptr", (char*)"literals", (tmp$5)&_ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR8LITERALSEv, (boolean)0ll );
	label$17:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12STRINGS_CTOREv( void )
{
	label$20:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.overload_.strings_ptr", (char*)"strings", (tmp$5)&_ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR7STRINGSEv, (boolean)0ll );
	label$21:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR18FIXED_STRINGS_CTOREv( void )
{
	label$24:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.overload_.strings_ptr", (char*)"fixed_strings", (tmp$5)&_ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR13FIXED_STRINGSEv, (boolean)0ll );
	label$25:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR13ZSTRINGS_CTOREv( void )
{
	label$28:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.overload_.strings_ptr", (char*)"zstrings", (tmp$5)&_ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR8ZSTRINGSEv, (boolean)0ll );
	label$29:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR17ZSTRING_PTRS_CTOREv( void )
{
	label$32:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.overload_.strings_ptr", (char*)"zstring_ptrs", (tmp$5)&_ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12ZSTRING_PTRSEv, (boolean)0ll );
	label$33:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR19FIXED_WSTRINGS_CTOREv( void )
{
	label$36:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.overload_.strings_ptr", (char*)"fixed_wstrings", (tmp$5)&_ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR14FIXED_WSTRINGSEv, (boolean)0ll );
	label$37:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR17WSTRING_PTRS_CTOREv( void )
{
	label$40:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.overload_.strings_ptr", (char*)"wstring_ptrs", (tmp$5)&_ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12WSTRING_PTRSEv, (boolean)0ll );
	label$41:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS9OVERLOAD_11STRINGS_PTR12SUITE_CTOR97Ev( void )
{
	label$42:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.overload_.strings_ptr", (tmp$4)0ull, (tmp$4)0ull );
	label$43:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
