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
struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE {
	int64 NUMBER;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE ) == 8 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE {
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE ) == 240 );
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
int32 fb_ArrayRedimObj( struct $7FBARRAYIvE*, uint64, void*, void*, uint64, ... );
int32 fb_ArrayRedimPresvObj( struct $7FBARRAYIvE*, uint64, void*, void*, uint64, ... );
int32 fb_ArrayEraseObj( struct $7FBARRAYIvE*, void*, void* );
int64 fb_ArrayLBound( struct $7FBARRAYIKvE*, int64 );
int64 fb_ArrayUBound( struct $7FBARRAYIKvE*, int64 );
static void fb_ctor__redimz2dzudt( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* );
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* );
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*, int64, int64 );
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*, int64, int64, int64, int64 );
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT5SHIFTEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10SHIFT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT5GROW0Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10GROW0_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT7SHRINK0Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT12SHRINK0_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT15SHIFT_AND_GROW0Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT20SHIFT_AND_GROW0_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT17SHIFT_AND_SHRINK0Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT22SHIFT_AND_SHRINK0_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT5GROW1Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10GROW1_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT7SHRINK1Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT12SHRINK1_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT15SHIFT_AND_GROW1Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT20SHIFT_AND_GROW1_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT17SHIFT_AND_SHRINK1Ev( void );
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT22SHIFT_AND_SHRINK1_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13SUITE_CTOR338Ev( void ) __attribute__(( constructor ));
static int64 _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E;
static int64 _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E;

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* THIS$1 )
{
	label$2:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	*(int64*)THIS$1 = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E + 1ll;
	label$3:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* THIS$1 )
{
	label$4:;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E + 1ll;
	label$5:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE* A$1, int64 LB0$1, int64 UB0$1 )
{
	label$6:;
	int64 COUNTER$1;
	COUNTER$1 = 1ll;
	{
		int64 IDX0$2;
		IDX0$2 = LB0$1;
		int64 TMP$7$2;
		TMP$7$2 = UB0$1;
		goto label$8;
		label$11:;
		{
			*(int64*)((IDX0$2 << (3ll & 63ll)) + *(int64*)A$1) = COUNTER$1;
			COUNTER$1 = COUNTER$1 + 1ll;
		}
		label$9:;
		IDX0$2 = IDX0$2 + 1ll;
		label$8:;
		if( IDX0$2 <= TMP$7$2) goto label$11;
		label$10:;
	}
	label$7:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE* A$1, int64 LB0$1, int64 UB0$1, int64 LB1$1, int64 UB1$1 )
{
	label$12:;
	int64 COUNTER$1;
	COUNTER$1 = 1ll;
	{
		int64 IDX0$2;
		IDX0$2 = LB0$1;
		int64 TMP$8$2;
		TMP$8$2 = UB0$1;
		goto label$14;
		label$17:;
		{
			{
				int64 IDX1$4;
				IDX1$4 = LB1$1;
				int64 TMP$9$4;
				TMP$9$4 = UB1$1;
				goto label$18;
				label$21:;
				{
					*(int64*)((((IDX0$2 * *(int64*)((uint8*)A$1 + 72ll)) + IDX1$4) << (3ll & 63ll)) + *(int64*)A$1) = COUNTER$1;
					COUNTER$1 = COUNTER$1 + 1ll;
				}
				label$19:;
				IDX1$4 = IDX1$4 + 1ll;
				label$18:;
				if( IDX1$4 <= TMP$9$4) goto label$21;
				label$20:;
			}
		}
		label$15:;
		IDX0$2 = IDX0$2 + 1ll;
		label$14:;
		if( IDX0$2 <= TMP$8$2) goto label$17;
		label$16:;
	}
	label$13:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT5SHIFTEv( void )
{
	label$22:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$1INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$1INS2_3UDTEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$1INS2_3UDTEEE C$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&C$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&C$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&C$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&C$1, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$2INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$2INS2_3UDTEEE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$2INS2_3UDTEEE A$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&A$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&A$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&A$1, 0ll, 9ll, 0ll, 4ll );
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
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 94, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$25;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$19$4;
				TMP$19$4 = SIZE0_A$2 + -1ll;
				goto label$26;
				label$29:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$20$6;
						TMP$20$6 = SIZE1_A$2 + -1ll;
						goto label$30;
						label$33:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 94, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$31:;
						IDX1$6 = IDX1$6 + 1ll;
						label$30:;
						if( IDX1$6 <= TMP$20$6) goto label$33;
						label$32:;
					}
				}
				label$27:;
				IDX0$4 = IDX0$4 + 1ll;
				label$26:;
				if( IDX0$4 <= TMP$19$4) goto label$29;
				label$28:;
			}
		}
		label$25:;
		label$24:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 96, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 97, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 1ll, 10ll, 1ll, 5ll );
	{
		int64 LB0_C$2;
		int64 vr$49 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$49;
		int64 SIZE_C$2;
		int64 vr$51 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$51 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$55 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$55;
		int64 SIZE0_A$2;
		int64 vr$57 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$57 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$61 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$61;
		int64 SIZE1_A$2;
		int64 vr$63 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$63 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 103, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$35;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$41$4;
				TMP$41$4 = SIZE0_A$2 + -1ll;
				goto label$36;
				label$39:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$42$6;
						TMP$42$6 = SIZE1_A$2 + -1ll;
						goto label$40;
						label$43:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 103, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$41:;
						IDX1$6 = IDX1$6 + 1ll;
						label$40:;
						if( IDX1$6 <= TMP$42$6) goto label$43;
						label$42:;
					}
				}
				label$37:;
				IDX0$4 = IDX0$4 + 1ll;
				label$36:;
				if( IDX0$4 <= TMP$41$4) goto label$39;
				label$38:;
			}
		}
		label$35:;
		label$34:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 105, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(ctor_count,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 106, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, -10ll, -1ll, -5ll, -1ll );
	{
		int64 LB0_C$2;
		int64 vr$91 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$91;
		int64 SIZE_C$2;
		int64 vr$93 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$93 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$97 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$97;
		int64 SIZE0_A$2;
		int64 vr$99 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$99 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$103 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$103;
		int64 SIZE1_A$2;
		int64 vr$105 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$105 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 110, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$45;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$45$4;
				TMP$45$4 = SIZE0_A$2 + -1ll;
				goto label$46;
				label$49:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$46$6;
						TMP$46$6 = SIZE1_A$2 + -1ll;
						goto label$50;
						label$53:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 110, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$51:;
						IDX1$6 = IDX1$6 + 1ll;
						label$50:;
						if( IDX1$6 <= TMP$46$6) goto label$53;
						label$52:;
					}
				}
				label$47:;
				IDX0$4 = IDX0$4 + 1ll;
				label$46:;
				if( IDX0$4 <= TMP$45$4) goto label$49;
				label$48:;
			}
		}
		label$45:;
		label$44:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 112, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(ctor_count,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 113, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 2ll, 11ll, 3ll, 7ll );
	{
		int64 LB0_C$2;
		int64 vr$133 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$133;
		int64 SIZE_C$2;
		int64 vr$135 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$135 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$139 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$139;
		int64 SIZE0_A$2;
		int64 vr$141 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$141 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$145 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$145;
		int64 SIZE1_A$2;
		int64 vr$147 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$147 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 117, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$55;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$47$4;
				TMP$47$4 = SIZE0_A$2 + -1ll;
				goto label$56;
				label$59:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$48$6;
						TMP$48$6 = SIZE1_A$2 + -1ll;
						goto label$60;
						label$63:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 117, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$61:;
						IDX1$6 = IDX1$6 + 1ll;
						label$60:;
						if( IDX1$6 <= TMP$48$6) goto label$63;
						label$62:;
					}
				}
				label$57:;
				IDX0$4 = IDX0$4 + 1ll;
				label$56:;
				if( IDX0$4 <= TMP$47$4) goto label$59;
				label$58:;
			}
		}
		label$55:;
		label$54:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 119, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(ctor_count,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 120, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&A$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&C$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	label$23:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT5GROW0Ev( void )
{
	label$66:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$3INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$3INS2_3UDTEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$3INS2_3UDTEEE C$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&C$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&C$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&C$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 1ull, 0ll, 99ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&C$1, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$4INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$4INS2_3UDTEEE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$4INS2_3UDTEEE A$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&A$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&A$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&A$1, 0ll, 9ll, 0ll, 4ll );
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
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 135, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$69;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$53$4;
				TMP$53$4 = SIZE0_A$2 + -1ll;
				goto label$70;
				label$73:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$54$6;
						TMP$54$6 = SIZE1_A$2 + -1ll;
						goto label$74;
						label$77:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 135, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$75:;
						IDX1$6 = IDX1$6 + 1ll;
						label$74:;
						if( IDX1$6 <= TMP$54$6) goto label$77;
						label$76:;
					}
				}
				label$71:;
				IDX0$4 = IDX0$4 + 1ll;
				label$70:;
				if( IDX0$4 <= TMP$53$4) goto label$73;
				label$72:;
			}
		}
		label$69:;
		label$68:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 137, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW0", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 138, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW0", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 19ll, 0ll, 4ll );
	{
		int64 LB0_C$2;
		int64 vr$49 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$49;
		int64 SIZE_C$2;
		int64 vr$51 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$51 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$55 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$55;
		int64 SIZE0_A$2;
		int64 vr$57 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$57 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$61 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$61;
		int64 SIZE1_A$2;
		int64 vr$63 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$63 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 144, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$79;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$55$4;
				TMP$55$4 = SIZE0_A$2 + -1ll;
				goto label$80;
				label$83:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$56$6;
						TMP$56$6 = SIZE1_A$2 + -1ll;
						goto label$84;
						label$87:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 144, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$85:;
						IDX1$6 = IDX1$6 + 1ll;
						label$84:;
						if( IDX1$6 <= TMP$56$6) goto label$87;
						label$86:;
					}
				}
				label$81:;
				IDX0$4 = IDX0$4 + 1ll;
				label$80:;
				if( IDX0$4 <= TMP$55$4) goto label$83;
				label$82:;
			}
		}
		label$79:;
		label$78:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 146, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW0", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 147, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW0", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&A$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&C$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	label$67:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT7SHRINK0Ev( void )
{
	label$90:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$5INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$5INS2_3UDTEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$5INS2_3UDTEEE C$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&C$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&C$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&C$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&C$1, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$6INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$6INS2_3UDTEEE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$6INS2_3UDTEEE A$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&A$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&A$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&A$1, 0ll, 9ll, 0ll, 4ll );
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
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 162, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$93;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$61$4;
				TMP$61$4 = SIZE0_A$2 + -1ll;
				goto label$94;
				label$97:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$62$6;
						TMP$62$6 = SIZE1_A$2 + -1ll;
						goto label$98;
						label$101:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 162, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$99:;
						IDX1$6 = IDX1$6 + 1ll;
						label$98:;
						if( IDX1$6 <= TMP$62$6) goto label$101;
						label$100:;
					}
				}
				label$95:;
				IDX0$4 = IDX0$4 + 1ll;
				label$94:;
				if( IDX0$4 <= TMP$61$4) goto label$97;
				label$96:;
			}
		}
		label$93:;
		label$92:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 164, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK0", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 165, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK0", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 7ll, 0ll, 4ll );
	{
		int64 LB0_C$2;
		int64 vr$49 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$49;
		int64 SIZE_C$2;
		int64 vr$51 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$51 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$55 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$55;
		int64 SIZE0_A$2;
		int64 vr$57 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$57 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$61 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$61;
		int64 SIZE1_A$2;
		int64 vr$63 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$63 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 171, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$103;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$63$4;
				TMP$63$4 = SIZE0_A$2 + -1ll;
				goto label$104;
				label$107:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$64$6;
						TMP$64$6 = SIZE1_A$2 + -1ll;
						goto label$108;
						label$111:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 171, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$109:;
						IDX1$6 = IDX1$6 + 1ll;
						label$108:;
						if( IDX1$6 <= TMP$64$6) goto label$111;
						label$110:;
					}
				}
				label$105:;
				IDX0$4 = IDX0$4 + 1ll;
				label$104:;
				if( IDX0$4 <= TMP$63$4) goto label$107;
				label$106:;
			}
		}
		label$103:;
		label$102:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 173, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK0", (char*)"CU_ASSERT_EQUAL(ctor_count,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 10ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 174, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK0", (char*)"CU_ASSERT_EQUAL(dtor_count,10)" );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&A$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&C$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	label$91:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT15SHIFT_AND_GROW0Ev( void )
{
	label$114:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$7INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$7INS2_3UDTEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$7INS2_3UDTEEE C$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&C$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&C$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&C$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 1ull, 0ll, 99ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&C$1, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$8INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$8INS2_3UDTEEE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT9FBARRAY$8INS2_3UDTEEE A$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&A$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&A$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&A$1, 0ll, 9ll, 0ll, 4ll );
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
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 189, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$117;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$72$4;
				TMP$72$4 = SIZE0_A$2 + -1ll;
				goto label$118;
				label$121:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$73$6;
						TMP$73$6 = SIZE1_A$2 + -1ll;
						goto label$122;
						label$125:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 189, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$123:;
						IDX1$6 = IDX1$6 + 1ll;
						label$122:;
						if( IDX1$6 <= TMP$73$6) goto label$125;
						label$124:;
					}
				}
				label$119:;
				IDX0$4 = IDX0$4 + 1ll;
				label$118:;
				if( IDX0$4 <= TMP$72$4) goto label$121;
				label$120:;
			}
		}
		label$117:;
		label$116:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 191, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW0", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 192, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW0", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 5ll, 24ll, 3ll, 7ll );
	{
		int64 LB0_C$2;
		int64 vr$49 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$49;
		int64 SIZE_C$2;
		int64 vr$51 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$51 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$55 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$55;
		int64 SIZE0_A$2;
		int64 vr$57 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$57 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$61 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$61;
		int64 SIZE1_A$2;
		int64 vr$63 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$63 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 198, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$127;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$74$4;
				TMP$74$4 = SIZE0_A$2 + -1ll;
				goto label$128;
				label$131:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$75$6;
						TMP$75$6 = SIZE1_A$2 + -1ll;
						goto label$132;
						label$135:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 198, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$133:;
						IDX1$6 = IDX1$6 + 1ll;
						label$132:;
						if( IDX1$6 <= TMP$75$6) goto label$135;
						label$134:;
					}
				}
				label$129:;
				IDX0$4 = IDX0$4 + 1ll;
				label$128:;
				if( IDX0$4 <= TMP$74$4) goto label$131;
				label$130:;
			}
		}
		label$127:;
		label$126:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 200, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW0", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 201, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW0", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&A$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&C$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	label$115:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT17SHIFT_AND_SHRINK0Ev( void )
{
	label$138:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$9INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$9INS2_3UDTEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY1$9INS2_3UDTEEE C$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&C$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&C$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&C$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&C$1, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$10INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$10INS2_3UDTEEE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$10INS2_3UDTEEE A$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&A$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&A$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 9ll, 0ll, 4ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&A$1, 0ll, 9ll, 0ll, 4ll );
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
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 216, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$141;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$80$4;
				TMP$80$4 = SIZE0_A$2 + -1ll;
				goto label$142;
				label$145:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$81$6;
						TMP$81$6 = SIZE1_A$2 + -1ll;
						goto label$146;
						label$149:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 216, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$147:;
						IDX1$6 = IDX1$6 + 1ll;
						label$146:;
						if( IDX1$6 <= TMP$81$6) goto label$149;
						label$148:;
					}
				}
				label$143:;
				IDX0$4 = IDX0$4 + 1ll;
				label$142:;
				if( IDX0$4 <= TMP$80$4) goto label$145;
				label$144:;
			}
		}
		label$141:;
		label$140:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 218, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 219, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 5ll, 9ll, 3ll, 7ll );
	{
		int64 LB0_C$2;
		int64 vr$49 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$49;
		int64 SIZE_C$2;
		int64 vr$51 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$51 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$55 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$55;
		int64 SIZE0_A$2;
		int64 vr$57 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$57 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$61 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$61;
		int64 SIZE1_A$2;
		int64 vr$63 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$63 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 225, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$151;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$82$4;
				TMP$82$4 = SIZE0_A$2 + -1ll;
				goto label$152;
				label$155:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$83$6;
						TMP$83$6 = SIZE1_A$2 + -1ll;
						goto label$156;
						label$159:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 225, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$157:;
						IDX1$6 = IDX1$6 + 1ll;
						label$156:;
						if( IDX1$6 <= TMP$83$6) goto label$159;
						label$158:;
					}
				}
				label$153:;
				IDX0$4 = IDX0$4 + 1ll;
				label$152:;
				if( IDX0$4 <= TMP$82$4) goto label$155;
				label$154:;
			}
		}
		label$151:;
		label$150:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 227, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT_EQUAL(ctor_count,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 25ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 228, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK0", (char*)"CU_ASSERT_EQUAL(dtor_count,25)" );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&A$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&C$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	label$139:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT5GROW1Ev( void )
{
	label$162:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$11INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$11INS2_3UDTEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$11INS2_3UDTEEE C$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&C$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&C$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&C$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 1ull, 0ll, 99ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&C$1, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$12INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$12INS2_3UDTEEE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$12INS2_3UDTEEE A$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&A$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&A$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 4ll, 0ll, 9ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&A$1, 0ll, 4ll, 0ll, 9ll );
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
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 243, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$165;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$91$4;
				TMP$91$4 = SIZE0_A$2 + -1ll;
				goto label$166;
				label$169:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$92$6;
						TMP$92$6 = SIZE1_A$2 + -1ll;
						goto label$170;
						label$173:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 243, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$171:;
						IDX1$6 = IDX1$6 + 1ll;
						label$170:;
						if( IDX1$6 <= TMP$92$6) goto label$173;
						label$172:;
					}
				}
				label$167:;
				IDX0$4 = IDX0$4 + 1ll;
				label$166:;
				if( IDX0$4 <= TMP$91$4) goto label$169;
				label$168:;
			}
		}
		label$165:;
		label$164:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 245, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW1", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 246, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW1", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 4ll, 0ll, 19ll );
	{
		int64 LB0_C$2;
		int64 vr$49 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$49;
		int64 SIZE_C$2;
		int64 vr$51 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$51 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$55 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$55;
		int64 SIZE0_A$2;
		int64 vr$57 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$57 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$61 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$61;
		int64 SIZE1_A$2;
		int64 vr$63 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$63 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 252, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$175;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$93$4;
				TMP$93$4 = SIZE0_A$2 + -1ll;
				goto label$176;
				label$179:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$94$6;
						TMP$94$6 = SIZE1_A$2 + -1ll;
						goto label$180;
						label$183:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 252, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$181:;
						IDX1$6 = IDX1$6 + 1ll;
						label$180:;
						if( IDX1$6 <= TMP$94$6) goto label$183;
						label$182:;
					}
				}
				label$177:;
				IDX0$4 = IDX0$4 + 1ll;
				label$176:;
				if( IDX0$4 <= TMP$93$4) goto label$179;
				label$178:;
			}
		}
		label$175:;
		label$174:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 254, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW1", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 255, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.GROW1", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&A$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&C$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	label$163:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT7SHRINK1Ev( void )
{
	label$186:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$13INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$13INS2_3UDTEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$13INS2_3UDTEEE C$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&C$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&C$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&C$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&C$1, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$14INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$14INS2_3UDTEEE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$14INS2_3UDTEEE A$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&A$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&A$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 4ll, 0ll, 9ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&A$1, 0ll, 4ll, 0ll, 9ll );
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
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 270, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$189;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$99$4;
				TMP$99$4 = SIZE0_A$2 + -1ll;
				goto label$190;
				label$193:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$100$6;
						TMP$100$6 = SIZE1_A$2 + -1ll;
						goto label$194;
						label$197:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 270, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$195:;
						IDX1$6 = IDX1$6 + 1ll;
						label$194:;
						if( IDX1$6 <= TMP$100$6) goto label$197;
						label$196:;
					}
				}
				label$191:;
				IDX0$4 = IDX0$4 + 1ll;
				label$190:;
				if( IDX0$4 <= TMP$99$4) goto label$193;
				label$192:;
			}
		}
		label$189:;
		label$188:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 272, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK1", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 273, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK1", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 4ll, 0ll, 7ll );
	{
		int64 LB0_C$2;
		int64 vr$49 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$49;
		int64 SIZE_C$2;
		int64 vr$51 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$51 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$55 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$55;
		int64 SIZE0_A$2;
		int64 vr$57 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$57 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$61 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$61;
		int64 SIZE1_A$2;
		int64 vr$63 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$63 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 279, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$199;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$101$4;
				TMP$101$4 = SIZE0_A$2 + -1ll;
				goto label$200;
				label$203:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$102$6;
						TMP$102$6 = SIZE1_A$2 + -1ll;
						goto label$204;
						label$207:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 279, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$205:;
						IDX1$6 = IDX1$6 + 1ll;
						label$204:;
						if( IDX1$6 <= TMP$102$6) goto label$207;
						label$206:;
					}
				}
				label$201:;
				IDX0$4 = IDX0$4 + 1ll;
				label$200:;
				if( IDX0$4 <= TMP$101$4) goto label$203;
				label$202:;
			}
		}
		label$199:;
		label$198:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 281, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK1", (char*)"CU_ASSERT_EQUAL(ctor_count,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 10ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 282, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHRINK1", (char*)"CU_ASSERT_EQUAL(dtor_count,10)" );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&A$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&C$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	label$187:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT15SHIFT_AND_GROW1Ev( void )
{
	label$210:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$15INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$15INS2_3UDTEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$15INS2_3UDTEEE C$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&C$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&C$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&C$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 1ull, 0ll, 99ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&C$1, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$16INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$16INS2_3UDTEEE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$16INS2_3UDTEEE A$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&A$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&A$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 4ll, 0ll, 9ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&A$1, 0ll, 4ll, 0ll, 9ll );
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
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 297, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$213;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$107$4;
				TMP$107$4 = SIZE0_A$2 + -1ll;
				goto label$214;
				label$217:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$108$6;
						TMP$108$6 = SIZE1_A$2 + -1ll;
						goto label$218;
						label$221:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 297, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$219:;
						IDX1$6 = IDX1$6 + 1ll;
						label$218:;
						if( IDX1$6 <= TMP$108$6) goto label$221;
						label$220:;
					}
				}
				label$215:;
				IDX0$4 = IDX0$4 + 1ll;
				label$214:;
				if( IDX0$4 <= TMP$107$4) goto label$217;
				label$216:;
			}
		}
		label$213:;
		label$212:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 299, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW1", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 300, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW1", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 3ll, 7ll, 5ll, 24ll );
	{
		int64 LB0_C$2;
		int64 vr$49 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$49;
		int64 SIZE_C$2;
		int64 vr$51 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$51 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$55 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$55;
		int64 SIZE0_A$2;
		int64 vr$57 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$57 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$61 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$61;
		int64 SIZE1_A$2;
		int64 vr$63 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$63 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 306, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$223;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$109$4;
				TMP$109$4 = SIZE0_A$2 + -1ll;
				goto label$224;
				label$227:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$110$6;
						TMP$110$6 = SIZE1_A$2 + -1ll;
						goto label$228;
						label$231:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 306, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$229:;
						IDX1$6 = IDX1$6 + 1ll;
						label$228:;
						if( IDX1$6 <= TMP$110$6) goto label$231;
						label$230:;
					}
				}
				label$225:;
				IDX0$4 = IDX0$4 + 1ll;
				label$224:;
				if( IDX0$4 <= TMP$109$4) goto label$227;
				label$226:;
			}
		}
		label$223:;
		label$222:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 308, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW1", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 309, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_GROW1", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&A$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&C$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	label$211:;
}

void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT17SHIFT_AND_SHRINK1Ev( void )
{
	label$234:;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$17INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$17INS2_3UDTEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11FBARRAY1$17INS2_3UDTEEE C$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&C$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&C$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&C$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&C$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&C$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&C$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&C$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&C$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 1ull, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_1DER7FBARRAYINS2_3UDTEEu7INTEGERS6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&C$1, 0ll, 49ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$18INS2_3UDTEEE {
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* DATA;
		struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[8];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$18INS2_3UDTEEE ) == 240 );
	struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10FBARRAY$18INS2_3UDTEEE A$1;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)&A$1 = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE**)((uint8*)&A$1 + 8ll) = (struct $N5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTE*)0ull;
	*(int64*)((uint8*)&A$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&A$1 + 32ll) = 0ll;
	*(int64*)((uint8*)&A$1 + 40ll) = 8ll;
	__builtin_memset( (void*)((uint8*)&A$1 + 48ll), 0, 192ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 0ll, 4ll, 0ll, 9ll );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13INIT_ARRAY_2DER7FBARRAYINS2_3UDTEEu7INTEGERS6_S6_S6_( (struct $7FBARRAYIN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTEE*)&A$1, 0ll, 4ll, 0ll, 9ll );
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
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 324, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$237;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$115$4;
				TMP$115$4 = SIZE0_A$2 + -1ll;
				goto label$238;
				label$241:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$116$6;
						TMP$116$6 = SIZE1_A$2 + -1ll;
						goto label$242;
						label$245:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 324, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$243:;
						IDX1$6 = IDX1$6 + 1ll;
						label$242:;
						if( IDX1$6 <= TMP$116$6) goto label$245;
						label$244:;
					}
				}
				label$239:;
				IDX0$4 = IDX0$4 + 1ll;
				label$238:;
				if( IDX0$4 <= TMP$115$4) goto label$241;
				label$240:;
			}
		}
		label$237:;
		label$236:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 50ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 326, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT_EQUAL(ctor_count,50)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 327, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT_EQUAL(dtor_count,0)" );
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E = 0ll;
	_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E = 0ll;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)&A$1, 8ull, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev, 2ull, 3ll, 7ll, 5ll, 9ll );
	{
		int64 LB0_C$2;
		int64 vr$49 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		LB0_C$2 = vr$49;
		int64 SIZE_C$2;
		int64 vr$51 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&C$1, 1ll );
		SIZE_C$2 = (vr$51 - LB0_C$2) + 1ll;
		int64 LB0_A$2;
		int64 vr$55 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		LB0_A$2 = vr$55;
		int64 SIZE0_A$2;
		int64 vr$57 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 1ll );
		SIZE0_A$2 = (vr$57 - LB0_A$2) + 1ll;
		int64 LB1_A$2;
		int64 vr$61 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		LB1_A$2 = vr$61;
		int64 SIZE1_A$2;
		int64 vr$63 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)&A$1, 2ll );
		SIZE1_A$2 = (vr$63 - LB1_A$2) + 1ll;
		int64 SIZE_A$2;
		SIZE_A$2 = SIZE0_A$2 * SIZE1_A$2;
		int64 IDX$2;
		IDX$2 = 0ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(SIZE_C$2 >= SIZE_A$2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 333, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT(size_c >= size_a)" );
		if( SIZE_C$2 < SIZE_A$2) goto label$247;
		{
			{
				int64 IDX0$4;
				IDX0$4 = 0ll;
				int64 TMP$117$4;
				TMP$117$4 = SIZE0_A$2 + -1ll;
				goto label$248;
				label$251:;
				{
					{
						int64 IDX1$6;
						IDX1$6 = 0ll;
						int64 TMP$118$6;
						TMP$118$6 = SIZE1_A$2 + -1ll;
						goto label$252;
						label$255:;
						{
							_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)(((LB0_C$2 + IDX$2) << (3ll & 63ll)) + *(int64*)&C$1) == *(int64*)((((((LB0_A$2 + IDX0$4) * *(int64*)((uint8*)&A$1 + 72ll)) + LB1_A$2) + IDX1$6) << (3ll & 63ll)) + *(int64*)&A$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 333, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT_EQUAL(c(lb0_c + idx).number,a(lb0_a + idx0, lb1_a + idx1).number)" );
							IDX$2 = IDX$2 + 1ll;
						}
						label$253:;
						IDX1$6 = IDX1$6 + 1ll;
						label$252:;
						if( IDX1$6 <= TMP$118$6) goto label$255;
						label$254:;
					}
				}
				label$249:;
				IDX0$4 = IDX0$4 + 1ll;
				label$248:;
				if( IDX0$4 <= TMP$117$4) goto label$251;
				label$250:;
			}
		}
		label$247:;
		label$246:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11CTOR_COUNT$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 335, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT_EQUAL(ctor_count,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT11DTOR_COUNT$E == 25ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Credim-2d-udt.bas", 336, (char*)"TESTS.FBC_TESTS.DIM_.REDIM_2D_UDT.SHIFT_AND_SHRINK1", (char*)"CU_ASSERT_EQUAL(dtor_count,25)" );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&A$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&C$1, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTC1Ev, (void*)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT3UDTD1Ev );
	label$235:;
}

__attribute__(( constructor )) static void fb_ctor__redimz2dzudt( void )
{
	label$0:;
	label$1:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10SHIFT_CTOREv( void )
{
	label$64:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_udt", (char*)"shift", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT5SHIFTEv, (boolean)0ll );
	label$65:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10GROW0_CTOREv( void )
{
	label$88:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_udt", (char*)"grow0", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT5GROW0Ev, (boolean)0ll );
	label$89:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT12SHRINK0_CTOREv( void )
{
	label$112:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_udt", (char*)"shrink0", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT7SHRINK0Ev, (boolean)0ll );
	label$113:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT20SHIFT_AND_GROW0_CTOREv( void )
{
	label$136:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_udt", (char*)"shift_and_grow0", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT15SHIFT_AND_GROW0Ev, (boolean)0ll );
	label$137:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT22SHIFT_AND_SHRINK0_CTOREv( void )
{
	label$160:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_udt", (char*)"shift_and_shrink0", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT17SHIFT_AND_SHRINK0Ev, (boolean)0ll );
	label$161:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT10GROW1_CTOREv( void )
{
	label$184:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_udt", (char*)"grow1", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT5GROW1Ev, (boolean)0ll );
	label$185:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT12SHRINK1_CTOREv( void )
{
	label$208:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_udt", (char*)"shrink1", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT7SHRINK1Ev, (boolean)0ll );
	label$209:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT20SHIFT_AND_GROW1_CTOREv( void )
{
	label$232:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_udt", (char*)"shift_and_grow1", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT15SHIFT_AND_GROW1Ev, (boolean)0ll );
	label$233:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT22SHIFT_AND_SHRINK1_CTOREv( void )
{
	label$256:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.redim_2d_udt", (char*)"shift_and_shrink1", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT17SHIFT_AND_SHRINK1Ev, (boolean)0ll );
	label$257:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_12REDIM_2D_UDT13SUITE_CTOR338Ev( void )
{
	label$258:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.dim_.redim_2d_udt", (tmp$4)0ull, (tmp$4)0ull );
	label$259:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
