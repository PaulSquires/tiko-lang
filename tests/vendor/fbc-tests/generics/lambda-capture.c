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
struct $7COUNTED {
	int32 V;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $7COUNTED ) == 4 );
struct $25LF08B29542EF53F89_Lt_0003IiE {
	int32* __CAP_TOTAL;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0003IiE ) == 8 );
struct $25LF08B29542EF53F89_Lt_0009IiE {
	int32 __CAP_BIAS;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0009IiE ) == 4 );
struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE {
	int32* __CAP_HITS;
	FBSTRING __CAP_NEEDLE;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE ) == 32 );
struct $25LF08B29542EF53F89_Lt_001CIiE {
	int32* __CAP_N1;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_001CIiE ) == 8 );
struct $25LF08B29542EF53F89_Lt_001EIiE {
	int32* __CAP_N2;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_001EIiE ) == 8 );
struct $25LF08B29542EF53F89_Lt_0022IiE {
	int32 __CAP_BIAS;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0022IiE ) == 4 );
struct $25LF08B29542EF53F89_Lt_0027IiE {
	int32* __CAP_TICKS;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0027IiE ) == 8 );
struct $25LF08B29542EF53F89_Lt_002EIiE {
	int32* __CAP_SUM_;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_002EIiE ) == 8 );
typedef void (*tmp$50)( int32 );
struct $25LF08B29542EF53F89_Lt_0035IiE {
	int32 __CAP_BIAS;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0035IiE ) == 4 );
struct $13ArrayIteratorIiE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorIiE ) == 16 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
struct $8FBARRAY1IiE {
	int32* DATA;
	int32* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1IiE ) == 72 );
struct $5ArrayIiE {
	struct $8FBARRAY1IiE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayIiE ) == 80 );
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
struct $25LF08B29542EF53F89_Lt_003DIxE {
	int64* __CAP_TOTAL;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_003DIxE ) == 8 );
typedef void (*tmp$65)( int32* );
struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE {
	FBSTRING* __CAP_OUT_;
	FBSTRING __CAP_SEP;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE ) == 32 );
struct $2PT {
	int32 X;
	int32 Y;
};
__FB_STATIC_ASSERT( sizeof( struct $2PT ) == 8 );
struct $25LF08B29542EF53F89_Lt_0055I2PTiE {
	struct $2PT* __CAP_P;
	int32* __CAP_GOT;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0055I2PTiE ) == 16 );
struct $25LF08B29542EF53F89_Lt_0059I2PTiE {
	struct $2PT __CAP_Q;
	int32* __CAP_GOT2;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0059I2PTiE ) == 16 );
struct $25LF08B29542EF53F89_Lt_005DI5ArrayIiEiE {
	struct $5ArrayIiE* __CAP_SRC;
	int32* __CAP_GOT;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_005DI5ArrayIiEiE ) == 16 );
struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE {
	struct $5ArrayIiE __CAP_ORIG;
	int32* __CAP_N;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE ) == 88 );
struct $8OptionalIiE {
	int32 V;
	boolean HAS;
};
__FB_STATIC_ASSERT( sizeof( struct $8OptionalIiE ) == 8 );
struct $25LF08B29542EF53F89_Lt_0069I8OptionalIiEiE {
	struct $8OptionalIiE* __CAP_O;
	int32* __CAP_OV;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0069I8OptionalIiEiE ) == 16 );
struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE {
	struct $7COUNTED __CAP_C;
	int32* __CAP_GOT;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE ) == 16 );
struct $25LF08B29542EF53F89_Lt_0073I7COUNTEDiE {
	struct $7COUNTED* __CAP_C;
	int32* __CAP_GOT;
};
__FB_STATIC_ASSERT( sizeof( struct $25LF08B29542EF53F89_Lt_0073I7COUNTEDiE ) == 16 );
typedef int32 (*tmp$42)( int32 );
int32 fb_ArrayRedimPresvEx( struct $7FBARRAYIvE*, uint64, int32, int32, uint64, ... );
int32 fb_ArrayRedimTo( struct $7FBARRAYIvE*, struct $7FBARRAYIvE*, int32, void*, void* );
int32 fb_ArrayErase( struct $7FBARRAYIvE* );
int64 fb_ArrayLBound( struct $7FBARRAYIKvE*, int64 );
int64 fb_ArrayUBound( struct $7FBARRAYIKvE*, int64 );
void* fb_ErrorThrowEx( int32, int32, char*, void*, void* );
void fb_Assert( char*, int64, char*, char* );
FBSTRING* fb_StrInit( void*, int64, void*, int64, int32 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_IntToStr( int32 );
int64 fb_StrInstr( int64, FBSTRING*, FBSTRING* );
static void fb_ctor__lambdazcapture( void ) __attribute__(( constructor ));
void _ZN7COUNTEDC1Ev( struct $7COUNTED* );
void _ZN7COUNTEDC1Ei( struct $7COUNTED*, int32 );
void _ZN7COUNTEDaSERS_( struct $7COUNTED*, struct $7COUNTED* );
void _ZN7COUNTEDD1Ev( struct $7COUNTED* );
static void _ZN25LF08B29542EF53F89_Lt_0003IiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_0003IiE*, int32 );
static int32 _ZN25LF08B29542EF53F89_Lt_0009IiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_0009IiE*, int32 );
static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE10__FBINVOKEERS0_( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE*, FBSTRING* );
static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGEC1Ev( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* );
static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGEaSERKS1_( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE*, struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* );
static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGEC1ERKS1_( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE*, struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* );
static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGED1Ev( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* );
static void _ZN25LF08B29542EF53F89_Lt_001CIiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_001CIiE* );
static void _ZN25LF08B29542EF53F89_Lt_001EIiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_001EIiE* );
static int32 _ZN25LF08B29542EF53F89_Lt_0022IiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_0022IiE*, int32 );
static void _ZN25LF08B29542EF53F89_Lt_0027IiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0027IiE* );
int32 LF08B29542EF53F89_LT_002B( int32 );
static void _ZN25LF08B29542EF53F89_Lt_002EIiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_002EIiE*, int32 );
static void _Z5ApplyI25LF08B29542EF53F89_Lt_002EIiEEiRS1_( int32, struct $25LF08B29542EF53F89_Lt_002EIiE* );
void LF08B29542EF53F89_LT_0031( int32 );
static void _Z5ApplyIPFviEEiRS1_( int32, tmp$50* );
static int32 _ZN25LF08B29542EF53F89_Lt_0035IiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_0035IiE*, int32 );
static int32 _Z6ApplyRI25LF08B29542EF53F89_Lt_0035IiEEiRS1_( int32, struct $25LF08B29542EF53F89_Lt_0035IiE* );
static int32 _ZN5ArrayIiE5COUNTEv( struct $5ArrayIiE* );
static int32 _ZN5ArrayIiE8CAPACITYEv( struct $5ArrayIiE* );
static int32* _ZN5ArrayIiEixEi( struct $5ArrayIiE*, int32 );
static void _ZN5ArrayIiE4PUSHERi( struct $5ArrayIiE*, int32* );
static void _ZN5ArrayIiE7RESERVEEi( struct $5ArrayIiE*, int32 );
static void _ZN5ArrayIiEC1Ev( struct $5ArrayIiE* );
static void _ZN5ArrayIiEaSERKS0_( struct $5ArrayIiE*, struct $5ArrayIiE* );
static void _ZN5ArrayIiED1Ev( struct $5ArrayIiE* );
static void _ZN25LF08B29542EF53F89_Lt_003DIxE10__FBINVOKEERi( struct $25LF08B29542EF53F89_Lt_003DIxE*, int32* );
static void _Z7ForEachIi25LF08B29542EF53F89_Lt_003DIxEER5ArrayIiERS1_( struct $5ArrayIiE*, struct $25LF08B29542EF53F89_Lt_003DIxE* );
void LF08B29542EF53F89_LT_0040( int32* );
static void _Z7ForEachIiPFvRiEER5ArrayIiERS2_( struct $5ArrayIiE*, tmp$65* );
static void _ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE10__FBINVOKEERi( struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE*, int32* );
static void _ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGEC1Ev( struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* );
static void _ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGEaSERKS2_( struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE*, struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* );
static void _ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGED1Ev( struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* );
static void _Z7ForEachIi25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGEER5ArrayIiERS3_( struct $5ArrayIiE*, struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* );
static void _ZN25LF08B29542EF53F89_Lt_0055I2PTiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0055I2PTiE* );
static void _ZN25LF08B29542EF53F89_Lt_0059I2PTiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0059I2PTiE* );
static void _ZN25LF08B29542EF53F89_Lt_005DI5ArrayIiEiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_005DI5ArrayIiEiE* );
static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* );
static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiEC1Ev( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* );
static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiEaSERKS2_( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE*, struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* );
static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiEC1ERKS2_( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE*, struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* );
static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiED1Ev( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* );
static int32* _ZN8OptionalIiE5VALUEEv( struct $8OptionalIiE* );
static struct $8OptionalIiE _Z4SomeIiERi( int32* );
static void _ZN25LF08B29542EF53F89_Lt_0069I8OptionalIiEiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0069I8OptionalIiEiE* );
static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* );
static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiEC1Ev( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* );
static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiEaSERKS1_( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE*, struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* );
static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiEC1ERKS1_( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE*, struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* );
static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiED1Ev( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* );
static void _ZN25LF08B29542EF53F89_Lt_0073I7COUNTEDiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0073I7COUNTEDiE* );
static int32 LIVECOUNTED$;
static int32 MADECOUNTED$;

void _ZN7COUNTEDC1Ev( struct $7COUNTED* THIS$1 )
{
	label$2:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	*(int32*)THIS$1 = 0;
	LIVECOUNTED$ = (int32)((int64)LIVECOUNTED$ + 1ll);
	MADECOUNTED$ = (int32)((int64)MADECOUNTED$ + 1ll);
	label$3:;
}

void _ZN7COUNTEDC1Ei( struct $7COUNTED* THIS$1, int32 N$1 )
{
	label$4:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	*(int32*)THIS$1 = N$1;
	LIVECOUNTED$ = (int32)((int64)LIVECOUNTED$ + 1ll);
	MADECOUNTED$ = (int32)((int64)MADECOUNTED$ + 1ll);
	label$5:;
}

void _ZN7COUNTEDC1ERS_( struct $7COUNTED* THIS$1, struct $7COUNTED* RHS$1 )
{
	label$6:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	*(int32*)THIS$1 = *(int32*)RHS$1;
	LIVECOUNTED$ = (int32)((int64)LIVECOUNTED$ + 1ll);
	MADECOUNTED$ = (int32)((int64)MADECOUNTED$ + 1ll);
	label$7:;
}

void _ZN7COUNTEDaSERS_( struct $7COUNTED* THIS$1, struct $7COUNTED* RHS$1 )
{
	label$8:;
	*(int32*)THIS$1 = *(int32*)RHS$1;
	label$9:;
}

void _ZN7COUNTEDD1Ev( struct $7COUNTED* THIS$1 )
{
	label$10:;
	LIVECOUNTED$ = (int32)((int64)LIVECOUNTED$ + -1ll);
	label$11:;
}

static void _ZN25LF08B29542EF53F89_Lt_0003IiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_0003IiE* THIS$1, int32 ITEM$1 )
{
	label$16:;
	int32* TOTAL$1;
	TOTAL$1 = *(int32**)THIS$1;
	*TOTAL$1 = (int32)((int64)*TOTAL$1 + (int64)ITEM$1);
	label$17:;
}

static int32 _ZN25LF08B29542EF53F89_Lt_0009IiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_0009IiE* THIS$1, int32 X$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$24:;
	int32* BIAS$1;
	BIAS$1 = (int32*)THIS$1;
	fb$result$1 = (int32)((int64)X$1 + (int64)*BIAS$1);
	goto label$25;
	label$25:;
	return fb$result$1;
}

static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE10__FBINVOKEERS0_( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* THIS$1, FBSTRING* ROW$1 )
{
	label$38:;
	int32* HITS$1;
	HITS$1 = *(int32**)THIS$1;
	FBSTRING* NEEDLE$1;
	NEEDLE$1 = (FBSTRING*)((uint8*)THIS$1 + 8ll);
	int64 vr$3 = fb_StrInstr( 1ll, (FBSTRING*)ROW$1, (FBSTRING*)NEEDLE$1 );
	if( vr$3 == 0ll) goto label$41;
	{
		*HITS$1 = (int32)((int64)*HITS$1 + 1ll);
		label$41:;
	}
	label$39:;
}

static void _ZN25LF08B29542EF53F89_Lt_001CIiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_001CIiE* THIS$1 )
{
	label$46:;
	int32* N1$1;
	N1$1 = *(int32**)THIS$1;
	*N1$1 = (int32)((int64)*N1$1 + 1ll);
	label$47:;
}

static void _ZN25LF08B29542EF53F89_Lt_001EIiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_001EIiE* THIS$1 )
{
	label$48:;
	int32* N2$1;
	N2$1 = *(int32**)THIS$1;
	*N2$1 = (int32)((int64)*N2$1 + 10ll);
	label$49:;
}

static int32 _ZN25LF08B29542EF53F89_Lt_0022IiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_0022IiE* THIS$1, int32 X$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$58:;
	int32* BIAS$1;
	BIAS$1 = (int32*)THIS$1;
	fb$result$1 = (int32)((int64)X$1 + (int64)*BIAS$1);
	goto label$59;
	label$59:;
	return fb$result$1;
}

static void _ZN25LF08B29542EF53F89_Lt_0027IiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0027IiE* THIS$1 )
{
	label$60:;
	int32* TICKS$1;
	TICKS$1 = *(int32**)THIS$1;
	*TICKS$1 = (int32)((int64)*TICKS$1 + 1ll);
	label$61:;
}

int32 LF08B29542EF53F89_LT_002B( int32 X$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$66:;
	fb$result$1 = (int32)((int64)X$1 << (1ll & 63ll));
	goto label$67;
	label$67:;
	return fb$result$1;
}

static void _ZN25LF08B29542EF53F89_Lt_002EIiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_002EIiE* THIS$1, int32 V$1 )
{
	label$74:;
	int32* SUM_$1;
	SUM_$1 = *(int32**)THIS$1;
	*SUM_$1 = (int32)((int64)*SUM_$1 + (int64)V$1);
	label$75:;
}

void LF08B29542EF53F89_LT_0031( int32 V$1 )
{
	label$76:;
	label$77:;
}

static void _Z5ApplyI25LF08B29542EF53F89_Lt_002EIiEEiRS1_( int32 N$1, struct $25LF08B29542EF53F89_Lt_002EIiE* F$1 )
{
	label$78:;
	{
		int32 I$2;
		I$2 = 1;
		int32 TMP$56$2;
		TMP$56$2 = N$1;
		goto label$80;
		label$83:;
		{
			_ZN25LF08B29542EF53F89_Lt_002EIiE10__FBINVOKEEi( F$1, I$2 );
		}
		label$81:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$80:;
		if( (int64)I$2 <= (int64)TMP$56$2) goto label$83;
		label$82:;
	}
	label$79:;
}

static void _Z5ApplyIPFviEEiRS1_( int32 N$1, tmp$50* F$1 )
{
	label$84:;
	{
		int32 I$2;
		I$2 = 1;
		int32 TMP$57$2;
		TMP$57$2 = N$1;
		goto label$86;
		label$89:;
		{
			(*F$1)( I$2 );
		}
		label$87:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$86:;
		if( (int64)I$2 <= (int64)TMP$57$2) goto label$89;
		label$88:;
	}
	label$85:;
}

static int32 _ZN25LF08B29542EF53F89_Lt_0035IiE10__FBINVOKEEi( struct $25LF08B29542EF53F89_Lt_0035IiE* THIS$1, int32 V$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$90:;
	int32* BIAS$1;
	BIAS$1 = (int32*)THIS$1;
	fb$result$1 = (int32)((int64)V$1 + (int64)*BIAS$1);
	goto label$91;
	label$91:;
	return fb$result$1;
}

static int32 _Z6ApplyRI25LF08B29542EF53F89_Lt_0035IiEEiRS1_( int32 N$1, struct $25LF08B29542EF53F89_Lt_0035IiE* F$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$92:;
	int32 vr$1 = _ZN25LF08B29542EF53F89_Lt_0035IiE10__FBINVOKEEi( F$1, N$1 );
	fb$result$1 = vr$1;
	goto label$93;
	label$93:;
	return fb$result$1;
}

static boolean _ZN13ArrayIteratorIiE7ISVALIDEv( struct $13ArrayIteratorIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$124:;
	struct $5ArrayIiE* A$1;
	A$1 = *(struct $5ArrayIiE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$125;
	label$125:;
	return fb$result$1;
}

void LF08B29542EF53F89_LT_0040( int32* V$1 )
{
	label$126:;
	*V$1 = (int32)((int64)*V$1 << (1ll & 63ll));
	label$127:;
}

static int32* _ZN13ArrayIteratorIiE5VALUEEv( struct $13ArrayIteratorIiE* THIS$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$128:;
	struct $5ArrayIiE* A$1;
	A$1 = *(struct $5ArrayIiE**)THIS$1;
	fb$result$1 = (int32*)((uint8*)*(int32**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) << (2ll & 63ll)));
	goto label$129;
	label$129:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorIiE8MOVENEXTEv( struct $13ArrayIteratorIiE* THIS$1 )
{
	label$130:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$131:;
}

static int32 _ZN5ArrayIiE5COUNTEv( struct $5ArrayIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$132:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$133;
	label$133:;
	return fb$result$1;
}

static int32 _ZN5ArrayIiE8CAPACITYEv( struct $5ArrayIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$134:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$135;
	label$135:;
	return fb$result$1;
}

static boolean _ZN5ArrayIiE7ISEMPTYEv( struct $5ArrayIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$136:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$137;
	label$137:;
	return fb$result$1;
}

static void _ZN5ArrayIiE7RESERVEEi( struct $5ArrayIiE* THIS$1, int32 N$1 )
{
	label$138:;
	int32 vr$1 = _ZN5ArrayIiE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$141;
	{
		goto label$139;
	}
	label$141:;
	label$140:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayIiE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$143;
	{
		CAP$1 = 8;
	}
	label$143:;
	label$142:;
	label$144:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$145;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$144;
	label$145:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 4ull, -1, 0, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$139:;
}

static void _ZN5ArrayIiE6SHRINKEv( struct $5ArrayIiE* THIS$1 )
{
	label$146:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$149;
	{
		fb_ArrayErase( (struct $7FBARRAYIvE*)THIS$1 );
		goto label$147;
	}
	label$149:;
	label$148:;
	int32 vr$6 = _ZN5ArrayIiE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$151;
	{
		goto label$147;
	}
	label$151:;
	label$150:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 4ull, -1, 0, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$147:;
}

static int32* _ZN5ArrayIiEixEi( struct $5ArrayIiE* THIS$1, int32 I$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$152:;
	fb$result$1 = (int32*)((uint8*)*(int32**)THIS$1 + ((int64)I$1 << (2ll & 63ll)));
	goto label$153;
	label$153:;
	return fb$result$1;
}

static int32* _ZN5ArrayIiE2ATEi( struct $5ArrayIiE* THIS$1, int32 I$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$154:;
	fb$result$1 = (int32*)((uint8*)*(int32**)THIS$1 + ((int64)I$1 << (2ll & 63ll)));
	goto label$155;
	label$155:;
	return fb$result$1;
}

static void _ZN5ArrayIiE4PUSHERi( struct $5ArrayIiE* THIS$1, int32* V$1 )
{
	label$156:;
	_ZN5ArrayIiE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (2ll & 63ll))) = *V$1;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$157:;
}

static int32 _ZN5ArrayIiE3POPEv( struct $5ArrayIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$158:;
	int32 R$1;
	__builtin_memset( &R$1, 0, 4ll );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$161;
	{
		fb$result$1 = R$1;
		goto label$159;
	}
	label$161:;
	label$160:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	R$1 = *(int32*)((uint8*)*(int32**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (2ll & 63ll)));
	fb$result$1 = R$1;
	goto label$159;
	label$159:;
	return fb$result$1;
}

static void _ZN5ArrayIiE6INSERTEiRi( struct $5ArrayIiE* THIS$1, int32 I$1, int32* V$1 )
{
	int64 TMP$74$1;
	label$162:;
	if( (int64)I$1 < 0ll) goto label$164;
	TMP$74$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$171;
	label$164:;
	TMP$74$1 = -1ll;
	label$171:;
	if( TMP$74$1 == 0ll) goto label$166;
	{
		goto label$163;
	}
	label$166:;
	label$165:;
	int32 TMP$1;
	TMP$1 = *V$1;
	_ZN5ArrayIiE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$75$2;
		TMP$75$2 = (int32)((int64)I$1 + 1ll);
		goto label$167;
		label$170:;
		{
			*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) = *(int32*)((uint8*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) + -4ll);
		}
		label$168:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$167:;
		if( (int64)K$2 >= (int64)TMP$75$2) goto label$170;
		label$169:;
	}
	*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)I$1 << (2ll & 63ll))) = TMP$1;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$163:;
}

static void _ZN5ArrayIiE6REMOVEEi( struct $5ArrayIiE* THIS$1, int32 I$1 )
{
	int64 TMP$76$1;
	label$172:;
	if( (int64)I$1 < 0ll) goto label$174;
	TMP$76$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$181;
	label$174:;
	TMP$76$1 = -1ll;
	label$181:;
	if( TMP$76$1 == 0ll) goto label$176;
	{
		goto label$173;
	}
	label$176:;
	label$175:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$77$2;
		TMP$77$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$177;
		label$180:;
		{
			*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) = *(int32*)((uint8*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) + 4ll);
		}
		label$178:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$177:;
		if( (int64)K$2 <= (int64)TMP$77$2) goto label$180;
		label$179:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$173:;
}

static void _ZN5ArrayIiE10REMOVESWAPEi( struct $5ArrayIiE* THIS$1, int32 I$1 )
{
	int64 TMP$78$1;
	label$182:;
	if( (int64)I$1 < 0ll) goto label$184;
	TMP$78$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$189;
	label$184:;
	TMP$78$1 = -1ll;
	label$189:;
	if( TMP$78$1 == 0ll) goto label$186;
	{
		goto label$183;
	}
	label$186:;
	label$185:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$188;
	{
		*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)I$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (2ll & 63ll)));
	}
	label$188:;
	label$187:;
	label$183:;
}

static void _ZN5ArrayIiE5CLEAREv( struct $5ArrayIiE* THIS$1 )
{
	label$190:;
	int32 BLANK$1;
	__builtin_memset( &BLANK$1, 0, 4ll );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$79$2;
		TMP$79$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$192;
		label$195:;
		{
			*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) = BLANK$1;
		}
		label$193:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$192:;
		if( (int64)K$2 <= (int64)TMP$79$2) goto label$195;
		label$194:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	label$191:;
}

static struct $13ArrayIteratorIiE _ZN5ArrayIiE11GETITERATOREv( struct $5ArrayIiE* THIS$1 )
{
	struct $13ArrayIteratorIiE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$196:;
	struct $13ArrayIteratorIiE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$197;
	label$197:;
	return fb$result$1;
}

static void _ZN25LF08B29542EF53F89_Lt_003DIxE10__FBINVOKEERi( struct $25LF08B29542EF53F89_Lt_003DIxE* THIS$1, int32* V$1 )
{
	label$198:;
	int64* TOTAL$1;
	TOTAL$1 = *(int64**)THIS$1;
	*TOTAL$1 = *(int64*)TOTAL$1 + (int64)*V$1;
	label$199:;
}

static void _Z7ForEachIi25LF08B29542EF53F89_Lt_003DIxEER5ArrayIiERS1_( struct $5ArrayIiE* A$1, struct $25LF08B29542EF53F89_Lt_003DIxE* F$1 )
{
	label$200:;
	{
		int32 I$2;
		I$2 = 0;
		int32 TMP$80$2;
		TMP$80$2 = (int32)((int64)*(int32*)((uint8*)A$1 + 72ll) + -1ll);
		goto label$202;
		label$205:;
		{
			_ZN25LF08B29542EF53F89_Lt_003DIxE10__FBINVOKEERi( F$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)I$2 << (2ll & 63ll))) );
		}
		label$203:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$202:;
		if( (int64)I$2 <= (int64)TMP$80$2) goto label$205;
		label$204:;
	}
	label$201:;
}

static void _Z7ForEachIiPFvRiEER5ArrayIiERS2_( struct $5ArrayIiE* A$1, tmp$65* F$1 )
{
	label$206:;
	{
		int32 I$2;
		I$2 = 0;
		int32 TMP$81$2;
		TMP$81$2 = (int32)((int64)*(int32*)((uint8*)A$1 + 72ll) + -1ll);
		goto label$208;
		label$211:;
		{
			(*F$1)( (int32*)((uint8*)*(int32**)A$1 + ((int64)I$2 << (2ll & 63ll))) );
		}
		label$209:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$208:;
		if( (int64)I$2 <= (int64)TMP$81$2) goto label$211;
		label$210:;
	}
	label$207:;
}

static void _ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE10__FBINVOKEERi( struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* THIS$1, int32* V$1 )
{
	FBSTRING TMP$82$1;
	FBSTRING TMP$83$1;
	label$212:;
	FBSTRING* OUT_$1;
	OUT_$1 = *(FBSTRING**)THIS$1;
	FBSTRING* SEP$1;
	SEP$1 = (FBSTRING*)((uint8*)THIS$1 + 8ll);
	FBSTRING* vr$4 = fb_IntToStr( *V$1 );
	__builtin_memset( &TMP$82$1, 0, 24ll );
	FBSTRING* vr$7 = fb_StrConcat( &TMP$82$1, (void*)vr$4, -1ll, (void*)SEP$1, -1ll );
	__builtin_memset( &TMP$83$1, 0, 24ll );
	FBSTRING* vr$10 = fb_StrConcat( &TMP$83$1, (void*)OUT_$1, -1ll, (void*)vr$7, -1ll );
	fb_StrAssign( (void*)OUT_$1, -1ll, (void*)vr$10, -1ll, 0 );
	label$213:;
}

static void _Z7ForEachIi25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGEER5ArrayIiERS3_( struct $5ArrayIiE* A$1, struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* F$1 )
{
	label$214:;
	{
		int32 I$2;
		I$2 = 0;
		int32 TMP$84$2;
		TMP$84$2 = (int32)((int64)*(int32*)((uint8*)A$1 + 72ll) + -1ll);
		goto label$216;
		label$219:;
		{
			_ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE10__FBINVOKEERi( F$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)I$2 << (2ll & 63ll))) );
		}
		label$217:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$216:;
		if( (int64)I$2 <= (int64)TMP$84$2) goto label$219;
		label$218:;
	}
	label$215:;
}

static void _ZN25LF08B29542EF53F89_Lt_0055I2PTiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0055I2PTiE* THIS$1 )
{
	label$226:;
	struct $2PT* P$1;
	P$1 = *(struct $2PT**)THIS$1;
	int32* GOT$1;
	GOT$1 = *(int32**)((uint8*)THIS$1 + 8ll);
	*GOT$1 = (int32)((int64)*(int32*)P$1 + (int64)*(int32*)((uint8*)P$1 + 4ll));
	*(int32*)P$1 = 99;
	label$227:;
}

static void _ZN25LF08B29542EF53F89_Lt_0059I2PTiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0059I2PTiE* THIS$1 )
{
	label$228:;
	struct $2PT* Q$1;
	Q$1 = (struct $2PT*)THIS$1;
	int32* GOT2$1;
	GOT2$1 = *(int32**)((uint8*)THIS$1 + 8ll);
	*GOT2$1 = (int32)((int64)*(int32*)Q$1 + (int64)*(int32*)((uint8*)Q$1 + 4ll));
	label$229:;
}

static void _ZN25LF08B29542EF53F89_Lt_005DI5ArrayIiEiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_005DI5ArrayIiEiE* THIS$1 )
{
	int32 TMP$97$1;
	label$236:;
	struct $5ArrayIiE* SRC$1;
	SRC$1 = *(struct $5ArrayIiE**)THIS$1;
	int32* GOT$1;
	GOT$1 = *(int32**)((uint8*)THIS$1 + 8ll);
	int32* vr$2 = _ZN5ArrayIiEixEi( SRC$1, 0 );
	*GOT$1 = *vr$2;
	TMP$97$1 = 9;
	_ZN5ArrayIiE4PUSHERi( SRC$1, &TMP$97$1 );
	label$237:;
}

static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* THIS$1 )
{
	label$250:;
	struct $5ArrayIiE* ORIG$1;
	ORIG$1 = (struct $5ArrayIiE*)THIS$1;
	int32* N$1;
	N$1 = *(int32**)((uint8*)THIS$1 + 80ll);
	int32 vr$3 = _ZN5ArrayIiE5COUNTEv( ORIG$1 );
	*N$1 = vr$3;
	label$251:;
}

static boolean _ZN8OptionalIiE8HASVALUEEv( struct $8OptionalIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$254:;
	fb$result$1 = *(boolean*)((uint8*)THIS$1 + 4ll);
	goto label$255;
	label$255:;
	return fb$result$1;
}

static int32* _ZN8OptionalIiE5VALUEEv( struct $8OptionalIiE* THIS$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$256:;
	if( *(boolean*)((uint8*)THIS$1 + 4ll) != (boolean)0ll) goto label$259;
	{
		label$260:;
		void* vr$2 = fb_ErrorThrowEx( 1, 84, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5Coptional.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$261:;
	}
	label$259:;
	label$258:;
	fb$result$1 = (int32*)THIS$1;
	goto label$257;
	label$257:;
	return fb$result$1;
}

static int32* _ZN8OptionalIiE7VALUEORERi( struct $8OptionalIiE* THIS$1, int32* DFLT$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$262:;
	if( *(boolean*)((uint8*)THIS$1 + 4ll) != (boolean)0ll) goto label$265;
	{
		fb$result$1 = DFLT$1;
		goto label$263;
	}
	label$265:;
	label$264:;
	fb$result$1 = (int32*)THIS$1;
	goto label$263;
	label$263:;
	return fb$result$1;
}

static void _ZN8OptionalIiE5CLEAREv( struct $8OptionalIiE* THIS$1 )
{
	label$266:;
	int32 BLANK$1;
	__builtin_memset( &BLANK$1, 0, 4ll );
	*(int32*)THIS$1 = BLANK$1;
	*(boolean*)((uint8*)THIS$1 + 4ll) = (boolean)0ll;
	label$267:;
}

static struct $8OptionalIiE _Z4SomeIiERi( int32* V$1 )
{
	struct $8OptionalIiE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$268:;
	struct $8OptionalIiE R$1;
	__builtin_memset( &R$1, 0, 8ll );
	*(int32*)&R$1 = *V$1;
	*(boolean*)((uint8*)&R$1 + 4ll) = (boolean)1ll;
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$269;
	label$269:;
	return fb$result$1;
}

static void _ZN25LF08B29542EF53F89_Lt_0069I8OptionalIiEiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0069I8OptionalIiEiE* THIS$1 )
{
	label$270:;
	struct $8OptionalIiE* O$1;
	O$1 = *(struct $8OptionalIiE**)THIS$1;
	int32* OV$1;
	OV$1 = *(int32**)((uint8*)THIS$1 + 8ll);
	int32* vr$2 = _ZN8OptionalIiE5VALUEEv( O$1 );
	*OV$1 = *vr$2;
	label$271:;
}

static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* THIS$1 )
{
	label$284:;
	struct $7COUNTED* C$1;
	C$1 = (struct $7COUNTED*)THIS$1;
	int32* GOT$1;
	GOT$1 = *(int32**)((uint8*)THIS$1 + 8ll);
	*GOT$1 = *(int32*)C$1;
	label$285:;
}

static void _ZN25LF08B29542EF53F89_Lt_0073I7COUNTEDiE10__FBINVOKEEv( struct $25LF08B29542EF53F89_Lt_0073I7COUNTEDiE* THIS$1 )
{
	label$292:;
	struct $7COUNTED* C$1;
	C$1 = *(struct $7COUNTED**)THIS$1;
	int32* GOT$1;
	GOT$1 = *(int32**)((uint8*)THIS$1 + 8ll);
	*GOT$1 = *(int32*)C$1;
	label$293:;
}

__attribute__(( constructor )) static void fb_ctor__lambdazcapture( void )
{
	label$0:;
	{
		int32 TOTAL$1;
		TOTAL$1 = 0;
		struct $25LF08B29542EF53F89_Lt_0003IiE TMP$4$1;
		__builtin_memset( &TMP$4$1, 0, 8ll );
		*(int32**)&TMP$4$1 = &TOTAL$1;
		struct $25LF08B29542EF53F89_Lt_0003IiE C$1;
		__builtin_memcpy( &C$1, &TMP$4$1, 8 );
		_ZN25LF08B29542EF53F89_Lt_0003IiE10__FBINVOKEEi( &C$1, 5 );
		_ZN25LF08B29542EF53F89_Lt_0003IiE10__FBINVOKEEi( &C$1, 7 );
		if( (int64)TOTAL$1 == 12ll) goto label$13;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 74ll, (char*)"__FB_MODLEVELPROC__", (char*)"total = 12" );
			label$13:;
		}
		TOTAL$1 = 100;
		_ZN25LF08B29542EF53F89_Lt_0003IiE10__FBINVOKEEi( &C$1, 1 );
		if( (int64)TOTAL$1 == 101ll) goto label$15;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 79ll, (char*)"__FB_MODLEVELPROC__", (char*)"total = 101" );
			label$15:;
		}
	}
	{
		int32 BIAS$1;
		BIAS$1 = 10;
		struct $25LF08B29542EF53F89_Lt_0009IiE TMP$10$1;
		__builtin_memset( &TMP$10$1, 0, 4ll );
		*(int32*)&TMP$10$1 = BIAS$1;
		struct $25LF08B29542EF53F89_Lt_0009IiE A$1;
		__builtin_memcpy( &A$1, &TMP$10$1, 4 );
		BIAS$1 = 999;
		int32 vr$13 = _ZN25LF08B29542EF53F89_Lt_0009IiE10__FBINVOKEEi( &A$1, 5 );
		if( (int64)vr$13 == 15ll) goto label$19;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 93ll, (char*)"__FB_MODLEVELPROC__", (char*)"a( 5 ) = 15" );
			label$19:;
		}
		int32 vr$16 = _ZN25LF08B29542EF53F89_Lt_0009IiE10__FBINVOKEEi( &A$1, 0 );
		if( (int64)vr$16 == 10ll) goto label$21;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 94ll, (char*)"__FB_MODLEVELPROC__", (char*)"a( 0 ) = 10" );
			label$21:;
		}
		if( (int64)BIAS$1 == 999ll) goto label$23;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 95ll, (char*)"__FB_MODLEVELPROC__", (char*)"bias = 999" );
			label$23:;
		}
	}
	{
		FBSTRING TMP$18$1;
		FBSTRING TMP$20$1;
		FBSTRING TMP$22$1;
		FBSTRING TMP$26$1;
		int32 HITS$1;
		HITS$1 = 0;
		FBSTRING NEEDLE$1;
		fb_StrInit( (void*)&NEEDLE$1, -1ll, (void*)"err", 4ll, 0 );
		struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE TMP$16$1;
		_ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGEC1Ev( &TMP$16$1 );
		*(int32**)&TMP$16$1 = &HITS$1;
		fb_StrAssign( (void*)((uint8*)&TMP$16$1 + 8ll), -1ll, (void*)&NEEDLE$1, -1ll, 0 );
		struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE M$1;
		_ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGEC1ERKS1_( &M$1, (struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE*)&TMP$16$1 );
		__builtin_memset( &TMP$18$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$18$1, -1ll, (void*)"an err here", 12ll, 0 );
		_ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE10__FBINVOKEERS0_( &M$1, &TMP$18$1 );
		fb_StrDelete( (FBSTRING*)&TMP$18$1 );
		__builtin_memset( &TMP$20$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$20$1, -1ll, (void*)"fine", 5ll, 0 );
		_ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE10__FBINVOKEERS0_( &M$1, &TMP$20$1 );
		fb_StrDelete( (FBSTRING*)&TMP$20$1 );
		__builtin_memset( &TMP$22$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$22$1, -1ll, (void*)"err again", 10ll, 0 );
		_ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE10__FBINVOKEERS0_( &M$1, &TMP$22$1 );
		fb_StrDelete( (FBSTRING*)&TMP$22$1 );
		if( (int64)HITS$1 == 2ll) goto label$35;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 111ll, (char*)"__FB_MODLEVELPROC__", (char*)"hits = 2" );
			label$35:;
		}
		fb_StrAssign( (void*)&NEEDLE$1, -1ll, (void*)"zzz", 4ll, 0 );
		__builtin_memset( &TMP$26$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$26$1, -1ll, (void*)"err once more", 14ll, 0 );
		_ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE10__FBINVOKEERS0_( &M$1, &TMP$26$1 );
		fb_StrDelete( (FBSTRING*)&TMP$26$1 );
		if( (int64)HITS$1 == 3ll) goto label$37;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 116ll, (char*)"__FB_MODLEVELPROC__", (char*)"hits = 3" );
			label$37:;
		}
		_ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGED1Ev( &M$1 );
		_ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGED1Ev( &TMP$16$1 );
		fb_StrDelete( (FBSTRING*)&NEEDLE$1 );
	}
	{
		int32 N1$1;
		N1$1 = 0;
		int32 N2$1;
		N2$1 = 0;
		struct $25LF08B29542EF53F89_Lt_001CIiE TMP$29$1;
		__builtin_memset( &TMP$29$1, 0, 8ll );
		*(int32**)&TMP$29$1 = &N1$1;
		struct $25LF08B29542EF53F89_Lt_001CIiE I1$1;
		__builtin_memcpy( &I1$1, &TMP$29$1, 8 );
		struct $25LF08B29542EF53F89_Lt_001EIiE TMP$31$1;
		__builtin_memset( &TMP$31$1, 0, 8ll );
		*(int32**)&TMP$31$1 = &N2$1;
		struct $25LF08B29542EF53F89_Lt_001EIiE I2$1;
		__builtin_memcpy( &I2$1, &TMP$31$1, 8 );
		_ZN25LF08B29542EF53F89_Lt_001CIiE10__FBINVOKEEv( &I1$1 );
		_ZN25LF08B29542EF53F89_Lt_001CIiE10__FBINVOKEEv( &I1$1 );
		_ZN25LF08B29542EF53F89_Lt_001EIiE10__FBINVOKEEv( &I2$1 );
		if( (int64)N1$1 == 2ll) goto label$43;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 133ll, (char*)"__FB_MODLEVELPROC__", (char*)"n1 = 2" );
			label$43:;
		}
		if( (int64)N2$1 == 10ll) goto label$45;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 134ll, (char*)"__FB_MODLEVELPROC__", (char*)"n2 = 10" );
			label$45:;
		}
	}
	{
		int32 BIAS$1;
		BIAS$1 = 1;
		struct $25LF08B29542EF53F89_Lt_0022IiE TMP$35$1;
		__builtin_memset( &TMP$35$1, 0, 4ll );
		*(int32*)&TMP$35$1 = BIAS$1;
		struct $25LF08B29542EF53F89_Lt_0022IiE F$1;
		__builtin_memcpy( &F$1, &TMP$35$1, 4 );
		int32 R$1;
		int32 vr$69 = _ZN25LF08B29542EF53F89_Lt_0022IiE10__FBINVOKEEi( &F$1, 5 );
		R$1 = vr$69;
		if( (int64)R$1 == 6ll) goto label$51;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 145ll, (char*)"__FB_MODLEVELPROC__", (char*)"r = 6" );
			label$51:;
		}
		int32 vr$72 = _ZN25LF08B29542EF53F89_Lt_0022IiE10__FBINVOKEEi( &F$1, 5 );
		if( ((int64)vr$72 + 1ll) == 7ll) goto label$53;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 148ll, (char*)"__FB_MODLEVELPROC__", (char*)"f( 5 ) + 1 = 7" );
			label$53:;
		}
		int32 vr$76 = _ZN25LF08B29542EF53F89_Lt_0022IiE10__FBINVOKEEi( &F$1, 1 );
		int32 vr$78 = _ZN25LF08B29542EF53F89_Lt_0022IiE10__FBINVOKEEi( &F$1, vr$76 );
		if( (int64)vr$78 == 3ll) goto label$55;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 149ll, (char*)"__FB_MODLEVELPROC__", (char*)"f( f( 1 ) ) = 3" );
			label$55:;
		}
		int32 TICKS$1;
		TICKS$1 = 0;
		struct $25LF08B29542EF53F89_Lt_0027IiE TMP$40$1;
		__builtin_memset( &TMP$40$1, 0, 8ll );
		*(int32**)&TMP$40$1 = &TICKS$1;
		struct $25LF08B29542EF53F89_Lt_0027IiE T$1;
		__builtin_memcpy( &T$1, &TMP$40$1, 8 );
		_ZN25LF08B29542EF53F89_Lt_0027IiE10__FBINVOKEEv( &T$1 );
		_ZN25LF08B29542EF53F89_Lt_0027IiE10__FBINVOKEEv( &T$1 );
		if( (int64)TICKS$1 == 2ll) goto label$57;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 157ll, (char*)"__FB_MODLEVELPROC__", (char*)"ticks = 2" );
			label$57:;
		}
	}
	{
		tmp$42 E$1;
		E$1 = (tmp$42)&LF08B29542EF53F89_LT_002B;
		int32 vr$87 = (E$1)( 21 );
		if( (int64)vr$87 == 42ll) goto label$63;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 168ll, (char*)"__FB_MODLEVELPROC__", (char*)"e( 21 ) = 42" );
			label$63:;
		}
		goto label$65;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 169ll, (char*)"__FB_MODLEVELPROC__", (char*)"sizeof( e ) = sizeof( any ptr )" );
			label$65:;
		}
	}
	{
		tmp$50 TMP$51$1;
		int32 SUM_$1;
		SUM_$1 = 0;
		struct $25LF08B29542EF53F89_Lt_002EIiE TMP$47$1;
		__builtin_memset( &TMP$47$1, 0, 8ll );
		*(int32**)&TMP$47$1 = &SUM_$1;
		_Z5ApplyI25LF08B29542EF53F89_Lt_002EIiEEiRS1_( 4, &TMP$47$1 );
		if( (int64)SUM_$1 == 10ll) goto label$69;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 180ll, (char*)"__FB_MODLEVELPROC__", (char*)"sum_ = 10" );
			label$69:;
		}
		int32 SEEN$1;
		SEEN$1 = 0;
		TMP$51$1 = (tmp$50)&LF08B29542EF53F89_LT_0031;
		_Z5ApplyIPFviEEiRS1_( 3, &TMP$51$1 );
		if( (int64)SEEN$1 == 0ll) goto label$71;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 185ll, (char*)"__FB_MODLEVELPROC__", (char*)"seen = 0" );
			label$71:;
		}
		int32 BIAS$1;
		BIAS$1 = 2;
		struct $25LF08B29542EF53F89_Lt_0035IiE TMP$54$1;
		__builtin_memset( &TMP$54$1, 0, 4ll );
		*(int32*)&TMP$54$1 = BIAS$1;
		int32 GOT$1;
		int32 vr$97 = _Z6ApplyRI25LF08B29542EF53F89_Lt_0035IiEEiRS1_( 3, &TMP$54$1 );
		GOT$1 = vr$97;
		if( (int64)GOT$1 == 5ll) goto label$73;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 194ll, (char*)"__FB_MODLEVELPROC__", (char*)"got = 5" );
			label$73:;
		}
	}
	{
		tmp$65 TMP$66$1;
		struct $5ArrayIiE NUMS$1;
		_ZN5ArrayIiEC1Ev( &NUMS$1 );
		{
			int32 I$2;
			I$2 = 1;
			label$107:;
			{
				_ZN5ArrayIiE4PUSHERi( &NUMS$1, &I$2 );
			}
			label$105:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$104:;
			if( (int64)I$2 <= 4ll) goto label$107;
			label$106:;
		}
		int64 TOTAL$1;
		TOTAL$1 = 0ll;
		struct $25LF08B29542EF53F89_Lt_003DIxE TMP$62$1;
		__builtin_memset( &TMP$62$1, 0, 8ll );
		*(int64**)&TMP$62$1 = &TOTAL$1;
		_Z7ForEachIi25LF08B29542EF53F89_Lt_003DIxEER5ArrayIiERS1_( &NUMS$1, &TMP$62$1 );
		if( TOTAL$1 == 10ll) goto label$109;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 207ll, (char*)"__FB_MODLEVELPROC__", (char*)"total = 10" );
			label$109:;
		}
		TMP$66$1 = (tmp$65)&LF08B29542EF53F89_LT_0040;
		_Z7ForEachIiPFvRiEER5ArrayIiERS2_( &NUMS$1, &TMP$66$1 );
		int32* vr$113 = _ZN5ArrayIiEixEi( &NUMS$1, 0 );
		if( (int64)*vr$113 == 2ll) goto label$111;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 211ll, (char*)"__FB_MODLEVELPROC__", (char*)"nums[ 0 ] = 2" );
			label$111:;
		}
		int32* vr$116 = _ZN5ArrayIiEixEi( &NUMS$1, 3 );
		if( (int64)*vr$116 == 8ll) goto label$113;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 212ll, (char*)"__FB_MODLEVELPROC__", (char*)"nums[ 3 ] = 8" );
			label$113:;
		}
		FBSTRING SEP$1;
		fb_StrInit( (void*)&SEP$1, -1ll, (void*)"-", 2ll, 0 );
		FBSTRING OUT_$1;
		fb_StrInit( (void*)&OUT_$1, -1ll, (void*)"", 1ll, 0 );
		struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE TMP$71$1;
		_ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGEC1Ev( &TMP$71$1 );
		*(FBSTRING**)&TMP$71$1 = &OUT_$1;
		fb_StrAssign( (void*)((uint8*)&TMP$71$1 + 8ll), -1ll, (void*)&SEP$1, -1ll, 0 );
		_Z7ForEachIi25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGEER5ArrayIiERS3_( &NUMS$1, &TMP$71$1 );
		int32 vr$127 = fb_StrCompare( (void*)&OUT_$1, -1ll, (void*)"2-4-6-8-", 9ll );
		if( (int64)vr$127 == 0ll) goto label$123;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 220ll, (char*)"__FB_MODLEVELPROC__", (char*)"out_ = \x22" "2-4-6-8-\x22" );
			label$123:;
		}
		_ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGED1Ev( &TMP$71$1 );
		fb_StrDelete( (FBSTRING*)&OUT_$1 );
		fb_StrDelete( (FBSTRING*)&SEP$1 );
		_ZN5ArrayIiED1Ev( &NUMS$1 );
	}
	{
		struct $2PT P$1;
		__builtin_memset( &P$1, 0, 8ll );
		*(int32*)&P$1 = 3;
		*(int32*)((uint8*)&P$1 + 4ll) = 4;
		int32 GOT$1;
		GOT$1 = 0;
		struct $25LF08B29542EF53F89_Lt_0055I2PTiE TMP$86$1;
		__builtin_memset( &TMP$86$1, 0, 16ll );
		*(struct $2PT**)&TMP$86$1 = &P$1;
		*(int32**)((uint8*)&TMP$86$1 + 8ll) = &GOT$1;
		struct $25LF08B29542EF53F89_Lt_0055I2PTiE C$1;
		__builtin_memcpy( &C$1, &TMP$86$1, 16 );
		_ZN25LF08B29542EF53F89_Lt_0055I2PTiE10__FBINVOKEEv( &C$1 );
		if( (int64)GOT$1 == 7ll) goto label$221;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 240ll, (char*)"__FB_MODLEVELPROC__", (char*)"got = 7" );
			label$221:;
		}
		if( (int64)*(int32*)&P$1 == 99ll) goto label$223;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 241ll, (char*)"__FB_MODLEVELPROC__", (char*)"p.x = 99" );
			label$223:;
		}
		struct $2PT Q$1;
		__builtin_memset( &Q$1, 0, 8ll );
		*(int32*)&Q$1 = 1;
		*(int32*)((uint8*)&Q$1 + 4ll) = 2;
		int32 GOT2$1;
		GOT2$1 = 0;
		struct $25LF08B29542EF53F89_Lt_0059I2PTiE TMP$90$1;
		__builtin_memset( &TMP$90$1, 0, 16ll );
		__builtin_memcpy( (struct $2PT*)&TMP$90$1, &Q$1, 8 );
		*(int32**)((uint8*)&TMP$90$1 + 8ll) = &GOT2$1;
		struct $25LF08B29542EF53F89_Lt_0059I2PTiE D$1;
		__builtin_memcpy( &D$1, &TMP$90$1, 16 );
		*(int32*)&Q$1 = 100;
		_ZN25LF08B29542EF53F89_Lt_0059I2PTiE10__FBINVOKEEv( &D$1 );
		if( (int64)GOT2$1 == 3ll) goto label$225;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 252ll, (char*)"__FB_MODLEVELPROC__", (char*)"got2 = 3" );
			label$225:;
		}
	}
	{
		int32 TMP$92$1;
		struct $5ArrayIiE SRC$1;
		_ZN5ArrayIiEC1Ev( &SRC$1 );
		TMP$92$1 = 7;
		_ZN5ArrayIiE4PUSHERi( &SRC$1, &TMP$92$1 );
		int32 GOT$1;
		GOT$1 = 0;
		struct $25LF08B29542EF53F89_Lt_005DI5ArrayIiEiE TMP$94$1;
		__builtin_memset( &TMP$94$1, 0, 16ll );
		*(struct $5ArrayIiE**)&TMP$94$1 = &SRC$1;
		*(int32**)((uint8*)&TMP$94$1 + 8ll) = &GOT$1;
		struct $25LF08B29542EF53F89_Lt_005DI5ArrayIiEiE C$1;
		__builtin_memcpy( &C$1, &TMP$94$1, 16 );
		_ZN25LF08B29542EF53F89_Lt_005DI5ArrayIiEiE10__FBINVOKEEv( &C$1 );
		if( (int64)GOT$1 == 7ll) goto label$231;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 276ll, (char*)"__FB_MODLEVELPROC__", (char*)"got = 7" );
			label$231:;
		}
		int32 vr$162 = _ZN5ArrayIiE5COUNTEv( &SRC$1 );
		if( (int64)vr$162 == 2ll) goto label$233;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 277ll, (char*)"__FB_MODLEVELPROC__", (char*)"src.Count( ) = 2" );
			label$233:;
		}
		int32* vr$165 = _ZN5ArrayIiEixEi( &SRC$1, 1 );
		if( (int64)*vr$165 == 9ll) goto label$235;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 278ll, (char*)"__FB_MODLEVELPROC__", (char*)"src[ 1 ] = 9" );
			label$235:;
		}
		_ZN5ArrayIiED1Ev( &SRC$1 );
	}
	{
		int32 TMP$98$1;
		int32 TMP$101$1;
		struct $5ArrayIiE ORIG$1;
		_ZN5ArrayIiEC1Ev( &ORIG$1 );
		TMP$98$1 = 1;
		_ZN5ArrayIiE4PUSHERi( &ORIG$1, &TMP$98$1 );
		int32 N$1;
		N$1 = 0;
		struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE TMP$100$1;
		_ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiEC1Ev( &TMP$100$1 );
		_ZN5ArrayIiEaSERKS0_( (struct $5ArrayIiE*)&TMP$100$1, (struct $5ArrayIiE*)&ORIG$1 );
		*(int32**)((uint8*)&TMP$100$1 + 80ll) = &N$1;
		struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE D$1;
		_ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiEC1ERKS2_( &D$1, (struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE*)&TMP$100$1 );
		TMP$101$1 = 2;
		_ZN5ArrayIiE4PUSHERi( &ORIG$1, &TMP$101$1 );
		_ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE10__FBINVOKEEv( &D$1 );
		if( (int64)N$1 == 1ll) goto label$247;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 294ll, (char*)"__FB_MODLEVELPROC__", (char*)"n = 1" );
			label$247:;
		}
		int32 vr$182 = _ZN5ArrayIiE5COUNTEv( &ORIG$1 );
		if( (int64)vr$182 == 2ll) goto label$249;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 295ll, (char*)"__FB_MODLEVELPROC__", (char*)"orig.Count( ) = 2" );
			label$249:;
		}
		_ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiED1Ev( &D$1 );
		_ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiED1Ev( &TMP$100$1 );
		_ZN5ArrayIiED1Ev( &ORIG$1 );
	}
	{
		int32 TMP$104$1;
		struct $8OptionalIiE O$1;
		TMP$104$1 = 5;
		struct $8OptionalIiE vr$188 = _Z4SomeIiERi( &TMP$104$1 );
		O$1 = vr$188;
		int32 OV$1;
		OV$1 = 0;
		struct $25LF08B29542EF53F89_Lt_0069I8OptionalIiEiE TMP$106$1;
		__builtin_memset( &TMP$106$1, 0, 16ll );
		*(struct $8OptionalIiE**)&TMP$106$1 = &O$1;
		*(int32**)((uint8*)&TMP$106$1 + 8ll) = &OV$1;
		struct $25LF08B29542EF53F89_Lt_0069I8OptionalIiEiE E$1;
		__builtin_memcpy( &E$1, &TMP$106$1, 16 );
		_ZN25LF08B29542EF53F89_Lt_0069I8OptionalIiEiE10__FBINVOKEEv( &E$1 );
		if( (int64)OV$1 == 5ll) goto label$253;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 306ll, (char*)"__FB_MODLEVELPROC__", (char*)"ov = 5" );
			label$253:;
		}
	}
	LIVECOUNTED$ = 0;
	MADECOUNTED$ = 0;
	{
		struct $7COUNTED C$1;
		_ZN7COUNTEDC1Ei( &C$1, 5 );
		int32 GOT$1;
		GOT$1 = 0;
		struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE TMP$111$1;
		_ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiEC1Ev( &TMP$111$1 );
		_ZN7COUNTEDaSERS_( (struct $7COUNTED*)&TMP$111$1, &C$1 );
		*(int32**)((uint8*)&TMP$111$1 + 8ll) = &GOT$1;
		struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE F$1;
		_ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiEC1ERKS1_( &F$1, (struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE*)&TMP$111$1 );
		_ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiE10__FBINVOKEEv( &F$1 );
		if( (int64)GOT$1 == 5ll) goto label$281;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 325ll, (char*)"__FB_MODLEVELPROC__", (char*)"got = 5" );
			label$281:;
		}
		if( (int64)MADECOUNTED$ >= 2ll) goto label$283;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 326ll, (char*)"__FB_MODLEVELPROC__", (char*)"madeCounted >= 2" );
			label$283:;
		}
		_ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiED1Ev( &F$1 );
		_ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiED1Ev( &TMP$111$1 );
		_ZN7COUNTEDD1Ev( &C$1 );
	}
	if( (int64)LIVECOUNTED$ == 0ll) goto label$287;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 329ll, (char*)"__FB_MODLEVELPROC__", (char*)"liveCounted = 0" );
		label$287:;
	}
	LIVECOUNTED$ = 0;
	MADECOUNTED$ = 0;
	{
		struct $7COUNTED C$1;
		_ZN7COUNTEDC1Ei( &C$1, 3 );
		int32 MADE0$1;
		MADE0$1 = MADECOUNTED$;
		int32 GOT$1;
		GOT$1 = 0;
		struct $25LF08B29542EF53F89_Lt_0073I7COUNTEDiE TMP$116$1;
		__builtin_memset( &TMP$116$1, 0, 16ll );
		*(struct $7COUNTED**)&TMP$116$1 = &C$1;
		*(int32**)((uint8*)&TMP$116$1 + 8ll) = &GOT$1;
		struct $25LF08B29542EF53F89_Lt_0073I7COUNTEDiE F$1;
		__builtin_memcpy( &F$1, &TMP$116$1, 16 );
		_ZN25LF08B29542EF53F89_Lt_0073I7COUNTEDiE10__FBINVOKEEv( &F$1 );
		if( (int64)GOT$1 == 3ll) goto label$289;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 345ll, (char*)"__FB_MODLEVELPROC__", (char*)"got = 3" );
			label$289:;
		}
		if( (int64)MADECOUNTED$ == (int64)MADE0$1) goto label$291;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 346ll, (char*)"__FB_MODLEVELPROC__", (char*)"madeCounted = made0" );
			label$291:;
		}
		_ZN7COUNTEDD1Ev( &C$1 );
	}
	if( (int64)LIVECOUNTED$ == 0ll) goto label$295;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5Clambda-capture.bas", 349ll, (char*)"__FB_MODLEVELPROC__", (char*)"liveCounted = 0" );
		label$295:;
	}
	label$1:;
}

static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGEC1Ev( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* THIS$1 )
{
	__builtin_memset( (int32**)THIS$1, 0, 8ll );
	__builtin_memset( (FBSTRING*)((uint8*)THIS$1 + 8ll), 0, 24ll );
	label$26:;
	label$27:;
}

static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGEaSERKS1_( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* THIS$1, struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* __FB_RHS__$1 )
{
	label$28:;
	*(int32**)THIS$1 = *(int32**)__FB_RHS__$1;
	fb_StrAssign( (void*)((uint8*)THIS$1 + 8ll), -1ll, (void*)((uint8*)__FB_RHS__$1 + 8ll), -1ll, 0 );
	label$29:;
}

static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGEC1ERKS1_( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* THIS$1, struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* __FB_RHS__$1 )
{
	label$30:;
	__builtin_memset( (int32**)THIS$1, 0, 8ll );
	__builtin_memset( (FBSTRING*)((uint8*)THIS$1 + 8ll), 0, 24ll );
	_ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGEaSERKS1_( THIS$1, __FB_RHS__$1 );
	label$31:;
}

static void _ZN25LF08B29542EF53F89_Lt_000FIi8FBSTRINGED1Ev( struct $25LF08B29542EF53F89_Lt_000FIi8FBSTRINGE* THIS$1 )
{
	label$32:;
	label$33:;
	fb_StrDelete( (FBSTRING*)((uint8*)THIS$1 + 8ll) );
}

static void _ZN5ArrayIiEC1Ev( struct $5ArrayIiE* THIS$1 )
{
	*(int32**)THIS$1 = (int32*)0ull;
	*(int32**)((uint8*)THIS$1 + 8ll) = (int32*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 4ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$94:;
	label$95:;
}

static void _ZN5ArrayIiEaSERKS0_( struct $5ArrayIiE* THIS$1, struct $5ArrayIiE* __FB_RHS__$1 )
{
	int32* TMP$58$1;
	int32* TMP$59$1;
	int32* TMP$60$1;
	label$96:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)0ull, (void*)0ull );
	TMP$58$1 = *(int32**)((uint8*)THIS$1 + 8ll);
	TMP$59$1 = *(int32**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$60$1 = (int32*)((uint8*)TMP$59$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$98:;
	if( TMP$59$1 >= TMP$60$1) goto label$99;
	*TMP$58$1 = *TMP$59$1;
	TMP$58$1 = (int32*)((uint8*)TMP$58$1 + 4ll);
	TMP$59$1 = (int32*)((uint8*)TMP$59$1 + 4ll);
	goto label$98;
	label$99:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$97:;
}

static void _ZN5ArrayIiED1Ev( struct $5ArrayIiE* THIS$1 )
{
	label$102:;
	label$103:;
	fb_ArrayErase( (struct $7FBARRAYIvE*)THIS$1 );
}

static void _ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGEC1Ev( struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* THIS$1 )
{
	__builtin_memset( (FBSTRING**)THIS$1, 0, 8ll );
	__builtin_memset( (FBSTRING*)((uint8*)THIS$1 + 8ll), 0, 24ll );
	label$114:;
	label$115:;
}

static void _ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGEaSERKS2_( struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* THIS$1, struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* __FB_RHS__$1 )
{
	label$116:;
	*(FBSTRING**)THIS$1 = *(FBSTRING**)__FB_RHS__$1;
	fb_StrAssign( (void*)((uint8*)THIS$1 + 8ll), -1ll, (void*)((uint8*)__FB_RHS__$1 + 8ll), -1ll, 0 );
	label$117:;
}

static void _ZN25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGED1Ev( struct $25LF08B29542EF53F89_Lt_0046I8FBSTRING8FBSTRINGE* THIS$1 )
{
	label$120:;
	label$121:;
	fb_StrDelete( (FBSTRING*)((uint8*)THIS$1 + 8ll) );
}

static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiEC1Ev( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* THIS$1 )
{
	_ZN5ArrayIiEC1Ev( (struct $5ArrayIiE*)THIS$1 );
	__builtin_memset( (int32**)((uint8*)THIS$1 + 80ll), 0, 8ll );
	label$238:;
	label$239:;
}

static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiEaSERKS2_( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* THIS$1, struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* __FB_RHS__$1 )
{
	label$240:;
	_ZN5ArrayIiEaSERKS0_( (struct $5ArrayIiE*)THIS$1, (struct $5ArrayIiE*)__FB_RHS__$1 );
	*(int32**)((uint8*)THIS$1 + 80ll) = *(int32**)((uint8*)__FB_RHS__$1 + 80ll);
	label$241:;
}

static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiEC1ERKS2_( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* THIS$1, struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* __FB_RHS__$1 )
{
	label$242:;
	_ZN5ArrayIiEC1Ev( (struct $5ArrayIiE*)THIS$1 );
	__builtin_memset( (int32**)((uint8*)THIS$1 + 80ll), 0, 8ll );
	_ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiEaSERKS2_( THIS$1, __FB_RHS__$1 );
	label$243:;
}

static void _ZN25LF08B29542EF53F89_Lt_0063I5ArrayIiEiED1Ev( struct $25LF08B29542EF53F89_Lt_0063I5ArrayIiEiE* THIS$1 )
{
	label$244:;
	label$245:;
	_ZN5ArrayIiED1Ev( (struct $5ArrayIiE*)THIS$1 );
}

static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiEC1Ev( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* THIS$1 )
{
	_ZN7COUNTEDC1Ev( (struct $7COUNTED*)THIS$1 );
	__builtin_memset( (int32**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	label$272:;
	label$273:;
}

static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiEaSERKS1_( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* THIS$1, struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* __FB_RHS__$1 )
{
	label$274:;
	_ZN7COUNTEDaSERS_( (struct $7COUNTED*)THIS$1, (struct $7COUNTED*)__FB_RHS__$1 );
	*(int32**)((uint8*)THIS$1 + 8ll) = *(int32**)((uint8*)__FB_RHS__$1 + 8ll);
	label$275:;
}

static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiEC1ERKS1_( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* THIS$1, struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* __FB_RHS__$1 )
{
	label$276:;
	_ZN7COUNTEDC1Ev( (struct $7COUNTED*)THIS$1 );
	__builtin_memset( (int32**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	_ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiEaSERKS1_( THIS$1, __FB_RHS__$1 );
	label$277:;
}

static void _ZN25LF08B29542EF53F89_Lt_006EI7COUNTEDiED1Ev( struct $25LF08B29542EF53F89_Lt_006EI7COUNTEDiE* THIS$1 )
{
	label$278:;
	label$279:;
	_ZN7COUNTEDD1Ev( (struct $7COUNTED*)THIS$1 );
}
