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
struct $3REC {
	int32 KEY;
	int32 TAG;
};
__FB_STATIC_ASSERT( sizeof( struct $3REC ) == 8 );
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
struct $10LinkedNodeIiE;
struct $10LinkedNodeIiE {
	int32 VALUE;
	struct $10LinkedNodeIiE* NXT;
	struct $10LinkedNodeIiE* PRV;
};
__FB_STATIC_ASSERT( sizeof( struct $10LinkedNodeIiE ) == 24 );
struct $10LinkedListIiE {
	struct $10LinkedNodeIiE* HEAD;
	struct $10LinkedNodeIiE* TAIL;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $10LinkedListIiE ) == 24 );
struct $18LinkedListIteratorIiE {
	void* NODE;
};
__FB_STATIC_ASSERT( sizeof( struct $18LinkedListIteratorIiE ) == 8 );
struct $13ArrayIteratorIiE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorIiE ) == 16 );
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
typedef boolean (*tmp$50)( int32*, int32* );
struct $13ArrayIteratorI8FBSTRINGE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorI8FBSTRINGE ) == 16 );
struct $8FBARRAY1I8FBSTRINGE {
	FBSTRING* DATA;
	FBSTRING* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1I8FBSTRINGE ) == 72 );
struct $5ArrayI8FBSTRINGE {
	struct $8FBARRAY1I8FBSTRINGE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayI8FBSTRINGE ) == 80 );
typedef boolean (*tmp$129)( FBSTRING*, FBSTRING* );
struct $13ArrayIteratorIdE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorIdE ) == 16 );
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
struct $5ArrayIdE {
	struct $8FBARRAY1IdE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayIdE ) == 80 );
typedef boolean (*tmp$140)( double*, double* );
struct $13ArrayIteratorI3RECE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorI3RECE ) == 16 );
struct $8FBARRAY1I3RECE {
	struct $3REC* DATA;
	struct $3REC* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1I3RECE ) == 72 );
struct $5ArrayI3RECE {
	struct $8FBARRAY1I3RECE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayI3RECE ) == 80 );
typedef boolean (*tmp$149)( struct $3REC*, struct $3REC* );
struct $25LD2939E50C2FFBF23_Lt_00ADIiE {
	int32* __CAP_COMPARISONS;
};
__FB_STATIC_ASSERT( sizeof( struct $25LD2939E50C2FFBF23_Lt_00ADIiE ) == 8 );
struct $25LD2939E50C2FFBF23_Lt_00BEIiE {
	int32* __CAP_COMPARISONS;
};
__FB_STATIC_ASSERT( sizeof( struct $25LD2939E50C2FFBF23_Lt_00BEIiE ) == 8 );
struct $7FBARRAYIiE {
	int32* DATA;
	int32* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYIiE ) == 240 );
struct $7FBARRAYI3RECE {
	struct $3REC* DATA;
	struct $3REC* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYI3RECE ) == 240 );
struct $25LD2939E50C2FFBF23_Lt_00E8IiE {
	int32* __CAP_COMPARISONS;
};
__FB_STATIC_ASSERT( sizeof( struct $25LD2939E50C2FFBF23_Lt_00E8IiE ) == 8 );
struct $7FBARRAYI8FBSTRINGE {
	FBSTRING* DATA;
	FBSTRING* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYI8FBSTRINGE ) == 240 );
struct $13ArrayIteratorI7COUNTEDE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorI7COUNTEDE ) == 16 );
struct $8FBARRAY1I7COUNTEDE {
	struct $7COUNTED* DATA;
	struct $7COUNTED* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1I7COUNTEDE ) == 72 );
struct $5ArrayI7COUNTEDE {
	struct $8FBARRAY1I7COUNTEDE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayI7COUNTEDE ) == 80 );
typedef boolean (*tmp$275)( struct $7COUNTED*, struct $7COUNTED* );
struct $7FBARRAYI7COUNTEDE {
	struct $7COUNTED* DATA;
	struct $7COUNTED* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYI7COUNTEDE ) == 240 );
struct $18LinkedListIteratorI8FBSTRINGE {
	void* NODE;
};
__FB_STATIC_ASSERT( sizeof( struct $18LinkedListIteratorI8FBSTRINGE ) == 8 );
struct $10LinkedNodeI8FBSTRINGE;
struct $10LinkedNodeI8FBSTRINGE {
	FBSTRING VALUE;
	struct $10LinkedNodeI8FBSTRINGE* NXT;
	struct $10LinkedNodeI8FBSTRINGE* PRV;
};
__FB_STATIC_ASSERT( sizeof( struct $10LinkedNodeI8FBSTRINGE ) == 40 );
struct $10LinkedListI8FBSTRINGE {
	struct $10LinkedNodeI8FBSTRINGE* HEAD;
	struct $10LinkedNodeI8FBSTRINGE* TAIL;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $10LinkedListI8FBSTRINGE ) == 24 );
struct $25LD2939E50C2FFBF23_Lt_0150IiE {
	int32* __CAP_COMPARISONS;
};
__FB_STATIC_ASSERT( sizeof( struct $25LD2939E50C2FFBF23_Lt_0150IiE ) == 8 );
struct $18LinkedListIteratorI3RECE {
	void* NODE;
};
__FB_STATIC_ASSERT( sizeof( struct $18LinkedListIteratorI3RECE ) == 8 );
struct $10LinkedNodeI3RECE;
struct $10LinkedNodeI3RECE {
	struct $3REC VALUE;
	struct $10LinkedNodeI3RECE* NXT;
	struct $10LinkedNodeI3RECE* PRV;
};
__FB_STATIC_ASSERT( sizeof( struct $10LinkedNodeI3RECE ) == 24 );
struct $10LinkedListI3RECE {
	struct $10LinkedNodeI3RECE* HEAD;
	struct $10LinkedNodeI3RECE* TAIL;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $10LinkedListI3RECE ) == 24 );
struct $18LinkedListIteratorI7COUNTEDE {
	void* NODE;
};
__FB_STATIC_ASSERT( sizeof( struct $18LinkedListIteratorI7COUNTEDE ) == 8 );
struct $10LinkedNodeI7COUNTEDE;
struct $10LinkedNodeI7COUNTEDE {
	struct $7COUNTED VALUE;
	struct $10LinkedNodeI7COUNTEDE* NXT;
	struct $10LinkedNodeI7COUNTEDE* PRV;
};
__FB_STATIC_ASSERT( sizeof( struct $10LinkedNodeI7COUNTEDE ) == 24 );
struct $10LinkedListI7COUNTEDE {
	struct $10LinkedNodeI7COUNTEDE* HEAD;
	struct $10LinkedNodeI7COUNTEDE* TAIL;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $10LinkedListI7COUNTEDE ) == 24 );
static struct $7COUNTED tmp$367;
static struct $7COUNTED tmp$369;
struct $13ArrayIteratorI5ArrayIiEE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorI5ArrayIiEE ) == 16 );
struct $8FBARRAY1I5ArrayIiEE {
	struct $5ArrayIiE* DATA;
	struct $5ArrayIiE* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1I5ArrayIiEE ) == 72 );
struct $5ArrayI5ArrayIiEE {
	struct $8FBARRAY1I5ArrayIiEE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayI5ArrayIiEE ) == 80 );
int32 fb_ArrayRedimEx( struct $7FBARRAYIvE*, uint64, int32, int32, uint64, ... );
int32 fb_ArrayRedimPresvEx( struct $7FBARRAYIvE*, uint64, int32, int32, uint64, ... );
int32 fb_ArrayRedimObj( struct $7FBARRAYIvE*, uint64, void*, void*, uint64, ... );
int32 fb_ArrayRedimPresvObj( struct $7FBARRAYIvE*, uint64, void*, void*, uint64, ... );
int32 fb_ArrayRedimTo( struct $7FBARRAYIvE*, struct $7FBARRAYIvE*, int32, void*, void* );
int32 fb_ArrayErase( struct $7FBARRAYIvE* );
int32 fb_ArrayEraseObj( struct $7FBARRAYIvE*, void*, void* );
void fb_ArrayStrErase( struct $7FBARRAYIvE* );
int64 fb_ArrayLBound( struct $7FBARRAYIKvE*, int64 );
int64 fb_ArrayUBound( struct $7FBARRAYIKvE*, int64 );
void fb_Assert( char*, int64, char*, char* );
void fb_MemSwap( void*, void*, int64 );
void* calloc( uint64, uint64 );
void free( void* );
void fb_PrintString( int32, FBSTRING*, int32 );
FBSTRING* fb_StrInit( void*, int64, void*, int64, int32 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_StrAllocTempResult( FBSTRING* );
FBSTRING* fb_StrAllocTempDescZEx( char*, int64 );
FBSTRING* fb_LongintToStr( int64 );
int64 fb_StrLen( void*, int64 );
void fb_StrSwap( void*, int64, int32, void*, int64, int32 );
int32 atexit( void* );
static void fb_ctor__containerzsort( void ) __attribute__(( constructor ));
void SEEDRNG( uint64 );
int32 NEXTRNG( int32 );
void _ZN7COUNTEDC1Ev( struct $7COUNTED* );
void _ZN7COUNTEDC1Ei( struct $7COUNTED*, int32 );
void _ZN7COUNTEDC1ERS_( struct $7COUNTED*, struct $7COUNTED* );
void _ZN7COUNTEDaSERS_( struct $7COUNTED*, struct $7COUNTED* );
void _ZN7COUNTEDD1Ev( struct $7COUNTED* );
boolean _ZltR7COUNTEDS0_( struct $7COUNTED*, struct $7COUNTED* );
boolean _ZltR3RECS0_( struct $3REC*, struct $3REC* );
static void _ZN10LinkedListIiEC1Ev( struct $10LinkedListIiE* );
static void _ZN10LinkedListIiEC1ERS0_( struct $10LinkedListIiE*, struct $10LinkedListIiE* );
static void _ZN10LinkedListIiED1Ev( struct $10LinkedListIiE* );
static int32 _ZN10LinkedListIiE5COUNTEv( struct $10LinkedListIiE* );
static void _ZN10LinkedListIiE9PUSHFRONTERi( struct $10LinkedListIiE*, int32* );
static void _ZN10LinkedListIiE8PUSHBACKERi( struct $10LinkedListIiE*, int32* );
static int32 _ZN10LinkedListIiE8POPFRONTEv( struct $10LinkedListIiE* );
static int32 _ZN10LinkedListIiE7POPBACKEv( struct $10LinkedListIiE* );
static int32* _ZN10LinkedListIiE5FRONTEv( struct $10LinkedListIiE* );
static int32* _ZN10LinkedListIiE4BACKEv( struct $10LinkedListIiE* );
static void _ZN10LinkedListIiE5CLEAREv( struct $10LinkedListIiE* );
static void _ZN10LinkedListIiE8COPYFROMERS0_( struct $10LinkedListIiE*, struct $10LinkedListIiE* );
static int32 _ZN5ArrayIiE5COUNTEv( struct $5ArrayIiE* );
static int32 _ZN5ArrayIiE8CAPACITYEv( struct $5ArrayIiE* );
static int32* _ZN5ArrayIiEixEi( struct $5ArrayIiE*, int32 );
static void _ZN5ArrayIiE4PUSHERi( struct $5ArrayIiE*, int32* );
static void _ZN5ArrayIiE5CLEAREv( struct $5ArrayIiE* );
static void _ZN5ArrayIiE7RESERVEEi( struct $5ArrayIiE*, int32 );
static void _ZN5ArrayIiEC1Ev( struct $5ArrayIiE* );
static void _ZN5ArrayIiEaSERKS0_( struct $5ArrayIiE*, struct $5ArrayIiE* );
static void _ZN5ArrayIiEC1ERKS0_( struct $5ArrayIiE*, struct $5ArrayIiE* );
static void _ZN5ArrayIiED1Ev( struct $5ArrayIiE* );
struct $5ArrayIiE* LISTFORWARD( struct $5ArrayIiE*, struct $10LinkedListIiE* );
struct $5ArrayIiE* LISTBACKWARD( struct $5ArrayIiE*, struct $10LinkedListIiE* );
boolean SAMEMULTISET( struct $5ArrayIiE*, struct $5ArrayIiE* );
boolean ASCENDING( struct $5ArrayIiE* );
void MAKESHAPE( struct $5ArrayIiE*, int32, int32 );
static void _Z4SortIiER5ArrayIiE( struct $5ArrayIiE* );
static boolean _Z8IsSortedIiER5ArrayIiE( struct $5ArrayIiE* );
boolean L3C22B1CEA777A486_LT_0031( int32*, int32* );
static void _Z6SortByIiPFbRiRiEER5ArrayIiERS3_( struct $5ArrayIiE*, tmp$50* );
boolean L3C22B1CEA777A486_LT_0034( int32*, int32* );
static boolean _Z10IsSortedByIiPFbRiRiEER5ArrayIiERS3_( struct $5ArrayIiE*, tmp$50* );
static void _Z11SortIntroByIiPFbRiRiEER5ArrayIiEiiiRS3_( struct $5ArrayIiE*, int32, int32, int32, tmp$50* );
static void _Z10SortHeapByIiPFbRiRiEER5ArrayIiEiiRS3_( struct $5ArrayIiE*, int32, int32, tmp$50* );
static int32 _Z15SortPartitionByIiPFbRiRiEER5ArrayIiEiiRS3_( struct $5ArrayIiE*, int32, int32, tmp$50* );
static void _Z15SortInsertionByIiPFbRiRiEER5ArrayIiEiiRS3_( struct $5ArrayIiE*, int32, int32, tmp$50* );
static void _Z14SortSiftDownByIiPFbRiRiEER5ArrayIiEiiiRS3_( struct $5ArrayIiE*, int32, int32, int32, tmp$50* );
static int32 _ZN5ArrayI8FBSTRINGE5COUNTEv( struct $5ArrayI8FBSTRINGE* );
static int32 _ZN5ArrayI8FBSTRINGE8CAPACITYEv( struct $5ArrayI8FBSTRINGE* );
static FBSTRING* _ZN5ArrayI8FBSTRINGEixEi( struct $5ArrayI8FBSTRINGE*, int32 );
static void _ZN5ArrayI8FBSTRINGE4PUSHERS0_( struct $5ArrayI8FBSTRINGE*, FBSTRING* );
static void _ZN5ArrayI8FBSTRINGE7RESERVEEi( struct $5ArrayI8FBSTRINGE*, int32 );
static void _ZN5ArrayI8FBSTRINGEC1Ev( struct $5ArrayI8FBSTRINGE* );
static void _ZN5ArrayI8FBSTRINGEaSERKS1_( struct $5ArrayI8FBSTRINGE*, struct $5ArrayI8FBSTRINGE* );
static void _ZN5ArrayI8FBSTRINGED1Ev( struct $5ArrayI8FBSTRINGE* );
static void _Z4SortI8FBSTRINGER5ArrayI8FBSTRINGE( struct $5ArrayI8FBSTRINGE* );
static boolean _Z8IsSortedI8FBSTRINGER5ArrayI8FBSTRINGE( struct $5ArrayI8FBSTRINGE* );
static int32 _ZN5ArrayIdE8CAPACITYEv( struct $5ArrayIdE* );
static double* _ZN5ArrayIdEixEi( struct $5ArrayIdE*, int32 );
static void _ZN5ArrayIdE4PUSHERd( struct $5ArrayIdE*, double* );
static void _ZN5ArrayIdE7RESERVEEi( struct $5ArrayIdE*, int32 );
static void _ZN5ArrayIdEC1Ev( struct $5ArrayIdE* );
static void _ZN5ArrayIdEaSERKS0_( struct $5ArrayIdE*, struct $5ArrayIdE* );
static void _ZN5ArrayIdED1Ev( struct $5ArrayIdE* );
static void _Z4SortIdER5ArrayIdE( struct $5ArrayIdE* );
static int32 _ZN5ArrayI3RECE5COUNTEv( struct $5ArrayI3RECE* );
static int32 _ZN5ArrayI3RECE8CAPACITYEv( struct $5ArrayI3RECE* );
static struct $3REC* _ZN5ArrayI3RECEixEi( struct $5ArrayI3RECE*, int32 );
static void _ZN5ArrayI3RECE4PUSHERS0_( struct $5ArrayI3RECE*, struct $3REC* );
static void _ZN5ArrayI3RECE7RESERVEEi( struct $5ArrayI3RECE*, int32 );
static void _ZN5ArrayI3RECEC1Ev( struct $5ArrayI3RECE* );
static void _ZN5ArrayI3RECEaSERKS1_( struct $5ArrayI3RECE*, struct $5ArrayI3RECE* );
static void _ZN5ArrayI3RECED1Ev( struct $5ArrayI3RECE* );
static void _Z4SortI3RECER5ArrayI3RECE( struct $5ArrayI3RECE* );
static boolean _Z8IsSortedI3RECER5ArrayI3RECE( struct $5ArrayI3RECE* );
boolean L3C22B1CEA777A486_LT_0080( FBSTRING*, FBSTRING* );
static void _Z6SortByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGERS6_( struct $5ArrayI8FBSTRINGE*, tmp$129* );
boolean L3C22B1CEA777A486_LT_0083( FBSTRING*, FBSTRING* );
static boolean _Z10IsSortedByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGERS6_( struct $5ArrayI8FBSTRINGE*, tmp$129* );
boolean L3C22B1CEA777A486_LT_008B( double*, double* );
static void _Z6SortByIdPFbRdRdEER5ArrayIdERS3_( struct $5ArrayIdE*, tmp$140* );
boolean L3C22B1CEA777A486_LT_0094( struct $3REC*, struct $3REC* );
static void _Z6SortByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( struct $5ArrayI3RECE*, tmp$149* );
boolean L3C22B1CEA777A486_LT_0097( struct $3REC*, struct $3REC* );
static boolean _Z10IsSortedByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( struct $5ArrayI3RECE*, tmp$149* );
static void _Z11SortIntroByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiiRS6_( struct $5ArrayI8FBSTRINGE*, int32, int32, int32, tmp$129* );
static void _Z11SortIntroByIdPFbRdRdEER5ArrayIdEiiiRS3_( struct $5ArrayIdE*, int32, int32, int32, tmp$140* );
static void _Z11SortIntroByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiiRS6_( struct $5ArrayI3RECE*, int32, int32, int32, tmp$149* );
static void _Z10SortHeapByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( struct $5ArrayI8FBSTRINGE*, int32, int32, tmp$129* );
static int32 _Z15SortPartitionByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( struct $5ArrayI8FBSTRINGE*, int32, int32, tmp$129* );
static void _Z15SortInsertionByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( struct $5ArrayI8FBSTRINGE*, int32, int32, tmp$129* );
static void _Z10SortHeapByIdPFbRdRdEER5ArrayIdEiiRS3_( struct $5ArrayIdE*, int32, int32, tmp$140* );
static int32 _Z15SortPartitionByIdPFbRdRdEER5ArrayIdEiiRS3_( struct $5ArrayIdE*, int32, int32, tmp$140* );
static void _Z15SortInsertionByIdPFbRdRdEER5ArrayIdEiiRS3_( struct $5ArrayIdE*, int32, int32, tmp$140* );
static void _Z10SortHeapByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( struct $5ArrayI3RECE*, int32, int32, tmp$149* );
static int32 _Z15SortPartitionByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( struct $5ArrayI3RECE*, int32, int32, tmp$149* );
static void _Z15SortInsertionByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( struct $5ArrayI3RECE*, int32, int32, tmp$149* );
static void _Z14SortSiftDownByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiiRS6_( struct $5ArrayI8FBSTRINGE*, int32, int32, int32, tmp$129* );
static void _Z14SortSiftDownByIdPFbRdRdEER5ArrayIdEiiiRS3_( struct $5ArrayIdE*, int32, int32, int32, tmp$140* );
static void _Z14SortSiftDownByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiiRS6_( struct $5ArrayI3RECE*, int32, int32, int32, tmp$149* );
boolean LD2939E50C2FFBF23_LT_00A6( int32*, int32* );
boolean LD2939E50C2FFBF23_LT_00A9( int32*, int32* );
static boolean _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( struct $25LD2939E50C2FFBF23_Lt_00ADIiE*, int32*, int32* );
static void _Z6SortByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiERS1_( struct $5ArrayIiE*, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* );
static void _Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiiRS1_( struct $5ArrayIiE*, int32, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* );
static void _Z10SortHeapByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE*, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* );
static int32 _Z15SortPartitionByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE*, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* );
static void _Z15SortInsertionByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE*, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* );
static void _Z14SortSiftDownByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiiRS1_( struct $5ArrayIiE*, int32, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* );
boolean LD2939E50C2FFBF23_LT_00BB( struct $3REC*, struct $3REC* );
static boolean _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( struct $25LD2939E50C2FFBF23_Lt_00BEIiE*, int32*, int32* );
static void _Z6SortByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiERS1_( struct $5ArrayIiE*, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* );
static void _Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiiRS1_( struct $5ArrayIiE*, int32, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* );
static void _Z10SortHeapByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE*, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* );
static int32 _Z15SortPartitionByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE*, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* );
static void _Z15SortInsertionByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE*, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* );
static void _Z14SortSiftDownByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiiRS1_( struct $5ArrayIiE*, int32, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* );
boolean LD2939E50C2FFBF23_LT_00CC( int32*, int32* );
boolean LD2939E50C2FFBF23_LT_00D0( int32*, int32* );
static void _Z10StableSortIiER5ArrayIiE( struct $5ArrayIiE* );
boolean L3C22B1CEA777A486_LT_00D4( int32*, int32* );
static void _Z12StableSortByIiPFbRiRiEER5ArrayIiERS3_( struct $5ArrayIiE*, tmp$50* );
static void _Z11SortMergeByIiPFbRiRiEER5ArrayIiER7FBARRAYIiEiiiRS3_( struct $5ArrayIiE*, struct $7FBARRAYIiE*, int32, int32, int32, tmp$50* );
static void _Z10StableSortI3RECER5ArrayI3RECE( struct $5ArrayI3RECE* );
boolean L3C22B1CEA777A486_LT_00DF( struct $3REC*, struct $3REC* );
static void _Z12StableSortByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( struct $5ArrayI3RECE*, tmp$149* );
static void _Z11SortMergeByI3RECPFbR3RECR3RECEER5ArrayI3RECER7FBARRAYIS0_EiiiRS6_( struct $5ArrayI3RECE*, struct $7FBARRAYI3RECE*, int32, int32, int32, tmp$149* );
boolean LD2939E50C2FFBF23_LT_00E3( struct $3REC*, struct $3REC* );
static boolean _ZN25LD2939E50C2FFBF23_Lt_00E8IiE10__FBINVOKEERiS2_( struct $25LD2939E50C2FFBF23_Lt_00E8IiE*, int32*, int32* );
static void _Z12StableSortByIi25LD2939E50C2FFBF23_Lt_00E8IiEER5ArrayIiERS1_( struct $5ArrayIiE*, struct $25LD2939E50C2FFBF23_Lt_00E8IiE* );
static void _Z15SortInsertionByIi25LD2939E50C2FFBF23_Lt_00E8IiEER5ArrayIiEiiRS1_( struct $5ArrayIiE*, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00E8IiE* );
static void _Z11SortMergeByIi25LD2939E50C2FFBF23_Lt_00E8IiEER5ArrayIiER7FBARRAYIiEiiiRS1_( struct $5ArrayIiE*, struct $7FBARRAYIiE*, int32, int32, int32, struct $25LD2939E50C2FFBF23_Lt_00E8IiE* );
static void _Z10StableSortI8FBSTRINGER5ArrayI8FBSTRINGE( struct $5ArrayI8FBSTRINGE* );
boolean L3C22B1CEA777A486_LT_00FA( FBSTRING*, FBSTRING* );
static void _Z12StableSortByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGERS6_( struct $5ArrayI8FBSTRINGE*, tmp$129* );
static void _Z11SortMergeByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGER7FBARRAYIS0_EiiiRS6_( struct $5ArrayI8FBSTRINGE*, struct $7FBARRAYI8FBSTRINGE*, int32, int32, int32, tmp$129* );
static int32 _ZN5ArrayI7COUNTEDE8CAPACITYEv( struct $5ArrayI7COUNTEDE* );
static struct $7COUNTED* _ZN5ArrayI7COUNTEDEixEi( struct $5ArrayI7COUNTEDE*, int32 );
static void _ZN5ArrayI7COUNTEDE4PUSHERS0_( struct $5ArrayI7COUNTEDE*, struct $7COUNTED* );
static void _ZN5ArrayI7COUNTEDE7RESERVEEi( struct $5ArrayI7COUNTEDE*, int32 );
static void _ZN5ArrayI7COUNTEDEC1Ev( struct $5ArrayI7COUNTEDE* );
static void _ZN5ArrayI7COUNTEDEaSERKS1_( struct $5ArrayI7COUNTEDE*, struct $5ArrayI7COUNTEDE* );
static void _ZN5ArrayI7COUNTEDED1Ev( struct $5ArrayI7COUNTEDE* );
static void _Z4SortI7COUNTEDER5ArrayI7COUNTEDE( struct $5ArrayI7COUNTEDE* );
static void _Z10StableSortI7COUNTEDER5ArrayI7COUNTEDE( struct $5ArrayI7COUNTEDE* );
boolean L3C22B1CEA777A486_LT_0112( struct $7COUNTED*, struct $7COUNTED* );
static void _Z6SortByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDERS6_( struct $5ArrayI7COUNTEDE*, tmp$275* );
boolean L3C22B1CEA777A486_LT_0115( struct $7COUNTED*, struct $7COUNTED* );
static void _Z12StableSortByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDERS6_( struct $5ArrayI7COUNTEDE*, tmp$275* );
static void _Z11SortIntroByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiiRS6_( struct $5ArrayI7COUNTEDE*, int32, int32, int32, tmp$275* );
static void _Z15SortInsertionByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( struct $5ArrayI7COUNTEDE*, int32, int32, tmp$275* );
static void _Z11SortMergeByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDER7FBARRAYIS0_EiiiRS6_( struct $5ArrayI7COUNTEDE*, struct $7FBARRAYI7COUNTEDE*, int32, int32, int32, tmp$275* );
static void _Z10SortHeapByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( struct $5ArrayI7COUNTEDE*, int32, int32, tmp$275* );
static int32 _Z15SortPartitionByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( struct $5ArrayI7COUNTEDE*, int32, int32, tmp$275* );
static void _Z14SortSiftDownByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiiRS6_( struct $5ArrayI7COUNTEDE*, int32, int32, int32, tmp$275* );
static void _Z8SortListIiER10LinkedListIiE( struct $10LinkedListIiE* );
boolean L3C22B1CEA777A486_LT_012B( int32*, int32* );
static void _Z10SortListByIiPFbRiRiEER10LinkedListIiERS3_( struct $10LinkedListIiE*, tmp$50* );
static void _ZN10LinkedListI8FBSTRINGEC1Ev( struct $10LinkedListI8FBSTRINGE* );
static void _ZN10LinkedListI8FBSTRINGED1Ev( struct $10LinkedListI8FBSTRINGE* );
static boolean _ZN10LinkedListI8FBSTRINGE7ISEMPTYEv( struct $10LinkedListI8FBSTRINGE* );
static void _ZN10LinkedListI8FBSTRINGE8PUSHBACKERS0_( struct $10LinkedListI8FBSTRINGE*, FBSTRING* );
static FBSTRING* _ZN10LinkedListI8FBSTRINGE8POPFRONTEv( struct $10LinkedListI8FBSTRINGE* );
static void _ZN10LinkedListI8FBSTRINGE5CLEAREv( struct $10LinkedListI8FBSTRINGE* );
static void _ZN10LinkedListI8FBSTRINGE8COPYFROMERS1_( struct $10LinkedListI8FBSTRINGE*, struct $10LinkedListI8FBSTRINGE* );
static void _ZN10LinkedNodeI8FBSTRINGEC1Ev( struct $10LinkedNodeI8FBSTRINGE* );
static void _ZN10LinkedNodeI8FBSTRINGEaSERKS1_( struct $10LinkedNodeI8FBSTRINGE*, struct $10LinkedNodeI8FBSTRINGE* );
static void _ZN10LinkedNodeI8FBSTRINGED1Ev( struct $10LinkedNodeI8FBSTRINGE* );
static boolean _ZN25LD2939E50C2FFBF23_Lt_0150IiE10__FBINVOKEER8FBSTRINGS3_( struct $25LD2939E50C2FFBF23_Lt_0150IiE*, FBSTRING*, FBSTRING* );
static void _Z10SortListByI8FBSTRING25LD2939E50C2FFBF23_Lt_0150IiEER10LinkedListI8FBSTRINGERS2_( struct $10LinkedListI8FBSTRINGE*, struct $25LD2939E50C2FFBF23_Lt_0150IiE* );
static void _ZN10LinkedListI3RECEC1Ev( struct $10LinkedListI3RECE* );
static void _ZN10LinkedListI3RECED1Ev( struct $10LinkedListI3RECE* );
static int32 _ZN10LinkedListI3RECE5COUNTEv( struct $10LinkedListI3RECE* );
static void _ZN10LinkedListI3RECE8PUSHBACKERS0_( struct $10LinkedListI3RECE*, struct $3REC* );
static void _ZN10LinkedListI3RECE5CLEAREv( struct $10LinkedListI3RECE* );
static void _ZN10LinkedListI3RECE8COPYFROMERS1_( struct $10LinkedListI3RECE*, struct $10LinkedListI3RECE* );
static void _Z8SortListI3RECER10LinkedListI3RECE( struct $10LinkedListI3RECE* );
boolean L3C22B1CEA777A486_LT_0162( struct $3REC*, struct $3REC* );
static void _Z10SortListByI3RECPFbR3RECR3RECEER10LinkedListI3RECERS6_( struct $10LinkedListI3RECE*, tmp$149* );
static void _ZN10LinkedListI7COUNTEDEC1Ev( struct $10LinkedListI7COUNTEDE* );
static void _ZN10LinkedListI7COUNTEDED1Ev( struct $10LinkedListI7COUNTEDE* );
static void _ZN10LinkedListI7COUNTEDE8PUSHBACKERS0_( struct $10LinkedListI7COUNTEDE*, struct $7COUNTED* );
static void _ZN10LinkedListI7COUNTEDE5CLEAREv( struct $10LinkedListI7COUNTEDE* );
static void _ZN10LinkedListI7COUNTEDE8COPYFROMERS1_( struct $10LinkedListI7COUNTEDE*, struct $10LinkedListI7COUNTEDE* );
static void _ZN10LinkedListI7COUNTEDE10LABEL$2124Ev( void );
static void _ZN10LinkedListI7COUNTEDE10LABEL$2133Ev( void );
static void _ZN10LinkedNodeI7COUNTEDEC1Ev( struct $10LinkedNodeI7COUNTEDE* );
static void _ZN10LinkedNodeI7COUNTEDEaSERKS1_( struct $10LinkedNodeI7COUNTEDE*, struct $10LinkedNodeI7COUNTEDE* );
static void _ZN10LinkedNodeI7COUNTEDED1Ev( struct $10LinkedNodeI7COUNTEDE* );
static void _Z8SortListI7COUNTEDER10LinkedListI7COUNTEDE( struct $10LinkedListI7COUNTEDE* );
boolean L3C22B1CEA777A486_LT_0173( struct $7COUNTED*, struct $7COUNTED* );
static void _Z10SortListByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER10LinkedListI7COUNTEDERS6_( struct $10LinkedListI7COUNTEDE*, tmp$275* );
static int32 _ZN5ArrayI5ArrayIiEE5COUNTEv( struct $5ArrayI5ArrayIiEE* );
static int32 _ZN5ArrayI5ArrayIiEE8CAPACITYEv( struct $5ArrayI5ArrayIiEE* );
static struct $5ArrayIiE* _ZN5ArrayI5ArrayIiEEixEi( struct $5ArrayI5ArrayIiEE*, int32 );
static void _ZN5ArrayI5ArrayIiEE4PUSHERS1_( struct $5ArrayI5ArrayIiEE*, struct $5ArrayIiE* );
static void _ZN5ArrayI5ArrayIiEE7RESERVEEi( struct $5ArrayI5ArrayIiEE*, int32 );
static void _ZN5ArrayI5ArrayIiEEC1Ev( struct $5ArrayI5ArrayIiEE* );
static void _ZN5ArrayI5ArrayIiEEaSERKS2_( struct $5ArrayI5ArrayIiEE*, struct $5ArrayI5ArrayIiEE* );
static void _ZN5ArrayI5ArrayIiEED1Ev( struct $5ArrayI5ArrayIiEE* );
static uint64 RNGSTATE$;
static int32 LIVECOUNTED$;
static int32 COPIEDCOUNTED$;
static int32 DESTROYEDCOUNTED$;

void SEEDRNG( uint64 S$1 )
{
	label$2:;
	RNGSTATE$ = S$1;
	label$3:;
}

int32 NEXTRNG( int32 BOUND$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$4:;
	RNGSTATE$ = RNGSTATE$ ^ (RNGSTATE$ >> (12ll & 63ll));
	RNGSTATE$ = RNGSTATE$ ^ (RNGSTATE$ << (25ll & 63ll));
	RNGSTATE$ = RNGSTATE$ ^ (RNGSTATE$ >> (27ll & 63ll));
	fb$result$1 = (int32)(((RNGSTATE$ * 2685821657736338717ull) >> (33ll & 63ll)) % (uint64)(int64)BOUND$1);
	goto label$5;
	label$5:;
	return fb$result$1;
}

void _ZN7COUNTEDC1Ev( struct $7COUNTED* THIS$1 )
{
	label$6:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	*(int32*)THIS$1 = 0;
	LIVECOUNTED$ = (int32)((int64)LIVECOUNTED$ + 1ll);
	label$7:;
}

void _ZN7COUNTEDC1Ei( struct $7COUNTED* THIS$1, int32 N$1 )
{
	label$8:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	*(int32*)THIS$1 = N$1;
	LIVECOUNTED$ = (int32)((int64)LIVECOUNTED$ + 1ll);
	label$9:;
}

void _ZN7COUNTEDC1ERS_( struct $7COUNTED* THIS$1, struct $7COUNTED* RHS$1 )
{
	label$10:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	*(int32*)THIS$1 = *(int32*)RHS$1;
	LIVECOUNTED$ = (int32)((int64)LIVECOUNTED$ + 1ll);
	COPIEDCOUNTED$ = (int32)((int64)COPIEDCOUNTED$ + 1ll);
	label$11:;
}

void _ZN7COUNTEDaSERS_( struct $7COUNTED* THIS$1, struct $7COUNTED* RHS$1 )
{
	label$12:;
	*(int32*)THIS$1 = *(int32*)RHS$1;
	COPIEDCOUNTED$ = (int32)((int64)COPIEDCOUNTED$ + 1ll);
	label$13:;
}

void _ZN7COUNTEDD1Ev( struct $7COUNTED* THIS$1 )
{
	label$14:;
	LIVECOUNTED$ = (int32)((int64)LIVECOUNTED$ + -1ll);
	DESTROYEDCOUNTED$ = (int32)((int64)DESTROYEDCOUNTED$ + 1ll);
	label$15:;
}

boolean _ZltR7COUNTEDS0_( struct $7COUNTED* A$1, struct $7COUNTED* B$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$16:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)A$1 < (int64)*(int32*)B$1) != 0ll);
	goto label$17;
	label$17:;
	return fb$result$1;
}

boolean _ZltR3RECS0_( struct $3REC* A$1, struct $3REC* B$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$18:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)A$1 < (int64)*(int32*)B$1) != 0ll);
	goto label$19;
	label$19:;
	return fb$result$1;
}

struct $5ArrayIiE* LISTFORWARD( struct $5ArrayIiE* tmp$5$1, struct $10LinkedListIiE* L$1 )
{
	label$30:;
	struct $5ArrayIiE R$1;
	_ZN5ArrayIiEC1Ev( &R$1 );
	struct $10LinkedNodeIiE* P$1;
	P$1 = *(struct $10LinkedNodeIiE**)L$1;
	label$32:;
	if( P$1 == (struct $10LinkedNodeIiE*)0ull) goto label$33;
	{
		_ZN5ArrayIiE4PUSHERi( &R$1, (int32*)P$1 );
		P$1 = *(struct $10LinkedNodeIiE**)((uint8*)P$1 + 8ll);
	}
	goto label$32;
	label$33:;
	_ZN5ArrayIiEC1ERKS0_( tmp$5$1, (struct $5ArrayIiE*)&R$1 );
	_ZN5ArrayIiED1Ev( &R$1 );
	goto label$31;
	_ZN5ArrayIiED1Ev( &R$1 );
	label$31:;
	return tmp$5$1;
}

static boolean _ZN18LinkedListIteratorIiE7ISVALIDEv( struct $18LinkedListIteratorIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$34:;
	fb$result$1 = (boolean)((int64)-(*(void**)THIS$1 != (void*)0ull) != 0ll);
	goto label$35;
	label$35:;
	return fb$result$1;
}

static int32* _ZN18LinkedListIteratorIiE5VALUEEv( struct $18LinkedListIteratorIiE* THIS$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$36:;
	struct $10LinkedNodeIiE* N$1;
	N$1 = *(struct $10LinkedNodeIiE**)THIS$1;
	fb$result$1 = (int32*)N$1;
	goto label$37;
	label$37:;
	return fb$result$1;
}

static void _ZN18LinkedListIteratorIiE8MOVENEXTEv( struct $18LinkedListIteratorIiE* THIS$1 )
{
	label$38:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$41;
	{
		goto label$39;
		label$41:;
	}
	struct $10LinkedNodeIiE* N$1;
	N$1 = *(struct $10LinkedNodeIiE**)THIS$1;
	*(void**)THIS$1 = *(void**)((uint8*)N$1 + 8ll);
	label$39:;
}

static void _ZN10LinkedListIiEC1Ev( struct $10LinkedListIiE* THIS$1 )
{
	label$42:;
	__builtin_memset( (struct $10LinkedNodeIiE**)THIS$1, 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 16ll), 0, 4ll );
	*(struct $10LinkedNodeIiE**)THIS$1 = (struct $10LinkedNodeIiE*)0ull;
	*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeIiE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	label$43:;
}

static void _ZN10LinkedListIiEC1ERS0_( struct $10LinkedListIiE* THIS$1, struct $10LinkedListIiE* RHS$1 )
{
	label$44:;
	__builtin_memset( (struct $10LinkedNodeIiE**)THIS$1, 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 16ll), 0, 4ll );
	*(struct $10LinkedNodeIiE**)THIS$1 = (struct $10LinkedNodeIiE*)0ull;
	*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeIiE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	_ZN10LinkedListIiE8COPYFROMERS0_( THIS$1, RHS$1 );
	label$45:;
}

static void _ZN10LinkedListIiED1Ev( struct $10LinkedListIiE* THIS$1 )
{
	label$46:;
	_ZN10LinkedListIiE5CLEAREv( THIS$1 );
	label$47:;
}

static void _ZN10LinkedListIiEaSERS0_( struct $10LinkedListIiE* THIS$1, struct $10LinkedListIiE* RHS$1 )
{
	label$48:;
	if( RHS$1 != THIS$1) goto label$51;
	{
		goto label$49;
	}
	label$51:;
	label$50:;
	_ZN10LinkedListIiE5CLEAREv( THIS$1 );
	_ZN10LinkedListIiE8COPYFROMERS0_( THIS$1, RHS$1 );
	label$49:;
}

static void _ZN10LinkedListIiE8COPYFROMERS0_( struct $10LinkedListIiE* THIS$1, struct $10LinkedListIiE* RHS$1 )
{
	label$52:;
	struct $10LinkedNodeIiE* P$1;
	P$1 = *(struct $10LinkedNodeIiE**)RHS$1;
	label$54:;
	if( P$1 == (struct $10LinkedNodeIiE*)0ull) goto label$55;
	{
		_ZN10LinkedListIiE8PUSHBACKERi( THIS$1, (int32*)P$1 );
		P$1 = *(struct $10LinkedNodeIiE**)((uint8*)P$1 + 8ll);
	}
	goto label$54;
	label$55:;
	label$53:;
}

static int32 _ZN10LinkedListIiE5COUNTEv( struct $10LinkedListIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$56:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 16ll);
	goto label$57;
	label$57:;
	return fb$result$1;
}

static boolean _ZN10LinkedListIiE7ISEMPTYEv( struct $10LinkedListIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$58:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 16ll) == 0ll) != 0ll);
	goto label$59;
	label$59:;
	return fb$result$1;
}

static void _ZN10LinkedListIiE9PUSHFRONTERi( struct $10LinkedListIiE* THIS$1, int32* V$1 )
{
	struct $10LinkedNodeIiE* TMP$6$1;
	label$60:;
	int32 VV$1;
	VV$1 = *V$1;
	struct $10LinkedNodeIiE* N$1;
	void* vr$1 = calloc( 24ull, 1ull );
	TMP$6$1 = (struct $10LinkedNodeIiE*)vr$1;
	if( TMP$6$1 == (struct $10LinkedNodeIiE*)0ull) goto label$62;
	label$62:;
	N$1 = TMP$6$1;
	*(int32*)N$1 = VV$1;
	*(struct $10LinkedNodeIiE**)((uint8*)N$1 + 16ll) = (struct $10LinkedNodeIiE*)0ull;
	*(struct $10LinkedNodeIiE**)((uint8*)N$1 + 8ll) = *(struct $10LinkedNodeIiE**)THIS$1;
	if( *(struct $10LinkedNodeIiE**)THIS$1 == (struct $10LinkedNodeIiE*)0ull) goto label$64;
	{
		*(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)THIS$1 + 16ll) = N$1;
	}
	goto label$63;
	label$64:;
	{
		*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) = N$1;
	}
	label$63:;
	*(struct $10LinkedNodeIiE**)THIS$1 = N$1;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + 1ll);
	label$61:;
}

static void _ZN10LinkedListIiE8PUSHBACKERi( struct $10LinkedListIiE* THIS$1, int32* V$1 )
{
	struct $10LinkedNodeIiE* TMP$7$1;
	label$65:;
	int32 VV$1;
	VV$1 = *V$1;
	struct $10LinkedNodeIiE* N$1;
	void* vr$1 = calloc( 24ull, 1ull );
	TMP$7$1 = (struct $10LinkedNodeIiE*)vr$1;
	if( TMP$7$1 == (struct $10LinkedNodeIiE*)0ull) goto label$67;
	label$67:;
	N$1 = TMP$7$1;
	*(int32*)N$1 = VV$1;
	*(struct $10LinkedNodeIiE**)((uint8*)N$1 + 8ll) = (struct $10LinkedNodeIiE*)0ull;
	*(struct $10LinkedNodeIiE**)((uint8*)N$1 + 16ll) = *(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll);
	if( *(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) == (struct $10LinkedNodeIiE*)0ull) goto label$69;
	{
		*(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) + 8ll) = N$1;
	}
	goto label$68;
	label$69:;
	{
		*(struct $10LinkedNodeIiE**)THIS$1 = N$1;
	}
	label$68:;
	*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) = N$1;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + 1ll);
	label$66:;
}

static int32 _ZN10LinkedListIiE8POPFRONTEv( struct $10LinkedListIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$70:;
	int32 R$1;
	__builtin_memset( &R$1, 0, 4ll );
	if( *(struct $10LinkedNodeIiE**)THIS$1 != (struct $10LinkedNodeIiE*)0ull) goto label$73;
	{
		fb$result$1 = R$1;
		goto label$71;
	}
	label$73:;
	label$72:;
	struct $10LinkedNodeIiE* N$1;
	N$1 = *(struct $10LinkedNodeIiE**)THIS$1;
	R$1 = *(int32*)N$1;
	*(struct $10LinkedNodeIiE**)THIS$1 = *(struct $10LinkedNodeIiE**)((uint8*)N$1 + 8ll);
	if( *(struct $10LinkedNodeIiE**)THIS$1 == (struct $10LinkedNodeIiE*)0ull) goto label$75;
	{
		*(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)THIS$1 + 16ll) = (struct $10LinkedNodeIiE*)0ull;
	}
	goto label$74;
	label$75:;
	{
		*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeIiE*)0ull;
	}
	label$74:;
	if( N$1 == (struct $10LinkedNodeIiE*)0ull) goto label$76;
	free( (void*)N$1 );
	label$76:;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + -1ll);
	fb$result$1 = R$1;
	goto label$71;
	label$71:;
	return fb$result$1;
}

static int32 _ZN10LinkedListIiE7POPBACKEv( struct $10LinkedListIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$77:;
	int32 R$1;
	__builtin_memset( &R$1, 0, 4ll );
	if( *(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) != (struct $10LinkedNodeIiE*)0ull) goto label$80;
	{
		fb$result$1 = R$1;
		goto label$78;
	}
	label$80:;
	label$79:;
	struct $10LinkedNodeIiE* N$1;
	N$1 = *(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll);
	R$1 = *(int32*)N$1;
	*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) = *(struct $10LinkedNodeIiE**)((uint8*)N$1 + 16ll);
	if( *(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) == (struct $10LinkedNodeIiE*)0ull) goto label$82;
	{
		*(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) + 8ll) = (struct $10LinkedNodeIiE*)0ull;
	}
	goto label$81;
	label$82:;
	{
		*(struct $10LinkedNodeIiE**)THIS$1 = (struct $10LinkedNodeIiE*)0ull;
	}
	label$81:;
	if( N$1 == (struct $10LinkedNodeIiE*)0ull) goto label$83;
	free( (void*)N$1 );
	label$83:;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + -1ll);
	fb$result$1 = R$1;
	goto label$78;
	label$78:;
	return fb$result$1;
}

static int32* _ZN10LinkedListIiE5FRONTEv( struct $10LinkedListIiE* THIS$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$84:;
	static int32 BLANK$1;
	if( *(struct $10LinkedNodeIiE**)THIS$1 != (struct $10LinkedNodeIiE*)0ull) goto label$87;
	{
		fb$result$1 = &BLANK$1;
		goto label$85;
	}
	label$87:;
	label$86:;
	fb$result$1 = (int32*)*(struct $10LinkedNodeIiE**)THIS$1;
	goto label$85;
	label$85:;
	return fb$result$1;
}

static int32* _ZN10LinkedListIiE4BACKEv( struct $10LinkedListIiE* THIS$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$88:;
	static int32 BLANK$1;
	if( *(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) != (struct $10LinkedNodeIiE*)0ull) goto label$91;
	{
		fb$result$1 = &BLANK$1;
		goto label$89;
	}
	label$91:;
	label$90:;
	fb$result$1 = (int32*)*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll);
	goto label$89;
	label$89:;
	return fb$result$1;
}

static void _ZN10LinkedListIiE5CLEAREv( struct $10LinkedListIiE* THIS$1 )
{
	label$92:;
	struct $10LinkedNodeIiE* P$1;
	P$1 = *(struct $10LinkedNodeIiE**)THIS$1;
	label$94:;
	if( P$1 == (struct $10LinkedNodeIiE*)0ull) goto label$95;
	{
		struct $10LinkedNodeIiE* NXT$2;
		NXT$2 = *(struct $10LinkedNodeIiE**)((uint8*)P$1 + 8ll);
		if( P$1 == (struct $10LinkedNodeIiE*)0ull) goto label$96;
		free( (void*)P$1 );
		label$96:;
		P$1 = NXT$2;
	}
	goto label$94;
	label$95:;
	*(struct $10LinkedNodeIiE**)THIS$1 = (struct $10LinkedNodeIiE*)0ull;
	*(struct $10LinkedNodeIiE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeIiE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	label$93:;
}

static struct $18LinkedListIteratorIiE _ZN10LinkedListIiE11GETITERATOREv( struct $10LinkedListIiE* THIS$1 )
{
	struct $18LinkedListIteratorIiE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$97:;
	struct $18LinkedListIteratorIiE IT$1;
	__builtin_memset( &IT$1, 0, 8ll );
	*(void**)&IT$1 = *(void**)THIS$1;
	__builtin_memcpy( &fb$result$1, &IT$1, 8 );
	goto label$98;
	label$98:;
	return fb$result$1;
}

static boolean _ZN13ArrayIteratorIiE7ISVALIDEv( struct $13ArrayIteratorIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$99:;
	struct $5ArrayIiE* A$1;
	A$1 = *(struct $5ArrayIiE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$100;
	label$100:;
	return fb$result$1;
}

static int32* _ZN13ArrayIteratorIiE5VALUEEv( struct $13ArrayIteratorIiE* THIS$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$101:;
	struct $5ArrayIiE* A$1;
	A$1 = *(struct $5ArrayIiE**)THIS$1;
	fb$result$1 = (int32*)((uint8*)*(int32**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) << (2ll & 63ll)));
	goto label$102;
	label$102:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorIiE8MOVENEXTEv( struct $13ArrayIteratorIiE* THIS$1 )
{
	label$103:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$104:;
}

static int32 _ZN5ArrayIiE5COUNTEv( struct $5ArrayIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$105:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$106;
	label$106:;
	return fb$result$1;
}

static int32 _ZN5ArrayIiE8CAPACITYEv( struct $5ArrayIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$107:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$108;
	label$108:;
	return fb$result$1;
}

static boolean _ZN5ArrayIiE7ISEMPTYEv( struct $5ArrayIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$109:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$110;
	label$110:;
	return fb$result$1;
}

static void _ZN5ArrayIiE7RESERVEEi( struct $5ArrayIiE* THIS$1, int32 N$1 )
{
	label$111:;
	int32 vr$1 = _ZN5ArrayIiE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$114;
	{
		goto label$112;
	}
	label$114:;
	label$113:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayIiE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$116;
	{
		CAP$1 = 8;
	}
	label$116:;
	label$115:;
	label$117:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$118;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$117;
	label$118:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 4ull, -1, 0, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$112:;
}

static void _ZN5ArrayIiE6SHRINKEv( struct $5ArrayIiE* THIS$1 )
{
	label$119:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$122;
	{
		fb_ArrayErase( (struct $7FBARRAYIvE*)THIS$1 );
		goto label$120;
	}
	label$122:;
	label$121:;
	int32 vr$6 = _ZN5ArrayIiE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$124;
	{
		goto label$120;
	}
	label$124:;
	label$123:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 4ull, -1, 0, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$120:;
}

static int32* _ZN5ArrayIiEixEi( struct $5ArrayIiE* THIS$1, int32 I$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$125:;
	fb$result$1 = (int32*)((uint8*)*(int32**)THIS$1 + ((int64)I$1 << (2ll & 63ll)));
	goto label$126;
	label$126:;
	return fb$result$1;
}

static int32* _ZN5ArrayIiE2ATEi( struct $5ArrayIiE* THIS$1, int32 I$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$127:;
	fb$result$1 = (int32*)((uint8*)*(int32**)THIS$1 + ((int64)I$1 << (2ll & 63ll)));
	goto label$128;
	label$128:;
	return fb$result$1;
}

static void _ZN5ArrayIiE4PUSHERi( struct $5ArrayIiE* THIS$1, int32* V$1 )
{
	label$129:;
	_ZN5ArrayIiE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (2ll & 63ll))) = *V$1;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$130:;
}

static int32 _ZN5ArrayIiE3POPEv( struct $5ArrayIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$131:;
	int32 R$1;
	__builtin_memset( &R$1, 0, 4ll );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$134;
	{
		fb$result$1 = R$1;
		goto label$132;
	}
	label$134:;
	label$133:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	R$1 = *(int32*)((uint8*)*(int32**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (2ll & 63ll)));
	fb$result$1 = R$1;
	goto label$132;
	label$132:;
	return fb$result$1;
}

static void _ZN5ArrayIiE6INSERTEiRi( struct $5ArrayIiE* THIS$1, int32 I$1, int32* V$1 )
{
	int64 TMP$8$1;
	label$135:;
	if( (int64)I$1 < 0ll) goto label$137;
	TMP$8$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$144;
	label$137:;
	TMP$8$1 = -1ll;
	label$144:;
	if( TMP$8$1 == 0ll) goto label$139;
	{
		goto label$136;
	}
	label$139:;
	label$138:;
	int32 TMP$1;
	TMP$1 = *V$1;
	_ZN5ArrayIiE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$9$2;
		TMP$9$2 = (int32)((int64)I$1 + 1ll);
		goto label$140;
		label$143:;
		{
			*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) = *(int32*)((uint8*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) + -4ll);
		}
		label$141:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$140:;
		if( (int64)K$2 >= (int64)TMP$9$2) goto label$143;
		label$142:;
	}
	*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)I$1 << (2ll & 63ll))) = TMP$1;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$136:;
}

static void _ZN5ArrayIiE6REMOVEEi( struct $5ArrayIiE* THIS$1, int32 I$1 )
{
	int64 TMP$10$1;
	label$145:;
	if( (int64)I$1 < 0ll) goto label$147;
	TMP$10$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$154;
	label$147:;
	TMP$10$1 = -1ll;
	label$154:;
	if( TMP$10$1 == 0ll) goto label$149;
	{
		goto label$146;
	}
	label$149:;
	label$148:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$11$2;
		TMP$11$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$150;
		label$153:;
		{
			*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) = *(int32*)((uint8*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) + 4ll);
		}
		label$151:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$150:;
		if( (int64)K$2 <= (int64)TMP$11$2) goto label$153;
		label$152:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$146:;
}

static void _ZN5ArrayIiE10REMOVESWAPEi( struct $5ArrayIiE* THIS$1, int32 I$1 )
{
	int64 TMP$12$1;
	label$155:;
	if( (int64)I$1 < 0ll) goto label$157;
	TMP$12$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$162;
	label$157:;
	TMP$12$1 = -1ll;
	label$162:;
	if( TMP$12$1 == 0ll) goto label$159;
	{
		goto label$156;
	}
	label$159:;
	label$158:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$161;
	{
		*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)I$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (2ll & 63ll)));
	}
	label$161:;
	label$160:;
	label$156:;
}

static void _ZN5ArrayIiE5CLEAREv( struct $5ArrayIiE* THIS$1 )
{
	label$163:;
	int32 BLANK$1;
	__builtin_memset( &BLANK$1, 0, 4ll );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$13$2;
		TMP$13$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$165;
		label$168:;
		{
			*(int32*)((uint8*)*(int32**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) = BLANK$1;
		}
		label$166:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$165:;
		if( (int64)K$2 <= (int64)TMP$13$2) goto label$168;
		label$167:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	label$164:;
}

static struct $13ArrayIteratorIiE _ZN5ArrayIiE11GETITERATOREv( struct $5ArrayIiE* THIS$1 )
{
	struct $13ArrayIteratorIiE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$169:;
	struct $13ArrayIteratorIiE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$170;
	label$170:;
	return fb$result$1;
}

struct $5ArrayIiE* LISTBACKWARD( struct $5ArrayIiE* tmp$14$1, struct $10LinkedListIiE* L$1 )
{
	label$171:;
	struct $5ArrayIiE R$1;
	_ZN5ArrayIiEC1Ev( &R$1 );
	struct $10LinkedNodeIiE* P$1;
	P$1 = *(struct $10LinkedNodeIiE**)((uint8*)L$1 + 8ll);
	label$173:;
	if( P$1 == (struct $10LinkedNodeIiE*)0ull) goto label$174;
	{
		_ZN5ArrayIiE4PUSHERi( &R$1, (int32*)P$1 );
		P$1 = *(struct $10LinkedNodeIiE**)((uint8*)P$1 + 16ll);
	}
	goto label$173;
	label$174:;
	_ZN5ArrayIiEC1ERKS0_( tmp$14$1, (struct $5ArrayIiE*)&R$1 );
	_ZN5ArrayIiED1Ev( &R$1 );
	goto label$172;
	_ZN5ArrayIiED1Ev( &R$1 );
	label$172:;
	return tmp$14$1;
}

boolean SAMEMULTISET( struct $5ArrayIiE* A$1, struct $5ArrayIiE* B$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$175:;
	int32 vr$1 = _ZN5ArrayIiE5COUNTEv( A$1 );
	int32 vr$3 = _ZN5ArrayIiE5COUNTEv( B$1 );
	if( (int64)vr$1 == (int64)vr$3) goto label$178;
	{
		fb$result$1 = (boolean)0ll;
		goto label$176;
	}
	label$178:;
	label$177:;
	struct $5ArrayIiE X$1;
	_ZN5ArrayIiEC1ERKS0_( &X$1, (struct $5ArrayIiE*)A$1 );
	struct $5ArrayIiE Y$1;
	_ZN5ArrayIiEC1ERKS0_( &Y$1, (struct $5ArrayIiE*)B$1 );
	{
		int32 I$2;
		I$2 = 0;
		int32 TMP$15$2;
		int32 vr$8 = _ZN5ArrayIiE5COUNTEv( &X$1 );
		TMP$15$2 = (int32)((int64)vr$8 + -2ll);
		goto label$179;
		label$182:;
		{
			{
				int32 J$4;
				J$4 = 0;
				int32 TMP$16$4;
				int32 vr$13 = _ZN5ArrayIiE5COUNTEv( &X$1 );
				TMP$16$4 = (int32)(((int64)vr$13 + -2ll) - (int64)I$2);
				goto label$183;
				label$186:;
				{
					int32* vr$23 = _ZN5ArrayIiEixEi( &X$1, (int32)((int64)J$4 + 1ll) );
					int32* vr$26 = _ZN5ArrayIiEixEi( &X$1, J$4 );
					if( (int64)*vr$23 >= (int64)*vr$26) goto label$188;
					{
						{
							int32* TMP$17$7;
							int32* TMP$18$7;
							int32 TMP$19$7;
							int32* vr$29 = _ZN5ArrayIiEixEi( &X$1, J$4 );
							TMP$17$7 = vr$29;
							int32* vr$34 = _ZN5ArrayIiEixEi( &X$1, (int32)((int64)J$4 + 1ll) );
							TMP$18$7 = vr$34;
							TMP$19$7 = *TMP$17$7;
							*TMP$17$7 = *TMP$18$7;
							*TMP$18$7 = TMP$19$7;
						}
						label$188:;
					}
					int32* vr$43 = _ZN5ArrayIiEixEi( &Y$1, (int32)((int64)J$4 + 1ll) );
					int32* vr$46 = _ZN5ArrayIiEixEi( &Y$1, J$4 );
					if( (int64)*vr$43 >= (int64)*vr$46) goto label$190;
					{
						{
							int32* TMP$20$7;
							int32* TMP$21$7;
							int32 TMP$22$7;
							int32* vr$49 = _ZN5ArrayIiEixEi( &Y$1, J$4 );
							TMP$20$7 = vr$49;
							int32* vr$54 = _ZN5ArrayIiEixEi( &Y$1, (int32)((int64)J$4 + 1ll) );
							TMP$21$7 = vr$54;
							TMP$22$7 = *TMP$20$7;
							*TMP$20$7 = *TMP$21$7;
							*TMP$21$7 = TMP$22$7;
						}
						label$190:;
					}
				}
				label$184:;
				J$4 = (int32)((int64)J$4 + 1ll);
				label$183:;
				if( (int64)J$4 <= (int64)TMP$16$4) goto label$186;
				label$185:;
			}
		}
		label$180:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$179:;
		if( (int64)I$2 <= (int64)TMP$15$2) goto label$182;
		label$181:;
	}
	{
		int32 I$2;
		I$2 = 0;
		int32 TMP$23$2;
		int32 vr$70 = _ZN5ArrayIiE5COUNTEv( &X$1 );
		TMP$23$2 = (int32)((int64)vr$70 + -1ll);
		goto label$191;
		label$194:;
		{
			int32* vr$75 = _ZN5ArrayIiEixEi( &X$1, I$2 );
			int32* vr$78 = _ZN5ArrayIiEixEi( &Y$1, I$2 );
			if( (int64)*vr$75 == (int64)*vr$78) goto label$196;
			{
				fb$result$1 = (boolean)0ll;
				_ZN5ArrayIiED1Ev( &Y$1 );
				_ZN5ArrayIiED1Ev( &X$1 );
				goto label$176;
			}
			label$196:;
			label$195:;
		}
		label$192:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$191:;
		if( (int64)I$2 <= (int64)TMP$23$2) goto label$194;
		label$193:;
	}
	fb$result$1 = (boolean)1ll;
	_ZN5ArrayIiED1Ev( &Y$1 );
	_ZN5ArrayIiED1Ev( &X$1 );
	goto label$176;
	_ZN5ArrayIiED1Ev( &Y$1 );
	_ZN5ArrayIiED1Ev( &X$1 );
	label$176:;
	return fb$result$1;
}

boolean ASCENDING( struct $5ArrayIiE* A$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$197:;
	{
		int32 I$2;
		I$2 = 1;
		int32 TMP$24$2;
		int32 vr$1 = _ZN5ArrayIiE5COUNTEv( A$1 );
		TMP$24$2 = (int32)((int64)vr$1 + -1ll);
		goto label$199;
		label$202:;
		{
			int32* vr$5 = _ZN5ArrayIiEixEi( A$1, I$2 );
			int32* vr$10 = _ZN5ArrayIiEixEi( A$1, (int32)((int64)I$2 + -1ll) );
			if( (int64)*vr$5 >= (int64)*vr$10) goto label$204;
			{
				fb$result$1 = (boolean)0ll;
				goto label$198;
			}
			label$204:;
			label$203:;
		}
		label$200:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$199:;
		if( (int64)I$2 <= (int64)TMP$24$2) goto label$202;
		label$201:;
	}
	fb$result$1 = (boolean)1ll;
	goto label$198;
	label$198:;
	return fb$result$1;
}

void MAKESHAPE( struct $5ArrayIiE* A$1, int32 SHAPE$1, int32 N$1 )
{
	label$205:;
	_ZN5ArrayIiE5CLEAREv( A$1 );
	{
		if( (int64)SHAPE$1 != 0ll) goto label$208;
		label$209:;
		{
			{
				int32 I$4;
				I$4 = 0;
				int32 TMP$25$4;
				TMP$25$4 = (int32)((int64)N$1 + -1ll);
				goto label$210;
				label$213:;
				{
					_ZN5ArrayIiE4PUSHERi( A$1, &I$4 );
				}
				label$211:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$210:;
				if( (int64)I$4 <= (int64)TMP$25$4) goto label$213;
				label$212:;
			}
		}
		goto label$207;
		label$208:;
		if( (int64)SHAPE$1 != 1ll) goto label$214;
		label$215:;
		{
			{
				int32 I$4;
				I$4 = 0;
				int32 TMP$26$4;
				TMP$26$4 = (int32)((int64)N$1 + -1ll);
				goto label$216;
				label$219:;
				{
					int32 TMP$27$5;
					TMP$27$5 = (int32)(((int64)N$1 + -1ll) - (int64)I$4);
					_ZN5ArrayIiE4PUSHERi( A$1, &TMP$27$5 );
				}
				label$217:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$216:;
				if( (int64)I$4 <= (int64)TMP$26$4) goto label$219;
				label$218:;
			}
		}
		goto label$207;
		label$214:;
		if( (int64)SHAPE$1 != 2ll) goto label$220;
		label$221:;
		{
			{
				int32 I$4;
				I$4 = 0;
				int32 TMP$28$4;
				TMP$28$4 = (int32)((int64)N$1 + -1ll);
				goto label$222;
				label$225:;
				{
					int32 TMP$29$5;
					TMP$29$5 = 7;
					_ZN5ArrayIiE4PUSHERi( A$1, &TMP$29$5 );
				}
				label$223:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$222:;
				if( (int64)I$4 <= (int64)TMP$28$4) goto label$225;
				label$224:;
			}
		}
		goto label$207;
		label$220:;
		if( (int64)SHAPE$1 != 3ll) goto label$226;
		label$227:;
		{
			{
				int32 I$4;
				I$4 = 0;
				int32 TMP$30$4;
				TMP$30$4 = (int32)((int64)N$1 + -1ll);
				goto label$228;
				label$231:;
				{
					int32 TMP$31$5;
					TMP$31$5 = (int32)((int64)I$4 & 1ll);
					_ZN5ArrayIiE4PUSHERi( A$1, &TMP$31$5 );
				}
				label$229:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$228:;
				if( (int64)I$4 <= (int64)TMP$30$4) goto label$231;
				label$230:;
			}
		}
		goto label$207;
		label$226:;
		if( (int64)SHAPE$1 != 4ll) goto label$232;
		label$233:;
		{
			{
				int32 I$4;
				I$4 = 0;
				int32 TMP$32$4;
				TMP$32$4 = (int32)((int64)N$1 + -1ll);
				goto label$234;
				label$237:;
				{
					if( (int64)I$4 >= ((int64)N$1 / 2ll)) goto label$239;
					{
						_ZN5ArrayIiE4PUSHERi( A$1, &I$4 );
					}
					goto label$238;
					label$239:;
					{
						int32 TMP$33$6;
						TMP$33$6 = (int32)(((int64)N$1 + -1ll) - (int64)I$4);
						_ZN5ArrayIiE4PUSHERi( A$1, &TMP$33$6 );
						label$238:;
					}
				}
				label$235:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$234:;
				if( (int64)I$4 <= (int64)TMP$32$4) goto label$237;
				label$236:;
			}
		}
		goto label$207;
		label$232:;
		if( (int64)SHAPE$1 != 5ll) goto label$240;
		label$241:;
		{
			{
				int32 I$4;
				I$4 = 0;
				int32 TMP$34$4;
				TMP$34$4 = (int32)((int64)N$1 + -1ll);
				goto label$242;
				label$245:;
				{
					int32 TMP$35$5;
					TMP$35$5 = (int32)((int64)I$4 % 8ll);
					_ZN5ArrayIiE4PUSHERi( A$1, &TMP$35$5 );
				}
				label$243:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$242:;
				if( (int64)I$4 <= (int64)TMP$34$4) goto label$245;
				label$244:;
			}
		}
		goto label$207;
		label$240:;
		if( (int64)SHAPE$1 != 6ll) goto label$246;
		label$247:;
		{
			{
				int32 I$4;
				I$4 = 0;
				int32 TMP$36$4;
				TMP$36$4 = (int32)((int64)N$1 + -1ll);
				goto label$248;
				label$251:;
				{
					int32 TMP$37$5;
					int32 vr$84 = NEXTRNG( 1000000 );
					TMP$37$5 = vr$84;
					_ZN5ArrayIiE4PUSHERi( A$1, &TMP$37$5 );
				}
				label$249:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$248:;
				if( (int64)I$4 <= (int64)TMP$36$4) goto label$251;
				label$250:;
			}
		}
		goto label$207;
		label$246:;
		{
			{
				int32 I$4;
				I$4 = 0;
				int32 TMP$38$4;
				TMP$38$4 = (int32)((int64)N$1 + -1ll);
				goto label$253;
				label$256:;
				{
					int32 TMP$39$5;
					int32 vr$94 = NEXTRNG( 5 );
					TMP$39$5 = vr$94;
					_ZN5ArrayIiE4PUSHERi( A$1, &TMP$39$5 );
				}
				label$254:;
				I$4 = (int32)((int64)I$4 + 1ll);
				label$253:;
				if( (int64)I$4 <= (int64)TMP$38$4) goto label$256;
				label$255:;
			}
		}
		label$252:;
		label$207:;
	}
	label$206:;
}

static void _Z4SortIiER5ArrayIiE( struct $5ArrayIiE* A$1 )
{
	label$287:;
	typedef boolean (*_Z6tmp$48RiS_)( int32*, int32* );
	_Z6tmp$48RiS_ LESS$1;
	LESS$1 = (_Z6tmp$48RiS_)&L3C22B1CEA777A486_LT_0031;
	_Z6SortByIiPFbRiRiEER5ArrayIiERS3_( A$1, (tmp$50*)&LESS$1 );
	label$288:;
}

boolean L3C22B1CEA777A486_LT_0031( int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$289:;
	fb$result$1 = (boolean)((int64)-((int64)*X$1 < (int64)*Y$1) != 0ll);
	goto label$290;
	label$290:;
	return fb$result$1;
}

static boolean _Z8IsSortedIiER5ArrayIiE( struct $5ArrayIiE* A$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$291:;
	typedef boolean (*_Z6tmp$51RiS_)( int32*, int32* );
	_Z6tmp$51RiS_ LESS$1;
	LESS$1 = (_Z6tmp$51RiS_)&L3C22B1CEA777A486_LT_0034;
	boolean vr$2 = _Z10IsSortedByIiPFbRiRiEER5ArrayIiERS3_( A$1, (tmp$50*)&LESS$1 );
	fb$result$1 = vr$2;
	goto label$292;
	label$292:;
	return fb$result$1;
}

boolean L3C22B1CEA777A486_LT_0034( int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$293:;
	fb$result$1 = (boolean)((int64)-((int64)*X$1 < (int64)*Y$1) != 0ll);
	goto label$294;
	label$294:;
	return fb$result$1;
}

static void _Z6SortByIiPFbRiRiEER5ArrayIiERS3_( struct $5ArrayIiE* A$1, tmp$50* LESS$1 )
{
	label$295:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$298;
	{
		goto label$296;
	}
	label$298:;
	label$297:;
	int32 DEPTH$1;
	DEPTH$1 = 0;
	int32 M$1;
	M$1 = N$1;
	label$299:;
	if( (int64)M$1 <= 1ll) goto label$300;
	{
		M$1 = (int32)((int64)M$1 / 2ll);
		DEPTH$1 = (int32)((int64)DEPTH$1 + 1ll);
	}
	goto label$299;
	label$300:;
	DEPTH$1 = (int32)((int64)DEPTH$1 << (1ll & 63ll));
	_Z11SortIntroByIiPFbRiRiEER5ArrayIiEiiiRS3_( A$1, 0, (int32)((int64)N$1 + -1ll), DEPTH$1, LESS$1 );
	label$296:;
}

static boolean _Z10IsSortedByIiPFbRiRiEER5ArrayIiERS3_( struct $5ArrayIiE* A$1, tmp$50* LESS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$301:;
	{
		int32 I$2;
		I$2 = 1;
		int32 TMP$53$2;
		TMP$53$2 = (int32)((int64)*(int32*)((uint8*)A$1 + 72ll) + -1ll);
		goto label$303;
		label$306:;
		{
			boolean OUTOFORDER$3;
			boolean vr$14 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + ((int64)I$2 << (2ll & 63ll))), (int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)I$2 << (2ll & 63ll))) + -4ll) );
			OUTOFORDER$3 = vr$14;
			if( OUTOFORDER$3 == (boolean)0ll) goto label$308;
			{
				fb$result$1 = (boolean)0ll;
				goto label$302;
			}
			label$308:;
			label$307:;
		}
		label$304:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$303:;
		if( (int64)I$2 <= (int64)TMP$53$2) goto label$306;
		label$305:;
	}
	fb$result$1 = (boolean)1ll;
	goto label$302;
	label$302:;
	return fb$result$1;
}

static void _Z11SortIntroByIiPFbRiRiEER5ArrayIiEiiiRS3_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, int32 DEPTH$1, tmp$50* LESS$1 )
{
	label$309:;
	label$311:;
	if( (((int64)HI$1 - (int64)LO$1) + 1ll) <= 16ll) goto label$312;
	{
		if( (int64)DEPTH$1 != 0ll) goto label$314;
		{
			_Z10SortHeapByIiPFbRiRiEER5ArrayIiEiiRS3_( A$1, LO$1, HI$1, LESS$1 );
			goto label$310;
		}
		label$314:;
		label$313:;
		DEPTH$1 = (int32)((int64)DEPTH$1 + -1ll);
		int32 P$2;
		int32 vr$8 = _Z15SortPartitionByIiPFbRiRiEER5ArrayIiEiiRS3_( A$1, LO$1, HI$1, LESS$1 );
		P$2 = vr$8;
		if( ((int64)P$2 - (int64)LO$1) >= ((int64)HI$1 - (int64)P$2)) goto label$316;
		{
			_Z11SortIntroByIiPFbRiRiEER5ArrayIiEiiiRS3_( A$1, LO$1, (int32)((int64)P$2 + -1ll), DEPTH$1, LESS$1 );
			LO$1 = (int32)((int64)P$2 + 1ll);
		}
		goto label$315;
		label$316:;
		{
			_Z11SortIntroByIiPFbRiRiEER5ArrayIiEiiiRS3_( A$1, (int32)((int64)P$2 + 1ll), HI$1, DEPTH$1, LESS$1 );
			HI$1 = (int32)((int64)P$2 + -1ll);
		}
		label$315:;
	}
	goto label$311;
	label$312:;
	_Z15SortInsertionByIiPFbRiRiEER5ArrayIiEiiRS3_( A$1, LO$1, HI$1, LESS$1 );
	label$310:;
}

static void _Z10SortHeapByIiPFbRiRiEER5ArrayIiEiiRS3_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, tmp$50* LESS$1 )
{
	label$317:;
	int32 N$1;
	N$1 = (int32)(((int64)HI$1 - (int64)LO$1) + 1ll);
	if( (int64)N$1 >= 2ll) goto label$320;
	{
		goto label$318;
	}
	label$320:;
	label$319:;
	{
		int32 I$2;
		I$2 = (int32)(((int64)N$1 / 2ll) + -1ll);
		goto label$321;
		label$324:;
		{
			_Z14SortSiftDownByIiPFbRiRiEER5ArrayIiEiiiRS3_( A$1, LO$1, N$1, I$2, LESS$1 );
		}
		label$322:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$321:;
		if( (int64)I$2 >= 0ll) goto label$324;
		label$323:;
	}
	{
		int32 I$2;
		I$2 = (int32)((int64)N$1 + -1ll);
		goto label$325;
		label$328:;
		{
			{
				int32 TMP$54$4;
				TMP$54$4 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)I$2) << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)I$2) << (2ll & 63ll))) = TMP$54$4;
			}
			_Z14SortSiftDownByIiPFbRiRiEER5ArrayIiEiiiRS3_( A$1, LO$1, I$2, 0, LESS$1 );
		}
		label$326:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$325:;
		if( (int64)I$2 >= 1ll) goto label$328;
		label$327:;
	}
	label$318:;
}

static int32 _Z15SortPartitionByIiPFbRiRiEER5ArrayIiEiiRS3_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, tmp$50* LESS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$329:;
	int32 MID_$1;
	MID_$1 = (int32)((int64)LO$1 + (((int64)HI$1 - (int64)LO$1) / 2ll));
	boolean SW$1;
	boolean vr$16 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
	SW$1 = vr$16;
	if( SW$1 == (boolean)0ll) goto label$332;
	{
		{
			int32 TMP$55$3;
			TMP$55$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = TMP$55$3;
		}
	}
	label$332:;
	label$331:;
	boolean vr$42 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
	SW$1 = vr$42;
	if( SW$1 == (boolean)0ll) goto label$334;
	{
		{
			int32 TMP$56$3;
			TMP$56$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = TMP$56$3;
		}
	}
	label$334:;
	label$333:;
	boolean vr$68 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) );
	SW$1 = vr$68;
	if( SW$1 == (boolean)0ll) goto label$336;
	{
		{
			int32 TMP$57$3;
			TMP$57$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) = TMP$57$3;
		}
	}
	label$336:;
	label$335:;
	{
		int32 TMP$58$2;
		TMP$58$2 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) = TMP$58$2;
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)HI$1 + 1ll);
	label$337:;
	{
		label$340:;
		{
			I$1 = (int32)((int64)I$1 + 1ll);
			if( (int64)I$1 <= (int64)HI$1) goto label$344;
			{
				goto label$341;
			}
			label$344:;
			label$343:;
			boolean LT$3;
			boolean vr$118 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + ((int64)I$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
			LT$3 = vr$118;
			if( LT$3 != (boolean)0ll) goto label$346;
			{
				goto label$341;
			}
			label$346:;
			label$345:;
		}
		label$342:;
		goto label$340;
		label$341:;
		label$347:;
		{
			J$1 = (int32)((int64)J$1 + -1ll);
			if( (int64)J$1 > (int64)LO$1) goto label$351;
			{
				goto label$348;
			}
			label$351:;
			label$350:;
			boolean GT$3;
			boolean vr$133 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) );
			GT$3 = vr$133;
			if( GT$3 != (boolean)0ll) goto label$353;
			{
				goto label$348;
			}
			label$353:;
			label$352:;
		}
		label$349:;
		goto label$347;
		label$348:;
		if( (int64)I$1 < (int64)J$1) goto label$355;
		{
			goto label$338;
		}
		label$355:;
		label$354:;
		{
			int32 TMP$59$3;
			TMP$59$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)I$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)I$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) = TMP$59$3;
		}
	}
	label$339:;
	goto label$337;
	label$338:;
	{
		int32 TMP$60$2;
		TMP$60$2 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) = TMP$60$2;
	}
	fb$result$1 = J$1;
	goto label$330;
	label$330:;
	return fb$result$1;
}

static void _Z15SortInsertionByIiPFbRiRiEER5ArrayIiEiiRS3_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, tmp$50* LESS$1 )
{
	label$356:;
	{
		int32 I$2;
		I$2 = (int32)((int64)LO$1 + 1ll);
		int32 TMP$61$2;
		TMP$61$2 = HI$1;
		goto label$358;
		label$361:;
		{
			int32 J$3;
			J$3 = I$2;
			label$362:;
			{
				if( (int64)J$3 > (int64)LO$1) goto label$366;
				{
					goto label$363;
				}
				label$366:;
				label$365:;
				boolean LT$4;
				boolean vr$14 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))), (int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll) );
				LT$4 = vr$14;
				if( LT$4 != (boolean)0ll) goto label$368;
				{
					goto label$363;
				}
				label$368:;
				label$367:;
				{
					int32 TMP$62$5;
					TMP$62$5 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll)));
					*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) = *(int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll);
					*(int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll) = TMP$62$5;
				}
				J$3 = (int32)((int64)J$3 + -1ll);
			}
			label$364:;
			goto label$362;
			label$363:;
		}
		label$359:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$358:;
		if( (int64)I$2 <= (int64)TMP$61$2) goto label$361;
		label$360:;
	}
	label$357:;
}

static void _Z14SortSiftDownByIiPFbRiRiEER5ArrayIiEiiiRS3_( struct $5ArrayIiE* A$1, int32 LO$1, int32 N$1, int32 ROOT$1, tmp$50* LESS$1 )
{
	label$369:;
	label$371:;
	{
		int32 CHILD$2;
		CHILD$2 = (int32)(((int64)ROOT$1 << (1ll & 63ll)) + 1ll);
		if( (int64)CHILD$2 < (int64)N$1) goto label$375;
		{
			goto label$372;
		}
		label$375:;
		label$374:;
		if( ((int64)CHILD$2 + 1ll) >= (int64)N$1) goto label$377;
		{
			boolean RIGHTISBIGGER$3;
			boolean vr$22 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))), (int32*)((uint8*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) + 4ll) );
			RIGHTISBIGGER$3 = vr$22;
			if( RIGHTISBIGGER$3 == (boolean)0ll) goto label$379;
			{
				CHILD$2 = (int32)((int64)CHILD$2 + 1ll);
			}
			label$379:;
			label$378:;
		}
		label$377:;
		label$376:;
		boolean CHILDISBIGGER$2;
		boolean vr$39 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) );
		CHILDISBIGGER$2 = vr$39;
		if( CHILDISBIGGER$2 != (boolean)0ll) goto label$381;
		{
			goto label$372;
		}
		label$381:;
		label$380:;
		{
			int32 TMP$63$3;
			TMP$63$3 = *(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) = TMP$63$3;
		}
		ROOT$1 = CHILD$2;
	}
	label$373:;
	goto label$371;
	label$372:;
	label$370:;
}

static boolean _ZN13ArrayIteratorI8FBSTRINGE7ISVALIDEv( struct $13ArrayIteratorI8FBSTRINGE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$476:;
	struct $5ArrayI8FBSTRINGE* A$1;
	A$1 = *(struct $5ArrayI8FBSTRINGE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$477;
	label$477:;
	return fb$result$1;
}

static FBSTRING* _ZN13ArrayIteratorI8FBSTRINGE5VALUEEv( struct $13ArrayIteratorI8FBSTRINGE* THIS$1 )
{
	FBSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$478:;
	struct $5ArrayI8FBSTRINGE* A$1;
	A$1 = *(struct $5ArrayI8FBSTRINGE**)THIS$1;
	fb$result$1 = (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) * 24ll));
	goto label$479;
	label$479:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorI8FBSTRINGE8MOVENEXTEv( struct $13ArrayIteratorI8FBSTRINGE* THIS$1 )
{
	label$480:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$481:;
}

static int32 _ZN5ArrayI8FBSTRINGE5COUNTEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$482:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$483;
	label$483:;
	return fb$result$1;
}

static int32 _ZN5ArrayI8FBSTRINGE8CAPACITYEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$484:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$485;
	label$485:;
	return fb$result$1;
}

static boolean _ZN5ArrayI8FBSTRINGE7ISEMPTYEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$486:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$487;
	label$487:;
	return fb$result$1;
}

static void _ZN5ArrayI8FBSTRINGE7RESERVEEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 N$1 )
{
	label$488:;
	int32 vr$1 = _ZN5ArrayI8FBSTRINGE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$491;
	{
		goto label$489;
	}
	label$491:;
	label$490:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayI8FBSTRINGE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$493;
	{
		CAP$1 = 8;
	}
	label$493:;
	label$492:;
	label$494:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$495;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$494;
	label$495:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 24ull, -1, -1, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$489:;
}

static void _ZN5ArrayI8FBSTRINGE6SHRINKEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	label$496:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$499;
	{
		fb_ArrayStrErase( (struct $7FBARRAYIvE*)THIS$1 );
		goto label$497;
	}
	label$499:;
	label$498:;
	int32 vr$6 = _ZN5ArrayI8FBSTRINGE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$501;
	{
		goto label$497;
	}
	label$501:;
	label$500:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 24ull, -1, -1, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$497:;
}

static FBSTRING* _ZN5ArrayI8FBSTRINGEixEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1 )
{
	FBSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$502:;
	fb$result$1 = (FBSTRING*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)I$1 * 24ll));
	goto label$503;
	label$503:;
	return fb$result$1;
}

static FBSTRING* _ZN5ArrayI8FBSTRINGE2ATEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1 )
{
	FBSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$504:;
	fb$result$1 = (FBSTRING*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)I$1 * 24ll));
	goto label$505;
	label$505:;
	return fb$result$1;
}

static void _ZN5ArrayI8FBSTRINGE4PUSHERS0_( struct $5ArrayI8FBSTRINGE* THIS$1, FBSTRING* V$1 )
{
	label$506:;
	_ZN5ArrayI8FBSTRINGE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 24ll)), -1ll, (void*)V$1, -1ll, 0 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$507:;
}

static FBSTRING* _ZN5ArrayI8FBSTRINGE3POPEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$508:;
	FBSTRING R$1;
	__builtin_memset( &R$1, 0, 24ll );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$511;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
		fb_StrDelete( (FBSTRING*)&R$1 );
		goto label$509;
	}
	label$511:;
	label$510:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	fb_StrAssign( (void*)&R$1, -1ll, (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 24ll)), -1ll, 0 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&R$1 );
	goto label$509;
	fb_StrDelete( (FBSTRING*)&R$1 );
	label$509:;
	FBSTRING* vr$23 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$23;
}

static void _ZN5ArrayI8FBSTRINGE6INSERTEiRS0_( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1, FBSTRING* V$1 )
{
	int64 TMP$121$1;
	label$512:;
	if( (int64)I$1 < 0ll) goto label$514;
	TMP$121$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$521;
	label$514:;
	TMP$121$1 = -1ll;
	label$521:;
	if( TMP$121$1 == 0ll) goto label$516;
	{
		goto label$513;
	}
	label$516:;
	label$515:;
	FBSTRING TMP$1;
	fb_StrInit( (void*)&TMP$1, -1ll, (void*)V$1, -1ll, 0 );
	_ZN5ArrayI8FBSTRINGE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$122$2;
		TMP$122$2 = (int32)((int64)I$1 + 1ll);
		goto label$517;
		label$520:;
		{
			fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)), -1ll, (void*)((uint8*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)) + -24ll), -1ll, 0 );
		}
		label$518:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$517:;
		if( (int64)K$2 >= (int64)TMP$122$2) goto label$520;
		label$519:;
	}
	fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)I$1 * 24ll)), -1ll, (void*)&TMP$1, -1ll, 0 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	fb_StrDelete( (FBSTRING*)&TMP$1 );
	label$513:;
}

static void _ZN5ArrayI8FBSTRINGE6REMOVEEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1 )
{
	int64 TMP$123$1;
	label$522:;
	if( (int64)I$1 < 0ll) goto label$524;
	TMP$123$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$531;
	label$524:;
	TMP$123$1 = -1ll;
	label$531:;
	if( TMP$123$1 == 0ll) goto label$526;
	{
		goto label$523;
	}
	label$526:;
	label$525:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$124$2;
		TMP$124$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$527;
		label$530:;
		{
			fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)), -1ll, (void*)((uint8*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)) + 24ll), -1ll, 0 );
		}
		label$528:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$527:;
		if( (int64)K$2 <= (int64)TMP$124$2) goto label$530;
		label$529:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$523:;
}

static void _ZN5ArrayI8FBSTRINGE10REMOVESWAPEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1 )
{
	int64 TMP$125$1;
	label$532:;
	if( (int64)I$1 < 0ll) goto label$534;
	TMP$125$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$539;
	label$534:;
	TMP$125$1 = -1ll;
	label$539:;
	if( TMP$125$1 == 0ll) goto label$536;
	{
		goto label$533;
	}
	label$536:;
	label$535:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$538;
	{
		fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)I$1 * 24ll)), -1ll, (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 24ll)), -1ll, 0 );
	}
	label$538:;
	label$537:;
	label$533:;
}

static void _ZN5ArrayI8FBSTRINGE5CLEAREv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	label$540:;
	FBSTRING BLANK$1;
	__builtin_memset( &BLANK$1, 0, 24ll );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$126$2;
		TMP$126$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$542;
		label$545:;
		{
			fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)), -1ll, (void*)&BLANK$1, -1ll, 0 );
		}
		label$543:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$542:;
		if( (int64)K$2 <= (int64)TMP$126$2) goto label$545;
		label$544:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	fb_StrDelete( (FBSTRING*)&BLANK$1 );
	label$541:;
}

static struct $13ArrayIteratorI8FBSTRINGE _ZN5ArrayI8FBSTRINGE11GETITERATOREv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	struct $13ArrayIteratorI8FBSTRINGE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$546:;
	struct $13ArrayIteratorI8FBSTRINGE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$547;
	label$547:;
	return fb$result$1;
}

static void _Z4SortI8FBSTRINGER5ArrayI8FBSTRINGE( struct $5ArrayI8FBSTRINGE* A$1 )
{
	label$548:;
	typedef boolean (*_Z7tmp$127R8FBSTRINGS0_)( FBSTRING*, FBSTRING* );
	_Z7tmp$127R8FBSTRINGS0_ LESS$1;
	LESS$1 = (_Z7tmp$127R8FBSTRINGS0_)&L3C22B1CEA777A486_LT_0080;
	_Z6SortByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGERS6_( A$1, (tmp$129*)&LESS$1 );
	label$549:;
}

boolean L3C22B1CEA777A486_LT_0080( FBSTRING* X$1, FBSTRING* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$550:;
	int32 vr$1 = fb_StrCompare( (void*)X$1, -1ll, (void*)Y$1, -1ll );
	fb$result$1 = (boolean)((int64)-((int64)vr$1 < 0ll) != 0ll);
	goto label$551;
	label$551:;
	return fb$result$1;
}

static boolean _Z8IsSortedI8FBSTRINGER5ArrayI8FBSTRINGE( struct $5ArrayI8FBSTRINGE* A$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$552:;
	typedef boolean (*_Z7tmp$130R8FBSTRINGS0_)( FBSTRING*, FBSTRING* );
	_Z7tmp$130R8FBSTRINGS0_ LESS$1;
	LESS$1 = (_Z7tmp$130R8FBSTRINGS0_)&L3C22B1CEA777A486_LT_0083;
	boolean vr$2 = _Z10IsSortedByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGERS6_( A$1, (tmp$129*)&LESS$1 );
	fb$result$1 = vr$2;
	goto label$553;
	label$553:;
	return fb$result$1;
}

boolean L3C22B1CEA777A486_LT_0083( FBSTRING* X$1, FBSTRING* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$554:;
	int32 vr$1 = fb_StrCompare( (void*)X$1, -1ll, (void*)Y$1, -1ll );
	fb$result$1 = (boolean)((int64)-((int64)vr$1 < 0ll) != 0ll);
	goto label$555;
	label$555:;
	return fb$result$1;
}

static boolean _ZN13ArrayIteratorIdE7ISVALIDEv( struct $13ArrayIteratorIdE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$556:;
	struct $5ArrayIdE* A$1;
	A$1 = *(struct $5ArrayIdE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$557;
	label$557:;
	return fb$result$1;
}

static double* _ZN13ArrayIteratorIdE5VALUEEv( struct $13ArrayIteratorIdE* THIS$1 )
{
	double* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$558:;
	struct $5ArrayIdE* A$1;
	A$1 = *(struct $5ArrayIdE**)THIS$1;
	fb$result$1 = (double*)((uint8*)*(double**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) << (3ll & 63ll)));
	goto label$559;
	label$559:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorIdE8MOVENEXTEv( struct $13ArrayIteratorIdE* THIS$1 )
{
	label$560:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$561:;
}

static int32 _ZN5ArrayIdE5COUNTEv( struct $5ArrayIdE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$562:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$563;
	label$563:;
	return fb$result$1;
}

static int32 _ZN5ArrayIdE8CAPACITYEv( struct $5ArrayIdE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$564:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$565;
	label$565:;
	return fb$result$1;
}

static boolean _ZN5ArrayIdE7ISEMPTYEv( struct $5ArrayIdE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$566:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$567;
	label$567:;
	return fb$result$1;
}

static void _ZN5ArrayIdE7RESERVEEi( struct $5ArrayIdE* THIS$1, int32 N$1 )
{
	label$568:;
	int32 vr$1 = _ZN5ArrayIdE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$571;
	{
		goto label$569;
	}
	label$571:;
	label$570:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayIdE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$573;
	{
		CAP$1 = 8;
	}
	label$573:;
	label$572:;
	label$574:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$575;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$574;
	label$575:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 8ull, -1, 0, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$569:;
}

static void _ZN5ArrayIdE6SHRINKEv( struct $5ArrayIdE* THIS$1 )
{
	label$576:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$579;
	{
		fb_ArrayErase( (struct $7FBARRAYIvE*)THIS$1 );
		goto label$577;
	}
	label$579:;
	label$578:;
	int32 vr$6 = _ZN5ArrayIdE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$581;
	{
		goto label$577;
	}
	label$581:;
	label$580:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 8ull, -1, 0, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$577:;
}

static double* _ZN5ArrayIdEixEi( struct $5ArrayIdE* THIS$1, int32 I$1 )
{
	double* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$582:;
	fb$result$1 = (double*)((uint8*)*(double**)THIS$1 + ((int64)I$1 << (3ll & 63ll)));
	goto label$583;
	label$583:;
	return fb$result$1;
}

static double* _ZN5ArrayIdE2ATEi( struct $5ArrayIdE* THIS$1, int32 I$1 )
{
	double* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$584:;
	fb$result$1 = (double*)((uint8*)*(double**)THIS$1 + ((int64)I$1 << (3ll & 63ll)));
	goto label$585;
	label$585:;
	return fb$result$1;
}

static void _ZN5ArrayIdE4PUSHERd( struct $5ArrayIdE* THIS$1, double* V$1 )
{
	label$586:;
	_ZN5ArrayIdE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	*(double*)((uint8*)*(double**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (3ll & 63ll))) = *V$1;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$587:;
}

static double _ZN5ArrayIdE3POPEv( struct $5ArrayIdE* THIS$1 )
{
	double fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$588:;
	double R$1;
	__builtin_memset( &R$1, 0, 8ll );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$591;
	{
		fb$result$1 = R$1;
		goto label$589;
	}
	label$591:;
	label$590:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	R$1 = *(double*)((uint8*)*(double**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (3ll & 63ll)));
	fb$result$1 = R$1;
	goto label$589;
	label$589:;
	return fb$result$1;
}

static void _ZN5ArrayIdE6INSERTEiRd( struct $5ArrayIdE* THIS$1, int32 I$1, double* V$1 )
{
	int64 TMP$132$1;
	label$592:;
	if( (int64)I$1 < 0ll) goto label$594;
	TMP$132$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$601;
	label$594:;
	TMP$132$1 = -1ll;
	label$601:;
	if( TMP$132$1 == 0ll) goto label$596;
	{
		goto label$593;
	}
	label$596:;
	label$595:;
	double TMP$1;
	TMP$1 = *V$1;
	_ZN5ArrayIdE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$133$2;
		TMP$133$2 = (int32)((int64)I$1 + 1ll);
		goto label$597;
		label$600:;
		{
			*(double*)((uint8*)*(double**)THIS$1 + ((int64)K$2 << (3ll & 63ll))) = *(double*)((uint8*)((uint8*)*(double**)THIS$1 + ((int64)K$2 << (3ll & 63ll))) + -8ll);
		}
		label$598:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$597:;
		if( (int64)K$2 >= (int64)TMP$133$2) goto label$600;
		label$599:;
	}
	*(double*)((uint8*)*(double**)THIS$1 + ((int64)I$1 << (3ll & 63ll))) = TMP$1;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$593:;
}

static void _ZN5ArrayIdE6REMOVEEi( struct $5ArrayIdE* THIS$1, int32 I$1 )
{
	int64 TMP$134$1;
	label$602:;
	if( (int64)I$1 < 0ll) goto label$604;
	TMP$134$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$611;
	label$604:;
	TMP$134$1 = -1ll;
	label$611:;
	if( TMP$134$1 == 0ll) goto label$606;
	{
		goto label$603;
	}
	label$606:;
	label$605:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$135$2;
		TMP$135$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$607;
		label$610:;
		{
			*(double*)((uint8*)*(double**)THIS$1 + ((int64)K$2 << (3ll & 63ll))) = *(double*)((uint8*)((uint8*)*(double**)THIS$1 + ((int64)K$2 << (3ll & 63ll))) + 8ll);
		}
		label$608:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$607:;
		if( (int64)K$2 <= (int64)TMP$135$2) goto label$610;
		label$609:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$603:;
}

static void _ZN5ArrayIdE10REMOVESWAPEi( struct $5ArrayIdE* THIS$1, int32 I$1 )
{
	int64 TMP$136$1;
	label$612:;
	if( (int64)I$1 < 0ll) goto label$614;
	TMP$136$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$619;
	label$614:;
	TMP$136$1 = -1ll;
	label$619:;
	if( TMP$136$1 == 0ll) goto label$616;
	{
		goto label$613;
	}
	label$616:;
	label$615:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$618;
	{
		*(double*)((uint8*)*(double**)THIS$1 + ((int64)I$1 << (3ll & 63ll))) = *(double*)((uint8*)*(double**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (3ll & 63ll)));
	}
	label$618:;
	label$617:;
	label$613:;
}

static void _ZN5ArrayIdE5CLEAREv( struct $5ArrayIdE* THIS$1 )
{
	label$620:;
	double BLANK$1;
	__builtin_memset( &BLANK$1, 0, 8ll );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$137$2;
		TMP$137$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$622;
		label$625:;
		{
			*(double*)((uint8*)*(double**)THIS$1 + ((int64)K$2 << (3ll & 63ll))) = BLANK$1;
		}
		label$623:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$622:;
		if( (int64)K$2 <= (int64)TMP$137$2) goto label$625;
		label$624:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	label$621:;
}

static struct $13ArrayIteratorIdE _ZN5ArrayIdE11GETITERATOREv( struct $5ArrayIdE* THIS$1 )
{
	struct $13ArrayIteratorIdE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$626:;
	struct $13ArrayIteratorIdE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$627;
	label$627:;
	return fb$result$1;
}

static void _Z4SortIdER5ArrayIdE( struct $5ArrayIdE* A$1 )
{
	label$628:;
	typedef boolean (*_Z7tmp$138RdS_)( double*, double* );
	_Z7tmp$138RdS_ LESS$1;
	LESS$1 = (_Z7tmp$138RdS_)&L3C22B1CEA777A486_LT_008B;
	_Z6SortByIdPFbRdRdEER5ArrayIdERS3_( A$1, (tmp$140*)&LESS$1 );
	label$629:;
}

boolean L3C22B1CEA777A486_LT_008B( double* X$1, double* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$630:;
	fb$result$1 = (boolean)((int64)-(*X$1 < *Y$1) != 0ll);
	goto label$631;
	label$631:;
	return fb$result$1;
}

static boolean _ZN13ArrayIteratorI3RECE7ISVALIDEv( struct $13ArrayIteratorI3RECE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$632:;
	struct $5ArrayI3RECE* A$1;
	A$1 = *(struct $5ArrayI3RECE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$633;
	label$633:;
	return fb$result$1;
}

static struct $3REC* _ZN13ArrayIteratorI3RECE5VALUEEv( struct $13ArrayIteratorI3RECE* THIS$1 )
{
	struct $3REC* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$634:;
	struct $5ArrayI3RECE* A$1;
	A$1 = *(struct $5ArrayI3RECE**)THIS$1;
	fb$result$1 = (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) << (3ll & 63ll)));
	goto label$635;
	label$635:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorI3RECE8MOVENEXTEv( struct $13ArrayIteratorI3RECE* THIS$1 )
{
	label$636:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$637:;
}

static int32 _ZN5ArrayI3RECE5COUNTEv( struct $5ArrayI3RECE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$638:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$639;
	label$639:;
	return fb$result$1;
}

static int32 _ZN5ArrayI3RECE8CAPACITYEv( struct $5ArrayI3RECE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$640:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$641;
	label$641:;
	return fb$result$1;
}

static boolean _ZN5ArrayI3RECE7ISEMPTYEv( struct $5ArrayI3RECE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$642:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$643;
	label$643:;
	return fb$result$1;
}

static void _ZN5ArrayI3RECE7RESERVEEi( struct $5ArrayI3RECE* THIS$1, int32 N$1 )
{
	label$644:;
	int32 vr$1 = _ZN5ArrayI3RECE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$647;
	{
		goto label$645;
	}
	label$647:;
	label$646:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayI3RECE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$649;
	{
		CAP$1 = 8;
	}
	label$649:;
	label$648:;
	label$650:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$651;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$650;
	label$651:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 8ull, -1, 0, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$645:;
}

static void _ZN5ArrayI3RECE6SHRINKEv( struct $5ArrayI3RECE* THIS$1 )
{
	label$652:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$655;
	{
		fb_ArrayErase( (struct $7FBARRAYIvE*)THIS$1 );
		goto label$653;
	}
	label$655:;
	label$654:;
	int32 vr$6 = _ZN5ArrayI3RECE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$657;
	{
		goto label$653;
	}
	label$657:;
	label$656:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 8ull, -1, 0, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$653:;
}

static struct $3REC* _ZN5ArrayI3RECEixEi( struct $5ArrayI3RECE* THIS$1, int32 I$1 )
{
	struct $3REC* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$658:;
	fb$result$1 = (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)I$1 << (3ll & 63ll)));
	goto label$659;
	label$659:;
	return fb$result$1;
}

static struct $3REC* _ZN5ArrayI3RECE2ATEi( struct $5ArrayI3RECE* THIS$1, int32 I$1 )
{
	struct $3REC* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$660:;
	fb$result$1 = (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)I$1 << (3ll & 63ll)));
	goto label$661;
	label$661:;
	return fb$result$1;
}

static void _ZN5ArrayI3RECE4PUSHERS0_( struct $5ArrayI3RECE* THIS$1, struct $3REC* V$1 )
{
	label$662:;
	_ZN5ArrayI3RECE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	__builtin_memcpy( (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (3ll & 63ll))), V$1, 8 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$663:;
}

static struct $3REC _ZN5ArrayI3RECE3POPEv( struct $5ArrayI3RECE* THIS$1 )
{
	struct $3REC fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$664:;
	struct $3REC R$1;
	__builtin_memset( &R$1, 0, 8ll );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$667;
	{
		__builtin_memcpy( &fb$result$1, &R$1, 8 );
		goto label$665;
	}
	label$667:;
	label$666:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	__builtin_memcpy( &R$1, (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (3ll & 63ll))), 8 );
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$665;
	label$665:;
	return fb$result$1;
}

static void _ZN5ArrayI3RECE6INSERTEiRS0_( struct $5ArrayI3RECE* THIS$1, int32 I$1, struct $3REC* V$1 )
{
	int64 TMP$141$1;
	label$668:;
	if( (int64)I$1 < 0ll) goto label$670;
	TMP$141$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$677;
	label$670:;
	TMP$141$1 = -1ll;
	label$677:;
	if( TMP$141$1 == 0ll) goto label$672;
	{
		goto label$669;
	}
	label$672:;
	label$671:;
	struct $3REC TMP$1;
	__builtin_memcpy( &TMP$1, V$1, 8 );
	_ZN5ArrayI3RECE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$142$2;
		TMP$142$2 = (int32)((int64)I$1 + 1ll);
		goto label$673;
		label$676:;
		{
			__builtin_memcpy( (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)K$2 << (3ll & 63ll))), (struct $3REC*)((uint8*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)K$2 << (3ll & 63ll))) + -8ll), 8 );
		}
		label$674:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$673:;
		if( (int64)K$2 >= (int64)TMP$142$2) goto label$676;
		label$675:;
	}
	__builtin_memcpy( (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)I$1 << (3ll & 63ll))), &TMP$1, 8 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$669:;
}

static void _ZN5ArrayI3RECE6REMOVEEi( struct $5ArrayI3RECE* THIS$1, int32 I$1 )
{
	int64 TMP$143$1;
	label$678:;
	if( (int64)I$1 < 0ll) goto label$680;
	TMP$143$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$687;
	label$680:;
	TMP$143$1 = -1ll;
	label$687:;
	if( TMP$143$1 == 0ll) goto label$682;
	{
		goto label$679;
	}
	label$682:;
	label$681:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$144$2;
		TMP$144$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$683;
		label$686:;
		{
			__builtin_memcpy( (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)K$2 << (3ll & 63ll))), (struct $3REC*)((uint8*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)K$2 << (3ll & 63ll))) + 8ll), 8 );
		}
		label$684:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$683:;
		if( (int64)K$2 <= (int64)TMP$144$2) goto label$686;
		label$685:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$679:;
}

static void _ZN5ArrayI3RECE10REMOVESWAPEi( struct $5ArrayI3RECE* THIS$1, int32 I$1 )
{
	int64 TMP$145$1;
	label$688:;
	if( (int64)I$1 < 0ll) goto label$690;
	TMP$145$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$695;
	label$690:;
	TMP$145$1 = -1ll;
	label$695:;
	if( TMP$145$1 == 0ll) goto label$692;
	{
		goto label$689;
	}
	label$692:;
	label$691:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$694;
	{
		__builtin_memcpy( (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)I$1 << (3ll & 63ll))), (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (3ll & 63ll))), 8 );
	}
	label$694:;
	label$693:;
	label$689:;
}

static void _ZN5ArrayI3RECE5CLEAREv( struct $5ArrayI3RECE* THIS$1 )
{
	label$696:;
	struct $3REC BLANK$1;
	__builtin_memset( &BLANK$1, 0, 8ll );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$146$2;
		TMP$146$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$698;
		label$701:;
		{
			__builtin_memcpy( (struct $3REC*)((uint8*)*(struct $3REC**)THIS$1 + ((int64)K$2 << (3ll & 63ll))), &BLANK$1, 8 );
		}
		label$699:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$698:;
		if( (int64)K$2 <= (int64)TMP$146$2) goto label$701;
		label$700:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	label$697:;
}

static struct $13ArrayIteratorI3RECE _ZN5ArrayI3RECE11GETITERATOREv( struct $5ArrayI3RECE* THIS$1 )
{
	struct $13ArrayIteratorI3RECE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$702:;
	struct $13ArrayIteratorI3RECE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$703;
	label$703:;
	return fb$result$1;
}

static void _Z4SortI3RECER5ArrayI3RECE( struct $5ArrayI3RECE* A$1 )
{
	label$704:;
	typedef boolean (*_Z7tmp$147R3RECS0_)( struct $3REC*, struct $3REC* );
	_Z7tmp$147R3RECS0_ LESS$1;
	LESS$1 = (_Z7tmp$147R3RECS0_)&L3C22B1CEA777A486_LT_0094;
	_Z6SortByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( A$1, (tmp$149*)&LESS$1 );
	label$705:;
}

boolean L3C22B1CEA777A486_LT_0094( struct $3REC* X$1, struct $3REC* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$706:;
	boolean vr$1 = _ZltR3RECS0_( X$1, Y$1 );
	fb$result$1 = vr$1;
	goto label$707;
	label$707:;
	return fb$result$1;
}

static boolean _Z8IsSortedI3RECER5ArrayI3RECE( struct $5ArrayI3RECE* A$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$708:;
	typedef boolean (*_Z7tmp$150R3RECS0_)( struct $3REC*, struct $3REC* );
	_Z7tmp$150R3RECS0_ LESS$1;
	LESS$1 = (_Z7tmp$150R3RECS0_)&L3C22B1CEA777A486_LT_0097;
	boolean vr$2 = _Z10IsSortedByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( A$1, (tmp$149*)&LESS$1 );
	fb$result$1 = vr$2;
	goto label$709;
	label$709:;
	return fb$result$1;
}

boolean L3C22B1CEA777A486_LT_0097( struct $3REC* X$1, struct $3REC* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$710:;
	boolean vr$1 = _ZltR3RECS0_( X$1, Y$1 );
	fb$result$1 = vr$1;
	goto label$711;
	label$711:;
	return fb$result$1;
}

static void _Z6SortByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGERS6_( struct $5ArrayI8FBSTRINGE* A$1, tmp$129* LESS$1 )
{
	label$712:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$715;
	{
		goto label$713;
	}
	label$715:;
	label$714:;
	int32 DEPTH$1;
	DEPTH$1 = 0;
	int32 M$1;
	M$1 = N$1;
	label$716:;
	if( (int64)M$1 <= 1ll) goto label$717;
	{
		M$1 = (int32)((int64)M$1 / 2ll);
		DEPTH$1 = (int32)((int64)DEPTH$1 + 1ll);
	}
	goto label$716;
	label$717:;
	DEPTH$1 = (int32)((int64)DEPTH$1 << (1ll & 63ll));
	_Z11SortIntroByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiiRS6_( A$1, 0, (int32)((int64)N$1 + -1ll), DEPTH$1, LESS$1 );
	label$713:;
}

static boolean _Z10IsSortedByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGERS6_( struct $5ArrayI8FBSTRINGE* A$1, tmp$129* LESS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$718:;
	{
		int32 I$2;
		I$2 = 1;
		int32 TMP$152$2;
		TMP$152$2 = (int32)((int64)*(int32*)((uint8*)A$1 + 72ll) + -1ll);
		goto label$720;
		label$723:;
		{
			boolean OUTOFORDER$3;
			boolean vr$14 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)I$2 * 24ll)), (FBSTRING*)((uint8*)((uint8*)*(FBSTRING**)A$1 + ((int64)I$2 * 24ll)) + -24ll) );
			OUTOFORDER$3 = vr$14;
			if( OUTOFORDER$3 == (boolean)0ll) goto label$725;
			{
				fb$result$1 = (boolean)0ll;
				goto label$719;
			}
			label$725:;
			label$724:;
		}
		label$721:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$720:;
		if( (int64)I$2 <= (int64)TMP$152$2) goto label$723;
		label$722:;
	}
	fb$result$1 = (boolean)1ll;
	goto label$719;
	label$719:;
	return fb$result$1;
}

static void _Z6SortByIdPFbRdRdEER5ArrayIdERS3_( struct $5ArrayIdE* A$1, tmp$140* LESS$1 )
{
	label$726:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$729;
	{
		goto label$727;
	}
	label$729:;
	label$728:;
	int32 DEPTH$1;
	DEPTH$1 = 0;
	int32 M$1;
	M$1 = N$1;
	label$730:;
	if( (int64)M$1 <= 1ll) goto label$731;
	{
		M$1 = (int32)((int64)M$1 / 2ll);
		DEPTH$1 = (int32)((int64)DEPTH$1 + 1ll);
	}
	goto label$730;
	label$731:;
	DEPTH$1 = (int32)((int64)DEPTH$1 << (1ll & 63ll));
	_Z11SortIntroByIdPFbRdRdEER5ArrayIdEiiiRS3_( A$1, 0, (int32)((int64)N$1 + -1ll), DEPTH$1, LESS$1 );
	label$727:;
}

static void _Z6SortByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( struct $5ArrayI3RECE* A$1, tmp$149* LESS$1 )
{
	label$732:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$735;
	{
		goto label$733;
	}
	label$735:;
	label$734:;
	int32 DEPTH$1;
	DEPTH$1 = 0;
	int32 M$1;
	M$1 = N$1;
	label$736:;
	if( (int64)M$1 <= 1ll) goto label$737;
	{
		M$1 = (int32)((int64)M$1 / 2ll);
		DEPTH$1 = (int32)((int64)DEPTH$1 + 1ll);
	}
	goto label$736;
	label$737:;
	DEPTH$1 = (int32)((int64)DEPTH$1 << (1ll & 63ll));
	_Z11SortIntroByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiiRS6_( A$1, 0, (int32)((int64)N$1 + -1ll), DEPTH$1, LESS$1 );
	label$733:;
}

static boolean _Z10IsSortedByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( struct $5ArrayI3RECE* A$1, tmp$149* LESS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$738:;
	{
		int32 I$2;
		I$2 = 1;
		int32 TMP$153$2;
		TMP$153$2 = (int32)((int64)*(int32*)((uint8*)A$1 + 72ll) + -1ll);
		goto label$740;
		label$743:;
		{
			boolean OUTOFORDER$3;
			boolean vr$14 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)I$2 << (3ll & 63ll))), (struct $3REC*)((uint8*)((uint8*)*(struct $3REC**)A$1 + ((int64)I$2 << (3ll & 63ll))) + -8ll) );
			OUTOFORDER$3 = vr$14;
			if( OUTOFORDER$3 == (boolean)0ll) goto label$745;
			{
				fb$result$1 = (boolean)0ll;
				goto label$739;
			}
			label$745:;
			label$744:;
		}
		label$741:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$740:;
		if( (int64)I$2 <= (int64)TMP$153$2) goto label$743;
		label$742:;
	}
	fb$result$1 = (boolean)1ll;
	goto label$739;
	label$739:;
	return fb$result$1;
}

static void _Z11SortIntroByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiiRS6_( struct $5ArrayI8FBSTRINGE* A$1, int32 LO$1, int32 HI$1, int32 DEPTH$1, tmp$129* LESS$1 )
{
	label$746:;
	label$748:;
	if( (((int64)HI$1 - (int64)LO$1) + 1ll) <= 16ll) goto label$749;
	{
		if( (int64)DEPTH$1 != 0ll) goto label$751;
		{
			_Z10SortHeapByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( A$1, LO$1, HI$1, LESS$1 );
			goto label$747;
		}
		label$751:;
		label$750:;
		DEPTH$1 = (int32)((int64)DEPTH$1 + -1ll);
		int32 P$2;
		int32 vr$8 = _Z15SortPartitionByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( A$1, LO$1, HI$1, LESS$1 );
		P$2 = vr$8;
		if( ((int64)P$2 - (int64)LO$1) >= ((int64)HI$1 - (int64)P$2)) goto label$753;
		{
			_Z11SortIntroByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiiRS6_( A$1, LO$1, (int32)((int64)P$2 + -1ll), DEPTH$1, LESS$1 );
			LO$1 = (int32)((int64)P$2 + 1ll);
		}
		goto label$752;
		label$753:;
		{
			_Z11SortIntroByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiiRS6_( A$1, (int32)((int64)P$2 + 1ll), HI$1, DEPTH$1, LESS$1 );
			HI$1 = (int32)((int64)P$2 + -1ll);
		}
		label$752:;
	}
	goto label$748;
	label$749:;
	_Z15SortInsertionByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( A$1, LO$1, HI$1, LESS$1 );
	label$747:;
}

static void _Z11SortIntroByIdPFbRdRdEER5ArrayIdEiiiRS3_( struct $5ArrayIdE* A$1, int32 LO$1, int32 HI$1, int32 DEPTH$1, tmp$140* LESS$1 )
{
	label$754:;
	label$756:;
	if( (((int64)HI$1 - (int64)LO$1) + 1ll) <= 16ll) goto label$757;
	{
		if( (int64)DEPTH$1 != 0ll) goto label$759;
		{
			_Z10SortHeapByIdPFbRdRdEER5ArrayIdEiiRS3_( A$1, LO$1, HI$1, LESS$1 );
			goto label$755;
		}
		label$759:;
		label$758:;
		DEPTH$1 = (int32)((int64)DEPTH$1 + -1ll);
		int32 P$2;
		int32 vr$8 = _Z15SortPartitionByIdPFbRdRdEER5ArrayIdEiiRS3_( A$1, LO$1, HI$1, LESS$1 );
		P$2 = vr$8;
		if( ((int64)P$2 - (int64)LO$1) >= ((int64)HI$1 - (int64)P$2)) goto label$761;
		{
			_Z11SortIntroByIdPFbRdRdEER5ArrayIdEiiiRS3_( A$1, LO$1, (int32)((int64)P$2 + -1ll), DEPTH$1, LESS$1 );
			LO$1 = (int32)((int64)P$2 + 1ll);
		}
		goto label$760;
		label$761:;
		{
			_Z11SortIntroByIdPFbRdRdEER5ArrayIdEiiiRS3_( A$1, (int32)((int64)P$2 + 1ll), HI$1, DEPTH$1, LESS$1 );
			HI$1 = (int32)((int64)P$2 + -1ll);
		}
		label$760:;
	}
	goto label$756;
	label$757:;
	_Z15SortInsertionByIdPFbRdRdEER5ArrayIdEiiRS3_( A$1, LO$1, HI$1, LESS$1 );
	label$755:;
}

static void _Z11SortIntroByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiiRS6_( struct $5ArrayI3RECE* A$1, int32 LO$1, int32 HI$1, int32 DEPTH$1, tmp$149* LESS$1 )
{
	label$762:;
	label$764:;
	if( (((int64)HI$1 - (int64)LO$1) + 1ll) <= 16ll) goto label$765;
	{
		if( (int64)DEPTH$1 != 0ll) goto label$767;
		{
			_Z10SortHeapByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( A$1, LO$1, HI$1, LESS$1 );
			goto label$763;
		}
		label$767:;
		label$766:;
		DEPTH$1 = (int32)((int64)DEPTH$1 + -1ll);
		int32 P$2;
		int32 vr$8 = _Z15SortPartitionByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( A$1, LO$1, HI$1, LESS$1 );
		P$2 = vr$8;
		if( ((int64)P$2 - (int64)LO$1) >= ((int64)HI$1 - (int64)P$2)) goto label$769;
		{
			_Z11SortIntroByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiiRS6_( A$1, LO$1, (int32)((int64)P$2 + -1ll), DEPTH$1, LESS$1 );
			LO$1 = (int32)((int64)P$2 + 1ll);
		}
		goto label$768;
		label$769:;
		{
			_Z11SortIntroByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiiRS6_( A$1, (int32)((int64)P$2 + 1ll), HI$1, DEPTH$1, LESS$1 );
			HI$1 = (int32)((int64)P$2 + -1ll);
		}
		label$768:;
	}
	goto label$764;
	label$765:;
	_Z15SortInsertionByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( A$1, LO$1, HI$1, LESS$1 );
	label$763:;
}

static void _Z10SortHeapByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( struct $5ArrayI8FBSTRINGE* A$1, int32 LO$1, int32 HI$1, tmp$129* LESS$1 )
{
	label$770:;
	int32 N$1;
	N$1 = (int32)(((int64)HI$1 - (int64)LO$1) + 1ll);
	if( (int64)N$1 >= 2ll) goto label$773;
	{
		goto label$771;
	}
	label$773:;
	label$772:;
	{
		int32 I$2;
		I$2 = (int32)(((int64)N$1 / 2ll) + -1ll);
		goto label$774;
		label$777:;
		{
			_Z14SortSiftDownByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiiRS6_( A$1, LO$1, N$1, I$2, LESS$1 );
		}
		label$775:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$774:;
		if( (int64)I$2 >= 0ll) goto label$777;
		label$776:;
	}
	{
		int32 I$2;
		I$2 = (int32)((int64)N$1 + -1ll);
		goto label$778;
		label$781:;
		{
			{
				fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)LO$1 * 24ll)), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + (((int64)LO$1 + (int64)I$2) * 24ll)), -1ll, 0 );
			}
			_Z14SortSiftDownByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiiRS6_( A$1, LO$1, I$2, 0, LESS$1 );
		}
		label$779:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$778:;
		if( (int64)I$2 >= 1ll) goto label$781;
		label$780:;
	}
	label$771:;
}

static int32 _Z15SortPartitionByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( struct $5ArrayI8FBSTRINGE* A$1, int32 LO$1, int32 HI$1, tmp$129* LESS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$782:;
	int32 MID_$1;
	MID_$1 = (int32)((int64)LO$1 + (((int64)HI$1 - (int64)LO$1) / 2ll));
	boolean SW$1;
	boolean vr$16 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)MID_$1 * 24ll)), (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)LO$1 * 24ll)) );
	SW$1 = vr$16;
	if( SW$1 == (boolean)0ll) goto label$785;
	{
		{
			fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)MID_$1 * 24ll)), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)LO$1 * 24ll)), -1ll, 0 );
		}
	}
	label$785:;
	label$784:;
	boolean vr$34 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)HI$1 * 24ll)), (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)LO$1 * 24ll)) );
	SW$1 = vr$34;
	if( SW$1 == (boolean)0ll) goto label$787;
	{
		{
			fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)HI$1 * 24ll)), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)LO$1 * 24ll)), -1ll, 0 );
		}
	}
	label$787:;
	label$786:;
	boolean vr$52 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)HI$1 * 24ll)), (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)MID_$1 * 24ll)) );
	SW$1 = vr$52;
	if( SW$1 == (boolean)0ll) goto label$789;
	{
		{
			fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)HI$1 * 24ll)), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)MID_$1 * 24ll)), -1ll, 0 );
		}
	}
	label$789:;
	label$788:;
	{
		fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)LO$1 * 24ll)), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)MID_$1 * 24ll)), -1ll, 0 );
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)HI$1 + 1ll);
	label$790:;
	{
		label$793:;
		{
			I$1 = (int32)((int64)I$1 + 1ll);
			if( (int64)I$1 <= (int64)HI$1) goto label$797;
			{
				goto label$794;
			}
			label$797:;
			label$796:;
			boolean LT$3;
			boolean vr$86 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)I$1 * 24ll)), (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)LO$1 * 24ll)) );
			LT$3 = vr$86;
			if( LT$3 != (boolean)0ll) goto label$799;
			{
				goto label$794;
			}
			label$799:;
			label$798:;
		}
		label$795:;
		goto label$793;
		label$794:;
		label$800:;
		{
			J$1 = (int32)((int64)J$1 + -1ll);
			if( (int64)J$1 > (int64)LO$1) goto label$804;
			{
				goto label$801;
			}
			label$804:;
			label$803:;
			boolean GT$3;
			boolean vr$101 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)LO$1 * 24ll)), (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)J$1 * 24ll)) );
			GT$3 = vr$101;
			if( GT$3 != (boolean)0ll) goto label$806;
			{
				goto label$801;
			}
			label$806:;
			label$805:;
		}
		label$802:;
		goto label$800;
		label$801:;
		if( (int64)I$1 < (int64)J$1) goto label$808;
		{
			goto label$791;
		}
		label$808:;
		label$807:;
		{
			fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)I$1 * 24ll)), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)J$1 * 24ll)), -1ll, 0 );
		}
	}
	label$792:;
	goto label$790;
	label$791:;
	{
		fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)LO$1 * 24ll)), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)J$1 * 24ll)), -1ll, 0 );
	}
	fb$result$1 = J$1;
	goto label$783;
	label$783:;
	return fb$result$1;
}

static void _Z15SortInsertionByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( struct $5ArrayI8FBSTRINGE* A$1, int32 LO$1, int32 HI$1, tmp$129* LESS$1 )
{
	label$809:;
	{
		int32 I$2;
		I$2 = (int32)((int64)LO$1 + 1ll);
		int32 TMP$154$2;
		TMP$154$2 = HI$1;
		goto label$811;
		label$814:;
		{
			int32 J$3;
			J$3 = I$2;
			label$815:;
			{
				if( (int64)J$3 > (int64)LO$1) goto label$819;
				{
					goto label$816;
				}
				label$819:;
				label$818:;
				boolean LT$4;
				boolean vr$14 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)J$3 * 24ll)), (FBSTRING*)((uint8*)((uint8*)*(FBSTRING**)A$1 + ((int64)J$3 * 24ll)) + -24ll) );
				LT$4 = vr$14;
				if( LT$4 != (boolean)0ll) goto label$821;
				{
					goto label$816;
				}
				label$821:;
				label$820:;
				{
					fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)J$3 * 24ll)), -1ll, 0, (void*)((uint8*)((uint8*)*(FBSTRING**)A$1 + ((int64)J$3 * 24ll)) + -24ll), -1ll, 0 );
				}
				J$3 = (int32)((int64)J$3 + -1ll);
			}
			label$817:;
			goto label$815;
			label$816:;
		}
		label$812:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$811:;
		if( (int64)I$2 <= (int64)TMP$154$2) goto label$814;
		label$813:;
	}
	label$810:;
}

static void _Z10SortHeapByIdPFbRdRdEER5ArrayIdEiiRS3_( struct $5ArrayIdE* A$1, int32 LO$1, int32 HI$1, tmp$140* LESS$1 )
{
	label$822:;
	int32 N$1;
	N$1 = (int32)(((int64)HI$1 - (int64)LO$1) + 1ll);
	if( (int64)N$1 >= 2ll) goto label$825;
	{
		goto label$823;
	}
	label$825:;
	label$824:;
	{
		int32 I$2;
		I$2 = (int32)(((int64)N$1 / 2ll) + -1ll);
		goto label$826;
		label$829:;
		{
			_Z14SortSiftDownByIdPFbRdRdEER5ArrayIdEiiiRS3_( A$1, LO$1, N$1, I$2, LESS$1 );
		}
		label$827:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$826:;
		if( (int64)I$2 >= 0ll) goto label$829;
		label$828:;
	}
	{
		int32 I$2;
		I$2 = (int32)((int64)N$1 + -1ll);
		goto label$830;
		label$833:;
		{
			{
				double TMP$155$4;
				TMP$155$4 = *(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll)));
				*(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll))) = *(double*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)I$2) << (3ll & 63ll)));
				*(double*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)I$2) << (3ll & 63ll))) = TMP$155$4;
			}
			_Z14SortSiftDownByIdPFbRdRdEER5ArrayIdEiiiRS3_( A$1, LO$1, I$2, 0, LESS$1 );
		}
		label$831:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$830:;
		if( (int64)I$2 >= 1ll) goto label$833;
		label$832:;
	}
	label$823:;
}

static int32 _Z15SortPartitionByIdPFbRdRdEER5ArrayIdEiiRS3_( struct $5ArrayIdE* A$1, int32 LO$1, int32 HI$1, tmp$140* LESS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$834:;
	int32 MID_$1;
	MID_$1 = (int32)((int64)LO$1 + (((int64)HI$1 - (int64)LO$1) / 2ll));
	boolean SW$1;
	boolean vr$16 = (*LESS$1)( (double*)((uint8*)*(double**)A$1 + ((int64)MID_$1 << (3ll & 63ll))), (double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll))) );
	SW$1 = vr$16;
	if( SW$1 == (boolean)0ll) goto label$837;
	{
		{
			double TMP$156$3;
			TMP$156$3 = *(double*)((uint8*)*(double**)A$1 + ((int64)MID_$1 << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + ((int64)MID_$1 << (3ll & 63ll))) = *(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll))) = TMP$156$3;
		}
	}
	label$837:;
	label$836:;
	boolean vr$42 = (*LESS$1)( (double*)((uint8*)*(double**)A$1 + ((int64)HI$1 << (3ll & 63ll))), (double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll))) );
	SW$1 = vr$42;
	if( SW$1 == (boolean)0ll) goto label$839;
	{
		{
			double TMP$157$3;
			TMP$157$3 = *(double*)((uint8*)*(double**)A$1 + ((int64)HI$1 << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + ((int64)HI$1 << (3ll & 63ll))) = *(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll))) = TMP$157$3;
		}
	}
	label$839:;
	label$838:;
	boolean vr$68 = (*LESS$1)( (double*)((uint8*)*(double**)A$1 + ((int64)HI$1 << (3ll & 63ll))), (double*)((uint8*)*(double**)A$1 + ((int64)MID_$1 << (3ll & 63ll))) );
	SW$1 = vr$68;
	if( SW$1 == (boolean)0ll) goto label$841;
	{
		{
			double TMP$158$3;
			TMP$158$3 = *(double*)((uint8*)*(double**)A$1 + ((int64)HI$1 << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + ((int64)HI$1 << (3ll & 63ll))) = *(double*)((uint8*)*(double**)A$1 + ((int64)MID_$1 << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + ((int64)MID_$1 << (3ll & 63ll))) = TMP$158$3;
		}
	}
	label$841:;
	label$840:;
	{
		double TMP$159$2;
		TMP$159$2 = *(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll)));
		*(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll))) = *(double*)((uint8*)*(double**)A$1 + ((int64)MID_$1 << (3ll & 63ll)));
		*(double*)((uint8*)*(double**)A$1 + ((int64)MID_$1 << (3ll & 63ll))) = TMP$159$2;
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)HI$1 + 1ll);
	label$842:;
	{
		label$845:;
		{
			I$1 = (int32)((int64)I$1 + 1ll);
			if( (int64)I$1 <= (int64)HI$1) goto label$849;
			{
				goto label$846;
			}
			label$849:;
			label$848:;
			boolean LT$3;
			boolean vr$118 = (*LESS$1)( (double*)((uint8*)*(double**)A$1 + ((int64)I$1 << (3ll & 63ll))), (double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll))) );
			LT$3 = vr$118;
			if( LT$3 != (boolean)0ll) goto label$851;
			{
				goto label$846;
			}
			label$851:;
			label$850:;
		}
		label$847:;
		goto label$845;
		label$846:;
		label$852:;
		{
			J$1 = (int32)((int64)J$1 + -1ll);
			if( (int64)J$1 > (int64)LO$1) goto label$856;
			{
				goto label$853;
			}
			label$856:;
			label$855:;
			boolean GT$3;
			boolean vr$133 = (*LESS$1)( (double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll))), (double*)((uint8*)*(double**)A$1 + ((int64)J$1 << (3ll & 63ll))) );
			GT$3 = vr$133;
			if( GT$3 != (boolean)0ll) goto label$858;
			{
				goto label$853;
			}
			label$858:;
			label$857:;
		}
		label$854:;
		goto label$852;
		label$853:;
		if( (int64)I$1 < (int64)J$1) goto label$860;
		{
			goto label$843;
		}
		label$860:;
		label$859:;
		{
			double TMP$160$3;
			TMP$160$3 = *(double*)((uint8*)*(double**)A$1 + ((int64)I$1 << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + ((int64)I$1 << (3ll & 63ll))) = *(double*)((uint8*)*(double**)A$1 + ((int64)J$1 << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + ((int64)J$1 << (3ll & 63ll))) = TMP$160$3;
		}
	}
	label$844:;
	goto label$842;
	label$843:;
	{
		double TMP$161$2;
		TMP$161$2 = *(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll)));
		*(double*)((uint8*)*(double**)A$1 + ((int64)LO$1 << (3ll & 63ll))) = *(double*)((uint8*)*(double**)A$1 + ((int64)J$1 << (3ll & 63ll)));
		*(double*)((uint8*)*(double**)A$1 + ((int64)J$1 << (3ll & 63ll))) = TMP$161$2;
	}
	fb$result$1 = J$1;
	goto label$835;
	label$835:;
	return fb$result$1;
}

static void _Z15SortInsertionByIdPFbRdRdEER5ArrayIdEiiRS3_( struct $5ArrayIdE* A$1, int32 LO$1, int32 HI$1, tmp$140* LESS$1 )
{
	label$861:;
	{
		int32 I$2;
		I$2 = (int32)((int64)LO$1 + 1ll);
		int32 TMP$162$2;
		TMP$162$2 = HI$1;
		goto label$863;
		label$866:;
		{
			int32 J$3;
			J$3 = I$2;
			label$867:;
			{
				if( (int64)J$3 > (int64)LO$1) goto label$871;
				{
					goto label$868;
				}
				label$871:;
				label$870:;
				boolean LT$4;
				boolean vr$14 = (*LESS$1)( (double*)((uint8*)*(double**)A$1 + ((int64)J$3 << (3ll & 63ll))), (double*)((uint8*)((uint8*)*(double**)A$1 + ((int64)J$3 << (3ll & 63ll))) + -8ll) );
				LT$4 = vr$14;
				if( LT$4 != (boolean)0ll) goto label$873;
				{
					goto label$868;
				}
				label$873:;
				label$872:;
				{
					double TMP$163$5;
					TMP$163$5 = *(double*)((uint8*)*(double**)A$1 + ((int64)J$3 << (3ll & 63ll)));
					*(double*)((uint8*)*(double**)A$1 + ((int64)J$3 << (3ll & 63ll))) = *(double*)((uint8*)((uint8*)*(double**)A$1 + ((int64)J$3 << (3ll & 63ll))) + -8ll);
					*(double*)((uint8*)((uint8*)*(double**)A$1 + ((int64)J$3 << (3ll & 63ll))) + -8ll) = TMP$163$5;
				}
				J$3 = (int32)((int64)J$3 + -1ll);
			}
			label$869:;
			goto label$867;
			label$868:;
		}
		label$864:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$863:;
		if( (int64)I$2 <= (int64)TMP$162$2) goto label$866;
		label$865:;
	}
	label$862:;
}

static void _Z10SortHeapByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( struct $5ArrayI3RECE* A$1, int32 LO$1, int32 HI$1, tmp$149* LESS$1 )
{
	label$874:;
	int32 N$1;
	N$1 = (int32)(((int64)HI$1 - (int64)LO$1) + 1ll);
	if( (int64)N$1 >= 2ll) goto label$877;
	{
		goto label$875;
	}
	label$877:;
	label$876:;
	{
		int32 I$2;
		I$2 = (int32)(((int64)N$1 / 2ll) + -1ll);
		goto label$878;
		label$881:;
		{
			_Z14SortSiftDownByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiiRS6_( A$1, LO$1, N$1, I$2, LESS$1 );
		}
		label$879:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$878:;
		if( (int64)I$2 >= 0ll) goto label$881;
		label$880:;
	}
	{
		int32 I$2;
		I$2 = (int32)((int64)N$1 + -1ll);
		goto label$882;
		label$885:;
		{
			{
				fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)LO$1 << (3ll & 63ll))), (void*)((uint8*)*(struct $3REC**)A$1 + (((int64)LO$1 + (int64)I$2) << (3ll & 63ll))), 8ll );
			}
			_Z14SortSiftDownByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiiRS6_( A$1, LO$1, I$2, 0, LESS$1 );
		}
		label$883:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$882:;
		if( (int64)I$2 >= 1ll) goto label$885;
		label$884:;
	}
	label$875:;
}

static int32 _Z15SortPartitionByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( struct $5ArrayI3RECE* A$1, int32 LO$1, int32 HI$1, tmp$149* LESS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$886:;
	int32 MID_$1;
	MID_$1 = (int32)((int64)LO$1 + (((int64)HI$1 - (int64)LO$1) / 2ll));
	boolean SW$1;
	boolean vr$16 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)MID_$1 << (3ll & 63ll))), (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)LO$1 << (3ll & 63ll))) );
	SW$1 = vr$16;
	if( SW$1 == (boolean)0ll) goto label$889;
	{
		{
			fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)MID_$1 << (3ll & 63ll))), (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)LO$1 << (3ll & 63ll))), 8ll );
		}
	}
	label$889:;
	label$888:;
	boolean vr$34 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)HI$1 << (3ll & 63ll))), (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)LO$1 << (3ll & 63ll))) );
	SW$1 = vr$34;
	if( SW$1 == (boolean)0ll) goto label$891;
	{
		{
			fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)HI$1 << (3ll & 63ll))), (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)LO$1 << (3ll & 63ll))), 8ll );
		}
	}
	label$891:;
	label$890:;
	boolean vr$52 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)HI$1 << (3ll & 63ll))), (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)MID_$1 << (3ll & 63ll))) );
	SW$1 = vr$52;
	if( SW$1 == (boolean)0ll) goto label$893;
	{
		{
			fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)HI$1 << (3ll & 63ll))), (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)MID_$1 << (3ll & 63ll))), 8ll );
		}
	}
	label$893:;
	label$892:;
	{
		fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)LO$1 << (3ll & 63ll))), (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)MID_$1 << (3ll & 63ll))), 8ll );
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)HI$1 + 1ll);
	label$894:;
	{
		label$897:;
		{
			I$1 = (int32)((int64)I$1 + 1ll);
			if( (int64)I$1 <= (int64)HI$1) goto label$901;
			{
				goto label$898;
			}
			label$901:;
			label$900:;
			boolean LT$3;
			boolean vr$86 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)I$1 << (3ll & 63ll))), (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)LO$1 << (3ll & 63ll))) );
			LT$3 = vr$86;
			if( LT$3 != (boolean)0ll) goto label$903;
			{
				goto label$898;
			}
			label$903:;
			label$902:;
		}
		label$899:;
		goto label$897;
		label$898:;
		label$904:;
		{
			J$1 = (int32)((int64)J$1 + -1ll);
			if( (int64)J$1 > (int64)LO$1) goto label$908;
			{
				goto label$905;
			}
			label$908:;
			label$907:;
			boolean GT$3;
			boolean vr$101 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)LO$1 << (3ll & 63ll))), (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)J$1 << (3ll & 63ll))) );
			GT$3 = vr$101;
			if( GT$3 != (boolean)0ll) goto label$910;
			{
				goto label$905;
			}
			label$910:;
			label$909:;
		}
		label$906:;
		goto label$904;
		label$905:;
		if( (int64)I$1 < (int64)J$1) goto label$912;
		{
			goto label$895;
		}
		label$912:;
		label$911:;
		{
			fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)I$1 << (3ll & 63ll))), (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)J$1 << (3ll & 63ll))), 8ll );
		}
	}
	label$896:;
	goto label$894;
	label$895:;
	{
		fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)LO$1 << (3ll & 63ll))), (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)J$1 << (3ll & 63ll))), 8ll );
	}
	fb$result$1 = J$1;
	goto label$887;
	label$887:;
	return fb$result$1;
}

static void _Z15SortInsertionByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( struct $5ArrayI3RECE* A$1, int32 LO$1, int32 HI$1, tmp$149* LESS$1 )
{
	label$913:;
	{
		int32 I$2;
		I$2 = (int32)((int64)LO$1 + 1ll);
		int32 TMP$164$2;
		TMP$164$2 = HI$1;
		goto label$915;
		label$918:;
		{
			int32 J$3;
			J$3 = I$2;
			label$919:;
			{
				if( (int64)J$3 > (int64)LO$1) goto label$923;
				{
					goto label$920;
				}
				label$923:;
				label$922:;
				boolean LT$4;
				boolean vr$14 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)J$3 << (3ll & 63ll))), (struct $3REC*)((uint8*)((uint8*)*(struct $3REC**)A$1 + ((int64)J$3 << (3ll & 63ll))) + -8ll) );
				LT$4 = vr$14;
				if( LT$4 != (boolean)0ll) goto label$925;
				{
					goto label$920;
				}
				label$925:;
				label$924:;
				{
					fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)J$3 << (3ll & 63ll))), (void*)((uint8*)((uint8*)*(struct $3REC**)A$1 + ((int64)J$3 << (3ll & 63ll))) + -8ll), 8ll );
				}
				J$3 = (int32)((int64)J$3 + -1ll);
			}
			label$921:;
			goto label$919;
			label$920:;
		}
		label$916:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$915:;
		if( (int64)I$2 <= (int64)TMP$164$2) goto label$918;
		label$917:;
	}
	label$914:;
}

static void _Z14SortSiftDownByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiiRS6_( struct $5ArrayI8FBSTRINGE* A$1, int32 LO$1, int32 N$1, int32 ROOT$1, tmp$129* LESS$1 )
{
	label$926:;
	label$928:;
	{
		int32 CHILD$2;
		CHILD$2 = (int32)(((int64)ROOT$1 << (1ll & 63ll)) + 1ll);
		if( (int64)CHILD$2 < (int64)N$1) goto label$932;
		{
			goto label$929;
		}
		label$932:;
		label$931:;
		if( ((int64)CHILD$2 + 1ll) >= (int64)N$1) goto label$934;
		{
			boolean RIGHTISBIGGER$3;
			boolean vr$22 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + (((int64)LO$1 + (int64)CHILD$2) * 24ll)), (FBSTRING*)((uint8*)((uint8*)*(FBSTRING**)A$1 + (((int64)LO$1 + (int64)CHILD$2) * 24ll)) + 24ll) );
			RIGHTISBIGGER$3 = vr$22;
			if( RIGHTISBIGGER$3 == (boolean)0ll) goto label$936;
			{
				CHILD$2 = (int32)((int64)CHILD$2 + 1ll);
			}
			label$936:;
			label$935:;
		}
		label$934:;
		label$933:;
		boolean CHILDISBIGGER$2;
		boolean vr$39 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + (((int64)LO$1 + (int64)ROOT$1) * 24ll)), (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + (((int64)LO$1 + (int64)CHILD$2) * 24ll)) );
		CHILDISBIGGER$2 = vr$39;
		if( CHILDISBIGGER$2 != (boolean)0ll) goto label$938;
		{
			goto label$929;
		}
		label$938:;
		label$937:;
		{
			fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + (((int64)LO$1 + (int64)ROOT$1) * 24ll)), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + (((int64)LO$1 + (int64)CHILD$2) * 24ll)), -1ll, 0 );
		}
		ROOT$1 = CHILD$2;
	}
	label$930:;
	goto label$928;
	label$929:;
	label$927:;
}

static void _Z14SortSiftDownByIdPFbRdRdEER5ArrayIdEiiiRS3_( struct $5ArrayIdE* A$1, int32 LO$1, int32 N$1, int32 ROOT$1, tmp$140* LESS$1 )
{
	label$939:;
	label$941:;
	{
		int32 CHILD$2;
		CHILD$2 = (int32)(((int64)ROOT$1 << (1ll & 63ll)) + 1ll);
		if( (int64)CHILD$2 < (int64)N$1) goto label$945;
		{
			goto label$942;
		}
		label$945:;
		label$944:;
		if( ((int64)CHILD$2 + 1ll) >= (int64)N$1) goto label$947;
		{
			boolean RIGHTISBIGGER$3;
			boolean vr$22 = (*LESS$1)( (double*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (3ll & 63ll))), (double*)((uint8*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (3ll & 63ll))) + 8ll) );
			RIGHTISBIGGER$3 = vr$22;
			if( RIGHTISBIGGER$3 == (boolean)0ll) goto label$949;
			{
				CHILD$2 = (int32)((int64)CHILD$2 + 1ll);
			}
			label$949:;
			label$948:;
		}
		label$947:;
		label$946:;
		boolean CHILDISBIGGER$2;
		boolean vr$39 = (*LESS$1)( (double*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (3ll & 63ll))), (double*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (3ll & 63ll))) );
		CHILDISBIGGER$2 = vr$39;
		if( CHILDISBIGGER$2 != (boolean)0ll) goto label$951;
		{
			goto label$942;
		}
		label$951:;
		label$950:;
		{
			double TMP$165$3;
			TMP$165$3 = *(double*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (3ll & 63ll))) = *(double*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (3ll & 63ll)));
			*(double*)((uint8*)*(double**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (3ll & 63ll))) = TMP$165$3;
		}
		ROOT$1 = CHILD$2;
	}
	label$943:;
	goto label$941;
	label$942:;
	label$940:;
}

static void _Z14SortSiftDownByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiiRS6_( struct $5ArrayI3RECE* A$1, int32 LO$1, int32 N$1, int32 ROOT$1, tmp$149* LESS$1 )
{
	label$952:;
	label$954:;
	{
		int32 CHILD$2;
		CHILD$2 = (int32)(((int64)ROOT$1 << (1ll & 63ll)) + 1ll);
		if( (int64)CHILD$2 < (int64)N$1) goto label$958;
		{
			goto label$955;
		}
		label$958:;
		label$957:;
		if( ((int64)CHILD$2 + 1ll) >= (int64)N$1) goto label$960;
		{
			boolean RIGHTISBIGGER$3;
			boolean vr$22 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (3ll & 63ll))), (struct $3REC*)((uint8*)((uint8*)*(struct $3REC**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (3ll & 63ll))) + 8ll) );
			RIGHTISBIGGER$3 = vr$22;
			if( RIGHTISBIGGER$3 == (boolean)0ll) goto label$962;
			{
				CHILD$2 = (int32)((int64)CHILD$2 + 1ll);
			}
			label$962:;
			label$961:;
		}
		label$960:;
		label$959:;
		boolean CHILDISBIGGER$2;
		boolean vr$39 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (3ll & 63ll))), (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (3ll & 63ll))) );
		CHILDISBIGGER$2 = vr$39;
		if( CHILDISBIGGER$2 != (boolean)0ll) goto label$964;
		{
			goto label$955;
		}
		label$964:;
		label$963:;
		{
			fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (3ll & 63ll))), (void*)((uint8*)*(struct $3REC**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (3ll & 63ll))), 8ll );
		}
		ROOT$1 = CHILD$2;
	}
	label$956:;
	goto label$954;
	label$955:;
	label$953:;
}

boolean LD2939E50C2FFBF23_LT_00A6( int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$981:;
	fb$result$1 = (boolean)((int64)-((int64)*X$1 > (int64)*Y$1) != 0ll);
	goto label$982;
	label$982:;
	return fb$result$1;
}

boolean LD2939E50C2FFBF23_LT_00A9( int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$983:;
	fb$result$1 = (boolean)((int64)-((int64)*X$1 > (int64)*Y$1) != 0ll);
	goto label$984;
	label$984:;
	return fb$result$1;
}

static boolean _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( struct $25LD2939E50C2FFBF23_Lt_00ADIiE* THIS$1, int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$995:;
	int32* COMPARISONS$1;
	COMPARISONS$1 = *(int32**)THIS$1;
	*COMPARISONS$1 = (int32)((int64)*COMPARISONS$1 + 1ll);
	fb$result$1 = (boolean)((int64)-((int64)*X$1 < (int64)*Y$1) != 0ll);
	goto label$996;
	label$996:;
	return fb$result$1;
}

static void _Z6SortByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiERS1_( struct $5ArrayIiE* A$1, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* LESS$1 )
{
	label$997:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$1000;
	{
		goto label$998;
	}
	label$1000:;
	label$999:;
	int32 DEPTH$1;
	DEPTH$1 = 0;
	int32 M$1;
	M$1 = N$1;
	label$1001:;
	if( (int64)M$1 <= 1ll) goto label$1002;
	{
		M$1 = (int32)((int64)M$1 / 2ll);
		DEPTH$1 = (int32)((int64)DEPTH$1 + 1ll);
	}
	goto label$1001;
	label$1002:;
	DEPTH$1 = (int32)((int64)DEPTH$1 << (1ll & 63ll));
	_Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiiRS1_( A$1, 0, (int32)((int64)N$1 + -1ll), DEPTH$1, LESS$1 );
	label$998:;
}

static void _Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, int32 DEPTH$1, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* LESS$1 )
{
	label$1003:;
	label$1005:;
	if( (((int64)HI$1 - (int64)LO$1) + 1ll) <= 16ll) goto label$1006;
	{
		if( (int64)DEPTH$1 != 0ll) goto label$1008;
		{
			_Z10SortHeapByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiRS1_( A$1, LO$1, HI$1, LESS$1 );
			goto label$1004;
		}
		label$1008:;
		label$1007:;
		DEPTH$1 = (int32)((int64)DEPTH$1 + -1ll);
		int32 P$2;
		int32 vr$8 = _Z15SortPartitionByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiRS1_( A$1, LO$1, HI$1, LESS$1 );
		P$2 = vr$8;
		if( ((int64)P$2 - (int64)LO$1) >= ((int64)HI$1 - (int64)P$2)) goto label$1010;
		{
			_Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiiRS1_( A$1, LO$1, (int32)((int64)P$2 + -1ll), DEPTH$1, LESS$1 );
			LO$1 = (int32)((int64)P$2 + 1ll);
		}
		goto label$1009;
		label$1010:;
		{
			_Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiiRS1_( A$1, (int32)((int64)P$2 + 1ll), HI$1, DEPTH$1, LESS$1 );
			HI$1 = (int32)((int64)P$2 + -1ll);
		}
		label$1009:;
	}
	goto label$1005;
	label$1006:;
	_Z15SortInsertionByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiRS1_( A$1, LO$1, HI$1, LESS$1 );
	label$1004:;
}

static void _Z10SortHeapByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* LESS$1 )
{
	label$1011:;
	int32 N$1;
	N$1 = (int32)(((int64)HI$1 - (int64)LO$1) + 1ll);
	if( (int64)N$1 >= 2ll) goto label$1014;
	{
		goto label$1012;
	}
	label$1014:;
	label$1013:;
	{
		int32 I$2;
		I$2 = (int32)(((int64)N$1 / 2ll) + -1ll);
		goto label$1015;
		label$1018:;
		{
			_Z14SortSiftDownByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiiRS1_( A$1, LO$1, N$1, I$2, LESS$1 );
		}
		label$1016:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$1015:;
		if( (int64)I$2 >= 0ll) goto label$1018;
		label$1017:;
	}
	{
		int32 I$2;
		I$2 = (int32)((int64)N$1 + -1ll);
		goto label$1019;
		label$1022:;
		{
			{
				int32 TMP$177$4;
				TMP$177$4 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)I$2) << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)I$2) << (2ll & 63ll))) = TMP$177$4;
			}
			_Z14SortSiftDownByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiiRS1_( A$1, LO$1, I$2, 0, LESS$1 );
		}
		label$1020:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$1019:;
		if( (int64)I$2 >= 1ll) goto label$1022;
		label$1021:;
	}
	label$1012:;
}

static int32 _Z15SortPartitionByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* LESS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$1023:;
	int32 MID_$1;
	MID_$1 = (int32)((int64)LO$1 + (((int64)HI$1 - (int64)LO$1) / 2ll));
	boolean SW$1;
	boolean vr$16 = _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
	SW$1 = vr$16;
	if( SW$1 == (boolean)0ll) goto label$1026;
	{
		{
			int32 TMP$178$3;
			TMP$178$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = TMP$178$3;
		}
	}
	label$1026:;
	label$1025:;
	boolean vr$41 = _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
	SW$1 = vr$41;
	if( SW$1 == (boolean)0ll) goto label$1028;
	{
		{
			int32 TMP$179$3;
			TMP$179$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = TMP$179$3;
		}
	}
	label$1028:;
	label$1027:;
	boolean vr$66 = _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) );
	SW$1 = vr$66;
	if( SW$1 == (boolean)0ll) goto label$1030;
	{
		{
			int32 TMP$180$3;
			TMP$180$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) = TMP$180$3;
		}
	}
	label$1030:;
	label$1029:;
	{
		int32 TMP$181$2;
		TMP$181$2 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) = TMP$181$2;
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)HI$1 + 1ll);
	label$1031:;
	{
		label$1034:;
		{
			I$1 = (int32)((int64)I$1 + 1ll);
			if( (int64)I$1 <= (int64)HI$1) goto label$1038;
			{
				goto label$1035;
			}
			label$1038:;
			label$1037:;
			boolean LT$3;
			boolean vr$115 = _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)I$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
			LT$3 = vr$115;
			if( LT$3 != (boolean)0ll) goto label$1040;
			{
				goto label$1035;
			}
			label$1040:;
			label$1039:;
		}
		label$1036:;
		goto label$1034;
		label$1035:;
		label$1041:;
		{
			J$1 = (int32)((int64)J$1 + -1ll);
			if( (int64)J$1 > (int64)LO$1) goto label$1045;
			{
				goto label$1042;
			}
			label$1045:;
			label$1044:;
			boolean GT$3;
			boolean vr$129 = _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) );
			GT$3 = vr$129;
			if( GT$3 != (boolean)0ll) goto label$1047;
			{
				goto label$1042;
			}
			label$1047:;
			label$1046:;
		}
		label$1043:;
		goto label$1041;
		label$1042:;
		if( (int64)I$1 < (int64)J$1) goto label$1049;
		{
			goto label$1032;
		}
		label$1049:;
		label$1048:;
		{
			int32 TMP$182$3;
			TMP$182$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)I$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)I$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) = TMP$182$3;
		}
	}
	label$1033:;
	goto label$1031;
	label$1032:;
	{
		int32 TMP$183$2;
		TMP$183$2 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) = TMP$183$2;
	}
	fb$result$1 = J$1;
	goto label$1024;
	label$1024:;
	return fb$result$1;
}

static void _Z15SortInsertionByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* LESS$1 )
{
	label$1050:;
	{
		int32 I$2;
		I$2 = (int32)((int64)LO$1 + 1ll);
		int32 TMP$184$2;
		TMP$184$2 = HI$1;
		goto label$1052;
		label$1055:;
		{
			int32 J$3;
			J$3 = I$2;
			label$1056:;
			{
				if( (int64)J$3 > (int64)LO$1) goto label$1060;
				{
					goto label$1057;
				}
				label$1060:;
				label$1059:;
				boolean LT$4;
				boolean vr$14 = _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))), (int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll) );
				LT$4 = vr$14;
				if( LT$4 != (boolean)0ll) goto label$1062;
				{
					goto label$1057;
				}
				label$1062:;
				label$1061:;
				{
					int32 TMP$185$5;
					TMP$185$5 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll)));
					*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) = *(int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll);
					*(int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll) = TMP$185$5;
				}
				J$3 = (int32)((int64)J$3 + -1ll);
			}
			label$1058:;
			goto label$1056;
			label$1057:;
		}
		label$1053:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$1052:;
		if( (int64)I$2 <= (int64)TMP$184$2) goto label$1055;
		label$1054:;
	}
	label$1051:;
}

static void _Z14SortSiftDownByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiEiiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 N$1, int32 ROOT$1, struct $25LD2939E50C2FFBF23_Lt_00ADIiE* LESS$1 )
{
	label$1063:;
	label$1065:;
	{
		int32 CHILD$2;
		CHILD$2 = (int32)(((int64)ROOT$1 << (1ll & 63ll)) + 1ll);
		if( (int64)CHILD$2 < (int64)N$1) goto label$1069;
		{
			goto label$1066;
		}
		label$1069:;
		label$1068:;
		if( ((int64)CHILD$2 + 1ll) >= (int64)N$1) goto label$1071;
		{
			boolean RIGHTISBIGGER$3;
			boolean vr$22 = _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))), (int32*)((uint8*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) + 4ll) );
			RIGHTISBIGGER$3 = vr$22;
			if( RIGHTISBIGGER$3 == (boolean)0ll) goto label$1073;
			{
				CHILD$2 = (int32)((int64)CHILD$2 + 1ll);
			}
			label$1073:;
			label$1072:;
		}
		label$1071:;
		label$1070:;
		boolean CHILDISBIGGER$2;
		boolean vr$38 = _ZN25LD2939E50C2FFBF23_Lt_00ADIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) );
		CHILDISBIGGER$2 = vr$38;
		if( CHILDISBIGGER$2 != (boolean)0ll) goto label$1075;
		{
			goto label$1066;
		}
		label$1075:;
		label$1074:;
		{
			int32 TMP$186$3;
			TMP$186$3 = *(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) = TMP$186$3;
		}
		ROOT$1 = CHILD$2;
	}
	label$1067:;
	goto label$1065;
	label$1066:;
	label$1064:;
}

boolean LD2939E50C2FFBF23_LT_00BB( struct $3REC* X$1, struct $3REC* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1088:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)X$1 + 4ll) < (int64)*(int32*)((uint8*)Y$1 + 4ll)) != 0ll);
	goto label$1089;
	label$1089:;
	return fb$result$1;
}

static boolean _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( struct $25LD2939E50C2FFBF23_Lt_00BEIiE* THIS$1, int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1106:;
	int32* COMPARISONS$1;
	COMPARISONS$1 = *(int32**)THIS$1;
	*COMPARISONS$1 = (int32)((int64)*COMPARISONS$1 + 1ll);
	fb$result$1 = (boolean)((int64)-((int64)*X$1 < (int64)*Y$1) != 0ll);
	goto label$1107;
	label$1107:;
	return fb$result$1;
}

static void _Z6SortByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiERS1_( struct $5ArrayIiE* A$1, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* LESS$1 )
{
	label$1108:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$1111;
	{
		goto label$1109;
	}
	label$1111:;
	label$1110:;
	int32 DEPTH$1;
	DEPTH$1 = 0;
	int32 M$1;
	M$1 = N$1;
	label$1112:;
	if( (int64)M$1 <= 1ll) goto label$1113;
	{
		M$1 = (int32)((int64)M$1 / 2ll);
		DEPTH$1 = (int32)((int64)DEPTH$1 + 1ll);
	}
	goto label$1112;
	label$1113:;
	DEPTH$1 = (int32)((int64)DEPTH$1 << (1ll & 63ll));
	_Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiiRS1_( A$1, 0, (int32)((int64)N$1 + -1ll), DEPTH$1, LESS$1 );
	label$1109:;
}

static void _Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, int32 DEPTH$1, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* LESS$1 )
{
	label$1114:;
	label$1116:;
	if( (((int64)HI$1 - (int64)LO$1) + 1ll) <= 16ll) goto label$1117;
	{
		if( (int64)DEPTH$1 != 0ll) goto label$1119;
		{
			_Z10SortHeapByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiRS1_( A$1, LO$1, HI$1, LESS$1 );
			goto label$1115;
		}
		label$1119:;
		label$1118:;
		DEPTH$1 = (int32)((int64)DEPTH$1 + -1ll);
		int32 P$2;
		int32 vr$8 = _Z15SortPartitionByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiRS1_( A$1, LO$1, HI$1, LESS$1 );
		P$2 = vr$8;
		if( ((int64)P$2 - (int64)LO$1) >= ((int64)HI$1 - (int64)P$2)) goto label$1121;
		{
			_Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiiRS1_( A$1, LO$1, (int32)((int64)P$2 + -1ll), DEPTH$1, LESS$1 );
			LO$1 = (int32)((int64)P$2 + 1ll);
		}
		goto label$1120;
		label$1121:;
		{
			_Z11SortIntroByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiiRS1_( A$1, (int32)((int64)P$2 + 1ll), HI$1, DEPTH$1, LESS$1 );
			HI$1 = (int32)((int64)P$2 + -1ll);
		}
		label$1120:;
	}
	goto label$1116;
	label$1117:;
	_Z15SortInsertionByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiRS1_( A$1, LO$1, HI$1, LESS$1 );
	label$1115:;
}

static void _Z10SortHeapByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* LESS$1 )
{
	label$1122:;
	int32 N$1;
	N$1 = (int32)(((int64)HI$1 - (int64)LO$1) + 1ll);
	if( (int64)N$1 >= 2ll) goto label$1125;
	{
		goto label$1123;
	}
	label$1125:;
	label$1124:;
	{
		int32 I$2;
		I$2 = (int32)(((int64)N$1 / 2ll) + -1ll);
		goto label$1126;
		label$1129:;
		{
			_Z14SortSiftDownByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiiRS1_( A$1, LO$1, N$1, I$2, LESS$1 );
		}
		label$1127:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$1126:;
		if( (int64)I$2 >= 0ll) goto label$1129;
		label$1128:;
	}
	{
		int32 I$2;
		I$2 = (int32)((int64)N$1 + -1ll);
		goto label$1130;
		label$1133:;
		{
			{
				int32 TMP$193$4;
				TMP$193$4 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)I$2) << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)I$2) << (2ll & 63ll))) = TMP$193$4;
			}
			_Z14SortSiftDownByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiiRS1_( A$1, LO$1, I$2, 0, LESS$1 );
		}
		label$1131:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$1130:;
		if( (int64)I$2 >= 1ll) goto label$1133;
		label$1132:;
	}
	label$1123:;
}

static int32 _Z15SortPartitionByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* LESS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$1134:;
	int32 MID_$1;
	MID_$1 = (int32)((int64)LO$1 + (((int64)HI$1 - (int64)LO$1) / 2ll));
	boolean SW$1;
	boolean vr$16 = _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
	SW$1 = vr$16;
	if( SW$1 == (boolean)0ll) goto label$1137;
	{
		{
			int32 TMP$194$3;
			TMP$194$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = TMP$194$3;
		}
	}
	label$1137:;
	label$1136:;
	boolean vr$41 = _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
	SW$1 = vr$41;
	if( SW$1 == (boolean)0ll) goto label$1139;
	{
		{
			int32 TMP$195$3;
			TMP$195$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = TMP$195$3;
		}
	}
	label$1139:;
	label$1138:;
	boolean vr$66 = _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) );
	SW$1 = vr$66;
	if( SW$1 == (boolean)0ll) goto label$1141;
	{
		{
			int32 TMP$196$3;
			TMP$196$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)HI$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) = TMP$196$3;
		}
	}
	label$1141:;
	label$1140:;
	{
		int32 TMP$197$2;
		TMP$197$2 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) = TMP$197$2;
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)HI$1 + 1ll);
	label$1142:;
	{
		label$1145:;
		{
			I$1 = (int32)((int64)I$1 + 1ll);
			if( (int64)I$1 <= (int64)HI$1) goto label$1149;
			{
				goto label$1146;
			}
			label$1149:;
			label$1148:;
			boolean LT$3;
			boolean vr$115 = _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)I$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
			LT$3 = vr$115;
			if( LT$3 != (boolean)0ll) goto label$1151;
			{
				goto label$1146;
			}
			label$1151:;
			label$1150:;
		}
		label$1147:;
		goto label$1145;
		label$1146:;
		label$1152:;
		{
			J$1 = (int32)((int64)J$1 + -1ll);
			if( (int64)J$1 > (int64)LO$1) goto label$1156;
			{
				goto label$1153;
			}
			label$1156:;
			label$1155:;
			boolean GT$3;
			boolean vr$129 = _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) );
			GT$3 = vr$129;
			if( GT$3 != (boolean)0ll) goto label$1158;
			{
				goto label$1153;
			}
			label$1158:;
			label$1157:;
		}
		label$1154:;
		goto label$1152;
		label$1153:;
		if( (int64)I$1 < (int64)J$1) goto label$1160;
		{
			goto label$1143;
		}
		label$1160:;
		label$1159:;
		{
			int32 TMP$198$3;
			TMP$198$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)I$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)I$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) = TMP$198$3;
		}
	}
	label$1144:;
	goto label$1142;
	label$1143:;
	{
		int32 TMP$199$2;
		TMP$199$2 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)LO$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll)));
		*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) = TMP$199$2;
	}
	fb$result$1 = J$1;
	goto label$1135;
	label$1135:;
	return fb$result$1;
}

static void _Z15SortInsertionByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* LESS$1 )
{
	label$1161:;
	{
		int32 I$2;
		I$2 = (int32)((int64)LO$1 + 1ll);
		int32 TMP$200$2;
		TMP$200$2 = HI$1;
		goto label$1163;
		label$1166:;
		{
			int32 J$3;
			J$3 = I$2;
			label$1167:;
			{
				if( (int64)J$3 > (int64)LO$1) goto label$1171;
				{
					goto label$1168;
				}
				label$1171:;
				label$1170:;
				boolean LT$4;
				boolean vr$14 = _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))), (int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll) );
				LT$4 = vr$14;
				if( LT$4 != (boolean)0ll) goto label$1173;
				{
					goto label$1168;
				}
				label$1173:;
				label$1172:;
				{
					int32 TMP$201$5;
					TMP$201$5 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll)));
					*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) = *(int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll);
					*(int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll) = TMP$201$5;
				}
				J$3 = (int32)((int64)J$3 + -1ll);
			}
			label$1169:;
			goto label$1167;
			label$1168:;
		}
		label$1164:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$1163:;
		if( (int64)I$2 <= (int64)TMP$200$2) goto label$1166;
		label$1165:;
	}
	label$1162:;
}

static void _Z14SortSiftDownByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiEiiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 N$1, int32 ROOT$1, struct $25LD2939E50C2FFBF23_Lt_00BEIiE* LESS$1 )
{
	label$1174:;
	label$1176:;
	{
		int32 CHILD$2;
		CHILD$2 = (int32)(((int64)ROOT$1 << (1ll & 63ll)) + 1ll);
		if( (int64)CHILD$2 < (int64)N$1) goto label$1180;
		{
			goto label$1177;
		}
		label$1180:;
		label$1179:;
		if( ((int64)CHILD$2 + 1ll) >= (int64)N$1) goto label$1182;
		{
			boolean RIGHTISBIGGER$3;
			boolean vr$22 = _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))), (int32*)((uint8*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) + 4ll) );
			RIGHTISBIGGER$3 = vr$22;
			if( RIGHTISBIGGER$3 == (boolean)0ll) goto label$1184;
			{
				CHILD$2 = (int32)((int64)CHILD$2 + 1ll);
			}
			label$1184:;
			label$1183:;
		}
		label$1182:;
		label$1181:;
		boolean CHILDISBIGGER$2;
		boolean vr$38 = _ZN25LD2939E50C2FFBF23_Lt_00BEIiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll))), (int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) );
		CHILDISBIGGER$2 = vr$38;
		if( CHILDISBIGGER$2 != (boolean)0ll) goto label$1186;
		{
			goto label$1177;
		}
		label$1186:;
		label$1185:;
		{
			int32 TMP$202$3;
			TMP$202$3 = *(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) = TMP$202$3;
		}
		ROOT$1 = CHILD$2;
	}
	label$1178:;
	goto label$1176;
	label$1177:;
	label$1175:;
}

boolean LD2939E50C2FFBF23_LT_00CC( int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1195:;
	fb$result$1 = (boolean)0ll;
	goto label$1196;
	label$1196:;
	return fb$result$1;
}

boolean LD2939E50C2FFBF23_LT_00D0( int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1205:;
	fb$result$1 = (boolean)1ll;
	goto label$1206;
	label$1206:;
	return fb$result$1;
}

static void _Z10StableSortIiER5ArrayIiE( struct $5ArrayIiE* A$1 )
{
	label$1233:;
	typedef boolean (*_Z7tmp$211RiS_)( int32*, int32* );
	_Z7tmp$211RiS_ LESS$1;
	LESS$1 = (_Z7tmp$211RiS_)&L3C22B1CEA777A486_LT_00D4;
	_Z12StableSortByIiPFbRiRiEER5ArrayIiERS3_( A$1, (tmp$50*)&LESS$1 );
	label$1234:;
}

boolean L3C22B1CEA777A486_LT_00D4( int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1235:;
	fb$result$1 = (boolean)((int64)-((int64)*X$1 < (int64)*Y$1) != 0ll);
	goto label$1236;
	label$1236:;
	return fb$result$1;
}

static void _Z12StableSortByIiPFbRiRiEER5ArrayIiERS3_( struct $5ArrayIiE* A$1, tmp$50* LESS$1 )
{
	label$1237:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$1240;
	{
		goto label$1238;
	}
	label$1240:;
	label$1239:;
	int32 RUNW$1;
	RUNW$1 = 16;
	int32 S$1;
	S$1 = 0;
	label$1241:;
	if( (int64)S$1 >= (int64)N$1) goto label$1242;
	{
		int32 E$2;
		E$2 = (int32)(((int64)S$1 + (int64)RUNW$1) + -1ll);
		if( (int64)E$2 <= ((int64)N$1 + -1ll)) goto label$1244;
		{
			E$2 = (int32)((int64)N$1 + -1ll);
		}
		label$1244:;
		label$1243:;
		_Z15SortInsertionByIiPFbRiRiEER5ArrayIiEiiRS3_( A$1, S$1, E$2, LESS$1 );
		S$1 = (int32)((int64)S$1 + (int64)RUNW$1);
	}
	goto label$1241;
	label$1242:;
	if( (int64)RUNW$1 < (int64)N$1) goto label$1246;
	{
		goto label$1238;
	}
	label$1246:;
	label$1245:;
	struct $10FBARRAY1$1IiE {
		int32* DATA;
		int32* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $10FBARRAY1$1IiE ) == 72 );
	struct $10FBARRAY1$1IiE BUF$1;
	*(int32**)&BUF$1 = (int32*)0ull;
	*(int32**)((uint8*)&BUF$1 + 8ll) = (int32*)0ull;
	*(int64*)((uint8*)&BUF$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&BUF$1 + 24ll) = 4ll;
	*(int64*)((uint8*)&BUF$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&BUF$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&BUF$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&BUF$1, 4ull, -1, 0, 1ull, 0ll, (int64)N$1 + -1ll );
	label$1247:;
	if( (int64)RUNW$1 >= (int64)N$1) goto label$1248;
	{
		int32 LO$2;
		LO$2 = 0;
		label$1249:;
		if( (int64)LO$2 >= ((int64)N$1 - (int64)RUNW$1)) goto label$1250;
		{
			int32 MID_$3;
			MID_$3 = (int32)(((int64)LO$2 + (int64)RUNW$1) + -1ll);
			int32 HI$3;
			HI$3 = (int32)(((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll))) + -1ll);
			if( (int64)HI$3 <= ((int64)N$1 + -1ll)) goto label$1252;
			{
				HI$3 = (int32)((int64)N$1 + -1ll);
			}
			label$1252:;
			label$1251:;
			_Z11SortMergeByIiPFbRiRiEER5ArrayIiER7FBARRAYIiEiiiRS3_( A$1, (struct $7FBARRAYIiE*)&BUF$1, LO$2, MID_$3, HI$3, LESS$1 );
			LO$2 = (int32)((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll)));
		}
		goto label$1249;
		label$1250:;
		RUNW$1 = (int32)((int64)RUNW$1 << (1ll & 63ll));
	}
	goto label$1247;
	label$1248:;
	fb_ArrayErase( (struct $7FBARRAYIvE*)&BUF$1 );
	label$1238:;
}

static void _Z11SortMergeByIiPFbRiRiEER5ArrayIiER7FBARRAYIiEiiiRS3_( struct $5ArrayIiE* A$1, struct $7FBARRAYIiE* BUF$1, int32 LO$1, int32 MID_$1, int32 HI$1, tmp$50* LESS$1 )
{
	int64 TMP$215$1;
	label$1253:;
	{
		int32 X$2;
		X$2 = LO$1;
		int32 TMP$213$2;
		TMP$213$2 = MID_$1;
		goto label$1255;
		label$1258:;
		{
			{
				int32 TMP$214$4;
				TMP$214$4 = *(int32*)(((int64)X$2 << (2ll & 63ll)) + *(int64*)BUF$1);
				*(int32*)(((int64)X$2 << (2ll & 63ll)) + *(int64*)BUF$1) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)X$2 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)X$2 << (2ll & 63ll))) = TMP$214$4;
			}
		}
		label$1256:;
		X$2 = (int32)((int64)X$2 + 1ll);
		label$1255:;
		if( (int64)X$2 <= (int64)TMP$213$2) goto label$1258;
		label$1257:;
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)MID_$1 + 1ll);
	int32 K$1;
	K$1 = LO$1;
	label$1259:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1261;
	TMP$215$1 = (int64)-((int64)J$1 <= (int64)HI$1);
	goto label$1266;
	label$1261:;
	TMP$215$1 = 0ll;
	label$1266:;
	if( TMP$215$1 == 0ll) goto label$1260;
	{
		boolean TAKERIGHT$2;
		boolean vr$38 = (*LESS$1)( (int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))), (int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1) );
		TAKERIGHT$2 = vr$38;
		if( TAKERIGHT$2 == (boolean)0ll) goto label$1263;
		{
			{
				int32 TMP$216$4;
				TMP$216$4 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) = TMP$216$4;
			}
			J$1 = (int32)((int64)J$1 + 1ll);
		}
		goto label$1262;
		label$1263:;
		{
			{
				int32 TMP$217$4;
				TMP$217$4 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll))) = *(int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1);
				*(int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1) = TMP$217$4;
			}
			I$1 = (int32)((int64)I$1 + 1ll);
		}
		label$1262:;
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1259;
	label$1260:;
	label$1264:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1265;
	{
		{
			int32 TMP$218$3;
			TMP$218$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll))) = *(int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1);
			*(int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1) = TMP$218$3;
		}
		I$1 = (int32)((int64)I$1 + 1ll);
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1264;
	label$1265:;
	label$1254:;
}

static void _Z10StableSortI3RECER5ArrayI3RECE( struct $5ArrayI3RECE* A$1 )
{
	label$1289:;
	typedef boolean (*_Z7tmp$222R3RECS0_)( struct $3REC*, struct $3REC* );
	_Z7tmp$222R3RECS0_ LESS$1;
	LESS$1 = (_Z7tmp$222R3RECS0_)&L3C22B1CEA777A486_LT_00DF;
	_Z12StableSortByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( A$1, (tmp$149*)&LESS$1 );
	label$1290:;
}

boolean L3C22B1CEA777A486_LT_00DF( struct $3REC* X$1, struct $3REC* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1291:;
	boolean vr$1 = _ZltR3RECS0_( X$1, Y$1 );
	fb$result$1 = vr$1;
	goto label$1292;
	label$1292:;
	return fb$result$1;
}

static void _Z12StableSortByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( struct $5ArrayI3RECE* A$1, tmp$149* LESS$1 )
{
	label$1293:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$1296;
	{
		goto label$1294;
	}
	label$1296:;
	label$1295:;
	int32 RUNW$1;
	RUNW$1 = 16;
	int32 S$1;
	S$1 = 0;
	label$1297:;
	if( (int64)S$1 >= (int64)N$1) goto label$1298;
	{
		int32 E$2;
		E$2 = (int32)(((int64)S$1 + (int64)RUNW$1) + -1ll);
		if( (int64)E$2 <= ((int64)N$1 + -1ll)) goto label$1300;
		{
			E$2 = (int32)((int64)N$1 + -1ll);
		}
		label$1300:;
		label$1299:;
		_Z15SortInsertionByI3RECPFbR3RECR3RECEER5ArrayI3RECEiiRS6_( A$1, S$1, E$2, LESS$1 );
		S$1 = (int32)((int64)S$1 + (int64)RUNW$1);
	}
	goto label$1297;
	label$1298:;
	if( (int64)RUNW$1 < (int64)N$1) goto label$1302;
	{
		goto label$1294;
	}
	label$1302:;
	label$1301:;
	struct $10FBARRAY1$2I3RECE {
		struct $3REC* DATA;
		struct $3REC* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $10FBARRAY1$2I3RECE ) == 72 );
	struct $10FBARRAY1$2I3RECE BUF$1;
	*(struct $3REC**)&BUF$1 = (struct $3REC*)0ull;
	*(struct $3REC**)((uint8*)&BUF$1 + 8ll) = (struct $3REC*)0ull;
	*(int64*)((uint8*)&BUF$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&BUF$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&BUF$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&BUF$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&BUF$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&BUF$1, 8ull, -1, 0, 1ull, 0ll, (int64)N$1 + -1ll );
	label$1303:;
	if( (int64)RUNW$1 >= (int64)N$1) goto label$1304;
	{
		int32 LO$2;
		LO$2 = 0;
		label$1305:;
		if( (int64)LO$2 >= ((int64)N$1 - (int64)RUNW$1)) goto label$1306;
		{
			int32 MID_$3;
			MID_$3 = (int32)(((int64)LO$2 + (int64)RUNW$1) + -1ll);
			int32 HI$3;
			HI$3 = (int32)(((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll))) + -1ll);
			if( (int64)HI$3 <= ((int64)N$1 + -1ll)) goto label$1308;
			{
				HI$3 = (int32)((int64)N$1 + -1ll);
			}
			label$1308:;
			label$1307:;
			_Z11SortMergeByI3RECPFbR3RECR3RECEER5ArrayI3RECER7FBARRAYIS0_EiiiRS6_( A$1, (struct $7FBARRAYI3RECE*)&BUF$1, LO$2, MID_$3, HI$3, LESS$1 );
			LO$2 = (int32)((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll)));
		}
		goto label$1305;
		label$1306:;
		RUNW$1 = (int32)((int64)RUNW$1 << (1ll & 63ll));
	}
	goto label$1303;
	label$1304:;
	fb_ArrayErase( (struct $7FBARRAYIvE*)&BUF$1 );
	label$1294:;
}

static void _Z11SortMergeByI3RECPFbR3RECR3RECEER5ArrayI3RECER7FBARRAYIS0_EiiiRS6_( struct $5ArrayI3RECE* A$1, struct $7FBARRAYI3RECE* BUF$1, int32 LO$1, int32 MID_$1, int32 HI$1, tmp$149* LESS$1 )
{
	int64 TMP$225$1;
	label$1309:;
	{
		int32 X$2;
		X$2 = LO$1;
		int32 TMP$224$2;
		TMP$224$2 = MID_$1;
		goto label$1311;
		label$1314:;
		{
			{
				fb_MemSwap( (void*)(((int64)X$2 << (3ll & 63ll)) + *(int64*)BUF$1), (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)X$2 << (3ll & 63ll))), 8ll );
			}
		}
		label$1312:;
		X$2 = (int32)((int64)X$2 + 1ll);
		label$1311:;
		if( (int64)X$2 <= (int64)TMP$224$2) goto label$1314;
		label$1313:;
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)MID_$1 + 1ll);
	int32 K$1;
	K$1 = LO$1;
	label$1315:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1317;
	TMP$225$1 = (int64)-((int64)J$1 <= (int64)HI$1);
	goto label$1322;
	label$1317:;
	TMP$225$1 = 0ll;
	label$1322:;
	if( TMP$225$1 == 0ll) goto label$1316;
	{
		boolean TAKERIGHT$2;
		boolean vr$31 = (*LESS$1)( (struct $3REC*)((uint8*)*(struct $3REC**)A$1 + ((int64)J$1 << (3ll & 63ll))), (struct $3REC*)(((int64)I$1 << (3ll & 63ll)) + *(int64*)BUF$1) );
		TAKERIGHT$2 = vr$31;
		if( TAKERIGHT$2 == (boolean)0ll) goto label$1319;
		{
			{
				fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)K$1 << (3ll & 63ll))), (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)J$1 << (3ll & 63ll))), 8ll );
			}
			J$1 = (int32)((int64)J$1 + 1ll);
		}
		goto label$1318;
		label$1319:;
		{
			{
				fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)K$1 << (3ll & 63ll))), (void*)(((int64)I$1 << (3ll & 63ll)) + *(int64*)BUF$1), 8ll );
			}
			I$1 = (int32)((int64)I$1 + 1ll);
		}
		label$1318:;
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1315;
	label$1316:;
	label$1320:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1321;
	{
		{
			fb_MemSwap( (void*)((uint8*)*(struct $3REC**)A$1 + ((int64)K$1 << (3ll & 63ll))), (void*)(((int64)I$1 << (3ll & 63ll)) + *(int64*)BUF$1), 8ll );
		}
		I$1 = (int32)((int64)I$1 + 1ll);
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1320;
	label$1321:;
	label$1310:;
}

boolean LD2939E50C2FFBF23_LT_00E3( struct $3REC* X$1, struct $3REC* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1345:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)X$1 < (int64)*(int32*)Y$1) != 0ll);
	goto label$1346;
	label$1346:;
	return fb$result$1;
}

static boolean _ZN25LD2939E50C2FFBF23_Lt_00E8IiE10__FBINVOKEERiS2_( struct $25LD2939E50C2FFBF23_Lt_00E8IiE* THIS$1, int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1355:;
	int32* COMPARISONS$1;
	COMPARISONS$1 = *(int32**)THIS$1;
	*COMPARISONS$1 = (int32)((int64)*COMPARISONS$1 + 1ll);
	fb$result$1 = (boolean)((int64)-((int64)*X$1 < (int64)*Y$1) != 0ll);
	goto label$1356;
	label$1356:;
	return fb$result$1;
}

static void _Z12StableSortByIi25LD2939E50C2FFBF23_Lt_00E8IiEER5ArrayIiERS1_( struct $5ArrayIiE* A$1, struct $25LD2939E50C2FFBF23_Lt_00E8IiE* LESS$1 )
{
	label$1357:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$1360;
	{
		goto label$1358;
	}
	label$1360:;
	label$1359:;
	int32 RUNW$1;
	RUNW$1 = 16;
	int32 S$1;
	S$1 = 0;
	label$1361:;
	if( (int64)S$1 >= (int64)N$1) goto label$1362;
	{
		int32 E$2;
		E$2 = (int32)(((int64)S$1 + (int64)RUNW$1) + -1ll);
		if( (int64)E$2 <= ((int64)N$1 + -1ll)) goto label$1364;
		{
			E$2 = (int32)((int64)N$1 + -1ll);
		}
		label$1364:;
		label$1363:;
		_Z15SortInsertionByIi25LD2939E50C2FFBF23_Lt_00E8IiEER5ArrayIiEiiRS1_( A$1, S$1, E$2, LESS$1 );
		S$1 = (int32)((int64)S$1 + (int64)RUNW$1);
	}
	goto label$1361;
	label$1362:;
	if( (int64)RUNW$1 < (int64)N$1) goto label$1366;
	{
		goto label$1358;
	}
	label$1366:;
	label$1365:;
	struct $10FBARRAY1$3IiE {
		int32* DATA;
		int32* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $10FBARRAY1$3IiE ) == 72 );
	struct $10FBARRAY1$3IiE BUF$1;
	*(int32**)&BUF$1 = (int32*)0ull;
	*(int32**)((uint8*)&BUF$1 + 8ll) = (int32*)0ull;
	*(int64*)((uint8*)&BUF$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&BUF$1 + 24ll) = 4ll;
	*(int64*)((uint8*)&BUF$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&BUF$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&BUF$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&BUF$1, 4ull, -1, 0, 1ull, 0ll, (int64)N$1 + -1ll );
	label$1367:;
	if( (int64)RUNW$1 >= (int64)N$1) goto label$1368;
	{
		int32 LO$2;
		LO$2 = 0;
		label$1369:;
		if( (int64)LO$2 >= ((int64)N$1 - (int64)RUNW$1)) goto label$1370;
		{
			int32 MID_$3;
			MID_$3 = (int32)(((int64)LO$2 + (int64)RUNW$1) + -1ll);
			int32 HI$3;
			HI$3 = (int32)(((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll))) + -1ll);
			if( (int64)HI$3 <= ((int64)N$1 + -1ll)) goto label$1372;
			{
				HI$3 = (int32)((int64)N$1 + -1ll);
			}
			label$1372:;
			label$1371:;
			_Z11SortMergeByIi25LD2939E50C2FFBF23_Lt_00E8IiEER5ArrayIiER7FBARRAYIiEiiiRS1_( A$1, (struct $7FBARRAYIiE*)&BUF$1, LO$2, MID_$3, HI$3, LESS$1 );
			LO$2 = (int32)((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll)));
		}
		goto label$1369;
		label$1370:;
		RUNW$1 = (int32)((int64)RUNW$1 << (1ll & 63ll));
	}
	goto label$1367;
	label$1368:;
	fb_ArrayErase( (struct $7FBARRAYIvE*)&BUF$1 );
	label$1358:;
}

static void _Z15SortInsertionByIi25LD2939E50C2FFBF23_Lt_00E8IiEER5ArrayIiEiiRS1_( struct $5ArrayIiE* A$1, int32 LO$1, int32 HI$1, struct $25LD2939E50C2FFBF23_Lt_00E8IiE* LESS$1 )
{
	label$1373:;
	{
		int32 I$2;
		I$2 = (int32)((int64)LO$1 + 1ll);
		int32 TMP$234$2;
		TMP$234$2 = HI$1;
		goto label$1375;
		label$1378:;
		{
			int32 J$3;
			J$3 = I$2;
			label$1379:;
			{
				if( (int64)J$3 > (int64)LO$1) goto label$1383;
				{
					goto label$1380;
				}
				label$1383:;
				label$1382:;
				boolean LT$4;
				boolean vr$14 = _ZN25LD2939E50C2FFBF23_Lt_00E8IiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))), (int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll) );
				LT$4 = vr$14;
				if( LT$4 != (boolean)0ll) goto label$1385;
				{
					goto label$1380;
				}
				label$1385:;
				label$1384:;
				{
					int32 TMP$235$5;
					TMP$235$5 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll)));
					*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) = *(int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll);
					*(int32*)((uint8*)((uint8*)*(int32**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll) = TMP$235$5;
				}
				J$3 = (int32)((int64)J$3 + -1ll);
			}
			label$1381:;
			goto label$1379;
			label$1380:;
		}
		label$1376:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$1375:;
		if( (int64)I$2 <= (int64)TMP$234$2) goto label$1378;
		label$1377:;
	}
	label$1374:;
}

static void _Z11SortMergeByIi25LD2939E50C2FFBF23_Lt_00E8IiEER5ArrayIiER7FBARRAYIiEiiiRS1_( struct $5ArrayIiE* A$1, struct $7FBARRAYIiE* BUF$1, int32 LO$1, int32 MID_$1, int32 HI$1, struct $25LD2939E50C2FFBF23_Lt_00E8IiE* LESS$1 )
{
	int64 TMP$238$1;
	label$1386:;
	{
		int32 X$2;
		X$2 = LO$1;
		int32 TMP$236$2;
		TMP$236$2 = MID_$1;
		goto label$1388;
		label$1391:;
		{
			{
				int32 TMP$237$4;
				TMP$237$4 = *(int32*)(((int64)X$2 << (2ll & 63ll)) + *(int64*)BUF$1);
				*(int32*)(((int64)X$2 << (2ll & 63ll)) + *(int64*)BUF$1) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)X$2 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)X$2 << (2ll & 63ll))) = TMP$237$4;
			}
		}
		label$1389:;
		X$2 = (int32)((int64)X$2 + 1ll);
		label$1388:;
		if( (int64)X$2 <= (int64)TMP$236$2) goto label$1391;
		label$1390:;
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)MID_$1 + 1ll);
	int32 K$1;
	K$1 = LO$1;
	label$1392:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1394;
	TMP$238$1 = (int64)-((int64)J$1 <= (int64)HI$1);
	goto label$1399;
	label$1394:;
	TMP$238$1 = 0ll;
	label$1399:;
	if( TMP$238$1 == 0ll) goto label$1393;
	{
		boolean TAKERIGHT$2;
		boolean vr$38 = _ZN25LD2939E50C2FFBF23_Lt_00E8IiE10__FBINVOKEERiS2_( LESS$1, (int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))), (int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1) );
		TAKERIGHT$2 = vr$38;
		if( TAKERIGHT$2 == (boolean)0ll) goto label$1396;
		{
			{
				int32 TMP$239$4;
				TMP$239$4 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll))) = *(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)J$1 << (2ll & 63ll))) = TMP$239$4;
			}
			J$1 = (int32)((int64)J$1 + 1ll);
		}
		goto label$1395;
		label$1396:;
		{
			{
				int32 TMP$240$4;
				TMP$240$4 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll)));
				*(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll))) = *(int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1);
				*(int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1) = TMP$240$4;
			}
			I$1 = (int32)((int64)I$1 + 1ll);
		}
		label$1395:;
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1392;
	label$1393:;
	label$1397:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1398;
	{
		{
			int32 TMP$241$3;
			TMP$241$3 = *(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll)));
			*(int32*)((uint8*)*(int32**)A$1 + ((int64)K$1 << (2ll & 63ll))) = *(int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1);
			*(int32*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1) = TMP$241$3;
		}
		I$1 = (int32)((int64)I$1 + 1ll);
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1397;
	label$1398:;
	label$1387:;
}

static void _Z10StableSortI8FBSTRINGER5ArrayI8FBSTRINGE( struct $5ArrayI8FBSTRINGE* A$1 )
{
	label$1418:;
	typedef boolean (*_Z7tmp$249R8FBSTRINGS0_)( FBSTRING*, FBSTRING* );
	_Z7tmp$249R8FBSTRINGS0_ LESS$1;
	LESS$1 = (_Z7tmp$249R8FBSTRINGS0_)&L3C22B1CEA777A486_LT_00FA;
	_Z12StableSortByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGERS6_( A$1, (tmp$129*)&LESS$1 );
	label$1419:;
}

boolean L3C22B1CEA777A486_LT_00FA( FBSTRING* X$1, FBSTRING* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1420:;
	int32 vr$1 = fb_StrCompare( (void*)X$1, -1ll, (void*)Y$1, -1ll );
	fb$result$1 = (boolean)((int64)-((int64)vr$1 < 0ll) != 0ll);
	goto label$1421;
	label$1421:;
	return fb$result$1;
}

static void _Z12StableSortByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGERS6_( struct $5ArrayI8FBSTRINGE* A$1, tmp$129* LESS$1 )
{
	label$1422:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$1425;
	{
		goto label$1423;
	}
	label$1425:;
	label$1424:;
	int32 RUNW$1;
	RUNW$1 = 16;
	int32 S$1;
	S$1 = 0;
	label$1426:;
	if( (int64)S$1 >= (int64)N$1) goto label$1427;
	{
		int32 E$2;
		E$2 = (int32)(((int64)S$1 + (int64)RUNW$1) + -1ll);
		if( (int64)E$2 <= ((int64)N$1 + -1ll)) goto label$1429;
		{
			E$2 = (int32)((int64)N$1 + -1ll);
		}
		label$1429:;
		label$1428:;
		_Z15SortInsertionByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGEiiRS6_( A$1, S$1, E$2, LESS$1 );
		S$1 = (int32)((int64)S$1 + (int64)RUNW$1);
	}
	goto label$1426;
	label$1427:;
	if( (int64)RUNW$1 < (int64)N$1) goto label$1431;
	{
		goto label$1423;
	}
	label$1431:;
	label$1430:;
	struct $10FBARRAY1$4I8FBSTRINGE {
		FBSTRING* DATA;
		FBSTRING* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $10FBARRAY1$4I8FBSTRINGE ) == 72 );
	struct $10FBARRAY1$4I8FBSTRINGE BUF$1;
	*(FBSTRING**)&BUF$1 = (FBSTRING*)0ull;
	*(FBSTRING**)((uint8*)&BUF$1 + 8ll) = (FBSTRING*)0ull;
	*(int64*)((uint8*)&BUF$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&BUF$1 + 24ll) = 24ll;
	*(int64*)((uint8*)&BUF$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&BUF$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&BUF$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&BUF$1, 24ull, -1, -1, 1ull, 0ll, (int64)N$1 + -1ll );
	label$1432:;
	if( (int64)RUNW$1 >= (int64)N$1) goto label$1433;
	{
		int32 LO$2;
		LO$2 = 0;
		label$1434:;
		if( (int64)LO$2 >= ((int64)N$1 - (int64)RUNW$1)) goto label$1435;
		{
			int32 MID_$3;
			MID_$3 = (int32)(((int64)LO$2 + (int64)RUNW$1) + -1ll);
			int32 HI$3;
			HI$3 = (int32)(((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll))) + -1ll);
			if( (int64)HI$3 <= ((int64)N$1 + -1ll)) goto label$1437;
			{
				HI$3 = (int32)((int64)N$1 + -1ll);
			}
			label$1437:;
			label$1436:;
			_Z11SortMergeByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGER7FBARRAYIS0_EiiiRS6_( A$1, (struct $7FBARRAYI8FBSTRINGE*)&BUF$1, LO$2, MID_$3, HI$3, LESS$1 );
			LO$2 = (int32)((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll)));
		}
		goto label$1434;
		label$1435:;
		RUNW$1 = (int32)((int64)RUNW$1 << (1ll & 63ll));
	}
	goto label$1432;
	label$1433:;
	fb_ArrayStrErase( (struct $7FBARRAYIvE*)&BUF$1 );
	label$1423:;
}

static void _Z11SortMergeByI8FBSTRINGPFbR8FBSTRINGR8FBSTRINGEER5ArrayI8FBSTRINGER7FBARRAYIS0_EiiiRS6_( struct $5ArrayI8FBSTRINGE* A$1, struct $7FBARRAYI8FBSTRINGE* BUF$1, int32 LO$1, int32 MID_$1, int32 HI$1, tmp$129* LESS$1 )
{
	int64 TMP$252$1;
	label$1438:;
	{
		int32 X$2;
		X$2 = LO$1;
		int32 TMP$251$2;
		TMP$251$2 = MID_$1;
		goto label$1440;
		label$1443:;
		{
			{
				fb_StrSwap( (void*)(((int64)X$2 * 24ll) + *(int64*)BUF$1), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)X$2 * 24ll)), -1ll, 0 );
			}
		}
		label$1441:;
		X$2 = (int32)((int64)X$2 + 1ll);
		label$1440:;
		if( (int64)X$2 <= (int64)TMP$251$2) goto label$1443;
		label$1442:;
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)MID_$1 + 1ll);
	int32 K$1;
	K$1 = LO$1;
	label$1444:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1446;
	TMP$252$1 = (int64)-((int64)J$1 <= (int64)HI$1);
	goto label$1451;
	label$1446:;
	TMP$252$1 = 0ll;
	label$1451:;
	if( TMP$252$1 == 0ll) goto label$1445;
	{
		boolean TAKERIGHT$2;
		boolean vr$31 = (*LESS$1)( (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)J$1 * 24ll)), (FBSTRING*)(((int64)I$1 * 24ll) + *(int64*)BUF$1) );
		TAKERIGHT$2 = vr$31;
		if( TAKERIGHT$2 == (boolean)0ll) goto label$1448;
		{
			{
				fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)K$1 * 24ll)), -1ll, 0, (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)J$1 * 24ll)), -1ll, 0 );
			}
			J$1 = (int32)((int64)J$1 + 1ll);
		}
		goto label$1447;
		label$1448:;
		{
			{
				fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)K$1 * 24ll)), -1ll, 0, (void*)(((int64)I$1 * 24ll) + *(int64*)BUF$1), -1ll, 0 );
			}
			I$1 = (int32)((int64)I$1 + 1ll);
		}
		label$1447:;
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1444;
	label$1445:;
	label$1449:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1450;
	{
		{
			fb_StrSwap( (void*)((uint8*)*(FBSTRING**)A$1 + ((int64)K$1 * 24ll)), -1ll, 0, (void*)(((int64)I$1 * 24ll) + *(int64*)BUF$1), -1ll, 0 );
		}
		I$1 = (int32)((int64)I$1 + 1ll);
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1449;
	label$1450:;
	label$1439:;
}

static boolean _ZN13ArrayIteratorI7COUNTEDE7ISVALIDEv( struct $13ArrayIteratorI7COUNTEDE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1496:;
	struct $5ArrayI7COUNTEDE* A$1;
	A$1 = *(struct $5ArrayI7COUNTEDE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$1497;
	label$1497:;
	return fb$result$1;
}

static struct $7COUNTED* _ZN13ArrayIteratorI7COUNTEDE5VALUEEv( struct $13ArrayIteratorI7COUNTEDE* THIS$1 )
{
	struct $7COUNTED* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1498:;
	struct $5ArrayI7COUNTEDE* A$1;
	A$1 = *(struct $5ArrayI7COUNTEDE**)THIS$1;
	fb$result$1 = (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) << (2ll & 63ll)));
	goto label$1499;
	label$1499:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorI7COUNTEDE8MOVENEXTEv( struct $13ArrayIteratorI7COUNTEDE* THIS$1 )
{
	label$1500:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$1501:;
}

static int32 _ZN5ArrayI7COUNTEDE5COUNTEv( struct $5ArrayI7COUNTEDE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$1502:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$1503;
	label$1503:;
	return fb$result$1;
}

static int32 _ZN5ArrayI7COUNTEDE8CAPACITYEv( struct $5ArrayI7COUNTEDE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$1504:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$1505;
	label$1505:;
	return fb$result$1;
}

static boolean _ZN5ArrayI7COUNTEDE7ISEMPTYEv( struct $5ArrayI7COUNTEDE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1506:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$1507;
	label$1507:;
	return fb$result$1;
}

static void _ZN5ArrayI7COUNTEDE7RESERVEEi( struct $5ArrayI7COUNTEDE* THIS$1, int32 N$1 )
{
	label$1508:;
	int32 vr$1 = _ZN5ArrayI7COUNTEDE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$1511;
	{
		goto label$1509;
	}
	label$1511:;
	label$1510:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayI7COUNTEDE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$1513;
	{
		CAP$1 = 8;
	}
	label$1513:;
	label$1512:;
	label$1514:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$1515;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$1514;
	label$1515:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 4ull, (void*)&_ZN7COUNTEDC1Ev, (void*)&_ZN7COUNTEDD1Ev, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$1509:;
}

static void _ZN5ArrayI7COUNTEDE6SHRINKEv( struct $5ArrayI7COUNTEDE* THIS$1 )
{
	label$1516:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$1519;
	{
		fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN7COUNTEDC1Ev, (void*)&_ZN7COUNTEDD1Ev );
		goto label$1517;
	}
	label$1519:;
	label$1518:;
	int32 vr$6 = _ZN5ArrayI7COUNTEDE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$1521;
	{
		goto label$1517;
	}
	label$1521:;
	label$1520:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 4ull, (void*)&_ZN7COUNTEDC1Ev, (void*)&_ZN7COUNTEDD1Ev, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$1517:;
}

static struct $7COUNTED* _ZN5ArrayI7COUNTEDEixEi( struct $5ArrayI7COUNTEDE* THIS$1, int32 I$1 )
{
	struct $7COUNTED* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1522:;
	fb$result$1 = (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)I$1 << (2ll & 63ll)));
	goto label$1523;
	label$1523:;
	return fb$result$1;
}

static struct $7COUNTED* _ZN5ArrayI7COUNTEDE2ATEi( struct $5ArrayI7COUNTEDE* THIS$1, int32 I$1 )
{
	struct $7COUNTED* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1524:;
	fb$result$1 = (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)I$1 << (2ll & 63ll)));
	goto label$1525;
	label$1525:;
	return fb$result$1;
}

static void _ZN5ArrayI7COUNTEDE4PUSHERS0_( struct $5ArrayI7COUNTEDE* THIS$1, struct $7COUNTED* V$1 )
{
	label$1526:;
	_ZN5ArrayI7COUNTEDE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	_ZN7COUNTEDaSERS_( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (2ll & 63ll))), V$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$1527:;
}

static struct $7COUNTED* _ZN5ArrayI7COUNTEDE3POPEv( struct $7COUNTED* tmp$266$1, struct $5ArrayI7COUNTEDE* THIS$1 )
{
	label$1528:;
	struct $7COUNTED R$1;
	_ZN7COUNTEDC1Ev( &R$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$1531;
	{
		_ZN7COUNTEDC1ERS_( tmp$266$1, &R$1 );
		_ZN7COUNTEDD1Ev( &R$1 );
		goto label$1529;
	}
	label$1531:;
	label$1530:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	_ZN7COUNTEDaSERS_( &R$1, (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (2ll & 63ll))) );
	_ZN7COUNTEDC1ERS_( tmp$266$1, &R$1 );
	_ZN7COUNTEDD1Ev( &R$1 );
	goto label$1529;
	_ZN7COUNTEDD1Ev( &R$1 );
	label$1529:;
	return tmp$266$1;
}

static void _ZN5ArrayI7COUNTEDE6INSERTEiRS0_( struct $5ArrayI7COUNTEDE* THIS$1, int32 I$1, struct $7COUNTED* V$1 )
{
	int64 TMP$267$1;
	label$1532:;
	if( (int64)I$1 < 0ll) goto label$1534;
	TMP$267$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$1541;
	label$1534:;
	TMP$267$1 = -1ll;
	label$1541:;
	if( TMP$267$1 == 0ll) goto label$1536;
	{
		goto label$1533;
	}
	label$1536:;
	label$1535:;
	struct $7COUNTED TMP$1;
	_ZN7COUNTEDC1ERS_( &TMP$1, V$1 );
	_ZN5ArrayI7COUNTEDE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$268$2;
		TMP$268$2 = (int32)((int64)I$1 + 1ll);
		goto label$1537;
		label$1540:;
		{
			_ZN7COUNTEDaSERS_( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)K$2 << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) + -4ll) );
		}
		label$1538:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$1537:;
		if( (int64)K$2 >= (int64)TMP$268$2) goto label$1540;
		label$1539:;
	}
	_ZN7COUNTEDaSERS_( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)I$1 << (2ll & 63ll))), &TMP$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	_ZN7COUNTEDD1Ev( &TMP$1 );
	label$1533:;
}

static void _ZN5ArrayI7COUNTEDE6REMOVEEi( struct $5ArrayI7COUNTEDE* THIS$1, int32 I$1 )
{
	int64 TMP$269$1;
	label$1542:;
	if( (int64)I$1 < 0ll) goto label$1544;
	TMP$269$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$1551;
	label$1544:;
	TMP$269$1 = -1ll;
	label$1551:;
	if( TMP$269$1 == 0ll) goto label$1546;
	{
		goto label$1543;
	}
	label$1546:;
	label$1545:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$270$2;
		TMP$270$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$1547;
		label$1550:;
		{
			_ZN7COUNTEDaSERS_( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)K$2 << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)K$2 << (2ll & 63ll))) + 4ll) );
		}
		label$1548:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$1547:;
		if( (int64)K$2 <= (int64)TMP$270$2) goto label$1550;
		label$1549:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$1543:;
}

static void _ZN5ArrayI7COUNTEDE10REMOVESWAPEi( struct $5ArrayI7COUNTEDE* THIS$1, int32 I$1 )
{
	int64 TMP$271$1;
	label$1552:;
	if( (int64)I$1 < 0ll) goto label$1554;
	TMP$271$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$1559;
	label$1554:;
	TMP$271$1 = -1ll;
	label$1559:;
	if( TMP$271$1 == 0ll) goto label$1556;
	{
		goto label$1553;
	}
	label$1556:;
	label$1555:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$1558;
	{
		_ZN7COUNTEDaSERS_( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)I$1 << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (2ll & 63ll))) );
	}
	label$1558:;
	label$1557:;
	label$1553:;
}

static void _ZN5ArrayI7COUNTEDE5CLEAREv( struct $5ArrayI7COUNTEDE* THIS$1 )
{
	label$1560:;
	struct $7COUNTED BLANK$1;
	_ZN7COUNTEDC1Ev( &BLANK$1 );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$272$2;
		TMP$272$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$1562;
		label$1565:;
		{
			_ZN7COUNTEDaSERS_( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)THIS$1 + ((int64)K$2 << (2ll & 63ll))), &BLANK$1 );
		}
		label$1563:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$1562:;
		if( (int64)K$2 <= (int64)TMP$272$2) goto label$1565;
		label$1564:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	_ZN7COUNTEDD1Ev( &BLANK$1 );
	label$1561:;
}

static struct $13ArrayIteratorI7COUNTEDE _ZN5ArrayI7COUNTEDE11GETITERATOREv( struct $5ArrayI7COUNTEDE* THIS$1 )
{
	struct $13ArrayIteratorI7COUNTEDE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$1566:;
	struct $13ArrayIteratorI7COUNTEDE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$1567;
	label$1567:;
	return fb$result$1;
}

static void _Z4SortI7COUNTEDER5ArrayI7COUNTEDE( struct $5ArrayI7COUNTEDE* A$1 )
{
	label$1568:;
	typedef boolean (*_Z7tmp$273R7COUNTEDS0_)( struct $7COUNTED*, struct $7COUNTED* );
	_Z7tmp$273R7COUNTEDS0_ LESS$1;
	LESS$1 = (_Z7tmp$273R7COUNTEDS0_)&L3C22B1CEA777A486_LT_0112;
	_Z6SortByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDERS6_( A$1, (tmp$275*)&LESS$1 );
	label$1569:;
}

boolean L3C22B1CEA777A486_LT_0112( struct $7COUNTED* X$1, struct $7COUNTED* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1570:;
	boolean vr$1 = _ZltR7COUNTEDS0_( X$1, Y$1 );
	fb$result$1 = vr$1;
	goto label$1571;
	label$1571:;
	return fb$result$1;
}

static void _Z10StableSortI7COUNTEDER5ArrayI7COUNTEDE( struct $5ArrayI7COUNTEDE* A$1 )
{
	label$1572:;
	typedef boolean (*_Z7tmp$276R7COUNTEDS0_)( struct $7COUNTED*, struct $7COUNTED* );
	_Z7tmp$276R7COUNTEDS0_ LESS$1;
	LESS$1 = (_Z7tmp$276R7COUNTEDS0_)&L3C22B1CEA777A486_LT_0115;
	_Z12StableSortByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDERS6_( A$1, (tmp$275*)&LESS$1 );
	label$1573:;
}

boolean L3C22B1CEA777A486_LT_0115( struct $7COUNTED* X$1, struct $7COUNTED* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1574:;
	boolean vr$1 = _ZltR7COUNTEDS0_( X$1, Y$1 );
	fb$result$1 = vr$1;
	goto label$1575;
	label$1575:;
	return fb$result$1;
}

static void _Z6SortByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDERS6_( struct $5ArrayI7COUNTEDE* A$1, tmp$275* LESS$1 )
{
	label$1576:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$1579;
	{
		goto label$1577;
	}
	label$1579:;
	label$1578:;
	int32 DEPTH$1;
	DEPTH$1 = 0;
	int32 M$1;
	M$1 = N$1;
	label$1580:;
	if( (int64)M$1 <= 1ll) goto label$1581;
	{
		M$1 = (int32)((int64)M$1 / 2ll);
		DEPTH$1 = (int32)((int64)DEPTH$1 + 1ll);
	}
	goto label$1580;
	label$1581:;
	DEPTH$1 = (int32)((int64)DEPTH$1 << (1ll & 63ll));
	_Z11SortIntroByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiiRS6_( A$1, 0, (int32)((int64)N$1 + -1ll), DEPTH$1, LESS$1 );
	label$1577:;
}

static void _Z12StableSortByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDERS6_( struct $5ArrayI7COUNTEDE* A$1, tmp$275* LESS$1 )
{
	label$1582:;
	int32 N$1;
	N$1 = *(int32*)((uint8*)A$1 + 72ll);
	if( (int64)N$1 >= 2ll) goto label$1585;
	{
		goto label$1583;
	}
	label$1585:;
	label$1584:;
	int32 RUNW$1;
	RUNW$1 = 16;
	int32 S$1;
	S$1 = 0;
	label$1586:;
	if( (int64)S$1 >= (int64)N$1) goto label$1587;
	{
		int32 E$2;
		E$2 = (int32)(((int64)S$1 + (int64)RUNW$1) + -1ll);
		if( (int64)E$2 <= ((int64)N$1 + -1ll)) goto label$1589;
		{
			E$2 = (int32)((int64)N$1 + -1ll);
		}
		label$1589:;
		label$1588:;
		_Z15SortInsertionByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( A$1, S$1, E$2, LESS$1 );
		S$1 = (int32)((int64)S$1 + (int64)RUNW$1);
	}
	goto label$1586;
	label$1587:;
	if( (int64)RUNW$1 < (int64)N$1) goto label$1591;
	{
		goto label$1583;
	}
	label$1591:;
	label$1590:;
	struct $10FBARRAY1$5I7COUNTEDE {
		struct $7COUNTED* DATA;
		struct $7COUNTED* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $10FBARRAY1$5I7COUNTEDE ) == 72 );
	struct $10FBARRAY1$5I7COUNTEDE BUF$1;
	*(struct $7COUNTED**)&BUF$1 = (struct $7COUNTED*)0ull;
	*(struct $7COUNTED**)((uint8*)&BUF$1 + 8ll) = (struct $7COUNTED*)0ull;
	*(int64*)((uint8*)&BUF$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&BUF$1 + 24ll) = 4ll;
	*(int64*)((uint8*)&BUF$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&BUF$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&BUF$1 + 48ll), 0, 24ll );
	fb_ArrayRedimObj( (struct $7FBARRAYIvE*)&BUF$1, 4ull, (void*)&_ZN7COUNTEDC1Ev, (void*)&_ZN7COUNTEDD1Ev, 1ull, 0ll, (int64)N$1 + -1ll );
	label$1592:;
	if( (int64)RUNW$1 >= (int64)N$1) goto label$1593;
	{
		int32 LO$2;
		LO$2 = 0;
		label$1594:;
		if( (int64)LO$2 >= ((int64)N$1 - (int64)RUNW$1)) goto label$1595;
		{
			int32 MID_$3;
			MID_$3 = (int32)(((int64)LO$2 + (int64)RUNW$1) + -1ll);
			int32 HI$3;
			HI$3 = (int32)(((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll))) + -1ll);
			if( (int64)HI$3 <= ((int64)N$1 + -1ll)) goto label$1597;
			{
				HI$3 = (int32)((int64)N$1 + -1ll);
			}
			label$1597:;
			label$1596:;
			_Z11SortMergeByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDER7FBARRAYIS0_EiiiRS6_( A$1, (struct $7FBARRAYI7COUNTEDE*)&BUF$1, LO$2, MID_$3, HI$3, LESS$1 );
			LO$2 = (int32)((int64)LO$2 + ((int64)RUNW$1 << (1ll & 63ll)));
		}
		goto label$1594;
		label$1595:;
		RUNW$1 = (int32)((int64)RUNW$1 << (1ll & 63ll));
	}
	goto label$1592;
	label$1593:;
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)&BUF$1, (void*)&_ZN7COUNTEDC1Ev, (void*)&_ZN7COUNTEDD1Ev );
	label$1583:;
}

static void _Z11SortIntroByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiiRS6_( struct $5ArrayI7COUNTEDE* A$1, int32 LO$1, int32 HI$1, int32 DEPTH$1, tmp$275* LESS$1 )
{
	label$1598:;
	label$1600:;
	if( (((int64)HI$1 - (int64)LO$1) + 1ll) <= 16ll) goto label$1601;
	{
		if( (int64)DEPTH$1 != 0ll) goto label$1603;
		{
			_Z10SortHeapByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( A$1, LO$1, HI$1, LESS$1 );
			goto label$1599;
		}
		label$1603:;
		label$1602:;
		DEPTH$1 = (int32)((int64)DEPTH$1 + -1ll);
		int32 P$2;
		int32 vr$8 = _Z15SortPartitionByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( A$1, LO$1, HI$1, LESS$1 );
		P$2 = vr$8;
		if( ((int64)P$2 - (int64)LO$1) >= ((int64)HI$1 - (int64)P$2)) goto label$1605;
		{
			_Z11SortIntroByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiiRS6_( A$1, LO$1, (int32)((int64)P$2 + -1ll), DEPTH$1, LESS$1 );
			LO$1 = (int32)((int64)P$2 + 1ll);
		}
		goto label$1604;
		label$1605:;
		{
			_Z11SortIntroByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiiRS6_( A$1, (int32)((int64)P$2 + 1ll), HI$1, DEPTH$1, LESS$1 );
			HI$1 = (int32)((int64)P$2 + -1ll);
		}
		label$1604:;
	}
	goto label$1600;
	label$1601:;
	_Z15SortInsertionByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( A$1, LO$1, HI$1, LESS$1 );
	label$1599:;
}

static void _Z15SortInsertionByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( struct $5ArrayI7COUNTEDE* A$1, int32 LO$1, int32 HI$1, tmp$275* LESS$1 )
{
	label$1606:;
	{
		int32 I$2;
		I$2 = (int32)((int64)LO$1 + 1ll);
		int32 TMP$279$2;
		TMP$279$2 = HI$1;
		goto label$1608;
		label$1611:;
		{
			int32 J$3;
			J$3 = I$2;
			label$1612:;
			{
				if( (int64)J$3 > (int64)LO$1) goto label$1616;
				{
					goto label$1613;
				}
				label$1616:;
				label$1615:;
				boolean LT$4;
				boolean vr$14 = (*LESS$1)( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)J$3 << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll) );
				LT$4 = vr$14;
				if( LT$4 != (boolean)0ll) goto label$1618;
				{
					goto label$1613;
				}
				label$1618:;
				label$1617:;
				{
					fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)J$3 << (2ll & 63ll))), (void*)((uint8*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)J$3 << (2ll & 63ll))) + -4ll), 4ll );
				}
				J$3 = (int32)((int64)J$3 + -1ll);
			}
			label$1614:;
			goto label$1612;
			label$1613:;
		}
		label$1609:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$1608:;
		if( (int64)I$2 <= (int64)TMP$279$2) goto label$1611;
		label$1610:;
	}
	label$1607:;
}

static void _Z11SortMergeByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDER7FBARRAYIS0_EiiiRS6_( struct $5ArrayI7COUNTEDE* A$1, struct $7FBARRAYI7COUNTEDE* BUF$1, int32 LO$1, int32 MID_$1, int32 HI$1, tmp$275* LESS$1 )
{
	int64 TMP$281$1;
	label$1619:;
	{
		int32 X$2;
		X$2 = LO$1;
		int32 TMP$280$2;
		TMP$280$2 = MID_$1;
		goto label$1621;
		label$1624:;
		{
			{
				fb_MemSwap( (void*)(((int64)X$2 << (2ll & 63ll)) + *(int64*)BUF$1), (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)X$2 << (2ll & 63ll))), 4ll );
			}
		}
		label$1622:;
		X$2 = (int32)((int64)X$2 + 1ll);
		label$1621:;
		if( (int64)X$2 <= (int64)TMP$280$2) goto label$1624;
		label$1623:;
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)MID_$1 + 1ll);
	int32 K$1;
	K$1 = LO$1;
	label$1625:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1627;
	TMP$281$1 = (int64)-((int64)J$1 <= (int64)HI$1);
	goto label$1632;
	label$1627:;
	TMP$281$1 = 0ll;
	label$1632:;
	if( TMP$281$1 == 0ll) goto label$1626;
	{
		boolean TAKERIGHT$2;
		boolean vr$31 = (*LESS$1)( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)J$1 << (2ll & 63ll))), (struct $7COUNTED*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1) );
		TAKERIGHT$2 = vr$31;
		if( TAKERIGHT$2 == (boolean)0ll) goto label$1629;
		{
			{
				fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)K$1 << (2ll & 63ll))), (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)J$1 << (2ll & 63ll))), 4ll );
			}
			J$1 = (int32)((int64)J$1 + 1ll);
		}
		goto label$1628;
		label$1629:;
		{
			{
				fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)K$1 << (2ll & 63ll))), (void*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1), 4ll );
			}
			I$1 = (int32)((int64)I$1 + 1ll);
		}
		label$1628:;
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1625;
	label$1626:;
	label$1630:;
	if( (int64)I$1 > (int64)MID_$1) goto label$1631;
	{
		{
			fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)K$1 << (2ll & 63ll))), (void*)(((int64)I$1 << (2ll & 63ll)) + *(int64*)BUF$1), 4ll );
		}
		I$1 = (int32)((int64)I$1 + 1ll);
		K$1 = (int32)((int64)K$1 + 1ll);
	}
	goto label$1630;
	label$1631:;
	label$1620:;
}

static void _Z10SortHeapByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( struct $5ArrayI7COUNTEDE* A$1, int32 LO$1, int32 HI$1, tmp$275* LESS$1 )
{
	label$1633:;
	int32 N$1;
	N$1 = (int32)(((int64)HI$1 - (int64)LO$1) + 1ll);
	if( (int64)N$1 >= 2ll) goto label$1636;
	{
		goto label$1634;
	}
	label$1636:;
	label$1635:;
	{
		int32 I$2;
		I$2 = (int32)(((int64)N$1 / 2ll) + -1ll);
		goto label$1637;
		label$1640:;
		{
			_Z14SortSiftDownByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiiRS6_( A$1, LO$1, N$1, I$2, LESS$1 );
		}
		label$1638:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$1637:;
		if( (int64)I$2 >= 0ll) goto label$1640;
		label$1639:;
	}
	{
		int32 I$2;
		I$2 = (int32)((int64)N$1 + -1ll);
		goto label$1641;
		label$1644:;
		{
			{
				fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)LO$1 << (2ll & 63ll))), (void*)((uint8*)*(struct $7COUNTED**)A$1 + (((int64)LO$1 + (int64)I$2) << (2ll & 63ll))), 4ll );
			}
			_Z14SortSiftDownByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiiRS6_( A$1, LO$1, I$2, 0, LESS$1 );
		}
		label$1642:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$1641:;
		if( (int64)I$2 >= 1ll) goto label$1644;
		label$1643:;
	}
	label$1634:;
}

static int32 _Z15SortPartitionByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiRS6_( struct $5ArrayI7COUNTEDE* A$1, int32 LO$1, int32 HI$1, tmp$275* LESS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$1645:;
	int32 MID_$1;
	MID_$1 = (int32)((int64)LO$1 + (((int64)HI$1 - (int64)LO$1) / 2ll));
	boolean SW$1;
	boolean vr$16 = (*LESS$1)( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)MID_$1 << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
	SW$1 = vr$16;
	if( SW$1 == (boolean)0ll) goto label$1648;
	{
		{
			fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)MID_$1 << (2ll & 63ll))), (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)LO$1 << (2ll & 63ll))), 4ll );
		}
	}
	label$1648:;
	label$1647:;
	boolean vr$34 = (*LESS$1)( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
	SW$1 = vr$34;
	if( SW$1 == (boolean)0ll) goto label$1650;
	{
		{
			fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)LO$1 << (2ll & 63ll))), 4ll );
		}
	}
	label$1650:;
	label$1649:;
	boolean vr$52 = (*LESS$1)( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)MID_$1 << (2ll & 63ll))) );
	SW$1 = vr$52;
	if( SW$1 == (boolean)0ll) goto label$1652;
	{
		{
			fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)HI$1 << (2ll & 63ll))), (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)MID_$1 << (2ll & 63ll))), 4ll );
		}
	}
	label$1652:;
	label$1651:;
	{
		fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)LO$1 << (2ll & 63ll))), (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)MID_$1 << (2ll & 63ll))), 4ll );
	}
	int32 I$1;
	I$1 = LO$1;
	int32 J$1;
	J$1 = (int32)((int64)HI$1 + 1ll);
	label$1653:;
	{
		label$1656:;
		{
			I$1 = (int32)((int64)I$1 + 1ll);
			if( (int64)I$1 <= (int64)HI$1) goto label$1660;
			{
				goto label$1657;
			}
			label$1660:;
			label$1659:;
			boolean LT$3;
			boolean vr$86 = (*LESS$1)( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)I$1 << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)LO$1 << (2ll & 63ll))) );
			LT$3 = vr$86;
			if( LT$3 != (boolean)0ll) goto label$1662;
			{
				goto label$1657;
			}
			label$1662:;
			label$1661:;
		}
		label$1658:;
		goto label$1656;
		label$1657:;
		label$1663:;
		{
			J$1 = (int32)((int64)J$1 + -1ll);
			if( (int64)J$1 > (int64)LO$1) goto label$1667;
			{
				goto label$1664;
			}
			label$1667:;
			label$1666:;
			boolean GT$3;
			boolean vr$101 = (*LESS$1)( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)LO$1 << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)J$1 << (2ll & 63ll))) );
			GT$3 = vr$101;
			if( GT$3 != (boolean)0ll) goto label$1669;
			{
				goto label$1664;
			}
			label$1669:;
			label$1668:;
		}
		label$1665:;
		goto label$1663;
		label$1664:;
		if( (int64)I$1 < (int64)J$1) goto label$1671;
		{
			goto label$1654;
		}
		label$1671:;
		label$1670:;
		{
			fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)I$1 << (2ll & 63ll))), (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)J$1 << (2ll & 63ll))), 4ll );
		}
	}
	label$1655:;
	goto label$1653;
	label$1654:;
	{
		fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)LO$1 << (2ll & 63ll))), (void*)((uint8*)*(struct $7COUNTED**)A$1 + ((int64)J$1 << (2ll & 63ll))), 4ll );
	}
	fb$result$1 = J$1;
	goto label$1646;
	label$1646:;
	return fb$result$1;
}

static void _Z14SortSiftDownByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER5ArrayI7COUNTEDEiiiRS6_( struct $5ArrayI7COUNTEDE* A$1, int32 LO$1, int32 N$1, int32 ROOT$1, tmp$275* LESS$1 )
{
	label$1672:;
	label$1674:;
	{
		int32 CHILD$2;
		CHILD$2 = (int32)(((int64)ROOT$1 << (1ll & 63ll)) + 1ll);
		if( (int64)CHILD$2 < (int64)N$1) goto label$1678;
		{
			goto label$1675;
		}
		label$1678:;
		label$1677:;
		if( ((int64)CHILD$2 + 1ll) >= (int64)N$1) goto label$1680;
		{
			boolean RIGHTISBIGGER$3;
			boolean vr$22 = (*LESS$1)( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)((uint8*)*(struct $7COUNTED**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) + 4ll) );
			RIGHTISBIGGER$3 = vr$22;
			if( RIGHTISBIGGER$3 == (boolean)0ll) goto label$1682;
			{
				CHILD$2 = (int32)((int64)CHILD$2 + 1ll);
			}
			label$1682:;
			label$1681:;
		}
		label$1680:;
		label$1679:;
		boolean CHILDISBIGGER$2;
		boolean vr$39 = (*LESS$1)( (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll))), (struct $7COUNTED*)((uint8*)*(struct $7COUNTED**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))) );
		CHILDISBIGGER$2 = vr$39;
		if( CHILDISBIGGER$2 != (boolean)0ll) goto label$1684;
		{
			goto label$1675;
		}
		label$1684:;
		label$1683:;
		{
			fb_MemSwap( (void*)((uint8*)*(struct $7COUNTED**)A$1 + (((int64)LO$1 + (int64)ROOT$1) << (2ll & 63ll))), (void*)((uint8*)*(struct $7COUNTED**)A$1 + (((int64)LO$1 + (int64)CHILD$2) << (2ll & 63ll))), 4ll );
		}
		ROOT$1 = CHILD$2;
	}
	label$1676:;
	goto label$1674;
	label$1675:;
	label$1673:;
}

static void _Z8SortListIiER10LinkedListIiE( struct $10LinkedListIiE* L$1 )
{
	label$1729:;
	typedef boolean (*_Z7tmp$298RiS_)( int32*, int32* );
	_Z7tmp$298RiS_ LESS$1;
	LESS$1 = (_Z7tmp$298RiS_)&L3C22B1CEA777A486_LT_012B;
	_Z10SortListByIiPFbRiRiEER10LinkedListIiERS3_( L$1, (tmp$50*)&LESS$1 );
	label$1730:;
}

boolean L3C22B1CEA777A486_LT_012B( int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1731:;
	fb$result$1 = (boolean)((int64)-((int64)*X$1 < (int64)*Y$1) != 0ll);
	goto label$1732;
	label$1732:;
	return fb$result$1;
}

static void _Z10SortListByIiPFbRiRiEER10LinkedListIiERS3_( struct $10LinkedListIiE* L$1, tmp$50* LESS$1 )
{
	label$1733:;
	if( (int64)*(int32*)((uint8*)L$1 + 16ll) >= 2ll) goto label$1736;
	{
		goto label$1734;
	}
	label$1736:;
	label$1735:;
	struct $10LinkedNodeIiE* HEAD$1;
	HEAD$1 = *(struct $10LinkedNodeIiE**)L$1;
	struct $10LinkedNodeIiE* TAIL$1;
	TAIL$1 = (struct $10LinkedNodeIiE*)0ull;
	int32 RUNW$1;
	RUNW$1 = 1;
	label$1737:;
	{
		struct $10LinkedNodeIiE* P$2;
		P$2 = HEAD$1;
		struct $10LinkedNodeIiE* NEWHEAD$2;
		NEWHEAD$2 = (struct $10LinkedNodeIiE*)0ull;
		int32 MERGES$2;
		MERGES$2 = 0;
		TAIL$1 = (struct $10LinkedNodeIiE*)0ull;
		label$1740:;
		if( P$2 == (struct $10LinkedNodeIiE*)0ull) goto label$1741;
		{
			int64 TMP$300$3;
			MERGES$2 = (int32)((int64)MERGES$2 + 1ll);
			struct $10LinkedNodeIiE* Q$3;
			Q$3 = P$2;
			int32 PSIZE$3;
			PSIZE$3 = 0;
			label$1742:;
			if( (int64)PSIZE$3 >= (int64)RUNW$1) goto label$1744;
			TMP$300$3 = (int64)-(Q$3 != (struct $10LinkedNodeIiE*)0ull);
			goto label$1761;
			label$1744:;
			TMP$300$3 = 0ll;
			label$1761:;
			if( TMP$300$3 == 0ll) goto label$1743;
			{
				PSIZE$3 = (int32)((int64)PSIZE$3 + 1ll);
				Q$3 = *(struct $10LinkedNodeIiE**)((uint8*)Q$3 + 8ll);
			}
			goto label$1742;
			label$1743:;
			int32 QSIZE$3;
			QSIZE$3 = RUNW$1;
			label$1745:;
			{
				int64 TMP$301$4;
				boolean TMP$302$4;
				boolean PLEFT$4;
				PLEFT$4 = (boolean)((int64)-((int64)PSIZE$3 > 0ll) != 0ll);
				boolean QLEFT$4;
				if( (int64)QSIZE$3 <= 0ll) goto label$1748;
				TMP$301$4 = (int64)-(Q$3 != (struct $10LinkedNodeIiE*)0ull);
				goto label$1762;
				label$1748:;
				TMP$301$4 = 0ll;
				label$1762:;
				QLEFT$4 = (boolean)(TMP$301$4 != 0ll);
				if( PLEFT$4 != (boolean)0ll) goto label$1749;
				TMP$302$4 = (boolean)(QLEFT$4 != (boolean)0ll);
				goto label$1763;
				label$1749:;
				TMP$302$4 = (boolean)1ll;
				label$1763:;
				if( TMP$302$4 != (boolean)0ll) goto label$1751;
				{
					goto label$1746;
				}
				label$1751:;
				label$1750:;
				struct $10LinkedNodeIiE* E$4;
				__builtin_memset( &E$4, 0, 8ll );
				if( PLEFT$4 != (boolean)0ll) goto label$1753;
				{
					E$4 = Q$3;
					Q$3 = *(struct $10LinkedNodeIiE**)((uint8*)Q$3 + 8ll);
					QSIZE$3 = (int32)((int64)QSIZE$3 + -1ll);
				}
				goto label$1752;
				label$1753:;
				if( QLEFT$4 != (boolean)0ll) goto label$1754;
				{
					E$4 = P$2;
					P$2 = *(struct $10LinkedNodeIiE**)((uint8*)P$2 + 8ll);
					PSIZE$3 = (int32)((int64)PSIZE$3 + -1ll);
				}
				goto label$1752;
				label$1754:;
				{
					boolean TAKEQ$5;
					boolean vr$33 = (*LESS$1)( (int32*)Q$3, (int32*)P$2 );
					TAKEQ$5 = vr$33;
					if( TAKEQ$5 == (boolean)0ll) goto label$1756;
					{
						E$4 = Q$3;
						Q$3 = *(struct $10LinkedNodeIiE**)((uint8*)Q$3 + 8ll);
						QSIZE$3 = (int32)((int64)QSIZE$3 + -1ll);
					}
					goto label$1755;
					label$1756:;
					{
						E$4 = P$2;
						P$2 = *(struct $10LinkedNodeIiE**)((uint8*)P$2 + 8ll);
						PSIZE$3 = (int32)((int64)PSIZE$3 + -1ll);
					}
					label$1755:;
				}
				label$1752:;
				if( TAIL$1 == (struct $10LinkedNodeIiE*)0ull) goto label$1758;
				{
					*(struct $10LinkedNodeIiE**)((uint8*)TAIL$1 + 8ll) = E$4;
				}
				goto label$1757;
				label$1758:;
				{
					NEWHEAD$2 = E$4;
				}
				label$1757:;
				*(struct $10LinkedNodeIiE**)((uint8*)E$4 + 16ll) = TAIL$1;
				TAIL$1 = E$4;
			}
			label$1747:;
			goto label$1745;
			label$1746:;
			P$2 = Q$3;
		}
		goto label$1740;
		label$1741:;
		*(struct $10LinkedNodeIiE**)((uint8*)TAIL$1 + 8ll) = (struct $10LinkedNodeIiE*)0ull;
		HEAD$1 = NEWHEAD$2;
		if( (int64)MERGES$2 > 1ll) goto label$1760;
		{
			goto label$1738;
		}
		label$1760:;
		label$1759:;
		RUNW$1 = (int32)((int64)RUNW$1 << (1ll & 63ll));
	}
	label$1739:;
	goto label$1737;
	label$1738:;
	*(struct $10LinkedNodeIiE**)L$1 = HEAD$1;
	*(struct $10LinkedNodeIiE**)((uint8*)L$1 + 8ll) = TAIL$1;
	label$1734:;
}

static boolean _ZN18LinkedListIteratorI8FBSTRINGE7ISVALIDEv( struct $18LinkedListIteratorI8FBSTRINGE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1832:;
	fb$result$1 = (boolean)((int64)-(*(void**)THIS$1 != (void*)0ull) != 0ll);
	goto label$1833;
	label$1833:;
	return fb$result$1;
}

static FBSTRING* _ZN18LinkedListIteratorI8FBSTRINGE5VALUEEv( struct $18LinkedListIteratorI8FBSTRINGE* THIS$1 )
{
	FBSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1834:;
	struct $10LinkedNodeI8FBSTRINGE* N$1;
	N$1 = *(struct $10LinkedNodeI8FBSTRINGE**)THIS$1;
	fb$result$1 = (FBSTRING*)N$1;
	goto label$1835;
	label$1835:;
	return fb$result$1;
}

static void _ZN18LinkedListIteratorI8FBSTRINGE8MOVENEXTEv( struct $18LinkedListIteratorI8FBSTRINGE* THIS$1 )
{
	label$1836:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$1839;
	{
		goto label$1837;
		label$1839:;
	}
	struct $10LinkedNodeI8FBSTRINGE* N$1;
	N$1 = *(struct $10LinkedNodeI8FBSTRINGE**)THIS$1;
	*(void**)THIS$1 = *(void**)((uint8*)N$1 + 24ll);
	label$1837:;
}

static void _ZN10LinkedListI8FBSTRINGEC1Ev( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	label$1840:;
	__builtin_memset( (struct $10LinkedNodeI8FBSTRINGE**)THIS$1, 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 16ll), 0, 4ll );
	*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	label$1841:;
}

static void _ZN10LinkedListI8FBSTRINGEC1ERS1_( struct $10LinkedListI8FBSTRINGE* THIS$1, struct $10LinkedListI8FBSTRINGE* RHS$1 )
{
	label$1842:;
	__builtin_memset( (struct $10LinkedNodeI8FBSTRINGE**)THIS$1, 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 16ll), 0, 4ll );
	*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	_ZN10LinkedListI8FBSTRINGE8COPYFROMERS1_( THIS$1, RHS$1 );
	label$1843:;
}

static void _ZN10LinkedListI8FBSTRINGED1Ev( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	label$1844:;
	_ZN10LinkedListI8FBSTRINGE5CLEAREv( THIS$1 );
	label$1845:;
}

static void _ZN10LinkedListI8FBSTRINGEaSERS1_( struct $10LinkedListI8FBSTRINGE* THIS$1, struct $10LinkedListI8FBSTRINGE* RHS$1 )
{
	label$1846:;
	if( RHS$1 != THIS$1) goto label$1849;
	{
		goto label$1847;
	}
	label$1849:;
	label$1848:;
	_ZN10LinkedListI8FBSTRINGE5CLEAREv( THIS$1 );
	_ZN10LinkedListI8FBSTRINGE8COPYFROMERS1_( THIS$1, RHS$1 );
	label$1847:;
}

static void _ZN10LinkedListI8FBSTRINGE8COPYFROMERS1_( struct $10LinkedListI8FBSTRINGE* THIS$1, struct $10LinkedListI8FBSTRINGE* RHS$1 )
{
	label$1850:;
	struct $10LinkedNodeI8FBSTRINGE* P$1;
	P$1 = *(struct $10LinkedNodeI8FBSTRINGE**)RHS$1;
	label$1852:;
	if( P$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1853;
	{
		_ZN10LinkedListI8FBSTRINGE8PUSHBACKERS0_( THIS$1, (FBSTRING*)P$1 );
		P$1 = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)P$1 + 24ll);
	}
	goto label$1852;
	label$1853:;
	label$1851:;
}

static int32 _ZN10LinkedListI8FBSTRINGE5COUNTEv( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$1854:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 16ll);
	goto label$1855;
	label$1855:;
	return fb$result$1;
}

static boolean _ZN10LinkedListI8FBSTRINGE7ISEMPTYEv( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1856:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 16ll) == 0ll) != 0ll);
	goto label$1857;
	label$1857:;
	return fb$result$1;
}

static void _ZN10LinkedListI8FBSTRINGE9PUSHFRONTERS0_( struct $10LinkedListI8FBSTRINGE* THIS$1, FBSTRING* V$1 )
{
	struct $10LinkedNodeI8FBSTRINGE* TMP$343$1;
	label$1858:;
	FBSTRING VV$1;
	fb_StrInit( (void*)&VV$1, -1ll, (void*)V$1, -1ll, 0 );
	struct $10LinkedNodeI8FBSTRINGE* N$1;
	void* vr$1 = calloc( 40ull, 1ull );
	TMP$343$1 = (struct $10LinkedNodeI8FBSTRINGE*)vr$1;
	if( TMP$343$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1860;
	_ZN10LinkedNodeI8FBSTRINGEC1Ev( TMP$343$1 );
	label$1860:;
	N$1 = TMP$343$1;
	fb_StrAssign( (void*)N$1, -1ll, (void*)&VV$1, -1ll, 0 );
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)N$1 + 32ll) = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)N$1 + 24ll) = *(struct $10LinkedNodeI8FBSTRINGE**)THIS$1;
	if( *(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1862;
	{
		*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 + 32ll) = N$1;
	}
	goto label$1861;
	label$1862:;
	{
		*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) = N$1;
	}
	label$1861:;
	*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 = N$1;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + 1ll);
	fb_StrDelete( (FBSTRING*)&VV$1 );
	label$1859:;
}

static void _ZN10LinkedListI8FBSTRINGE8PUSHBACKERS0_( struct $10LinkedListI8FBSTRINGE* THIS$1, FBSTRING* V$1 )
{
	struct $10LinkedNodeI8FBSTRINGE* TMP$345$1;
	label$1863:;
	FBSTRING VV$1;
	fb_StrInit( (void*)&VV$1, -1ll, (void*)V$1, -1ll, 0 );
	struct $10LinkedNodeI8FBSTRINGE* N$1;
	void* vr$1 = calloc( 40ull, 1ull );
	TMP$345$1 = (struct $10LinkedNodeI8FBSTRINGE*)vr$1;
	if( TMP$345$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1865;
	_ZN10LinkedNodeI8FBSTRINGEC1Ev( TMP$345$1 );
	label$1865:;
	N$1 = TMP$345$1;
	fb_StrAssign( (void*)N$1, -1ll, (void*)&VV$1, -1ll, 0 );
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)N$1 + 24ll) = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)N$1 + 32ll) = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll);
	if( *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1867;
	{
		*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) + 24ll) = N$1;
	}
	goto label$1866;
	label$1867:;
	{
		*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 = N$1;
	}
	label$1866:;
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) = N$1;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + 1ll);
	fb_StrDelete( (FBSTRING*)&VV$1 );
	label$1864:;
}

static FBSTRING* _ZN10LinkedListI8FBSTRINGE8POPFRONTEv( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$1868:;
	FBSTRING R$1;
	__builtin_memset( &R$1, 0, 24ll );
	if( *(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 != (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1871;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
		fb_StrDelete( (FBSTRING*)&R$1 );
		goto label$1869;
	}
	label$1871:;
	label$1870:;
	struct $10LinkedNodeI8FBSTRINGE* N$1;
	N$1 = *(struct $10LinkedNodeI8FBSTRINGE**)THIS$1;
	fb_StrAssign( (void*)&R$1, -1ll, (void*)N$1, -1ll, 0 );
	*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)N$1 + 24ll);
	if( *(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1873;
	{
		*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 + 32ll) = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	}
	goto label$1872;
	label$1873:;
	{
		*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	}
	label$1872:;
	if( N$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1874;
	_ZN10LinkedNodeI8FBSTRINGED1Ev( N$1 );
	free( (void*)N$1 );
	label$1874:;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + -1ll);
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&R$1 );
	goto label$1869;
	fb_StrDelete( (FBSTRING*)&R$1 );
	label$1869:;
	FBSTRING* vr$26 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$26;
}

static FBSTRING* _ZN10LinkedListI8FBSTRINGE7POPBACKEv( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$1875:;
	FBSTRING R$1;
	__builtin_memset( &R$1, 0, 24ll );
	if( *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) != (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1878;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
		fb_StrDelete( (FBSTRING*)&R$1 );
		goto label$1876;
	}
	label$1878:;
	label$1877:;
	struct $10LinkedNodeI8FBSTRINGE* N$1;
	N$1 = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll);
	fb_StrAssign( (void*)&R$1, -1ll, (void*)N$1, -1ll, 0 );
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)N$1 + 32ll);
	if( *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1880;
	{
		*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) + 24ll) = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	}
	goto label$1879;
	label$1880:;
	{
		*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	}
	label$1879:;
	if( N$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1881;
	_ZN10LinkedNodeI8FBSTRINGED1Ev( N$1 );
	free( (void*)N$1 );
	label$1881:;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + -1ll);
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&R$1 );
	goto label$1876;
	fb_StrDelete( (FBSTRING*)&R$1 );
	label$1876:;
	FBSTRING* vr$26 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$26;
}

static FBSTRING* _ZN10LinkedListI8FBSTRINGE5FRONTEv( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	FBSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1882:;
	static FBSTRING BLANK$1;
	if( *(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 != (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1885;
	{
		fb$result$1 = &BLANK$1;
		goto label$1883;
	}
	label$1885:;
	label$1884:;
	fb$result$1 = (FBSTRING*)*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1;
	goto label$1883;
	label$1883:;
	return fb$result$1;
}

static FBSTRING* _ZN10LinkedListI8FBSTRINGE4BACKEv( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	FBSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1886:;
	static FBSTRING BLANK$1;
	if( *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) != (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1889;
	{
		fb$result$1 = &BLANK$1;
		goto label$1887;
	}
	label$1889:;
	label$1888:;
	fb$result$1 = (FBSTRING*)*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll);
	goto label$1887;
	label$1887:;
	return fb$result$1;
}

static void _ZN10LinkedListI8FBSTRINGE5CLEAREv( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	label$1890:;
	struct $10LinkedNodeI8FBSTRINGE* P$1;
	P$1 = *(struct $10LinkedNodeI8FBSTRINGE**)THIS$1;
	label$1892:;
	if( P$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1893;
	{
		struct $10LinkedNodeI8FBSTRINGE* NXT$2;
		NXT$2 = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)P$1 + 24ll);
		if( P$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1894;
		_ZN10LinkedNodeI8FBSTRINGED1Ev( P$1 );
		free( (void*)P$1 );
		label$1894:;
		P$1 = NXT$2;
	}
	goto label$1892;
	label$1893:;
	*(struct $10LinkedNodeI8FBSTRINGE**)THIS$1 = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	label$1891:;
}

static struct $18LinkedListIteratorI8FBSTRINGE _ZN10LinkedListI8FBSTRINGE11GETITERATOREv( struct $10LinkedListI8FBSTRINGE* THIS$1 )
{
	struct $18LinkedListIteratorI8FBSTRINGE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1895:;
	struct $18LinkedListIteratorI8FBSTRINGE IT$1;
	__builtin_memset( &IT$1, 0, 8ll );
	*(void**)&IT$1 = *(void**)THIS$1;
	__builtin_memcpy( &fb$result$1, &IT$1, 8 );
	goto label$1896;
	label$1896:;
	return fb$result$1;
}

static boolean _ZN25LD2939E50C2FFBF23_Lt_0150IiE10__FBINVOKEER8FBSTRINGS3_( struct $25LD2939E50C2FFBF23_Lt_0150IiE* THIS$1, FBSTRING* X$1, FBSTRING* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1897:;
	int32* COMPARISONS$1;
	COMPARISONS$1 = *(int32**)THIS$1;
	*COMPARISONS$1 = (int32)((int64)*COMPARISONS$1 + 1ll);
	int32 vr$7 = fb_StrCompare( (void*)X$1, -1ll, (void*)Y$1, -1ll );
	fb$result$1 = (boolean)((int64)-((int64)vr$7 > 0ll) != 0ll);
	goto label$1898;
	label$1898:;
	return fb$result$1;
}

static void _Z10SortListByI8FBSTRING25LD2939E50C2FFBF23_Lt_0150IiEER10LinkedListI8FBSTRINGERS2_( struct $10LinkedListI8FBSTRINGE* L$1, struct $25LD2939E50C2FFBF23_Lt_0150IiE* LESS$1 )
{
	label$1899:;
	if( (int64)*(int32*)((uint8*)L$1 + 16ll) >= 2ll) goto label$1902;
	{
		goto label$1900;
	}
	label$1902:;
	label$1901:;
	struct $10LinkedNodeI8FBSTRINGE* HEAD$1;
	HEAD$1 = *(struct $10LinkedNodeI8FBSTRINGE**)L$1;
	struct $10LinkedNodeI8FBSTRINGE* TAIL$1;
	TAIL$1 = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
	int32 RUNW$1;
	RUNW$1 = 1;
	label$1903:;
	{
		struct $10LinkedNodeI8FBSTRINGE* P$2;
		P$2 = HEAD$1;
		struct $10LinkedNodeI8FBSTRINGE* NEWHEAD$2;
		NEWHEAD$2 = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
		int32 MERGES$2;
		MERGES$2 = 0;
		TAIL$1 = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
		label$1906:;
		if( P$2 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1907;
		{
			int64 TMP$347$3;
			MERGES$2 = (int32)((int64)MERGES$2 + 1ll);
			struct $10LinkedNodeI8FBSTRINGE* Q$3;
			Q$3 = P$2;
			int32 PSIZE$3;
			PSIZE$3 = 0;
			label$1908:;
			if( (int64)PSIZE$3 >= (int64)RUNW$1) goto label$1910;
			TMP$347$3 = (int64)-(Q$3 != (struct $10LinkedNodeI8FBSTRINGE*)0ull);
			goto label$1927;
			label$1910:;
			TMP$347$3 = 0ll;
			label$1927:;
			if( TMP$347$3 == 0ll) goto label$1909;
			{
				PSIZE$3 = (int32)((int64)PSIZE$3 + 1ll);
				Q$3 = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)Q$3 + 24ll);
			}
			goto label$1908;
			label$1909:;
			int32 QSIZE$3;
			QSIZE$3 = RUNW$1;
			label$1911:;
			{
				int64 TMP$348$4;
				boolean TMP$349$4;
				boolean PLEFT$4;
				PLEFT$4 = (boolean)((int64)-((int64)PSIZE$3 > 0ll) != 0ll);
				boolean QLEFT$4;
				if( (int64)QSIZE$3 <= 0ll) goto label$1914;
				TMP$348$4 = (int64)-(Q$3 != (struct $10LinkedNodeI8FBSTRINGE*)0ull);
				goto label$1928;
				label$1914:;
				TMP$348$4 = 0ll;
				label$1928:;
				QLEFT$4 = (boolean)(TMP$348$4 != 0ll);
				if( PLEFT$4 != (boolean)0ll) goto label$1915;
				TMP$349$4 = (boolean)(QLEFT$4 != (boolean)0ll);
				goto label$1929;
				label$1915:;
				TMP$349$4 = (boolean)1ll;
				label$1929:;
				if( TMP$349$4 != (boolean)0ll) goto label$1917;
				{
					goto label$1912;
				}
				label$1917:;
				label$1916:;
				struct $10LinkedNodeI8FBSTRINGE* E$4;
				__builtin_memset( &E$4, 0, 8ll );
				if( PLEFT$4 != (boolean)0ll) goto label$1919;
				{
					E$4 = Q$3;
					Q$3 = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)Q$3 + 24ll);
					QSIZE$3 = (int32)((int64)QSIZE$3 + -1ll);
				}
				goto label$1918;
				label$1919:;
				if( QLEFT$4 != (boolean)0ll) goto label$1920;
				{
					E$4 = P$2;
					P$2 = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)P$2 + 24ll);
					PSIZE$3 = (int32)((int64)PSIZE$3 + -1ll);
				}
				goto label$1918;
				label$1920:;
				{
					boolean TAKEQ$5;
					boolean vr$33 = _ZN25LD2939E50C2FFBF23_Lt_0150IiE10__FBINVOKEER8FBSTRINGS3_( LESS$1, (FBSTRING*)Q$3, (FBSTRING*)P$2 );
					TAKEQ$5 = vr$33;
					if( TAKEQ$5 == (boolean)0ll) goto label$1922;
					{
						E$4 = Q$3;
						Q$3 = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)Q$3 + 24ll);
						QSIZE$3 = (int32)((int64)QSIZE$3 + -1ll);
					}
					goto label$1921;
					label$1922:;
					{
						E$4 = P$2;
						P$2 = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)P$2 + 24ll);
						PSIZE$3 = (int32)((int64)PSIZE$3 + -1ll);
					}
					label$1921:;
				}
				label$1918:;
				if( TAIL$1 == (struct $10LinkedNodeI8FBSTRINGE*)0ull) goto label$1924;
				{
					*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)TAIL$1 + 24ll) = E$4;
				}
				goto label$1923;
				label$1924:;
				{
					NEWHEAD$2 = E$4;
				}
				label$1923:;
				*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)E$4 + 32ll) = TAIL$1;
				TAIL$1 = E$4;
			}
			label$1913:;
			goto label$1911;
			label$1912:;
			P$2 = Q$3;
		}
		goto label$1906;
		label$1907:;
		*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)TAIL$1 + 24ll) = (struct $10LinkedNodeI8FBSTRINGE*)0ull;
		HEAD$1 = NEWHEAD$2;
		if( (int64)MERGES$2 > 1ll) goto label$1926;
		{
			goto label$1904;
		}
		label$1926:;
		label$1925:;
		RUNW$1 = (int32)((int64)RUNW$1 << (1ll & 63ll));
	}
	label$1905:;
	goto label$1903;
	label$1904:;
	*(struct $10LinkedNodeI8FBSTRINGE**)L$1 = HEAD$1;
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)L$1 + 8ll) = TAIL$1;
	label$1900:;
}

static boolean _ZN18LinkedListIteratorI3RECE7ISVALIDEv( struct $18LinkedListIteratorI3RECE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1946:;
	fb$result$1 = (boolean)((int64)-(*(void**)THIS$1 != (void*)0ull) != 0ll);
	goto label$1947;
	label$1947:;
	return fb$result$1;
}

static struct $3REC* _ZN18LinkedListIteratorI3RECE5VALUEEv( struct $18LinkedListIteratorI3RECE* THIS$1 )
{
	struct $3REC* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1948:;
	struct $10LinkedNodeI3RECE* N$1;
	N$1 = *(struct $10LinkedNodeI3RECE**)THIS$1;
	fb$result$1 = (struct $3REC*)N$1;
	goto label$1949;
	label$1949:;
	return fb$result$1;
}

static void _ZN18LinkedListIteratorI3RECE8MOVENEXTEv( struct $18LinkedListIteratorI3RECE* THIS$1 )
{
	label$1950:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$1953;
	{
		goto label$1951;
		label$1953:;
	}
	struct $10LinkedNodeI3RECE* N$1;
	N$1 = *(struct $10LinkedNodeI3RECE**)THIS$1;
	*(void**)THIS$1 = *(void**)((uint8*)N$1 + 8ll);
	label$1951:;
}

static void _ZN10LinkedListI3RECEC1Ev( struct $10LinkedListI3RECE* THIS$1 )
{
	label$1954:;
	__builtin_memset( (struct $10LinkedNodeI3RECE**)THIS$1, 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 16ll), 0, 4ll );
	*(struct $10LinkedNodeI3RECE**)THIS$1 = (struct $10LinkedNodeI3RECE*)0ull;
	*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI3RECE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	label$1955:;
}

static void _ZN10LinkedListI3RECEC1ERS1_( struct $10LinkedListI3RECE* THIS$1, struct $10LinkedListI3RECE* RHS$1 )
{
	label$1956:;
	__builtin_memset( (struct $10LinkedNodeI3RECE**)THIS$1, 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 16ll), 0, 4ll );
	*(struct $10LinkedNodeI3RECE**)THIS$1 = (struct $10LinkedNodeI3RECE*)0ull;
	*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI3RECE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	_ZN10LinkedListI3RECE8COPYFROMERS1_( THIS$1, RHS$1 );
	label$1957:;
}

static void _ZN10LinkedListI3RECED1Ev( struct $10LinkedListI3RECE* THIS$1 )
{
	label$1958:;
	_ZN10LinkedListI3RECE5CLEAREv( THIS$1 );
	label$1959:;
}

static void _ZN10LinkedListI3RECEaSERS1_( struct $10LinkedListI3RECE* THIS$1, struct $10LinkedListI3RECE* RHS$1 )
{
	label$1960:;
	if( RHS$1 != THIS$1) goto label$1963;
	{
		goto label$1961;
	}
	label$1963:;
	label$1962:;
	_ZN10LinkedListI3RECE5CLEAREv( THIS$1 );
	_ZN10LinkedListI3RECE8COPYFROMERS1_( THIS$1, RHS$1 );
	label$1961:;
}

static void _ZN10LinkedListI3RECE8COPYFROMERS1_( struct $10LinkedListI3RECE* THIS$1, struct $10LinkedListI3RECE* RHS$1 )
{
	label$1964:;
	struct $10LinkedNodeI3RECE* P$1;
	P$1 = *(struct $10LinkedNodeI3RECE**)RHS$1;
	label$1966:;
	if( P$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$1967;
	{
		_ZN10LinkedListI3RECE8PUSHBACKERS0_( THIS$1, (struct $3REC*)P$1 );
		P$1 = *(struct $10LinkedNodeI3RECE**)((uint8*)P$1 + 8ll);
	}
	goto label$1966;
	label$1967:;
	label$1965:;
}

static int32 _ZN10LinkedListI3RECE5COUNTEv( struct $10LinkedListI3RECE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$1968:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 16ll);
	goto label$1969;
	label$1969:;
	return fb$result$1;
}

static boolean _ZN10LinkedListI3RECE7ISEMPTYEv( struct $10LinkedListI3RECE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$1970:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 16ll) == 0ll) != 0ll);
	goto label$1971;
	label$1971:;
	return fb$result$1;
}

static void _ZN10LinkedListI3RECE9PUSHFRONTERS0_( struct $10LinkedListI3RECE* THIS$1, struct $3REC* V$1 )
{
	struct $10LinkedNodeI3RECE* TMP$351$1;
	label$1972:;
	struct $3REC VV$1;
	__builtin_memcpy( &VV$1, V$1, 8 );
	struct $10LinkedNodeI3RECE* N$1;
	void* vr$1 = calloc( 24ull, 1ull );
	TMP$351$1 = (struct $10LinkedNodeI3RECE*)vr$1;
	if( TMP$351$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$1974;
	label$1974:;
	N$1 = TMP$351$1;
	__builtin_memcpy( (struct $3REC*)N$1, &VV$1, 8 );
	*(struct $10LinkedNodeI3RECE**)((uint8*)N$1 + 16ll) = (struct $10LinkedNodeI3RECE*)0ull;
	*(struct $10LinkedNodeI3RECE**)((uint8*)N$1 + 8ll) = *(struct $10LinkedNodeI3RECE**)THIS$1;
	if( *(struct $10LinkedNodeI3RECE**)THIS$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$1976;
	{
		*(struct $10LinkedNodeI3RECE**)((uint8*)*(struct $10LinkedNodeI3RECE**)THIS$1 + 16ll) = N$1;
	}
	goto label$1975;
	label$1976:;
	{
		*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) = N$1;
	}
	label$1975:;
	*(struct $10LinkedNodeI3RECE**)THIS$1 = N$1;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + 1ll);
	label$1973:;
}

static void _ZN10LinkedListI3RECE8PUSHBACKERS0_( struct $10LinkedListI3RECE* THIS$1, struct $3REC* V$1 )
{
	struct $10LinkedNodeI3RECE* TMP$352$1;
	label$1977:;
	struct $3REC VV$1;
	__builtin_memcpy( &VV$1, V$1, 8 );
	struct $10LinkedNodeI3RECE* N$1;
	void* vr$1 = calloc( 24ull, 1ull );
	TMP$352$1 = (struct $10LinkedNodeI3RECE*)vr$1;
	if( TMP$352$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$1979;
	label$1979:;
	N$1 = TMP$352$1;
	__builtin_memcpy( (struct $3REC*)N$1, &VV$1, 8 );
	*(struct $10LinkedNodeI3RECE**)((uint8*)N$1 + 8ll) = (struct $10LinkedNodeI3RECE*)0ull;
	*(struct $10LinkedNodeI3RECE**)((uint8*)N$1 + 16ll) = *(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll);
	if( *(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) == (struct $10LinkedNodeI3RECE*)0ull) goto label$1981;
	{
		*(struct $10LinkedNodeI3RECE**)((uint8*)*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) + 8ll) = N$1;
	}
	goto label$1980;
	label$1981:;
	{
		*(struct $10LinkedNodeI3RECE**)THIS$1 = N$1;
	}
	label$1980:;
	*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) = N$1;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + 1ll);
	label$1978:;
}

static struct $3REC _ZN10LinkedListI3RECE8POPFRONTEv( struct $10LinkedListI3RECE* THIS$1 )
{
	struct $3REC fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1982:;
	struct $3REC R$1;
	__builtin_memset( &R$1, 0, 8ll );
	if( *(struct $10LinkedNodeI3RECE**)THIS$1 != (struct $10LinkedNodeI3RECE*)0ull) goto label$1985;
	{
		__builtin_memcpy( &fb$result$1, &R$1, 8 );
		goto label$1983;
	}
	label$1985:;
	label$1984:;
	struct $10LinkedNodeI3RECE* N$1;
	N$1 = *(struct $10LinkedNodeI3RECE**)THIS$1;
	__builtin_memcpy( &R$1, (struct $3REC*)N$1, 8 );
	*(struct $10LinkedNodeI3RECE**)THIS$1 = *(struct $10LinkedNodeI3RECE**)((uint8*)N$1 + 8ll);
	if( *(struct $10LinkedNodeI3RECE**)THIS$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$1987;
	{
		*(struct $10LinkedNodeI3RECE**)((uint8*)*(struct $10LinkedNodeI3RECE**)THIS$1 + 16ll) = (struct $10LinkedNodeI3RECE*)0ull;
	}
	goto label$1986;
	label$1987:;
	{
		*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI3RECE*)0ull;
	}
	label$1986:;
	if( N$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$1988;
	free( (void*)N$1 );
	label$1988:;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + -1ll);
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$1983;
	label$1983:;
	return fb$result$1;
}

static struct $3REC _ZN10LinkedListI3RECE7POPBACKEv( struct $10LinkedListI3RECE* THIS$1 )
{
	struct $3REC fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1989:;
	struct $3REC R$1;
	__builtin_memset( &R$1, 0, 8ll );
	if( *(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) != (struct $10LinkedNodeI3RECE*)0ull) goto label$1992;
	{
		__builtin_memcpy( &fb$result$1, &R$1, 8 );
		goto label$1990;
	}
	label$1992:;
	label$1991:;
	struct $10LinkedNodeI3RECE* N$1;
	N$1 = *(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll);
	__builtin_memcpy( &R$1, (struct $3REC*)N$1, 8 );
	*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) = *(struct $10LinkedNodeI3RECE**)((uint8*)N$1 + 16ll);
	if( *(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) == (struct $10LinkedNodeI3RECE*)0ull) goto label$1994;
	{
		*(struct $10LinkedNodeI3RECE**)((uint8*)*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) + 8ll) = (struct $10LinkedNodeI3RECE*)0ull;
	}
	goto label$1993;
	label$1994:;
	{
		*(struct $10LinkedNodeI3RECE**)THIS$1 = (struct $10LinkedNodeI3RECE*)0ull;
	}
	label$1993:;
	if( N$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$1995;
	free( (void*)N$1 );
	label$1995:;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + -1ll);
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$1990;
	label$1990:;
	return fb$result$1;
}

static struct $3REC* _ZN10LinkedListI3RECE5FRONTEv( struct $10LinkedListI3RECE* THIS$1 )
{
	struct $3REC* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1996:;
	static struct $3REC BLANK$1;
	if( *(struct $10LinkedNodeI3RECE**)THIS$1 != (struct $10LinkedNodeI3RECE*)0ull) goto label$1999;
	{
		fb$result$1 = &BLANK$1;
		goto label$1997;
	}
	label$1999:;
	label$1998:;
	fb$result$1 = (struct $3REC*)*(struct $10LinkedNodeI3RECE**)THIS$1;
	goto label$1997;
	label$1997:;
	return fb$result$1;
}

static struct $3REC* _ZN10LinkedListI3RECE4BACKEv( struct $10LinkedListI3RECE* THIS$1 )
{
	struct $3REC* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2000:;
	static struct $3REC BLANK$1;
	if( *(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) != (struct $10LinkedNodeI3RECE*)0ull) goto label$2003;
	{
		fb$result$1 = &BLANK$1;
		goto label$2001;
	}
	label$2003:;
	label$2002:;
	fb$result$1 = (struct $3REC*)*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll);
	goto label$2001;
	label$2001:;
	return fb$result$1;
}

static void _ZN10LinkedListI3RECE5CLEAREv( struct $10LinkedListI3RECE* THIS$1 )
{
	label$2004:;
	struct $10LinkedNodeI3RECE* P$1;
	P$1 = *(struct $10LinkedNodeI3RECE**)THIS$1;
	label$2006:;
	if( P$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$2007;
	{
		struct $10LinkedNodeI3RECE* NXT$2;
		NXT$2 = *(struct $10LinkedNodeI3RECE**)((uint8*)P$1 + 8ll);
		if( P$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$2008;
		free( (void*)P$1 );
		label$2008:;
		P$1 = NXT$2;
	}
	goto label$2006;
	label$2007:;
	*(struct $10LinkedNodeI3RECE**)THIS$1 = (struct $10LinkedNodeI3RECE*)0ull;
	*(struct $10LinkedNodeI3RECE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI3RECE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	label$2005:;
}

static struct $18LinkedListIteratorI3RECE _ZN10LinkedListI3RECE11GETITERATOREv( struct $10LinkedListI3RECE* THIS$1 )
{
	struct $18LinkedListIteratorI3RECE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2009:;
	struct $18LinkedListIteratorI3RECE IT$1;
	__builtin_memset( &IT$1, 0, 8ll );
	*(void**)&IT$1 = *(void**)THIS$1;
	__builtin_memcpy( &fb$result$1, &IT$1, 8 );
	goto label$2010;
	label$2010:;
	return fb$result$1;
}

static void _Z8SortListI3RECER10LinkedListI3RECE( struct $10LinkedListI3RECE* L$1 )
{
	label$2011:;
	typedef boolean (*_Z7tmp$353R3RECS0_)( struct $3REC*, struct $3REC* );
	_Z7tmp$353R3RECS0_ LESS$1;
	LESS$1 = (_Z7tmp$353R3RECS0_)&L3C22B1CEA777A486_LT_0162;
	_Z10SortListByI3RECPFbR3RECR3RECEER10LinkedListI3RECERS6_( L$1, (tmp$149*)&LESS$1 );
	label$2012:;
}

boolean L3C22B1CEA777A486_LT_0162( struct $3REC* X$1, struct $3REC* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$2013:;
	boolean vr$1 = _ZltR3RECS0_( X$1, Y$1 );
	fb$result$1 = vr$1;
	goto label$2014;
	label$2014:;
	return fb$result$1;
}

static void _Z10SortListByI3RECPFbR3RECR3RECEER10LinkedListI3RECERS6_( struct $10LinkedListI3RECE* L$1, tmp$149* LESS$1 )
{
	label$2015:;
	if( (int64)*(int32*)((uint8*)L$1 + 16ll) >= 2ll) goto label$2018;
	{
		goto label$2016;
	}
	label$2018:;
	label$2017:;
	struct $10LinkedNodeI3RECE* HEAD$1;
	HEAD$1 = *(struct $10LinkedNodeI3RECE**)L$1;
	struct $10LinkedNodeI3RECE* TAIL$1;
	TAIL$1 = (struct $10LinkedNodeI3RECE*)0ull;
	int32 RUNW$1;
	RUNW$1 = 1;
	label$2019:;
	{
		struct $10LinkedNodeI3RECE* P$2;
		P$2 = HEAD$1;
		struct $10LinkedNodeI3RECE* NEWHEAD$2;
		NEWHEAD$2 = (struct $10LinkedNodeI3RECE*)0ull;
		int32 MERGES$2;
		MERGES$2 = 0;
		TAIL$1 = (struct $10LinkedNodeI3RECE*)0ull;
		label$2022:;
		if( P$2 == (struct $10LinkedNodeI3RECE*)0ull) goto label$2023;
		{
			int64 TMP$355$3;
			MERGES$2 = (int32)((int64)MERGES$2 + 1ll);
			struct $10LinkedNodeI3RECE* Q$3;
			Q$3 = P$2;
			int32 PSIZE$3;
			PSIZE$3 = 0;
			label$2024:;
			if( (int64)PSIZE$3 >= (int64)RUNW$1) goto label$2026;
			TMP$355$3 = (int64)-(Q$3 != (struct $10LinkedNodeI3RECE*)0ull);
			goto label$2043;
			label$2026:;
			TMP$355$3 = 0ll;
			label$2043:;
			if( TMP$355$3 == 0ll) goto label$2025;
			{
				PSIZE$3 = (int32)((int64)PSIZE$3 + 1ll);
				Q$3 = *(struct $10LinkedNodeI3RECE**)((uint8*)Q$3 + 8ll);
			}
			goto label$2024;
			label$2025:;
			int32 QSIZE$3;
			QSIZE$3 = RUNW$1;
			label$2027:;
			{
				int64 TMP$356$4;
				boolean TMP$357$4;
				boolean PLEFT$4;
				PLEFT$4 = (boolean)((int64)-((int64)PSIZE$3 > 0ll) != 0ll);
				boolean QLEFT$4;
				if( (int64)QSIZE$3 <= 0ll) goto label$2030;
				TMP$356$4 = (int64)-(Q$3 != (struct $10LinkedNodeI3RECE*)0ull);
				goto label$2044;
				label$2030:;
				TMP$356$4 = 0ll;
				label$2044:;
				QLEFT$4 = (boolean)(TMP$356$4 != 0ll);
				if( PLEFT$4 != (boolean)0ll) goto label$2031;
				TMP$357$4 = (boolean)(QLEFT$4 != (boolean)0ll);
				goto label$2045;
				label$2031:;
				TMP$357$4 = (boolean)1ll;
				label$2045:;
				if( TMP$357$4 != (boolean)0ll) goto label$2033;
				{
					goto label$2028;
				}
				label$2033:;
				label$2032:;
				struct $10LinkedNodeI3RECE* E$4;
				__builtin_memset( &E$4, 0, 8ll );
				if( PLEFT$4 != (boolean)0ll) goto label$2035;
				{
					E$4 = Q$3;
					Q$3 = *(struct $10LinkedNodeI3RECE**)((uint8*)Q$3 + 8ll);
					QSIZE$3 = (int32)((int64)QSIZE$3 + -1ll);
				}
				goto label$2034;
				label$2035:;
				if( QLEFT$4 != (boolean)0ll) goto label$2036;
				{
					E$4 = P$2;
					P$2 = *(struct $10LinkedNodeI3RECE**)((uint8*)P$2 + 8ll);
					PSIZE$3 = (int32)((int64)PSIZE$3 + -1ll);
				}
				goto label$2034;
				label$2036:;
				{
					boolean TAKEQ$5;
					boolean vr$33 = (*LESS$1)( (struct $3REC*)Q$3, (struct $3REC*)P$2 );
					TAKEQ$5 = vr$33;
					if( TAKEQ$5 == (boolean)0ll) goto label$2038;
					{
						E$4 = Q$3;
						Q$3 = *(struct $10LinkedNodeI3RECE**)((uint8*)Q$3 + 8ll);
						QSIZE$3 = (int32)((int64)QSIZE$3 + -1ll);
					}
					goto label$2037;
					label$2038:;
					{
						E$4 = P$2;
						P$2 = *(struct $10LinkedNodeI3RECE**)((uint8*)P$2 + 8ll);
						PSIZE$3 = (int32)((int64)PSIZE$3 + -1ll);
					}
					label$2037:;
				}
				label$2034:;
				if( TAIL$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$2040;
				{
					*(struct $10LinkedNodeI3RECE**)((uint8*)TAIL$1 + 8ll) = E$4;
				}
				goto label$2039;
				label$2040:;
				{
					NEWHEAD$2 = E$4;
				}
				label$2039:;
				*(struct $10LinkedNodeI3RECE**)((uint8*)E$4 + 16ll) = TAIL$1;
				TAIL$1 = E$4;
			}
			label$2029:;
			goto label$2027;
			label$2028:;
			P$2 = Q$3;
		}
		goto label$2022;
		label$2023:;
		*(struct $10LinkedNodeI3RECE**)((uint8*)TAIL$1 + 8ll) = (struct $10LinkedNodeI3RECE*)0ull;
		HEAD$1 = NEWHEAD$2;
		if( (int64)MERGES$2 > 1ll) goto label$2042;
		{
			goto label$2020;
		}
		label$2042:;
		label$2041:;
		RUNW$1 = (int32)((int64)RUNW$1 << (1ll & 63ll));
	}
	label$2021:;
	goto label$2019;
	label$2020:;
	*(struct $10LinkedNodeI3RECE**)L$1 = HEAD$1;
	*(struct $10LinkedNodeI3RECE**)((uint8*)L$1 + 8ll) = TAIL$1;
	label$2016:;
}

static boolean _ZN18LinkedListIteratorI7COUNTEDE7ISVALIDEv( struct $18LinkedListIteratorI7COUNTEDE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$2072:;
	fb$result$1 = (boolean)((int64)-(*(void**)THIS$1 != (void*)0ull) != 0ll);
	goto label$2073;
	label$2073:;
	return fb$result$1;
}

static struct $7COUNTED* _ZN18LinkedListIteratorI7COUNTEDE5VALUEEv( struct $18LinkedListIteratorI7COUNTEDE* THIS$1 )
{
	struct $7COUNTED* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2074:;
	struct $10LinkedNodeI7COUNTEDE* N$1;
	N$1 = *(struct $10LinkedNodeI7COUNTEDE**)THIS$1;
	fb$result$1 = (struct $7COUNTED*)N$1;
	goto label$2075;
	label$2075:;
	return fb$result$1;
}

static void _ZN18LinkedListIteratorI7COUNTEDE8MOVENEXTEv( struct $18LinkedListIteratorI7COUNTEDE* THIS$1 )
{
	label$2076:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$2079;
	{
		goto label$2077;
		label$2079:;
	}
	struct $10LinkedNodeI7COUNTEDE* N$1;
	N$1 = *(struct $10LinkedNodeI7COUNTEDE**)THIS$1;
	*(void**)THIS$1 = *(void**)((uint8*)N$1 + 8ll);
	label$2077:;
}

static void _ZN10LinkedListI7COUNTEDEC1Ev( struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	label$2080:;
	__builtin_memset( (struct $10LinkedNodeI7COUNTEDE**)THIS$1, 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 16ll), 0, 4ll );
	*(struct $10LinkedNodeI7COUNTEDE**)THIS$1 = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	label$2081:;
}

static void _ZN10LinkedListI7COUNTEDEC1ERS1_( struct $10LinkedListI7COUNTEDE* THIS$1, struct $10LinkedListI7COUNTEDE* RHS$1 )
{
	label$2082:;
	__builtin_memset( (struct $10LinkedNodeI7COUNTEDE**)THIS$1, 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 16ll), 0, 4ll );
	*(struct $10LinkedNodeI7COUNTEDE**)THIS$1 = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	_ZN10LinkedListI7COUNTEDE8COPYFROMERS1_( THIS$1, RHS$1 );
	label$2083:;
}

static void _ZN10LinkedListI7COUNTEDED1Ev( struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	label$2084:;
	_ZN10LinkedListI7COUNTEDE5CLEAREv( THIS$1 );
	label$2085:;
}

static void _ZN10LinkedListI7COUNTEDEaSERS1_( struct $10LinkedListI7COUNTEDE* THIS$1, struct $10LinkedListI7COUNTEDE* RHS$1 )
{
	label$2086:;
	if( RHS$1 != THIS$1) goto label$2089;
	{
		goto label$2087;
	}
	label$2089:;
	label$2088:;
	_ZN10LinkedListI7COUNTEDE5CLEAREv( THIS$1 );
	_ZN10LinkedListI7COUNTEDE8COPYFROMERS1_( THIS$1, RHS$1 );
	label$2087:;
}

static void _ZN10LinkedListI7COUNTEDE8COPYFROMERS1_( struct $10LinkedListI7COUNTEDE* THIS$1, struct $10LinkedListI7COUNTEDE* RHS$1 )
{
	label$2090:;
	struct $10LinkedNodeI7COUNTEDE* P$1;
	P$1 = *(struct $10LinkedNodeI7COUNTEDE**)RHS$1;
	label$2092:;
	if( P$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2093;
	{
		_ZN10LinkedListI7COUNTEDE8PUSHBACKERS0_( THIS$1, (struct $7COUNTED*)P$1 );
		P$1 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)P$1 + 8ll);
	}
	goto label$2092;
	label$2093:;
	label$2091:;
}

static int32 _ZN10LinkedListI7COUNTEDE5COUNTEv( struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$2094:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 16ll);
	goto label$2095;
	label$2095:;
	return fb$result$1;
}

static boolean _ZN10LinkedListI7COUNTEDE7ISEMPTYEv( struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$2096:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 16ll) == 0ll) != 0ll);
	goto label$2097;
	label$2097:;
	return fb$result$1;
}

static void _ZN10LinkedListI7COUNTEDE9PUSHFRONTERS0_( struct $10LinkedListI7COUNTEDE* THIS$1, struct $7COUNTED* V$1 )
{
	struct $10LinkedNodeI7COUNTEDE* TMP$360$1;
	label$2098:;
	struct $7COUNTED VV$1;
	_ZN7COUNTEDC1ERS_( &VV$1, V$1 );
	struct $10LinkedNodeI7COUNTEDE* N$1;
	void* vr$1 = calloc( 24ull, 1ull );
	TMP$360$1 = (struct $10LinkedNodeI7COUNTEDE*)vr$1;
	if( TMP$360$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2100;
	_ZN10LinkedNodeI7COUNTEDEC1Ev( TMP$360$1 );
	label$2100:;
	N$1 = TMP$360$1;
	_ZN7COUNTEDaSERS_( (struct $7COUNTED*)N$1, &VV$1 );
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)N$1 + 16ll) = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)N$1 + 8ll) = *(struct $10LinkedNodeI7COUNTEDE**)THIS$1;
	if( *(struct $10LinkedNodeI7COUNTEDE**)THIS$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2102;
	{
		*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)*(struct $10LinkedNodeI7COUNTEDE**)THIS$1 + 16ll) = N$1;
	}
	goto label$2101;
	label$2102:;
	{
		*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) = N$1;
	}
	label$2101:;
	*(struct $10LinkedNodeI7COUNTEDE**)THIS$1 = N$1;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + 1ll);
	_ZN7COUNTEDD1Ev( &VV$1 );
	label$2099:;
}

static void _ZN10LinkedListI7COUNTEDE8PUSHBACKERS0_( struct $10LinkedListI7COUNTEDE* THIS$1, struct $7COUNTED* V$1 )
{
	struct $10LinkedNodeI7COUNTEDE* TMP$362$1;
	label$2103:;
	struct $7COUNTED VV$1;
	_ZN7COUNTEDC1ERS_( &VV$1, V$1 );
	struct $10LinkedNodeI7COUNTEDE* N$1;
	void* vr$1 = calloc( 24ull, 1ull );
	TMP$362$1 = (struct $10LinkedNodeI7COUNTEDE*)vr$1;
	if( TMP$362$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2105;
	_ZN10LinkedNodeI7COUNTEDEC1Ev( TMP$362$1 );
	label$2105:;
	N$1 = TMP$362$1;
	_ZN7COUNTEDaSERS_( (struct $7COUNTED*)N$1, &VV$1 );
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)N$1 + 8ll) = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)N$1 + 16ll) = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll);
	if( *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2107;
	{
		*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) + 8ll) = N$1;
	}
	goto label$2106;
	label$2107:;
	{
		*(struct $10LinkedNodeI7COUNTEDE**)THIS$1 = N$1;
	}
	label$2106:;
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) = N$1;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + 1ll);
	_ZN7COUNTEDD1Ev( &VV$1 );
	label$2104:;
}

static struct $7COUNTED* _ZN10LinkedListI7COUNTEDE8POPFRONTEv( struct $7COUNTED* tmp$364$1, struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	label$2108:;
	struct $7COUNTED R$1;
	_ZN7COUNTEDC1Ev( &R$1 );
	if( *(struct $10LinkedNodeI7COUNTEDE**)THIS$1 != (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2111;
	{
		_ZN7COUNTEDC1ERS_( tmp$364$1, &R$1 );
		_ZN7COUNTEDD1Ev( &R$1 );
		goto label$2109;
	}
	label$2111:;
	label$2110:;
	struct $10LinkedNodeI7COUNTEDE* N$1;
	N$1 = *(struct $10LinkedNodeI7COUNTEDE**)THIS$1;
	_ZN7COUNTEDaSERS_( &R$1, (struct $7COUNTED*)N$1 );
	*(struct $10LinkedNodeI7COUNTEDE**)THIS$1 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)N$1 + 8ll);
	if( *(struct $10LinkedNodeI7COUNTEDE**)THIS$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2113;
	{
		*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)*(struct $10LinkedNodeI7COUNTEDE**)THIS$1 + 16ll) = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	}
	goto label$2112;
	label$2113:;
	{
		*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	}
	label$2112:;
	if( N$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2114;
	_ZN10LinkedNodeI7COUNTEDED1Ev( N$1 );
	free( (void*)N$1 );
	label$2114:;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + -1ll);
	_ZN7COUNTEDC1ERS_( tmp$364$1, &R$1 );
	_ZN7COUNTEDD1Ev( &R$1 );
	goto label$2109;
	_ZN7COUNTEDD1Ev( &R$1 );
	label$2109:;
	return tmp$364$1;
}

static struct $7COUNTED* _ZN10LinkedListI7COUNTEDE7POPBACKEv( struct $7COUNTED* tmp$365$1, struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	label$2115:;
	struct $7COUNTED R$1;
	_ZN7COUNTEDC1Ev( &R$1 );
	if( *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) != (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2118;
	{
		_ZN7COUNTEDC1ERS_( tmp$365$1, &R$1 );
		_ZN7COUNTEDD1Ev( &R$1 );
		goto label$2116;
	}
	label$2118:;
	label$2117:;
	struct $10LinkedNodeI7COUNTEDE* N$1;
	N$1 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll);
	_ZN7COUNTEDaSERS_( &R$1, (struct $7COUNTED*)N$1 );
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)N$1 + 16ll);
	if( *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2120;
	{
		*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) + 8ll) = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	}
	goto label$2119;
	label$2120:;
	{
		*(struct $10LinkedNodeI7COUNTEDE**)THIS$1 = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	}
	label$2119:;
	if( N$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2121;
	_ZN10LinkedNodeI7COUNTEDED1Ev( N$1 );
	free( (void*)N$1 );
	label$2121:;
	*(int32*)((uint8*)THIS$1 + 16ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 16ll) + -1ll);
	_ZN7COUNTEDC1ERS_( tmp$365$1, &R$1 );
	_ZN7COUNTEDD1Ev( &R$1 );
	goto label$2116;
	_ZN7COUNTEDD1Ev( &R$1 );
	label$2116:;
	return tmp$365$1;
}

static void _ZN10LinkedListI7COUNTEDE10LABEL$2124Ev( void )
{
	label$2129:;
	_ZN7COUNTEDD1Ev( &tmp$367 );
	label$2130:;
}

static struct $7COUNTED* _ZN10LinkedListI7COUNTEDE5FRONTEv( struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	struct $7COUNTED* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2122:;
	static int64 LABEL$2125$1;
	if( LABEL$2125$1 != 0ll) goto label$2126;
	LABEL$2125$1 = 1ll;
	_ZN7COUNTEDC1Ev( &tmp$367 );
	atexit( (void*)&_ZN10LinkedListI7COUNTEDE10LABEL$2124Ev );
	label$2126:;
	if( *(struct $10LinkedNodeI7COUNTEDE**)THIS$1 != (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2128;
	{
		fb$result$1 = &tmp$367;
		goto label$2123;
	}
	label$2128:;
	label$2127:;
	fb$result$1 = (struct $7COUNTED*)*(struct $10LinkedNodeI7COUNTEDE**)THIS$1;
	goto label$2123;
	label$2123:;
	return fb$result$1;
}

static void _ZN10LinkedListI7COUNTEDE10LABEL$2133Ev( void )
{
	label$2138:;
	_ZN7COUNTEDD1Ev( &tmp$369 );
	label$2139:;
}

static struct $7COUNTED* _ZN10LinkedListI7COUNTEDE4BACKEv( struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	struct $7COUNTED* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2131:;
	static int64 LABEL$2134$1;
	if( LABEL$2134$1 != 0ll) goto label$2135;
	LABEL$2134$1 = 1ll;
	_ZN7COUNTEDC1Ev( &tmp$369 );
	atexit( (void*)&_ZN10LinkedListI7COUNTEDE10LABEL$2133Ev );
	label$2135:;
	if( *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) != (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2137;
	{
		fb$result$1 = &tmp$369;
		goto label$2132;
	}
	label$2137:;
	label$2136:;
	fb$result$1 = (struct $7COUNTED*)*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll);
	goto label$2132;
	label$2132:;
	return fb$result$1;
}

static void _ZN10LinkedListI7COUNTEDE5CLEAREv( struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	label$2140:;
	struct $10LinkedNodeI7COUNTEDE* P$1;
	P$1 = *(struct $10LinkedNodeI7COUNTEDE**)THIS$1;
	label$2142:;
	if( P$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2143;
	{
		struct $10LinkedNodeI7COUNTEDE* NXT$2;
		NXT$2 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)P$1 + 8ll);
		if( P$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2144;
		_ZN10LinkedNodeI7COUNTEDED1Ev( P$1 );
		free( (void*)P$1 );
		label$2144:;
		P$1 = NXT$2;
	}
	goto label$2142;
	label$2143:;
	*(struct $10LinkedNodeI7COUNTEDE**)THIS$1 = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	*(int32*)((uint8*)THIS$1 + 16ll) = 0;
	label$2141:;
}

static struct $18LinkedListIteratorI7COUNTEDE _ZN10LinkedListI7COUNTEDE11GETITERATOREv( struct $10LinkedListI7COUNTEDE* THIS$1 )
{
	struct $18LinkedListIteratorI7COUNTEDE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2145:;
	struct $18LinkedListIteratorI7COUNTEDE IT$1;
	__builtin_memset( &IT$1, 0, 8ll );
	*(void**)&IT$1 = *(void**)THIS$1;
	__builtin_memcpy( &fb$result$1, &IT$1, 8 );
	goto label$2146;
	label$2146:;
	return fb$result$1;
}

static void _Z8SortListI7COUNTEDER10LinkedListI7COUNTEDE( struct $10LinkedListI7COUNTEDE* L$1 )
{
	label$2147:;
	typedef boolean (*_Z7tmp$370R7COUNTEDS0_)( struct $7COUNTED*, struct $7COUNTED* );
	_Z7tmp$370R7COUNTEDS0_ LESS$1;
	LESS$1 = (_Z7tmp$370R7COUNTEDS0_)&L3C22B1CEA777A486_LT_0173;
	_Z10SortListByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER10LinkedListI7COUNTEDERS6_( L$1, (tmp$275*)&LESS$1 );
	label$2148:;
}

boolean L3C22B1CEA777A486_LT_0173( struct $7COUNTED* X$1, struct $7COUNTED* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$2149:;
	boolean vr$1 = _ZltR7COUNTEDS0_( X$1, Y$1 );
	fb$result$1 = vr$1;
	goto label$2150;
	label$2150:;
	return fb$result$1;
}

static void _Z10SortListByI7COUNTEDPFbR7COUNTEDR7COUNTEDEER10LinkedListI7COUNTEDERS6_( struct $10LinkedListI7COUNTEDE* L$1, tmp$275* LESS$1 )
{
	label$2151:;
	if( (int64)*(int32*)((uint8*)L$1 + 16ll) >= 2ll) goto label$2154;
	{
		goto label$2152;
	}
	label$2154:;
	label$2153:;
	struct $10LinkedNodeI7COUNTEDE* HEAD$1;
	HEAD$1 = *(struct $10LinkedNodeI7COUNTEDE**)L$1;
	struct $10LinkedNodeI7COUNTEDE* TAIL$1;
	TAIL$1 = (struct $10LinkedNodeI7COUNTEDE*)0ull;
	int32 RUNW$1;
	RUNW$1 = 1;
	label$2155:;
	{
		struct $10LinkedNodeI7COUNTEDE* P$2;
		P$2 = HEAD$1;
		struct $10LinkedNodeI7COUNTEDE* NEWHEAD$2;
		NEWHEAD$2 = (struct $10LinkedNodeI7COUNTEDE*)0ull;
		int32 MERGES$2;
		MERGES$2 = 0;
		TAIL$1 = (struct $10LinkedNodeI7COUNTEDE*)0ull;
		label$2158:;
		if( P$2 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2159;
		{
			int64 TMP$372$3;
			MERGES$2 = (int32)((int64)MERGES$2 + 1ll);
			struct $10LinkedNodeI7COUNTEDE* Q$3;
			Q$3 = P$2;
			int32 PSIZE$3;
			PSIZE$3 = 0;
			label$2160:;
			if( (int64)PSIZE$3 >= (int64)RUNW$1) goto label$2162;
			TMP$372$3 = (int64)-(Q$3 != (struct $10LinkedNodeI7COUNTEDE*)0ull);
			goto label$2179;
			label$2162:;
			TMP$372$3 = 0ll;
			label$2179:;
			if( TMP$372$3 == 0ll) goto label$2161;
			{
				PSIZE$3 = (int32)((int64)PSIZE$3 + 1ll);
				Q$3 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)Q$3 + 8ll);
			}
			goto label$2160;
			label$2161:;
			int32 QSIZE$3;
			QSIZE$3 = RUNW$1;
			label$2163:;
			{
				int64 TMP$373$4;
				boolean TMP$374$4;
				boolean PLEFT$4;
				PLEFT$4 = (boolean)((int64)-((int64)PSIZE$3 > 0ll) != 0ll);
				boolean QLEFT$4;
				if( (int64)QSIZE$3 <= 0ll) goto label$2166;
				TMP$373$4 = (int64)-(Q$3 != (struct $10LinkedNodeI7COUNTEDE*)0ull);
				goto label$2180;
				label$2166:;
				TMP$373$4 = 0ll;
				label$2180:;
				QLEFT$4 = (boolean)(TMP$373$4 != 0ll);
				if( PLEFT$4 != (boolean)0ll) goto label$2167;
				TMP$374$4 = (boolean)(QLEFT$4 != (boolean)0ll);
				goto label$2181;
				label$2167:;
				TMP$374$4 = (boolean)1ll;
				label$2181:;
				if( TMP$374$4 != (boolean)0ll) goto label$2169;
				{
					goto label$2164;
				}
				label$2169:;
				label$2168:;
				struct $10LinkedNodeI7COUNTEDE* E$4;
				__builtin_memset( &E$4, 0, 8ll );
				if( PLEFT$4 != (boolean)0ll) goto label$2171;
				{
					E$4 = Q$3;
					Q$3 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)Q$3 + 8ll);
					QSIZE$3 = (int32)((int64)QSIZE$3 + -1ll);
				}
				goto label$2170;
				label$2171:;
				if( QLEFT$4 != (boolean)0ll) goto label$2172;
				{
					E$4 = P$2;
					P$2 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)P$2 + 8ll);
					PSIZE$3 = (int32)((int64)PSIZE$3 + -1ll);
				}
				goto label$2170;
				label$2172:;
				{
					boolean TAKEQ$5;
					boolean vr$33 = (*LESS$1)( (struct $7COUNTED*)Q$3, (struct $7COUNTED*)P$2 );
					TAKEQ$5 = vr$33;
					if( TAKEQ$5 == (boolean)0ll) goto label$2174;
					{
						E$4 = Q$3;
						Q$3 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)Q$3 + 8ll);
						QSIZE$3 = (int32)((int64)QSIZE$3 + -1ll);
					}
					goto label$2173;
					label$2174:;
					{
						E$4 = P$2;
						P$2 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)P$2 + 8ll);
						PSIZE$3 = (int32)((int64)PSIZE$3 + -1ll);
					}
					label$2173:;
				}
				label$2170:;
				if( TAIL$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2176;
				{
					*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)TAIL$1 + 8ll) = E$4;
				}
				goto label$2175;
				label$2176:;
				{
					NEWHEAD$2 = E$4;
				}
				label$2175:;
				*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)E$4 + 16ll) = TAIL$1;
				TAIL$1 = E$4;
			}
			label$2165:;
			goto label$2163;
			label$2164:;
			P$2 = Q$3;
		}
		goto label$2158;
		label$2159:;
		*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)TAIL$1 + 8ll) = (struct $10LinkedNodeI7COUNTEDE*)0ull;
		HEAD$1 = NEWHEAD$2;
		if( (int64)MERGES$2 > 1ll) goto label$2178;
		{
			goto label$2156;
		}
		label$2178:;
		label$2177:;
		RUNW$1 = (int32)((int64)RUNW$1 << (1ll & 63ll));
	}
	label$2157:;
	goto label$2155;
	label$2156:;
	*(struct $10LinkedNodeI7COUNTEDE**)L$1 = HEAD$1;
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)L$1 + 8ll) = TAIL$1;
	label$2152:;
}

static boolean _ZN13ArrayIteratorI5ArrayIiEE7ISVALIDEv( struct $13ArrayIteratorI5ArrayIiEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$2204:;
	struct $5ArrayI5ArrayIiEE* A$1;
	A$1 = *(struct $5ArrayI5ArrayIiEE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$2205;
	label$2205:;
	return fb$result$1;
}

static struct $5ArrayIiE* _ZN13ArrayIteratorI5ArrayIiEE5VALUEEv( struct $13ArrayIteratorI5ArrayIiEE* THIS$1 )
{
	struct $5ArrayIiE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2206:;
	struct $5ArrayI5ArrayIiEE* A$1;
	A$1 = *(struct $5ArrayI5ArrayIiEE**)THIS$1;
	fb$result$1 = (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) * 80ll));
	goto label$2207;
	label$2207:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorI5ArrayIiEE8MOVENEXTEv( struct $13ArrayIteratorI5ArrayIiEE* THIS$1 )
{
	label$2208:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$2209:;
}

static int32 _ZN5ArrayI5ArrayIiEE5COUNTEv( struct $5ArrayI5ArrayIiEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$2210:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$2211;
	label$2211:;
	return fb$result$1;
}

static int32 _ZN5ArrayI5ArrayIiEE8CAPACITYEv( struct $5ArrayI5ArrayIiEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$2212:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$2213;
	label$2213:;
	return fb$result$1;
}

static boolean _ZN5ArrayI5ArrayIiEE7ISEMPTYEv( struct $5ArrayI5ArrayIiEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$2214:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$2215;
	label$2215:;
	return fb$result$1;
}

static void _ZN5ArrayI5ArrayIiEE7RESERVEEi( struct $5ArrayI5ArrayIiEE* THIS$1, int32 N$1 )
{
	label$2216:;
	int32 vr$1 = _ZN5ArrayI5ArrayIiEE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$2219;
	{
		goto label$2217;
	}
	label$2219:;
	label$2218:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayI5ArrayIiEE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$2221;
	{
		CAP$1 = 8;
	}
	label$2221:;
	label$2220:;
	label$2222:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$2223;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$2222;
	label$2223:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 80ull, (void*)&_ZN5ArrayIiEC1Ev, (void*)&_ZN5ArrayIiED1Ev, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$2217:;
}

static void _ZN5ArrayI5ArrayIiEE6SHRINKEv( struct $5ArrayI5ArrayIiEE* THIS$1 )
{
	label$2224:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$2227;
	{
		fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN5ArrayIiEC1Ev, (void*)&_ZN5ArrayIiED1Ev );
		goto label$2225;
	}
	label$2227:;
	label$2226:;
	int32 vr$6 = _ZN5ArrayI5ArrayIiEE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$2229;
	{
		goto label$2225;
	}
	label$2229:;
	label$2228:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 80ull, (void*)&_ZN5ArrayIiEC1Ev, (void*)&_ZN5ArrayIiED1Ev, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$2225:;
}

static struct $5ArrayIiE* _ZN5ArrayI5ArrayIiEEixEi( struct $5ArrayI5ArrayIiEE* THIS$1, int32 I$1 )
{
	struct $5ArrayIiE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2230:;
	fb$result$1 = (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)I$1 * 80ll));
	goto label$2231;
	label$2231:;
	return fb$result$1;
}

static struct $5ArrayIiE* _ZN5ArrayI5ArrayIiEE2ATEi( struct $5ArrayI5ArrayIiEE* THIS$1, int32 I$1 )
{
	struct $5ArrayIiE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2232:;
	fb$result$1 = (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)I$1 * 80ll));
	goto label$2233;
	label$2233:;
	return fb$result$1;
}

static void _ZN5ArrayI5ArrayIiEE4PUSHERS1_( struct $5ArrayI5ArrayIiEE* THIS$1, struct $5ArrayIiE* V$1 )
{
	label$2234:;
	_ZN5ArrayI5ArrayIiEE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	_ZN5ArrayIiEaSERKS0_( (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 80ll)), (struct $5ArrayIiE*)V$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$2235:;
}

static struct $5ArrayIiE* _ZN5ArrayI5ArrayIiEE3POPEv( struct $5ArrayIiE* tmp$387$1, struct $5ArrayI5ArrayIiEE* THIS$1 )
{
	label$2236:;
	struct $5ArrayIiE R$1;
	_ZN5ArrayIiEC1Ev( &R$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$2239;
	{
		_ZN5ArrayIiEC1ERKS0_( tmp$387$1, (struct $5ArrayIiE*)&R$1 );
		_ZN5ArrayIiED1Ev( &R$1 );
		goto label$2237;
	}
	label$2239:;
	label$2238:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	_ZN5ArrayIiEaSERKS0_( &R$1, (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 80ll)) );
	_ZN5ArrayIiEC1ERKS0_( tmp$387$1, (struct $5ArrayIiE*)&R$1 );
	_ZN5ArrayIiED1Ev( &R$1 );
	goto label$2237;
	_ZN5ArrayIiED1Ev( &R$1 );
	label$2237:;
	return tmp$387$1;
}

static void _ZN5ArrayI5ArrayIiEE6INSERTEiRS1_( struct $5ArrayI5ArrayIiEE* THIS$1, int32 I$1, struct $5ArrayIiE* V$1 )
{
	int64 TMP$388$1;
	label$2240:;
	if( (int64)I$1 < 0ll) goto label$2242;
	TMP$388$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$2249;
	label$2242:;
	TMP$388$1 = -1ll;
	label$2249:;
	if( TMP$388$1 == 0ll) goto label$2244;
	{
		goto label$2241;
	}
	label$2244:;
	label$2243:;
	struct $5ArrayIiE TMP$1;
	_ZN5ArrayIiEC1ERKS0_( &TMP$1, (struct $5ArrayIiE*)V$1 );
	_ZN5ArrayI5ArrayIiEE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$389$2;
		TMP$389$2 = (int32)((int64)I$1 + 1ll);
		goto label$2245;
		label$2248:;
		{
			_ZN5ArrayIiEaSERKS0_( (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)K$2 * 80ll)), (struct $5ArrayIiE*)((uint8*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)K$2 * 80ll)) + -80ll) );
		}
		label$2246:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$2245:;
		if( (int64)K$2 >= (int64)TMP$389$2) goto label$2248;
		label$2247:;
	}
	_ZN5ArrayIiEaSERKS0_( (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)I$1 * 80ll)), (struct $5ArrayIiE*)&TMP$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	_ZN5ArrayIiED1Ev( &TMP$1 );
	label$2241:;
}

static void _ZN5ArrayI5ArrayIiEE6REMOVEEi( struct $5ArrayI5ArrayIiEE* THIS$1, int32 I$1 )
{
	int64 TMP$390$1;
	label$2250:;
	if( (int64)I$1 < 0ll) goto label$2252;
	TMP$390$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$2259;
	label$2252:;
	TMP$390$1 = -1ll;
	label$2259:;
	if( TMP$390$1 == 0ll) goto label$2254;
	{
		goto label$2251;
	}
	label$2254:;
	label$2253:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$391$2;
		TMP$391$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$2255;
		label$2258:;
		{
			_ZN5ArrayIiEaSERKS0_( (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)K$2 * 80ll)), (struct $5ArrayIiE*)((uint8*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)K$2 * 80ll)) + 80ll) );
		}
		label$2256:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$2255:;
		if( (int64)K$2 <= (int64)TMP$391$2) goto label$2258;
		label$2257:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$2251:;
}

static void _ZN5ArrayI5ArrayIiEE10REMOVESWAPEi( struct $5ArrayI5ArrayIiEE* THIS$1, int32 I$1 )
{
	int64 TMP$392$1;
	label$2260:;
	if( (int64)I$1 < 0ll) goto label$2262;
	TMP$392$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$2267;
	label$2262:;
	TMP$392$1 = -1ll;
	label$2267:;
	if( TMP$392$1 == 0ll) goto label$2264;
	{
		goto label$2261;
	}
	label$2264:;
	label$2263:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$2266;
	{
		_ZN5ArrayIiEaSERKS0_( (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)I$1 * 80ll)), (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 80ll)) );
	}
	label$2266:;
	label$2265:;
	label$2261:;
}

static void _ZN5ArrayI5ArrayIiEE5CLEAREv( struct $5ArrayI5ArrayIiEE* THIS$1 )
{
	label$2268:;
	struct $5ArrayIiE BLANK$1;
	_ZN5ArrayIiEC1Ev( &BLANK$1 );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$393$2;
		TMP$393$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$2270;
		label$2273:;
		{
			_ZN5ArrayIiEaSERKS0_( (struct $5ArrayIiE*)((uint8*)*(struct $5ArrayIiE**)THIS$1 + ((int64)K$2 * 80ll)), (struct $5ArrayIiE*)&BLANK$1 );
		}
		label$2271:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$2270:;
		if( (int64)K$2 <= (int64)TMP$393$2) goto label$2273;
		label$2272:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	_ZN5ArrayIiED1Ev( &BLANK$1 );
	label$2269:;
}

static struct $13ArrayIteratorI5ArrayIiEE _ZN5ArrayI5ArrayIiEE11GETITERATOREv( struct $5ArrayI5ArrayIiEE* THIS$1 )
{
	struct $13ArrayIteratorI5ArrayIiEE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$2274:;
	struct $13ArrayIteratorI5ArrayIiEE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$2275;
	label$2275:;
	return fb$result$1;
}

__attribute__(( constructor )) static void fb_ctor__containerzsort( void )
{
	label$0:;
	{
		SEEDRNG( 20260809ull );
		{
			int32 SHAPE$2;
			SHAPE$2 = 0;
			label$260:;
			{
				{
					int32 N$4;
					N$4 = 0;
					label$264:;
					{
						struct $5ArrayIiE A$5;
						_ZN5ArrayIiEC1Ev( &A$5 );
						MAKESHAPE( &A$5, SHAPE$2, N$4 );
						struct $5ArrayIiE BEFORE$5;
						_ZN5ArrayIiEC1ERKS0_( &BEFORE$5, (struct $5ArrayIiE*)&A$5 );
						_Z4SortIiER5ArrayIiE( &A$5 );
						int32 vr$6 = _ZN5ArrayIiE5COUNTEv( &A$5 );
						if( (int64)vr$6 == (int64)N$4) goto label$266;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 222ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Count( ) = n" );
							label$266:;
						}
						boolean vr$10 = ASCENDING( &A$5 );
						if( (int64)-vr$10 != 0ll) goto label$268;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 223ll, (char*)"__FB_MODLEVELPROC__", (char*)"Ascending( a )" );
							label$268:;
						}
						boolean vr$13 = _Z8IsSortedIiER5ArrayIiE( &A$5 );
						if( (int64)-vr$13 != 0ll) goto label$270;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 224ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( a )" );
							label$270:;
						}
						boolean vr$17 = SAMEMULTISET( &A$5, &BEFORE$5 );
						if( (int64)-vr$17 != 0ll) goto label$272;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 225ll, (char*)"__FB_MODLEVELPROC__", (char*)"SameMultiset( a, before )" );
							label$272:;
						}
						_ZN5ArrayIiED1Ev( &BEFORE$5 );
						_ZN5ArrayIiED1Ev( &A$5 );
					}
					label$262:;
					N$4 = (int32)((int64)N$4 + 1ll);
					label$261:;
					if( (int64)N$4 <= 40ll) goto label$264;
					label$263:;
				}
			}
			label$258:;
			SHAPE$2 = (int32)((int64)SHAPE$2 + 1ll);
			label$257:;
			if( (int64)SHAPE$2 <= 7ll) goto label$260;
			label$259:;
		}
		{
			int32 SHAPE$2;
			SHAPE$2 = 0;
			label$276:;
			{
				int32 SIZES$3[3];
				struct $8FBARRAY1IiE tmp$46$3;
				*(int32**)&tmp$46$3 = (int32*)SIZES$3;
				*(int32**)((uint8*)&tmp$46$3 + 8ll) = (int32*)SIZES$3;
				*(int64*)((uint8*)&tmp$46$3 + 16ll) = 12ll;
				*(int64*)((uint8*)&tmp$46$3 + 24ll) = 4ll;
				*(int64*)((uint8*)&tmp$46$3 + 32ll) = 1ll;
				*(int64*)((uint8*)&tmp$46$3 + 40ll) = 49ll;
				*(int64*)((uint8*)&tmp$46$3 + 48ll) = 3ll;
				*(int64*)((uint8*)&tmp$46$3 + 56ll) = 0ll;
				*(int64*)((uint8*)&tmp$46$3 + 64ll) = 2ll;
				*(int32*)SIZES$3 = 100;
				*(int32*)((int64)(int32*)SIZES$3 + 4ll) = 511;
				*(int32*)((int64)(int32*)SIZES$3 + 8ll) = 1000;
				{
					int32 S$4;
					S$4 = 0;
					label$280:;
					{
						struct $5ArrayIiE A$5;
						_ZN5ArrayIiEC1Ev( &A$5 );
						MAKESHAPE( &A$5, SHAPE$2, *(int32*)((int64)(int32*)SIZES$3 + ((int64)S$4 << (2ll & 63ll))) );
						struct $5ArrayIiE BEFORE$5;
						_ZN5ArrayIiEC1ERKS0_( &BEFORE$5, (struct $5ArrayIiE*)&A$5 );
						_Z4SortIiER5ArrayIiE( &A$5 );
						int32 vr$39 = _ZN5ArrayIiE5COUNTEv( &A$5 );
						if( (int64)vr$39 == (int64)*(int32*)((int64)(int32*)SIZES$3 + ((int64)S$4 << (2ll & 63ll)))) goto label$282;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 238ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Count( ) = sizes( s )" );
							label$282:;
						}
						boolean vr$45 = _Z8IsSortedIiER5ArrayIiE( &A$5 );
						if( (int64)-vr$45 != 0ll) goto label$284;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 239ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( a )" );
							label$284:;
						}
						boolean vr$49 = SAMEMULTISET( &A$5, &BEFORE$5 );
						if( (int64)-vr$49 != 0ll) goto label$286;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 240ll, (char*)"__FB_MODLEVELPROC__", (char*)"SameMultiset( a, before )" );
							label$286:;
						}
						_ZN5ArrayIiED1Ev( &BEFORE$5 );
						_ZN5ArrayIiED1Ev( &A$5 );
					}
					label$278:;
					S$4 = (int32)((int64)S$4 + 1ll);
					label$277:;
					if( (int64)S$4 <= 2ll) goto label$280;
					label$279:;
				}
			}
			label$274:;
			SHAPE$2 = (int32)((int64)SHAPE$2 + 1ll);
			label$273:;
			if( (int64)SHAPE$2 <= 7ll) goto label$276;
			label$275:;
		}
	}
	{
		int32 TMP$66$1;
		int32 TMP$69$1;
		int32 TMP$70$1;
		struct $5ArrayIiE E$1;
		_ZN5ArrayIiEC1Ev( &E$1 );
		_Z4SortIiER5ArrayIiE( &E$1 );
		int32 vr$64 = _ZN5ArrayIiE5COUNTEv( &E$1 );
		if( (int64)vr$64 == 0ll) goto label$383;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 249ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.Count( ) = 0" );
			label$383:;
		}
		boolean vr$67 = _Z8IsSortedIiER5ArrayIiE( &E$1 );
		if( (int64)-vr$67 != 0ll) goto label$385;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 250ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( e )" );
			label$385:;
		}
		struct $5ArrayIiE ONE$1;
		_ZN5ArrayIiEC1Ev( &ONE$1 );
		TMP$66$1 = 42;
		_ZN5ArrayIiE4PUSHERi( &ONE$1, &TMP$66$1 );
		_Z4SortIiER5ArrayIiE( &ONE$1 );
		int32 vr$74 = _ZN5ArrayIiE5COUNTEv( &ONE$1 );
		if( (int64)vr$74 == 1ll) goto label$387;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 255ll, (char*)"__FB_MODLEVELPROC__", (char*)"one.Count( ) = 1" );
			label$387:;
		}
		int32* vr$77 = _ZN5ArrayIiEixEi( &ONE$1, 0 );
		if( (int64)*vr$77 == 42ll) goto label$389;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 256ll, (char*)"__FB_MODLEVELPROC__", (char*)"one[ 0 ] = 42" );
			label$389:;
		}
		struct $5ArrayIiE TWO$1;
		_ZN5ArrayIiEC1Ev( &TWO$1 );
		TMP$69$1 = 2;
		_ZN5ArrayIiE4PUSHERi( &TWO$1, &TMP$69$1 );
		TMP$70$1 = 1;
		_ZN5ArrayIiE4PUSHERi( &TWO$1, &TMP$70$1 );
		_Z4SortIiER5ArrayIiE( &TWO$1 );
		int32* vr$86 = _ZN5ArrayIiEixEi( &TWO$1, 0 );
		if( (int64)*vr$86 == 1ll) goto label$391;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 261ll, (char*)"__FB_MODLEVELPROC__", (char*)"two[ 0 ] = 1" );
			label$391:;
		}
		int32* vr$89 = _ZN5ArrayIiEixEi( &TWO$1, 1 );
		if( (int64)*vr$89 == 2ll) goto label$393;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 262ll, (char*)"__FB_MODLEVELPROC__", (char*)"two[ 1 ] = 2" );
			label$393:;
		}
		_Z4SortIiER5ArrayIiE( &TWO$1 );
		int32* vr$93 = _ZN5ArrayIiEixEi( &TWO$1, 0 );
		if( (int64)*vr$93 == 1ll) goto label$395;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 266ll, (char*)"__FB_MODLEVELPROC__", (char*)"two[ 0 ] = 1" );
			label$395:;
		}
		int32* vr$96 = _ZN5ArrayIiEixEi( &TWO$1, 1 );
		if( (int64)*vr$96 == 2ll) goto label$397;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 267ll, (char*)"__FB_MODLEVELPROC__", (char*)"two[ 1 ] = 2" );
			label$397:;
		}
		_ZN5ArrayIiED1Ev( &TWO$1 );
		_ZN5ArrayIiED1Ev( &ONE$1 );
		_ZN5ArrayIiED1Ev( &E$1 );
	}
	{
		int32 TMP$73$1;
		int32 TMP$74$1;
		int32 TMP$75$1;
		int32 TMP$76$1;
		int32 TMP$77$1;
		struct $5ArrayIiE A$1;
		_ZN5ArrayIiEC1Ev( &A$1 );
		TMP$73$1 = 0;
		_ZN5ArrayIiE4PUSHERi( &A$1, &TMP$73$1 );
		TMP$74$1 = 2147483647;
		_ZN5ArrayIiE4PUSHERi( &A$1, &TMP$74$1 );
		TMP$75$1 = (int32)-2147483648u;
		_ZN5ArrayIiE4PUSHERi( &A$1, &TMP$75$1 );
		TMP$76$1 = -1;
		_ZN5ArrayIiE4PUSHERi( &A$1, &TMP$76$1 );
		TMP$77$1 = 1;
		_ZN5ArrayIiE4PUSHERi( &A$1, &TMP$77$1 );
		_Z4SortIiER5ArrayIiE( &A$1 );
		int32* vr$114 = _ZN5ArrayIiEixEi( &A$1, 0 );
		if( (int64)*vr$114 == -2147483648ll) goto label$399;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 277ll, (char*)"__FB_MODLEVELPROC__", (char*)"a[ 0 ] = -2147483648" );
			label$399:;
		}
		int32* vr$117 = _ZN5ArrayIiEixEi( &A$1, 1 );
		if( (int64)*vr$117 == -1ll) goto label$401;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 278ll, (char*)"__FB_MODLEVELPROC__", (char*)"a[ 1 ] = -1" );
			label$401:;
		}
		int32* vr$120 = _ZN5ArrayIiEixEi( &A$1, 2 );
		if( (int64)*vr$120 == 0ll) goto label$403;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 279ll, (char*)"__FB_MODLEVELPROC__", (char*)"a[ 2 ] = 0" );
			label$403:;
		}
		int32* vr$123 = _ZN5ArrayIiEixEi( &A$1, 3 );
		if( (int64)*vr$123 == 1ll) goto label$405;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 280ll, (char*)"__FB_MODLEVELPROC__", (char*)"a[ 3 ] = 1" );
			label$405:;
		}
		int32* vr$126 = _ZN5ArrayIiEixEi( &A$1, 4 );
		if( (int64)*vr$126 == 2147483647ll) goto label$407;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 281ll, (char*)"__FB_MODLEVELPROC__", (char*)"a[ 4 ] = 2147483647" );
			label$407:;
		}
		_ZN5ArrayIiED1Ev( &A$1 );
	}
	{
		FBSTRING TMP$87$1;
		FBSTRING TMP$89$1;
		FBSTRING TMP$91$1;
		FBSTRING TMP$93$1;
		FBSTRING TMP$94$1;
		FBSTRING TMP$95$1;
		double TMP$106$1;
		double TMP$107$1;
		double TMP$108$1;
		double TMP$109$1;
		double TMP$110$1;
		struct $5ArrayI8FBSTRINGE S$1;
		_ZN5ArrayI8FBSTRINGEC1Ev( &S$1 );
		__builtin_memset( &TMP$87$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$87$1, -1ll, (void*)"pear", 5ll, 0 );
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &S$1, &TMP$87$1 );
		fb_StrDelete( (FBSTRING*)&TMP$87$1 );
		__builtin_memset( &TMP$89$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$89$1, -1ll, (void*)"Apple", 6ll, 0 );
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &S$1, &TMP$89$1 );
		fb_StrDelete( (FBSTRING*)&TMP$89$1 );
		__builtin_memset( &TMP$91$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$91$1, -1ll, (void*)"fig", 4ll, 0 );
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &S$1, &TMP$91$1 );
		fb_StrDelete( (FBSTRING*)&TMP$91$1 );
		__builtin_memset( &TMP$93$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$93$1, -1ll, (void*)"apple", 6ll, 0 );
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &S$1, &TMP$93$1 );
		fb_StrDelete( (FBSTRING*)&TMP$93$1 );
		__builtin_memset( &TMP$94$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$94$1, -1ll, (void*)"", 1ll, 0 );
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &S$1, &TMP$94$1 );
		fb_StrDelete( (FBSTRING*)&TMP$94$1 );
		__builtin_memset( &TMP$95$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$95$1, -1ll, (void*)"fig", 4ll, 0 );
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &S$1, &TMP$95$1 );
		fb_StrDelete( (FBSTRING*)&TMP$95$1 );
		_Z4SortI8FBSTRINGER5ArrayI8FBSTRINGE( &S$1 );
		FBSTRING* vr$162 = _ZN5ArrayI8FBSTRINGEixEi( &S$1, 0 );
		int32 vr$163 = fb_StrCompare( (void*)vr$162, -1ll, (void*)"", 1ll );
		if( (int64)vr$163 == 0ll) goto label$419;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 291ll, (char*)"__FB_MODLEVELPROC__", (char*)"s[ 0 ] = \x22\x22" );
			label$419:;
		}
		FBSTRING* vr$166 = _ZN5ArrayI8FBSTRINGEixEi( &S$1, 1 );
		int32 vr$167 = fb_StrCompare( (void*)vr$166, -1ll, (void*)"Apple", 6ll );
		if( (int64)vr$167 == 0ll) goto label$421;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 292ll, (char*)"__FB_MODLEVELPROC__", (char*)"s[ 1 ] = \x22" "Apple\x22" );
			label$421:;
		}
		FBSTRING* vr$170 = _ZN5ArrayI8FBSTRINGEixEi( &S$1, 2 );
		int32 vr$171 = fb_StrCompare( (void*)vr$170, -1ll, (void*)"apple", 6ll );
		if( (int64)vr$171 == 0ll) goto label$423;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 293ll, (char*)"__FB_MODLEVELPROC__", (char*)"s[ 2 ] = \x22" "apple\x22" );
			label$423:;
		}
		FBSTRING* vr$174 = _ZN5ArrayI8FBSTRINGEixEi( &S$1, 3 );
		int32 vr$175 = fb_StrCompare( (void*)vr$174, -1ll, (void*)"fig", 4ll );
		if( (int64)vr$175 == 0ll) goto label$425;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 294ll, (char*)"__FB_MODLEVELPROC__", (char*)"s[ 3 ] = \x22" "fig\x22" );
			label$425:;
		}
		FBSTRING* vr$178 = _ZN5ArrayI8FBSTRINGEixEi( &S$1, 4 );
		int32 vr$179 = fb_StrCompare( (void*)vr$178, -1ll, (void*)"fig", 4ll );
		if( (int64)vr$179 == 0ll) goto label$427;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 295ll, (char*)"__FB_MODLEVELPROC__", (char*)"s[ 4 ] = \x22" "fig\x22" );
			label$427:;
		}
		FBSTRING* vr$182 = _ZN5ArrayI8FBSTRINGEixEi( &S$1, 5 );
		int32 vr$183 = fb_StrCompare( (void*)vr$182, -1ll, (void*)"pear", 5ll );
		if( (int64)vr$183 == 0ll) goto label$429;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 296ll, (char*)"__FB_MODLEVELPROC__", (char*)"s[ 5 ] = \x22pear\x22" );
			label$429:;
		}
		boolean vr$186 = _Z8IsSortedI8FBSTRINGER5ArrayI8FBSTRINGE( &S$1 );
		if( (int64)-vr$186 != 0ll) goto label$431;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 297ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( s )" );
			label$431:;
		}
		struct $5ArrayIdE D$1;
		_ZN5ArrayIdEC1Ev( &D$1 );
		TMP$106$1 = 0x1.4p+1;
		_ZN5ArrayIdE4PUSHERd( &D$1, &TMP$106$1 );
		TMP$107$1 = -0x1.p-1;
		_ZN5ArrayIdE4PUSHERd( &D$1, &TMP$107$1 );
		TMP$108$1 = 0x1.4p+1;
		_ZN5ArrayIdE4PUSHERd( &D$1, &TMP$108$1 );
		TMP$109$1 = 0x1.7E43C8800759Cp+996;
		_ZN5ArrayIdE4PUSHERd( &D$1, &TMP$109$1 );
		TMP$110$1 = 0x0p+0;
		_ZN5ArrayIdE4PUSHERd( &D$1, &TMP$110$1 );
		_Z4SortIdER5ArrayIdE( &D$1 );
		double* vr$201 = _ZN5ArrayIdEixEi( &D$1, 0 );
		if( *vr$201 == -0x1.p-1) goto label$443;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 302ll, (char*)"__FB_MODLEVELPROC__", (char*)"d[ 0 ] = -0.5" );
			label$443:;
		}
		double* vr$203 = _ZN5ArrayIdEixEi( &D$1, 1 );
		if( *vr$203 == 0x0p+0) goto label$445;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 303ll, (char*)"__FB_MODLEVELPROC__", (char*)"d[ 1 ] = 0.0" );
			label$445:;
		}
		double* vr$205 = _ZN5ArrayIdEixEi( &D$1, 2 );
		if( *vr$205 == 0x1.4p+1) goto label$447;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 304ll, (char*)"__FB_MODLEVELPROC__", (char*)"d[ 2 ] = 2.5" );
			label$447:;
		}
		double* vr$207 = _ZN5ArrayIdEixEi( &D$1, 3 );
		if( *vr$207 == 0x1.4p+1) goto label$449;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 305ll, (char*)"__FB_MODLEVELPROC__", (char*)"d[ 3 ] = 2.5" );
			label$449:;
		}
		double* vr$209 = _ZN5ArrayIdEixEi( &D$1, 4 );
		if( *vr$209 == 0x1.7E43C8800759Cp+996) goto label$451;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 306ll, (char*)"__FB_MODLEVELPROC__", (char*)"d[ 4 ] = 1e300" );
			label$451:;
		}
		struct $5ArrayI3RECE R$1;
		_ZN5ArrayI3RECEC1Ev( &R$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$465:;
			{
				struct $3REC X$3;
				__builtin_memset( &X$3, 0, 8ll );
				*(int32*)&X$3 = (int32)(-(int64)I$2 + 49ll);
				*(int32*)((uint8*)&X$3 + 4ll) = I$2;
				_ZN5ArrayI3RECE4PUSHERS0_( &R$1, &X$3 );
			}
			label$463:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$462:;
			if( (int64)I$2 <= 49ll) goto label$465;
			label$464:;
		}
		_Z4SortI3RECER5ArrayI3RECE( &R$1 );
		boolean OK$1;
		OK$1 = (boolean)1ll;
		{
			int32 I$2;
			I$2 = 0;
			label$469:;
			{
				struct $3REC* vr$224 = _ZN5ArrayI3RECEixEi( &R$1, I$2 );
				if( (int64)*(int32*)vr$224 == (int64)I$2) goto label$471;
				{
					OK$1 = (boolean)0ll;
					label$471:;
				}
			}
			label$467:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$466:;
			if( (int64)I$2 <= 49ll) goto label$469;
			label$468:;
		}
		if( (int64)-OK$1 != 0ll) goto label$473;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 320ll, (char*)"__FB_MODLEVELPROC__", (char*)"ok" );
			label$473:;
		}
		boolean vr$233 = _Z8IsSortedI3RECER5ArrayI3RECE( &R$1 );
		if( (int64)-vr$233 != 0ll) goto label$475;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 321ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( r )" );
			label$475:;
		}
		_ZN5ArrayI3RECED1Ev( &R$1 );
		_ZN5ArrayIdED1Ev( &D$1 );
		_ZN5ArrayI8FBSTRINGED1Ev( &S$1 );
	}
	{
		tmp$50 TMP$167$1;
		tmp$50 TMP$170$1;
		struct $5ArrayIiE A$1;
		_ZN5ArrayIiEC1Ev( &A$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$968:;
			{
				_ZN5ArrayIiE4PUSHERi( &A$1, &I$2 );
			}
			label$966:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$965:;
			if( (int64)I$2 <= 99ll) goto label$968;
			label$967:;
		}
		TMP$167$1 = (tmp$50)&LD2939E50C2FFBF23_LT_00A6;
		_Z6SortByIiPFbRiRiEER5ArrayIiERS3_( &A$1, &TMP$167$1 );
		boolean OK$1;
		OK$1 = (boolean)1ll;
		{
			int32 I$2;
			I$2 = 0;
			label$972:;
			{
				int32* vr$248 = _ZN5ArrayIiEixEi( &A$1, I$2 );
				if( (int64)*vr$248 == (-(int64)I$2 + 99ll)) goto label$974;
				{
					OK$1 = (boolean)0ll;
					label$974:;
				}
			}
			label$970:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$969:;
			if( (int64)I$2 <= 99ll) goto label$972;
			label$971:;
		}
		if( (int64)-OK$1 != 0ll) goto label$976;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 335ll, (char*)"__FB_MODLEVELPROC__", (char*)"ok" );
			label$976:;
		}
		boolean vr$259 = _Z8IsSortedIiER5ArrayIiE( &A$1 );
		if( (int64)-(boolean)(vr$259 == (boolean)0ll) != 0ll) goto label$978;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 336ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( a ) = false" );
			label$978:;
		}
		boolean BYDESCENDING$1;
		TMP$170$1 = (tmp$50)&LD2939E50C2FFBF23_LT_00A9;
		boolean vr$264 = _Z10IsSortedByIiPFbRiRiEER5ArrayIiERS3_( &A$1, &TMP$170$1 );
		BYDESCENDING$1 = vr$264;
		if( (int64)-BYDESCENDING$1 != 0ll) goto label$980;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 344ll, (char*)"__FB_MODLEVELPROC__", (char*)"byDescending" );
			label$980:;
		}
		_ZN5ArrayIiED1Ev( &A$1 );
	}
	{
		int32 COMPARISONS$1;
		COMPARISONS$1 = 0;
		struct $5ArrayIiE A$1;
		_ZN5ArrayIiEC1Ev( &A$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$988:;
			{
				int32 TMP$172$3;
				TMP$172$3 = (int32)(-(int64)I$2 + 199ll);
				_ZN5ArrayIiE4PUSHERi( &A$1, &TMP$172$3 );
			}
			label$986:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$985:;
			if( (int64)I$2 <= 199ll) goto label$988;
			label$987:;
		}
		struct $25LD2939E50C2FFBF23_Lt_00ADIiE TMP$174$1;
		__builtin_memset( &TMP$174$1, 0, 8ll );
		*(int32**)&TMP$174$1 = &COMPARISONS$1;
		_Z6SortByIi25LD2939E50C2FFBF23_Lt_00ADIiEER5ArrayIiERS1_( &A$1, &TMP$174$1 );
		boolean vr$283 = _Z8IsSortedIiER5ArrayIiE( &A$1 );
		if( (int64)-vr$283 != 0ll) goto label$990;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 359ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( a )" );
			label$990:;
		}
		if( (int64)COMPARISONS$1 > 0ll) goto label$992;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 360ll, (char*)"__FB_MODLEVELPROC__", (char*)"comparisons > 0" );
			label$992:;
		}
		if( (int64)COMPARISONS$1 < 15290ll) goto label$994;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 364ll, (char*)"__FB_MODLEVELPROC__", (char*)"comparisons < 15290" );
			label$994:;
		}
		_ZN5ArrayIiED1Ev( &A$1 );
	}
	{
		tmp$149 TMP$188$1;
		struct $5ArrayI3RECE R$1;
		_ZN5ArrayI3RECEC1Ev( &R$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1079:;
			{
				struct $3REC X$3;
				__builtin_memset( &X$3, 0, 8ll );
				*(int32*)&X$3 = I$2;
				*(int32*)((uint8*)&X$3 + 4ll) = (int32)(-(int64)I$2 + 9ll);
				_ZN5ArrayI3RECE4PUSHERS0_( &R$1, &X$3 );
			}
			label$1077:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1076:;
			if( (int64)I$2 <= 9ll) goto label$1079;
			label$1078:;
		}
		TMP$188$1 = (tmp$149)&LD2939E50C2FFBF23_LT_00BB;
		_Z6SortByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( &R$1, &TMP$188$1 );
		boolean OK$1;
		OK$1 = (boolean)1ll;
		{
			int32 I$2;
			I$2 = 0;
			label$1083:;
			{
				struct $3REC* vr$303 = _ZN5ArrayI3RECEixEi( &R$1, I$2 );
				if( (int64)*(int32*)((uint8*)vr$303 + 4ll) == (int64)I$2) goto label$1085;
				{
					OK$1 = (boolean)0ll;
					label$1085:;
				}
			}
			label$1081:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1080:;
			if( (int64)I$2 <= 9ll) goto label$1083;
			label$1082:;
		}
		if( (int64)-OK$1 != 0ll) goto label$1087;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 383ll, (char*)"__FB_MODLEVELPROC__", (char*)"ok" );
			label$1087:;
		}
		_ZN5ArrayI3RECED1Ev( &R$1 );
	}
	{
		struct $5ArrayIiE A$1;
		_ZN5ArrayIiEC1Ev( &A$1 );
		struct $8FBARRAY1IiE KILLER$1;
		*(int32**)&KILLER$1 = (int32*)0ull;
		*(int32**)((uint8*)&KILLER$1 + 8ll) = (int32*)0ull;
		*(int64*)((uint8*)&KILLER$1 + 16ll) = 0ll;
		*(int64*)((uint8*)&KILLER$1 + 24ll) = 4ll;
		*(int64*)((uint8*)&KILLER$1 + 32ll) = 1ll;
		*(int64*)((uint8*)&KILLER$1 + 40ll) = 17ll;
		__builtin_memset( (void*)((uint8*)&KILLER$1 + 48ll), 0, 24ll );
		fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&KILLER$1, 4ull, -1, 0, 1ull, 0ll, 511ll );
		{
			int32 I$2;
			I$2 = 0;
			label$1093:;
			{
				*(int32*)(((int64)I$2 << (2ll & 63ll)) + *(int64*)&KILLER$1) = I$2;
			}
			label$1091:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1090:;
			if( (int64)I$2 <= 511ll) goto label$1093;
			label$1092:;
		}
		int32 LO$1;
		LO$1 = 0;
		int32 HI$1;
		HI$1 = 511;
		int32 SMALL$1;
		SMALL$1 = 0;
		label$1094:;
		if( (int64)LO$1 >= (int64)HI$1) goto label$1095;
		{
			int32 MID_$2;
			MID_$2 = (int32)((int64)LO$1 + (((int64)HI$1 - (int64)LO$1) / 2ll));
			{
				int32 TMP$189$3;
				TMP$189$3 = *(int32*)(((int64)MID_$2 << (2ll & 63ll)) + *(int64*)&KILLER$1);
				*(int32*)(((int64)MID_$2 << (2ll & 63ll)) + *(int64*)&KILLER$1) = *(int32*)((uint8*)(((int64)HI$1 << (2ll & 63ll)) + *(int64*)&KILLER$1) + -4ll);
				*(int32*)((uint8*)(((int64)HI$1 << (2ll & 63ll)) + *(int64*)&KILLER$1) + -4ll) = TMP$189$3;
			}
			int32 T$2;
			T$2 = *(int32*)(((int64)LO$1 << (2ll & 63ll)) + *(int64*)&KILLER$1);
			*(int32*)(((int64)LO$1 << (2ll & 63ll)) + *(int64*)&KILLER$1) = *(int32*)(((int64)HI$1 << (2ll & 63ll)) + *(int64*)&KILLER$1);
			*(int32*)(((int64)HI$1 << (2ll & 63ll)) + *(int64*)&KILLER$1) = T$2;
			*(int32*)(((int64)LO$1 << (2ll & 63ll)) + *(int64*)&KILLER$1) = SMALL$1;
			SMALL$1 = (int32)((int64)SMALL$1 + 1ll);
			LO$1 = (int32)((int64)LO$1 + 1ll);
			HI$1 = (int32)((int64)HI$1 + -1ll);
		}
		goto label$1094;
		label$1095:;
		{
			int32 I$2;
			I$2 = 0;
			label$1099:;
			{
				_ZN5ArrayIiE4PUSHERi( &A$1, (int32*)(((int64)I$2 << (2ll & 63ll)) + *(int64*)&KILLER$1) );
			}
			label$1097:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1096:;
			if( (int64)I$2 <= 511ll) goto label$1099;
			label$1098:;
		}
		struct $5ArrayIiE BEFORE$1;
		_ZN5ArrayIiEC1ERKS0_( &BEFORE$1, (struct $5ArrayIiE*)&A$1 );
		int32 COMPARISONS$1;
		COMPARISONS$1 = 0;
		struct $25LD2939E50C2FFBF23_Lt_00BEIiE TMP$191$1;
		__builtin_memset( &TMP$191$1, 0, 8ll );
		*(int32**)&TMP$191$1 = &COMPARISONS$1;
		_Z6SortByIi25LD2939E50C2FFBF23_Lt_00BEIiEER5ArrayIiERS1_( &A$1, &TMP$191$1 );
		boolean vr$383 = _Z8IsSortedIiER5ArrayIiE( &A$1 );
		if( (int64)-vr$383 != 0ll) goto label$1101;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 433ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( a )" );
			label$1101:;
		}
		boolean vr$387 = SAMEMULTISET( &A$1, &BEFORE$1 );
		if( (int64)-vr$387 != 0ll) goto label$1103;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 434ll, (char*)"__FB_MODLEVELPROC__", (char*)"SameMultiset( a, before )" );
			label$1103:;
		}
		if( (int64)COMPARISONS$1 < 115200ll) goto label$1105;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 436ll, (char*)"__FB_MODLEVELPROC__", (char*)"comparisons < 4608 * 25" );
			label$1105:;
		}
		_ZN5ArrayIiED1Ev( &BEFORE$1 );
		fb_ArrayErase( (struct $7FBARRAYIvE*)&KILLER$1 );
		_ZN5ArrayIiED1Ev( &A$1 );
	}
	{
		tmp$50 TMP$205$1;
		struct $5ArrayIiE A$1;
		_ZN5ArrayIiEC1Ev( &A$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1190:;
			{
				int32 TMP$203$3;
				TMP$203$3 = (int32)(-(int64)I$2 + 99ll);
				_ZN5ArrayIiE4PUSHERi( &A$1, &TMP$203$3 );
			}
			label$1188:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1187:;
			if( (int64)I$2 <= 99ll) goto label$1190;
			label$1189:;
		}
		struct $5ArrayIiE BEFORE$1;
		_ZN5ArrayIiEC1ERKS0_( &BEFORE$1, (struct $5ArrayIiE*)&A$1 );
		TMP$205$1 = (tmp$50)&LD2939E50C2FFBF23_LT_00CC;
		_Z6SortByIiPFbRiRiEER5ArrayIiERS3_( &A$1, &TMP$205$1 );
		int32 vr$409 = _ZN5ArrayIiE5COUNTEv( &A$1 );
		if( (int64)vr$409 == 100ll) goto label$1192;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 449ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Count( ) = 100" );
			label$1192:;
		}
		boolean vr$413 = SAMEMULTISET( &A$1, &BEFORE$1 );
		if( (int64)-vr$413 != 0ll) goto label$1194;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 450ll, (char*)"__FB_MODLEVELPROC__", (char*)"SameMultiset( a, before )" );
			label$1194:;
		}
		_ZN5ArrayIiED1Ev( &BEFORE$1 );
		_ZN5ArrayIiED1Ev( &A$1 );
	}
	{
		tmp$50 TMP$209$1;
		struct $5ArrayIiE A$1;
		_ZN5ArrayIiEC1Ev( &A$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1200:;
			{
				int32 TMP$207$3;
				TMP$207$3 = (int32)(-(int64)I$2 + 99ll);
				_ZN5ArrayIiE4PUSHERi( &A$1, &TMP$207$3 );
			}
			label$1198:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1197:;
			if( (int64)I$2 <= 99ll) goto label$1200;
			label$1199:;
		}
		struct $5ArrayIiE BEFORE$1;
		_ZN5ArrayIiEC1ERKS0_( &BEFORE$1, (struct $5ArrayIiE*)&A$1 );
		TMP$209$1 = (tmp$50)&LD2939E50C2FFBF23_LT_00D0;
		_Z6SortByIiPFbRiRiEER5ArrayIiERS3_( &A$1, &TMP$209$1 );
		int32 vr$433 = _ZN5ArrayIiE5COUNTEv( &A$1 );
		if( (int64)vr$433 == 100ll) goto label$1202;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 464ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Count( ) = 100" );
			label$1202:;
		}
		boolean vr$437 = SAMEMULTISET( &A$1, &BEFORE$1 );
		if( (int64)-vr$437 != 0ll) goto label$1204;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 465ll, (char*)"__FB_MODLEVELPROC__", (char*)"SameMultiset( a, before )" );
			label$1204:;
		}
		_ZN5ArrayIiED1Ev( &BEFORE$1 );
		_ZN5ArrayIiED1Ev( &A$1 );
	}
	{
		SEEDRNG( 987654321ull );
		{
			int32 SHAPE$2;
			SHAPE$2 = 0;
			label$1210:;
			{
				{
					int32 N$4;
					N$4 = 0;
					label$1214:;
					{
						struct $5ArrayIiE A$5;
						_ZN5ArrayIiEC1Ev( &A$5 );
						MAKESHAPE( &A$5, SHAPE$2, N$4 );
						struct $5ArrayIiE BEFORE$5;
						_ZN5ArrayIiEC1ERKS0_( &BEFORE$5, (struct $5ArrayIiE*)&A$5 );
						_Z10StableSortIiER5ArrayIiE( &A$5 );
						int32 vr$447 = _ZN5ArrayIiE5COUNTEv( &A$5 );
						if( (int64)vr$447 == (int64)N$4) goto label$1216;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 484ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Count( ) = n" );
							label$1216:;
						}
						boolean vr$451 = _Z8IsSortedIiER5ArrayIiE( &A$5 );
						if( (int64)-vr$451 != 0ll) goto label$1218;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 485ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( a )" );
							label$1218:;
						}
						boolean vr$455 = SAMEMULTISET( &A$5, &BEFORE$5 );
						if( (int64)-vr$455 != 0ll) goto label$1220;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 486ll, (char*)"__FB_MODLEVELPROC__", (char*)"SameMultiset( a, before )" );
							label$1220:;
						}
						_ZN5ArrayIiED1Ev( &BEFORE$5 );
						_ZN5ArrayIiED1Ev( &A$5 );
					}
					label$1212:;
					N$4 = (int32)((int64)N$4 + 1ll);
					label$1211:;
					if( (int64)N$4 <= 40ll) goto label$1214;
					label$1213:;
				}
			}
			label$1208:;
			SHAPE$2 = (int32)((int64)SHAPE$2 + 1ll);
			label$1207:;
			if( (int64)SHAPE$2 <= 7ll) goto label$1210;
			label$1209:;
		}
		{
			int32 SHAPE$2;
			SHAPE$2 = 0;
			label$1224:;
			{
				int32 SIZES$3[3];
				struct $8FBARRAY1IiE tmp$210$3;
				*(int32**)&tmp$210$3 = (int32*)SIZES$3;
				*(int32**)((uint8*)&tmp$210$3 + 8ll) = (int32*)SIZES$3;
				*(int64*)((uint8*)&tmp$210$3 + 16ll) = 12ll;
				*(int64*)((uint8*)&tmp$210$3 + 24ll) = 4ll;
				*(int64*)((uint8*)&tmp$210$3 + 32ll) = 1ll;
				*(int64*)((uint8*)&tmp$210$3 + 40ll) = 49ll;
				*(int64*)((uint8*)&tmp$210$3 + 48ll) = 3ll;
				*(int64*)((uint8*)&tmp$210$3 + 56ll) = 0ll;
				*(int64*)((uint8*)&tmp$210$3 + 64ll) = 2ll;
				*(int32*)SIZES$3 = 100;
				*(int32*)((int64)(int32*)SIZES$3 + 4ll) = 511;
				*(int32*)((int64)(int32*)SIZES$3 + 8ll) = 1000;
				{
					int32 S$4;
					S$4 = 0;
					label$1228:;
					{
						struct $5ArrayIiE A$5;
						_ZN5ArrayIiEC1Ev( &A$5 );
						MAKESHAPE( &A$5, SHAPE$2, *(int32*)((int64)(int32*)SIZES$3 + ((int64)S$4 << (2ll & 63ll))) );
						struct $5ArrayIiE BEFORE$5;
						_ZN5ArrayIiEC1ERKS0_( &BEFORE$5, (struct $5ArrayIiE*)&A$5 );
						_Z10StableSortIiER5ArrayIiE( &A$5 );
						boolean vr$477 = _Z8IsSortedIiER5ArrayIiE( &A$5 );
						if( (int64)-vr$477 != 0ll) goto label$1230;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 499ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( a )" );
							label$1230:;
						}
						boolean vr$481 = SAMEMULTISET( &A$5, &BEFORE$5 );
						if( (int64)-vr$481 != 0ll) goto label$1232;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 500ll, (char*)"__FB_MODLEVELPROC__", (char*)"SameMultiset( a, before )" );
							label$1232:;
						}
						_ZN5ArrayIiED1Ev( &BEFORE$5 );
						_ZN5ArrayIiED1Ev( &A$5 );
					}
					label$1226:;
					S$4 = (int32)((int64)S$4 + 1ll);
					label$1225:;
					if( (int64)S$4 <= 2ll) goto label$1228;
					label$1227:;
				}
			}
			label$1222:;
			SHAPE$2 = (int32)((int64)SHAPE$2 + 1ll);
			label$1221:;
			if( (int64)SHAPE$2 <= 7ll) goto label$1224;
			label$1223:;
		}
	}
	{
		SEEDRNG( 555ull );
		struct $5ArrayI3RECE R$1;
		_ZN5ArrayI3RECEC1Ev( &R$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1270:;
			{
				struct $3REC X$3;
				__builtin_memset( &X$3, 0, 8ll );
				int32 vr$495 = NEXTRNG( 8 );
				*(int32*)&X$3 = vr$495;
				*(int32*)((uint8*)&X$3 + 4ll) = I$2;
				_ZN5ArrayI3RECE4PUSHERS0_( &R$1, &X$3 );
			}
			label$1268:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1267:;
			if( (int64)I$2 <= 399ll) goto label$1270;
			label$1269:;
		}
		_Z10StableSortI3RECER5ArrayI3RECE( &R$1 );
		boolean vr$504 = _Z8IsSortedI3RECER5ArrayI3RECE( &R$1 );
		if( (int64)-vr$504 != 0ll) goto label$1272;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 523ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( r )" );
			label$1272:;
		}
		boolean STABLE$1;
		STABLE$1 = (boolean)1ll;
		{
			int32 I$2;
			I$2 = 1;
			int32 TMP$219$2;
			int32 vr$507 = _ZN5ArrayI3RECE5COUNTEv( &R$1 );
			TMP$219$2 = (int32)((int64)vr$507 + -1ll);
			goto label$1273;
			label$1276:;
			{
				struct $3REC* vr$512 = _ZN5ArrayI3RECEixEi( &R$1, I$2 );
				struct $3REC* vr$518 = _ZN5ArrayI3RECEixEi( &R$1, (int32)((int64)I$2 + -1ll) );
				if( (int64)*(int32*)vr$512 != (int64)*(int32*)vr$518) goto label$1278;
				{
					struct $3REC* vr$521 = _ZN5ArrayI3RECEixEi( &R$1, I$2 );
					struct $3REC* vr$527 = _ZN5ArrayI3RECEixEi( &R$1, (int32)((int64)I$2 + -1ll) );
					if( (int64)*(int32*)((uint8*)vr$521 + 4ll) > (int64)*(int32*)((uint8*)vr$527 + 4ll)) goto label$1280;
					{
						STABLE$1 = (boolean)0ll;
						label$1280:;
					}
				}
				label$1278:;
				label$1277:;
			}
			label$1274:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1273:;
			if( (int64)I$2 <= (int64)TMP$219$2) goto label$1276;
			label$1275:;
		}
		if( (int64)-STABLE$1 != 0ll) goto label$1282;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 530ll, (char*)"__FB_MODLEVELPROC__", (char*)"stable" );
			label$1282:;
		}
		SEEDRNG( 555ull );
		struct $5ArrayI3RECE R2$1;
		_ZN5ArrayI3RECEC1Ev( &R2$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1286:;
			{
				struct $3REC X$3;
				__builtin_memset( &X$3, 0, 8ll );
				int32 vr$537 = NEXTRNG( 8 );
				*(int32*)&X$3 = vr$537;
				*(int32*)((uint8*)&X$3 + 4ll) = I$2;
				_ZN5ArrayI3RECE4PUSHERS0_( &R2$1, &X$3 );
			}
			label$1284:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1283:;
			if( (int64)I$2 <= 399ll) goto label$1286;
			label$1285:;
		}
		_Z4SortI3RECER5ArrayI3RECE( &R2$1 );
		boolean vr$546 = _Z8IsSortedI3RECER5ArrayI3RECE( &R2$1 );
		if( (int64)-vr$546 != 0ll) goto label$1288;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 543ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( r2 )" );
			label$1288:;
		}
		_ZN5ArrayI3RECED1Ev( &R2$1 );
		_ZN5ArrayI3RECED1Ev( &R$1 );
	}
	{
		{
			int32 N$2;
			N$2 = 0;
			label$1326:;
			{
				tmp$149 TMP$228$3;
				struct $5ArrayI3RECE R$3;
				_ZN5ArrayI3RECEC1Ev( &R$3 );
				{
					int32 I$4;
					I$4 = 0;
					int32 TMP$226$4;
					TMP$226$4 = (int32)((int64)N$2 + -1ll);
					goto label$1327;
					label$1330:;
					{
						struct $3REC X$5;
						__builtin_memset( &X$5, 0, 8ll );
						*(int32*)&X$5 = (int32)((int64)I$4 % 3ll);
						*(int32*)((uint8*)&X$5 + 4ll) = I$4;
						_ZN5ArrayI3RECE4PUSHERS0_( &R$3, &X$5 );
					}
					label$1328:;
					I$4 = (int32)((int64)I$4 + 1ll);
					label$1327:;
					if( (int64)I$4 <= (int64)TMP$226$4) goto label$1330;
					label$1329:;
				}
				TMP$228$3 = (tmp$149)&LD2939E50C2FFBF23_LT_00E3;
				_Z12StableSortByI3RECPFbR3RECR3RECEER5ArrayI3RECERS6_( &R$3, &TMP$228$3 );
				int32 vr$568 = _ZN5ArrayI3RECE5COUNTEv( &R$3 );
				if( (int64)vr$568 == (int64)N$2) goto label$1332;
				{
					fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 563ll, (char*)"__FB_MODLEVELPROC__", (char*)"r.Count( ) = n" );
					label$1332:;
				}
				boolean OK$3;
				OK$3 = (boolean)1ll;
				{
					int32 I$4;
					I$4 = 1;
					int32 TMP$230$4;
					TMP$230$4 = (int32)((int64)N$2 + -1ll);
					goto label$1333;
					label$1336:;
					{
						struct $3REC* vr$575 = _ZN5ArrayI3RECEixEi( &R$3, I$4 );
						struct $3REC* vr$581 = _ZN5ArrayI3RECEixEi( &R$3, (int32)((int64)I$4 + -1ll) );
						if( (int64)*(int32*)vr$575 >= (int64)*(int32*)vr$581) goto label$1338;
						{
							OK$3 = (boolean)0ll;
							label$1338:;
						}
						struct $3REC* vr$584 = _ZN5ArrayI3RECEixEi( &R$3, I$4 );
						struct $3REC* vr$590 = _ZN5ArrayI3RECEixEi( &R$3, (int32)((int64)I$4 + -1ll) );
						if( (int64)*(int32*)vr$584 != (int64)*(int32*)vr$590) goto label$1340;
						{
							struct $3REC* vr$593 = _ZN5ArrayI3RECEixEi( &R$3, I$4 );
							struct $3REC* vr$599 = _ZN5ArrayI3RECEixEi( &R$3, (int32)((int64)I$4 + -1ll) );
							if( (int64)*(int32*)((uint8*)vr$593 + 4ll) > (int64)*(int32*)((uint8*)vr$599 + 4ll)) goto label$1342;
							{
								OK$3 = (boolean)0ll;
								label$1342:;
							}
						}
						label$1340:;
						label$1339:;
					}
					label$1334:;
					I$4 = (int32)((int64)I$4 + 1ll);
					label$1333:;
					if( (int64)I$4 <= (int64)TMP$230$4) goto label$1336;
					label$1335:;
				}
				if( (int64)-OK$3 != 0ll) goto label$1344;
				{
					fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 571ll, (char*)"__FB_MODLEVELPROC__", (char*)"ok" );
					label$1344:;
				}
				_ZN5ArrayI3RECED1Ev( &R$3 );
			}
			label$1324:;
			N$2 = (int32)((int64)N$2 + 1ll);
			label$1323:;
			if( (int64)N$2 <= 70ll) goto label$1326;
			label$1325:;
		}
	}
	{
		int32 COMPARISONS$1;
		COMPARISONS$1 = 0;
		struct $5ArrayIiE A$1;
		_ZN5ArrayIiEC1Ev( &A$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1350:;
			{
				int32 TMP$231$3;
				TMP$231$3 = (int32)(-(int64)I$2 + 199ll);
				_ZN5ArrayIiE4PUSHERi( &A$1, &TMP$231$3 );
			}
			label$1348:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1347:;
			if( (int64)I$2 <= 199ll) goto label$1350;
			label$1349:;
		}
		struct $25LD2939E50C2FFBF23_Lt_00E8IiE TMP$233$1;
		__builtin_memset( &TMP$233$1, 0, 8ll );
		*(int32**)&TMP$233$1 = &COMPARISONS$1;
		_Z12StableSortByIi25LD2939E50C2FFBF23_Lt_00E8IiEER5ArrayIiERS1_( &A$1, &TMP$233$1 );
		boolean vr$628 = _Z8IsSortedIiER5ArrayIiE( &A$1 );
		if( (int64)-vr$628 != 0ll) goto label$1352;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 588ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( a )" );
			label$1352:;
		}
		if( (int64)COMPARISONS$1 < 15290ll) goto label$1354;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 589ll, (char*)"__FB_MODLEVELPROC__", (char*)"comparisons < 15290" );
			label$1354:;
		}
		_ZN5ArrayIiED1Ev( &A$1 );
	}
	{
		struct $5ArrayI8FBSTRINGE S$1;
		_ZN5ArrayI8FBSTRINGEC1Ev( &S$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1403:;
			{
				FBSTRING TMP$243$3;
				FBSTRING TMP$244$3;
				__builtin_memset( &TMP$244$3, 0, 24ll );
				FBSTRING* vr$637 = fb_LongintToStr( -(int64)I$2 + 99ll );
				__builtin_memset( &TMP$243$3, 0, 24ll );
				FBSTRING* vr$640 = fb_StrConcat( &TMP$243$3, (void*)"item", 5ll, (void*)vr$637, -1ll );
				fb_StrAssign( (void*)&TMP$244$3, -1ll, (void*)vr$640, -1ll, 0 );
				_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &S$1, &TMP$244$3 );
				fb_StrDelete( (FBSTRING*)&TMP$244$3 );
			}
			label$1401:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1400:;
			if( (int64)I$2 <= 99ll) goto label$1403;
			label$1402:;
		}
		_Z10StableSortI8FBSTRINGER5ArrayI8FBSTRINGE( &S$1 );
		boolean vr$651 = _Z8IsSortedI8FBSTRINGER5ArrayI8FBSTRINGE( &S$1 );
		if( (int64)-vr$651 != 0ll) goto label$1405;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 600ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( s )" );
			label$1405:;
		}
		FBSTRING* vr$654 = _ZN5ArrayI8FBSTRINGEixEi( &S$1, 0 );
		int32 vr$655 = fb_StrCompare( (void*)vr$654, -1ll, (void*)"item0", 6ll );
		if( (int64)vr$655 == 0ll) goto label$1407;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 601ll, (char*)"__FB_MODLEVELPROC__", (char*)"s[ 0 ] = \x22item0\x22" );
			label$1407:;
		}
		int32 vr$658 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &S$1 );
		if( (int64)vr$658 == 100ll) goto label$1409;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 602ll, (char*)"__FB_MODLEVELPROC__", (char*)"s.Count( ) = 100" );
			label$1409:;
		}
		boolean ALLLIVE$1;
		ALLLIVE$1 = (boolean)1ll;
		{
			int32 I$2;
			I$2 = 0;
			label$1413:;
			{
				FBSTRING* vr$661 = _ZN5ArrayI8FBSTRINGEixEi( &S$1, I$2 );
				int64 vr$662 = fb_StrLen( (void*)vr$661, -1ll );
				if( vr$662 >= 5ll) goto label$1415;
				{
					ALLLIVE$1 = (boolean)0ll;
					label$1415:;
				}
			}
			label$1411:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1410:;
			if( (int64)I$2 <= 99ll) goto label$1413;
			label$1412:;
		}
		if( (int64)-ALLLIVE$1 != 0ll) goto label$1417;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 609ll, (char*)"__FB_MODLEVELPROC__", (char*)"allLive" );
			label$1417:;
		}
		_ZN5ArrayI8FBSTRINGED1Ev( &S$1 );
	}
	{
		struct $5ArrayI7COUNTEDE A$1;
		_ZN5ArrayI7COUNTEDEC1Ev( &A$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1465:;
			{
				struct $7COUNTED TMP$258$3;
				_ZN7COUNTEDC1Ei( &TMP$258$3, (int32)(-(int64)I$2 + 99ll) );
				_ZN5ArrayI7COUNTEDE4PUSHERS0_( &A$1, &TMP$258$3 );
				_ZN7COUNTEDD1Ev( &TMP$258$3 );
			}
			label$1463:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1462:;
			if( (int64)I$2 <= 99ll) goto label$1465;
			label$1464:;
		}
		int32 LIVEBEFORE$1;
		LIVEBEFORE$1 = LIVECOUNTED$;
		COPIEDCOUNTED$ = 0;
		DESTROYEDCOUNTED$ = 0;
		_Z4SortI7COUNTEDER5ArrayI7COUNTEDE( &A$1 );
		if( (int64)COPIEDCOUNTED$ == 0ll) goto label$1467;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 628ll, (char*)"__FB_MODLEVELPROC__", (char*)"copiedCounted = 0" );
			label$1467:;
		}
		if( (int64)DESTROYEDCOUNTED$ == 0ll) goto label$1469;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 629ll, (char*)"__FB_MODLEVELPROC__", (char*)"destroyedCounted = 0" );
			label$1469:;
		}
		if( (int64)LIVECOUNTED$ == (int64)LIVEBEFORE$1) goto label$1471;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 630ll, (char*)"__FB_MODLEVELPROC__", (char*)"liveCounted = liveBefore" );
			label$1471:;
		}
		boolean OK$1;
		OK$1 = (boolean)1ll;
		{
			int32 I$2;
			I$2 = 0;
			label$1475:;
			{
				struct $7COUNTED* vr$688 = _ZN5ArrayI7COUNTEDEixEi( &A$1, I$2 );
				if( (int64)*(int32*)vr$688 == (int64)I$2) goto label$1477;
				{
					OK$1 = (boolean)0ll;
					label$1477:;
				}
			}
			label$1473:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1472:;
			if( (int64)I$2 <= 99ll) goto label$1475;
			label$1474:;
		}
		if( (int64)-OK$1 != 0ll) goto label$1479;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 636ll, (char*)"__FB_MODLEVELPROC__", (char*)"ok" );
			label$1479:;
		}
		struct $5ArrayI7COUNTEDE B$1;
		_ZN5ArrayI7COUNTEDEC1Ev( &B$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1483:;
			{
				struct $7COUNTED TMP$262$3;
				_ZN7COUNTEDC1Ei( &TMP$262$3, (int32)(-(int64)I$2 + 99ll) );
				_ZN5ArrayI7COUNTEDE4PUSHERS0_( &B$1, &TMP$262$3 );
				_ZN7COUNTEDD1Ev( &TMP$262$3 );
			}
			label$1481:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1480:;
			if( (int64)I$2 <= 99ll) goto label$1483;
			label$1482:;
		}
		LIVEBEFORE$1 = LIVECOUNTED$;
		COPIEDCOUNTED$ = 0;
		_Z10StableSortI7COUNTEDER5ArrayI7COUNTEDE( &B$1 );
		if( (int64)COPIEDCOUNTED$ == 0ll) goto label$1485;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 650ll, (char*)"__FB_MODLEVELPROC__", (char*)"copiedCounted = 0" );
			label$1485:;
		}
		if( (int64)LIVECOUNTED$ == (int64)LIVEBEFORE$1) goto label$1487;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 651ll, (char*)"__FB_MODLEVELPROC__", (char*)"liveCounted = liveBefore" );
			label$1487:;
		}
		OK$1 = (boolean)1ll;
		{
			int32 I$2;
			I$2 = 0;
			label$1491:;
			{
				struct $7COUNTED* vr$714 = _ZN5ArrayI7COUNTEDEixEi( &B$1, I$2 );
				if( (int64)*(int32*)vr$714 == (int64)I$2) goto label$1493;
				{
					OK$1 = (boolean)0ll;
					label$1493:;
				}
			}
			label$1489:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1488:;
			if( (int64)I$2 <= 99ll) goto label$1491;
			label$1490:;
		}
		if( (int64)-OK$1 != 0ll) goto label$1495;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 656ll, (char*)"__FB_MODLEVELPROC__", (char*)"ok" );
			label$1495:;
		}
		_ZN5ArrayI7COUNTEDED1Ev( &B$1 );
		_ZN5ArrayI7COUNTEDED1Ev( &A$1 );
	}
	{
		SEEDRNG( 4242ull );
		{
			int32 SHAPE$2;
			SHAPE$2 = 0;
			label$1688:;
			{
				{
					int32 N$4;
					N$4 = 0;
					label$1692:;
					{
						struct $5ArrayIiE SRC$5;
						_ZN5ArrayIiEC1Ev( &SRC$5 );
						MAKESHAPE( &SRC$5, SHAPE$2, N$4 );
						struct $10LinkedListIiE L$5;
						_ZN10LinkedListIiEC1Ev( &L$5 );
						{
							int32 I$6;
							I$6 = 0;
							int32 TMP$282$6;
							TMP$282$6 = (int32)((int64)N$4 + -1ll);
							goto label$1693;
							label$1696:;
							{
								int32* vr$731 = _ZN5ArrayIiEixEi( &SRC$5, I$6 );
								_ZN10LinkedListIiE8PUSHBACKERi( &L$5, vr$731 );
							}
							label$1694:;
							I$6 = (int32)((int64)I$6 + 1ll);
							label$1693:;
							if( (int64)I$6 <= (int64)TMP$282$6) goto label$1696;
							label$1695:;
						}
						_Z8SortListIiER10LinkedListIiE( &L$5 );
						int32 vr$740 = _ZN10LinkedListIiE5COUNTEv( &L$5 );
						if( (int64)vr$740 == (int64)N$4) goto label$1698;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 676ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.Count( ) = n" );
							label$1698:;
						}
						struct $5ArrayIiE FWD$5;
						LISTFORWARD( &FWD$5, &L$5 );
						int32 vr$746 = _ZN5ArrayIiE5COUNTEv( &FWD$5 );
						if( (int64)vr$746 == (int64)N$4) goto label$1700;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 679ll, (char*)"__FB_MODLEVELPROC__", (char*)"fwd.Count( ) = n" );
							label$1700:;
						}
						boolean vr$750 = _Z8IsSortedIiER5ArrayIiE( &FWD$5 );
						if( (int64)-vr$750 != 0ll) goto label$1702;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 680ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( fwd )" );
							label$1702:;
						}
						boolean vr$754 = SAMEMULTISET( &FWD$5, &SRC$5 );
						if( (int64)-vr$754 != 0ll) goto label$1704;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 681ll, (char*)"__FB_MODLEVELPROC__", (char*)"SameMultiset( fwd, src )" );
							label$1704:;
						}
						struct $5ArrayIiE BWD$5;
						LISTBACKWARD( &BWD$5, &L$5 );
						int32 vr$759 = _ZN5ArrayIiE5COUNTEv( &BWD$5 );
						if( (int64)vr$759 == (int64)N$4) goto label$1706;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 685ll, (char*)"__FB_MODLEVELPROC__", (char*)"bwd.Count( ) = n" );
							label$1706:;
						}
						boolean MIRRORED$5;
						MIRRORED$5 = (boolean)1ll;
						{
							int32 I$6;
							I$6 = 0;
							int32 TMP$290$6;
							TMP$290$6 = (int32)((int64)N$4 + -1ll);
							goto label$1707;
							label$1710:;
							{
								int32* vr$766 = _ZN5ArrayIiEixEi( &BWD$5, I$6 );
								int32* vr$774 = _ZN5ArrayIiEixEi( &FWD$5, (int32)(((int64)N$4 + -1ll) - (int64)I$6) );
								if( (int64)*vr$766 == (int64)*vr$774) goto label$1712;
								{
									MIRRORED$5 = (boolean)0ll;
									label$1712:;
								}
							}
							label$1708:;
							I$6 = (int32)((int64)I$6 + 1ll);
							label$1707:;
							if( (int64)I$6 <= (int64)TMP$290$6) goto label$1710;
							label$1709:;
						}
						if( (int64)-MIRRORED$5 != 0ll) goto label$1714;
						{
							fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 690ll, (char*)"__FB_MODLEVELPROC__", (char*)"mirrored" );
							label$1714:;
						}
						if( (int64)N$4 <= 0ll) goto label$1716;
						{
							if( *(struct $10LinkedNodeIiE**)&L$5 != (struct $10LinkedNodeIiE*)0ull) goto label$1718;
							{
								fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 695ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.head <> 0" );
								label$1718:;
							}
							if( *(struct $10LinkedNodeIiE**)((uint8*)&L$5 + 8ll) != (struct $10LinkedNodeIiE*)0ull) goto label$1720;
							{
								fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 696ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.tail <> 0" );
								label$1720:;
							}
							if( *(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)&L$5 + 16ll) == (struct $10LinkedNodeIiE*)0ull) goto label$1722;
							{
								fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 697ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.head->prv = 0" );
								label$1722:;
							}
							if( *(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)((uint8*)&L$5 + 8ll) + 8ll) == (struct $10LinkedNodeIiE*)0ull) goto label$1724;
							{
								fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 698ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.tail->nxt = 0" );
								label$1724:;
							}
							int32* vr$786 = _ZN10LinkedListIiE5FRONTEv( &L$5 );
							int32* vr$789 = _ZN5ArrayIiEixEi( &FWD$5, 0 );
							if( (int64)*vr$786 == (int64)*vr$789) goto label$1726;
							{
								fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 699ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.Front( ) = fwd[ 0 ]" );
								label$1726:;
							}
							int32* vr$792 = _ZN10LinkedListIiE4BACKEv( &L$5 );
							int32* vr$798 = _ZN5ArrayIiEixEi( &FWD$5, (int32)((int64)N$4 + -1ll) );
							if( (int64)*vr$792 == (int64)*vr$798) goto label$1728;
							{
								fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 700ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.Back( ) = fwd[ n-1 ]" );
								label$1728:;
							}
						}
						label$1716:;
						label$1715:;
						_ZN5ArrayIiED1Ev( &BWD$5 );
						_ZN5ArrayIiED1Ev( &FWD$5 );
						_ZN10LinkedListIiED1Ev( &L$5 );
						_ZN5ArrayIiED1Ev( &SRC$5 );
					}
					label$1690:;
					N$4 = (int32)((int64)N$4 + 1ll);
					label$1689:;
					if( (int64)N$4 <= 40ll) goto label$1692;
					label$1691:;
				}
			}
			label$1686:;
			SHAPE$2 = (int32)((int64)SHAPE$2 + 1ll);
			label$1685:;
			if( (int64)SHAPE$2 <= 7ll) goto label$1688;
			label$1687:;
		}
	}
	{
		int32 TMP$307$1;
		int32 TMP$308$1;
		struct $10LinkedListIiE L$1;
		_ZN10LinkedListIiEC1Ev( &L$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1767:;
			{
				int32 TMP$303$3;
				TMP$303$3 = (int32)(-(int64)I$2 + 19ll);
				_ZN10LinkedListIiE8PUSHBACKERi( &L$1, &TMP$303$3 );
			}
			label$1765:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1764:;
			if( (int64)I$2 <= 19ll) goto label$1767;
			label$1766:;
		}
		_Z8SortListIiER10LinkedListIiE( &L$1 );
		int32 vr$825 = _ZN10LinkedListIiE8POPFRONTEv( &L$1 );
		if( (int64)vr$825 == 0ll) goto label$1769;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 716ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.PopFront( ) = 0" );
			label$1769:;
		}
		int32 vr$828 = _ZN10LinkedListIiE7POPBACKEv( &L$1 );
		if( (int64)vr$828 == 19ll) goto label$1771;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 717ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.PopBack( ) = 19" );
			label$1771:;
		}
		int32 vr$831 = _ZN10LinkedListIiE5COUNTEv( &L$1 );
		if( (int64)vr$831 == 18ll) goto label$1773;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 718ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.Count( ) = 18" );
			label$1773:;
		}
		TMP$307$1 = -1;
		_ZN10LinkedListIiE9PUSHFRONTERi( &L$1, &TMP$307$1 );
		TMP$308$1 = 99;
		_ZN10LinkedListIiE8PUSHBACKERi( &L$1, &TMP$308$1 );
		int32* vr$838 = _ZN10LinkedListIiE5FRONTEv( &L$1 );
		if( (int64)*vr$838 == -1ll) goto label$1775;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 721ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.Front( ) = -1" );
			label$1775:;
		}
		int32* vr$841 = _ZN10LinkedListIiE4BACKEv( &L$1 );
		if( (int64)*vr$841 == 99ll) goto label$1777;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 722ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.Back( ) = 99" );
			label$1777:;
		}
		int32 vr$844 = _ZN10LinkedListIiE5COUNTEv( &L$1 );
		if( (int64)vr$844 == 20ll) goto label$1779;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 723ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.Count( ) = 20" );
			label$1779:;
		}
		struct $5ArrayIiE FWD$1;
		LISTFORWARD( &FWD$1, &L$1 );
		boolean vr$849 = _Z8IsSortedIiER5ArrayIiE( &FWD$1 );
		if( (int64)-vr$849 != 0ll) goto label$1781;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 726ll, (char*)"__FB_MODLEVELPROC__", (char*)"IsSorted( fwd )" );
			label$1781:;
		}
		struct $10LinkedListIiE COPY_$1;
		_ZN10LinkedListIiEC1ERS0_( &COPY_$1, &L$1 );
		int32 vr$854 = _ZN10LinkedListIiE5COUNTEv( &COPY_$1 );
		if( (int64)vr$854 == 20ll) goto label$1783;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 730ll, (char*)"__FB_MODLEVELPROC__", (char*)"copy_.Count( ) = 20" );
			label$1783:;
		}
		_ZN10LinkedListIiE8POPFRONTEv( &COPY_$1 );
		int32 vr$858 = _ZN10LinkedListIiE5COUNTEv( &COPY_$1 );
		if( (int64)vr$858 == 19ll) goto label$1785;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 732ll, (char*)"__FB_MODLEVELPROC__", (char*)"copy_.Count( ) = 19" );
			label$1785:;
		}
		int32 vr$861 = _ZN10LinkedListIiE5COUNTEv( &L$1 );
		if( (int64)vr$861 == 20ll) goto label$1787;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 733ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.Count( ) = 20" );
			label$1787:;
		}
		_ZN10LinkedListIiED1Ev( &COPY_$1 );
		_ZN5ArrayIiED1Ev( &FWD$1 );
		_ZN10LinkedListIiED1Ev( &L$1 );
	}
	{
		int32 TMP$317$1;
		int32 TMP$322$1;
		int32 TMP$323$1;
		struct $10LinkedListIiE E$1;
		_ZN10LinkedListIiEC1Ev( &E$1 );
		_Z8SortListIiER10LinkedListIiE( &E$1 );
		int32 vr$869 = _ZN10LinkedListIiE5COUNTEv( &E$1 );
		if( (int64)vr$869 == 0ll) goto label$1789;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 740ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.Count( ) = 0" );
			label$1789:;
		}
		if( *(struct $10LinkedNodeIiE**)&E$1 == (struct $10LinkedNodeIiE*)0ull) goto label$1791;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 741ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.head = 0" );
			label$1791:;
		}
		if( *(struct $10LinkedNodeIiE**)((uint8*)&E$1 + 8ll) == (struct $10LinkedNodeIiE*)0ull) goto label$1793;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 742ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.tail = 0" );
			label$1793:;
		}
		struct $10LinkedListIiE ONE$1;
		_ZN10LinkedListIiEC1Ev( &ONE$1 );
		TMP$317$1 = 5;
		_ZN10LinkedListIiE8PUSHBACKERi( &ONE$1, &TMP$317$1 );
		_Z8SortListIiER10LinkedListIiE( &ONE$1 );
		int32 vr$876 = _ZN10LinkedListIiE5COUNTEv( &ONE$1 );
		if( (int64)vr$876 == 1ll) goto label$1795;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 747ll, (char*)"__FB_MODLEVELPROC__", (char*)"one.Count( ) = 1" );
			label$1795:;
		}
		int32* vr$879 = _ZN10LinkedListIiE5FRONTEv( &ONE$1 );
		if( (int64)*vr$879 == 5ll) goto label$1797;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 748ll, (char*)"__FB_MODLEVELPROC__", (char*)"one.Front( ) = 5" );
			label$1797:;
		}
		if( *(struct $10LinkedNodeIiE**)&ONE$1 == *(struct $10LinkedNodeIiE**)((uint8*)&ONE$1 + 8ll)) goto label$1799;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 749ll, (char*)"__FB_MODLEVELPROC__", (char*)"one.head = one.tail" );
			label$1799:;
		}
		if( *(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)&ONE$1 + 16ll) == (struct $10LinkedNodeIiE*)0ull) goto label$1801;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 750ll, (char*)"__FB_MODLEVELPROC__", (char*)"one.head->prv = 0" );
			label$1801:;
		}
		if( *(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)((uint8*)&ONE$1 + 8ll) + 8ll) == (struct $10LinkedNodeIiE*)0ull) goto label$1803;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 751ll, (char*)"__FB_MODLEVELPROC__", (char*)"one.tail->nxt = 0" );
			label$1803:;
		}
		struct $10LinkedListIiE TWO$1;
		_ZN10LinkedListIiEC1Ev( &TWO$1 );
		TMP$322$1 = 2;
		_ZN10LinkedListIiE8PUSHBACKERi( &TWO$1, &TMP$322$1 );
		TMP$323$1 = 1;
		_ZN10LinkedListIiE8PUSHBACKERi( &TWO$1, &TMP$323$1 );
		_Z8SortListIiER10LinkedListIiE( &TWO$1 );
		int32* vr$890 = _ZN10LinkedListIiE5FRONTEv( &TWO$1 );
		if( (int64)*vr$890 == 1ll) goto label$1805;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 756ll, (char*)"__FB_MODLEVELPROC__", (char*)"two.Front( ) = 1" );
			label$1805:;
		}
		int32* vr$893 = _ZN10LinkedListIiE4BACKEv( &TWO$1 );
		if( (int64)*vr$893 == 2ll) goto label$1807;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 757ll, (char*)"__FB_MODLEVELPROC__", (char*)"two.Back( ) = 2" );
			label$1807:;
		}
		if( *(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)&TWO$1 + 8ll) == *(struct $10LinkedNodeIiE**)((uint8*)&TWO$1 + 8ll)) goto label$1809;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 758ll, (char*)"__FB_MODLEVELPROC__", (char*)"two.head->nxt = two.tail" );
			label$1809:;
		}
		if( *(struct $10LinkedNodeIiE**)((uint8*)*(struct $10LinkedNodeIiE**)((uint8*)&TWO$1 + 8ll) + 16ll) == *(struct $10LinkedNodeIiE**)&TWO$1) goto label$1811;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 759ll, (char*)"__FB_MODLEVELPROC__", (char*)"two.tail->prv = two.head" );
			label$1811:;
		}
		_ZN10LinkedListIiED1Ev( &TWO$1 );
		_ZN10LinkedListIiED1Ev( &ONE$1 );
		_ZN10LinkedListIiED1Ev( &E$1 );
	}
	{
		FBSTRING TMP$329$1;
		FBSTRING TMP$331$1;
		FBSTRING TMP$333$1;
		FBSTRING TMP$335$1;
		struct $10LinkedListI8FBSTRINGE L$1;
		_ZN10LinkedListI8FBSTRINGEC1Ev( &L$1 );
		__builtin_memset( &TMP$329$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$329$1, -1ll, (void*)"delta", 6ll, 0 );
		_ZN10LinkedListI8FBSTRINGE8PUSHBACKERS0_( &L$1, &TMP$329$1 );
		fb_StrDelete( (FBSTRING*)&TMP$329$1 );
		__builtin_memset( &TMP$331$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$331$1, -1ll, (void*)"alpha", 6ll, 0 );
		_ZN10LinkedListI8FBSTRINGE8PUSHBACKERS0_( &L$1, &TMP$331$1 );
		fb_StrDelete( (FBSTRING*)&TMP$331$1 );
		__builtin_memset( &TMP$333$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$333$1, -1ll, (void*)"charlie", 8ll, 0 );
		_ZN10LinkedListI8FBSTRINGE8PUSHBACKERS0_( &L$1, &TMP$333$1 );
		fb_StrDelete( (FBSTRING*)&TMP$333$1 );
		__builtin_memset( &TMP$335$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$335$1, -1ll, (void*)"bravo", 6ll, 0 );
		_ZN10LinkedListI8FBSTRINGE8PUSHBACKERS0_( &L$1, &TMP$335$1 );
		fb_StrDelete( (FBSTRING*)&TMP$335$1 );
		int32 COMPARISONS$1;
		COMPARISONS$1 = 0;
		struct $25LD2939E50C2FFBF23_Lt_0150IiE TMP$337$1;
		__builtin_memset( &TMP$337$1, 0, 8ll );
		*(int32**)&TMP$337$1 = &COMPARISONS$1;
		_Z10SortListByI8FBSTRING25LD2939E50C2FFBF23_Lt_0150IiEER10LinkedListI8FBSTRINGERS2_( &L$1, &TMP$337$1 );
		if( (int64)COMPARISONS$1 > 0ll) goto label$1821;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 774ll, (char*)"__FB_MODLEVELPROC__", (char*)"comparisons > 0" );
			label$1821:;
		}
		FBSTRING* vr$927 = _ZN10LinkedListI8FBSTRINGE8POPFRONTEv( &L$1 );
		int32 vr$928 = fb_StrCompare( (void*)vr$927, -1ll, (void*)"delta", 6ll );
		if( (int64)vr$928 == 0ll) goto label$1823;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 775ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.PopFront( ) = \x22" "delta\x22" );
			label$1823:;
		}
		FBSTRING* vr$931 = _ZN10LinkedListI8FBSTRINGE8POPFRONTEv( &L$1 );
		int32 vr$932 = fb_StrCompare( (void*)vr$931, -1ll, (void*)"charlie", 8ll );
		if( (int64)vr$932 == 0ll) goto label$1825;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 776ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.PopFront( ) = \x22" "charlie\x22" );
			label$1825:;
		}
		FBSTRING* vr$935 = _ZN10LinkedListI8FBSTRINGE8POPFRONTEv( &L$1 );
		int32 vr$936 = fb_StrCompare( (void*)vr$935, -1ll, (void*)"bravo", 6ll );
		if( (int64)vr$936 == 0ll) goto label$1827;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 777ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.PopFront( ) = \x22" "bravo\x22" );
			label$1827:;
		}
		FBSTRING* vr$939 = _ZN10LinkedListI8FBSTRINGE8POPFRONTEv( &L$1 );
		int32 vr$940 = fb_StrCompare( (void*)vr$939, -1ll, (void*)"alpha", 6ll );
		if( (int64)vr$940 == 0ll) goto label$1829;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 778ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.PopFront( ) = \x22" "alpha\x22" );
			label$1829:;
		}
		boolean vr$943 = _ZN10LinkedListI8FBSTRINGE7ISEMPTYEv( &L$1 );
		if( (int64)-vr$943 != 0ll) goto label$1831;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 779ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.IsEmpty( )" );
			label$1831:;
		}
		_ZN10LinkedListI8FBSTRINGED1Ev( &L$1 );
	}
	{
		SEEDRNG( 31337ull );
		struct $10LinkedListI3RECE L$1;
		_ZN10LinkedListI3RECEC1Ev( &L$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$1933:;
			{
				struct $3REC X$3;
				__builtin_memset( &X$3, 0, 8ll );
				int32 vr$948 = NEXTRNG( 5 );
				*(int32*)&X$3 = vr$948;
				*(int32*)((uint8*)&X$3 + 4ll) = I$2;
				_ZN10LinkedListI3RECE8PUSHBACKERS0_( &L$1, &X$3 );
			}
			label$1931:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$1930:;
			if( (int64)I$2 <= 199ll) goto label$1933;
			label$1932:;
		}
		_Z8SortListI3RECER10LinkedListI3RECE( &L$1 );
		int32 vr$957 = _ZN10LinkedListI3RECE5COUNTEv( &L$1 );
		if( (int64)vr$957 == 200ll) goto label$1935;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 795ll, (char*)"__FB_MODLEVELPROC__", (char*)"l.Count( ) = 200" );
			label$1935:;
		}
		boolean OK$1;
		OK$1 = (boolean)1ll;
		struct $10LinkedNodeI3RECE* P$1;
		P$1 = *(struct $10LinkedNodeI3RECE**)&L$1;
		int32 PREVKEY$1;
		PREVKEY$1 = -1;
		int32 PREVTAG$1;
		PREVTAG$1 = -1;
		label$1936:;
		if( P$1 == (struct $10LinkedNodeI3RECE*)0ull) goto label$1937;
		{
			if( (int64)*(int32*)P$1 >= (int64)PREVKEY$1) goto label$1939;
			{
				OK$1 = (boolean)0ll;
				label$1939:;
			}
			if( (int64)*(int32*)P$1 != (int64)PREVKEY$1) goto label$1941;
			{
				if( (int64)*(int32*)((uint8*)P$1 + 4ll) > (int64)PREVTAG$1) goto label$1943;
				{
					OK$1 = (boolean)0ll;
					label$1943:;
				}
			}
			label$1941:;
			label$1940:;
			PREVKEY$1 = *(int32*)P$1;
			PREVTAG$1 = *(int32*)((uint8*)P$1 + 4ll);
			P$1 = *(struct $10LinkedNodeI3RECE**)((uint8*)P$1 + 8ll);
		}
		goto label$1936;
		label$1937:;
		if( (int64)-OK$1 != 0ll) goto label$1945;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 808ll, (char*)"__FB_MODLEVELPROC__", (char*)"ok" );
			label$1945:;
		}
		_ZN10LinkedListI3RECED1Ev( &L$1 );
	}
	{
		struct $10LinkedListI7COUNTEDE L$1;
		_ZN10LinkedListI7COUNTEDEC1Ev( &L$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$2057:;
			{
				struct $7COUNTED TMP$358$3;
				_ZN7COUNTEDC1Ei( &TMP$358$3, (int32)(-(int64)I$2 + 99ll) );
				_ZN10LinkedListI7COUNTEDE8PUSHBACKERS0_( &L$1, &TMP$358$3 );
				_ZN7COUNTEDD1Ev( &TMP$358$3 );
			}
			label$2055:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$2054:;
			if( (int64)I$2 <= 99ll) goto label$2057;
			label$2056:;
		}
		int32 LIVEBEFORE$1;
		LIVEBEFORE$1 = LIVECOUNTED$;
		COPIEDCOUNTED$ = 0;
		DESTROYEDCOUNTED$ = 0;
		_Z8SortListI7COUNTEDER10LinkedListI7COUNTEDE( &L$1 );
		if( (int64)COPIEDCOUNTED$ == 0ll) goto label$2059;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 825ll, (char*)"__FB_MODLEVELPROC__", (char*)"copiedCounted = 0" );
			label$2059:;
		}
		if( (int64)DESTROYEDCOUNTED$ == 0ll) goto label$2061;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 826ll, (char*)"__FB_MODLEVELPROC__", (char*)"destroyedCounted = 0" );
			label$2061:;
		}
		if( (int64)LIVECOUNTED$ == (int64)LIVEBEFORE$1) goto label$2063;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 827ll, (char*)"__FB_MODLEVELPROC__", (char*)"liveCounted = liveBefore" );
			label$2063:;
		}
		boolean OK$1;
		OK$1 = (boolean)1ll;
		struct $10LinkedNodeI7COUNTEDE* P$1;
		P$1 = *(struct $10LinkedNodeI7COUNTEDE**)&L$1;
		int32 EXPECT$1;
		EXPECT$1 = 0;
		label$2064:;
		if( P$1 == (struct $10LinkedNodeI7COUNTEDE*)0ull) goto label$2065;
		{
			if( (int64)*(int32*)P$1 == (int64)EXPECT$1) goto label$2067;
			{
				OK$1 = (boolean)0ll;
				label$2067:;
			}
			EXPECT$1 = (int32)((int64)EXPECT$1 + 1ll);
			P$1 = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)P$1 + 8ll);
		}
		goto label$2064;
		label$2065:;
		if( (int64)-OK$1 != 0ll) goto label$2069;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 837ll, (char*)"__FB_MODLEVELPROC__", (char*)"ok" );
			label$2069:;
		}
		if( (int64)EXPECT$1 == 100ll) goto label$2071;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 838ll, (char*)"__FB_MODLEVELPROC__", (char*)"expect = 100" );
			label$2071:;
		}
		_ZN10LinkedListI7COUNTEDED1Ev( &L$1 );
	}
	{
		struct $5ArrayI5ArrayIiEE OUTER_$1;
		_ZN5ArrayI5ArrayIiEEC1Ev( &OUTER_$1 );
		{
			int32 I$2;
			I$2 = 0;
			label$2195:;
			{
				int32 TMP$380$3;
				int32 TMP$381$3;
				struct $5ArrayIiE INNER$3;
				_ZN5ArrayIiEC1Ev( &INNER$3 );
				TMP$380$3 = (int32)(-(int64)I$2 + 5ll);
				_ZN5ArrayIiE4PUSHERi( &INNER$3, &TMP$380$3 );
				TMP$381$3 = 1;
				_ZN5ArrayIiE4PUSHERi( &INNER$3, &TMP$381$3 );
				_ZN5ArrayI5ArrayIiEE4PUSHERS1_( &OUTER_$1, &INNER$3 );
				_ZN5ArrayIiED1Ev( &INNER$3 );
			}
			label$2193:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$2192:;
			if( (int64)I$2 <= 4ll) goto label$2195;
			label$2194:;
		}
		{
			int32 I$2;
			I$2 = 0;
			label$2199:;
			{
				struct $5ArrayIiE* vr$1019 = _ZN5ArrayI5ArrayIiEEixEi( &OUTER_$1, I$2 );
				_Z4SortIiER5ArrayIiE( vr$1019 );
				struct $5ArrayIiE* vr$1021 = _ZN5ArrayI5ArrayIiEEixEi( &OUTER_$1, I$2 );
				int32* vr$1022 = _ZN5ArrayIiEixEi( vr$1021, 0 );
				struct $5ArrayIiE* vr$1025 = _ZN5ArrayI5ArrayIiEEixEi( &OUTER_$1, I$2 );
				int32* vr$1026 = _ZN5ArrayIiEixEi( vr$1025, 1 );
				if( (int64)*vr$1022 <= (int64)*vr$1026) goto label$2201;
				{
					fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 857ll, (char*)"__FB_MODLEVELPROC__", (char*)"outer_[ i ][ 0 ] <= outer_[ i ][ 1 ]" );
					label$2201:;
				}
			}
			label$2197:;
			I$2 = (int32)((int64)I$2 + 1ll);
			label$2196:;
			if( (int64)I$2 <= 4ll) goto label$2199;
			label$2198:;
		}
		int32 vr$1033 = _ZN5ArrayI5ArrayIiEE5COUNTEv( &OUTER_$1 );
		if( (int64)vr$1033 == 5ll) goto label$2203;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 859ll, (char*)"__FB_MODLEVELPROC__", (char*)"outer_.Count( ) = 5" );
			label$2203:;
		}
		_ZN5ArrayI5ArrayIiEED1Ev( &OUTER_$1 );
	}
	{
		FBSTRING TMP$394$1;
		FBSTRING TMP$395$1;
		FBSTRING TMP$396$1;
		struct $5ArrayI8FBSTRINGE KS$1;
		_ZN5ArrayI8FBSTRINGEC1Ev( &KS$1 );
		__builtin_memset( &TMP$394$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$394$1, -1ll, (void*)"pear", 5ll, 0 );
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &KS$1, &TMP$394$1 );
		fb_StrDelete( (FBSTRING*)&TMP$394$1 );
		__builtin_memset( &TMP$395$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$395$1, -1ll, (void*)"apple", 6ll, 0 );
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &KS$1, &TMP$395$1 );
		fb_StrDelete( (FBSTRING*)&TMP$395$1 );
		__builtin_memset( &TMP$396$1, 0, 24ll );
		fb_StrAssign( (void*)&TMP$396$1, -1ll, (void*)"fig", 4ll, 0 );
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &KS$1, &TMP$396$1 );
		fb_StrDelete( (FBSTRING*)&TMP$396$1 );
		_Z4SortI8FBSTRINGER5ArrayI8FBSTRINGE( &KS$1 );
		FBSTRING* vr$1054 = _ZN5ArrayI8FBSTRINGEixEi( &KS$1, 0 );
		int32 vr$1055 = fb_StrCompare( (void*)vr$1054, -1ll, (void*)"apple", 6ll );
		if( (int64)vr$1055 == 0ll) goto label$2277;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 871ll, (char*)"__FB_MODLEVELPROC__", (char*)"ks[ 0 ] = \x22" "apple\x22" );
			label$2277:;
		}
		FBSTRING* vr$1058 = _ZN5ArrayI8FBSTRINGEixEi( &KS$1, 1 );
		int32 vr$1059 = fb_StrCompare( (void*)vr$1058, -1ll, (void*)"fig", 4ll );
		if( (int64)vr$1059 == 0ll) goto label$2279;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 872ll, (char*)"__FB_MODLEVELPROC__", (char*)"ks[ 1 ] = \x22" "fig\x22" );
			label$2279:;
		}
		FBSTRING* vr$1062 = _ZN5ArrayI8FBSTRINGEixEi( &KS$1, 2 );
		int32 vr$1063 = fb_StrCompare( (void*)vr$1062, -1ll, (void*)"pear", 5ll );
		if( (int64)vr$1063 == 0ll) goto label$2281;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cgenerics\x5C" "container-sort.bas", 873ll, (char*)"__FB_MODLEVELPROC__", (char*)"ks[ 2 ] = \x22pear\x22" );
			label$2281:;
		}
		_ZN5ArrayI8FBSTRINGED1Ev( &KS$1 );
	}
	FBSTRING* vr$1066 = fb_StrAllocTempDescZEx( (char*)"container-sort: ok", 18ll );
	fb_PrintString( 0, (FBSTRING*)vr$1066, 1 );
	label$1:;
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
	label$20:;
	label$21:;
}

static void _ZN5ArrayIiEaSERKS0_( struct $5ArrayIiE* THIS$1, struct $5ArrayIiE* __FB_RHS__$1 )
{
	int32* TMP$2$1;
	int32* TMP$3$1;
	int32* TMP$4$1;
	label$22:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)0ull, (void*)0ull );
	TMP$2$1 = *(int32**)((uint8*)THIS$1 + 8ll);
	TMP$3$1 = *(int32**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$4$1 = (int32*)((uint8*)TMP$3$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$24:;
	if( TMP$3$1 >= TMP$4$1) goto label$25;
	*TMP$2$1 = *TMP$3$1;
	TMP$2$1 = (int32*)((uint8*)TMP$2$1 + 4ll);
	TMP$3$1 = (int32*)((uint8*)TMP$3$1 + 4ll);
	goto label$24;
	label$25:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$23:;
}

static void _ZN5ArrayIiEC1ERKS0_( struct $5ArrayIiE* THIS$1, struct $5ArrayIiE* __FB_RHS__$1 )
{
	label$26:;
	*(int32**)THIS$1 = (int32*)0ull;
	*(int32**)((uint8*)THIS$1 + 8ll) = (int32*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 4ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	_ZN5ArrayIiEaSERKS0_( THIS$1, __FB_RHS__$1 );
	label$27:;
}

static void _ZN5ArrayIiED1Ev( struct $5ArrayIiE* THIS$1 )
{
	label$28:;
	label$29:;
	fb_ArrayErase( (struct $7FBARRAYIvE*)THIS$1 );
}

static void _ZN5ArrayI8FBSTRINGEC1Ev( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	*(FBSTRING**)THIS$1 = (FBSTRING*)0ull;
	*(FBSTRING**)((uint8*)THIS$1 + 8ll) = (FBSTRING*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 24ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$408:;
	label$409:;
}

static void _ZN5ArrayI8FBSTRINGEaSERKS1_( struct $5ArrayI8FBSTRINGE* THIS$1, struct $5ArrayI8FBSTRINGE* __FB_RHS__$1 )
{
	FBSTRING* TMP$83$1;
	FBSTRING* TMP$84$1;
	FBSTRING* TMP$85$1;
	label$410:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, -1, (void*)0ull, (void*)0ull );
	TMP$83$1 = *(FBSTRING**)((uint8*)THIS$1 + 8ll);
	TMP$84$1 = *(FBSTRING**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$85$1 = (FBSTRING*)((uint8*)TMP$84$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$412:;
	if( TMP$84$1 >= TMP$85$1) goto label$413;
	fb_StrAssign( (void*)TMP$83$1, -1ll, (void*)TMP$84$1, -1ll, 0 );
	TMP$83$1 = (FBSTRING*)((uint8*)TMP$83$1 + 24ll);
	TMP$84$1 = (FBSTRING*)((uint8*)TMP$84$1 + 24ll);
	goto label$412;
	label$413:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$411:;
}

static void _ZN5ArrayI8FBSTRINGED1Ev( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	label$416:;
	label$417:;
	fb_ArrayStrErase( (struct $7FBARRAYIvE*)THIS$1 );
}

static void _ZN5ArrayIdEC1Ev( struct $5ArrayIdE* THIS$1 )
{
	*(double**)THIS$1 = (double*)0ull;
	*(double**)((uint8*)THIS$1 + 8ll) = (double*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 8ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$432:;
	label$433:;
}

static void _ZN5ArrayIdEaSERKS0_( struct $5ArrayIdE* THIS$1, struct $5ArrayIdE* __FB_RHS__$1 )
{
	double* TMP$103$1;
	double* TMP$104$1;
	double* TMP$105$1;
	label$434:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)0ull, (void*)0ull );
	TMP$103$1 = *(double**)((uint8*)THIS$1 + 8ll);
	TMP$104$1 = *(double**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$105$1 = (double*)((uint8*)TMP$104$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$436:;
	if( TMP$104$1 >= TMP$105$1) goto label$437;
	*TMP$103$1 = *TMP$104$1;
	TMP$103$1 = (double*)((uint8*)TMP$103$1 + 8ll);
	TMP$104$1 = (double*)((uint8*)TMP$104$1 + 8ll);
	goto label$436;
	label$437:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$435:;
}

static void _ZN5ArrayIdED1Ev( struct $5ArrayIdE* THIS$1 )
{
	label$440:;
	label$441:;
	fb_ArrayErase( (struct $7FBARRAYIvE*)THIS$1 );
}

static void _ZN5ArrayI3RECEC1Ev( struct $5ArrayI3RECE* THIS$1 )
{
	*(struct $3REC**)THIS$1 = (struct $3REC*)0ull;
	*(struct $3REC**)((uint8*)THIS$1 + 8ll) = (struct $3REC*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 8ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$452:;
	label$453:;
}

static void _ZN5ArrayI3RECEaSERKS1_( struct $5ArrayI3RECE* THIS$1, struct $5ArrayI3RECE* __FB_RHS__$1 )
{
	struct $3REC* TMP$116$1;
	struct $3REC* TMP$117$1;
	struct $3REC* TMP$118$1;
	label$454:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)0ull, (void*)0ull );
	TMP$116$1 = *(struct $3REC**)((uint8*)THIS$1 + 8ll);
	TMP$117$1 = *(struct $3REC**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$118$1 = (struct $3REC*)((uint8*)TMP$117$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$456:;
	if( TMP$117$1 >= TMP$118$1) goto label$457;
	__builtin_memcpy( TMP$116$1, TMP$117$1, 8 );
	TMP$116$1 = (struct $3REC*)((uint8*)TMP$116$1 + 8ll);
	TMP$117$1 = (struct $3REC*)((uint8*)TMP$117$1 + 8ll);
	goto label$456;
	label$457:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$455:;
}

static void _ZN5ArrayI3RECED1Ev( struct $5ArrayI3RECE* THIS$1 )
{
	label$460:;
	label$461:;
	fb_ArrayErase( (struct $7FBARRAYIvE*)THIS$1 );
}

static void _ZN5ArrayI7COUNTEDEC1Ev( struct $5ArrayI7COUNTEDE* THIS$1 )
{
	*(struct $7COUNTED**)THIS$1 = (struct $7COUNTED*)0ull;
	*(struct $7COUNTED**)((uint8*)THIS$1 + 8ll) = (struct $7COUNTED*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 4ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$1452:;
	label$1453:;
}

static void _ZN5ArrayI7COUNTEDEaSERKS1_( struct $5ArrayI7COUNTEDE* THIS$1, struct $5ArrayI7COUNTEDE* __FB_RHS__$1 )
{
	struct $7COUNTED* TMP$254$1;
	struct $7COUNTED* TMP$255$1;
	struct $7COUNTED* TMP$256$1;
	label$1454:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)&_ZN7COUNTEDC1Ev, (void*)&_ZN7COUNTEDD1Ev );
	TMP$254$1 = *(struct $7COUNTED**)((uint8*)THIS$1 + 8ll);
	TMP$255$1 = *(struct $7COUNTED**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$256$1 = (struct $7COUNTED*)((uint8*)TMP$255$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$1456:;
	if( TMP$255$1 >= TMP$256$1) goto label$1457;
	_ZN7COUNTEDaSERS_( TMP$254$1, TMP$255$1 );
	TMP$254$1 = (struct $7COUNTED*)((uint8*)TMP$254$1 + 4ll);
	TMP$255$1 = (struct $7COUNTED*)((uint8*)TMP$255$1 + 4ll);
	goto label$1456;
	label$1457:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$1455:;
}

static void _ZN5ArrayI7COUNTEDED1Ev( struct $5ArrayI7COUNTEDE* THIS$1 )
{
	label$1460:;
	label$1461:;
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN7COUNTEDC1Ev, (void*)&_ZN7COUNTEDD1Ev );
}

static void _ZN10LinkedNodeI8FBSTRINGEC1Ev( struct $10LinkedNodeI8FBSTRINGE* THIS$1 )
{
	__builtin_memset( (FBSTRING*)THIS$1, 0, 24ll );
	__builtin_memset( (struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 24ll), 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 32ll), 0, 8ll );
	label$1812:;
	label$1813:;
}

static void _ZN10LinkedNodeI8FBSTRINGEaSERKS1_( struct $10LinkedNodeI8FBSTRINGE* THIS$1, struct $10LinkedNodeI8FBSTRINGE* __FB_RHS__$1 )
{
	label$1814:;
	fb_StrAssign( (void*)THIS$1, -1ll, (void*)__FB_RHS__$1, -1ll, 0 );
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 24ll) = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)__FB_RHS__$1 + 24ll);
	*(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)THIS$1 + 32ll) = *(struct $10LinkedNodeI8FBSTRINGE**)((uint8*)__FB_RHS__$1 + 32ll);
	label$1815:;
}

static void _ZN10LinkedNodeI8FBSTRINGED1Ev( struct $10LinkedNodeI8FBSTRINGE* THIS$1 )
{
	label$1818:;
	label$1819:;
	fb_StrDelete( (FBSTRING*)THIS$1 );
}

static void _ZN10LinkedNodeI7COUNTEDEC1Ev( struct $10LinkedNodeI7COUNTEDE* THIS$1 )
{
	_ZN7COUNTEDC1Ev( (struct $7COUNTED*)THIS$1 );
	__builtin_memset( (struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 16ll), 0, 8ll );
	label$2046:;
	label$2047:;
}

static void _ZN10LinkedNodeI7COUNTEDEaSERKS1_( struct $10LinkedNodeI7COUNTEDE* THIS$1, struct $10LinkedNodeI7COUNTEDE* __FB_RHS__$1 )
{
	label$2048:;
	_ZN7COUNTEDaSERS_( (struct $7COUNTED*)THIS$1, (struct $7COUNTED*)__FB_RHS__$1 );
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 8ll) = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)__FB_RHS__$1 + 8ll);
	*(struct $10LinkedNodeI7COUNTEDE**)((uint8*)THIS$1 + 16ll) = *(struct $10LinkedNodeI7COUNTEDE**)((uint8*)__FB_RHS__$1 + 16ll);
	label$2049:;
}

static void _ZN10LinkedNodeI7COUNTEDED1Ev( struct $10LinkedNodeI7COUNTEDE* THIS$1 )
{
	label$2052:;
	label$2053:;
	_ZN7COUNTEDD1Ev( (struct $7COUNTED*)THIS$1 );
}

static void _ZN5ArrayI5ArrayIiEEC1Ev( struct $5ArrayI5ArrayIiEE* THIS$1 )
{
	*(struct $5ArrayIiE**)THIS$1 = (struct $5ArrayIiE*)0ull;
	*(struct $5ArrayIiE**)((uint8*)THIS$1 + 8ll) = (struct $5ArrayIiE*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 80ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$2182:;
	label$2183:;
}

static void _ZN5ArrayI5ArrayIiEEaSERKS2_( struct $5ArrayI5ArrayIiEE* THIS$1, struct $5ArrayI5ArrayIiEE* __FB_RHS__$1 )
{
	struct $5ArrayIiE* TMP$376$1;
	struct $5ArrayIiE* TMP$377$1;
	struct $5ArrayIiE* TMP$378$1;
	label$2184:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)&_ZN5ArrayIiEC1Ev, (void*)&_ZN5ArrayIiED1Ev );
	TMP$376$1 = *(struct $5ArrayIiE**)((uint8*)THIS$1 + 8ll);
	TMP$377$1 = *(struct $5ArrayIiE**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$378$1 = (struct $5ArrayIiE*)((uint8*)TMP$377$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$2186:;
	if( TMP$377$1 >= TMP$378$1) goto label$2187;
	_ZN5ArrayIiEaSERKS0_( TMP$376$1, (struct $5ArrayIiE*)TMP$377$1 );
	TMP$376$1 = (struct $5ArrayIiE*)((uint8*)TMP$376$1 + 80ll);
	TMP$377$1 = (struct $5ArrayIiE*)((uint8*)TMP$377$1 + 80ll);
	goto label$2186;
	label$2187:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$2185:;
}

static void _ZN5ArrayI5ArrayIiEED1Ev( struct $5ArrayI5ArrayIiEE* THIS$1 )
{
	label$2190:;
	label$2191:;
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN5ArrayIiEC1Ev, (void*)&_ZN5ArrayIiED1Ev );
}
