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
struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_12SIMPLESUBUDTE {
	int8 AA;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_12SIMPLESUBUDTE ) == 1 );
struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_9SIMPLEUDTE {
	struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_12SIMPLESUBUDTE A;
	double B;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_9SIMPLEUDTE ) == 16 );
struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE {
	uint8 __fb_struct_body[56];
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE ) == 56 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
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
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
void fb_ArrayDestructStr( struct $7FBARRAYIvE* );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
int32 fb_StrCompare( void*, int64, void*, int64 );
void fb_ThreadWait( void* );
void* fb_ThreadCall( void*, int32, int64, int32, ... );
void* fb_MutexCreate( void );
void fb_MutexDestroy( void* );
void fb_MutexLock( void* );
void fb_MutexUnlock( void* );
static void fb_ctor__threadcall( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10OVERLOADEDEu7INTEGER( int64 );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10OVERLOADEDER8FBSTRING( FBSTRING* );
int32 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_4INITEv( void );
int32 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7CLEANUPEv( void );
static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTC1Ev( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE* );
static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTaSERKS3_( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE*, struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE* );
static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTD1Ev( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE* );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_8SMALLINTEahst( int8, uint8, int16, uint16 );
void testWindowsMs( void );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6BIGINTERu7INTEGERRu8UINTEGERRxRyRiRj( int64*, uint64*, int64*, uint64*, int32*, uint32* );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_8FLOATSTREfRdR8FBSTRING( float, double*, FBSTRING* );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_9TYPEARRAYENS2_9SIMPLEUDTERNS2_10COMPLEXUDTER7FBARRAYI8FBSTRINGERu7INTEGERS9_( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_9SIMPLEUDTE, struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE*, struct $7FBARRAYI8FBSTRINGE*, int64*, int64 );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7NOARGSAEv( void );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7NOARGSBEv( void );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_12THREADCALLNS2NSEv( void );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_13THREADCALLONS2NSEv( void );
void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_12DEFAULT_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_13SUITE_CTOR205Ev( void ) __attribute__(( constructor ));
static int64 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_17NOARGSA_EXECUTED$E = 0ll;
static int64 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_17NOARGSB_EXECUTED$E = 0ll;
static int64 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_23OVERLOADEDINT_EXECUTED$E = 0ll;
static int64 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_23OVERLOADEDSTR_EXECUTED$E = 0ll;
static int64 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_19NAMESPACE_EXECUTED$E = 0ll;
static int64 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_24OTHERNAMESPACE_EXECUTED$E = 0ll;
static void* _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E;

int32 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_4INITEv( void )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$2:;
	void* vr$1 = fb_MutexCreate(  );
	_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E = vr$1;
	fb$result$1 = 0;
	goto label$3;
	label$3:;
	return fb$result$1;
}

int32 _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7CLEANUPEv( void )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$4:;
	fb_MutexDestroy( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb$result$1 = 0;
	goto label$5;
	label$5:;
	return fb$result$1;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_8SMALLINTEahst( int8 B$1, uint8 UB$1, int16 S$1, uint16 US$1 )
{
	label$15:;
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)B$1 == 20ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 64, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.SMALLINT", (char*)"CU_ASSERT((b = 20) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)UB$1 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 65, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.SMALLINT", (char*)"CU_ASSERT((ub = 1) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)S$1 == 19ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 66, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.SMALLINT", (char*)"CU_ASSERT((s = 19) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)US$1 == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 67, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.SMALLINT", (char*)"CU_ASSERT((us = 2) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	label$16:;
}

void testWindowsMs( void )
{
	label$17:;
	label$18:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6BIGINTERu7INTEGERRu8UINTEGERRxRyRiRj( int64* I$1, uint64* UI$1, int64* L$1, uint64* UL$1, int32* I4$1, uint32* UI4$1 )
{
	label$19:;
	*I$1 = 17ll;
	*UI$1 = 3ull;
	*L$1 = 16ll;
	*UL$1 = 4ull;
	*I4$1 = 15;
	*UI4$1 = 5u;
	label$20:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_8FLOATSTREfRdR8FBSTRING( float S$1, double* D$1, FBSTRING* S1$1 )
{
	label$21:;
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((int64)-((double)S$1 > 0x1.DFF7CED916873p+3) & (int64)-((double)S$1 < 0x1.E051EB851EB85p+3)) != 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 90, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.FLOATSTR", (char*)"CU_ASSERT((s > 14.999 and s < 15.01) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	int32 vr$7 = fb_StrCompare( (void*)S1$1, -1ll, (void*)"fourteen", 9ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$7 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 91, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.FLOATSTR", (char*)"CU_ASSERT((s1 = \x22" "fourteen\x22) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_StrAssign( (void*)S1$1, -1ll, (void*)"five", 5ll, 0 );
	*D$1 = 0x1.Ap+3;
	label$22:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_9TYPEARRAYENS2_9SIMPLEUDTERNS2_10COMPLEXUDTER7FBARRAYI8FBSTRINGERu7INTEGERS9_( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_9SIMPLEUDTE SU$1, struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE* CU$1, struct $7FBARRAYI8FBSTRINGE* ANARRAY$1, int64* BV$1, int64 OPT$1 )
{
	label$23:;
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)*(int8*)&SU$1 == 10ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 101, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.TYPEARRAY", (char*)"CU_ASSERT((su.a.aa = 10) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((int64)-(*(double*)((uint8*)&SU$1 + 8ll) > 0x1.FF5C28F5C28F6p+2) & (int64)-(*(double*)((uint8*)&SU$1 + 8ll) < 0x1.0051EB851EB85p+3)) != 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 102, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.TYPEARRAY", (char*)"CU_ASSERT((su.b > 7.99 and su.b < 8.01) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(OPT$1 == 13ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 103, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.TYPEARRAY", (char*)"CU_ASSERT((opt = 13) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	*(int64*)CU$1 = 7ll;
	*(int64*)((uint8*)CU$1 + 8ll) = 11ll;
	*(int64*)((uint8*)CU$1 + 16ll) = 8ll;
	fb_StrAssign( (void*)((uint8*)CU$1 + 24ll), -1ll, (void*)"ten", 4ll, 0 );
	fb_StrAssign( (void*)*(int64*)ANARRAY$1, -1ll, (void*)"ten", 4ll, 0 );
	fb_StrAssign( (void*)((uint8*)*(int64*)ANARRAY$1 + 24ll), -1ll, (void*)"nine", 5ll, 0 );
	*BV$1 = 9ll;
	label$24:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7NOARGSAEv( void )
{
	label$25:;
	_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_17NOARGSA_EXECUTED$E = -1ll;
	label$26:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7NOARGSBEv( void )
{
	label$27:;
	_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_17NOARGSB_EXECUTED$E = -1ll;
	label$28:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10OVERLOADEDEu7INTEGER( int64 I$1 )
{
	label$29:;
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(I$1 == -10ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 124, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.OVERLOADED", (char*)"CU_ASSERT((i = -10) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_23OVERLOADEDINT_EXECUTED$E = -1ll;
	label$30:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10OVERLOADEDER8FBSTRING( FBSTRING* S$1 )
{
	label$31:;
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	int32 vr$0 = fb_StrCompare( (void*)S$1, -1ll, (void*)"minus eleven", 13ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$0 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 129, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.OVERLOADED", (char*)"CU_ASSERT((s = \x22minus eleven\x22) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_23OVERLOADEDSTR_EXECUTED$E = -1ll;
	label$32:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_12THREADCALLNS2NSEv( void )
{
	label$33:;
	_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_19NAMESPACE_EXECUTED$E = -1ll;
	label$34:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_13THREADCALLONS2NSEv( void )
{
	label$35:;
	_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_24OTHERNAMESPACE_EXECUTED$E = -1ll;
	label$36:;
}

void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7DEFAULTEv( void )
{
	int8 TMP$60$1;
	uint8 TMP$61$1;
	int16 TMP$62$1;
	uint16 TMP$63$1;
	int64* TMP$66$1;
	uint64* TMP$67$1;
	int64* TMP$68$1;
	uint64* TMP$69$1;
	int32* TMP$70$1;
	uint32* TMP$71$1;
	float TMP$73$1;
	double* TMP$74$1;
	FBSTRING* TMP$75$1;
	struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE* TMP$77$1;
	struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10FBARRAY1$2I8FBSTRINGEE {
		FBSTRING* DATA;
		FBSTRING* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10FBARRAY1$2I8FBSTRINGEE ) == 72 );
	struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10FBARRAY1$2I8FBSTRINGEE* TMP$78$1;
	int64** TMP$79$1;
	int64 TMP$80$1;
	int64 TMP$83$1;
	FBSTRING* TMP$85$1;
	label$37:;
	void* THREAD$1;
	__builtin_memset( &THREAD$1, 0, 8ll );
	int64 I$1;
	__builtin_memset( &I$1, 0, 8ll );
	uint64 UI$1;
	__builtin_memset( &UI$1, 0, 8ll );
	int64 L$1;
	__builtin_memset( &L$1, 0, 8ll );
	uint64 UL$1;
	__builtin_memset( &UL$1, 0, 8ll );
	int32 I4$1;
	__builtin_memset( &I4$1, 0, 4ll );
	uint32 IU4$1;
	__builtin_memset( &IU4$1, 0, 4ll );
	double D$1;
	__builtin_memset( &D$1, 0, 8ll );
	FBSTRING S1$1;
	__builtin_memset( &S1$1, 0, 24ll );
	FBSTRING S2$1;
	__builtin_memset( &S2$1, 0, 24ll );
	int64* BV$1;
	__builtin_memset( &BV$1, 0, 8ll );
	struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE CU$1;
	_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTC1Ev( &CU$1 );
	FBSTRING ANARRAY$1[2];
	__builtin_memset( (FBSTRING*)ANARRAY$1, 0, 48ll );
	struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10FBARRAY1$2I8FBSTRINGEE tmp$56$1;
	*(FBSTRING**)&tmp$56$1 = (FBSTRING*)ANARRAY$1;
	*(FBSTRING**)((uint8*)&tmp$56$1 + 8ll) = (FBSTRING*)ANARRAY$1;
	*(int64*)((uint8*)&tmp$56$1 + 16ll) = 48ll;
	*(int64*)((uint8*)&tmp$56$1 + 24ll) = 24ll;
	*(int64*)((uint8*)&tmp$56$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$56$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$56$1 + 48ll) = 2ll;
	*(int64*)((uint8*)&tmp$56$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$56$1 + 64ll) = 1ll;
	struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_9SIMPLEUDTE SU$1;
	*(int8*)&SU$1 = (int8)10;
	__builtin_memset( (void*)((uint8*)&SU$1 + 1ll), 0, 7ll );
	*(double*)((uint8*)&SU$1 + 8ll) = 0x1.p+3;
	void* SMALLINT_THREAD$1;
	__builtin_memset( &SMALLINT_THREAD$1, 0, 8ll );
	void* BIGINT_THREAD$1;
	__builtin_memset( &BIGINT_THREAD$1, 0, 8ll );
	void* FLOATSTR_THREAD$1;
	__builtin_memset( &FLOATSTR_THREAD$1, 0, 8ll );
	void* TYPEARRAY_THREAD$1;
	__builtin_memset( &TYPEARRAY_THREAD$1, 0, 8ll );
	void* NOARGSA_THREAD$1;
	__builtin_memset( &NOARGSA_THREAD$1, 0, 8ll );
	void* NOARGSB_THREAD$1;
	__builtin_memset( &NOARGSB_THREAD$1, 0, 8ll );
	void* OVLINT_THREAD$1;
	__builtin_memset( &OVLINT_THREAD$1, 0, 8ll );
	void* OVLSTR_THREAD$1;
	__builtin_memset( &OVLSTR_THREAD$1, 0, 8ll );
	void* NAMESPACE_THREAD$1;
	__builtin_memset( &NAMESPACE_THREAD$1, 0, 8ll );
	void* ONAMESPACE_THREAD$1;
	__builtin_memset( &ONAMESPACE_THREAD$1, 0, 8ll );
	void* TESTWINDOWSMS_THREAD$1;
	__builtin_memset( &TESTWINDOWSMS_THREAD$1, 0, 8ll );
	TMP$60$1 = (int8)20;
	TMP$61$1 = (uint8)1u;
	TMP$62$1 = (int16)19;
	TMP$63$1 = (uint16)2u;
	void* vr$31 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_8SMALLINTEahst, 0, 0ll, 4, 2ll, &TMP$60$1, 3ll, &TMP$61$1, 4ll, &TMP$62$1, 5ll, &TMP$63$1 );
	SMALLINT_THREAD$1 = vr$31;
	void* vr$32 = fb_ThreadCall( (void*)&testWindowsMs, 0, 0ll, 0 );
	TESTWINDOWSMS_THREAD$1 = vr$32;
	TMP$66$1 = &I$1;
	TMP$67$1 = &UI$1;
	TMP$68$1 = &L$1;
	TMP$69$1 = &UL$1;
	TMP$70$1 = &I4$1;
	TMP$71$1 = &IU4$1;
	void* vr$45 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6BIGINTERu7INTEGERRu8UINTEGERRxRyRiRj, 1, 0ll, 6, 13ll, &TMP$66$1, 13ll, &TMP$67$1, 13ll, &TMP$68$1, 13ll, &TMP$69$1, 13ll, &TMP$70$1, 13ll, &TMP$71$1 );
	BIGINT_THREAD$1 = vr$45;
	fb_StrAssign( (void*)&S1$1, -1ll, (void*)"fourteen", 9ll, 0 );
	TMP$73$1 = 0x1.Ep+3f;
	TMP$74$1 = &D$1;
	TMP$75$1 = &S1$1;
	void* vr$52 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_8FLOATSTREfRdR8FBSTRING, 0, 0ll, 3, 10ll, &TMP$73$1, 13ll, &TMP$74$1, 13ll, &TMP$75$1 );
	FLOATSTR_THREAD$1 = vr$52;
	TMP$77$1 = &CU$1;
	TMP$78$1 = &tmp$56$1;
	TMP$79$1 = &BV$1;
	TMP$80$1 = 13ll;
	void* vr$61 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_9TYPEARRAYENS2_9SIMPLEUDTERNS2_10COMPLEXUDTER7FBARRAYI8FBSTRINGERu7INTEGERS9_, 0, 0ll, 5, 12ll, 2ll, 2ll, 11ll, &SU$1, 13ll, &TMP$77$1, 13ll, &TMP$78$1, 13ll, &TMP$79$1, 8ll, &TMP$80$1 );
	TYPEARRAY_THREAD$1 = vr$61;
	void* vr$62 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7NOARGSAEv, 0, 0ll, 0 );
	NOARGSA_THREAD$1 = vr$62;
	void* vr$63 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7NOARGSBEv, 0, 0ll, 0 );
	NOARGSB_THREAD$1 = vr$63;
	TMP$83$1 = -10ll;
	void* vr$65 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10OVERLOADEDEu7INTEGER, 0, 0ll, 1, 8ll, &TMP$83$1 );
	OVLINT_THREAD$1 = vr$65;
	fb_StrAssign( (void*)&S2$1, -1ll, (void*)"minus eleven", 13ll, 0 );
	TMP$85$1 = &S2$1;
	void* vr$69 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10OVERLOADEDER8FBSTRING, 0, 0ll, 1, 13ll, &TMP$85$1 );
	OVLSTR_THREAD$1 = vr$69;
	void* vr$70 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_12THREADCALLNS2NSEv, 0, 0ll, 0 );
	NAMESPACE_THREAD$1 = vr$70;
	void* vr$71 = fb_ThreadCall( (void*)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_13THREADCALLONS2NSEv, 0, 0ll, 0 );
	ONAMESPACE_THREAD$1 = vr$71;
	fb_ThreadWait( SMALLINT_THREAD$1 );
	fb_ThreadWait( TESTWINDOWSMS_THREAD$1 );
	fb_ThreadWait( BIGINT_THREAD$1 );
	fb_ThreadWait( FLOATSTR_THREAD$1 );
	fb_ThreadWait( TYPEARRAY_THREAD$1 );
	fb_ThreadWait( NOARGSA_THREAD$1 );
	fb_ThreadWait( NOARGSB_THREAD$1 );
	fb_ThreadWait( OVLINT_THREAD$1 );
	fb_ThreadWait( OVLSTR_THREAD$1 );
	fb_ThreadWait( NAMESPACE_THREAD$1 );
	fb_ThreadWait( ONAMESPACE_THREAD$1 );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((((((int64)-(I$1 == 17ll) & (int64)-(UI$1 == 3ull)) & (int64)-(L$1 == 16ll)) & (int64)-(UL$1 == 4ull)) & (int64)-((int64)I4$1 == 15ll)) & (int64)-((int64)IU4$1 == 5ll)) != 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 190, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((i = 17 and ui = 3 and l = 16 and ul = 4 and i4 = 15 and iu4 = 5) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	int32 vr$91 = fb_StrCompare( (void*)&S1$1, -1ll, (void*)"five", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((((int64)-(D$1 > 0x1.9FAE147AE147Bp+3) & (int64)-(D$1 < 0x1.A051EB851EB85p+3)) & (int64)-((int64)vr$91 == 0ll)) != 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 191, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((d > 12.99 and d < 13.01 and s1 = \x22" "five\x22) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((((int64)-(*(int64*)&CU$1 == 7ll) & (int64)-(*(int64*)((uint8*)&CU$1 + 8ll) == 11ll)) & (int64)-(*(int64*)((uint8*)&CU$1 + 16ll) == 8ll)) != 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 192, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((cu.c(0) = 7 and cu.c(1) = 11 and cu.c(2) = 8) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	int32 vr$105 = fb_StrCompare( (void*)((uint8*)&CU$1 + 24ll), -1ll, (void*)"ten", 4ll );
	int32 vr$109 = fb_StrCompare( (void*)ANARRAY$1, -1ll, (void*)"ten", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((int64)-((int64)vr$105 == 0ll) & (int64)-((int64)vr$109 == 0ll)) != 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 193, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((cu.d = \x22ten\x22 and AnArray(0) = \x22ten\x22) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	int32 vr$116 = fb_StrCompare( (void*)((int64)(FBSTRING*)ANARRAY$1 + 24ll), -1ll, (void*)"nine", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((int64)-((int64)vr$116 == 0ll) & (int64)-(BV$1 == (int64*)9ull)) != 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 194, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((AnArray(1) = \x22nine\x22 and bv = 9) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_17NOARGSA_EXECUTED$E == -1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 197, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((NoArgsA_Executed = -1) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_17NOARGSB_EXECUTED$E == -1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 198, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((NoArgsB_Executed = -1) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_23OVERLOADEDINT_EXECUTED$E == -1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 199, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((OverloadedInt_Executed = -1) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_23OVERLOADEDSTR_EXECUTED$E == -1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 200, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((OverloadedStr_Executed = -1) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_19NAMESPACE_EXECUTED$E == -1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 201, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((Namespace_Executed = -1) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_MutexLock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_24OTHERNAMESPACE_EXECUTED$E == -1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cthreads\x5Cthreadcall.bas", 202, (char*)"TESTS.FBC_TESTS.THREADS.THREADCALL_.DEFAULT", (char*)"CU_ASSERT((OtherNamespace_Executed = -1) <> 0)" );
	fb_MutexUnlock( _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_6MUTEX$E );
	fb_ArrayDestructStr( (struct $7FBARRAYIvE*)&tmp$56$1 );
	_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTD1Ev( &CU$1 );
	fb_StrDelete( (FBSTRING*)&S2$1 );
	fb_StrDelete( (FBSTRING*)&S1$1 );
	label$38:;
}

__attribute__(( constructor )) static void fb_ctor__threadcall( void )
{
	label$0:;
	label$1:;
}

static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTC1Ev( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE* THIS$1 )
{
	__builtin_memset( (int64*)THIS$1, 0, 24ll );
	__builtin_memset( (FBSTRING*)((uint8*)THIS$1 + 24ll), 0, 24ll );
	*(int64*)((uint8*)THIS$1 + 48ll) = (int64)(uint64)(*(int64*)((uint8*)THIS$1 + 48ll) & -2ll);
	label$6:;
	label$7:;
}

static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTaSERKS3_( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE* THIS$1, struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE* __FB_RHS__$1 )
{
	int64 TMP$7$1;
	int64* TMP$8$1;
	int64* TMP$9$1;
	label$8:;
	TMP$8$1 = (int64*)THIS$1;
	TMP$9$1 = (int64*)__FB_RHS__$1;
	TMP$7$1 = 0ll;
	label$10:;
	*TMP$8$1 = *TMP$9$1;
	TMP$8$1 = (int64*)((uint8*)TMP$8$1 + 8ll);
	TMP$9$1 = (int64*)((uint8*)TMP$9$1 + 8ll);
	TMP$7$1 = TMP$7$1 + 1ll;
	if( TMP$7$1 != 3ll) goto label$10;
	fb_StrAssign( (void*)((uint8*)THIS$1 + 24ll), -1ll, (void*)((uint8*)__FB_RHS__$1 + 24ll), -1ll, 0 );
	*(int64*)((uint8*)THIS$1 + 48ll) = (int64)((uint64)(*(int64*)((uint8*)THIS$1 + 48ll) & -2ll) | ((*(uint64*)((uint8*)__FB_RHS__$1 + 48ll) & 1ull) & 1ull));
	label$9:;
}

static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTD1Ev( struct $N5TESTS9FBC_TESTS7THREADS11THREADCALL_10COMPLEXUDTE* THIS$1 )
{
	label$13:;
	label$14:;
	fb_StrDelete( (FBSTRING*)((uint8*)THIS$1 + 24ll) );
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_12DEFAULT_CTOREv( void )
{
	label$39:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.threads.threadcall_", (char*)"default", (tmp$5)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7DEFAULTEv, (boolean)0ll );
	label$40:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_13SUITE_CTOR205Ev( void )
{
	label$41:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.threads.threadcall_", (tmp$4)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_4INITEv, (tmp$4)&_ZN5TESTS9FBC_TESTS7THREADS11THREADCALL_7CLEANUPEv );
	label$42:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit\0-l\0ffi\0-mt";
