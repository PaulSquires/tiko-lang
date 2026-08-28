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
struct $19UWSTRING_FIXED_BASE {
	uint16 _DATA[256];
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $19UWSTRING_FIXED_BASE ) == 512 );
struct $14UWSTRING_FIXED {
	struct $19UWSTRING_FIXED_BASE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $14UWSTRING_FIXED ) == 512 );
struct $22UWSTRING_FIXED_MUTABLE {
	struct $19UWSTRING_FIXED_BASE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $22UWSTRING_FIXED_MUTABLE ) == 512 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
uint16* fb_WstrAssign( uint16*, int64, uint16* );
uint16* fb_WstrAssignFromA( uint16*, int64, void*, int64 );
void fb_StrDelete( FBSTRING* );
int32 fb_WstrCompare( uint16*, uint16* );
FBSTRING* fb_IntToStr( int32 );
FBSTRING* fb_UIntToStr( uint32 );
FBSTRING* fb_LongintToStr( int64 );
FBSTRING* fb_ULongintToStr( uint64 );
FBSTRING* fb_FloatToStr( float );
FBSTRING* fb_DoubleToStr( double );
FBSTRING* fb_WstrToStr( uint16* );
int64 fb_WstrLen( uint16* );
static void fb_ctor__str( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN19UWSTRING_FIXED_BASEC1Ev( struct $19UWSTRING_FIXED_BASE* );
void _ZN14UWSTRING_FIXEDC1EPKc( struct $14UWSTRING_FIXED*, char* );
uint16* _ZN14UWSTRING_FIXEDcvwEv( struct $14UWSTRING_FIXED* );
static void _ZN14UWSTRING_FIXEDaSERKS_( struct $14UWSTRING_FIXED*, struct $14UWSTRING_FIXED* );
static void _ZN22UWSTRING_FIXED_MUTABLEaSERKS_( struct $22UWSTRING_FIXED_MUTABLE*, struct $22UWSTRING_FIXED_MUTABLE* );
void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_7NUMERICEv( void );
static void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_12NUMERIC_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_13SUITE_CTOR122Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_7NUMERICEv( void )
{
	label$10:;
	{
		FBSTRING TMP$8$2;
		int8 T$2;
		T$2 = (int8)-128;
		uint16 W$2[50];
		FBSTRING* vr$1 = fb_IntToStr( (int32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$8$2, 0, 24ll );
		FBSTRING* vr$5 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$8$2, -1ll, (void*)vr$5, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$8$2 );
		fb_StrDelete( (FBSTRING*)&TMP$8$2 );
		uint16 R$2[50];
		uint16* vr$10 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$10 );
		int64 vr$13 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$15 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$13 == vr$15) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$20 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$20 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$25 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$27 = fb_WstrLen( (uint16*)R$2 );
			if( vr$25 != vr$27) goto label$13;
			{
				label$14:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$24$6;
						int64 vr$29 = fb_WstrLen( (uint16*)W$2 );
						TMP$24$6 = vr$29 + -1ll;
						goto label$17;
						label$20:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$22;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$41 = fb_IntToStr( (int32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$41, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$29$2, 0, 24ll );
		FBSTRING* vr$45 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$29$2, -1ll, (void*)vr$45, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$29$2 );
		fb_StrDelete( (FBSTRING*)&TMP$29$2 );
		uint16 R$2[50];
		uint16* vr$50 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$50 );
		int64 vr$53 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$55 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$53 == vr$55) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$60 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$60 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$65 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$67 = fb_WstrLen( (uint16*)R$2 );
			if( vr$65 != vr$67) goto label$24;
			{
				label$25:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$30$6;
						int64 vr$69 = fb_WstrLen( (uint16*)W$2 );
						TMP$30$6 = vr$69 + -1ll;
						goto label$28;
						label$31:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$33;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$81 = fb_IntToStr( (int32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$81, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$31$2, 0, 24ll );
		FBSTRING* vr$85 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$31$2, -1ll, (void*)vr$85, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$31$2 );
		fb_StrDelete( (FBSTRING*)&TMP$31$2 );
		uint16 R$2[50];
		uint16* vr$90 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$90 );
		int64 vr$93 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$95 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$93 == vr$95) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$100 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$100 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$105 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$107 = fb_WstrLen( (uint16*)R$2 );
			if( vr$105 != vr$107) goto label$35;
			{
				label$36:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$32$6;
						int64 vr$109 = fb_WstrLen( (uint16*)W$2 );
						TMP$32$6 = vr$109 + -1ll;
						goto label$39;
						label$42:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$44;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$121 = fb_UIntToStr( (uint32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$121, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$33$2, 0, 24ll );
		FBSTRING* vr$125 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$33$2, -1ll, (void*)vr$125, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$33$2 );
		fb_StrDelete( (FBSTRING*)&TMP$33$2 );
		uint16 R$2[50];
		uint16* vr$130 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$130 );
		int64 vr$133 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$135 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$133 == vr$135) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$140 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$140 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$145 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$147 = fb_WstrLen( (uint16*)R$2 );
			if( vr$145 != vr$147) goto label$46;
			{
				label$47:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$34$6;
						int64 vr$149 = fb_WstrLen( (uint16*)W$2 );
						TMP$34$6 = vr$149 + -1ll;
						goto label$50;
						label$53:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$55;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$161 = fb_UIntToStr( (uint32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$161, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$35$2, 0, 24ll );
		FBSTRING* vr$165 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$35$2, -1ll, (void*)vr$165, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$35$2 );
		fb_StrDelete( (FBSTRING*)&TMP$35$2 );
		uint16 R$2[50];
		uint16* vr$170 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$170 );
		int64 vr$173 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$175 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$173 == vr$175) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$180 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$180 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$185 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$187 = fb_WstrLen( (uint16*)R$2 );
			if( vr$185 != vr$187) goto label$57;
			{
				label$58:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$36$6;
						int64 vr$189 = fb_WstrLen( (uint16*)W$2 );
						TMP$36$6 = vr$189 + -1ll;
						goto label$61;
						label$64:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$66;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$201 = fb_UIntToStr( (uint32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$201, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$37$2, 0, 24ll );
		FBSTRING* vr$205 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$37$2, -1ll, (void*)vr$205, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$37$2 );
		fb_StrDelete( (FBSTRING*)&TMP$37$2 );
		uint16 R$2[50];
		uint16* vr$210 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$210 );
		int64 vr$213 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$215 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$213 == vr$215) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$220 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$220 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$225 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$227 = fb_WstrLen( (uint16*)R$2 );
			if( vr$225 != vr$227) goto label$68;
			{
				label$69:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$38$6;
						int64 vr$229 = fb_WstrLen( (uint16*)W$2 );
						TMP$38$6 = vr$229 + -1ll;
						goto label$72;
						label$75:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$77;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$241 = fb_IntToStr( (int32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$241, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$39$2, 0, 24ll );
		FBSTRING* vr$245 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$39$2, -1ll, (void*)vr$245, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$39$2 );
		fb_StrDelete( (FBSTRING*)&TMP$39$2 );
		uint16 R$2[50];
		uint16* vr$250 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$250 );
		int64 vr$253 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$255 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$253 == vr$255) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$260 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$260 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$265 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$267 = fb_WstrLen( (uint16*)R$2 );
			if( vr$265 != vr$267) goto label$79;
			{
				label$80:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$40$6;
						int64 vr$269 = fb_WstrLen( (uint16*)W$2 );
						TMP$40$6 = vr$269 + -1ll;
						goto label$83;
						label$86:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$88;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$281 = fb_IntToStr( (int32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$281, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$41$2, 0, 24ll );
		FBSTRING* vr$285 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$41$2, -1ll, (void*)vr$285, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$41$2 );
		fb_StrDelete( (FBSTRING*)&TMP$41$2 );
		uint16 R$2[50];
		uint16* vr$290 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$290 );
		int64 vr$293 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$295 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$293 == vr$295) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$300 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$300 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$305 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$307 = fb_WstrLen( (uint16*)R$2 );
			if( vr$305 != vr$307) goto label$90;
			{
				label$91:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$42$6;
						int64 vr$309 = fb_WstrLen( (uint16*)W$2 );
						TMP$42$6 = vr$309 + -1ll;
						goto label$94;
						label$97:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$99;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$321 = fb_IntToStr( (int32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$321, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$43$2, 0, 24ll );
		FBSTRING* vr$325 = fb_IntToStr( (int32)T$2 );
		fb_StrAssign( (void*)&TMP$43$2, -1ll, (void*)vr$325, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$43$2 );
		fb_StrDelete( (FBSTRING*)&TMP$43$2 );
		uint16 R$2[50];
		uint16* vr$330 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$330 );
		int64 vr$333 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$335 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$333 == vr$335) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$340 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$340 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$345 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$347 = fb_WstrLen( (uint16*)R$2 );
			if( vr$345 != vr$347) goto label$101;
			{
				label$102:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$44$6;
						int64 vr$349 = fb_WstrLen( (uint16*)W$2 );
						TMP$44$6 = vr$349 + -1ll;
						goto label$105;
						label$108:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$110;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$361 = fb_UIntToStr( (uint32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$361, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$45$2, 0, 24ll );
		FBSTRING* vr$365 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$45$2, -1ll, (void*)vr$365, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$45$2 );
		fb_StrDelete( (FBSTRING*)&TMP$45$2 );
		uint16 R$2[50];
		uint16* vr$370 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$370 );
		int64 vr$373 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$375 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$373 == vr$375) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$380 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$380 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$385 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$387 = fb_WstrLen( (uint16*)R$2 );
			if( vr$385 != vr$387) goto label$112;
			{
				label$113:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$46$6;
						int64 vr$389 = fb_WstrLen( (uint16*)W$2 );
						TMP$46$6 = vr$389 + -1ll;
						goto label$116;
						label$119:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$121;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$401 = fb_UIntToStr( (uint32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$401, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$47$2, 0, 24ll );
		FBSTRING* vr$405 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$47$2, -1ll, (void*)vr$405, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$47$2 );
		fb_StrDelete( (FBSTRING*)&TMP$47$2 );
		uint16 R$2[50];
		uint16* vr$410 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$410 );
		int64 vr$413 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$415 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$413 == vr$415) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$420 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$420 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$425 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$427 = fb_WstrLen( (uint16*)R$2 );
			if( vr$425 != vr$427) goto label$123;
			{
				label$124:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$48$6;
						int64 vr$429 = fb_WstrLen( (uint16*)W$2 );
						TMP$48$6 = vr$429 + -1ll;
						goto label$127;
						label$130:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$132;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$441 = fb_UIntToStr( (uint32)T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$441, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$49$2, 0, 24ll );
		FBSTRING* vr$445 = fb_UIntToStr( (uint32)T$2 );
		fb_StrAssign( (void*)&TMP$49$2, -1ll, (void*)vr$445, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$49$2 );
		fb_StrDelete( (FBSTRING*)&TMP$49$2 );
		uint16 R$2[50];
		uint16* vr$450 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$450 );
		int64 vr$453 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$455 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$453 == vr$455) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$460 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$460 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$465 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$467 = fb_WstrLen( (uint16*)R$2 );
			if( vr$465 != vr$467) goto label$134;
			{
				label$135:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$50$6;
						int64 vr$469 = fb_WstrLen( (uint16*)W$2 );
						TMP$50$6 = vr$469 + -1ll;
						goto label$138;
						label$141:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$143;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$480 = fb_IntToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$480, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$51$2, 0, 24ll );
		FBSTRING* vr$483 = fb_IntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$51$2, -1ll, (void*)vr$483, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$51$2 );
		fb_StrDelete( (FBSTRING*)&TMP$51$2 );
		uint16 R$2[50];
		uint16* vr$488 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$488 );
		int64 vr$491 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$493 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$491 == vr$493) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$498 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$498 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$503 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$505 = fb_WstrLen( (uint16*)R$2 );
			if( vr$503 != vr$505) goto label$145;
			{
				label$146:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$52$6;
						int64 vr$507 = fb_WstrLen( (uint16*)W$2 );
						TMP$52$6 = vr$507 + -1ll;
						goto label$149;
						label$152:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$154;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$518 = fb_IntToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$518, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$53$2, 0, 24ll );
		FBSTRING* vr$521 = fb_IntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$53$2, -1ll, (void*)vr$521, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$53$2 );
		fb_StrDelete( (FBSTRING*)&TMP$53$2 );
		uint16 R$2[50];
		uint16* vr$526 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$526 );
		int64 vr$529 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$531 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$529 == vr$531) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$536 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$536 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$541 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$543 = fb_WstrLen( (uint16*)R$2 );
			if( vr$541 != vr$543) goto label$156;
			{
				label$157:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$54$6;
						int64 vr$545 = fb_WstrLen( (uint16*)W$2 );
						TMP$54$6 = vr$545 + -1ll;
						goto label$160;
						label$163:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$165;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$556 = fb_IntToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$556, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$55$2, 0, 24ll );
		FBSTRING* vr$559 = fb_IntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$55$2, -1ll, (void*)vr$559, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$55$2 );
		fb_StrDelete( (FBSTRING*)&TMP$55$2 );
		uint16 R$2[50];
		uint16* vr$564 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$564 );
		int64 vr$567 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$569 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$567 == vr$569) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$574 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$574 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$579 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$581 = fb_WstrLen( (uint16*)R$2 );
			if( vr$579 != vr$581) goto label$167;
			{
				label$168:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$56$6;
						int64 vr$583 = fb_WstrLen( (uint16*)W$2 );
						TMP$56$6 = vr$583 + -1ll;
						goto label$171;
						label$174:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$176;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$594 = fb_UIntToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$594, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$57$2, 0, 24ll );
		FBSTRING* vr$597 = fb_UIntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$57$2, -1ll, (void*)vr$597, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$57$2 );
		fb_StrDelete( (FBSTRING*)&TMP$57$2 );
		uint16 R$2[50];
		uint16* vr$602 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$602 );
		int64 vr$605 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$607 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$605 == vr$607) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$612 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$612 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$617 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$619 = fb_WstrLen( (uint16*)R$2 );
			if( vr$617 != vr$619) goto label$178;
			{
				label$179:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$58$6;
						int64 vr$621 = fb_WstrLen( (uint16*)W$2 );
						TMP$58$6 = vr$621 + -1ll;
						goto label$182;
						label$185:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$187;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$632 = fb_UIntToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$632, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$59$2, 0, 24ll );
		FBSTRING* vr$635 = fb_UIntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$59$2, -1ll, (void*)vr$635, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$59$2 );
		fb_StrDelete( (FBSTRING*)&TMP$59$2 );
		uint16 R$2[50];
		uint16* vr$640 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$640 );
		int64 vr$643 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$645 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$643 == vr$645) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$650 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$650 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$655 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$657 = fb_WstrLen( (uint16*)R$2 );
			if( vr$655 != vr$657) goto label$189;
			{
				label$190:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$60$6;
						int64 vr$659 = fb_WstrLen( (uint16*)W$2 );
						TMP$60$6 = vr$659 + -1ll;
						goto label$193;
						label$196:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$198;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$670 = fb_UIntToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$670, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$61$2, 0, 24ll );
		FBSTRING* vr$673 = fb_UIntToStr( T$2 );
		fb_StrAssign( (void*)&TMP$61$2, -1ll, (void*)vr$673, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$61$2 );
		fb_StrDelete( (FBSTRING*)&TMP$61$2 );
		uint16 R$2[50];
		uint16* vr$678 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$678 );
		int64 vr$681 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$683 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$681 == vr$683) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$688 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$688 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$693 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$695 = fb_WstrLen( (uint16*)R$2 );
			if( vr$693 != vr$695) goto label$200;
			{
				label$201:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$62$6;
						int64 vr$697 = fb_WstrLen( (uint16*)W$2 );
						TMP$62$6 = vr$697 + -1ll;
						goto label$204;
						label$207:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$209;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$708 = fb_LongintToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$708, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$63$2, 0, 24ll );
		FBSTRING* vr$711 = fb_LongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$63$2, -1ll, (void*)vr$711, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$63$2 );
		fb_StrDelete( (FBSTRING*)&TMP$63$2 );
		uint16 R$2[50];
		uint16* vr$716 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$716 );
		int64 vr$719 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$721 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$719 == vr$721) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$726 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$726 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$731 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$733 = fb_WstrLen( (uint16*)R$2 );
			if( vr$731 != vr$733) goto label$211;
			{
				label$212:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$64$6;
						int64 vr$735 = fb_WstrLen( (uint16*)W$2 );
						TMP$64$6 = vr$735 + -1ll;
						goto label$215;
						label$218:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$220;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$746 = fb_LongintToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$746, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$65$2, 0, 24ll );
		FBSTRING* vr$749 = fb_LongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$65$2, -1ll, (void*)vr$749, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$65$2 );
		fb_StrDelete( (FBSTRING*)&TMP$65$2 );
		uint16 R$2[50];
		uint16* vr$754 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$754 );
		int64 vr$757 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$759 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$757 == vr$759) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$764 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$764 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$769 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$771 = fb_WstrLen( (uint16*)R$2 );
			if( vr$769 != vr$771) goto label$222;
			{
				label$223:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$66$6;
						int64 vr$773 = fb_WstrLen( (uint16*)W$2 );
						TMP$66$6 = vr$773 + -1ll;
						goto label$226;
						label$229:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$231;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$784 = fb_LongintToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$784, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$67$2, 0, 24ll );
		FBSTRING* vr$787 = fb_LongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$67$2, -1ll, (void*)vr$787, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$67$2 );
		fb_StrDelete( (FBSTRING*)&TMP$67$2 );
		uint16 R$2[50];
		uint16* vr$792 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$792 );
		int64 vr$795 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$797 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$795 == vr$797) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$802 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$802 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$807 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$809 = fb_WstrLen( (uint16*)R$2 );
			if( vr$807 != vr$809) goto label$233;
			{
				label$234:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$68$6;
						int64 vr$811 = fb_WstrLen( (uint16*)W$2 );
						TMP$68$6 = vr$811 + -1ll;
						goto label$237;
						label$240:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$242;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$822 = fb_ULongintToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$822, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$69$2, 0, 24ll );
		FBSTRING* vr$825 = fb_ULongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$69$2, -1ll, (void*)vr$825, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$69$2 );
		fb_StrDelete( (FBSTRING*)&TMP$69$2 );
		uint16 R$2[50];
		uint16* vr$830 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$830 );
		int64 vr$833 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$835 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$833 == vr$835) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$840 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$840 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$845 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$847 = fb_WstrLen( (uint16*)R$2 );
			if( vr$845 != vr$847) goto label$244;
			{
				label$245:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$70$6;
						int64 vr$849 = fb_WstrLen( (uint16*)W$2 );
						TMP$70$6 = vr$849 + -1ll;
						goto label$248;
						label$251:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$253;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$860 = fb_ULongintToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$860, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$71$2, 0, 24ll );
		FBSTRING* vr$863 = fb_ULongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$71$2, -1ll, (void*)vr$863, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$71$2 );
		fb_StrDelete( (FBSTRING*)&TMP$71$2 );
		uint16 R$2[50];
		uint16* vr$868 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$868 );
		int64 vr$871 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$873 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$871 == vr$873) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$878 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$878 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$883 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$885 = fb_WstrLen( (uint16*)R$2 );
			if( vr$883 != vr$885) goto label$255;
			{
				label$256:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$72$6;
						int64 vr$887 = fb_WstrLen( (uint16*)W$2 );
						TMP$72$6 = vr$887 + -1ll;
						goto label$259;
						label$262:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$264;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$898 = fb_ULongintToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$898, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$73$2, 0, 24ll );
		FBSTRING* vr$901 = fb_ULongintToStr( T$2 );
		fb_StrAssign( (void*)&TMP$73$2, -1ll, (void*)vr$901, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$73$2 );
		fb_StrDelete( (FBSTRING*)&TMP$73$2 );
		uint16 R$2[50];
		uint16* vr$906 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$906 );
		int64 vr$909 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$911 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$909 == vr$911) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$916 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$916 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$921 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$923 = fb_WstrLen( (uint16*)R$2 );
			if( vr$921 != vr$923) goto label$266;
			{
				label$267:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$74$6;
						int64 vr$925 = fb_WstrLen( (uint16*)W$2 );
						TMP$74$6 = vr$925 + -1ll;
						goto label$270;
						label$273:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$275;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$936 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$936, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$75$2, 0, 24ll );
		FBSTRING* vr$939 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$75$2, -1ll, (void*)vr$939, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$75$2 );
		fb_StrDelete( (FBSTRING*)&TMP$75$2 );
		uint16 R$2[50];
		uint16* vr$944 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$944 );
		int64 vr$947 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$949 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$947 == vr$949) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$954 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$954 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$959 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$961 = fb_WstrLen( (uint16*)R$2 );
			if( vr$959 != vr$961) goto label$277;
			{
				label$278:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$76$6;
						int64 vr$963 = fb_WstrLen( (uint16*)W$2 );
						TMP$76$6 = vr$963 + -1ll;
						goto label$281;
						label$284:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$286;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$974 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$974, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$77$2, 0, 24ll );
		FBSTRING* vr$977 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$77$2, -1ll, (void*)vr$977, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$77$2 );
		fb_StrDelete( (FBSTRING*)&TMP$77$2 );
		uint16 R$2[50];
		uint16* vr$982 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$982 );
		int64 vr$985 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$987 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$985 == vr$987) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$992 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$992 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$997 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$999 = fb_WstrLen( (uint16*)R$2 );
			if( vr$997 != vr$999) goto label$288;
			{
				label$289:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$78$6;
						int64 vr$1001 = fb_WstrLen( (uint16*)W$2 );
						TMP$78$6 = vr$1001 + -1ll;
						goto label$292;
						label$295:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$297;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1012 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1012, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$79$2, 0, 24ll );
		FBSTRING* vr$1015 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$79$2, -1ll, (void*)vr$1015, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$79$2 );
		fb_StrDelete( (FBSTRING*)&TMP$79$2 );
		uint16 R$2[50];
		uint16* vr$1020 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1020 );
		int64 vr$1023 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1025 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1023 == vr$1025) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1030 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1030 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1035 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1037 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1035 != vr$1037) goto label$299;
			{
				label$300:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$80$6;
						int64 vr$1039 = fb_WstrLen( (uint16*)W$2 );
						TMP$80$6 = vr$1039 + -1ll;
						goto label$303;
						label$306:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$308;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1050 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1050, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$81$2, 0, 24ll );
		FBSTRING* vr$1053 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$81$2, -1ll, (void*)vr$1053, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$81$2 );
		fb_StrDelete( (FBSTRING*)&TMP$81$2 );
		uint16 R$2[50];
		uint16* vr$1058 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1058 );
		int64 vr$1061 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1063 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1061 == vr$1063) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1068 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1068 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1073 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1075 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1073 != vr$1075) goto label$310;
			{
				label$311:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$82$6;
						int64 vr$1077 = fb_WstrLen( (uint16*)W$2 );
						TMP$82$6 = vr$1077 + -1ll;
						goto label$314;
						label$317:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$319;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1088 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1088, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$83$2, 0, 24ll );
		FBSTRING* vr$1091 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$83$2, -1ll, (void*)vr$1091, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$83$2 );
		fb_StrDelete( (FBSTRING*)&TMP$83$2 );
		uint16 R$2[50];
		uint16* vr$1096 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1096 );
		int64 vr$1099 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1101 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1099 == vr$1101) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1106 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1106 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1111 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1113 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1111 != vr$1113) goto label$321;
			{
				label$322:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$84$6;
						int64 vr$1115 = fb_WstrLen( (uint16*)W$2 );
						TMP$84$6 = vr$1115 + -1ll;
						goto label$325;
						label$328:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$330;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1126 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1126, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$85$2, 0, 24ll );
		FBSTRING* vr$1129 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$85$2, -1ll, (void*)vr$1129, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$85$2 );
		fb_StrDelete( (FBSTRING*)&TMP$85$2 );
		uint16 R$2[50];
		uint16* vr$1134 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1134 );
		int64 vr$1137 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1139 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1137 == vr$1139) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1144 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1144 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1149 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1151 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1149 != vr$1151) goto label$332;
			{
				label$333:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$86$6;
						int64 vr$1153 = fb_WstrLen( (uint16*)W$2 );
						TMP$86$6 = vr$1153 + -1ll;
						goto label$336;
						label$339:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$341;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1164 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1164, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$87$2, 0, 24ll );
		FBSTRING* vr$1167 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$87$2, -1ll, (void*)vr$1167, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$87$2 );
		fb_StrDelete( (FBSTRING*)&TMP$87$2 );
		uint16 R$2[50];
		uint16* vr$1172 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1172 );
		int64 vr$1175 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1177 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1175 == vr$1177) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1182 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1182 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1187 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1189 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1187 != vr$1189) goto label$343;
			{
				label$344:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$88$6;
						int64 vr$1191 = fb_WstrLen( (uint16*)W$2 );
						TMP$88$6 = vr$1191 + -1ll;
						goto label$347;
						label$350:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$352;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1202 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1202, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$89$2, 0, 24ll );
		FBSTRING* vr$1205 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$89$2, -1ll, (void*)vr$1205, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$89$2 );
		fb_StrDelete( (FBSTRING*)&TMP$89$2 );
		uint16 R$2[50];
		uint16* vr$1210 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1210 );
		int64 vr$1213 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1215 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1213 == vr$1215) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1220 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1220 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1225 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1227 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1225 != vr$1227) goto label$354;
			{
				label$355:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$90$6;
						int64 vr$1229 = fb_WstrLen( (uint16*)W$2 );
						TMP$90$6 = vr$1229 + -1ll;
						goto label$358;
						label$361:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$363;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1240 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1240, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$91$2, 0, 24ll );
		FBSTRING* vr$1243 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$91$2, -1ll, (void*)vr$1243, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$91$2 );
		fb_StrDelete( (FBSTRING*)&TMP$91$2 );
		uint16 R$2[50];
		uint16* vr$1248 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1248 );
		int64 vr$1251 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1253 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1251 == vr$1253) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1258 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1258 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1263 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1265 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1263 != vr$1265) goto label$365;
			{
				label$366:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$92$6;
						int64 vr$1267 = fb_WstrLen( (uint16*)W$2 );
						TMP$92$6 = vr$1267 + -1ll;
						goto label$369;
						label$372:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$374;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1278 = fb_FloatToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1278, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$93$2, 0, 24ll );
		FBSTRING* vr$1281 = fb_FloatToStr( T$2 );
		fb_StrAssign( (void*)&TMP$93$2, -1ll, (void*)vr$1281, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$93$2 );
		fb_StrDelete( (FBSTRING*)&TMP$93$2 );
		uint16 R$2[50];
		uint16* vr$1286 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1286 );
		int64 vr$1289 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1291 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1289 == vr$1291) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1296 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1296 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1301 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1303 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1301 != vr$1303) goto label$376;
			{
				label$377:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$94$6;
						int64 vr$1305 = fb_WstrLen( (uint16*)W$2 );
						TMP$94$6 = vr$1305 + -1ll;
						goto label$380;
						label$383:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$385;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1316 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1316, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$95$2, 0, 24ll );
		FBSTRING* vr$1319 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$95$2, -1ll, (void*)vr$1319, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$95$2 );
		fb_StrDelete( (FBSTRING*)&TMP$95$2 );
		uint16 R$2[50];
		uint16* vr$1324 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1324 );
		int64 vr$1327 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1329 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1327 == vr$1329) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1334 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1334 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1339 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1341 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1339 != vr$1341) goto label$387;
			{
				label$388:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$96$6;
						int64 vr$1343 = fb_WstrLen( (uint16*)W$2 );
						TMP$96$6 = vr$1343 + -1ll;
						goto label$391;
						label$394:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$396;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1354 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1354, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$97$2, 0, 24ll );
		FBSTRING* vr$1357 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$97$2, -1ll, (void*)vr$1357, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$97$2 );
		fb_StrDelete( (FBSTRING*)&TMP$97$2 );
		uint16 R$2[50];
		uint16* vr$1362 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1362 );
		int64 vr$1365 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1367 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1365 == vr$1367) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1372 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1372 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1377 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1379 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1377 != vr$1379) goto label$398;
			{
				label$399:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$98$6;
						int64 vr$1381 = fb_WstrLen( (uint16*)W$2 );
						TMP$98$6 = vr$1381 + -1ll;
						goto label$402;
						label$405:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$407;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1392 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1392, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$99$2, 0, 24ll );
		FBSTRING* vr$1395 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$99$2, -1ll, (void*)vr$1395, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$99$2 );
		fb_StrDelete( (FBSTRING*)&TMP$99$2 );
		uint16 R$2[50];
		uint16* vr$1400 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1400 );
		int64 vr$1403 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1405 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1403 == vr$1405) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1410 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1410 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1415 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1417 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1415 != vr$1417) goto label$409;
			{
				label$410:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$100$6;
						int64 vr$1419 = fb_WstrLen( (uint16*)W$2 );
						TMP$100$6 = vr$1419 + -1ll;
						goto label$413;
						label$416:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$418;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1430 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1430, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$101$2, 0, 24ll );
		FBSTRING* vr$1433 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$101$2, -1ll, (void*)vr$1433, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$101$2 );
		fb_StrDelete( (FBSTRING*)&TMP$101$2 );
		uint16 R$2[50];
		uint16* vr$1438 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1438 );
		int64 vr$1441 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1443 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1441 == vr$1443) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1448 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1448 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1453 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1455 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1453 != vr$1455) goto label$420;
			{
				label$421:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$102$6;
						int64 vr$1457 = fb_WstrLen( (uint16*)W$2 );
						TMP$102$6 = vr$1457 + -1ll;
						goto label$424;
						label$427:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$429;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1468 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1468, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$103$2, 0, 24ll );
		FBSTRING* vr$1471 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$103$2, -1ll, (void*)vr$1471, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$103$2 );
		fb_StrDelete( (FBSTRING*)&TMP$103$2 );
		uint16 R$2[50];
		uint16* vr$1476 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1476 );
		int64 vr$1479 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1481 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1479 == vr$1481) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1486 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1486 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1491 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1493 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1491 != vr$1493) goto label$431;
			{
				label$432:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$104$6;
						int64 vr$1495 = fb_WstrLen( (uint16*)W$2 );
						TMP$104$6 = vr$1495 + -1ll;
						goto label$435;
						label$438:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$440;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1506 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1506, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$105$2, 0, 24ll );
		FBSTRING* vr$1509 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$105$2, -1ll, (void*)vr$1509, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$105$2 );
		fb_StrDelete( (FBSTRING*)&TMP$105$2 );
		uint16 R$2[50];
		uint16* vr$1514 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1514 );
		int64 vr$1517 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1519 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1517 == vr$1519) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1524 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1524 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1529 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1531 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1529 != vr$1531) goto label$442;
			{
				label$443:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$106$6;
						int64 vr$1533 = fb_WstrLen( (uint16*)W$2 );
						TMP$106$6 = vr$1533 + -1ll;
						goto label$446;
						label$449:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$451;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1544 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1544, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$107$2, 0, 24ll );
		FBSTRING* vr$1547 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$107$2, -1ll, (void*)vr$1547, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$107$2 );
		fb_StrDelete( (FBSTRING*)&TMP$107$2 );
		uint16 R$2[50];
		uint16* vr$1552 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1552 );
		int64 vr$1555 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1557 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1555 == vr$1557) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1562 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1562 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1567 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1569 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1567 != vr$1569) goto label$453;
			{
				label$454:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$108$6;
						int64 vr$1571 = fb_WstrLen( (uint16*)W$2 );
						TMP$108$6 = vr$1571 + -1ll;
						goto label$457;
						label$460:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$462;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1582 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1582, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$109$2, 0, 24ll );
		FBSTRING* vr$1585 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$109$2, -1ll, (void*)vr$1585, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$109$2 );
		fb_StrDelete( (FBSTRING*)&TMP$109$2 );
		uint16 R$2[50];
		uint16* vr$1590 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1590 );
		int64 vr$1593 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1595 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1593 == vr$1595) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1600 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1600 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1605 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1607 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1605 != vr$1607) goto label$464;
			{
				label$465:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$110$6;
						int64 vr$1609 = fb_WstrLen( (uint16*)W$2 );
						TMP$110$6 = vr$1609 + -1ll;
						goto label$468;
						label$471:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$473;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1620 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1620, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$111$2, 0, 24ll );
		FBSTRING* vr$1623 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$111$2, -1ll, (void*)vr$1623, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$111$2 );
		fb_StrDelete( (FBSTRING*)&TMP$111$2 );
		uint16 R$2[50];
		uint16* vr$1628 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1628 );
		int64 vr$1631 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1633 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1631 == vr$1633) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1638 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1638 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1643 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1645 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1643 != vr$1645) goto label$475;
			{
				label$476:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$112$6;
						int64 vr$1647 = fb_WstrLen( (uint16*)W$2 );
						TMP$112$6 = vr$1647 + -1ll;
						goto label$479;
						label$482:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$484;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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
		uint16 W$2[50];
		FBSTRING* vr$1658 = fb_DoubleToStr( T$2 );
		fb_WstrAssignFromA( (uint16*)W$2, 50ll, (void*)vr$1658, -1ll );
		struct $14UWSTRING_FIXED U$2;
		__builtin_memset( &TMP$113$2, 0, 24ll );
		FBSTRING* vr$1661 = fb_DoubleToStr( T$2 );
		fb_StrAssign( (void*)&TMP$113$2, -1ll, (void*)vr$1661, -1ll, 0 );
		_ZN14UWSTRING_FIXEDC1EPKc( &U$2, (char*)*(char**)&TMP$113$2 );
		fb_StrDelete( (FBSTRING*)&TMP$113$2 );
		uint16 R$2[50];
		uint16* vr$1666 = _ZN14UWSTRING_FIXEDcvwEv( &U$2 );
		fb_WstrAssign( (uint16*)R$2, 50ll, vr$1666 );
		int64 vr$1669 = fb_WstrLen( (uint16*)W$2 );
		int64 vr$1671 = fb_WstrLen( (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1669 == vr$1671) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1676 = fb_WstrCompare( (uint16*)W$2, (uint16*)R$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1676 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1681 = fb_WstrLen( (uint16*)W$2 );
			int64 vr$1683 = fb_WstrLen( (uint16*)R$2 );
			if( vr$1681 != vr$1683) goto label$486;
			{
				label$487:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$114$6;
						int64 vr$1685 = fb_WstrLen( (uint16*)W$2 );
						TMP$114$6 = vr$1685 + -1ll;
						goto label$490;
						label$493:;
						{
							if( (int64)*(uint16*)((uint8*)W$2 + (I$6 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R$2 + (I$6 << (1ll & 63ll)))) goto label$495;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_FAIL()" );
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
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.NUMERIC", (char*)"CU_PASS()" );
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

void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_7DEFAULTEv( void )
{
	FBSTRING TMP$118$1;
	FBSTRING TMP$119$1;
	label$498:;
	uint16 S1$1[10];
	fb_WstrAssignFromA( (uint16*)S1$1, 10ll, (void*)"A", 2ll );
	uint16 S2$1[10];
	fb_WstrAssignFromA( (uint16*)S2$1, 10ll, (void*)"A", 2ll );
	uint16 S3$1[10];
	FBSTRING* vr$3 = fb_WstrToStr( (uint16*)S1$1 );
	fb_WstrAssignFromA( (uint16*)S3$1, 10ll, (void*)vr$3, -1ll );
	struct $14UWSTRING_FIXED U1$1;
	_ZN14UWSTRING_FIXEDC1EPKc( &U1$1, (char*)"A" );
	struct $14UWSTRING_FIXED U2$1;
	_ZN14UWSTRING_FIXEDC1EPKc( &U2$1, (char*)"A" );
	struct $14UWSTRING_FIXED U3$1;
	__builtin_memset( &TMP$118$1, 0, 24ll );
	FBSTRING* vr$9 = fb_WstrToStr( (uint16*)S1$1 );
	fb_StrAssign( (void*)&TMP$118$1, -1ll, (void*)vr$9, -1ll, 0 );
	_ZN14UWSTRING_FIXEDC1EPKc( &U3$1, (char*)*(char**)&TMP$118$1 );
	fb_StrDelete( (FBSTRING*)&TMP$118$1 );
	struct $14UWSTRING_FIXED U4$1;
	__builtin_memset( &TMP$119$1, 0, 24ll );
	uint16* vr$15 = _ZN14UWSTRING_FIXEDcvwEv( &U1$1 );
	FBSTRING* vr$16 = fb_WstrToStr( vr$15 );
	fb_StrAssign( (void*)&TMP$119$1, -1ll, (void*)vr$16, -1ll, 0 );
	_ZN14UWSTRING_FIXEDC1EPKc( &U4$1, (char*)*(char**)&TMP$119$1 );
	fb_StrDelete( (FBSTRING*)&TMP$119$1 );
	uint16 S4$1[10];
	uint16* vr$21 = _ZN14UWSTRING_FIXEDcvwEv( &U1$1 );
	FBSTRING* vr$22 = fb_WstrToStr( vr$21 );
	fb_WstrAssignFromA( (uint16*)S4$1, 10ll, (void*)vr$22, -1ll );
	uint16 R1$1[10];
	uint16* vr$25 = _ZN14UWSTRING_FIXEDcvwEv( &U1$1 );
	fb_WstrAssign( (uint16*)R1$1, 10ll, vr$25 );
	uint16 R2$1[10];
	uint16* vr$28 = _ZN14UWSTRING_FIXEDcvwEv( &U2$1 );
	fb_WstrAssign( (uint16*)R2$1, 10ll, vr$28 );
	uint16 R3$1[10];
	uint16* vr$31 = _ZN14UWSTRING_FIXEDcvwEv( &U3$1 );
	fb_WstrAssign( (uint16*)R3$1, 10ll, vr$31 );
	uint16 R4$1[10];
	uint16* vr$34 = _ZN14UWSTRING_FIXEDcvwEv( &U4$1 );
	fb_WstrAssign( (uint16*)R4$1, 10ll, vr$34 );
	int64 vr$37 = fb_WstrLen( (uint16*)S1$1 );
	int64 vr$39 = fb_WstrLen( (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$37 == vr$39) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s1))" );
	int32 vr$44 = fb_WstrCompare( (uint16*)S1$1, (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$44 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s1)" );
	{
		int64 vr$49 = fb_WstrLen( (uint16*)S1$1 );
		int64 vr$51 = fb_WstrLen( (uint16*)S1$1 );
		if( vr$49 != vr$51) goto label$501;
		{
			label$502:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$129$5;
					int64 vr$53 = fb_WstrLen( (uint16*)S1$1 );
					TMP$129$5 = vr$53 + -1ll;
					goto label$505;
					label$508:;
					{
						goto label$510;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$503;
						}
						label$510:;
						label$509:;
					}
					label$506:;
					I$5 = I$5 + 1ll;
					label$505:;
					if( I$5 <= TMP$129$5) goto label$508;
					label$507:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$504:;
			label$503:;
		}
		label$501:;
		label$500:;
	}
	int64 vr$57 = fb_WstrLen( (uint16*)S1$1 );
	int64 vr$59 = fb_WstrLen( (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$57 == vr$59) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s2))" );
	int32 vr$64 = fb_WstrCompare( (uint16*)S1$1, (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$64 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s2)" );
	{
		int64 vr$69 = fb_WstrLen( (uint16*)S1$1 );
		int64 vr$71 = fb_WstrLen( (uint16*)S2$1 );
		if( vr$69 != vr$71) goto label$512;
		{
			label$513:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$136$5;
					int64 vr$73 = fb_WstrLen( (uint16*)S1$1 );
					TMP$136$5 = vr$73 + -1ll;
					goto label$516;
					label$519:;
					{
						if( (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll)))) goto label$521;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$514;
						}
						label$521:;
						label$520:;
					}
					label$517:;
					I$5 = I$5 + 1ll;
					label$516:;
					if( I$5 <= TMP$136$5) goto label$519;
					label$518:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$515:;
			label$514:;
		}
		label$512:;
		label$511:;
	}
	int64 vr$85 = fb_WstrLen( (uint16*)S1$1 );
	int64 vr$87 = fb_WstrLen( (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$85 == vr$87) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s3))" );
	int32 vr$92 = fb_WstrCompare( (uint16*)S1$1, (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$92 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s3)" );
	{
		int64 vr$97 = fb_WstrLen( (uint16*)S1$1 );
		int64 vr$99 = fb_WstrLen( (uint16*)S3$1 );
		if( vr$97 != vr$99) goto label$523;
		{
			label$524:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$143$5;
					int64 vr$101 = fb_WstrLen( (uint16*)S1$1 );
					TMP$143$5 = vr$101 + -1ll;
					goto label$527;
					label$530:;
					{
						if( (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll)))) goto label$532;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$525;
						}
						label$532:;
						label$531:;
					}
					label$528:;
					I$5 = I$5 + 1ll;
					label$527:;
					if( I$5 <= TMP$143$5) goto label$530;
					label$529:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$526:;
			label$525:;
		}
		label$523:;
		label$522:;
	}
	int64 vr$113 = fb_WstrLen( (uint16*)S1$1 );
	int64 vr$115 = fb_WstrLen( (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$113 == vr$115) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s4))" );
	int32 vr$120 = fb_WstrCompare( (uint16*)S1$1, (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$120 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s4)" );
	{
		int64 vr$125 = fb_WstrLen( (uint16*)S1$1 );
		int64 vr$127 = fb_WstrLen( (uint16*)S4$1 );
		if( vr$125 != vr$127) goto label$534;
		{
			label$535:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$150$5;
					int64 vr$129 = fb_WstrLen( (uint16*)S1$1 );
					TMP$150$5 = vr$129 + -1ll;
					goto label$538;
					label$541:;
					{
						if( (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll)))) goto label$543;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$536;
						}
						label$543:;
						label$542:;
					}
					label$539:;
					I$5 = I$5 + 1ll;
					label$538:;
					if( I$5 <= TMP$150$5) goto label$541;
					label$540:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$537:;
			label$536:;
		}
		label$534:;
		label$533:;
	}
	int64 vr$141 = fb_WstrLen( (uint16*)S1$1 );
	int64 vr$143 = fb_WstrLen( (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$141 == vr$143) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r1))" );
	int32 vr$148 = fb_WstrCompare( (uint16*)S1$1, (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$148 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r1)" );
	{
		int64 vr$153 = fb_WstrLen( (uint16*)S1$1 );
		int64 vr$155 = fb_WstrLen( (uint16*)R1$1 );
		if( vr$153 != vr$155) goto label$545;
		{
			label$546:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$157$5;
					int64 vr$157 = fb_WstrLen( (uint16*)S1$1 );
					TMP$157$5 = vr$157 + -1ll;
					goto label$549;
					label$552:;
					{
						if( (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll)))) goto label$554;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$547;
						}
						label$554:;
						label$553:;
					}
					label$550:;
					I$5 = I$5 + 1ll;
					label$549:;
					if( I$5 <= TMP$157$5) goto label$552;
					label$551:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$548:;
			label$547:;
		}
		label$545:;
		label$544:;
	}
	int64 vr$169 = fb_WstrLen( (uint16*)S1$1 );
	int64 vr$171 = fb_WstrLen( (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$169 == vr$171) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r2))" );
	int32 vr$176 = fb_WstrCompare( (uint16*)S1$1, (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$176 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r2)" );
	{
		int64 vr$181 = fb_WstrLen( (uint16*)S1$1 );
		int64 vr$183 = fb_WstrLen( (uint16*)R2$1 );
		if( vr$181 != vr$183) goto label$556;
		{
			label$557:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$164$5;
					int64 vr$185 = fb_WstrLen( (uint16*)S1$1 );
					TMP$164$5 = vr$185 + -1ll;
					goto label$560;
					label$563:;
					{
						if( (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll)))) goto label$565;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$558;
						}
						label$565:;
						label$564:;
					}
					label$561:;
					I$5 = I$5 + 1ll;
					label$560:;
					if( I$5 <= TMP$164$5) goto label$563;
					label$562:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$559:;
			label$558:;
		}
		label$556:;
		label$555:;
	}
	int64 vr$197 = fb_WstrLen( (uint16*)S1$1 );
	int64 vr$199 = fb_WstrLen( (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$197 == vr$199) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r3))" );
	int32 vr$204 = fb_WstrCompare( (uint16*)S1$1, (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$204 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r3)" );
	{
		int64 vr$209 = fb_WstrLen( (uint16*)S1$1 );
		int64 vr$211 = fb_WstrLen( (uint16*)R3$1 );
		if( vr$209 != vr$211) goto label$567;
		{
			label$568:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$171$5;
					int64 vr$213 = fb_WstrLen( (uint16*)S1$1 );
					TMP$171$5 = vr$213 + -1ll;
					goto label$571;
					label$574:;
					{
						if( (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll)))) goto label$576;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$569;
						}
						label$576:;
						label$575:;
					}
					label$572:;
					I$5 = I$5 + 1ll;
					label$571:;
					if( I$5 <= TMP$171$5) goto label$574;
					label$573:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$570:;
			label$569:;
		}
		label$567:;
		label$566:;
	}
	int64 vr$225 = fb_WstrLen( (uint16*)S1$1 );
	int64 vr$227 = fb_WstrLen( (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$225 == vr$227) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r4))" );
	int32 vr$232 = fb_WstrCompare( (uint16*)S1$1, (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$232 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r4)" );
	{
		int64 vr$237 = fb_WstrLen( (uint16*)S1$1 );
		int64 vr$239 = fb_WstrLen( (uint16*)R4$1 );
		if( vr$237 != vr$239) goto label$578;
		{
			label$579:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$178$5;
					int64 vr$241 = fb_WstrLen( (uint16*)S1$1 );
					TMP$178$5 = vr$241 + -1ll;
					goto label$582;
					label$585:;
					{
						if( (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll)))) goto label$587;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$580;
						}
						label$587:;
						label$586:;
					}
					label$583:;
					I$5 = I$5 + 1ll;
					label$582:;
					if( I$5 <= TMP$178$5) goto label$585;
					label$584:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$581:;
			label$580:;
		}
		label$578:;
		label$577:;
	}
	int64 vr$253 = fb_WstrLen( (uint16*)S2$1 );
	int64 vr$255 = fb_WstrLen( (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$253 == vr$255) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s1))" );
	int32 vr$260 = fb_WstrCompare( (uint16*)S2$1, (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$260 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s1)" );
	{
		int64 vr$265 = fb_WstrLen( (uint16*)S2$1 );
		int64 vr$267 = fb_WstrLen( (uint16*)S1$1 );
		if( vr$265 != vr$267) goto label$589;
		{
			label$590:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$186$5;
					int64 vr$269 = fb_WstrLen( (uint16*)S2$1 );
					TMP$186$5 = vr$269 + -1ll;
					goto label$593;
					label$596:;
					{
						if( (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll)))) goto label$598;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$591;
						}
						label$598:;
						label$597:;
					}
					label$594:;
					I$5 = I$5 + 1ll;
					label$593:;
					if( I$5 <= TMP$186$5) goto label$596;
					label$595:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$592:;
			label$591:;
		}
		label$589:;
		label$588:;
	}
	int64 vr$281 = fb_WstrLen( (uint16*)S2$1 );
	int64 vr$283 = fb_WstrLen( (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$281 == vr$283) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s2))" );
	int32 vr$288 = fb_WstrCompare( (uint16*)S2$1, (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$288 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s2)" );
	{
		int64 vr$293 = fb_WstrLen( (uint16*)S2$1 );
		int64 vr$295 = fb_WstrLen( (uint16*)S2$1 );
		if( vr$293 != vr$295) goto label$600;
		{
			label$601:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$192$5;
					int64 vr$297 = fb_WstrLen( (uint16*)S2$1 );
					TMP$192$5 = vr$297 + -1ll;
					goto label$604;
					label$607:;
					{
						goto label$609;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$602;
						}
						label$609:;
						label$608:;
					}
					label$605:;
					I$5 = I$5 + 1ll;
					label$604:;
					if( I$5 <= TMP$192$5) goto label$607;
					label$606:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$603:;
			label$602:;
		}
		label$600:;
		label$599:;
	}
	int64 vr$301 = fb_WstrLen( (uint16*)S2$1 );
	int64 vr$303 = fb_WstrLen( (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$301 == vr$303) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s3))" );
	int32 vr$308 = fb_WstrCompare( (uint16*)S2$1, (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$308 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s3)" );
	{
		int64 vr$313 = fb_WstrLen( (uint16*)S2$1 );
		int64 vr$315 = fb_WstrLen( (uint16*)S3$1 );
		if( vr$313 != vr$315) goto label$611;
		{
			label$612:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$198$5;
					int64 vr$317 = fb_WstrLen( (uint16*)S2$1 );
					TMP$198$5 = vr$317 + -1ll;
					goto label$615;
					label$618:;
					{
						if( (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll)))) goto label$620;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$613;
						}
						label$620:;
						label$619:;
					}
					label$616:;
					I$5 = I$5 + 1ll;
					label$615:;
					if( I$5 <= TMP$198$5) goto label$618;
					label$617:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$614:;
			label$613:;
		}
		label$611:;
		label$610:;
	}
	int64 vr$329 = fb_WstrLen( (uint16*)S2$1 );
	int64 vr$331 = fb_WstrLen( (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$329 == vr$331) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s4))" );
	int32 vr$336 = fb_WstrCompare( (uint16*)S2$1, (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$336 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s4)" );
	{
		int64 vr$341 = fb_WstrLen( (uint16*)S2$1 );
		int64 vr$343 = fb_WstrLen( (uint16*)S4$1 );
		if( vr$341 != vr$343) goto label$622;
		{
			label$623:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$204$5;
					int64 vr$345 = fb_WstrLen( (uint16*)S2$1 );
					TMP$204$5 = vr$345 + -1ll;
					goto label$626;
					label$629:;
					{
						if( (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll)))) goto label$631;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$624;
						}
						label$631:;
						label$630:;
					}
					label$627:;
					I$5 = I$5 + 1ll;
					label$626:;
					if( I$5 <= TMP$204$5) goto label$629;
					label$628:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$625:;
			label$624:;
		}
		label$622:;
		label$621:;
	}
	int64 vr$357 = fb_WstrLen( (uint16*)S2$1 );
	int64 vr$359 = fb_WstrLen( (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$357 == vr$359) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r1))" );
	int32 vr$364 = fb_WstrCompare( (uint16*)S2$1, (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$364 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r1)" );
	{
		int64 vr$369 = fb_WstrLen( (uint16*)S2$1 );
		int64 vr$371 = fb_WstrLen( (uint16*)R1$1 );
		if( vr$369 != vr$371) goto label$633;
		{
			label$634:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$210$5;
					int64 vr$373 = fb_WstrLen( (uint16*)S2$1 );
					TMP$210$5 = vr$373 + -1ll;
					goto label$637;
					label$640:;
					{
						if( (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll)))) goto label$642;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$635;
						}
						label$642:;
						label$641:;
					}
					label$638:;
					I$5 = I$5 + 1ll;
					label$637:;
					if( I$5 <= TMP$210$5) goto label$640;
					label$639:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$636:;
			label$635:;
		}
		label$633:;
		label$632:;
	}
	int64 vr$385 = fb_WstrLen( (uint16*)S2$1 );
	int64 vr$387 = fb_WstrLen( (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$385 == vr$387) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r2))" );
	int32 vr$392 = fb_WstrCompare( (uint16*)S2$1, (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$392 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r2)" );
	{
		int64 vr$397 = fb_WstrLen( (uint16*)S2$1 );
		int64 vr$399 = fb_WstrLen( (uint16*)R2$1 );
		if( vr$397 != vr$399) goto label$644;
		{
			label$645:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$216$5;
					int64 vr$401 = fb_WstrLen( (uint16*)S2$1 );
					TMP$216$5 = vr$401 + -1ll;
					goto label$648;
					label$651:;
					{
						if( (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll)))) goto label$653;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$646;
						}
						label$653:;
						label$652:;
					}
					label$649:;
					I$5 = I$5 + 1ll;
					label$648:;
					if( I$5 <= TMP$216$5) goto label$651;
					label$650:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$647:;
			label$646:;
		}
		label$644:;
		label$643:;
	}
	int64 vr$413 = fb_WstrLen( (uint16*)S2$1 );
	int64 vr$415 = fb_WstrLen( (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$413 == vr$415) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r3))" );
	int32 vr$420 = fb_WstrCompare( (uint16*)S2$1, (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$420 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r3)" );
	{
		int64 vr$425 = fb_WstrLen( (uint16*)S2$1 );
		int64 vr$427 = fb_WstrLen( (uint16*)R3$1 );
		if( vr$425 != vr$427) goto label$655;
		{
			label$656:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$222$5;
					int64 vr$429 = fb_WstrLen( (uint16*)S2$1 );
					TMP$222$5 = vr$429 + -1ll;
					goto label$659;
					label$662:;
					{
						if( (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll)))) goto label$664;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$657;
						}
						label$664:;
						label$663:;
					}
					label$660:;
					I$5 = I$5 + 1ll;
					label$659:;
					if( I$5 <= TMP$222$5) goto label$662;
					label$661:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$658:;
			label$657:;
		}
		label$655:;
		label$654:;
	}
	int64 vr$441 = fb_WstrLen( (uint16*)S2$1 );
	int64 vr$443 = fb_WstrLen( (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$441 == vr$443) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r4))" );
	int32 vr$448 = fb_WstrCompare( (uint16*)S2$1, (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$448 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r4)" );
	{
		int64 vr$453 = fb_WstrLen( (uint16*)S2$1 );
		int64 vr$455 = fb_WstrLen( (uint16*)R4$1 );
		if( vr$453 != vr$455) goto label$666;
		{
			label$667:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$228$5;
					int64 vr$457 = fb_WstrLen( (uint16*)S2$1 );
					TMP$228$5 = vr$457 + -1ll;
					goto label$670;
					label$673:;
					{
						if( (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll)))) goto label$675;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$668;
						}
						label$675:;
						label$674:;
					}
					label$671:;
					I$5 = I$5 + 1ll;
					label$670:;
					if( I$5 <= TMP$228$5) goto label$673;
					label$672:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$669:;
			label$668:;
		}
		label$666:;
		label$665:;
	}
	int64 vr$469 = fb_WstrLen( (uint16*)S3$1 );
	int64 vr$471 = fb_WstrLen( (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$469 == vr$471) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s1))" );
	int32 vr$476 = fb_WstrCompare( (uint16*)S3$1, (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$476 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s1)" );
	{
		int64 vr$481 = fb_WstrLen( (uint16*)S3$1 );
		int64 vr$483 = fb_WstrLen( (uint16*)S1$1 );
		if( vr$481 != vr$483) goto label$677;
		{
			label$678:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$236$5;
					int64 vr$485 = fb_WstrLen( (uint16*)S3$1 );
					TMP$236$5 = vr$485 + -1ll;
					goto label$681;
					label$684:;
					{
						if( (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll)))) goto label$686;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$679;
						}
						label$686:;
						label$685:;
					}
					label$682:;
					I$5 = I$5 + 1ll;
					label$681:;
					if( I$5 <= TMP$236$5) goto label$684;
					label$683:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$680:;
			label$679:;
		}
		label$677:;
		label$676:;
	}
	int64 vr$497 = fb_WstrLen( (uint16*)S3$1 );
	int64 vr$499 = fb_WstrLen( (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$497 == vr$499) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s2))" );
	int32 vr$504 = fb_WstrCompare( (uint16*)S3$1, (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$504 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s2)" );
	{
		int64 vr$509 = fb_WstrLen( (uint16*)S3$1 );
		int64 vr$511 = fb_WstrLen( (uint16*)S2$1 );
		if( vr$509 != vr$511) goto label$688;
		{
			label$689:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$242$5;
					int64 vr$513 = fb_WstrLen( (uint16*)S3$1 );
					TMP$242$5 = vr$513 + -1ll;
					goto label$692;
					label$695:;
					{
						if( (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll)))) goto label$697;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$690;
						}
						label$697:;
						label$696:;
					}
					label$693:;
					I$5 = I$5 + 1ll;
					label$692:;
					if( I$5 <= TMP$242$5) goto label$695;
					label$694:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$691:;
			label$690:;
		}
		label$688:;
		label$687:;
	}
	int64 vr$525 = fb_WstrLen( (uint16*)S3$1 );
	int64 vr$527 = fb_WstrLen( (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$525 == vr$527) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s3))" );
	int32 vr$532 = fb_WstrCompare( (uint16*)S3$1, (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$532 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s3)" );
	{
		int64 vr$537 = fb_WstrLen( (uint16*)S3$1 );
		int64 vr$539 = fb_WstrLen( (uint16*)S3$1 );
		if( vr$537 != vr$539) goto label$699;
		{
			label$700:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$248$5;
					int64 vr$541 = fb_WstrLen( (uint16*)S3$1 );
					TMP$248$5 = vr$541 + -1ll;
					goto label$703;
					label$706:;
					{
						goto label$708;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$701;
						}
						label$708:;
						label$707:;
					}
					label$704:;
					I$5 = I$5 + 1ll;
					label$703:;
					if( I$5 <= TMP$248$5) goto label$706;
					label$705:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$702:;
			label$701:;
		}
		label$699:;
		label$698:;
	}
	int64 vr$545 = fb_WstrLen( (uint16*)S3$1 );
	int64 vr$547 = fb_WstrLen( (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$545 == vr$547) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s4))" );
	int32 vr$552 = fb_WstrCompare( (uint16*)S3$1, (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$552 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s4)" );
	{
		int64 vr$557 = fb_WstrLen( (uint16*)S3$1 );
		int64 vr$559 = fb_WstrLen( (uint16*)S4$1 );
		if( vr$557 != vr$559) goto label$710;
		{
			label$711:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$254$5;
					int64 vr$561 = fb_WstrLen( (uint16*)S3$1 );
					TMP$254$5 = vr$561 + -1ll;
					goto label$714;
					label$717:;
					{
						if( (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll)))) goto label$719;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$712;
						}
						label$719:;
						label$718:;
					}
					label$715:;
					I$5 = I$5 + 1ll;
					label$714:;
					if( I$5 <= TMP$254$5) goto label$717;
					label$716:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$713:;
			label$712:;
		}
		label$710:;
		label$709:;
	}
	int64 vr$573 = fb_WstrLen( (uint16*)S3$1 );
	int64 vr$575 = fb_WstrLen( (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$573 == vr$575) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r1))" );
	int32 vr$580 = fb_WstrCompare( (uint16*)S3$1, (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$580 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r1)" );
	{
		int64 vr$585 = fb_WstrLen( (uint16*)S3$1 );
		int64 vr$587 = fb_WstrLen( (uint16*)R1$1 );
		if( vr$585 != vr$587) goto label$721;
		{
			label$722:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$260$5;
					int64 vr$589 = fb_WstrLen( (uint16*)S3$1 );
					TMP$260$5 = vr$589 + -1ll;
					goto label$725;
					label$728:;
					{
						if( (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll)))) goto label$730;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$723;
						}
						label$730:;
						label$729:;
					}
					label$726:;
					I$5 = I$5 + 1ll;
					label$725:;
					if( I$5 <= TMP$260$5) goto label$728;
					label$727:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$724:;
			label$723:;
		}
		label$721:;
		label$720:;
	}
	int64 vr$601 = fb_WstrLen( (uint16*)S3$1 );
	int64 vr$603 = fb_WstrLen( (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$601 == vr$603) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r2))" );
	int32 vr$608 = fb_WstrCompare( (uint16*)S3$1, (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$608 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r2)" );
	{
		int64 vr$613 = fb_WstrLen( (uint16*)S3$1 );
		int64 vr$615 = fb_WstrLen( (uint16*)R2$1 );
		if( vr$613 != vr$615) goto label$732;
		{
			label$733:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$266$5;
					int64 vr$617 = fb_WstrLen( (uint16*)S3$1 );
					TMP$266$5 = vr$617 + -1ll;
					goto label$736;
					label$739:;
					{
						if( (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll)))) goto label$741;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$734;
						}
						label$741:;
						label$740:;
					}
					label$737:;
					I$5 = I$5 + 1ll;
					label$736:;
					if( I$5 <= TMP$266$5) goto label$739;
					label$738:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$735:;
			label$734:;
		}
		label$732:;
		label$731:;
	}
	int64 vr$629 = fb_WstrLen( (uint16*)S3$1 );
	int64 vr$631 = fb_WstrLen( (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$629 == vr$631) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r3))" );
	int32 vr$636 = fb_WstrCompare( (uint16*)S3$1, (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$636 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r3)" );
	{
		int64 vr$641 = fb_WstrLen( (uint16*)S3$1 );
		int64 vr$643 = fb_WstrLen( (uint16*)R3$1 );
		if( vr$641 != vr$643) goto label$743;
		{
			label$744:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$272$5;
					int64 vr$645 = fb_WstrLen( (uint16*)S3$1 );
					TMP$272$5 = vr$645 + -1ll;
					goto label$747;
					label$750:;
					{
						if( (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll)))) goto label$752;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$745;
						}
						label$752:;
						label$751:;
					}
					label$748:;
					I$5 = I$5 + 1ll;
					label$747:;
					if( I$5 <= TMP$272$5) goto label$750;
					label$749:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$746:;
			label$745:;
		}
		label$743:;
		label$742:;
	}
	int64 vr$657 = fb_WstrLen( (uint16*)S3$1 );
	int64 vr$659 = fb_WstrLen( (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$657 == vr$659) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r4))" );
	int32 vr$664 = fb_WstrCompare( (uint16*)S3$1, (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$664 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r4)" );
	{
		int64 vr$669 = fb_WstrLen( (uint16*)S3$1 );
		int64 vr$671 = fb_WstrLen( (uint16*)R4$1 );
		if( vr$669 != vr$671) goto label$754;
		{
			label$755:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$278$5;
					int64 vr$673 = fb_WstrLen( (uint16*)S3$1 );
					TMP$278$5 = vr$673 + -1ll;
					goto label$758;
					label$761:;
					{
						if( (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll)))) goto label$763;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$756;
						}
						label$763:;
						label$762:;
					}
					label$759:;
					I$5 = I$5 + 1ll;
					label$758:;
					if( I$5 <= TMP$278$5) goto label$761;
					label$760:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$757:;
			label$756:;
		}
		label$754:;
		label$753:;
	}
	int64 vr$685 = fb_WstrLen( (uint16*)S4$1 );
	int64 vr$687 = fb_WstrLen( (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$685 == vr$687) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s1))" );
	int32 vr$692 = fb_WstrCompare( (uint16*)S4$1, (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$692 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s1)" );
	{
		int64 vr$697 = fb_WstrLen( (uint16*)S4$1 );
		int64 vr$699 = fb_WstrLen( (uint16*)S1$1 );
		if( vr$697 != vr$699) goto label$765;
		{
			label$766:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$286$5;
					int64 vr$701 = fb_WstrLen( (uint16*)S4$1 );
					TMP$286$5 = vr$701 + -1ll;
					goto label$769;
					label$772:;
					{
						if( (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll)))) goto label$774;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$767;
						}
						label$774:;
						label$773:;
					}
					label$770:;
					I$5 = I$5 + 1ll;
					label$769:;
					if( I$5 <= TMP$286$5) goto label$772;
					label$771:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$768:;
			label$767:;
		}
		label$765:;
		label$764:;
	}
	int64 vr$713 = fb_WstrLen( (uint16*)S4$1 );
	int64 vr$715 = fb_WstrLen( (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$713 == vr$715) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s2))" );
	int32 vr$720 = fb_WstrCompare( (uint16*)S4$1, (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$720 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s2)" );
	{
		int64 vr$725 = fb_WstrLen( (uint16*)S4$1 );
		int64 vr$727 = fb_WstrLen( (uint16*)S2$1 );
		if( vr$725 != vr$727) goto label$776;
		{
			label$777:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$292$5;
					int64 vr$729 = fb_WstrLen( (uint16*)S4$1 );
					TMP$292$5 = vr$729 + -1ll;
					goto label$780;
					label$783:;
					{
						if( (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll)))) goto label$785;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$778;
						}
						label$785:;
						label$784:;
					}
					label$781:;
					I$5 = I$5 + 1ll;
					label$780:;
					if( I$5 <= TMP$292$5) goto label$783;
					label$782:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$779:;
			label$778:;
		}
		label$776:;
		label$775:;
	}
	int64 vr$741 = fb_WstrLen( (uint16*)S4$1 );
	int64 vr$743 = fb_WstrLen( (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$741 == vr$743) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s3))" );
	int32 vr$748 = fb_WstrCompare( (uint16*)S4$1, (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$748 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s3)" );
	{
		int64 vr$753 = fb_WstrLen( (uint16*)S4$1 );
		int64 vr$755 = fb_WstrLen( (uint16*)S3$1 );
		if( vr$753 != vr$755) goto label$787;
		{
			label$788:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$298$5;
					int64 vr$757 = fb_WstrLen( (uint16*)S4$1 );
					TMP$298$5 = vr$757 + -1ll;
					goto label$791;
					label$794:;
					{
						if( (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll)))) goto label$796;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$789;
						}
						label$796:;
						label$795:;
					}
					label$792:;
					I$5 = I$5 + 1ll;
					label$791:;
					if( I$5 <= TMP$298$5) goto label$794;
					label$793:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$790:;
			label$789:;
		}
		label$787:;
		label$786:;
	}
	int64 vr$769 = fb_WstrLen( (uint16*)S4$1 );
	int64 vr$771 = fb_WstrLen( (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$769 == vr$771) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s4))" );
	int32 vr$776 = fb_WstrCompare( (uint16*)S4$1, (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$776 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s4)" );
	{
		int64 vr$781 = fb_WstrLen( (uint16*)S4$1 );
		int64 vr$783 = fb_WstrLen( (uint16*)S4$1 );
		if( vr$781 != vr$783) goto label$798;
		{
			label$799:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$304$5;
					int64 vr$785 = fb_WstrLen( (uint16*)S4$1 );
					TMP$304$5 = vr$785 + -1ll;
					goto label$802;
					label$805:;
					{
						goto label$807;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$800;
						}
						label$807:;
						label$806:;
					}
					label$803:;
					I$5 = I$5 + 1ll;
					label$802:;
					if( I$5 <= TMP$304$5) goto label$805;
					label$804:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$801:;
			label$800:;
		}
		label$798:;
		label$797:;
	}
	int64 vr$789 = fb_WstrLen( (uint16*)S4$1 );
	int64 vr$791 = fb_WstrLen( (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$789 == vr$791) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r1))" );
	int32 vr$796 = fb_WstrCompare( (uint16*)S4$1, (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$796 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r1)" );
	{
		int64 vr$801 = fb_WstrLen( (uint16*)S4$1 );
		int64 vr$803 = fb_WstrLen( (uint16*)R1$1 );
		if( vr$801 != vr$803) goto label$809;
		{
			label$810:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$310$5;
					int64 vr$805 = fb_WstrLen( (uint16*)S4$1 );
					TMP$310$5 = vr$805 + -1ll;
					goto label$813;
					label$816:;
					{
						if( (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll)))) goto label$818;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$811;
						}
						label$818:;
						label$817:;
					}
					label$814:;
					I$5 = I$5 + 1ll;
					label$813:;
					if( I$5 <= TMP$310$5) goto label$816;
					label$815:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$812:;
			label$811:;
		}
		label$809:;
		label$808:;
	}
	int64 vr$817 = fb_WstrLen( (uint16*)S4$1 );
	int64 vr$819 = fb_WstrLen( (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$817 == vr$819) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r2))" );
	int32 vr$824 = fb_WstrCompare( (uint16*)S4$1, (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$824 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r2)" );
	{
		int64 vr$829 = fb_WstrLen( (uint16*)S4$1 );
		int64 vr$831 = fb_WstrLen( (uint16*)R2$1 );
		if( vr$829 != vr$831) goto label$820;
		{
			label$821:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$316$5;
					int64 vr$833 = fb_WstrLen( (uint16*)S4$1 );
					TMP$316$5 = vr$833 + -1ll;
					goto label$824;
					label$827:;
					{
						if( (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll)))) goto label$829;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$822;
						}
						label$829:;
						label$828:;
					}
					label$825:;
					I$5 = I$5 + 1ll;
					label$824:;
					if( I$5 <= TMP$316$5) goto label$827;
					label$826:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$823:;
			label$822:;
		}
		label$820:;
		label$819:;
	}
	int64 vr$845 = fb_WstrLen( (uint16*)S4$1 );
	int64 vr$847 = fb_WstrLen( (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$845 == vr$847) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r3))" );
	int32 vr$852 = fb_WstrCompare( (uint16*)S4$1, (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$852 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r3)" );
	{
		int64 vr$857 = fb_WstrLen( (uint16*)S4$1 );
		int64 vr$859 = fb_WstrLen( (uint16*)R3$1 );
		if( vr$857 != vr$859) goto label$831;
		{
			label$832:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$322$5;
					int64 vr$861 = fb_WstrLen( (uint16*)S4$1 );
					TMP$322$5 = vr$861 + -1ll;
					goto label$835;
					label$838:;
					{
						if( (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll)))) goto label$840;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$833;
						}
						label$840:;
						label$839:;
					}
					label$836:;
					I$5 = I$5 + 1ll;
					label$835:;
					if( I$5 <= TMP$322$5) goto label$838;
					label$837:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$834:;
			label$833:;
		}
		label$831:;
		label$830:;
	}
	int64 vr$873 = fb_WstrLen( (uint16*)S4$1 );
	int64 vr$875 = fb_WstrLen( (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$873 == vr$875) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r4))" );
	int32 vr$880 = fb_WstrCompare( (uint16*)S4$1, (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$880 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r4)" );
	{
		int64 vr$885 = fb_WstrLen( (uint16*)S4$1 );
		int64 vr$887 = fb_WstrLen( (uint16*)R4$1 );
		if( vr$885 != vr$887) goto label$842;
		{
			label$843:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$328$5;
					int64 vr$889 = fb_WstrLen( (uint16*)S4$1 );
					TMP$328$5 = vr$889 + -1ll;
					goto label$846;
					label$849:;
					{
						if( (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll)))) goto label$851;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$844;
						}
						label$851:;
						label$850:;
					}
					label$847:;
					I$5 = I$5 + 1ll;
					label$846:;
					if( I$5 <= TMP$328$5) goto label$849;
					label$848:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$845:;
			label$844:;
		}
		label$842:;
		label$841:;
	}
	int64 vr$901 = fb_WstrLen( (uint16*)R1$1 );
	int64 vr$903 = fb_WstrLen( (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$901 == vr$903) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s1))" );
	int32 vr$908 = fb_WstrCompare( (uint16*)R1$1, (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$908 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s1)" );
	{
		int64 vr$913 = fb_WstrLen( (uint16*)R1$1 );
		int64 vr$915 = fb_WstrLen( (uint16*)S1$1 );
		if( vr$913 != vr$915) goto label$853;
		{
			label$854:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$336$5;
					int64 vr$917 = fb_WstrLen( (uint16*)R1$1 );
					TMP$336$5 = vr$917 + -1ll;
					goto label$857;
					label$860:;
					{
						if( (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll)))) goto label$862;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$855;
						}
						label$862:;
						label$861:;
					}
					label$858:;
					I$5 = I$5 + 1ll;
					label$857:;
					if( I$5 <= TMP$336$5) goto label$860;
					label$859:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$856:;
			label$855:;
		}
		label$853:;
		label$852:;
	}
	int64 vr$929 = fb_WstrLen( (uint16*)R1$1 );
	int64 vr$931 = fb_WstrLen( (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$929 == vr$931) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s2))" );
	int32 vr$936 = fb_WstrCompare( (uint16*)R1$1, (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$936 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s2)" );
	{
		int64 vr$941 = fb_WstrLen( (uint16*)R1$1 );
		int64 vr$943 = fb_WstrLen( (uint16*)S2$1 );
		if( vr$941 != vr$943) goto label$864;
		{
			label$865:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$342$5;
					int64 vr$945 = fb_WstrLen( (uint16*)R1$1 );
					TMP$342$5 = vr$945 + -1ll;
					goto label$868;
					label$871:;
					{
						if( (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll)))) goto label$873;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$866;
						}
						label$873:;
						label$872:;
					}
					label$869:;
					I$5 = I$5 + 1ll;
					label$868:;
					if( I$5 <= TMP$342$5) goto label$871;
					label$870:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$867:;
			label$866:;
		}
		label$864:;
		label$863:;
	}
	int64 vr$957 = fb_WstrLen( (uint16*)R1$1 );
	int64 vr$959 = fb_WstrLen( (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$957 == vr$959) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s3))" );
	int32 vr$964 = fb_WstrCompare( (uint16*)R1$1, (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$964 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s3)" );
	{
		int64 vr$969 = fb_WstrLen( (uint16*)R1$1 );
		int64 vr$971 = fb_WstrLen( (uint16*)S3$1 );
		if( vr$969 != vr$971) goto label$875;
		{
			label$876:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$348$5;
					int64 vr$973 = fb_WstrLen( (uint16*)R1$1 );
					TMP$348$5 = vr$973 + -1ll;
					goto label$879;
					label$882:;
					{
						if( (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll)))) goto label$884;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$877;
						}
						label$884:;
						label$883:;
					}
					label$880:;
					I$5 = I$5 + 1ll;
					label$879:;
					if( I$5 <= TMP$348$5) goto label$882;
					label$881:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$878:;
			label$877:;
		}
		label$875:;
		label$874:;
	}
	int64 vr$985 = fb_WstrLen( (uint16*)R1$1 );
	int64 vr$987 = fb_WstrLen( (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$985 == vr$987) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s4))" );
	int32 vr$992 = fb_WstrCompare( (uint16*)R1$1, (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$992 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s4)" );
	{
		int64 vr$997 = fb_WstrLen( (uint16*)R1$1 );
		int64 vr$999 = fb_WstrLen( (uint16*)S4$1 );
		if( vr$997 != vr$999) goto label$886;
		{
			label$887:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$354$5;
					int64 vr$1001 = fb_WstrLen( (uint16*)R1$1 );
					TMP$354$5 = vr$1001 + -1ll;
					goto label$890;
					label$893:;
					{
						if( (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll)))) goto label$895;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$888;
						}
						label$895:;
						label$894:;
					}
					label$891:;
					I$5 = I$5 + 1ll;
					label$890:;
					if( I$5 <= TMP$354$5) goto label$893;
					label$892:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$889:;
			label$888:;
		}
		label$886:;
		label$885:;
	}
	int64 vr$1013 = fb_WstrLen( (uint16*)R1$1 );
	int64 vr$1015 = fb_WstrLen( (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1013 == vr$1015) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r1))" );
	int32 vr$1020 = fb_WstrCompare( (uint16*)R1$1, (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1020 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r1)" );
	{
		int64 vr$1025 = fb_WstrLen( (uint16*)R1$1 );
		int64 vr$1027 = fb_WstrLen( (uint16*)R1$1 );
		if( vr$1025 != vr$1027) goto label$897;
		{
			label$898:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$360$5;
					int64 vr$1029 = fb_WstrLen( (uint16*)R1$1 );
					TMP$360$5 = vr$1029 + -1ll;
					goto label$901;
					label$904:;
					{
						goto label$906;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$899;
						}
						label$906:;
						label$905:;
					}
					label$902:;
					I$5 = I$5 + 1ll;
					label$901:;
					if( I$5 <= TMP$360$5) goto label$904;
					label$903:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$900:;
			label$899:;
		}
		label$897:;
		label$896:;
	}
	int64 vr$1033 = fb_WstrLen( (uint16*)R1$1 );
	int64 vr$1035 = fb_WstrLen( (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1033 == vr$1035) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r2))" );
	int32 vr$1040 = fb_WstrCompare( (uint16*)R1$1, (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1040 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r2)" );
	{
		int64 vr$1045 = fb_WstrLen( (uint16*)R1$1 );
		int64 vr$1047 = fb_WstrLen( (uint16*)R2$1 );
		if( vr$1045 != vr$1047) goto label$908;
		{
			label$909:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$366$5;
					int64 vr$1049 = fb_WstrLen( (uint16*)R1$1 );
					TMP$366$5 = vr$1049 + -1ll;
					goto label$912;
					label$915:;
					{
						if( (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll)))) goto label$917;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$910;
						}
						label$917:;
						label$916:;
					}
					label$913:;
					I$5 = I$5 + 1ll;
					label$912:;
					if( I$5 <= TMP$366$5) goto label$915;
					label$914:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$911:;
			label$910:;
		}
		label$908:;
		label$907:;
	}
	int64 vr$1061 = fb_WstrLen( (uint16*)R1$1 );
	int64 vr$1063 = fb_WstrLen( (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1061 == vr$1063) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r3))" );
	int32 vr$1068 = fb_WstrCompare( (uint16*)R1$1, (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1068 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r3)" );
	{
		int64 vr$1073 = fb_WstrLen( (uint16*)R1$1 );
		int64 vr$1075 = fb_WstrLen( (uint16*)R3$1 );
		if( vr$1073 != vr$1075) goto label$919;
		{
			label$920:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$372$5;
					int64 vr$1077 = fb_WstrLen( (uint16*)R1$1 );
					TMP$372$5 = vr$1077 + -1ll;
					goto label$923;
					label$926:;
					{
						if( (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll)))) goto label$928;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$921;
						}
						label$928:;
						label$927:;
					}
					label$924:;
					I$5 = I$5 + 1ll;
					label$923:;
					if( I$5 <= TMP$372$5) goto label$926;
					label$925:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$922:;
			label$921:;
		}
		label$919:;
		label$918:;
	}
	int64 vr$1089 = fb_WstrLen( (uint16*)R1$1 );
	int64 vr$1091 = fb_WstrLen( (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1089 == vr$1091) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r4))" );
	int32 vr$1096 = fb_WstrCompare( (uint16*)R1$1, (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1096 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r4)" );
	{
		int64 vr$1101 = fb_WstrLen( (uint16*)R1$1 );
		int64 vr$1103 = fb_WstrLen( (uint16*)R4$1 );
		if( vr$1101 != vr$1103) goto label$930;
		{
			label$931:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$378$5;
					int64 vr$1105 = fb_WstrLen( (uint16*)R1$1 );
					TMP$378$5 = vr$1105 + -1ll;
					goto label$934;
					label$937:;
					{
						if( (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll)))) goto label$939;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$932;
						}
						label$939:;
						label$938:;
					}
					label$935:;
					I$5 = I$5 + 1ll;
					label$934:;
					if( I$5 <= TMP$378$5) goto label$937;
					label$936:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$933:;
			label$932:;
		}
		label$930:;
		label$929:;
	}
	int64 vr$1117 = fb_WstrLen( (uint16*)R2$1 );
	int64 vr$1119 = fb_WstrLen( (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1117 == vr$1119) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s1))" );
	int32 vr$1124 = fb_WstrCompare( (uint16*)R2$1, (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1124 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s1)" );
	{
		int64 vr$1129 = fb_WstrLen( (uint16*)R2$1 );
		int64 vr$1131 = fb_WstrLen( (uint16*)S1$1 );
		if( vr$1129 != vr$1131) goto label$941;
		{
			label$942:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$386$5;
					int64 vr$1133 = fb_WstrLen( (uint16*)R2$1 );
					TMP$386$5 = vr$1133 + -1ll;
					goto label$945;
					label$948:;
					{
						if( (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll)))) goto label$950;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$943;
						}
						label$950:;
						label$949:;
					}
					label$946:;
					I$5 = I$5 + 1ll;
					label$945:;
					if( I$5 <= TMP$386$5) goto label$948;
					label$947:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$944:;
			label$943:;
		}
		label$941:;
		label$940:;
	}
	int64 vr$1145 = fb_WstrLen( (uint16*)R2$1 );
	int64 vr$1147 = fb_WstrLen( (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1145 == vr$1147) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s2))" );
	int32 vr$1152 = fb_WstrCompare( (uint16*)R2$1, (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1152 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s2)" );
	{
		int64 vr$1157 = fb_WstrLen( (uint16*)R2$1 );
		int64 vr$1159 = fb_WstrLen( (uint16*)S2$1 );
		if( vr$1157 != vr$1159) goto label$952;
		{
			label$953:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$392$5;
					int64 vr$1161 = fb_WstrLen( (uint16*)R2$1 );
					TMP$392$5 = vr$1161 + -1ll;
					goto label$956;
					label$959:;
					{
						if( (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll)))) goto label$961;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$954;
						}
						label$961:;
						label$960:;
					}
					label$957:;
					I$5 = I$5 + 1ll;
					label$956:;
					if( I$5 <= TMP$392$5) goto label$959;
					label$958:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$955:;
			label$954:;
		}
		label$952:;
		label$951:;
	}
	int64 vr$1173 = fb_WstrLen( (uint16*)R2$1 );
	int64 vr$1175 = fb_WstrLen( (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1173 == vr$1175) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s3))" );
	int32 vr$1180 = fb_WstrCompare( (uint16*)R2$1, (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1180 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s3)" );
	{
		int64 vr$1185 = fb_WstrLen( (uint16*)R2$1 );
		int64 vr$1187 = fb_WstrLen( (uint16*)S3$1 );
		if( vr$1185 != vr$1187) goto label$963;
		{
			label$964:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$398$5;
					int64 vr$1189 = fb_WstrLen( (uint16*)R2$1 );
					TMP$398$5 = vr$1189 + -1ll;
					goto label$967;
					label$970:;
					{
						if( (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll)))) goto label$972;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$965;
						}
						label$972:;
						label$971:;
					}
					label$968:;
					I$5 = I$5 + 1ll;
					label$967:;
					if( I$5 <= TMP$398$5) goto label$970;
					label$969:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$966:;
			label$965:;
		}
		label$963:;
		label$962:;
	}
	int64 vr$1201 = fb_WstrLen( (uint16*)R2$1 );
	int64 vr$1203 = fb_WstrLen( (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1201 == vr$1203) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s4))" );
	int32 vr$1208 = fb_WstrCompare( (uint16*)R2$1, (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1208 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s4)" );
	{
		int64 vr$1213 = fb_WstrLen( (uint16*)R2$1 );
		int64 vr$1215 = fb_WstrLen( (uint16*)S4$1 );
		if( vr$1213 != vr$1215) goto label$974;
		{
			label$975:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$404$5;
					int64 vr$1217 = fb_WstrLen( (uint16*)R2$1 );
					TMP$404$5 = vr$1217 + -1ll;
					goto label$978;
					label$981:;
					{
						if( (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll)))) goto label$983;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$976;
						}
						label$983:;
						label$982:;
					}
					label$979:;
					I$5 = I$5 + 1ll;
					label$978:;
					if( I$5 <= TMP$404$5) goto label$981;
					label$980:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$977:;
			label$976:;
		}
		label$974:;
		label$973:;
	}
	int64 vr$1229 = fb_WstrLen( (uint16*)R2$1 );
	int64 vr$1231 = fb_WstrLen( (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1229 == vr$1231) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r1))" );
	int32 vr$1236 = fb_WstrCompare( (uint16*)R2$1, (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1236 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r1)" );
	{
		int64 vr$1241 = fb_WstrLen( (uint16*)R2$1 );
		int64 vr$1243 = fb_WstrLen( (uint16*)R1$1 );
		if( vr$1241 != vr$1243) goto label$985;
		{
			label$986:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$410$5;
					int64 vr$1245 = fb_WstrLen( (uint16*)R2$1 );
					TMP$410$5 = vr$1245 + -1ll;
					goto label$989;
					label$992:;
					{
						if( (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll)))) goto label$994;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$987;
						}
						label$994:;
						label$993:;
					}
					label$990:;
					I$5 = I$5 + 1ll;
					label$989:;
					if( I$5 <= TMP$410$5) goto label$992;
					label$991:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$988:;
			label$987:;
		}
		label$985:;
		label$984:;
	}
	int64 vr$1257 = fb_WstrLen( (uint16*)R2$1 );
	int64 vr$1259 = fb_WstrLen( (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1257 == vr$1259) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r2))" );
	int32 vr$1264 = fb_WstrCompare( (uint16*)R2$1, (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1264 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r2)" );
	{
		int64 vr$1269 = fb_WstrLen( (uint16*)R2$1 );
		int64 vr$1271 = fb_WstrLen( (uint16*)R2$1 );
		if( vr$1269 != vr$1271) goto label$996;
		{
			label$997:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$416$5;
					int64 vr$1273 = fb_WstrLen( (uint16*)R2$1 );
					TMP$416$5 = vr$1273 + -1ll;
					goto label$1000;
					label$1003:;
					{
						goto label$1005;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$998;
						}
						label$1005:;
						label$1004:;
					}
					label$1001:;
					I$5 = I$5 + 1ll;
					label$1000:;
					if( I$5 <= TMP$416$5) goto label$1003;
					label$1002:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$999:;
			label$998:;
		}
		label$996:;
		label$995:;
	}
	int64 vr$1277 = fb_WstrLen( (uint16*)R2$1 );
	int64 vr$1279 = fb_WstrLen( (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1277 == vr$1279) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r3))" );
	int32 vr$1284 = fb_WstrCompare( (uint16*)R2$1, (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1284 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r3)" );
	{
		int64 vr$1289 = fb_WstrLen( (uint16*)R2$1 );
		int64 vr$1291 = fb_WstrLen( (uint16*)R3$1 );
		if( vr$1289 != vr$1291) goto label$1007;
		{
			label$1008:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$422$5;
					int64 vr$1293 = fb_WstrLen( (uint16*)R2$1 );
					TMP$422$5 = vr$1293 + -1ll;
					goto label$1011;
					label$1014:;
					{
						if( (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll)))) goto label$1016;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1009;
						}
						label$1016:;
						label$1015:;
					}
					label$1012:;
					I$5 = I$5 + 1ll;
					label$1011:;
					if( I$5 <= TMP$422$5) goto label$1014;
					label$1013:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1010:;
			label$1009:;
		}
		label$1007:;
		label$1006:;
	}
	int64 vr$1305 = fb_WstrLen( (uint16*)R2$1 );
	int64 vr$1307 = fb_WstrLen( (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1305 == vr$1307) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r4))" );
	int32 vr$1312 = fb_WstrCompare( (uint16*)R2$1, (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1312 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r4)" );
	{
		int64 vr$1317 = fb_WstrLen( (uint16*)R2$1 );
		int64 vr$1319 = fb_WstrLen( (uint16*)R4$1 );
		if( vr$1317 != vr$1319) goto label$1018;
		{
			label$1019:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$428$5;
					int64 vr$1321 = fb_WstrLen( (uint16*)R2$1 );
					TMP$428$5 = vr$1321 + -1ll;
					goto label$1022;
					label$1025:;
					{
						if( (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll)))) goto label$1027;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1020;
						}
						label$1027:;
						label$1026:;
					}
					label$1023:;
					I$5 = I$5 + 1ll;
					label$1022:;
					if( I$5 <= TMP$428$5) goto label$1025;
					label$1024:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1021:;
			label$1020:;
		}
		label$1018:;
		label$1017:;
	}
	int64 vr$1333 = fb_WstrLen( (uint16*)R3$1 );
	int64 vr$1335 = fb_WstrLen( (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1333 == vr$1335) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s1))" );
	int32 vr$1340 = fb_WstrCompare( (uint16*)R3$1, (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1340 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s1)" );
	{
		int64 vr$1345 = fb_WstrLen( (uint16*)R3$1 );
		int64 vr$1347 = fb_WstrLen( (uint16*)S1$1 );
		if( vr$1345 != vr$1347) goto label$1029;
		{
			label$1030:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$436$5;
					int64 vr$1349 = fb_WstrLen( (uint16*)R3$1 );
					TMP$436$5 = vr$1349 + -1ll;
					goto label$1033;
					label$1036:;
					{
						if( (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll)))) goto label$1038;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1031;
						}
						label$1038:;
						label$1037:;
					}
					label$1034:;
					I$5 = I$5 + 1ll;
					label$1033:;
					if( I$5 <= TMP$436$5) goto label$1036;
					label$1035:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1032:;
			label$1031:;
		}
		label$1029:;
		label$1028:;
	}
	int64 vr$1361 = fb_WstrLen( (uint16*)R3$1 );
	int64 vr$1363 = fb_WstrLen( (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1361 == vr$1363) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s2))" );
	int32 vr$1368 = fb_WstrCompare( (uint16*)R3$1, (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1368 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s2)" );
	{
		int64 vr$1373 = fb_WstrLen( (uint16*)R3$1 );
		int64 vr$1375 = fb_WstrLen( (uint16*)S2$1 );
		if( vr$1373 != vr$1375) goto label$1040;
		{
			label$1041:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$442$5;
					int64 vr$1377 = fb_WstrLen( (uint16*)R3$1 );
					TMP$442$5 = vr$1377 + -1ll;
					goto label$1044;
					label$1047:;
					{
						if( (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll)))) goto label$1049;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1042;
						}
						label$1049:;
						label$1048:;
					}
					label$1045:;
					I$5 = I$5 + 1ll;
					label$1044:;
					if( I$5 <= TMP$442$5) goto label$1047;
					label$1046:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1043:;
			label$1042:;
		}
		label$1040:;
		label$1039:;
	}
	int64 vr$1389 = fb_WstrLen( (uint16*)R3$1 );
	int64 vr$1391 = fb_WstrLen( (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1389 == vr$1391) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s3))" );
	int32 vr$1396 = fb_WstrCompare( (uint16*)R3$1, (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1396 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s3)" );
	{
		int64 vr$1401 = fb_WstrLen( (uint16*)R3$1 );
		int64 vr$1403 = fb_WstrLen( (uint16*)S3$1 );
		if( vr$1401 != vr$1403) goto label$1051;
		{
			label$1052:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$448$5;
					int64 vr$1405 = fb_WstrLen( (uint16*)R3$1 );
					TMP$448$5 = vr$1405 + -1ll;
					goto label$1055;
					label$1058:;
					{
						if( (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll)))) goto label$1060;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1053;
						}
						label$1060:;
						label$1059:;
					}
					label$1056:;
					I$5 = I$5 + 1ll;
					label$1055:;
					if( I$5 <= TMP$448$5) goto label$1058;
					label$1057:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1054:;
			label$1053:;
		}
		label$1051:;
		label$1050:;
	}
	int64 vr$1417 = fb_WstrLen( (uint16*)R3$1 );
	int64 vr$1419 = fb_WstrLen( (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1417 == vr$1419) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s4))" );
	int32 vr$1424 = fb_WstrCompare( (uint16*)R3$1, (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1424 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s4)" );
	{
		int64 vr$1429 = fb_WstrLen( (uint16*)R3$1 );
		int64 vr$1431 = fb_WstrLen( (uint16*)S4$1 );
		if( vr$1429 != vr$1431) goto label$1062;
		{
			label$1063:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$454$5;
					int64 vr$1433 = fb_WstrLen( (uint16*)R3$1 );
					TMP$454$5 = vr$1433 + -1ll;
					goto label$1066;
					label$1069:;
					{
						if( (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll)))) goto label$1071;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1064;
						}
						label$1071:;
						label$1070:;
					}
					label$1067:;
					I$5 = I$5 + 1ll;
					label$1066:;
					if( I$5 <= TMP$454$5) goto label$1069;
					label$1068:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1065:;
			label$1064:;
		}
		label$1062:;
		label$1061:;
	}
	int64 vr$1445 = fb_WstrLen( (uint16*)R3$1 );
	int64 vr$1447 = fb_WstrLen( (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1445 == vr$1447) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r1))" );
	int32 vr$1452 = fb_WstrCompare( (uint16*)R3$1, (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1452 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r1)" );
	{
		int64 vr$1457 = fb_WstrLen( (uint16*)R3$1 );
		int64 vr$1459 = fb_WstrLen( (uint16*)R1$1 );
		if( vr$1457 != vr$1459) goto label$1073;
		{
			label$1074:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$460$5;
					int64 vr$1461 = fb_WstrLen( (uint16*)R3$1 );
					TMP$460$5 = vr$1461 + -1ll;
					goto label$1077;
					label$1080:;
					{
						if( (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll)))) goto label$1082;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1075;
						}
						label$1082:;
						label$1081:;
					}
					label$1078:;
					I$5 = I$5 + 1ll;
					label$1077:;
					if( I$5 <= TMP$460$5) goto label$1080;
					label$1079:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1076:;
			label$1075:;
		}
		label$1073:;
		label$1072:;
	}
	int64 vr$1473 = fb_WstrLen( (uint16*)R3$1 );
	int64 vr$1475 = fb_WstrLen( (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1473 == vr$1475) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r2))" );
	int32 vr$1480 = fb_WstrCompare( (uint16*)R3$1, (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1480 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r2)" );
	{
		int64 vr$1485 = fb_WstrLen( (uint16*)R3$1 );
		int64 vr$1487 = fb_WstrLen( (uint16*)R2$1 );
		if( vr$1485 != vr$1487) goto label$1084;
		{
			label$1085:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$466$5;
					int64 vr$1489 = fb_WstrLen( (uint16*)R3$1 );
					TMP$466$5 = vr$1489 + -1ll;
					goto label$1088;
					label$1091:;
					{
						if( (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll)))) goto label$1093;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1086;
						}
						label$1093:;
						label$1092:;
					}
					label$1089:;
					I$5 = I$5 + 1ll;
					label$1088:;
					if( I$5 <= TMP$466$5) goto label$1091;
					label$1090:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1087:;
			label$1086:;
		}
		label$1084:;
		label$1083:;
	}
	int64 vr$1501 = fb_WstrLen( (uint16*)R3$1 );
	int64 vr$1503 = fb_WstrLen( (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1501 == vr$1503) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r3))" );
	int32 vr$1508 = fb_WstrCompare( (uint16*)R3$1, (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1508 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r3)" );
	{
		int64 vr$1513 = fb_WstrLen( (uint16*)R3$1 );
		int64 vr$1515 = fb_WstrLen( (uint16*)R3$1 );
		if( vr$1513 != vr$1515) goto label$1095;
		{
			label$1096:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$472$5;
					int64 vr$1517 = fb_WstrLen( (uint16*)R3$1 );
					TMP$472$5 = vr$1517 + -1ll;
					goto label$1099;
					label$1102:;
					{
						goto label$1104;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1097;
						}
						label$1104:;
						label$1103:;
					}
					label$1100:;
					I$5 = I$5 + 1ll;
					label$1099:;
					if( I$5 <= TMP$472$5) goto label$1102;
					label$1101:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1098:;
			label$1097:;
		}
		label$1095:;
		label$1094:;
	}
	int64 vr$1521 = fb_WstrLen( (uint16*)R3$1 );
	int64 vr$1523 = fb_WstrLen( (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1521 == vr$1523) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r4))" );
	int32 vr$1528 = fb_WstrCompare( (uint16*)R3$1, (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1528 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r4)" );
	{
		int64 vr$1533 = fb_WstrLen( (uint16*)R3$1 );
		int64 vr$1535 = fb_WstrLen( (uint16*)R4$1 );
		if( vr$1533 != vr$1535) goto label$1106;
		{
			label$1107:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$478$5;
					int64 vr$1537 = fb_WstrLen( (uint16*)R3$1 );
					TMP$478$5 = vr$1537 + -1ll;
					goto label$1110;
					label$1113:;
					{
						if( (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll)))) goto label$1115;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1108;
						}
						label$1115:;
						label$1114:;
					}
					label$1111:;
					I$5 = I$5 + 1ll;
					label$1110:;
					if( I$5 <= TMP$478$5) goto label$1113;
					label$1112:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1109:;
			label$1108:;
		}
		label$1106:;
		label$1105:;
	}
	int64 vr$1549 = fb_WstrLen( (uint16*)R4$1 );
	int64 vr$1551 = fb_WstrLen( (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1549 == vr$1551) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s1))" );
	int32 vr$1556 = fb_WstrCompare( (uint16*)R4$1, (uint16*)S1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1556 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s1)" );
	{
		int64 vr$1561 = fb_WstrLen( (uint16*)R4$1 );
		int64 vr$1563 = fb_WstrLen( (uint16*)S1$1 );
		if( vr$1561 != vr$1563) goto label$1117;
		{
			label$1118:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$486$5;
					int64 vr$1565 = fb_WstrLen( (uint16*)R4$1 );
					TMP$486$5 = vr$1565 + -1ll;
					goto label$1121;
					label$1124:;
					{
						if( (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S1$1 + (I$5 << (1ll & 63ll)))) goto label$1126;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1119;
						}
						label$1126:;
						label$1125:;
					}
					label$1122:;
					I$5 = I$5 + 1ll;
					label$1121:;
					if( I$5 <= TMP$486$5) goto label$1124;
					label$1123:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1120:;
			label$1119:;
		}
		label$1117:;
		label$1116:;
	}
	int64 vr$1577 = fb_WstrLen( (uint16*)R4$1 );
	int64 vr$1579 = fb_WstrLen( (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1577 == vr$1579) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s2))" );
	int32 vr$1584 = fb_WstrCompare( (uint16*)R4$1, (uint16*)S2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1584 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s2)" );
	{
		int64 vr$1589 = fb_WstrLen( (uint16*)R4$1 );
		int64 vr$1591 = fb_WstrLen( (uint16*)S2$1 );
		if( vr$1589 != vr$1591) goto label$1128;
		{
			label$1129:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$492$5;
					int64 vr$1593 = fb_WstrLen( (uint16*)R4$1 );
					TMP$492$5 = vr$1593 + -1ll;
					goto label$1132;
					label$1135:;
					{
						if( (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S2$1 + (I$5 << (1ll & 63ll)))) goto label$1137;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1130;
						}
						label$1137:;
						label$1136:;
					}
					label$1133:;
					I$5 = I$5 + 1ll;
					label$1132:;
					if( I$5 <= TMP$492$5) goto label$1135;
					label$1134:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1131:;
			label$1130:;
		}
		label$1128:;
		label$1127:;
	}
	int64 vr$1605 = fb_WstrLen( (uint16*)R4$1 );
	int64 vr$1607 = fb_WstrLen( (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1605 == vr$1607) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s3))" );
	int32 vr$1612 = fb_WstrCompare( (uint16*)R4$1, (uint16*)S3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1612 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s3)" );
	{
		int64 vr$1617 = fb_WstrLen( (uint16*)R4$1 );
		int64 vr$1619 = fb_WstrLen( (uint16*)S3$1 );
		if( vr$1617 != vr$1619) goto label$1139;
		{
			label$1140:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$498$5;
					int64 vr$1621 = fb_WstrLen( (uint16*)R4$1 );
					TMP$498$5 = vr$1621 + -1ll;
					goto label$1143;
					label$1146:;
					{
						if( (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S3$1 + (I$5 << (1ll & 63ll)))) goto label$1148;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1141;
						}
						label$1148:;
						label$1147:;
					}
					label$1144:;
					I$5 = I$5 + 1ll;
					label$1143:;
					if( I$5 <= TMP$498$5) goto label$1146;
					label$1145:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1142:;
			label$1141:;
		}
		label$1139:;
		label$1138:;
	}
	int64 vr$1633 = fb_WstrLen( (uint16*)R4$1 );
	int64 vr$1635 = fb_WstrLen( (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1633 == vr$1635) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s4))" );
	int32 vr$1640 = fb_WstrCompare( (uint16*)R4$1, (uint16*)S4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1640 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s4)" );
	{
		int64 vr$1645 = fb_WstrLen( (uint16*)R4$1 );
		int64 vr$1647 = fb_WstrLen( (uint16*)S4$1 );
		if( vr$1645 != vr$1647) goto label$1150;
		{
			label$1151:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$504$5;
					int64 vr$1649 = fb_WstrLen( (uint16*)R4$1 );
					TMP$504$5 = vr$1649 + -1ll;
					goto label$1154;
					label$1157:;
					{
						if( (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)S4$1 + (I$5 << (1ll & 63ll)))) goto label$1159;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1152;
						}
						label$1159:;
						label$1158:;
					}
					label$1155:;
					I$5 = I$5 + 1ll;
					label$1154:;
					if( I$5 <= TMP$504$5) goto label$1157;
					label$1156:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1153:;
			label$1152:;
		}
		label$1150:;
		label$1149:;
	}
	int64 vr$1661 = fb_WstrLen( (uint16*)R4$1 );
	int64 vr$1663 = fb_WstrLen( (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1661 == vr$1663) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r1))" );
	int32 vr$1668 = fb_WstrCompare( (uint16*)R4$1, (uint16*)R1$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1668 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r1)" );
	{
		int64 vr$1673 = fb_WstrLen( (uint16*)R4$1 );
		int64 vr$1675 = fb_WstrLen( (uint16*)R1$1 );
		if( vr$1673 != vr$1675) goto label$1161;
		{
			label$1162:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$510$5;
					int64 vr$1677 = fb_WstrLen( (uint16*)R4$1 );
					TMP$510$5 = vr$1677 + -1ll;
					goto label$1165;
					label$1168:;
					{
						if( (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R1$1 + (I$5 << (1ll & 63ll)))) goto label$1170;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1163;
						}
						label$1170:;
						label$1169:;
					}
					label$1166:;
					I$5 = I$5 + 1ll;
					label$1165:;
					if( I$5 <= TMP$510$5) goto label$1168;
					label$1167:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1164:;
			label$1163:;
		}
		label$1161:;
		label$1160:;
	}
	int64 vr$1689 = fb_WstrLen( (uint16*)R4$1 );
	int64 vr$1691 = fb_WstrLen( (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1689 == vr$1691) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r2))" );
	int32 vr$1696 = fb_WstrCompare( (uint16*)R4$1, (uint16*)R2$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1696 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r2)" );
	{
		int64 vr$1701 = fb_WstrLen( (uint16*)R4$1 );
		int64 vr$1703 = fb_WstrLen( (uint16*)R2$1 );
		if( vr$1701 != vr$1703) goto label$1172;
		{
			label$1173:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$516$5;
					int64 vr$1705 = fb_WstrLen( (uint16*)R4$1 );
					TMP$516$5 = vr$1705 + -1ll;
					goto label$1176;
					label$1179:;
					{
						if( (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R2$1 + (I$5 << (1ll & 63ll)))) goto label$1181;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1174;
						}
						label$1181:;
						label$1180:;
					}
					label$1177:;
					I$5 = I$5 + 1ll;
					label$1176:;
					if( I$5 <= TMP$516$5) goto label$1179;
					label$1178:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1175:;
			label$1174:;
		}
		label$1172:;
		label$1171:;
	}
	int64 vr$1717 = fb_WstrLen( (uint16*)R4$1 );
	int64 vr$1719 = fb_WstrLen( (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1717 == vr$1719) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r3))" );
	int32 vr$1724 = fb_WstrCompare( (uint16*)R4$1, (uint16*)R3$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1724 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r3)" );
	{
		int64 vr$1729 = fb_WstrLen( (uint16*)R4$1 );
		int64 vr$1731 = fb_WstrLen( (uint16*)R3$1 );
		if( vr$1729 != vr$1731) goto label$1183;
		{
			label$1184:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$522$5;
					int64 vr$1733 = fb_WstrLen( (uint16*)R4$1 );
					TMP$522$5 = vr$1733 + -1ll;
					goto label$1187;
					label$1190:;
					{
						if( (int64)*(uint16*)((uint8*)R4$1 + (I$5 << (1ll & 63ll))) == (int64)*(uint16*)((uint8*)R3$1 + (I$5 << (1ll & 63ll)))) goto label$1192;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1185;
						}
						label$1192:;
						label$1191:;
					}
					label$1188:;
					I$5 = I$5 + 1ll;
					label$1187:;
					if( I$5 <= TMP$522$5) goto label$1190;
					label$1189:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1186:;
			label$1185:;
		}
		label$1183:;
		label$1182:;
	}
	int64 vr$1745 = fb_WstrLen( (uint16*)R4$1 );
	int64 vr$1747 = fb_WstrLen( (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1745 == vr$1747) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r4))" );
	int32 vr$1752 = fb_WstrCompare( (uint16*)R4$1, (uint16*)R4$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1752 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r4)" );
	{
		int64 vr$1757 = fb_WstrLen( (uint16*)R4$1 );
		int64 vr$1759 = fb_WstrLen( (uint16*)R4$1 );
		if( vr$1757 != vr$1759) goto label$1194;
		{
			label$1195:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$528$5;
					int64 vr$1761 = fb_WstrLen( (uint16*)R4$1 );
					TMP$528$5 = vr$1761 + -1ll;
					goto label$1198;
					label$1201:;
					{
						goto label$1203;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1196;
						}
						label$1203:;
						label$1202:;
					}
					label$1199:;
					I$5 = I$5 + 1ll;
					label$1198:;
					if( I$5 <= TMP$528$5) goto label$1201;
					label$1200:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-wstring\x5Cstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_WSTRING_.STR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1197:;
			label$1196:;
		}
		label$1194:;
		label$1193:;
	}
	label$499:;
}

static void _ZN14UWSTRING_FIXEDaSERKS_( struct $14UWSTRING_FIXED* THIS$1, struct $14UWSTRING_FIXED* __FB_RHS__$1 )
{
	label$2:;
	__builtin_memcpy( (struct $19UWSTRING_FIXED_BASE*)THIS$1, (struct $19UWSTRING_FIXED_BASE*)__FB_RHS__$1, 512 );
	label$3:;
}

static void _ZN22UWSTRING_FIXED_MUTABLEaSERKS_( struct $22UWSTRING_FIXED_MUTABLE* THIS$1, struct $22UWSTRING_FIXED_MUTABLE* __FB_RHS__$1 )
{
	label$6:;
	__builtin_memcpy( (struct $19UWSTRING_FIXED_BASE*)THIS$1, (struct $19UWSTRING_FIXED_BASE*)__FB_RHS__$1, 512 );
	label$7:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_12NUMERIC_CTOREv( void )
{
	label$496:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.udt_wstring_.str_", (char*)"numeric", (tmp$5)&_ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_7NUMERICEv, (boolean)0ll );
	label$497:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_12DEFAULT_CTOREv( void )
{
	label$1204:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.udt_wstring_.str_", (char*)"default", (tmp$5)&_ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_7DEFAULTEv, (boolean)0ll );
	label$1205:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_WSTRING_4STR_13SUITE_CTOR122Ev( void )
{
	label$1206:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.udt_wstring_.str_", (tmp$4)0ull, (tmp$4)0ull );
	label$1207:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
