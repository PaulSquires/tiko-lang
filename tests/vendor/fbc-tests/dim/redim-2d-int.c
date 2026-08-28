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
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
struct $7FBARRAYIu7INTEGERE {
	int64* DATA;
	int64* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYIu7INTEGERE ) == 240 );
struct $7FBARRAYIvE {
	void* DATA;
	void* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYIvE ) == 240 );
struct $7FBARRAYIKvE {
	void* DATA;
	void* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYIKvE ) == 240 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
int32 fb_ArrayRedimEx( struct $7FBARRAYIvE*, uint64, int32, int32, uint64, ... );
int32 fb_ArrayRedimPresvEx( struct $7FBARRAYIvE*, uint64, int32, int32, uint64, ... );
int32 fb_ArrayErase( struct $7FBARRAYIvE* );
int64 fb_ArrayLBound( struct $7FBARRAYIKvE*, int64 );
int64 fb_ArrayUBound( struct $7FBARRAYIKvE*, int64 );
static void fb_ctor__redimz2dzint( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( struct $7FBARRAYIu7INTEGERE*, int64, int64 );
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( struct $7FBARRAYIu7INTEGERE*, int64, int64, int64, int64 );
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT5SHIFTEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10SHIFT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT5GROW0Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10GROW0_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT7SHRINK0Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT12SHRINK0_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT15SHIFT_AND_GROW0Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT20SHIFT_AND_GROW0_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT17SHIFT_AND_SHRINK0Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT22SHIFT_AND_SHRINK0_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT5GROW1Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10GROW1_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT7SHRINK1Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT12SHRINK1_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT15SHIFT_AND_GROW1Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT20SHIFT_AND_GROW1_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT17SHIFT_AND_SHRINK1Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT22SHIFT_AND_SHRINK1_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13SUITE_CTOR215Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( struct $7FBARRAYIu7INTEGERE* A$1, int64 LB0$1, int64 UB0$1 )
{
	label$2:;
	int64 COUNTER$1;
	COUNTER$1 = 1ll;
	{
		int64 IDX0$2;
		IDX0$2 = LB0$1;
		int64 TMP$7$2;
		TMP$7$2 = UB0$1;
		goto label$4;
		label$7:;
		{
			*(int64*)((IDX0$2 << (3ll & 63ll)) + *(int64*)A$1) = COUNTER$1;
			COUNTER$1 = COUNTER$1 + 1ll;
		}
		label$5:;
		IDX0$2 = IDX0$2 + 1ll;
		label$4:;
		if( IDX0$2 <= TMP$7$2) goto label$7;
		label$6:;
	}
	label$3:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( struct $7FBARRAYIu7INTEGERE* A$1, int64 LB0$1, int64 UB0$1, int64 LB1$1, int64 UB1$1 )
{
	label$8:;
	int64 COUNTER$1;
	COUNTER$1 = 1ll;
	{
		int64 IDX0$2;
		IDX0$2 = LB0$1;
		int64 TMP$8$2;
		TMP$8$2 = UB0$1;
		goto label$10;
		label$13:;
		{
			{
				int64 IDX1$4;
				IDX1$4 = LB1$1;
				int64 TMP$9$4;
				TMP$9$4 = UB1$1;
				goto label$14;
				label$17:;
				{
					*(int64*)((((IDX0$2 * *(int64*)((uint8*)A$1 + 72ll)) + IDX1$4) << (3ll & 63ll)) + *(int64*)A$1) = COUNTER$1;
					COUNTER$1 = COUNTER$1 + 1ll;
				}
				label$15:;
				IDX1$4 = IDX1$4 + 1ll;
				label$14:;
				if( IDX1$4 <= TMP$9$4) goto label$17;
				label$16:;
			}
		}
		label$11:;
		IDX0$2 = IDX0$2 + 1ll;
		label$10:;
		if( IDX0$2 <= TMP$8$2) goto label$13;
		label$12:;
	}
	label$9:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT5SHIFTEv( void )
{
	label$18:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$1Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$1Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$1Iu7INTEGEREE C$1;
	*(int64**)&C$1 = (int64*)0ull;
	*(int64**)((uint8*)&C$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&C$1, 8ull, -1, 0, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( (struct $7FBARRAYIu7INTEGERE*)&C$1, 0ll, 49ll );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$2Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$2Iu7INTEGEREE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$2Iu7INTEGEREE A$1;
	*(int64**)&A$1 = (int64*)0ull;
	*(int64**)((uint8*)&A$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( (struct $7FBARRAYIu7INTEGERE*)&A$1, 0ll, 9ll, 0ll, 4ll );
	{
		int64 LB0_C$2;
		int64 vr$7 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$7;
		int64 SIZE_C$2;
		int64 vr$9 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$9 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$13 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$13;
		int64 SIZE0_A$2;
		int64 vr$15 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$15 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$19 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$19;
		int64 SIZE1_A$2;
		int64 vr$21 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$21 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 73, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$21;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$18$4;
				TMP$18$4 = SIZE0_A$2 + -1ll;
				goto label$22;
				label$25:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$19$6;
						TMP$19$6 = SIZE1_A$2 + -1ll;
						goto label$26;
						label$29:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 73, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$27:;
						IDX1$6 = IDX1$6 + 1ll;
						label$26:;
						if( IDX1$6 <= TMP$19$6) goto label$29;
						label$28:;
					}
				}
				label$23:;
				IDX0$4 = IDX0$4 + 1ll;
				label$22:;
				if( IDX0$4 <= TMP$18$4) goto label$25;
				label$24:;
			}
		}
		label$21:;
		label$20:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 1ll, 10ll, 1ll, 5ll );
	{
		int64 LB0_C$2;
		int64 vr$45 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$45;
		int64 SIZE_C$2;
		int64 vr$47 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$47 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$51 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$51;
		int64 SIZE0_A$2;
		int64 vr$53 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$53 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$57 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$57;
		int64 SIZE1_A$2;
		int64 vr$59 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$59 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 77, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$31;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$28$4;
				TMP$28$4 = SIZE0_A$2 + -1ll;
				goto label$32;
				label$35:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$29$6;
						TMP$29$6 = SIZE1_A$2 + -1ll;
						goto label$36;
						label$39:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 77, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$37:;
						IDX1$6 = IDX1$6 + 1ll;
						label$36:;
						if( IDX1$6 <= TMP$29$6) goto label$39;
						label$38:;
					}
				}
				label$33:;
				IDX0$4 = IDX0$4 + 1ll;
				label$32:;
				if( IDX0$4 <= TMP$28$4) goto label$35;
				label$34:;
			}
		}
		label$31:;
		label$30:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, -10ll, -1ll, -5ll, -1ll );
	{
		int64 LB0_C$2;
		int64 vr$83 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$83;
		int64 SIZE_C$2;
		int64 vr$85 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$85 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$89 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$89;
		int64 SIZE0_A$2;
		int64 vr$91 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$91 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$95 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$95;
		int64 SIZE1_A$2;
		int64 vr$97 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$97 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 81, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$41;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$30$4;
				TMP$30$4 = SIZE0_A$2 + -1ll;
				goto label$42;
				label$45:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$31$6;
						TMP$31$6 = SIZE1_A$2 + -1ll;
						goto label$46;
						label$49:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 81, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$47:;
						IDX1$6 = IDX1$6 + 1ll;
						label$46:;
						if( IDX1$6 <= TMP$31$6) goto label$49;
						label$48:;
					}
				}
				label$43:;
				IDX0$4 = IDX0$4 + 1ll;
				label$42:;
				if( IDX0$4 <= TMP$30$4) goto label$45;
				label$44:;
			}
		}
		label$41:;
		label$40:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 2ll, 11ll, 3ll, 7ll );
	{
		int64 LB0_C$2;
		int64 vr$121 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$121;
		int64 SIZE_C$2;
		int64 vr$123 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$123 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$127 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$127;
		int64 SIZE0_A$2;
		int64 vr$129 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$129 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$133 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$133;
		int64 SIZE1_A$2;
		int64 vr$135 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$135 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 85, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$51;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$32$4;
				TMP$32$4 = SIZE0_A$2 + -1ll;
				goto label$52;
				label$55:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$33$6;
						TMP$33$6 = SIZE1_A$2 + -1ll;
						goto label$56;
						label$59:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 85, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$57:;
						IDX1$6 = IDX1$6 + 1ll;
						label$56:;
						if( IDX1$6 <= TMP$33$6) goto label$59;
						label$58:;
					}
				}
				label$53:;
				IDX0$4 = IDX0$4 + 1ll;
				label$52:;
				if( IDX0$4 <= TMP$32$4) goto label$55;
				label$54:;
			}
		}
		label$51:;
		label$50:;
	}
	fb_ArrayErase( (struct $7FBARRAYIvE*)&A$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&C$1 );
	label$19:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT5GROW0Ev( void )
{
	label$62:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$3Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$3Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$3Iu7INTEGEREE C$1;
	*(int64**)&C$1 = (int64*)0ull;
	*(int64**)((uint8*)&C$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&C$1, 8ull, -1, 0, 1ull, 0ll, 99ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( (struct $7FBARRAYIu7INTEGERE*)&C$1, 0ll, 49ll );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$4Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$4Iu7INTEGEREE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$4Iu7INTEGEREE A$1;
	*(int64**)&A$1 = (int64*)0ull;
	*(int64**)((uint8*)&A$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( (struct $7FBARRAYIu7INTEGERE*)&A$1, 0ll, 9ll, 0ll, 4ll );
	{
		int64 LB0_C$2;
		int64 vr$7 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$7;
		int64 SIZE_C$2;
		int64 vr$9 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$9 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$13 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$13;
		int64 SIZE0_A$2;
		int64 vr$15 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$15 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$19 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$19;
		int64 SIZE1_A$2;
		int64 vr$21 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$21 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 97, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.GROW0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$65;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$37$4;
				TMP$37$4 = SIZE0_A$2 + -1ll;
				goto label$66;
				label$69:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$38$6;
						TMP$38$6 = SIZE1_A$2 + -1ll;
						goto label$70;
						label$73:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 97, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.GROW0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$71:;
						IDX1$6 = IDX1$6 + 1ll;
						label$70:;
						if( IDX1$6 <= TMP$38$6) goto label$73;
						label$72:;
					}
				}
				label$67:;
				IDX0$4 = IDX0$4 + 1ll;
				label$66:;
				if( IDX0$4 <= TMP$37$4) goto label$69;
				label$68:;
			}
		}
		label$65:;
		label$64:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 19ll, 0ll, 4ll );
	{
		int64 LB0_C$2;
		int64 vr$45 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$45;
		int64 SIZE_C$2;
		int64 vr$47 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$47 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$51 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$51;
		int64 SIZE0_A$2;
		int64 vr$53 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$53 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$57 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$57;
		int64 SIZE1_A$2;
		int64 vr$59 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$59 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 101, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.GROW0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$75;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$39$4;
				TMP$39$4 = SIZE0_A$2 + -1ll;
				goto label$76;
				label$79:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$40$6;
						TMP$40$6 = SIZE1_A$2 + -1ll;
						goto label$80;
						label$83:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 101, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.GROW0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$81:;
						IDX1$6 = IDX1$6 + 1ll;
						label$80:;
						if( IDX1$6 <= TMP$40$6) goto label$83;
						label$82:;
					}
				}
				label$77:;
				IDX0$4 = IDX0$4 + 1ll;
				label$76:;
				if( IDX0$4 <= TMP$39$4) goto label$79;
				label$78:;
			}
		}
		label$75:;
		label$74:;
	}
	fb_ArrayErase( (struct $7FBARRAYIvE*)&A$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&C$1 );
	label$63:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT7SHRINK0Ev( void )
{
	label$86:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$5Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$5Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$5Iu7INTEGEREE C$1;
	*(int64**)&C$1 = (int64*)0ull;
	*(int64**)((uint8*)&C$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&C$1, 8ull, -1, 0, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( (struct $7FBARRAYIu7INTEGERE*)&C$1, 0ll, 49ll );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$6Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$6Iu7INTEGEREE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$6Iu7INTEGEREE A$1;
	*(int64**)&A$1 = (int64*)0ull;
	*(int64**)((uint8*)&A$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( (struct $7FBARRAYIu7INTEGERE*)&A$1, 0ll, 9ll, 0ll, 4ll );
	{
		int64 LB0_C$2;
		int64 vr$7 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$7;
		int64 SIZE_C$2;
		int64 vr$9 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$9 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$13 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$13;
		int64 SIZE0_A$2;
		int64 vr$15 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$15 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$19 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$19;
		int64 SIZE1_A$2;
		int64 vr$21 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$21 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 113, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHRINK0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$89;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$44$4;
				TMP$44$4 = SIZE0_A$2 + -1ll;
				goto label$90;
				label$93:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$45$6;
						TMP$45$6 = SIZE1_A$2 + -1ll;
						goto label$94;
						label$97:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 113, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHRINK0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$95:;
						IDX1$6 = IDX1$6 + 1ll;
						label$94:;
						if( IDX1$6 <= TMP$45$6) goto label$97;
						label$96:;
					}
				}
				label$91:;
				IDX0$4 = IDX0$4 + 1ll;
				label$90:;
				if( IDX0$4 <= TMP$44$4) goto label$93;
				label$92:;
			}
		}
		label$89:;
		label$88:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 7ll, 0ll, 4ll );
	{
		int64 LB0_C$2;
		int64 vr$45 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$45;
		int64 SIZE_C$2;
		int64 vr$47 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$47 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$51 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$51;
		int64 SIZE0_A$2;
		int64 vr$53 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$53 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$57 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$57;
		int64 SIZE1_A$2;
		int64 vr$59 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$59 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 117, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHRINK0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$99;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$46$4;
				TMP$46$4 = SIZE0_A$2 + -1ll;
				goto label$100;
				label$103:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$47$6;
						TMP$47$6 = SIZE1_A$2 + -1ll;
						goto label$104;
						label$107:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 117, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHRINK0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$105:;
						IDX1$6 = IDX1$6 + 1ll;
						label$104:;
						if( IDX1$6 <= TMP$47$6) goto label$107;
						label$106:;
					}
				}
				label$101:;
				IDX0$4 = IDX0$4 + 1ll;
				label$100:;
				if( IDX0$4 <= TMP$46$4) goto label$103;
				label$102:;
			}
		}
		label$99:;
		label$98:;
	}
	fb_ArrayErase( (struct $7FBARRAYIvE*)&A$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&C$1 );
	label$87:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT15SHIFT_AND_GROW0Ev( void )
{
	label$110:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$7Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$7Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$7Iu7INTEGEREE C$1;
	*(int64**)&C$1 = (int64*)0ull;
	*(int64**)((uint8*)&C$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&C$1, 8ull, -1, 0, 1ull, 0ll, 99ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( (struct $7FBARRAYIu7INTEGERE*)&C$1, 0ll, 49ll );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$8Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$8Iu7INTEGEREE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT9FBARRAY$8Iu7INTEGEREE A$1;
	*(int64**)&A$1 = (int64*)0ull;
	*(int64**)((uint8*)&A$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( (struct $7FBARRAYIu7INTEGERE*)&A$1, 0ll, 9ll, 0ll, 4ll );
	{
		int64 LB0_C$2;
		int64 vr$7 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$7;
		int64 SIZE_C$2;
		int64 vr$9 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$9 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$13 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$13;
		int64 SIZE0_A$2;
		int64 vr$15 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$15 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$19 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$19;
		int64 SIZE1_A$2;
		int64 vr$21 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$21 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 129, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_GROW0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$113;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$51$4;
				TMP$51$4 = SIZE0_A$2 + -1ll;
				goto label$114;
				label$117:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$52$6;
						TMP$52$6 = SIZE1_A$2 + -1ll;
						goto label$118;
						label$121:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 129, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_GROW0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$119:;
						IDX1$6 = IDX1$6 + 1ll;
						label$118:;
						if( IDX1$6 <= TMP$52$6) goto label$121;
						label$120:;
					}
				}
				label$115:;
				IDX0$4 = IDX0$4 + 1ll;
				label$114:;
				if( IDX0$4 <= TMP$51$4) goto label$117;
				label$116:;
			}
		}
		label$113:;
		label$112:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 5ll, 24ll, 3ll, 7ll );
	{
		int64 LB0_C$2;
		int64 vr$45 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$45;
		int64 SIZE_C$2;
		int64 vr$47 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$47 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$51 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$51;
		int64 SIZE0_A$2;
		int64 vr$53 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$53 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$57 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$57;
		int64 SIZE1_A$2;
		int64 vr$59 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$59 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 133, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_GROW0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$123;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$53$4;
				TMP$53$4 = SIZE0_A$2 + -1ll;
				goto label$124;
				label$127:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$54$6;
						TMP$54$6 = SIZE1_A$2 + -1ll;
						goto label$128;
						label$131:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 133, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_GROW0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$129:;
						IDX1$6 = IDX1$6 + 1ll;
						label$128:;
						if( IDX1$6 <= TMP$54$6) goto label$131;
						label$130:;
					}
				}
				label$125:;
				IDX0$4 = IDX0$4 + 1ll;
				label$124:;
				if( IDX0$4 <= TMP$53$4) goto label$127;
				label$126:;
			}
		}
		label$123:;
		label$122:;
	}
	fb_ArrayErase( (struct $7FBARRAYIvE*)&A$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&C$1 );
	label$111:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT17SHIFT_AND_SHRINK0Ev( void )
{
	label$134:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$9Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$9Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY1$9Iu7INTEGEREE C$1;
	*(int64**)&C$1 = (int64*)0ull;
	*(int64**)((uint8*)&C$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&C$1, 8ull, -1, 0, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( (struct $7FBARRAYIu7INTEGERE*)&C$1, 0ll, 49ll );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$10Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$10Iu7INTEGEREE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$10Iu7INTEGEREE A$1;
	*(int64**)&A$1 = (int64*)0ull;
	*(int64**)((uint8*)&A$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( (struct $7FBARRAYIu7INTEGERE*)&A$1, 0ll, 9ll, 0ll, 4ll );
	{
		int64 LB0_C$2;
		int64 vr$7 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$7;
		int64 SIZE_C$2;
		int64 vr$9 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$9 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$13 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$13;
		int64 SIZE0_A$2;
		int64 vr$15 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$15 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$19 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$19;
		int64 SIZE1_A$2;
		int64 vr$21 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$21 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 145, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$137;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$58$4;
				TMP$58$4 = SIZE0_A$2 + -1ll;
				goto label$138;
				label$141:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$59$6;
						TMP$59$6 = SIZE1_A$2 + -1ll;
						goto label$142;
						label$145:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 145, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$143:;
						IDX1$6 = IDX1$6 + 1ll;
						label$142:;
						if( IDX1$6 <= TMP$59$6) goto label$145;
						label$144:;
					}
				}
				label$139:;
				IDX0$4 = IDX0$4 + 1ll;
				label$138:;
				if( IDX0$4 <= TMP$58$4) goto label$141;
				label$140:;
			}
		}
		label$137:;
		label$136:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 5ll, 9ll, 3ll, 7ll );
	{
		int64 LB0_C$2;
		int64 vr$45 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$45;
		int64 SIZE_C$2;
		int64 vr$47 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$47 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$51 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$51;
		int64 SIZE0_A$2;
		int64 vr$53 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$53 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$57 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$57;
		int64 SIZE1_A$2;
		int64 vr$59 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$59 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 149, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$147;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$60$4;
				TMP$60$4 = SIZE0_A$2 + -1ll;
				goto label$148;
				label$151:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$61$6;
						TMP$61$6 = SIZE1_A$2 + -1ll;
						goto label$152;
						label$155:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 149, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$153:;
						IDX1$6 = IDX1$6 + 1ll;
						label$152:;
						if( IDX1$6 <= TMP$61$6) goto label$155;
						label$154:;
					}
				}
				label$149:;
				IDX0$4 = IDX0$4 + 1ll;
				label$148:;
				if( IDX0$4 <= TMP$60$4) goto label$151;
				label$150:;
			}
		}
		label$147:;
		label$146:;
	}
	fb_ArrayErase( (struct $7FBARRAYIvE*)&A$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&C$1 );
	label$135:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT5GROW1Ev( void )
{
	label$158:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$11Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$11Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$11Iu7INTEGEREE C$1;
	*(int64**)&C$1 = (int64*)0ull;
	*(int64**)((uint8*)&C$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&C$1, 8ull, -1, 0, 1ull, 0ll, 99ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( (struct $7FBARRAYIu7INTEGERE*)&C$1, 0ll, 49ll );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$12Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$12Iu7INTEGEREE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$12Iu7INTEGEREE A$1;
	*(int64**)&A$1 = (int64*)0ull;
	*(int64**)((uint8*)&A$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 4ll, 0ll, 9ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( (struct $7FBARRAYIu7INTEGERE*)&A$1, 0ll, 4ll, 0ll, 9ll );
	{
		int64 LB0_C$2;
		int64 vr$7 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$7;
		int64 SIZE_C$2;
		int64 vr$9 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$9 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$13 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$13;
		int64 SIZE0_A$2;
		int64 vr$15 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$15 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$19 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$19;
		int64 SIZE1_A$2;
		int64 vr$21 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$21 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 161, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.GROW1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$161;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$65$4;
				TMP$65$4 = SIZE0_A$2 + -1ll;
				goto label$162;
				label$165:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$66$6;
						TMP$66$6 = SIZE1_A$2 + -1ll;
						goto label$166;
						label$169:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 161, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.GROW1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$167:;
						IDX1$6 = IDX1$6 + 1ll;
						label$166:;
						if( IDX1$6 <= TMP$66$6) goto label$169;
						label$168:;
					}
				}
				label$163:;
				IDX0$4 = IDX0$4 + 1ll;
				label$162:;
				if( IDX0$4 <= TMP$65$4) goto label$165;
				label$164:;
			}
		}
		label$161:;
		label$160:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 4ll, 0ll, 19ll );
	{
		int64 LB0_C$2;
		int64 vr$45 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$45;
		int64 SIZE_C$2;
		int64 vr$47 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$47 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$51 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$51;
		int64 SIZE0_A$2;
		int64 vr$53 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$53 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$57 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$57;
		int64 SIZE1_A$2;
		int64 vr$59 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$59 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 165, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.GROW1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$171;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$67$4;
				TMP$67$4 = SIZE0_A$2 + -1ll;
				goto label$172;
				label$175:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$68$6;
						TMP$68$6 = SIZE1_A$2 + -1ll;
						goto label$176;
						label$179:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 165, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.GROW1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$177:;
						IDX1$6 = IDX1$6 + 1ll;
						label$176:;
						if( IDX1$6 <= TMP$68$6) goto label$179;
						label$178:;
					}
				}
				label$173:;
				IDX0$4 = IDX0$4 + 1ll;
				label$172:;
				if( IDX0$4 <= TMP$67$4) goto label$175;
				label$174:;
			}
		}
		label$171:;
		label$170:;
	}
	fb_ArrayErase( (struct $7FBARRAYIvE*)&A$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&C$1 );
	label$159:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT7SHRINK1Ev( void )
{
	label$182:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$13Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$13Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$13Iu7INTEGEREE C$1;
	*(int64**)&C$1 = (int64*)0ull;
	*(int64**)((uint8*)&C$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&C$1, 8ull, -1, 0, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( (struct $7FBARRAYIu7INTEGERE*)&C$1, 0ll, 49ll );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$14Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$14Iu7INTEGEREE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$14Iu7INTEGEREE A$1;
	*(int64**)&A$1 = (int64*)0ull;
	*(int64**)((uint8*)&A$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 4ll, 0ll, 9ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( (struct $7FBARRAYIu7INTEGERE*)&A$1, 0ll, 4ll, 0ll, 9ll );
	{
		int64 LB0_C$2;
		int64 vr$7 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$7;
		int64 SIZE_C$2;
		int64 vr$9 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$9 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$13 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$13;
		int64 SIZE0_A$2;
		int64 vr$15 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$15 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$19 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$19;
		int64 SIZE1_A$2;
		int64 vr$21 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$21 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 177, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHRINK1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$185;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$72$4;
				TMP$72$4 = SIZE0_A$2 + -1ll;
				goto label$186;
				label$189:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$73$6;
						TMP$73$6 = SIZE1_A$2 + -1ll;
						goto label$190;
						label$193:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 177, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHRINK1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$191:;
						IDX1$6 = IDX1$6 + 1ll;
						label$190:;
						if( IDX1$6 <= TMP$73$6) goto label$193;
						label$192:;
					}
				}
				label$187:;
				IDX0$4 = IDX0$4 + 1ll;
				label$186:;
				if( IDX0$4 <= TMP$72$4) goto label$189;
				label$188:;
			}
		}
		label$185:;
		label$184:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 4ll, 0ll, 7ll );
	{
		int64 LB0_C$2;
		int64 vr$45 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$45;
		int64 SIZE_C$2;
		int64 vr$47 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$47 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$51 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$51;
		int64 SIZE0_A$2;
		int64 vr$53 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$53 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$57 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$57;
		int64 SIZE1_A$2;
		int64 vr$59 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$59 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 181, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHRINK1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$195;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$74$4;
				TMP$74$4 = SIZE0_A$2 + -1ll;
				goto label$196;
				label$199:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$75$6;
						TMP$75$6 = SIZE1_A$2 + -1ll;
						goto label$200;
						label$203:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 181, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHRINK1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$201:;
						IDX1$6 = IDX1$6 + 1ll;
						label$200:;
						if( IDX1$6 <= TMP$75$6) goto label$203;
						label$202:;
					}
				}
				label$197:;
				IDX0$4 = IDX0$4 + 1ll;
				label$196:;
				if( IDX0$4 <= TMP$74$4) goto label$199;
				label$198:;
			}
		}
		label$195:;
		label$194:;
	}
	fb_ArrayErase( (struct $7FBARRAYIvE*)&A$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&C$1 );
	label$183:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT15SHIFT_AND_GROW1Ev( void )
{
	label$206:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$15Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$15Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$15Iu7INTEGEREE C$1;
	*(int64**)&C$1 = (int64*)0ull;
	*(int64**)((uint8*)&C$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&C$1, 8ull, -1, 0, 1ull, 0ll, 99ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( (struct $7FBARRAYIu7INTEGERE*)&C$1, 0ll, 49ll );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$16Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$16Iu7INTEGEREE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$16Iu7INTEGEREE A$1;
	*(int64**)&A$1 = (int64*)0ull;
	*(int64**)((uint8*)&A$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 4ll, 0ll, 9ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( (struct $7FBARRAYIu7INTEGERE*)&A$1, 0ll, 4ll, 0ll, 9ll );
	{
		int64 LB0_C$2;
		int64 vr$7 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$7;
		int64 SIZE_C$2;
		int64 vr$9 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$9 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$13 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$13;
		int64 SIZE0_A$2;
		int64 vr$15 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$15 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$19 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$19;
		int64 SIZE1_A$2;
		int64 vr$21 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$21 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 193, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_GROW1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$209;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$79$4;
				TMP$79$4 = SIZE0_A$2 + -1ll;
				goto label$210;
				label$213:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$80$6;
						TMP$80$6 = SIZE1_A$2 + -1ll;
						goto label$214;
						label$217:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 193, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_GROW1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$215:;
						IDX1$6 = IDX1$6 + 1ll;
						label$214:;
						if( IDX1$6 <= TMP$80$6) goto label$217;
						label$216:;
					}
				}
				label$211:;
				IDX0$4 = IDX0$4 + 1ll;
				label$210:;
				if( IDX0$4 <= TMP$79$4) goto label$213;
				label$212:;
			}
		}
		label$209:;
		label$208:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 3ll, 7ll, 5ll, 24ll );
	{
		int64 LB0_C$2;
		int64 vr$45 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$45;
		int64 SIZE_C$2;
		int64 vr$47 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$47 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$51 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$51;
		int64 SIZE0_A$2;
		int64 vr$53 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$53 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$57 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$57;
		int64 SIZE1_A$2;
		int64 vr$59 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$59 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 197, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_GROW1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$219;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$81$4;
				TMP$81$4 = SIZE0_A$2 + -1ll;
				goto label$220;
				label$223:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$82$6;
						TMP$82$6 = SIZE1_A$2 + -1ll;
						goto label$224;
						label$227:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 197, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_GROW1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$225:;
						IDX1$6 = IDX1$6 + 1ll;
						label$224:;
						if( IDX1$6 <= TMP$82$6) goto label$227;
						label$226:;
					}
				}
				label$221:;
				IDX0$4 = IDX0$4 + 1ll;
				label$220:;
				if( IDX0$4 <= TMP$81$4) goto label$223;
				label$222:;
			}
		}
		label$219:;
		label$218:;
	}
	fb_ArrayErase( (struct $7FBARRAYIvE*)&A$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&C$1 );
	label$207:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT17SHIFT_AND_SHRINK1Ev( void )
{
	label$230:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$17Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$17Iu7INTEGEREE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT11FBARRAY1$17Iu7INTEGEREE C$1;
	*(int64**)&C$1 = (int64*)0ull;
	*(int64**)((uint8*)&C$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&C$1, 8ull, -1, 0, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_1DER7FBARRAYIu7INTEGERES3_S3_( (struct $7FBARRAYIu7INTEGERE*)&C$1, 0ll, 49ll );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$18Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$18Iu7INTEGEREE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10FBARRAY$18Iu7INTEGEREE A$1;
	*(int64**)&A$1 = (int64*)0ull;
	*(int64**)((uint8*)&A$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 0ll, 4ll, 0ll, 9ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13INIT_ARRAY_2DER7FBARRAYIu7INTEGERES3_S3_S3_S3_( (struct $7FBARRAYIu7INTEGERE*)&A$1, 0ll, 4ll, 0ll, 9ll );
	{
		int64 LB0_C$2;
		int64 vr$7 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$7;
		int64 SIZE_C$2;
		int64 vr$9 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$9 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$13 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$13;
		int64 SIZE0_A$2;
		int64 vr$15 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$15 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$19 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$19;
		int64 SIZE1_A$2;
		int64 vr$21 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$21 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 209, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$233;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$86$4;
				TMP$86$4 = SIZE0_A$2 + -1ll;
				goto label$234;
				label$237:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$87$6;
						TMP$87$6 = SIZE1_A$2 + -1ll;
						goto label$238;
						label$241:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 209, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$239:;
						IDX1$6 = IDX1$6 + 1ll;
						label$238:;
						if( IDX1$6 <= TMP$87$6) goto label$241;
						label$240:;
					}
				}
				label$235:;
				IDX0$4 = IDX0$4 + 1ll;
				label$234:;
				if( IDX0$4 <= TMP$86$4) goto label$237;
				label$236:;
			}
		}
		label$233:;
		label$232:;
	}
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)&A$1, 8ull, -1, 0, 2ull, 3ll, 7ll, 5ll, 9ll );
	{
		int64 LB0_C$2;
		int64 vr$45 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$45;
		int64 SIZE_C$2;
		int64 vr$47 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$47 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$51 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$51;
		int64 SIZE0_A$2;
		int64 vr$53 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$53 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$57 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$57;
		int64 SIZE1_A$2;
		int64 vr$59 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$59 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 213, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$243;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$88$4;
				TMP$88$4 = SIZE0_A$2 + -1ll;
				goto label$244;
				label$247:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$89$6;
						TMP$89$6 = SIZE1_A$2 + -1ll;
						goto label$248;
						label$251:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-int.bas", 213, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_INT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx),a(lb0_a + idx0, lb1_a + idx1))" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$249:;
						IDX1$6 = IDX1$6 + 1ll;
						label$248:;
						if( IDX1$6 <= TMP$89$6) goto label$251;
						label$250:;
					}
				}
				label$245:;
				IDX0$4 = IDX0$4 + 1ll;
				label$244:;
				if( IDX0$4 <= TMP$88$4) goto label$247;
				label$246:;
			}
		}
		label$243:;
		label$242:;
	}
	fb_ArrayErase( (struct $7FBARRAYIvE*)&A$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&C$1 );
	label$231:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10SHIFT_CTOREv( void )
{
	label$60:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_int", (char*)"shift", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT5SHIFTEv, (boolean)0ll );
	label$61:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10GROW0_CTOREv( void )
{
	label$84:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_int", (char*)"grow0", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT5GROW0Ev, (boolean)0ll );
	label$85:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT12SHRINK0_CTOREv( void )
{
	label$108:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_int", (char*)"shrink0", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT7SHRINK0Ev, (boolean)0ll );
	label$109:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT20SHIFT_AND_GROW0_CTOREv( void )
{
	label$132:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_int", (char*)"shift_and_grow0", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT15SHIFT_AND_GROW0Ev, (boolean)0ll );
	label$133:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT22SHIFT_AND_SHRINK0_CTOREv( void )
{
	label$156:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_int", (char*)"shift_and_shrink0", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT17SHIFT_AND_SHRINK0Ev, (boolean)0ll );
	label$157:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT10GROW1_CTOREv( void )
{
	label$180:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_int", (char*)"grow1", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT5GROW1Ev, (boolean)0ll );
	label$181:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT12SHRINK1_CTOREv( void )
{
	label$204:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_int", (char*)"shrink1", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT7SHRINK1Ev, (boolean)0ll );
	label$205:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT20SHIFT_AND_GROW1_CTOREv( void )
{
	label$228:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_int", (char*)"shift_and_grow1", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT15SHIFT_AND_GROW1Ev, (boolean)0ll );
	label$229:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT22SHIFT_AND_SHRINK1_CTOREv( void )
{
	label$252:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_int", (char*)"shift_and_shrink1", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT17SHIFT_AND_SHRINK1Ev, (boolean)0ll );
	label$253:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_INT13SUITE_CTOR215Ev( void )
{
	label$254:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.dim_.redim_2d_int", (tmp$4)0ull, (tmp$4)0ull );
	label$255:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
