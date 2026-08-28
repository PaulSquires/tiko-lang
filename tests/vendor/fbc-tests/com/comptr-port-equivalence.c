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
struct $6ILINKW {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $6ILINKW ) == 8 );
struct $6ComPtrI6ILINKWE {
	struct $6ILINKW* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrI6ILINKWE ) == 8 );
struct $6IPFILE {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $6IPFILE ) == 8 );
struct $6ComPtrI6IPFILEE {
	struct $6IPFILE* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrI6IPFILEE ) == 8 );
struct $6IidTagI6IPFILEE {
	int32 UNUSED;
};
__FB_STATIC_ASSERT( sizeof( struct $6IidTagI6IPFILEE ) == 4 );
struct $5_GUID {
	uint32 DATA1;
	uint16 DATA2;
	uint16 DATA3;
	uint8 DATA4[8];
};
__FB_STATIC_ASSERT( sizeof( struct $5_GUID ) == 16 );
struct $N2FB7COMINITE {
	int32 HR;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB7COMINITE ) == 4 );
struct $6TRACE_ {
	int32 AFTERCREATE;
	int32 AFTERQUERY;
	int32 AFTERRELEASINGQUERIED;
	boolean QUERIEDISDIFFERENTPOINTER;
};
__FB_STATIC_ASSERT( sizeof( struct $6TRACE_ ) == 16 );
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
typedef uint32 (*tmp$8410)( struct $N2FB10COMUNKNOWNE* );
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
typedef int32 (*tmp$8411)( struct $6ILINKW*, uint16* );
typedef int32 (*tmp$8415)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
void _ZN10fb_Object$C1Ev( struct $10fb_Object$* );
void* fb_ErrorThrowEx( int32, int32, char*, void*, void* );
void fb_Assert( char*, int64, char*, char* );
void fb_PrintBool( int32, boolean, int32 );
void fb_PrintString( int32, FBSTRING*, int32 );
FBSTRING* fb_StrAllocTempDescZEx( char*, int64 );
static void fb_ctor__comptrzportzequivalence( void ) __attribute__(( constructor ));
int64 _InterlockedExchangeAdd64( int64*, int64 );
int32 _InterlockedExchangeAdd( int32*, int32 );
void CoUninitialize( void );
int32 CoInitializeEx( void*, uint32 );
int32 CoCreateInstance( struct $5_GUID*, struct $9IUnknown_*, uint32, struct $5_GUID*, void** );
void CoTaskMemFree( void* );
struct $6HWND__ {
	int32 UNUSED;
};
__FB_STATIC_ASSERT( sizeof( struct $6HWND__ ) == 4 );
int64 SendMessageA( struct $6HWND__*, uint32, uint64, int64 );
static void _ZN2FB10COMUNKNOWNC1Ev( struct $N2FB10COMUNKNOWNE* );
static void _ZN2FB10COMUNKNOWNaSERKS0_( struct $N2FB10COMUNKNOWNE*, struct $N2FB10COMUNKNOWNE* );
static void _ZN2FB11COMDISPATCHaSERKS0_( struct $N2FB11COMDISPATCHE*, struct $N2FB11COMDISPATCHE* );
static struct $N2FB10COMUNKNOWNE* _ZN2FB6HASUNKEPv( void* );
static struct $5_GUID* _ZN2FB11HIIDUNKNOWNEv( void );
static void* _ZN2FB10HCANONICALEPNS_10COMUNKNOWNE( struct $N2FB10COMUNKNOWNE* );
static void _ZN2FB7COMINITC1Ej( struct $N2FB7COMINITE*, uint32 );
static void _ZN2FB7COMINITD1Ev( struct $N2FB7COMINITE* );
static boolean _ZN2FB7COMINIT2OKEv( struct $N2FB7COMINITE* );
static void _ZN2FB18COMCONNECTIONPOINTaSERKS0_( struct $N2FB18COMCONNECTIONPOINTE*, struct $N2FB18COMCONNECTIONPOINTE* );
static void _ZN2FB27COMCONNECTIONPOINTCONTAINERaSERKS0_( struct $N2FB27COMCONNECTIONPOINTCONTAINERE*, struct $N2FB27COMCONNECTIONPOINTCONTAINERE* );
static void _ZN2FB17COMOBJECTWITHSITEaSERKS0_( struct $N2FB17COMOBJECTWITHSITEE*, struct $N2FB17COMOBJECTWITHSITEE* );
static struct $5_GUID* _ZN2FB22HIIDCONNPOINTCONTAINEREv( void );
static struct $5_GUID* _ZN2FB18HIIDOBJECTWITHSITEEv( void );
static void _ZN6ILINKWaSERKS_( struct $6ILINKW*, struct $6ILINKW* );
static void _ZN6IPFILEaSERKS_( struct $6IPFILE*, struct $6IPFILE* );
static struct $5_GUID* _Z5IIDOF6IidTagI6IPFILEE( struct $6IidTagI6IPFILEE );
static int32 RC( void* );
static int32 RAWFLOW( struct $6TRACE_* );
static int32 COMPTRFLOW( struct $6TRACE_* );
static void _ZN6ComPtrI6ILINKWEC1Ev( struct $6ComPtrI6ILINKWE* );
static void _ZN6ComPtrI6ILINKWED1Ev( struct $6ComPtrI6ILINKWE* );
static struct $6ILINKW* _ZN6ComPtrI6ILINKWE3GETEv( struct $6ComPtrI6ILINKWE* );
static boolean _ZN6ComPtrI6ILINKWE6ISNULLEv( struct $6ComPtrI6ILINKWE* );
static void _ZN6ComPtrI6ILINKWE7RELEASEEv( struct $6ComPtrI6ILINKWE* );
static struct $6ILINKW** _ZN6ComPtrI6ILINKWE6PUTREFEv( struct $6ComPtrI6ILINKWE* );
static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI6ILINKWE7UNKNOWNEv( struct $6ComPtrI6ILINKWE* );
static struct $6ILINKW* _ZptR6ComPtrI6ILINKWE( struct $6ComPtrI6ILINKWE* );
static void _ZN6ComPtrI6IPFILEEC1Ev( struct $6ComPtrI6IPFILEE* );
static void _ZN6ComPtrI6IPFILEED1Ev( struct $6ComPtrI6IPFILEE* );
static struct $6IPFILE* _ZN6ComPtrI6IPFILEE3GETEv( struct $6ComPtrI6IPFILEE* );
static void _ZN6ComPtrI6IPFILEE6ATTACHEPS0_( struct $6ComPtrI6IPFILEE*, struct $6IPFILE* );
static void _ZN6ComPtrI6IPFILEE7RELEASEEv( struct $6ComPtrI6IPFILEE* );
static int32 _Z7ComCastI6ILINKW6IPFILEER6ComPtrI6ILINKWER6ComPtrI6IPFILEE( struct $6ComPtrI6ILINKWE*, struct $6ComPtrI6IPFILEE* );
struct $8fb_RTTI$;
struct $8fb_RTTI$ {
	void* STDLIBVTABLE;
	char* ID;
	struct $8fb_RTTI$* RTTIBASE;
};
__FB_STATIC_ASSERT( sizeof( struct $8fb_RTTI$ ) == 24 );
extern struct $8fb_RTTI$ __fb_ZTS6Object;
extern struct $5_GUID CLSID_ShellLink;
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
static struct $8fb_RTTI$ _ZTSN6ILINKWE = { (void*)0ull, (char*)"6ILINKW", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN6ILINKWE[23] = { (void*)0ull, (void*)&_ZTSN6ILINKWE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8fb_RTTI$ _ZTSN6IPFILEE = { (void*)0ull, (char*)"6IPFILE", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN6IPFILEE[11] = { (void*)0ull, (void*)&_ZTSN6IPFILEE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $5_GUID IID_ILINKW$ = { 136441u, (uint16)0u, (uint16)0u, { (uint8)192u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)70u } };
static struct $5_GUID IID_IPFILE$ = { 267u, (uint16)0u, (uint16)0u, { (uint8)192u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)70u } };

static void _ZN6ComPtrI6ILINKWEC1Ev( struct $6ComPtrI6ILINKWE* THIS$1 )
{
	label$178:;
	__builtin_memset( (struct $6ILINKW**)THIS$1, 0, 8ll );
	*(struct $6ILINKW**)THIS$1 = (struct $6ILINKW*)0ull;
	label$179:;
}

static void _ZN6ComPtrI6ILINKWEC1EPS0_( struct $6ComPtrI6ILINKWE* THIS$1, struct $6ILINKW* RAW$1 )
{
	label$180:;
	__builtin_memset( (struct $6ILINKW**)THIS$1, 0, 8ll );
	*(struct $6ILINKW**)THIS$1 = RAW$1;
	if( *(struct $6ILINKW**)THIS$1 == (struct $6ILINKW*)0ull) goto label$183;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6ILINKWE8tmp$8418Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6ILINKWE8tmp$8418Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$183:;
	}
	label$181:;
}

static void _ZN6ComPtrI6ILINKWEC1ERS1_( struct $6ComPtrI6ILINKWE* THIS$1, struct $6ComPtrI6ILINKWE* RHS$1 )
{
	label$184:;
	__builtin_memset( (struct $6ILINKW**)THIS$1, 0, 8ll );
	*(struct $6ILINKW**)THIS$1 = *(struct $6ILINKW**)RHS$1;
	if( *(struct $6ILINKW**)THIS$1 == (struct $6ILINKW*)0ull) goto label$187;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6ILINKWE8tmp$8419Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6ILINKWE8tmp$8419Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$187:;
	}
	label$185:;
}

static void _ZN6ComPtrI6ILINKWED1Ev( struct $6ComPtrI6ILINKWE* THIS$1 )
{
	label$188:;
	_ZN6ComPtrI6ILINKWE7RELEASEEv( THIS$1 );
	label$189:;
}

static void _ZN6ComPtrI6ILINKWEaSERS1_( struct $6ComPtrI6ILINKWE* THIS$1, struct $6ComPtrI6ILINKWE* RHS$1 )
{
	label$190:;
	if( *(struct $6ILINKW**)THIS$1 != *(struct $6ILINKW**)RHS$1) goto label$193;
	{
		goto label$191;
		label$193:;
	}
	struct $6ILINKW* OLD$1;
	OLD$1 = *(struct $6ILINKW**)THIS$1;
	*(struct $6ILINKW**)THIS$1 = *(struct $6ILINKW**)RHS$1;
	if( *(struct $6ILINKW**)THIS$1 == (struct $6ILINKW*)0ull) goto label$195;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6ILINKWE8tmp$8420Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6ILINKWE8tmp$8420Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$195:;
	}
	if( OLD$1 == (struct $6ILINKW*)0ull) goto label$197;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI6ILINKWE8tmp$8421Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6ILINKWE8tmp$8421Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$197:;
	}
	label$191:;
}

static struct $6ILINKW* _ZN6ComPtrI6ILINKWE3GETEv( struct $6ComPtrI6ILINKWE* THIS$1 )
{
	struct $6ILINKW* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$198:;
	fb$result$1 = *(struct $6ILINKW**)THIS$1;
	goto label$199;
	label$199:;
	return fb$result$1;
}

static struct $6ILINKW* _ZN6ComPtrI6ILINKWE3REFEv( struct $6ComPtrI6ILINKWE* THIS$1 )
{
	struct $6ILINKW* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$200:;
	if( *(struct $6ILINKW**)THIS$1 != (struct $6ILINKW*)0ull) goto label$203;
	{
		label$204:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$205:;
	}
	label$203:;
	label$202:;
	fb$result$1 = *(struct $6ILINKW**)THIS$1;
	goto label$201;
	label$201:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI6ILINKWE6ISNULLEv( struct $6ComPtrI6ILINKWE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$206:;
	fb$result$1 = (boolean)((int64)-(*(struct $6ILINKW**)THIS$1 == (struct $6ILINKW*)0ull) != 0ll);
	goto label$207;
	label$207:;
	return fb$result$1;
}

static void _ZN6ComPtrI6ILINKWE6ATTACHEPS0_( struct $6ComPtrI6ILINKWE* THIS$1, struct $6ILINKW* RAW$1 )
{
	label$208:;
	_ZN6ComPtrI6ILINKWE7RELEASEEv( THIS$1 );
	*(struct $6ILINKW**)THIS$1 = RAW$1;
	label$209:;
}

static struct $6ILINKW* _ZN6ComPtrI6ILINKWE6DETACHEv( struct $6ComPtrI6ILINKWE* THIS$1 )
{
	struct $6ILINKW* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$210:;
	struct $6ILINKW* R$1;
	R$1 = *(struct $6ILINKW**)THIS$1;
	*(struct $6ILINKW**)THIS$1 = (struct $6ILINKW*)0ull;
	fb$result$1 = R$1;
	goto label$211;
	label$211:;
	return fb$result$1;
}

static void _ZN6ComPtrI6ILINKWE7RELEASEEv( struct $6ComPtrI6ILINKWE* THIS$1 )
{
	label$212:;
	if( *(struct $6ILINKW**)THIS$1 == (struct $6ILINKW*)0ull) goto label$215;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $6ILINKW**)THIS$1 = (struct $6ILINKW*)0ull;
		typedef uint32 (*_ZN6ComPtrI6ILINKWE8tmp$8423Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6ILINKWE8tmp$8423Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$215:;
	label$214:;
	label$213:;
}

static int32 _ZN6ComPtrI6ILINKWE6COPYTOEPPS0_( struct $6ComPtrI6ILINKWE* THIS$1, struct $6ILINKW** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$216:;
	if( PP$1 != (struct $6ILINKW**)0ull) goto label$219;
	{
		fb$result$1 = -2147467261;
		goto label$217;
		label$219:;
	}
	*PP$1 = *(struct $6ILINKW**)THIS$1;
	if( *(struct $6ILINKW**)THIS$1 == (struct $6ILINKW*)0ull) goto label$221;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6ILINKWE8tmp$8424Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6ILINKWE8tmp$8424Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$221:;
	}
	fb$result$1 = 0;
	goto label$217;
	label$217:;
	return fb$result$1;
}

static struct $6ILINKW** _ZN6ComPtrI6ILINKWE6PUTREFEv( struct $6ComPtrI6ILINKWE* THIS$1 )
{
	struct $6ILINKW** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$222:;
	if( *(struct $6ILINKW**)THIS$1 == (struct $6ILINKW*)0ull) goto label$225;
	{
		label$226:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$227:;
		label$225:;
	}
	fb$result$1 = (struct $6ILINKW**)THIS$1;
	goto label$223;
	label$223:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI6ILINKWE7UNKNOWNEv( struct $6ComPtrI6ILINKWE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$228:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$229;
	label$229:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI6ILINKWE13ISEQUALOBJECTEPv( struct $6ComPtrI6ILINKWE* THIS$1, void* OTHER$1 )
{
	int64 TMP$8425$1;
	int64 TMP$8426$1;
	int64 TMP$8427$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$230:;
	if( *(struct $6ILINKW**)THIS$1 != (struct $6ILINKW*)0ull) goto label$232;
	TMP$8425$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$243;
	label$232:;
	TMP$8425$1 = 0ll;
	label$243:;
	if( TMP$8425$1 == 0ll) goto label$234;
	{
		fb$result$1 = (boolean)1ll;
		goto label$231;
		label$234:;
	}
	if( *(struct $6ILINKW**)THIS$1 == (struct $6ILINKW*)0ull) goto label$235;
	TMP$8426$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$244;
	label$235:;
	TMP$8426$1 = -1ll;
	label$244:;
	if( TMP$8426$1 == 0ll) goto label$237;
	{
		fb$result$1 = (boolean)0ll;
		goto label$231;
		label$237:;
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
	if( A$1 == (void*)0ull) goto label$238;
	TMP$8427$1 = (int64)-(A$1 == B$1);
	goto label$245;
	label$238:;
	TMP$8427$1 = 0ll;
	label$245:;
	SAME$1 = (boolean)(TMP$8427$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$240;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI6ILINKWE8tmp$8428Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6ILINKWE8tmp$8428Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$240:;
	}
	if( B$1 == (void*)0ull) goto label$242;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI6ILINKWE8tmp$8429Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6ILINKWE8tmp$8429Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$242:;
	}
	fb$result$1 = SAME$1;
	goto label$231;
	label$231:;
	return fb$result$1;
}

static struct $6ILINKW* _ZptR6ComPtrI6ILINKWE( struct $6ComPtrI6ILINKWE* H$1 )
{
	struct $6ILINKW* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$246:;
	fb$result$1 = *(struct $6ILINKW**)H$1;
	goto label$247;
	label$247:;
	return fb$result$1;
}

static void _ZN6ComPtrI6IPFILEEC1Ev( struct $6ComPtrI6IPFILEE* THIS$1 )
{
	label$248:;
	__builtin_memset( (struct $6IPFILE**)THIS$1, 0, 8ll );
	*(struct $6IPFILE**)THIS$1 = (struct $6IPFILE*)0ull;
	label$249:;
}

static void _ZN6ComPtrI6IPFILEEC1EPS0_( struct $6ComPtrI6IPFILEE* THIS$1, struct $6IPFILE* RAW$1 )
{
	label$250:;
	__builtin_memset( (struct $6IPFILE**)THIS$1, 0, 8ll );
	*(struct $6IPFILE**)THIS$1 = RAW$1;
	if( *(struct $6IPFILE**)THIS$1 == (struct $6IPFILE*)0ull) goto label$253;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IPFILEE8tmp$8430Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IPFILEE8tmp$8430Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$253:;
	}
	label$251:;
}

static void _ZN6ComPtrI6IPFILEEC1ERS1_( struct $6ComPtrI6IPFILEE* THIS$1, struct $6ComPtrI6IPFILEE* RHS$1 )
{
	label$254:;
	__builtin_memset( (struct $6IPFILE**)THIS$1, 0, 8ll );
	*(struct $6IPFILE**)THIS$1 = *(struct $6IPFILE**)RHS$1;
	if( *(struct $6IPFILE**)THIS$1 == (struct $6IPFILE*)0ull) goto label$257;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IPFILEE8tmp$8431Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IPFILEE8tmp$8431Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$257:;
	}
	label$255:;
}

static void _ZN6ComPtrI6IPFILEED1Ev( struct $6ComPtrI6IPFILEE* THIS$1 )
{
	label$258:;
	_ZN6ComPtrI6IPFILEE7RELEASEEv( THIS$1 );
	label$259:;
}

static void _ZN6ComPtrI6IPFILEEaSERS1_( struct $6ComPtrI6IPFILEE* THIS$1, struct $6ComPtrI6IPFILEE* RHS$1 )
{
	label$260:;
	if( *(struct $6IPFILE**)THIS$1 != *(struct $6IPFILE**)RHS$1) goto label$263;
	{
		goto label$261;
		label$263:;
	}
	struct $6IPFILE* OLD$1;
	OLD$1 = *(struct $6IPFILE**)THIS$1;
	*(struct $6IPFILE**)THIS$1 = *(struct $6IPFILE**)RHS$1;
	if( *(struct $6IPFILE**)THIS$1 == (struct $6IPFILE*)0ull) goto label$265;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IPFILEE8tmp$8432Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IPFILEE8tmp$8432Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$265:;
	}
	if( OLD$1 == (struct $6IPFILE*)0ull) goto label$267;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI6IPFILEE8tmp$8433Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IPFILEE8tmp$8433Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$267:;
	}
	label$261:;
}

static struct $6IPFILE* _ZN6ComPtrI6IPFILEE3GETEv( struct $6ComPtrI6IPFILEE* THIS$1 )
{
	struct $6IPFILE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$268:;
	fb$result$1 = *(struct $6IPFILE**)THIS$1;
	goto label$269;
	label$269:;
	return fb$result$1;
}

static struct $6IPFILE* _ZN6ComPtrI6IPFILEE3REFEv( struct $6ComPtrI6IPFILEE* THIS$1 )
{
	struct $6IPFILE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$270:;
	if( *(struct $6IPFILE**)THIS$1 != (struct $6IPFILE*)0ull) goto label$273;
	{
		label$274:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$275:;
	}
	label$273:;
	label$272:;
	fb$result$1 = *(struct $6IPFILE**)THIS$1;
	goto label$271;
	label$271:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI6IPFILEE6ISNULLEv( struct $6ComPtrI6IPFILEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$276:;
	fb$result$1 = (boolean)((int64)-(*(struct $6IPFILE**)THIS$1 == (struct $6IPFILE*)0ull) != 0ll);
	goto label$277;
	label$277:;
	return fb$result$1;
}

static void _ZN6ComPtrI6IPFILEE6ATTACHEPS0_( struct $6ComPtrI6IPFILEE* THIS$1, struct $6IPFILE* RAW$1 )
{
	label$278:;
	_ZN6ComPtrI6IPFILEE7RELEASEEv( THIS$1 );
	*(struct $6IPFILE**)THIS$1 = RAW$1;
	label$279:;
}

static struct $6IPFILE* _ZN6ComPtrI6IPFILEE6DETACHEv( struct $6ComPtrI6IPFILEE* THIS$1 )
{
	struct $6IPFILE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$280:;
	struct $6IPFILE* R$1;
	R$1 = *(struct $6IPFILE**)THIS$1;
	*(struct $6IPFILE**)THIS$1 = (struct $6IPFILE*)0ull;
	fb$result$1 = R$1;
	goto label$281;
	label$281:;
	return fb$result$1;
}

static void _ZN6ComPtrI6IPFILEE7RELEASEEv( struct $6ComPtrI6IPFILEE* THIS$1 )
{
	label$282:;
	if( *(struct $6IPFILE**)THIS$1 == (struct $6IPFILE*)0ull) goto label$285;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $6IPFILE**)THIS$1 = (struct $6IPFILE*)0ull;
		typedef uint32 (*_ZN6ComPtrI6IPFILEE8tmp$8434Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IPFILEE8tmp$8434Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$285:;
	label$284:;
	label$283:;
}

static int32 _ZN6ComPtrI6IPFILEE6COPYTOEPPS0_( struct $6ComPtrI6IPFILEE* THIS$1, struct $6IPFILE** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$286:;
	if( PP$1 != (struct $6IPFILE**)0ull) goto label$289;
	{
		fb$result$1 = -2147467261;
		goto label$287;
		label$289:;
	}
	*PP$1 = *(struct $6IPFILE**)THIS$1;
	if( *(struct $6IPFILE**)THIS$1 == (struct $6IPFILE*)0ull) goto label$291;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IPFILEE8tmp$8435Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IPFILEE8tmp$8435Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$291:;
	}
	fb$result$1 = 0;
	goto label$287;
	label$287:;
	return fb$result$1;
}

static struct $6IPFILE** _ZN6ComPtrI6IPFILEE6PUTREFEv( struct $6ComPtrI6IPFILEE* THIS$1 )
{
	struct $6IPFILE** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$292:;
	if( *(struct $6IPFILE**)THIS$1 == (struct $6IPFILE*)0ull) goto label$295;
	{
		label$296:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$297:;
		label$295:;
	}
	fb$result$1 = (struct $6IPFILE**)THIS$1;
	goto label$293;
	label$293:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI6IPFILEE7UNKNOWNEv( struct $6ComPtrI6IPFILEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$298:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$299;
	label$299:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI6IPFILEE13ISEQUALOBJECTEPv( struct $6ComPtrI6IPFILEE* THIS$1, void* OTHER$1 )
{
	int64 TMP$8436$1;
	int64 TMP$8437$1;
	int64 TMP$8438$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$300:;
	if( *(struct $6IPFILE**)THIS$1 != (struct $6IPFILE*)0ull) goto label$302;
	TMP$8436$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$313;
	label$302:;
	TMP$8436$1 = 0ll;
	label$313:;
	if( TMP$8436$1 == 0ll) goto label$304;
	{
		fb$result$1 = (boolean)1ll;
		goto label$301;
		label$304:;
	}
	if( *(struct $6IPFILE**)THIS$1 == (struct $6IPFILE*)0ull) goto label$305;
	TMP$8437$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$314;
	label$305:;
	TMP$8437$1 = -1ll;
	label$314:;
	if( TMP$8437$1 == 0ll) goto label$307;
	{
		fb$result$1 = (boolean)0ll;
		goto label$301;
		label$307:;
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
	if( A$1 == (void*)0ull) goto label$308;
	TMP$8438$1 = (int64)-(A$1 == B$1);
	goto label$315;
	label$308:;
	TMP$8438$1 = 0ll;
	label$315:;
	SAME$1 = (boolean)(TMP$8438$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$310;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI6IPFILEE8tmp$8439Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IPFILEE8tmp$8439Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$310:;
	}
	if( B$1 == (void*)0ull) goto label$312;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI6IPFILEE8tmp$8440Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IPFILEE8tmp$8440Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$312:;
	}
	fb$result$1 = SAME$1;
	goto label$301;
	label$301:;
	return fb$result$1;
}

static int32 _Z7ComCastI6ILINKW6IPFILEER6ComPtrI6ILINKWER6ComPtrI6IPFILEE( struct $6ComPtrI6ILINKWE* SRC$1, struct $6ComPtrI6IPFILEE* DST$1 )
{
	int64 TMP$8442$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$316:;
	_ZN6ComPtrI6IPFILEE7RELEASEEv( DST$1 );
	boolean vr$1 = _ZN6ComPtrI6ILINKWE6ISNULLEv( SRC$1 );
	if( vr$1 == (boolean)0ll) goto label$319;
	{
		fb$result$1 = -2147467261;
		goto label$317;
		label$319:;
	}
	struct $6IidTagI6IPFILEE TAG$1;
	__builtin_memset( &TAG$1, 0, 4ll );
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $5_GUID* vr$4 = _Z5IIDOF6IidTagI6IPFILEE( TAG$1 );
	struct $N2FB10COMUNKNOWNE* vr$5 = _ZN6ComPtrI6ILINKWE7UNKNOWNEv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$7 = _ZN6ComPtrI6ILINKWE7UNKNOWNEv( SRC$1 );
	typedef int32 (*_Z8tmp$8441PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$6 = (*(_Z8tmp$8441PK5_GUIDPPv*)*(void***)vr$7)( vr$5, vr$4, &OUT_$1 );
	HR$1 = vr$6;
	if( (int64)HR$1 < 0ll) goto label$320;
	TMP$8442$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$323;
	label$320:;
	TMP$8442$1 = 0ll;
	label$323:;
	if( TMP$8442$1 == 0ll) goto label$322;
	{
		_ZN6ComPtrI6IPFILEE6ATTACHEPS0_( DST$1, (struct $6IPFILE*)OUT_$1 );
	}
	label$322:;
	label$321:;
	fb$result$1 = HR$1;
	goto label$317;
	label$317:;
	return fb$result$1;
}

__attribute__(( constructor )) static void fb_ctor__comptrzportzequivalence( void )
{
	label$0:;
	{
		struct $N2FB7COMINITE CO$1;
		_ZN2FB7COMINITC1Ej( &CO$1, 2u );
		boolean vr$2 = _ZN2FB7COMINIT2OKEv( &CO$1 );
		if( (int64)-vr$2 != 0ll) goto label$325;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-port-equivalence.bas", 139ll, (char*)"__FB_MODLEVELPROC__", (char*)"co.Ok( )" );
			label$325:;
		}
		struct $6TRACE_ RAW_$1;
		__builtin_memset( &RAW_$1, 0, 16ll );
		struct $6TRACE_ COM_$1;
		__builtin_memset( &COM_$1, 0, 16ll );
		int32 vr$7 = RAWFLOW( &RAW_$1 );
		if( (int64)vr$7 == 0ll) goto label$327;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-port-equivalence.bas", 142ll, (char*)"__FB_MODLEVELPROC__", (char*)"RawFlow( raw_ ) = S_OK" );
			label$327:;
		}
		int32 vr$10 = COMPTRFLOW( &COM_$1 );
		if( (int64)vr$10 == 0ll) goto label$329;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-port-equivalence.bas", 143ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComPtrFlow( com_ ) = S_OK" );
			label$329:;
		}
		if( (int64)*(int32*)&RAW_$1 == (int64)*(int32*)&COM_$1) goto label$331;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-port-equivalence.bas", 149ll, (char*)"__FB_MODLEVELPROC__", (char*)"raw_.afterCreate = com_.afterCreate" );
			label$331:;
		}
		if( (int64)*(int32*)((uint8*)&RAW_$1 + 4ll) == (int64)*(int32*)((uint8*)&COM_$1 + 4ll)) goto label$333;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-port-equivalence.bas", 150ll, (char*)"__FB_MODLEVELPROC__", (char*)"raw_.afterQuery = com_.afterQuery" );
			label$333:;
		}
		if( (int64)*(int32*)((uint8*)&RAW_$1 + 8ll) == (int64)*(int32*)((uint8*)&COM_$1 + 8ll)) goto label$335;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-port-equivalence.bas", 151ll, (char*)"__FB_MODLEVELPROC__", (char*)"raw_.afterReleasingQueried = com_.afterReleasingQueried" );
			label$335:;
		}
		if( (int64)-(boolean)(*(boolean*)((uint8*)&RAW_$1 + 12ll) == *(boolean*)((uint8*)&COM_$1 + 12ll)) != 0ll) goto label$337;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-port-equivalence.bas", 152ll, (char*)"__FB_MODLEVELPROC__", (char*)"raw_.queriedIsDifferentPointer = com_.queriedIsDifferentPointer" );
			label$337:;
		}
		if( (int64)*(int32*)((uint8*)&COM_$1 + 4ll) > (int64)*(int32*)&COM_$1) goto label$339;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-port-equivalence.bas", 156ll, (char*)"__FB_MODLEVELPROC__", (char*)"com_.afterQuery > com_.afterCreate" );
			label$339:;
		}
		if( (int64)*(int32*)((uint8*)&COM_$1 + 8ll) == (int64)*(int32*)&COM_$1) goto label$341;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-port-equivalence.bas", 157ll, (char*)"__FB_MODLEVELPROC__", (char*)"com_.afterReleasingQueried = com_.afterCreate" );
			label$341:;
		}
		FBSTRING* vr$24 = fb_StrAllocTempDescZEx( (char*)"  IPersistFile is a different pointer from IShellLink: ", 55ll );
		fb_PrintString( 0, (FBSTRING*)vr$24, 0 );
		fb_PrintBool( 0, *(boolean*)((uint8*)&COM_$1 + 12ll), 1 );
		_ZN2FB7COMINITD1Ev( &CO$1 );
	}
	FBSTRING* vr$26 = fb_StrAllocTempDescZEx( (char*)"comptr-port-equivalence: ok", 27ll );
	fb_PrintString( 0, (FBSTRING*)vr$26, 1 );
	label$1:;
}

static void _ZN2FB10COMUNKNOWNC1Ev( struct $N2FB10COMUNKNOWNE* THIS$1 )
{
	_ZN10fb_Object$C1Ev( (struct $10fb_Object$*)THIS$1 );
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN2FB10COMUNKNOWNE + 16ll);
	label$53:;
	label$54:;
}

static void _ZN2FB10COMUNKNOWNaSERKS0_( struct $N2FB10COMUNKNOWNE* THIS$1, struct $N2FB10COMUNKNOWNE* __FB_RHS__$1 )
{
	label$55:;
	label$56:;
}

static void _ZN2FB11COMDISPATCHaSERKS0_( struct $N2FB11COMDISPATCHE* THIS$1, struct $N2FB11COMDISPATCHE* __FB_RHS__$1 )
{
	label$61:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$62:;
}

static struct $N2FB10COMUNKNOWNE* _ZN2FB6HASUNKEPv( void* P$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$65:;
	fb$result$1 = (struct $N2FB10COMUNKNOWNE*)P$1;
	goto label$66;
	label$66:;
	return fb$result$1;
}

static struct $5_GUID* _ZN2FB11HIIDUNKNOWNEv( void )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$67:;
	static struct $5_GUID G$1 = { 0u, (uint16)0u, (uint16)0u, { (uint8)192u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)70u } };
	fb$result$1 = (struct $5_GUID*)&G$1;
	goto label$68;
	label$68:;
	return fb$result$1;
}

static void* _ZN2FB10HCANONICALEPNS_10COMUNKNOWNE( struct $N2FB10COMUNKNOWNE* P$1 )
{
	void* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$69:;
	if( P$1 != (struct $N2FB10COMUNKNOWNE*)0ull) goto label$72;
	{
		fb$result$1 = (void*)0ull;
		goto label$70;
		label$72:;
	}
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	struct $5_GUID* vr$2 = _ZN2FB11HIIDUNKNOWNEv(  );
	typedef int32 (*_ZN2FB8tmp$8379EPK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$3 = (*(_ZN2FB8tmp$8379EPK5_GUIDPPv*)*(void***)P$1)( P$1, vr$2, &OUT_$1 );
	if( (int64)vr$3 >= 0ll) goto label$74;
	{
		fb$result$1 = (void*)0ull;
		goto label$70;
		label$74:;
	}
	fb$result$1 = OUT_$1;
	goto label$70;
	label$70:;
	return fb$result$1;
}

static void _ZN2FB7COMINITC1Ej( struct $N2FB7COMINITE* THIS$1, uint32 MODE$1 )
{
	label$75:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	int32 vr$2 = CoInitializeEx( (void*)0ull, MODE$1 );
	*(int32*)THIS$1 = vr$2;
	label$76:;
}

static void _ZN2FB7COMINITD1Ev( struct $N2FB7COMINITE* THIS$1 )
{
	label$81:;
	if( (int64)*(int32*)THIS$1 < 0ll) goto label$84;
	{
		CoUninitialize(  );
		label$84:;
	}
	label$82:;
}

static boolean _ZN2FB7COMINIT2OKEv( struct $N2FB7COMINITE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$85:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)THIS$1 >= 0ll) != 0ll);
	goto label$86;
	label$86:;
	return fb$result$1;
}

static void _ZN2FB18COMCONNECTIONPOINTaSERKS0_( struct $N2FB18COMCONNECTIONPOINTE* THIS$1, struct $N2FB18COMCONNECTIONPOINTE* __FB_RHS__$1 )
{
	label$91:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$92:;
}

static void _ZN2FB27COMCONNECTIONPOINTCONTAINERaSERKS0_( struct $N2FB27COMCONNECTIONPOINTCONTAINERE* THIS$1, struct $N2FB27COMCONNECTIONPOINTCONTAINERE* __FB_RHS__$1 )
{
	label$97:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$98:;
}

static void _ZN2FB17COMOBJECTWITHSITEaSERKS0_( struct $N2FB17COMOBJECTWITHSITEE* THIS$1, struct $N2FB17COMOBJECTWITHSITEE* __FB_RHS__$1 )
{
	label$103:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$104:;
}

static struct $5_GUID* _ZN2FB22HIIDCONNPOINTCONTAINEREv( void )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$107:;
	static struct $5_GUID G$1 = { 2979443332u, (uint16)47796u, (uint16)4122u, { (uint8)182u, (uint8)156u, (uint8)0u, (uint8)170u, (uint8)0u, (uint8)52u, (uint8)29u, (uint8)7u } };
	fb$result$1 = (struct $5_GUID*)&G$1;
	goto label$108;
	label$108:;
	return fb$result$1;
}

static struct $5_GUID* _ZN2FB18HIIDOBJECTWITHSITEEv( void )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$109:;
	static struct $5_GUID G$1 = { 4232577443u, (uint16)11177u, (uint16)4559u, { (uint8)162u, (uint8)41u, (uint8)0u, (uint8)170u, (uint8)0u, (uint8)61u, (uint8)115u, (uint8)82u } };
	fb$result$1 = (struct $5_GUID*)&G$1;
	goto label$110;
	label$110:;
	return fb$result$1;
}

static void _ZN6ILINKWaSERKS_( struct $6ILINKW* THIS$1, struct $6ILINKW* __FB_RHS__$1 )
{
	label$144:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$145:;
}

static void _ZN6IPFILEaSERKS_( struct $6IPFILE* THIS$1, struct $6IPFILE* __FB_RHS__$1 )
{
	label$150:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$151:;
}

static struct $5_GUID* _Z5IIDOF6IidTagI6IPFILEE( struct $6IidTagI6IPFILEE TAG$1 )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$156:;
	fb$result$1 = (struct $5_GUID*)&IID_IPFILE$;
	goto label$157;
	label$157:;
	return fb$result$1;
}

static int32 RC( void* P$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$158:;
	if( P$1 != (void*)0ull) goto label$161;
	{
		fb$result$1 = -1;
		goto label$159;
		label$161:;
	}
	struct $N2FB10COMUNKNOWNE* U$1;
	U$1 = (struct $N2FB10COMUNKNOWNE*)P$1;
	uint32 N$1;
	uint32 vr$1 = (*(tmp$8410*)((uint8*)*(void***)U$1 + 8ll))( U$1 );
	N$1 = vr$1;
	(*(tmp$8410*)((uint8*)*(void***)U$1 + 16ll))( U$1 );
	fb$result$1 = (int32)((int64)N$1 + -1ll);
	goto label$159;
	label$159:;
	return fb$result$1;
}

static int32 RAWFLOW( struct $6TRACE_* T$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$162:;
	void* RAWLINK$1;
	RAWLINK$1 = (void*)0ull;
	int32 HR$1;
	int32 vr$2 = CoCreateInstance( (struct $5_GUID*)&CLSID_ShellLink, (struct $9IUnknown_*)0ull, 1u, (struct $5_GUID*)&IID_ILINKW$, &RAWLINK$1 );
	HR$1 = vr$2;
	if( (int64)HR$1 >= 0ll) goto label$165;
	{
		fb$result$1 = HR$1;
		goto label$163;
		label$165:;
	}
	int32 vr$4 = RC( RAWLINK$1 );
	*(int32*)T$1 = vr$4;
	struct $6ILINKW* LINK$1;
	LINK$1 = (struct $6ILINKW*)RAWLINK$1;
	int32 vr$6 = (*(tmp$8411*)((uint8*)*(void***)LINK$1 + 160ll))( LINK$1, (uint16*)L"C:\x005CWindows\x005C" L"explorer.exe" );
	HR$1 = vr$6;
	if( (int64)HR$1 >= 0ll) goto label$167;
	{
		(*(tmp$8410*)((uint8*)*(void***)LINK$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)LINK$1 );
		fb$result$1 = HR$1;
		goto label$163;
		label$167:;
	}
	void* RAWFILE$1;
	RAWFILE$1 = (void*)0ull;
	int32 vr$13 = (*(tmp$8415*)*(void***)LINK$1)( (struct $N2FB10COMUNKNOWNE*)LINK$1, (struct $5_GUID*)&IID_IPFILE$, &RAWFILE$1 );
	HR$1 = vr$13;
	if( (int64)HR$1 >= 0ll) goto label$169;
	{
		(*(tmp$8410*)((uint8*)*(void***)LINK$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)LINK$1 );
		fb$result$1 = HR$1;
		goto label$163;
		label$169:;
	}
	int32 vr$19 = RC( RAWLINK$1 );
	*(int32*)((uint8*)T$1 + 4ll) = vr$19;
	*(boolean*)((uint8*)T$1 + 12ll) = (boolean)((int64)-(RAWFILE$1 != RAWLINK$1) != 0ll);
	struct $6IPFILE* FILE$1;
	FILE$1 = (struct $6IPFILE*)RAWFILE$1;
	(*(tmp$8410*)((uint8*)*(void***)FILE$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)FILE$1 );
	int32 vr$26 = RC( RAWLINK$1 );
	*(int32*)((uint8*)T$1 + 8ll) = vr$26;
	(*(tmp$8410*)((uint8*)*(void***)LINK$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)LINK$1 );
	fb$result$1 = 0;
	goto label$163;
	label$163:;
	return fb$result$1;
}

static int32 COMPTRFLOW( struct $6TRACE_* T$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$170:;
	struct $6ComPtrI6ILINKWE LINK$1;
	_ZN6ComPtrI6ILINKWEC1Ev( &LINK$1 );
	int32 HR$1;
	struct $6ILINKW** vr$3 = _ZN6ComPtrI6ILINKWE6PUTREFEv( &LINK$1 );
	int32 vr$4 = CoCreateInstance( (struct $5_GUID*)&CLSID_ShellLink, (struct $9IUnknown_*)0ull, 1u, (struct $5_GUID*)&IID_ILINKW$, (void**)vr$3 );
	HR$1 = vr$4;
	if( (int64)HR$1 >= 0ll) goto label$173;
	{
		fb$result$1 = HR$1;
		_ZN6ComPtrI6ILINKWED1Ev( &LINK$1 );
		goto label$171;
		label$173:;
	}
	struct $6ILINKW* vr$8 = _ZN6ComPtrI6ILINKWE3GETEv( &LINK$1 );
	int32 vr$9 = RC( (void*)vr$8 );
	*(int32*)T$1 = vr$9;
	struct $6ILINKW* vr$12 = _ZptR6ComPtrI6ILINKWE( &LINK$1 );
	struct $6ILINKW* vr$15 = _ZptR6ComPtrI6ILINKWE( &LINK$1 );
	int32 vr$13 = (*(tmp$8411*)((uint8*)*(void***)vr$15 + 160ll))( vr$12, (uint16*)L"C:\x005CWindows\x005C" L"explorer.exe" );
	HR$1 = vr$13;
	if( (int64)HR$1 >= 0ll) goto label$175;
	{
		fb$result$1 = HR$1;
		_ZN6ComPtrI6ILINKWED1Ev( &LINK$1 );
		goto label$171;
		label$175:;
	}
	{
		struct $6ComPtrI6IPFILEE FILE$2;
		_ZN6ComPtrI6IPFILEEC1Ev( &FILE$2 );
		int32 vr$22 = _Z7ComCastI6ILINKW6IPFILEER6ComPtrI6ILINKWER6ComPtrI6IPFILEE( &LINK$1, &FILE$2 );
		HR$1 = vr$22;
		if( (int64)HR$1 >= 0ll) goto label$177;
		{
			fb$result$1 = HR$1;
			_ZN6ComPtrI6IPFILEED1Ev( &FILE$2 );
			_ZN6ComPtrI6ILINKWED1Ev( &LINK$1 );
			goto label$171;
			label$177:;
		}
		struct $6ILINKW* vr$27 = _ZN6ComPtrI6ILINKWE3GETEv( &LINK$1 );
		int32 vr$28 = RC( (void*)vr$27 );
		*(int32*)((uint8*)T$1 + 4ll) = vr$28;
		struct $6IPFILE* vr$31 = _ZN6ComPtrI6IPFILEE3GETEv( &FILE$2 );
		struct $6ILINKW* vr$33 = _ZN6ComPtrI6ILINKWE3GETEv( &LINK$1 );
		*(boolean*)((uint8*)T$1 + 12ll) = (boolean)((int64)-((void*)vr$31 != (void*)vr$33) != 0ll);
		_ZN6ComPtrI6IPFILEED1Ev( &FILE$2 );
	}
	struct $6ILINKW* vr$39 = _ZN6ComPtrI6ILINKWE3GETEv( &LINK$1 );
	int32 vr$40 = RC( (void*)vr$39 );
	*(int32*)((uint8*)T$1 + 8ll) = vr$40;
	fb$result$1 = 0;
	_ZN6ComPtrI6ILINKWED1Ev( &LINK$1 );
	goto label$171;
	_ZN6ComPtrI6ILINKWED1Ev( &LINK$1 );
	label$171:;
	return fb$result$1;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0kernel32\0-l\0gdi32\0-l\0msimg32\0-l\0user32\0-l\0version\0-l\0advapi32\0-l\0imm32\0-l\0uuid\0-l\0ole32\0-l\0oleaut32\0-l\0shell32\0-l\0comctl32";
