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
struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE {
	double* ARRAY;
	int64 ITEMS;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE ) == 16 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
struct $7FBARRAYIdE {
	double* DATA;
	double* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYIdE ) == 240 );
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
struct $7FBARRAYIN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE {
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE* DATA;
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYIN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE ) == 240 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
int64 fb_ArrayLBound( struct $7FBARRAYIKvE*, int64 );
int64 fb_ArrayUBound( struct $7FBARRAYIKvE*, int64 );
static void fb_ctor__ctor_bydesc( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOC1ER7FBARRAYIdE( struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*, struct $7FBARRAYIdE* );
void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7DO_TESTER7FBARRAYINS2_3FOOEE( struct $7FBARRAYIN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE* );
void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC5LOCALEv( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10LOCAL_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC12STATIC_LOCALEv( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC17STATIC_LOCAL_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC6GLOBALEv( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC11GLOBAL_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC12SUITE_CTOR74Ev( void ) __attribute__(( constructor ));
static void _GLOBAL__I( void ) __attribute__(( constructor ));
static double _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR1$E[3] = { 0x1.p+0, 0x1.p+1, 0x1.8p+1 };
struct $8FBARRAY1IdE {
	double* DATA;
	double* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1IdE ) == 72 );
static struct $8FBARRAY1IdE _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7tmp$61$E = { (double*)((uint8*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR1$E + -8ll), (double*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR1$E, 24ll, 8ll, 1ll, 49ll, { { 3ll, 1ll, 3ll } } };
static double _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR2$E[4] = { -0x1.p+0, -0x1.p+1, -0x1.8p+1, -0x1.p+2 };
static struct $8FBARRAY1IdE _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7tmp$62$E = { (double*)((uint8*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR2$E + -8ll), (double*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR2$E, 32ll, 8ll, 1ll, 49ll, { { 4ll, 1ll, 4ll } } };
static double _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR3$E[5] = { 0x1.6p+3, 0x1.6p+4, 0x1.08p+5, 0x1.6p+5, 0x1.B8p+5 };
static struct $8FBARRAY1IdE _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7tmp$63$E = { (double*)((uint8*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR3$E + -8ll), (double*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR3$E, 40ll, 8ll, 1ll, 49ll, { { 5ll, 1ll, 5ll } } };
static struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E[3];
struct $8FBARRAY1IN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE {
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE* DATA;
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1IN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE ) == 72 );
static struct $8FBARRAY1IN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7tmp$64$E = { (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)((uint8*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E + -16ll), (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E, 48ll, 16ll, 1ll, 49ll, { { 3ll, 1ll, 3ll } } };

void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOC1ER7FBARRAYIdE( struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE* THIS$1, struct $7FBARRAYIdE* ARR$1 )
{
	label$2:;
	__builtin_memset( (double**)THIS$1, 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	int64 vr$4 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)ARR$1, 1ll );
	*(double**)THIS$1 = (double*)((vr$4 << (3ll & 63ll)) + *(int64*)ARR$1);
	int64 vr$10 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)ARR$1, 1ll );
	int64 vr$11 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)ARR$1, 1ll );
	*(int64*)((uint8*)THIS$1 + 8ll) = (vr$10 - vr$11) + 1ll;
	label$3:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7DO_TESTER7FBARRAYINS2_3FOOEE( struct $7FBARRAYIN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE* FOOTB$1 )
{
	label$4:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)*(int64*)FOOTB$1 + 24ll) == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 20, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.DO_TEST", (char*)"CU_ASSERT_EQUAL(footb(1).items,3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)*(int64*)FOOTB$1 + 40ll) == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 21, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.DO_TEST", (char*)"CU_ASSERT_EQUAL(footb(2).items,4)" );
	{
		int64 I$2;
		I$2 = 0ll;
		label$9:;
		{
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)*(double**)((uint8*)*(int64*)FOOTB$1 + 16ll) + (I$2 << (3ll & 63ll))) == (double)(I$2 + 1ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 24, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.DO_TEST", (char*)"CU_ASSERT_EQUAL(footb(1).array[i],1 + i)" );
		}
		label$7:;
		I$2 = I$2 + 1ll;
		label$6:;
		if( I$2 <= 2ll) goto label$9;
		label$8:;
	}
	{
		int64 I$2;
		I$2 = 0ll;
		label$13:;
		{
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)*(double**)((uint8*)*(int64*)FOOTB$1 + 32ll) + (I$2 << (3ll & 63ll))) == (double)-(I$2 + 1ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 28, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.DO_TEST", (char*)"CU_ASSERT_EQUAL(footb(2).array[i],-(1 + i))" );
		}
		label$11:;
		I$2 = I$2 + 1ll;
		label$10:;
		if( I$2 <= 3ll) goto label$13;
		label$12:;
	}
	label$5:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC5LOCALEv( void )
{
	label$14:;
	double ARR1$1[3];
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$1IdEE {
		double* DATA;
		double* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$1IdEE ) == 72 );
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$1IdEE tmp$37$1;
	*(double**)&tmp$37$1 = (double*)((int64)(double*)ARR1$1 + -8ll);
	*(double**)((uint8*)&tmp$37$1 + 8ll) = (double*)ARR1$1;
	*(int64*)((uint8*)&tmp$37$1 + 16ll) = 24ll;
	*(int64*)((uint8*)&tmp$37$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&tmp$37$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$37$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$37$1 + 48ll) = 3ll;
	*(int64*)((uint8*)&tmp$37$1 + 56ll) = 1ll;
	*(int64*)((uint8*)&tmp$37$1 + 64ll) = 3ll;
	*(double*)ARR1$1 = 0x1.p+0;
	*(double*)((int64)(double*)ARR1$1 + 8ll) = 0x1.p+1;
	*(double*)((int64)(double*)ARR1$1 + 16ll) = 0x1.8p+1;
	double ARR2$1[4];
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$1IdEE tmp$38$1;
	*(double**)&tmp$38$1 = (double*)((int64)(double*)ARR2$1 + -8ll);
	*(double**)((uint8*)&tmp$38$1 + 8ll) = (double*)ARR2$1;
	*(int64*)((uint8*)&tmp$38$1 + 16ll) = 32ll;
	*(int64*)((uint8*)&tmp$38$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&tmp$38$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$38$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$38$1 + 48ll) = 4ll;
	*(int64*)((uint8*)&tmp$38$1 + 56ll) = 1ll;
	*(int64*)((uint8*)&tmp$38$1 + 64ll) = 4ll;
	*(double*)ARR2$1 = -0x1.p+0;
	*(double*)((int64)(double*)ARR2$1 + 8ll) = -0x1.p+1;
	*(double*)((int64)(double*)ARR2$1 + 16ll) = -0x1.8p+1;
	*(double*)((int64)(double*)ARR2$1 + 24ll) = -0x1.p+2;
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE FOOTB$1[2];
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$2INS2_3FOOEEE {
		struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE* DATA;
		struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$2INS2_3FOOEEE ) == 72 );
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$2INS2_3FOOEEE tmp$39$1;
	*(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE**)&tmp$39$1 = (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1 + -16ll);
	*(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE**)((uint8*)&tmp$39$1 + 8ll) = (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1;
	*(int64*)((uint8*)&tmp$39$1 + 16ll) = 32ll;
	*(int64*)((uint8*)&tmp$39$1 + 24ll) = 16ll;
	*(int64*)((uint8*)&tmp$39$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$39$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$39$1 + 48ll) = 2ll;
	*(int64*)((uint8*)&tmp$39$1 + 56ll) = 1ll;
	*(int64*)((uint8*)&tmp$39$1 + 64ll) = 2ll;
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOC1ER7FBARRAYIdE( (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1, (struct $7FBARRAYIdE*)&tmp$37$1 );
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOC1ER7FBARRAYIdE( (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1 + 16ll), (struct $7FBARRAYIdE*)&tmp$38$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double**)FOOTB$1 == (double*)ARR1$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 37, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.LOCAL", (char*)"CU_ASSERT(footb(1).array = @arr1(1))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1 + 8ll) == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 38, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.LOCAL", (char*)"CU_ASSERT(footb(1).items = 3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double**)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1 + 16ll) == (double*)ARR2$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 39, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.LOCAL", (char*)"CU_ASSERT(footb(2).array = @arr2(1))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1 + 24ll) == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 40, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.LOCAL", (char*)"CU_ASSERT(footb(2).items = 4)" );
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7DO_TESTER7FBARRAYINS2_3FOOEE( (struct $7FBARRAYIN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE*)&tmp$39$1 );
	label$15:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC12STATIC_LOCALEv( void )
{
	label$18:;
	static double ARR1$1[3] = { 0x1.p+0, 0x1.p+1, 0x1.8p+1 };
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$3IdEE {
		double* DATA;
		double* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$3IdEE ) == 72 );
	static struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$3IdEE tmp$56$1 = { (double*)((uint8*)ARR1$1 + -8ll), (double*)ARR1$1, 24ll, 8ll, 1ll, 49ll, { { 3ll, 1ll, 3ll } } };
	static double ARR2$1[4] = { -0x1.p+0, -0x1.p+1, -0x1.8p+1, -0x1.p+2 };
	static struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$3IdEE tmp$57$1 = { (double*)((uint8*)ARR2$1 + -8ll), (double*)ARR2$1, 32ll, 8ll, 1ll, 49ll, { { 4ll, 1ll, 4ll } } };
	static struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE FOOTB$1[2];
	struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$4INS2_3FOOEEE {
		struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE* DATA;
		struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$4INS2_3FOOEEE ) == 72 );
	static struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10FBARRAY1$4INS2_3FOOEEE tmp$58$1 = { (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)((uint8*)FOOTB$1 + -16ll), (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1, 32ll, 16ll, 1ll, 49ll, { { 2ll, 1ll, 2ll } } };
	static int64 LABEL$20$1;
	if( LABEL$20$1 != 0ll) goto label$21;
	LABEL$20$1 = 1ll;
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOC1ER7FBARRAYIdE( (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1, (struct $7FBARRAYIdE*)&tmp$56$1 );
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOC1ER7FBARRAYIdE( (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)((uint8*)FOOTB$1 + 16ll), (struct $7FBARRAYIdE*)&tmp$57$1 );
	label$21:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double**)FOOTB$1 == (double*)ARR1$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 50, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.STATIC_LOCAL", (char*)"CU_ASSERT(footb(1).array = @arr1(1))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1 + 8ll) == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 51, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.STATIC_LOCAL", (char*)"CU_ASSERT(footb(1).items = 3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double**)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1 + 16ll) == (double*)ARR2$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 52, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.STATIC_LOCAL", (char*)"CU_ASSERT(footb(2).array = @arr2(1))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)FOOTB$1 + 24ll) == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 53, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.STATIC_LOCAL", (char*)"CU_ASSERT(footb(2).items = 4)" );
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7DO_TESTER7FBARRAYINS2_3FOOEE( (struct $7FBARRAYIN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE*)&tmp$58$1 );
	label$19:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC6GLOBALEv( void )
{
	label$24:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double**)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E == (double*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR1$E) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 64, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.GLOBAL", (char*)"CU_ASSERT(g_footb(1).array = @g_arr1(1))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E + 8ll) == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 65, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.GLOBAL", (char*)"CU_ASSERT(g_footb(1).items = 3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double**)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E + 16ll) == (double*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR2$E) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 66, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.GLOBAL", (char*)"CU_ASSERT(g_footb(2).array = @g_arr2(1))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E + 24ll) == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 67, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.GLOBAL", (char*)"CU_ASSERT(g_footb(2).items = 4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double**)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E + 32ll) == (double*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7G_ARR3$E) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 68, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.GLOBAL", (char*)"CU_ASSERT(g_footb(3).array = @g_arr3(1))" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((int64)(struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E + 40ll) == 5ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5C" "ctor_bydesc.bas", 69, (char*)"TESTS.FBC_TESTS.STRUCTS.CTOR_BYDESC.GLOBAL", (char*)"CU_ASSERT(g_footb(3).items = 5)" );
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7DO_TESTER7FBARRAYINS2_3FOOEE( (struct $7FBARRAYIN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOEE*)&_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7tmp$64$E );
	label$25:;
}

__attribute__(( constructor )) static void fb_ctor__ctor_bydesc( void )
{
	label$0:;
	label$1:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC10LOCAL_CTOREv( void )
{
	label$16:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.ctor_bydesc", (char*)"local", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC5LOCALEv, (boolean)0ll );
	label$17:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC17STATIC_LOCAL_CTOREv( void )
{
	label$22:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.ctor_bydesc", (char*)"static_local", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC12STATIC_LOCALEv, (boolean)0ll );
	label$23:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC11GLOBAL_CTOREv( void )
{
	label$26:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.ctor_bydesc", (char*)"global", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC6GLOBALEv, (boolean)0ll );
	label$27:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC12SUITE_CTOR74Ev( void )
{
	label$28:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.structs.ctor_bydesc", (tmp$4)0ull, (tmp$4)0ull );
	label$29:;
}

__attribute__(( constructor )) static void _GLOBAL__I( void )
{
	label$31:;
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOC1ER7FBARRAYIdE( (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E, (struct $7FBARRAYIdE*)&_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7tmp$61$E );
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOC1ER7FBARRAYIdE( (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)((uint8*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E + 16ll), (struct $7FBARRAYIdE*)&_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7tmp$62$E );
	_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOC1ER7FBARRAYIdE( (struct $N5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC3FOOE*)((uint8*)_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC8G_FOOTB$E + 32ll), (struct $7FBARRAYIdE*)&_ZN5TESTS9FBC_TESTS7STRUCTS11CTOR_BYDESC7tmp$63$E );
	label$32:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
