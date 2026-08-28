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
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
int32 fb_StrCompare( void*, int64, void*, int64 );
int64 fb_StrLen( void*, int64 );
static void fb_ctor__iif( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN19UZSTRING_FIXED_BASEC1Ev( struct $19UZSTRING_FIXED_BASE* );
void _ZN14UZSTRING_FIXEDC1EPKc( struct $14UZSTRING_FIXED*, char* );
char* _ZN14UZSTRING_FIXEDcvcEv( struct $14UZSTRING_FIXED* );
static void _ZN14UZSTRING_FIXEDaSERKS_( struct $14UZSTRING_FIXED*, struct $14UZSTRING_FIXED* );
static void _ZN14UZSTRING_FIXEDC1ERKS_( struct $14UZSTRING_FIXED*, struct $14UZSTRING_FIXED* );
static void _ZN22UZSTRING_FIXED_MUTABLEaSERKS_( struct $22UZSTRING_FIXED_MUTABLE*, struct $22UZSTRING_FIXED_MUTABLE* );
void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_11ZSTRING_IIFEv( void );
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_16ZSTRING_IIF_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_11USTRING_IIFEv( void );
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_16USTRING_IIF_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_13SUITE_CTOR197Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_11ZSTRING_IIFEv( void )
{
	label$10:;
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"", 1ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"a", 2ll, 0 );
		struct $14UZSTRING_FIXED U1$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U1$2, (char*)"" );
		struct $14UZSTRING_FIXED U2$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U2$2, (char*)"a" );
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"a", 2ll, 0 );
			goto label$13;
			{
				int64 vr$6 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$8 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$6 == vr$8) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$13 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$13 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$18 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$20 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$18 != vr$20) goto label$15;
					{
						label$16:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$23$8;
								int64 vr$22 = fb_StrLen( (void*)A$3, 50ll );
								TMP$23$8 = vr$22 + -1ll;
								goto label$19;
								label$22:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$24;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$17;
									}
									label$24:;
									label$23:;
								}
								label$20:;
								I$8 = I$8 + 1ll;
								label$19:;
								if( I$8 <= TMP$23$8) goto label$22;
								label$21:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$18:;
						label$17:;
					}
					label$15:;
					label$14:;
				}
			}
			goto label$12;
			label$13:;
			{
				int64 vr$32 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$34 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$32 == vr$34) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$39 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$39 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$44 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$46 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$44 != vr$46) goto label$26;
					{
						label$27:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$34$8;
								int64 vr$48 = fb_StrLen( (void*)A$3, 50ll );
								TMP$34$8 = vr$48 + -1ll;
								goto label$30;
								label$33:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$35;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$28;
									}
									label$35:;
									label$34:;
								}
								label$31:;
								I$8 = I$8 + 1ll;
								label$30:;
								if( I$8 <= TMP$34$8) goto label$33;
								label$32:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$29:;
						label$28:;
					}
					label$26:;
					label$25:;
				}
			}
			label$12:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"a", 2ll, 0 );
			goto label$37;
			{
				int64 vr$59 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$61 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$59 == vr$61) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$66 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$66 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$71 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$73 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$71 != vr$73) goto label$39;
					{
						label$40:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$35$8;
								int64 vr$75 = fb_StrLen( (void*)A$3, 50ll );
								TMP$35$8 = vr$75 + -1ll;
								goto label$43;
								label$46:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$48;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$41;
									}
									label$48:;
									label$47:;
								}
								label$44:;
								I$8 = I$8 + 1ll;
								label$43:;
								if( I$8 <= TMP$35$8) goto label$46;
								label$45:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$42:;
						label$41:;
					}
					label$39:;
					label$38:;
				}
			}
			goto label$36;
			label$37:;
			{
				int64 vr$85 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$87 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$85 == vr$87) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$92 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$92 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$97 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$99 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$97 != vr$99) goto label$50;
					{
						label$51:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$36$8;
								int64 vr$101 = fb_StrLen( (void*)A$3, 50ll );
								TMP$36$8 = vr$101 + -1ll;
								goto label$54;
								label$57:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$59;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$52;
									}
									label$59:;
									label$58:;
								}
								label$55:;
								I$8 = I$8 + 1ll;
								label$54:;
								if( I$8 <= TMP$36$8) goto label$57;
								label$56:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$53:;
						label$52:;
					}
					label$50:;
					label$49:;
				}
			}
			label$36:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)T2$2, 50ll, 0 );
			goto label$61;
			{
				int64 vr$113 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$115 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$113 == vr$115) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$120 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$120 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$125 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$127 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$125 != vr$127) goto label$63;
					{
						label$64:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$37$8;
								int64 vr$129 = fb_StrLen( (void*)A$3, 50ll );
								TMP$37$8 = vr$129 + -1ll;
								goto label$67;
								label$70:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$72;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$65;
									}
									label$72:;
									label$71:;
								}
								label$68:;
								I$8 = I$8 + 1ll;
								label$67:;
								if( I$8 <= TMP$37$8) goto label$70;
								label$69:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$66:;
						label$65:;
					}
					label$63:;
					label$62:;
				}
			}
			goto label$60;
			label$61:;
			{
				int64 vr$139 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$141 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$139 == vr$141) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$146 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$146 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$151 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$153 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$151 != vr$153) goto label$74;
					{
						label$75:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$38$8;
								int64 vr$155 = fb_StrLen( (void*)A$3, 50ll );
								TMP$38$8 = vr$155 + -1ll;
								goto label$78;
								label$81:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$83;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$76;
									}
									label$83:;
									label$82:;
								}
								label$79:;
								I$8 = I$8 + 1ll;
								label$78:;
								if( I$8 <= TMP$38$8) goto label$81;
								label$80:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$77:;
						label$76:;
					}
					label$74:;
					label$73:;
				}
			}
			label$60:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)T2$2, 50ll, 0 );
			goto label$85;
			{
				int64 vr$167 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$169 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$167 == vr$169) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$174 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$174 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$179 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$181 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$179 != vr$181) goto label$87;
					{
						label$88:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$39$8;
								int64 vr$183 = fb_StrLen( (void*)A$3, 50ll );
								TMP$39$8 = vr$183 + -1ll;
								goto label$91;
								label$94:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$96;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$89;
									}
									label$96:;
									label$95:;
								}
								label$92:;
								I$8 = I$8 + 1ll;
								label$91:;
								if( I$8 <= TMP$39$8) goto label$94;
								label$93:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$90:;
						label$89:;
					}
					label$87:;
					label$86:;
				}
			}
			goto label$84;
			label$85:;
			{
				int64 vr$193 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$195 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$193 == vr$195) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$200 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$200 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$205 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$207 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$205 != vr$207) goto label$98;
					{
						label$99:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$40$8;
								int64 vr$209 = fb_StrLen( (void*)A$3, 50ll );
								TMP$40$8 = vr$209 + -1ll;
								goto label$102;
								label$105:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$107;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$100;
									}
									label$107:;
									label$106:;
								}
								label$103:;
								I$8 = I$8 + 1ll;
								label$102:;
								if( I$8 <= TMP$40$8) goto label$105;
								label$104:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$101:;
						label$100:;
					}
					label$98:;
					label$97:;
				}
			}
			label$84:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"a", 2ll, 0 );
			goto label$109;
			{
				int64 vr$220 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$222 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$220 == vr$222) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$227 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$227 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$232 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$234 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$232 != vr$234) goto label$111;
					{
						label$112:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$41$8;
								int64 vr$236 = fb_StrLen( (void*)A$3, 50ll );
								TMP$41$8 = vr$236 + -1ll;
								goto label$115;
								label$118:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$120;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$113;
									}
									label$120:;
									label$119:;
								}
								label$116:;
								I$8 = I$8 + 1ll;
								label$115:;
								if( I$8 <= TMP$41$8) goto label$118;
								label$117:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$114:;
						label$113:;
					}
					label$111:;
					label$110:;
				}
			}
			goto label$108;
			label$109:;
			{
				int64 vr$246 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$248 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$246 == vr$248) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$253 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$253 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$258 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$260 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$258 != vr$260) goto label$122;
					{
						label$123:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$42$8;
								int64 vr$262 = fb_StrLen( (void*)A$3, 50ll );
								TMP$42$8 = vr$262 + -1ll;
								goto label$126;
								label$129:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$131;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$124;
									}
									label$131:;
									label$130:;
								}
								label$127:;
								I$8 = I$8 + 1ll;
								label$126:;
								if( I$8 <= TMP$42$8) goto label$129;
								label$128:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$125:;
						label$124:;
					}
					label$122:;
					label$121:;
				}
			}
			label$108:;
		}
		{
			char A$3[50];
			char* vr$272 = _ZN14UZSTRING_FIXEDcvcEv( &U2$2 );
			fb_StrAssign( (void*)A$3, 50ll, (void*)vr$272, 0ll, 0 );
			goto label$133;
			{
				int64 vr$275 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$277 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$275 == vr$277) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$282 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$282 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$287 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$289 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$287 != vr$289) goto label$135;
					{
						label$136:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$43$8;
								int64 vr$291 = fb_StrLen( (void*)A$3, 50ll );
								TMP$43$8 = vr$291 + -1ll;
								goto label$139;
								label$142:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$144;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$137;
									}
									label$144:;
									label$143:;
								}
								label$140:;
								I$8 = I$8 + 1ll;
								label$139:;
								if( I$8 <= TMP$43$8) goto label$142;
								label$141:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$138:;
						label$137:;
					}
					label$135:;
					label$134:;
				}
			}
			goto label$132;
			label$133:;
			{
				int64 vr$301 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$303 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$301 == vr$303) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$308 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$308 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$313 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$315 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$313 != vr$315) goto label$146;
					{
						label$147:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$44$8;
								int64 vr$317 = fb_StrLen( (void*)A$3, 50ll );
								TMP$44$8 = vr$317 + -1ll;
								goto label$150;
								label$153:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$155;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$148;
									}
									label$155:;
									label$154:;
								}
								label$151:;
								I$8 = I$8 + 1ll;
								label$150:;
								if( I$8 <= TMP$44$8) goto label$153;
								label$152:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$149:;
						label$148:;
					}
					label$146:;
					label$145:;
				}
			}
			label$132:;
		}
		{
			char A$3[50];
			char* vr$327 = _ZN14UZSTRING_FIXEDcvcEv( &U2$2 );
			fb_StrAssign( (void*)A$3, 50ll, (void*)vr$327, 0ll, 0 );
			goto label$157;
			{
				int64 vr$330 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$332 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$330 == vr$332) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$337 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$337 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$342 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$344 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$342 != vr$344) goto label$159;
					{
						label$160:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$45$8;
								int64 vr$346 = fb_StrLen( (void*)A$3, 50ll );
								TMP$45$8 = vr$346 + -1ll;
								goto label$163;
								label$166:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$168;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$161;
									}
									label$168:;
									label$167:;
								}
								label$164:;
								I$8 = I$8 + 1ll;
								label$163:;
								if( I$8 <= TMP$45$8) goto label$166;
								label$165:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$162:;
						label$161:;
					}
					label$159:;
					label$158:;
				}
			}
			goto label$156;
			label$157:;
			{
				int64 vr$356 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$358 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$356 == vr$358) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$363 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$363 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$368 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$370 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$368 != vr$370) goto label$170;
					{
						label$171:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$46$8;
								int64 vr$372 = fb_StrLen( (void*)A$3, 50ll );
								TMP$46$8 = vr$372 + -1ll;
								goto label$174;
								label$177:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$179;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$172;
									}
									label$179:;
									label$178:;
								}
								label$175:;
								I$8 = I$8 + 1ll;
								label$174:;
								if( I$8 <= TMP$46$8) goto label$177;
								label$176:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 179, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$173:;
						label$172:;
					}
					label$170:;
					label$169:;
				}
			}
			label$156:;
		}
	}
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"", 1ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"a", 2ll, 0 );
		struct $14UZSTRING_FIXED U1$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U1$2, (char*)"" );
		struct $14UZSTRING_FIXED U2$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U2$2, (char*)"a" );
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"", 1ll, 0 );
			{
				int64 vr$387 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$389 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$387 == vr$389) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$394 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$394 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$399 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$401 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$399 != vr$401) goto label$183;
					{
						label$184:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$47$8;
								int64 vr$403 = fb_StrLen( (void*)A$3, 50ll );
								TMP$47$8 = vr$403 + -1ll;
								goto label$187;
								label$190:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$192;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$185;
									}
									label$192:;
									label$191:;
								}
								label$188:;
								I$8 = I$8 + 1ll;
								label$187:;
								if( I$8 <= TMP$47$8) goto label$190;
								label$189:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$186:;
						label$185:;
					}
					label$183:;
					label$182:;
				}
			}
			goto label$180;
			label$181:;
			{
				int64 vr$413 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$415 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$413 == vr$415) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$420 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$420 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$425 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$427 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$425 != vr$427) goto label$194;
					{
						label$195:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$48$8;
								int64 vr$429 = fb_StrLen( (void*)A$3, 50ll );
								TMP$48$8 = vr$429 + -1ll;
								goto label$198;
								label$201:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$203;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$196;
									}
									label$203:;
									label$202:;
								}
								label$199:;
								I$8 = I$8 + 1ll;
								label$198:;
								if( I$8 <= TMP$48$8) goto label$201;
								label$200:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$197:;
						label$196:;
					}
					label$194:;
					label$193:;
				}
			}
			label$180:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)T1$2, 50ll, 0 );
			{
				int64 vr$441 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$443 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$441 == vr$443) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$448 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$448 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$453 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$455 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$453 != vr$455) goto label$207;
					{
						label$208:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$49$8;
								int64 vr$457 = fb_StrLen( (void*)A$3, 50ll );
								TMP$49$8 = vr$457 + -1ll;
								goto label$211;
								label$214:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$216;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$209;
									}
									label$216:;
									label$215:;
								}
								label$212:;
								I$8 = I$8 + 1ll;
								label$211:;
								if( I$8 <= TMP$49$8) goto label$214;
								label$213:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$210:;
						label$209:;
					}
					label$207:;
					label$206:;
				}
			}
			goto label$204;
			label$205:;
			{
				int64 vr$467 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$469 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$467 == vr$469) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$474 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$474 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$479 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$481 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$479 != vr$481) goto label$218;
					{
						label$219:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$50$8;
								int64 vr$483 = fb_StrLen( (void*)A$3, 50ll );
								TMP$50$8 = vr$483 + -1ll;
								goto label$222;
								label$225:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$227;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$220;
									}
									label$227:;
									label$226:;
								}
								label$223:;
								I$8 = I$8 + 1ll;
								label$222:;
								if( I$8 <= TMP$50$8) goto label$225;
								label$224:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$221:;
						label$220:;
					}
					label$218:;
					label$217:;
				}
			}
			label$204:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"", 1ll, 0 );
			{
				int64 vr$494 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$496 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$494 == vr$496) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$501 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$501 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$506 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$508 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$506 != vr$508) goto label$231;
					{
						label$232:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$51$8;
								int64 vr$510 = fb_StrLen( (void*)A$3, 50ll );
								TMP$51$8 = vr$510 + -1ll;
								goto label$235;
								label$238:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$240;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$233;
									}
									label$240:;
									label$239:;
								}
								label$236:;
								I$8 = I$8 + 1ll;
								label$235:;
								if( I$8 <= TMP$51$8) goto label$238;
								label$237:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$234:;
						label$233:;
					}
					label$231:;
					label$230:;
				}
			}
			goto label$228;
			label$229:;
			{
				int64 vr$520 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$522 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$520 == vr$522) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$527 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$527 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$532 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$534 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$532 != vr$534) goto label$242;
					{
						label$243:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$52$8;
								int64 vr$536 = fb_StrLen( (void*)A$3, 50ll );
								TMP$52$8 = vr$536 + -1ll;
								goto label$246;
								label$249:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$251;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$244;
									}
									label$251:;
									label$250:;
								}
								label$247:;
								I$8 = I$8 + 1ll;
								label$246:;
								if( I$8 <= TMP$52$8) goto label$249;
								label$248:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$245:;
						label$244:;
					}
					label$242:;
					label$241:;
				}
			}
			label$228:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)T1$2, 50ll, 0 );
			{
				int64 vr$548 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$550 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$548 == vr$550) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$555 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$555 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$560 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$562 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$560 != vr$562) goto label$255;
					{
						label$256:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$53$8;
								int64 vr$564 = fb_StrLen( (void*)A$3, 50ll );
								TMP$53$8 = vr$564 + -1ll;
								goto label$259;
								label$262:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$264;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$257;
									}
									label$264:;
									label$263:;
								}
								label$260:;
								I$8 = I$8 + 1ll;
								label$259:;
								if( I$8 <= TMP$53$8) goto label$262;
								label$261:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$258:;
						label$257:;
					}
					label$255:;
					label$254:;
				}
			}
			goto label$252;
			label$253:;
			{
				int64 vr$574 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$576 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$574 == vr$576) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$581 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$581 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$586 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$588 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$586 != vr$588) goto label$266;
					{
						label$267:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$54$8;
								int64 vr$590 = fb_StrLen( (void*)A$3, 50ll );
								TMP$54$8 = vr$590 + -1ll;
								goto label$270;
								label$273:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$275;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$268;
									}
									label$275:;
									label$274:;
								}
								label$271:;
								I$8 = I$8 + 1ll;
								label$270:;
								if( I$8 <= TMP$54$8) goto label$273;
								label$272:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$269:;
						label$268:;
					}
					label$266:;
					label$265:;
				}
			}
			label$252:;
		}
		{
			char A$3[50];
			char* vr$600 = _ZN14UZSTRING_FIXEDcvcEv( &U1$2 );
			fb_StrAssign( (void*)A$3, 50ll, (void*)vr$600, 0ll, 0 );
			{
				int64 vr$603 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$605 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$603 == vr$605) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$610 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$610 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$615 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$617 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$615 != vr$617) goto label$279;
					{
						label$280:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$55$8;
								int64 vr$619 = fb_StrLen( (void*)A$3, 50ll );
								TMP$55$8 = vr$619 + -1ll;
								goto label$283;
								label$286:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$288;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$281;
									}
									label$288:;
									label$287:;
								}
								label$284:;
								I$8 = I$8 + 1ll;
								label$283:;
								if( I$8 <= TMP$55$8) goto label$286;
								label$285:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$282:;
						label$281:;
					}
					label$279:;
					label$278:;
				}
			}
			goto label$276;
			label$277:;
			{
				int64 vr$629 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$631 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$629 == vr$631) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$636 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$636 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$641 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$643 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$641 != vr$643) goto label$290;
					{
						label$291:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$56$8;
								int64 vr$645 = fb_StrLen( (void*)A$3, 50ll );
								TMP$56$8 = vr$645 + -1ll;
								goto label$294;
								label$297:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$299;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$292;
									}
									label$299:;
									label$298:;
								}
								label$295:;
								I$8 = I$8 + 1ll;
								label$294:;
								if( I$8 <= TMP$56$8) goto label$297;
								label$296:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$293:;
						label$292:;
					}
					label$290:;
					label$289:;
				}
			}
			label$276:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"", 1ll, 0 );
			{
				int64 vr$656 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$658 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$656 == vr$658) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$663 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$663 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$668 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$670 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$668 != vr$670) goto label$303;
					{
						label$304:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$57$8;
								int64 vr$672 = fb_StrLen( (void*)A$3, 50ll );
								TMP$57$8 = vr$672 + -1ll;
								goto label$307;
								label$310:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$312;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$305;
									}
									label$312:;
									label$311:;
								}
								label$308:;
								I$8 = I$8 + 1ll;
								label$307:;
								if( I$8 <= TMP$57$8) goto label$310;
								label$309:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$306:;
						label$305:;
					}
					label$303:;
					label$302:;
				}
			}
			goto label$300;
			label$301:;
			{
				int64 vr$682 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$684 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$682 == vr$684) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$689 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$689 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$694 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$696 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$694 != vr$696) goto label$314;
					{
						label$315:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$58$8;
								int64 vr$698 = fb_StrLen( (void*)A$3, 50ll );
								TMP$58$8 = vr$698 + -1ll;
								goto label$318;
								label$321:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$323;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$316;
									}
									label$323:;
									label$322:;
								}
								label$319:;
								I$8 = I$8 + 1ll;
								label$318:;
								if( I$8 <= TMP$58$8) goto label$321;
								label$320:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$317:;
						label$316:;
					}
					label$314:;
					label$313:;
				}
			}
			label$300:;
		}
		{
			char A$3[50];
			char* vr$708 = _ZN14UZSTRING_FIXEDcvcEv( &U1$2 );
			fb_StrAssign( (void*)A$3, 50ll, (void*)vr$708, 0ll, 0 );
			{
				int64 vr$711 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$713 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$711 == vr$713) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$718 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$718 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$723 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$725 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$723 != vr$725) goto label$327;
					{
						label$328:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$59$8;
								int64 vr$727 = fb_StrLen( (void*)A$3, 50ll );
								TMP$59$8 = vr$727 + -1ll;
								goto label$331;
								label$334:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$336;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$329;
									}
									label$336:;
									label$335:;
								}
								label$332:;
								I$8 = I$8 + 1ll;
								label$331:;
								if( I$8 <= TMP$59$8) goto label$334;
								label$333:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$330:;
						label$329:;
					}
					label$327:;
					label$326:;
				}
			}
			goto label$324;
			label$325:;
			{
				int64 vr$737 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$739 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$737 == vr$739) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$744 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$744 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$749 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$751 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$749 != vr$751) goto label$338;
					{
						label$339:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$60$8;
								int64 vr$753 = fb_StrLen( (void*)A$3, 50ll );
								TMP$60$8 = vr$753 + -1ll;
								goto label$342;
								label$345:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$347;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$340;
									}
									label$347:;
									label$346:;
								}
								label$343:;
								I$8 = I$8 + 1ll;
								label$342:;
								if( I$8 <= TMP$60$8) goto label$345;
								label$344:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 180, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$341:;
						label$340:;
					}
					label$338:;
					label$337:;
				}
			}
			label$324:;
		}
	}
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"a", 2ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"xyz", 4ll, 0 );
		struct $14UZSTRING_FIXED U1$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U1$2, (char*)"a" );
		struct $14UZSTRING_FIXED U2$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U2$2, (char*)"xyz" );
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"xyz", 4ll, 0 );
			goto label$349;
			{
				int64 vr$768 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$770 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$768 == vr$770) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$775 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$775 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$780 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$782 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$780 != vr$782) goto label$351;
					{
						label$352:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$62$8;
								int64 vr$784 = fb_StrLen( (void*)A$3, 50ll );
								TMP$62$8 = vr$784 + -1ll;
								goto label$355;
								label$358:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$360;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$353;
									}
									label$360:;
									label$359:;
								}
								label$356:;
								I$8 = I$8 + 1ll;
								label$355:;
								if( I$8 <= TMP$62$8) goto label$358;
								label$357:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$354:;
						label$353:;
					}
					label$351:;
					label$350:;
				}
			}
			goto label$348;
			label$349:;
			{
				int64 vr$794 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$796 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$794 == vr$796) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$801 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$801 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$806 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$808 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$806 != vr$808) goto label$362;
					{
						label$363:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$63$8;
								int64 vr$810 = fb_StrLen( (void*)A$3, 50ll );
								TMP$63$8 = vr$810 + -1ll;
								goto label$366;
								label$369:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$371;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$364;
									}
									label$371:;
									label$370:;
								}
								label$367:;
								I$8 = I$8 + 1ll;
								label$366:;
								if( I$8 <= TMP$63$8) goto label$369;
								label$368:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$365:;
						label$364:;
					}
					label$362:;
					label$361:;
				}
			}
			label$348:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"xyz", 4ll, 0 );
			goto label$373;
			{
				int64 vr$821 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$823 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$821 == vr$823) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$828 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$828 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$833 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$835 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$833 != vr$835) goto label$375;
					{
						label$376:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$64$8;
								int64 vr$837 = fb_StrLen( (void*)A$3, 50ll );
								TMP$64$8 = vr$837 + -1ll;
								goto label$379;
								label$382:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$384;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$377;
									}
									label$384:;
									label$383:;
								}
								label$380:;
								I$8 = I$8 + 1ll;
								label$379:;
								if( I$8 <= TMP$64$8) goto label$382;
								label$381:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$378:;
						label$377:;
					}
					label$375:;
					label$374:;
				}
			}
			goto label$372;
			label$373:;
			{
				int64 vr$847 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$849 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$847 == vr$849) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$854 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$854 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$859 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$861 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$859 != vr$861) goto label$386;
					{
						label$387:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$65$8;
								int64 vr$863 = fb_StrLen( (void*)A$3, 50ll );
								TMP$65$8 = vr$863 + -1ll;
								goto label$390;
								label$393:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$395;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$388;
									}
									label$395:;
									label$394:;
								}
								label$391:;
								I$8 = I$8 + 1ll;
								label$390:;
								if( I$8 <= TMP$65$8) goto label$393;
								label$392:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$389:;
						label$388:;
					}
					label$386:;
					label$385:;
				}
			}
			label$372:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)T2$2, 50ll, 0 );
			goto label$397;
			{
				int64 vr$875 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$877 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$875 == vr$877) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$882 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$882 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$887 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$889 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$887 != vr$889) goto label$399;
					{
						label$400:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$66$8;
								int64 vr$891 = fb_StrLen( (void*)A$3, 50ll );
								TMP$66$8 = vr$891 + -1ll;
								goto label$403;
								label$406:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$408;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$401;
									}
									label$408:;
									label$407:;
								}
								label$404:;
								I$8 = I$8 + 1ll;
								label$403:;
								if( I$8 <= TMP$66$8) goto label$406;
								label$405:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$402:;
						label$401:;
					}
					label$399:;
					label$398:;
				}
			}
			goto label$396;
			label$397:;
			{
				int64 vr$901 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$903 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$901 == vr$903) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$908 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$908 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$913 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$915 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$913 != vr$915) goto label$410;
					{
						label$411:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$67$8;
								int64 vr$917 = fb_StrLen( (void*)A$3, 50ll );
								TMP$67$8 = vr$917 + -1ll;
								goto label$414;
								label$417:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$419;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$412;
									}
									label$419:;
									label$418:;
								}
								label$415:;
								I$8 = I$8 + 1ll;
								label$414:;
								if( I$8 <= TMP$67$8) goto label$417;
								label$416:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$413:;
						label$412:;
					}
					label$410:;
					label$409:;
				}
			}
			label$396:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)T2$2, 50ll, 0 );
			goto label$421;
			{
				int64 vr$929 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$931 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$929 == vr$931) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$936 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$936 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$941 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$943 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$941 != vr$943) goto label$423;
					{
						label$424:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$68$8;
								int64 vr$945 = fb_StrLen( (void*)A$3, 50ll );
								TMP$68$8 = vr$945 + -1ll;
								goto label$427;
								label$430:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$432;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$425;
									}
									label$432:;
									label$431:;
								}
								label$428:;
								I$8 = I$8 + 1ll;
								label$427:;
								if( I$8 <= TMP$68$8) goto label$430;
								label$429:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$426:;
						label$425:;
					}
					label$423:;
					label$422:;
				}
			}
			goto label$420;
			label$421:;
			{
				int64 vr$955 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$957 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$955 == vr$957) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$962 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$962 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$967 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$969 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$967 != vr$969) goto label$434;
					{
						label$435:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$69$8;
								int64 vr$971 = fb_StrLen( (void*)A$3, 50ll );
								TMP$69$8 = vr$971 + -1ll;
								goto label$438;
								label$441:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$443;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$436;
									}
									label$443:;
									label$442:;
								}
								label$439:;
								I$8 = I$8 + 1ll;
								label$438:;
								if( I$8 <= TMP$69$8) goto label$441;
								label$440:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$437:;
						label$436:;
					}
					label$434:;
					label$433:;
				}
			}
			label$420:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"xyz", 4ll, 0 );
			goto label$445;
			{
				int64 vr$982 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$984 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$982 == vr$984) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$989 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$989 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$994 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$996 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$994 != vr$996) goto label$447;
					{
						label$448:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$70$8;
								int64 vr$998 = fb_StrLen( (void*)A$3, 50ll );
								TMP$70$8 = vr$998 + -1ll;
								goto label$451;
								label$454:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$456;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$449;
									}
									label$456:;
									label$455:;
								}
								label$452:;
								I$8 = I$8 + 1ll;
								label$451:;
								if( I$8 <= TMP$70$8) goto label$454;
								label$453:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$450:;
						label$449:;
					}
					label$447:;
					label$446:;
				}
			}
			goto label$444;
			label$445:;
			{
				int64 vr$1008 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1010 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1008 == vr$1010) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1015 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1015 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1020 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1022 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1020 != vr$1022) goto label$458;
					{
						label$459:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$71$8;
								int64 vr$1024 = fb_StrLen( (void*)A$3, 50ll );
								TMP$71$8 = vr$1024 + -1ll;
								goto label$462;
								label$465:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$467;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$460;
									}
									label$467:;
									label$466:;
								}
								label$463:;
								I$8 = I$8 + 1ll;
								label$462:;
								if( I$8 <= TMP$71$8) goto label$465;
								label$464:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$461:;
						label$460:;
					}
					label$458:;
					label$457:;
				}
			}
			label$444:;
		}
		{
			char A$3[50];
			char* vr$1034 = _ZN14UZSTRING_FIXEDcvcEv( &U2$2 );
			fb_StrAssign( (void*)A$3, 50ll, (void*)vr$1034, 0ll, 0 );
			goto label$469;
			{
				int64 vr$1037 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1039 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1037 == vr$1039) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$1044 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1044 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$1049 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1051 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1049 != vr$1051) goto label$471;
					{
						label$472:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$72$8;
								int64 vr$1053 = fb_StrLen( (void*)A$3, 50ll );
								TMP$72$8 = vr$1053 + -1ll;
								goto label$475;
								label$478:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$480;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$473;
									}
									label$480:;
									label$479:;
								}
								label$476:;
								I$8 = I$8 + 1ll;
								label$475:;
								if( I$8 <= TMP$72$8) goto label$478;
								label$477:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$474:;
						label$473:;
					}
					label$471:;
					label$470:;
				}
			}
			goto label$468;
			label$469:;
			{
				int64 vr$1063 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1065 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1063 == vr$1065) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1070 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1070 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1075 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1077 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1075 != vr$1077) goto label$482;
					{
						label$483:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$73$8;
								int64 vr$1079 = fb_StrLen( (void*)A$3, 50ll );
								TMP$73$8 = vr$1079 + -1ll;
								goto label$486;
								label$489:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$491;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$484;
									}
									label$491:;
									label$490:;
								}
								label$487:;
								I$8 = I$8 + 1ll;
								label$486:;
								if( I$8 <= TMP$73$8) goto label$489;
								label$488:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$485:;
						label$484:;
					}
					label$482:;
					label$481:;
				}
			}
			label$468:;
		}
		{
			char A$3[50];
			char* vr$1089 = _ZN14UZSTRING_FIXEDcvcEv( &U2$2 );
			fb_StrAssign( (void*)A$3, 50ll, (void*)vr$1089, 0ll, 0 );
			goto label$493;
			{
				int64 vr$1092 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1094 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1092 == vr$1094) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$1099 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1099 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$1104 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1106 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1104 != vr$1106) goto label$495;
					{
						label$496:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$74$8;
								int64 vr$1108 = fb_StrLen( (void*)A$3, 50ll );
								TMP$74$8 = vr$1108 + -1ll;
								goto label$499;
								label$502:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$504;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$497;
									}
									label$504:;
									label$503:;
								}
								label$500:;
								I$8 = I$8 + 1ll;
								label$499:;
								if( I$8 <= TMP$74$8) goto label$502;
								label$501:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$498:;
						label$497:;
					}
					label$495:;
					label$494:;
				}
			}
			goto label$492;
			label$493:;
			{
				int64 vr$1118 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1120 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1118 == vr$1120) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1125 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1125 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1130 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1132 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1130 != vr$1132) goto label$506;
					{
						label$507:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$75$8;
								int64 vr$1134 = fb_StrLen( (void*)A$3, 50ll );
								TMP$75$8 = vr$1134 + -1ll;
								goto label$510;
								label$513:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$515;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$508;
									}
									label$515:;
									label$514:;
								}
								label$511:;
								I$8 = I$8 + 1ll;
								label$510:;
								if( I$8 <= TMP$75$8) goto label$513;
								label$512:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 182, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$509:;
						label$508:;
					}
					label$506:;
					label$505:;
				}
			}
			label$492:;
		}
	}
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"a", 2ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"xyz", 4ll, 0 );
		struct $14UZSTRING_FIXED U1$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U1$2, (char*)"a" );
		struct $14UZSTRING_FIXED U2$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U2$2, (char*)"xyz" );
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"a", 2ll, 0 );
			{
				int64 vr$1149 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1151 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1149 == vr$1151) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$1156 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1156 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$1161 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1163 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1161 != vr$1163) goto label$519;
					{
						label$520:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$76$8;
								int64 vr$1165 = fb_StrLen( (void*)A$3, 50ll );
								TMP$76$8 = vr$1165 + -1ll;
								goto label$523;
								label$526:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$528;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$521;
									}
									label$528:;
									label$527:;
								}
								label$524:;
								I$8 = I$8 + 1ll;
								label$523:;
								if( I$8 <= TMP$76$8) goto label$526;
								label$525:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$522:;
						label$521:;
					}
					label$519:;
					label$518:;
				}
			}
			goto label$516;
			label$517:;
			{
				int64 vr$1175 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1177 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1175 == vr$1177) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1182 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1182 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1187 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1189 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1187 != vr$1189) goto label$530;
					{
						label$531:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$77$8;
								int64 vr$1191 = fb_StrLen( (void*)A$3, 50ll );
								TMP$77$8 = vr$1191 + -1ll;
								goto label$534;
								label$537:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$539;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$532;
									}
									label$539:;
									label$538:;
								}
								label$535:;
								I$8 = I$8 + 1ll;
								label$534:;
								if( I$8 <= TMP$77$8) goto label$537;
								label$536:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$533:;
						label$532:;
					}
					label$530:;
					label$529:;
				}
			}
			label$516:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)T1$2, 50ll, 0 );
			{
				int64 vr$1203 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1205 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1203 == vr$1205) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$1210 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1210 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$1215 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1217 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1215 != vr$1217) goto label$543;
					{
						label$544:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$78$8;
								int64 vr$1219 = fb_StrLen( (void*)A$3, 50ll );
								TMP$78$8 = vr$1219 + -1ll;
								goto label$547;
								label$550:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$552;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$545;
									}
									label$552:;
									label$551:;
								}
								label$548:;
								I$8 = I$8 + 1ll;
								label$547:;
								if( I$8 <= TMP$78$8) goto label$550;
								label$549:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$546:;
						label$545:;
					}
					label$543:;
					label$542:;
				}
			}
			goto label$540;
			label$541:;
			{
				int64 vr$1229 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1231 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1229 == vr$1231) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1236 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1236 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1241 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1243 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1241 != vr$1243) goto label$554;
					{
						label$555:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$79$8;
								int64 vr$1245 = fb_StrLen( (void*)A$3, 50ll );
								TMP$79$8 = vr$1245 + -1ll;
								goto label$558;
								label$561:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$563;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$556;
									}
									label$563:;
									label$562:;
								}
								label$559:;
								I$8 = I$8 + 1ll;
								label$558:;
								if( I$8 <= TMP$79$8) goto label$561;
								label$560:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$557:;
						label$556:;
					}
					label$554:;
					label$553:;
				}
			}
			label$540:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"a", 2ll, 0 );
			{
				int64 vr$1256 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1258 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1256 == vr$1258) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$1263 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1263 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$1268 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1270 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1268 != vr$1270) goto label$567;
					{
						label$568:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$80$8;
								int64 vr$1272 = fb_StrLen( (void*)A$3, 50ll );
								TMP$80$8 = vr$1272 + -1ll;
								goto label$571;
								label$574:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$576;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$569;
									}
									label$576:;
									label$575:;
								}
								label$572:;
								I$8 = I$8 + 1ll;
								label$571:;
								if( I$8 <= TMP$80$8) goto label$574;
								label$573:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$570:;
						label$569:;
					}
					label$567:;
					label$566:;
				}
			}
			goto label$564;
			label$565:;
			{
				int64 vr$1282 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1284 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1282 == vr$1284) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1289 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1289 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1294 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1296 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1294 != vr$1296) goto label$578;
					{
						label$579:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$81$8;
								int64 vr$1298 = fb_StrLen( (void*)A$3, 50ll );
								TMP$81$8 = vr$1298 + -1ll;
								goto label$582;
								label$585:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$587;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$580;
									}
									label$587:;
									label$586:;
								}
								label$583:;
								I$8 = I$8 + 1ll;
								label$582:;
								if( I$8 <= TMP$81$8) goto label$585;
								label$584:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$581:;
						label$580:;
					}
					label$578:;
					label$577:;
				}
			}
			label$564:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)T1$2, 50ll, 0 );
			{
				int64 vr$1310 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1312 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1310 == vr$1312) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$1317 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1317 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$1322 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1324 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1322 != vr$1324) goto label$591;
					{
						label$592:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$82$8;
								int64 vr$1326 = fb_StrLen( (void*)A$3, 50ll );
								TMP$82$8 = vr$1326 + -1ll;
								goto label$595;
								label$598:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$600;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$593;
									}
									label$600:;
									label$599:;
								}
								label$596:;
								I$8 = I$8 + 1ll;
								label$595:;
								if( I$8 <= TMP$82$8) goto label$598;
								label$597:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$594:;
						label$593:;
					}
					label$591:;
					label$590:;
				}
			}
			goto label$588;
			label$589:;
			{
				int64 vr$1336 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1338 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1336 == vr$1338) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1343 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1343 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1348 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1350 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1348 != vr$1350) goto label$602;
					{
						label$603:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$83$8;
								int64 vr$1352 = fb_StrLen( (void*)A$3, 50ll );
								TMP$83$8 = vr$1352 + -1ll;
								goto label$606;
								label$609:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$611;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$604;
									}
									label$611:;
									label$610:;
								}
								label$607:;
								I$8 = I$8 + 1ll;
								label$606:;
								if( I$8 <= TMP$83$8) goto label$609;
								label$608:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$605:;
						label$604:;
					}
					label$602:;
					label$601:;
				}
			}
			label$588:;
		}
		{
			char A$3[50];
			char* vr$1362 = _ZN14UZSTRING_FIXEDcvcEv( &U1$2 );
			fb_StrAssign( (void*)A$3, 50ll, (void*)vr$1362, 0ll, 0 );
			{
				int64 vr$1365 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1367 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1365 == vr$1367) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$1372 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1372 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$1377 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1379 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1377 != vr$1379) goto label$615;
					{
						label$616:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$84$8;
								int64 vr$1381 = fb_StrLen( (void*)A$3, 50ll );
								TMP$84$8 = vr$1381 + -1ll;
								goto label$619;
								label$622:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$624;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$617;
									}
									label$624:;
									label$623:;
								}
								label$620:;
								I$8 = I$8 + 1ll;
								label$619:;
								if( I$8 <= TMP$84$8) goto label$622;
								label$621:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$618:;
						label$617:;
					}
					label$615:;
					label$614:;
				}
			}
			goto label$612;
			label$613:;
			{
				int64 vr$1391 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1393 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1391 == vr$1393) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1398 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1398 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1403 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1405 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1403 != vr$1405) goto label$626;
					{
						label$627:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$85$8;
								int64 vr$1407 = fb_StrLen( (void*)A$3, 50ll );
								TMP$85$8 = vr$1407 + -1ll;
								goto label$630;
								label$633:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$635;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$628;
									}
									label$635:;
									label$634:;
								}
								label$631:;
								I$8 = I$8 + 1ll;
								label$630:;
								if( I$8 <= TMP$85$8) goto label$633;
								label$632:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$629:;
						label$628:;
					}
					label$626:;
					label$625:;
				}
			}
			label$612:;
		}
		{
			char A$3[50];
			fb_StrAssign( (void*)A$3, 50ll, (void*)"a", 2ll, 0 );
			{
				int64 vr$1418 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1420 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1418 == vr$1420) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$1425 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1425 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$1430 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1432 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1430 != vr$1432) goto label$639;
					{
						label$640:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$86$8;
								int64 vr$1434 = fb_StrLen( (void*)A$3, 50ll );
								TMP$86$8 = vr$1434 + -1ll;
								goto label$643;
								label$646:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$648;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$641;
									}
									label$648:;
									label$647:;
								}
								label$644:;
								I$8 = I$8 + 1ll;
								label$643:;
								if( I$8 <= TMP$86$8) goto label$646;
								label$645:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$642:;
						label$641:;
					}
					label$639:;
					label$638:;
				}
			}
			goto label$636;
			label$637:;
			{
				int64 vr$1444 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1446 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1444 == vr$1446) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1451 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1451 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1456 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1458 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1456 != vr$1458) goto label$650;
					{
						label$651:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$87$8;
								int64 vr$1460 = fb_StrLen( (void*)A$3, 50ll );
								TMP$87$8 = vr$1460 + -1ll;
								goto label$654;
								label$657:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$659;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$652;
									}
									label$659:;
									label$658:;
								}
								label$655:;
								I$8 = I$8 + 1ll;
								label$654:;
								if( I$8 <= TMP$87$8) goto label$657;
								label$656:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$653:;
						label$652:;
					}
					label$650:;
					label$649:;
				}
			}
			label$636:;
		}
		{
			char A$3[50];
			char* vr$1470 = _ZN14UZSTRING_FIXEDcvcEv( &U1$2 );
			fb_StrAssign( (void*)A$3, 50ll, (void*)vr$1470, 0ll, 0 );
			{
				int64 vr$1473 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1475 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1473 == vr$1475) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t1))" );
				int32 vr$1480 = fb_StrCompare( (void*)A$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1480 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t1)" );
				{
					int64 vr$1485 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1487 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1485 != vr$1487) goto label$663;
					{
						label$664:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$88$8;
								int64 vr$1489 = fb_StrLen( (void*)A$3, 50ll );
								TMP$88$8 = vr$1489 + -1ll;
								goto label$667;
								label$670:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$672;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$665;
									}
									label$672:;
									label$671:;
								}
								label$668:;
								I$8 = I$8 + 1ll;
								label$667:;
								if( I$8 <= TMP$88$8) goto label$670;
								label$669:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$666:;
						label$665:;
					}
					label$663:;
					label$662:;
				}
			}
			goto label$660;
			label$661:;
			{
				int64 vr$1499 = fb_StrLen( (void*)A$3, 50ll );
				int64 vr$1501 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1499 == vr$1501) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT(len(a) = len(t2))" );
				int32 vr$1506 = fb_StrCompare( (void*)A$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1506 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_ASSERT_EQUAL(a,t2)" );
				{
					int64 vr$1511 = fb_StrLen( (void*)A$3, 50ll );
					int64 vr$1513 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1511 != vr$1513) goto label$674;
					{
						label$675:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$89$8;
								int64 vr$1515 = fb_StrLen( (void*)A$3, 50ll );
								TMP$89$8 = vr$1515 + -1ll;
								goto label$678;
								label$681:;
								{
									if( (int64)*(uint8*)((uint8*)A$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$683;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_FAIL()" );
										goto label$676;
									}
									label$683:;
									label$682:;
								}
								label$679:;
								I$8 = I$8 + 1ll;
								label$678:;
								if( I$8 <= TMP$89$8) goto label$681;
								label$680:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 183, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.ZSTRING_IIF", (char*)"CU_PASS()" );
						}
						label$677:;
						label$676:;
					}
					label$674:;
					label$673:;
				}
			}
			label$660:;
		}
	}
	label$11:;
}

void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_11USTRING_IIFEv( void )
{
	label$686:;
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"", 1ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"a", 2ll, 0 );
		struct $14UZSTRING_FIXED U1$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U1$2, (char*)"" );
		struct $14UZSTRING_FIXED U2$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U2$2, (char*)"a" );
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"a" );
			char R$3[50];
			char* vr$6 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$6, 0ll, 0 );
			goto label$689;
			{
				int64 vr$9 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$11 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$9 == vr$11) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$16 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$16 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$21 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$23 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$21 != vr$23) goto label$691;
					{
						label$692:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$101$8;
								int64 vr$25 = fb_StrLen( (void*)R$3, 50ll );
								TMP$101$8 = vr$25 + -1ll;
								goto label$695;
								label$698:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$700;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$693;
									}
									label$700:;
									label$699:;
								}
								label$696:;
								I$8 = I$8 + 1ll;
								label$695:;
								if( I$8 <= TMP$101$8) goto label$698;
								label$697:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$694:;
						label$693:;
					}
					label$691:;
					label$690:;
				}
			}
			goto label$688;
			label$689:;
			{
				int64 vr$35 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$37 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$35 == vr$37) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$42 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$42 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$47 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$49 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$47 != vr$49) goto label$702;
					{
						label$703:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$107$8;
								int64 vr$51 = fb_StrLen( (void*)R$3, 50ll );
								TMP$107$8 = vr$51 + -1ll;
								goto label$706;
								label$709:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$711;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$704;
									}
									label$711:;
									label$710:;
								}
								label$707:;
								I$8 = I$8 + 1ll;
								label$706:;
								if( I$8 <= TMP$107$8) goto label$709;
								label$708:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$705:;
						label$704:;
					}
					label$702:;
					label$701:;
				}
			}
			label$688:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"a" );
			char R$3[50];
			char* vr$62 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$62, 0ll, 0 );
			goto label$713;
			{
				int64 vr$65 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$67 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$65 == vr$67) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$72 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$72 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$77 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$79 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$77 != vr$79) goto label$715;
					{
						label$716:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$108$8;
								int64 vr$81 = fb_StrLen( (void*)R$3, 50ll );
								TMP$108$8 = vr$81 + -1ll;
								goto label$719;
								label$722:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$724;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$717;
									}
									label$724:;
									label$723:;
								}
								label$720:;
								I$8 = I$8 + 1ll;
								label$719:;
								if( I$8 <= TMP$108$8) goto label$722;
								label$721:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$718:;
						label$717:;
					}
					label$715:;
					label$714:;
				}
			}
			goto label$712;
			label$713:;
			{
				int64 vr$91 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$93 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$91 == vr$93) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$98 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$98 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$103 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$105 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$103 != vr$105) goto label$726;
					{
						label$727:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$109$8;
								int64 vr$107 = fb_StrLen( (void*)R$3, 50ll );
								TMP$109$8 = vr$107 + -1ll;
								goto label$730;
								label$733:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$735;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$728;
									}
									label$735:;
									label$734:;
								}
								label$731:;
								I$8 = I$8 + 1ll;
								label$730:;
								if( I$8 <= TMP$109$8) goto label$733;
								label$732:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$729:;
						label$728:;
					}
					label$726:;
					label$725:;
				}
			}
			label$712:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)T2$2 );
			char R$3[50];
			char* vr$119 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$119, 0ll, 0 );
			goto label$737;
			{
				int64 vr$122 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$124 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$122 == vr$124) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$129 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$129 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$134 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$136 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$134 != vr$136) goto label$739;
					{
						label$740:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$110$8;
								int64 vr$138 = fb_StrLen( (void*)R$3, 50ll );
								TMP$110$8 = vr$138 + -1ll;
								goto label$743;
								label$746:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$748;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$741;
									}
									label$748:;
									label$747:;
								}
								label$744:;
								I$8 = I$8 + 1ll;
								label$743:;
								if( I$8 <= TMP$110$8) goto label$746;
								label$745:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$742:;
						label$741:;
					}
					label$739:;
					label$738:;
				}
			}
			goto label$736;
			label$737:;
			{
				int64 vr$148 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$150 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$148 == vr$150) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$155 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$155 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$160 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$162 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$160 != vr$162) goto label$750;
					{
						label$751:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$111$8;
								int64 vr$164 = fb_StrLen( (void*)R$3, 50ll );
								TMP$111$8 = vr$164 + -1ll;
								goto label$754;
								label$757:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$759;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$752;
									}
									label$759:;
									label$758:;
								}
								label$755:;
								I$8 = I$8 + 1ll;
								label$754:;
								if( I$8 <= TMP$111$8) goto label$757;
								label$756:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$753:;
						label$752:;
					}
					label$750:;
					label$749:;
				}
			}
			label$736:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)T2$2 );
			char R$3[50];
			char* vr$176 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$176, 0ll, 0 );
			goto label$761;
			{
				int64 vr$179 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$181 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$179 == vr$181) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$186 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$186 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$191 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$193 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$191 != vr$193) goto label$763;
					{
						label$764:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$112$8;
								int64 vr$195 = fb_StrLen( (void*)R$3, 50ll );
								TMP$112$8 = vr$195 + -1ll;
								goto label$767;
								label$770:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$772;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$765;
									}
									label$772:;
									label$771:;
								}
								label$768:;
								I$8 = I$8 + 1ll;
								label$767:;
								if( I$8 <= TMP$112$8) goto label$770;
								label$769:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$766:;
						label$765:;
					}
					label$763:;
					label$762:;
				}
			}
			goto label$760;
			label$761:;
			{
				int64 vr$205 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$207 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$205 == vr$207) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$212 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$212 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$217 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$219 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$217 != vr$219) goto label$774;
					{
						label$775:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$113$8;
								int64 vr$221 = fb_StrLen( (void*)R$3, 50ll );
								TMP$113$8 = vr$221 + -1ll;
								goto label$778;
								label$781:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$783;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$776;
									}
									label$783:;
									label$782:;
								}
								label$779:;
								I$8 = I$8 + 1ll;
								label$778:;
								if( I$8 <= TMP$113$8) goto label$781;
								label$780:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$777:;
						label$776:;
					}
					label$774:;
					label$773:;
				}
			}
			label$760:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"a" );
			char R$3[50];
			char* vr$232 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$232, 0ll, 0 );
			goto label$785;
			{
				int64 vr$235 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$237 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$235 == vr$237) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$242 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$242 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$247 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$249 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$247 != vr$249) goto label$787;
					{
						label$788:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$114$8;
								int64 vr$251 = fb_StrLen( (void*)R$3, 50ll );
								TMP$114$8 = vr$251 + -1ll;
								goto label$791;
								label$794:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$796;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$789;
									}
									label$796:;
									label$795:;
								}
								label$792:;
								I$8 = I$8 + 1ll;
								label$791:;
								if( I$8 <= TMP$114$8) goto label$794;
								label$793:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$790:;
						label$789:;
					}
					label$787:;
					label$786:;
				}
			}
			goto label$784;
			label$785:;
			{
				int64 vr$261 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$263 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$261 == vr$263) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$268 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$268 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$273 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$275 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$273 != vr$275) goto label$798;
					{
						label$799:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$115$8;
								int64 vr$277 = fb_StrLen( (void*)R$3, 50ll );
								TMP$115$8 = vr$277 + -1ll;
								goto label$802;
								label$805:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$807;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$800;
									}
									label$807:;
									label$806:;
								}
								label$803:;
								I$8 = I$8 + 1ll;
								label$802:;
								if( I$8 <= TMP$115$8) goto label$805;
								label$804:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$801:;
						label$800:;
					}
					label$798:;
					label$797:;
				}
			}
			label$784:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1ERKS_( &A$3, (struct $14UZSTRING_FIXED*)&U2$2 );
			char R$3[50];
			char* vr$289 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$289, 0ll, 0 );
			goto label$809;
			{
				int64 vr$292 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$294 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$292 == vr$294) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$299 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$299 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$304 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$306 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$304 != vr$306) goto label$811;
					{
						label$812:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$116$8;
								int64 vr$308 = fb_StrLen( (void*)R$3, 50ll );
								TMP$116$8 = vr$308 + -1ll;
								goto label$815;
								label$818:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$820;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$813;
									}
									label$820:;
									label$819:;
								}
								label$816:;
								I$8 = I$8 + 1ll;
								label$815:;
								if( I$8 <= TMP$116$8) goto label$818;
								label$817:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$814:;
						label$813:;
					}
					label$811:;
					label$810:;
				}
			}
			goto label$808;
			label$809:;
			{
				int64 vr$318 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$320 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$318 == vr$320) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$325 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$325 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$330 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$332 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$330 != vr$332) goto label$822;
					{
						label$823:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$117$8;
								int64 vr$334 = fb_StrLen( (void*)R$3, 50ll );
								TMP$117$8 = vr$334 + -1ll;
								goto label$826;
								label$829:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$831;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$824;
									}
									label$831:;
									label$830:;
								}
								label$827:;
								I$8 = I$8 + 1ll;
								label$826:;
								if( I$8 <= TMP$117$8) goto label$829;
								label$828:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$825:;
						label$824:;
					}
					label$822:;
					label$821:;
				}
			}
			label$808:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1ERKS_( &A$3, (struct $14UZSTRING_FIXED*)&U2$2 );
			char R$3[50];
			char* vr$346 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$346, 0ll, 0 );
			goto label$833;
			{
				int64 vr$349 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$351 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$349 == vr$351) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$356 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$356 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$361 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$363 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$361 != vr$363) goto label$835;
					{
						label$836:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$118$8;
								int64 vr$365 = fb_StrLen( (void*)R$3, 50ll );
								TMP$118$8 = vr$365 + -1ll;
								goto label$839;
								label$842:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$844;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$837;
									}
									label$844:;
									label$843:;
								}
								label$840:;
								I$8 = I$8 + 1ll;
								label$839:;
								if( I$8 <= TMP$118$8) goto label$842;
								label$841:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$838:;
						label$837:;
					}
					label$835:;
					label$834:;
				}
			}
			goto label$832;
			label$833:;
			{
				int64 vr$375 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$377 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$375 == vr$377) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$382 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$382 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$387 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$389 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$387 != vr$389) goto label$846;
					{
						label$847:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$119$8;
								int64 vr$391 = fb_StrLen( (void*)R$3, 50ll );
								TMP$119$8 = vr$391 + -1ll;
								goto label$850;
								label$853:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$855;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$848;
									}
									label$855:;
									label$854:;
								}
								label$851:;
								I$8 = I$8 + 1ll;
								label$850:;
								if( I$8 <= TMP$119$8) goto label$853;
								label$852:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 189, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$849:;
						label$848:;
					}
					label$846:;
					label$845:;
				}
			}
			label$832:;
		}
	}
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"", 1ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"a", 2ll, 0 );
		struct $14UZSTRING_FIXED U1$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U1$2, (char*)"" );
		struct $14UZSTRING_FIXED U2$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U2$2, (char*)"a" );
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"" );
			char R$3[50];
			char* vr$406 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$406, 0ll, 0 );
			{
				int64 vr$409 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$411 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$409 == vr$411) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$416 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$416 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$421 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$423 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$421 != vr$423) goto label$859;
					{
						label$860:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$120$8;
								int64 vr$425 = fb_StrLen( (void*)R$3, 50ll );
								TMP$120$8 = vr$425 + -1ll;
								goto label$863;
								label$866:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$868;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$861;
									}
									label$868:;
									label$867:;
								}
								label$864:;
								I$8 = I$8 + 1ll;
								label$863:;
								if( I$8 <= TMP$120$8) goto label$866;
								label$865:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$862:;
						label$861:;
					}
					label$859:;
					label$858:;
				}
			}
			goto label$856;
			label$857:;
			{
				int64 vr$435 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$437 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$435 == vr$437) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$442 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$442 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$447 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$449 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$447 != vr$449) goto label$870;
					{
						label$871:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$121$8;
								int64 vr$451 = fb_StrLen( (void*)R$3, 50ll );
								TMP$121$8 = vr$451 + -1ll;
								goto label$874;
								label$877:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$879;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$872;
									}
									label$879:;
									label$878:;
								}
								label$875:;
								I$8 = I$8 + 1ll;
								label$874:;
								if( I$8 <= TMP$121$8) goto label$877;
								label$876:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$873:;
						label$872:;
					}
					label$870:;
					label$869:;
				}
			}
			label$856:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)T1$2 );
			char R$3[50];
			char* vr$463 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$463, 0ll, 0 );
			{
				int64 vr$466 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$468 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$466 == vr$468) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$473 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$473 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$478 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$480 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$478 != vr$480) goto label$883;
					{
						label$884:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$122$8;
								int64 vr$482 = fb_StrLen( (void*)R$3, 50ll );
								TMP$122$8 = vr$482 + -1ll;
								goto label$887;
								label$890:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$892;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$885;
									}
									label$892:;
									label$891:;
								}
								label$888:;
								I$8 = I$8 + 1ll;
								label$887:;
								if( I$8 <= TMP$122$8) goto label$890;
								label$889:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$886:;
						label$885:;
					}
					label$883:;
					label$882:;
				}
			}
			goto label$880;
			label$881:;
			{
				int64 vr$492 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$494 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$492 == vr$494) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$499 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$499 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$504 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$506 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$504 != vr$506) goto label$894;
					{
						label$895:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$123$8;
								int64 vr$508 = fb_StrLen( (void*)R$3, 50ll );
								TMP$123$8 = vr$508 + -1ll;
								goto label$898;
								label$901:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$903;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$896;
									}
									label$903:;
									label$902:;
								}
								label$899:;
								I$8 = I$8 + 1ll;
								label$898:;
								if( I$8 <= TMP$123$8) goto label$901;
								label$900:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$897:;
						label$896:;
					}
					label$894:;
					label$893:;
				}
			}
			label$880:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"" );
			char R$3[50];
			char* vr$519 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$519, 0ll, 0 );
			{
				int64 vr$522 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$524 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$522 == vr$524) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$529 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$529 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$534 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$536 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$534 != vr$536) goto label$907;
					{
						label$908:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$124$8;
								int64 vr$538 = fb_StrLen( (void*)R$3, 50ll );
								TMP$124$8 = vr$538 + -1ll;
								goto label$911;
								label$914:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$916;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$909;
									}
									label$916:;
									label$915:;
								}
								label$912:;
								I$8 = I$8 + 1ll;
								label$911:;
								if( I$8 <= TMP$124$8) goto label$914;
								label$913:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$910:;
						label$909:;
					}
					label$907:;
					label$906:;
				}
			}
			goto label$904;
			label$905:;
			{
				int64 vr$548 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$550 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$548 == vr$550) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$555 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$555 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$560 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$562 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$560 != vr$562) goto label$918;
					{
						label$919:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$125$8;
								int64 vr$564 = fb_StrLen( (void*)R$3, 50ll );
								TMP$125$8 = vr$564 + -1ll;
								goto label$922;
								label$925:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$927;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$920;
									}
									label$927:;
									label$926:;
								}
								label$923:;
								I$8 = I$8 + 1ll;
								label$922:;
								if( I$8 <= TMP$125$8) goto label$925;
								label$924:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$921:;
						label$920:;
					}
					label$918:;
					label$917:;
				}
			}
			label$904:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)T1$2 );
			char R$3[50];
			char* vr$576 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$576, 0ll, 0 );
			{
				int64 vr$579 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$581 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$579 == vr$581) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$586 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$586 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$591 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$593 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$591 != vr$593) goto label$931;
					{
						label$932:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$126$8;
								int64 vr$595 = fb_StrLen( (void*)R$3, 50ll );
								TMP$126$8 = vr$595 + -1ll;
								goto label$935;
								label$938:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$940;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$933;
									}
									label$940:;
									label$939:;
								}
								label$936:;
								I$8 = I$8 + 1ll;
								label$935:;
								if( I$8 <= TMP$126$8) goto label$938;
								label$937:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$934:;
						label$933:;
					}
					label$931:;
					label$930:;
				}
			}
			goto label$928;
			label$929:;
			{
				int64 vr$605 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$607 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$605 == vr$607) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$612 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$612 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$617 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$619 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$617 != vr$619) goto label$942;
					{
						label$943:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$127$8;
								int64 vr$621 = fb_StrLen( (void*)R$3, 50ll );
								TMP$127$8 = vr$621 + -1ll;
								goto label$946;
								label$949:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$951;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$944;
									}
									label$951:;
									label$950:;
								}
								label$947:;
								I$8 = I$8 + 1ll;
								label$946:;
								if( I$8 <= TMP$127$8) goto label$949;
								label$948:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$945:;
						label$944:;
					}
					label$942:;
					label$941:;
				}
			}
			label$928:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1ERKS_( &A$3, (struct $14UZSTRING_FIXED*)&U1$2 );
			char R$3[50];
			char* vr$633 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$633, 0ll, 0 );
			{
				int64 vr$636 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$638 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$636 == vr$638) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$643 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$643 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$648 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$650 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$648 != vr$650) goto label$955;
					{
						label$956:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$128$8;
								int64 vr$652 = fb_StrLen( (void*)R$3, 50ll );
								TMP$128$8 = vr$652 + -1ll;
								goto label$959;
								label$962:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$964;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$957;
									}
									label$964:;
									label$963:;
								}
								label$960:;
								I$8 = I$8 + 1ll;
								label$959:;
								if( I$8 <= TMP$128$8) goto label$962;
								label$961:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$958:;
						label$957:;
					}
					label$955:;
					label$954:;
				}
			}
			goto label$952;
			label$953:;
			{
				int64 vr$662 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$664 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$662 == vr$664) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$669 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$669 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$674 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$676 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$674 != vr$676) goto label$966;
					{
						label$967:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$129$8;
								int64 vr$678 = fb_StrLen( (void*)R$3, 50ll );
								TMP$129$8 = vr$678 + -1ll;
								goto label$970;
								label$973:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$975;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$968;
									}
									label$975:;
									label$974:;
								}
								label$971:;
								I$8 = I$8 + 1ll;
								label$970:;
								if( I$8 <= TMP$129$8) goto label$973;
								label$972:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$969:;
						label$968:;
					}
					label$966:;
					label$965:;
				}
			}
			label$952:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"" );
			char R$3[50];
			char* vr$689 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$689, 0ll, 0 );
			{
				int64 vr$692 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$694 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$692 == vr$694) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$699 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$699 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$704 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$706 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$704 != vr$706) goto label$979;
					{
						label$980:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$130$8;
								int64 vr$708 = fb_StrLen( (void*)R$3, 50ll );
								TMP$130$8 = vr$708 + -1ll;
								goto label$983;
								label$986:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$988;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$981;
									}
									label$988:;
									label$987:;
								}
								label$984:;
								I$8 = I$8 + 1ll;
								label$983:;
								if( I$8 <= TMP$130$8) goto label$986;
								label$985:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$982:;
						label$981:;
					}
					label$979:;
					label$978:;
				}
			}
			goto label$976;
			label$977:;
			{
				int64 vr$718 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$720 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$718 == vr$720) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$725 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$725 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$730 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$732 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$730 != vr$732) goto label$990;
					{
						label$991:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$131$8;
								int64 vr$734 = fb_StrLen( (void*)R$3, 50ll );
								TMP$131$8 = vr$734 + -1ll;
								goto label$994;
								label$997:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$999;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$992;
									}
									label$999:;
									label$998:;
								}
								label$995:;
								I$8 = I$8 + 1ll;
								label$994:;
								if( I$8 <= TMP$131$8) goto label$997;
								label$996:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$993:;
						label$992:;
					}
					label$990:;
					label$989:;
				}
			}
			label$976:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1ERKS_( &A$3, (struct $14UZSTRING_FIXED*)&U1$2 );
			char R$3[50];
			char* vr$746 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$746, 0ll, 0 );
			{
				int64 vr$749 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$751 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$749 == vr$751) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$756 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$756 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$761 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$763 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$761 != vr$763) goto label$1003;
					{
						label$1004:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$132$8;
								int64 vr$765 = fb_StrLen( (void*)R$3, 50ll );
								TMP$132$8 = vr$765 + -1ll;
								goto label$1007;
								label$1010:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1012;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1005;
									}
									label$1012:;
									label$1011:;
								}
								label$1008:;
								I$8 = I$8 + 1ll;
								label$1007:;
								if( I$8 <= TMP$132$8) goto label$1010;
								label$1009:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1006:;
						label$1005:;
					}
					label$1003:;
					label$1002:;
				}
			}
			goto label$1000;
			label$1001:;
			{
				int64 vr$775 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$777 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$775 == vr$777) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$782 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$782 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$787 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$789 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$787 != vr$789) goto label$1014;
					{
						label$1015:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$133$8;
								int64 vr$791 = fb_StrLen( (void*)R$3, 50ll );
								TMP$133$8 = vr$791 + -1ll;
								goto label$1018;
								label$1021:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1023;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1016;
									}
									label$1023:;
									label$1022:;
								}
								label$1019:;
								I$8 = I$8 + 1ll;
								label$1018:;
								if( I$8 <= TMP$133$8) goto label$1021;
								label$1020:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 190, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1017:;
						label$1016:;
					}
					label$1014:;
					label$1013:;
				}
			}
			label$1000:;
		}
	}
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"a", 2ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"xyz", 4ll, 0 );
		struct $14UZSTRING_FIXED U1$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U1$2, (char*)"a" );
		struct $14UZSTRING_FIXED U2$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U2$2, (char*)"xyz" );
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"xyz" );
			char R$3[50];
			char* vr$806 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$806, 0ll, 0 );
			goto label$1025;
			{
				int64 vr$809 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$811 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$809 == vr$811) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$816 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$816 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$821 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$823 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$821 != vr$823) goto label$1027;
					{
						label$1028:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$134$8;
								int64 vr$825 = fb_StrLen( (void*)R$3, 50ll );
								TMP$134$8 = vr$825 + -1ll;
								goto label$1031;
								label$1034:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1036;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1029;
									}
									label$1036:;
									label$1035:;
								}
								label$1032:;
								I$8 = I$8 + 1ll;
								label$1031:;
								if( I$8 <= TMP$134$8) goto label$1034;
								label$1033:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1030:;
						label$1029:;
					}
					label$1027:;
					label$1026:;
				}
			}
			goto label$1024;
			label$1025:;
			{
				int64 vr$835 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$837 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$835 == vr$837) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$842 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$842 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$847 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$849 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$847 != vr$849) goto label$1038;
					{
						label$1039:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$135$8;
								int64 vr$851 = fb_StrLen( (void*)R$3, 50ll );
								TMP$135$8 = vr$851 + -1ll;
								goto label$1042;
								label$1045:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1047;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1040;
									}
									label$1047:;
									label$1046:;
								}
								label$1043:;
								I$8 = I$8 + 1ll;
								label$1042:;
								if( I$8 <= TMP$135$8) goto label$1045;
								label$1044:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1041:;
						label$1040:;
					}
					label$1038:;
					label$1037:;
				}
			}
			label$1024:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"xyz" );
			char R$3[50];
			char* vr$862 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$862, 0ll, 0 );
			goto label$1049;
			{
				int64 vr$865 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$867 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$865 == vr$867) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$872 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$872 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$877 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$879 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$877 != vr$879) goto label$1051;
					{
						label$1052:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$136$8;
								int64 vr$881 = fb_StrLen( (void*)R$3, 50ll );
								TMP$136$8 = vr$881 + -1ll;
								goto label$1055;
								label$1058:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1060;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1053;
									}
									label$1060:;
									label$1059:;
								}
								label$1056:;
								I$8 = I$8 + 1ll;
								label$1055:;
								if( I$8 <= TMP$136$8) goto label$1058;
								label$1057:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1054:;
						label$1053:;
					}
					label$1051:;
					label$1050:;
				}
			}
			goto label$1048;
			label$1049:;
			{
				int64 vr$891 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$893 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$891 == vr$893) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$898 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$898 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$903 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$905 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$903 != vr$905) goto label$1062;
					{
						label$1063:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$137$8;
								int64 vr$907 = fb_StrLen( (void*)R$3, 50ll );
								TMP$137$8 = vr$907 + -1ll;
								goto label$1066;
								label$1069:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1071;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1064;
									}
									label$1071:;
									label$1070:;
								}
								label$1067:;
								I$8 = I$8 + 1ll;
								label$1066:;
								if( I$8 <= TMP$137$8) goto label$1069;
								label$1068:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1065:;
						label$1064:;
					}
					label$1062:;
					label$1061:;
				}
			}
			label$1048:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)T2$2 );
			char R$3[50];
			char* vr$919 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$919, 0ll, 0 );
			goto label$1073;
			{
				int64 vr$922 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$924 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$922 == vr$924) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$929 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$929 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$934 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$936 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$934 != vr$936) goto label$1075;
					{
						label$1076:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$138$8;
								int64 vr$938 = fb_StrLen( (void*)R$3, 50ll );
								TMP$138$8 = vr$938 + -1ll;
								goto label$1079;
								label$1082:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1084;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1077;
									}
									label$1084:;
									label$1083:;
								}
								label$1080:;
								I$8 = I$8 + 1ll;
								label$1079:;
								if( I$8 <= TMP$138$8) goto label$1082;
								label$1081:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1078:;
						label$1077:;
					}
					label$1075:;
					label$1074:;
				}
			}
			goto label$1072;
			label$1073:;
			{
				int64 vr$948 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$950 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$948 == vr$950) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$955 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$955 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$960 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$962 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$960 != vr$962) goto label$1086;
					{
						label$1087:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$139$8;
								int64 vr$964 = fb_StrLen( (void*)R$3, 50ll );
								TMP$139$8 = vr$964 + -1ll;
								goto label$1090;
								label$1093:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1095;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1088;
									}
									label$1095:;
									label$1094:;
								}
								label$1091:;
								I$8 = I$8 + 1ll;
								label$1090:;
								if( I$8 <= TMP$139$8) goto label$1093;
								label$1092:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1089:;
						label$1088:;
					}
					label$1086:;
					label$1085:;
				}
			}
			label$1072:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)T2$2 );
			char R$3[50];
			char* vr$976 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$976, 0ll, 0 );
			goto label$1097;
			{
				int64 vr$979 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$981 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$979 == vr$981) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$986 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$986 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$991 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$993 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$991 != vr$993) goto label$1099;
					{
						label$1100:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$140$8;
								int64 vr$995 = fb_StrLen( (void*)R$3, 50ll );
								TMP$140$8 = vr$995 + -1ll;
								goto label$1103;
								label$1106:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1108;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1101;
									}
									label$1108:;
									label$1107:;
								}
								label$1104:;
								I$8 = I$8 + 1ll;
								label$1103:;
								if( I$8 <= TMP$140$8) goto label$1106;
								label$1105:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1102:;
						label$1101:;
					}
					label$1099:;
					label$1098:;
				}
			}
			goto label$1096;
			label$1097:;
			{
				int64 vr$1005 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1007 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1005 == vr$1007) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1012 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1012 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1017 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1019 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1017 != vr$1019) goto label$1110;
					{
						label$1111:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$141$8;
								int64 vr$1021 = fb_StrLen( (void*)R$3, 50ll );
								TMP$141$8 = vr$1021 + -1ll;
								goto label$1114;
								label$1117:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1119;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1112;
									}
									label$1119:;
									label$1118:;
								}
								label$1115:;
								I$8 = I$8 + 1ll;
								label$1114:;
								if( I$8 <= TMP$141$8) goto label$1117;
								label$1116:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1113:;
						label$1112:;
					}
					label$1110:;
					label$1109:;
				}
			}
			label$1096:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"xyz" );
			char R$3[50];
			char* vr$1032 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1032, 0ll, 0 );
			goto label$1121;
			{
				int64 vr$1035 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1037 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1035 == vr$1037) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1042 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1042 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1047 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1049 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1047 != vr$1049) goto label$1123;
					{
						label$1124:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$142$8;
								int64 vr$1051 = fb_StrLen( (void*)R$3, 50ll );
								TMP$142$8 = vr$1051 + -1ll;
								goto label$1127;
								label$1130:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1132;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1125;
									}
									label$1132:;
									label$1131:;
								}
								label$1128:;
								I$8 = I$8 + 1ll;
								label$1127:;
								if( I$8 <= TMP$142$8) goto label$1130;
								label$1129:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1126:;
						label$1125:;
					}
					label$1123:;
					label$1122:;
				}
			}
			goto label$1120;
			label$1121:;
			{
				int64 vr$1061 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1063 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1061 == vr$1063) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1068 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1068 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1073 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1075 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1073 != vr$1075) goto label$1134;
					{
						label$1135:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$143$8;
								int64 vr$1077 = fb_StrLen( (void*)R$3, 50ll );
								TMP$143$8 = vr$1077 + -1ll;
								goto label$1138;
								label$1141:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1143;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1136;
									}
									label$1143:;
									label$1142:;
								}
								label$1139:;
								I$8 = I$8 + 1ll;
								label$1138:;
								if( I$8 <= TMP$143$8) goto label$1141;
								label$1140:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1137:;
						label$1136:;
					}
					label$1134:;
					label$1133:;
				}
			}
			label$1120:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1ERKS_( &A$3, (struct $14UZSTRING_FIXED*)&U2$2 );
			char R$3[50];
			char* vr$1089 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1089, 0ll, 0 );
			goto label$1145;
			{
				int64 vr$1092 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1094 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1092 == vr$1094) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1099 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1099 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1104 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1106 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1104 != vr$1106) goto label$1147;
					{
						label$1148:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$144$8;
								int64 vr$1108 = fb_StrLen( (void*)R$3, 50ll );
								TMP$144$8 = vr$1108 + -1ll;
								goto label$1151;
								label$1154:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1156;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1149;
									}
									label$1156:;
									label$1155:;
								}
								label$1152:;
								I$8 = I$8 + 1ll;
								label$1151:;
								if( I$8 <= TMP$144$8) goto label$1154;
								label$1153:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1150:;
						label$1149:;
					}
					label$1147:;
					label$1146:;
				}
			}
			goto label$1144;
			label$1145:;
			{
				int64 vr$1118 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1120 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1118 == vr$1120) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1125 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1125 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1130 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1132 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1130 != vr$1132) goto label$1158;
					{
						label$1159:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$145$8;
								int64 vr$1134 = fb_StrLen( (void*)R$3, 50ll );
								TMP$145$8 = vr$1134 + -1ll;
								goto label$1162;
								label$1165:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1167;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1160;
									}
									label$1167:;
									label$1166:;
								}
								label$1163:;
								I$8 = I$8 + 1ll;
								label$1162:;
								if( I$8 <= TMP$145$8) goto label$1165;
								label$1164:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1161:;
						label$1160:;
					}
					label$1158:;
					label$1157:;
				}
			}
			label$1144:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1ERKS_( &A$3, (struct $14UZSTRING_FIXED*)&U2$2 );
			char R$3[50];
			char* vr$1146 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1146, 0ll, 0 );
			goto label$1169;
			{
				int64 vr$1149 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1151 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1149 == vr$1151) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1156 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1156 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1161 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1163 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1161 != vr$1163) goto label$1171;
					{
						label$1172:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$146$8;
								int64 vr$1165 = fb_StrLen( (void*)R$3, 50ll );
								TMP$146$8 = vr$1165 + -1ll;
								goto label$1175;
								label$1178:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1180;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1173;
									}
									label$1180:;
									label$1179:;
								}
								label$1176:;
								I$8 = I$8 + 1ll;
								label$1175:;
								if( I$8 <= TMP$146$8) goto label$1178;
								label$1177:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1174:;
						label$1173:;
					}
					label$1171:;
					label$1170:;
				}
			}
			goto label$1168;
			label$1169:;
			{
				int64 vr$1175 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1177 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1175 == vr$1177) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1182 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1182 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1187 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1189 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1187 != vr$1189) goto label$1182;
					{
						label$1183:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$147$8;
								int64 vr$1191 = fb_StrLen( (void*)R$3, 50ll );
								TMP$147$8 = vr$1191 + -1ll;
								goto label$1186;
								label$1189:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1191;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1184;
									}
									label$1191:;
									label$1190:;
								}
								label$1187:;
								I$8 = I$8 + 1ll;
								label$1186:;
								if( I$8 <= TMP$147$8) goto label$1189;
								label$1188:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 192, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1185:;
						label$1184:;
					}
					label$1182:;
					label$1181:;
				}
			}
			label$1168:;
		}
	}
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"a", 2ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"xyz", 4ll, 0 );
		struct $14UZSTRING_FIXED U1$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U1$2, (char*)"a" );
		struct $14UZSTRING_FIXED U2$2;
		_ZN14UZSTRING_FIXEDC1EPKc( &U2$2, (char*)"xyz" );
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"a" );
			char R$3[50];
			char* vr$1206 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1206, 0ll, 0 );
			{
				int64 vr$1209 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1211 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1209 == vr$1211) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1216 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1216 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1221 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1223 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1221 != vr$1223) goto label$1195;
					{
						label$1196:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$148$8;
								int64 vr$1225 = fb_StrLen( (void*)R$3, 50ll );
								TMP$148$8 = vr$1225 + -1ll;
								goto label$1199;
								label$1202:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1204;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1197;
									}
									label$1204:;
									label$1203:;
								}
								label$1200:;
								I$8 = I$8 + 1ll;
								label$1199:;
								if( I$8 <= TMP$148$8) goto label$1202;
								label$1201:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1198:;
						label$1197:;
					}
					label$1195:;
					label$1194:;
				}
			}
			goto label$1192;
			label$1193:;
			{
				int64 vr$1235 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1237 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1235 == vr$1237) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1242 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1242 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1247 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1249 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1247 != vr$1249) goto label$1206;
					{
						label$1207:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$149$8;
								int64 vr$1251 = fb_StrLen( (void*)R$3, 50ll );
								TMP$149$8 = vr$1251 + -1ll;
								goto label$1210;
								label$1213:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1215;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1208;
									}
									label$1215:;
									label$1214:;
								}
								label$1211:;
								I$8 = I$8 + 1ll;
								label$1210:;
								if( I$8 <= TMP$149$8) goto label$1213;
								label$1212:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1209:;
						label$1208:;
					}
					label$1206:;
					label$1205:;
				}
			}
			label$1192:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)T1$2 );
			char R$3[50];
			char* vr$1263 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1263, 0ll, 0 );
			{
				int64 vr$1266 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1268 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1266 == vr$1268) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1273 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1273 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1278 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1280 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1278 != vr$1280) goto label$1219;
					{
						label$1220:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$150$8;
								int64 vr$1282 = fb_StrLen( (void*)R$3, 50ll );
								TMP$150$8 = vr$1282 + -1ll;
								goto label$1223;
								label$1226:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1228;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1221;
									}
									label$1228:;
									label$1227:;
								}
								label$1224:;
								I$8 = I$8 + 1ll;
								label$1223:;
								if( I$8 <= TMP$150$8) goto label$1226;
								label$1225:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1222:;
						label$1221:;
					}
					label$1219:;
					label$1218:;
				}
			}
			goto label$1216;
			label$1217:;
			{
				int64 vr$1292 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1294 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1292 == vr$1294) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1299 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1299 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1304 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1306 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1304 != vr$1306) goto label$1230;
					{
						label$1231:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$151$8;
								int64 vr$1308 = fb_StrLen( (void*)R$3, 50ll );
								TMP$151$8 = vr$1308 + -1ll;
								goto label$1234;
								label$1237:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1239;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1232;
									}
									label$1239:;
									label$1238:;
								}
								label$1235:;
								I$8 = I$8 + 1ll;
								label$1234:;
								if( I$8 <= TMP$151$8) goto label$1237;
								label$1236:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1233:;
						label$1232:;
					}
					label$1230:;
					label$1229:;
				}
			}
			label$1216:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"a" );
			char R$3[50];
			char* vr$1319 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1319, 0ll, 0 );
			{
				int64 vr$1322 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1324 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1322 == vr$1324) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1329 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1329 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1334 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1336 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1334 != vr$1336) goto label$1243;
					{
						label$1244:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$152$8;
								int64 vr$1338 = fb_StrLen( (void*)R$3, 50ll );
								TMP$152$8 = vr$1338 + -1ll;
								goto label$1247;
								label$1250:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1252;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1245;
									}
									label$1252:;
									label$1251:;
								}
								label$1248:;
								I$8 = I$8 + 1ll;
								label$1247:;
								if( I$8 <= TMP$152$8) goto label$1250;
								label$1249:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1246:;
						label$1245:;
					}
					label$1243:;
					label$1242:;
				}
			}
			goto label$1240;
			label$1241:;
			{
				int64 vr$1348 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1350 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1348 == vr$1350) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1355 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1355 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1360 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1362 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1360 != vr$1362) goto label$1254;
					{
						label$1255:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$153$8;
								int64 vr$1364 = fb_StrLen( (void*)R$3, 50ll );
								TMP$153$8 = vr$1364 + -1ll;
								goto label$1258;
								label$1261:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1263;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1256;
									}
									label$1263:;
									label$1262:;
								}
								label$1259:;
								I$8 = I$8 + 1ll;
								label$1258:;
								if( I$8 <= TMP$153$8) goto label$1261;
								label$1260:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1257:;
						label$1256:;
					}
					label$1254:;
					label$1253:;
				}
			}
			label$1240:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)T1$2 );
			char R$3[50];
			char* vr$1376 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1376, 0ll, 0 );
			{
				int64 vr$1379 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1381 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1379 == vr$1381) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1386 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1386 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1391 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1393 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1391 != vr$1393) goto label$1267;
					{
						label$1268:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$154$8;
								int64 vr$1395 = fb_StrLen( (void*)R$3, 50ll );
								TMP$154$8 = vr$1395 + -1ll;
								goto label$1271;
								label$1274:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1276;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1269;
									}
									label$1276:;
									label$1275:;
								}
								label$1272:;
								I$8 = I$8 + 1ll;
								label$1271:;
								if( I$8 <= TMP$154$8) goto label$1274;
								label$1273:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1270:;
						label$1269:;
					}
					label$1267:;
					label$1266:;
				}
			}
			goto label$1264;
			label$1265:;
			{
				int64 vr$1405 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1407 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1405 == vr$1407) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1412 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1412 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1417 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1419 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1417 != vr$1419) goto label$1278;
					{
						label$1279:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$155$8;
								int64 vr$1421 = fb_StrLen( (void*)R$3, 50ll );
								TMP$155$8 = vr$1421 + -1ll;
								goto label$1282;
								label$1285:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1287;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1280;
									}
									label$1287:;
									label$1286:;
								}
								label$1283:;
								I$8 = I$8 + 1ll;
								label$1282:;
								if( I$8 <= TMP$155$8) goto label$1285;
								label$1284:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1281:;
						label$1280:;
					}
					label$1278:;
					label$1277:;
				}
			}
			label$1264:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1ERKS_( &A$3, (struct $14UZSTRING_FIXED*)&U1$2 );
			char R$3[50];
			char* vr$1433 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1433, 0ll, 0 );
			{
				int64 vr$1436 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1438 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1436 == vr$1438) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1443 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1443 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1448 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1450 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1448 != vr$1450) goto label$1291;
					{
						label$1292:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$156$8;
								int64 vr$1452 = fb_StrLen( (void*)R$3, 50ll );
								TMP$156$8 = vr$1452 + -1ll;
								goto label$1295;
								label$1298:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1300;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1293;
									}
									label$1300:;
									label$1299:;
								}
								label$1296:;
								I$8 = I$8 + 1ll;
								label$1295:;
								if( I$8 <= TMP$156$8) goto label$1298;
								label$1297:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1294:;
						label$1293:;
					}
					label$1291:;
					label$1290:;
				}
			}
			goto label$1288;
			label$1289:;
			{
				int64 vr$1462 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1464 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1462 == vr$1464) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1469 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1469 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1474 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1476 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1474 != vr$1476) goto label$1302;
					{
						label$1303:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$157$8;
								int64 vr$1478 = fb_StrLen( (void*)R$3, 50ll );
								TMP$157$8 = vr$1478 + -1ll;
								goto label$1306;
								label$1309:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1311;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1304;
									}
									label$1311:;
									label$1310:;
								}
								label$1307:;
								I$8 = I$8 + 1ll;
								label$1306:;
								if( I$8 <= TMP$157$8) goto label$1309;
								label$1308:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1305:;
						label$1304:;
					}
					label$1302:;
					label$1301:;
				}
			}
			label$1288:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1EPKc( &A$3, (char*)"a" );
			char R$3[50];
			char* vr$1489 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1489, 0ll, 0 );
			{
				int64 vr$1492 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1494 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1492 == vr$1494) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1499 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1499 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1504 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1506 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1504 != vr$1506) goto label$1315;
					{
						label$1316:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$158$8;
								int64 vr$1508 = fb_StrLen( (void*)R$3, 50ll );
								TMP$158$8 = vr$1508 + -1ll;
								goto label$1319;
								label$1322:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1324;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1317;
									}
									label$1324:;
									label$1323:;
								}
								label$1320:;
								I$8 = I$8 + 1ll;
								label$1319:;
								if( I$8 <= TMP$158$8) goto label$1322;
								label$1321:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1318:;
						label$1317:;
					}
					label$1315:;
					label$1314:;
				}
			}
			goto label$1312;
			label$1313:;
			{
				int64 vr$1518 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1520 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1518 == vr$1520) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1525 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1525 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1530 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1532 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1530 != vr$1532) goto label$1326;
					{
						label$1327:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$159$8;
								int64 vr$1534 = fb_StrLen( (void*)R$3, 50ll );
								TMP$159$8 = vr$1534 + -1ll;
								goto label$1330;
								label$1333:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1335;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1328;
									}
									label$1335:;
									label$1334:;
								}
								label$1331:;
								I$8 = I$8 + 1ll;
								label$1330:;
								if( I$8 <= TMP$159$8) goto label$1333;
								label$1332:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1329:;
						label$1328:;
					}
					label$1326:;
					label$1325:;
				}
			}
			label$1312:;
		}
		{
			struct $14UZSTRING_FIXED A$3;
			_ZN14UZSTRING_FIXEDC1ERKS_( &A$3, (struct $14UZSTRING_FIXED*)&U1$2 );
			char R$3[50];
			char* vr$1546 = _ZN14UZSTRING_FIXEDcvcEv( &A$3 );
			fb_StrAssign( (void*)R$3, 50ll, (void*)vr$1546, 0ll, 0 );
			{
				int64 vr$1549 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1551 = fb_StrLen( (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1549 == vr$1551) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t1))" );
				int32 vr$1556 = fb_StrCompare( (void*)R$3, 50ll, (void*)T1$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1556 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t1)" );
				{
					int64 vr$1561 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1563 = fb_StrLen( (void*)T1$2, 50ll );
					if( vr$1561 != vr$1563) goto label$1339;
					{
						label$1340:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$160$8;
								int64 vr$1565 = fb_StrLen( (void*)R$3, 50ll );
								TMP$160$8 = vr$1565 + -1ll;
								goto label$1343;
								label$1346:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T1$2 + I$8)) goto label$1348;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1341;
									}
									label$1348:;
									label$1347:;
								}
								label$1344:;
								I$8 = I$8 + 1ll;
								label$1343:;
								if( I$8 <= TMP$160$8) goto label$1346;
								label$1345:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1342:;
						label$1341:;
					}
					label$1339:;
					label$1338:;
				}
			}
			goto label$1336;
			label$1337:;
			{
				int64 vr$1575 = fb_StrLen( (void*)R$3, 50ll );
				int64 vr$1577 = fb_StrLen( (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1575 == vr$1577) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT(len(r) = len(t2))" );
				int32 vr$1582 = fb_StrCompare( (void*)R$3, 50ll, (void*)T2$2, 50ll );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1582 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_ASSERT_EQUAL(r,t2)" );
				{
					int64 vr$1587 = fb_StrLen( (void*)R$3, 50ll );
					int64 vr$1589 = fb_StrLen( (void*)T2$2, 50ll );
					if( vr$1587 != vr$1589) goto label$1350;
					{
						label$1351:;
						{
							{
								int64 I$8;
								I$8 = 0ll;
								int64 TMP$161$8;
								int64 vr$1591 = fb_StrLen( (void*)R$3, 50ll );
								TMP$161$8 = vr$1591 + -1ll;
								goto label$1354;
								label$1357:;
								{
									if( (int64)*(uint8*)((uint8*)R$3 + I$8) == (int64)*(uint8*)((uint8*)T2$2 + I$8)) goto label$1359;
									{
										_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_FAIL()" );
										goto label$1352;
									}
									label$1359:;
									label$1358:;
								}
								label$1355:;
								I$8 = I$8 + 1ll;
								label$1354:;
								if( I$8 <= TMP$161$8) goto label$1357;
								label$1356:;
							}
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Ciif.bas", 193, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.IIF_.USTRING_IIF", (char*)"CU_PASS()" );
						}
						label$1353:;
						label$1352:;
					}
					label$1350:;
					label$1349:;
				}
			}
			label$1336:;
		}
	}
	label$687:;
}

static void _ZN14UZSTRING_FIXEDaSERKS_( struct $14UZSTRING_FIXED* THIS$1, struct $14UZSTRING_FIXED* __FB_RHS__$1 )
{
	label$2:;
	__builtin_memcpy( (struct $19UZSTRING_FIXED_BASE*)THIS$1, (struct $19UZSTRING_FIXED_BASE*)__FB_RHS__$1, 256 );
	label$3:;
}

static void _ZN14UZSTRING_FIXEDC1ERKS_( struct $14UZSTRING_FIXED* THIS$1, struct $14UZSTRING_FIXED* __FB_RHS__$1 )
{
	label$4:;
	_ZN19UZSTRING_FIXED_BASEC1Ev( (struct $19UZSTRING_FIXED_BASE*)THIS$1 );
	_ZN14UZSTRING_FIXEDaSERKS_( THIS$1, __FB_RHS__$1 );
	label$5:;
}

static void _ZN22UZSTRING_FIXED_MUTABLEaSERKS_( struct $22UZSTRING_FIXED_MUTABLE* THIS$1, struct $22UZSTRING_FIXED_MUTABLE* __FB_RHS__$1 )
{
	label$6:;
	__builtin_memcpy( (struct $19UZSTRING_FIXED_BASE*)THIS$1, (struct $19UZSTRING_FIXED_BASE*)__FB_RHS__$1, 256 );
	label$7:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_16ZSTRING_IIF_CTOREv( void )
{
	label$684:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.udt_zstring_.iif_", (char*)"zstring_iif", (tmp$5)&_ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_11ZSTRING_IIFEv, (boolean)0ll );
	label$685:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_16USTRING_IIF_CTOREv( void )
{
	label$1360:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.udt_zstring_.iif_", (char*)"ustring_iif", (tmp$5)&_ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_11USTRING_IIFEv, (boolean)0ll );
	label$1361:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_4IIF_13SUITE_CTOR197Ev( void )
{
	label$1362:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.udt_zstring_.iif_", (tmp$4)0ull, (tmp$4)0ull );
	label$1363:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
