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
struct $N2FB3RNGE {
	uint64 S0;
	uint64 S1;
	uint64 S2;
	uint64 S3;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $N2FB3RNGE ) == 32 );
struct $N2FB5VEC3DE {
	double X;
	double Y;
	double Z;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5VEC3DE ) == 24 );
struct $N2FB5VEC3FE {
	float X;
	float Y;
	float Z;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5VEC3FE ) == 12 );
struct $N2FB5MAT4DE {
	double M[16];
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5MAT4DE ) == 128 );
struct $N2FB5QUATDE {
	double X;
	double Y;
	double Z;
	double W;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5QUATDE ) == 32 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
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
int64 fb_ArrayLBound( struct $7FBARRAYIKvE*, int64 );
int64 fb_ArrayUBound( struct $7FBARRAYIKvE*, int64 );
void fb_StrSwap( void*, int64, int32, void*, int64, int32 );
static void fb_ctor__vector( void ) __attribute__(( constructor ));
typedef void (*tmp$5)( void );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
struct $N2FB5VEC2FE {
	float X;
	float Y;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5VEC2FE ) == 8 );
static struct $N2FB5VEC2FE _ZN2FB6VEC2F_Eff( float, float );
static struct $N2FB5VEC3FE _ZN2FB6VEC3F_Efff( float, float, float );
struct $N2FB5VEC4FE {
	float X;
	float Y;
	float Z;
	float W;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5VEC4FE ) == 16 );
static struct $N2FB5VEC4FE _ZN2FB6VEC4F_Effff( float, float, float, float );
static struct $N2FB5VEC3FE _ZN2FBmiERNS_5VEC3FES1_( struct $N2FB5VEC3FE*, struct $N2FB5VEC3FE* );
static float _ZN2FB3DOTERNS_5VEC2FES1_( struct $N2FB5VEC2FE*, struct $N2FB5VEC2FE* );
static float _ZN2FB3DOTERNS_5VEC3FES1_( struct $N2FB5VEC3FE*, struct $N2FB5VEC3FE* );
static float _ZN2FB3DOTERNS_5VEC4FES1_( struct $N2FB5VEC4FE*, struct $N2FB5VEC4FE* );
static struct $N2FB5VEC3FE _ZN2FB5CROSSERNS_5VEC3FES1_( struct $N2FB5VEC3FE*, struct $N2FB5VEC3FE* );
static float _ZN2FB15DISTANCESQUAREDERNS_5VEC3FES1_( struct $N2FB5VEC3FE*, struct $N2FB5VEC3FE* );
static struct $N2FB5VEC3FE _ZN2FB9NORMALIZEERNS_5VEC3FE( struct $N2FB5VEC3FE* );
struct $N2FB5VEC2DE {
	double X;
	double Y;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5VEC2DE ) == 16 );
static struct $N2FB5VEC2DE _ZN2FB6VEC2D_Edd( double, double );
static struct $N2FB5VEC3DE _ZN2FB6VEC3D_Eddd( double, double, double );
struct $N2FB5VEC4DE {
	double X;
	double Y;
	double Z;
	double W;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5VEC4DE ) == 32 );
static struct $N2FB5VEC4DE _ZN2FB6VEC4D_Edddd( double, double, double, double );
static struct $N2FB5VEC3DE _ZN2FBplERNS_5VEC3DES1_( struct $N2FB5VEC3DE*, struct $N2FB5VEC3DE* );
static struct $N2FB5VEC3DE _ZN2FBmiERNS_5VEC3DES1_( struct $N2FB5VEC3DE*, struct $N2FB5VEC3DE* );
static double _ZN2FB3DOTERNS_5VEC2DES1_( struct $N2FB5VEC2DE*, struct $N2FB5VEC2DE* );
static double _ZN2FB3DOTERNS_5VEC3DES1_( struct $N2FB5VEC3DE*, struct $N2FB5VEC3DE* );
static double _ZN2FB3DOTERNS_5VEC4DES1_( struct $N2FB5VEC4DE*, struct $N2FB5VEC4DE* );
static struct $N2FB5VEC3DE _ZN2FB5CROSSERNS_5VEC3DES1_( struct $N2FB5VEC3DE*, struct $N2FB5VEC3DE* );
static double _ZN2FB13LENGTHSQUAREDERNS_5VEC3DE( struct $N2FB5VEC3DE* );
static double _ZN2FB6LENGTHERNS_5VEC3DE( struct $N2FB5VEC3DE* );
static double _ZN2FB15DISTANCESQUAREDERNS_5VEC3DES1_( struct $N2FB5VEC3DE*, struct $N2FB5VEC3DE* );
static struct $N2FB5VEC3DE _ZN2FB9NORMALIZEERNS_5VEC3DE( struct $N2FB5VEC3DE* );
static double _ZN2FB5ANGLEERNS_5VEC3DES1_( struct $N2FB5VEC3DE*, struct $N2FB5VEC3DE* );
struct $N2FB5MAT4FE {
	float M[16];
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5MAT4FE ) == 64 );
static struct $N2FB5MAT4FE _ZN2FB13MAT4FIDENTITYEv( void );
static struct $N2FB5MAT4DE _ZN2FB13MAT4DIDENTITYEv( void );
static struct $N2FB5MAT4DE _ZN2FB16MAT4DTRANSLATIONEddd( double, double, double );
static struct $N2FB5MAT4DE _ZN2FB12MAT4DSCALINGEddd( double, double, double );
static struct $N2FB5MAT4DE _ZN2FB14MAT4DROTATIONYEd( double );
static struct $N2FB5MAT4DE _ZN2FBmlERNS_5MAT4DES1_( struct $N2FB5MAT4DE*, struct $N2FB5MAT4DE* );
static boolean _ZN2FBeqERNS_5MAT4DES1_( struct $N2FB5MAT4DE*, struct $N2FB5MAT4DE* );
static struct $N2FB5VEC3DE _ZN2FB14TRANSFORMPOINTERNS_5MAT4DERNS_5VEC3DE( struct $N2FB5MAT4DE*, struct $N2FB5VEC3DE* );
static struct $N2FB5VEC3DE _ZN2FB15TRANSFORMVECTORERNS_5MAT4DERNS_5VEC3DE( struct $N2FB5MAT4DE*, struct $N2FB5VEC3DE* );
static struct $N2FB5MAT4DE _ZN2FB9TRANSPOSEERNS_5MAT4DE( struct $N2FB5MAT4DE* );
static double _ZN2FB11DETERMINANTERNS_5MAT4DE( struct $N2FB5MAT4DE* );
static boolean _ZN2FB10TRYINVERSEERNS_5MAT4DES1_( struct $N2FB5MAT4DE*, struct $N2FB5MAT4DE* );
struct $N2FB5QUATFE {
	float X;
	float Y;
	float Z;
	float W;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB5QUATFE ) == 16 );
static struct $N2FB5QUATFE _ZN2FB6QUATF_Effff( float, float, float, float );
static struct $N2FB5QUATFE _ZN2FB13QUATFIDENTITYEv( void );
static float _ZN2FB3DOTERNS_5QUATFES1_( struct $N2FB5QUATFE*, struct $N2FB5QUATFE* );
static struct $N2FB5QUATFE _ZN2FB9NORMALIZEERNS_5QUATFE( struct $N2FB5QUATFE* );
static struct $N2FB5QUATDE _ZN2FB6QUATD_Edddd( double, double, double, double );
static struct $N2FB5QUATDE _ZN2FB13QUATDIDENTITYEv( void );
static struct $N2FB5QUATDE _ZN2FB18QUATDFROMAXISANGLEERNS_5VEC3DEd( struct $N2FB5VEC3DE*, double );
static struct $N2FB5QUATDE _ZN2FBmlERNS_5QUATDES1_( struct $N2FB5QUATDE*, struct $N2FB5QUATDE* );
static struct $N2FB5QUATDE _ZN2FB9CONJUGATEERNS_5QUATDE( struct $N2FB5QUATDE* );
static double _ZN2FB3DOTERNS_5QUATDES1_( struct $N2FB5QUATDE*, struct $N2FB5QUATDE* );
static double _ZN2FB6LENGTHERNS_5QUATDE( struct $N2FB5QUATDE* );
static struct $N2FB5QUATDE _ZN2FB9NORMALIZEERNS_5QUATDE( struct $N2FB5QUATDE* );
static struct $N2FB5VEC3DE _ZN2FB6ROTATEERNS_5QUATDERNS_5VEC3DE( struct $N2FB5QUATDE*, struct $N2FB5VEC3DE* );
static struct $N2FB5MAT4DE _ZN2FB8TOMATRIXERNS_5QUATDE( struct $N2FB5QUATDE* );
static struct $N2FB5QUATDE _ZN2FB5SLERPERNS_5QUATDES1_d( struct $N2FB5QUATDE*, struct $N2FB5QUATDE*, double );
static uint64 _ZN2FB3RNG12NEXTULONGINTEv( struct $N2FB3RNGE* );
static int64 _ZN2FB3RNG7NEXTINTExx( struct $N2FB3RNGE*, int64, int64 );
static double _ZN2FB3RNG10NEXTDOUBLEEv( struct $N2FB3RNGE* );
static double _ZN2FB3RNG15NEXTDOUBLERANGEEdd( struct $N2FB3RNGE*, double, double );
static double _ZN2FB3RNG10NEXTNORMALEv( struct $N2FB3RNGE* );
static uint64 _ZN2FB11HSPLITMIX64ERy( uint64* );
static uint64 _ZN2FB7HROTL64Eyi( uint64, int32 );
static struct $N2FB3RNGE _ZN2FB9RNGSEEDEDEy( uint64 );
static uint64 _ZN2FB10HMULHIGH64EyyRy( uint64, uint64, uint64* );
int8 SystemFunction036( void*, uint32 );
static boolean _ZN2FB11CRYPTOBYTESEPvj( void*, uint32 );
static uint64 _ZN2FB14CRYPTOULONGINTEv( void );
void _ZN5TESTS9FBC_TESTS4MATH3VEC18VECTOR_IDENTITIES_Ev( void );
static void _ZN5TESTS9FBC_TESTS4MATH3VEC23VECTOR_IDENTITIES__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4MATH3VEC12ZERO_VECTOR_Ev( void );
static void _ZN5TESTS9FBC_TESTS4MATH3VEC17ZERO_VECTOR__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4MATH3VEC18MATRIX_IDENTITIES_Ev( void );
static void _ZN5TESTS9FBC_TESTS4MATH3VEC23MATRIX_IDENTITIES__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4MATH3VEC20POINT_VERSUS_VECTOR_Ev( void );
static void _ZN5TESTS9FBC_TESTS4MATH3VEC25POINT_VERSUS_VECTOR__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4MATH3VEC22QUATERNION_IDENTITIES_Ev( void );
static void _ZN5TESTS9FBC_TESTS4MATH3VEC27QUATERNION_IDENTITIES__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4MATH3VEC6SLERP_Ev( void );
static void _ZN5TESTS9FBC_TESTS4MATH3VEC11SLERP__CTOREv( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS4MATH3VEC18VECTOR_IDENTITIES_Ev( void )
{
	label$554:;
	struct $N2FB3RNGE R$1;
	struct $N2FB3RNGE vr$0 = _ZN2FB9RNGSEEDEDEy( 31337ull );
	R$1 = vr$0;
	{
		int32 K$2;
		K$2 = 1;
		label$559:;
		{
			struct $N2FB5VEC3DE TMP$65$3;
			struct $N2FB5VEC3DE A$3;
			double vr$2 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.4p+3, 0x1.4p+3 );
			double vr$4 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.4p+3, 0x1.4p+3 );
			double vr$6 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.4p+3, 0x1.4p+3 );
			struct $N2FB5VEC3DE vr$7 = _ZN2FB6VEC3D_Eddd( vr$6, vr$4, vr$2 );
			A$3 = vr$7;
			struct $N2FB5VEC3DE B$3;
			double vr$9 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.4p+3, 0x1.4p+3 );
			double vr$11 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.4p+3, 0x1.4p+3 );
			double vr$13 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.4p+3, 0x1.4p+3 );
			struct $N2FB5VEC3DE vr$14 = _ZN2FB6VEC3D_Eddd( vr$13, vr$11, vr$9 );
			B$3 = vr$14;
			struct $N2FB5VEC3DE N$3;
			struct $N2FB5VEC3DE vr$16 = _ZN2FB9NORMALIZEERNS_5VEC3DE( &A$3 );
			N$3 = vr$16;
			double vr$18 = _ZN2FB6LENGTHERNS_5VEC3DE( &N$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (vr$18 + -0x1.p+0) ) < 0x1.19799812DEA11p-40) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 27, (char*)"TESTS.FBC_TESTS.MATH.VEC.VECTOR_IDENTITIES_", (char*)"CU_ASSERT(abs( Length( n ) - 1.0 ) < 1e-12)" );
			struct $N2FB5VEC3DE C$3;
			struct $N2FB5VEC3DE vr$25 = _ZN2FB5CROSSERNS_5VEC3DES1_( &A$3, &B$3 );
			C$3 = vr$25;
			double vr$28 = _ZN2FB3DOTERNS_5VEC3DES1_( &C$3, &A$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( vr$28 ) < 0x1.5798EE2308C3Ap-27) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 31, (char*)"TESTS.FBC_TESTS.MATH.VEC.VECTOR_IDENTITIES_", (char*)"CU_ASSERT(abs( Dot( c, a ) ) < 1e-8)" );
			double vr$34 = _ZN2FB3DOTERNS_5VEC3DES1_( &C$3, &B$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( vr$34 ) < 0x1.5798EE2308C3Ap-27) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 32, (char*)"TESTS.FBC_TESTS.MATH.VEC.VECTOR_IDENTITIES_", (char*)"CU_ASSERT(abs( Dot( c, b ) ) < 1e-8)" );
			struct $N2FB5VEC3DE C2$3;
			struct $N2FB5VEC3DE vr$40 = _ZN2FB5CROSSERNS_5VEC3DES1_( &B$3, &A$3 );
			C2$3 = vr$40;
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (*(double*)&C$3 + *(double*)&C2$3) ) < 0x1.19799812DEA11p-40) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 34, (char*)"TESTS.FBC_TESTS.MATH.VEC.VECTOR_IDENTITIES_", (char*)"CU_ASSERT(abs( c.x + c2.x ) < 1e-12)" );
			struct $N2FB5VEC3DE vr$47 = _ZN2FBplERNS_5VEC3DES1_( &A$3, &B$3 );
			TMP$65$3 = vr$47;
			double vr$49 = _ZN2FB6LENGTHERNS_5VEC3DE( &TMP$65$3 );
			double vr$51 = _ZN2FB6LENGTHERNS_5VEC3DE( &A$3 );
			double vr$53 = _ZN2FB6LENGTHERNS_5VEC3DE( &B$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$49 <= ((vr$51 + vr$53) + 0x1.12E0BE826D695p-30)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 37, (char*)"TESTS.FBC_TESTS.MATH.VEC.VECTOR_IDENTITIES_", (char*)"CU_ASSERT(Length( a + b ) <= Length( a ) + Length( b ) + 1e-9)" );
			double LHS$3;
			double vr$60 = _ZN2FB3DOTERNS_5VEC3DES1_( &A$3, &B$3 );
			LHS$3 = vr$60;
			double RHS$3;
			double vr$62 = _ZN2FB6LENGTHERNS_5VEC3DE( &A$3 );
			double vr$64 = _ZN2FB6LENGTHERNS_5VEC3DE( &B$3 );
			double vr$68 = _ZN2FB5ANGLEERNS_5VEC3DES1_( &A$3, &B$3 );
			RHS$3 = (vr$62 * vr$64) * __builtin_cos( vr$68 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (LHS$3 - RHS$3) ) < 0x1.5798EE2308C3Ap-27) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 42, (char*)"TESTS.FBC_TESTS.MATH.VEC.VECTOR_IDENTITIES_", (char*)"CU_ASSERT(abs( lhs - rhs ) < 1e-8)" );
			double vr$76 = _ZN2FB13LENGTHSQUAREDERNS_5VEC3DE( &A$3 );
			double vr$78 = _ZN2FB6LENGTHERNS_5VEC3DE( &A$3 );
			double vr$80 = _ZN2FB6LENGTHERNS_5VEC3DE( &A$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (vr$76 - (vr$78 * vr$80)) ) < 0x1.5798EE2308C3Ap-27) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 45, (char*)"TESTS.FBC_TESTS.MATH.VEC.VECTOR_IDENTITIES_", (char*)"CU_ASSERT(abs( LengthSquared( a ) - Length( a ) * Length( a ) ) < 1e-8)" );
		}
		label$557:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$556:;
		if( (int64)K$2 <= 20000ll) goto label$559;
		label$558:;
	}
	label$555:;
}

void _ZN5TESTS9FBC_TESTS4MATH3VEC12ZERO_VECTOR_Ev( void )
{
	struct $N2FB5VEC3DE TMP$77$1;
	struct $N2FB5VEC3FE TMP$91$1;
	struct $N2FB5VEC3DE TMP$95$1;
	struct $N2FB5VEC3DE TMP$99$1;
	label$562:;
	struct $N2FB5VEC3DE Z$1;
	struct $N2FB5VEC3DE vr$0 = _ZN2FB6VEC3D_Eddd( 0x0p+0, 0x0p+0, 0x0p+0 );
	TMP$77$1 = vr$0;
	struct $N2FB5VEC3DE vr$2 = _ZN2FB9NORMALIZEERNS_5VEC3DE( &TMP$77$1 );
	Z$1 = vr$2;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)&Z$1 == 0x0p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 54, (char*)"TESTS.FBC_TESTS.MATH.VEC.ZERO_VECTOR_", (char*)"CU_ASSERT(z.x = 0.0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&Z$1 + 8ll) == 0x0p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 55, (char*)"TESTS.FBC_TESTS.MATH.VEC.ZERO_VECTOR_", (char*)"CU_ASSERT(z.y = 0.0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&Z$1 + 16ll) == 0x0p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 56, (char*)"TESTS.FBC_TESTS.MATH.VEC.ZERO_VECTOR_", (char*)"CU_ASSERT(z.z = 0.0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(!(*(double*)&Z$1 != *(double*)&Z$1)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 57, (char*)"TESTS.FBC_TESTS.MATH.VEC.ZERO_VECTOR_", (char*)"CU_ASSERT(( z.x <> z.x ) = 0)" );
	struct $N2FB5VEC3FE ZF$1;
	struct $N2FB5VEC3FE vr$11 = _ZN2FB6VEC3F_Efff( 0x0p+0f, 0x0p+0f, 0x0p+0f );
	TMP$91$1 = vr$11;
	struct $N2FB5VEC3FE vr$13 = _ZN2FB9NORMALIZEERNS_5VEC3FE( &TMP$91$1 );
	ZF$1 = vr$13;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(float*)&ZF$1 == 0x0p+0f) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 60, (char*)"TESTS.FBC_TESTS.MATH.VEC.ZERO_VECTOR_", (char*)"CU_ASSERT(zf.x = 0.0f)" );
	struct $N2FB5VEC3DE vr$16 = _ZN2FB6VEC3D_Eddd( 0x1.8p+1, 0x1.p+2, 0x0p+0 );
	TMP$95$1 = vr$16;
	double vr$18 = _ZN2FB6LENGTHERNS_5VEC3DE( &TMP$95$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$18 == 0x1.4p+2) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 62, (char*)"TESTS.FBC_TESTS.MATH.VEC.ZERO_VECTOR_", (char*)"CU_ASSERT(Length( Vec3d_( 3, 4, 0 ) ) = 5.0)" );
	struct $N2FB5VEC3DE vr$21 = _ZN2FB6VEC3D_Eddd( 0x0p+0, 0x0p+0, 0x0p+0 );
	TMP$99$1 = vr$21;
	double vr$23 = _ZN2FB6LENGTHERNS_5VEC3DE( &TMP$99$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$23 == 0x0p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 63, (char*)"TESTS.FBC_TESTS.MATH.VEC.ZERO_VECTOR_", (char*)"CU_ASSERT(Length( Vec3d_( 0, 0, 0 ) ) = 0.0)" );
	label$563:;
}

void _ZN5TESTS9FBC_TESTS4MATH3VEC18MATRIX_IDENTITIES_Ev( void )
{
	struct $N2FB5MAT4DE TMP$113$1;
	struct $N2FB5MAT4DE TMP$114$1;
	struct $N2FB5MAT4DE TMP$118$1;
	struct $N2FB5MAT4DE TMP$122$1;
	label$566:;
	struct $N2FB3RNGE R$1;
	struct $N2FB3RNGE vr$0 = _ZN2FB9RNGSEEDEDEy( 4242ull );
	R$1 = vr$0;
	struct $N2FB5MAT4DE ID$1;
	struct $N2FB5MAT4DE vr$1 = _ZN2FB13MAT4DIDENTITYEv(  );
	ID$1 = vr$1;
	{
		int32 K$2;
		K$2 = 1;
		label$571:;
		{
			struct $N2FB5MAT4DE M$3;
			__builtin_memset( &M$3, 0, 128ll );
			{
				int32 I$4;
				I$4 = 0;
				label$575:;
				{
					double vr$4 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.8p+1, 0x1.8p+1 );
					*(double*)((uint8*)&M$3 + ((int64)I$4 << (3ll & 63ll))) = vr$4;
				}
				label$573:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$572:;
				if( (int64)I$4 <= 15ll) goto label$575;
				label$574:;
			}
			struct $N2FB5MAT4DE INV$3;
			__builtin_memset( &INV$3, 0, 128ll );
			boolean vr$16 = _ZN2FB10TRYINVERSEERNS_5MAT4DES1_( &M$3, &INV$3 );
			if( vr$16 == (boolean)0ll) goto label$577;
			{
				struct $N2FB5MAT4DE P$4;
				struct $N2FB5MAT4DE vr$19 = _ZN2FBmlERNS_5MAT4DES1_( &M$3, &INV$3 );
				P$4 = vr$19;
				double WORST$4;
				WORST$4 = 0x0p+0;
				{
					int32 I$5;
					I$5 = 0;
					label$581:;
					{
						double WANT$6;
						WANT$6 = *(double*)((uint8*)&ID$1 + ((int64)I$5 << (3ll & 63ll)));
						double GOT$6;
						GOT$6 = *(double*)((uint8*)&P$4 + ((int64)I$5 << (3ll & 63ll)));
						double E$6;
						E$6 = __builtin_fabs( (GOT$6 - WANT$6) );
						if( !(E$6 > WORST$4)) goto label$583;
						{
							WORST$4 = E$6;
							label$583:;
						}
					}
					label$579:;
					I$5 = (int32)((int64)I$5 + 1ll);
					label$578:;
					if( (int64)I$5 <= 15ll) goto label$581;
					label$580:;
				}
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(WORST$4 < 0x1.0C6F7A0B5ED8Dp-20) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 87, (char*)"TESTS.FBC_TESTS.MATH.VEC.MATRIX_IDENTITIES_", (char*)"CU_ASSERT(worst < 1e-6)" );
			}
			label$577:;
			label$576:;
		}
		label$569:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$568:;
		if( (int64)K$2 <= 3000ll) goto label$571;
		label$570:;
	}
	{
		int32 K$2;
		K$2 = 1;
		label$587:;
		{
			struct $N2FB5MAT4DE TMP$109$3;
			struct $N2FB5MAT4DE A$3;
			__builtin_memset( &A$3, 0, 128ll );
			struct $N2FB5MAT4DE B$3;
			__builtin_memset( &B$3, 0, 128ll );
			{
				int32 I$4;
				I$4 = 0;
				label$591:;
				{
					double vr$43 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.p+1, 0x1.p+1 );
					*(double*)((uint8*)&A$3 + ((int64)I$4 << (3ll & 63ll))) = vr$43;
					double vr$49 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.p+1, 0x1.p+1 );
					*(double*)((uint8*)&B$3 + ((int64)I$4 << (3ll & 63ll))) = vr$49;
				}
				label$589:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$588:;
				if( (int64)I$4 <= 15ll) goto label$591;
				label$590:;
			}
			double LHS$3;
			struct $N2FB5MAT4DE vr$60 = _ZN2FBmlERNS_5MAT4DES1_( &A$3, &B$3 );
			TMP$109$3 = vr$60;
			double vr$62 = _ZN2FB11DETERMINANTERNS_5MAT4DE( &TMP$109$3 );
			LHS$3 = vr$62;
			double RHS$3;
			double vr$64 = _ZN2FB11DETERMINANTERNS_5MAT4DE( &A$3 );
			double vr$66 = _ZN2FB11DETERMINANTERNS_5MAT4DE( &B$3 );
			RHS$3 = vr$64 * vr$66;
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (LHS$3 - RHS$3) ) <= ((__builtin_fabs( RHS$3 ) * 0x1.0C6F7A0B5ED8Dp-20) + 0x1.0C6F7A0B5ED8Dp-20)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 100, (char*)"TESTS.FBC_TESTS.MATH.VEC.MATRIX_IDENTITIES_", (char*)"CU_ASSERT(abs( lhs - rhs ) <= 1e-6 * ( 1.0 + abs( rhs ) ))" );
		}
		label$585:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$584:;
		if( (int64)K$2 <= 2000ll) goto label$587;
		label$586:;
	}
	struct $N2FB5MAT4DE T$1;
	struct $N2FB5MAT4DE vr$79 = _ZN2FB16MAT4DTRANSLATIONEddd( 0x1.p+0, 0x1.p+1, 0x1.8p+1 );
	T$1 = vr$79;
	struct $N2FB5MAT4DE vr$82 = _ZN2FB9TRANSPOSEERNS_5MAT4DE( &T$1 );
	TMP$113$1 = vr$82;
	struct $N2FB5MAT4DE vr$84 = _ZN2FB9TRANSPOSEERNS_5MAT4DE( &TMP$113$1 );
	TMP$114$1 = vr$84;
	boolean vr$86 = _ZN2FBeqERNS_5MAT4DES1_( &TMP$114$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$86, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 105, (char*)"TESTS.FBC_TESTS.MATH.VEC.MATRIX_IDENTITIES_", (char*)"CU_ASSERT(Transpose( Transpose( t ) ) = t)" );
	struct $N2FB5MAT4DE vr$90 = _ZN2FBmlERNS_5MAT4DES1_( &T$1, &ID$1 );
	TMP$118$1 = vr$90;
	boolean vr$92 = _ZN2FBeqERNS_5MAT4DES1_( &TMP$118$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$92, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 106, (char*)"TESTS.FBC_TESTS.MATH.VEC.MATRIX_IDENTITIES_", (char*)"CU_ASSERT(( t * id ) = t)" );
	struct $N2FB5MAT4DE vr$96 = _ZN2FBmlERNS_5MAT4DES1_( &ID$1, &T$1 );
	TMP$122$1 = vr$96;
	boolean vr$98 = _ZN2FBeqERNS_5MAT4DES1_( &TMP$122$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$98, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 107, (char*)"TESTS.FBC_TESTS.MATH.VEC.MATRIX_IDENTITIES_", (char*)"CU_ASSERT(( id * t ) = t)" );
	double vr$100 = _ZN2FB11DETERMINANTERNS_5MAT4DE( &ID$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$100 == 0x1.p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 108, (char*)"TESTS.FBC_TESTS.MATH.VEC.MATRIX_IDENTITIES_", (char*)"CU_ASSERT(Determinant( id ) = 1.0)" );
	struct $N2FB5MAT4DE SING$1;
	__builtin_memset( &SING$1, 0, 128ll );
	{
		int32 I$2;
		I$2 = 0;
		label$595:;
		{
			*(double*)((uint8*)&SING$1 + ((int64)I$2 << (3ll & 63ll))) = 0x0p+0;
		}
		label$593:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$592:;
		if( (int64)I$2 <= 15ll) goto label$595;
		label$594:;
	}
	struct $N2FB5MAT4DE JUNK$1;
	__builtin_memset( &JUNK$1, 0, 128ll );
	boolean vr$115 = _ZN2FB10TRYINVERSEERNS_5MAT4DES1_( &SING$1, &JUNK$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$115 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 116, (char*)"TESTS.FBC_TESTS.MATH.VEC.MATRIX_IDENTITIES_", (char*)"CU_ASSERT(TryInverse( sing, junk ) = false)" );
	label$567:;
}

void _ZN5TESTS9FBC_TESTS4MATH3VEC20POINT_VERSUS_VECTOR_Ev( void )
{
	struct $N2FB5MAT4DE TMP$153$1;
	struct $N2FB5VEC3DE TMP$154$1;
	struct $N2FB5MAT4DE TMP$155$1;
	struct $N2FB5VEC3DE TMP$156$1;
	struct $N2FB5VEC3DE TMP$163$1;
	label$598:;
	struct $N2FB5MAT4DE T$1;
	struct $N2FB5MAT4DE vr$0 = _ZN2FB16MAT4DTRANSLATIONEddd( 0x1.4p+3, 0x1.4p+4, 0x1.Ep+4 );
	T$1 = vr$0;
	struct $N2FB5VEC3DE V$1;
	struct $N2FB5VEC3DE vr$1 = _ZN2FB6VEC3D_Eddd( 0x1.p+0, 0x1.p+1, 0x1.8p+1 );
	V$1 = vr$1;
	struct $N2FB5VEC3DE P$1;
	struct $N2FB5VEC3DE vr$4 = _ZN2FB14TRANSFORMPOINTERNS_5MAT4DERNS_5VEC3DE( &T$1, &V$1 );
	P$1 = vr$4;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)&P$1 == 0x1.6p+3) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 126, (char*)"TESTS.FBC_TESTS.MATH.VEC.POINT_VERSUS_VECTOR_", (char*)"CU_ASSERT(p.x = 11.0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&P$1 + 8ll) == 0x1.6p+4) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 127, (char*)"TESTS.FBC_TESTS.MATH.VEC.POINT_VERSUS_VECTOR_", (char*)"CU_ASSERT(p.y = 22.0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&P$1 + 16ll) == 0x1.08p+5) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 128, (char*)"TESTS.FBC_TESTS.MATH.VEC.POINT_VERSUS_VECTOR_", (char*)"CU_ASSERT(p.z = 33.0)" );
	struct $N2FB5VEC3DE D$1;
	struct $N2FB5VEC3DE vr$13 = _ZN2FB15TRANSFORMVECTORERNS_5MAT4DERNS_5VEC3DE( &T$1, &V$1 );
	D$1 = vr$13;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)&D$1 == 0x1.p+0) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 131, (char*)"TESTS.FBC_TESTS.MATH.VEC.POINT_VERSUS_VECTOR_", (char*)"CU_ASSERT(d.x = 1.0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&D$1 + 8ll) == 0x1.p+1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 132, (char*)"TESTS.FBC_TESTS.MATH.VEC.POINT_VERSUS_VECTOR_", (char*)"CU_ASSERT(d.y = 2.0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)((uint8*)&D$1 + 16ll) == 0x1.8p+1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 133, (char*)"TESTS.FBC_TESTS.MATH.VEC.POINT_VERSUS_VECTOR_", (char*)"CU_ASSERT(d.z = 3.0)" );
	struct $N2FB5MAT4DE S$1;
	struct $N2FB5MAT4DE vr$20 = _ZN2FB12MAT4DSCALINGEddd( 0x1.p+1, 0x1.p+1, 0x1.p+1 );
	S$1 = vr$20;
	struct $N2FB5VEC3DE TS$1;
	struct $N2FB5VEC3DE vr$21 = _ZN2FB6VEC3D_Eddd( 0x1.p+0, 0x1.p+0, 0x1.p+0 );
	TMP$154$1 = vr$21;
	struct $N2FB5MAT4DE vr$25 = _ZN2FBmlERNS_5MAT4DES1_( &T$1, &S$1 );
	TMP$153$1 = vr$25;
	struct $N2FB5VEC3DE vr$27 = _ZN2FB14TRANSFORMPOINTERNS_5MAT4DERNS_5VEC3DE( &TMP$153$1, &TMP$154$1 );
	TS$1 = vr$27;
	struct $N2FB5VEC3DE ST$1;
	struct $N2FB5VEC3DE vr$28 = _ZN2FB6VEC3D_Eddd( 0x1.p+0, 0x1.p+0, 0x1.p+0 );
	TMP$156$1 = vr$28;
	struct $N2FB5MAT4DE vr$32 = _ZN2FBmlERNS_5MAT4DES1_( &S$1, &T$1 );
	TMP$155$1 = vr$32;
	struct $N2FB5VEC3DE vr$34 = _ZN2FB14TRANSFORMPOINTERNS_5MAT4DERNS_5VEC3DE( &TMP$155$1, &TMP$156$1 );
	ST$1 = vr$34;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)&TS$1 == 0x1.8p+3) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 141, (char*)"TESTS.FBC_TESTS.MATH.VEC.POINT_VERSUS_VECTOR_", (char*)"CU_ASSERT(ts.x = 12.0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(double*)&ST$1 == 0x1.6p+4) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 142, (char*)"TESTS.FBC_TESTS.MATH.VEC.POINT_VERSUS_VECTOR_", (char*)"CU_ASSERT(st.x = 22.0)" );
	struct $N2FB5MAT4DE RY$1;
	struct $N2FB5MAT4DE vr$39 = _ZN2FB14MAT4DROTATIONYEd( 0x1.6666666666666p-1 );
	RY$1 = vr$39;
	struct $N2FB5VEC3DE RV$1;
	struct $N2FB5VEC3DE vr$40 = _ZN2FB6VEC3D_Eddd( 0x1.p+0, 0x0p+0, 0x0p+0 );
	TMP$163$1 = vr$40;
	struct $N2FB5VEC3DE vr$43 = _ZN2FB15TRANSFORMVECTORERNS_5MAT4DERNS_5VEC3DE( &RY$1, &TMP$163$1 );
	RV$1 = vr$43;
	double vr$45 = _ZN2FB6LENGTHERNS_5VEC3DE( &RV$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (vr$45 + -0x1.p+0) ) < 0x1.19799812DEA11p-40) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 147, (char*)"TESTS.FBC_TESTS.MATH.VEC.POINT_VERSUS_VECTOR_", (char*)"CU_ASSERT(abs( Length( rv ) - 1.0 ) < 1e-12)" );
	label$599:;
}

void _ZN5TESTS9FBC_TESTS4MATH3VEC22QUATERNION_IDENTITIES_Ev( void )
{
	struct $N2FB5VEC3DE TMP$197$1;
	struct $N2FB5VEC3DE TMP$198$1;
	label$602:;
	struct $N2FB3RNGE R$1;
	struct $N2FB3RNGE vr$0 = _ZN2FB9RNGSEEDEDEy( 5150ull );
	R$1 = vr$0;
	{
		int32 K$2;
		K$2 = 1;
		label$607:;
		{
			struct $N2FB5VEC3DE TMP$169$3;
			struct $N2FB5VEC3DE AXIS$3;
			double vr$2 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.p+0, 0x1.p+0 );
			double vr$4 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.p+0, 0x1.p+0 );
			double vr$6 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.p+0, 0x1.p+0 );
			struct $N2FB5VEC3DE vr$7 = _ZN2FB6VEC3D_Eddd( vr$6, vr$4, vr$2 );
			TMP$169$3 = vr$7;
			struct $N2FB5VEC3DE vr$9 = _ZN2FB9NORMALIZEERNS_5VEC3DE( &TMP$169$3 );
			AXIS$3 = vr$9;
			double vr$11 = _ZN2FB6LENGTHERNS_5VEC3DE( &AXIS$3 );
			if( !(vr$11 > 0x1.p-1)) goto label$609;
			{
				struct $N2FB5QUATDE TMP$174$4;
				struct $N2FB5MAT4DE TMP$184$4;
				double ANG$4;
				double vr$13 = _ZN2FB3RNG15NEXTDOUBLERANGEEdd( &R$1, -0x1.8p+1, 0x1.8p+1 );
				ANG$4 = vr$13;
				struct $N2FB5QUATDE Q$4;
				struct $N2FB5QUATDE vr$15 = _ZN2FB18QUATDFROMAXISANGLEERNS_5VEC3DEd( &AXIS$3, ANG$4 );
				Q$4 = vr$15;
				double vr$17 = _ZN2FB6LENGTHERNS_5QUATDE( &Q$4 );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (vr$17 + -0x1.p+0) ) < 0x1.19799812DEA11p-40) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 162, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( Length( q ) - 1.0 ) < 1e-12)" );
				struct $N2FB5QUATDE E$4;
				struct $N2FB5QUATDE vr$23 = _ZN2FB9CONJUGATEERNS_5QUATDE( &Q$4 );
				TMP$174$4 = vr$23;
				struct $N2FB5QUATDE vr$26 = _ZN2FBmlERNS_5QUATDES1_( &Q$4, &TMP$174$4 );
				E$4 = vr$26;
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (*(double*)((uint8*)&E$4 + 24ll) + -0x1.p+0) ) < 0x1.19799812DEA11p-40) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 166, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( e.w - 1.0 ) < 1e-12)" );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( *(double*)&E$4 ) < 0x1.19799812DEA11p-40) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 167, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( e.x ) < 1e-12)" );
				struct $N2FB5VEC3DE V$4;
				struct $N2FB5VEC3DE vr$34 = _ZN2FB6VEC3D_Eddd( 0x1.p+0, 0x1.p+1, 0x1.8p+1 );
				V$4 = vr$34;
				struct $N2FB5VEC3DE RV$4;
				struct $N2FB5VEC3DE vr$37 = _ZN2FB6ROTATEERNS_5QUATDERNS_5VEC3DE( &Q$4, &V$4 );
				RV$4 = vr$37;
				double vr$39 = _ZN2FB6LENGTHERNS_5VEC3DE( &RV$4 );
				double vr$41 = _ZN2FB6LENGTHERNS_5VEC3DE( &V$4 );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (vr$39 - vr$41) ) < 0x1.B7CDFD9D7BDBBp-34) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 172, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( Length( rv ) - Length( v ) ) < 1e-10)" );
				struct $N2FB5VEC3DE MV$4;
				struct $N2FB5MAT4DE vr$48 = _ZN2FB8TOMATRIXERNS_5QUATDE( &Q$4 );
				TMP$184$4 = vr$48;
				struct $N2FB5VEC3DE vr$50 = _ZN2FB15TRANSFORMVECTORERNS_5MAT4DERNS_5VEC3DE( &TMP$184$4, &V$4 );
				MV$4 = vr$50;
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (*(double*)&MV$4 - *(double*)&RV$4) ) < 0x1.12E0BE826D695p-30) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 179, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( mv.x - rv.x ) < 1e-9)" );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (*(double*)((uint8*)&MV$4 + 8ll) - *(double*)((uint8*)&RV$4 + 8ll)) ) < 0x1.12E0BE826D695p-30) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 180, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( mv.y - rv.y ) < 1e-9)" );
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (*(double*)((uint8*)&MV$4 + 16ll) - *(double*)((uint8*)&RV$4 + 16ll)) ) < 0x1.12E0BE826D695p-30) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 181, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( mv.z - rv.z ) < 1e-9)" );
				struct $N2FB5VEC3DE RA$4;
				struct $N2FB5VEC3DE vr$65 = _ZN2FB6ROTATEERNS_5QUATDERNS_5VEC3DE( &Q$4, &AXIS$3 );
				RA$4 = vr$65;
				_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (*(double*)&RA$4 - *(double*)&AXIS$3) ) < 0x1.12E0BE826D695p-30) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 185, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( ra.x - axis.x ) < 1e-9)" );
			}
			label$609:;
			label$608:;
		}
		label$605:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$604:;
		if( (int64)K$2 <= 10000ll) goto label$607;
		label$606:;
	}
	struct $N2FB5QUATDE Q90$1;
	struct $N2FB5VEC3DE vr$74 = _ZN2FB6VEC3D_Eddd( 0x0p+0, 0x1.p+0, 0x0p+0 );
	TMP$197$1 = vr$74;
	struct $N2FB5QUATDE vr$76 = _ZN2FB18QUATDFROMAXISANGLEERNS_5VEC3DEd( &TMP$197$1, 0x1.921FB54442D18p+0 );
	Q90$1 = vr$76;
	struct $N2FB5VEC3DE RX$1;
	struct $N2FB5VEC3DE vr$77 = _ZN2FB6VEC3D_Eddd( 0x1.p+0, 0x0p+0, 0x0p+0 );
	TMP$198$1 = vr$77;
	struct $N2FB5VEC3DE vr$80 = _ZN2FB6ROTATEERNS_5QUATDERNS_5VEC3DE( &Q90$1, &TMP$198$1 );
	RX$1 = vr$80;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( *(double*)&RX$1 ) < 0x1.12E0BE826D695p-30) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 192, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( rx.x ) < 1e-9)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (*(double*)((uint8*)&RX$1 + 16ll) + 0x1.p+0) ) < 0x1.12E0BE826D695p-30) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 193, (char*)"TESTS.FBC_TESTS.MATH.VEC.QUATERNION_IDENTITIES_", (char*)"CU_ASSERT(abs( rx.z + 1.0 ) < 1e-9)" );
	label$603:;
}

void _ZN5TESTS9FBC_TESTS4MATH3VEC6SLERP_Ev( void )
{
	struct $N2FB5VEC3DE TMP$207$1;
	struct $N2FB5VEC3DE TMP$208$1;
	label$612:;
	struct $N2FB5QUATDE A$1;
	struct $N2FB5VEC3DE vr$0 = _ZN2FB6VEC3D_Eddd( 0x0p+0, 0x1.p+0, 0x0p+0 );
	TMP$207$1 = vr$0;
	struct $N2FB5QUATDE vr$2 = _ZN2FB18QUATDFROMAXISANGLEERNS_5VEC3DEd( &TMP$207$1, 0x0p+0 );
	A$1 = vr$2;
	struct $N2FB5QUATDE B$1;
	struct $N2FB5VEC3DE vr$3 = _ZN2FB6VEC3D_Eddd( 0x0p+0, 0x1.p+0, 0x0p+0 );
	TMP$208$1 = vr$3;
	struct $N2FB5QUATDE vr$5 = _ZN2FB18QUATDFROMAXISANGLEERNS_5VEC3DEd( &TMP$208$1, 0x1.p+0 );
	B$1 = vr$5;
	struct $N2FB5QUATDE S0$1;
	struct $N2FB5QUATDE vr$8 = _ZN2FB5SLERPERNS_5QUATDES1_d( &A$1, &B$1, 0x0p+0 );
	S0$1 = vr$8;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (*(double*)((uint8*)&S0$1 + 24ll) - *(double*)((uint8*)&A$1 + 24ll)) ) < 0x1.19799812DEA11p-40) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 202, (char*)"TESTS.FBC_TESTS.MATH.VEC.SLERP_", (char*)"CU_ASSERT(abs( s0.w - a.w ) < 1e-12)" );
	struct $N2FB5QUATDE S1$1;
	struct $N2FB5QUATDE vr$15 = _ZN2FB5SLERPERNS_5QUATDES1_d( &A$1, &B$1, 0x1.p+0 );
	S1$1 = vr$15;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (*(double*)((uint8*)&S1$1 + 24ll) - *(double*)((uint8*)&B$1 + 24ll)) ) < 0x1.19799812DEA11p-40) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 204, (char*)"TESTS.FBC_TESTS.MATH.VEC.SLERP_", (char*)"CU_ASSERT(abs( s1.w - b.w ) < 1e-12)" );
	{
		int32 I$2;
		I$2 = 0;
		label$617:;
		{
			struct $N2FB5QUATDE S$3;
			struct $N2FB5QUATDE vr$25 = _ZN2FB5SLERPERNS_5QUATDES1_d( &A$1, &B$1, (double)(int64)I$2 / 0x1.9p+6 );
			S$3 = vr$25;
			double vr$27 = _ZN2FB6LENGTHERNS_5QUATDE( &S$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(__builtin_fabs( (vr$27 + -0x1.p+0) ) < 0x1.12E0BE826D695p-30) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 209, (char*)"TESTS.FBC_TESTS.MATH.VEC.SLERP_", (char*)"CU_ASSERT(abs( Length( s ) - 1.0 ) < 1e-9)" );
		}
		label$615:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$614:;
		if( (int64)I$2 <= 100ll) goto label$617;
		label$616:;
	}
	struct $N2FB5QUATDE NB$1;
	struct $N2FB5QUATDE vr$40 = _ZN2FB6QUATD_Edddd( -(*(double*)&B$1), -(*(double*)((uint8*)&B$1 + 8ll)), -(*(double*)((uint8*)&B$1 + 16ll)), -(*(double*)((uint8*)&B$1 + 24ll)) );
	NB$1 = vr$40;
	struct $N2FB5QUATDE MID_$1;
	struct $N2FB5QUATDE vr$43 = _ZN2FB5SLERPERNS_5QUATDES1_d( &A$1, &NB$1, 0x1.p-1 );
	MID_$1 = vr$43;
	double DOTM$1;
	double vr$46 = _ZN2FB3DOTERNS_5QUATDES1_( &A$1, &MID_$1 );
	DOTM$1 = __builtin_fabs( vr$46 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(DOTM$1 > 0x1.999999999999Ap-1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cmath\x5Cvector.bas", 217, (char*)"TESTS.FBC_TESTS.MATH.VEC.SLERP_", (char*)"CU_ASSERT(dotm > 0.8)" );
	label$613:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit\0-l\0advapi32";
