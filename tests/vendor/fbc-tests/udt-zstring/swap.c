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
struct $22UZSTRING_FIXED_MUTABLE {
	struct $19UZSTRING_FIXED_BASE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $22UZSTRING_FIXED_MUTABLE ) == 256 );
struct $15UZSTRING_HAS_ID {
	struct $22UZSTRING_FIXED_MUTABLE BASE$;
	int64 ID;
};
__FB_STATIC_ASSERT( sizeof( struct $15UZSTRING_HAS_ID ) == 264 );
struct $14UZSTRING_FIXED {
	struct $19UZSTRING_FIXED_BASE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $14UZSTRING_FIXED ) == 256 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
void fb_MemSwap( void*, void*, int64 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
int32 fb_StrCompare( void*, int64, void*, int64 );
int64 fb_StrLen( void*, int64 );
void fb_StrSwap( void*, int64, int32, void*, int64, int32 );
static void fb_ctor__swap( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN19UZSTRING_FIXED_BASEC1Ev( struct $19UZSTRING_FIXED_BASE* );
static void _ZN14UZSTRING_FIXEDaSERKS_( struct $14UZSTRING_FIXED*, struct $14UZSTRING_FIXED* );
void _ZN22UZSTRING_FIXED_MUTABLEC1Ev( struct $22UZSTRING_FIXED_MUTABLE* );
void _ZN22UZSTRING_FIXED_MUTABLEC1EPKw( struct $22UZSTRING_FIXED_MUTABLE*, uint16* );
void _ZN22UZSTRING_FIXED_MUTABLEC1EPKc( struct $22UZSTRING_FIXED_MUTABLE*, char* );
static void _ZN22UZSTRING_FIXED_MUTABLEaSERKS_( struct $22UZSTRING_FIXED_MUTABLE*, struct $22UZSTRING_FIXED_MUTABLE* );
void _ZN15UZSTRING_HAS_IDC1EPKc( struct $15UZSTRING_HAS_ID*, char* );
char* _ZN15UZSTRING_HAS_IDcvcEv( struct $15UZSTRING_HAS_ID* );
static void _ZN15UZSTRING_HAS_IDaSERKS_( struct $15UZSTRING_HAS_ID*, struct $15UZSTRING_HAS_ID* );
void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5SWAP_7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5SWAP_12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5SWAP_13SUITE_CTOR117Ev( void ) __attribute__(( constructor ));

void _ZN15UZSTRING_HAS_IDC1Ev( struct $15UZSTRING_HAS_ID* THIS$1 )
{
	_ZN22UZSTRING_FIXED_MUTABLEC1Ev( (struct $22UZSTRING_FIXED_MUTABLE*)THIS$1 );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 256ll), 0, 8ll );
	label$14:;
	label$15:;
}

void _ZN15UZSTRING_HAS_IDC1EPKw( struct $15UZSTRING_HAS_ID* THIS$1, uint16* S$1 )
{
	_ZN22UZSTRING_FIXED_MUTABLEC1EPKw( (struct $22UZSTRING_FIXED_MUTABLE*)THIS$1, S$1 );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 256ll), 0, 8ll );
	label$16:;
	label$17:;
}

void _ZN15UZSTRING_HAS_IDC1EPKc( struct $15UZSTRING_HAS_ID* THIS$1, char* S$1 )
{
	_ZN22UZSTRING_FIXED_MUTABLEC1EPKc( (struct $22UZSTRING_FIXED_MUTABLE*)THIS$1, S$1 );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 256ll), 0, 8ll );
	label$18:;
	label$19:;
}

char* _ZN15UZSTRING_HAS_IDcvcEv( struct $15UZSTRING_HAS_ID* THIS$1 )
{
	char* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$20:;
	fb$result$1 = (char*)THIS$1;
	label$21:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5SWAP_7DEFAULTEv( void )
{
	label$22:;
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"", 1ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"", 1ll, 0 );
		struct $15UZSTRING_HAS_ID U1$2;
		_ZN15UZSTRING_HAS_IDC1EPKc( &U1$2, (char*)"" );
		*(int64*)((uint8*)&U1$2 + 256ll) = 1ll;
		struct $15UZSTRING_HAS_ID U2$2;
		_ZN15UZSTRING_HAS_IDC1EPKc( &U2$2, (char*)"" );
		*(int64*)((uint8*)&U2$2 + 256ll) = 2ll;
		{
			char R1$3[50];
			char* vr$5 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$5, 0ll, 0 );
			char R2$3[50];
			char* vr$8 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$8, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$15 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$17 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$15 == vr$17) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$22 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$22 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$27 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$29 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$27 != vr$29) goto label$25;
				{
					label$26:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$31$7;
							int64 vr$31 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$31$7 = vr$31 + -1ll;
							goto label$29;
							label$32:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$34;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$27;
								}
								label$34:;
								label$33:;
							}
							label$30:;
							I$7 = I$7 + 1ll;
							label$29:;
							if( I$7 <= TMP$31$7) goto label$32;
							label$31:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$28:;
					label$27:;
				}
				label$25:;
				label$24:;
			}
			int64 vr$41 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$43 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$41 == vr$43) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$48 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$48 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$53 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$55 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$53 != vr$55) goto label$36;
				{
					label$37:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$45$7;
							int64 vr$57 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$45$7 = vr$57 + -1ll;
							goto label$40;
							label$43:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$45;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$38;
								}
								label$45:;
								label$44:;
							}
							label$41:;
							I$7 = I$7 + 1ll;
							label$40:;
							if( I$7 <= TMP$45$7) goto label$43;
							label$42:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$39:;
					label$38:;
				}
				label$36:;
				label$35:;
			}
		}
		{
			{
				char* vr$67 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$69 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$69, 0ll, 0, (void*)vr$67, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$71 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$71, 0ll, 0 );
			char R2$3[50];
			char* vr$74 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$74, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$81 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$83 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$81 == vr$83) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t2))" );
			int32 vr$88 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$88 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t2)" );
			{
				int64 vr$93 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$95 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$93 != vr$95) goto label$47;
				{
					label$48:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$51$7;
							int64 vr$97 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$51$7 = vr$97 + -1ll;
							goto label$51;
							label$54:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$56;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$49;
								}
								label$56:;
								label$55:;
							}
							label$52:;
							I$7 = I$7 + 1ll;
							label$51:;
							if( I$7 <= TMP$51$7) goto label$54;
							label$53:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$50:;
					label$49:;
				}
				label$47:;
				label$46:;
			}
			int64 vr$107 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$109 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$107 == vr$109) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t1))" );
			int32 vr$114 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$114 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t1)" );
			{
				int64 vr$119 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$121 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$119 != vr$121) goto label$58;
				{
					label$59:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$57$7;
							int64 vr$123 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$57$7 = vr$123 + -1ll;
							goto label$62;
							label$65:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$67;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$60;
								}
								label$67:;
								label$66:;
							}
							label$63:;
							I$7 = I$7 + 1ll;
							label$62:;
							if( I$7 <= TMP$57$7) goto label$65;
							label$64:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$61:;
					label$60:;
				}
				label$58:;
				label$57:;
			}
		}
		{
			{
				char* vr$133 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$135 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$135, 0ll, 0, (void*)vr$133, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$137 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$137, 0ll, 0 );
			char R2$3[50];
			char* vr$140 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$140, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$147 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$149 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$147 == vr$149) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$154 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$154 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$159 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$161 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$159 != vr$161) goto label$69;
				{
					label$70:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$58$7;
							int64 vr$163 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$58$7 = vr$163 + -1ll;
							goto label$73;
							label$76:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$78;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$71;
								}
								label$78:;
								label$77:;
							}
							label$74:;
							I$7 = I$7 + 1ll;
							label$73:;
							if( I$7 <= TMP$58$7) goto label$76;
							label$75:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$72:;
					label$71:;
				}
				label$69:;
				label$68:;
			}
			int64 vr$173 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$175 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$173 == vr$175) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$180 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$180 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$185 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$187 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$185 != vr$187) goto label$80;
				{
					label$81:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$59$7;
							int64 vr$189 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$59$7 = vr$189 + -1ll;
							goto label$84;
							label$87:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$89;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$82;
								}
								label$89:;
								label$88:;
							}
							label$85:;
							I$7 = I$7 + 1ll;
							label$84:;
							if( I$7 <= TMP$59$7) goto label$87;
							label$86:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$83:;
					label$82:;
				}
				label$80:;
				label$79:;
			}
		}
		{
			{
				char* vr$199 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$201 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$201, 0ll, 0, (void*)vr$199, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$203 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$203, 0ll, 0 );
			char R2$3[50];
			char* vr$206 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$206, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$213 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$215 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$213 == vr$215) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t2))" );
			int32 vr$220 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$220 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t2)" );
			{
				int64 vr$225 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$227 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$225 != vr$227) goto label$91;
				{
					label$92:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$60$7;
							int64 vr$229 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$60$7 = vr$229 + -1ll;
							goto label$95;
							label$98:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$100;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$93;
								}
								label$100:;
								label$99:;
							}
							label$96:;
							I$7 = I$7 + 1ll;
							label$95:;
							if( I$7 <= TMP$60$7) goto label$98;
							label$97:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$94:;
					label$93:;
				}
				label$91:;
				label$90:;
			}
			int64 vr$239 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$241 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$239 == vr$241) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t1))" );
			int32 vr$246 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$246 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t1)" );
			{
				int64 vr$251 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$253 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$251 != vr$253) goto label$102;
				{
					label$103:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$61$7;
							int64 vr$255 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$61$7 = vr$255 + -1ll;
							goto label$106;
							label$109:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$111;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$104;
								}
								label$111:;
								label$110:;
							}
							label$107:;
							I$7 = I$7 + 1ll;
							label$106:;
							if( I$7 <= TMP$61$7) goto label$109;
							label$108:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$105:;
					label$104:;
				}
				label$102:;
				label$101:;
			}
		}
		{
			{
				fb_MemSwap( (void*)&U1$2, (void*)&U2$2, 264ll );
			}
			char R1$3[50];
			char* vr$267 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$267, 0ll, 0 );
			char R2$3[50];
			char* vr$270 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$270, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 2)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 1)" );
			int64 vr$277 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$279 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$277 == vr$279) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$284 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$284 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$289 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$291 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$289 != vr$291) goto label$113;
				{
					label$114:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$68$7;
							int64 vr$293 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$68$7 = vr$293 + -1ll;
							goto label$117;
							label$120:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$122;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$115;
								}
								label$122:;
								label$121:;
							}
							label$118:;
							I$7 = I$7 + 1ll;
							label$117:;
							if( I$7 <= TMP$68$7) goto label$120;
							label$119:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$116:;
					label$115:;
				}
				label$113:;
				label$112:;
			}
			int64 vr$303 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$305 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$303 == vr$305) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$310 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$310 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$315 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$317 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$315 != vr$317) goto label$124;
				{
					label$125:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$69$7;
							int64 vr$319 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$69$7 = vr$319 + -1ll;
							goto label$128;
							label$131:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$133;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$126;
								}
								label$133:;
								label$132:;
							}
							label$129:;
							I$7 = I$7 + 1ll;
							label$128:;
							if( I$7 <= TMP$69$7) goto label$131;
							label$130:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 109, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$127:;
					label$126:;
				}
				label$124:;
				label$123:;
			}
		}
	}
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"", 1ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"a", 2ll, 0 );
		struct $15UZSTRING_HAS_ID U1$2;
		_ZN15UZSTRING_HAS_IDC1EPKc( &U1$2, (char*)"" );
		*(int64*)((uint8*)&U1$2 + 256ll) = 1ll;
		struct $15UZSTRING_HAS_ID U2$2;
		_ZN15UZSTRING_HAS_IDC1EPKc( &U2$2, (char*)"a" );
		*(int64*)((uint8*)&U2$2 + 256ll) = 2ll;
		{
			char R1$3[50];
			char* vr$333 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$333, 0ll, 0 );
			char R2$3[50];
			char* vr$336 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$336, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$343 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$345 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$343 == vr$345) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$350 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$350 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$355 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$357 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$355 != vr$357) goto label$135;
				{
					label$136:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$71$7;
							int64 vr$359 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$71$7 = vr$359 + -1ll;
							goto label$139;
							label$142:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$144;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$137;
								}
								label$144:;
								label$143:;
							}
							label$140:;
							I$7 = I$7 + 1ll;
							label$139:;
							if( I$7 <= TMP$71$7) goto label$142;
							label$141:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$138:;
					label$137:;
				}
				label$135:;
				label$134:;
			}
			int64 vr$369 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$371 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$369 == vr$371) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$376 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$376 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$381 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$383 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$381 != vr$383) goto label$146;
				{
					label$147:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$72$7;
							int64 vr$385 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$72$7 = vr$385 + -1ll;
							goto label$150;
							label$153:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$155;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$148;
								}
								label$155:;
								label$154:;
							}
							label$151:;
							I$7 = I$7 + 1ll;
							label$150:;
							if( I$7 <= TMP$72$7) goto label$153;
							label$152:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$149:;
					label$148:;
				}
				label$146:;
				label$145:;
			}
		}
		{
			{
				char* vr$395 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$397 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$397, 0ll, 0, (void*)vr$395, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$399 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$399, 0ll, 0 );
			char R2$3[50];
			char* vr$402 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$402, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$409 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$411 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$409 == vr$411) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t2))" );
			int32 vr$416 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$416 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t2)" );
			{
				int64 vr$421 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$423 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$421 != vr$423) goto label$157;
				{
					label$158:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$73$7;
							int64 vr$425 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$73$7 = vr$425 + -1ll;
							goto label$161;
							label$164:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$166;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$159;
								}
								label$166:;
								label$165:;
							}
							label$162:;
							I$7 = I$7 + 1ll;
							label$161:;
							if( I$7 <= TMP$73$7) goto label$164;
							label$163:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$160:;
					label$159:;
				}
				label$157:;
				label$156:;
			}
			int64 vr$435 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$437 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$435 == vr$437) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t1))" );
			int32 vr$442 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$442 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t1)" );
			{
				int64 vr$447 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$449 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$447 != vr$449) goto label$168;
				{
					label$169:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$74$7;
							int64 vr$451 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$74$7 = vr$451 + -1ll;
							goto label$172;
							label$175:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$177;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$170;
								}
								label$177:;
								label$176:;
							}
							label$173:;
							I$7 = I$7 + 1ll;
							label$172:;
							if( I$7 <= TMP$74$7) goto label$175;
							label$174:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$171:;
					label$170:;
				}
				label$168:;
				label$167:;
			}
		}
		{
			{
				char* vr$461 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$463 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$463, 0ll, 0, (void*)vr$461, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$465 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$465, 0ll, 0 );
			char R2$3[50];
			char* vr$468 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$468, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$475 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$477 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$475 == vr$477) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$482 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$482 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$487 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$489 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$487 != vr$489) goto label$179;
				{
					label$180:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$75$7;
							int64 vr$491 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$75$7 = vr$491 + -1ll;
							goto label$183;
							label$186:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$188;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$181;
								}
								label$188:;
								label$187:;
							}
							label$184:;
							I$7 = I$7 + 1ll;
							label$183:;
							if( I$7 <= TMP$75$7) goto label$186;
							label$185:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$182:;
					label$181:;
				}
				label$179:;
				label$178:;
			}
			int64 vr$501 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$503 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$501 == vr$503) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$508 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$508 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$513 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$515 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$513 != vr$515) goto label$190;
				{
					label$191:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$76$7;
							int64 vr$517 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$76$7 = vr$517 + -1ll;
							goto label$194;
							label$197:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$199;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$192;
								}
								label$199:;
								label$198:;
							}
							label$195:;
							I$7 = I$7 + 1ll;
							label$194:;
							if( I$7 <= TMP$76$7) goto label$197;
							label$196:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$193:;
					label$192:;
				}
				label$190:;
				label$189:;
			}
		}
		{
			{
				char* vr$527 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$529 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$529, 0ll, 0, (void*)vr$527, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$531 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$531, 0ll, 0 );
			char R2$3[50];
			char* vr$534 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$534, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$541 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$543 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$541 == vr$543) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t2))" );
			int32 vr$548 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$548 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t2)" );
			{
				int64 vr$553 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$555 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$553 != vr$555) goto label$201;
				{
					label$202:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$77$7;
							int64 vr$557 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$77$7 = vr$557 + -1ll;
							goto label$205;
							label$208:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$210;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$203;
								}
								label$210:;
								label$209:;
							}
							label$206:;
							I$7 = I$7 + 1ll;
							label$205:;
							if( I$7 <= TMP$77$7) goto label$208;
							label$207:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$204:;
					label$203:;
				}
				label$201:;
				label$200:;
			}
			int64 vr$567 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$569 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$567 == vr$569) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t1))" );
			int32 vr$574 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$574 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t1)" );
			{
				int64 vr$579 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$581 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$579 != vr$581) goto label$212;
				{
					label$213:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$78$7;
							int64 vr$583 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$78$7 = vr$583 + -1ll;
							goto label$216;
							label$219:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$221;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$214;
								}
								label$221:;
								label$220:;
							}
							label$217:;
							I$7 = I$7 + 1ll;
							label$216:;
							if( I$7 <= TMP$78$7) goto label$219;
							label$218:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$215:;
					label$214:;
				}
				label$212:;
				label$211:;
			}
		}
		{
			{
				fb_MemSwap( (void*)&U1$2, (void*)&U2$2, 264ll );
			}
			char R1$3[50];
			char* vr$595 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$595, 0ll, 0 );
			char R2$3[50];
			char* vr$598 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$598, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 2)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 1)" );
			int64 vr$605 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$607 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$605 == vr$607) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$612 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$612 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$617 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$619 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$617 != vr$619) goto label$223;
				{
					label$224:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$79$7;
							int64 vr$621 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$79$7 = vr$621 + -1ll;
							goto label$227;
							label$230:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$232;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$225;
								}
								label$232:;
								label$231:;
							}
							label$228:;
							I$7 = I$7 + 1ll;
							label$227:;
							if( I$7 <= TMP$79$7) goto label$230;
							label$229:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$226:;
					label$225:;
				}
				label$223:;
				label$222:;
			}
			int64 vr$631 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$633 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$631 == vr$633) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$638 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$638 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$643 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$645 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$643 != vr$645) goto label$234;
				{
					label$235:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$80$7;
							int64 vr$647 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$80$7 = vr$647 + -1ll;
							goto label$238;
							label$241:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$243;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$236;
								}
								label$243:;
								label$242:;
							}
							label$239:;
							I$7 = I$7 + 1ll;
							label$238:;
							if( I$7 <= TMP$80$7) goto label$241;
							label$240:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 111, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$237:;
					label$236:;
				}
				label$234:;
				label$233:;
			}
		}
	}
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"a", 2ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"a", 2ll, 0 );
		struct $15UZSTRING_HAS_ID U1$2;
		_ZN15UZSTRING_HAS_IDC1EPKc( &U1$2, (char*)"a" );
		*(int64*)((uint8*)&U1$2 + 256ll) = 1ll;
		struct $15UZSTRING_HAS_ID U2$2;
		_ZN15UZSTRING_HAS_IDC1EPKc( &U2$2, (char*)"a" );
		*(int64*)((uint8*)&U2$2 + 256ll) = 2ll;
		{
			char R1$3[50];
			char* vr$661 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$661, 0ll, 0 );
			char R2$3[50];
			char* vr$664 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$664, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$671 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$673 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$671 == vr$673) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$678 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$678 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$683 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$685 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$683 != vr$685) goto label$245;
				{
					label$246:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$81$7;
							int64 vr$687 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$81$7 = vr$687 + -1ll;
							goto label$249;
							label$252:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$254;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$247;
								}
								label$254:;
								label$253:;
							}
							label$250:;
							I$7 = I$7 + 1ll;
							label$249:;
							if( I$7 <= TMP$81$7) goto label$252;
							label$251:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$248:;
					label$247:;
				}
				label$245:;
				label$244:;
			}
			int64 vr$697 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$699 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$697 == vr$699) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$704 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$704 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$709 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$711 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$709 != vr$711) goto label$256;
				{
					label$257:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$82$7;
							int64 vr$713 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$82$7 = vr$713 + -1ll;
							goto label$260;
							label$263:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$265;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$258;
								}
								label$265:;
								label$264:;
							}
							label$261:;
							I$7 = I$7 + 1ll;
							label$260:;
							if( I$7 <= TMP$82$7) goto label$263;
							label$262:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$259:;
					label$258:;
				}
				label$256:;
				label$255:;
			}
		}
		{
			{
				char* vr$723 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$725 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$725, 0ll, 0, (void*)vr$723, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$727 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$727, 0ll, 0 );
			char R2$3[50];
			char* vr$730 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$730, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$737 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$739 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$737 == vr$739) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t2))" );
			int32 vr$744 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$744 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t2)" );
			{
				int64 vr$749 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$751 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$749 != vr$751) goto label$267;
				{
					label$268:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$83$7;
							int64 vr$753 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$83$7 = vr$753 + -1ll;
							goto label$271;
							label$274:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$276;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$269;
								}
								label$276:;
								label$275:;
							}
							label$272:;
							I$7 = I$7 + 1ll;
							label$271:;
							if( I$7 <= TMP$83$7) goto label$274;
							label$273:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$270:;
					label$269:;
				}
				label$267:;
				label$266:;
			}
			int64 vr$763 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$765 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$763 == vr$765) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t1))" );
			int32 vr$770 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$770 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t1)" );
			{
				int64 vr$775 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$777 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$775 != vr$777) goto label$278;
				{
					label$279:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$84$7;
							int64 vr$779 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$84$7 = vr$779 + -1ll;
							goto label$282;
							label$285:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$287;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$280;
								}
								label$287:;
								label$286:;
							}
							label$283:;
							I$7 = I$7 + 1ll;
							label$282:;
							if( I$7 <= TMP$84$7) goto label$285;
							label$284:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$281:;
					label$280:;
				}
				label$278:;
				label$277:;
			}
		}
		{
			{
				char* vr$789 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$791 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$791, 0ll, 0, (void*)vr$789, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$793 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$793, 0ll, 0 );
			char R2$3[50];
			char* vr$796 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$796, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$803 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$805 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$803 == vr$805) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$810 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$810 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$815 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$817 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$815 != vr$817) goto label$289;
				{
					label$290:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$85$7;
							int64 vr$819 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$85$7 = vr$819 + -1ll;
							goto label$293;
							label$296:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$298;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$291;
								}
								label$298:;
								label$297:;
							}
							label$294:;
							I$7 = I$7 + 1ll;
							label$293:;
							if( I$7 <= TMP$85$7) goto label$296;
							label$295:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$292:;
					label$291:;
				}
				label$289:;
				label$288:;
			}
			int64 vr$829 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$831 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$829 == vr$831) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$836 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$836 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$841 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$843 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$841 != vr$843) goto label$300;
				{
					label$301:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$86$7;
							int64 vr$845 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$86$7 = vr$845 + -1ll;
							goto label$304;
							label$307:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$309;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$302;
								}
								label$309:;
								label$308:;
							}
							label$305:;
							I$7 = I$7 + 1ll;
							label$304:;
							if( I$7 <= TMP$86$7) goto label$307;
							label$306:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$303:;
					label$302:;
				}
				label$300:;
				label$299:;
			}
		}
		{
			{
				char* vr$855 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$857 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$857, 0ll, 0, (void*)vr$855, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$859 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$859, 0ll, 0 );
			char R2$3[50];
			char* vr$862 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$862, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$869 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$871 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$869 == vr$871) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t2))" );
			int32 vr$876 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$876 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t2)" );
			{
				int64 vr$881 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$883 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$881 != vr$883) goto label$311;
				{
					label$312:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$87$7;
							int64 vr$885 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$87$7 = vr$885 + -1ll;
							goto label$315;
							label$318:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$320;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$313;
								}
								label$320:;
								label$319:;
							}
							label$316:;
							I$7 = I$7 + 1ll;
							label$315:;
							if( I$7 <= TMP$87$7) goto label$318;
							label$317:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$314:;
					label$313:;
				}
				label$311:;
				label$310:;
			}
			int64 vr$895 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$897 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$895 == vr$897) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t1))" );
			int32 vr$902 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$902 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t1)" );
			{
				int64 vr$907 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$909 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$907 != vr$909) goto label$322;
				{
					label$323:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$88$7;
							int64 vr$911 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$88$7 = vr$911 + -1ll;
							goto label$326;
							label$329:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$331;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$324;
								}
								label$331:;
								label$330:;
							}
							label$327:;
							I$7 = I$7 + 1ll;
							label$326:;
							if( I$7 <= TMP$88$7) goto label$329;
							label$328:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$325:;
					label$324:;
				}
				label$322:;
				label$321:;
			}
		}
		{
			{
				fb_MemSwap( (void*)&U1$2, (void*)&U2$2, 264ll );
			}
			char R1$3[50];
			char* vr$923 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$923, 0ll, 0 );
			char R2$3[50];
			char* vr$926 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$926, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 2)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 1)" );
			int64 vr$933 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$935 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$933 == vr$935) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$940 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$940 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$945 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$947 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$945 != vr$947) goto label$333;
				{
					label$334:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$89$7;
							int64 vr$949 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$89$7 = vr$949 + -1ll;
							goto label$337;
							label$340:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$342;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$335;
								}
								label$342:;
								label$341:;
							}
							label$338:;
							I$7 = I$7 + 1ll;
							label$337:;
							if( I$7 <= TMP$89$7) goto label$340;
							label$339:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$336:;
					label$335:;
				}
				label$333:;
				label$332:;
			}
			int64 vr$959 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$961 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$959 == vr$961) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$966 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$966 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$971 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$973 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$971 != vr$973) goto label$344;
				{
					label$345:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$90$7;
							int64 vr$975 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$90$7 = vr$975 + -1ll;
							goto label$348;
							label$351:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$353;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$346;
								}
								label$353:;
								label$352:;
							}
							label$349:;
							I$7 = I$7 + 1ll;
							label$348:;
							if( I$7 <= TMP$90$7) goto label$351;
							label$350:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 112, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$347:;
					label$346:;
				}
				label$344:;
				label$343:;
			}
		}
	}
	{
		char T1$2[50];
		fb_StrAssign( (void*)T1$2, 50ll, (void*)"a", 2ll, 0 );
		char T2$2[50];
		fb_StrAssign( (void*)T2$2, 50ll, (void*)"abcdefghi", 10ll, 0 );
		struct $15UZSTRING_HAS_ID U1$2;
		_ZN15UZSTRING_HAS_IDC1EPKc( &U1$2, (char*)"a" );
		*(int64*)((uint8*)&U1$2 + 256ll) = 1ll;
		struct $15UZSTRING_HAS_ID U2$2;
		_ZN15UZSTRING_HAS_IDC1EPKc( &U2$2, (char*)"abcdefghi" );
		*(int64*)((uint8*)&U2$2 + 256ll) = 2ll;
		{
			char R1$3[50];
			char* vr$989 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$989, 0ll, 0 );
			char R2$3[50];
			char* vr$992 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$992, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$999 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$1001 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$999 == vr$1001) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$1006 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1006 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$1011 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$1013 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$1011 != vr$1013) goto label$355;
				{
					label$356:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$92$7;
							int64 vr$1015 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$92$7 = vr$1015 + -1ll;
							goto label$359;
							label$362:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$364;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$357;
								}
								label$364:;
								label$363:;
							}
							label$360:;
							I$7 = I$7 + 1ll;
							label$359:;
							if( I$7 <= TMP$92$7) goto label$362;
							label$361:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$358:;
					label$357:;
				}
				label$355:;
				label$354:;
			}
			int64 vr$1025 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$1027 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1025 == vr$1027) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$1032 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1032 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$1037 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$1039 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$1037 != vr$1039) goto label$366;
				{
					label$367:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$93$7;
							int64 vr$1041 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$93$7 = vr$1041 + -1ll;
							goto label$370;
							label$373:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$375;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$368;
								}
								label$375:;
								label$374:;
							}
							label$371:;
							I$7 = I$7 + 1ll;
							label$370:;
							if( I$7 <= TMP$93$7) goto label$373;
							label$372:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$369:;
					label$368:;
				}
				label$366:;
				label$365:;
			}
		}
		{
			{
				char* vr$1051 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$1053 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$1053, 0ll, 0, (void*)vr$1051, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$1055 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$1055, 0ll, 0 );
			char R2$3[50];
			char* vr$1058 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$1058, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$1065 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$1067 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1065 == vr$1067) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t2))" );
			int32 vr$1072 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1072 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t2)" );
			{
				int64 vr$1077 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$1079 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$1077 != vr$1079) goto label$377;
				{
					label$378:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$94$7;
							int64 vr$1081 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$94$7 = vr$1081 + -1ll;
							goto label$381;
							label$384:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$386;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$379;
								}
								label$386:;
								label$385:;
							}
							label$382:;
							I$7 = I$7 + 1ll;
							label$381:;
							if( I$7 <= TMP$94$7) goto label$384;
							label$383:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$380:;
					label$379:;
				}
				label$377:;
				label$376:;
			}
			int64 vr$1091 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$1093 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1091 == vr$1093) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t1))" );
			int32 vr$1098 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1098 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t1)" );
			{
				int64 vr$1103 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$1105 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$1103 != vr$1105) goto label$388;
				{
					label$389:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$95$7;
							int64 vr$1107 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$95$7 = vr$1107 + -1ll;
							goto label$392;
							label$395:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$397;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$390;
								}
								label$397:;
								label$396:;
							}
							label$393:;
							I$7 = I$7 + 1ll;
							label$392:;
							if( I$7 <= TMP$95$7) goto label$395;
							label$394:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$391:;
					label$390:;
				}
				label$388:;
				label$387:;
			}
		}
		{
			{
				char* vr$1117 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$1119 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$1119, 0ll, 0, (void*)vr$1117, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$1121 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$1121, 0ll, 0 );
			char R2$3[50];
			char* vr$1124 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$1124, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$1131 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$1133 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1131 == vr$1133) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$1138 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1138 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$1143 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$1145 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$1143 != vr$1145) goto label$399;
				{
					label$400:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$96$7;
							int64 vr$1147 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$96$7 = vr$1147 + -1ll;
							goto label$403;
							label$406:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$408;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$401;
								}
								label$408:;
								label$407:;
							}
							label$404:;
							I$7 = I$7 + 1ll;
							label$403:;
							if( I$7 <= TMP$96$7) goto label$406;
							label$405:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$402:;
					label$401:;
				}
				label$399:;
				label$398:;
			}
			int64 vr$1157 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$1159 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1157 == vr$1159) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$1164 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1164 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$1169 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$1171 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$1169 != vr$1171) goto label$410;
				{
					label$411:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$97$7;
							int64 vr$1173 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$97$7 = vr$1173 + -1ll;
							goto label$414;
							label$417:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$419;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$412;
								}
								label$419:;
								label$418:;
							}
							label$415:;
							I$7 = I$7 + 1ll;
							label$414:;
							if( I$7 <= TMP$97$7) goto label$417;
							label$416:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$413:;
					label$412:;
				}
				label$410:;
				label$409:;
			}
		}
		{
			{
				char* vr$1183 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
				char* vr$1185 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
				fb_StrSwap( (void*)vr$1185, 0ll, 0, (void*)vr$1183, 0ll, 0 );
			}
			char R1$3[50];
			char* vr$1187 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$1187, 0ll, 0 );
			char R2$3[50];
			char* vr$1190 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$1190, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 1)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 2)" );
			int64 vr$1197 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$1199 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1197 == vr$1199) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t2))" );
			int32 vr$1204 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1204 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t2)" );
			{
				int64 vr$1209 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$1211 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$1209 != vr$1211) goto label$421;
				{
					label$422:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$98$7;
							int64 vr$1213 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$98$7 = vr$1213 + -1ll;
							goto label$425;
							label$428:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$430;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$423;
								}
								label$430:;
								label$429:;
							}
							label$426:;
							I$7 = I$7 + 1ll;
							label$425:;
							if( I$7 <= TMP$98$7) goto label$428;
							label$427:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$424:;
					label$423:;
				}
				label$421:;
				label$420:;
			}
			int64 vr$1223 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$1225 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1223 == vr$1225) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t1))" );
			int32 vr$1230 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1230 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t1)" );
			{
				int64 vr$1235 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$1237 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$1235 != vr$1237) goto label$432;
				{
					label$433:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$99$7;
							int64 vr$1239 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$99$7 = vr$1239 + -1ll;
							goto label$436;
							label$439:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$441;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$434;
								}
								label$441:;
								label$440:;
							}
							label$437:;
							I$7 = I$7 + 1ll;
							label$436:;
							if( I$7 <= TMP$99$7) goto label$439;
							label$438:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$435:;
					label$434:;
				}
				label$432:;
				label$431:;
			}
		}
		{
			{
				fb_MemSwap( (void*)&U1$2, (void*)&U2$2, 264ll );
			}
			char R1$3[50];
			char* vr$1251 = _ZN15UZSTRING_HAS_IDcvcEv( &U1$2 );
			fb_StrAssign( (void*)R1$3, 50ll, (void*)vr$1251, 0ll, 0 );
			char R2$3[50];
			char* vr$1254 = _ZN15UZSTRING_HAS_IDcvcEv( &U2$2 );
			fb_StrAssign( (void*)R2$3, 50ll, (void*)vr$1254, 0ll, 0 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U1$2 + 256ll) == 2ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u1.id = 2)" );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U2$2 + 256ll) == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(u2.id = 1)" );
			int64 vr$1261 = fb_StrLen( (void*)R1$3, 50ll );
			int64 vr$1263 = fb_StrLen( (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1261 == vr$1263) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r1) = len(t1))" );
			int32 vr$1268 = fb_StrCompare( (void*)R1$3, 50ll, (void*)T1$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1268 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r1,t1)" );
			{
				int64 vr$1273 = fb_StrLen( (void*)R1$3, 50ll );
				int64 vr$1275 = fb_StrLen( (void*)T1$2, 50ll );
				if( vr$1273 != vr$1275) goto label$443;
				{
					label$444:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$100$7;
							int64 vr$1277 = fb_StrLen( (void*)R1$3, 50ll );
							TMP$100$7 = vr$1277 + -1ll;
							goto label$447;
							label$450:;
							{
								if( (int64)*(uint8*)((uint8*)R1$3 + I$7) == (int64)*(uint8*)((uint8*)T1$2 + I$7)) goto label$452;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$445;
								}
								label$452:;
								label$451:;
							}
							label$448:;
							I$7 = I$7 + 1ll;
							label$447:;
							if( I$7 <= TMP$100$7) goto label$450;
							label$449:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$446:;
					label$445:;
				}
				label$443:;
				label$442:;
			}
			int64 vr$1287 = fb_StrLen( (void*)R2$3, 50ll );
			int64 vr$1289 = fb_StrLen( (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$1287 == vr$1289) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT(len(r2) = len(t2))" );
			int32 vr$1294 = fb_StrCompare( (void*)R2$3, 50ll, (void*)T2$2, 50ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$1294 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_ASSERT_EQUAL(r2,t2)" );
			{
				int64 vr$1299 = fb_StrLen( (void*)R2$3, 50ll );
				int64 vr$1301 = fb_StrLen( (void*)T2$2, 50ll );
				if( vr$1299 != vr$1301) goto label$454;
				{
					label$455:;
					{
						{
							int64 I$7;
							I$7 = 0ll;
							int64 TMP$101$7;
							int64 vr$1303 = fb_StrLen( (void*)R2$3, 50ll );
							TMP$101$7 = vr$1303 + -1ll;
							goto label$458;
							label$461:;
							{
								if( (int64)*(uint8*)((uint8*)R2$3 + I$7) == (int64)*(uint8*)((uint8*)T2$2 + I$7)) goto label$463;
								{
									_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)0ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_FAIL()" );
									goto label$456;
								}
								label$463:;
								label$462:;
							}
							label$459:;
							I$7 = I$7 + 1ll;
							label$458:;
							if( I$7 <= TMP$101$7) goto label$461;
							label$460:;
						}
						_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)1ll, (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5Cudt-zstring\x5Cswap.bas", 113, (char*)"TESTS.FBC_TESTS.UDT_ZSTRING_.SWAP_.DEFAULT", (char*)"CU_PASS()" );
					}
					label$457:;
					label$456:;
				}
				label$454:;
				label$453:;
			}
		}
	}
	label$23:;
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

static void _ZN15UZSTRING_HAS_IDaSERKS_( struct $15UZSTRING_HAS_ID* THIS$1, struct $15UZSTRING_HAS_ID* __FB_RHS__$1 )
{
	label$10:;
	_ZN22UZSTRING_FIXED_MUTABLEaSERKS_( (struct $22UZSTRING_FIXED_MUTABLE*)THIS$1, (struct $22UZSTRING_FIXED_MUTABLE*)__FB_RHS__$1 );
	*(int64*)((uint8*)THIS$1 + 256ll) = *(int64*)((uint8*)__FB_RHS__$1 + 256ll);
	label$11:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5SWAP_12DEFAULT_CTOREv( void )
{
	label$464:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.udt_zstring_.swap_", (char*)"default", (tmp$5)&_ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5SWAP_7DEFAULTEv, (boolean)0ll );
	label$465:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS12UDT_ZSTRING_5SWAP_13SUITE_CTOR117Ev( void )
{
	label$466:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.udt_zstring_.swap_", (tmp$4)0ull, (tmp$4)0ull );
	label$467:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
