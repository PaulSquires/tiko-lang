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
struct $10fb_Object$ {
	void* VPTR$;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $10fb_Object$ ) == 8 );
struct $N2FB10COMUNKNOWNE {
	struct $10fb_Object$ BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB10COMUNKNOWNE ) == 8 );
struct $5IFAKE {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $5IFAKE ) == 8 );
struct $6ComPtrI5IFAKEE {
	struct $5IFAKE* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrI5IFAKEE ) == 8 );
struct $10ComHeapPtrItE {
	uint16* P;
};
__FB_STATIC_ASSERT( sizeof( struct $10ComHeapPtrItE ) == 8 );
struct $11ISHELLITEM_ {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $11ISHELLITEM_ ) == 8 );
struct $6ComPtrI11ISHELLITEM_E {
	struct $11ISHELLITEM_* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrI11ISHELLITEM_E ) == 8 );
struct $N2FB7COMINITE {
	int32 HR;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB7COMINITE ) == 4 );
typedef int32 (*tmp$2102)( struct $5IFAKE* );
struct $7SPYVTBL {
	void* QUERYINTERFACE;
	void* ADDREF;
	void* RELEASE;
	void* PREALLOC;
	void* POSTALLOC;
	void* PREFREE;
	void* POSTFREE;
	void* PREREALLOC;
	void* POSTREALLOC;
	void* PREGETSIZE;
	void* POSTGETSIZE;
	void* PREDIDALLOC;
	void* POSTDIDALLOC;
	void* PREHEAPMINIMIZE;
	void* POSTHEAPMINIMIZE;
};
__FB_STATIC_ASSERT( sizeof( struct $7SPYVTBL ) == 120 );
struct $11IMallocSpy_;
struct $5_GUID {
	uint32 DATA1;
	uint16 DATA2;
	uint16 DATA3;
	uint8 DATA4[8];
};
__FB_STATIC_ASSERT( sizeof( struct $5_GUID ) == 16 );
typedef int32 (*tmp$563)( struct $11IMallocSpy_*, struct $5_GUID*, void** );
typedef uint32 (*tmp$564)( struct $11IMallocSpy_* );
typedef uint64 (*tmp$565)( struct $11IMallocSpy_*, uint64 );
typedef void* (*tmp$566)( struct $11IMallocSpy_*, void* );
typedef void* (*tmp$567)( struct $11IMallocSpy_*, void*, int32 );
typedef void (*tmp$568)( struct $11IMallocSpy_*, int32 );
typedef uint64 (*tmp$569)( struct $11IMallocSpy_*, void*, uint64, void**, int32 );
typedef uint64 (*tmp$570)( struct $11IMallocSpy_*, uint64, int32 );
typedef int32 (*tmp$571)( struct $11IMallocSpy_*, void*, int32, int32 );
typedef void (*tmp$572)( struct $11IMallocSpy_* );
struct $14IMallocSpyVtbl {
	tmp$563 QUERYINTERFACE;
	tmp$564 ADDREF;
	tmp$564 RELEASE;
	tmp$565 PREALLOC;
	tmp$566 POSTALLOC;
	tmp$567 PREFREE;
	tmp$568 POSTFREE;
	tmp$569 PREREALLOC;
	tmp$567 POSTREALLOC;
	tmp$567 PREGETSIZE;
	tmp$570 POSTGETSIZE;
	tmp$567 PREDIDALLOC;
	tmp$571 POSTDIDALLOC;
	tmp$572 PREHEAPMINIMIZE;
	tmp$572 POSTHEAPMINIMIZE;
};
__FB_STATIC_ASSERT( sizeof( struct $14IMallocSpyVtbl ) == 120 );
struct $11IMallocSpy_ {
	struct $14IMallocSpyVtbl* LPVTBL;
};
__FB_STATIC_ASSERT( sizeof( struct $11IMallocSpy_ ) == 8 );
typedef int32 (*tmp$2153)( struct $11ISHELLITEM_*, int32, uint16** );
struct $7CPCVTBL {
	void* QUERYINTERFACE;
	void* ADDREF;
	void* RELEASE;
	void* ENUMCONNECTIONPOINTS;
	void* FINDCONNECTIONPOINT;
};
__FB_STATIC_ASSERT( sizeof( struct $7CPCVTBL ) == 40 );
struct $6CPVTBL {
	void* QUERYINTERFACE;
	void* ADDREF;
	void* RELEASE;
	void* GETCONNECTIONINTERFACE;
	void* GETCONNECTIONPOINTCONTAINER;
	void* ADVISE;
	void* UNADVISE;
	void* ENUMCONNECTIONS;
};
__FB_STATIC_ASSERT( sizeof( struct $6CPVTBL ) == 64 );
struct $3SRC;
struct $5CPOBJ {
	struct $6CPVTBL* LPVTBL;
	struct $3SRC* OWNER;
};
__FB_STATIC_ASSERT( sizeof( struct $5CPOBJ ) == 16 );
struct $3SRC {
	struct $7CPCVTBL* LPVTBL;
	int32 REFS;
	uint32 LASTCOOKIE;
	int32 ADVISECOUNT;
	int32 UNADVISECOUNT;
	void* LASTSINK;
	struct $5CPOBJ CP;
};
__FB_STATIC_ASSERT( sizeof( struct $3SRC ) == 48 );
struct $N2FB11COMDISPATCHE {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB11COMDISPATCHE ) == 8 );
struct $N2FB18COMCONNECTIONPOINTE {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB18COMCONNECTIONPOINTE ) == 8 );
struct $N2FB27COMCONNECTIONPOINTCONTAINERE {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB27COMCONNECTIONPOINTCONTAINERE ) == 8 );
struct $N2FB17COMOBJECTWITHSITEE {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB17COMOBJECTWITHSITEE ) == 8 );
struct $9IUnknown_;
typedef int32 (*tmp$276)( struct $9IUnknown_*, struct $5_GUID*, void** );
typedef uint32 (*tmp$277)( struct $9IUnknown_* );
struct $12IUnknownVtbl {
	tmp$276 QUERYINTERFACE;
	tmp$277 ADDREF;
	tmp$277 RELEASE;
};
__FB_STATIC_ASSERT( sizeof( struct $12IUnknownVtbl ) == 24 );
struct $9IUnknown_ {
	struct $12IUnknownVtbl* LPVTBL;
};
__FB_STATIC_ASSERT( sizeof( struct $9IUnknown_ ) == 8 );
typedef uint32 (*tmp$2081)( struct $N2FB10COMUNKNOWNE* );
struct $8FAKEVTBL {
	void* QUERYINTERFACE;
	void* ADDREF;
	void* RELEASE;
	void* POKE;
};
__FB_STATIC_ASSERT( sizeof( struct $8FAKEVTBL ) == 32 );
struct $4FAKE {
	struct $8FAKEVTBL* LPVTBL;
	int32 REFS;
};
__FB_STATIC_ASSERT( sizeof( struct $4FAKE ) == 16 );
struct $6SPYOBJ {
	struct $7SPYVTBL* LPVTBL;
};
__FB_STATIC_ASSERT( sizeof( struct $6SPYOBJ ) == 8 );
void _ZN10fb_Object$C1Ev( struct $10fb_Object$* );
void* fb_ErrorThrowEx( int32, int32, char*, void*, void* );
void fb_Assert( char*, int64, char*, char* );
void* calloc( uint64, uint64 );
void free( void* );
void fb_PrintString( int32, FBSTRING*, int32 );
FBSTRING* fb_StrAllocTempDescZEx( char*, int64 );
int64 fb_WstrLen( uint16* );
static void fb_ctor__comptrzcompanions( void ) __attribute__(( constructor ));
int32 memcmp( void*, void*, uint64 );
int64 _InterlockedExchangeAdd64( int64*, int64 );
int32 _InterlockedExchangeAdd( int32*, int32 );
void CoUninitialize( void );
int32 CoInitializeEx( void*, uint32 );
int32 CoCreateInstance( struct $5_GUID*, struct $9IUnknown_*, uint32, struct $5_GUID*, void** );
void* CoTaskMemAlloc( uint64 );
void CoTaskMemFree( void* );
int32 CoRegisterMallocSpy( struct $11IMallocSpy_* );
int32 CoRevokeMallocSpy( void );
static void _ZN2FB10COMUNKNOWNC1Ev( struct $N2FB10COMUNKNOWNE* );
static void _ZN2FB10COMUNKNOWNaSERKS0_( struct $N2FB10COMUNKNOWNE*, struct $N2FB10COMUNKNOWNE* );
static void _ZN2FB11COMDISPATCHaSERKS0_( struct $N2FB11COMDISPATCHE*, struct $N2FB11COMDISPATCHE* );
static struct $N2FB10COMUNKNOWNE* _ZN2FB6HASUNKEPv( void* );
static struct $5_GUID* _ZN2FB11HIIDUNKNOWNEv( void );
static void* _ZN2FB10HCANONICALEPNS_10COMUNKNOWNE( struct $N2FB10COMUNKNOWNE* );
static void _ZN2FB7COMINITC1Ej( struct $N2FB7COMINITE*, uint32 );
static void _ZN2FB7COMINITD1Ev( struct $N2FB7COMINITE* );
static boolean _ZN2FB7COMINIT2OKEv( struct $N2FB7COMINITE* );
static boolean _ZN2FB7COMINIT8ISFAILEDEv( struct $N2FB7COMINITE* );
static void _ZN2FB18COMCONNECTIONPOINTaSERKS0_( struct $N2FB18COMCONNECTIONPOINTE*, struct $N2FB18COMCONNECTIONPOINTE* );
static void _ZN2FB27COMCONNECTIONPOINTCONTAINERaSERKS0_( struct $N2FB27COMCONNECTIONPOINTCONTAINERE*, struct $N2FB27COMCONNECTIONPOINTCONTAINERE* );
static void _ZN2FB17COMOBJECTWITHSITEaSERKS0_( struct $N2FB17COMOBJECTWITHSITEE*, struct $N2FB17COMOBJECTWITHSITEE* );
static struct $5_GUID* _ZN2FB22HIIDCONNPOINTCONTAINEREv( void );
static struct $5_GUID* _ZN2FB18HIIDOBJECTWITHSITEEv( void );
static int32 _ZN2FB9COMADVISEEPvS0_PK5_GUIDRj( void*, void*, struct $5_GUID*, uint32* );
static int32 _ZN2FB11COMUNADVISEEPvPK5_GUIDj( void*, struct $5_GUID*, uint32 );
static int32 _ZN2FB10COMSETSITEEPvS0_( void*, void* );
static int32 COMISALIVE( void );
static void _ZN5IFAKEaSERKS_( struct $5IFAKE*, struct $5IFAKE* );
static int32 FQI( struct $4FAKE*, struct $5_GUID*, void** );
static uint32 FADDREF( struct $4FAKE* );
static uint32 FRELEASE( struct $4FAKE* );
static int32 FPOKE( struct $4FAKE* );
static struct $5IFAKE* NEWFAKE( void );
static void _ZN6ComPtrI5IFAKEEC1Ev( struct $6ComPtrI5IFAKEE* );
static void _ZN6ComPtrI5IFAKEED1Ev( struct $6ComPtrI5IFAKEE* );
static void _ZN6ComPtrI5IFAKEE6ATTACHEPS0_( struct $6ComPtrI5IFAKEE*, struct $5IFAKE* );
static void _ZN6ComPtrI5IFAKEE7RELEASEEv( struct $6ComPtrI5IFAKEE* );
static struct $5IFAKE* _ZptR6ComPtrI5IFAKEE( struct $6ComPtrI5IFAKEE* );
static int32 SPYQI( struct $6SPYOBJ*, struct $5_GUID*, void** );
static uint32 SPYADDREF( struct $6SPYOBJ* );
static uint32 SPYRELEASE( struct $6SPYOBJ* );
static uint64 SPYPREALLOC( struct $6SPYOBJ*, uint64 );
static void* SPYPOSTALLOC( struct $6SPYOBJ*, void* );
static void* SPYPREFREE( struct $6SPYOBJ*, void*, int32 );
static void SPYPOSTFREE( struct $6SPYOBJ*, int32 );
static uint64 SPYPREREALLOC( struct $6SPYOBJ*, void*, uint64, void**, int32 );
static void* SPYPOSTREALLOC( struct $6SPYOBJ*, void*, int32 );
static void* SPYPREGETSIZE( struct $6SPYOBJ*, void*, int32 );
static uint64 SPYPOSTGETSIZE( struct $6SPYOBJ*, uint64, int32 );
static void* SPYPREDIDALLOC( struct $6SPYOBJ*, void*, int32 );
static int32 SPYPOSTDIDALLOC( struct $6SPYOBJ*, void*, int32, int32 );
static void SPYPREHEAPMINIMIZE( struct $6SPYOBJ* );
static void SPYPOSTHEAPMINIMIZE( struct $6SPYOBJ* );
static void _ZN10ComHeapPtrItEC1Ev( struct $10ComHeapPtrItE* );
static void _ZN10ComHeapPtrItED1Ev( struct $10ComHeapPtrItE* );
static uint16* _ZN10ComHeapPtrItE3GETEv( struct $10ComHeapPtrItE* );
static boolean _ZN10ComHeapPtrItE6ISNULLEv( struct $10ComHeapPtrItE* );
static void _ZN10ComHeapPtrItE6ATTACHEPt( struct $10ComHeapPtrItE*, uint16* );
static uint16* _ZN10ComHeapPtrItE6DETACHEv( struct $10ComHeapPtrItE* );
static void _ZN10ComHeapPtrItE4FREEEv( struct $10ComHeapPtrItE* );
static uint16** _ZN10ComHeapPtrItE6PUTREFEv( struct $10ComHeapPtrItE* );
static boolean _ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( struct $10ComHeapPtrItE*, uint64 );
static void _ZN11ISHELLITEM_aSERKS_( struct $11ISHELLITEM_*, struct $11ISHELLITEM_* );
int32 SHCreateItemFromParsingName( uint16*, void*, struct $5_GUID*, void** );
static void _ZN6ComPtrI11ISHELLITEM_EC1Ev( struct $6ComPtrI11ISHELLITEM_E* );
static void _ZN6ComPtrI11ISHELLITEM_ED1Ev( struct $6ComPtrI11ISHELLITEM_E* );
static boolean _ZN6ComPtrI11ISHELLITEM_E6ISNULLEv( struct $6ComPtrI11ISHELLITEM_E* );
static void _ZN6ComPtrI11ISHELLITEM_E7RELEASEEv( struct $6ComPtrI11ISHELLITEM_E* );
static struct $11ISHELLITEM_** _ZN6ComPtrI11ISHELLITEM_E6PUTREFEv( struct $6ComPtrI11ISHELLITEM_E* );
static struct $11ISHELLITEM_* _ZptR6ComPtrI11ISHELLITEM_E( struct $6ComPtrI11ISHELLITEM_E* );
static uint32 SRCADDREF( struct $3SRC* );
static uint32 SRCRELEASE( struct $3SRC* );
static int32 SRCQI( struct $3SRC*, struct $5_GUID*, void** );
static int32 SRCFIND( struct $3SRC*, struct $5_GUID*, void** );
static int32 SRCENUMCP( struct $3SRC*, void** );
static int32 CPQI( struct $5CPOBJ*, struct $5_GUID*, void** );
static uint32 CPADDREF( struct $5CPOBJ* );
static uint32 CPRELEASE( struct $5CPOBJ* );
static int32 CPADVISE( struct $5CPOBJ*, void*, uint32* );
static int32 CPUNADVISE( struct $5CPOBJ*, uint32 );
static int32 CPGETIFACE( struct $5CPOBJ*, struct $5_GUID* );
static int32 CPGETCPC( struct $5CPOBJ*, void** );
static int32 CPENUM( struct $5CPOBJ*, void** );
struct $8fb_RTTI$;
struct $8fb_RTTI$ {
	void* STDLIBVTABLE;
	char* ID;
	struct $8fb_RTTI$* RTTIBASE;
};
__FB_STATIC_ASSERT( sizeof( struct $8fb_RTTI$ ) == 24 );
extern struct $8fb_RTTI$ __fb_ZTS6Object;
static struct $8fb_RTTI$ _ZTSN2FB10COMUNKNOWNE = { (void*)0ull, (char*)"N2FB10COMUNKNOWNE", &__fb_ZTS6Object };
static void* _ZTVN2FB10COMUNKNOWNE[5] = { (void*)0ull, (void*)&_ZTSN2FB10COMUNKNOWNE, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8fb_RTTI$ _ZTSN2FB11COMDISPATCHE = { (void*)0ull, (char*)"N2FB11COMDISPATCHE", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN2FB11COMDISPATCHE[9] = { (void*)0ull, (void*)&_ZTSN2FB11COMDISPATCHE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8fb_RTTI$ _ZTSN2FB18COMCONNECTIONPOINTE = { (void*)0ull, (char*)"N2FB18COMCONNECTIONPOINTE", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN2FB18COMCONNECTIONPOINTE[10] = { (void*)0ull, (void*)&_ZTSN2FB18COMCONNECTIONPOINTE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8fb_RTTI$ _ZTSN2FB27COMCONNECTIONPOINTCONTAINERE = { (void*)0ull, (char*)"N2FB27COMCONNECTIONPOINTCONTAINERE", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN2FB27COMCONNECTIONPOINTCONTAINERE[7] = { (void*)0ull, (void*)&_ZTSN2FB27COMCONNECTIONPOINTCONTAINERE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8fb_RTTI$ _ZTSN2FB17COMOBJECTWITHSITEE = { (void*)0ull, (char*)"N2FB17COMOBJECTWITHSITEE", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN2FB17COMOBJECTWITHSITEE[7] = { (void*)0ull, (void*)&_ZTSN2FB17COMOBJECTWITHSITEE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $5_GUID CLSID_SHELLLINK_$ = { 136193u, (uint16)0u, (uint16)0u, { (uint8)192u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)70u } };
static struct $5_GUID IID_IUNKNOWN_$ = { 0u, (uint16)0u, (uint16)0u, { (uint8)192u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)70u } };
static struct $8fb_RTTI$ _ZTSN5IFAKEE = { (void*)0ull, (char*)"5IFAKE", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN5IFAKEE[6] = { (void*)0ull, (void*)&_ZTSN5IFAKEE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8FAKEVTBL G_VTBL$;
static int32 G_DESTROYED$;
static int32 G_HRSEENBYRELEASE$;
static struct $7SPYVTBL G_SPYVTBL$;
static struct $6SPYOBJ G_SPY$;
static int32 G_ALLOCS$;
static int32 G_FREES$;
static struct $8fb_RTTI$ _ZTSN11ISHELLITEM_E = { (void*)0ull, (char*)"11ISHELLITEM_", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN11ISHELLITEM_E[10] = { (void*)0ull, (void*)&_ZTSN11ISHELLITEM_E, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $5_GUID IID_ISHELLITEM_$ = { 1132621086u, (uint16)59160u, (uint16)17134u, { (uint8)188u, (uint8)85u, (uint8)161u, (uint8)226u, (uint8)97u, (uint8)195u, (uint8)123u, (uint8)254u } };
static struct $7CPCVTBL G_CPCVTBL$;
static struct $6CPVTBL G_CPVTBL$;
static struct $5_GUID IID_SINK$ = { 2576941056u, (uint16)1u, (uint16)2u, { (uint8)1u, (uint8)2u, (uint8)3u, (uint8)4u, (uint8)5u, (uint8)6u, (uint8)7u, (uint8)8u } };
static struct $5_GUID IID_OTHER$ = { 2863267840u, (uint16)1u, (uint16)2u, { (uint8)1u, (uint8)2u, (uint8)3u, (uint8)4u, (uint8)5u, (uint8)6u, (uint8)7u, (uint8)8u } };

static void _ZN6ComPtrI5IFAKEEC1Ev( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	label$169:;
	__builtin_memset( (struct $5IFAKE**)THIS$1, 0, 8ll );
	*(struct $5IFAKE**)THIS$1 = (struct $5IFAKE*)0ull;
	label$170:;
}

static void _ZN6ComPtrI5IFAKEEC1EPS0_( struct $6ComPtrI5IFAKEE* THIS$1, struct $5IFAKE* RAW$1 )
{
	label$171:;
	__builtin_memset( (struct $5IFAKE**)THIS$1, 0, 8ll );
	*(struct $5IFAKE**)THIS$1 = RAW$1;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$174;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2104Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2104Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$174:;
	}
	label$172:;
}

static void _ZN6ComPtrI5IFAKEEC1ERS1_( struct $6ComPtrI5IFAKEE* THIS$1, struct $6ComPtrI5IFAKEE* RHS$1 )
{
	label$175:;
	__builtin_memset( (struct $5IFAKE**)THIS$1, 0, 8ll );
	*(struct $5IFAKE**)THIS$1 = *(struct $5IFAKE**)RHS$1;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$178;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2105Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2105Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$178:;
	}
	label$176:;
}

static void _ZN6ComPtrI5IFAKEED1Ev( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	label$179:;
	_ZN6ComPtrI5IFAKEE7RELEASEEv( THIS$1 );
	label$180:;
}

static void _ZN6ComPtrI5IFAKEEaSERS1_( struct $6ComPtrI5IFAKEE* THIS$1, struct $6ComPtrI5IFAKEE* RHS$1 )
{
	label$181:;
	if( *(struct $5IFAKE**)THIS$1 != *(struct $5IFAKE**)RHS$1) goto label$184;
	{
		goto label$182;
		label$184:;
	}
	struct $5IFAKE* OLD$1;
	OLD$1 = *(struct $5IFAKE**)THIS$1;
	*(struct $5IFAKE**)THIS$1 = *(struct $5IFAKE**)RHS$1;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$186;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2106Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2106Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$186:;
	}
	if( OLD$1 == (struct $5IFAKE*)0ull) goto label$188;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2107Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2107Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$188:;
	}
	label$182:;
}

static struct $5IFAKE* _ZN6ComPtrI5IFAKEE3GETEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$189:;
	fb$result$1 = *(struct $5IFAKE**)THIS$1;
	goto label$190;
	label$190:;
	return fb$result$1;
}

static struct $5IFAKE* _ZN6ComPtrI5IFAKEE3REFEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$191:;
	if( *(struct $5IFAKE**)THIS$1 != (struct $5IFAKE*)0ull) goto label$194;
	{
		label$195:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$196:;
	}
	label$194:;
	label$193:;
	fb$result$1 = *(struct $5IFAKE**)THIS$1;
	goto label$192;
	label$192:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI5IFAKEE6ISNULLEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$197:;
	fb$result$1 = (boolean)((int64)-(*(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) != 0ll);
	goto label$198;
	label$198:;
	return fb$result$1;
}

static void _ZN6ComPtrI5IFAKEE6ATTACHEPS0_( struct $6ComPtrI5IFAKEE* THIS$1, struct $5IFAKE* RAW$1 )
{
	label$199:;
	_ZN6ComPtrI5IFAKEE7RELEASEEv( THIS$1 );
	*(struct $5IFAKE**)THIS$1 = RAW$1;
	label$200:;
}

static struct $5IFAKE* _ZN6ComPtrI5IFAKEE6DETACHEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$201:;
	struct $5IFAKE* R$1;
	R$1 = *(struct $5IFAKE**)THIS$1;
	*(struct $5IFAKE**)THIS$1 = (struct $5IFAKE*)0ull;
	fb$result$1 = R$1;
	goto label$202;
	label$202:;
	return fb$result$1;
}

static void _ZN6ComPtrI5IFAKEE7RELEASEEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	label$203:;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$206;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $5IFAKE**)THIS$1 = (struct $5IFAKE*)0ull;
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2109Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2109Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$206:;
	label$205:;
	label$204:;
}

static int32 _ZN6ComPtrI5IFAKEE6COPYTOEPPS0_( struct $6ComPtrI5IFAKEE* THIS$1, struct $5IFAKE** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$207:;
	if( PP$1 != (struct $5IFAKE**)0ull) goto label$210;
	{
		fb$result$1 = -2147467261;
		goto label$208;
		label$210:;
	}
	*PP$1 = *(struct $5IFAKE**)THIS$1;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$212;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2110Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2110Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$212:;
	}
	fb$result$1 = 0;
	goto label$208;
	label$208:;
	return fb$result$1;
}

static struct $5IFAKE** _ZN6ComPtrI5IFAKEE6PUTREFEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $5IFAKE** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$213:;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$216;
	{
		label$217:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$218:;
		label$216:;
	}
	fb$result$1 = (struct $5IFAKE**)THIS$1;
	goto label$214;
	label$214:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI5IFAKEE7UNKNOWNEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$219:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$220;
	label$220:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI5IFAKEE13ISEQUALOBJECTEPv( struct $6ComPtrI5IFAKEE* THIS$1, void* OTHER$1 )
{
	int64 TMP$2111$1;
	int64 TMP$2112$1;
	int64 TMP$2113$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$221:;
	if( *(struct $5IFAKE**)THIS$1 != (struct $5IFAKE*)0ull) goto label$223;
	TMP$2111$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$234;
	label$223:;
	TMP$2111$1 = 0ll;
	label$234:;
	if( TMP$2111$1 == 0ll) goto label$225;
	{
		fb$result$1 = (boolean)1ll;
		goto label$222;
		label$225:;
	}
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$226;
	TMP$2112$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$235;
	label$226:;
	TMP$2112$1 = -1ll;
	label$235:;
	if( TMP$2112$1 == 0ll) goto label$228;
	{
		fb$result$1 = (boolean)0ll;
		goto label$222;
		label$228:;
	}
	void* A$1;
	struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	void* vr$7 = _ZN2FB10HCANONICALEPNS_10COMUNKNOWNE( vr$6 );
	A$1 = vr$7;
	void* B$1;
	struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( OTHER$1 );
	void* vr$9 = _ZN2FB10HCANONICALEPNS_10COMUNKNOWNE( vr$8 );
	B$1 = vr$9;
	boolean SAME$1;
	if( A$1 == (void*)0ull) goto label$229;
	TMP$2113$1 = (int64)-(A$1 == B$1);
	goto label$236;
	label$229:;
	TMP$2113$1 = 0ll;
	label$236:;
	SAME$1 = (boolean)(TMP$2113$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$231;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2114Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2114Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$231:;
	}
	if( B$1 == (void*)0ull) goto label$233;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2115Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2115Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$233:;
	}
	fb$result$1 = SAME$1;
	goto label$222;
	label$222:;
	return fb$result$1;
}

static struct $5IFAKE* _ZptR6ComPtrI5IFAKEE( struct $6ComPtrI5IFAKEE* H$1 )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$237:;
	fb$result$1 = *(struct $5IFAKE**)H$1;
	goto label$238;
	label$238:;
	return fb$result$1;
}

static void _ZN10ComHeapPtrItEC1Ev( struct $10ComHeapPtrItE* THIS$1 )
{
	label$321:;
	__builtin_memset( (uint16**)THIS$1, 0, 8ll );
	*(uint16**)THIS$1 = (uint16*)0ull;
	label$322:;
}

static void _ZN10ComHeapPtrItEC1ERS0_( struct $10ComHeapPtrItE* THIS$1, struct $10ComHeapPtrItE* RHS$1 )
{
	__builtin_memset( (uint16**)THIS$1, 0, 8ll );
	label$323:;
	label$324:;
}

static void _ZN10ComHeapPtrItEaSERS0_( struct $10ComHeapPtrItE* THIS$1, struct $10ComHeapPtrItE* RHS$1 )
{
	label$325:;
	label$326:;
}

static void _ZN10ComHeapPtrItED1Ev( struct $10ComHeapPtrItE* THIS$1 )
{
	label$327:;
	_ZN10ComHeapPtrItE4FREEEv( THIS$1 );
	label$328:;
}

static uint16* _ZN10ComHeapPtrItE3GETEv( struct $10ComHeapPtrItE* THIS$1 )
{
	uint16* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$329:;
	fb$result$1 = *(uint16**)THIS$1;
	goto label$330;
	label$330:;
	return fb$result$1;
}

static boolean _ZN10ComHeapPtrItE6ISNULLEv( struct $10ComHeapPtrItE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$331:;
	fb$result$1 = (boolean)((int64)-(*(uint16**)THIS$1 == (uint16*)0ull) != 0ll);
	goto label$332;
	label$332:;
	return fb$result$1;
}

static void _ZN10ComHeapPtrItE6ATTACHEPt( struct $10ComHeapPtrItE* THIS$1, uint16* RAW$1 )
{
	label$333:;
	_ZN10ComHeapPtrItE4FREEEv( THIS$1 );
	*(uint16**)THIS$1 = RAW$1;
	label$334:;
}

static uint16* _ZN10ComHeapPtrItE6DETACHEv( struct $10ComHeapPtrItE* THIS$1 )
{
	uint16* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$335:;
	uint16* R$1;
	R$1 = *(uint16**)THIS$1;
	*(uint16**)THIS$1 = (uint16*)0ull;
	fb$result$1 = R$1;
	goto label$336;
	label$336:;
	return fb$result$1;
}

static void _ZN10ComHeapPtrItE4FREEEv( struct $10ComHeapPtrItE* THIS$1 )
{
	label$337:;
	if( *(uint16**)THIS$1 == (uint16*)0ull) goto label$340;
	{
		void* Q$2;
		Q$2 = (void*)*(uint16**)THIS$1;
		*(uint16**)THIS$1 = (uint16*)0ull;
		CoTaskMemFree( Q$2 );
	}
	label$340:;
	label$339:;
	label$338:;
}

static uint16** _ZN10ComHeapPtrItE6PUTREFEv( struct $10ComHeapPtrItE* THIS$1 )
{
	uint16** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$341:;
	if( *(uint16**)THIS$1 == (uint16*)0ull) goto label$344;
	{
		label$345:;
		void* vr$2 = fb_ErrorThrowEx( 1, 749, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$346:;
		label$344:;
	}
	fb$result$1 = (uint16**)THIS$1;
	goto label$342;
	label$342:;
	return fb$result$1;
}

static boolean _ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( struct $10ComHeapPtrItE* THIS$1, uint64 COUNT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$347:;
	_ZN10ComHeapPtrItE4FREEEv( THIS$1 );
	void* vr$2 = CoTaskMemAlloc( COUNT$1 << (1ull & 63ll) );
	*(uint16**)THIS$1 = (uint16*)vr$2;
	fb$result$1 = (boolean)((int64)-(*(uint16**)THIS$1 != (uint16*)0ull) != 0ll);
	goto label$348;
	label$348:;
	return fb$result$1;
}

static void _ZN6ComPtrI11ISHELLITEM_EC1Ev( struct $6ComPtrI11ISHELLITEM_E* THIS$1 )
{
	label$395:;
	__builtin_memset( (struct $11ISHELLITEM_**)THIS$1, 0, 8ll );
	*(struct $11ISHELLITEM_**)THIS$1 = (struct $11ISHELLITEM_*)0ull;
	label$396:;
}

static void _ZN6ComPtrI11ISHELLITEM_EC1EPS0_( struct $6ComPtrI11ISHELLITEM_E* THIS$1, struct $11ISHELLITEM_* RAW$1 )
{
	label$397:;
	__builtin_memset( (struct $11ISHELLITEM_**)THIS$1, 0, 8ll );
	*(struct $11ISHELLITEM_**)THIS$1 = RAW$1;
	if( *(struct $11ISHELLITEM_**)THIS$1 == (struct $11ISHELLITEM_*)0ull) goto label$400;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI11ISHELLITEM_E8tmp$2156Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI11ISHELLITEM_E8tmp$2156Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$400:;
	}
	label$398:;
}

static void _ZN6ComPtrI11ISHELLITEM_EC1ERS1_( struct $6ComPtrI11ISHELLITEM_E* THIS$1, struct $6ComPtrI11ISHELLITEM_E* RHS$1 )
{
	label$401:;
	__builtin_memset( (struct $11ISHELLITEM_**)THIS$1, 0, 8ll );
	*(struct $11ISHELLITEM_**)THIS$1 = *(struct $11ISHELLITEM_**)RHS$1;
	if( *(struct $11ISHELLITEM_**)THIS$1 == (struct $11ISHELLITEM_*)0ull) goto label$404;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI11ISHELLITEM_E8tmp$2157Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI11ISHELLITEM_E8tmp$2157Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$404:;
	}
	label$402:;
}

static void _ZN6ComPtrI11ISHELLITEM_ED1Ev( struct $6ComPtrI11ISHELLITEM_E* THIS$1 )
{
	label$405:;
	_ZN6ComPtrI11ISHELLITEM_E7RELEASEEv( THIS$1 );
	label$406:;
}

static void _ZN6ComPtrI11ISHELLITEM_EaSERS1_( struct $6ComPtrI11ISHELLITEM_E* THIS$1, struct $6ComPtrI11ISHELLITEM_E* RHS$1 )
{
	label$407:;
	if( *(struct $11ISHELLITEM_**)THIS$1 != *(struct $11ISHELLITEM_**)RHS$1) goto label$410;
	{
		goto label$408;
		label$410:;
	}
	struct $11ISHELLITEM_* OLD$1;
	OLD$1 = *(struct $11ISHELLITEM_**)THIS$1;
	*(struct $11ISHELLITEM_**)THIS$1 = *(struct $11ISHELLITEM_**)RHS$1;
	if( *(struct $11ISHELLITEM_**)THIS$1 == (struct $11ISHELLITEM_*)0ull) goto label$412;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI11ISHELLITEM_E8tmp$2158Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI11ISHELLITEM_E8tmp$2158Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$412:;
	}
	if( OLD$1 == (struct $11ISHELLITEM_*)0ull) goto label$414;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI11ISHELLITEM_E8tmp$2159Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI11ISHELLITEM_E8tmp$2159Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$414:;
	}
	label$408:;
}

static struct $11ISHELLITEM_* _ZN6ComPtrI11ISHELLITEM_E3GETEv( struct $6ComPtrI11ISHELLITEM_E* THIS$1 )
{
	struct $11ISHELLITEM_* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$415:;
	fb$result$1 = *(struct $11ISHELLITEM_**)THIS$1;
	goto label$416;
	label$416:;
	return fb$result$1;
}

static struct $11ISHELLITEM_* _ZN6ComPtrI11ISHELLITEM_E3REFEv( struct $6ComPtrI11ISHELLITEM_E* THIS$1 )
{
	struct $11ISHELLITEM_* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$417:;
	if( *(struct $11ISHELLITEM_**)THIS$1 != (struct $11ISHELLITEM_*)0ull) goto label$420;
	{
		label$421:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$422:;
	}
	label$420:;
	label$419:;
	fb$result$1 = *(struct $11ISHELLITEM_**)THIS$1;
	goto label$418;
	label$418:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI11ISHELLITEM_E6ISNULLEv( struct $6ComPtrI11ISHELLITEM_E* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$423:;
	fb$result$1 = (boolean)((int64)-(*(struct $11ISHELLITEM_**)THIS$1 == (struct $11ISHELLITEM_*)0ull) != 0ll);
	goto label$424;
	label$424:;
	return fb$result$1;
}

static void _ZN6ComPtrI11ISHELLITEM_E6ATTACHEPS0_( struct $6ComPtrI11ISHELLITEM_E* THIS$1, struct $11ISHELLITEM_* RAW$1 )
{
	label$425:;
	_ZN6ComPtrI11ISHELLITEM_E7RELEASEEv( THIS$1 );
	*(struct $11ISHELLITEM_**)THIS$1 = RAW$1;
	label$426:;
}

static struct $11ISHELLITEM_* _ZN6ComPtrI11ISHELLITEM_E6DETACHEv( struct $6ComPtrI11ISHELLITEM_E* THIS$1 )
{
	struct $11ISHELLITEM_* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$427:;
	struct $11ISHELLITEM_* R$1;
	R$1 = *(struct $11ISHELLITEM_**)THIS$1;
	*(struct $11ISHELLITEM_**)THIS$1 = (struct $11ISHELLITEM_*)0ull;
	fb$result$1 = R$1;
	goto label$428;
	label$428:;
	return fb$result$1;
}

static void _ZN6ComPtrI11ISHELLITEM_E7RELEASEEv( struct $6ComPtrI11ISHELLITEM_E* THIS$1 )
{
	label$429:;
	if( *(struct $11ISHELLITEM_**)THIS$1 == (struct $11ISHELLITEM_*)0ull) goto label$432;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $11ISHELLITEM_**)THIS$1 = (struct $11ISHELLITEM_*)0ull;
		typedef uint32 (*_ZN6ComPtrI11ISHELLITEM_E8tmp$2160Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI11ISHELLITEM_E8tmp$2160Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$432:;
	label$431:;
	label$430:;
}

static int32 _ZN6ComPtrI11ISHELLITEM_E6COPYTOEPPS0_( struct $6ComPtrI11ISHELLITEM_E* THIS$1, struct $11ISHELLITEM_** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$433:;
	if( PP$1 != (struct $11ISHELLITEM_**)0ull) goto label$436;
	{
		fb$result$1 = -2147467261;
		goto label$434;
		label$436:;
	}
	*PP$1 = *(struct $11ISHELLITEM_**)THIS$1;
	if( *(struct $11ISHELLITEM_**)THIS$1 == (struct $11ISHELLITEM_*)0ull) goto label$438;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI11ISHELLITEM_E8tmp$2161Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI11ISHELLITEM_E8tmp$2161Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$438:;
	}
	fb$result$1 = 0;
	goto label$434;
	label$434:;
	return fb$result$1;
}

static struct $11ISHELLITEM_** _ZN6ComPtrI11ISHELLITEM_E6PUTREFEv( struct $6ComPtrI11ISHELLITEM_E* THIS$1 )
{
	struct $11ISHELLITEM_** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$439:;
	if( *(struct $11ISHELLITEM_**)THIS$1 == (struct $11ISHELLITEM_*)0ull) goto label$442;
	{
		label$443:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$444:;
		label$442:;
	}
	fb$result$1 = (struct $11ISHELLITEM_**)THIS$1;
	goto label$440;
	label$440:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI11ISHELLITEM_E7UNKNOWNEv( struct $6ComPtrI11ISHELLITEM_E* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$445:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$446;
	label$446:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI11ISHELLITEM_E13ISEQUALOBJECTEPv( struct $6ComPtrI11ISHELLITEM_E* THIS$1, void* OTHER$1 )
{
	int64 TMP$2162$1;
	int64 TMP$2163$1;
	int64 TMP$2164$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$447:;
	if( *(struct $11ISHELLITEM_**)THIS$1 != (struct $11ISHELLITEM_*)0ull) goto label$449;
	TMP$2162$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$460;
	label$449:;
	TMP$2162$1 = 0ll;
	label$460:;
	if( TMP$2162$1 == 0ll) goto label$451;
	{
		fb$result$1 = (boolean)1ll;
		goto label$448;
		label$451:;
	}
	if( *(struct $11ISHELLITEM_**)THIS$1 == (struct $11ISHELLITEM_*)0ull) goto label$452;
	TMP$2163$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$461;
	label$452:;
	TMP$2163$1 = -1ll;
	label$461:;
	if( TMP$2163$1 == 0ll) goto label$454;
	{
		fb$result$1 = (boolean)0ll;
		goto label$448;
		label$454:;
	}
	void* A$1;
	struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	void* vr$7 = _ZN2FB10HCANONICALEPNS_10COMUNKNOWNE( vr$6 );
	A$1 = vr$7;
	void* B$1;
	struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( OTHER$1 );
	void* vr$9 = _ZN2FB10HCANONICALEPNS_10COMUNKNOWNE( vr$8 );
	B$1 = vr$9;
	boolean SAME$1;
	if( A$1 == (void*)0ull) goto label$455;
	TMP$2164$1 = (int64)-(A$1 == B$1);
	goto label$462;
	label$455:;
	TMP$2164$1 = 0ll;
	label$462:;
	SAME$1 = (boolean)(TMP$2164$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$457;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI11ISHELLITEM_E8tmp$2165Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI11ISHELLITEM_E8tmp$2165Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$457:;
	}
	if( B$1 == (void*)0ull) goto label$459;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI11ISHELLITEM_E8tmp$2166Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI11ISHELLITEM_E8tmp$2166Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$459:;
	}
	fb$result$1 = SAME$1;
	goto label$448;
	label$448:;
	return fb$result$1;
}

static struct $11ISHELLITEM_* _ZptR6ComPtrI11ISHELLITEM_E( struct $6ComPtrI11ISHELLITEM_E* H$1 )
{
	struct $11ISHELLITEM_* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$463:;
	fb$result$1 = *(struct $11ISHELLITEM_**)H$1;
	goto label$464;
	label$464:;
	return fb$result$1;
}

__attribute__(( constructor )) static void fb_ctor__comptrzcompanions( void )
{
	label$0:;
	*(void**)&G_VTBL$ = (void*)&FQI;
	*(void**)((uint8*)&G_VTBL$ + 8ll) = (void*)&FADDREF;
	*(void**)((uint8*)&G_VTBL$ + 16ll) = (void*)&FRELEASE;
	*(void**)((uint8*)&G_VTBL$ + 24ll) = (void*)&FPOKE;
	{
		struct $N2FB7COMINITE CO$1;
		_ZN2FB7COMINITC1Ej( &CO$1, 2u );
		boolean vr$2 = _ZN2FB7COMINIT2OKEv( &CO$1 );
		if( (int64)-(boolean)(vr$2 == (boolean)1ll) != 0ll) goto label$140;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 100ll, (char*)"__FB_MODLEVELPROC__", (char*)"co.Ok( ) = TRUE" );
			label$140:;
		}
		boolean vr$6 = _ZN2FB7COMINIT8ISFAILEDEv( &CO$1 );
		if( (int64)-(boolean)(vr$6 == (boolean)0ll) != 0ll) goto label$142;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 101ll, (char*)"__FB_MODLEVELPROC__", (char*)"co.IsFailed( ) = FALSE" );
			label$142:;
		}
		if( (int64)*(int32*)&CO$1 == 0ll) goto label$144;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 102ll, (char*)"__FB_MODLEVELPROC__", (char*)"co.hr = S_OK" );
			label$144:;
		}
		int32 vr$10 = COMISALIVE(  );
		if( (int64)vr$10 == 0ll) goto label$146;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 103ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComIsAlive( ) = S_OK" );
			label$146:;
		}
		{
			struct $N2FB7COMINITE INNER$2;
			_ZN2FB7COMINITC1Ej( &INNER$2, 2u );
			if( (int64)*(int32*)&INNER$2 == 1ll) goto label$148;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 110ll, (char*)"__FB_MODLEVELPROC__", (char*)"inner.hr = S_FALSE" );
				label$148:;
			}
			boolean vr$15 = _ZN2FB7COMINIT2OKEv( &INNER$2 );
			if( (int64)-(boolean)(vr$15 == (boolean)1ll) != 0ll) goto label$150;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 111ll, (char*)"__FB_MODLEVELPROC__", (char*)"inner.Ok( ) = TRUE" );
				label$150:;
			}
			boolean vr$19 = _ZN2FB7COMINIT8ISFAILEDEv( &INNER$2 );
			if( (int64)-(boolean)(vr$19 == (boolean)0ll) != 0ll) goto label$152;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 112ll, (char*)"__FB_MODLEVELPROC__", (char*)"inner.IsFailed( ) = FALSE" );
				label$152:;
			}
			_ZN2FB7COMINITD1Ev( &INNER$2 );
		}
		int32 vr$23 = COMISALIVE(  );
		if( (int64)vr$23 == 0ll) goto label$154;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 114ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComIsAlive( ) = S_OK" );
			label$154:;
		}
		{
			struct $N2FB7COMINITE WRONG$2;
			_ZN2FB7COMINITC1Ej( &WRONG$2, 0u );
			if( (int64)*(int32*)&WRONG$2 == -2147417850ll) goto label$156;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 120ll, (char*)"__FB_MODLEVELPROC__", (char*)"wrong.hr = cast( HRESULT, &h80010106 )" );
				label$156:;
			}
			boolean vr$28 = _ZN2FB7COMINIT2OKEv( &WRONG$2 );
			if( (int64)-(boolean)(vr$28 == (boolean)0ll) != 0ll) goto label$158;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 121ll, (char*)"__FB_MODLEVELPROC__", (char*)"wrong.Ok( ) = FALSE" );
				label$158:;
			}
			boolean vr$32 = _ZN2FB7COMINIT8ISFAILEDEv( &WRONG$2 );
			if( (int64)-(boolean)(vr$32 == (boolean)1ll) != 0ll) goto label$160;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 122ll, (char*)"__FB_MODLEVELPROC__", (char*)"wrong.IsFailed( ) = TRUE" );
				label$160:;
			}
			_ZN2FB7COMINITD1Ev( &WRONG$2 );
		}
		int32 vr$36 = COMISALIVE(  );
		if( (int64)vr$36 == 0ll) goto label$162;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 124ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComIsAlive( ) = S_OK" );
			label$162:;
		}
		_ZN2FB7COMINITD1Ev( &CO$1 );
	}
	int32 vr$39 = COMISALIVE(  );
	if( (int64)vr$39 == -2147221008ll) goto label$164;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 128ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComIsAlive( ) = cast( HRESULT, &h800401F0 )" );
		label$164:;
	}
	G_DESTROYED$ = 0;
	G_HRSEENBYRELEASE$ = -1;
	{
		struct $N2FB7COMINITE CO$1;
		_ZN2FB7COMINITC1Ej( &CO$1, 2u );
		boolean vr$43 = _ZN2FB7COMINIT2OKEv( &CO$1 );
		if( (int64)-vr$43 != 0ll) goto label$166;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 136ll, (char*)"__FB_MODLEVELPROC__", (char*)"co.Ok( )" );
			label$166:;
		}
		struct $6ComPtrI5IFAKEE P$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &P$1 );
		struct $5IFAKE* vr$46 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &P$1, vr$46 );
		struct $5IFAKE* vr$49 = _ZptR6ComPtrI5IFAKEE( &P$1 );
		struct $5IFAKE* vr$52 = _ZptR6ComPtrI5IFAKEE( &P$1 );
		int32 vr$50 = (*(tmp$2102*)((uint8*)*(void***)vr$52 + 24ll))( vr$49 );
		if( (int64)vr$50 == 1ll) goto label$168;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 139ll, (char*)"__FB_MODLEVELPROC__", (char*)"p->Poke( ) = 1" );
			label$168:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &P$1 );
		_ZN2FB7COMINITD1Ev( &CO$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$240;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 141ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$240:;
	}
	if( (int64)G_HRSEENBYRELEASE$ == 0ll) goto label$242;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 142ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_hrSeenByRelease = S_OK" );
		label$242:;
	}
	G_DESTROYED$ = 0;
	G_HRSEENBYRELEASE$ = -1;
	{
		struct $6ComPtrI5IFAKEE P$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &P$1 );
		struct $5IFAKE* vr$60 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &P$1, vr$60 );
		{
			struct $N2FB7COMINITE CO$2;
			_ZN2FB7COMINITC1Ej( &CO$2, 2u );
			boolean vr$64 = _ZN2FB7COMINIT2OKEv( &CO$2 );
			if( (int64)-vr$64 != 0ll) goto label$244;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 158ll, (char*)"__FB_MODLEVELPROC__", (char*)"co.Ok( )" );
				label$244:;
			}
			int32 vr$66 = COMISALIVE(  );
			if( (int64)vr$66 == 0ll) goto label$246;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 159ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComIsAlive( ) = S_OK" );
				label$246:;
			}
			_ZN2FB7COMINITD1Ev( &CO$2 );
		}
		_ZN6ComPtrI5IFAKEED1Ev( &P$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$248;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 162ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$248:;
	}
	if( (int64)G_HRSEENBYRELEASE$ == -2147221008ll) goto label$250;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 163ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_hrSeenByRelease = cast( HRESULT, &h800401F0 )" );
		label$250:;
	}
	*(void**)&G_SPYVTBL$ = (void*)&SPYQI;
	*(void**)((uint8*)&G_SPYVTBL$ + 8ll) = (void*)&SPYADDREF;
	*(void**)((uint8*)&G_SPYVTBL$ + 16ll) = (void*)&SPYRELEASE;
	*(void**)((uint8*)&G_SPYVTBL$ + 24ll) = (void*)&SPYPREALLOC;
	*(void**)((uint8*)&G_SPYVTBL$ + 32ll) = (void*)&SPYPOSTALLOC;
	*(void**)((uint8*)&G_SPYVTBL$ + 40ll) = (void*)&SPYPREFREE;
	*(void**)((uint8*)&G_SPYVTBL$ + 48ll) = (void*)&SPYPOSTFREE;
	*(void**)((uint8*)&G_SPYVTBL$ + 56ll) = (void*)&SPYPREREALLOC;
	*(void**)((uint8*)&G_SPYVTBL$ + 64ll) = (void*)&SPYPOSTREALLOC;
	*(void**)((uint8*)&G_SPYVTBL$ + 72ll) = (void*)&SPYPREGETSIZE;
	*(void**)((uint8*)&G_SPYVTBL$ + 80ll) = (void*)&SPYPOSTGETSIZE;
	*(void**)((uint8*)&G_SPYVTBL$ + 88ll) = (void*)&SPYPREDIDALLOC;
	*(void**)((uint8*)&G_SPYVTBL$ + 96ll) = (void*)&SPYPOSTDIDALLOC;
	*(void**)((uint8*)&G_SPYVTBL$ + 104ll) = (void*)&SPYPREHEAPMINIMIZE;
	*(void**)((uint8*)&G_SPYVTBL$ + 112ll) = (void*)&SPYPOSTHEAPMINIMIZE;
	*(struct $7SPYVTBL**)&G_SPY$ = &G_SPYVTBL$;
	{
		int32 vr$72 = CoRegisterMallocSpy( (struct $11IMallocSpy_*)&G_SPY$ );
		if( (int64)vr$72 == 0ll) goto label$288;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 247ll, (char*)"__FB_MODLEVELPROC__", (char*)"CoRegisterMallocSpy( cptr( IMallocSpy ptr, cast( any ptr, @g_spy ) ) ) = S_OK" );
			label$288:;
		}
		G_ALLOCS$ = 0;
		G_FREES$ = 0;
		{
			struct $10ComHeapPtrItE H$2;
			_ZN10ComHeapPtrItEC1Ev( &H$2 );
			boolean vr$76 = _ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( &H$2, 32ull );
			if( (int64)-(boolean)(vr$76 == (boolean)1ll) != 0ll) goto label$290;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 253ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.Alloc( 32 ) = TRUE" );
				label$290:;
			}
			if( (int64)G_ALLOCS$ == 1ll) goto label$292;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 254ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_allocs = 1" );
				label$292:;
			}
			if( (int64)G_FREES$ == 0ll) goto label$294;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 255ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 0" );
				label$294:;
			}
			_ZN10ComHeapPtrItED1Ev( &H$2 );
		}
		if( (int64)G_FREES$ == 1ll) goto label$296;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 257ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 1" );
			label$296:;
		}
		G_ALLOCS$ = 0;
		G_FREES$ = 0;
		{
			struct $10ComHeapPtrItE H$2;
			_ZN10ComHeapPtrItEC1Ev( &H$2 );
			_ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( &H$2, 32ull );
			_ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( &H$2, 8ull );
			if( (int64)G_ALLOCS$ == 2ll) goto label$298;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 265ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_allocs = 2" );
				label$298:;
			}
			if( (int64)G_FREES$ == 1ll) goto label$300;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 266ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 1" );
				label$300:;
			}
			_ZN10ComHeapPtrItED1Ev( &H$2 );
		}
		if( (int64)G_FREES$ == 2ll) goto label$302;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 268ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 2" );
			label$302:;
		}
		G_ALLOCS$ = 0;
		G_FREES$ = 0;
		{
			struct $10ComHeapPtrItE H$2;
			_ZN10ComHeapPtrItEC1Ev( &H$2 );
			_ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( &H$2, 16ull );
			void* vr$92 = CoTaskMemAlloc( 8ull );
			_ZN10ComHeapPtrItE6ATTACHEPt( &H$2, (uint16*)vr$92 );
			if( (int64)G_ALLOCS$ == 2ll) goto label$304;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 276ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_allocs = 2" );
				label$304:;
			}
			if( (int64)G_FREES$ == 1ll) goto label$306;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 277ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 1" );
				label$306:;
			}
			_ZN10ComHeapPtrItED1Ev( &H$2 );
		}
		if( (int64)G_FREES$ == 2ll) goto label$308;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 279ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 2" );
			label$308:;
		}
		G_ALLOCS$ = 0;
		G_FREES$ = 0;
		uint16* DETACHED$1;
		__builtin_memset( &DETACHED$1, 0, 8ll );
		{
			struct $10ComHeapPtrItE H$2;
			_ZN10ComHeapPtrItEC1Ev( &H$2 );
			_ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( &H$2, 16ull );
			uint16* vr$102 = _ZN10ComHeapPtrItE6DETACHEv( &H$2 );
			DETACHED$1 = vr$102;
			if( (int64)G_FREES$ == 0ll) goto label$310;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 288ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 0" );
				label$310:;
			}
			_ZN10ComHeapPtrItED1Ev( &H$2 );
		}
		if( (int64)G_FREES$ == 0ll) goto label$312;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 290ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 0" );
			label$312:;
		}
		CoTaskMemFree( (void*)DETACHED$1 );
		if( (int64)G_FREES$ == 1ll) goto label$314;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 293ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 1" );
			label$314:;
		}
		G_ALLOCS$ = 0;
		G_FREES$ = 0;
		{
			struct $10ComHeapPtrItE H$2;
			_ZN10ComHeapPtrItEC1Ev( &H$2 );
			_ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( &H$2, 16ull );
			_ZN10ComHeapPtrItE4FREEEv( &H$2 );
			_ZN10ComHeapPtrItE4FREEEv( &H$2 );
			if( (int64)G_FREES$ == 1ll) goto label$316;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 302ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 1" );
				label$316:;
			}
			_ZN10ComHeapPtrItED1Ev( &H$2 );
		}
		if( (int64)G_FREES$ == 1ll) goto label$318;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 304ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_frees = 1" );
			label$318:;
		}
		int32 vr$114 = CoRevokeMallocSpy(  );
		if( (int64)vr$114 == 0ll) goto label$320;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 306ll, (char*)"__FB_MODLEVELPROC__", (char*)"CoRevokeMallocSpy( ) = S_OK" );
			label$320:;
		}
	}
	{
		struct $10ComHeapPtrItE H$1;
		_ZN10ComHeapPtrItEC1Ev( &H$1 );
		boolean vr$118 = _ZN10ComHeapPtrItE6ISNULLEv( &H$1 );
		if( (int64)-(boolean)(vr$118 == (boolean)1ll) != 0ll) goto label$350;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 313ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.IsNull( ) = TRUE" );
			label$350:;
		}
		uint16* vr$122 = _ZN10ComHeapPtrItE3GETEv( &H$1 );
		if( vr$122 == (uint16*)0ull) goto label$352;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 314ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.Get( ) = 0" );
			label$352:;
		}
		uint16* vr$124 = _ZN10ComHeapPtrItE6DETACHEv( &H$1 );
		if( vr$124 == (uint16*)0ull) goto label$354;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 315ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.Detach( ) = 0" );
			label$354:;
		}
		_ZN10ComHeapPtrItE4FREEEv( &H$1 );
		boolean vr$127 = _ZN10ComHeapPtrItE6ISNULLEv( &H$1 );
		if( (int64)-(boolean)(vr$127 == (boolean)1ll) != 0ll) goto label$356;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 317ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.IsNull( ) = TRUE" );
			label$356:;
		}
		boolean vr$131 = _ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( &H$1, 32ull );
		if( (int64)-(boolean)(vr$131 == (boolean)1ll) != 0ll) goto label$358;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 319ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.Alloc( 32 ) = TRUE" );
			label$358:;
		}
		boolean vr$135 = _ZN10ComHeapPtrItE6ISNULLEv( &H$1 );
		if( (int64)-(boolean)(vr$135 == (boolean)0ll) != 0ll) goto label$360;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 320ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.IsNull( ) = FALSE" );
			label$360:;
		}
		uint16* vr$139 = _ZN10ComHeapPtrItE3GETEv( &H$1 );
		*vr$139 = (uint16)65u;
		uint16* vr$141 = _ZN10ComHeapPtrItE3GETEv( &H$1 );
		*(uint16*)((uint8*)vr$141 + 2ll) = (uint16)0u;
		uint16* vr$143 = _ZN10ComHeapPtrItE3GETEv( &H$1 );
		if( (uint64)(int64)*vr$143 == 65ull) goto label$362;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 323ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.Get( )[0] = asc( \x22" "A\x22 )" );
			label$362:;
		}
		boolean vr$146 = _ZN10ComHeapPtrItE5ALLOCEu8UINTEGER( &H$1, 8ull );
		if( (int64)-(boolean)(vr$146 == (boolean)1ll) != 0ll) goto label$364;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 326ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.Alloc( 8 ) = TRUE" );
			label$364:;
		}
		boolean vr$150 = _ZN10ComHeapPtrItE6ISNULLEv( &H$1 );
		if( (int64)-(boolean)(vr$150 == (boolean)0ll) != 0ll) goto label$366;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 327ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.IsNull( ) = FALSE" );
			label$366:;
		}
		uint16* RAW$1;
		uint16* vr$154 = _ZN10ComHeapPtrItE6DETACHEv( &H$1 );
		RAW$1 = vr$154;
		boolean vr$156 = _ZN10ComHeapPtrItE6ISNULLEv( &H$1 );
		if( (int64)-(boolean)(vr$156 == (boolean)1ll) != 0ll) goto label$368;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 331ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.IsNull( ) = TRUE" );
			label$368:;
		}
		if( RAW$1 != (uint16*)0ull) goto label$370;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 332ll, (char*)"__FB_MODLEVELPROC__", (char*)"raw <> 0" );
			label$370:;
		}
		CoTaskMemFree( (void*)RAW$1 );
		void* vr$159 = CoTaskMemAlloc( 16ull );
		_ZN10ComHeapPtrItE6ATTACHEPt( &H$1, (uint16*)vr$159 );
		boolean vr$162 = _ZN10ComHeapPtrItE6ISNULLEv( &H$1 );
		if( (int64)-(boolean)(vr$162 == (boolean)0ll) != 0ll) goto label$372;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 337ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.IsNull( ) = FALSE" );
			label$372:;
		}
		_ZN10ComHeapPtrItE4FREEEv( &H$1 );
		boolean vr$167 = _ZN10ComHeapPtrItE6ISNULLEv( &H$1 );
		if( (int64)-(boolean)(vr$167 == (boolean)1ll) != 0ll) goto label$374;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 339ll, (char*)"__FB_MODLEVELPROC__", (char*)"h.IsNull( ) = TRUE" );
			label$374:;
		}
		_ZN10ComHeapPtrItE4FREEEv( &H$1 );
		_ZN10ComHeapPtrItED1Ev( &H$1 );
	}
	{
		struct $10ComHeapPtrItE H$1;
		_ZN10ComHeapPtrItEC1Ev( &H$1 );
		uint16** SLOT$1;
		uint16** vr$174 = _ZN10ComHeapPtrItE6PUTREFEv( &H$1 );
		SLOT$1 = vr$174;
		if( SLOT$1 == (uint16**)&H$1) goto label$376;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 348ll, (char*)"__FB_MODLEVELPROC__", (char*)"slot = @h.p" );
			label$376:;
		}
		_ZN10ComHeapPtrItED1Ev( &H$1 );
	}
	{
		struct $N2FB7COMINITE CO$1;
		_ZN2FB7COMINITC1Ej( &CO$1, 2u );
		boolean vr$179 = _ZN2FB7COMINIT2OKEv( &CO$1 );
		if( (int64)-vr$179 != 0ll) goto label$384;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 378ll, (char*)"__FB_MODLEVELPROC__", (char*)"co.Ok( )" );
			label$384:;
		}
		{
			struct $6ComPtrI11ISHELLITEM_E ITEM$2;
			_ZN6ComPtrI11ISHELLITEM_EC1Ev( &ITEM$2 );
			int32 HR$2;
			struct $11ISHELLITEM_** vr$183 = _ZN6ComPtrI11ISHELLITEM_E6PUTREFEv( &ITEM$2 );
			int32 vr$184 = SHCreateItemFromParsingName( (uint16*)L"C:\x005CWindows", (void*)0ull, (struct $5_GUID*)&IID_ISHELLITEM_$, (void**)vr$183 );
			HR$2 = vr$184;
			if( (int64)HR$2 >= 0ll) goto label$386;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 385ll, (char*)"__FB_MODLEVELPROC__", (char*)"(cast(HRESULT, (hr)) >= 0)" );
				label$386:;
			}
			boolean vr$187 = _ZN6ComPtrI11ISHELLITEM_E6ISNULLEv( &ITEM$2 );
			if( (int64)-(boolean)(vr$187 == (boolean)0ll) != 0ll) goto label$388;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 386ll, (char*)"__FB_MODLEVELPROC__", (char*)"item.IsNull( ) = FALSE" );
				label$388:;
			}
			struct $10ComHeapPtrItE DISPNAME$2;
			_ZN10ComHeapPtrItEC1Ev( &DISPNAME$2 );
			uint16** vr$192 = _ZN10ComHeapPtrItE6PUTREFEv( &DISPNAME$2 );
			struct $11ISHELLITEM_* vr$194 = _ZptR6ComPtrI11ISHELLITEM_E( &ITEM$2 );
			struct $11ISHELLITEM_* vr$197 = _ZptR6ComPtrI11ISHELLITEM_E( &ITEM$2 );
			int32 vr$195 = (*(tmp$2153*)((uint8*)*(void***)vr$197 + 40ll))( vr$194, -2147123200, vr$192 );
			HR$2 = vr$195;
			if( (int64)HR$2 >= 0ll) goto label$390;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 392ll, (char*)"__FB_MODLEVELPROC__", (char*)"(cast(HRESULT, (hr)) >= 0)" );
				label$390:;
			}
			boolean vr$201 = _ZN10ComHeapPtrItE6ISNULLEv( &DISPNAME$2 );
			if( (int64)-(boolean)(vr$201 == (boolean)0ll) != 0ll) goto label$392;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 393ll, (char*)"__FB_MODLEVELPROC__", (char*)"dispName.IsNull( ) = FALSE" );
				label$392:;
			}
			uint16* vr$205 = _ZN10ComHeapPtrItE3GETEv( &DISPNAME$2 );
			int64 vr$206 = fb_WstrLen( (uint16*)vr$205 );
			if( vr$206 > 0ll) goto label$394;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 394ll, (char*)"__FB_MODLEVELPROC__", (char*)"len( *cptr( wstring ptr, dispName.Get( ) ) ) > 0" );
				label$394:;
			}
			_ZN10ComHeapPtrItED1Ev( &DISPNAME$2 );
			_ZN6ComPtrI11ISHELLITEM_ED1Ev( &ITEM$2 );
		}
		_ZN2FB7COMINITD1Ev( &CO$1 );
	}
	*(void**)&G_CPCVTBL$ = (void*)&SRCQI;
	*(void**)((uint8*)&G_CPCVTBL$ + 8ll) = (void*)&SRCADDREF;
	*(void**)((uint8*)&G_CPCVTBL$ + 16ll) = (void*)&SRCRELEASE;
	*(void**)((uint8*)&G_CPCVTBL$ + 24ll) = (void*)&SRCENUMCP;
	*(void**)((uint8*)&G_CPCVTBL$ + 32ll) = (void*)&SRCFIND;
	*(void**)&G_CPVTBL$ = (void*)&CPQI;
	*(void**)((uint8*)&G_CPVTBL$ + 8ll) = (void*)&CPADDREF;
	*(void**)((uint8*)&G_CPVTBL$ + 16ll) = (void*)&CPRELEASE;
	*(void**)((uint8*)&G_CPVTBL$ + 24ll) = (void*)&CPGETIFACE;
	*(void**)((uint8*)&G_CPVTBL$ + 32ll) = (void*)&CPGETCPC;
	*(void**)((uint8*)&G_CPVTBL$ + 40ll) = (void*)&CPADVISE;
	*(void**)((uint8*)&G_CPVTBL$ + 48ll) = (void*)&CPUNADVISE;
	*(void**)((uint8*)&G_CPVTBL$ + 56ll) = (void*)&CPENUM;
	{
		struct $3SRC S$1;
		__builtin_memset( &S$1, 0, 48ll );
		*(struct $7CPCVTBL**)&S$1 = &G_CPCVTBL$;
		*(int32*)((uint8*)&S$1 + 8ll) = 1;
		*(struct $6CPVTBL**)((uint8*)&S$1 + 32ll) = &G_CPVTBL$;
		*(struct $3SRC**)((uint8*)&S$1 + 40ll) = &S$1;
		int32 SINKOBJ$1;
		__builtin_memset( &SINKOBJ$1, 0, 4ll );
		void* SINK$1;
		SINK$1 = (void*)&SINKOBJ$1;
		uint32 COOKIE$1;
		__builtin_memset( &COOKIE$1, 0, 4ll );
		int32 vr$217 = _ZN2FB9COMADVISEEPvS0_PK5_GUIDRj( (void*)&S$1, SINK$1, (struct $5_GUID*)&IID_SINK$, &COOKIE$1 );
		if( (int64)vr$217 == 0ll) goto label$508;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 531ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComAdvise( @s, sink, @IID_Sink, cookie ) = S_OK" );
			label$508:;
		}
		if( (int64)COOKIE$1 == 1ll) goto label$510;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 532ll, (char*)"__FB_MODLEVELPROC__", (char*)"cookie = 1" );
			label$510:;
		}
		if( (int64)*(int32*)((uint8*)&S$1 + 16ll) == 1ll) goto label$512;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 533ll, (char*)"__FB_MODLEVELPROC__", (char*)"s.adviseCount = 1" );
			label$512:;
		}
		if( *(void**)((uint8*)&S$1 + 24ll) == SINK$1) goto label$514;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 534ll, (char*)"__FB_MODLEVELPROC__", (char*)"s.lastSink = sink" );
			label$514:;
		}
		if( (int64)*(int32*)((uint8*)&S$1 + 8ll) == 1ll) goto label$516;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 535ll, (char*)"__FB_MODLEVELPROC__", (char*)"s.refs = 1" );
			label$516:;
		}
		int32 vr$223 = _ZN2FB11COMUNADVISEEPvPK5_GUIDj( (void*)&S$1, (struct $5_GUID*)&IID_SINK$, COOKIE$1 );
		if( (int64)vr$223 == 0ll) goto label$518;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 537ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComUnadvise( @s, @IID_Sink, cookie ) = S_OK" );
			label$518:;
		}
		if( (int64)*(int32*)((uint8*)&S$1 + 20ll) == 1ll) goto label$520;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 538ll, (char*)"__FB_MODLEVELPROC__", (char*)"s.unadviseCount = 1" );
			label$520:;
		}
		if( (int64)*(int32*)((uint8*)&S$1 + 8ll) == 1ll) goto label$522;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 539ll, (char*)"__FB_MODLEVELPROC__", (char*)"s.refs = 1" );
			label$522:;
		}
		uint32 C2$1;
		__builtin_memset( &C2$1, 0, 4ll );
		int32 vr$230 = _ZN2FB9COMADVISEEPvS0_PK5_GUIDRj( (void*)&S$1, SINK$1, (struct $5_GUID*)&IID_OTHER$, &C2$1 );
		if( (int64)vr$230 == -2147220992ll) goto label$524;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 543ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComAdvise( @s, sink, @IID_Other, c2 ) = cast( HRESULT, &h80040200 )" );
			label$524:;
		}
		if( (int64)C2$1 == 0ll) goto label$526;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 544ll, (char*)"__FB_MODLEVELPROC__", (char*)"c2 = 0" );
			label$526:;
		}
		if( (int64)*(int32*)((uint8*)&S$1 + 8ll) == 1ll) goto label$528;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 545ll, (char*)"__FB_MODLEVELPROC__", (char*)"s.refs = 1" );
			label$528:;
		}
		uint32 C4$1;
		C4$1 = 0u;
		int32 vr$236 = _ZN2FB9COMADVISEEPvS0_PK5_GUIDRj( (void*)&S$1, (void*)57005ull, (struct $5_GUID*)&IID_SINK$, &C4$1 );
		if( (int64)vr$236 == -2147467259ll) goto label$530;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 549ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComAdvise( @s, cast( any ptr, &hDEAD ), @IID_Sink, c4 ) = cast(HRESULT, &h80004005)" );
			label$530:;
		}
		if( (int64)C4$1 == 0ll) goto label$532;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 550ll, (char*)"__FB_MODLEVELPROC__", (char*)"c4 = 0" );
			label$532:;
		}
		if( (int64)*(int32*)((uint8*)&S$1 + 8ll) == 1ll) goto label$534;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 551ll, (char*)"__FB_MODLEVELPROC__", (char*)"s.refs = 1" );
			label$534:;
		}
		uint32 C3$1;
		__builtin_memset( &C3$1, 0, 4ll );
		int32 vr$242 = _ZN2FB9COMADVISEEPvS0_PK5_GUIDRj( (void*)0ull, SINK$1, (struct $5_GUID*)&IID_SINK$, &C3$1 );
		if( (int64)vr$242 == -2147467261ll) goto label$536;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 555ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComAdvise( 0, sink, @IID_Sink, c3 ) = cast(HRESULT, &h80004003)" );
			label$536:;
		}
		int32 vr$246 = _ZN2FB9COMADVISEEPvS0_PK5_GUIDRj( (void*)&S$1, (void*)0ull, (struct $5_GUID*)&IID_SINK$, &C3$1 );
		if( (int64)vr$246 == -2147467261ll) goto label$538;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 556ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComAdvise( @s, 0, @IID_Sink, c3 ) = cast(HRESULT, &h80004003)" );
			label$538:;
		}
		int32 vr$248 = _ZN2FB11COMUNADVISEEPvPK5_GUIDj( (void*)0ull, (struct $5_GUID*)&IID_SINK$, 1u );
		if( (int64)vr$248 == -2147467261ll) goto label$540;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 557ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComUnadvise( 0, @IID_Sink, 1 ) = cast(HRESULT, &h80004003)" );
			label$540:;
		}
		int32 vr$251 = _ZN2FB10COMSETSITEEPvS0_( (void*)&S$1, (void*)0ull );
		if( (int64)vr$251 == -2147467262ll) goto label$542;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 560ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComSetSite( @s, 0 ) = cast(HRESULT, &h80004002)" );
			label$542:;
		}
		int32 vr$253 = _ZN2FB10COMSETSITEEPvS0_( (void*)0ull, (void*)0ull );
		if( (int64)vr$253 == -2147467261ll) goto label$544;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 561ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComSetSite( 0, 0 ) = cast(HRESULT, &h80004003)" );
			label$544:;
		}
		if( (int64)*(int32*)((uint8*)&S$1 + 8ll) == 1ll) goto label$546;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-companions.bas", 562ll, (char*)"__FB_MODLEVELPROC__", (char*)"s.refs = 1" );
			label$546:;
		}
	}
	FBSTRING* vr$256 = fb_StrAllocTempDescZEx( (char*)"comptr-companions: ok", 21ll );
	fb_PrintString( 0, (FBSTRING*)vr$256, 1 );
	label$1:;
}

static void _ZN2FB10COMUNKNOWNC1Ev( struct $N2FB10COMUNKNOWNE* THIS$1 )
{
	_ZN10fb_Object$C1Ev( (struct $10fb_Object$*)THIS$1 );
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN2FB10COMUNKNOWNE + 16ll);
	label$26:;
	label$27:;
}

static void _ZN2FB10COMUNKNOWNaSERKS0_( struct $N2FB10COMUNKNOWNE* THIS$1, struct $N2FB10COMUNKNOWNE* __FB_RHS__$1 )
{
	label$28:;
	label$29:;
}

static void _ZN2FB11COMDISPATCHaSERKS0_( struct $N2FB11COMDISPATCHE* THIS$1, struct $N2FB11COMDISPATCHE* __FB_RHS__$1 )
{
	label$34:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$35:;
}

static struct $N2FB10COMUNKNOWNE* _ZN2FB6HASUNKEPv( void* P$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$38:;
	fb$result$1 = (struct $N2FB10COMUNKNOWNE*)P$1;
	goto label$39;
	label$39:;
	return fb$result$1;
}

static struct $5_GUID* _ZN2FB11HIIDUNKNOWNEv( void )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$40:;
	static struct $5_GUID G$1 = { 0u, (uint16)0u, (uint16)0u, { (uint8)192u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)70u } };
	fb$result$1 = (struct $5_GUID*)&G$1;
	goto label$41;
	label$41:;
	return fb$result$1;
}

static void* _ZN2FB10HCANONICALEPNS_10COMUNKNOWNE( struct $N2FB10COMUNKNOWNE* P$1 )
{
	void* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$42:;
	if( P$1 != (struct $N2FB10COMUNKNOWNE*)0ull) goto label$45;
	{
		fb$result$1 = (void*)0ull;
		goto label$43;
		label$45:;
	}
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	struct $5_GUID* vr$2 = _ZN2FB11HIIDUNKNOWNEv(  );
	typedef int32 (*_ZN2FB8tmp$2054EPK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$3 = (*(_ZN2FB8tmp$2054EPK5_GUIDPPv*)*(void***)P$1)( P$1, vr$2, &OUT_$1 );
	if( (int64)vr$3 >= 0ll) goto label$47;
	{
		fb$result$1 = (void*)0ull;
		goto label$43;
		label$47:;
	}
	fb$result$1 = OUT_$1;
	goto label$43;
	label$43:;
	return fb$result$1;
}

static void _ZN2FB7COMINITC1Ej( struct $N2FB7COMINITE* THIS$1, uint32 MODE$1 )
{
	label$48:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	int32 vr$2 = CoInitializeEx( (void*)0ull, MODE$1 );
	*(int32*)THIS$1 = vr$2;
	label$49:;
}

static void _ZN2FB7COMINITD1Ev( struct $N2FB7COMINITE* THIS$1 )
{
	label$54:;
	if( (int64)*(int32*)THIS$1 < 0ll) goto label$57;
	{
		CoUninitialize(  );
		label$57:;
	}
	label$55:;
}

static boolean _ZN2FB7COMINIT2OKEv( struct $N2FB7COMINITE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$58:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)THIS$1 >= 0ll) != 0ll);
	goto label$59;
	label$59:;
	return fb$result$1;
}

static boolean _ZN2FB7COMINIT8ISFAILEDEv( struct $N2FB7COMINITE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$60:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)THIS$1 < 0ll) != 0ll);
	goto label$61;
	label$61:;
	return fb$result$1;
}

static void _ZN2FB18COMCONNECTIONPOINTaSERKS0_( struct $N2FB18COMCONNECTIONPOINTE* THIS$1, struct $N2FB18COMCONNECTIONPOINTE* __FB_RHS__$1 )
{
	label$64:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$65:;
}

static void _ZN2FB27COMCONNECTIONPOINTCONTAINERaSERKS0_( struct $N2FB27COMCONNECTIONPOINTCONTAINERE* THIS$1, struct $N2FB27COMCONNECTIONPOINTCONTAINERE* __FB_RHS__$1 )
{
	label$70:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$71:;
}

static void _ZN2FB17COMOBJECTWITHSITEaSERKS0_( struct $N2FB17COMOBJECTWITHSITEE* THIS$1, struct $N2FB17COMOBJECTWITHSITEE* __FB_RHS__$1 )
{
	label$76:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$77:;
}

static struct $5_GUID* _ZN2FB22HIIDCONNPOINTCONTAINEREv( void )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$80:;
	static struct $5_GUID G$1 = { 2979443332u, (uint16)47796u, (uint16)4122u, { (uint8)182u, (uint8)156u, (uint8)0u, (uint8)170u, (uint8)0u, (uint8)52u, (uint8)29u, (uint8)7u } };
	fb$result$1 = (struct $5_GUID*)&G$1;
	goto label$81;
	label$81:;
	return fb$result$1;
}

static struct $5_GUID* _ZN2FB18HIIDOBJECTWITHSITEEv( void )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$82:;
	static struct $5_GUID G$1 = { 4232577443u, (uint16)11177u, (uint16)4559u, { (uint8)162u, (uint8)41u, (uint8)0u, (uint8)170u, (uint8)0u, (uint8)61u, (uint8)115u, (uint8)82u } };
	fb$result$1 = (struct $5_GUID*)&G$1;
	goto label$83;
	label$83:;
	return fb$result$1;
}

static int32 _ZN2FB9COMADVISEEPvS0_PK5_GUIDRj( void* SRC$1, void* SINK$1, struct $5_GUID* IID$1, uint32* COOKIE$1 )
{
	int64 TMP$2063$1;
	int64 TMP$2064$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$84:;
	*COOKIE$1 = 0u;
	if( SRC$1 == (void*)0ull) goto label$86;
	TMP$2063$1 = (int64)-(SINK$1 == (void*)0ull);
	goto label$547;
	label$86:;
	TMP$2063$1 = -1ll;
	label$547:;
	if( TMP$2063$1 != 0ll) goto label$87;
	TMP$2064$1 = (int64)-(IID$1 == (struct $5_GUID*)0ull);
	goto label$548;
	label$87:;
	TMP$2064$1 = -1ll;
	label$548:;
	if( TMP$2064$1 == 0ll) goto label$89;
	{
		fb$result$1 = -2147467261;
		goto label$85;
		label$89:;
	}
	void* RAWCPC$1;
	RAWCPC$1 = (void*)0ull;
	int32 HR$1;
	struct $5_GUID* vr$5 = _ZN2FB22HIIDCONNPOINTCONTAINEREv(  );
	struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( SRC$1 );
	typedef int32 (*_ZN2FB8tmp$2065EPK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$7 = (*(_ZN2FB8tmp$2065EPK5_GUIDPPv*)*(void***)vr$8)( vr$6, vr$5, &RAWCPC$1 );
	HR$1 = vr$7;
	if( (int64)HR$1 >= 0ll) goto label$91;
	{
		fb$result$1 = HR$1;
		goto label$85;
		label$91:;
	}
	struct $N2FB27COMCONNECTIONPOINTCONTAINERE* CPC$1;
	CPC$1 = (struct $N2FB27COMCONNECTIONPOINTCONTAINERE*)RAWCPC$1;
	void* RAWCP$1;
	RAWCP$1 = (void*)0ull;
	typedef int32 (*_ZN2FB8tmp$2066EPK5_GUIDPPv)( struct $N2FB27COMCONNECTIONPOINTCONTAINERE*, struct $5_GUID*, void** );
	int32 vr$12 = (*(_ZN2FB8tmp$2066EPK5_GUIDPPv*)((uint8*)*(void***)CPC$1 + 32ll))( CPC$1, IID$1, &RAWCP$1 );
	HR$1 = vr$12;
	typedef uint32 (*_ZN2FB8tmp$2067Ev)( struct $N2FB10COMUNKNOWNE* );
	(*(_ZN2FB8tmp$2067Ev*)((uint8*)*(void***)CPC$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)CPC$1 );
	if( (int64)HR$1 >= 0ll) goto label$93;
	{
		fb$result$1 = HR$1;
		goto label$85;
		label$93:;
	}
	struct $N2FB18COMCONNECTIONPOINTE* CP$1;
	CP$1 = (struct $N2FB18COMCONNECTIONPOINTE*)RAWCP$1;
	uint32 C$1;
	C$1 = 0u;
	typedef int32 (*_ZN2FB8tmp$2068EPvPj)( struct $N2FB18COMCONNECTIONPOINTE*, void*, uint32* );
	int32 vr$19 = (*(_ZN2FB8tmp$2068EPvPj*)((uint8*)*(void***)CP$1 + 40ll))( CP$1, SINK$1, &C$1 );
	HR$1 = vr$19;
	(*(_ZN2FB8tmp$2067Ev*)((uint8*)*(void***)CP$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)CP$1 );
	if( (int64)HR$1 < 0ll) goto label$95;
	{
		*COOKIE$1 = C$1;
		label$95:;
	}
	fb$result$1 = HR$1;
	goto label$85;
	label$85:;
	return fb$result$1;
}

static int32 _ZN2FB11COMUNADVISEEPvPK5_GUIDj( void* SRC$1, struct $5_GUID* IID$1, uint32 COOKIE$1 )
{
	int64 TMP$2069$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$96:;
	if( SRC$1 == (void*)0ull) goto label$98;
	TMP$2069$1 = (int64)-(IID$1 == (struct $5_GUID*)0ull);
	goto label$549;
	label$98:;
	TMP$2069$1 = -1ll;
	label$549:;
	if( TMP$2069$1 == 0ll) goto label$100;
	{
		fb$result$1 = -2147467261;
		goto label$97;
		label$100:;
	}
	void* RAWCPC$1;
	RAWCPC$1 = (void*)0ull;
	int32 HR$1;
	struct $5_GUID* vr$3 = _ZN2FB22HIIDCONNPOINTCONTAINEREv(  );
	struct $N2FB10COMUNKNOWNE* vr$4 = _ZN2FB6HASUNKEPv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( SRC$1 );
	typedef int32 (*_ZN2FB8tmp$2070EPK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$5 = (*(_ZN2FB8tmp$2070EPK5_GUIDPPv*)*(void***)vr$6)( vr$4, vr$3, &RAWCPC$1 );
	HR$1 = vr$5;
	if( (int64)HR$1 >= 0ll) goto label$102;
	{
		fb$result$1 = HR$1;
		goto label$97;
		label$102:;
	}
	struct $N2FB27COMCONNECTIONPOINTCONTAINERE* CPC$1;
	CPC$1 = (struct $N2FB27COMCONNECTIONPOINTCONTAINERE*)RAWCPC$1;
	void* RAWCP$1;
	RAWCP$1 = (void*)0ull;
	typedef int32 (*_ZN2FB8tmp$2071EPK5_GUIDPPv)( struct $N2FB27COMCONNECTIONPOINTCONTAINERE*, struct $5_GUID*, void** );
	int32 vr$10 = (*(_ZN2FB8tmp$2071EPK5_GUIDPPv*)((uint8*)*(void***)CPC$1 + 32ll))( CPC$1, IID$1, &RAWCP$1 );
	HR$1 = vr$10;
	typedef uint32 (*_ZN2FB8tmp$2072Ev)( struct $N2FB10COMUNKNOWNE* );
	(*(_ZN2FB8tmp$2072Ev*)((uint8*)*(void***)CPC$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)CPC$1 );
	if( (int64)HR$1 >= 0ll) goto label$104;
	{
		fb$result$1 = HR$1;
		goto label$97;
		label$104:;
	}
	struct $N2FB18COMCONNECTIONPOINTE* CP$1;
	CP$1 = (struct $N2FB18COMCONNECTIONPOINTE*)RAWCP$1;
	typedef int32 (*_ZN2FB8tmp$2073Ej)( struct $N2FB18COMCONNECTIONPOINTE*, uint32 );
	int32 vr$16 = (*(_ZN2FB8tmp$2073Ej*)((uint8*)*(void***)CP$1 + 48ll))( CP$1, COOKIE$1 );
	HR$1 = vr$16;
	(*(_ZN2FB8tmp$2072Ev*)((uint8*)*(void***)CP$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)CP$1 );
	fb$result$1 = HR$1;
	goto label$97;
	label$97:;
	return fb$result$1;
}

static int32 _ZN2FB10COMSETSITEEPvS0_( void* OBJ$1, void* SITE$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$105:;
	if( OBJ$1 != (void*)0ull) goto label$108;
	{
		fb$result$1 = -2147467261;
		goto label$106;
		label$108:;
	}
	void* RAW$1;
	RAW$1 = (void*)0ull;
	int32 HR$1;
	struct $5_GUID* vr$2 = _ZN2FB18HIIDOBJECTWITHSITEEv(  );
	struct $N2FB10COMUNKNOWNE* vr$3 = _ZN2FB6HASUNKEPv( OBJ$1 );
	struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( OBJ$1 );
	typedef int32 (*_ZN2FB8tmp$2074EPK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$4 = (*(_ZN2FB8tmp$2074EPK5_GUIDPPv*)*(void***)vr$5)( vr$3, vr$2, &RAW$1 );
	HR$1 = vr$4;
	if( (int64)HR$1 >= 0ll) goto label$110;
	{
		fb$result$1 = HR$1;
		goto label$106;
		label$110:;
	}
	struct $N2FB17COMOBJECTWITHSITEE* OWS$1;
	OWS$1 = (struct $N2FB17COMOBJECTWITHSITEE*)RAW$1;
	typedef int32 (*_ZN2FB8tmp$2075EPv)( struct $N2FB17COMOBJECTWITHSITEE*, void* );
	int32 vr$8 = (*(_ZN2FB8tmp$2075EPv*)((uint8*)*(void***)OWS$1 + 24ll))( OWS$1, SITE$1 );
	HR$1 = vr$8;
	typedef uint32 (*_ZN2FB8tmp$2076Ev)( struct $N2FB10COMUNKNOWNE* );
	(*(_ZN2FB8tmp$2076Ev*)((uint8*)*(void***)OWS$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)OWS$1 );
	fb$result$1 = HR$1;
	goto label$106;
	label$106:;
	return fb$result$1;
}

static int32 COMISALIVE( void )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$115:;
	void* TMP$1;
	TMP$1 = (void*)0ull;
	int32 HR$1;
	int32 vr$2 = CoCreateInstance( (struct $5_GUID*)&CLSID_SHELLLINK_$, (struct $9IUnknown_*)0ull, 1u, (struct $5_GUID*)&IID_IUNKNOWN_$, &TMP$1 );
	HR$1 = vr$2;
	if( TMP$1 == (void*)0ull) goto label$118;
	{
		(*(tmp$2081*)((uint8*)*(void***)TMP$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)TMP$1 );
		label$118:;
	}
	fb$result$1 = HR$1;
	goto label$116;
	label$116:;
	return fb$result$1;
}

static void _ZN5IFAKEaSERKS_( struct $5IFAKE* THIS$1, struct $5IFAKE* __FB_RHS__$1 )
{
	label$121:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$122:;
}

static int32 FQI( struct $4FAKE* S$1, struct $5_GUID* RIID$1, void** PPV$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$125:;
	if( PPV$1 != (void**)0ull) goto label$128;
	{
		fb$result$1 = -2147467261;
		goto label$126;
		label$128:;
	}
	*PPV$1 = (void*)S$1;
	*(int32*)((uint8*)S$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 8ll) + 1ll);
	fb$result$1 = 0;
	goto label$126;
	label$126:;
	return fb$result$1;
}

static uint32 FADDREF( struct $4FAKE* S$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$129:;
	*(int32*)((uint8*)S$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 8ll) + 1ll);
	fb$result$1 = *(uint32*)((uint8*)S$1 + 8ll);
	goto label$130;
	label$130:;
	return fb$result$1;
}

static uint32 FRELEASE( struct $4FAKE* S$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$131:;
	*(int32*)((uint8*)S$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 8ll) + -1ll);
	int32 N$1;
	N$1 = *(int32*)((uint8*)S$1 + 8ll);
	if( (int64)N$1 != 0ll) goto label$134;
	{
		int32 vr$8 = COMISALIVE(  );
		G_HRSEENBYRELEASE$ = vr$8;
		G_DESTROYED$ = (int32)((int64)G_DESTROYED$ + 1ll);
		free( (void*)S$1 );
	}
	label$134:;
	label$133:;
	fb$result$1 = (uint32)N$1;
	goto label$132;
	label$132:;
	return fb$result$1;
}

static int32 FPOKE( struct $4FAKE* S$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$135:;
	fb$result$1 = 1;
	goto label$136;
	label$136:;
	return fb$result$1;
}

static struct $5IFAKE* NEWFAKE( void )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$137:;
	struct $4FAKE* F$1;
	void* vr$1 = calloc( 16ull, 1ull );
	F$1 = (struct $4FAKE*)vr$1;
	*(struct $8FAKEVTBL**)F$1 = &G_VTBL$;
	*(int32*)((uint8*)F$1 + 8ll) = 1;
	fb$result$1 = (struct $5IFAKE*)F$1;
	goto label$138;
	label$138:;
	return fb$result$1;
}

static int32 SPYQI( struct $6SPYOBJ* S$1, struct $5_GUID* RIID$1, void** PPV$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$251:;
	if( PPV$1 != (void**)0ull) goto label$254;
	{
		fb$result$1 = -2147467261;
		goto label$252;
		label$254:;
	}
	*PPV$1 = (void*)S$1;
	fb$result$1 = 0;
	goto label$252;
	label$252:;
	return fb$result$1;
}

static uint32 SPYADDREF( struct $6SPYOBJ* S$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$255:;
	fb$result$1 = 2u;
	goto label$256;
	label$256:;
	return fb$result$1;
}

static uint32 SPYRELEASE( struct $6SPYOBJ* S$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$257:;
	fb$result$1 = 1u;
	goto label$258;
	label$258:;
	return fb$result$1;
}

static uint64 SPYPREALLOC( struct $6SPYOBJ* S$1, uint64 CB$1 )
{
	uint64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$259:;
	fb$result$1 = CB$1;
	goto label$260;
	label$260:;
	return fb$result$1;
}

static void* SPYPOSTALLOC( struct $6SPYOBJ* S$1, void* P$1 )
{
	void* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$261:;
	if( P$1 == (void*)0ull) goto label$264;
	{
		G_ALLOCS$ = (int32)((int64)G_ALLOCS$ + 1ll);
		label$264:;
	}
	fb$result$1 = P$1;
	goto label$262;
	label$262:;
	return fb$result$1;
}

static void* SPYPREFREE( struct $6SPYOBJ* S$1, void* P$1, int32 SPYED$1 )
{
	void* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$265:;
	if( P$1 == (void*)0ull) goto label$268;
	{
		G_FREES$ = (int32)((int64)G_FREES$ + 1ll);
		label$268:;
	}
	fb$result$1 = P$1;
	goto label$266;
	label$266:;
	return fb$result$1;
}

static void SPYPOSTFREE( struct $6SPYOBJ* S$1, int32 SPYED$1 )
{
	label$269:;
	label$270:;
}

static uint64 SPYPREREALLOC( struct $6SPYOBJ* S$1, void* P$1, uint64 CB$1, void** PPNEW$1, int32 SPYED$1 )
{
	uint64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$271:;
	*PPNEW$1 = P$1;
	fb$result$1 = CB$1;
	goto label$272;
	label$272:;
	return fb$result$1;
}

static void* SPYPOSTREALLOC( struct $6SPYOBJ* S$1, void* P$1, int32 SPYED$1 )
{
	void* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$273:;
	fb$result$1 = P$1;
	goto label$274;
	label$274:;
	return fb$result$1;
}

static void* SPYPREGETSIZE( struct $6SPYOBJ* S$1, void* P$1, int32 SPYED$1 )
{
	void* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$275:;
	fb$result$1 = P$1;
	goto label$276;
	label$276:;
	return fb$result$1;
}

static uint64 SPYPOSTGETSIZE( struct $6SPYOBJ* S$1, uint64 CB$1, int32 SPYED$1 )
{
	uint64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$277:;
	fb$result$1 = CB$1;
	goto label$278;
	label$278:;
	return fb$result$1;
}

static void* SPYPREDIDALLOC( struct $6SPYOBJ* S$1, void* P$1, int32 SPYED$1 )
{
	void* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$279:;
	fb$result$1 = P$1;
	goto label$280;
	label$280:;
	return fb$result$1;
}

static int32 SPYPOSTDIDALLOC( struct $6SPYOBJ* S$1, void* P$1, int32 SPYED$1, int32 ACT$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$281:;
	fb$result$1 = ACT$1;
	goto label$282;
	label$282:;
	return fb$result$1;
}

static void SPYPREHEAPMINIMIZE( struct $6SPYOBJ* S$1 )
{
	label$283:;
	label$284:;
}

static void SPYPOSTHEAPMINIMIZE( struct $6SPYOBJ* S$1 )
{
	label$285:;
	label$286:;
}

static void _ZN11ISHELLITEM_aSERKS_( struct $11ISHELLITEM_* THIS$1, struct $11ISHELLITEM_* __FB_RHS__$1 )
{
	label$379:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$380:;
}

static int32 SRCQI( struct $3SRC* S$1, struct $5_GUID* RIID$1, void** PPV$1 )
{
	int64 TMP$2170$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$465:;
	if( PPV$1 != (void**)0ull) goto label$468;
	{
		fb$result$1 = -2147467261;
		goto label$466;
		label$468:;
	}
	*PPV$1 = (void*)0ull;
	struct $5_GUID IIDCPC$1;
	*(uint32*)&IIDCPC$1 = 2979443332u;
	*(uint16*)((uint8*)&IIDCPC$1 + 4ll) = (uint16)47796u;
	*(uint16*)((uint8*)&IIDCPC$1 + 6ll) = (uint16)4122u;
	*(uint8*)((uint8*)&IIDCPC$1 + 8ll) = (uint8)182u;
	*(uint8*)((uint8*)&IIDCPC$1 + 9ll) = (uint8)156u;
	*(uint8*)((uint8*)&IIDCPC$1 + 10ll) = (uint8)0u;
	*(uint8*)((uint8*)&IIDCPC$1 + 11ll) = (uint8)170u;
	*(uint8*)((uint8*)&IIDCPC$1 + 12ll) = (uint8)0u;
	*(uint8*)((uint8*)&IIDCPC$1 + 13ll) = (uint8)52u;
	*(uint8*)((uint8*)&IIDCPC$1 + 14ll) = (uint8)29u;
	*(uint8*)((uint8*)&IIDCPC$1 + 15ll) = (uint8)7u;
	int32 vr$3 = memcmp( (void*)RIID$1, (void*)&IIDCPC$1, 16ull );
	if( (int64)vr$3 == 0ll) goto label$469;
	int32 vr$5 = memcmp( (void*)RIID$1, (void*)&IID_IUNKNOWN_$, 16ull );
	TMP$2170$1 = (int64)-((int64)vr$5 == 0ll);
	goto label$550;
	label$469:;
	TMP$2170$1 = -1ll;
	label$550:;
	if( TMP$2170$1 == 0ll) goto label$471;
	{
		*PPV$1 = (void*)S$1;
		SRCADDREF( S$1 );
		fb$result$1 = 0;
		goto label$466;
	}
	label$471:;
	label$470:;
	fb$result$1 = -2147467262;
	goto label$466;
	label$466:;
	return fb$result$1;
}

static uint32 SRCADDREF( struct $3SRC* S$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$472:;
	*(int32*)((uint8*)S$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 8ll) + 1ll);
	fb$result$1 = *(uint32*)((uint8*)S$1 + 8ll);
	goto label$473;
	label$473:;
	return fb$result$1;
}

static uint32 SRCRELEASE( struct $3SRC* S$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$474:;
	*(int32*)((uint8*)S$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 8ll) + -1ll);
	fb$result$1 = *(uint32*)((uint8*)S$1 + 8ll);
	goto label$475;
	label$475:;
	return fb$result$1;
}

static int32 SRCFIND( struct $3SRC* S$1, struct $5_GUID* RIID$1, void** PPCP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$476:;
	if( PPCP$1 != (void**)0ull) goto label$479;
	{
		fb$result$1 = -2147467261;
		goto label$477;
		label$479:;
	}
	*PPCP$1 = (void*)0ull;
	int32 vr$2 = memcmp( (void*)RIID$1, (void*)&IID_SINK$, 16ull );
	if( (int64)vr$2 == 0ll) goto label$481;
	{
		fb$result$1 = -2147220992;
		goto label$477;
		label$481:;
	}
	*PPCP$1 = (void*)((uint8*)S$1 + 32ll);
	SRCADDREF( S$1 );
	fb$result$1 = 0;
	goto label$477;
	label$477:;
	return fb$result$1;
}

static int32 SRCENUMCP( struct $3SRC* S$1, void** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$482:;
	fb$result$1 = -2147467263;
	goto label$483;
	label$483:;
	return fb$result$1;
}

static int32 CPQI( struct $5CPOBJ* C$1, struct $5_GUID* RIID$1, void** PPV$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$484:;
	int32 vr$2 = SRCQI( *(struct $3SRC**)((uint8*)C$1 + 8ll), RIID$1, PPV$1 );
	fb$result$1 = vr$2;
	goto label$485;
	label$485:;
	return fb$result$1;
}

static uint32 CPADDREF( struct $5CPOBJ* C$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$486:;
	uint32 vr$2 = SRCADDREF( *(struct $3SRC**)((uint8*)C$1 + 8ll) );
	fb$result$1 = vr$2;
	goto label$487;
	label$487:;
	return fb$result$1;
}

static uint32 CPRELEASE( struct $5CPOBJ* C$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$488:;
	uint32 vr$2 = SRCRELEASE( *(struct $3SRC**)((uint8*)C$1 + 8ll) );
	fb$result$1 = vr$2;
	goto label$489;
	label$489:;
	return fb$result$1;
}

static int32 CPADVISE( struct $5CPOBJ* C$1, void* SINK$1, uint32* PDW$1 )
{
	int64 TMP$2171$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$490:;
	if( SINK$1 == (void*)0ull) goto label$492;
	TMP$2171$1 = (int64)-(PDW$1 == (uint32*)0ull);
	goto label$551;
	label$492:;
	TMP$2171$1 = -1ll;
	label$551:;
	if( TMP$2171$1 == 0ll) goto label$494;
	{
		fb$result$1 = -2147467261;
		goto label$491;
		label$494:;
	}
	if( SINK$1 != (void*)57005ull) goto label$496;
	{
		*PDW$1 = 195936478u;
		fb$result$1 = -2147467259;
		goto label$491;
	}
	label$496:;
	label$495:;
	*(int32*)((uint8*)*(struct $3SRC**)((uint8*)C$1 + 8ll) + 16ll) = (int32)((int64)*(int32*)((uint8*)*(struct $3SRC**)((uint8*)C$1 + 8ll) + 16ll) + 1ll);
	*(uint32*)((uint8*)*(struct $3SRC**)((uint8*)C$1 + 8ll) + 12ll) = (uint32)((int64)*(uint32*)((uint8*)*(struct $3SRC**)((uint8*)C$1 + 8ll) + 12ll) + 1ll);
	*(void**)((uint8*)*(struct $3SRC**)((uint8*)C$1 + 8ll) + 24ll) = SINK$1;
	*PDW$1 = *(uint32*)((uint8*)*(struct $3SRC**)((uint8*)C$1 + 8ll) + 12ll);
	fb$result$1 = 0;
	goto label$491;
	label$491:;
	return fb$result$1;
}

static int32 CPUNADVISE( struct $5CPOBJ* C$1, uint32 DW$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$497:;
	if( (int64)DW$1 == (int64)*(uint32*)((uint8*)*(struct $3SRC**)((uint8*)C$1 + 8ll) + 12ll)) goto label$500;
	{
		fb$result$1 = -2147467261;
		goto label$498;
		label$500:;
	}
	*(int32*)((uint8*)*(struct $3SRC**)((uint8*)C$1 + 8ll) + 20ll) = (int32)((int64)*(int32*)((uint8*)*(struct $3SRC**)((uint8*)C$1 + 8ll) + 20ll) + 1ll);
	fb$result$1 = 0;
	goto label$498;
	label$498:;
	return fb$result$1;
}

static int32 CPGETIFACE( struct $5CPOBJ* C$1, struct $5_GUID* PIID$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$501:;
	fb$result$1 = -2147467263;
	goto label$502;
	label$502:;
	return fb$result$1;
}

static int32 CPGETCPC( struct $5CPOBJ* C$1, void** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$503:;
	fb$result$1 = -2147467263;
	goto label$504;
	label$504:;
	return fb$result$1;
}

static int32 CPENUM( struct $5CPOBJ* C$1, void** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$505:;
	fb$result$1 = -2147467263;
	goto label$506;
	label$506:;
	return fb$result$1;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0kernel32\0-l\0gdi32\0-l\0msimg32\0-l\0user32\0-l\0version\0-l\0advapi32\0-l\0imm32\0-l\0uuid\0-l\0ole32\0-l\0oleaut32\0-l\0shell32";
