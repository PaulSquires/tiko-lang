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
FBSTRING* fb_WstrAssignToA_Init( void*, int64, uint16*, int64 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_WstrDelete( uint16* );
int32 fb_StrCompare( void*, int64, void*, int64 );
uint16* fb_IntToWstr( int32 );
uint16* fb_UIntToWstr( uint32 );
uint16* fb_LongintToWstr( int64 );
uint16* fb_ULongintToWstr( uint64 );
uint16* fb_FloatToWstr( float );
uint16* fb_DoubleToWstr( double );
uint16* fb_StrToWstr( char* );
int64 fb_StrLen( void*, int64 );
static void fb_ctor__wstr( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN19UZSTRING_FIXED_BASEC1Ev( struct $19UZSTRING_FIXED_BASE* );
void _ZN14UZSTRING_FIXEDC1EPKw( struct $14UZSTRING_FIXED*, uint16* );
char* _ZN14UZSTRING_FIXEDcvcEv( struct $14UZSTRING_FIXED* );
static void _ZN14UZSTRING_FIXEDaSERKS_( struct $14UZSTRING_FIXED*, struct $14UZSTRING_FIXED* );
static void _ZN22UZSTRING_FIXED_MUTABLEaSERKS_( struct $22UZSTRING_FIXED_MUTABLE*, struct $22UZSTRING_FIXED_MUTABLE* );
void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_7NUMERICEv( void );
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_12NUMERIC_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_13SUITE_CTOR122Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_7NUMERICEv( void )
{
	label$10:;
	{
		uint16* TMP$8$2;
		uint16* TMP$9$2;
		int8 T$2;
		T$2 = (int8)-128;
		char W$2[50];
		uint16* vr$1 = fb_IntToWstr( (int32)T$2 );
		TMP$8$2 = vr$1;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$8$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$8$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$4 = fb_IntToWstr( (int32)T$2 );
		TMP$9$2 = vr$4;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$9$2 );
		fb_WstrDelete( (uint16*)TMP$9$2 );
		char R$2[50];
		char* vr$7 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$7, 0ll, 0 );
		int64 vr$10 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$12 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$10 == vr$12) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$17 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$17 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$22 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$24 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$22 != vr$24) goto label$13;
			{
				label$14:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$25$6;
						int64 vr$26 = fb_StrLen( (void*)W$2, 50ll );
						TMP$25$6 = vr$26 + -1ll;
						goto label$17;
						label$20:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$22;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$15;
							}
							label$22:;
							label$21:;
						}
						label$18:;
						I$6 = I$6 + 1ll;
						label$17:;
						if( I$6 <= TMP$25$6) goto label$20;
						label$19:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 23, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$16:;
				label$15:;
			}
			label$13:;
			label$12:;
		}
	}
	{
		uint16* TMP$30$2;
		uint16* TMP$31$2;
		int8 T$2;
		T$2 = (int8)0;
		char W$2[50];
		uint16* vr$36 = fb_IntToWstr( (int32)T$2 );
		TMP$30$2 = vr$36;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$30$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$30$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$39 = fb_IntToWstr( (int32)T$2 );
		TMP$31$2 = vr$39;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$31$2 );
		fb_WstrDelete( (uint16*)TMP$31$2 );
		char R$2[50];
		char* vr$42 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$42, 0ll, 0 );
		int64 vr$45 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$47 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$45 == vr$47) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$52 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$52 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$57 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$59 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$57 != vr$59) goto label$24;
			{
				label$25:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$32$6;
						int64 vr$61 = fb_StrLen( (void*)W$2, 50ll );
						TMP$32$6 = vr$61 + -1ll;
						goto label$28;
						label$31:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$33;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$26;
							}
							label$33:;
							label$32:;
						}
						label$29:;
						I$6 = I$6 + 1ll;
						label$28:;
						if( I$6 <= TMP$32$6) goto label$31;
						label$30:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 24, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$27:;
				label$26:;
			}
			label$24:;
			label$23:;
		}
	}
	{
		uint16* TMP$33$2;
		uint16* TMP$34$2;
		int8 T$2;
		T$2 = (int8)127;
		char W$2[50];
		uint16* vr$71 = fb_IntToWstr( (int32)T$2 );
		TMP$33$2 = vr$71;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$33$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$33$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$74 = fb_IntToWstr( (int32)T$2 );
		TMP$34$2 = vr$74;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$34$2 );
		fb_WstrDelete( (uint16*)TMP$34$2 );
		char R$2[50];
		char* vr$77 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$77, 0ll, 0 );
		int64 vr$80 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$82 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$80 == vr$82) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$87 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$87 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$92 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$94 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$92 != vr$94) goto label$35;
			{
				label$36:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$35$6;
						int64 vr$96 = fb_StrLen( (void*)W$2, 50ll );
						TMP$35$6 = vr$96 + -1ll;
						goto label$39;
						label$42:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$44;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$37;
							}
							label$44:;
							label$43:;
						}
						label$40:;
						I$6 = I$6 + 1ll;
						label$39:;
						if( I$6 <= TMP$35$6) goto label$42;
						label$41:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 25, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$38:;
				label$37:;
			}
			label$35:;
			label$34:;
		}
	}
	{
		uint16* TMP$36$2;
		uint16* TMP$37$2;
		uint8 T$2;
		T$2 = (uint8)0u;
		char W$2[50];
		uint16* vr$106 = fb_UIntToWstr( (uint32)T$2 );
		TMP$36$2 = vr$106;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$36$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$36$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$109 = fb_UIntToWstr( (uint32)T$2 );
		TMP$37$2 = vr$109;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$37$2 );
		fb_WstrDelete( (uint16*)TMP$37$2 );
		char R$2[50];
		char* vr$112 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$112, 0ll, 0 );
		int64 vr$115 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$117 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$115 == vr$117) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$122 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$122 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$127 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$129 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$127 != vr$129) goto label$46;
			{
				label$47:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$38$6;
						int64 vr$131 = fb_StrLen( (void*)W$2, 50ll );
						TMP$38$6 = vr$131 + -1ll;
						goto label$50;
						label$53:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$55;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$48;
							}
							label$55:;
							label$54:;
						}
						label$51:;
						I$6 = I$6 + 1ll;
						label$50:;
						if( I$6 <= TMP$38$6) goto label$53;
						label$52:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 27, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$49:;
				label$48:;
			}
			label$46:;
			label$45:;
		}
	}
	{
		uint16* TMP$39$2;
		uint16* TMP$40$2;
		uint8 T$2;
		T$2 = (uint8)128u;
		char W$2[50];
		uint16* vr$141 = fb_UIntToWstr( (uint32)T$2 );
		TMP$39$2 = vr$141;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$39$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$39$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$144 = fb_UIntToWstr( (uint32)T$2 );
		TMP$40$2 = vr$144;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$40$2 );
		fb_WstrDelete( (uint16*)TMP$40$2 );
		char R$2[50];
		char* vr$147 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$147, 0ll, 0 );
		int64 vr$150 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$152 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$150 == vr$152) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$157 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$157 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$162 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$164 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$162 != vr$164) goto label$57;
			{
				label$58:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$41$6;
						int64 vr$166 = fb_StrLen( (void*)W$2, 50ll );
						TMP$41$6 = vr$166 + -1ll;
						goto label$61;
						label$64:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$66;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$59;
							}
							label$66:;
							label$65:;
						}
						label$62:;
						I$6 = I$6 + 1ll;
						label$61:;
						if( I$6 <= TMP$41$6) goto label$64;
						label$63:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 28, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$60:;
				label$59:;
			}
			label$57:;
			label$56:;
		}
	}
	{
		uint16* TMP$42$2;
		uint16* TMP$43$2;
		uint8 T$2;
		T$2 = (uint8)255u;
		char W$2[50];
		uint16* vr$176 = fb_UIntToWstr( (uint32)T$2 );
		TMP$42$2 = vr$176;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$42$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$42$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$179 = fb_UIntToWstr( (uint32)T$2 );
		TMP$43$2 = vr$179;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$43$2 );
		fb_WstrDelete( (uint16*)TMP$43$2 );
		char R$2[50];
		char* vr$182 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$182, 0ll, 0 );
		int64 vr$185 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$187 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$185 == vr$187) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$192 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$192 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$197 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$199 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$197 != vr$199) goto label$68;
			{
				label$69:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$44$6;
						int64 vr$201 = fb_StrLen( (void*)W$2, 50ll );
						TMP$44$6 = vr$201 + -1ll;
						goto label$72;
						label$75:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$77;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$70;
							}
							label$77:;
							label$76:;
						}
						label$73:;
						I$6 = I$6 + 1ll;
						label$72:;
						if( I$6 <= TMP$44$6) goto label$75;
						label$74:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 29, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$71:;
				label$70:;
			}
			label$68:;
			label$67:;
		}
	}
	{
		uint16* TMP$45$2;
		uint16* TMP$46$2;
		int16 T$2;
		T$2 = (int16)-32768;
		char W$2[50];
		uint16* vr$211 = fb_IntToWstr( (int32)T$2 );
		TMP$45$2 = vr$211;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$45$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$45$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$214 = fb_IntToWstr( (int32)T$2 );
		TMP$46$2 = vr$214;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$46$2 );
		fb_WstrDelete( (uint16*)TMP$46$2 );
		char R$2[50];
		char* vr$217 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$217, 0ll, 0 );
		int64 vr$220 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$222 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$220 == vr$222) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$227 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$227 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$232 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$234 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$232 != vr$234) goto label$79;
			{
				label$80:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$47$6;
						int64 vr$236 = fb_StrLen( (void*)W$2, 50ll );
						TMP$47$6 = vr$236 + -1ll;
						goto label$83;
						label$86:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$88;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$81;
							}
							label$88:;
							label$87:;
						}
						label$84:;
						I$6 = I$6 + 1ll;
						label$83:;
						if( I$6 <= TMP$47$6) goto label$86;
						label$85:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 31, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$82:;
				label$81:;
			}
			label$79:;
			label$78:;
		}
	}
	{
		uint16* TMP$48$2;
		uint16* TMP$49$2;
		int16 T$2;
		T$2 = (int16)0;
		char W$2[50];
		uint16* vr$246 = fb_IntToWstr( (int32)T$2 );
		TMP$48$2 = vr$246;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$48$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$48$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$249 = fb_IntToWstr( (int32)T$2 );
		TMP$49$2 = vr$249;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$49$2 );
		fb_WstrDelete( (uint16*)TMP$49$2 );
		char R$2[50];
		char* vr$252 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$252, 0ll, 0 );
		int64 vr$255 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$257 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$255 == vr$257) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$262 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$262 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$267 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$269 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$267 != vr$269) goto label$90;
			{
				label$91:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$50$6;
						int64 vr$271 = fb_StrLen( (void*)W$2, 50ll );
						TMP$50$6 = vr$271 + -1ll;
						goto label$94;
						label$97:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$99;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$92;
							}
							label$99:;
							label$98:;
						}
						label$95:;
						I$6 = I$6 + 1ll;
						label$94:;
						if( I$6 <= TMP$50$6) goto label$97;
						label$96:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 32, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$93:;
				label$92:;
			}
			label$90:;
			label$89:;
		}
	}
	{
		uint16* TMP$51$2;
		uint16* TMP$52$2;
		int16 T$2;
		T$2 = (int16)32767;
		char W$2[50];
		uint16* vr$281 = fb_IntToWstr( (int32)T$2 );
		TMP$51$2 = vr$281;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$51$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$51$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$284 = fb_IntToWstr( (int32)T$2 );
		TMP$52$2 = vr$284;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$52$2 );
		fb_WstrDelete( (uint16*)TMP$52$2 );
		char R$2[50];
		char* vr$287 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$287, 0ll, 0 );
		int64 vr$290 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$292 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$290 == vr$292) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$297 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$297 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$302 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$304 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$302 != vr$304) goto label$101;
			{
				label$102:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$53$6;
						int64 vr$306 = fb_StrLen( (void*)W$2, 50ll );
						TMP$53$6 = vr$306 + -1ll;
						goto label$105;
						label$108:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$110;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$103;
							}
							label$110:;
							label$109:;
						}
						label$106:;
						I$6 = I$6 + 1ll;
						label$105:;
						if( I$6 <= TMP$53$6) goto label$108;
						label$107:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 33, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$104:;
				label$103:;
			}
			label$101:;
			label$100:;
		}
	}
	{
		uint16* TMP$54$2;
		uint16* TMP$55$2;
		uint16 T$2;
		T$2 = (uint16)0u;
		char W$2[50];
		uint16* vr$316 = fb_UIntToWstr( (uint32)T$2 );
		TMP$54$2 = vr$316;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$54$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$54$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$319 = fb_UIntToWstr( (uint32)T$2 );
		TMP$55$2 = vr$319;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$55$2 );
		fb_WstrDelete( (uint16*)TMP$55$2 );
		char R$2[50];
		char* vr$322 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$322, 0ll, 0 );
		int64 vr$325 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$327 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$325 == vr$327) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$332 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$332 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$337 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$339 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$337 != vr$339) goto label$112;
			{
				label$113:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$56$6;
						int64 vr$341 = fb_StrLen( (void*)W$2, 50ll );
						TMP$56$6 = vr$341 + -1ll;
						goto label$116;
						label$119:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$121;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$114;
							}
							label$121:;
							label$120:;
						}
						label$117:;
						I$6 = I$6 + 1ll;
						label$116:;
						if( I$6 <= TMP$56$6) goto label$119;
						label$118:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 35, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$115:;
				label$114:;
			}
			label$112:;
			label$111:;
		}
	}
	{
		uint16* TMP$57$2;
		uint16* TMP$58$2;
		uint16 T$2;
		T$2 = (uint16)32768u;
		char W$2[50];
		uint16* vr$351 = fb_UIntToWstr( (uint32)T$2 );
		TMP$57$2 = vr$351;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$57$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$57$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$354 = fb_UIntToWstr( (uint32)T$2 );
		TMP$58$2 = vr$354;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$58$2 );
		fb_WstrDelete( (uint16*)TMP$58$2 );
		char R$2[50];
		char* vr$357 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$357, 0ll, 0 );
		int64 vr$360 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$362 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$360 == vr$362) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$367 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$367 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$372 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$374 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$372 != vr$374) goto label$123;
			{
				label$124:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$59$6;
						int64 vr$376 = fb_StrLen( (void*)W$2, 50ll );
						TMP$59$6 = vr$376 + -1ll;
						goto label$127;
						label$130:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$132;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$125;
							}
							label$132:;
							label$131:;
						}
						label$128:;
						I$6 = I$6 + 1ll;
						label$127:;
						if( I$6 <= TMP$59$6) goto label$130;
						label$129:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 36, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$126:;
				label$125:;
			}
			label$123:;
			label$122:;
		}
	}
	{
		uint16* TMP$60$2;
		uint16* TMP$61$2;
		uint16 T$2;
		T$2 = (uint16)65535u;
		char W$2[50];
		uint16* vr$386 = fb_UIntToWstr( (uint32)T$2 );
		TMP$60$2 = vr$386;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$60$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$60$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$389 = fb_UIntToWstr( (uint32)T$2 );
		TMP$61$2 = vr$389;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$61$2 );
		fb_WstrDelete( (uint16*)TMP$61$2 );
		char R$2[50];
		char* vr$392 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$392, 0ll, 0 );
		int64 vr$395 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$397 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$395 == vr$397) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$402 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$402 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$407 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$409 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$407 != vr$409) goto label$134;
			{
				label$135:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$62$6;
						int64 vr$411 = fb_StrLen( (void*)W$2, 50ll );
						TMP$62$6 = vr$411 + -1ll;
						goto label$138;
						label$141:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$143;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$136;
							}
							label$143:;
							label$142:;
						}
						label$139:;
						I$6 = I$6 + 1ll;
						label$138:;
						if( I$6 <= TMP$62$6) goto label$141;
						label$140:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 37, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$137:;
				label$136:;
			}
			label$134:;
			label$133:;
		}
	}
	{
		uint16* TMP$63$2;
		uint16* TMP$64$2;
		int32 T$2;
		T$2 = (int32)-2147483648u;
		char W$2[50];
		uint16* vr$420 = fb_IntToWstr( T$2 );
		TMP$63$2 = vr$420;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$63$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$63$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$422 = fb_IntToWstr( T$2 );
		TMP$64$2 = vr$422;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$64$2 );
		fb_WstrDelete( (uint16*)TMP$64$2 );
		char R$2[50];
		char* vr$425 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$425, 0ll, 0 );
		int64 vr$428 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$430 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$428 == vr$430) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$435 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$435 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$440 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$442 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$440 != vr$442) goto label$145;
			{
				label$146:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$65$6;
						int64 vr$444 = fb_StrLen( (void*)W$2, 50ll );
						TMP$65$6 = vr$444 + -1ll;
						goto label$149;
						label$152:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$154;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$147;
							}
							label$154:;
							label$153:;
						}
						label$150:;
						I$6 = I$6 + 1ll;
						label$149:;
						if( I$6 <= TMP$65$6) goto label$152;
						label$151:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 39, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$148:;
				label$147:;
			}
			label$145:;
			label$144:;
		}
	}
	{
		uint16* TMP$66$2;
		uint16* TMP$67$2;
		int32 T$2;
		T$2 = 0;
		char W$2[50];
		uint16* vr$453 = fb_IntToWstr( T$2 );
		TMP$66$2 = vr$453;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$66$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$66$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$455 = fb_IntToWstr( T$2 );
		TMP$67$2 = vr$455;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$67$2 );
		fb_WstrDelete( (uint16*)TMP$67$2 );
		char R$2[50];
		char* vr$458 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$458, 0ll, 0 );
		int64 vr$461 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$463 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$461 == vr$463) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$468 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$468 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$473 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$475 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$473 != vr$475) goto label$156;
			{
				label$157:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$68$6;
						int64 vr$477 = fb_StrLen( (void*)W$2, 50ll );
						TMP$68$6 = vr$477 + -1ll;
						goto label$160;
						label$163:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$165;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$158;
							}
							label$165:;
							label$164:;
						}
						label$161:;
						I$6 = I$6 + 1ll;
						label$160:;
						if( I$6 <= TMP$68$6) goto label$163;
						label$162:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 40, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$159:;
				label$158:;
			}
			label$156:;
			label$155:;
		}
	}
	{
		uint16* TMP$69$2;
		uint16* TMP$70$2;
		int32 T$2;
		T$2 = 2147483647;
		char W$2[50];
		uint16* vr$486 = fb_IntToWstr( T$2 );
		TMP$69$2 = vr$486;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$69$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$69$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$488 = fb_IntToWstr( T$2 );
		TMP$70$2 = vr$488;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$70$2 );
		fb_WstrDelete( (uint16*)TMP$70$2 );
		char R$2[50];
		char* vr$491 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$491, 0ll, 0 );
		int64 vr$494 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$496 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$494 == vr$496) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$501 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$501 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$506 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$508 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$506 != vr$508) goto label$167;
			{
				label$168:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$71$6;
						int64 vr$510 = fb_StrLen( (void*)W$2, 50ll );
						TMP$71$6 = vr$510 + -1ll;
						goto label$171;
						label$174:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$176;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$169;
							}
							label$176:;
							label$175:;
						}
						label$172:;
						I$6 = I$6 + 1ll;
						label$171:;
						if( I$6 <= TMP$71$6) goto label$174;
						label$173:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 41, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$170:;
				label$169:;
			}
			label$167:;
			label$166:;
		}
	}
	{
		uint16* TMP$72$2;
		uint16* TMP$73$2;
		uint32 T$2;
		T$2 = 0u;
		char W$2[50];
		uint16* vr$519 = fb_UIntToWstr( T$2 );
		TMP$72$2 = vr$519;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$72$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$72$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$521 = fb_UIntToWstr( T$2 );
		TMP$73$2 = vr$521;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$73$2 );
		fb_WstrDelete( (uint16*)TMP$73$2 );
		char R$2[50];
		char* vr$524 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$524, 0ll, 0 );
		int64 vr$527 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$529 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$527 == vr$529) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$534 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$534 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$539 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$541 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$539 != vr$541) goto label$178;
			{
				label$179:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$74$6;
						int64 vr$543 = fb_StrLen( (void*)W$2, 50ll );
						TMP$74$6 = vr$543 + -1ll;
						goto label$182;
						label$185:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$187;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$180;
							}
							label$187:;
							label$186:;
						}
						label$183:;
						I$6 = I$6 + 1ll;
						label$182:;
						if( I$6 <= TMP$74$6) goto label$185;
						label$184:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 43, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$181:;
				label$180:;
			}
			label$178:;
			label$177:;
		}
	}
	{
		uint16* TMP$75$2;
		uint16* TMP$76$2;
		uint32 T$2;
		T$2 = 2147483648u;
		char W$2[50];
		uint16* vr$552 = fb_UIntToWstr( T$2 );
		TMP$75$2 = vr$552;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$75$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$75$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$554 = fb_UIntToWstr( T$2 );
		TMP$76$2 = vr$554;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$76$2 );
		fb_WstrDelete( (uint16*)TMP$76$2 );
		char R$2[50];
		char* vr$557 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$557, 0ll, 0 );
		int64 vr$560 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$562 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$560 == vr$562) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$567 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$567 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$572 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$574 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$572 != vr$574) goto label$189;
			{
				label$190:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$77$6;
						int64 vr$576 = fb_StrLen( (void*)W$2, 50ll );
						TMP$77$6 = vr$576 + -1ll;
						goto label$193;
						label$196:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$198;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$191;
							}
							label$198:;
							label$197:;
						}
						label$194:;
						I$6 = I$6 + 1ll;
						label$193:;
						if( I$6 <= TMP$77$6) goto label$196;
						label$195:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 44, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$192:;
				label$191:;
			}
			label$189:;
			label$188:;
		}
	}
	{
		uint16* TMP$78$2;
		uint16* TMP$79$2;
		uint32 T$2;
		T$2 = 4294967295u;
		char W$2[50];
		uint16* vr$585 = fb_UIntToWstr( T$2 );
		TMP$78$2 = vr$585;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$78$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$78$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$587 = fb_UIntToWstr( T$2 );
		TMP$79$2 = vr$587;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$79$2 );
		fb_WstrDelete( (uint16*)TMP$79$2 );
		char R$2[50];
		char* vr$590 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$590, 0ll, 0 );
		int64 vr$593 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$595 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$593 == vr$595) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$600 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$600 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$605 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$607 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$605 != vr$607) goto label$200;
			{
				label$201:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$80$6;
						int64 vr$609 = fb_StrLen( (void*)W$2, 50ll );
						TMP$80$6 = vr$609 + -1ll;
						goto label$204;
						label$207:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$209;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$202;
							}
							label$209:;
							label$208:;
						}
						label$205:;
						I$6 = I$6 + 1ll;
						label$204:;
						if( I$6 <= TMP$80$6) goto label$207;
						label$206:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 45, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$203:;
				label$202:;
			}
			label$200:;
			label$199:;
		}
	}
	{
		uint16* TMP$81$2;
		uint16* TMP$82$2;
		int64 T$2;
		T$2 = (int64)-9223372036854775808ull;
		char W$2[50];
		uint16* vr$618 = fb_LongintToWstr( T$2 );
		TMP$81$2 = vr$618;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$81$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$81$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$620 = fb_LongintToWstr( T$2 );
		TMP$82$2 = vr$620;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$82$2 );
		fb_WstrDelete( (uint16*)TMP$82$2 );
		char R$2[50];
		char* vr$623 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$623, 0ll, 0 );
		int64 vr$626 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$628 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$626 == vr$628) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$633 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$633 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$638 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$640 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$638 != vr$640) goto label$211;
			{
				label$212:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$83$6;
						int64 vr$642 = fb_StrLen( (void*)W$2, 50ll );
						TMP$83$6 = vr$642 + -1ll;
						goto label$215;
						label$218:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$220;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$213;
							}
							label$220:;
							label$219:;
						}
						label$216:;
						I$6 = I$6 + 1ll;
						label$215:;
						if( I$6 <= TMP$83$6) goto label$218;
						label$217:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 47, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$214:;
				label$213:;
			}
			label$211:;
			label$210:;
		}
	}
	{
		uint16* TMP$84$2;
		uint16* TMP$85$2;
		int64 T$2;
		T$2 = 0ll;
		char W$2[50];
		uint16* vr$651 = fb_LongintToWstr( T$2 );
		TMP$84$2 = vr$651;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$84$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$84$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$653 = fb_LongintToWstr( T$2 );
		TMP$85$2 = vr$653;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$85$2 );
		fb_WstrDelete( (uint16*)TMP$85$2 );
		char R$2[50];
		char* vr$656 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$656, 0ll, 0 );
		int64 vr$659 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$661 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$659 == vr$661) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$666 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$666 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$671 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$673 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$671 != vr$673) goto label$222;
			{
				label$223:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$86$6;
						int64 vr$675 = fb_StrLen( (void*)W$2, 50ll );
						TMP$86$6 = vr$675 + -1ll;
						goto label$226;
						label$229:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$231;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$224;
							}
							label$231:;
							label$230:;
						}
						label$227:;
						I$6 = I$6 + 1ll;
						label$226:;
						if( I$6 <= TMP$86$6) goto label$229;
						label$228:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 48, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$225:;
				label$224:;
			}
			label$222:;
			label$221:;
		}
	}
	{
		uint16* TMP$87$2;
		uint16* TMP$88$2;
		int64 T$2;
		T$2 = 9223372036854775807ll;
		char W$2[50];
		uint16* vr$684 = fb_LongintToWstr( T$2 );
		TMP$87$2 = vr$684;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$87$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$87$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$686 = fb_LongintToWstr( T$2 );
		TMP$88$2 = vr$686;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$88$2 );
		fb_WstrDelete( (uint16*)TMP$88$2 );
		char R$2[50];
		char* vr$689 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$689, 0ll, 0 );
		int64 vr$692 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$694 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$692 == vr$694) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$699 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$699 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$704 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$706 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$704 != vr$706) goto label$233;
			{
				label$234:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$89$6;
						int64 vr$708 = fb_StrLen( (void*)W$2, 50ll );
						TMP$89$6 = vr$708 + -1ll;
						goto label$237;
						label$240:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$242;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$235;
							}
							label$242:;
							label$241:;
						}
						label$238:;
						I$6 = I$6 + 1ll;
						label$237:;
						if( I$6 <= TMP$89$6) goto label$240;
						label$239:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 49, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$236:;
				label$235:;
			}
			label$233:;
			label$232:;
		}
	}
	{
		uint16* TMP$90$2;
		uint16* TMP$91$2;
		uint64 T$2;
		T$2 = 0ull;
		char W$2[50];
		uint16* vr$717 = fb_ULongintToWstr( T$2 );
		TMP$90$2 = vr$717;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$90$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$90$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$719 = fb_ULongintToWstr( T$2 );
		TMP$91$2 = vr$719;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$91$2 );
		fb_WstrDelete( (uint16*)TMP$91$2 );
		char R$2[50];
		char* vr$722 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$722, 0ll, 0 );
		int64 vr$725 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$727 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$725 == vr$727) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$732 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$732 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$737 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$739 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$737 != vr$739) goto label$244;
			{
				label$245:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$92$6;
						int64 vr$741 = fb_StrLen( (void*)W$2, 50ll );
						TMP$92$6 = vr$741 + -1ll;
						goto label$248;
						label$251:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$253;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$246;
							}
							label$253:;
							label$252:;
						}
						label$249:;
						I$6 = I$6 + 1ll;
						label$248:;
						if( I$6 <= TMP$92$6) goto label$251;
						label$250:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 51, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$247:;
				label$246:;
			}
			label$244:;
			label$243:;
		}
	}
	{
		uint16* TMP$93$2;
		uint16* TMP$94$2;
		uint64 T$2;
		T$2 = 9223372036854775808ull;
		char W$2[50];
		uint16* vr$750 = fb_ULongintToWstr( T$2 );
		TMP$93$2 = vr$750;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$93$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$93$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$752 = fb_ULongintToWstr( T$2 );
		TMP$94$2 = vr$752;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$94$2 );
		fb_WstrDelete( (uint16*)TMP$94$2 );
		char R$2[50];
		char* vr$755 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$755, 0ll, 0 );
		int64 vr$758 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$760 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$758 == vr$760) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$765 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$765 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$770 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$772 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$770 != vr$772) goto label$255;
			{
				label$256:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$95$6;
						int64 vr$774 = fb_StrLen( (void*)W$2, 50ll );
						TMP$95$6 = vr$774 + -1ll;
						goto label$259;
						label$262:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$264;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$257;
							}
							label$264:;
							label$263:;
						}
						label$260:;
						I$6 = I$6 + 1ll;
						label$259:;
						if( I$6 <= TMP$95$6) goto label$262;
						label$261:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 52, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$258:;
				label$257:;
			}
			label$255:;
			label$254:;
		}
	}
	{
		uint16* TMP$96$2;
		uint16* TMP$97$2;
		uint64 T$2;
		T$2 = 18446744073709551615ull;
		char W$2[50];
		uint16* vr$783 = fb_ULongintToWstr( T$2 );
		TMP$96$2 = vr$783;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$96$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$96$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$785 = fb_ULongintToWstr( T$2 );
		TMP$97$2 = vr$785;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$97$2 );
		fb_WstrDelete( (uint16*)TMP$97$2 );
		char R$2[50];
		char* vr$788 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$788, 0ll, 0 );
		int64 vr$791 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$793 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$791 == vr$793) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$798 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$798 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$803 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$805 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$803 != vr$805) goto label$266;
			{
				label$267:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$98$6;
						int64 vr$807 = fb_StrLen( (void*)W$2, 50ll );
						TMP$98$6 = vr$807 + -1ll;
						goto label$270;
						label$273:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$275;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$268;
							}
							label$275:;
							label$274:;
						}
						label$271:;
						I$6 = I$6 + 1ll;
						label$270:;
						if( I$6 <= TMP$98$6) goto label$273;
						label$272:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 53, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$269:;
				label$268:;
			}
			label$266:;
			label$265:;
		}
	}
	{
		uint16* TMP$99$2;
		uint16* TMP$100$2;
		float T$2;
		T$2 = -0x1.8p+0f;
		char W$2[50];
		uint16* vr$816 = fb_FloatToWstr( T$2 );
		TMP$99$2 = vr$816;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$99$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$99$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$818 = fb_FloatToWstr( T$2 );
		TMP$100$2 = vr$818;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$100$2 );
		fb_WstrDelete( (uint16*)TMP$100$2 );
		char R$2[50];
		char* vr$821 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$821, 0ll, 0 );
		int64 vr$824 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$826 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$824 == vr$826) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$831 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$831 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$836 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$838 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$836 != vr$838) goto label$277;
			{
				label$278:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$101$6;
						int64 vr$840 = fb_StrLen( (void*)W$2, 50ll );
						TMP$101$6 = vr$840 + -1ll;
						goto label$281;
						label$284:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$286;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$279;
							}
							label$286:;
							label$285:;
						}
						label$282:;
						I$6 = I$6 + 1ll;
						label$281:;
						if( I$6 <= TMP$101$6) goto label$284;
						label$283:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 55, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$280:;
				label$279:;
			}
			label$277:;
			label$276:;
		}
	}
	{
		uint16* TMP$102$2;
		uint16* TMP$103$2;
		float T$2;
		T$2 = -0x1.p+0f;
		char W$2[50];
		uint16* vr$849 = fb_FloatToWstr( T$2 );
		TMP$102$2 = vr$849;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$102$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$102$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$851 = fb_FloatToWstr( T$2 );
		TMP$103$2 = vr$851;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$103$2 );
		fb_WstrDelete( (uint16*)TMP$103$2 );
		char R$2[50];
		char* vr$854 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$854, 0ll, 0 );
		int64 vr$857 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$859 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$857 == vr$859) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$864 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$864 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$869 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$871 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$869 != vr$871) goto label$288;
			{
				label$289:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$104$6;
						int64 vr$873 = fb_StrLen( (void*)W$2, 50ll );
						TMP$104$6 = vr$873 + -1ll;
						goto label$292;
						label$295:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$297;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$290;
							}
							label$297:;
							label$296:;
						}
						label$293:;
						I$6 = I$6 + 1ll;
						label$292:;
						if( I$6 <= TMP$104$6) goto label$295;
						label$294:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 56, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$291:;
				label$290:;
			}
			label$288:;
			label$287:;
		}
	}
	{
		uint16* TMP$105$2;
		uint16* TMP$106$2;
		float T$2;
		T$2 = -0x1.p+0f;
		char W$2[50];
		uint16* vr$882 = fb_FloatToWstr( T$2 );
		TMP$105$2 = vr$882;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$105$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$105$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$884 = fb_FloatToWstr( T$2 );
		TMP$106$2 = vr$884;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$106$2 );
		fb_WstrDelete( (uint16*)TMP$106$2 );
		char R$2[50];
		char* vr$887 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$887, 0ll, 0 );
		int64 vr$890 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$892 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$890 == vr$892) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$897 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$897 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$902 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$904 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$902 != vr$904) goto label$299;
			{
				label$300:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$107$6;
						int64 vr$906 = fb_StrLen( (void*)W$2, 50ll );
						TMP$107$6 = vr$906 + -1ll;
						goto label$303;
						label$306:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$308;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$301;
							}
							label$308:;
							label$307:;
						}
						label$304:;
						I$6 = I$6 + 1ll;
						label$303:;
						if( I$6 <= TMP$107$6) goto label$306;
						label$305:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 57, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$302:;
				label$301:;
			}
			label$299:;
			label$298:;
		}
	}
	{
		uint16* TMP$108$2;
		uint16* TMP$109$2;
		float T$2;
		T$2 = -0x1.p-1f;
		char W$2[50];
		uint16* vr$915 = fb_FloatToWstr( T$2 );
		TMP$108$2 = vr$915;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$108$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$108$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$917 = fb_FloatToWstr( T$2 );
		TMP$109$2 = vr$917;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$109$2 );
		fb_WstrDelete( (uint16*)TMP$109$2 );
		char R$2[50];
		char* vr$920 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$920, 0ll, 0 );
		int64 vr$923 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$925 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$923 == vr$925) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$930 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$930 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$935 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$937 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$935 != vr$937) goto label$310;
			{
				label$311:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$110$6;
						int64 vr$939 = fb_StrLen( (void*)W$2, 50ll );
						TMP$110$6 = vr$939 + -1ll;
						goto label$314;
						label$317:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$319;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$312;
							}
							label$319:;
							label$318:;
						}
						label$315:;
						I$6 = I$6 + 1ll;
						label$314:;
						if( I$6 <= TMP$110$6) goto label$317;
						label$316:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 58, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$313:;
				label$312:;
			}
			label$310:;
			label$309:;
		}
	}
	{
		uint16* TMP$111$2;
		uint16* TMP$112$2;
		float T$2;
		T$2 = 0x0p+0f;
		char W$2[50];
		uint16* vr$948 = fb_FloatToWstr( T$2 );
		TMP$111$2 = vr$948;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$111$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$111$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$950 = fb_FloatToWstr( T$2 );
		TMP$112$2 = vr$950;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$112$2 );
		fb_WstrDelete( (uint16*)TMP$112$2 );
		char R$2[50];
		char* vr$953 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$953, 0ll, 0 );
		int64 vr$956 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$958 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$956 == vr$958) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$963 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$963 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$968 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$970 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$968 != vr$970) goto label$321;
			{
				label$322:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$113$6;
						int64 vr$972 = fb_StrLen( (void*)W$2, 50ll );
						TMP$113$6 = vr$972 + -1ll;
						goto label$325;
						label$328:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$330;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$323;
							}
							label$330:;
							label$329:;
						}
						label$326:;
						I$6 = I$6 + 1ll;
						label$325:;
						if( I$6 <= TMP$113$6) goto label$328;
						label$327:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 59, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$324:;
				label$323:;
			}
			label$321:;
			label$320:;
		}
	}
	{
		uint16* TMP$114$2;
		uint16* TMP$115$2;
		float T$2;
		T$2 = 0x1.p-1f;
		char W$2[50];
		uint16* vr$981 = fb_FloatToWstr( T$2 );
		TMP$114$2 = vr$981;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$114$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$114$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$983 = fb_FloatToWstr( T$2 );
		TMP$115$2 = vr$983;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$115$2 );
		fb_WstrDelete( (uint16*)TMP$115$2 );
		char R$2[50];
		char* vr$986 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$986, 0ll, 0 );
		int64 vr$989 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$991 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$989 == vr$991) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$996 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$996 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1001 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1003 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1001 != vr$1003) goto label$332;
			{
				label$333:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$116$6;
						int64 vr$1005 = fb_StrLen( (void*)W$2, 50ll );
						TMP$116$6 = vr$1005 + -1ll;
						goto label$336;
						label$339:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$341;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$334;
							}
							label$341:;
							label$340:;
						}
						label$337:;
						I$6 = I$6 + 1ll;
						label$336:;
						if( I$6 <= TMP$116$6) goto label$339;
						label$338:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 60, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$335:;
				label$334:;
			}
			label$332:;
			label$331:;
		}
	}
	{
		uint16* TMP$117$2;
		uint16* TMP$118$2;
		float T$2;
		T$2 = 0x1.p+0f;
		char W$2[50];
		uint16* vr$1014 = fb_FloatToWstr( T$2 );
		TMP$117$2 = vr$1014;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$117$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$117$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1016 = fb_FloatToWstr( T$2 );
		TMP$118$2 = vr$1016;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$118$2 );
		fb_WstrDelete( (uint16*)TMP$118$2 );
		char R$2[50];
		char* vr$1019 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1019, 0ll, 0 );
		int64 vr$1022 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1024 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1022 == vr$1024) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1029 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1029 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1034 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1036 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1034 != vr$1036) goto label$343;
			{
				label$344:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$119$6;
						int64 vr$1038 = fb_StrLen( (void*)W$2, 50ll );
						TMP$119$6 = vr$1038 + -1ll;
						goto label$347;
						label$350:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$352;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$345;
							}
							label$352:;
							label$351:;
						}
						label$348:;
						I$6 = I$6 + 1ll;
						label$347:;
						if( I$6 <= TMP$119$6) goto label$350;
						label$349:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 61, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$346:;
				label$345:;
			}
			label$343:;
			label$342:;
		}
	}
	{
		uint16* TMP$120$2;
		uint16* TMP$121$2;
		float T$2;
		T$2 = 0x1.8p+0f;
		char W$2[50];
		uint16* vr$1047 = fb_FloatToWstr( T$2 );
		TMP$120$2 = vr$1047;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$120$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$120$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1049 = fb_FloatToWstr( T$2 );
		TMP$121$2 = vr$1049;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$121$2 );
		fb_WstrDelete( (uint16*)TMP$121$2 );
		char R$2[50];
		char* vr$1052 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1052, 0ll, 0 );
		int64 vr$1055 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1057 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1055 == vr$1057) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1062 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1062 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1067 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1069 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1067 != vr$1069) goto label$354;
			{
				label$355:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$122$6;
						int64 vr$1071 = fb_StrLen( (void*)W$2, 50ll );
						TMP$122$6 = vr$1071 + -1ll;
						goto label$358;
						label$361:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$363;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$356;
							}
							label$363:;
							label$362:;
						}
						label$359:;
						I$6 = I$6 + 1ll;
						label$358:;
						if( I$6 <= TMP$122$6) goto label$361;
						label$360:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 62, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$357:;
				label$356:;
			}
			label$354:;
			label$353:;
		}
	}
	{
		uint16* TMP$123$2;
		uint16* TMP$124$2;
		float T$2;
		T$2 = 0x1.p+1f;
		char W$2[50];
		uint16* vr$1080 = fb_FloatToWstr( T$2 );
		TMP$123$2 = vr$1080;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$123$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$123$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1082 = fb_FloatToWstr( T$2 );
		TMP$124$2 = vr$1082;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$124$2 );
		fb_WstrDelete( (uint16*)TMP$124$2 );
		char R$2[50];
		char* vr$1085 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1085, 0ll, 0 );
		int64 vr$1088 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1090 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1088 == vr$1090) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1095 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1095 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1100 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1102 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1100 != vr$1102) goto label$365;
			{
				label$366:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$125$6;
						int64 vr$1104 = fb_StrLen( (void*)W$2, 50ll );
						TMP$125$6 = vr$1104 + -1ll;
						goto label$369;
						label$372:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$374;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$367;
							}
							label$374:;
							label$373:;
						}
						label$370:;
						I$6 = I$6 + 1ll;
						label$369:;
						if( I$6 <= TMP$125$6) goto label$372;
						label$371:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 63, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$368:;
				label$367:;
			}
			label$365:;
			label$364:;
		}
	}
	{
		uint16* TMP$126$2;
		uint16* TMP$127$2;
		float T$2;
		T$2 = 0x1.4p+1f;
		char W$2[50];
		uint16* vr$1113 = fb_FloatToWstr( T$2 );
		TMP$126$2 = vr$1113;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$126$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$126$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1115 = fb_FloatToWstr( T$2 );
		TMP$127$2 = vr$1115;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$127$2 );
		fb_WstrDelete( (uint16*)TMP$127$2 );
		char R$2[50];
		char* vr$1118 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1118, 0ll, 0 );
		int64 vr$1121 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1123 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1121 == vr$1123) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1128 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1128 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1133 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1135 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1133 != vr$1135) goto label$376;
			{
				label$377:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$128$6;
						int64 vr$1137 = fb_StrLen( (void*)W$2, 50ll );
						TMP$128$6 = vr$1137 + -1ll;
						goto label$380;
						label$383:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$385;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$378;
							}
							label$385:;
							label$384:;
						}
						label$381:;
						I$6 = I$6 + 1ll;
						label$380:;
						if( I$6 <= TMP$128$6) goto label$383;
						label$382:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 64, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$379:;
				label$378:;
			}
			label$376:;
			label$375:;
		}
	}
	{
		uint16* TMP$129$2;
		uint16* TMP$130$2;
		double T$2;
		T$2 = -0x1.8p+0;
		char W$2[50];
		uint16* vr$1146 = fb_DoubleToWstr( T$2 );
		TMP$129$2 = vr$1146;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$129$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$129$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1148 = fb_DoubleToWstr( T$2 );
		TMP$130$2 = vr$1148;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$130$2 );
		fb_WstrDelete( (uint16*)TMP$130$2 );
		char R$2[50];
		char* vr$1151 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1151, 0ll, 0 );
		int64 vr$1154 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1156 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1154 == vr$1156) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1161 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1161 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1166 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1168 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1166 != vr$1168) goto label$387;
			{
				label$388:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$131$6;
						int64 vr$1170 = fb_StrLen( (void*)W$2, 50ll );
						TMP$131$6 = vr$1170 + -1ll;
						goto label$391;
						label$394:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$396;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$389;
							}
							label$396:;
							label$395:;
						}
						label$392:;
						I$6 = I$6 + 1ll;
						label$391:;
						if( I$6 <= TMP$131$6) goto label$394;
						label$393:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 66, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$390:;
				label$389:;
			}
			label$387:;
			label$386:;
		}
	}
	{
		uint16* TMP$132$2;
		uint16* TMP$133$2;
		double T$2;
		T$2 = -0x1.p+0;
		char W$2[50];
		uint16* vr$1179 = fb_DoubleToWstr( T$2 );
		TMP$132$2 = vr$1179;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$132$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$132$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1181 = fb_DoubleToWstr( T$2 );
		TMP$133$2 = vr$1181;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$133$2 );
		fb_WstrDelete( (uint16*)TMP$133$2 );
		char R$2[50];
		char* vr$1184 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1184, 0ll, 0 );
		int64 vr$1187 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1189 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1187 == vr$1189) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1194 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1194 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1199 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1201 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1199 != vr$1201) goto label$398;
			{
				label$399:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$134$6;
						int64 vr$1203 = fb_StrLen( (void*)W$2, 50ll );
						TMP$134$6 = vr$1203 + -1ll;
						goto label$402;
						label$405:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$407;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$400;
							}
							label$407:;
							label$406:;
						}
						label$403:;
						I$6 = I$6 + 1ll;
						label$402:;
						if( I$6 <= TMP$134$6) goto label$405;
						label$404:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 67, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$401:;
				label$400:;
			}
			label$398:;
			label$397:;
		}
	}
	{
		uint16* TMP$135$2;
		uint16* TMP$136$2;
		double T$2;
		T$2 = -0x1.p+0;
		char W$2[50];
		uint16* vr$1212 = fb_DoubleToWstr( T$2 );
		TMP$135$2 = vr$1212;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$135$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$135$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1214 = fb_DoubleToWstr( T$2 );
		TMP$136$2 = vr$1214;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$136$2 );
		fb_WstrDelete( (uint16*)TMP$136$2 );
		char R$2[50];
		char* vr$1217 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1217, 0ll, 0 );
		int64 vr$1220 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1222 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1220 == vr$1222) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1227 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1227 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1232 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1234 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1232 != vr$1234) goto label$409;
			{
				label$410:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$137$6;
						int64 vr$1236 = fb_StrLen( (void*)W$2, 50ll );
						TMP$137$6 = vr$1236 + -1ll;
						goto label$413;
						label$416:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$418;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$411;
							}
							label$418:;
							label$417:;
						}
						label$414:;
						I$6 = I$6 + 1ll;
						label$413:;
						if( I$6 <= TMP$137$6) goto label$416;
						label$415:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 68, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$412:;
				label$411:;
			}
			label$409:;
			label$408:;
		}
	}
	{
		uint16* TMP$138$2;
		uint16* TMP$139$2;
		double T$2;
		T$2 = -0x1.p-1;
		char W$2[50];
		uint16* vr$1245 = fb_DoubleToWstr( T$2 );
		TMP$138$2 = vr$1245;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$138$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$138$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1247 = fb_DoubleToWstr( T$2 );
		TMP$139$2 = vr$1247;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$139$2 );
		fb_WstrDelete( (uint16*)TMP$139$2 );
		char R$2[50];
		char* vr$1250 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1250, 0ll, 0 );
		int64 vr$1253 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1255 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1253 == vr$1255) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1260 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1260 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1265 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1267 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1265 != vr$1267) goto label$420;
			{
				label$421:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$140$6;
						int64 vr$1269 = fb_StrLen( (void*)W$2, 50ll );
						TMP$140$6 = vr$1269 + -1ll;
						goto label$424;
						label$427:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$429;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$422;
							}
							label$429:;
							label$428:;
						}
						label$425:;
						I$6 = I$6 + 1ll;
						label$424:;
						if( I$6 <= TMP$140$6) goto label$427;
						label$426:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 69, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$423:;
				label$422:;
			}
			label$420:;
			label$419:;
		}
	}
	{
		uint16* TMP$141$2;
		uint16* TMP$142$2;
		double T$2;
		T$2 = 0x0p+0;
		char W$2[50];
		uint16* vr$1278 = fb_DoubleToWstr( T$2 );
		TMP$141$2 = vr$1278;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$141$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$141$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1280 = fb_DoubleToWstr( T$2 );
		TMP$142$2 = vr$1280;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$142$2 );
		fb_WstrDelete( (uint16*)TMP$142$2 );
		char R$2[50];
		char* vr$1283 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1283, 0ll, 0 );
		int64 vr$1286 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1288 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1286 == vr$1288) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1293 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1293 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1298 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1300 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1298 != vr$1300) goto label$431;
			{
				label$432:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$143$6;
						int64 vr$1302 = fb_StrLen( (void*)W$2, 50ll );
						TMP$143$6 = vr$1302 + -1ll;
						goto label$435;
						label$438:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$440;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$433;
							}
							label$440:;
							label$439:;
						}
						label$436:;
						I$6 = I$6 + 1ll;
						label$435:;
						if( I$6 <= TMP$143$6) goto label$438;
						label$437:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 70, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$434:;
				label$433:;
			}
			label$431:;
			label$430:;
		}
	}
	{
		uint16* TMP$144$2;
		uint16* TMP$145$2;
		double T$2;
		T$2 = 0x1.p-1;
		char W$2[50];
		uint16* vr$1311 = fb_DoubleToWstr( T$2 );
		TMP$144$2 = vr$1311;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$144$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$144$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1313 = fb_DoubleToWstr( T$2 );
		TMP$145$2 = vr$1313;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$145$2 );
		fb_WstrDelete( (uint16*)TMP$145$2 );
		char R$2[50];
		char* vr$1316 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1316, 0ll, 0 );
		int64 vr$1319 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1321 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1319 == vr$1321) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1326 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1326 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1331 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1333 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1331 != vr$1333) goto label$442;
			{
				label$443:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$146$6;
						int64 vr$1335 = fb_StrLen( (void*)W$2, 50ll );
						TMP$146$6 = vr$1335 + -1ll;
						goto label$446;
						label$449:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$451;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$444;
							}
							label$451:;
							label$450:;
						}
						label$447:;
						I$6 = I$6 + 1ll;
						label$446:;
						if( I$6 <= TMP$146$6) goto label$449;
						label$448:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 71, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$445:;
				label$444:;
			}
			label$442:;
			label$441:;
		}
	}
	{
		uint16* TMP$147$2;
		uint16* TMP$148$2;
		double T$2;
		T$2 = 0x1.p+0;
		char W$2[50];
		uint16* vr$1344 = fb_DoubleToWstr( T$2 );
		TMP$147$2 = vr$1344;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$147$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$147$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1346 = fb_DoubleToWstr( T$2 );
		TMP$148$2 = vr$1346;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$148$2 );
		fb_WstrDelete( (uint16*)TMP$148$2 );
		char R$2[50];
		char* vr$1349 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1349, 0ll, 0 );
		int64 vr$1352 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1354 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1352 == vr$1354) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1359 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1359 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1364 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1366 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1364 != vr$1366) goto label$453;
			{
				label$454:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$149$6;
						int64 vr$1368 = fb_StrLen( (void*)W$2, 50ll );
						TMP$149$6 = vr$1368 + -1ll;
						goto label$457;
						label$460:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$462;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$455;
							}
							label$462:;
							label$461:;
						}
						label$458:;
						I$6 = I$6 + 1ll;
						label$457:;
						if( I$6 <= TMP$149$6) goto label$460;
						label$459:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 72, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$456:;
				label$455:;
			}
			label$453:;
			label$452:;
		}
	}
	{
		uint16* TMP$150$2;
		uint16* TMP$151$2;
		double T$2;
		T$2 = 0x1.8p+0;
		char W$2[50];
		uint16* vr$1377 = fb_DoubleToWstr( T$2 );
		TMP$150$2 = vr$1377;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$150$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$150$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1379 = fb_DoubleToWstr( T$2 );
		TMP$151$2 = vr$1379;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$151$2 );
		fb_WstrDelete( (uint16*)TMP$151$2 );
		char R$2[50];
		char* vr$1382 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1382, 0ll, 0 );
		int64 vr$1385 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1387 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1385 == vr$1387) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1392 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1392 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1397 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1399 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1397 != vr$1399) goto label$464;
			{
				label$465:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$152$6;
						int64 vr$1401 = fb_StrLen( (void*)W$2, 50ll );
						TMP$152$6 = vr$1401 + -1ll;
						goto label$468;
						label$471:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$473;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$466;
							}
							label$473:;
							label$472:;
						}
						label$469:;
						I$6 = I$6 + 1ll;
						label$468:;
						if( I$6 <= TMP$152$6) goto label$471;
						label$470:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 73, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$467:;
				label$466:;
			}
			label$464:;
			label$463:;
		}
	}
	{
		uint16* TMP$153$2;
		uint16* TMP$154$2;
		double T$2;
		T$2 = 0x1.p+1;
		char W$2[50];
		uint16* vr$1410 = fb_DoubleToWstr( T$2 );
		TMP$153$2 = vr$1410;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$153$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$153$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1412 = fb_DoubleToWstr( T$2 );
		TMP$154$2 = vr$1412;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$154$2 );
		fb_WstrDelete( (uint16*)TMP$154$2 );
		char R$2[50];
		char* vr$1415 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1415, 0ll, 0 );
		int64 vr$1418 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1420 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1418 == vr$1420) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1425 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1425 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1430 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1432 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1430 != vr$1432) goto label$475;
			{
				label$476:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$155$6;
						int64 vr$1434 = fb_StrLen( (void*)W$2, 50ll );
						TMP$155$6 = vr$1434 + -1ll;
						goto label$479;
						label$482:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$484;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$477;
							}
							label$484:;
							label$483:;
						}
						label$480:;
						I$6 = I$6 + 1ll;
						label$479:;
						if( I$6 <= TMP$155$6) goto label$482;
						label$481:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 74, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
				}
				label$478:;
				label$477:;
			}
			label$475:;
			label$474:;
		}
	}
	{
		uint16* TMP$156$2;
		uint16* TMP$157$2;
		double T$2;
		T$2 = 0x1.4p+1;
		char W$2[50];
		uint16* vr$1443 = fb_DoubleToWstr( T$2 );
		TMP$156$2 = vr$1443;
		fb_WstrAssignToA_Init( (void*)W$2, 50ll, (uint16*)TMP$156$2, 0ll );
		fb_WstrDelete( (uint16*)TMP$156$2 );
		struct $14UZSTRING_FIXED U$2;
		uint16* vr$1445 = fb_DoubleToWstr( T$2 );
		TMP$157$2 = vr$1445;
		_ZN14UZSTRING_FIXEDC1EPKw( &U$2, (uint16*)TMP$157$2 );
		fb_WstrDelete( (uint16*)TMP$157$2 );
		char R$2[50];
		char* vr$1448 = _ZN14UZSTRING_FIXEDcvcEv( &U$2 );
		fb_StrAssign( (void*)R$2, 50ll, (void*)vr$1448, 0ll, 0 );
		int64 vr$1451 = fb_StrLen( (void*)W$2, 50ll );
		int64 vr$1453 = fb_StrLen( (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1451 == vr$1453) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT(len(w) = len(r))" );
		int32 vr$1458 = fb_StrCompare( (void*)W$2, 50ll, (void*)R$2, 50ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1458 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_ASSERT_EQUAL(w,r)" );
		{
			int64 vr$1463 = fb_StrLen( (void*)W$2, 50ll );
			int64 vr$1465 = fb_StrLen( (void*)R$2, 50ll );
			if( vr$1463 != vr$1465) goto label$486;
			{
				label$487:;
				{
					{
						int64 I$6;
						I$6 = 0ll;
						int64 TMP$158$6;
						int64 vr$1467 = fb_StrLen( (void*)W$2, 50ll );
						TMP$158$6 = vr$1467 + -1ll;
						goto label$490;
						label$493:;
						{
							if( (int64)*(uint8*)((uint8*)W$2 + I$6) == (int64)*(uint8*)((uint8*)R$2 + I$6)) goto label$495;
							{
								_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_FAIL()" );
								goto label$488;
							}
							label$495:;
							label$494:;
						}
						label$491:;
						I$6 = I$6 + 1ll;
						label$490:;
						if( I$6 <= TMP$158$6) goto label$493;
						label$492:;
					}
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 75, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.NUMERIC", (char*)"CU_PASS()" );
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

void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_7DEFAULTEv( void )
{
	uint16* TMP$162$1;
	uint16* TMP$163$1;
	uint16* TMP$164$1;
	label$498:;
	char S1$1[10];
	fb_WstrAssignToA_Init( (void*)S1$1, 10ll, (uint16*)L"A", 0ll );
	char S2$1[10];
	fb_WstrAssignToA_Init( (void*)S2$1, 10ll, (uint16*)L"A", 0ll );
	char S3$1[10];
	uint16* vr$3 = fb_StrToWstr( (char*)S1$1 );
	TMP$162$1 = vr$3;
	fb_WstrAssignToA_Init( (void*)S3$1, 10ll, (uint16*)TMP$162$1, 0ll );
	fb_WstrDelete( (uint16*)TMP$162$1 );
	struct $14UZSTRING_FIXED U1$1;
	_ZN14UZSTRING_FIXEDC1EPKw( &U1$1, (uint16*)L"A" );
	struct $14UZSTRING_FIXED U2$1;
	_ZN14UZSTRING_FIXEDC1EPKw( &U2$1, (uint16*)L"A" );
	struct $14UZSTRING_FIXED U3$1;
	uint16* vr$8 = fb_StrToWstr( (char*)S1$1 );
	TMP$163$1 = vr$8;
	_ZN14UZSTRING_FIXEDC1EPKw( &U3$1, (uint16*)TMP$163$1 );
	fb_WstrDelete( (uint16*)TMP$163$1 );
	struct $14UZSTRING_FIXED U4$1;
	char* vr$11 = _ZN14UZSTRING_FIXEDcvcEv( &U1$1 );
	uint16* vr$12 = fb_StrToWstr( vr$11 );
	TMP$164$1 = vr$12;
	_ZN14UZSTRING_FIXEDC1EPKw( &U4$1, (uint16*)TMP$164$1 );
	fb_WstrDelete( (uint16*)TMP$164$1 );
	char S4$1[10];
	char* vr$15 = _ZN14UZSTRING_FIXEDcvcEv( &U1$1 );
	fb_StrAssign( (void*)S4$1, 10ll, (void*)vr$15, 0ll, 0 );
	char R1$1[10];
	char* vr$18 = _ZN14UZSTRING_FIXEDcvcEv( &U1$1 );
	fb_StrAssign( (void*)R1$1, 10ll, (void*)vr$18, 0ll, 0 );
	char R2$1[10];
	char* vr$21 = _ZN14UZSTRING_FIXEDcvcEv( &U2$1 );
	fb_StrAssign( (void*)R2$1, 10ll, (void*)vr$21, 0ll, 0 );
	char R3$1[10];
	char* vr$24 = _ZN14UZSTRING_FIXEDcvcEv( &U3$1 );
	fb_StrAssign( (void*)R3$1, 10ll, (void*)vr$24, 0ll, 0 );
	char R4$1[10];
	char* vr$27 = _ZN14UZSTRING_FIXEDcvcEv( &U4$1 );
	fb_StrAssign( (void*)R4$1, 10ll, (void*)vr$27, 0ll, 0 );
	int64 vr$30 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$32 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$30 == vr$32) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s1))" );
	int32 vr$37 = fb_StrCompare( (void*)S1$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$37 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s1)" );
	{
		int64 vr$42 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$44 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$42 != vr$44) goto label$501;
		{
			label$502:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$174$5;
					int64 vr$46 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$174$5 = vr$46 + -1ll;
					goto label$505;
					label$508:;
					{
						goto label$510;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$503;
						}
						label$510:;
						label$509:;
					}
					label$506:;
					I$5 = I$5 + 1ll;
					label$505:;
					if( I$5 <= TMP$174$5) goto label$508;
					label$507:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$504:;
			label$503:;
		}
		label$501:;
		label$500:;
	}
	int64 vr$50 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$52 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$50 == vr$52) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s2))" );
	int32 vr$57 = fb_StrCompare( (void*)S1$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$57 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s2)" );
	{
		int64 vr$62 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$64 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$62 != vr$64) goto label$512;
		{
			label$513:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$181$5;
					int64 vr$66 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$181$5 = vr$66 + -1ll;
					goto label$516;
					label$519:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$521;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$514;
						}
						label$521:;
						label$520:;
					}
					label$517:;
					I$5 = I$5 + 1ll;
					label$516:;
					if( I$5 <= TMP$181$5) goto label$519;
					label$518:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$515:;
			label$514:;
		}
		label$512:;
		label$511:;
	}
	int64 vr$76 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$78 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$76 == vr$78) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s3))" );
	int32 vr$83 = fb_StrCompare( (void*)S1$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$83 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s3)" );
	{
		int64 vr$88 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$90 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$88 != vr$90) goto label$523;
		{
			label$524:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$188$5;
					int64 vr$92 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$188$5 = vr$92 + -1ll;
					goto label$527;
					label$530:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$532;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$525;
						}
						label$532:;
						label$531:;
					}
					label$528:;
					I$5 = I$5 + 1ll;
					label$527:;
					if( I$5 <= TMP$188$5) goto label$530;
					label$529:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$526:;
			label$525:;
		}
		label$523:;
		label$522:;
	}
	int64 vr$102 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$104 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$102 == vr$104) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(s4))" );
	int32 vr$109 = fb_StrCompare( (void*)S1$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$109 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,s4)" );
	{
		int64 vr$114 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$116 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$114 != vr$116) goto label$534;
		{
			label$535:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$195$5;
					int64 vr$118 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$195$5 = vr$118 + -1ll;
					goto label$538;
					label$541:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$543;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$536;
						}
						label$543:;
						label$542:;
					}
					label$539:;
					I$5 = I$5 + 1ll;
					label$538:;
					if( I$5 <= TMP$195$5) goto label$541;
					label$540:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$537:;
			label$536:;
		}
		label$534:;
		label$533:;
	}
	int64 vr$128 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$130 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$128 == vr$130) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r1))" );
	int32 vr$135 = fb_StrCompare( (void*)S1$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$135 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r1)" );
	{
		int64 vr$140 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$142 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$140 != vr$142) goto label$545;
		{
			label$546:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$202$5;
					int64 vr$144 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$202$5 = vr$144 + -1ll;
					goto label$549;
					label$552:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$554;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$547;
						}
						label$554:;
						label$553:;
					}
					label$550:;
					I$5 = I$5 + 1ll;
					label$549:;
					if( I$5 <= TMP$202$5) goto label$552;
					label$551:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$548:;
			label$547:;
		}
		label$545:;
		label$544:;
	}
	int64 vr$154 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$156 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$154 == vr$156) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r2))" );
	int32 vr$161 = fb_StrCompare( (void*)S1$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$161 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r2)" );
	{
		int64 vr$166 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$168 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$166 != vr$168) goto label$556;
		{
			label$557:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$209$5;
					int64 vr$170 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$209$5 = vr$170 + -1ll;
					goto label$560;
					label$563:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$565;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$558;
						}
						label$565:;
						label$564:;
					}
					label$561:;
					I$5 = I$5 + 1ll;
					label$560:;
					if( I$5 <= TMP$209$5) goto label$563;
					label$562:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$559:;
			label$558:;
		}
		label$556:;
		label$555:;
	}
	int64 vr$180 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$182 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$180 == vr$182) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r3))" );
	int32 vr$187 = fb_StrCompare( (void*)S1$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$187 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r3)" );
	{
		int64 vr$192 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$194 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$192 != vr$194) goto label$567;
		{
			label$568:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$216$5;
					int64 vr$196 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$216$5 = vr$196 + -1ll;
					goto label$571;
					label$574:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$576;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$569;
						}
						label$576:;
						label$575:;
					}
					label$572:;
					I$5 = I$5 + 1ll;
					label$571:;
					if( I$5 <= TMP$216$5) goto label$574;
					label$573:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$570:;
			label$569:;
		}
		label$567:;
		label$566:;
	}
	int64 vr$206 = fb_StrLen( (void*)S1$1, 10ll );
	int64 vr$208 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$206 == vr$208) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s1) = len(r4))" );
	int32 vr$213 = fb_StrCompare( (void*)S1$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$213 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s1,r4)" );
	{
		int64 vr$218 = fb_StrLen( (void*)S1$1, 10ll );
		int64 vr$220 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$218 != vr$220) goto label$578;
		{
			label$579:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$223$5;
					int64 vr$222 = fb_StrLen( (void*)S1$1, 10ll );
					TMP$223$5 = vr$222 + -1ll;
					goto label$582;
					label$585:;
					{
						if( (int64)*(uint8*)((uint8*)S1$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$587;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$580;
						}
						label$587:;
						label$586:;
					}
					label$583:;
					I$5 = I$5 + 1ll;
					label$582:;
					if( I$5 <= TMP$223$5) goto label$585;
					label$584:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$581:;
			label$580:;
		}
		label$578:;
		label$577:;
	}
	int64 vr$232 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$234 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$232 == vr$234) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s1))" );
	int32 vr$239 = fb_StrCompare( (void*)S2$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$239 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s1)" );
	{
		int64 vr$244 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$246 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$244 != vr$246) goto label$589;
		{
			label$590:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$231$5;
					int64 vr$248 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$231$5 = vr$248 + -1ll;
					goto label$593;
					label$596:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$598;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$591;
						}
						label$598:;
						label$597:;
					}
					label$594:;
					I$5 = I$5 + 1ll;
					label$593:;
					if( I$5 <= TMP$231$5) goto label$596;
					label$595:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$592:;
			label$591:;
		}
		label$589:;
		label$588:;
	}
	int64 vr$258 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$260 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$258 == vr$260) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s2))" );
	int32 vr$265 = fb_StrCompare( (void*)S2$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$265 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s2)" );
	{
		int64 vr$270 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$272 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$270 != vr$272) goto label$600;
		{
			label$601:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$237$5;
					int64 vr$274 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$237$5 = vr$274 + -1ll;
					goto label$604;
					label$607:;
					{
						goto label$609;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$602;
						}
						label$609:;
						label$608:;
					}
					label$605:;
					I$5 = I$5 + 1ll;
					label$604:;
					if( I$5 <= TMP$237$5) goto label$607;
					label$606:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$603:;
			label$602:;
		}
		label$600:;
		label$599:;
	}
	int64 vr$278 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$280 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$278 == vr$280) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s3))" );
	int32 vr$285 = fb_StrCompare( (void*)S2$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$285 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s3)" );
	{
		int64 vr$290 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$292 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$290 != vr$292) goto label$611;
		{
			label$612:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$243$5;
					int64 vr$294 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$243$5 = vr$294 + -1ll;
					goto label$615;
					label$618:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$620;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$613;
						}
						label$620:;
						label$619:;
					}
					label$616:;
					I$5 = I$5 + 1ll;
					label$615:;
					if( I$5 <= TMP$243$5) goto label$618;
					label$617:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$614:;
			label$613:;
		}
		label$611:;
		label$610:;
	}
	int64 vr$304 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$306 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$304 == vr$306) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(s4))" );
	int32 vr$311 = fb_StrCompare( (void*)S2$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$311 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,s4)" );
	{
		int64 vr$316 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$318 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$316 != vr$318) goto label$622;
		{
			label$623:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$249$5;
					int64 vr$320 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$249$5 = vr$320 + -1ll;
					goto label$626;
					label$629:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$631;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$624;
						}
						label$631:;
						label$630:;
					}
					label$627:;
					I$5 = I$5 + 1ll;
					label$626:;
					if( I$5 <= TMP$249$5) goto label$629;
					label$628:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$625:;
			label$624:;
		}
		label$622:;
		label$621:;
	}
	int64 vr$330 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$332 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$330 == vr$332) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r1))" );
	int32 vr$337 = fb_StrCompare( (void*)S2$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$337 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r1)" );
	{
		int64 vr$342 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$344 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$342 != vr$344) goto label$633;
		{
			label$634:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$255$5;
					int64 vr$346 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$255$5 = vr$346 + -1ll;
					goto label$637;
					label$640:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$642;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$635;
						}
						label$642:;
						label$641:;
					}
					label$638:;
					I$5 = I$5 + 1ll;
					label$637:;
					if( I$5 <= TMP$255$5) goto label$640;
					label$639:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$636:;
			label$635:;
		}
		label$633:;
		label$632:;
	}
	int64 vr$356 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$358 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$356 == vr$358) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r2))" );
	int32 vr$363 = fb_StrCompare( (void*)S2$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$363 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r2)" );
	{
		int64 vr$368 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$370 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$368 != vr$370) goto label$644;
		{
			label$645:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$261$5;
					int64 vr$372 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$261$5 = vr$372 + -1ll;
					goto label$648;
					label$651:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$653;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$646;
						}
						label$653:;
						label$652:;
					}
					label$649:;
					I$5 = I$5 + 1ll;
					label$648:;
					if( I$5 <= TMP$261$5) goto label$651;
					label$650:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$647:;
			label$646:;
		}
		label$644:;
		label$643:;
	}
	int64 vr$382 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$384 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$382 == vr$384) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r3))" );
	int32 vr$389 = fb_StrCompare( (void*)S2$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$389 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r3)" );
	{
		int64 vr$394 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$396 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$394 != vr$396) goto label$655;
		{
			label$656:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$267$5;
					int64 vr$398 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$267$5 = vr$398 + -1ll;
					goto label$659;
					label$662:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$664;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$657;
						}
						label$664:;
						label$663:;
					}
					label$660:;
					I$5 = I$5 + 1ll;
					label$659:;
					if( I$5 <= TMP$267$5) goto label$662;
					label$661:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$658:;
			label$657:;
		}
		label$655:;
		label$654:;
	}
	int64 vr$408 = fb_StrLen( (void*)S2$1, 10ll );
	int64 vr$410 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$408 == vr$410) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s2) = len(r4))" );
	int32 vr$415 = fb_StrCompare( (void*)S2$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$415 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s2,r4)" );
	{
		int64 vr$420 = fb_StrLen( (void*)S2$1, 10ll );
		int64 vr$422 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$420 != vr$422) goto label$666;
		{
			label$667:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$273$5;
					int64 vr$424 = fb_StrLen( (void*)S2$1, 10ll );
					TMP$273$5 = vr$424 + -1ll;
					goto label$670;
					label$673:;
					{
						if( (int64)*(uint8*)((uint8*)S2$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$675;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$668;
						}
						label$675:;
						label$674:;
					}
					label$671:;
					I$5 = I$5 + 1ll;
					label$670:;
					if( I$5 <= TMP$273$5) goto label$673;
					label$672:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$669:;
			label$668:;
		}
		label$666:;
		label$665:;
	}
	int64 vr$434 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$436 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$434 == vr$436) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s1))" );
	int32 vr$441 = fb_StrCompare( (void*)S3$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$441 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s1)" );
	{
		int64 vr$446 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$448 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$446 != vr$448) goto label$677;
		{
			label$678:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$281$5;
					int64 vr$450 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$281$5 = vr$450 + -1ll;
					goto label$681;
					label$684:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$686;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$679;
						}
						label$686:;
						label$685:;
					}
					label$682:;
					I$5 = I$5 + 1ll;
					label$681:;
					if( I$5 <= TMP$281$5) goto label$684;
					label$683:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$680:;
			label$679:;
		}
		label$677:;
		label$676:;
	}
	int64 vr$460 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$462 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$460 == vr$462) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s2))" );
	int32 vr$467 = fb_StrCompare( (void*)S3$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$467 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s2)" );
	{
		int64 vr$472 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$474 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$472 != vr$474) goto label$688;
		{
			label$689:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$287$5;
					int64 vr$476 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$287$5 = vr$476 + -1ll;
					goto label$692;
					label$695:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$697;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$690;
						}
						label$697:;
						label$696:;
					}
					label$693:;
					I$5 = I$5 + 1ll;
					label$692:;
					if( I$5 <= TMP$287$5) goto label$695;
					label$694:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$691:;
			label$690:;
		}
		label$688:;
		label$687:;
	}
	int64 vr$486 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$488 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$486 == vr$488) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s3))" );
	int32 vr$493 = fb_StrCompare( (void*)S3$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$493 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s3)" );
	{
		int64 vr$498 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$500 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$498 != vr$500) goto label$699;
		{
			label$700:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$293$5;
					int64 vr$502 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$293$5 = vr$502 + -1ll;
					goto label$703;
					label$706:;
					{
						goto label$708;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$701;
						}
						label$708:;
						label$707:;
					}
					label$704:;
					I$5 = I$5 + 1ll;
					label$703:;
					if( I$5 <= TMP$293$5) goto label$706;
					label$705:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$702:;
			label$701:;
		}
		label$699:;
		label$698:;
	}
	int64 vr$506 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$508 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$506 == vr$508) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(s4))" );
	int32 vr$513 = fb_StrCompare( (void*)S3$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$513 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,s4)" );
	{
		int64 vr$518 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$520 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$518 != vr$520) goto label$710;
		{
			label$711:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$299$5;
					int64 vr$522 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$299$5 = vr$522 + -1ll;
					goto label$714;
					label$717:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$719;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$712;
						}
						label$719:;
						label$718:;
					}
					label$715:;
					I$5 = I$5 + 1ll;
					label$714:;
					if( I$5 <= TMP$299$5) goto label$717;
					label$716:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$713:;
			label$712:;
		}
		label$710:;
		label$709:;
	}
	int64 vr$532 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$534 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$532 == vr$534) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r1))" );
	int32 vr$539 = fb_StrCompare( (void*)S3$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$539 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r1)" );
	{
		int64 vr$544 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$546 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$544 != vr$546) goto label$721;
		{
			label$722:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$305$5;
					int64 vr$548 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$305$5 = vr$548 + -1ll;
					goto label$725;
					label$728:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$730;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$723;
						}
						label$730:;
						label$729:;
					}
					label$726:;
					I$5 = I$5 + 1ll;
					label$725:;
					if( I$5 <= TMP$305$5) goto label$728;
					label$727:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$724:;
			label$723:;
		}
		label$721:;
		label$720:;
	}
	int64 vr$558 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$560 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$558 == vr$560) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r2))" );
	int32 vr$565 = fb_StrCompare( (void*)S3$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$565 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r2)" );
	{
		int64 vr$570 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$572 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$570 != vr$572) goto label$732;
		{
			label$733:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$311$5;
					int64 vr$574 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$311$5 = vr$574 + -1ll;
					goto label$736;
					label$739:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$741;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$734;
						}
						label$741:;
						label$740:;
					}
					label$737:;
					I$5 = I$5 + 1ll;
					label$736:;
					if( I$5 <= TMP$311$5) goto label$739;
					label$738:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$735:;
			label$734:;
		}
		label$732:;
		label$731:;
	}
	int64 vr$584 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$586 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$584 == vr$586) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r3))" );
	int32 vr$591 = fb_StrCompare( (void*)S3$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$591 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r3)" );
	{
		int64 vr$596 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$598 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$596 != vr$598) goto label$743;
		{
			label$744:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$317$5;
					int64 vr$600 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$317$5 = vr$600 + -1ll;
					goto label$747;
					label$750:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$752;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$745;
						}
						label$752:;
						label$751:;
					}
					label$748:;
					I$5 = I$5 + 1ll;
					label$747:;
					if( I$5 <= TMP$317$5) goto label$750;
					label$749:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$746:;
			label$745:;
		}
		label$743:;
		label$742:;
	}
	int64 vr$610 = fb_StrLen( (void*)S3$1, 10ll );
	int64 vr$612 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$610 == vr$612) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s3) = len(r4))" );
	int32 vr$617 = fb_StrCompare( (void*)S3$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$617 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s3,r4)" );
	{
		int64 vr$622 = fb_StrLen( (void*)S3$1, 10ll );
		int64 vr$624 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$622 != vr$624) goto label$754;
		{
			label$755:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$323$5;
					int64 vr$626 = fb_StrLen( (void*)S3$1, 10ll );
					TMP$323$5 = vr$626 + -1ll;
					goto label$758;
					label$761:;
					{
						if( (int64)*(uint8*)((uint8*)S3$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$763;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$756;
						}
						label$763:;
						label$762:;
					}
					label$759:;
					I$5 = I$5 + 1ll;
					label$758:;
					if( I$5 <= TMP$323$5) goto label$761;
					label$760:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$757:;
			label$756:;
		}
		label$754:;
		label$753:;
	}
	int64 vr$636 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$638 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$636 == vr$638) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s1))" );
	int32 vr$643 = fb_StrCompare( (void*)S4$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$643 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s1)" );
	{
		int64 vr$648 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$650 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$648 != vr$650) goto label$765;
		{
			label$766:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$331$5;
					int64 vr$652 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$331$5 = vr$652 + -1ll;
					goto label$769;
					label$772:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$774;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$767;
						}
						label$774:;
						label$773:;
					}
					label$770:;
					I$5 = I$5 + 1ll;
					label$769:;
					if( I$5 <= TMP$331$5) goto label$772;
					label$771:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$768:;
			label$767:;
		}
		label$765:;
		label$764:;
	}
	int64 vr$662 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$664 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$662 == vr$664) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s2))" );
	int32 vr$669 = fb_StrCompare( (void*)S4$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$669 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s2)" );
	{
		int64 vr$674 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$676 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$674 != vr$676) goto label$776;
		{
			label$777:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$337$5;
					int64 vr$678 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$337$5 = vr$678 + -1ll;
					goto label$780;
					label$783:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$785;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$778;
						}
						label$785:;
						label$784:;
					}
					label$781:;
					I$5 = I$5 + 1ll;
					label$780:;
					if( I$5 <= TMP$337$5) goto label$783;
					label$782:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$779:;
			label$778:;
		}
		label$776:;
		label$775:;
	}
	int64 vr$688 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$690 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$688 == vr$690) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s3))" );
	int32 vr$695 = fb_StrCompare( (void*)S4$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$695 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s3)" );
	{
		int64 vr$700 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$702 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$700 != vr$702) goto label$787;
		{
			label$788:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$343$5;
					int64 vr$704 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$343$5 = vr$704 + -1ll;
					goto label$791;
					label$794:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$796;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$789;
						}
						label$796:;
						label$795:;
					}
					label$792:;
					I$5 = I$5 + 1ll;
					label$791:;
					if( I$5 <= TMP$343$5) goto label$794;
					label$793:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$790:;
			label$789:;
		}
		label$787:;
		label$786:;
	}
	int64 vr$714 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$716 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$714 == vr$716) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(s4))" );
	int32 vr$721 = fb_StrCompare( (void*)S4$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$721 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,s4)" );
	{
		int64 vr$726 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$728 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$726 != vr$728) goto label$798;
		{
			label$799:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$349$5;
					int64 vr$730 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$349$5 = vr$730 + -1ll;
					goto label$802;
					label$805:;
					{
						goto label$807;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$800;
						}
						label$807:;
						label$806:;
					}
					label$803:;
					I$5 = I$5 + 1ll;
					label$802:;
					if( I$5 <= TMP$349$5) goto label$805;
					label$804:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$801:;
			label$800:;
		}
		label$798:;
		label$797:;
	}
	int64 vr$734 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$736 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$734 == vr$736) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r1))" );
	int32 vr$741 = fb_StrCompare( (void*)S4$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$741 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r1)" );
	{
		int64 vr$746 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$748 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$746 != vr$748) goto label$809;
		{
			label$810:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$355$5;
					int64 vr$750 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$355$5 = vr$750 + -1ll;
					goto label$813;
					label$816:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$818;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$811;
						}
						label$818:;
						label$817:;
					}
					label$814:;
					I$5 = I$5 + 1ll;
					label$813:;
					if( I$5 <= TMP$355$5) goto label$816;
					label$815:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$812:;
			label$811:;
		}
		label$809:;
		label$808:;
	}
	int64 vr$760 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$762 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$760 == vr$762) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r2))" );
	int32 vr$767 = fb_StrCompare( (void*)S4$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$767 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r2)" );
	{
		int64 vr$772 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$774 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$772 != vr$774) goto label$820;
		{
			label$821:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$361$5;
					int64 vr$776 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$361$5 = vr$776 + -1ll;
					goto label$824;
					label$827:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$829;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$822;
						}
						label$829:;
						label$828:;
					}
					label$825:;
					I$5 = I$5 + 1ll;
					label$824:;
					if( I$5 <= TMP$361$5) goto label$827;
					label$826:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$823:;
			label$822:;
		}
		label$820:;
		label$819:;
	}
	int64 vr$786 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$788 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$786 == vr$788) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r3))" );
	int32 vr$793 = fb_StrCompare( (void*)S4$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$793 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r3)" );
	{
		int64 vr$798 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$800 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$798 != vr$800) goto label$831;
		{
			label$832:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$367$5;
					int64 vr$802 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$367$5 = vr$802 + -1ll;
					goto label$835;
					label$838:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$840;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$833;
						}
						label$840:;
						label$839:;
					}
					label$836:;
					I$5 = I$5 + 1ll;
					label$835:;
					if( I$5 <= TMP$367$5) goto label$838;
					label$837:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$834:;
			label$833:;
		}
		label$831:;
		label$830:;
	}
	int64 vr$812 = fb_StrLen( (void*)S4$1, 10ll );
	int64 vr$814 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$812 == vr$814) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(s4) = len(r4))" );
	int32 vr$819 = fb_StrCompare( (void*)S4$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$819 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(s4,r4)" );
	{
		int64 vr$824 = fb_StrLen( (void*)S4$1, 10ll );
		int64 vr$826 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$824 != vr$826) goto label$842;
		{
			label$843:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$373$5;
					int64 vr$828 = fb_StrLen( (void*)S4$1, 10ll );
					TMP$373$5 = vr$828 + -1ll;
					goto label$846;
					label$849:;
					{
						if( (int64)*(uint8*)((uint8*)S4$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$851;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$844;
						}
						label$851:;
						label$850:;
					}
					label$847:;
					I$5 = I$5 + 1ll;
					label$846:;
					if( I$5 <= TMP$373$5) goto label$849;
					label$848:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 114, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$845:;
			label$844:;
		}
		label$842:;
		label$841:;
	}
	int64 vr$838 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$840 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$838 == vr$840) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s1))" );
	int32 vr$845 = fb_StrCompare( (void*)R1$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$845 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s1)" );
	{
		int64 vr$850 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$852 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$850 != vr$852) goto label$853;
		{
			label$854:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$381$5;
					int64 vr$854 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$381$5 = vr$854 + -1ll;
					goto label$857;
					label$860:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$862;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$855;
						}
						label$862:;
						label$861:;
					}
					label$858:;
					I$5 = I$5 + 1ll;
					label$857:;
					if( I$5 <= TMP$381$5) goto label$860;
					label$859:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$856:;
			label$855:;
		}
		label$853:;
		label$852:;
	}
	int64 vr$864 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$866 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$864 == vr$866) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s2))" );
	int32 vr$871 = fb_StrCompare( (void*)R1$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$871 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s2)" );
	{
		int64 vr$876 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$878 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$876 != vr$878) goto label$864;
		{
			label$865:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$387$5;
					int64 vr$880 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$387$5 = vr$880 + -1ll;
					goto label$868;
					label$871:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$873;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$866;
						}
						label$873:;
						label$872:;
					}
					label$869:;
					I$5 = I$5 + 1ll;
					label$868:;
					if( I$5 <= TMP$387$5) goto label$871;
					label$870:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$867:;
			label$866:;
		}
		label$864:;
		label$863:;
	}
	int64 vr$890 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$892 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$890 == vr$892) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s3))" );
	int32 vr$897 = fb_StrCompare( (void*)R1$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$897 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s3)" );
	{
		int64 vr$902 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$904 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$902 != vr$904) goto label$875;
		{
			label$876:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$393$5;
					int64 vr$906 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$393$5 = vr$906 + -1ll;
					goto label$879;
					label$882:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$884;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$877;
						}
						label$884:;
						label$883:;
					}
					label$880:;
					I$5 = I$5 + 1ll;
					label$879:;
					if( I$5 <= TMP$393$5) goto label$882;
					label$881:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$878:;
			label$877:;
		}
		label$875:;
		label$874:;
	}
	int64 vr$916 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$918 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$916 == vr$918) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(s4))" );
	int32 vr$923 = fb_StrCompare( (void*)R1$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$923 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,s4)" );
	{
		int64 vr$928 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$930 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$928 != vr$930) goto label$886;
		{
			label$887:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$399$5;
					int64 vr$932 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$399$5 = vr$932 + -1ll;
					goto label$890;
					label$893:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$895;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$888;
						}
						label$895:;
						label$894:;
					}
					label$891:;
					I$5 = I$5 + 1ll;
					label$890:;
					if( I$5 <= TMP$399$5) goto label$893;
					label$892:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$889:;
			label$888:;
		}
		label$886:;
		label$885:;
	}
	int64 vr$942 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$944 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$942 == vr$944) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r1))" );
	int32 vr$949 = fb_StrCompare( (void*)R1$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$949 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r1)" );
	{
		int64 vr$954 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$956 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$954 != vr$956) goto label$897;
		{
			label$898:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$405$5;
					int64 vr$958 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$405$5 = vr$958 + -1ll;
					goto label$901;
					label$904:;
					{
						goto label$906;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$899;
						}
						label$906:;
						label$905:;
					}
					label$902:;
					I$5 = I$5 + 1ll;
					label$901:;
					if( I$5 <= TMP$405$5) goto label$904;
					label$903:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$900:;
			label$899:;
		}
		label$897:;
		label$896:;
	}
	int64 vr$962 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$964 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$962 == vr$964) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r2))" );
	int32 vr$969 = fb_StrCompare( (void*)R1$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$969 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r2)" );
	{
		int64 vr$974 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$976 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$974 != vr$976) goto label$908;
		{
			label$909:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$411$5;
					int64 vr$978 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$411$5 = vr$978 + -1ll;
					goto label$912;
					label$915:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$917;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$910;
						}
						label$917:;
						label$916:;
					}
					label$913:;
					I$5 = I$5 + 1ll;
					label$912:;
					if( I$5 <= TMP$411$5) goto label$915;
					label$914:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$911:;
			label$910:;
		}
		label$908:;
		label$907:;
	}
	int64 vr$988 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$990 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$988 == vr$990) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r3))" );
	int32 vr$995 = fb_StrCompare( (void*)R1$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$995 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r3)" );
	{
		int64 vr$1000 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$1002 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$1000 != vr$1002) goto label$919;
		{
			label$920:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$417$5;
					int64 vr$1004 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$417$5 = vr$1004 + -1ll;
					goto label$923;
					label$926:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$928;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$921;
						}
						label$928:;
						label$927:;
					}
					label$924:;
					I$5 = I$5 + 1ll;
					label$923:;
					if( I$5 <= TMP$417$5) goto label$926;
					label$925:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$922:;
			label$921:;
		}
		label$919:;
		label$918:;
	}
	int64 vr$1014 = fb_StrLen( (void*)R1$1, 10ll );
	int64 vr$1016 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1014 == vr$1016) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(r4))" );
	int32 vr$1021 = fb_StrCompare( (void*)R1$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1021 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,r4)" );
	{
		int64 vr$1026 = fb_StrLen( (void*)R1$1, 10ll );
		int64 vr$1028 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$1026 != vr$1028) goto label$930;
		{
			label$931:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$423$5;
					int64 vr$1030 = fb_StrLen( (void*)R1$1, 10ll );
					TMP$423$5 = vr$1030 + -1ll;
					goto label$934;
					label$937:;
					{
						if( (int64)*(uint8*)((uint8*)R1$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$939;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$932;
						}
						label$939:;
						label$938:;
					}
					label$935:;
					I$5 = I$5 + 1ll;
					label$934:;
					if( I$5 <= TMP$423$5) goto label$937;
					label$936:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 115, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$933:;
			label$932:;
		}
		label$930:;
		label$929:;
	}
	int64 vr$1040 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1042 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1040 == vr$1042) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s1))" );
	int32 vr$1047 = fb_StrCompare( (void*)R2$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1047 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s1)" );
	{
		int64 vr$1052 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1054 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$1052 != vr$1054) goto label$941;
		{
			label$942:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$431$5;
					int64 vr$1056 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$431$5 = vr$1056 + -1ll;
					goto label$945;
					label$948:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$950;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$943;
						}
						label$950:;
						label$949:;
					}
					label$946:;
					I$5 = I$5 + 1ll;
					label$945:;
					if( I$5 <= TMP$431$5) goto label$948;
					label$947:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$944:;
			label$943:;
		}
		label$941:;
		label$940:;
	}
	int64 vr$1066 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1068 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1066 == vr$1068) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s2))" );
	int32 vr$1073 = fb_StrCompare( (void*)R2$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1073 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s2)" );
	{
		int64 vr$1078 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1080 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$1078 != vr$1080) goto label$952;
		{
			label$953:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$437$5;
					int64 vr$1082 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$437$5 = vr$1082 + -1ll;
					goto label$956;
					label$959:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$961;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$954;
						}
						label$961:;
						label$960:;
					}
					label$957:;
					I$5 = I$5 + 1ll;
					label$956:;
					if( I$5 <= TMP$437$5) goto label$959;
					label$958:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$955:;
			label$954:;
		}
		label$952:;
		label$951:;
	}
	int64 vr$1092 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1094 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1092 == vr$1094) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s3))" );
	int32 vr$1099 = fb_StrCompare( (void*)R2$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1099 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s3)" );
	{
		int64 vr$1104 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1106 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$1104 != vr$1106) goto label$963;
		{
			label$964:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$443$5;
					int64 vr$1108 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$443$5 = vr$1108 + -1ll;
					goto label$967;
					label$970:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$972;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$965;
						}
						label$972:;
						label$971:;
					}
					label$968:;
					I$5 = I$5 + 1ll;
					label$967:;
					if( I$5 <= TMP$443$5) goto label$970;
					label$969:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$966:;
			label$965:;
		}
		label$963:;
		label$962:;
	}
	int64 vr$1118 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1120 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1118 == vr$1120) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(s4))" );
	int32 vr$1125 = fb_StrCompare( (void*)R2$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1125 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,s4)" );
	{
		int64 vr$1130 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1132 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$1130 != vr$1132) goto label$974;
		{
			label$975:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$449$5;
					int64 vr$1134 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$449$5 = vr$1134 + -1ll;
					goto label$978;
					label$981:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$983;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$976;
						}
						label$983:;
						label$982:;
					}
					label$979:;
					I$5 = I$5 + 1ll;
					label$978:;
					if( I$5 <= TMP$449$5) goto label$981;
					label$980:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$977:;
			label$976:;
		}
		label$974:;
		label$973:;
	}
	int64 vr$1144 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1146 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1144 == vr$1146) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r1))" );
	int32 vr$1151 = fb_StrCompare( (void*)R2$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1151 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r1)" );
	{
		int64 vr$1156 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1158 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$1156 != vr$1158) goto label$985;
		{
			label$986:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$455$5;
					int64 vr$1160 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$455$5 = vr$1160 + -1ll;
					goto label$989;
					label$992:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$994;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$987;
						}
						label$994:;
						label$993:;
					}
					label$990:;
					I$5 = I$5 + 1ll;
					label$989:;
					if( I$5 <= TMP$455$5) goto label$992;
					label$991:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$988:;
			label$987:;
		}
		label$985:;
		label$984:;
	}
	int64 vr$1170 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1172 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1170 == vr$1172) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r2))" );
	int32 vr$1177 = fb_StrCompare( (void*)R2$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1177 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r2)" );
	{
		int64 vr$1182 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1184 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$1182 != vr$1184) goto label$996;
		{
			label$997:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$461$5;
					int64 vr$1186 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$461$5 = vr$1186 + -1ll;
					goto label$1000;
					label$1003:;
					{
						goto label$1005;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$998;
						}
						label$1005:;
						label$1004:;
					}
					label$1001:;
					I$5 = I$5 + 1ll;
					label$1000:;
					if( I$5 <= TMP$461$5) goto label$1003;
					label$1002:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$999:;
			label$998:;
		}
		label$996:;
		label$995:;
	}
	int64 vr$1190 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1192 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1190 == vr$1192) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r3))" );
	int32 vr$1197 = fb_StrCompare( (void*)R2$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1197 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r3)" );
	{
		int64 vr$1202 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1204 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$1202 != vr$1204) goto label$1007;
		{
			label$1008:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$467$5;
					int64 vr$1206 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$467$5 = vr$1206 + -1ll;
					goto label$1011;
					label$1014:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$1016;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1009;
						}
						label$1016:;
						label$1015:;
					}
					label$1012:;
					I$5 = I$5 + 1ll;
					label$1011:;
					if( I$5 <= TMP$467$5) goto label$1014;
					label$1013:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1010:;
			label$1009:;
		}
		label$1007:;
		label$1006:;
	}
	int64 vr$1216 = fb_StrLen( (void*)R2$1, 10ll );
	int64 vr$1218 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1216 == vr$1218) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(r4))" );
	int32 vr$1223 = fb_StrCompare( (void*)R2$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1223 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,r4)" );
	{
		int64 vr$1228 = fb_StrLen( (void*)R2$1, 10ll );
		int64 vr$1230 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$1228 != vr$1230) goto label$1018;
		{
			label$1019:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$473$5;
					int64 vr$1232 = fb_StrLen( (void*)R2$1, 10ll );
					TMP$473$5 = vr$1232 + -1ll;
					goto label$1022;
					label$1025:;
					{
						if( (int64)*(uint8*)((uint8*)R2$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$1027;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1020;
						}
						label$1027:;
						label$1026:;
					}
					label$1023:;
					I$5 = I$5 + 1ll;
					label$1022:;
					if( I$5 <= TMP$473$5) goto label$1025;
					label$1024:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 116, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1021:;
			label$1020:;
		}
		label$1018:;
		label$1017:;
	}
	int64 vr$1242 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1244 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1242 == vr$1244) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s1))" );
	int32 vr$1249 = fb_StrCompare( (void*)R3$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1249 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s1)" );
	{
		int64 vr$1254 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1256 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$1254 != vr$1256) goto label$1029;
		{
			label$1030:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$481$5;
					int64 vr$1258 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$481$5 = vr$1258 + -1ll;
					goto label$1033;
					label$1036:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$1038;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1031;
						}
						label$1038:;
						label$1037:;
					}
					label$1034:;
					I$5 = I$5 + 1ll;
					label$1033:;
					if( I$5 <= TMP$481$5) goto label$1036;
					label$1035:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1032:;
			label$1031:;
		}
		label$1029:;
		label$1028:;
	}
	int64 vr$1268 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1270 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1268 == vr$1270) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s2))" );
	int32 vr$1275 = fb_StrCompare( (void*)R3$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1275 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s2)" );
	{
		int64 vr$1280 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1282 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$1280 != vr$1282) goto label$1040;
		{
			label$1041:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$487$5;
					int64 vr$1284 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$487$5 = vr$1284 + -1ll;
					goto label$1044;
					label$1047:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$1049;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1042;
						}
						label$1049:;
						label$1048:;
					}
					label$1045:;
					I$5 = I$5 + 1ll;
					label$1044:;
					if( I$5 <= TMP$487$5) goto label$1047;
					label$1046:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1043:;
			label$1042:;
		}
		label$1040:;
		label$1039:;
	}
	int64 vr$1294 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1296 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1294 == vr$1296) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s3))" );
	int32 vr$1301 = fb_StrCompare( (void*)R3$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1301 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s3)" );
	{
		int64 vr$1306 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1308 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$1306 != vr$1308) goto label$1051;
		{
			label$1052:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$493$5;
					int64 vr$1310 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$493$5 = vr$1310 + -1ll;
					goto label$1055;
					label$1058:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$1060;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1053;
						}
						label$1060:;
						label$1059:;
					}
					label$1056:;
					I$5 = I$5 + 1ll;
					label$1055:;
					if( I$5 <= TMP$493$5) goto label$1058;
					label$1057:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1054:;
			label$1053:;
		}
		label$1051:;
		label$1050:;
	}
	int64 vr$1320 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1322 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1320 == vr$1322) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(s4))" );
	int32 vr$1327 = fb_StrCompare( (void*)R3$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1327 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,s4)" );
	{
		int64 vr$1332 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1334 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$1332 != vr$1334) goto label$1062;
		{
			label$1063:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$499$5;
					int64 vr$1336 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$499$5 = vr$1336 + -1ll;
					goto label$1066;
					label$1069:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$1071;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1064;
						}
						label$1071:;
						label$1070:;
					}
					label$1067:;
					I$5 = I$5 + 1ll;
					label$1066:;
					if( I$5 <= TMP$499$5) goto label$1069;
					label$1068:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1065:;
			label$1064:;
		}
		label$1062:;
		label$1061:;
	}
	int64 vr$1346 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1348 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1346 == vr$1348) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r1))" );
	int32 vr$1353 = fb_StrCompare( (void*)R3$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1353 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r1)" );
	{
		int64 vr$1358 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1360 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$1358 != vr$1360) goto label$1073;
		{
			label$1074:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$505$5;
					int64 vr$1362 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$505$5 = vr$1362 + -1ll;
					goto label$1077;
					label$1080:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$1082;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1075;
						}
						label$1082:;
						label$1081:;
					}
					label$1078:;
					I$5 = I$5 + 1ll;
					label$1077:;
					if( I$5 <= TMP$505$5) goto label$1080;
					label$1079:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1076:;
			label$1075:;
		}
		label$1073:;
		label$1072:;
	}
	int64 vr$1372 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1374 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1372 == vr$1374) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r2))" );
	int32 vr$1379 = fb_StrCompare( (void*)R3$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1379 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r2)" );
	{
		int64 vr$1384 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1386 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$1384 != vr$1386) goto label$1084;
		{
			label$1085:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$511$5;
					int64 vr$1388 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$511$5 = vr$1388 + -1ll;
					goto label$1088;
					label$1091:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$1093;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1086;
						}
						label$1093:;
						label$1092:;
					}
					label$1089:;
					I$5 = I$5 + 1ll;
					label$1088:;
					if( I$5 <= TMP$511$5) goto label$1091;
					label$1090:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1087:;
			label$1086:;
		}
		label$1084:;
		label$1083:;
	}
	int64 vr$1398 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1400 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1398 == vr$1400) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r3))" );
	int32 vr$1405 = fb_StrCompare( (void*)R3$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1405 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r3)" );
	{
		int64 vr$1410 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1412 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$1410 != vr$1412) goto label$1095;
		{
			label$1096:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$517$5;
					int64 vr$1414 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$517$5 = vr$1414 + -1ll;
					goto label$1099;
					label$1102:;
					{
						goto label$1104;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1097;
						}
						label$1104:;
						label$1103:;
					}
					label$1100:;
					I$5 = I$5 + 1ll;
					label$1099:;
					if( I$5 <= TMP$517$5) goto label$1102;
					label$1101:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1098:;
			label$1097:;
		}
		label$1095:;
		label$1094:;
	}
	int64 vr$1418 = fb_StrLen( (void*)R3$1, 10ll );
	int64 vr$1420 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1418 == vr$1420) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r3) = len(r4))" );
	int32 vr$1425 = fb_StrCompare( (void*)R3$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1425 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r3,r4)" );
	{
		int64 vr$1430 = fb_StrLen( (void*)R3$1, 10ll );
		int64 vr$1432 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$1430 != vr$1432) goto label$1106;
		{
			label$1107:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$523$5;
					int64 vr$1434 = fb_StrLen( (void*)R3$1, 10ll );
					TMP$523$5 = vr$1434 + -1ll;
					goto label$1110;
					label$1113:;
					{
						if( (int64)*(uint8*)((uint8*)R3$1 + I$5) == (int64)*(uint8*)((uint8*)R4$1 + I$5)) goto label$1115;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1108;
						}
						label$1115:;
						label$1114:;
					}
					label$1111:;
					I$5 = I$5 + 1ll;
					label$1110:;
					if( I$5 <= TMP$523$5) goto label$1113;
					label$1112:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 117, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1109:;
			label$1108:;
		}
		label$1106:;
		label$1105:;
	}
	int64 vr$1444 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1446 = fb_StrLen( (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1444 == vr$1446) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s1))" );
	int32 vr$1451 = fb_StrCompare( (void*)R4$1, 10ll, (void*)S1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1451 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s1)" );
	{
		int64 vr$1456 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1458 = fb_StrLen( (void*)S1$1, 10ll );
		if( vr$1456 != vr$1458) goto label$1117;
		{
			label$1118:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$531$5;
					int64 vr$1460 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$531$5 = vr$1460 + -1ll;
					goto label$1121;
					label$1124:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)S1$1 + I$5)) goto label$1126;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1119;
						}
						label$1126:;
						label$1125:;
					}
					label$1122:;
					I$5 = I$5 + 1ll;
					label$1121:;
					if( I$5 <= TMP$531$5) goto label$1124;
					label$1123:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1120:;
			label$1119:;
		}
		label$1117:;
		label$1116:;
	}
	int64 vr$1470 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1472 = fb_StrLen( (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1470 == vr$1472) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s2))" );
	int32 vr$1477 = fb_StrCompare( (void*)R4$1, 10ll, (void*)S2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1477 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s2)" );
	{
		int64 vr$1482 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1484 = fb_StrLen( (void*)S2$1, 10ll );
		if( vr$1482 != vr$1484) goto label$1128;
		{
			label$1129:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$537$5;
					int64 vr$1486 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$537$5 = vr$1486 + -1ll;
					goto label$1132;
					label$1135:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)S2$1 + I$5)) goto label$1137;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1130;
						}
						label$1137:;
						label$1136:;
					}
					label$1133:;
					I$5 = I$5 + 1ll;
					label$1132:;
					if( I$5 <= TMP$537$5) goto label$1135;
					label$1134:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1131:;
			label$1130:;
		}
		label$1128:;
		label$1127:;
	}
	int64 vr$1496 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1498 = fb_StrLen( (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1496 == vr$1498) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s3))" );
	int32 vr$1503 = fb_StrCompare( (void*)R4$1, 10ll, (void*)S3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1503 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s3)" );
	{
		int64 vr$1508 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1510 = fb_StrLen( (void*)S3$1, 10ll );
		if( vr$1508 != vr$1510) goto label$1139;
		{
			label$1140:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$543$5;
					int64 vr$1512 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$543$5 = vr$1512 + -1ll;
					goto label$1143;
					label$1146:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)S3$1 + I$5)) goto label$1148;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1141;
						}
						label$1148:;
						label$1147:;
					}
					label$1144:;
					I$5 = I$5 + 1ll;
					label$1143:;
					if( I$5 <= TMP$543$5) goto label$1146;
					label$1145:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1142:;
			label$1141:;
		}
		label$1139:;
		label$1138:;
	}
	int64 vr$1522 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1524 = fb_StrLen( (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1522 == vr$1524) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(s4))" );
	int32 vr$1529 = fb_StrCompare( (void*)R4$1, 10ll, (void*)S4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1529 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,s4)" );
	{
		int64 vr$1534 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1536 = fb_StrLen( (void*)S4$1, 10ll );
		if( vr$1534 != vr$1536) goto label$1150;
		{
			label$1151:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$549$5;
					int64 vr$1538 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$549$5 = vr$1538 + -1ll;
					goto label$1154;
					label$1157:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)S4$1 + I$5)) goto label$1159;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1152;
						}
						label$1159:;
						label$1158:;
					}
					label$1155:;
					I$5 = I$5 + 1ll;
					label$1154:;
					if( I$5 <= TMP$549$5) goto label$1157;
					label$1156:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1153:;
			label$1152:;
		}
		label$1150:;
		label$1149:;
	}
	int64 vr$1548 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1550 = fb_StrLen( (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1548 == vr$1550) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r1))" );
	int32 vr$1555 = fb_StrCompare( (void*)R4$1, 10ll, (void*)R1$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1555 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r1)" );
	{
		int64 vr$1560 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1562 = fb_StrLen( (void*)R1$1, 10ll );
		if( vr$1560 != vr$1562) goto label$1161;
		{
			label$1162:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$555$5;
					int64 vr$1564 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$555$5 = vr$1564 + -1ll;
					goto label$1165;
					label$1168:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)R1$1 + I$5)) goto label$1170;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1163;
						}
						label$1170:;
						label$1169:;
					}
					label$1166:;
					I$5 = I$5 + 1ll;
					label$1165:;
					if( I$5 <= TMP$555$5) goto label$1168;
					label$1167:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1164:;
			label$1163:;
		}
		label$1161:;
		label$1160:;
	}
	int64 vr$1574 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1576 = fb_StrLen( (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1574 == vr$1576) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r2))" );
	int32 vr$1581 = fb_StrCompare( (void*)R4$1, 10ll, (void*)R2$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1581 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r2)" );
	{
		int64 vr$1586 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1588 = fb_StrLen( (void*)R2$1, 10ll );
		if( vr$1586 != vr$1588) goto label$1172;
		{
			label$1173:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$561$5;
					int64 vr$1590 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$561$5 = vr$1590 + -1ll;
					goto label$1176;
					label$1179:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)R2$1 + I$5)) goto label$1181;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1174;
						}
						label$1181:;
						label$1180:;
					}
					label$1177:;
					I$5 = I$5 + 1ll;
					label$1176:;
					if( I$5 <= TMP$561$5) goto label$1179;
					label$1178:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1175:;
			label$1174:;
		}
		label$1172:;
		label$1171:;
	}
	int64 vr$1600 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1602 = fb_StrLen( (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1600 == vr$1602) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r3))" );
	int32 vr$1607 = fb_StrCompare( (void*)R4$1, 10ll, (void*)R3$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1607 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r3)" );
	{
		int64 vr$1612 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1614 = fb_StrLen( (void*)R3$1, 10ll );
		if( vr$1612 != vr$1614) goto label$1183;
		{
			label$1184:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$567$5;
					int64 vr$1616 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$567$5 = vr$1616 + -1ll;
					goto label$1187;
					label$1190:;
					{
						if( (int64)*(uint8*)((uint8*)R4$1 + I$5) == (int64)*(uint8*)((uint8*)R3$1 + I$5)) goto label$1192;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1185;
						}
						label$1192:;
						label$1191:;
					}
					label$1188:;
					I$5 = I$5 + 1ll;
					label$1187:;
					if( I$5 <= TMP$567$5) goto label$1190;
					label$1189:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
			}
			label$1186:;
			label$1185:;
		}
		label$1183:;
		label$1182:;
	}
	int64 vr$1626 = fb_StrLen( (void*)R4$1, 10ll );
	int64 vr$1628 = fb_StrLen( (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1626 == vr$1628) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT(len(r4) = len(r4))" );
	int32 vr$1633 = fb_StrCompare( (void*)R4$1, 10ll, (void*)R4$1, 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1633 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r4,r4)" );
	{
		int64 vr$1638 = fb_StrLen( (void*)R4$1, 10ll );
		int64 vr$1640 = fb_StrLen( (void*)R4$1, 10ll );
		if( vr$1638 != vr$1640) goto label$1194;
		{
			label$1195:;
			{
				{
					int64 I$5;
					I$5 = 0ll;
					int64 TMP$573$5;
					int64 vr$1642 = fb_StrLen( (void*)R4$1, 10ll );
					TMP$573$5 = vr$1642 + -1ll;
					goto label$1198;
					label$1201:;
					{
						goto label$1203;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_FAIL()" );
							goto label$1196;
						}
						label$1203:;
						label$1202:;
					}
					label$1199:;
					I$5 = I$5 + 1ll;
					label$1198:;
					if( I$5 <= TMP$573$5) goto label$1201;
					label$1200:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cwstr.bas", 118, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.WSTR_.DEFAULT", (char*)"CU_PASS()" );
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

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_12NUMERIC_CTOREv( void )
{
	label$496:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.udt_zstring_.wstr_", (char*)"numeric", (tmp$5)&_ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_7NUMERICEv, (boolean)0ll );
	label$497:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_12DEFAULT_CTOREv( void )
{
	label$1204:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.udt_zstring_.wstr_", (char*)"default", (tmp$5)&_ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_7DEFAULTEv, (boolean)0ll );
	label$1205:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5WSTR_13SUITE_CTOR122Ev( void )
{
	label$1206:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.udt_zstring_.wstr_", (tmp$4)0ull, (tmp$4)0ull );
	label$1207:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
