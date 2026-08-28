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
struct $19UZSTRING_FIXED_BASE {
	char _DATA[256];
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $19UZSTRING_FIXED_BASE ) == 256 );
struct $14UZSTRING_FIXED {
	struct $19UZSTRING_FIXED_BASE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $14UZSTRING_FIXED ) == 256 );
struct $22UZSTRING_FIXED_MUTABLE {
	struct $19UZSTRING_FIXED_BASE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $22UZSTRING_FIXED_MUTABLE ) == 256 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
FBSTRING* fb_StrInit( void*, int64, void*, int64, int32 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
void fb_WstrDelete( uint16* );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_IntToStr( int32 );
FBSTRING* fb_UIntToStr( uint32 );
FBSTRING* fb_LongintToStr( int64 );
FBSTRING* fb_ULongintToStr( uint64 );
FBSTRING* fb_FloatToStr( float );
FBSTRING* fb_DoubleToStr( double );
uint16* fb_StrToWstr( char* );
int64 fb_StrLen( void*, int64 );
static void fb_ctor__str( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN19UZSTRING_FIXED_BASEC1Ev( struct $19UZSTRING_FIXED_BASE* );
void _ZN14UZSTRING_FIXEDC1EPKw( struct $14UZSTRING_FIXED*, uint16* );
void _ZN14UZSTRING_FIXEDC1EPKc( struct $14UZSTRING_FIXED*, char* );
char* _ZN14UZSTRING_FIXEDcvcEv( struct $14UZSTRING_FIXED* );
static void _ZN14UZSTRING_FIXEDaSERKS_( struct $14UZSTRING_FIXED*, struct $14UZSTRING_FIXED* );
static void _ZN22UZSTRING_FIXED_MUTABLEaSERKS_( struct $22UZSTRING_FIXED_MUTABLE*, struct $22UZSTRING_FIXED_MUTABLE* );
void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_7NUMERICEv( void );
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_12NUMERIC_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_13SUITE_CTOR122Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_7NUMERICEv( void )
{
	label$10:;
	{
		FBSTRING TMP$8$2;
		int8 T$2;
		T$2 = (int8)-128;
		char W$2[50];
		FBSTRING* vr$1 = fb_IntToStr( (int32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$8$2, 0, 24ll );
		FBSTRING* vr$5 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$8$2, -1ll, (void*)vr$5, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$8$2 );
		fb_StrDelete( (FBSTRING*)&TMP$8$2 );
		char R$2[50];
		char* vr$10 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$10, 0ll, 0 );
		int64 vr$13 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$15 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$13 == vr$15) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$20 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$20 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$25 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$27 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$25 != vr$27) goto label$13;
			{
				label$14:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$24$6;
						int64 vr$29 = fb_StrLen( (void*)W$2, 50ll );
						TMP$24$6 = vr$29 + -1ll;
						goto label$17;
						label$20:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$22;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$15;
							}
							label$22:;
							label$21:;
						}
						label$18:;
						I$6 = I$6 + 1ll;
						label$17:;
						if( I$6 <= TMP$24$6) goto label$20;
						label$19:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$16:;
				label$15:;
			}
			label$13:;
			label$12:;
		}
	}
	{
		FBSTRING TMP$29$2;
		int8 T$2;
		T$2 = (int8)0;
		char W$2[50];
		FBSTRING* vr$39 = fb_IntToStr( (int32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$39, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$29$2, 0, 24ll );
		FBSTRING* vr$43 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$29$2, -1ll, (void*)vr$43, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$29$2 );
		fb_StrDelete( (FBSTRING*)&TMP$29$2 );
		char R$2[50];
		char* vr$48 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$48, 0ll, 0 );
		int64 vr$51 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$53 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$51 == vr$53) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$58 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$58 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$63 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$65 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$63 != vr$65) goto label$24;
			{
				label$25:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$30$6;
						int64 vr$67 = fb_StrLen( (void*)W$2, 50ll );
						TMP$30$6 = vr$67 + -1ll;
						goto label$28;
						label$31:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$33;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$26;
							}
							label$33:;
							label$32:;
						}
						label$29:;
						I$6 = I$6 + 1ll;
						label$28:;
						if( I$6 <= TMP$30$6) goto label$31;
						label$30:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$27:;
				label$26:;
			}
			label$24:;
			label$23:;
		}
	}
	{
		FBSTRING TMP$31$2;
		int8 T$2;
		T$2 = (int8)127;
		char W$2[50];
		FBSTRING* vr$77 = fb_IntToStr( (int32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$77, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$31$2, 0, 24ll );
		FBSTRING* vr$81 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$31$2, -1ll, (void*)vr$81, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$31$2 );
		fb_StrDelete( (FBSTRING*)&TMP$31$2 );
		char R$2[50];
		char* vr$86 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$86, 0ll, 0 );
		int64 vr$89 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$91 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$89 == vr$91) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$96 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$96 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$101 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$103 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$101 != vr$103) goto label$35;
			{
				label$36:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$32$6;
						int64 vr$105 = fb_StrLen( (void*)W$2, 50ll );
						TMP$32$6 = vr$105 + -1ll;
						goto label$39;
						label$42:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$44;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$37;
							}
							label$44:;
							label$43:;
						}
						label$40:;
						I$6 = I$6 + 1ll;
						label$39:;
						if( I$6 <= TMP$32$6) goto label$42;
						label$41:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$38:;
				label$37:;
			}
			label$35:;
			label$34:;
		}
	}
	{
		FBSTRING TMP$33$2;
		uint8 T$2;
		T$2 = (uint8)0u;
		char W$2[50];
		FBSTRING* vr$115 = fb_UIntToStr( (uint32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$115, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$33$2, 0, 24ll );
		FBSTRING* vr$119 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$33$2, -1ll, (void*)vr$119, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$33$2 );
		fb_StrDelete( (FBSTRING*)&TMP$33$2 );
		char R$2[50];
		char* vr$124 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$124, 0ll, 0 );
		int64 vr$127 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$129 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$127 == vr$129) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$134 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$134 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$139 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$141 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$139 != vr$141) goto label$46;
			{
				label$47:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$34$6;
						int64 vr$143 = fb_StrLen( (void*)W$2, 50ll );
						TMP$34$6 = vr$143 + -1ll;
						goto label$50;
						label$53:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$55;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$48;
							}
							label$55:;
							label$54:;
						}
						label$51:;
						I$6 = I$6 + 1ll;
						label$50:;
						if( I$6 <= TMP$34$6) goto label$53;
						label$52:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$49:;
				label$48:;
			}
			label$46:;
			label$45:;
		}
	}
	{
		FBSTRING TMP$35$2;
		uint8 T$2;
		T$2 = (uint8)128u;
		char W$2[50];
		FBSTRING* vr$153 = fb_UIntToStr( (uint32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$153, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$35$2, 0, 24ll );
		FBSTRING* vr$157 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$35$2, -1ll, (void*)vr$157, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$35$2 );
		fb_StrDelete( (FBSTRING*)&TMP$35$2 );
		char R$2[50];
		char* vr$162 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$162, 0ll, 0 );
		int64 vr$165 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$167 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$165 == vr$167) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$172 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$172 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$177 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$179 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$177 != vr$179) goto label$57;
			{
				label$58:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$36$6;
						int64 vr$181 = fb_StrLen( (void*)W$2, 50ll );
						TMP$36$6 = vr$181 + -1ll;
						goto label$61;
						label$64:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$66;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$59;
							}
							label$66:;
							label$65:;
						}
						label$62:;
						I$6 = I$6 + 1ll;
						label$61:;
						if( I$6 <= TMP$36$6) goto label$64;
						label$63:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$60:;
				label$59:;
			}
			label$57:;
			label$56:;
		}
	}
	{
		FBSTRING TMP$37$2;
		uint8 T$2;
		T$2 = (uint8)255u;
		char W$2[50];
		FBSTRING* vr$191 = fb_UIntToStr( (uint32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$191, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$37$2, 0, 24ll );
		FBSTRING* vr$195 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$37$2, -1ll, (void*)vr$195, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$37$2 );
		fb_StrDelete( (FBSTRING*)&TMP$37$2 );
		char R$2[50];
		char* vr$200 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$200, 0ll, 0 );
		int64 vr$203 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$205 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$203 == vr$205) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$210 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$210 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$215 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$217 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$215 != vr$217) goto label$68;
			{
				label$69:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$38$6;
						int64 vr$219 = fb_StrLen( (void*)W$2, 50ll );
						TMP$38$6 = vr$219 + -1ll;
						goto label$72;
						label$75:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$77;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$70;
							}
							label$77:;
							label$76:;
						}
						label$73:;
						I$6 = I$6 + 1ll;
						label$72:;
						if( I$6 <= TMP$38$6) goto label$75;
						label$74:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$71:;
				label$70:;
			}
			label$68:;
			label$67:;
		}
	}
	{
		FBSTRING TMP$39$2;
		int16 T$2;
		T$2 = (int16)-32768;
		char W$2[50];
		FBSTRING* vr$229 = fb_IntToStr( (int32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$229, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$39$2, 0, 24ll );
		FBSTRING* vr$233 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$39$2, -1ll, (void*)vr$233, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$39$2 );
		fb_StrDelete( (FBSTRING*)&TMP$39$2 );
		char R$2[50];
		char* vr$238 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$238, 0ll, 0 );
		int64 vr$241 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$243 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$241 == vr$243) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$248 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$248 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$253 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$255 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$253 != vr$255) goto label$79;
			{
				label$80:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$40$6;
						int64 vr$257 = fb_StrLen( (void*)W$2, 50ll );
						TMP$40$6 = vr$257 + -1ll;
						goto label$83;
						label$86:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$88;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$81;
							}
							label$88:;
							label$87:;
						}
						label$84:;
						I$6 = I$6 + 1ll;
						label$83:;
						if( I$6 <= TMP$40$6) goto label$86;
						label$85:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$82:;
				label$81:;
			}
			label$79:;
			label$78:;
		}
	}
	{
		FBSTRING TMP$41$2;
		int16 T$2;
		T$2 = (int16)0;
		char W$2[50];
		FBSTRING* vr$267 = fb_IntToStr( (int32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$267, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$41$2, 0, 24ll );
		FBSTRING* vr$271 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$41$2, -1ll, (void*)vr$271, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$41$2 );
		fb_StrDelete( (FBSTRING*)&TMP$41$2 );
		char R$2[50];
		char* vr$276 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$276, 0ll, 0 );
		int64 vr$279 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$281 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$279 == vr$281) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$286 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$286 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$291 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$293 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$291 != vr$293) goto label$90;
			{
				label$91:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$42$6;
						int64 vr$295 = fb_StrLen( (void*)W$2, 50ll );
						TMP$42$6 = vr$295 + -1ll;
						goto label$94;
						label$97:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$99;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$92;
							}
							label$99:;
							label$98:;
						}
						label$95:;
						I$6 = I$6 + 1ll;
						label$94:;
						if( I$6 <= TMP$42$6) goto label$97;
						label$96:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$93:;
				label$92:;
			}
			label$90:;
			label$89:;
		}
	}
	{
		FBSTRING TMP$43$2;
		int16 T$2;
		T$2 = (int16)32767;
		char W$2[50];
		FBSTRING* vr$305 = fb_IntToStr( (int32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$305, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$43$2, 0, 24ll );
		FBSTRING* vr$309 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$43$2, -1ll, (void*)vr$309, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$43$2 );
		fb_StrDelete( (FBSTRING*)&TMP$43$2 );
		char R$2[50];
		char* vr$314 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$314, 0ll, 0 );
		int64 vr$317 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$319 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$317 == vr$319) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$324 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$324 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$329 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$331 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$329 != vr$331) goto label$101;
			{
				label$102:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$44$6;
						int64 vr$333 = fb_StrLen( (void*)W$2, 50ll );
						TMP$44$6 = vr$333 + -1ll;
						goto label$105;
						label$108:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$110;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$103;
							}
							label$110:;
							label$109:;
						}
						label$106:;
						I$6 = I$6 + 1ll;
						label$105:;
						if( I$6 <= TMP$44$6) goto label$108;
						label$107:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$104:;
				label$103:;
			}
			label$101:;
			label$100:;
		}
	}
	{
		FBSTRING TMP$45$2;
		uint16 T$2;
		T$2 = (uint16)0u;
		char W$2[50];
		FBSTRING* vr$343 = fb_UIntToStr( (uint32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$343, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$45$2, 0, 24ll );
		FBSTRING* vr$347 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$45$2, -1ll, (void*)vr$347, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$45$2 );
		fb_StrDelete( (FBSTRING*)&TMP$45$2 );
		char R$2[50];
		char* vr$352 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$352, 0ll, 0 );
		int64 vr$355 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$357 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$355 == vr$357) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$362 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$362 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$367 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$369 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$367 != vr$369) goto label$112;
			{
				label$113:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$46$6;
						int64 vr$371 = fb_StrLen( (void*)W$2, 50ll );
						TMP$46$6 = vr$371 + -1ll;
						goto label$116;
						label$119:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$121;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$114;
							}
							label$121:;
							label$120:;
						}
						label$117:;
						I$6 = I$6 + 1ll;
						label$116:;
						if( I$6 <= TMP$46$6) goto label$119;
						label$118:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$115:;
				label$114:;
			}
			label$112:;
			label$111:;
		}
	}
	{
		FBSTRING TMP$47$2;
		uint16 T$2;
		T$2 = (uint16)32768u;
		char W$2[50];
		FBSTRING* vr$381 = fb_UIntToStr( (uint32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$381, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$47$2, 0, 24ll );
		FBSTRING* vr$385 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$47$2, -1ll, (void*)vr$385, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$47$2 );
		fb_StrDelete( (FBSTRING*)&TMP$47$2 );
		char R$2[50];
		char* vr$390 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$390, 0ll, 0 );
		int64 vr$393 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$395 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$393 == vr$395) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$400 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$400 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$405 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$407 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$405 != vr$407) goto label$123;
			{
				label$124:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$48$6;
						int64 vr$409 = fb_StrLen( (void*)W$2, 50ll );
						TMP$48$6 = vr$409 + -1ll;
						goto label$127;
						label$130:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$132;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$125;
							}
							label$132:;
							label$131:;
						}
						label$128:;
						I$6 = I$6 + 1ll;
						label$127:;
						if( I$6 <= TMP$48$6) goto label$130;
						label$129:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$126:;
				label$125:;
			}
			label$123:;
			label$122:;
		}
	}
	{
		FBSTRING TMP$49$2;
		uint16 T$2;
		T$2 = (uint16)65535u;
		char W$2[50];
		FBSTRING* vr$419 = fb_UIntToStr( (uint32)T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$419, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$49$2, 0, 24ll );
		FBSTRING* vr$423 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$49$2, -1ll, (void*)vr$423, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$49$2 );
		fb_StrDelete( (FBSTRING*)&TMP$49$2 );
		char R$2[50];
		char* vr$428 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$428, 0ll, 0 );
		int64 vr$431 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$433 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$431 == vr$433) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$438 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$438 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$443 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$445 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$443 != vr$445) goto label$134;
			{
				label$135:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$50$6;
						int64 vr$447 = fb_StrLen( (void*)W$2, 50ll );
						TMP$50$6 = vr$447 + -1ll;
						goto label$138;
						label$141:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$143;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$136;
							}
							label$143:;
							label$142:;
						}
						label$139:;
						I$6 = I$6 + 1ll;
						label$138:;
						if( I$6 <= TMP$50$6) goto label$141;
						label$140:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$137:;
				label$136:;
			}
			label$134:;
			label$133:;
		}
	}
	{
		FBSTRING TMP$51$2;
		int32 T$2;
		T$2 = (int32)-2147483648u;
		char W$2[50];
		FBSTRING* vr$456 = fb_IntToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$456, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$51$2, 0, 24ll );
		FBSTRING* vr$459 = fb_IntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$51$2, -1ll, (void*)vr$459, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$51$2 );
		fb_StrDelete( (FBSTRING*)&TMP$51$2 );
		char R$2[50];
		char* vr$464 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$464, 0ll, 0 );
		int64 vr$467 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$469 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$467 == vr$469) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$474 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$474 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$479 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$481 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$479 != vr$481) goto label$145;
			{
				label$146:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$52$6;
						int64 vr$483 = fb_StrLen( (void*)W$2, 50ll );
						TMP$52$6 = vr$483 + -1ll;
						goto label$149;
						label$152:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$154;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$147;
							}
							label$154:;
							label$153:;
						}
						label$150:;
						I$6 = I$6 + 1ll;
						label$149:;
						if( I$6 <= TMP$52$6) goto label$152;
						label$151:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$148:;
				label$147:;
			}
			label$145:;
			label$144:;
		}
	}
	{
		FBSTRING TMP$53$2;
		int32 T$2;
		T$2 = 0;
		char W$2[50];
		FBSTRING* vr$492 = fb_IntToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$492, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$53$2, 0, 24ll );
		FBSTRING* vr$495 = fb_IntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$53$2, -1ll, (void*)vr$495, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$53$2 );
		fb_StrDelete( (FBSTRING*)&TMP$53$2 );
		char R$2[50];
		char* vr$500 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$500, 0ll, 0 );
		int64 vr$503 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$505 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$503 == vr$505) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$510 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$510 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$515 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$517 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$515 != vr$517) goto label$156;
			{
				label$157:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$54$6;
						int64 vr$519 = fb_StrLen( (void*)W$2, 50ll );
						TMP$54$6 = vr$519 + -1ll;
						goto label$160;
						label$163:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$165;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$158;
							}
							label$165:;
							label$164:;
						}
						label$161:;
						I$6 = I$6 + 1ll;
						label$160:;
						if( I$6 <= TMP$54$6) goto label$163;
						label$162:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$159:;
				label$158:;
			}
			label$156:;
			label$155:;
		}
	}
	{
		FBSTRING TMP$55$2;
		int32 T$2;
		T$2 = 2147483647;
		char W$2[50];
		FBSTRING* vr$528 = fb_IntToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$528, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$55$2, 0, 24ll );
		FBSTRING* vr$531 = fb_IntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$55$2, -1ll, (void*)vr$531, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$55$2 );
		fb_StrDelete( (FBSTRING*)&TMP$55$2 );
		char R$2[50];
		char* vr$536 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$536, 0ll, 0 );
		int64 vr$539 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$541 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$539 == vr$541) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$546 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$546 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$551 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$553 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$551 != vr$553) goto label$167;
			{
				label$168:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$56$6;
						int64 vr$555 = fb_StrLen( (void*)W$2, 50ll );
						TMP$56$6 = vr$555 + -1ll;
						goto label$171;
						label$174:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$176;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$169;
							}
							label$176:;
							label$175:;
						}
						label$172:;
						I$6 = I$6 + 1ll;
						label$171:;
						if( I$6 <= TMP$56$6) goto label$174;
						label$173:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$170:;
				label$169:;
			}
			label$167:;
			label$166:;
		}
	}
	{
		FBSTRING TMP$57$2;
		uint32 T$2;
		T$2 = 0u;
		char W$2[50];
		FBSTRING* vr$564 = fb_UIntToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$564, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$57$2, 0, 24ll );
		FBSTRING* vr$567 = fb_UIntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$57$2, -1ll, (void*)vr$567, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$57$2 );
		fb_StrDelete( (FBSTRING*)&TMP$57$2 );
		char R$2[50];
		char* vr$572 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$572, 0ll, 0 );
		int64 vr$575 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$577 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$575 == vr$577) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$582 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$582 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$587 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$589 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$587 != vr$589) goto label$178;
			{
				label$179:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$58$6;
						int64 vr$591 = fb_StrLen( (void*)W$2, 50ll );
						TMP$58$6 = vr$591 + -1ll;
						goto label$182;
						label$185:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$187;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$180;
							}
							label$187:;
							label$186:;
						}
						label$183:;
						I$6 = I$6 + 1ll;
						label$182:;
						if( I$6 <= TMP$58$6) goto label$185;
						label$184:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$181:;
				label$180:;
			}
			label$178:;
			label$177:;
		}
	}
	{
		FBSTRING TMP$59$2;
		uint32 T$2;
		T$2 = 2147483648u;
		char W$2[50];
		FBSTRING* vr$600 = fb_UIntToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$600, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$59$2, 0, 24ll );
		FBSTRING* vr$603 = fb_UIntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$59$2, -1ll, (void*)vr$603, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$59$2 );
		fb_StrDelete( (FBSTRING*)&TMP$59$2 );
		char R$2[50];
		char* vr$608 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$608, 0ll, 0 );
		int64 vr$611 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$613 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$611 == vr$613) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$618 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$618 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$623 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$625 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$623 != vr$625) goto label$189;
			{
				label$190:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$60$6;
						int64 vr$627 = fb_StrLen( (void*)W$2, 50ll );
						TMP$60$6 = vr$627 + -1ll;
						goto label$193;
						label$196:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$198;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$191;
							}
							label$198:;
							label$197:;
						}
						label$194:;
						I$6 = I$6 + 1ll;
						label$193:;
						if( I$6 <= TMP$60$6) goto label$196;
						label$195:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$192:;
				label$191:;
			}
			label$189:;
			label$188:;
		}
	}
	{
		FBSTRING TMP$61$2;
		uint32 T$2;
		T$2 = 4294967295u;
		char W$2[50];
		FBSTRING* vr$636 = fb_UIntToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$636, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$61$2, 0, 24ll );
		FBSTRING* vr$639 = fb_UIntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$61$2, -1ll, (void*)vr$639, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$61$2 );
		fb_StrDelete( (FBSTRING*)&TMP$61$2 );
		char R$2[50];
		char* vr$644 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$644, 0ll, 0 );
		int64 vr$647 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$649 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$647 == vr$649) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$654 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$654 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$659 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$661 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$659 != vr$661) goto label$200;
			{
				label$201:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$62$6;
						int64 vr$663 = fb_StrLen( (void*)W$2, 50ll );
						TMP$62$6 = vr$663 + -1ll;
						goto label$204;
						label$207:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$209;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$202;
							}
							label$209:;
							label$208:;
						}
						label$205:;
						I$6 = I$6 + 1ll;
						label$204:;
						if( I$6 <= TMP$62$6) goto label$207;
						label$206:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$203:;
				label$202:;
			}
			label$200:;
			label$199:;
		}
	}
	{
		FBSTRING TMP$63$2;
		int64 T$2;
		T$2 = (int64)-9223372036854775808ull;
		char W$2[50];
		FBSTRING* vr$672 = fb_LongintToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$672, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$63$2, 0, 24ll );
		FBSTRING* vr$675 = fb_LongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$63$2, -1ll, (void*)vr$675, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$63$2 );
		fb_StrDelete( (FBSTRING*)&TMP$63$2 );
		char R$2[50];
		char* vr$680 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$680, 0ll, 0 );
		int64 vr$683 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$685 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$683 == vr$685) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$690 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$690 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$695 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$697 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$695 != vr$697) goto label$211;
			{
				label$212:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$64$6;
						int64 vr$699 = fb_StrLen( (void*)W$2, 50ll );
						TMP$64$6 = vr$699 + -1ll;
						goto label$215;
						label$218:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$220;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$213;
							}
							label$220:;
							label$219:;
						}
						label$216:;
						I$6 = I$6 + 1ll;
						label$215:;
						if( I$6 <= TMP$64$6) goto label$218;
						label$217:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$214:;
				label$213:;
			}
			label$211:;
			label$210:;
		}
	}
	{
		FBSTRING TMP$65$2;
		int64 T$2;
		T$2 = 0ll;
		char W$2[50];
		FBSTRING* vr$708 = fb_LongintToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$708, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$65$2, 0, 24ll );
		FBSTRING* vr$711 = fb_LongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$65$2, -1ll, (void*)vr$711, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$65$2 );
		fb_StrDelete( (FBSTRING*)&TMP$65$2 );
		char R$2[50];
		char* vr$716 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$716, 0ll, 0 );
		int64 vr$719 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$721 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$719 == vr$721) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$726 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$726 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$731 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$733 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$731 != vr$733) goto label$222;
			{
				label$223:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$66$6;
						int64 vr$735 = fb_StrLen( (void*)W$2, 50ll );
						TMP$66$6 = vr$735 + -1ll;
						goto label$226;
						label$229:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$231;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$224;
							}
							label$231:;
							label$230:;
						}
						label$227:;
						I$6 = I$6 + 1ll;
						label$226:;
						if( I$6 <= TMP$66$6) goto label$229;
						label$228:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$225:;
				label$224:;
			}
			label$222:;
			label$221:;
		}
	}
	{
		FBSTRING TMP$67$2;
		int64 T$2;
		T$2 = 9223372036854775807ll;
		char W$2[50];
		FBSTRING* vr$744 = fb_LongintToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$744, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$67$2, 0, 24ll );
		FBSTRING* vr$747 = fb_LongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$67$2, -1ll, (void*)vr$747, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$67$2 );
		fb_StrDelete( (FBSTRING*)&TMP$67$2 );
		char R$2[50];
		char* vr$752 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$752, 0ll, 0 );
		int64 vr$755 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$757 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$755 == vr$757) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$762 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$762 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$767 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$769 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$767 != vr$769) goto label$233;
			{
				label$234:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$68$6;
						int64 vr$771 = fb_StrLen( (void*)W$2, 50ll );
						TMP$68$6 = vr$771 + -1ll;
						goto label$237;
						label$240:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$242;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$235;
							}
							label$242:;
							label$241:;
						}
						label$238:;
						I$6 = I$6 + 1ll;
						label$237:;
						if( I$6 <= TMP$68$6) goto label$240;
						label$239:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$236:;
				label$235:;
			}
			label$233:;
			label$232:;
		}
	}
	{
		FBSTRING TMP$69$2;
		uint64 T$2;
		T$2 = 0ull;
		char W$2[50];
		FBSTRING* vr$780 = fb_ULongintToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$780, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$69$2, 0, 24ll );
		FBSTRING* vr$783 = fb_ULongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$69$2, -1ll, (void*)vr$783, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$69$2 );
		fb_StrDelete( (FBSTRING*)&TMP$69$2 );
		char R$2[50];
		char* vr$788 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$788, 0ll, 0 );
		int64 vr$791 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$793 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$791 == vr$793) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$798 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$798 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$803 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$805 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$803 != vr$805) goto label$244;
			{
				label$245:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$70$6;
						int64 vr$807 = fb_StrLen( (void*)W$2, 50ll );
						TMP$70$6 = vr$807 + -1ll;
						goto label$248;
						label$251:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$253;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$246;
							}
							label$253:;
							label$252:;
						}
						label$249:;
						I$6 = I$6 + 1ll;
						label$248:;
						if( I$6 <= TMP$70$6) goto label$251;
						label$250:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$247:;
				label$246:;
			}
			label$244:;
			label$243:;
		}
	}
	{
		FBSTRING TMP$71$2;
		uint64 T$2;
		T$2 = 9223372036854775808ull;
		char W$2[50];
		FBSTRING* vr$816 = fb_ULongintToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$816, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$71$2, 0, 24ll );
		FBSTRING* vr$819 = fb_ULongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$71$2, -1ll, (void*)vr$819, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$71$2 );
		fb_StrDelete( (FBSTRING*)&TMP$71$2 );
		char R$2[50];
		char* vr$824 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$824, 0ll, 0 );
		int64 vr$827 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$829 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$827 == vr$829) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$834 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$834 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$839 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$841 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$839 != vr$841) goto label$255;
			{
				label$256:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$72$6;
						int64 vr$843 = fb_StrLen( (void*)W$2, 50ll );
						TMP$72$6 = vr$843 + -1ll;
						goto label$259;
						label$262:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$264;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$257;
							}
							label$264:;
							label$263:;
						}
						label$260:;
						I$6 = I$6 + 1ll;
						label$259:;
						if( I$6 <= TMP$72$6) goto label$262;
						label$261:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$258:;
				label$257:;
			}
			label$255:;
			label$254:;
		}
	}
	{
		FBSTRING TMP$73$2;
		uint64 T$2;
		T$2 = 18446744073709551615ull;
		char W$2[50];
		FBSTRING* vr$852 = fb_ULongintToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$852, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$73$2, 0, 24ll );
		FBSTRING* vr$855 = fb_ULongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$73$2, -1ll, (void*)vr$855, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$73$2 );
		fb_StrDelete( (FBSTRING*)&TMP$73$2 );
		char R$2[50];
		char* vr$860 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$860, 0ll, 0 );
		int64 vr$863 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$865 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$863 == vr$865) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$870 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$870 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$875 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$877 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$875 != vr$877) goto label$266;
			{
				label$267:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$74$6;
						int64 vr$879 = fb_StrLen( (void*)W$2, 50ll );
						TMP$74$6 = vr$879 + -1ll;
						goto label$270;
						label$273:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$275;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$268;
							}
							label$275:;
							label$274:;
						}
						label$271:;
						I$6 = I$6 + 1ll;
						label$270:;
						if( I$6 <= TMP$74$6) goto label$273;
						label$272:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$269:;
				label$268:;
			}
			label$266:;
			label$265:;
		}
	}
	{
		FBSTRING TMP$75$2;
		float T$2;
		T$2 = -0x1.8p+0f;
		char W$2[50];
		FBSTRING* vr$888 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$888, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$75$2, 0, 24ll );
		FBSTRING* vr$891 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$75$2, -1ll, (void*)vr$891, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$75$2 );
		fb_StrDelete( (FBSTRING*)&TMP$75$2 );
		char R$2[50];
		char* vr$896 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$896, 0ll, 0 );
		int64 vr$899 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$901 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$899 == vr$901) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$906 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$906 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$911 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$913 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$911 != vr$913) goto label$277;
			{
				label$278:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$76$6;
						int64 vr$915 = fb_StrLen( (void*)W$2, 50ll );
						TMP$76$6 = vr$915 + -1ll;
						goto label$281;
						label$284:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$286;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$279;
							}
							label$286:;
							label$285:;
						}
						label$282:;
						I$6 = I$6 + 1ll;
						label$281:;
						if( I$6 <= TMP$76$6) goto label$284;
						label$283:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$280:;
				label$279:;
			}
			label$277:;
			label$276:;
		}
	}
	{
		FBSTRING TMP$77$2;
		float T$2;
		T$2 = -0x1.p+0f;
		char W$2[50];
		FBSTRING* vr$924 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$924, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$77$2, 0, 24ll );
		FBSTRING* vr$927 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$77$2, -1ll, (void*)vr$927, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$77$2 );
		fb_StrDelete( (FBSTRING*)&TMP$77$2 );
		char R$2[50];
		char* vr$932 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$932, 0ll, 0 );
		int64 vr$935 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$937 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$935 == vr$937) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$942 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$942 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$947 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$949 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$947 != vr$949) goto label$288;
			{
				label$289:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$78$6;
						int64 vr$951 = fb_StrLen( (void*)W$2, 50ll );
						TMP$78$6 = vr$951 + -1ll;
						goto label$292;
						label$295:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$297;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$290;
							}
							label$297:;
							label$296:;
						}
						label$293:;
						I$6 = I$6 + 1ll;
						label$292:;
						if( I$6 <= TMP$78$6) goto label$295;
						label$294:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$291:;
				label$290:;
			}
			label$288:;
			label$287:;
		}
	}
	{
		FBSTRING TMP$79$2;
		float T$2;
		T$2 = -0x1.p+0f;
		char W$2[50];
		FBSTRING* vr$960 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$960, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$79$2, 0, 24ll );
		FBSTRING* vr$963 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$79$2, -1ll, (void*)vr$963, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$79$2 );
		fb_StrDelete( (FBSTRING*)&TMP$79$2 );
		char R$2[50];
		char* vr$968 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$968, 0ll, 0 );
		int64 vr$971 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$973 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$971 == vr$973) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$978 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$978 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$983 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$985 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$983 != vr$985) goto label$299;
			{
				label$300:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$80$6;
						int64 vr$987 = fb_StrLen( (void*)W$2, 50ll );
						TMP$80$6 = vr$987 + -1ll;
						goto label$303;
						label$306:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$308;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$301;
							}
							label$308:;
							label$307:;
						}
						label$304:;
						I$6 = I$6 + 1ll;
						label$303:;
						if( I$6 <= TMP$80$6) goto label$306;
						label$305:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$302:;
				label$301:;
			}
			label$299:;
			label$298:;
		}
	}
	{
		FBSTRING TMP$81$2;
		float T$2;
		T$2 = -0x1.p-1f;
		char W$2[50];
		FBSTRING* vr$996 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$996, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$81$2, 0, 24ll );
		FBSTRING* vr$999 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$81$2, -1ll, (void*)vr$999, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$81$2 );
		fb_StrDelete( (FBSTRING*)&TMP$81$2 );
		char R$2[50];
		char* vr$1004 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1004, 0ll, 0 );
		int64 vr$1007 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1009 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1007 == vr$1009) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1014 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1014 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1019 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1021 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1019 != vr$1021) goto label$310;
			{
				label$311:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$82$6;
						int64 vr$1023 = fb_StrLen( (void*)W$2, 50ll );
						TMP$82$6 = vr$1023 + -1ll;
						goto label$314;
						label$317:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$319;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$312;
							}
							label$319:;
							label$318:;
						}
						label$315:;
						I$6 = I$6 + 1ll;
						label$314:;
						if( I$6 <= TMP$82$6) goto label$317;
						label$316:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$313:;
				label$312:;
			}
			label$310:;
			label$309:;
		}
	}
	{
		FBSTRING TMP$83$2;
		float T$2;
		T$2 = 0x0p+0f;
		char W$2[50];
		FBSTRING* vr$1032 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1032, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$83$2, 0, 24ll );
		FBSTRING* vr$1035 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$83$2, -1ll, (void*)vr$1035, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$83$2 );
		fb_StrDelete( (FBSTRING*)&TMP$83$2 );
		char R$2[50];
		char* vr$1040 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1040, 0ll, 0 );
		int64 vr$1043 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1045 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1043 == vr$1045) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1050 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1050 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1055 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1057 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1055 != vr$1057) goto label$321;
			{
				label$322:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$84$6;
						int64 vr$1059 = fb_StrLen( (void*)W$2, 50ll );
						TMP$84$6 = vr$1059 + -1ll;
						goto label$325;
						label$328:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$330;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$323;
							}
							label$330:;
							label$329:;
						}
						label$326:;
						I$6 = I$6 + 1ll;
						label$325:;
						if( I$6 <= TMP$84$6) goto label$328;
						label$327:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$324:;
				label$323:;
			}
			label$321:;
			label$320:;
		}
	}
	{
		FBSTRING TMP$85$2;
		float T$2;
		T$2 = 0x1.p-1f;
		char W$2[50];
		FBSTRING* vr$1068 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1068, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$85$2, 0, 24ll );
		FBSTRING* vr$1071 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$85$2, -1ll, (void*)vr$1071, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$85$2 );
		fb_StrDelete( (FBSTRING*)&TMP$85$2 );
		char R$2[50];
		char* vr$1076 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1076, 0ll, 0 );
		int64 vr$1079 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1081 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1079 == vr$1081) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1086 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1086 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1091 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1093 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1091 != vr$1093) goto label$332;
			{
				label$333:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$86$6;
						int64 vr$1095 = fb_StrLen( (void*)W$2, 50ll );
						TMP$86$6 = vr$1095 + -1ll;
						goto label$336;
						label$339:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$341;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$334;
							}
							label$341:;
							label$340:;
						}
						label$337:;
						I$6 = I$6 + 1ll;
						label$336:;
						if( I$6 <= TMP$86$6) goto label$339;
						label$338:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$335:;
				label$334:;
			}
			label$332:;
			label$331:;
		}
	}
	{
		FBSTRING TMP$87$2;
		float T$2;
		T$2 = 0x1.p+0f;
		char W$2[50];
		FBSTRING* vr$1104 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1104, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$87$2, 0, 24ll );
		FBSTRING* vr$1107 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$87$2, -1ll, (void*)vr$1107, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$87$2 );
		fb_StrDelete( (FBSTRING*)&TMP$87$2 );
		char R$2[50];
		char* vr$1112 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1112, 0ll, 0 );
		int64 vr$1115 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1117 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1115 == vr$1117) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1122 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1122 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1127 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1129 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1127 != vr$1129) goto label$343;
			{
				label$344:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$88$6;
						int64 vr$1131 = fb_StrLen( (void*)W$2, 50ll );
						TMP$88$6 = vr$1131 + -1ll;
						goto label$347;
						label$350:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$352;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$345;
							}
							label$352:;
							label$351:;
						}
						label$348:;
						I$6 = I$6 + 1ll;
						label$347:;
						if( I$6 <= TMP$88$6) goto label$350;
						label$349:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$346:;
				label$345:;
			}
			label$343:;
			label$342:;
		}
	}
	{
		FBSTRING TMP$89$2;
		float T$2;
		T$2 = 0x1.8p+0f;
		char W$2[50];
		FBSTRING* vr$1140 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1140, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$89$2, 0, 24ll );
		FBSTRING* vr$1143 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$89$2, -1ll, (void*)vr$1143, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$89$2 );
		fb_StrDelete( (FBSTRING*)&TMP$89$2 );
		char R$2[50];
		char* vr$1148 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1148, 0ll, 0 );
		int64 vr$1151 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1153 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1151 == vr$1153) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1158 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1158 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1163 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1165 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1163 != vr$1165) goto label$354;
			{
				label$355:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$90$6;
						int64 vr$1167 = fb_StrLen( (void*)W$2, 50ll );
						TMP$90$6 = vr$1167 + -1ll;
						goto label$358;
						label$361:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$363;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$356;
							}
							label$363:;
							label$362:;
						}
						label$359:;
						I$6 = I$6 + 1ll;
						label$358:;
						if( I$6 <= TMP$90$6) goto label$361;
						label$360:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$357:;
				label$356:;
			}
			label$354:;
			label$353:;
		}
	}
	{
		FBSTRING TMP$91$2;
		float T$2;
		T$2 = 0x1.p+1f;
		char W$2[50];
		FBSTRING* vr$1176 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1176, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$91$2, 0, 24ll );
		FBSTRING* vr$1179 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$91$2, -1ll, (void*)vr$1179, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$91$2 );
		fb_StrDelete( (FBSTRING*)&TMP$91$2 );
		char R$2[50];
		char* vr$1184 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1184, 0ll, 0 );
		int64 vr$1187 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1189 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1187 == vr$1189) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1194 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1194 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1199 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1201 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1199 != vr$1201) goto label$365;
			{
				label$366:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$92$6;
						int64 vr$1203 = fb_StrLen( (void*)W$2, 50ll );
						TMP$92$6 = vr$1203 + -1ll;
						goto label$369;
						label$372:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$374;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$367;
							}
							label$374:;
							label$373:;
						}
						label$370:;
						I$6 = I$6 + 1ll;
						label$369:;
						if( I$6 <= TMP$92$6) goto label$372;
						label$371:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$368:;
				label$367:;
			}
			label$365:;
			label$364:;
		}
	}
	{
		FBSTRING TMP$93$2;
		float T$2;
		T$2 = 0x1.4p+1f;
		char W$2[50];
		FBSTRING* vr$1212 = fb_FloatToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1212, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$93$2, 0, 24ll );
		FBSTRING* vr$1215 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$93$2, -1ll, (void*)vr$1215, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$93$2 );
		fb_StrDelete( (FBSTRING*)&TMP$93$2 );
		char R$2[50];
		char* vr$1220 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1220, 0ll, 0 );
		int64 vr$1223 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1225 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1223 == vr$1225) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1230 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1230 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1235 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1237 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1235 != vr$1237) goto label$376;
			{
				label$377:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$94$6;
						int64 vr$1239 = fb_StrLen( (void*)W$2, 50ll );
						TMP$94$6 = vr$1239 + -1ll;
						goto label$380;
						label$383:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$385;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$378;
							}
							label$385:;
							label$384:;
						}
						label$381:;
						I$6 = I$6 + 1ll;
						label$380:;
						if( I$6 <= TMP$94$6) goto label$383;
						label$382:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$379:;
				label$378:;
			}
			label$376:;
			label$375:;
		}
	}
	{
		FBSTRING TMP$95$2;
		double T$2;
		T$2 = -0x1.8p+0;
		char W$2[50];
		FBSTRING* vr$1248 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1248, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$95$2, 0, 24ll );
		FBSTRING* vr$1251 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$95$2, -1ll, (void*)vr$1251, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$95$2 );
		fb_StrDelete( (FBSTRING*)&TMP$95$2 );
		char R$2[50];
		char* vr$1256 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1256, 0ll, 0 );
		int64 vr$1259 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1261 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1259 == vr$1261) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1266 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1266 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1271 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1273 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1271 != vr$1273) goto label$387;
			{
				label$388:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$96$6;
						int64 vr$1275 = fb_StrLen( (void*)W$2, 50ll );
						TMP$96$6 = vr$1275 + -1ll;
						goto label$391;
						label$394:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$396;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$389;
							}
							label$396:;
							label$395:;
						}
						label$392:;
						I$6 = I$6 + 1ll;
						label$391:;
						if( I$6 <= TMP$96$6) goto label$394;
						label$393:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$390:;
				label$389:;
			}
			label$387:;
			label$386:;
		}
	}
	{
		FBSTRING TMP$97$2;
		double T$2;
		T$2 = -0x1.p+0;
		char W$2[50];
		FBSTRING* vr$1284 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1284, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$97$2, 0, 24ll );
		FBSTRING* vr$1287 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$97$2, -1ll, (void*)vr$1287, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$97$2 );
		fb_StrDelete( (FBSTRING*)&TMP$97$2 );
		char R$2[50];
		char* vr$1292 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1292, 0ll, 0 );
		int64 vr$1295 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1297 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1295 == vr$1297) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1302 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1302 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1307 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1309 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1307 != vr$1309) goto label$398;
			{
				label$399:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$98$6;
						int64 vr$1311 = fb_StrLen( (void*)W$2, 50ll );
						TMP$98$6 = vr$1311 + -1ll;
						goto label$402;
						label$405:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$407;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$400;
							}
							label$407:;
							label$406:;
						}
						label$403:;
						I$6 = I$6 + 1ll;
						label$402:;
						if( I$6 <= TMP$98$6) goto label$405;
						label$404:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$401:;
				label$400:;
			}
			label$398:;
			label$397:;
		}
	}
	{
		FBSTRING TMP$99$2;
		double T$2;
		T$2 = -0x1.p+0;
		char W$2[50];
		FBSTRING* vr$1320 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1320, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$99$2, 0, 24ll );
		FBSTRING* vr$1323 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$99$2, -1ll, (void*)vr$1323, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$99$2 );
		fb_StrDelete( (FBSTRING*)&TMP$99$2 );
		char R$2[50];
		char* vr$1328 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1328, 0ll, 0 );
		int64 vr$1331 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1333 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1331 == vr$1333) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1338 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1338 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1343 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1345 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1343 != vr$1345) goto label$409;
			{
				label$410:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$100$6;
						int64 vr$1347 = fb_StrLen( (void*)W$2, 50ll );
						TMP$100$6 = vr$1347 + -1ll;
						goto label$413;
						label$416:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$418;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$411;
							}
							label$418:;
							label$417:;
						}
						label$414:;
						I$6 = I$6 + 1ll;
						label$413:;
						if( I$6 <= TMP$100$6) goto label$416;
						label$415:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$412:;
				label$411:;
			}
			label$409:;
			label$408:;
		}
	}
	{
		FBSTRING TMP$101$2;
		double T$2;
		T$2 = -0x1.p-1;
		char W$2[50];
		FBSTRING* vr$1356 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1356, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$101$2, 0, 24ll );
		FBSTRING* vr$1359 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$101$2, -1ll, (void*)vr$1359, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$101$2 );
		fb_StrDelete( (FBSTRING*)&TMP$101$2 );
		char R$2[50];
		char* vr$1364 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1364, 0ll, 0 );
		int64 vr$1367 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1369 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1367 == vr$1369) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1374 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1374 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1379 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1381 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1379 != vr$1381) goto label$420;
			{
				label$421:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$102$6;
						int64 vr$1383 = fb_StrLen( (void*)W$2, 50ll );
						TMP$102$6 = vr$1383 + -1ll;
						goto label$424;
						label$427:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$429;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$422;
							}
							label$429:;
							label$428:;
						}
						label$425:;
						I$6 = I$6 + 1ll;
						label$424:;
						if( I$6 <= TMP$102$6) goto label$427;
						label$426:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$423:;
				label$422:;
			}
			label$420:;
			label$419:;
		}
	}
	{
		FBSTRING TMP$103$2;
		double T$2;
		T$2 = 0x0p+0;
		char W$2[50];
		FBSTRING* vr$1392 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1392, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$103$2, 0, 24ll );
		FBSTRING* vr$1395 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$103$2, -1ll, (void*)vr$1395, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$103$2 );
		fb_StrDelete( (FBSTRING*)&TMP$103$2 );
		char R$2[50];
		char* vr$1400 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1400, 0ll, 0 );
		int64 vr$1403 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1405 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1403 == vr$1405) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1410 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1410 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1415 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1417 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1415 != vr$1417) goto label$431;
			{
				label$432:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$104$6;
						int64 vr$1419 = fb_StrLen( (void*)W$2, 50ll );
						TMP$104$6 = vr$1419 + -1ll;
						goto label$435;
						label$438:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$440;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$433;
							}
							label$440:;
							label$439:;
						}
						label$436:;
						I$6 = I$6 + 1ll;
						label$435:;
						if( I$6 <= TMP$104$6) goto label$438;
						label$437:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$434:;
				label$433:;
			}
			label$431:;
			label$430:;
		}
	}
	{
		FBSTRING TMP$105$2;
		double T$2;
		T$2 = 0x1.p-1;
		char W$2[50];
		FBSTRING* vr$1428 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1428, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$105$2, 0, 24ll );
		FBSTRING* vr$1431 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$105$2, -1ll, (void*)vr$1431, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$105$2 );
		fb_StrDelete( (FBSTRING*)&TMP$105$2 );
		char R$2[50];
		char* vr$1436 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1436, 0ll, 0 );
		int64 vr$1439 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1441 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1439 == vr$1441) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1446 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1446 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1451 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1453 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1451 != vr$1453) goto label$442;
			{
				label$443:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$106$6;
						int64 vr$1455 = fb_StrLen( (void*)W$2, 50ll );
						TMP$106$6 = vr$1455 + -1ll;
						goto label$446;
						label$449:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$451;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$444;
							}
							label$451:;
							label$450:;
						}
						label$447:;
						I$6 = I$6 + 1ll;
						label$446:;
						if( I$6 <= TMP$106$6) goto label$449;
						label$448:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$445:;
				label$444:;
			}
			label$442:;
			label$441:;
		}
	}
	{
		FBSTRING TMP$107$2;
		double T$2;
		T$2 = 0x1.p+0;
		char W$2[50];
		FBSTRING* vr$1464 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1464, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$107$2, 0, 24ll );
		FBSTRING* vr$1467 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$107$2, -1ll, (void*)vr$1467, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$107$2 );
		fb_StrDelete( (FBSTRING*)&TMP$107$2 );
		char R$2[50];
		char* vr$1472 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1472, 0ll, 0 );
		int64 vr$1475 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1477 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1475 == vr$1477) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1482 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1482 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1487 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1489 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1487 != vr$1489) goto label$453;
			{
				label$454:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$108$6;
						int64 vr$1491 = fb_StrLen( (void*)W$2, 50ll );
						TMP$108$6 = vr$1491 + -1ll;
						goto label$457;
						label$460:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$462;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$455;
							}
							label$462:;
							label$461:;
						}
						label$458:;
						I$6 = I$6 + 1ll;
						label$457:;
						if( I$6 <= TMP$108$6) goto label$460;
						label$459:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$456:;
				label$455:;
			}
			label$453:;
			label$452:;
		}
	}
	{
		FBSTRING TMP$109$2;
		double T$2;
		T$2 = 0x1.8p+0;
		char W$2[50];
		FBSTRING* vr$1500 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1500, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$109$2, 0, 24ll );
		FBSTRING* vr$1503 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$109$2, -1ll, (void*)vr$1503, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$109$2 );
		fb_StrDelete( (FBSTRING*)&TMP$109$2 );
		char R$2[50];
		char* vr$1508 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1508, 0ll, 0 );
		int64 vr$1511 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1513 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1511 == vr$1513) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1518 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1518 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1523 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1525 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1523 != vr$1525) goto label$464;
			{
				label$465:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$110$6;
						int64 vr$1527 = fb_StrLen( (void*)W$2, 50ll );
						TMP$110$6 = vr$1527 + -1ll;
						goto label$468;
						label$471:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$473;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$466;
							}
							label$473:;
							label$472:;
						}
						label$469:;
						I$6 = I$6 + 1ll;
						label$468:;
						if( I$6 <= TMP$110$6) goto label$471;
						label$470:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$467:;
				label$466:;
			}
			label$464:;
			label$463:;
		}
	}
	{
		FBSTRING TMP$111$2;
		double T$2;
		T$2 = 0x1.p+1;
		char W$2[50];
		FBSTRING* vr$1536 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1536, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$111$2, 0, 24ll );
		FBSTRING* vr$1539 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$111$2, -1ll, (void*)vr$1539, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$111$2 );
		fb_StrDelete( (FBSTRING*)&TMP$111$2 );
		char R$2[50];
		char* vr$1544 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1544, 0ll, 0 );
		int64 vr$1547 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1549 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1547 == vr$1549) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1554 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1554 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1559 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1561 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1559 != vr$1561) goto label$475;
			{
				label$476:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$112$6;
						int64 vr$1563 = fb_StrLen( (void*)W$2, 50ll );
						TMP$112$6 = vr$1563 + -1ll;
						goto label$479;
						label$482:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$484;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$477;
							}
							label$484:;
							label$483:;
						}
						label$480:;
						I$6 = I$6 + 1ll;
						label$479:;
						if( I$6 <= TMP$112$6) goto label$482;
						label$481:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$478:;
				label$477:;
			}
			label$475:;
			label$474:;
		}
	}
	{
		FBSTRING TMP$113$2;
		double T$2;
		T$2 = 0x1.4p+1;
		char W$2[50];
		FBSTRING* vr$1572 = fb_DoubleToStr( T$2 );
		fb_StrInit( (void*)W$2, 50ll, (void*)vr$1572, -1ll, 0 );
		struct $14UZSTRING_FIXED U$2;
		__builtin_memset( &TMP$113$2, 0, 24ll );
		FBSTRING* vr$1575 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$113$2, -1ll, (void*)vr$1575, -1ll, 0 );
		_ZN14UZSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$113$2 );
		fb_StrDelete( (FBSTRING*)&TMP$113$2 );
		char R$2[50];
		char* vr$1580 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1580, 0ll, 0 );
		int64 vr$1583 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1585 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1583 == vr$1585) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1590 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1590 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1595 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1597 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1595 != vr$1597) goto label$486;
			{
				label$487:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$114$6;
						int64 vr$1599 = fb_StrLen( (void*)W$2, 50ll );
						TMP$114$6 = vr$1599 + -1ll;
						goto label$490;
						label$493:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$495;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$488;
							}
							label$495:;
							label$494:;
						}
						label$491:;
						I$6 = I$6 + 1ll;
						label$490:;
						if( I$6 <= TMP$114$6) goto label$493;
						label$492:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$489:;
				label$488:;
			}
			label$486:;
			label$485:;
		}
	}
	label$11:;
}

void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_7DEFAULTEv( void )
{
	uint16* TMP$118$1;
	label$498:;
	char S1$1[10];
	fb_StrAssign( (void*)S1$1, 10ll, (void*)"\x0C", 2ll, 0 );
	char S2$1[10];
	fb_StrAssign( (void*)S2$1, 10ll, (void*)"\x0C", 2ll, 0 );
	char S3$1[10];
	fb_StrAssign( (void*)S3$1, 10ll, (void*)S1$1, 10ll, 0 );
	struct $14UZSTRING_FIXED U1$1;
	_ZN14UZSTRING_FIXEDC1EPKc( &U1$1, (char*)"\x0C" );
	struct $14UZSTRING_FIXED U2$1;
	_ZN14UZSTRING_FIXEDC1EPKc( &U2$1, (char*)"\x0C" );
	struct $14UZSTRING_FIXED U3$1;
	_ZN14UZSTRING_FIXEDC1EPKc( &U3$1, (char*)S1$1 );
	struct $14UZSTRING_FIXED U4$1;
	char* vr$9 = _ZN14UZSTRING_FIXEDcvcEv( &U1$1 );
	uint16* vr$10 = fb_StrToWstr( vr$9 );
	TMP$118$1 = vr$10;
	_ZN14UZSTRING_FIXEDC1EPKw( &U4$1, (uint16*)TMP$118$1 );
	fb_WstrDelete( (uint16*)TMP$118$1 );
	char S4$1[10];
	char* vr$13 = _ZN14UZSTRING_FIXEDcvcEv( &U1$1 );
	fb_StrAssign( (void*)S4$1, 10ll, (void*)vr$13, 0ll, 0 );
	char R1$1[10];
	char* vr$16 = _ZN14UZSTRING_FIXEDcvcEv( &U1$1 );
	fb_StrAssign( (void*)R1$1, 10ll, (void*)vr$16, 0ll, 0 );
	char R2$1[10];
	char* vr$19 = _ZN14UZSTRING_FIXEDcvcEv( &U2$1 );
	fb_StrAssign( (void*)R2$1, 10ll, (void*)vr$19, 0ll, 0 );
	char R3$1[10];
	char* vr$22 = _ZN14UZSTRING_FIXEDcvcEv( &U3$1 );
	fb_StrAssign( (void*)R3$1, 10ll, (void*)vr$22, 0ll, 0 );
	char R4$1[10];
	char* vr$25 = _ZN14UZSTRING_FIXEDcvcEv( &U4$1 );
	fb_StrAssign( (void*)R4$1, 10ll, (void*)vr$25, 0ll, 0 );
	int64 vr$28 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$30 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$28 == vr$30) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s1))" );
	int32 vr$35 = fb_StrCompare( (void*)S1$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$35 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s1)" );
	{
		int64 vr$40 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$42 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$40 != vr$42) goto label$501;
		{
			label$502:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$128$5;
					int64 vr$44 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$128$5 = vr$44 + -1ll;
					goto label$505;
					label$508:;
					{
						goto label$510;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$503;
						}
						label$510:;
						label$509:;
					}
					label$506:;
					I$5 = I$5 + 1ll;
					label$505:;
					if( I$5 <= TMP$128$5) goto label$508;
					label$507:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$504:;
			label$503:;
		}
		label$501:;
		label$500:;
	}
	int64 vr$48 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$50 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$48 == vr$50) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s2))" );
	int32 vr$55 = fb_StrCompare( (void*)S1$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$55 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s2)" );
	{
		int64 vr$60 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$62 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$60 != vr$62) goto label$512;
		{
			label$513:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$135$5;
					int64 vr$64 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$135$5 = vr$64 + -1ll;
					goto label$516;
					label$519:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$521;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$514;
						}
						label$521:;
						label$520:;
					}
					label$517:;
					I$5 = I$5 + 1ll;
					label$516:;
					if( I$5 <= TMP$135$5) goto label$519;
					label$518:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$515:;
			label$514:;
		}
		label$512:;
		label$511:;
	}
	int64 vr$74 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$76 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$74 == vr$76) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s3))" );
	int32 vr$81 = fb_StrCompare( (void*)S1$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$81 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s3)" );
	{
		int64 vr$86 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$88 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$86 != vr$88) goto label$523;
		{
			label$524:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$142$5;
					int64 vr$90 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$142$5 = vr$90 + -1ll;
					goto label$527;
					label$530:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$532;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$525;
						}
						label$532:;
						label$531:;
					}
					label$528:;
					I$5 = I$5 + 1ll;
					label$527:;
					if( I$5 <= TMP$142$5) goto label$530;
					label$529:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$526:;
			label$525:;
		}
		label$523:;
		label$522:;
	}
	int64 vr$100 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$102 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$100 == vr$102) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s4))" );
	int32 vr$107 = fb_StrCompare( (void*)S1$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$107 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s4)" );
	{
		int64 vr$112 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$114 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$112 != vr$114) goto label$534;
		{
			label$535:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$149$5;
					int64 vr$116 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$149$5 = vr$116 + -1ll;
					goto label$538;
					label$541:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$543;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$536;
						}
						label$543:;
						label$542:;
					}
					label$539:;
					I$5 = I$5 + 1ll;
					label$538:;
					if( I$5 <= TMP$149$5) goto label$541;
					label$540:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$537:;
			label$536:;
		}
		label$534:;
		label$533:;
	}
	int64 vr$126 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$128 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$126 == vr$128) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r1))" );
	int32 vr$133 = fb_StrCompare( (void*)S1$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$133 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r1)" );
	{
		int64 vr$138 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$140 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$138 != vr$140) goto label$545;
		{
			label$546:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$156$5;
					int64 vr$142 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$156$5 = vr$142 + -1ll;
					goto label$549;
					label$552:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$554;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$547;
						}
						label$554:;
						label$553:;
					}
					label$550:;
					I$5 = I$5 + 1ll;
					label$549:;
					if( I$5 <= TMP$156$5) goto label$552;
					label$551:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$548:;
			label$547:;
		}
		label$545:;
		label$544:;
	}
	int64 vr$152 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$154 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$152 == vr$154) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r2))" );
	int32 vr$159 = fb_StrCompare( (void*)S1$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$159 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r2)" );
	{
		int64 vr$164 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$166 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$164 != vr$166) goto label$556;
		{
			label$557:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$163$5;
					int64 vr$168 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$163$5 = vr$168 + -1ll;
					goto label$560;
					label$563:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$565;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$558;
						}
						label$565:;
						label$564:;
					}
					label$561:;
					I$5 = I$5 + 1ll;
					label$560:;
					if( I$5 <= TMP$163$5) goto label$563;
					label$562:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$559:;
			label$558:;
		}
		label$556:;
		label$555:;
	}
	int64 vr$178 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$180 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$178 == vr$180) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r3))" );
	int32 vr$185 = fb_StrCompare( (void*)S1$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$185 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r3)" );
	{
		int64 vr$190 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$192 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$190 != vr$192) goto label$567;
		{
			label$568:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$170$5;
					int64 vr$194 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$170$5 = vr$194 + -1ll;
					goto label$571;
					label$574:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$576;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$569;
						}
						label$576:;
						label$575:;
					}
					label$572:;
					I$5 = I$5 + 1ll;
					label$571:;
					if( I$5 <= TMP$170$5) goto label$574;
					label$573:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$570:;
			label$569:;
		}
		label$567:;
		label$566:;
	}
	int64 vr$204 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$206 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$204 == vr$206) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r4))" );
	int32 vr$211 = fb_StrCompare( (void*)S1$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$211 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r4)" );
	{
		int64 vr$216 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$218 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$216 != vr$218) goto label$578;
		{
			label$579:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$177$5;
					int64 vr$220 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$177$5 = vr$220 + -1ll;
					goto label$582;
					label$585:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$587;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$580;
						}
						label$587:;
						label$586:;
					}
					label$583:;
					I$5 = I$5 + 1ll;
					label$582:;
					if( I$5 <= TMP$177$5) goto label$585;
					label$584:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$581:;
			label$580:;
		}
		label$578:;
		label$577:;
	}
	int64 vr$230 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$232 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$230 == vr$232) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s1))" );
	int32 vr$237 = fb_StrCompare( (void*)S2$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$237 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s1)" );
	{
		int64 vr$242 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$244 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$242 != vr$244) goto label$589;
		{
			label$590:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$185$5;
					int64 vr$246 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$185$5 = vr$246 + -1ll;
					goto label$593;
					label$596:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$598;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$591;
						}
						label$598:;
						label$597:;
					}
					label$594:;
					I$5 = I$5 + 1ll;
					label$593:;
					if( I$5 <= TMP$185$5) goto label$596;
					label$595:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$592:;
			label$591:;
		}
		label$589:;
		label$588:;
	}
	int64 vr$256 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$258 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$256 == vr$258) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s2))" );
	int32 vr$263 = fb_StrCompare( (void*)S2$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$263 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s2)" );
	{
		int64 vr$268 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$270 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$268 != vr$270) goto label$600;
		{
			label$601:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$191$5;
					int64 vr$272 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$191$5 = vr$272 + -1ll;
					goto label$604;
					label$607:;
					{
						goto label$609;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$602;
						}
						label$609:;
						label$608:;
					}
					label$605:;
					I$5 = I$5 + 1ll;
					label$604:;
					if( I$5 <= TMP$191$5) goto label$607;
					label$606:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$603:;
			label$602:;
		}
		label$600:;
		label$599:;
	}
	int64 vr$276 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$278 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$276 == vr$278) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s3))" );
	int32 vr$283 = fb_StrCompare( (void*)S2$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$283 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s3)" );
	{
		int64 vr$288 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$290 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$288 != vr$290) goto label$611;
		{
			label$612:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$197$5;
					int64 vr$292 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$197$5 = vr$292 + -1ll;
					goto label$615;
					label$618:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$620;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$613;
						}
						label$620:;
						label$619:;
					}
					label$616:;
					I$5 = I$5 + 1ll;
					label$615:;
					if( I$5 <= TMP$197$5) goto label$618;
					label$617:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$614:;
			label$613:;
		}
		label$611:;
		label$610:;
	}
	int64 vr$302 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$304 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$302 == vr$304) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s4))" );
	int32 vr$309 = fb_StrCompare( (void*)S2$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$309 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s4)" );
	{
		int64 vr$314 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$316 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$314 != vr$316) goto label$622;
		{
			label$623:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$203$5;
					int64 vr$318 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$203$5 = vr$318 + -1ll;
					goto label$626;
					label$629:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$631;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$624;
						}
						label$631:;
						label$630:;
					}
					label$627:;
					I$5 = I$5 + 1ll;
					label$626:;
					if( I$5 <= TMP$203$5) goto label$629;
					label$628:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$625:;
			label$624:;
		}
		label$622:;
		label$621:;
	}
	int64 vr$328 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$330 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$328 == vr$330) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r1))" );
	int32 vr$335 = fb_StrCompare( (void*)S2$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$335 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r1)" );
	{
		int64 vr$340 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$342 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$340 != vr$342) goto label$633;
		{
			label$634:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$209$5;
					int64 vr$344 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$209$5 = vr$344 + -1ll;
					goto label$637;
					label$640:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$642;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$635;
						}
						label$642:;
						label$641:;
					}
					label$638:;
					I$5 = I$5 + 1ll;
					label$637:;
					if( I$5 <= TMP$209$5) goto label$640;
					label$639:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$636:;
			label$635:;
		}
		label$633:;
		label$632:;
	}
	int64 vr$354 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$356 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$354 == vr$356) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r2))" );
	int32 vr$361 = fb_StrCompare( (void*)S2$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$361 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r2)" );
	{
		int64 vr$366 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$368 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$366 != vr$368) goto label$644;
		{
			label$645:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$215$5;
					int64 vr$370 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$215$5 = vr$370 + -1ll;
					goto label$648;
					label$651:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$653;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$646;
						}
						label$653:;
						label$652:;
					}
					label$649:;
					I$5 = I$5 + 1ll;
					label$648:;
					if( I$5 <= TMP$215$5) goto label$651;
					label$650:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$647:;
			label$646:;
		}
		label$644:;
		label$643:;
	}
	int64 vr$380 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$382 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$380 == vr$382) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r3))" );
	int32 vr$387 = fb_StrCompare( (void*)S2$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$387 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r3)" );
	{
		int64 vr$392 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$394 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$392 != vr$394) goto label$655;
		{
			label$656:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$221$5;
					int64 vr$396 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$221$5 = vr$396 + -1ll;
					goto label$659;
					label$662:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$664;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$657;
						}
						label$664:;
						label$663:;
					}
					label$660:;
					I$5 = I$5 + 1ll;
					label$659:;
					if( I$5 <= TMP$221$5) goto label$662;
					label$661:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$658:;
			label$657:;
		}
		label$655:;
		label$654:;
	}
	int64 vr$406 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$408 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$406 == vr$408) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r4))" );
	int32 vr$413 = fb_StrCompare( (void*)S2$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$413 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r4)" );
	{
		int64 vr$418 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$420 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$418 != vr$420) goto label$666;
		{
			label$667:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$227$5;
					int64 vr$422 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$227$5 = vr$422 + -1ll;
					goto label$670;
					label$673:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$675;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$668;
						}
						label$675:;
						label$674:;
					}
					label$671:;
					I$5 = I$5 + 1ll;
					label$670:;
					if( I$5 <= TMP$227$5) goto label$673;
					label$672:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$669:;
			label$668:;
		}
		label$666:;
		label$665:;
	}
	int64 vr$432 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$434 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$432 == vr$434) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s1))" );
	int32 vr$439 = fb_StrCompare( (void*)S3$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$439 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s1)" );
	{
		int64 vr$444 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$446 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$444 != vr$446) goto label$677;
		{
			label$678:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$235$5;
					int64 vr$448 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$235$5 = vr$448 + -1ll;
					goto label$681;
					label$684:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$686;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$679;
						}
						label$686:;
						label$685:;
					}
					label$682:;
					I$5 = I$5 + 1ll;
					label$681:;
					if( I$5 <= TMP$235$5) goto label$684;
					label$683:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$680:;
			label$679:;
		}
		label$677:;
		label$676:;
	}
	int64 vr$458 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$460 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$458 == vr$460) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s2))" );
	int32 vr$465 = fb_StrCompare( (void*)S3$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$465 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s2)" );
	{
		int64 vr$470 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$472 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$470 != vr$472) goto label$688;
		{
			label$689:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$241$5;
					int64 vr$474 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$241$5 = vr$474 + -1ll;
					goto label$692;
					label$695:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$697;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$690;
						}
						label$697:;
						label$696:;
					}
					label$693:;
					I$5 = I$5 + 1ll;
					label$692:;
					if( I$5 <= TMP$241$5) goto label$695;
					label$694:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$691:;
			label$690:;
		}
		label$688:;
		label$687:;
	}
	int64 vr$484 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$486 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$484 == vr$486) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s3))" );
	int32 vr$491 = fb_StrCompare( (void*)S3$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$491 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s3)" );
	{
		int64 vr$496 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$498 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$496 != vr$498) goto label$699;
		{
			label$700:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$247$5;
					int64 vr$500 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$247$5 = vr$500 + -1ll;
					goto label$703;
					label$706:;
					{
						goto label$708;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$701;
						}
						label$708:;
						label$707:;
					}
					label$704:;
					I$5 = I$5 + 1ll;
					label$703:;
					if( I$5 <= TMP$247$5) goto label$706;
					label$705:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$702:;
			label$701:;
		}
		label$699:;
		label$698:;
	}
	int64 vr$504 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$506 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$504 == vr$506) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s4))" );
	int32 vr$511 = fb_StrCompare( (void*)S3$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$511 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s4)" );
	{
		int64 vr$516 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$518 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$516 != vr$518) goto label$710;
		{
			label$711:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$253$5;
					int64 vr$520 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$253$5 = vr$520 + -1ll;
					goto label$714;
					label$717:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$719;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$712;
						}
						label$719:;
						label$718:;
					}
					label$715:;
					I$5 = I$5 + 1ll;
					label$714:;
					if( I$5 <= TMP$253$5) goto label$717;
					label$716:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$713:;
			label$712:;
		}
		label$710:;
		label$709:;
	}
	int64 vr$530 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$532 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$530 == vr$532) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r1))" );
	int32 vr$537 = fb_StrCompare( (void*)S3$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$537 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r1)" );
	{
		int64 vr$542 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$544 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$542 != vr$544) goto label$721;
		{
			label$722:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$259$5;
					int64 vr$546 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$259$5 = vr$546 + -1ll;
					goto label$725;
					label$728:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$730;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$723;
						}
						label$730:;
						label$729:;
					}
					label$726:;
					I$5 = I$5 + 1ll;
					label$725:;
					if( I$5 <= TMP$259$5) goto label$728;
					label$727:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$724:;
			label$723:;
		}
		label$721:;
		label$720:;
	}
	int64 vr$556 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$558 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$556 == vr$558) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r2))" );
	int32 vr$563 = fb_StrCompare( (void*)S3$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$563 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r2)" );
	{
		int64 vr$568 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$570 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$568 != vr$570) goto label$732;
		{
			label$733:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$265$5;
					int64 vr$572 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$265$5 = vr$572 + -1ll;
					goto label$736;
					label$739:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$741;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$734;
						}
						label$741:;
						label$740:;
					}
					label$737:;
					I$5 = I$5 + 1ll;
					label$736:;
					if( I$5 <= TMP$265$5) goto label$739;
					label$738:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$735:;
			label$734:;
		}
		label$732:;
		label$731:;
	}
	int64 vr$582 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$584 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$582 == vr$584) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r3))" );
	int32 vr$589 = fb_StrCompare( (void*)S3$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$589 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r3)" );
	{
		int64 vr$594 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$596 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$594 != vr$596) goto label$743;
		{
			label$744:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$271$5;
					int64 vr$598 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$271$5 = vr$598 + -1ll;
					goto label$747;
					label$750:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$752;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$745;
						}
						label$752:;
						label$751:;
					}
					label$748:;
					I$5 = I$5 + 1ll;
					label$747:;
					if( I$5 <= TMP$271$5) goto label$750;
					label$749:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$746:;
			label$745:;
		}
		label$743:;
		label$742:;
	}
	int64 vr$608 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$610 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$608 == vr$610) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r4))" );
	int32 vr$615 = fb_StrCompare( (void*)S3$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$615 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r4)" );
	{
		int64 vr$620 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$622 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$620 != vr$622) goto label$754;
		{
			label$755:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$277$5;
					int64 vr$624 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$277$5 = vr$624 + -1ll;
					goto label$758;
					label$761:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$763;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$756;
						}
						label$763:;
						label$762:;
					}
					label$759:;
					I$5 = I$5 + 1ll;
					label$758:;
					if( I$5 <= TMP$277$5) goto label$761;
					label$760:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$757:;
			label$756:;
		}
		label$754:;
		label$753:;
	}
	int64 vr$634 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$636 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$634 == vr$636) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s1))" );
	int32 vr$641 = fb_StrCompare( (void*)S4$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$641 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s1)" );
	{
		int64 vr$646 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$648 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$646 != vr$648) goto label$765;
		{
			label$766:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$285$5;
					int64 vr$650 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$285$5 = vr$650 + -1ll;
					goto label$769;
					label$772:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$774;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$767;
						}
						label$774:;
						label$773:;
					}
					label$770:;
					I$5 = I$5 + 1ll;
					label$769:;
					if( I$5 <= TMP$285$5) goto label$772;
					label$771:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$768:;
			label$767:;
		}
		label$765:;
		label$764:;
	}
	int64 vr$660 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$662 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$660 == vr$662) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s2))" );
	int32 vr$667 = fb_StrCompare( (void*)S4$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$667 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s2)" );
	{
		int64 vr$672 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$674 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$672 != vr$674) goto label$776;
		{
			label$777:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$291$5;
					int64 vr$676 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$291$5 = vr$676 + -1ll;
					goto label$780;
					label$783:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$785;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$778;
						}
						label$785:;
						label$784:;
					}
					label$781:;
					I$5 = I$5 + 1ll;
					label$780:;
					if( I$5 <= TMP$291$5) goto label$783;
					label$782:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$779:;
			label$778:;
		}
		label$776:;
		label$775:;
	}
	int64 vr$686 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$688 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$686 == vr$688) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s3))" );
	int32 vr$693 = fb_StrCompare( (void*)S4$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$693 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s3)" );
	{
		int64 vr$698 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$700 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$698 != vr$700) goto label$787;
		{
			label$788:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$297$5;
					int64 vr$702 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$297$5 = vr$702 + -1ll;
					goto label$791;
					label$794:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$796;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$789;
						}
						label$796:;
						label$795:;
					}
					label$792:;
					I$5 = I$5 + 1ll;
					label$791:;
					if( I$5 <= TMP$297$5) goto label$794;
					label$793:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$790:;
			label$789:;
		}
		label$787:;
		label$786:;
	}
	int64 vr$712 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$714 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$712 == vr$714) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s4))" );
	int32 vr$719 = fb_StrCompare( (void*)S4$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$719 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s4)" );
	{
		int64 vr$724 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$726 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$724 != vr$726) goto label$798;
		{
			label$799:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$303$5;
					int64 vr$728 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$303$5 = vr$728 + -1ll;
					goto label$802;
					label$805:;
					{
						goto label$807;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$800;
						}
						label$807:;
						label$806:;
					}
					label$803:;
					I$5 = I$5 + 1ll;
					label$802:;
					if( I$5 <= TMP$303$5) goto label$805;
					label$804:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$801:;
			label$800:;
		}
		label$798:;
		label$797:;
	}
	int64 vr$732 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$734 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$732 == vr$734) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r1))" );
	int32 vr$739 = fb_StrCompare( (void*)S4$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$739 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r1)" );
	{
		int64 vr$744 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$746 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$744 != vr$746) goto label$809;
		{
			label$810:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$309$5;
					int64 vr$748 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$309$5 = vr$748 + -1ll;
					goto label$813;
					label$816:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$818;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$811;
						}
						label$818:;
						label$817:;
					}
					label$814:;
					I$5 = I$5 + 1ll;
					label$813:;
					if( I$5 <= TMP$309$5) goto label$816;
					label$815:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$812:;
			label$811:;
		}
		label$809:;
		label$808:;
	}
	int64 vr$758 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$760 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$758 == vr$760) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r2))" );
	int32 vr$765 = fb_StrCompare( (void*)S4$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$765 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r2)" );
	{
		int64 vr$770 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$772 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$770 != vr$772) goto label$820;
		{
			label$821:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$315$5;
					int64 vr$774 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$315$5 = vr$774 + -1ll;
					goto label$824;
					label$827:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$829;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$822;
						}
						label$829:;
						label$828:;
					}
					label$825:;
					I$5 = I$5 + 1ll;
					label$824:;
					if( I$5 <= TMP$315$5) goto label$827;
					label$826:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$823:;
			label$822:;
		}
		label$820:;
		label$819:;
	}
	int64 vr$784 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$786 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$784 == vr$786) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r3))" );
	int32 vr$791 = fb_StrCompare( (void*)S4$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$791 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r3)" );
	{
		int64 vr$796 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$798 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$796 != vr$798) goto label$831;
		{
			label$832:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$321$5;
					int64 vr$800 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$321$5 = vr$800 + -1ll;
					goto label$835;
					label$838:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$840;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$833;
						}
						label$840:;
						label$839:;
					}
					label$836:;
					I$5 = I$5 + 1ll;
					label$835:;
					if( I$5 <= TMP$321$5) goto label$838;
					label$837:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$834:;
			label$833:;
		}
		label$831:;
		label$830:;
	}
	int64 vr$810 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$812 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$810 == vr$812) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r4))" );
	int32 vr$817 = fb_StrCompare( (void*)S4$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$817 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r4)" );
	{
		int64 vr$822 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$824 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$822 != vr$824) goto label$842;
		{
			label$843:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$327$5;
					int64 vr$826 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$327$5 = vr$826 + -1ll;
					goto label$846;
					label$849:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$851;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$844;
						}
						label$851:;
						label$850:;
					}
					label$847:;
					I$5 = I$5 + 1ll;
					label$846:;
					if( I$5 <= TMP$327$5) goto label$849;
					label$848:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$845:;
			label$844:;
		}
		label$842:;
		label$841:;
	}
	int64 vr$836 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$838 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$836 == vr$838) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s1))" );
	int32 vr$843 = fb_StrCompare( (void*)R1$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$843 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s1)" );
	{
		int64 vr$848 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$850 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$848 != vr$850) goto label$853;
		{
			label$854:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$335$5;
					int64 vr$852 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$335$5 = vr$852 + -1ll;
					goto label$857;
					label$860:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$862;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$855;
						}
						label$862:;
						label$861:;
					}
					label$858:;
					I$5 = I$5 + 1ll;
					label$857:;
					if( I$5 <= TMP$335$5) goto label$860;
					label$859:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$856:;
			label$855:;
		}
		label$853:;
		label$852:;
	}
	int64 vr$862 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$864 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$862 == vr$864) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s2))" );
	int32 vr$869 = fb_StrCompare( (void*)R1$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$869 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s2)" );
	{
		int64 vr$874 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$876 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$874 != vr$876) goto label$864;
		{
			label$865:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$341$5;
					int64 vr$878 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$341$5 = vr$878 + -1ll;
					goto label$868;
					label$871:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$873;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$866;
						}
						label$873:;
						label$872:;
					}
					label$869:;
					I$5 = I$5 + 1ll;
					label$868:;
					if( I$5 <= TMP$341$5) goto label$871;
					label$870:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$867:;
			label$866:;
		}
		label$864:;
		label$863:;
	}
	int64 vr$888 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$890 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$888 == vr$890) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s3))" );
	int32 vr$895 = fb_StrCompare( (void*)R1$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$895 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s3)" );
	{
		int64 vr$900 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$902 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$900 != vr$902) goto label$875;
		{
			label$876:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$347$5;
					int64 vr$904 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$347$5 = vr$904 + -1ll;
					goto label$879;
					label$882:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$884;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$877;
						}
						label$884:;
						label$883:;
					}
					label$880:;
					I$5 = I$5 + 1ll;
					label$879:;
					if( I$5 <= TMP$347$5) goto label$882;
					label$881:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$878:;
			label$877:;
		}
		label$875:;
		label$874:;
	}
	int64 vr$914 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$916 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$914 == vr$916) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s4))" );
	int32 vr$921 = fb_StrCompare( (void*)R1$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$921 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s4)" );
	{
		int64 vr$926 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$928 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$926 != vr$928) goto label$886;
		{
			label$887:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$353$5;
					int64 vr$930 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$353$5 = vr$930 + -1ll;
					goto label$890;
					label$893:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$895;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$888;
						}
						label$895:;
						label$894:;
					}
					label$891:;
					I$5 = I$5 + 1ll;
					label$890:;
					if( I$5 <= TMP$353$5) goto label$893;
					label$892:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$889:;
			label$888:;
		}
		label$886:;
		label$885:;
	}
	int64 vr$940 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$942 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$940 == vr$942) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r1))" );
	int32 vr$947 = fb_StrCompare( (void*)R1$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$947 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r1)" );
	{
		int64 vr$952 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$954 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$952 != vr$954) goto label$897;
		{
			label$898:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$359$5;
					int64 vr$956 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$359$5 = vr$956 + -1ll;
					goto label$901;
					label$904:;
					{
						goto label$906;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$899;
						}
						label$906:;
						label$905:;
					}
					label$902:;
					I$5 = I$5 + 1ll;
					label$901:;
					if( I$5 <= TMP$359$5) goto label$904;
					label$903:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$900:;
			label$899:;
		}
		label$897:;
		label$896:;
	}
	int64 vr$960 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$962 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$960 == vr$962) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r2))" );
	int32 vr$967 = fb_StrCompare( (void*)R1$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$967 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r2)" );
	{
		int64 vr$972 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$974 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$972 != vr$974) goto label$908;
		{
			label$909:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$365$5;
					int64 vr$976 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$365$5 = vr$976 + -1ll;
					goto label$912;
					label$915:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$917;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$910;
						}
						label$917:;
						label$916:;
					}
					label$913:;
					I$5 = I$5 + 1ll;
					label$912:;
					if( I$5 <= TMP$365$5) goto label$915;
					label$914:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$911:;
			label$910:;
		}
		label$908:;
		label$907:;
	}
	int64 vr$986 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$988 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$986 == vr$988) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r3))" );
	int32 vr$993 = fb_StrCompare( (void*)R1$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$993 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r3)" );
	{
		int64 vr$998 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$1000 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$998 != vr$1000) goto label$919;
		{
			label$920:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$371$5;
					int64 vr$1002 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$371$5 = vr$1002 + -1ll;
					goto label$923;
					label$926:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$928;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$921;
						}
						label$928:;
						label$927:;
					}
					label$924:;
					I$5 = I$5 + 1ll;
					label$923:;
					if( I$5 <= TMP$371$5) goto label$926;
					label$925:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$922:;
			label$921:;
		}
		label$919:;
		label$918:;
	}
	int64 vr$1012 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$1014 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1012 == vr$1014) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r4))" );
	int32 vr$1019 = fb_StrCompare( (void*)R1$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1019 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r4)" );
	{
		int64 vr$1024 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$1026 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$1024 != vr$1026) goto label$930;
		{
			label$931:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$377$5;
					int64 vr$1028 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$377$5 = vr$1028 + -1ll;
					goto label$934;
					label$937:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$939;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$932;
						}
						label$939:;
						label$938:;
					}
					label$935:;
					I$5 = I$5 + 1ll;
					label$934:;
					if( I$5 <= TMP$377$5) goto label$937;
					label$936:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$933:;
			label$932:;
		}
		label$930:;
		label$929:;
	}
	int64 vr$1038 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1040 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1038 == vr$1040) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s1))" );
	int32 vr$1045 = fb_StrCompare( (void*)R2$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1045 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s1)" );
	{
		int64 vr$1050 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1052 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$1050 != vr$1052) goto label$941;
		{
			label$942:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$385$5;
					int64 vr$1054 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$385$5 = vr$1054 + -1ll;
					goto label$945;
					label$948:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$950;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$943;
						}
						label$950:;
						label$949:;
					}
					label$946:;
					I$5 = I$5 + 1ll;
					label$945:;
					if( I$5 <= TMP$385$5) goto label$948;
					label$947:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$944:;
			label$943:;
		}
		label$941:;
		label$940:;
	}
	int64 vr$1064 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1066 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1064 == vr$1066) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s2))" );
	int32 vr$1071 = fb_StrCompare( (void*)R2$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1071 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s2)" );
	{
		int64 vr$1076 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1078 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$1076 != vr$1078) goto label$952;
		{
			label$953:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$391$5;
					int64 vr$1080 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$391$5 = vr$1080 + -1ll;
					goto label$956;
					label$959:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$961;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$954;
						}
						label$961:;
						label$960:;
					}
					label$957:;
					I$5 = I$5 + 1ll;
					label$956:;
					if( I$5 <= TMP$391$5) goto label$959;
					label$958:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$955:;
			label$954:;
		}
		label$952:;
		label$951:;
	}
	int64 vr$1090 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1092 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1090 == vr$1092) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s3))" );
	int32 vr$1097 = fb_StrCompare( (void*)R2$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1097 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s3)" );
	{
		int64 vr$1102 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1104 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$1102 != vr$1104) goto label$963;
		{
			label$964:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$397$5;
					int64 vr$1106 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$397$5 = vr$1106 + -1ll;
					goto label$967;
					label$970:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$972;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$965;
						}
						label$972:;
						label$971:;
					}
					label$968:;
					I$5 = I$5 + 1ll;
					label$967:;
					if( I$5 <= TMP$397$5) goto label$970;
					label$969:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$966:;
			label$965:;
		}
		label$963:;
		label$962:;
	}
	int64 vr$1116 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1118 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1116 == vr$1118) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s4))" );
	int32 vr$1123 = fb_StrCompare( (void*)R2$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1123 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s4)" );
	{
		int64 vr$1128 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1130 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$1128 != vr$1130) goto label$974;
		{
			label$975:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$403$5;
					int64 vr$1132 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$403$5 = vr$1132 + -1ll;
					goto label$978;
					label$981:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$983;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$976;
						}
						label$983:;
						label$982:;
					}
					label$979:;
					I$5 = I$5 + 1ll;
					label$978:;
					if( I$5 <= TMP$403$5) goto label$981;
					label$980:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$977:;
			label$976:;
		}
		label$974:;
		label$973:;
	}
	int64 vr$1142 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1144 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1142 == vr$1144) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r1))" );
	int32 vr$1149 = fb_StrCompare( (void*)R2$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1149 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r1)" );
	{
		int64 vr$1154 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1156 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$1154 != vr$1156) goto label$985;
		{
			label$986:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$409$5;
					int64 vr$1158 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$409$5 = vr$1158 + -1ll;
					goto label$989;
					label$992:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$994;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$987;
						}
						label$994:;
						label$993:;
					}
					label$990:;
					I$5 = I$5 + 1ll;
					label$989:;
					if( I$5 <= TMP$409$5) goto label$992;
					label$991:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$988:;
			label$987:;
		}
		label$985:;
		label$984:;
	}
	int64 vr$1168 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1170 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1168 == vr$1170) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r2))" );
	int32 vr$1175 = fb_StrCompare( (void*)R2$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1175 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r2)" );
	{
		int64 vr$1180 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1182 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$1180 != vr$1182) goto label$996;
		{
			label$997:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$415$5;
					int64 vr$1184 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$415$5 = vr$1184 + -1ll;
					goto label$1000;
					label$1003:;
					{
						goto label$1005;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$998;
						}
						label$1005:;
						label$1004:;
					}
					label$1001:;
					I$5 = I$5 + 1ll;
					label$1000:;
					if( I$5 <= TMP$415$5) goto label$1003;
					label$1002:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$999:;
			label$998:;
		}
		label$996:;
		label$995:;
	}
	int64 vr$1188 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1190 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1188 == vr$1190) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r3))" );
	int32 vr$1195 = fb_StrCompare( (void*)R2$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1195 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r3)" );
	{
		int64 vr$1200 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1202 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$1200 != vr$1202) goto label$1007;
		{
			label$1008:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$421$5;
					int64 vr$1204 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$421$5 = vr$1204 + -1ll;
					goto label$1011;
					label$1014:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$1016;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1009;
						}
						label$1016:;
						label$1015:;
					}
					label$1012:;
					I$5 = I$5 + 1ll;
					label$1011:;
					if( I$5 <= TMP$421$5) goto label$1014;
					label$1013:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1010:;
			label$1009:;
		}
		label$1007:;
		label$1006:;
	}
	int64 vr$1214 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1216 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1214 == vr$1216) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r4))" );
	int32 vr$1221 = fb_StrCompare( (void*)R2$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1221 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r4)" );
	{
		int64 vr$1226 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1228 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$1226 != vr$1228) goto label$1018;
		{
			label$1019:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$427$5;
					int64 vr$1230 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$427$5 = vr$1230 + -1ll;
					goto label$1022;
					label$1025:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$1027;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1020;
						}
						label$1027:;
						label$1026:;
					}
					label$1023:;
					I$5 = I$5 + 1ll;
					label$1022:;
					if( I$5 <= TMP$427$5) goto label$1025;
					label$1024:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1021:;
			label$1020:;
		}
		label$1018:;
		label$1017:;
	}
	int64 vr$1240 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1242 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1240 == vr$1242) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s1))" );
	int32 vr$1247 = fb_StrCompare( (void*)R3$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1247 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s1)" );
	{
		int64 vr$1252 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1254 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$1252 != vr$1254) goto label$1029;
		{
			label$1030:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$435$5;
					int64 vr$1256 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$435$5 = vr$1256 + -1ll;
					goto label$1033;
					label$1036:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$1038;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1031;
						}
						label$1038:;
						label$1037:;
					}
					label$1034:;
					I$5 = I$5 + 1ll;
					label$1033:;
					if( I$5 <= TMP$435$5) goto label$1036;
					label$1035:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1032:;
			label$1031:;
		}
		label$1029:;
		label$1028:;
	}
	int64 vr$1266 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1268 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1266 == vr$1268) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s2))" );
	int32 vr$1273 = fb_StrCompare( (void*)R3$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1273 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s2)" );
	{
		int64 vr$1278 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1280 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$1278 != vr$1280) goto label$1040;
		{
			label$1041:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$441$5;
					int64 vr$1282 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$441$5 = vr$1282 + -1ll;
					goto label$1044;
					label$1047:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$1049;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1042;
						}
						label$1049:;
						label$1048:;
					}
					label$1045:;
					I$5 = I$5 + 1ll;
					label$1044:;
					if( I$5 <= TMP$441$5) goto label$1047;
					label$1046:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1043:;
			label$1042:;
		}
		label$1040:;
		label$1039:;
	}
	int64 vr$1292 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1294 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1292 == vr$1294) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s3))" );
	int32 vr$1299 = fb_StrCompare( (void*)R3$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1299 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s3)" );
	{
		int64 vr$1304 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1306 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$1304 != vr$1306) goto label$1051;
		{
			label$1052:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$447$5;
					int64 vr$1308 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$447$5 = vr$1308 + -1ll;
					goto label$1055;
					label$1058:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$1060;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1053;
						}
						label$1060:;
						label$1059:;
					}
					label$1056:;
					I$5 = I$5 + 1ll;
					label$1055:;
					if( I$5 <= TMP$447$5) goto label$1058;
					label$1057:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1054:;
			label$1053:;
		}
		label$1051:;
		label$1050:;
	}
	int64 vr$1318 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1320 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1318 == vr$1320) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s4))" );
	int32 vr$1325 = fb_StrCompare( (void*)R3$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1325 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s4)" );
	{
		int64 vr$1330 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1332 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$1330 != vr$1332) goto label$1062;
		{
			label$1063:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$453$5;
					int64 vr$1334 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$453$5 = vr$1334 + -1ll;
					goto label$1066;
					label$1069:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$1071;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1064;
						}
						label$1071:;
						label$1070:;
					}
					label$1067:;
					I$5 = I$5 + 1ll;
					label$1066:;
					if( I$5 <= TMP$453$5) goto label$1069;
					label$1068:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1065:;
			label$1064:;
		}
		label$1062:;
		label$1061:;
	}
	int64 vr$1344 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1346 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1344 == vr$1346) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r1))" );
	int32 vr$1351 = fb_StrCompare( (void*)R3$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1351 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r1)" );
	{
		int64 vr$1356 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1358 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$1356 != vr$1358) goto label$1073;
		{
			label$1074:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$459$5;
					int64 vr$1360 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$459$5 = vr$1360 + -1ll;
					goto label$1077;
					label$1080:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$1082;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1075;
						}
						label$1082:;
						label$1081:;
					}
					label$1078:;
					I$5 = I$5 + 1ll;
					label$1077:;
					if( I$5 <= TMP$459$5) goto label$1080;
					label$1079:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1076:;
			label$1075:;
		}
		label$1073:;
		label$1072:;
	}
	int64 vr$1370 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1372 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1370 == vr$1372) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r2))" );
	int32 vr$1377 = fb_StrCompare( (void*)R3$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1377 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r2)" );
	{
		int64 vr$1382 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1384 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$1382 != vr$1384) goto label$1084;
		{
			label$1085:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$465$5;
					int64 vr$1386 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$465$5 = vr$1386 + -1ll;
					goto label$1088;
					label$1091:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$1093;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1086;
						}
						label$1093:;
						label$1092:;
					}
					label$1089:;
					I$5 = I$5 + 1ll;
					label$1088:;
					if( I$5 <= TMP$465$5) goto label$1091;
					label$1090:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1087:;
			label$1086:;
		}
		label$1084:;
		label$1083:;
	}
	int64 vr$1396 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1398 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1396 == vr$1398) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r3))" );
	int32 vr$1403 = fb_StrCompare( (void*)R3$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1403 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r3)" );
	{
		int64 vr$1408 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1410 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$1408 != vr$1410) goto label$1095;
		{
			label$1096:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$471$5;
					int64 vr$1412 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$471$5 = vr$1412 + -1ll;
					goto label$1099;
					label$1102:;
					{
						goto label$1104;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1097;
						}
						label$1104:;
						label$1103:;
					}
					label$1100:;
					I$5 = I$5 + 1ll;
					label$1099:;
					if( I$5 <= TMP$471$5) goto label$1102;
					label$1101:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1098:;
			label$1097:;
		}
		label$1095:;
		label$1094:;
	}
	int64 vr$1416 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1418 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1416 == vr$1418) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r4))" );
	int32 vr$1423 = fb_StrCompare( (void*)R3$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1423 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r4)" );
	{
		int64 vr$1428 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1430 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$1428 != vr$1430) goto label$1106;
		{
			label$1107:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$477$5;
					int64 vr$1432 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$477$5 = vr$1432 + -1ll;
					goto label$1110;
					label$1113:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$1115;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1108;
						}
						label$1115:;
						label$1114:;
					}
					label$1111:;
					I$5 = I$5 + 1ll;
					label$1110:;
					if( I$5 <= TMP$477$5) goto label$1113;
					label$1112:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1109:;
			label$1108:;
		}
		label$1106:;
		label$1105:;
	}
	int64 vr$1442 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1444 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1442 == vr$1444) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s1))" );
	int32 vr$1449 = fb_StrCompare( (void*)R4$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1449 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s1)" );
	{
		int64 vr$1454 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1456 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$1454 != vr$1456) goto label$1117;
		{
			label$1118:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$485$5;
					int64 vr$1458 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$485$5 = vr$1458 + -1ll;
					goto label$1121;
					label$1124:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$1126;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1119;
						}
						label$1126:;
						label$1125:;
					}
					label$1122:;
					I$5 = I$5 + 1ll;
					label$1121:;
					if( I$5 <= TMP$485$5) goto label$1124;
					label$1123:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1120:;
			label$1119:;
		}
		label$1117:;
		label$1116:;
	}
	int64 vr$1468 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1470 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1468 == vr$1470) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s2))" );
	int32 vr$1475 = fb_StrCompare( (void*)R4$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1475 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s2)" );
	{
		int64 vr$1480 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1482 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$1480 != vr$1482) goto label$1128;
		{
			label$1129:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$491$5;
					int64 vr$1484 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$491$5 = vr$1484 + -1ll;
					goto label$1132;
					label$1135:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$1137;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1130;
						}
						label$1137:;
						label$1136:;
					}
					label$1133:;
					I$5 = I$5 + 1ll;
					label$1132:;
					if( I$5 <= TMP$491$5) goto label$1135;
					label$1134:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1131:;
			label$1130:;
		}
		label$1128:;
		label$1127:;
	}
	int64 vr$1494 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1496 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1494 == vr$1496) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s3))" );
	int32 vr$1501 = fb_StrCompare( (void*)R4$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1501 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s3)" );
	{
		int64 vr$1506 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1508 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$1506 != vr$1508) goto label$1139;
		{
			label$1140:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$497$5;
					int64 vr$1510 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$497$5 = vr$1510 + -1ll;
					goto label$1143;
					label$1146:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$1148;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1141;
						}
						label$1148:;
						label$1147:;
					}
					label$1144:;
					I$5 = I$5 + 1ll;
					label$1143:;
					if( I$5 <= TMP$497$5) goto label$1146;
					label$1145:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1142:;
			label$1141:;
		}
		label$1139:;
		label$1138:;
	}
	int64 vr$1520 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1522 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1520 == vr$1522) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s4))" );
	int32 vr$1527 = fb_StrCompare( (void*)R4$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1527 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s4)" );
	{
		int64 vr$1532 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1534 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$1532 != vr$1534) goto label$1150;
		{
			label$1151:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$503$5;
					int64 vr$1536 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$503$5 = vr$1536 + -1ll;
					goto label$1154;
					label$1157:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$1159;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1152;
						}
						label$1159:;
						label$1158:;
					}
					label$1155:;
					I$5 = I$5 + 1ll;
					label$1154:;
					if( I$5 <= TMP$503$5) goto label$1157;
					label$1156:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1153:;
			label$1152:;
		}
		label$1150:;
		label$1149:;
	}
	int64 vr$1546 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1548 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1546 == vr$1548) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r1))" );
	int32 vr$1553 = fb_StrCompare( (void*)R4$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1553 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r1)" );
	{
		int64 vr$1558 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1560 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$1558 != vr$1560) goto label$1161;
		{
			label$1162:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$509$5;
					int64 vr$1562 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$509$5 = vr$1562 + -1ll;
					goto label$1165;
					label$1168:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$1170;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1163;
						}
						label$1170:;
						label$1169:;
					}
					label$1166:;
					I$5 = I$5 + 1ll;
					label$1165:;
					if( I$5 <= TMP$509$5) goto label$1168;
					label$1167:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1164:;
			label$1163:;
		}
		label$1161:;
		label$1160:;
	}
	int64 vr$1572 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1574 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1572 == vr$1574) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r2))" );
	int32 vr$1579 = fb_StrCompare( (void*)R4$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1579 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r2)" );
	{
		int64 vr$1584 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1586 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$1584 != vr$1586) goto label$1172;
		{
			label$1173:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$515$5;
					int64 vr$1588 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$515$5 = vr$1588 + -1ll;
					goto label$1176;
					label$1179:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$1181;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1174;
						}
						label$1181:;
						label$1180:;
					}
					label$1177:;
					I$5 = I$5 + 1ll;
					label$1176:;
					if( I$5 <= TMP$515$5) goto label$1179;
					label$1178:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1175:;
			label$1174:;
		}
		label$1172:;
		label$1171:;
	}
	int64 vr$1598 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1600 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1598 == vr$1600) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r3))" );
	int32 vr$1605 = fb_StrCompare( (void*)R4$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1605 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r3)" );
	{
		int64 vr$1610 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1612 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$1610 != vr$1612) goto label$1183;
		{
			label$1184:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$521$5;
					int64 vr$1614 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$521$5 = vr$1614 + -1ll;
					goto label$1187;
					label$1190:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$1192;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1185;
						}
						label$1192:;
						label$1191:;
					}
					label$1188:;
					I$5 = I$5 + 1ll;
					label$1187:;
					if( I$5 <= TMP$521$5) goto label$1190;
					label$1189:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1186:;
			label$1185:;
		}
		label$1183:;
		label$1182:;
	}
	int64 vr$1624 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1626 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1624 == vr$1626) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r4))" );
	int32 vr$1631 = fb_StrCompare( (void*)R4$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1631 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r4)" );
	{
		int64 vr$1636 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1638 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$1636 != vr$1638) goto label$1194;
		{
			label$1195:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$527$5;
					int64 vr$1640 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$527$5 = vr$1640 + -1ll;
					goto label$1198;
					label$1201:;
					{
						goto label$1203;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1196;
						}
						label$1203:;
						label$1202:;
					}
					label$1199:;
					I$5 = I$5 + 1ll;
					label$1198:;
					if( I$5 <= TMP$527$5) goto label$1201;
					label$1200:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1197:;
			label$1196:;
		}
		label$1194:;
		label$1193:;
	}
	label$499:;
}

static void _ZN14UZSTRING_FIXEDaSERKS_( struct $14UZSTRING_FIXED* THIS$1, struct $14UZSTRING_FIXED* __FB_RHS__$1 )
{
	label$2:;
	__builtin_memcpy( (struct $19UZSTRING_FIXED_BASE*)THIS$1, (struct $19UZSTRING_FIXED_BASE*)__FB_RHS__$1, 256 );
	label$3:;
}

static void _ZN22UZSTRING_FIXED_MUTABLEaSERKS_( struct $22UZSTRING_FIXED_MUTABLE* THIS$1, struct $22UZSTRING_FIXED_MUTABLE* __FB_RHS__$1 )
{
	label$6:;
	__builtin_memcpy( (struct $19UZSTRING_FIXED_BASE*)THIS$1, (struct $19UZSTRING_FIXED_BASE*)__FB_RHS__$1, 256 );
	label$7:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_12NUMERIC_CTOREv( void )
{
	label$496:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.udt_zstring_.str_", (char*)"numeric", (tmp$5)&_ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_7NUMERICEv, (boolean)0ll );
	label$497:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_12DEFAULT_CTOREv( void )
{
	label$1204:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.udt_zstring_.str_", (char*)"default", (tmp$5)&_ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_7DEFAULTEv, (boolean)0ll );
	label$1205:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4STR_13SUITE_CTOR122Ev( void )
{
	label$1206:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.udt_zstring_.str_", (tmp$4)0ull, (tmp$4)0ull );
	label$1207:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
