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
typedef void (*tmp$3)( void );
typedef int32 (*tmp$2)( void );
static void fb_ctor__rgb_qb( void ) __attribute__(( constructor ));
void fbcu_add_suite_qb( char*, tmp$2, tmp$2 );
void fbcu_add_test_qb( char*, char*, tmp$3, boolean );
void fbcu_CU_ASSERT_qb_( boolean, char*, int32, char*, char* );
int32 TESTS$FBC_TESTS$GFX$RGB_QB$INIT( void );
void TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGB_( void );
static void TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGB__CTOR( void ) __attribute__(( constructor ));
void TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGBA( void );
static void TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGBA_CTOR( void ) __attribute__(( constructor ));
static void TESTS$FBC_TESTS$GFX$RGB_QB_CTOR62( void ) __attribute__(( constructor ));
static uint8 C$[5];

int32 TESTS$FBC_TESTS$GFX$RGB_QB$INIT( void )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	float TESTS$FBC_TESTS$RGB_QB$INIT$1;
	__builtin_memset( &TESTS$FBC_TESTS$RGB_QB$INIT$1, 0, 4ll );
	label$2:;
	*(uint8*)C$ = (uint8)0u;
	*(uint8*)((int64)(uint8*)C$ + 1ll) = (uint8)1u;
	*(uint8*)((int64)(uint8*)C$ + 2ll) = (uint8)127u;
	*(uint8*)((int64)(uint8*)C$ + 3ll) = (uint8)128u;
	*(uint8*)((int64)(uint8*)C$ + 4ll) = (uint8)255u;
	TESTS$FBC_TESTS$RGB_QB$INIT$1 = 0x0p+0f;
	label$3:;
	return fb$result$1;
}

void TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGB_( void )
{
	label$4:;
	int16 RIDX$1;
	uint8 R$1;
	__builtin_memset( &R$1, 0, 1ll );
	int16 GIDX$1;
	uint8 G$1;
	__builtin_memset( &G$1, 0, 1ll );
	int16 BIDX$1;
	uint8 B$1;
	__builtin_memset( &B$1, 0, 1ll );
	{
		RIDX$1 = (int16)1;
		label$9:;
		{
			R$1 = *(uint8*)(((int64)(uint8*)C$ + (int64)RIDX$1) + -1ll);
			{
				GIDX$1 = (int16)1;
				label$13:;
				{
					G$1 = *(uint8*)(((int64)(uint8*)C$ + (int64)GIDX$1) + -1ll);
					{
						BIDX$1 = (int16)1;
						label$17:;
						{
							B$1 = *(uint8*)(((int64)(uint8*)C$ + (int64)BIDX$1) + -1ll);
							fbcu_CU_ASSERT_qb_( (boolean)((int64)-(((((uint32)((uint32)R$1 << (16ll & 31ll)) | (uint32)((uint32)G$1 << (8ll & 31ll))) | (uint32)B$1) | 4278190080u) == ((((uint32)((uint32)R$1 << (16ll & 31ll)) | (uint32)((uint32)G$1 << (8ll & 31ll))) | (uint32)B$1) | 4278190080u)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgfx\x5Crgb_qb.bas", 30, (char*)"TESTS.FBC_TESTS.GFX.RGB_QB.MACRORGB_", (char*)"CU_ASSERT_EQUAL(__culng((__culng(__cubyte(r)) __shl 16) or (__culng(__cubyte(g)) __shl 8) or __culng(__cubyte(b)) or &hFF000000ul),((__culng(r) __shl 16) or (__culng(g) __shl 8) or __culng(b) or (&HFF000000)))" );
						}
						label$15:;
						BIDX$1 = (int16)(BIDX$1 + (int16)1);
						label$14:;
						if( BIDX$1 <= (int16)5) goto label$17;
						label$16:;
					}
				}
				label$11:;
				GIDX$1 = (int16)(GIDX$1 + (int16)1);
				label$10:;
				if( GIDX$1 <= (int16)5) goto label$13;
				label$12:;
			}
		}
		label$7:;
		RIDX$1 = (int16)(RIDX$1 + (int16)1);
		label$6:;
		if( RIDX$1 <= (int16)5) goto label$9;
		label$8:;
	}
	fbcu_CU_ASSERT_qb_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgfx\x5Crgb_qb.bas", 35, (char*)"TESTS.FBC_TESTS.GFX.RGB_QB.MACRORGB_", (char*)"CU_ASSERT_EQUAL(__sizeof( __culng((__culng(__cubyte(0)) __shl 16) or (__culng(__cubyte(0)) __shl 8) or __culng(__cubyte(0)) or &hFF000000ul) ),__sizeof( __ulong ))" );
	label$5:;
}

void TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGBA( void )
{
	label$20:;
	int16 RIDX$1;
	uint8 R$1;
	__builtin_memset( &R$1, 0, 1ll );
	int16 GIDX$1;
	uint8 G$1;
	__builtin_memset( &G$1, 0, 1ll );
	int16 BIDX$1;
	uint8 B$1;
	__builtin_memset( &B$1, 0, 1ll );
	int16 AIDX$1;
	uint8 A$1;
	__builtin_memset( &A$1, 0, 1ll );
	{
		RIDX$1 = (int16)1;
		label$25:;
		{
			R$1 = *(uint8*)(((int64)(uint8*)C$ + (int64)RIDX$1) + -1ll);
			{
				GIDX$1 = (int16)1;
				label$29:;
				{
					G$1 = *(uint8*)(((int64)(uint8*)C$ + (int64)GIDX$1) + -1ll);
					{
						BIDX$1 = (int16)1;
						label$33:;
						{
							B$1 = *(uint8*)(((int64)(uint8*)C$ + (int64)BIDX$1) + -1ll);
							{
								AIDX$1 = (int16)1;
								label$37:;
								{
									A$1 = *(uint8*)(((int64)(uint8*)C$ + (int64)AIDX$1) + -1ll);
									fbcu_CU_ASSERT_qb_( (boolean)((int64)-(((((uint32)((uint32)R$1 << (16ll & 31ll)) | (uint32)((uint32)G$1 << (8ll & 31ll))) | (uint32)B$1) | (uint32)((uint32)A$1 << (24ll & 31ll))) == ((((uint32)((uint32)R$1 << (16ll & 31ll)) | (uint32)((uint32)G$1 << (8ll & 31ll))) | (uint32)B$1) | (uint32)((uint32)A$1 << (24ll & 31ll)))) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgfx\x5Crgb_qb.bas", 53, (char*)"TESTS.FBC_TESTS.GFX.RGB_QB.MACRORGBA", (char*)"CU_ASSERT_EQUAL(__culng((__culng(__cubyte(r)) __shl 16) or (__culng(__cubyte(g)) __shl 8) or __culng(__cubyte(b)) or (__culng(__cubyte(a)) __shl 24)),((__culng(r) __shl 16) or (__culng(g) __shl 8) or __culng(b) or (__culng(a) __shl 24)))" );
								}
								label$35:;
								AIDX$1 = (int16)(AIDX$1 + (int16)1);
								label$34:;
								if( AIDX$1 <= (int16)5) goto label$37;
								label$36:;
							}
						}
						label$31:;
						BIDX$1 = (int16)(BIDX$1 + (int16)1);
						label$30:;
						if( BIDX$1 <= (int16)5) goto label$33;
						label$32:;
					}
				}
				label$27:;
				GIDX$1 = (int16)(GIDX$1 + (int16)1);
				label$26:;
				if( GIDX$1 <= (int16)5) goto label$29;
				label$28:;
			}
		}
		label$23:;
		RIDX$1 = (int16)(RIDX$1 + (int16)1);
		label$22:;
		if( RIDX$1 <= (int16)5) goto label$25;
		label$24:;
	}
	fbcu_CU_ASSERT_qb_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgfx\x5Crgb_qb.bas", 59, (char*)"TESTS.FBC_TESTS.GFX.RGB_QB.MACRORGBA", (char*)"CU_ASSERT_EQUAL(__sizeof( __culng((__culng(__cubyte(0)) __shl 16) or (__culng(__cubyte(0)) __shl 8) or __culng(__cubyte(0)) or (__culng(__cubyte(0)) __shl 24)) ),__sizeof( __ulong ))" );
	label$21:;
}

__attribute__(( constructor )) static void fb_ctor__rgb_qb( void )
{
	label$0:;
	label$1:;
}

__attribute__(( constructor )) static void TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGB__CTOR( void )
{
	label$18:;
	fbcu_add_test_qb( (char*)"fbc_tests.gfx.rgb_qb", (char*)"MacroRGB_", (tmp$3)&TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGB_, (boolean)0ll );
	label$19:;
}

__attribute__(( constructor )) static void TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGBA_CTOR( void )
{
	label$38:;
	fbcu_add_test_qb( (char*)"fbc_tests.gfx.rgb_qb", (char*)"MacroRGBA", (tmp$3)&TESTS$FBC_TESTS$GFX$RGB_QB$MACRORGBA, (boolean)0ll );
	label$39:;
}

__attribute__(( constructor )) static void TESTS$FBC_TESTS$GFX$RGB_QB_CTOR62( void )
{
	label$40:;
	fbcu_add_suite_qb( (char*)"fbc_tests.gfx.rgb_qb", (tmp$2)&TESTS$FBC_TESTS$GFX$RGB_QB$INIT, (tmp$2)0ull );
	label$41:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit\0-lang\0qb";
