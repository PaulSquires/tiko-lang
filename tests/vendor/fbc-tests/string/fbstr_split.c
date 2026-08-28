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
struct $13ArrayIteratorI8FBSTRINGE {
	void* SRC;
	int32 IDX;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorI8FBSTRINGE ) == 16 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
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
struct $13ArrayIteratorI9FBUSTRINGE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorI9FBUSTRINGE ) == 16 );
struct $8FBARRAY1I9FBUSTRINGE {
	FBUSTRING* DATA;
	FBUSTRING* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1I9FBUSTRINGE ) == 72 );
struct $5ArrayI9FBUSTRINGE {
	struct $8FBARRAY1I9FBUSTRINGE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayI9FBUSTRINGE ) == 80 );
struct $13ArrayIteratorIN2FB6CSVROWEE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorIN2FB6CSVROWEE ) == 16 );
struct $N2FB6CSVROWE {
	struct $5ArrayI8FBSTRINGE FIELDS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB6CSVROWE ) == 80 );
struct $8FBARRAY1IN2FB6CSVROWEE {
	struct $N2FB6CSVROWE* DATA;
	struct $N2FB6CSVROWE* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1IN2FB6CSVROWEE ) == 72 );
struct $5ArrayIN2FB6CSVROWEE {
	struct $8FBARRAY1IN2FB6CSVROWEE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayIN2FB6CSVROWEE ) == 80 );
struct $13ArrayIteratorIN2FB7CSVUROWEE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorIN2FB7CSVUROWEE ) == 16 );
struct $N2FB7CSVUROWE {
	struct $5ArrayI9FBUSTRINGE FIELDS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB7CSVUROWE ) == 80 );
struct $8FBARRAY1IN2FB7CSVUROWEE {
	struct $N2FB7CSVUROWE* DATA;
	struct $N2FB7CSVUROWE* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1IN2FB7CSVUROWEE ) == 72 );
struct $5ArrayIN2FB7CSVUROWEE {
	struct $8FBARRAY1IN2FB7CSVUROWEE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayIN2FB7CSVUROWEE ) == 80 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
int32 fb_ArrayRedimEx( struct $7FBARRAYIvE*, uint64, int32, int32, uint64, ... );
int32 fb_ArrayRedimPresvEx( struct $7FBARRAYIvE*, uint64, int32, int32, uint64, ... );
int32 fb_ArrayRedimPresvObj( struct $7FBARRAYIvE*, uint64, void*, void*, uint64, ... );
int32 fb_ArrayRedimTo( struct $7FBARRAYIvE*, struct $7FBARRAYIvE*, int32, void*, void* );
void fb_ArrayDestructStr( struct $7FBARRAYIvE* );
void fb_ArrayDestructUStr( struct $7FBARRAYIvE* );
void fb_ArrayUStrErase( struct $7FBARRAYIvE* );
int32 fb_ArrayErase( struct $7FBARRAYIvE* );
int32 fb_ArrayEraseObj( struct $7FBARRAYIvE*, void*, void* );
void fb_ArrayStrErase( struct $7FBARRAYIvE* );
int64 fb_ArrayLBound( struct $7FBARRAYIKvE*, int64 );
int64 fb_ArrayUBound( struct $7FBARRAYIKvE*, int64 );
FBSTRING* fb_StrInit( void*, int64, void*, int64, int32 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
uint16* fb_WstrAssignFromA( uint16*, int64, void*, int64 );
void fb_StrDelete( FBSTRING* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_StrConcatAssign( void*, int64, void*, int64, int32 );
FBSTRING* fb_StrAllocTempResult( FBSTRING* );
FBSTRING* fb_StrMid( FBSTRING*, int64, int64 );
void fb_StrAssignMid( FBSTRING*, int64, int64, FBSTRING* );
int64 fb_StrLen( void*, int64 );
FBSTRING* fb_SPACE( int64 );
FBUSTRING* fb_UStrInit( void*, int64, void*, int64, int32 );
FBUSTRING* fb_UStrAssign( void*, int64, void*, int64, int32 );
void fb_UStrDelete( FBUSTRING* );
FBUSTRING* fb_UStrConcat( FBUSTRING*, void*, int64, void*, int64 );
FBUSTRING* fb_UStrConcatAssign( void*, int64, void*, int64, int32 );
int32 fb_UStrCompare( void*, int64, void*, int64 );
int64 fb_UStrLen( void*, int64 );
FBSTRING* fb_UStrAssignToA( void*, int64, void*, int64, int32, int32 );
FBUSTRING* fb_UStrAllocTempResult( FBUSTRING* );
FBUSTRING* fb_WstrToUStr( uint16* );
FBUSTRING* fb_UStrMid( void*, int64, int64, int64 );
void fb_UStrAssignMid( void*, int64, int64, int64, void*, int64 );
static void fb_ctor__fbstr_split( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
int64 fb_StrTally( FBSTRING*, FBUSTRING*, boolean );
int64 fb_UStrTally( FBUSTRING*, FBUSTRING*, boolean );
FBSTRING* fb_StrRepeat( int64, FBSTRING* );
FBUSTRING* fb_UStrRepeat( int64, FBUSTRING* );
int64 fb_StrSplitSpans( FBSTRING*, FBUSTRING*, boolean, int64*, int64 );
int64 fb_UStrSplitSpans( FBUSTRING*, FBUSTRING*, boolean, int64*, int64 );
int64 fb_StrSplitCharsSpans( FBSTRING*, FBUSTRING*, boolean, int64*, int64 );
int64 fb_UStrSplitCharsSpans( FBUSTRING*, FBUSTRING*, boolean, int64*, int64 );
static struct $5ArrayI8FBSTRINGE* _ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( struct $5ArrayI8FBSTRINGE*, FBSTRING*, FBUSTRING*, boolean );
static struct $5ArrayI9FBUSTRINGE* _ZN2FB5SPLITERK9FBUSTRINGS2_b( struct $5ArrayI9FBUSTRINGE*, FBUSTRING*, FBUSTRING*, boolean );
static struct $5ArrayI9FBUSTRINGE* _ZN2FB5SPLITERKwRK9FBUSTRINGb( struct $5ArrayI9FBUSTRINGE*, uint16*, FBUSTRING*, boolean );
static struct $5ArrayI8FBSTRINGE* _ZN2FB10SPLITCHARSERK8FBSTRINGRK9FBUSTRINGb( struct $5ArrayI8FBSTRINGE*, FBSTRING*, FBUSTRING*, boolean );
static struct $5ArrayI9FBUSTRINGE* _ZN2FB10SPLITCHARSERK9FBUSTRINGS2_b( struct $5ArrayI9FBUSTRINGE*, FBUSTRING*, FBUSTRING*, boolean );
static struct $5ArrayI9FBUSTRINGE* _ZN2FB10SPLITCHARSERKwRK9FBUSTRINGb( struct $5ArrayI9FBUSTRINGE*, uint16*, FBUSTRING*, boolean );
static FBSTRING* _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( struct $5ArrayI8FBSTRINGE*, FBUSTRING* );
static FBUSTRING* _ZN2FB4JOINER5ArrayI9FBUSTRINGERKS1_( struct $5ArrayI9FBUSTRINGE*, FBUSTRING* );
static void _ZN2FB6CSVROWC1Ev( struct $N2FB6CSVROWE* );
static void _ZN2FB6CSVROWaSERKS0_( struct $N2FB6CSVROWE*, struct $N2FB6CSVROWE* );
static void _ZN2FB6CSVROWC1ERKS0_( struct $N2FB6CSVROWE*, struct $N2FB6CSVROWE* );
static void _ZN2FB6CSVROWD1Ev( struct $N2FB6CSVROWE* );
static void _ZN2FB7CSVUROWC1Ev( struct $N2FB7CSVUROWE* );
static void _ZN2FB7CSVUROWaSERKS0_( struct $N2FB7CSVUROWE*, struct $N2FB7CSVUROWE* );
static void _ZN2FB7CSVUROWC1ERKS0_( struct $N2FB7CSVUROWE*, struct $N2FB7CSVUROWE* );
static void _ZN2FB7CSVUROWD1Ev( struct $N2FB7CSVUROWE* );
static struct $5ArrayIN2FB6CSVROWEE* _ZN2FB8SPLITCSVERK8FBSTRINGRK9FBUSTRING( struct $5ArrayIN2FB6CSVROWEE*, FBSTRING*, FBUSTRING* );
static struct $5ArrayIN2FB7CSVUROWEE* _ZN2FB8SPLITCSVERK9FBUSTRINGS2_( struct $5ArrayIN2FB7CSVUROWEE*, FBUSTRING*, FBUSTRING* );
static struct $5ArrayI9FBUSTRINGE* _ZN2FB11SPLITCSVROWERK9FBUSTRINGS2_( struct $5ArrayI9FBUSTRINGE*, FBUSTRING*, FBUSTRING* );
static int32 _ZN5ArrayI8FBSTRINGE5COUNTEv( struct $5ArrayI8FBSTRINGE* );
static int32 _ZN5ArrayI8FBSTRINGE8CAPACITYEv( struct $5ArrayI8FBSTRINGE* );
static FBSTRING* _ZN5ArrayI8FBSTRINGEixEi( struct $5ArrayI8FBSTRINGE*, int32 );
static void _ZN5ArrayI8FBSTRINGE4PUSHERS0_( struct $5ArrayI8FBSTRINGE*, FBSTRING* );
static void _ZN5ArrayI8FBSTRINGE5CLEAREv( struct $5ArrayI8FBSTRINGE* );
static void _ZN5ArrayI8FBSTRINGE7RESERVEEi( struct $5ArrayI8FBSTRINGE*, int32 );
static struct $13ArrayIteratorI8FBSTRINGE _ZN5ArrayI8FBSTRINGE11GETITERATOREv( struct $5ArrayI8FBSTRINGE* );
static void _ZN5ArrayI8FBSTRINGEC1Ev( struct $5ArrayI8FBSTRINGE* );
static void _ZN5ArrayI8FBSTRINGEaSERKS1_( struct $5ArrayI8FBSTRINGE*, struct $5ArrayI8FBSTRINGE* );
static void _ZN5ArrayI8FBSTRINGEC1ERKS1_( struct $5ArrayI8FBSTRINGE*, struct $5ArrayI8FBSTRINGE* );
static void _ZN5ArrayI8FBSTRINGED1Ev( struct $5ArrayI8FBSTRINGE* );
static boolean _ZN13ArrayIteratorI8FBSTRINGE7ISVALIDEv( struct $13ArrayIteratorI8FBSTRINGE* );
static FBSTRING* _ZN13ArrayIteratorI8FBSTRINGE5VALUEEv( struct $13ArrayIteratorI8FBSTRINGE* );
static void _ZN13ArrayIteratorI8FBSTRINGE8MOVENEXTEv( struct $13ArrayIteratorI8FBSTRINGE* );
static int32 _ZN5ArrayI9FBUSTRINGE5COUNTEv( struct $5ArrayI9FBUSTRINGE* );
static int32 _ZN5ArrayI9FBUSTRINGE8CAPACITYEv( struct $5ArrayI9FBUSTRINGE* );
static FBUSTRING* _ZN5ArrayI9FBUSTRINGEixEi( struct $5ArrayI9FBUSTRINGE*, int32 );
static void _ZN5ArrayI9FBUSTRINGE4PUSHERS0_( struct $5ArrayI9FBUSTRINGE*, FBUSTRING* );
static void _ZN5ArrayI9FBUSTRINGE5CLEAREv( struct $5ArrayI9FBUSTRINGE* );
static void _ZN5ArrayI9FBUSTRINGE7RESERVEEi( struct $5ArrayI9FBUSTRINGE*, int32 );
static void _ZN5ArrayI9FBUSTRINGEC1Ev( struct $5ArrayI9FBUSTRINGE* );
static void _ZN5ArrayI9FBUSTRINGEaSERKS1_( struct $5ArrayI9FBUSTRINGE*, struct $5ArrayI9FBUSTRINGE* );
static void _ZN5ArrayI9FBUSTRINGEC1ERKS1_( struct $5ArrayI9FBUSTRINGE*, struct $5ArrayI9FBUSTRINGE* );
static void _ZN5ArrayI9FBUSTRINGED1Ev( struct $5ArrayI9FBUSTRINGE* );
static int32 _ZN5ArrayIN2FB6CSVROWEE5COUNTEv( struct $5ArrayIN2FB6CSVROWEE* );
static int32 _ZN5ArrayIN2FB6CSVROWEE8CAPACITYEv( struct $5ArrayIN2FB6CSVROWEE* );
static struct $N2FB6CSVROWE* _ZN5ArrayIN2FB6CSVROWEEixEi( struct $5ArrayIN2FB6CSVROWEE*, int32 );
static void _ZN5ArrayIN2FB6CSVROWEE4PUSHERS1_( struct $5ArrayIN2FB6CSVROWEE*, struct $N2FB6CSVROWE* );
static void _ZN5ArrayIN2FB6CSVROWEE5CLEAREv( struct $5ArrayIN2FB6CSVROWEE* );
static void _ZN5ArrayIN2FB6CSVROWEE7RESERVEEi( struct $5ArrayIN2FB6CSVROWEE*, int32 );
static void _ZN5ArrayIN2FB6CSVROWEEC1Ev( struct $5ArrayIN2FB6CSVROWEE* );
static void _ZN5ArrayIN2FB6CSVROWEEaSERKS2_( struct $5ArrayIN2FB6CSVROWEE*, struct $5ArrayIN2FB6CSVROWEE* );
static void _ZN5ArrayIN2FB6CSVROWEEC1ERKS2_( struct $5ArrayIN2FB6CSVROWEE*, struct $5ArrayIN2FB6CSVROWEE* );
static void _ZN5ArrayIN2FB6CSVROWEED1Ev( struct $5ArrayIN2FB6CSVROWEE* );
static int32 _ZN5ArrayIN2FB7CSVUROWEE5COUNTEv( struct $5ArrayIN2FB7CSVUROWEE* );
static int32 _ZN5ArrayIN2FB7CSVUROWEE8CAPACITYEv( struct $5ArrayIN2FB7CSVUROWEE* );
static struct $N2FB7CSVUROWE* _ZN5ArrayIN2FB7CSVUROWEEixEi( struct $5ArrayIN2FB7CSVUROWEE*, int32 );
static void _ZN5ArrayIN2FB7CSVUROWEE4PUSHERS1_( struct $5ArrayIN2FB7CSVUROWEE*, struct $N2FB7CSVUROWE* );
static void _ZN5ArrayIN2FB7CSVUROWEE5CLEAREv( struct $5ArrayIN2FB7CSVUROWEE* );
static void _ZN5ArrayIN2FB7CSVUROWEE7RESERVEEi( struct $5ArrayIN2FB7CSVUROWEE*, int32 );
static void _ZN5ArrayIN2FB7CSVUROWEEC1Ev( struct $5ArrayIN2FB7CSVUROWEE* );
static void _ZN5ArrayIN2FB7CSVUROWEEaSERKS2_( struct $5ArrayIN2FB7CSVUROWEE*, struct $5ArrayIN2FB7CSVUROWEE* );
static void _ZN5ArrayIN2FB7CSVUROWEEC1ERKS2_( struct $5ArrayIN2FB7CSVUROWEE*, struct $5ArrayIN2FB7CSVUROWEE* );
static void _ZN5ArrayIN2FB7CSVUROWEED1Ev( struct $5ArrayIN2FB7CSVUROWEE* );
int64 SPLITINOTHERMODULE( FBSTRING* );
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT19SPLIT_STRING_BASICSEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT24SPLIT_STRING_BASICS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT29SPLIT_EMPTY_FIELDS_ARE_FIELDSEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT34SPLIT_EMPTY_FIELDS_ARE_FIELDS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT30SPLIT_NON_OVERLAPPING_AND_CASEEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT35SPLIT_NON_OVERLAPPING_AND_CASE_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT17SPLITCHARS_STRINGEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT22SPLITCHARS_STRING_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT11JOIN_STRINGEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT16JOIN_STRING_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT20JOIN_SPLIT_ROUNDTRIPEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT25JOIN_SPLIT_ROUNDTRIP_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SPLIT_ZSTRINGEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT18SPLIT_ZSTRING_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SPLIT_USTRINGEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT18SPLIT_USTRING_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT33SPLIT_WSTRING_GIVES_USTRING_ARRAYEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT38SPLIT_WSTRING_GIVES_USTRING_ARRAY_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SPLIT_UNICODEEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT18SPLIT_UNICODE_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT23SPLIT_ROUNDTRIP_USTRINGEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT28SPLIT_ROUNDTRIP_USTRING_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT28SPLIT_RESULT_IS_A_REAL_ARRAYEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT33SPLIT_RESULT_IS_A_REAL_ARRAY_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT17SPLIT_MANY_FIELDSEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT22SPLIT_MANY_FIELDS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT39SPLIT_BODIES_ARE_PRIVATE_ACROSS_MODULESEv( void );
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT44SPLIT_BODIES_ARE_PRIVATE_ACROSS_MODULES_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SUITE_CTOR361Ev( void ) __attribute__(( constructor ));

static boolean _ZN13ArrayIteratorI8FBSTRINGE7ISVALIDEv( struct $13ArrayIteratorI8FBSTRINGE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$214:;
	struct $5ArrayI8FBSTRINGE* A$1;
	A$1 = *(struct $5ArrayI8FBSTRINGE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$215;
	label$215:;
	return fb$result$1;
}

static FBSTRING* _ZN13ArrayIteratorI8FBSTRINGE5VALUEEv( struct $13ArrayIteratorI8FBSTRINGE* THIS$1 )
{
	FBSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$216:;
	struct $5ArrayI8FBSTRINGE* A$1;
	A$1 = *(struct $5ArrayI8FBSTRINGE**)THIS$1;
	fb$result$1 = (FBSTRING*)((uint8*)*(FBSTRING**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) * 24ll));
	goto label$217;
	label$217:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorI8FBSTRINGE8MOVENEXTEv( struct $13ArrayIteratorI8FBSTRINGE* THIS$1 )
{
	label$218:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$219:;
}

static int32 _ZN5ArrayI8FBSTRINGE5COUNTEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$220:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$221;
	label$221:;
	return fb$result$1;
}

static int32 _ZN5ArrayI8FBSTRINGE8CAPACITYEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$222:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$223;
	label$223:;
	return fb$result$1;
}

static boolean _ZN5ArrayI8FBSTRINGE7ISEMPTYEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$224:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$225;
	label$225:;
	return fb$result$1;
}

static void _ZN5ArrayI8FBSTRINGE7RESERVEEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 N$1 )
{
	label$226:;
	int32 vr$1 = _ZN5ArrayI8FBSTRINGE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$229;
	{
		goto label$227;
	}
	label$229:;
	label$228:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayI8FBSTRINGE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$231;
	{
		CAP$1 = 8;
	}
	label$231:;
	label$230:;
	label$232:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$233;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$232;
	label$233:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 24ull, -1, -1, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$227:;
}

static void _ZN5ArrayI8FBSTRINGE6SHRINKEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	label$234:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$237;
	{
		fb_ArrayStrErase( (struct $7FBARRAYIvE*)THIS$1 );
		goto label$235;
	}
	label$237:;
	label$236:;
	int32 vr$6 = _ZN5ArrayI8FBSTRINGE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$239;
	{
		goto label$235;
	}
	label$239:;
	label$238:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 24ull, -1, -1, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$235:;
}

static FBSTRING* _ZN5ArrayI8FBSTRINGEixEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1 )
{
	FBSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$240:;
	fb$result$1 = (FBSTRING*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)I$1 * 24ll));
	goto label$241;
	label$241:;
	return fb$result$1;
}

static FBSTRING* _ZN5ArrayI8FBSTRINGE2ATEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1 )
{
	FBSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$242:;
	fb$result$1 = (FBSTRING*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)I$1 * 24ll));
	goto label$243;
	label$243:;
	return fb$result$1;
}

static void _ZN5ArrayI8FBSTRINGE4PUSHERS0_( struct $5ArrayI8FBSTRINGE* THIS$1, FBSTRING* V$1 )
{
	label$244:;
	_ZN5ArrayI8FBSTRINGE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 24ll)), -1ll, (void*)V$1, -1ll, 0 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$245:;
}

static FBSTRING* _ZN5ArrayI8FBSTRINGE3POPEv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$246:;
	FBSTRING R$1;
	__builtin_memset( &R$1, 0, 24ll );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$249;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
		fb_StrDelete( (FBSTRING*)&R$1 );
		goto label$247;
	}
	label$249:;
	label$248:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	fb_StrAssign( (void*)&R$1, -1ll, (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 24ll)), -1ll, 0 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&R$1 );
	goto label$247;
	fb_StrDelete( (FBSTRING*)&R$1 );
	label$247:;
	FBSTRING* vr$23 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$23;
}

static void _ZN5ArrayI8FBSTRINGE6INSERTEiRS0_( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1, FBSTRING* V$1 )
{
	int64 TMP$83$1;
	label$250:;
	if( (int64)I$1 < 0ll) goto label$252;
	TMP$83$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$259;
	label$252:;
	TMP$83$1 = -1ll;
	label$259:;
	if( TMP$83$1 == 0ll) goto label$254;
	{
		goto label$251;
	}
	label$254:;
	label$253:;
	FBSTRING TMP$1;
	fb_StrInit( (void*)&TMP$1, -1ll, (void*)V$1, -1ll, 0 );
	_ZN5ArrayI8FBSTRINGE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$84$2;
		TMP$84$2 = (int32)((int64)I$1 + 1ll);
		goto label$255;
		label$258:;
		{
			fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)), -1ll, (void*)((uint8*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)) + -24ll), -1ll, 0 );
		}
		label$256:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$255:;
		if( (int64)K$2 >= (int64)TMP$84$2) goto label$258;
		label$257:;
	}
	fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)I$1 * 24ll)), -1ll, (void*)&TMP$1, -1ll, 0 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	fb_StrDelete( (FBSTRING*)&TMP$1 );
	label$251:;
}

static void _ZN5ArrayI8FBSTRINGE6REMOVEEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1 )
{
	int64 TMP$85$1;
	label$260:;
	if( (int64)I$1 < 0ll) goto label$262;
	TMP$85$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$269;
	label$262:;
	TMP$85$1 = -1ll;
	label$269:;
	if( TMP$85$1 == 0ll) goto label$264;
	{
		goto label$261;
	}
	label$264:;
	label$263:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$86$2;
		TMP$86$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$265;
		label$268:;
		{
			fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)), -1ll, (void*)((uint8*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)) + 24ll), -1ll, 0 );
		}
		label$266:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$265:;
		if( (int64)K$2 <= (int64)TMP$86$2) goto label$268;
		label$267:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$261:;
}

static void _ZN5ArrayI8FBSTRINGE10REMOVESWAPEi( struct $5ArrayI8FBSTRINGE* THIS$1, int32 I$1 )
{
	int64 TMP$87$1;
	label$270:;
	if( (int64)I$1 < 0ll) goto label$272;
	TMP$87$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$277;
	label$272:;
	TMP$87$1 = -1ll;
	label$277:;
	if( TMP$87$1 == 0ll) goto label$274;
	{
		goto label$271;
	}
	label$274:;
	label$273:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$276;
	{
		fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)I$1 * 24ll)), -1ll, (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 24ll)), -1ll, 0 );
	}
	label$276:;
	label$275:;
	label$271:;
}

static void _ZN5ArrayI8FBSTRINGE5CLEAREv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	label$278:;
	FBSTRING BLANK$1;
	__builtin_memset( &BLANK$1, 0, 24ll );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$88$2;
		TMP$88$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$280;
		label$283:;
		{
			fb_StrAssign( (void*)((uint8*)*(FBSTRING**)THIS$1 + ((int64)K$2 * 24ll)), -1ll, (void*)&BLANK$1, -1ll, 0 );
		}
		label$281:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$280:;
		if( (int64)K$2 <= (int64)TMP$88$2) goto label$283;
		label$282:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	fb_StrDelete( (FBSTRING*)&BLANK$1 );
	label$279:;
}

static struct $13ArrayIteratorI8FBSTRINGE _ZN5ArrayI8FBSTRINGE11GETITERATOREv( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	struct $13ArrayIteratorI8FBSTRINGE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$284:;
	struct $13ArrayIteratorI8FBSTRINGE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$285;
	label$285:;
	return fb$result$1;
}

static boolean _ZN13ArrayIteratorI9FBUSTRINGE7ISVALIDEv( struct $13ArrayIteratorI9FBUSTRINGE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$286:;
	struct $5ArrayI9FBUSTRINGE* A$1;
	A$1 = *(struct $5ArrayI9FBUSTRINGE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$287;
	label$287:;
	return fb$result$1;
}

static FBUSTRING* _ZN13ArrayIteratorI9FBUSTRINGE5VALUEEv( struct $13ArrayIteratorI9FBUSTRINGE* THIS$1 )
{
	FBUSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$288:;
	struct $5ArrayI9FBUSTRINGE* A$1;
	A$1 = *(struct $5ArrayI9FBUSTRINGE**)THIS$1;
	fb$result$1 = (FBUSTRING*)((uint8*)*(FBUSTRING**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) * 24ll));
	goto label$289;
	label$289:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorI9FBUSTRINGE8MOVENEXTEv( struct $13ArrayIteratorI9FBUSTRINGE* THIS$1 )
{
	label$290:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$291:;
}

static int32 _ZN5ArrayI9FBUSTRINGE5COUNTEv( struct $5ArrayI9FBUSTRINGE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$292:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$293;
	label$293:;
	return fb$result$1;
}

static int32 _ZN5ArrayI9FBUSTRINGE8CAPACITYEv( struct $5ArrayI9FBUSTRINGE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$294:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$295;
	label$295:;
	return fb$result$1;
}

static boolean _ZN5ArrayI9FBUSTRINGE7ISEMPTYEv( struct $5ArrayI9FBUSTRINGE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$296:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$297;
	label$297:;
	return fb$result$1;
}

static void _ZN5ArrayI9FBUSTRINGE7RESERVEEi( struct $5ArrayI9FBUSTRINGE* THIS$1, int32 N$1 )
{
	label$298:;
	int32 vr$1 = _ZN5ArrayI9FBUSTRINGE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$301;
	{
		goto label$299;
	}
	label$301:;
	label$300:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayI9FBUSTRINGE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$303;
	{
		CAP$1 = 8;
	}
	label$303:;
	label$302:;
	label$304:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$305;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$304;
	label$305:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 24ull, -1, 0, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$299:;
}

static void _ZN5ArrayI9FBUSTRINGE6SHRINKEv( struct $5ArrayI9FBUSTRINGE* THIS$1 )
{
	label$306:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$309;
	{
		fb_ArrayUStrErase( (struct $7FBARRAYIvE*)THIS$1 );
		goto label$307;
	}
	label$309:;
	label$308:;
	int32 vr$6 = _ZN5ArrayI9FBUSTRINGE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$311;
	{
		goto label$307;
	}
	label$311:;
	label$310:;
	fb_ArrayRedimPresvEx( (struct $7FBARRAYIvE*)THIS$1, 24ull, -1, 0, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$307:;
}

static FBUSTRING* _ZN5ArrayI9FBUSTRINGEixEi( struct $5ArrayI9FBUSTRINGE* THIS$1, int32 I$1 )
{
	FBUSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$312:;
	fb$result$1 = (FBUSTRING*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)I$1 * 24ll));
	goto label$313;
	label$313:;
	return fb$result$1;
}

static FBUSTRING* _ZN5ArrayI9FBUSTRINGE2ATEi( struct $5ArrayI9FBUSTRINGE* THIS$1, int32 I$1 )
{
	FBUSTRING* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$314:;
	fb$result$1 = (FBUSTRING*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)I$1 * 24ll));
	goto label$315;
	label$315:;
	return fb$result$1;
}

static void _ZN5ArrayI9FBUSTRINGE4PUSHERS0_( struct $5ArrayI9FBUSTRINGE* THIS$1, FBUSTRING* V$1 )
{
	label$316:;
	_ZN5ArrayI9FBUSTRINGE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	fb_UStrAssign( (void*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 24ll)), -1ll, (void*)V$1, -1ll, 0 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$317:;
}

static FBUSTRING* _ZN5ArrayI9FBUSTRINGE3POPEv( struct $5ArrayI9FBUSTRINGE* THIS$1 )
{
	FBUSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$318:;
	FBUSTRING R$1;
	__builtin_memset( &R$1, 0, 24ll );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$321;
	{
		fb_UStrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
		fb_UStrDelete( (FBUSTRING*)&R$1 );
		goto label$319;
	}
	label$321:;
	label$320:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	fb_UStrAssign( (void*)&R$1, -1ll, (void*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 24ll)), -1ll, 0 );
	fb_UStrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
	fb_UStrDelete( (FBUSTRING*)&R$1 );
	goto label$319;
	fb_UStrDelete( (FBUSTRING*)&R$1 );
	label$319:;
	FBUSTRING* vr$23 = fb_UStrAllocTempResult( &fb$result$1 );
	return vr$23;
}

static void _ZN5ArrayI9FBUSTRINGE6INSERTEiRS0_( struct $5ArrayI9FBUSTRINGE* THIS$1, int32 I$1, FBUSTRING* V$1 )
{
	int64 TMP$89$1;
	label$322:;
	if( (int64)I$1 < 0ll) goto label$324;
	TMP$89$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$331;
	label$324:;
	TMP$89$1 = -1ll;
	label$331:;
	if( TMP$89$1 == 0ll) goto label$326;
	{
		goto label$323;
	}
	label$326:;
	label$325:;
	FBUSTRING TMP$1;
	fb_UStrInit( (void*)&TMP$1, -1ll, (void*)V$1, -1ll, 0 );
	_ZN5ArrayI9FBUSTRINGE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$90$2;
		TMP$90$2 = (int32)((int64)I$1 + 1ll);
		goto label$327;
		label$330:;
		{
			fb_UStrAssign( (void*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)K$2 * 24ll)), -1ll, (void*)((uint8*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)K$2 * 24ll)) + -24ll), -1ll, 0 );
		}
		label$328:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$327:;
		if( (int64)K$2 >= (int64)TMP$90$2) goto label$330;
		label$329:;
	}
	fb_UStrAssign( (void*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)I$1 * 24ll)), -1ll, (void*)&TMP$1, -1ll, 0 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	fb_UStrDelete( (FBUSTRING*)&TMP$1 );
	label$323:;
}

static void _ZN5ArrayI9FBUSTRINGE6REMOVEEi( struct $5ArrayI9FBUSTRINGE* THIS$1, int32 I$1 )
{
	int64 TMP$91$1;
	label$332:;
	if( (int64)I$1 < 0ll) goto label$334;
	TMP$91$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$341;
	label$334:;
	TMP$91$1 = -1ll;
	label$341:;
	if( TMP$91$1 == 0ll) goto label$336;
	{
		goto label$333;
	}
	label$336:;
	label$335:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$92$2;
		TMP$92$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$337;
		label$340:;
		{
			fb_UStrAssign( (void*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)K$2 * 24ll)), -1ll, (void*)((uint8*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)K$2 * 24ll)) + 24ll), -1ll, 0 );
		}
		label$338:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$337:;
		if( (int64)K$2 <= (int64)TMP$92$2) goto label$340;
		label$339:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$333:;
}

static void _ZN5ArrayI9FBUSTRINGE10REMOVESWAPEi( struct $5ArrayI9FBUSTRINGE* THIS$1, int32 I$1 )
{
	int64 TMP$93$1;
	label$342:;
	if( (int64)I$1 < 0ll) goto label$344;
	TMP$93$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$349;
	label$344:;
	TMP$93$1 = -1ll;
	label$349:;
	if( TMP$93$1 == 0ll) goto label$346;
	{
		goto label$343;
	}
	label$346:;
	label$345:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$348;
	{
		fb_UStrAssign( (void*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)I$1 * 24ll)), -1ll, (void*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 24ll)), -1ll, 0 );
	}
	label$348:;
	label$347:;
	label$343:;
}

static void _ZN5ArrayI9FBUSTRINGE5CLEAREv( struct $5ArrayI9FBUSTRINGE* THIS$1 )
{
	label$350:;
	FBUSTRING BLANK$1;
	__builtin_memset( &BLANK$1, 0, 24ll );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$94$2;
		TMP$94$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$352;
		label$355:;
		{
			fb_UStrAssign( (void*)((uint8*)*(FBUSTRING**)THIS$1 + ((int64)K$2 * 24ll)), -1ll, (void*)&BLANK$1, -1ll, 0 );
		}
		label$353:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$352:;
		if( (int64)K$2 <= (int64)TMP$94$2) goto label$355;
		label$354:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	fb_UStrDelete( (FBUSTRING*)&BLANK$1 );
	label$351:;
}

static struct $13ArrayIteratorI9FBUSTRINGE _ZN5ArrayI9FBUSTRINGE11GETITERATOREv( struct $5ArrayI9FBUSTRINGE* THIS$1 )
{
	struct $13ArrayIteratorI9FBUSTRINGE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$356:;
	struct $13ArrayIteratorI9FBUSTRINGE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$357;
	label$357:;
	return fb$result$1;
}

static boolean _ZN13ArrayIteratorIN2FB6CSVROWEE7ISVALIDEv( struct $13ArrayIteratorIN2FB6CSVROWEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$358:;
	struct $5ArrayIN2FB6CSVROWEE* A$1;
	A$1 = *(struct $5ArrayIN2FB6CSVROWEE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$359;
	label$359:;
	return fb$result$1;
}

static struct $N2FB6CSVROWE* _ZN13ArrayIteratorIN2FB6CSVROWEE5VALUEEv( struct $13ArrayIteratorIN2FB6CSVROWEE* THIS$1 )
{
	struct $N2FB6CSVROWE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$360:;
	struct $5ArrayIN2FB6CSVROWEE* A$1;
	A$1 = *(struct $5ArrayIN2FB6CSVROWEE**)THIS$1;
	fb$result$1 = (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) * 80ll));
	goto label$361;
	label$361:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorIN2FB6CSVROWEE8MOVENEXTEv( struct $13ArrayIteratorIN2FB6CSVROWEE* THIS$1 )
{
	label$362:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$363:;
}

static int32 _ZN5ArrayIN2FB6CSVROWEE5COUNTEv( struct $5ArrayIN2FB6CSVROWEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$364:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$365;
	label$365:;
	return fb$result$1;
}

static int32 _ZN5ArrayIN2FB6CSVROWEE8CAPACITYEv( struct $5ArrayIN2FB6CSVROWEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$366:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$367;
	label$367:;
	return fb$result$1;
}

static boolean _ZN5ArrayIN2FB6CSVROWEE7ISEMPTYEv( struct $5ArrayIN2FB6CSVROWEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$368:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$369;
	label$369:;
	return fb$result$1;
}

static void _ZN5ArrayIN2FB6CSVROWEE7RESERVEEi( struct $5ArrayIN2FB6CSVROWEE* THIS$1, int32 N$1 )
{
	label$370:;
	int32 vr$1 = _ZN5ArrayIN2FB6CSVROWEE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$373;
	{
		goto label$371;
	}
	label$373:;
	label$372:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayIN2FB6CSVROWEE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$375;
	{
		CAP$1 = 8;
	}
	label$375:;
	label$374:;
	label$376:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$377;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$376;
	label$377:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 80ull, (void*)&_ZN2FB6CSVROWC1Ev, (void*)&_ZN2FB6CSVROWD1Ev, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$371:;
}

static void _ZN5ArrayIN2FB6CSVROWEE6SHRINKEv( struct $5ArrayIN2FB6CSVROWEE* THIS$1 )
{
	label$378:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$381;
	{
		fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN2FB6CSVROWC1Ev, (void*)&_ZN2FB6CSVROWD1Ev );
		goto label$379;
	}
	label$381:;
	label$380:;
	int32 vr$6 = _ZN5ArrayIN2FB6CSVROWEE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$383;
	{
		goto label$379;
	}
	label$383:;
	label$382:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 80ull, (void*)&_ZN2FB6CSVROWC1Ev, (void*)&_ZN2FB6CSVROWD1Ev, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$379:;
}

static struct $N2FB6CSVROWE* _ZN5ArrayIN2FB6CSVROWEEixEi( struct $5ArrayIN2FB6CSVROWEE* THIS$1, int32 I$1 )
{
	struct $N2FB6CSVROWE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$384:;
	fb$result$1 = (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)I$1 * 80ll));
	goto label$385;
	label$385:;
	return fb$result$1;
}

static struct $N2FB6CSVROWE* _ZN5ArrayIN2FB6CSVROWEE2ATEi( struct $5ArrayIN2FB6CSVROWEE* THIS$1, int32 I$1 )
{
	struct $N2FB6CSVROWE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$386:;
	fb$result$1 = (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)I$1 * 80ll));
	goto label$387;
	label$387:;
	return fb$result$1;
}

static void _ZN5ArrayIN2FB6CSVROWEE4PUSHERS1_( struct $5ArrayIN2FB6CSVROWEE* THIS$1, struct $N2FB6CSVROWE* V$1 )
{
	label$388:;
	_ZN5ArrayIN2FB6CSVROWEE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	_ZN2FB6CSVROWaSERKS0_( (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 80ll)), (struct $N2FB6CSVROWE*)V$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$389:;
}

static struct $N2FB6CSVROWE* _ZN5ArrayIN2FB6CSVROWEE3POPEv( struct $N2FB6CSVROWE* tmp$98$1, struct $5ArrayIN2FB6CSVROWEE* THIS$1 )
{
	label$390:;
	struct $N2FB6CSVROWE R$1;
	_ZN2FB6CSVROWC1Ev( &R$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$393;
	{
		_ZN2FB6CSVROWC1ERKS0_( tmp$98$1, (struct $N2FB6CSVROWE*)&R$1 );
		_ZN2FB6CSVROWD1Ev( &R$1 );
		goto label$391;
	}
	label$393:;
	label$392:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	_ZN2FB6CSVROWaSERKS0_( &R$1, (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 80ll)) );
	_ZN2FB6CSVROWC1ERKS0_( tmp$98$1, (struct $N2FB6CSVROWE*)&R$1 );
	_ZN2FB6CSVROWD1Ev( &R$1 );
	goto label$391;
	_ZN2FB6CSVROWD1Ev( &R$1 );
	label$391:;
	return tmp$98$1;
}

static void _ZN5ArrayIN2FB6CSVROWEE6INSERTEiRS1_( struct $5ArrayIN2FB6CSVROWEE* THIS$1, int32 I$1, struct $N2FB6CSVROWE* V$1 )
{
	int64 TMP$99$1;
	label$394:;
	if( (int64)I$1 < 0ll) goto label$396;
	TMP$99$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$403;
	label$396:;
	TMP$99$1 = -1ll;
	label$403:;
	if( TMP$99$1 == 0ll) goto label$398;
	{
		goto label$395;
	}
	label$398:;
	label$397:;
	struct $N2FB6CSVROWE TMP$1;
	_ZN2FB6CSVROWC1ERKS0_( &TMP$1, (struct $N2FB6CSVROWE*)V$1 );
	_ZN5ArrayIN2FB6CSVROWEE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$100$2;
		TMP$100$2 = (int32)((int64)I$1 + 1ll);
		goto label$399;
		label$402:;
		{
			_ZN2FB6CSVROWaSERKS0_( (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)K$2 * 80ll)), (struct $N2FB6CSVROWE*)((uint8*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)K$2 * 80ll)) + -80ll) );
		}
		label$400:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$399:;
		if( (int64)K$2 >= (int64)TMP$100$2) goto label$402;
		label$401:;
	}
	_ZN2FB6CSVROWaSERKS0_( (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)I$1 * 80ll)), (struct $N2FB6CSVROWE*)&TMP$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	_ZN2FB6CSVROWD1Ev( &TMP$1 );
	label$395:;
}

static void _ZN5ArrayIN2FB6CSVROWEE6REMOVEEi( struct $5ArrayIN2FB6CSVROWEE* THIS$1, int32 I$1 )
{
	int64 TMP$101$1;
	label$404:;
	if( (int64)I$1 < 0ll) goto label$406;
	TMP$101$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$413;
	label$406:;
	TMP$101$1 = -1ll;
	label$413:;
	if( TMP$101$1 == 0ll) goto label$408;
	{
		goto label$405;
	}
	label$408:;
	label$407:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$102$2;
		TMP$102$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$409;
		label$412:;
		{
			_ZN2FB6CSVROWaSERKS0_( (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)K$2 * 80ll)), (struct $N2FB6CSVROWE*)((uint8*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)K$2 * 80ll)) + 80ll) );
		}
		label$410:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$409:;
		if( (int64)K$2 <= (int64)TMP$102$2) goto label$412;
		label$411:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$405:;
}

static void _ZN5ArrayIN2FB6CSVROWEE10REMOVESWAPEi( struct $5ArrayIN2FB6CSVROWEE* THIS$1, int32 I$1 )
{
	int64 TMP$103$1;
	label$414:;
	if( (int64)I$1 < 0ll) goto label$416;
	TMP$103$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$421;
	label$416:;
	TMP$103$1 = -1ll;
	label$421:;
	if( TMP$103$1 == 0ll) goto label$418;
	{
		goto label$415;
	}
	label$418:;
	label$417:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$420;
	{
		_ZN2FB6CSVROWaSERKS0_( (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)I$1 * 80ll)), (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 80ll)) );
	}
	label$420:;
	label$419:;
	label$415:;
}

static void _ZN5ArrayIN2FB6CSVROWEE5CLEAREv( struct $5ArrayIN2FB6CSVROWEE* THIS$1 )
{
	label$422:;
	struct $N2FB6CSVROWE BLANK$1;
	_ZN2FB6CSVROWC1Ev( &BLANK$1 );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$104$2;
		TMP$104$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$424;
		label$427:;
		{
			_ZN2FB6CSVROWaSERKS0_( (struct $N2FB6CSVROWE*)((uint8*)*(struct $N2FB6CSVROWE**)THIS$1 + ((int64)K$2 * 80ll)), (struct $N2FB6CSVROWE*)&BLANK$1 );
		}
		label$425:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$424:;
		if( (int64)K$2 <= (int64)TMP$104$2) goto label$427;
		label$426:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	_ZN2FB6CSVROWD1Ev( &BLANK$1 );
	label$423:;
}

static struct $13ArrayIteratorIN2FB6CSVROWEE _ZN5ArrayIN2FB6CSVROWEE11GETITERATOREv( struct $5ArrayIN2FB6CSVROWEE* THIS$1 )
{
	struct $13ArrayIteratorIN2FB6CSVROWEE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$428:;
	struct $13ArrayIteratorIN2FB6CSVROWEE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$429;
	label$429:;
	return fb$result$1;
}

static boolean _ZN13ArrayIteratorIN2FB7CSVUROWEE7ISVALIDEv( struct $13ArrayIteratorIN2FB7CSVUROWEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$430:;
	struct $5ArrayIN2FB7CSVUROWEE* A$1;
	A$1 = *(struct $5ArrayIN2FB7CSVUROWEE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$431;
	label$431:;
	return fb$result$1;
}

static struct $N2FB7CSVUROWE* _ZN13ArrayIteratorIN2FB7CSVUROWEE5VALUEEv( struct $13ArrayIteratorIN2FB7CSVUROWEE* THIS$1 )
{
	struct $N2FB7CSVUROWE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$432:;
	struct $5ArrayIN2FB7CSVUROWEE* A$1;
	A$1 = *(struct $5ArrayIN2FB7CSVUROWEE**)THIS$1;
	fb$result$1 = (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) * 80ll));
	goto label$433;
	label$433:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorIN2FB7CSVUROWEE8MOVENEXTEv( struct $13ArrayIteratorIN2FB7CSVUROWEE* THIS$1 )
{
	label$434:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$435:;
}

static int32 _ZN5ArrayIN2FB7CSVUROWEE5COUNTEv( struct $5ArrayIN2FB7CSVUROWEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$436:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$437;
	label$437:;
	return fb$result$1;
}

static int32 _ZN5ArrayIN2FB7CSVUROWEE8CAPACITYEv( struct $5ArrayIN2FB7CSVUROWEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$438:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$439;
	label$439:;
	return fb$result$1;
}

static boolean _ZN5ArrayIN2FB7CSVUROWEE7ISEMPTYEv( struct $5ArrayIN2FB7CSVUROWEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$440:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$441;
	label$441:;
	return fb$result$1;
}

static void _ZN5ArrayIN2FB7CSVUROWEE7RESERVEEi( struct $5ArrayIN2FB7CSVUROWEE* THIS$1, int32 N$1 )
{
	label$442:;
	int32 vr$1 = _ZN5ArrayIN2FB7CSVUROWEE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$445;
	{
		goto label$443;
	}
	label$445:;
	label$444:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayIN2FB7CSVUROWEE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$447;
	{
		CAP$1 = 8;
	}
	label$447:;
	label$446:;
	label$448:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$449;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$448;
	label$449:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 80ull, (void*)&_ZN2FB7CSVUROWC1Ev, (void*)&_ZN2FB7CSVUROWD1Ev, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$443:;
}

static void _ZN5ArrayIN2FB7CSVUROWEE6SHRINKEv( struct $5ArrayIN2FB7CSVUROWEE* THIS$1 )
{
	label$450:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$453;
	{
		fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN2FB7CSVUROWC1Ev, (void*)&_ZN2FB7CSVUROWD1Ev );
		goto label$451;
	}
	label$453:;
	label$452:;
	int32 vr$6 = _ZN5ArrayIN2FB7CSVUROWEE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$455;
	{
		goto label$451;
	}
	label$455:;
	label$454:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 80ull, (void*)&_ZN2FB7CSVUROWC1Ev, (void*)&_ZN2FB7CSVUROWD1Ev, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$451:;
}

static struct $N2FB7CSVUROWE* _ZN5ArrayIN2FB7CSVUROWEEixEi( struct $5ArrayIN2FB7CSVUROWEE* THIS$1, int32 I$1 )
{
	struct $N2FB7CSVUROWE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$456:;
	fb$result$1 = (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)I$1 * 80ll));
	goto label$457;
	label$457:;
	return fb$result$1;
}

static struct $N2FB7CSVUROWE* _ZN5ArrayIN2FB7CSVUROWEE2ATEi( struct $5ArrayIN2FB7CSVUROWEE* THIS$1, int32 I$1 )
{
	struct $N2FB7CSVUROWE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$458:;
	fb$result$1 = (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)I$1 * 80ll));
	goto label$459;
	label$459:;
	return fb$result$1;
}

static void _ZN5ArrayIN2FB7CSVUROWEE4PUSHERS1_( struct $5ArrayIN2FB7CSVUROWEE* THIS$1, struct $N2FB7CSVUROWE* V$1 )
{
	label$460:;
	_ZN5ArrayIN2FB7CSVUROWEE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	_ZN2FB7CSVUROWaSERKS0_( (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 80ll)), (struct $N2FB7CSVUROWE*)V$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$461:;
}

static struct $N2FB7CSVUROWE* _ZN5ArrayIN2FB7CSVUROWEE3POPEv( struct $N2FB7CSVUROWE* tmp$108$1, struct $5ArrayIN2FB7CSVUROWEE* THIS$1 )
{
	label$462:;
	struct $N2FB7CSVUROWE R$1;
	_ZN2FB7CSVUROWC1Ev( &R$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$465;
	{
		_ZN2FB7CSVUROWC1ERKS0_( tmp$108$1, (struct $N2FB7CSVUROWE*)&R$1 );
		_ZN2FB7CSVUROWD1Ev( &R$1 );
		goto label$463;
	}
	label$465:;
	label$464:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	_ZN2FB7CSVUROWaSERKS0_( &R$1, (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 80ll)) );
	_ZN2FB7CSVUROWC1ERKS0_( tmp$108$1, (struct $N2FB7CSVUROWE*)&R$1 );
	_ZN2FB7CSVUROWD1Ev( &R$1 );
	goto label$463;
	_ZN2FB7CSVUROWD1Ev( &R$1 );
	label$463:;
	return tmp$108$1;
}

static void _ZN5ArrayIN2FB7CSVUROWEE6INSERTEiRS1_( struct $5ArrayIN2FB7CSVUROWEE* THIS$1, int32 I$1, struct $N2FB7CSVUROWE* V$1 )
{
	int64 TMP$109$1;
	label$466:;
	if( (int64)I$1 < 0ll) goto label$468;
	TMP$109$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$475;
	label$468:;
	TMP$109$1 = -1ll;
	label$475:;
	if( TMP$109$1 == 0ll) goto label$470;
	{
		goto label$467;
	}
	label$470:;
	label$469:;
	struct $N2FB7CSVUROWE TMP$1;
	_ZN2FB7CSVUROWC1ERKS0_( &TMP$1, (struct $N2FB7CSVUROWE*)V$1 );
	_ZN5ArrayIN2FB7CSVUROWEE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$110$2;
		TMP$110$2 = (int32)((int64)I$1 + 1ll);
		goto label$471;
		label$474:;
		{
			_ZN2FB7CSVUROWaSERKS0_( (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)K$2 * 80ll)), (struct $N2FB7CSVUROWE*)((uint8*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)K$2 * 80ll)) + -80ll) );
		}
		label$472:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$471:;
		if( (int64)K$2 >= (int64)TMP$110$2) goto label$474;
		label$473:;
	}
	_ZN2FB7CSVUROWaSERKS0_( (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)I$1 * 80ll)), (struct $N2FB7CSVUROWE*)&TMP$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	_ZN2FB7CSVUROWD1Ev( &TMP$1 );
	label$467:;
}

static void _ZN5ArrayIN2FB7CSVUROWEE6REMOVEEi( struct $5ArrayIN2FB7CSVUROWEE* THIS$1, int32 I$1 )
{
	int64 TMP$111$1;
	label$476:;
	if( (int64)I$1 < 0ll) goto label$478;
	TMP$111$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$485;
	label$478:;
	TMP$111$1 = -1ll;
	label$485:;
	if( TMP$111$1 == 0ll) goto label$480;
	{
		goto label$477;
	}
	label$480:;
	label$479:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$112$2;
		TMP$112$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$481;
		label$484:;
		{
			_ZN2FB7CSVUROWaSERKS0_( (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)K$2 * 80ll)), (struct $N2FB7CSVUROWE*)((uint8*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)K$2 * 80ll)) + 80ll) );
		}
		label$482:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$481:;
		if( (int64)K$2 <= (int64)TMP$112$2) goto label$484;
		label$483:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$477:;
}

static void _ZN5ArrayIN2FB7CSVUROWEE10REMOVESWAPEi( struct $5ArrayIN2FB7CSVUROWEE* THIS$1, int32 I$1 )
{
	int64 TMP$113$1;
	label$486:;
	if( (int64)I$1 < 0ll) goto label$488;
	TMP$113$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$493;
	label$488:;
	TMP$113$1 = -1ll;
	label$493:;
	if( TMP$113$1 == 0ll) goto label$490;
	{
		goto label$487;
	}
	label$490:;
	label$489:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$492;
	{
		_ZN2FB7CSVUROWaSERKS0_( (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)I$1 * 80ll)), (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) * 80ll)) );
	}
	label$492:;
	label$491:;
	label$487:;
}

static void _ZN5ArrayIN2FB7CSVUROWEE5CLEAREv( struct $5ArrayIN2FB7CSVUROWEE* THIS$1 )
{
	label$494:;
	struct $N2FB7CSVUROWE BLANK$1;
	_ZN2FB7CSVUROWC1Ev( &BLANK$1 );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$114$2;
		TMP$114$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$496;
		label$499:;
		{
			_ZN2FB7CSVUROWaSERKS0_( (struct $N2FB7CSVUROWE*)((uint8*)*(struct $N2FB7CSVUROWE**)THIS$1 + ((int64)K$2 * 80ll)), (struct $N2FB7CSVUROWE*)&BLANK$1 );
		}
		label$497:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$496:;
		if( (int64)K$2 <= (int64)TMP$114$2) goto label$499;
		label$498:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	_ZN2FB7CSVUROWD1Ev( &BLANK$1 );
	label$495:;
}

static struct $13ArrayIteratorIN2FB7CSVUROWEE _ZN5ArrayIN2FB7CSVUROWEE11GETITERATOREv( struct $5ArrayIN2FB7CSVUROWEE* THIS$1 )
{
	struct $13ArrayIteratorIN2FB7CSVUROWEE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$500:;
	struct $13ArrayIteratorIN2FB7CSVUROWEE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$501;
	label$501:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT19SPLIT_STRING_BASICSEv( void )
{
	FBSTRING TMP$119$1;
	FBUSTRING TMP$121$1;
	FBSTRING TMP$156$1;
	FBUSTRING TMP$158$1;
	FBSTRING TMP$182$1;
	FBUSTRING TMP$184$1;
	label$502:;
	struct $5ArrayI8FBSTRINGE A$1;
	__builtin_memset( &TMP$121$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$121$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$119$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$119$1, -1ll, (void*)"a,b,c", 6ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &A$1, (FBSTRING*)&TMP$119$1, (FBUSTRING*)&TMP$121$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$121$1 );
	fb_StrDelete( (FBSTRING*)&TMP$119$1 );
	int32 vr$10 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &A$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$10 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 36, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_STRING_BASICS", (char*)"CU_ASSERT_EQUAL(a.Count( ),3)" );
	FBSTRING* vr$15 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 0 );
	int32 vr$16 = fb_StrCompare( (void*)vr$15, -1ll, (void*)"a", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$16 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 37, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_STRING_BASICS", (char*)"CU_ASSERT_EQUAL(a[0],\x22" "a\x22)" );
	FBSTRING* vr$21 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 1 );
	int32 vr$22 = fb_StrCompare( (void*)vr$21, -1ll, (void*)"b", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$22 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 38, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_STRING_BASICS", (char*)"CU_ASSERT_EQUAL(a[1],\x22" "b\x22)" );
	FBSTRING* vr$27 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 2 );
	int32 vr$28 = fb_StrCompare( (void*)vr$27, -1ll, (void*)"c", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$28 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 39, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_STRING_BASICS", (char*)"CU_ASSERT_EQUAL(a[2],\x22" "c\x22)" );
	struct $5ArrayI8FBSTRINGE B$1;
	__builtin_memset( &TMP$158$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$158$1, -1ll, (void*)(uint16[]){0x003B,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$156$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$156$1, -1ll, (void*)"x;y", 4ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &B$1, (FBSTRING*)&TMP$156$1, (FBUSTRING*)&TMP$158$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$158$1 );
	fb_StrDelete( (FBSTRING*)&TMP$156$1 );
	int32 vr$42 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &B$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$42 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 43, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_STRING_BASICS", (char*)"CU_ASSERT_EQUAL(b.Count( ),2)" );
	FBSTRING* vr$47 = _ZN5ArrayI8FBSTRINGEixEi( &B$1, 0 );
	int32 vr$48 = fb_StrCompare( (void*)vr$47, -1ll, (void*)"x", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$48 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 44, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_STRING_BASICS", (char*)"CU_ASSERT_EQUAL(b[0],\x22x\x22)" );
	FBSTRING* vr$53 = _ZN5ArrayI8FBSTRINGEixEi( &B$1, 1 );
	int32 vr$54 = fb_StrCompare( (void*)vr$53, -1ll, (void*)"y", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$54 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 45, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_STRING_BASICS", (char*)"CU_ASSERT_EQUAL(b[1],\x22y\x22)" );
	struct $5ArrayI8FBSTRINGE C$1;
	__builtin_memset( &TMP$184$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$184$1, -1ll, (void*)(uint16[]){0x003C,0x003E,0x0000}, -9223372036854775806ll, 0 );
	__builtin_memset( &TMP$182$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$182$1, -1ll, (void*)"a<>b<>c", 8ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &C$1, (FBSTRING*)&TMP$182$1, (FBUSTRING*)&TMP$184$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$184$1 );
	fb_StrDelete( (FBSTRING*)&TMP$182$1 );
	int32 vr$68 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &C$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$68 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 49, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_STRING_BASICS", (char*)"CU_ASSERT_EQUAL(c.Count( ),3)" );
	FBSTRING* vr$73 = _ZN5ArrayI8FBSTRINGEixEi( &C$1, 1 );
	int32 vr$74 = fb_StrCompare( (void*)vr$73, -1ll, (void*)"b", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$74 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 50, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_STRING_BASICS", (char*)"CU_ASSERT_EQUAL(c[1],\x22" "b\x22)" );
	_ZN5ArrayI8FBSTRINGED1Ev( &C$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &B$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &A$1 );
	label$503:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT29SPLIT_EMPTY_FIELDS_ARE_FIELDSEv( void )
{
	FBSTRING TMP$199$1;
	FBUSTRING TMP$200$1;
	FBSTRING TMP$207$1;
	FBUSTRING TMP$208$1;
	FBSTRING TMP$215$1;
	FBUSTRING TMP$216$1;
	FBSTRING TMP$227$1;
	FBUSTRING TMP$228$1;
	FBSTRING TMP$246$1;
	FBUSTRING TMP$247$1;
	FBSTRING TMP$255$1;
	FBUSTRING TMP$256$1;
	FBSTRING TMP$270$1;
	FBUSTRING TMP$271$1;
	FBSTRING TMP$284$1;
	FBUSTRING TMP$285$1;
	FBSTRING TMP$297$1;
	FBUSTRING TMP$299$1;
	FBSTRING TMP$318$1;
	FBUSTRING TMP$320$1;
	label$506:;
	struct $5ArrayI8FBSTRINGE A$1;
	__builtin_memset( &TMP$200$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$200$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$199$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$199$1, -1ll, (void*)"a,,c", 5ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &A$1, (FBSTRING*)&TMP$199$1, (FBUSTRING*)&TMP$200$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$200$1 );
	fb_StrDelete( (FBSTRING*)&TMP$199$1 );
	int32 vr$10 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &A$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$10 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 56, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(a.Count( ),3)" );
	FBSTRING* vr$15 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 1 );
	int32 vr$16 = fb_StrCompare( (void*)vr$15, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$16 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 57, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(a[1],\x22\x22)" );
	struct $5ArrayI8FBSTRINGE B$1;
	__builtin_memset( &TMP$208$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$208$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$207$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$207$1, -1ll, (void*)",a", 3ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &B$1, (FBSTRING*)&TMP$207$1, (FBUSTRING*)&TMP$208$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$208$1 );
	fb_StrDelete( (FBSTRING*)&TMP$207$1 );
	int32 vr$30 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &B$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$30 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 60, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(b.Count( ),2)" );
	FBSTRING* vr$35 = _ZN5ArrayI8FBSTRINGEixEi( &B$1, 0 );
	int32 vr$36 = fb_StrCompare( (void*)vr$35, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$36 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 61, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(b[0],\x22\x22)" );
	FBSTRING* vr$41 = _ZN5ArrayI8FBSTRINGEixEi( &B$1, 1 );
	int32 vr$42 = fb_StrCompare( (void*)vr$41, -1ll, (void*)"a", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$42 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 62, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(b[1],\x22" "a\x22)" );
	struct $5ArrayI8FBSTRINGE C$1;
	__builtin_memset( &TMP$216$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$216$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$215$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$215$1, -1ll, (void*)"a,", 3ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &C$1, (FBSTRING*)&TMP$215$1, (FBUSTRING*)&TMP$216$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$216$1 );
	fb_StrDelete( (FBSTRING*)&TMP$215$1 );
	int32 vr$56 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &C$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$56 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 65, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(c.Count( ),2)" );
	FBSTRING* vr$61 = _ZN5ArrayI8FBSTRINGEixEi( &C$1, 0 );
	int32 vr$62 = fb_StrCompare( (void*)vr$61, -1ll, (void*)"a", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$62 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 66, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(c[0],\x22" "a\x22)" );
	FBSTRING* vr$67 = _ZN5ArrayI8FBSTRINGEixEi( &C$1, 1 );
	int32 vr$68 = fb_StrCompare( (void*)vr$67, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$68 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 67, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(c[1],\x22\x22)" );
	struct $5ArrayI8FBSTRINGE D$1;
	__builtin_memset( &TMP$228$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$228$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$227$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$227$1, -1ll, (void*)",", 2ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &D$1, (FBSTRING*)&TMP$227$1, (FBUSTRING*)&TMP$228$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$228$1 );
	fb_StrDelete( (FBSTRING*)&TMP$227$1 );
	int32 vr$82 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$82 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 70, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(d.Count( ),2)" );
	FBSTRING* vr$87 = _ZN5ArrayI8FBSTRINGEixEi( &D$1, 0 );
	int32 vr$88 = fb_StrCompare( (void*)vr$87, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$88 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 71, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(d[0],\x22\x22)" );
	FBSTRING* vr$93 = _ZN5ArrayI8FBSTRINGEixEi( &D$1, 1 );
	int32 vr$94 = fb_StrCompare( (void*)vr$93, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$94 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 72, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(d[1],\x22\x22)" );
	struct $5ArrayI8FBSTRINGE E$1;
	__builtin_memset( &TMP$247$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$247$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$246$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$246$1, -1ll, (void*)",,,", 4ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &E$1, (FBSTRING*)&TMP$246$1, (FBUSTRING*)&TMP$247$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$247$1 );
	fb_StrDelete( (FBSTRING*)&TMP$246$1 );
	int32 vr$108 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &E$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$108 == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 75, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(e.Count( ),4)" );
	struct $5ArrayI8FBSTRINGE F$1;
	__builtin_memset( &TMP$256$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$256$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$255$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$255$1, -1ll, (void*)"", 1ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &F$1, (FBSTRING*)&TMP$255$1, (FBUSTRING*)&TMP$256$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$256$1 );
	fb_StrDelete( (FBSTRING*)&TMP$255$1 );
	int32 vr$122 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &F$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$122 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 79, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(f.Count( ),1)" );
	FBSTRING* vr$127 = _ZN5ArrayI8FBSTRINGEixEi( &F$1, 0 );
	int32 vr$128 = fb_StrCompare( (void*)vr$127, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$128 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 80, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(f[0],\x22\x22)" );
	struct $5ArrayI8FBSTRINGE G$1;
	__builtin_memset( &TMP$271$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$271$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$270$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$270$1, -1ll, (void*)"abc", 4ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &G$1, (FBSTRING*)&TMP$270$1, (FBUSTRING*)&TMP$271$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$271$1 );
	fb_StrDelete( (FBSTRING*)&TMP$270$1 );
	int32 vr$142 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &G$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$142 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 84, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(g.Count( ),1)" );
	FBSTRING* vr$147 = _ZN5ArrayI8FBSTRINGEixEi( &G$1, 0 );
	int32 vr$148 = fb_StrCompare( (void*)vr$147, -1ll, (void*)"abc", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$148 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 85, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(g[0],\x22" "abc\x22)" );
	struct $5ArrayI8FBSTRINGE H$1;
	__builtin_memset( &TMP$285$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$285$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
	__builtin_memset( &TMP$284$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$284$1, -1ll, (void*)"abc", 4ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &H$1, (FBSTRING*)&TMP$284$1, (FBUSTRING*)&TMP$285$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$285$1 );
	fb_StrDelete( (FBSTRING*)&TMP$284$1 );
	int32 vr$162 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &H$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$162 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 89, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(h.Count( ),1)" );
	FBSTRING* vr$167 = _ZN5ArrayI8FBSTRINGEixEi( &H$1, 0 );
	int32 vr$168 = fb_StrCompare( (void*)vr$167, -1ll, (void*)"abc", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$168 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 90, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(h[0],\x22" "abc\x22)" );
	struct $5ArrayI8FBSTRINGE I_$1;
	__builtin_memset( &TMP$299$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$299$1, -1ll, (void*)(uint16[]){0x0061,0x0062,0x0063,0x0000}, -9223372036854775805ll, 0 );
	__builtin_memset( &TMP$297$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$297$1, -1ll, (void*)"abc", 4ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &I_$1, (FBSTRING*)&TMP$297$1, (FBUSTRING*)&TMP$299$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$299$1 );
	fb_StrDelete( (FBSTRING*)&TMP$297$1 );
	int32 vr$182 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &I_$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$182 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 94, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(i_.Count( ),2)" );
	FBSTRING* vr$187 = _ZN5ArrayI8FBSTRINGEixEi( &I_$1, 0 );
	int32 vr$188 = fb_StrCompare( (void*)vr$187, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$188 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 95, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(i_[0],\x22\x22)" );
	FBSTRING* vr$193 = _ZN5ArrayI8FBSTRINGEixEi( &I_$1, 1 );
	int32 vr$194 = fb_StrCompare( (void*)vr$193, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$194 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 96, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(i_[1],\x22\x22)" );
	struct $5ArrayI8FBSTRINGE J$1;
	__builtin_memset( &TMP$320$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$320$1, -1ll, (void*)(uint16[]){0x0061,0x0062,0x0063,0x0064,0x0000}, -9223372036854775804ll, 0 );
	__builtin_memset( &TMP$318$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$318$1, -1ll, (void*)"ab", 3ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &J$1, (FBSTRING*)&TMP$318$1, (FBUSTRING*)&TMP$320$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$320$1 );
	fb_StrDelete( (FBSTRING*)&TMP$318$1 );
	int32 vr$208 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &J$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$208 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 100, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_EMPTY_FIELDS_ARE_FIELDS", (char*)"CU_ASSERT_EQUAL(j.Count( ),1)" );
	_ZN5ArrayI8FBSTRINGED1Ev( &J$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &I_$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &H$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &G$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &F$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &E$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &D$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &C$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &B$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &A$1 );
	label$507:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT30SPLIT_NON_OVERLAPPING_AND_CASEEv( void )
{
	FBSTRING TMP$331$1;
	FBUSTRING TMP$333$1;
	FBSTRING TMP$337$1;
	FBUSTRING TMP$338$1;
	FBSTRING TMP$341$1;
	FBUSTRING TMP$343$1;
	FBSTRING TMP$347$1;
	FBUSTRING TMP$348$1;
	label$510:;
	struct $5ArrayI8FBSTRINGE A$1;
	__builtin_memset( &TMP$333$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$333$1, -1ll, (void*)(uint16[]){0x0061,0x0061,0x0000}, -9223372036854775806ll, 0 );
	__builtin_memset( &TMP$331$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$331$1, -1ll, (void*)"aaaa", 5ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &A$1, (FBSTRING*)&TMP$331$1, (FBUSTRING*)&TMP$333$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$333$1 );
	fb_StrDelete( (FBSTRING*)&TMP$331$1 );
	int32 vr$10 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &A$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$10 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 106, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_NON_OVERLAPPING_AND_CASE", (char*)"CU_ASSERT_EQUAL(a.Count( ),3)" );
	struct $5ArrayI8FBSTRINGE B$1;
	__builtin_memset( &TMP$338$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$338$1, -1ll, (void*)(uint16[]){0x0061,0x0061,0x0000}, -9223372036854775806ll, 0 );
	__builtin_memset( &TMP$337$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$337$1, -1ll, (void*)"aaa", 4ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &B$1, (FBSTRING*)&TMP$337$1, (FBUSTRING*)&TMP$338$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$338$1 );
	fb_StrDelete( (FBSTRING*)&TMP$337$1 );
	int32 vr$24 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &B$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$24 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 109, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_NON_OVERLAPPING_AND_CASE", (char*)"CU_ASSERT_EQUAL(b.Count( ),2)" );
	FBSTRING* vr$29 = _ZN5ArrayI8FBSTRINGEixEi( &B$1, 1 );
	int32 vr$30 = fb_StrCompare( (void*)vr$29, -1ll, (void*)"a", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$30 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 110, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_NON_OVERLAPPING_AND_CASE", (char*)"CU_ASSERT_EQUAL(b[1],\x22" "a\x22)" );
	struct $5ArrayI8FBSTRINGE C$1;
	__builtin_memset( &TMP$343$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$343$1, -1ll, (void*)(uint16[]){0x0078,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$341$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$341$1, -1ll, (void*)"aXbXc", 6ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &C$1, (FBSTRING*)&TMP$341$1, (FBUSTRING*)&TMP$343$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$343$1 );
	fb_StrDelete( (FBSTRING*)&TMP$341$1 );
	int32 vr$44 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &C$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$44 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 113, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_NON_OVERLAPPING_AND_CASE", (char*)"CU_ASSERT_EQUAL(c.Count( ),1)" );
	struct $5ArrayI8FBSTRINGE D$1;
	__builtin_memset( &TMP$348$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$348$1, -1ll, (void*)(uint16[]){0x0078,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$347$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$347$1, -1ll, (void*)"aXbXc", 6ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &D$1, (FBSTRING*)&TMP$347$1, (FBUSTRING*)&TMP$348$1, (boolean)1ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$348$1 );
	fb_StrDelete( (FBSTRING*)&TMP$347$1 );
	int32 vr$58 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$58 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 116, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_NON_OVERLAPPING_AND_CASE", (char*)"CU_ASSERT_EQUAL(d.Count( ),3)" );
	FBSTRING* vr$63 = _ZN5ArrayI8FBSTRINGEixEi( &D$1, 1 );
	int32 vr$64 = fb_StrCompare( (void*)vr$63, -1ll, (void*)"b", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$64 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 117, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_NON_OVERLAPPING_AND_CASE", (char*)"CU_ASSERT_EQUAL(d[1],\x22" "b\x22)" );
	_ZN5ArrayI8FBSTRINGED1Ev( &D$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &C$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &B$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &A$1 );
	label$511:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT17SPLITCHARS_STRINGEv( void )
{
	FBSTRING TMP$358$1;
	FBUSTRING TMP$360$1;
	FBSTRING TMP$364$1;
	FBUSTRING TMP$365$1;
	FBSTRING TMP$371$1;
	FBUSTRING TMP$372$1;
	FBSTRING TMP$374$1;
	FBUSTRING TMP$375$1;
	FBSTRING TMP$381$1;
	FBUSTRING TMP$383$1;
	FBSTRING TMP$393$1;
	FBUSTRING TMP$395$1;
	label$514:;
	struct $5ArrayI8FBSTRINGE A$1;
	__builtin_memset( &TMP$360$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$360$1, -1ll, (void*)(uint16[]){0x002C,0x003B,0x0000}, -9223372036854775806ll, 0 );
	__builtin_memset( &TMP$358$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$358$1, -1ll, (void*)"a,b;c", 6ll, 0 );
	_ZN2FB10SPLITCHARSERK8FBSTRINGRK9FBUSTRINGb( &A$1, (FBSTRING*)&TMP$358$1, (FBUSTRING*)&TMP$360$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$360$1 );
	fb_StrDelete( (FBSTRING*)&TMP$358$1 );
	int32 vr$10 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &A$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$10 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 122, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(a.Count( ),3)" );
	FBSTRING* vr$15 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 0 );
	int32 vr$16 = fb_StrCompare( (void*)vr$15, -1ll, (void*)"a", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$16 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 123, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(a[0],\x22" "a\x22)" );
	FBSTRING* vr$21 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 1 );
	int32 vr$22 = fb_StrCompare( (void*)vr$21, -1ll, (void*)"b", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$22 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 124, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(a[1],\x22" "b\x22)" );
	FBSTRING* vr$27 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 2 );
	int32 vr$28 = fb_StrCompare( (void*)vr$27, -1ll, (void*)"c", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$28 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 125, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(a[2],\x22" "c\x22)" );
	struct $5ArrayI8FBSTRINGE B$1;
	__builtin_memset( &TMP$365$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$365$1, -1ll, (void*)(uint16[]){0x002C,0x003B,0x0000}, -9223372036854775806ll, 0 );
	__builtin_memset( &TMP$364$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$364$1, -1ll, (void*)"a,;b", 5ll, 0 );
	_ZN2FB10SPLITCHARSERK8FBSTRINGRK9FBUSTRINGb( &B$1, (FBSTRING*)&TMP$364$1, (FBUSTRING*)&TMP$365$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$365$1 );
	fb_StrDelete( (FBSTRING*)&TMP$364$1 );
	int32 vr$42 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &B$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$42 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 129, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(b.Count( ),3)" );
	FBSTRING* vr$47 = _ZN5ArrayI8FBSTRINGEixEi( &B$1, 1 );
	int32 vr$48 = fb_StrCompare( (void*)vr$47, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$48 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 130, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(b[1],\x22\x22)" );
	struct $5ArrayI8FBSTRINGE C$1;
	__builtin_memset( &TMP$372$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$372$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
	__builtin_memset( &TMP$371$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$371$1, -1ll, (void*)"abc", 4ll, 0 );
	_ZN2FB10SPLITCHARSERK8FBSTRINGRK9FBUSTRINGb( &C$1, (FBSTRING*)&TMP$371$1, (FBUSTRING*)&TMP$372$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$372$1 );
	fb_StrDelete( (FBSTRING*)&TMP$371$1 );
	int32 vr$62 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &C$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$62 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 133, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(c.Count( ),1)" );
	struct $5ArrayI8FBSTRINGE D$1;
	__builtin_memset( &TMP$375$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$375$1, -1ll, (void*)(uint16[]){0x002C,0x003B,0x0000}, -9223372036854775806ll, 0 );
	__builtin_memset( &TMP$374$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$374$1, -1ll, (void*)"", 1ll, 0 );
	_ZN2FB10SPLITCHARSERK8FBSTRINGRK9FBUSTRINGb( &D$1, (FBSTRING*)&TMP$374$1, (FBUSTRING*)&TMP$375$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$375$1 );
	fb_StrDelete( (FBSTRING*)&TMP$374$1 );
	int32 vr$76 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$76 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 136, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(d.Count( ),1)" );
	struct $5ArrayI8FBSTRINGE E$1;
	__builtin_memset( &TMP$383$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$383$1, -1ll, (void*)(uint16[]){0x0078,0x0079,0x0000}, -9223372036854775806ll, 0 );
	__builtin_memset( &TMP$381$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$381$1, -1ll, (void*)"aXbYc", 6ll, 0 );
	_ZN2FB10SPLITCHARSERK8FBSTRINGRK9FBUSTRINGb( &E$1, (FBSTRING*)&TMP$381$1, (FBUSTRING*)&TMP$383$1, (boolean)1ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$383$1 );
	fb_StrDelete( (FBSTRING*)&TMP$381$1 );
	int32 vr$90 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &E$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$90 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 139, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(e.Count( ),3)" );
	struct $5ArrayI8FBSTRINGE F$1;
	__builtin_memset( &TMP$395$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$395$1, -1ll, (void*)(uint16[]){0x0020,0x0009,0x0000}, -9223372036854775806ll, 0 );
	__builtin_memset( &TMP$393$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$393$1, -1ll, (void*)"one two\x09three", 14ll, 0 );
	_ZN2FB10SPLITCHARSERK8FBSTRINGRK9FBUSTRINGb( &F$1, (FBSTRING*)&TMP$393$1, (FBUSTRING*)&TMP$395$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$395$1 );
	fb_StrDelete( (FBSTRING*)&TMP$393$1 );
	int32 vr$104 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &F$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$104 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 143, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(f.Count( ),3)" );
	FBSTRING* vr$109 = _ZN5ArrayI8FBSTRINGEixEi( &F$1, 2 );
	int32 vr$110 = fb_StrCompare( (void*)vr$109, -1ll, (void*)"three", 6ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$110 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 144, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLITCHARS_STRING", (char*)"CU_ASSERT_EQUAL(f[2],\x22three\x22)" );
	_ZN5ArrayI8FBSTRINGED1Ev( &F$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &E$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &D$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &C$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &B$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &A$1 );
	label$515:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT11JOIN_STRINGEv( void )
{
	FBUSTRING TMP$406$1;
	FBUSTRING TMP$414$1;
	FBUSTRING TMP$420$1;
	FBUSTRING TMP$426$1;
	FBUSTRING TMP$431$1;
	FBUSTRING TMP$441$1;
	FBUSTRING TMP$449$1;
	FBUSTRING TMP$457$1;
	label$518:;
	struct $5ArrayI8FBSTRINGE A$1;
	_ZN5ArrayI8FBSTRINGEC1Ev( &A$1 );
	__builtin_memset( &TMP$406$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$406$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBSTRING* vr$5 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &A$1, (FBUSTRING*)&TMP$406$1 );
	int32 vr$6 = fb_StrCompare( (void*)vr$5, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$6 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 151, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_STRING", (char*)"CU_ASSERT_EQUAL(Join( a ),\x22\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$406$1 );
	FBSTRING ONE$1;
	fb_StrInit( (void*)&ONE$1, -1ll, (void*)"solo", 5ll, 0 );
	_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &A$1, &ONE$1 );
	__builtin_memset( &TMP$414$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$414$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBSTRING* vr$18 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &A$1, (FBUSTRING*)&TMP$414$1 );
	int32 vr$19 = fb_StrCompare( (void*)vr$18, -1ll, (void*)"solo", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$19 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 155, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_STRING", (char*)"CU_ASSERT_EQUAL(Join( a ),\x22solo\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$414$1 );
	__builtin_memset( &TMP$420$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$420$1, -1ll, (void*)(uint16[]){0x002D,0x002D,0x002D,0x0000}, -9223372036854775805ll, 0 );
	FBSTRING* vr$28 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &A$1, (FBUSTRING*)&TMP$420$1 );
	int32 vr$29 = fb_StrCompare( (void*)vr$28, -1ll, (void*)"solo", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$29 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 156, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_STRING", (char*)"CU_ASSERT_EQUAL(Join( a, \x22---\x22 ),\x22solo\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$420$1 );
	FBSTRING TWO$1;
	fb_StrInit( (void*)&TWO$1, -1ll, (void*)"b", 2ll, 0 );
	_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &A$1, &TWO$1 );
	__builtin_memset( &TMP$426$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$426$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBSTRING* vr$41 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &A$1, (FBUSTRING*)&TMP$426$1 );
	int32 vr$42 = fb_StrCompare( (void*)vr$41, -1ll, (void*)"solo,b", 7ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$42 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 160, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_STRING", (char*)"CU_ASSERT_EQUAL(Join( a ),\x22solo,b\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$426$1 );
	__builtin_memset( &TMP$431$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$431$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
	FBSTRING* vr$51 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &A$1, (FBUSTRING*)&TMP$431$1 );
	int32 vr$52 = fb_StrCompare( (void*)vr$51, -1ll, (void*)"solob", 6ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$52 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 161, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_STRING", (char*)"CU_ASSERT_EQUAL(Join( a, \x22\x22 ),\x22solob\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$431$1 );
	__builtin_memset( &TMP$441$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$441$1, -1ll, (void*)(uint16[]){0x0020,0x002D,0x003E,0x0020,0x0000}, -9223372036854775804ll, 0 );
	FBSTRING* vr$61 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &A$1, (FBUSTRING*)&TMP$441$1 );
	int32 vr$62 = fb_StrCompare( (void*)vr$61, -1ll, (void*)"solo -> b", 10ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$62 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 162, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_STRING", (char*)"CU_ASSERT_EQUAL(Join( a, \x22 -> \x22 ),\x22solo -> b\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$441$1 );
	struct $5ArrayI8FBSTRINGE B$1;
	_ZN5ArrayI8FBSTRINGEC1Ev( &B$1 );
	FBSTRING E$1;
	fb_StrInit( (void*)&E$1, -1ll, (void*)"", 1ll, 0 );
	_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &B$1, &E$1 );
	_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &B$1, &E$1 );
	_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &B$1, &E$1 );
	int32 vr$76 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &B$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$76 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 168, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_STRING", (char*)"CU_ASSERT_EQUAL(b.Count( ),3)" );
	__builtin_memset( &TMP$449$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$449$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBSTRING* vr$84 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &B$1, (FBUSTRING*)&TMP$449$1 );
	int32 vr$85 = fb_StrCompare( (void*)vr$84, -1ll, (void*)",,", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$85 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 169, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_STRING", (char*)"CU_ASSERT_EQUAL(Join( b ),\x22,,\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$449$1 );
	__builtin_memset( &TMP$457$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$457$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
	FBSTRING* vr$94 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &B$1, (FBUSTRING*)&TMP$457$1 );
	int32 vr$95 = fb_StrCompare( (void*)vr$94, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$95 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 170, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_STRING", (char*)"CU_ASSERT_EQUAL(Join( b, \x22\x22 ),\x22\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$457$1 );
	fb_StrDelete( (FBSTRING*)&E$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &B$1 );
	fb_StrDelete( (FBSTRING*)&TWO$1 );
	fb_StrDelete( (FBSTRING*)&ONE$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &A$1 );
	label$519:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT20JOIN_SPLIT_ROUNDTRIPEv( void )
{
	label$522:;
	FBSTRING CASES$1[14];
	struct $N5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT10FBARRAY1$1I8FBSTRINGEE {
		FBSTRING* DATA;
		FBSTRING* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT10FBARRAY1$1I8FBSTRINGEE ) == 72 );
	struct $N5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT10FBARRAY1$1I8FBSTRINGEE tmp$465$1;
	*(FBSTRING**)&tmp$465$1 = (FBSTRING*)CASES$1;
	*(FBSTRING**)((uint8*)&tmp$465$1 + 8ll) = (FBSTRING*)CASES$1;
	*(int64*)((uint8*)&tmp$465$1 + 16ll) = 336ll;
	*(int64*)((uint8*)&tmp$465$1 + 24ll) = 24ll;
	*(int64*)((uint8*)&tmp$465$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$465$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$465$1 + 48ll) = 14ll;
	*(int64*)((uint8*)&tmp$465$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$465$1 + 64ll) = 13ll;
	fb_StrInit( (void*)CASES$1, -1ll, (void*)"", 1ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 24ll), -1ll, (void*)"a", 2ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 48ll), -1ll, (void*)"a,b", 4ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 72ll), -1ll, (void*)"a,b,c", 6ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 96ll), -1ll, (void*)",", 2ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 120ll), -1ll, (void*)",,", 3ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 144ll), -1ll, (void*)"a,", 3ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 168ll), -1ll, (void*)",a", 3ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 192ll), -1ll, (void*)"a,,b", 5ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 216ll), -1ll, (void*)",,a,,", 6ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 240ll), -1ll, (void*)"abc", 4ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 264ll), -1ll, (void*)"a,b,,c,", 8ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 288ll), -1ll, (void*)",,,,", 5ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)CASES$1 + 312ll), -1ll, (void*)"one,two,three", 14ll, 0 );
	{
		int64 I$2;
		I$2 = 0ll;
		label$527:;
		{
			FBUSTRING TMP$473$3;
			FBUSTRING TMP$474$3;
			FBUSTRING TMP$482$3;
			struct $5ArrayI8FBSTRINGE PARTS$3;
			__builtin_memset( &TMP$473$3, 0, 24ll );
			fb_UStrAssign( (void*)&TMP$473$3, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
			_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &PARTS$3, (FBSTRING*)((int64)(FBSTRING*)CASES$1 + (I$2 * 24ll)), (FBUSTRING*)&TMP$473$3, (boolean)0ll );
			fb_UStrDelete( (FBUSTRING*)&TMP$473$3 );
			__builtin_memset( &TMP$474$3, 0, 24ll );
			fb_UStrAssign( (void*)&TMP$474$3, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
			FBSTRING* vr$29 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &PARTS$3, (FBUSTRING*)&TMP$474$3 );
			int32 vr$30 = fb_StrCompare( (void*)vr$29, -1ll, (void*)((int64)(FBSTRING*)CASES$1 + (I$2 * 24ll)), -1ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$30 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 183, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_SPLIT_ROUNDTRIP", (char*)"CU_ASSERT_EQUAL(Join( parts, \x22,\x22 ),cases( i ))" );
			fb_UStrDelete( (FBUSTRING*)&TMP$474$3 );
			int32 vr$36 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &PARTS$3 );
			__builtin_memset( &TMP$482$3, 0, 24ll );
			fb_UStrAssign( (void*)&TMP$482$3, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
			int64 vr$43 = fb_StrTally( (FBSTRING*)((int64)(FBSTRING*)CASES$1 + (I$2 * 24ll)), (FBUSTRING*)&TMP$482$3, (boolean)0ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$36 == (vr$43 + 1ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 185, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_SPLIT_ROUNDTRIP", (char*)"CU_ASSERT_EQUAL(parts.Count( ),Tally( cases( i ), \x22,\x22 ) + 1)" );
			fb_UStrDelete( (FBUSTRING*)&TMP$482$3 );
			_ZN5ArrayI8FBSTRINGED1Ev( &PARTS$3 );
		}
		label$525:;
		I$2 = I$2 + 1ll;
		label$524:;
		if( I$2 <= 13ll) goto label$527;
		label$526:;
	}
	FBSTRING MCASES$1[5];
	struct $N5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT10FBARRAY1$1I8FBSTRINGEE tmp$489$1;
	*(FBSTRING**)&tmp$489$1 = (FBSTRING*)MCASES$1;
	*(FBSTRING**)((uint8*)&tmp$489$1 + 8ll) = (FBSTRING*)MCASES$1;
	*(int64*)((uint8*)&tmp$489$1 + 16ll) = 120ll;
	*(int64*)((uint8*)&tmp$489$1 + 24ll) = 24ll;
	*(int64*)((uint8*)&tmp$489$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$489$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$489$1 + 48ll) = 5ll;
	*(int64*)((uint8*)&tmp$489$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$489$1 + 64ll) = 4ll;
	fb_StrInit( (void*)MCASES$1, -1ll, (void*)"", 1ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)MCASES$1 + 24ll), -1ll, (void*)"a", 2ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)MCASES$1 + 48ll), -1ll, (void*)"a<>b", 5ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)MCASES$1 + 72ll), -1ll, (void*)"<>", 3ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)MCASES$1 + 96ll), -1ll, (void*)"a<><>b", 7ll, 0 );
	{
		int64 I$2;
		I$2 = 0ll;
		label$531:;
		{
			FBUSTRING TMP$493$3;
			FBUSTRING TMP$494$3;
			struct $5ArrayI8FBSTRINGE PARTS$3;
			__builtin_memset( &TMP$493$3, 0, 24ll );
			fb_UStrAssign( (void*)&TMP$493$3, -1ll, (void*)(uint16[]){0x003C,0x003E,0x0000}, -9223372036854775806ll, 0 );
			_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &PARTS$3, (FBSTRING*)((int64)(FBSTRING*)MCASES$1 + (I$2 * 24ll)), (FBUSTRING*)&TMP$493$3, (boolean)0ll );
			fb_UStrDelete( (FBUSTRING*)&TMP$493$3 );
			__builtin_memset( &TMP$494$3, 0, 24ll );
			fb_UStrAssign( (void*)&TMP$494$3, -1ll, (void*)(uint16[]){0x003C,0x003E,0x0000}, -9223372036854775806ll, 0 );
			FBSTRING* vr$70 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &PARTS$3, (FBUSTRING*)&TMP$494$3 );
			int32 vr$71 = fb_StrCompare( (void*)vr$70, -1ll, (void*)((int64)(FBSTRING*)MCASES$1 + (I$2 * 24ll)), -1ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$71 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 192, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.JOIN_SPLIT_ROUNDTRIP", (char*)"CU_ASSERT_EQUAL(Join( parts, \x22<>\x22 ),mcases( i ))" );
			fb_UStrDelete( (FBUSTRING*)&TMP$494$3 );
			_ZN5ArrayI8FBSTRINGED1Ev( &PARTS$3 );
		}
		label$529:;
		I$2 = I$2 + 1ll;
		label$528:;
		if( I$2 <= 4ll) goto label$531;
		label$530:;
	}
	fb_ArrayDestructStr( (struct $7FBARRAYIvE*)&tmp$489$1 );
	fb_ArrayDestructStr( (struct $7FBARRAYIvE*)&tmp$465$1 );
	label$523:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SPLIT_ZSTRINGEv( void )
{
	FBSTRING TMP$504$1;
	FBUSTRING TMP$505$1;
	FBUSTRING TMP$507$1;
	label$534:;
	char Z$1[16];
	fb_StrAssign( (void*)Z$1, 16ll, (void*)"a,b,c", 6ll, 0 );
	struct $5ArrayI8FBSTRINGE A$1;
	__builtin_memset( &TMP$505$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$505$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$504$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$504$1, -1ll, (void*)Z$1, 16ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &A$1, (FBSTRING*)&TMP$504$1, (FBUSTRING*)&TMP$505$1, (boolean)0ll );
	fb_StrAssign( (void*)Z$1, 16ll, (void*)&TMP$504$1, -1ll, 0 );
	fb_UStrDelete( (FBUSTRING*)&TMP$505$1 );
	fb_StrDelete( (FBSTRING*)&TMP$504$1 );
	int32 vr$14 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &A$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$14 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 204, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_ZSTRING", (char*)"CU_ASSERT_EQUAL(a.Count( ),3)" );
	FBSTRING* vr$19 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 2 );
	int32 vr$20 = fb_StrCompare( (void*)vr$19, -1ll, (void*)"c", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$20 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 205, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_ZSTRING", (char*)"CU_ASSERT_EQUAL(a[2],\x22" "c\x22)" );
	__builtin_memset( &TMP$507$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$507$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBSTRING* vr$28 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &A$1, (FBUSTRING*)&TMP$507$1 );
	int32 vr$29 = fb_StrCompare( (void*)vr$28, -1ll, (void*)"a,b,c", 6ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$29 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 206, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_ZSTRING", (char*)"CU_ASSERT_EQUAL(Join( a ),\x22" "a,b,c\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$507$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &A$1 );
	label$535:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SPLIT_USTRINGEv( void )
{
	FBUSTRING TMP$515$1;
	FBUSTRING TMP$524$1;
	FBUSTRING TMP$527$1;
	FBUSTRING TMP$537$1;
	FBUSTRING TMP$542$1;
	FBUSTRING TMP$543$1;
	FBUSTRING TMP$548$1;
	label$538:;
	FBUSTRING U$1;
	fb_UStrInit( (void*)&U$1, -1ll, (void*)(uint16[]){0x0061,0x002C,0x0062,0x002C,0x0063,0x0000}, -9223372036854775803ll, 0 );
	struct $5ArrayI9FBUSTRINGE A$1;
	__builtin_memset( &TMP$515$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$515$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB5SPLITERK9FBUSTRINGS2_b( &A$1, (FBUSTRING*)&U$1, (FBUSTRING*)&TMP$515$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$515$1 );
	int32 vr$8 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &A$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$8 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 212, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(a.Count( ),3)" );
	FBUSTRING* vr$13 = _ZN5ArrayI9FBUSTRINGEixEi( &A$1, 0 );
	int32 vr$14 = fb_UStrCompare( (void*)vr$13, -1ll, (void*)(uint16[]){0x0061,0x0000}, -9223372036854775807ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$14 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 213, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(a[0],\x22" "a\x22)" );
	FBUSTRING* vr$19 = _ZN5ArrayI9FBUSTRINGEixEi( &A$1, 2 );
	int32 vr$20 = fb_UStrCompare( (void*)vr$19, -1ll, (void*)(uint16[]){0x0063,0x0000}, -9223372036854775807ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$20 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 214, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(a[2],\x22" "c\x22)" );
	FBUSTRING* vr$25 = _ZN5ArrayI9FBUSTRINGEixEi( &A$1, 0 );
	int64 vr$26 = fb_UStrLen( (void*)vr$25, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$26 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 215, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(len( a[0] ),1)" );
	__builtin_memset( &TMP$524$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$524$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBUSTRING* vr$33 = _ZN2FB4JOINER5ArrayI9FBUSTRINGERKS1_( &A$1, (FBUSTRING*)&TMP$524$1 );
	int32 vr$34 = fb_UStrCompare( (void*)vr$33, -1ll, (void*)(uint16[]){0x0061,0x002C,0x0062,0x002C,0x0063,0x0000}, -9223372036854775803ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$34 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 216, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(Join( a ),\x22" "a,b,c\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$524$1 );
	__builtin_memset( &TMP$527$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$527$1, -1ll, (void*)(uint16[]){0x007C,0x0000}, -9223372036854775807ll, 0 );
	FBUSTRING* vr$43 = _ZN2FB4JOINER5ArrayI9FBUSTRINGERKS1_( &A$1, (FBUSTRING*)&TMP$527$1 );
	int32 vr$44 = fb_UStrCompare( (void*)vr$43, -1ll, (void*)(uint16[]){0x0061,0x007C,0x0062,0x007C,0x0063,0x0000}, -9223372036854775803ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$44 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 217, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(Join( a, \x22|\x22 ),\x22" "a|b|c\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$527$1 );
	FBUSTRING UE$1;
	fb_UStrInit( (void*)&UE$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
	struct $5ArrayI9FBUSTRINGE B$1;
	__builtin_memset( &TMP$537$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$537$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB5SPLITERK9FBUSTRINGS2_b( &B$1, (FBUSTRING*)&UE$1, (FBUSTRING*)&TMP$537$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$537$1 );
	int32 vr$57 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &B$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$57 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 221, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(b.Count( ),1)" );
	FBUSTRING* vr$62 = _ZN5ArrayI9FBUSTRINGEixEi( &B$1, 0 );
	int32 vr$63 = fb_UStrCompare( (void*)vr$62, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$63 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 222, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(b[0],\x22\x22)" );
	uint16 UF$1[16];
	fb_UStrInit( (void*)UF$1, -9223372036854775793ll, (void*)(uint16[]){0x0078,0x003B,0x0079,0x0000}, -9223372036854775805ll, -1 );
	struct $5ArrayI9FBUSTRINGE C$1;
	__builtin_memset( &TMP$543$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$543$1, -1ll, (void*)(uint16[]){0x003B,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$542$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$542$1, -1ll, (void*)UF$1, -9223372036854775793ll, 0 );
	_ZN2FB5SPLITERK9FBUSTRINGS2_b( &C$1, (FBUSTRING*)&TMP$542$1, (FBUSTRING*)&TMP$543$1, (boolean)0ll );
	fb_UStrAssign( (void*)UF$1, -9223372036854775793ll, (void*)&TMP$542$1, -1ll, -1 );
	fb_UStrDelete( (FBUSTRING*)&TMP$543$1 );
	fb_UStrDelete( (FBUSTRING*)&TMP$542$1 );
	int32 vr$81 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &C$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$81 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 226, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(c.Count( ),2)" );
	FBUSTRING* vr$86 = _ZN5ArrayI9FBUSTRINGEixEi( &C$1, 1 );
	int32 vr$87 = fb_UStrCompare( (void*)vr$86, -1ll, (void*)(uint16[]){0x0079,0x0000}, -9223372036854775807ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$87 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 227, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(c[1],\x22y\x22)" );
	struct $5ArrayI9FBUSTRINGE D$1;
	__builtin_memset( &TMP$548$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$548$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB10SPLITCHARSERK9FBUSTRINGS2_b( &D$1, (FBUSTRING*)&U$1, (FBUSTRING*)&TMP$548$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$548$1 );
	int32 vr$98 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$98 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 230, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_USTRING", (char*)"CU_ASSERT_EQUAL(d.Count( ),3)" );
	_ZN5ArrayI9FBUSTRINGED1Ev( &D$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &C$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &B$1 );
	fb_UStrDelete( (FBUSTRING*)&UE$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &A$1 );
	fb_UStrDelete( (FBUSTRING*)&U$1 );
	label$539:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT33SPLIT_WSTRING_GIVES_USTRING_ARRAYEv( void )
{
	FBUSTRING TMP$552$1;
	FBUSTRING TMP$560$1;
	FBUSTRING TMP$562$1;
	label$542:;
	uint16 W$1[16];
	fb_WstrAssignFromA( (uint16*)W$1, 16ll, (void*)"a,b,c", 6ll );
	struct $5ArrayI9FBUSTRINGE A$1;
	__builtin_memset( &TMP$552$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$552$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB5SPLITERKwRK9FBUSTRINGb( &A$1, (uint16*)W$1, (FBUSTRING*)&TMP$552$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$552$1 );
	int32 vr$8 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &A$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$8 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 239, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_WSTRING_GIVES_USTRING_ARRAY", (char*)"CU_ASSERT_EQUAL(a.Count( ),3)" );
	FBUSTRING* vr$13 = _ZN5ArrayI9FBUSTRINGEixEi( &A$1, 1 );
	int32 vr$14 = fb_UStrCompare( (void*)vr$13, -1ll, (void*)(uint16[]){0x0062,0x0000}, -9223372036854775807ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$14 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 240, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_WSTRING_GIVES_USTRING_ARRAY", (char*)"CU_ASSERT_EQUAL(a[1],\x22" "b\x22)" );
	FBUSTRING* vr$19 = _ZN5ArrayI9FBUSTRINGEixEi( &A$1, 1 );
	int64 vr$20 = fb_UStrLen( (void*)vr$19, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$20 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 241, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_WSTRING_GIVES_USTRING_ARRAY", (char*)"CU_ASSERT_EQUAL(len( a[1] ),1)" );
	__builtin_memset( &TMP$560$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$560$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBUSTRING* vr$27 = _ZN2FB4JOINER5ArrayI9FBUSTRINGERKS1_( &A$1, (FBUSTRING*)&TMP$560$1 );
	int32 vr$28 = fb_UStrCompare( (void*)vr$27, -1ll, (void*)(uint16[]){0x0061,0x002C,0x0062,0x002C,0x0063,0x0000}, -9223372036854775803ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$28 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 242, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_WSTRING_GIVES_USTRING_ARRAY", (char*)"CU_ASSERT_EQUAL(Join( a ),\x22" "a,b,c\x22)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$560$1 );
	struct $5ArrayI9FBUSTRINGE B$1;
	__builtin_memset( &TMP$562$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$562$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB10SPLITCHARSERKwRK9FBUSTRINGb( &B$1, (uint16*)W$1, (FBUSTRING*)&TMP$562$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$562$1 );
	int32 vr$40 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &B$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$40 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 245, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_WSTRING_GIVES_USTRING_ARRAY", (char*)"CU_ASSERT_EQUAL(b.Count( ),3)" );
	_ZN5ArrayI9FBUSTRINGED1Ev( &B$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &A$1 );
	label$543:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SPLIT_UNICODEEv( void )
{
	FBUSTRING TMP$583$1;
	FBUSTRING TMP$589$1;
	FBUSTRING TMP$604$1;
	FBUSTRING TMP$620$1;
	FBUSTRING TMP$627$1;
	label$546:;
	FBUSTRING ASTRAL$1;
	fb_UStrInit( (void*)&ASTRAL$1, -1ll, (void*)(uint16[]){0xD834,0xDD1E,0x0000}, -9223372036854775806ll, 0 );
	int64 vr$2 = fb_UStrLen( (void*)&ASTRAL$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$2 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 253, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(len( astral ),2)" );
	FBUSTRING U$1;
	fb_UStrInit( (void*)&U$1, -1ll, (void*)(uint16[]){0x0061,0x002C,0x0000}, -9223372036854775806ll, 0 );
	fb_UStrConcatAssign( (void*)&U$1, -1ll, (void*)&ASTRAL$1, -1ll, 0 );
	fb_UStrConcatAssign( (void*)&U$1, -1ll, (void*)(uint16[]){0x002C,0x0062,0x0000}, -9223372036854775806ll, 0 );
	int64 vr$10 = fb_UStrLen( (void*)&U$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$10 == 6ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 258, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(len( u ),6)" );
	struct $5ArrayI9FBUSTRINGE A$1;
	__builtin_memset( &TMP$583$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$583$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB5SPLITERK9FBUSTRINGS2_b( &A$1, (FBUSTRING*)&U$1, (FBUSTRING*)&TMP$583$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$583$1 );
	int32 vr$20 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &A$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$20 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 261, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(a.Count( ),3)" );
	FBUSTRING* vr$25 = _ZN5ArrayI9FBUSTRINGEixEi( &A$1, 1 );
	int64 vr$26 = fb_UStrLen( (void*)vr$25, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$26 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 262, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(len( a[1] ),2)" );
	FBUSTRING* vr$31 = _ZN5ArrayI9FBUSTRINGEixEi( &A$1, 1 );
	int32 vr$32 = fb_UStrCompare( (void*)vr$31, -1ll, (void*)&ASTRAL$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$32 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 263, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(a[1],astral)" );
	__builtin_memset( &TMP$589$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$589$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBUSTRING* vr$41 = _ZN2FB4JOINER5ArrayI9FBUSTRINGERKS1_( &A$1, (FBUSTRING*)&TMP$589$1 );
	int32 vr$42 = fb_UStrCompare( (void*)vr$41, -1ll, (void*)&U$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$42 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 264, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(Join( a ),u)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$589$1 );
	FBUSTRING V$1;
	fb_UStrInit( (void*)&V$1, -1ll, (void*)(uint16[]){0x0078,0x0000}, -9223372036854775807ll, 0 );
	fb_UStrConcatAssign( (void*)&V$1, -1ll, (void*)&ASTRAL$1, -1ll, 0 );
	fb_UStrConcatAssign( (void*)&V$1, -1ll, (void*)(uint16[]){0x0079,0x0000}, -9223372036854775807ll, 0 );
	struct $5ArrayI9FBUSTRINGE B$1;
	_ZN2FB5SPLITERK9FBUSTRINGS2_b( &B$1, (FBUSTRING*)&V$1, (FBUSTRING*)&ASTRAL$1, (boolean)0ll );
	int32 vr$55 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &B$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$55 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 271, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(b.Count( ),2)" );
	FBUSTRING* vr$60 = _ZN5ArrayI9FBUSTRINGEixEi( &B$1, 0 );
	int32 vr$61 = fb_UStrCompare( (void*)vr$60, -1ll, (void*)(uint16[]){0x0078,0x0000}, -9223372036854775807ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$61 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 272, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(b[0],\x22x\x22)" );
	FBUSTRING* vr$66 = _ZN5ArrayI9FBUSTRINGEixEi( &B$1, 1 );
	int32 vr$67 = fb_UStrCompare( (void*)vr$66, -1ll, (void*)(uint16[]){0x0079,0x0000}, -9223372036854775807ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$67 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 273, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(b[1],\x22y\x22)" );
	FBUSTRING ACC$1;
	fb_UStrInit( (void*)&ACC$1, -1ll, (void*)(uint16[]){0x0063,0x0061,0x0066,0x00E9,0x0058,0x00E9,0x0000}, -9223372036854775802ll, 0 );
	struct $5ArrayI9FBUSTRINGE C$1;
	__builtin_memset( &TMP$604$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$604$1, -1ll, (void*)(uint16[]){0x00C9,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB5SPLITERK9FBUSTRINGS2_b( &C$1, (FBUSTRING*)&ACC$1, (FBUSTRING*)&TMP$604$1, (boolean)1ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$604$1 );
	int32 vr$79 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &C$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$79 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 278, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(c.Count( ),3)" );
	FBUSTRING* vr$84 = _ZN5ArrayI9FBUSTRINGEixEi( &C$1, 0 );
	int32 vr$85 = fb_UStrCompare( (void*)vr$84, -1ll, (void*)(uint16[]){0x0063,0x0061,0x0066,0x0000}, -9223372036854775805ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$85 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 279, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(c[0],\x22" "caf\x22)" );
	FBUSTRING* vr$90 = _ZN5ArrayI9FBUSTRINGEixEi( &C$1, 1 );
	int32 vr$91 = fb_UStrCompare( (void*)vr$90, -1ll, (void*)(uint16[]){0x0058,0x0000}, -9223372036854775807ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$91 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 280, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(c[1],\x22X\x22)" );
	FBSTRING SB$1;
	fb_StrInit( (void*)&SB$1, -1ll, (void*)"caf\xC3\xA9,x", 8ll, 0 );
	struct $5ArrayI8FBSTRINGE D$1;
	__builtin_memset( &TMP$620$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$620$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &D$1, (FBSTRING*)&SB$1, (FBUSTRING*)&TMP$620$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$620$1 );
	int32 vr$103 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$103 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 285, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(d.Count( ),2)" );
	FBSTRING* vr$108 = _ZN5ArrayI8FBSTRINGEixEi( &D$1, 0 );
	int64 vr$109 = fb_StrLen( (void*)vr$108, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$109 == 5ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 286, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(len( d[0] ),5)" );
	__builtin_memset( &TMP$627$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$627$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBSTRING* vr$117 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &D$1, (FBUSTRING*)&TMP$627$1 );
	int32 vr$118 = fb_StrCompare( (void*)vr$117, -1ll, (void*)&SB$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$118 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 287, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_UNICODE", (char*)"CU_ASSERT_EQUAL(Join( d ),sb)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$627$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &D$1 );
	fb_StrDelete( (FBSTRING*)&SB$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &C$1 );
	fb_UStrDelete( (FBUSTRING*)&ACC$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &B$1 );
	fb_UStrDelete( (FBUSTRING*)&V$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &A$1 );
	fb_UStrDelete( (FBUSTRING*)&U$1 );
	fb_UStrDelete( (FBUSTRING*)&ASTRAL$1 );
	label$547:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT23SPLIT_ROUNDTRIP_USTRINGEv( void )
{
	label$550:;
	FBUSTRING UCASES$1[7];
	__builtin_memset( (FBUSTRING*)UCASES$1, 0, 168ll );
	struct $N5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT10FBARRAY1$2I9FBUSTRINGEE {
		FBUSTRING* DATA;
		FBUSTRING* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT10FBARRAY1$2I9FBUSTRINGEE ) == 72 );
	struct $N5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT10FBARRAY1$2I9FBUSTRINGEE tmp$636$1;
	*(FBUSTRING**)&tmp$636$1 = (FBUSTRING*)UCASES$1;
	*(FBUSTRING**)((uint8*)&tmp$636$1 + 8ll) = (FBUSTRING*)UCASES$1;
	*(int64*)((uint8*)&tmp$636$1 + 16ll) = 168ll;
	*(int64*)((uint8*)&tmp$636$1 + 24ll) = 24ll;
	*(int64*)((uint8*)&tmp$636$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$636$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$636$1 + 48ll) = 7ll;
	*(int64*)((uint8*)&tmp$636$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$636$1 + 64ll) = 6ll;
	fb_UStrAssign( (void*)UCASES$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
	fb_UStrAssign( (void*)((int64)(FBUSTRING*)UCASES$1 + 24ll), -1ll, (void*)(uint16[]){0x0061,0x0000}, -9223372036854775807ll, 0 );
	fb_UStrAssign( (void*)((int64)(FBUSTRING*)UCASES$1 + 48ll), -1ll, (void*)(uint16[]){0x0061,0x002C,0x0062,0x0000}, -9223372036854775805ll, 0 );
	fb_UStrAssign( (void*)((int64)(FBUSTRING*)UCASES$1 + 72ll), -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	fb_UStrAssign( (void*)((int64)(FBUSTRING*)UCASES$1 + 96ll), -1ll, (void*)(uint16[]){0x002C,0x002C,0x0000}, -9223372036854775806ll, 0 );
	fb_UStrAssign( (void*)((int64)(FBUSTRING*)UCASES$1 + 120ll), -1ll, (void*)(uint16[]){0x0061,0x002C,0x002C,0x0062,0x002C,0x0000}, -9223372036854775803ll, 0 );
	fb_UStrAssign( (void*)((int64)(FBUSTRING*)UCASES$1 + 144ll), -1ll, (void*)(uint16[]){0x0063,0x0061,0x0066,0x00E9,0x002C,0x0078,0x0000}, -9223372036854775802ll, 0 );
	{
		int64 I$2;
		I$2 = 0ll;
		label$555:;
		{
			FBUSTRING TMP$644$3;
			FBUSTRING TMP$645$3;
			FBUSTRING TMP$650$3;
			struct $5ArrayI9FBUSTRINGE PARTS$3;
			__builtin_memset( &TMP$644$3, 0, 24ll );
			fb_UStrAssign( (void*)&TMP$644$3, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
			_ZN2FB5SPLITERK9FBUSTRINGS2_b( &PARTS$3, (FBUSTRING*)((int64)(FBUSTRING*)UCASES$1 + (I$2 * 24ll)), (FBUSTRING*)&TMP$644$3, (boolean)0ll );
			fb_UStrDelete( (FBUSTRING*)&TMP$644$3 );
			__builtin_memset( &TMP$645$3, 0, 24ll );
			fb_UStrAssign( (void*)&TMP$645$3, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
			FBUSTRING* vr$23 = _ZN2FB4JOINER5ArrayI9FBUSTRINGERKS1_( &PARTS$3, (FBUSTRING*)&TMP$645$3 );
			int32 vr$24 = fb_UStrCompare( (void*)vr$23, -1ll, (void*)((int64)(FBUSTRING*)UCASES$1 + (I$2 * 24ll)), -1ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$24 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 302, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_ROUNDTRIP_USTRING", (char*)"CU_ASSERT_EQUAL(Join( parts, \x22,\x22 ),ucases( i ))" );
			fb_UStrDelete( (FBUSTRING*)&TMP$645$3 );
			int32 vr$30 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( &PARTS$3 );
			__builtin_memset( &TMP$650$3, 0, 24ll );
			fb_UStrAssign( (void*)&TMP$650$3, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
			int64 vr$37 = fb_UStrTally( (FBUSTRING*)((int64)(FBUSTRING*)UCASES$1 + (I$2 * 24ll)), (FBUSTRING*)&TMP$650$3, (boolean)0ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$30 == (vr$37 + 1ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 303, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_ROUNDTRIP_USTRING", (char*)"CU_ASSERT_EQUAL(parts.Count( ),Tally( ucases( i ), \x22,\x22 ) + 1)" );
			fb_UStrDelete( (FBUSTRING*)&TMP$650$3 );
			_ZN5ArrayI9FBUSTRINGED1Ev( &PARTS$3 );
		}
		label$553:;
		I$2 = I$2 + 1ll;
		label$552:;
		if( I$2 <= 6ll) goto label$555;
		label$554:;
	}
	fb_ArrayDestructUStr( (struct $7FBARRAYIvE*)&tmp$636$1 );
	label$551:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT28SPLIT_RESULT_IS_A_REAL_ARRAYEv( void )
{
	FBSTRING TMP$657$1;
	FBUSTRING TMP$658$1;
	FBSTRING TMP$677$1;
	FBUSTRING TMP$678$1;
	label$558:;
	struct $5ArrayI8FBSTRINGE A$1;
	__builtin_memset( &TMP$658$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$658$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$657$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$657$1, -1ll, (void*)"one,two,three", 14ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &A$1, (FBSTRING*)&TMP$657$1, (FBUSTRING*)&TMP$658$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$658$1 );
	fb_StrDelete( (FBSTRING*)&TMP$657$1 );
	int64 N$1;
	N$1 = 0ll;
	int64 CHARS$1;
	CHARS$1 = 0ll;
	{
		struct $13ArrayIteratorI8FBSTRINGE TMP$659$2;
		struct $13ArrayIteratorI8FBSTRINGE vr$10 = _ZN5ArrayI8FBSTRINGE11GETITERATOREv( &A$1 );
		TMP$659$2 = vr$10;
		goto label$560;
		label$563:;
		{
			FBSTRING P$3;
			FBSTRING* vr$12 = _ZN13ArrayIteratorI8FBSTRINGE5VALUEEv( &TMP$659$2 );
			fb_StrInit( (void*)&P$3, -1ll, (void*)vr$12, -1ll, 0 );
			N$1 = N$1 + 1ll;
			int64 vr$16 = fb_StrLen( (void*)&P$3, -1ll );
			CHARS$1 = CHARS$1 + vr$16;
			fb_StrDelete( (FBSTRING*)&P$3 );
		}
		label$561:;
		_ZN13ArrayIteratorI8FBSTRINGE8MOVENEXTEv( &TMP$659$2 );
		label$560:;
		boolean vr$21 = _ZN13ArrayIteratorI8FBSTRINGE7ISVALIDEv( &TMP$659$2 );
		if( (int64)-vr$21 != 0ll) goto label$563;
		label$562:;
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(N$1 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 321, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_RESULT_IS_A_REAL_ARRAY", (char*)"CU_ASSERT_EQUAL(n,3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(CHARS$1 == 11ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 322, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_RESULT_IS_A_REAL_ARRAY", (char*)"CU_ASSERT_EQUAL(chars,11)" );
	FBSTRING* vr$28 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 0 );
	fb_StrAssign( (void*)vr$28, -1ll, (void*)"CHANGED", 8ll, 0 );
	FBSTRING* vr$30 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 0 );
	int32 vr$31 = fb_StrCompare( (void*)vr$30, -1ll, (void*)"CHANGED", 8ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$31 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 326, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_RESULT_IS_A_REAL_ARRAY", (char*)"CU_ASSERT_EQUAL(a[0],\x22" "CHANGED\x22)" );
	struct $5ArrayI8FBSTRINGE B$1;
	__builtin_memset( &TMP$678$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$678$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	__builtin_memset( &TMP$677$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$677$1, -1ll, (void*)"one,two,three", 14ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &B$1, (FBSTRING*)&TMP$677$1, (FBUSTRING*)&TMP$678$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$678$1 );
	fb_StrDelete( (FBSTRING*)&TMP$677$1 );
	FBSTRING* vr$45 = _ZN5ArrayI8FBSTRINGEixEi( &B$1, 0 );
	int32 vr$46 = fb_StrCompare( (void*)vr$45, -1ll, (void*)"one", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$46 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 328, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_RESULT_IS_A_REAL_ARRAY", (char*)"CU_ASSERT_EQUAL(b[0],\x22one\x22)" );
	_ZN5ArrayI8FBSTRINGED1Ev( &B$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &A$1 );
	label$559:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT17SPLIT_MANY_FIELDSEv( void )
{
	FBUSTRING TMP$686$1;
	FBUSTRING TMP$695$1;
	FBUSTRING TMP$707$1;
	FBSTRING TMP$714$1;
	FBUSTRING TMP$716$1;
	FBUSTRING TMP$720$1;
	label$566:;
	FBSTRING SRC$1;
	fb_StrInit( (void*)&SRC$1, -1ll, (void*)"", 1ll, 0 );
	{
		int64 I$2;
		I$2 = 1ll;
		label$571:;
		{
			if( I$2 <= 1ll) goto label$573;
			{
				fb_StrConcatAssign( (void*)&SRC$1, -1ll, (void*)",", 2ll, 0 );
				label$573:;
			}
			fb_StrConcatAssign( (void*)&SRC$1, -1ll, (void*)"f", 2ll, 0 );
		}
		label$569:;
		I$2 = I$2 + 1ll;
		label$568:;
		if( I$2 <= 2000ll) goto label$571;
		label$570:;
	}
	__builtin_memset( &TMP$686$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$686$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	int64 vr$8 = fb_StrTally( (FBSTRING*)&SRC$1, (FBUSTRING*)&TMP$686$1, (boolean)0ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$8 == 1999ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 339, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_MANY_FIELDS", (char*)"CU_ASSERT_EQUAL(Tally( src, \x22,\x22 ),1999)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$686$1 );
	struct $5ArrayI8FBSTRINGE A$1;
	__builtin_memset( &TMP$695$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$695$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &A$1, (FBSTRING*)&SRC$1, (FBUSTRING*)&TMP$695$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$695$1 );
	int32 vr$19 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &A$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$19 == 2000ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 342, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_MANY_FIELDS", (char*)"CU_ASSERT_EQUAL(a.Count( ),2000)" );
	FBSTRING* vr$24 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 0 );
	int32 vr$25 = fb_StrCompare( (void*)vr$24, -1ll, (void*)"f", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$25 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 343, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_MANY_FIELDS", (char*)"CU_ASSERT_EQUAL(a[0],\x22" "f\x22)" );
	FBSTRING* vr$30 = _ZN5ArrayI8FBSTRINGEixEi( &A$1, 1999 );
	int32 vr$31 = fb_StrCompare( (void*)vr$30, -1ll, (void*)"f", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$31 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 344, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_MANY_FIELDS", (char*)"CU_ASSERT_EQUAL(a[1999],\x22" "f\x22)" );
	__builtin_memset( &TMP$707$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$707$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBSTRING* vr$40 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &A$1, (FBUSTRING*)&TMP$707$1 );
	int32 vr$41 = fb_StrCompare( (void*)vr$40, -1ll, (void*)&SRC$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$41 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 345, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_MANY_FIELDS", (char*)"CU_ASSERT_EQUAL(Join( a, \x22,\x22 ),src)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$707$1 );
	FBSTRING COMMAS$1;
	__builtin_memset( &TMP$714$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$714$1, -1ll, (void*)",", 2ll, 0 );
	FBSTRING* vr$49 = fb_StrRepeat( 2000ll, (FBSTRING*)&TMP$714$1 );
	fb_StrInit( (void*)&COMMAS$1, -1ll, (void*)vr$49, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&TMP$714$1 );
	struct $5ArrayI8FBSTRINGE B$1;
	__builtin_memset( &TMP$716$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$716$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	_ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( &B$1, (FBSTRING*)&COMMAS$1, (FBUSTRING*)&TMP$716$1, (boolean)0ll );
	fb_UStrDelete( (FBUSTRING*)&TMP$716$1 );
	int32 vr$59 = _ZN5ArrayI8FBSTRINGE5COUNTEv( &B$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$59 == 2001ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 350, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_MANY_FIELDS", (char*)"CU_ASSERT_EQUAL(b.Count( ),2001)" );
	__builtin_memset( &TMP$720$1, 0, 24ll );
	fb_UStrAssign( (void*)&TMP$720$1, -1ll, (void*)(uint16[]){0x002C,0x0000}, -9223372036854775807ll, 0 );
	FBSTRING* vr$68 = _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( &B$1, (FBUSTRING*)&TMP$720$1 );
	int32 vr$69 = fb_StrCompare( (void*)vr$68, -1ll, (void*)&COMMAS$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$69 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 351, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_MANY_FIELDS", (char*)"CU_ASSERT_EQUAL(Join( b, \x22,\x22 ),commas)" );
	fb_UStrDelete( (FBUSTRING*)&TMP$720$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &B$1 );
	fb_StrDelete( (FBSTRING*)&COMMAS$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &A$1 );
	fb_StrDelete( (FBSTRING*)&SRC$1 );
	label$567:;
}

void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT39SPLIT_BODIES_ARE_PRIVATE_ACROSS_MODULESEv( void )
{
	FBSTRING TMP$730$1;
	FBSTRING TMP$737$1;
	label$576:;
	__builtin_memset( &TMP$730$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$730$1, -1ll, (void*)"a,b,c,d", 8ll, 0 );
	int64 vr$3 = SPLITINOTHERMODULE( (FBSTRING*)&TMP$730$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$3 == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 357, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_BODIES_ARE_PRIVATE_ACROSS_MODULES", (char*)"CU_ASSERT_EQUAL(SplitInOtherModule( \x22" "a,b,c,d\x22 ),4)" );
	fb_StrDelete( (FBSTRING*)&TMP$730$1 );
	__builtin_memset( &TMP$737$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$737$1, -1ll, (void*)"", 1ll, 0 );
	int64 vr$10 = SPLITINOTHERMODULE( (FBSTRING*)&TMP$737$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$10 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstring\x5C" "fbstr_split.bas", 358, (char*)"TESTS.FBC_TESTS.STRING_.FBSTR_SPLIT.SPLIT_BODIES_ARE_PRIVATE_ACROSS_MODULES", (char*)"CU_ASSERT_EQUAL(SplitInOtherModule( \x22\x22 ),1)" );
	fb_StrDelete( (FBSTRING*)&TMP$737$1 );
	label$577:;
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
	label$2:;
	label$3:;
}

static void _ZN5ArrayI8FBSTRINGEaSERKS1_( struct $5ArrayI8FBSTRINGE* THIS$1, struct $5ArrayI8FBSTRINGE* __FB_RHS__$1 )
{
	FBSTRING* TMP$9$1;
	FBSTRING* TMP$10$1;
	FBSTRING* TMP$11$1;
	label$4:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, -1, (void*)0ull, (void*)0ull );
	TMP$9$1 = *(FBSTRING**)((uint8*)THIS$1 + 8ll);
	TMP$10$1 = *(FBSTRING**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$11$1 = (FBSTRING*)((uint8*)TMP$10$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$6:;
	if( TMP$10$1 >= TMP$11$1) goto label$7;
	fb_StrAssign( (void*)TMP$9$1, -1ll, (void*)TMP$10$1, -1ll, 0 );
	TMP$9$1 = (FBSTRING*)((uint8*)TMP$9$1 + 24ll);
	TMP$10$1 = (FBSTRING*)((uint8*)TMP$10$1 + 24ll);
	goto label$6;
	label$7:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$5:;
}

static void _ZN5ArrayI8FBSTRINGEC1ERKS1_( struct $5ArrayI8FBSTRINGE* THIS$1, struct $5ArrayI8FBSTRINGE* __FB_RHS__$1 )
{
	label$8:;
	*(FBSTRING**)THIS$1 = (FBSTRING*)0ull;
	*(FBSTRING**)((uint8*)THIS$1 + 8ll) = (FBSTRING*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 24ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	_ZN5ArrayI8FBSTRINGEaSERKS1_( THIS$1, __FB_RHS__$1 );
	label$9:;
}

static void _ZN5ArrayI8FBSTRINGED1Ev( struct $5ArrayI8FBSTRINGE* THIS$1 )
{
	label$10:;
	label$11:;
	fb_ArrayStrErase( (struct $7FBARRAYIvE*)THIS$1 );
}

static struct $5ArrayI8FBSTRINGE* _ZN2FB5SPLITERK8FBSTRINGRK9FBUSTRINGb( struct $5ArrayI8FBSTRINGE* tmp$12$1, FBSTRING* S$1, FBUSTRING* DELIM$1, boolean IGNORECASE$1 )
{
	label$12:;
	struct $5ArrayI8FBSTRINGE RES$1;
	_ZN5ArrayI8FBSTRINGEC1Ev( &RES$1 );
	int64 N$1;
	int64 vr$1 = fb_StrSplitSpans( S$1, DELIM$1, IGNORECASE$1, (int64*)0ull, 0ll );
	N$1 = vr$1;
	if( N$1 > 0ll) goto label$15;
	{
		_ZN5ArrayI8FBSTRINGEC1ERKS1_( tmp$12$1, (struct $5ArrayI8FBSTRINGE*)&RES$1 );
		_ZN5ArrayI8FBSTRINGED1Ev( &RES$1 );
		goto label$13;
		label$15:;
	}
	struct $N2FB10FBARRAY1$3Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N2FB10FBARRAY1$3Iu7INTEGEREE ) == 72 );
	struct $N2FB10FBARRAY1$3Iu7INTEGEREE SPANS$1;
	*(int64**)&SPANS$1 = (int64*)0ull;
	*(int64**)((uint8*)&SPANS$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&SPANS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&SPANS$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&SPANS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&SPANS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&SPANS$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&SPANS$1, 8ull, -1, 0, 1ull, 0ll, (N$1 << (1ll & 63ll)) + -1ll );
	fb_StrSplitSpans( S$1, DELIM$1, IGNORECASE$1, (int64*)*(int64*)&SPANS$1, N$1 );
	_ZN5ArrayI8FBSTRINGE7RESERVEEi( &RES$1, (int32)N$1 );
	{
		int64 I$2;
		I$2 = 0ll;
		int64 TMP$13$2;
		TMP$13$2 = N$1 + -1ll;
		goto label$16;
		label$19:;
		{
			FBSTRING PIECE$3;
			FBSTRING* vr$17 = fb_StrMid( S$1, *(int64*)((I$2 << (4ll & 63ll)) + *(int64*)&SPANS$1) + 1ll, *(int64*)((uint8*)((I$2 << (4ll & 63ll)) + *(int64*)&SPANS$1) + 8ll) );
			fb_StrInit( (void*)&PIECE$3, -1ll, (void*)vr$17, -1ll, 0 );
			_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &RES$1, &PIECE$3 );
			fb_StrDelete( (FBSTRING*)&PIECE$3 );
		}
		label$17:;
		I$2 = I$2 + 1ll;
		label$16:;
		if( I$2 <= TMP$13$2) goto label$19;
		label$18:;
	}
	_ZN5ArrayI8FBSTRINGEC1ERKS1_( tmp$12$1, (struct $5ArrayI8FBSTRINGE*)&RES$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&SPANS$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &RES$1 );
	goto label$13;
	fb_ArrayErase( (struct $7FBARRAYIvE*)&SPANS$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &RES$1 );
	label$13:;
	return tmp$12$1;
}

static void _ZN5ArrayI9FBUSTRINGEC1Ev( struct $5ArrayI9FBUSTRINGE* THIS$1 )
{
	*(FBUSTRING**)THIS$1 = (FBUSTRING*)0ull;
	*(FBUSTRING**)((uint8*)THIS$1 + 8ll) = (FBUSTRING*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 24ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$20:;
	label$21:;
}

static void _ZN5ArrayI9FBUSTRINGEaSERKS1_( struct $5ArrayI9FBUSTRINGE* THIS$1, struct $5ArrayI9FBUSTRINGE* __FB_RHS__$1 )
{
	FBUSTRING* TMP$14$1;
	FBUSTRING* TMP$15$1;
	FBUSTRING* TMP$16$1;
	label$22:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)0ull, (void*)0ull );
	TMP$14$1 = *(FBUSTRING**)((uint8*)THIS$1 + 8ll);
	TMP$15$1 = *(FBUSTRING**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$16$1 = (FBUSTRING*)((uint8*)TMP$15$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$24:;
	if( TMP$15$1 >= TMP$16$1) goto label$25;
	fb_UStrAssign( (void*)TMP$14$1, -1ll, (void*)TMP$15$1, -1ll, 0 );
	TMP$14$1 = (FBUSTRING*)((uint8*)TMP$14$1 + 24ll);
	TMP$15$1 = (FBUSTRING*)((uint8*)TMP$15$1 + 24ll);
	goto label$24;
	label$25:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$23:;
}

static void _ZN5ArrayI9FBUSTRINGEC1ERKS1_( struct $5ArrayI9FBUSTRINGE* THIS$1, struct $5ArrayI9FBUSTRINGE* __FB_RHS__$1 )
{
	label$26:;
	*(FBUSTRING**)THIS$1 = (FBUSTRING*)0ull;
	*(FBUSTRING**)((uint8*)THIS$1 + 8ll) = (FBUSTRING*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 24ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	_ZN5ArrayI9FBUSTRINGEaSERKS1_( THIS$1, __FB_RHS__$1 );
	label$27:;
}

static void _ZN5ArrayI9FBUSTRINGED1Ev( struct $5ArrayI9FBUSTRINGE* THIS$1 )
{
	label$28:;
	label$29:;
	fb_ArrayUStrErase( (struct $7FBARRAYIvE*)THIS$1 );
}

static struct $5ArrayI9FBUSTRINGE* _ZN2FB5SPLITERK9FBUSTRINGS2_b( struct $5ArrayI9FBUSTRINGE* tmp$17$1, FBUSTRING* S$1, FBUSTRING* DELIM$1, boolean IGNORECASE$1 )
{
	label$30:;
	struct $5ArrayI9FBUSTRINGE RES$1;
	_ZN5ArrayI9FBUSTRINGEC1Ev( &RES$1 );
	int64 N$1;
	int64 vr$1 = fb_UStrSplitSpans( S$1, DELIM$1, IGNORECASE$1, (int64*)0ull, 0ll );
	N$1 = vr$1;
	if( N$1 > 0ll) goto label$33;
	{
		_ZN5ArrayI9FBUSTRINGEC1ERKS1_( tmp$17$1, (struct $5ArrayI9FBUSTRINGE*)&RES$1 );
		_ZN5ArrayI9FBUSTRINGED1Ev( &RES$1 );
		goto label$31;
		label$33:;
	}
	struct $N2FB10FBARRAY1$4Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N2FB10FBARRAY1$4Iu7INTEGEREE ) == 72 );
	struct $N2FB10FBARRAY1$4Iu7INTEGEREE SPANS$1;
	*(int64**)&SPANS$1 = (int64*)0ull;
	*(int64**)((uint8*)&SPANS$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&SPANS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&SPANS$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&SPANS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&SPANS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&SPANS$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&SPANS$1, 8ull, -1, 0, 1ull, 0ll, (N$1 << (1ll & 63ll)) + -1ll );
	fb_UStrSplitSpans( S$1, DELIM$1, IGNORECASE$1, (int64*)*(int64*)&SPANS$1, N$1 );
	_ZN5ArrayI9FBUSTRINGE7RESERVEEi( &RES$1, (int32)N$1 );
	{
		int64 I$2;
		I$2 = 0ll;
		int64 TMP$18$2;
		TMP$18$2 = N$1 + -1ll;
		goto label$34;
		label$37:;
		{
			FBUSTRING PIECE$3;
			FBUSTRING* vr$17 = fb_UStrMid( (void*)S$1, -1ll, *(int64*)((I$2 << (4ll & 63ll)) + *(int64*)&SPANS$1) + 1ll, *(int64*)((uint8*)((I$2 << (4ll & 63ll)) + *(int64*)&SPANS$1) + 8ll) );
			fb_UStrInit( (void*)&PIECE$3, -1ll, (void*)vr$17, -1ll, 0 );
			_ZN5ArrayI9FBUSTRINGE4PUSHERS0_( &RES$1, &PIECE$3 );
			fb_UStrDelete( (FBUSTRING*)&PIECE$3 );
		}
		label$35:;
		I$2 = I$2 + 1ll;
		label$34:;
		if( I$2 <= TMP$18$2) goto label$37;
		label$36:;
	}
	_ZN5ArrayI9FBUSTRINGEC1ERKS1_( tmp$17$1, (struct $5ArrayI9FBUSTRINGE*)&RES$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&SPANS$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &RES$1 );
	goto label$31;
	fb_ArrayErase( (struct $7FBARRAYIvE*)&SPANS$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &RES$1 );
	label$31:;
	return tmp$17$1;
}

static struct $5ArrayI9FBUSTRINGE* _ZN2FB5SPLITERKwRK9FBUSTRINGb( struct $5ArrayI9FBUSTRINGE* tmp$19$1, uint16* S$1, FBUSTRING* DELIM$1, boolean IGNORECASE$1 )
{
	struct $5ArrayI9FBUSTRINGE TMP$20$1;
	label$38:;
	FBUSTRING TMP$1;
	FBUSTRING* vr$0 = fb_WstrToUStr( S$1 );
	fb_UStrInit( (void*)&TMP$1, -1ll, (void*)vr$0, -1ll, 0 );
	struct $5ArrayI9FBUSTRINGE* vr$4 = _ZN2FB5SPLITERK9FBUSTRINGS2_b( &TMP$20$1, (FBUSTRING*)&TMP$1, DELIM$1, IGNORECASE$1 );
	_ZN5ArrayI9FBUSTRINGEC1ERKS1_( tmp$19$1, (struct $5ArrayI9FBUSTRINGE*)vr$4 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &TMP$20$1 );
	fb_UStrDelete( (FBUSTRING*)&TMP$1 );
	goto label$39;
	fb_UStrDelete( (FBUSTRING*)&TMP$1 );
	label$39:;
	return tmp$19$1;
}

static struct $5ArrayI8FBSTRINGE* _ZN2FB10SPLITCHARSERK8FBSTRINGRK9FBUSTRINGb( struct $5ArrayI8FBSTRINGE* tmp$21$1, FBSTRING* S$1, FBUSTRING* CHARS$1, boolean IGNORECASE$1 )
{
	label$40:;
	struct $5ArrayI8FBSTRINGE RES$1;
	_ZN5ArrayI8FBSTRINGEC1Ev( &RES$1 );
	int64 N$1;
	int64 vr$1 = fb_StrSplitCharsSpans( S$1, CHARS$1, IGNORECASE$1, (int64*)0ull, 0ll );
	N$1 = vr$1;
	if( N$1 > 0ll) goto label$43;
	{
		_ZN5ArrayI8FBSTRINGEC1ERKS1_( tmp$21$1, (struct $5ArrayI8FBSTRINGE*)&RES$1 );
		_ZN5ArrayI8FBSTRINGED1Ev( &RES$1 );
		goto label$41;
		label$43:;
	}
	struct $N2FB10FBARRAY1$5Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N2FB10FBARRAY1$5Iu7INTEGEREE ) == 72 );
	struct $N2FB10FBARRAY1$5Iu7INTEGEREE SPANS$1;
	*(int64**)&SPANS$1 = (int64*)0ull;
	*(int64**)((uint8*)&SPANS$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&SPANS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&SPANS$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&SPANS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&SPANS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&SPANS$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&SPANS$1, 8ull, -1, 0, 1ull, 0ll, (N$1 << (1ll & 63ll)) + -1ll );
	fb_StrSplitCharsSpans( S$1, CHARS$1, IGNORECASE$1, (int64*)*(int64*)&SPANS$1, N$1 );
	_ZN5ArrayI8FBSTRINGE7RESERVEEi( &RES$1, (int32)N$1 );
	{
		int64 I$2;
		I$2 = 0ll;
		int64 TMP$22$2;
		TMP$22$2 = N$1 + -1ll;
		goto label$44;
		label$47:;
		{
			FBSTRING PIECE$3;
			FBSTRING* vr$17 = fb_StrMid( S$1, *(int64*)((I$2 << (4ll & 63ll)) + *(int64*)&SPANS$1) + 1ll, *(int64*)((uint8*)((I$2 << (4ll & 63ll)) + *(int64*)&SPANS$1) + 8ll) );
			fb_StrInit( (void*)&PIECE$3, -1ll, (void*)vr$17, -1ll, 0 );
			_ZN5ArrayI8FBSTRINGE4PUSHERS0_( &RES$1, &PIECE$3 );
			fb_StrDelete( (FBSTRING*)&PIECE$3 );
		}
		label$45:;
		I$2 = I$2 + 1ll;
		label$44:;
		if( I$2 <= TMP$22$2) goto label$47;
		label$46:;
	}
	_ZN5ArrayI8FBSTRINGEC1ERKS1_( tmp$21$1, (struct $5ArrayI8FBSTRINGE*)&RES$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&SPANS$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &RES$1 );
	goto label$41;
	fb_ArrayErase( (struct $7FBARRAYIvE*)&SPANS$1 );
	_ZN5ArrayI8FBSTRINGED1Ev( &RES$1 );
	label$41:;
	return tmp$21$1;
}

static struct $5ArrayI9FBUSTRINGE* _ZN2FB10SPLITCHARSERK9FBUSTRINGS2_b( struct $5ArrayI9FBUSTRINGE* tmp$23$1, FBUSTRING* S$1, FBUSTRING* CHARS$1, boolean IGNORECASE$1 )
{
	label$48:;
	struct $5ArrayI9FBUSTRINGE RES$1;
	_ZN5ArrayI9FBUSTRINGEC1Ev( &RES$1 );
	int64 N$1;
	int64 vr$1 = fb_UStrSplitCharsSpans( S$1, CHARS$1, IGNORECASE$1, (int64*)0ull, 0ll );
	N$1 = vr$1;
	if( N$1 > 0ll) goto label$51;
	{
		_ZN5ArrayI9FBUSTRINGEC1ERKS1_( tmp$23$1, (struct $5ArrayI9FBUSTRINGE*)&RES$1 );
		_ZN5ArrayI9FBUSTRINGED1Ev( &RES$1 );
		goto label$49;
		label$51:;
	}
	struct $N2FB10FBARRAY1$6Iu7INTEGEREE {
		int64* DATA;
		int64* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N2FB10FBARRAY1$6Iu7INTEGEREE ) == 72 );
	struct $N2FB10FBARRAY1$6Iu7INTEGEREE SPANS$1;
	*(int64**)&SPANS$1 = (int64*)0ull;
	*(int64**)((uint8*)&SPANS$1 + 8ll) = (int64*)0ull;
	*(int64*)((uint8*)&SPANS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)&SPANS$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&SPANS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&SPANS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)&SPANS$1 + 48ll), 0, 24ll );
	fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&SPANS$1, 8ull, -1, 0, 1ull, 0ll, (N$1 << (1ll & 63ll)) + -1ll );
	fb_UStrSplitCharsSpans( S$1, CHARS$1, IGNORECASE$1, (int64*)*(int64*)&SPANS$1, N$1 );
	_ZN5ArrayI9FBUSTRINGE7RESERVEEi( &RES$1, (int32)N$1 );
	{
		int64 I$2;
		I$2 = 0ll;
		int64 TMP$24$2;
		TMP$24$2 = N$1 + -1ll;
		goto label$52;
		label$55:;
		{
			FBUSTRING PIECE$3;
			FBUSTRING* vr$17 = fb_UStrMid( (void*)S$1, -1ll, *(int64*)((I$2 << (4ll & 63ll)) + *(int64*)&SPANS$1) + 1ll, *(int64*)((uint8*)((I$2 << (4ll & 63ll)) + *(int64*)&SPANS$1) + 8ll) );
			fb_UStrInit( (void*)&PIECE$3, -1ll, (void*)vr$17, -1ll, 0 );
			_ZN5ArrayI9FBUSTRINGE4PUSHERS0_( &RES$1, &PIECE$3 );
			fb_UStrDelete( (FBUSTRING*)&PIECE$3 );
		}
		label$53:;
		I$2 = I$2 + 1ll;
		label$52:;
		if( I$2 <= TMP$24$2) goto label$55;
		label$54:;
	}
	_ZN5ArrayI9FBUSTRINGEC1ERKS1_( tmp$23$1, (struct $5ArrayI9FBUSTRINGE*)&RES$1 );
	fb_ArrayErase( (struct $7FBARRAYIvE*)&SPANS$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &RES$1 );
	goto label$49;
	fb_ArrayErase( (struct $7FBARRAYIvE*)&SPANS$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &RES$1 );
	label$49:;
	return tmp$23$1;
}

static struct $5ArrayI9FBUSTRINGE* _ZN2FB10SPLITCHARSERKwRK9FBUSTRINGb( struct $5ArrayI9FBUSTRINGE* tmp$25$1, uint16* S$1, FBUSTRING* CHARS$1, boolean IGNORECASE$1 )
{
	struct $5ArrayI9FBUSTRINGE TMP$26$1;
	label$56:;
	FBUSTRING TMP$1;
	FBUSTRING* vr$0 = fb_WstrToUStr( S$1 );
	fb_UStrInit( (void*)&TMP$1, -1ll, (void*)vr$0, -1ll, 0 );
	struct $5ArrayI9FBUSTRINGE* vr$4 = _ZN2FB10SPLITCHARSERK9FBUSTRINGS2_b( &TMP$26$1, (FBUSTRING*)&TMP$1, CHARS$1, IGNORECASE$1 );
	_ZN5ArrayI9FBUSTRINGEC1ERKS1_( tmp$25$1, (struct $5ArrayI9FBUSTRINGE*)vr$4 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &TMP$26$1 );
	fb_UStrDelete( (FBUSTRING*)&TMP$1 );
	goto label$57;
	fb_UStrDelete( (FBUSTRING*)&TMP$1 );
	label$57:;
	return tmp$25$1;
}

static FBSTRING* _ZN2FB4JOINER5ArrayI8FBSTRINGERK9FBUSTRING( struct $5ArrayI8FBSTRINGE* PARTS$1, FBUSTRING* DELIM$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$58:;
	int64 N$1;
	int32 vr$1 = _ZN5ArrayI8FBSTRINGE5COUNTEv( PARTS$1 );
	N$1 = (int64)vr$1;
	if( N$1 > 0ll) goto label$61;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$59;
		label$61:;
	}
	FBSTRING D$1;
	fb_UStrAssignToA( (void*)&D$1, -1ll, (void*)DELIM$1, -1ll, 0, -1 );
	int64 TOTAL$1;
	int64 vr$7 = fb_StrLen( (void*)&D$1, -1ll );
	TOTAL$1 = (N$1 + -1ll) * vr$7;
	{
		int64 I$2;
		I$2 = 0ll;
		int64 TMP$27$2;
		TMP$27$2 = N$1 + -1ll;
		goto label$62;
		label$65:;
		{
			FBSTRING* vr$11 = _ZN5ArrayI8FBSTRINGEixEi( PARTS$1, (int32)I$2 );
			int64 vr$12 = fb_StrLen( (void*)vr$11, -1ll );
			TOTAL$1 = TOTAL$1 + vr$12;
		}
		label$63:;
		I$2 = I$2 + 1ll;
		label$62:;
		if( I$2 <= TMP$27$2) goto label$65;
		label$64:;
	}
	if( TOTAL$1 > 0ll) goto label$67;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		fb_StrDelete( (FBSTRING*)&D$1 );
		goto label$59;
		label$67:;
	}
	FBSTRING RES$1;
	FBSTRING* vr$17 = fb_SPACE( TOTAL$1 );
	fb_StrInit( (void*)&RES$1, -1ll, (void*)vr$17, -1ll, 0 );
	int64 AT$1;
	AT$1 = 1ll;
	{
		int64 I$2;
		I$2 = 0ll;
		int64 TMP$28$2;
		TMP$28$2 = N$1 + -1ll;
		goto label$68;
		label$71:;
		{
			int64 TMP$29$3;
			if( I$2 <= 0ll) goto label$72;
			int64 vr$21 = fb_StrLen( (void*)&D$1, -1ll );
			TMP$29$3 = (int64)-(vr$21 > 0ll);
			goto label$582;
			label$72:;
			TMP$29$3 = 0ll;
			label$582:;
			if( TMP$29$3 == 0ll) goto label$74;
			{
				int64 vr$25 = fb_StrLen( (void*)&D$1, -1ll );
				fb_StrAssignMid( &RES$1, AT$1, vr$25, (FBSTRING*)&D$1 );
				int64 vr$28 = fb_StrLen( (void*)&D$1, -1ll );
				AT$1 = AT$1 + vr$28;
			}
			label$74:;
			label$73:;
			int64 PL$3;
			FBSTRING* vr$31 = _ZN5ArrayI8FBSTRINGEixEi( PARTS$1, (int32)I$2 );
			int64 vr$32 = fb_StrLen( (void*)vr$31, -1ll );
			PL$3 = vr$32;
			if( PL$3 <= 0ll) goto label$76;
			{
				FBSTRING* vr$34 = _ZN5ArrayI8FBSTRINGEixEi( PARTS$1, (int32)I$2 );
				fb_StrAssignMid( &RES$1, AT$1, PL$3, (FBSTRING*)vr$34 );
				AT$1 = AT$1 + PL$3;
			}
			label$76:;
			label$75:;
		}
		label$69:;
		I$2 = I$2 + 1ll;
		label$68:;
		if( I$2 <= TMP$28$2) goto label$71;
		label$70:;
	}
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&RES$1, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&RES$1 );
	fb_StrDelete( (FBSTRING*)&D$1 );
	goto label$59;
	fb_StrDelete( (FBSTRING*)&RES$1 );
	fb_StrDelete( (FBSTRING*)&D$1 );
	label$59:;
	FBSTRING* vr$45 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$45;
}

static FBUSTRING* _ZN2FB4JOINER5ArrayI9FBUSTRINGERKS1_( struct $5ArrayI9FBUSTRINGE* PARTS$1, FBUSTRING* DELIM$1 )
{
	FBUSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$77:;
	int64 N$1;
	int32 vr$1 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( PARTS$1 );
	N$1 = (int64)vr$1;
	if( N$1 > 0ll) goto label$80;
	{
		fb_UStrInit( (void*)&fb$result$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
		goto label$78;
		label$80:;
	}
	int64 TOTAL$1;
	int64 vr$5 = fb_UStrLen( (void*)DELIM$1, -1ll );
	TOTAL$1 = (N$1 + -1ll) * vr$5;
	{
		int64 I$2;
		I$2 = 0ll;
		int64 TMP$31$2;
		TMP$31$2 = N$1 + -1ll;
		goto label$81;
		label$84:;
		{
			FBUSTRING* vr$9 = _ZN5ArrayI9FBUSTRINGEixEi( PARTS$1, (int32)I$2 );
			int64 vr$10 = fb_UStrLen( (void*)vr$9, -1ll );
			TOTAL$1 = TOTAL$1 + vr$10;
		}
		label$82:;
		I$2 = I$2 + 1ll;
		label$81:;
		if( I$2 <= TMP$31$2) goto label$84;
		label$83:;
	}
	if( TOTAL$1 > 0ll) goto label$86;
	{
		fb_UStrInit( (void*)&fb$result$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
		goto label$78;
		label$86:;
	}
	FBUSTRING ONE$1;
	fb_UStrInit( (void*)&ONE$1, -1ll, (void*)(uint16[]){0x0020,0x0000}, -9223372036854775807ll, 0 );
	FBUSTRING RES$1;
	FBUSTRING* vr$16 = fb_UStrRepeat( TOTAL$1, (FBUSTRING*)&ONE$1 );
	fb_UStrInit( (void*)&RES$1, -1ll, (void*)vr$16, -1ll, 0 );
	int64 AT$1;
	AT$1 = 1ll;
	{
		int64 I$2;
		I$2 = 0ll;
		int64 TMP$33$2;
		TMP$33$2 = N$1 + -1ll;
		goto label$87;
		label$90:;
		{
			int64 TMP$34$3;
			if( I$2 <= 0ll) goto label$91;
			int64 vr$19 = fb_UStrLen( (void*)DELIM$1, -1ll );
			TMP$34$3 = (int64)-(vr$19 > 0ll);
			goto label$583;
			label$91:;
			TMP$34$3 = 0ll;
			label$583:;
			if( TMP$34$3 == 0ll) goto label$93;
			{
				int64 vr$21 = fb_UStrLen( (void*)DELIM$1, -1ll );
				fb_UStrAssignMid( (void*)&RES$1, -1ll, AT$1, vr$21, (void*)DELIM$1, -1ll );
				int64 vr$23 = fb_UStrLen( (void*)DELIM$1, -1ll );
				AT$1 = AT$1 + vr$23;
			}
			label$93:;
			label$92:;
			int64 PL$3;
			FBUSTRING* vr$26 = _ZN5ArrayI9FBUSTRINGEixEi( PARTS$1, (int32)I$2 );
			int64 vr$27 = fb_UStrLen( (void*)vr$26, -1ll );
			PL$3 = vr$27;
			if( PL$3 <= 0ll) goto label$95;
			{
				FBUSTRING* vr$29 = _ZN5ArrayI9FBUSTRINGEixEi( PARTS$1, (int32)I$2 );
				fb_UStrAssignMid( (void*)&RES$1, -1ll, AT$1, PL$3, (void*)vr$29, -1ll );
				AT$1 = AT$1 + PL$3;
			}
			label$95:;
			label$94:;
		}
		label$88:;
		I$2 = I$2 + 1ll;
		label$87:;
		if( I$2 <= TMP$33$2) goto label$90;
		label$89:;
	}
	fb_UStrInit( (void*)&fb$result$1, -1ll, (void*)&RES$1, -1ll, 0 );
	fb_UStrDelete( (FBUSTRING*)&RES$1 );
	fb_UStrDelete( (FBUSTRING*)&ONE$1 );
	goto label$78;
	fb_UStrDelete( (FBUSTRING*)&RES$1 );
	fb_UStrDelete( (FBUSTRING*)&ONE$1 );
	label$78:;
	FBUSTRING* vr$40 = fb_UStrAllocTempResult( &fb$result$1 );
	return vr$40;
}

static void _ZN2FB6CSVROWC1Ev( struct $N2FB6CSVROWE* THIS$1 )
{
	_ZN5ArrayI8FBSTRINGEC1Ev( (struct $5ArrayI8FBSTRINGE*)THIS$1 );
	label$96:;
	label$97:;
}

static void _ZN2FB6CSVROWaSERKS0_( struct $N2FB6CSVROWE* THIS$1, struct $N2FB6CSVROWE* __FB_RHS__$1 )
{
	label$98:;
	_ZN5ArrayI8FBSTRINGEaSERKS1_( (struct $5ArrayI8FBSTRINGE*)THIS$1, (struct $5ArrayI8FBSTRINGE*)__FB_RHS__$1 );
	label$99:;
}

static void _ZN2FB6CSVROWC1ERKS0_( struct $N2FB6CSVROWE* THIS$1, struct $N2FB6CSVROWE* __FB_RHS__$1 )
{
	label$100:;
	_ZN5ArrayI8FBSTRINGEC1Ev( (struct $5ArrayI8FBSTRINGE*)THIS$1 );
	_ZN2FB6CSVROWaSERKS0_( THIS$1, __FB_RHS__$1 );
	label$101:;
}

static void _ZN2FB6CSVROWD1Ev( struct $N2FB6CSVROWE* THIS$1 )
{
	label$102:;
	label$103:;
	_ZN5ArrayI8FBSTRINGED1Ev( (struct $5ArrayI8FBSTRINGE*)THIS$1 );
}

static void _ZN2FB7CSVUROWC1Ev( struct $N2FB7CSVUROWE* THIS$1 )
{
	_ZN5ArrayI9FBUSTRINGEC1Ev( (struct $5ArrayI9FBUSTRINGE*)THIS$1 );
	label$104:;
	label$105:;
}

static void _ZN2FB7CSVUROWaSERKS0_( struct $N2FB7CSVUROWE* THIS$1, struct $N2FB7CSVUROWE* __FB_RHS__$1 )
{
	label$106:;
	_ZN5ArrayI9FBUSTRINGEaSERKS1_( (struct $5ArrayI9FBUSTRINGE*)THIS$1, (struct $5ArrayI9FBUSTRINGE*)__FB_RHS__$1 );
	label$107:;
}

static void _ZN2FB7CSVUROWC1ERKS0_( struct $N2FB7CSVUROWE* THIS$1, struct $N2FB7CSVUROWE* __FB_RHS__$1 )
{
	label$108:;
	_ZN5ArrayI9FBUSTRINGEC1Ev( (struct $5ArrayI9FBUSTRINGE*)THIS$1 );
	_ZN2FB7CSVUROWaSERKS0_( THIS$1, __FB_RHS__$1 );
	label$109:;
}

static void _ZN2FB7CSVUROWD1Ev( struct $N2FB7CSVUROWE* THIS$1 )
{
	label$110:;
	label$111:;
	_ZN5ArrayI9FBUSTRINGED1Ev( (struct $5ArrayI9FBUSTRINGE*)THIS$1 );
}

static void _ZN5ArrayIN2FB6CSVROWEEC1Ev( struct $5ArrayIN2FB6CSVROWEE* THIS$1 )
{
	*(struct $N2FB6CSVROWE**)THIS$1 = (struct $N2FB6CSVROWE*)0ull;
	*(struct $N2FB6CSVROWE**)((uint8*)THIS$1 + 8ll) = (struct $N2FB6CSVROWE*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 80ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$112:;
	label$113:;
}

static void _ZN5ArrayIN2FB6CSVROWEEaSERKS2_( struct $5ArrayIN2FB6CSVROWEE* THIS$1, struct $5ArrayIN2FB6CSVROWEE* __FB_RHS__$1 )
{
	struct $N2FB6CSVROWE* TMP$36$1;
	struct $N2FB6CSVROWE* TMP$37$1;
	struct $N2FB6CSVROWE* TMP$38$1;
	label$114:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)&_ZN2FB6CSVROWC1Ev, (void*)&_ZN2FB6CSVROWD1Ev );
	TMP$36$1 = *(struct $N2FB6CSVROWE**)((uint8*)THIS$1 + 8ll);
	TMP$37$1 = *(struct $N2FB6CSVROWE**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$38$1 = (struct $N2FB6CSVROWE*)((uint8*)TMP$37$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$116:;
	if( TMP$37$1 >= TMP$38$1) goto label$117;
	_ZN2FB6CSVROWaSERKS0_( TMP$36$1, (struct $N2FB6CSVROWE*)TMP$37$1 );
	TMP$36$1 = (struct $N2FB6CSVROWE*)((uint8*)TMP$36$1 + 80ll);
	TMP$37$1 = (struct $N2FB6CSVROWE*)((uint8*)TMP$37$1 + 80ll);
	goto label$116;
	label$117:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$115:;
}

static void _ZN5ArrayIN2FB6CSVROWEEC1ERKS2_( struct $5ArrayIN2FB6CSVROWEE* THIS$1, struct $5ArrayIN2FB6CSVROWEE* __FB_RHS__$1 )
{
	label$118:;
	*(struct $N2FB6CSVROWE**)THIS$1 = (struct $N2FB6CSVROWE*)0ull;
	*(struct $N2FB6CSVROWE**)((uint8*)THIS$1 + 8ll) = (struct $N2FB6CSVROWE*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 80ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	_ZN5ArrayIN2FB6CSVROWEEaSERKS2_( THIS$1, __FB_RHS__$1 );
	label$119:;
}

static void _ZN5ArrayIN2FB6CSVROWEED1Ev( struct $5ArrayIN2FB6CSVROWEE* THIS$1 )
{
	label$120:;
	label$121:;
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN2FB6CSVROWC1Ev, (void*)&_ZN2FB6CSVROWD1Ev );
}

static struct $5ArrayIN2FB6CSVROWEE* _ZN2FB8SPLITCSVERK8FBSTRINGRK9FBUSTRING( struct $5ArrayIN2FB6CSVROWEE* tmp$40$1, FBSTRING* S$1, FBUSTRING* DELIM$1 )
{
	FBSTRING TMP$50$1;
	int64 TMP$51$1;
	int64 TMP$52$1;
	label$122:;
	struct $5ArrayIN2FB6CSVROWEE ROWS$1;
	_ZN5ArrayIN2FB6CSVROWEEC1Ev( &ROWS$1 );
	FBSTRING D$1;
	fb_UStrAssignToA( (void*)&D$1, -1ll, (void*)DELIM$1, -1ll, 0, -1 );
	int64 DCH$1;
	DCH$1 = -1ll;
	int64 vr$3 = fb_StrLen( (void*)&D$1, -1ll );
	if( vr$3 != 1ll) goto label$125;
	{
		DCH$1 = (int64)*(uint8*)*(char**)&D$1;
		label$125:;
	}
	int64 N$1;
	int64 vr$6 = fb_StrLen( (void*)S$1, -1ll );
	N$1 = vr$6;
	int64 I$1;
	I$1 = 0ll;
	int64 RUNSTART$1;
	RUNSTART$1 = 0ll;
	struct $N2FB6CSVROWE ROW$1;
	_ZN2FB6CSVROWC1Ev( &ROW$1 );
	FBSTRING CUR$1;
	__builtin_memset( &CUR$1, 0, 24ll );
	boolean INQUOTES$1;
	INQUOTES$1 = (boolean)0ll;
	boolean ROWSTARTED$1;
	ROWSTARTED$1 = (boolean)0ll;
	label$126:;
	if( I$1 >= N$1) goto label$127;
	{
		int64 TMP$44$2;
		int64 TMP$46$2;
		int64 CH$2;
		CH$2 = (int64)*(uint8*)((uint8*)*(char**)S$1 + I$1);
		if( INQUOTES$1 == (boolean)0ll) goto label$129;
		{
			FBSTRING TMP$41$3;
			int64 TMP$42$3;
			if( CH$2 == 34ll) goto label$131;
			{
				I$1 = I$1 + 1ll;
				goto label$126;
			}
			label$131:;
			label$130:;
			FBSTRING* vr$15 = fb_StrMid( S$1, RUNSTART$1 + 1ll, I$1 - RUNSTART$1 );
			__builtin_memset( &TMP$41$3, 0, 24ll );
			FBSTRING* vr$19 = fb_StrConcat( &TMP$41$3, (void*)&CUR$1, -1ll, (void*)vr$15, -1ll );
			fb_StrAssign( (void*)&CUR$1, -1ll, (void*)vr$19, -1ll, 0 );
			if( (I$1 + 1ll) >= N$1) goto label$132;
			TMP$42$3 = (int64)-((int64)*(uint8*)((uint8*)((uint8*)*(char**)S$1 + I$1) + 1ll) == 34ll);
			goto label$584;
			label$132:;
			TMP$42$3 = 0ll;
			label$584:;
			if( TMP$42$3 == 0ll) goto label$134;
			{
				fb_StrConcatAssign( (void*)&CUR$1, -1ll, (void*)"\x22", 2ll, 0 );
				I$1 = I$1 + 2ll;
			}
			goto label$133;
			label$134:;
			{
				INQUOTES$1 = (boolean)0ll;
				I$1 = I$1 + 1ll;
			}
			label$133:;
			RUNSTART$1 = I$1;
			goto label$126;
		}
		label$129:;
		label$128:;
		if( CH$2 != 34ll) goto label$136;
		{
			FBSTRING TMP$43$3;
			FBSTRING* vr$31 = fb_StrMid( S$1, RUNSTART$1 + 1ll, I$1 - RUNSTART$1 );
			__builtin_memset( &TMP$43$3, 0, 24ll );
			FBSTRING* vr$35 = fb_StrConcat( &TMP$43$3, (void*)&CUR$1, -1ll, (void*)vr$31, -1ll );
			fb_StrAssign( (void*)&CUR$1, -1ll, (void*)vr$35, -1ll, 0 );
			INQUOTES$1 = (boolean)1ll;
			ROWSTARTED$1 = (boolean)1ll;
			I$1 = I$1 + 1ll;
			RUNSTART$1 = I$1;
			goto label$126;
		}
		label$136:;
		label$135:;
		if( DCH$1 < 0ll) goto label$137;
		TMP$44$2 = (int64)-(CH$2 == DCH$1);
		goto label$585;
		label$137:;
		TMP$44$2 = 0ll;
		label$585:;
		if( TMP$44$2 == 0ll) goto label$139;
		{
			FBSTRING TMP$45$3;
			FBSTRING* vr$41 = fb_StrMid( S$1, RUNSTART$1 + 1ll, I$1 - RUNSTART$1 );
			__builtin_memset( &TMP$45$3, 0, 24ll );
			FBSTRING* vr$45 = fb_StrConcat( &TMP$45$3, (void*)&CUR$1, -1ll, (void*)vr$41, -1ll );
			fb_StrAssign( (void*)&CUR$1, -1ll, (void*)vr$45, -1ll, 0 );
			_ZN5ArrayI8FBSTRINGE4PUSHERS0_( (struct $5ArrayI8FBSTRINGE*)&ROW$1, &CUR$1 );
			fb_StrAssign( (void*)&CUR$1, -1ll, (void*)"", 1ll, 0 );
			ROWSTARTED$1 = (boolean)1ll;
			I$1 = I$1 + 1ll;
			RUNSTART$1 = I$1;
			goto label$126;
		}
		label$139:;
		label$138:;
		if( CH$2 == 13ll) goto label$140;
		TMP$46$2 = (int64)-(CH$2 == 10ll);
		goto label$586;
		label$140:;
		TMP$46$2 = -1ll;
		label$586:;
		if( TMP$46$2 == 0ll) goto label$142;
		{
			FBSTRING TMP$47$3;
			int64 TMP$48$3;
			int64 TMP$49$3;
			FBSTRING* vr$54 = fb_StrMid( S$1, RUNSTART$1 + 1ll, I$1 - RUNSTART$1 );
			__builtin_memset( &TMP$47$3, 0, 24ll );
			FBSTRING* vr$58 = fb_StrConcat( &TMP$47$3, (void*)&CUR$1, -1ll, (void*)vr$54, -1ll );
			fb_StrAssign( (void*)&CUR$1, -1ll, (void*)vr$58, -1ll, 0 );
			_ZN5ArrayI8FBSTRINGE4PUSHERS0_( (struct $5ArrayI8FBSTRINGE*)&ROW$1, &CUR$1 );
			fb_StrAssign( (void*)&CUR$1, -1ll, (void*)"", 1ll, 0 );
			_ZN5ArrayIN2FB6CSVROWEE4PUSHERS1_( &ROWS$1, &ROW$1 );
			_ZN5ArrayI8FBSTRINGE5CLEAREv( (struct $5ArrayI8FBSTRINGE*)&ROW$1 );
			ROWSTARTED$1 = (boolean)0ll;
			if( CH$2 != 13ll) goto label$143;
			TMP$48$3 = (int64)-((I$1 + 1ll) < N$1);
			goto label$587;
			label$143:;
			TMP$48$3 = 0ll;
			label$587:;
			if( TMP$48$3 == 0ll) goto label$144;
			TMP$49$3 = (int64)-((int64)*(uint8*)((uint8*)((uint8*)*(char**)S$1 + I$1) + 1ll) == 10ll);
			goto label$588;
			label$144:;
			TMP$49$3 = 0ll;
			label$588:;
			if( TMP$49$3 == 0ll) goto label$146;
			{
				I$1 = I$1 + 2ll;
			}
			goto label$145;
			label$146:;
			{
				I$1 = I$1 + 1ll;
			}
			label$145:;
			RUNSTART$1 = I$1;
			goto label$126;
		}
		label$142:;
		label$141:;
		ROWSTARTED$1 = (boolean)1ll;
		I$1 = I$1 + 1ll;
	}
	goto label$126;
	label$127:;
	if( INQUOTES$1 == (boolean)0ll) goto label$148;
	{
		_ZN5ArrayIN2FB6CSVROWEE5CLEAREv( &ROWS$1 );
		_ZN5ArrayIN2FB6CSVROWEEC1ERKS2_( tmp$40$1, (struct $5ArrayIN2FB6CSVROWEE*)&ROWS$1 );
		fb_StrDelete( (FBSTRING*)&CUR$1 );
		_ZN2FB6CSVROWD1Ev( &ROW$1 );
		fb_StrDelete( (FBSTRING*)&D$1 );
		_ZN5ArrayIN2FB6CSVROWEED1Ev( &ROWS$1 );
		goto label$123;
	}
	label$148:;
	label$147:;
	FBSTRING* vr$83 = fb_StrMid( S$1, RUNSTART$1 + 1ll, N$1 - RUNSTART$1 );
	__builtin_memset( &TMP$50$1, 0, 24ll );
	FBSTRING* vr$87 = fb_StrConcat( &TMP$50$1, (void*)&CUR$1, -1ll, (void*)vr$83, -1ll );
	fb_StrAssign( (void*)&CUR$1, -1ll, (void*)vr$87, -1ll, 0 );
	if( (int64)-ROWSTARTED$1 != 0ll) goto label$149;
	int64 vr$91 = fb_StrLen( (void*)&CUR$1, -1ll );
	TMP$51$1 = (int64)-(vr$91 > 0ll);
	goto label$589;
	label$149:;
	TMP$51$1 = -1ll;
	label$589:;
	if( TMP$51$1 != 0ll) goto label$150;
	int32 vr$94 = _ZN5ArrayIN2FB6CSVROWEE5COUNTEv( &ROWS$1 );
	TMP$52$1 = (int64)-((int64)vr$94 == 0ll);
	goto label$590;
	label$150:;
	TMP$52$1 = -1ll;
	label$590:;
	if( TMP$52$1 == 0ll) goto label$152;
	{
		_ZN5ArrayI8FBSTRINGE4PUSHERS0_( (struct $5ArrayI8FBSTRINGE*)&ROW$1, &CUR$1 );
		_ZN5ArrayIN2FB6CSVROWEE4PUSHERS1_( &ROWS$1, &ROW$1 );
	}
	label$152:;
	label$151:;
	_ZN5ArrayIN2FB6CSVROWEEC1ERKS2_( tmp$40$1, (struct $5ArrayIN2FB6CSVROWEE*)&ROWS$1 );
	fb_StrDelete( (FBSTRING*)&CUR$1 );
	_ZN2FB6CSVROWD1Ev( &ROW$1 );
	fb_StrDelete( (FBSTRING*)&D$1 );
	_ZN5ArrayIN2FB6CSVROWEED1Ev( &ROWS$1 );
	goto label$123;
	fb_StrDelete( (FBSTRING*)&CUR$1 );
	_ZN2FB6CSVROWD1Ev( &ROW$1 );
	fb_StrDelete( (FBSTRING*)&D$1 );
	_ZN5ArrayIN2FB6CSVROWEED1Ev( &ROWS$1 );
	label$123:;
	return tmp$40$1;
}

static void _ZN5ArrayIN2FB7CSVUROWEEC1Ev( struct $5ArrayIN2FB7CSVUROWEE* THIS$1 )
{
	*(struct $N2FB7CSVUROWE**)THIS$1 = (struct $N2FB7CSVUROWE*)0ull;
	*(struct $N2FB7CSVUROWE**)((uint8*)THIS$1 + 8ll) = (struct $N2FB7CSVUROWE*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 80ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$153:;
	label$154:;
}

static void _ZN5ArrayIN2FB7CSVUROWEEaSERKS2_( struct $5ArrayIN2FB7CSVUROWEE* THIS$1, struct $5ArrayIN2FB7CSVUROWEE* __FB_RHS__$1 )
{
	struct $N2FB7CSVUROWE* TMP$54$1;
	struct $N2FB7CSVUROWE* TMP$55$1;
	struct $N2FB7CSVUROWE* TMP$56$1;
	label$155:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)&_ZN2FB7CSVUROWC1Ev, (void*)&_ZN2FB7CSVUROWD1Ev );
	TMP$54$1 = *(struct $N2FB7CSVUROWE**)((uint8*)THIS$1 + 8ll);
	TMP$55$1 = *(struct $N2FB7CSVUROWE**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$56$1 = (struct $N2FB7CSVUROWE*)((uint8*)TMP$55$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$157:;
	if( TMP$55$1 >= TMP$56$1) goto label$158;
	_ZN2FB7CSVUROWaSERKS0_( TMP$54$1, (struct $N2FB7CSVUROWE*)TMP$55$1 );
	TMP$54$1 = (struct $N2FB7CSVUROWE*)((uint8*)TMP$54$1 + 80ll);
	TMP$55$1 = (struct $N2FB7CSVUROWE*)((uint8*)TMP$55$1 + 80ll);
	goto label$157;
	label$158:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$156:;
}

static void _ZN5ArrayIN2FB7CSVUROWEEC1ERKS2_( struct $5ArrayIN2FB7CSVUROWEE* THIS$1, struct $5ArrayIN2FB7CSVUROWEE* __FB_RHS__$1 )
{
	label$159:;
	*(struct $N2FB7CSVUROWE**)THIS$1 = (struct $N2FB7CSVUROWE*)0ull;
	*(struct $N2FB7CSVUROWE**)((uint8*)THIS$1 + 8ll) = (struct $N2FB7CSVUROWE*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 80ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	_ZN5ArrayIN2FB7CSVUROWEEaSERKS2_( THIS$1, __FB_RHS__$1 );
	label$160:;
}

static void _ZN5ArrayIN2FB7CSVUROWEED1Ev( struct $5ArrayIN2FB7CSVUROWEE* THIS$1 )
{
	label$161:;
	label$162:;
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN2FB7CSVUROWC1Ev, (void*)&_ZN2FB7CSVUROWD1Ev );
}

static struct $5ArrayIN2FB7CSVUROWEE* _ZN2FB8SPLITCSVERK9FBUSTRINGS2_( struct $5ArrayIN2FB7CSVUROWEE* tmp$58$1, FBUSTRING* S$1, FBUSTRING* DELIM$1 )
{
	FBUSTRING TMP$70$1;
	int64 TMP$71$1;
	int64 TMP$72$1;
	label$163:;
	struct $5ArrayIN2FB7CSVUROWEE ROWS$1;
	_ZN5ArrayIN2FB7CSVUROWEEC1Ev( &ROWS$1 );
	int64 DCH$1;
	DCH$1 = -1ll;
	int64 vr$1 = fb_UStrLen( (void*)DELIM$1, -1ll );
	if( vr$1 != 1ll) goto label$166;
	{
		DCH$1 = (int64)*(uint16*)*(uint16**)DELIM$1;
		label$166:;
	}
	int64 N$1;
	int64 vr$5 = fb_UStrLen( (void*)S$1, -1ll );
	N$1 = vr$5;
	int64 I$1;
	I$1 = 0ll;
	int64 RUNSTART$1;
	RUNSTART$1 = 0ll;
	struct $N2FB7CSVUROWE ROW$1;
	_ZN2FB7CSVUROWC1Ev( &ROW$1 );
	FBUSTRING CUR$1;
	__builtin_memset( &CUR$1, 0, 24ll );
	boolean INQUOTES$1;
	INQUOTES$1 = (boolean)0ll;
	boolean ROWSTARTED$1;
	ROWSTARTED$1 = (boolean)0ll;
	label$167:;
	if( I$1 >= N$1) goto label$168;
	{
		int64 TMP$64$2;
		int64 TMP$66$2;
		int64 CH$2;
		CH$2 = (int64)*(uint16*)((uint8*)*(uint16**)S$1 + (I$1 << (1ll & 63ll)));
		if( INQUOTES$1 == (boolean)0ll) goto label$170;
		{
			FBUSTRING TMP$59$3;
			int64 TMP$60$3;
			if( CH$2 == 34ll) goto label$172;
			{
				I$1 = I$1 + 1ll;
				goto label$167;
			}
			label$172:;
			label$171:;
			FBUSTRING* vr$15 = fb_UStrMid( (void*)S$1, -1ll, RUNSTART$1 + 1ll, I$1 - RUNSTART$1 );
			__builtin_memset( &TMP$59$3, 0, 24ll );
			FBUSTRING* vr$19 = fb_UStrConcat( &TMP$59$3, (void*)&CUR$1, -1ll, (void*)vr$15, -1ll );
			fb_UStrAssign( (void*)&CUR$1, -1ll, (void*)vr$19, -1ll, 0 );
			if( (I$1 + 1ll) >= N$1) goto label$173;
			TMP$60$3 = (int64)-((int64)*(uint16*)((uint8*)((uint8*)*(uint16**)S$1 + (I$1 << (1ll & 63ll))) + 2ll) == 34ll);
			goto label$591;
			label$173:;
			TMP$60$3 = 0ll;
			label$591:;
			if( TMP$60$3 == 0ll) goto label$175;
			{
				fb_UStrConcatAssign( (void*)&CUR$1, -1ll, (void*)(uint16[]){0x0022,0x0000}, -9223372036854775807ll, 0 );
				I$1 = I$1 + 2ll;
			}
			goto label$174;
			label$175:;
			{
				INQUOTES$1 = (boolean)0ll;
				I$1 = I$1 + 1ll;
			}
			label$174:;
			RUNSTART$1 = I$1;
			goto label$167;
		}
		label$170:;
		label$169:;
		if( CH$2 != 34ll) goto label$177;
		{
			FBUSTRING TMP$63$3;
			FBUSTRING* vr$32 = fb_UStrMid( (void*)S$1, -1ll, RUNSTART$1 + 1ll, I$1 - RUNSTART$1 );
			__builtin_memset( &TMP$63$3, 0, 24ll );
			FBUSTRING* vr$36 = fb_UStrConcat( &TMP$63$3, (void*)&CUR$1, -1ll, (void*)vr$32, -1ll );
			fb_UStrAssign( (void*)&CUR$1, -1ll, (void*)vr$36, -1ll, 0 );
			INQUOTES$1 = (boolean)1ll;
			ROWSTARTED$1 = (boolean)1ll;
			I$1 = I$1 + 1ll;
			RUNSTART$1 = I$1;
			goto label$167;
		}
		label$177:;
		label$176:;
		if( DCH$1 < 0ll) goto label$178;
		TMP$64$2 = (int64)-(CH$2 == DCH$1);
		goto label$592;
		label$178:;
		TMP$64$2 = 0ll;
		label$592:;
		if( TMP$64$2 == 0ll) goto label$180;
		{
			FBUSTRING TMP$65$3;
			FBUSTRING* vr$42 = fb_UStrMid( (void*)S$1, -1ll, RUNSTART$1 + 1ll, I$1 - RUNSTART$1 );
			__builtin_memset( &TMP$65$3, 0, 24ll );
			FBUSTRING* vr$46 = fb_UStrConcat( &TMP$65$3, (void*)&CUR$1, -1ll, (void*)vr$42, -1ll );
			fb_UStrAssign( (void*)&CUR$1, -1ll, (void*)vr$46, -1ll, 0 );
			_ZN5ArrayI9FBUSTRINGE4PUSHERS0_( (struct $5ArrayI9FBUSTRINGE*)&ROW$1, &CUR$1 );
			fb_UStrAssign( (void*)&CUR$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
			ROWSTARTED$1 = (boolean)1ll;
			I$1 = I$1 + 1ll;
			RUNSTART$1 = I$1;
			goto label$167;
		}
		label$180:;
		label$179:;
		if( CH$2 == 13ll) goto label$181;
		TMP$66$2 = (int64)-(CH$2 == 10ll);
		goto label$593;
		label$181:;
		TMP$66$2 = -1ll;
		label$593:;
		if( TMP$66$2 == 0ll) goto label$183;
		{
			FBUSTRING TMP$67$3;
			int64 TMP$68$3;
			int64 TMP$69$3;
			FBUSTRING* vr$55 = fb_UStrMid( (void*)S$1, -1ll, RUNSTART$1 + 1ll, I$1 - RUNSTART$1 );
			__builtin_memset( &TMP$67$3, 0, 24ll );
			FBUSTRING* vr$59 = fb_UStrConcat( &TMP$67$3, (void*)&CUR$1, -1ll, (void*)vr$55, -1ll );
			fb_UStrAssign( (void*)&CUR$1, -1ll, (void*)vr$59, -1ll, 0 );
			_ZN5ArrayI9FBUSTRINGE4PUSHERS0_( (struct $5ArrayI9FBUSTRINGE*)&ROW$1, &CUR$1 );
			fb_UStrAssign( (void*)&CUR$1, -1ll, (void*)(uint16[]){0x0000}, (int64)-9223372036854775808ull, 0 );
			_ZN5ArrayIN2FB7CSVUROWEE4PUSHERS1_( &ROWS$1, &ROW$1 );
			_ZN5ArrayI9FBUSTRINGE5CLEAREv( (struct $5ArrayI9FBUSTRINGE*)&ROW$1 );
			ROWSTARTED$1 = (boolean)0ll;
			if( CH$2 != 13ll) goto label$184;
			TMP$68$3 = (int64)-((I$1 + 1ll) < N$1);
			goto label$594;
			label$184:;
			TMP$68$3 = 0ll;
			label$594:;
			if( TMP$68$3 == 0ll) goto label$185;
			TMP$69$3 = (int64)-((int64)*(uint16*)((uint8*)((uint8*)*(uint16**)S$1 + (I$1 << (1ll & 63ll))) + 2ll) == 10ll);
			goto label$595;
			label$185:;
			TMP$69$3 = 0ll;
			label$595:;
			if( TMP$69$3 == 0ll) goto label$187;
			{
				I$1 = I$1 + 2ll;
			}
			goto label$186;
			label$187:;
			{
				I$1 = I$1 + 1ll;
			}
			label$186:;
			RUNSTART$1 = I$1;
			goto label$167;
		}
		label$183:;
		label$182:;
		ROWSTARTED$1 = (boolean)1ll;
		I$1 = I$1 + 1ll;
	}
	goto label$167;
	label$168:;
	if( INQUOTES$1 == (boolean)0ll) goto label$189;
	{
		_ZN5ArrayIN2FB7CSVUROWEE5CLEAREv( &ROWS$1 );
		_ZN5ArrayIN2FB7CSVUROWEEC1ERKS2_( tmp$58$1, (struct $5ArrayIN2FB7CSVUROWEE*)&ROWS$1 );
		fb_UStrDelete( (FBUSTRING*)&CUR$1 );
		_ZN2FB7CSVUROWD1Ev( &ROW$1 );
		_ZN5ArrayIN2FB7CSVUROWEED1Ev( &ROWS$1 );
		goto label$164;
	}
	label$189:;
	label$188:;
	FBUSTRING* vr$84 = fb_UStrMid( (void*)S$1, -1ll, RUNSTART$1 + 1ll, N$1 - RUNSTART$1 );
	__builtin_memset( &TMP$70$1, 0, 24ll );
	FBUSTRING* vr$88 = fb_UStrConcat( &TMP$70$1, (void*)&CUR$1, -1ll, (void*)vr$84, -1ll );
	fb_UStrAssign( (void*)&CUR$1, -1ll, (void*)vr$88, -1ll, 0 );
	if( (int64)-ROWSTARTED$1 != 0ll) goto label$190;
	int64 vr$92 = fb_UStrLen( (void*)&CUR$1, -1ll );
	TMP$71$1 = (int64)-(vr$92 > 0ll);
	goto label$596;
	label$190:;
	TMP$71$1 = -1ll;
	label$596:;
	if( TMP$71$1 != 0ll) goto label$191;
	int32 vr$95 = _ZN5ArrayIN2FB7CSVUROWEE5COUNTEv( &ROWS$1 );
	TMP$72$1 = (int64)-((int64)vr$95 == 0ll);
	goto label$597;
	label$191:;
	TMP$72$1 = -1ll;
	label$597:;
	if( TMP$72$1 == 0ll) goto label$193;
	{
		_ZN5ArrayI9FBUSTRINGE4PUSHERS0_( (struct $5ArrayI9FBUSTRINGE*)&ROW$1, &CUR$1 );
		_ZN5ArrayIN2FB7CSVUROWEE4PUSHERS1_( &ROWS$1, &ROW$1 );
	}
	label$193:;
	label$192:;
	_ZN5ArrayIN2FB7CSVUROWEEC1ERKS2_( tmp$58$1, (struct $5ArrayIN2FB7CSVUROWEE*)&ROWS$1 );
	fb_UStrDelete( (FBUSTRING*)&CUR$1 );
	_ZN2FB7CSVUROWD1Ev( &ROW$1 );
	_ZN5ArrayIN2FB7CSVUROWEED1Ev( &ROWS$1 );
	goto label$164;
	fb_UStrDelete( (FBUSTRING*)&CUR$1 );
	_ZN2FB7CSVUROWD1Ev( &ROW$1 );
	_ZN5ArrayIN2FB7CSVUROWEED1Ev( &ROWS$1 );
	label$164:;
	return tmp$58$1;
}

static struct $5ArrayI9FBUSTRINGE* _ZN2FB11SPLITCSVROWERK9FBUSTRINGS2_( struct $5ArrayI9FBUSTRINGE* tmp$78$1, FBUSTRING* S$1, FBUSTRING* DELIM$1 )
{
	label$204:;
	struct $5ArrayI9FBUSTRINGE RES$1;
	_ZN5ArrayI9FBUSTRINGEC1Ev( &RES$1 );
	struct $5ArrayIN2FB7CSVUROWEE ROWS$1;
	_ZN2FB8SPLITCSVERK9FBUSTRINGS2_( &ROWS$1, S$1, DELIM$1 );
	int32 vr$3 = _ZN5ArrayIN2FB7CSVUROWEE5COUNTEv( &ROWS$1 );
	if( (int64)vr$3 != 0ll) goto label$207;
	{
		_ZN5ArrayI9FBUSTRINGEC1ERKS1_( tmp$78$1, (struct $5ArrayI9FBUSTRINGE*)&RES$1 );
		_ZN5ArrayIN2FB7CSVUROWEED1Ev( &ROWS$1 );
		_ZN5ArrayI9FBUSTRINGED1Ev( &RES$1 );
		goto label$205;
		label$207:;
	}
	int64 N$1;
	struct $N2FB7CSVUROWE* vr$9 = _ZN5ArrayIN2FB7CSVUROWEEixEi( &ROWS$1, 0 );
	int32 vr$11 = _ZN5ArrayI9FBUSTRINGE5COUNTEv( (struct $5ArrayI9FBUSTRINGE*)vr$9 );
	N$1 = (int64)vr$11;
	_ZN5ArrayI9FBUSTRINGE7RESERVEEi( &RES$1, (int32)N$1 );
	{
		int64 I$2;
		I$2 = 0ll;
		int64 TMP$80$2;
		TMP$80$2 = N$1 + -1ll;
		goto label$208;
		label$211:;
		{
			struct $N2FB7CSVUROWE* vr$18 = _ZN5ArrayIN2FB7CSVUROWEEixEi( &ROWS$1, 0 );
			FBUSTRING* vr$20 = _ZN5ArrayI9FBUSTRINGEixEi( (struct $5ArrayI9FBUSTRINGE*)vr$18, (int32)I$2 );
			_ZN5ArrayI9FBUSTRINGE4PUSHERS0_( &RES$1, vr$20 );
		}
		label$209:;
		I$2 = I$2 + 1ll;
		label$208:;
		if( I$2 <= TMP$80$2) goto label$211;
		label$210:;
	}
	_ZN5ArrayI9FBUSTRINGEC1ERKS1_( tmp$78$1, (struct $5ArrayI9FBUSTRINGE*)&RES$1 );
	_ZN5ArrayIN2FB7CSVUROWEED1Ev( &ROWS$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &RES$1 );
	goto label$205;
	_ZN5ArrayIN2FB7CSVUROWEED1Ev( &ROWS$1 );
	_ZN5ArrayI9FBUSTRINGED1Ev( &RES$1 );
	label$205:;
	return tmp$78$1;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT24SPLIT_STRING_BASICS_CTOREv( void )
{
	label$504:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_string_basics", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT19SPLIT_STRING_BASICSEv, (boolean)0ll );
	label$505:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT34SPLIT_EMPTY_FIELDS_ARE_FIELDS_CTOREv( void )
{
	label$508:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_empty_fields_are_fields", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT29SPLIT_EMPTY_FIELDS_ARE_FIELDSEv, (boolean)0ll );
	label$509:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT35SPLIT_NON_OVERLAPPING_AND_CASE_CTOREv( void )
{
	label$512:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_non_overlapping_and_case", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT30SPLIT_NON_OVERLAPPING_AND_CASEEv, (boolean)0ll );
	label$513:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT22SPLITCHARS_STRING_CTOREv( void )
{
	label$516:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"splitchars_string", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT17SPLITCHARS_STRINGEv, (boolean)0ll );
	label$517:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT16JOIN_STRING_CTOREv( void )
{
	label$520:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"join_string", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT11JOIN_STRINGEv, (boolean)0ll );
	label$521:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT25JOIN_SPLIT_ROUNDTRIP_CTOREv( void )
{
	label$532:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"join_split_roundtrip", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT20JOIN_SPLIT_ROUNDTRIPEv, (boolean)0ll );
	label$533:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT18SPLIT_ZSTRING_CTOREv( void )
{
	label$536:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_zstring", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SPLIT_ZSTRINGEv, (boolean)0ll );
	label$537:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT18SPLIT_USTRING_CTOREv( void )
{
	label$540:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_ustring", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SPLIT_USTRINGEv, (boolean)0ll );
	label$541:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT38SPLIT_WSTRING_GIVES_USTRING_ARRAY_CTOREv( void )
{
	label$544:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_wstring_gives_ustring_array", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT33SPLIT_WSTRING_GIVES_USTRING_ARRAYEv, (boolean)0ll );
	label$545:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT18SPLIT_UNICODE_CTOREv( void )
{
	label$548:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_unicode", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SPLIT_UNICODEEv, (boolean)0ll );
	label$549:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT28SPLIT_ROUNDTRIP_USTRING_CTOREv( void )
{
	label$556:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_roundtrip_ustring", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT23SPLIT_ROUNDTRIP_USTRINGEv, (boolean)0ll );
	label$557:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT33SPLIT_RESULT_IS_A_REAL_ARRAY_CTOREv( void )
{
	label$564:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_result_is_a_real_array", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT28SPLIT_RESULT_IS_A_REAL_ARRAYEv, (boolean)0ll );
	label$565:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT22SPLIT_MANY_FIELDS_CTOREv( void )
{
	label$574:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_many_fields", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT17SPLIT_MANY_FIELDSEv, (boolean)0ll );
	label$575:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT44SPLIT_BODIES_ARE_PRIVATE_ACROSS_MODULES_CTOREv( void )
{
	label$578:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.string_.fbstr_split", (char*)"split_bodies_are_private_across_modules", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT39SPLIT_BODIES_ARE_PRIVATE_ACROSS_MODULESEv, (boolean)0ll );
	label$579:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRING_11FBSTR_SPLIT13SUITE_CTOR361Ev( void )
{
	label$580:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.string_.fbstr_split", (tmp$4)0ull, (tmp$4)0ull );
	label$581:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
