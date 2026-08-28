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
struct $14NOTANINTERFACE {
	int32 X;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $14NOTANINTERFACE ) == 4 );
struct $6ComPtrI14NOTANINTERFACEE {
	struct $14NOTANINTERFACE* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrI14NOTANINTERFACEE ) == 8 );
struct $10fb_Object$ {
	void* VPTR$;
};
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
struct $13ArrayIteratorI6ComPtrI5IFAKEEE {
	void* SRC;
	int32 IDX;
};
__FB_STATIC_ASSERT( sizeof( struct $13ArrayIteratorI6ComPtrI5IFAKEEE ) == 16 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
struct $8FBARRAY1I6ComPtrI5IFAKEEE {
	struct $6ComPtrI5IFAKEE* DATA;
	struct $6ComPtrI5IFAKEE* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1I6ComPtrI5IFAKEEE ) == 72 );
struct $5ArrayI6ComPtrI5IFAKEEE {
	struct $8FBARRAY1I6ComPtrI5IFAKEEE ITEMS;
	int32 NUM;
};
__FB_STATIC_ASSERT( sizeof( struct $5ArrayI6ComPtrI5IFAKEEE ) == 80 );
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
struct $6ComPtrIN2FB10COMUNKNOWNEE {
	struct $N2FB10COMUNKNOWNE* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrIN2FB10COMUNKNOWNEE ) == 8 );
typedef uint32 (*tmp$2119)( struct $N2FB10COMUNKNOWNE* );
typedef int32 (*tmp$2127)( struct $5IFAKE* );
typedef void (*tmp$252)( void );
struct $6HOLDER {
	struct $6ComPtrI5IFAKEE INNER;
};
__FB_STATIC_ASSERT( sizeof( struct $6HOLDER ) == 8 );
struct $5_GUID {
	uint32 DATA1;
	uint16 DATA2;
	uint16 DATA3;
	uint8 DATA4[8];
};
__FB_STATIC_ASSERT( sizeof( struct $5_GUID ) == 16 );
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
	int32 POKED;
};
__FB_STATIC_ASSERT( sizeof( struct $4FAKE ) == 16 );
void _ZN10fb_Object$C1Ev( struct $10fb_Object$* );
int32 fb_ArrayRedimPresvObj( struct $7FBARRAYIvE*, uint64, void*, void*, uint64, ... );
int32 fb_ArrayRedimTo( struct $7FBARRAYIvE*, struct $7FBARRAYIvE*, int32, void*, void* );
int32 fb_ArrayEraseObj( struct $7FBARRAYIvE*, void*, void* );
int64 fb_ArrayLBound( struct $7FBARRAYIKvE*, int64 );
int64 fb_ArrayUBound( struct $7FBARRAYIKvE*, int64 );
void* fb_ErrorThrowEx( int32, int32, char*, void*, void* );
void fb_Assert( char*, int64, char*, char* );
void* calloc( uint64, uint64 );
void free( void* );
void fb_PrintString( int32, FBSTRING*, int32 );
FBSTRING* fb_StrAllocTempDescZEx( char*, int64 );
static void fb_ctor__comptr( void ) __attribute__(( constructor ));
int64 _InterlockedExchangeAdd64( int64*, int64 );
int32 _InterlockedExchangeAdd( int32*, int32 );
void CoUninitialize( void );
int32 CoInitializeEx( void*, uint32 );
int32 CoCreateInstance( struct $5_GUID*, struct $9IUnknown_*, uint32, struct $5_GUID*, void** );
static void _ZN2FB10COMUNKNOWNC1Ev( struct $N2FB10COMUNKNOWNE* );
static void _ZN2FB10COMUNKNOWNaSERKS0_( struct $N2FB10COMUNKNOWNE*, struct $N2FB10COMUNKNOWNE* );
static void _ZN2FB11COMDISPATCHaSERKS0_( struct $N2FB11COMDISPATCHE*, struct $N2FB11COMDISPATCHE* );
static struct $N2FB10COMUNKNOWNE* _ZN2FB6HASUNKEPv( void* );
static struct $5_GUID* _ZN2FB11HIIDUNKNOWNEv( void );
static void* _ZN2FB10HCANONICALEPNS_10COMUNKNOWNE( struct $N2FB10COMUNKNOWNE* );
static void _ZN2FB18COMCONNECTIONPOINTaSERKS0_( struct $N2FB18COMCONNECTIONPOINTE*, struct $N2FB18COMCONNECTIONPOINTE* );
static void _ZN2FB27COMCONNECTIONPOINTCONTAINERaSERKS0_( struct $N2FB27COMCONNECTIONPOINTCONTAINERE*, struct $N2FB27COMCONNECTIONPOINTCONTAINERE* );
static void _ZN2FB17COMOBJECTWITHSITEaSERKS0_( struct $N2FB17COMOBJECTWITHSITEE*, struct $N2FB17COMOBJECTWITHSITEE* );
static struct $5_GUID* _ZN2FB22HIIDCONNPOINTCONTAINEREv( void );
static struct $5_GUID* _ZN2FB18HIIDOBJECTWITHSITEEv( void );
static void _ZN5IFAKEaSERKS_( struct $5IFAKE*, struct $5IFAKE* );
static int32 FAKEQI( struct $4FAKE*, struct $5_GUID*, void** );
static uint32 FAKEADDREF( struct $4FAKE* );
static uint32 FAKERELEASE( struct $4FAKE* );
static int32 FAKEPOKE( struct $4FAKE* );
static struct $5IFAKE* NEWFAKE( void );
static int32 REFSOF( void* );
static void _ZN6ComPtrI14NOTANINTERFACEEC1Ev( struct $6ComPtrI14NOTANINTERFACEE* );
static void _ZN6ComPtrI14NOTANINTERFACEED1Ev( struct $6ComPtrI14NOTANINTERFACEE* );
static boolean _ZN6ComPtrI14NOTANINTERFACEE6ISNULLEv( struct $6ComPtrI14NOTANINTERFACEE* );
static void _ZN6ComPtrI14NOTANINTERFACEE7RELEASEEv( struct $6ComPtrI14NOTANINTERFACEE* );
static void _ZN6ComPtrI5IFAKEEC1Ev( struct $6ComPtrI5IFAKEE* );
static void _ZN6ComPtrI5IFAKEEC1EPS0_( struct $6ComPtrI5IFAKEE*, struct $5IFAKE* );
static void _ZN6ComPtrI5IFAKEEC1ERS1_( struct $6ComPtrI5IFAKEE*, struct $6ComPtrI5IFAKEE* );
static void _ZN6ComPtrI5IFAKEED1Ev( struct $6ComPtrI5IFAKEE* );
static void _ZN6ComPtrI5IFAKEEaSERS1_( struct $6ComPtrI5IFAKEE*, struct $6ComPtrI5IFAKEE* );
static struct $5IFAKE* _ZN6ComPtrI5IFAKEE3GETEv( struct $6ComPtrI5IFAKEE* );
static struct $5IFAKE* _ZN6ComPtrI5IFAKEE3REFEv( struct $6ComPtrI5IFAKEE* );
static boolean _ZN6ComPtrI5IFAKEE6ISNULLEv( struct $6ComPtrI5IFAKEE* );
static void _ZN6ComPtrI5IFAKEE6ATTACHEPS0_( struct $6ComPtrI5IFAKEE*, struct $5IFAKE* );
static struct $5IFAKE* _ZN6ComPtrI5IFAKEE6DETACHEv( struct $6ComPtrI5IFAKEE* );
static void _ZN6ComPtrI5IFAKEE7RELEASEEv( struct $6ComPtrI5IFAKEE* );
static int32 _ZN6ComPtrI5IFAKEE6COPYTOEPPS0_( struct $6ComPtrI5IFAKEE*, struct $5IFAKE** );
static struct $5IFAKE** _ZN6ComPtrI5IFAKEE6PUTREFEv( struct $6ComPtrI5IFAKEE* );
static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI5IFAKEE7UNKNOWNEv( struct $6ComPtrI5IFAKEE* );
static boolean _ZN6ComPtrI5IFAKEE13ISEQUALOBJECTEPv( struct $6ComPtrI5IFAKEE*, void* );
static struct $5IFAKE* _ZptR6ComPtrI5IFAKEE( struct $6ComPtrI5IFAKEE* );
static void DROPY( void );
static void INSPECTZ( void );
static struct $5IFAKE* _ZdeR6ComPtrI5IFAKEE( struct $6ComPtrI5IFAKEE* );
static int32 EARLYRETURN( boolean );
static void TAKESBYREF( struct $6ComPtrI5IFAKEE*, int32* );
static void TAKESBYVAL( struct $6ComPtrI5IFAKEE*, int32* );
static int32 _ZN5ArrayI6ComPtrI5IFAKEEE5COUNTEv( struct $5ArrayI6ComPtrI5IFAKEEE* );
static int32 _ZN5ArrayI6ComPtrI5IFAKEEE8CAPACITYEv( struct $5ArrayI6ComPtrI5IFAKEEE* );
static void _ZN5ArrayI6ComPtrI5IFAKEEE4PUSHERS2_( struct $5ArrayI6ComPtrI5IFAKEEE*, struct $6ComPtrI5IFAKEE* );
static void _ZN5ArrayI6ComPtrI5IFAKEEE7RESERVEEi( struct $5ArrayI6ComPtrI5IFAKEEE*, int32 );
static void _ZN5ArrayI6ComPtrI5IFAKEEEC1Ev( struct $5ArrayI6ComPtrI5IFAKEEE* );
static void _ZN5ArrayI6ComPtrI5IFAKEEEaSERKS3_( struct $5ArrayI6ComPtrI5IFAKEEE*, struct $5ArrayI6ComPtrI5IFAKEEE* );
static void _ZN5ArrayI6ComPtrI5IFAKEEED1Ev( struct $5ArrayI6ComPtrI5IFAKEEE* );
static void _ZN6HOLDERC1Ev( struct $6HOLDER* );
static void _ZN6HOLDERaSERKS_( struct $6HOLDER*, struct $6HOLDER* );
static void _ZN6HOLDERD1Ev( struct $6HOLDER* );
static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1Ev( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1ERS2_( struct $6ComPtrIN2FB10COMUNKNOWNEE*, struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static void _ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static boolean _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static void _ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static int32 _ZN6ComPtrIN2FB10COMUNKNOWNEE6COPYTOEPPS1_( struct $6ComPtrIN2FB10COMUNKNOWNEE*, struct $N2FB10COMUNKNOWNE** );
static struct $N2FB10COMUNKNOWNE** _ZN6ComPtrIN2FB10COMUNKNOWNEE6PUTREFEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static boolean _ZN6ComPtrIN2FB10COMUNKNOWNEE13ISEQUALOBJECTEPv( struct $6ComPtrIN2FB10COMUNKNOWNEE*, void* );
static void _GLOBAL__I( void ) __attribute__(( constructor ));
static void _GLOBAL__D( void ) __attribute__(( destructor ));
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
static int32 G_DESTROYED$;
static struct $8fb_RTTI$ _ZTSN5IFAKEE = { (void*)0ull, (char*)"5IFAKE", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN5IFAKEE[6] = { (void*)0ull, (void*)&_ZTSN5IFAKEE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8FAKEVTBL G_VTBL$;
static tmp$252 G_ONDESTROY$;
static struct $6ComPtrI5IFAKEE G_Y$;
static struct $6ComPtrI5IFAKEE G_Z$;
static int32 G_ZWASNULLINHOOK$;

static void _ZN6ComPtrI14NOTANINTERFACEEC1Ev( struct $6ComPtrI14NOTANINTERFACEE* THIS$1 )
{
	label$143:;
	__builtin_memset( (struct $14NOTANINTERFACE**)THIS$1, 0, 8ll );
	*(struct $14NOTANINTERFACE**)THIS$1 = (struct $14NOTANINTERFACE*)0ull;
	label$144:;
}

static void _ZN6ComPtrI14NOTANINTERFACEEC1EPS0_( struct $6ComPtrI14NOTANINTERFACEE* THIS$1, struct $14NOTANINTERFACE* RAW$1 )
{
	label$145:;
	__builtin_memset( (struct $14NOTANINTERFACE**)THIS$1, 0, 8ll );
	*(struct $14NOTANINTERFACE**)THIS$1 = RAW$1;
	if( *(struct $14NOTANINTERFACE**)THIS$1 == (struct $14NOTANINTERFACE*)0ull) goto label$148;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI14NOTANINTERFACEE8tmp$2087Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI14NOTANINTERFACEE8tmp$2087Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$148:;
	}
	label$146:;
}

static void _ZN6ComPtrI14NOTANINTERFACEEC1ERS1_( struct $6ComPtrI14NOTANINTERFACEE* THIS$1, struct $6ComPtrI14NOTANINTERFACEE* RHS$1 )
{
	label$149:;
	__builtin_memset( (struct $14NOTANINTERFACE**)THIS$1, 0, 8ll );
	*(struct $14NOTANINTERFACE**)THIS$1 = *(struct $14NOTANINTERFACE**)RHS$1;
	if( *(struct $14NOTANINTERFACE**)THIS$1 == (struct $14NOTANINTERFACE*)0ull) goto label$152;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI14NOTANINTERFACEE8tmp$2088Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI14NOTANINTERFACEE8tmp$2088Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$152:;
	}
	label$150:;
}

static void _ZN6ComPtrI14NOTANINTERFACEED1Ev( struct $6ComPtrI14NOTANINTERFACEE* THIS$1 )
{
	label$153:;
	_ZN6ComPtrI14NOTANINTERFACEE7RELEASEEv( THIS$1 );
	label$154:;
}

static void _ZN6ComPtrI14NOTANINTERFACEEaSERS1_( struct $6ComPtrI14NOTANINTERFACEE* THIS$1, struct $6ComPtrI14NOTANINTERFACEE* RHS$1 )
{
	label$155:;
	if( *(struct $14NOTANINTERFACE**)THIS$1 != *(struct $14NOTANINTERFACE**)RHS$1) goto label$158;
	{
		goto label$156;
		label$158:;
	}
	struct $14NOTANINTERFACE* OLD$1;
	OLD$1 = *(struct $14NOTANINTERFACE**)THIS$1;
	*(struct $14NOTANINTERFACE**)THIS$1 = *(struct $14NOTANINTERFACE**)RHS$1;
	if( *(struct $14NOTANINTERFACE**)THIS$1 == (struct $14NOTANINTERFACE*)0ull) goto label$160;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI14NOTANINTERFACEE8tmp$2089Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI14NOTANINTERFACEE8tmp$2089Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$160:;
	}
	if( OLD$1 == (struct $14NOTANINTERFACE*)0ull) goto label$162;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI14NOTANINTERFACEE8tmp$2090Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI14NOTANINTERFACEE8tmp$2090Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$162:;
	}
	label$156:;
}

static struct $14NOTANINTERFACE* _ZN6ComPtrI14NOTANINTERFACEE3GETEv( struct $6ComPtrI14NOTANINTERFACEE* THIS$1 )
{
	struct $14NOTANINTERFACE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$163:;
	fb$result$1 = *(struct $14NOTANINTERFACE**)THIS$1;
	goto label$164;
	label$164:;
	return fb$result$1;
}

static struct $14NOTANINTERFACE* _ZN6ComPtrI14NOTANINTERFACEE3REFEv( struct $6ComPtrI14NOTANINTERFACEE* THIS$1 )
{
	struct $14NOTANINTERFACE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$165:;
	if( *(struct $14NOTANINTERFACE**)THIS$1 != (struct $14NOTANINTERFACE*)0ull) goto label$168;
	{
		label$169:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$170:;
	}
	label$168:;
	label$167:;
	fb$result$1 = *(struct $14NOTANINTERFACE**)THIS$1;
	goto label$166;
	label$166:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI14NOTANINTERFACEE6ISNULLEv( struct $6ComPtrI14NOTANINTERFACEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$171:;
	fb$result$1 = (boolean)((int64)-(*(struct $14NOTANINTERFACE**)THIS$1 == (struct $14NOTANINTERFACE*)0ull) != 0ll);
	goto label$172;
	label$172:;
	return fb$result$1;
}

static void _ZN6ComPtrI14NOTANINTERFACEE6ATTACHEPS0_( struct $6ComPtrI14NOTANINTERFACEE* THIS$1, struct $14NOTANINTERFACE* RAW$1 )
{
	label$173:;
	_ZN6ComPtrI14NOTANINTERFACEE7RELEASEEv( THIS$1 );
	*(struct $14NOTANINTERFACE**)THIS$1 = RAW$1;
	label$174:;
}

static struct $14NOTANINTERFACE* _ZN6ComPtrI14NOTANINTERFACEE6DETACHEv( struct $6ComPtrI14NOTANINTERFACEE* THIS$1 )
{
	struct $14NOTANINTERFACE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$175:;
	struct $14NOTANINTERFACE* R$1;
	R$1 = *(struct $14NOTANINTERFACE**)THIS$1;
	*(struct $14NOTANINTERFACE**)THIS$1 = (struct $14NOTANINTERFACE*)0ull;
	fb$result$1 = R$1;
	goto label$176;
	label$176:;
	return fb$result$1;
}

static void _ZN6ComPtrI14NOTANINTERFACEE7RELEASEEv( struct $6ComPtrI14NOTANINTERFACEE* THIS$1 )
{
	label$177:;
	if( *(struct $14NOTANINTERFACE**)THIS$1 == (struct $14NOTANINTERFACE*)0ull) goto label$180;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $14NOTANINTERFACE**)THIS$1 = (struct $14NOTANINTERFACE*)0ull;
		typedef uint32 (*_ZN6ComPtrI14NOTANINTERFACEE8tmp$2092Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI14NOTANINTERFACEE8tmp$2092Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$180:;
	label$179:;
	label$178:;
}

static int32 _ZN6ComPtrI14NOTANINTERFACEE6COPYTOEPPS0_( struct $6ComPtrI14NOTANINTERFACEE* THIS$1, struct $14NOTANINTERFACE** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$181:;
	if( PP$1 != (struct $14NOTANINTERFACE**)0ull) goto label$184;
	{
		fb$result$1 = -2147467261;
		goto label$182;
		label$184:;
	}
	*PP$1 = *(struct $14NOTANINTERFACE**)THIS$1;
	if( *(struct $14NOTANINTERFACE**)THIS$1 == (struct $14NOTANINTERFACE*)0ull) goto label$186;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI14NOTANINTERFACEE8tmp$2093Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI14NOTANINTERFACEE8tmp$2093Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$186:;
	}
	fb$result$1 = 0;
	goto label$182;
	label$182:;
	return fb$result$1;
}

static struct $14NOTANINTERFACE** _ZN6ComPtrI14NOTANINTERFACEE6PUTREFEv( struct $6ComPtrI14NOTANINTERFACEE* THIS$1 )
{
	struct $14NOTANINTERFACE** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$187:;
	if( *(struct $14NOTANINTERFACE**)THIS$1 == (struct $14NOTANINTERFACE*)0ull) goto label$190;
	{
		label$191:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$192:;
		label$190:;
	}
	fb$result$1 = (struct $14NOTANINTERFACE**)THIS$1;
	goto label$188;
	label$188:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI14NOTANINTERFACEE7UNKNOWNEv( struct $6ComPtrI14NOTANINTERFACEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$193:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$194;
	label$194:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI14NOTANINTERFACEE13ISEQUALOBJECTEPv( struct $6ComPtrI14NOTANINTERFACEE* THIS$1, void* OTHER$1 )
{
	int64 TMP$2094$1;
	int64 TMP$2095$1;
	int64 TMP$2096$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$195:;
	if( *(struct $14NOTANINTERFACE**)THIS$1 != (struct $14NOTANINTERFACE*)0ull) goto label$197;
	TMP$2094$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$208;
	label$197:;
	TMP$2094$1 = 0ll;
	label$208:;
	if( TMP$2094$1 == 0ll) goto label$199;
	{
		fb$result$1 = (boolean)1ll;
		goto label$196;
		label$199:;
	}
	if( *(struct $14NOTANINTERFACE**)THIS$1 == (struct $14NOTANINTERFACE*)0ull) goto label$200;
	TMP$2095$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$209;
	label$200:;
	TMP$2095$1 = -1ll;
	label$209:;
	if( TMP$2095$1 == 0ll) goto label$202;
	{
		fb$result$1 = (boolean)0ll;
		goto label$196;
		label$202:;
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
	if( A$1 == (void*)0ull) goto label$203;
	TMP$2096$1 = (int64)-(A$1 == B$1);
	goto label$210;
	label$203:;
	TMP$2096$1 = 0ll;
	label$210:;
	SAME$1 = (boolean)(TMP$2096$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$205;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI14NOTANINTERFACEE8tmp$2097Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI14NOTANINTERFACEE8tmp$2097Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$205:;
	}
	if( B$1 == (void*)0ull) goto label$207;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI14NOTANINTERFACEE8tmp$2098Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI14NOTANINTERFACEE8tmp$2098Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$207:;
	}
	fb$result$1 = SAME$1;
	goto label$196;
	label$196:;
	return fb$result$1;
}

static void _ZN6ComPtrI5IFAKEEC1Ev( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	label$223:;
	__builtin_memset( (struct $5IFAKE**)THIS$1, 0, 8ll );
	*(struct $5IFAKE**)THIS$1 = (struct $5IFAKE*)0ull;
	label$224:;
}

static void _ZN6ComPtrI5IFAKEEC1EPS0_( struct $6ComPtrI5IFAKEE* THIS$1, struct $5IFAKE* RAW$1 )
{
	label$225:;
	__builtin_memset( (struct $5IFAKE**)THIS$1, 0, 8ll );
	*(struct $5IFAKE**)THIS$1 = RAW$1;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$228;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2104Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2104Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$228:;
	}
	label$226:;
}

static void _ZN6ComPtrI5IFAKEEC1ERS1_( struct $6ComPtrI5IFAKEE* THIS$1, struct $6ComPtrI5IFAKEE* RHS$1 )
{
	label$229:;
	__builtin_memset( (struct $5IFAKE**)THIS$1, 0, 8ll );
	*(struct $5IFAKE**)THIS$1 = *(struct $5IFAKE**)RHS$1;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$232;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2105Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2105Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$232:;
	}
	label$230:;
}

static void _ZN6ComPtrI5IFAKEED1Ev( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	label$233:;
	_ZN6ComPtrI5IFAKEE7RELEASEEv( THIS$1 );
	label$234:;
}

static void _ZN6ComPtrI5IFAKEEaSERS1_( struct $6ComPtrI5IFAKEE* THIS$1, struct $6ComPtrI5IFAKEE* RHS$1 )
{
	label$235:;
	if( *(struct $5IFAKE**)THIS$1 != *(struct $5IFAKE**)RHS$1) goto label$238;
	{
		goto label$236;
		label$238:;
	}
	struct $5IFAKE* OLD$1;
	OLD$1 = *(struct $5IFAKE**)THIS$1;
	*(struct $5IFAKE**)THIS$1 = *(struct $5IFAKE**)RHS$1;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$240;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2106Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2106Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$240:;
	}
	if( OLD$1 == (struct $5IFAKE*)0ull) goto label$242;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2107Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2107Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$242:;
	}
	label$236:;
}

static struct $5IFAKE* _ZN6ComPtrI5IFAKEE3GETEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$243:;
	fb$result$1 = *(struct $5IFAKE**)THIS$1;
	goto label$244;
	label$244:;
	return fb$result$1;
}

static struct $5IFAKE* _ZN6ComPtrI5IFAKEE3REFEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$245:;
	if( *(struct $5IFAKE**)THIS$1 != (struct $5IFAKE*)0ull) goto label$248;
	{
		label$249:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$250:;
	}
	label$248:;
	label$247:;
	fb$result$1 = *(struct $5IFAKE**)THIS$1;
	goto label$246;
	label$246:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI5IFAKEE6ISNULLEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$251:;
	fb$result$1 = (boolean)((int64)-(*(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) != 0ll);
	goto label$252;
	label$252:;
	return fb$result$1;
}

static void _ZN6ComPtrI5IFAKEE6ATTACHEPS0_( struct $6ComPtrI5IFAKEE* THIS$1, struct $5IFAKE* RAW$1 )
{
	label$253:;
	_ZN6ComPtrI5IFAKEE7RELEASEEv( THIS$1 );
	*(struct $5IFAKE**)THIS$1 = RAW$1;
	label$254:;
}

static struct $5IFAKE* _ZN6ComPtrI5IFAKEE6DETACHEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$255:;
	struct $5IFAKE* R$1;
	R$1 = *(struct $5IFAKE**)THIS$1;
	*(struct $5IFAKE**)THIS$1 = (struct $5IFAKE*)0ull;
	fb$result$1 = R$1;
	goto label$256;
	label$256:;
	return fb$result$1;
}

static void _ZN6ComPtrI5IFAKEE7RELEASEEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	label$257:;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$260;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $5IFAKE**)THIS$1 = (struct $5IFAKE*)0ull;
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2108Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2108Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$260:;
	label$259:;
	label$258:;
}

static int32 _ZN6ComPtrI5IFAKEE6COPYTOEPPS0_( struct $6ComPtrI5IFAKEE* THIS$1, struct $5IFAKE** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$261:;
	if( PP$1 != (struct $5IFAKE**)0ull) goto label$264;
	{
		fb$result$1 = -2147467261;
		goto label$262;
		label$264:;
	}
	*PP$1 = *(struct $5IFAKE**)THIS$1;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$266;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2109Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2109Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$266:;
	}
	fb$result$1 = 0;
	goto label$262;
	label$262:;
	return fb$result$1;
}

static struct $5IFAKE** _ZN6ComPtrI5IFAKEE6PUTREFEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $5IFAKE** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$267:;
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$270;
	{
		label$271:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$272:;
		label$270:;
	}
	fb$result$1 = (struct $5IFAKE**)THIS$1;
	goto label$268;
	label$268:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI5IFAKEE7UNKNOWNEv( struct $6ComPtrI5IFAKEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$273:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$274;
	label$274:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI5IFAKEE13ISEQUALOBJECTEPv( struct $6ComPtrI5IFAKEE* THIS$1, void* OTHER$1 )
{
	int64 TMP$2110$1;
	int64 TMP$2111$1;
	int64 TMP$2112$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$275:;
	if( *(struct $5IFAKE**)THIS$1 != (struct $5IFAKE*)0ull) goto label$277;
	TMP$2110$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$288;
	label$277:;
	TMP$2110$1 = 0ll;
	label$288:;
	if( TMP$2110$1 == 0ll) goto label$279;
	{
		fb$result$1 = (boolean)1ll;
		goto label$276;
		label$279:;
	}
	if( *(struct $5IFAKE**)THIS$1 == (struct $5IFAKE*)0ull) goto label$280;
	TMP$2111$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$289;
	label$280:;
	TMP$2111$1 = -1ll;
	label$289:;
	if( TMP$2111$1 == 0ll) goto label$282;
	{
		fb$result$1 = (boolean)0ll;
		goto label$276;
		label$282:;
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
	if( A$1 == (void*)0ull) goto label$283;
	TMP$2112$1 = (int64)-(A$1 == B$1);
	goto label$290;
	label$283:;
	TMP$2112$1 = 0ll;
	label$290:;
	SAME$1 = (boolean)(TMP$2112$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$285;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2113Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2113Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$285:;
	}
	if( B$1 == (void*)0ull) goto label$287;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI5IFAKEE8tmp$2114Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI5IFAKEE8tmp$2114Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$287:;
	}
	fb$result$1 = SAME$1;
	goto label$276;
	label$276:;
	return fb$result$1;
}

static struct $5IFAKE* _ZptR6ComPtrI5IFAKEE( struct $6ComPtrI5IFAKEE* H$1 )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$339:;
	fb$result$1 = *(struct $5IFAKE**)H$1;
	goto label$340;
	label$340:;
	return fb$result$1;
}

static struct $5IFAKE* _ZdeR6ComPtrI5IFAKEE( struct $6ComPtrI5IFAKEE* H$1 )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$454:;
	fb$result$1 = *(struct $5IFAKE**)H$1;
	goto label$455;
	label$455:;
	return fb$result$1;
}

static boolean _ZN13ArrayIteratorI6ComPtrI5IFAKEEE7ISVALIDEv( struct $13ArrayIteratorI6ComPtrI5IFAKEEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$504:;
	struct $5ArrayI6ComPtrI5IFAKEEE* A$1;
	A$1 = *(struct $5ArrayI6ComPtrI5IFAKEEE**)THIS$1;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) < (int64)*(int32*)((uint8*)A$1 + 72ll)) != 0ll);
	goto label$505;
	label$505:;
	return fb$result$1;
}

static struct $6ComPtrI5IFAKEE* _ZN13ArrayIteratorI6ComPtrI5IFAKEEE5VALUEEv( struct $13ArrayIteratorI6ComPtrI5IFAKEEE* THIS$1 )
{
	struct $6ComPtrI5IFAKEE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$506:;
	struct $5ArrayI6ComPtrI5IFAKEEE* A$1;
	A$1 = *(struct $5ArrayI6ComPtrI5IFAKEEE**)THIS$1;
	fb$result$1 = (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)A$1 + ((int64)*(int32*)((uint8*)THIS$1 + 8ll) << (3ll & 63ll)));
	goto label$507;
	label$507:;
	return fb$result$1;
}

static void _ZN13ArrayIteratorI6ComPtrI5IFAKEEE8MOVENEXTEv( struct $13ArrayIteratorI6ComPtrI5IFAKEEE* THIS$1 )
{
	label$508:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + 1ll);
	label$509:;
}

static int32 _ZN5ArrayI6ComPtrI5IFAKEEE5COUNTEv( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$510:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 72ll);
	goto label$511;
	label$511:;
	return fb$result$1;
}

static int32 _ZN5ArrayI6ComPtrI5IFAKEEE8CAPACITYEv( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$512:;
	int64 vr$3 = fb_ArrayUBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	int64 vr$6 = fb_ArrayLBound( (struct $7FBARRAYIKvE*)THIS$1, 1ll );
	fb$result$1 = (int32)((vr$3 - vr$6) + 1ll);
	goto label$513;
	label$513:;
	return fb$result$1;
}

static boolean _ZN5ArrayI6ComPtrI5IFAKEEE7ISEMPTYEv( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$514:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 72ll) == 0ll) != 0ll);
	goto label$515;
	label$515:;
	return fb$result$1;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEE7RESERVEEi( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1, int32 N$1 )
{
	label$516:;
	int32 vr$1 = _ZN5ArrayI6ComPtrI5IFAKEEE8CAPACITYEv( THIS$1 );
	if( (int64)N$1 > (int64)vr$1) goto label$519;
	{
		goto label$517;
	}
	label$519:;
	label$518:;
	int32 CAP$1;
	int32 vr$3 = _ZN5ArrayI6ComPtrI5IFAKEEE8CAPACITYEv( THIS$1 );
	CAP$1 = vr$3;
	if( (int64)CAP$1 >= 8ll) goto label$521;
	{
		CAP$1 = 8;
	}
	label$521:;
	label$520:;
	label$522:;
	if( (int64)CAP$1 >= (int64)N$1) goto label$523;
	{
		CAP$1 = (int32)((int64)CAP$1 << (1ll & 63ll));
	}
	goto label$522;
	label$523:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 8ull, (void*)&_ZN6ComPtrI5IFAKEEC1Ev, (void*)&_ZN6ComPtrI5IFAKEED1Ev, 1ull, 0ll, (int64)CAP$1 + -1ll );
	label$517:;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEE6SHRINKEv( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1 )
{
	label$524:;
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$527;
	{
		fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN6ComPtrI5IFAKEEC1Ev, (void*)&_ZN6ComPtrI5IFAKEED1Ev );
		goto label$525;
	}
	label$527:;
	label$526:;
	int32 vr$6 = _ZN5ArrayI6ComPtrI5IFAKEEE8CAPACITYEv( THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != (int64)vr$6) goto label$529;
	{
		goto label$525;
	}
	label$529:;
	label$528:;
	fb_ArrayRedimPresvObj( (struct $7FBARRAYIvE*)THIS$1, 8ull, (void*)&_ZN6ComPtrI5IFAKEEC1Ev, (void*)&_ZN6ComPtrI5IFAKEED1Ev, 1ull, 0ll, (int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll );
	label$525:;
}

static struct $6ComPtrI5IFAKEE* _ZN5ArrayI6ComPtrI5IFAKEEEixEi( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1, int32 I$1 )
{
	struct $6ComPtrI5IFAKEE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$530:;
	fb$result$1 = (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)I$1 << (3ll & 63ll)));
	goto label$531;
	label$531:;
	return fb$result$1;
}

static struct $6ComPtrI5IFAKEE* _ZN5ArrayI6ComPtrI5IFAKEEE2ATEi( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1, int32 I$1 )
{
	struct $6ComPtrI5IFAKEE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$532:;
	fb$result$1 = (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)I$1 << (3ll & 63ll)));
	goto label$533;
	label$533:;
	return fb$result$1;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEE4PUSHERS2_( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1, struct $6ComPtrI5IFAKEE* V$1 )
{
	label$534:;
	_ZN5ArrayI6ComPtrI5IFAKEEE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	_ZN6ComPtrI5IFAKEEaSERS1_( (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (3ll & 63ll))), V$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	label$535:;
}

static struct $6ComPtrI5IFAKEE* _ZN5ArrayI6ComPtrI5IFAKEEE3POPEv( struct $6ComPtrI5IFAKEE* tmp$2171$1, struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1 )
{
	label$536:;
	struct $6ComPtrI5IFAKEE R$1;
	_ZN6ComPtrI5IFAKEEC1Ev( &R$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 72ll) != 0ll) goto label$539;
	{
		_ZN6ComPtrI5IFAKEEC1ERS1_( tmp$2171$1, &R$1 );
		_ZN6ComPtrI5IFAKEED1Ev( &R$1 );
		goto label$537;
	}
	label$539:;
	label$538:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	_ZN6ComPtrI5IFAKEEaSERS1_( &R$1, (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (3ll & 63ll))) );
	_ZN6ComPtrI5IFAKEEC1ERS1_( tmp$2171$1, &R$1 );
	_ZN6ComPtrI5IFAKEED1Ev( &R$1 );
	goto label$537;
	_ZN6ComPtrI5IFAKEED1Ev( &R$1 );
	label$537:;
	return tmp$2171$1;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEE6INSERTEiRS2_( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1, int32 I$1, struct $6ComPtrI5IFAKEE* V$1 )
{
	int64 TMP$2172$1;
	label$540:;
	if( (int64)I$1 < 0ll) goto label$542;
	TMP$2172$1 = (int64)-((int64)I$1 > (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$549;
	label$542:;
	TMP$2172$1 = -1ll;
	label$549:;
	if( TMP$2172$1 == 0ll) goto label$544;
	{
		goto label$541;
	}
	label$544:;
	label$543:;
	struct $6ComPtrI5IFAKEE TMP$1;
	_ZN6ComPtrI5IFAKEEC1ERS1_( &TMP$1, V$1 );
	_ZN5ArrayI6ComPtrI5IFAKEEE7RESERVEEi( THIS$1, (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll) );
	{
		int32 K$2;
		K$2 = *(int32*)((uint8*)THIS$1 + 72ll);
		int32 TMP$2173$2;
		TMP$2173$2 = (int32)((int64)I$1 + 1ll);
		goto label$545;
		label$548:;
		{
			_ZN6ComPtrI5IFAKEEaSERS1_( (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)K$2 << (3ll & 63ll))), (struct $6ComPtrI5IFAKEE*)((uint8*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)K$2 << (3ll & 63ll))) + -8ll) );
		}
		label$546:;
		K$2 = (int32)((int64)K$2 + -1ll);
		label$545:;
		if( (int64)K$2 >= (int64)TMP$2173$2) goto label$548;
		label$547:;
	}
	_ZN6ComPtrI5IFAKEEaSERS1_( (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)I$1 << (3ll & 63ll))), &TMP$1 );
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + 1ll);
	_ZN6ComPtrI5IFAKEED1Ev( &TMP$1 );
	label$541:;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEE6REMOVEEi( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1, int32 I$1 )
{
	int64 TMP$2174$1;
	label$550:;
	if( (int64)I$1 < 0ll) goto label$552;
	TMP$2174$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$559;
	label$552:;
	TMP$2174$1 = -1ll;
	label$559:;
	if( TMP$2174$1 == 0ll) goto label$554;
	{
		goto label$551;
	}
	label$554:;
	label$553:;
	{
		int32 K$2;
		K$2 = I$1;
		int32 TMP$2175$2;
		TMP$2175$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -2ll);
		goto label$555;
		label$558:;
		{
			_ZN6ComPtrI5IFAKEEaSERS1_( (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)K$2 << (3ll & 63ll))), (struct $6ComPtrI5IFAKEE*)((uint8*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)K$2 << (3ll & 63ll))) + 8ll) );
		}
		label$556:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$555:;
		if( (int64)K$2 <= (int64)TMP$2175$2) goto label$558;
		label$557:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	label$551:;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEE10REMOVESWAPEi( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1, int32 I$1 )
{
	int64 TMP$2176$1;
	label$560:;
	if( (int64)I$1 < 0ll) goto label$562;
	TMP$2176$1 = (int64)-((int64)I$1 >= (int64)*(int32*)((uint8*)THIS$1 + 72ll));
	goto label$567;
	label$562:;
	TMP$2176$1 = -1ll;
	label$567:;
	if( TMP$2176$1 == 0ll) goto label$564;
	{
		goto label$561;
	}
	label$564:;
	label$563:;
	*(int32*)((uint8*)THIS$1 + 72ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
	if( (int64)I$1 == (int64)*(int32*)((uint8*)THIS$1 + 72ll)) goto label$566;
	{
		_ZN6ComPtrI5IFAKEEaSERS1_( (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)I$1 << (3ll & 63ll))), (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)*(int32*)((uint8*)THIS$1 + 72ll) << (3ll & 63ll))) );
	}
	label$566:;
	label$565:;
	label$561:;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEE5CLEAREv( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1 )
{
	label$568:;
	struct $6ComPtrI5IFAKEE BLANK$1;
	_ZN6ComPtrI5IFAKEEC1Ev( &BLANK$1 );
	{
		int32 K$2;
		K$2 = 0;
		int32 TMP$2177$2;
		TMP$2177$2 = (int32)((int64)*(int32*)((uint8*)THIS$1 + 72ll) + -1ll);
		goto label$570;
		label$573:;
		{
			_ZN6ComPtrI5IFAKEEaSERS1_( (struct $6ComPtrI5IFAKEE*)((uint8*)*(struct $6ComPtrI5IFAKEE**)THIS$1 + ((int64)K$2 << (3ll & 63ll))), &BLANK$1 );
		}
		label$571:;
		K$2 = (int32)((int64)K$2 + 1ll);
		label$570:;
		if( (int64)K$2 <= (int64)TMP$2177$2) goto label$573;
		label$572:;
	}
	*(int32*)((uint8*)THIS$1 + 72ll) = 0;
	_ZN6ComPtrI5IFAKEED1Ev( &BLANK$1 );
	label$569:;
}

static struct $13ArrayIteratorI6ComPtrI5IFAKEEE _ZN5ArrayI6ComPtrI5IFAKEEE11GETITERATOREv( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1 )
{
	struct $13ArrayIteratorI6ComPtrI5IFAKEEE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$574:;
	struct $13ArrayIteratorI6ComPtrI5IFAKEEE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	*(int32*)((uint8*)&IT$1 + 8ll) = 0;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$575;
	label$575:;
	return fb$result$1;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1Ev( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	label$604:;
	__builtin_memset( (struct $N2FB10COMUNKNOWNE**)THIS$1, 0, 8ll );
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = (struct $N2FB10COMUNKNOWNE*)0ull;
	label$605:;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1EPS1_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $N2FB10COMUNKNOWNE* RAW$1 )
{
	label$606:;
	__builtin_memset( (struct $N2FB10COMUNKNOWNE**)THIS$1, 0, 8ll );
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = RAW$1;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$609;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2188Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2188Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$609:;
	}
	label$607:;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1ERS2_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $6ComPtrIN2FB10COMUNKNOWNEE* RHS$1 )
{
	label$610:;
	__builtin_memset( (struct $N2FB10COMUNKNOWNE**)THIS$1, 0, 8ll );
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = *(struct $N2FB10COMUNKNOWNE**)RHS$1;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$613;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2189Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2189Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$613:;
	}
	label$611:;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	label$614:;
	_ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( THIS$1 );
	label$615:;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEEaSERS2_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $6ComPtrIN2FB10COMUNKNOWNEE* RHS$1 )
{
	label$616:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 != *(struct $N2FB10COMUNKNOWNE**)RHS$1) goto label$619;
	{
		goto label$617;
		label$619:;
	}
	struct $N2FB10COMUNKNOWNE* OLD$1;
	OLD$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = *(struct $N2FB10COMUNKNOWNE**)RHS$1;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$621;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2190Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2190Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$621:;
	}
	if( OLD$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$623;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2191Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2191Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$623:;
	}
	label$617:;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE3GETEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$624:;
	fb$result$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	goto label$625;
	label$625:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE3REFEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$626:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 != (struct $N2FB10COMUNKNOWNE*)0ull) goto label$629;
	{
		label$630:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$631:;
	}
	label$629:;
	label$628:;
	fb$result$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	goto label$627;
	label$627:;
	return fb$result$1;
}

static boolean _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$632:;
	fb$result$1 = (boolean)((int64)-(*(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) != 0ll);
	goto label$633;
	label$633:;
	return fb$result$1;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEE6ATTACHEPS1_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $N2FB10COMUNKNOWNE* RAW$1 )
{
	label$634:;
	_ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( THIS$1 );
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = RAW$1;
	label$635:;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE6DETACHEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$636:;
	struct $N2FB10COMUNKNOWNE* R$1;
	R$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = (struct $N2FB10COMUNKNOWNE*)0ull;
	fb$result$1 = R$1;
	goto label$637;
	label$637:;
	return fb$result$1;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	label$638:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$641;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $N2FB10COMUNKNOWNE**)THIS$1 = (struct $N2FB10COMUNKNOWNE*)0ull;
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2192Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2192Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$641:;
	label$640:;
	label$639:;
}

static int32 _ZN6ComPtrIN2FB10COMUNKNOWNEE6COPYTOEPPS1_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $N2FB10COMUNKNOWNE** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$642:;
	if( PP$1 != (struct $N2FB10COMUNKNOWNE**)0ull) goto label$645;
	{
		fb$result$1 = -2147467261;
		goto label$643;
		label$645:;
	}
	*PP$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$647;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2193Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2193Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$647:;
	}
	fb$result$1 = 0;
	goto label$643;
	label$643:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE** _ZN6ComPtrIN2FB10COMUNKNOWNEE6PUTREFEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$648:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$651;
	{
		label$652:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$653:;
		label$651:;
	}
	fb$result$1 = (struct $N2FB10COMUNKNOWNE**)THIS$1;
	goto label$649;
	label$649:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$654:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$655;
	label$655:;
	return fb$result$1;
}

static boolean _ZN6ComPtrIN2FB10COMUNKNOWNEE13ISEQUALOBJECTEPv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, void* OTHER$1 )
{
	int64 TMP$2194$1;
	int64 TMP$2195$1;
	int64 TMP$2196$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$656:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 != (struct $N2FB10COMUNKNOWNE*)0ull) goto label$658;
	TMP$2194$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$669;
	label$658:;
	TMP$2194$1 = 0ll;
	label$669:;
	if( TMP$2194$1 == 0ll) goto label$660;
	{
		fb$result$1 = (boolean)1ll;
		goto label$657;
		label$660:;
	}
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$661;
	TMP$2195$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$670;
	label$661:;
	TMP$2195$1 = -1ll;
	label$670:;
	if( TMP$2195$1 == 0ll) goto label$663;
	{
		fb$result$1 = (boolean)0ll;
		goto label$657;
		label$663:;
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
	if( A$1 == (void*)0ull) goto label$664;
	TMP$2196$1 = (int64)-(A$1 == B$1);
	goto label$671;
	label$664:;
	TMP$2196$1 = 0ll;
	label$671:;
	SAME$1 = (boolean)(TMP$2196$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$666;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2197Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2197Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$666:;
	}
	if( B$1 == (void*)0ull) goto label$668;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2198Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2198Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$668:;
	}
	fb$result$1 = SAME$1;
	goto label$657;
	label$657:;
	return fb$result$1;
}

__attribute__(( constructor )) static void fb_ctor__comptr( void )
{
	label$0:;
	*(void**)&G_VTBL$ = (void*)&FAKEQI;
	*(void**)((uint8*)&G_VTBL$ + 8ll) = (void*)&FAKEADDREF;
	*(void**)((uint8*)&G_VTBL$ + 16ll) = (void*)&FAKERELEASE;
	*(void**)((uint8*)&G_VTBL$ + 24ll) = (void*)&FAKEPOKE;
	{
		struct $6ComPtrI14NOTANINTERFACEE BAD$1;
		_ZN6ComPtrI14NOTANINTERFACEEC1Ev( &BAD$1 );
		boolean vr$2 = _ZN6ComPtrI14NOTANINTERFACEE6ISNULLEv( &BAD$1 );
		if( (int64)-(boolean)(vr$2 == (boolean)1ll) != 0ll) goto label$142;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 139ll, (char*)"__FB_MODLEVELPROC__", (char*)"bad.IsNull( ) = TRUE" );
			label$142:;
		}
		_ZN6ComPtrI14NOTANINTERFACEED1Ev( &BAD$1 );
	}
	{
		struct $6ComPtrI5IFAKEE E$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &E$1 );
		boolean vr$8 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &E$1 );
		if( (int64)-(boolean)(vr$8 == (boolean)1ll) != 0ll) goto label$212;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 146ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.IsNull( ) = TRUE" );
			label$212:;
		}
		struct $5IFAKE* vr$12 = _ZN6ComPtrI5IFAKEE3GETEv( &E$1 );
		if( vr$12 == (struct $5IFAKE*)0ull) goto label$214;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 147ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.Get( ) = 0" );
			label$214:;
		}
		struct $N2FB10COMUNKNOWNE* vr$14 = _ZN6ComPtrI5IFAKEE7UNKNOWNEv( &E$1 );
		if( vr$14 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$216;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 148ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.Unknown( ) = 0" );
			label$216:;
		}
		struct $5IFAKE* vr$16 = _ZN6ComPtrI5IFAKEE6DETACHEv( &E$1 );
		if( vr$16 == (struct $5IFAKE*)0ull) goto label$218;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 149ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.Detach( ) = 0" );
			label$218:;
		}
		_ZN6ComPtrI5IFAKEE7RELEASEEv( &E$1 );
		boolean vr$19 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &E$1 );
		if( (int64)-(boolean)(vr$19 == (boolean)1ll) != 0ll) goto label$220;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 151ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.IsNull( ) = TRUE" );
			label$220:;
		}
		boolean vr$23 = _ZN6ComPtrI5IFAKEE13ISEQUALOBJECTEPv( &E$1, (void*)0ull );
		if( (int64)-(boolean)(vr$23 == (boolean)1ll) != 0ll) goto label$222;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 152ll, (char*)"__FB_MODLEVELPROC__", (char*)"e.IsEqualObject( 0 ) = TRUE" );
			label$222:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &E$1 );
	}
	{
		struct $5IFAKE* RAW$1;
		struct $5IFAKE* vr$27 = NEWFAKE(  );
		RAW$1 = vr$27;
		int32 vr$28 = REFSOF( (void*)RAW$1 );
		if( (int64)vr$28 == 1ll) goto label$292;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 159ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( raw ) = 1" );
			label$292:;
		}
		{
			struct $6ComPtrI5IFAKEE A$2;
			_ZN6ComPtrI5IFAKEEC1EPS0_( &A$2, RAW$1 );
			int32 vr$31 = REFSOF( (void*)RAW$1 );
			if( (int64)vr$31 == 2ll) goto label$294;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 162ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( raw ) = 2" );
				label$294:;
			}
			boolean vr$34 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &A$2 );
			if( (int64)-(boolean)(vr$34 == (boolean)0ll) != 0ll) goto label$296;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 163ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsNull( ) = FALSE" );
				label$296:;
			}
			struct $5IFAKE* vr$38 = _ZN6ComPtrI5IFAKEE3GETEv( &A$2 );
			if( vr$38 == RAW$1) goto label$298;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 164ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Get( ) = raw" );
				label$298:;
			}
			_ZN6ComPtrI5IFAKEED1Ev( &A$2 );
		}
		int32 vr$40 = REFSOF( (void*)RAW$1 );
		if( (int64)vr$40 == 1ll) goto label$300;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 166ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( raw ) = 1" );
			label$300:;
		}
		(*(tmp$2119*)((uint8*)*(void***)RAW$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)RAW$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$302;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 169ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$302:;
	}
	G_DESTROYED$ = 0;
	{
		{
			struct $6ComPtrI5IFAKEE A$2;
			_ZN6ComPtrI5IFAKEEC1Ev( &A$2 );
			struct $5IFAKE* vr$46 = NEWFAKE(  );
			_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$2, vr$46 );
			struct $5IFAKE* vr$49 = _ZN6ComPtrI5IFAKEE3GETEv( &A$2 );
			int32 vr$50 = REFSOF( (void*)vr$49 );
			if( (int64)vr$50 == 1ll) goto label$304;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 178ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
				label$304:;
			}
			_ZN6ComPtrI5IFAKEED1Ev( &A$2 );
		}
		if( (int64)G_DESTROYED$ == 1ll) goto label$306;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 180ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
			label$306:;
		}
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $5IFAKE* vr$55 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$55 );
		struct $5IFAKE* vr$57 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$57 );
		if( (int64)G_DESTROYED$ == 1ll) goto label$308;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 189ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
			label$308:;
		}
		struct $5IFAKE* vr$61 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$62 = REFSOF( (void*)vr$61 );
		if( (int64)vr$62 == 1ll) goto label$310;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 190ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$310:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 2ll) goto label$312;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 192ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 2" );
		label$312:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $5IFAKE* vr$67 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$67 );
		struct $5IFAKE* vr$70 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$71 = REFSOF( (void*)vr$70 );
		if( (int64)vr$71 == 1ll) goto label$314;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 200ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$314:;
		}
		{
			struct $6ComPtrI5IFAKEE B$2;
			_ZN6ComPtrI5IFAKEEC1ERS1_( &B$2, &A$1 );
			struct $5IFAKE* vr$76 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
			int32 vr$77 = REFSOF( (void*)vr$76 );
			if( (int64)vr$77 == 2ll) goto label$316;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 204ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 2" );
				label$316:;
			}
			struct $6ComPtrI5IFAKEE C$2;
			_ZN6ComPtrI5IFAKEEC1Ev( &C$2 );
			_ZN6ComPtrI5IFAKEEaSERS1_( &C$2, &B$2 );
			struct $5IFAKE* vr$83 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
			int32 vr$84 = REFSOF( (void*)vr$83 );
			if( (int64)vr$84 == 3ll) goto label$318;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 208ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 3" );
				label$318:;
			}
			_ZN6ComPtrI5IFAKEEaSERS1_( &C$2, &C$2 );
			struct $5IFAKE* vr$89 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
			int32 vr$90 = REFSOF( (void*)vr$89 );
			if( (int64)vr$90 == 3ll) goto label$320;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 211ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 3" );
				label$320:;
			}
			boolean vr$93 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &C$2 );
			if( (int64)-(boolean)(vr$93 == (boolean)0ll) != 0ll) goto label$322;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 212ll, (char*)"__FB_MODLEVELPROC__", (char*)"c.IsNull( ) = FALSE" );
				label$322:;
			}
			_ZN6ComPtrI5IFAKEEaSERS1_( &B$2, &B$2 );
			struct $5IFAKE* vr$99 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
			int32 vr$100 = REFSOF( (void*)vr$99 );
			if( (int64)vr$100 == 3ll) goto label$324;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 215ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 3" );
				label$324:;
			}
			_ZN6ComPtrI5IFAKEED1Ev( &C$2 );
			_ZN6ComPtrI5IFAKEED1Ev( &B$2 );
		}
		struct $5IFAKE* vr$105 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$106 = REFSOF( (void*)vr$105 );
		if( (int64)vr$106 == 1ll) goto label$326;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 222ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$326:;
		}
		_ZN6ComPtrI5IFAKEEaSERS1_( &A$1, &A$1 );
		if( (int64)G_DESTROYED$ == 0ll) goto label$328;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 224ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 0" );
			label$328:;
		}
		boolean vr$112 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &A$1 );
		if( (int64)-(boolean)(vr$112 == (boolean)0ll) != 0ll) goto label$330;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 225ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsNull( ) = FALSE" );
			label$330:;
		}
		struct $5IFAKE* vr$116 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$117 = REFSOF( (void*)vr$116 );
		if( (int64)vr$117 == 1ll) goto label$332;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 226ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$332:;
		}
		struct $5IFAKE* vr$120 = _ZptR6ComPtrI5IFAKEE( &A$1 );
		struct $5IFAKE* vr$123 = _ZptR6ComPtrI5IFAKEE( &A$1 );
		int32 vr$121 = (*(tmp$2127*)((uint8*)*(void***)vr$123 + 24ll))( vr$120 );
		if( (int64)vr$121 > 0ll) goto label$334;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 227ll, (char*)"__FB_MODLEVELPROC__", (char*)"a->Poke( ) > 0" );
			label$334:;
		}
		struct $5IFAKE* vr$127 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$128 = REFSOF( (void*)vr$127 );
		if( (int64)vr$128 == 1ll) goto label$336;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 229ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$336:;
		}
		if( (int64)G_DESTROYED$ == 0ll) goto label$338;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 230ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 0" );
			label$338:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$342;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 232ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$342:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $6ComPtrI5IFAKEE B$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &B$1 );
		struct $5IFAKE* vr$135 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$135 );
		struct $5IFAKE* vr$137 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &B$1, vr$137 );
		struct $5IFAKE* FIRST$1;
		struct $5IFAKE* vr$140 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		FIRST$1 = vr$140;
		_ZN6ComPtrI5IFAKEEaSERS1_( &A$1, &B$1 );
		if( (int64)G_DESTROYED$ == 1ll) goto label$344;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 242ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
			label$344:;
		}
		struct $5IFAKE* vr$145 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		struct $5IFAKE* vr$147 = _ZN6ComPtrI5IFAKEE3GETEv( &B$1 );
		if( vr$145 == vr$147) goto label$346;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 243ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Get( ) = b.Get( )" );
			label$346:;
		}
		struct $5IFAKE* vr$149 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$150 = REFSOF( (void*)vr$149 );
		if( (int64)vr$150 == 2ll) goto label$348;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 244ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 2" );
			label$348:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &B$1 );
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 2ll) goto label$350;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 246ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 2" );
		label$350:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $6ComPtrI5IFAKEE E$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &E$1 );
		struct $5IFAKE* vr$157 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$157 );
		_ZN6ComPtrI5IFAKEEaSERS1_( &A$1, &E$1 );
		if( (int64)G_DESTROYED$ == 1ll) goto label$352;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 254ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
			label$352:;
		}
		boolean vr$163 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &A$1 );
		if( (int64)-(boolean)(vr$163 == (boolean)1ll) != 0ll) goto label$354;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 255ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsNull( ) = TRUE" );
			label$354:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &E$1 );
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE G2$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &G2$1 );
		struct $5IFAKE* vr$169 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &G2$1, vr$169 );
		struct $5IFAKE* vr$171 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &G_Y$, vr$171 );
		struct $5IFAKE* vr$173 = _ZN6ComPtrI5IFAKEE3GETEv( &G2$1 );
		int32 vr$174 = REFSOF( (void*)vr$173 );
		if( (int64)vr$174 == 1ll) goto label$358;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 281ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( g2.Get( ) ) = 1" );
			label$358:;
		}
		struct $5IFAKE* vr$176 = _ZN6ComPtrI5IFAKEE3GETEv( &G_Y$ );
		int32 vr$177 = REFSOF( (void*)vr$176 );
		if( (int64)vr$177 == 1ll) goto label$360;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 282ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( g_y.Get( ) ) = 1" );
			label$360:;
		}
		G_ONDESTROY$ = (tmp$252)&DROPY;
		struct $5IFAKE* Y$1;
		struct $5IFAKE* vr$179 = _ZN6ComPtrI5IFAKEE3GETEv( &G_Y$ );
		Y$1 = vr$179;
		_ZN6ComPtrI5IFAKEEaSERS1_( &G2$1, &G_Y$ );
		if( (int64)G_DESTROYED$ == 1ll) goto label$362;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 289ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
			label$362:;
		}
		boolean vr$183 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &G2$1 );
		if( (int64)-(boolean)(vr$183 == (boolean)0ll) != 0ll) goto label$364;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 290ll, (char*)"__FB_MODLEVELPROC__", (char*)"g2.IsNull( ) = FALSE" );
			label$364:;
		}
		struct $5IFAKE* vr$187 = _ZN6ComPtrI5IFAKEE3GETEv( &G2$1 );
		if( vr$187 == Y$1) goto label$366;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 291ll, (char*)"__FB_MODLEVELPROC__", (char*)"g2.Get( ) = y" );
			label$366:;
		}
		struct $5IFAKE* vr$189 = _ZN6ComPtrI5IFAKEE3GETEv( &G2$1 );
		int32 vr$190 = REFSOF( (void*)vr$189 );
		if( (int64)vr$190 == 1ll) goto label$368;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 292ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( g2.Get( ) ) = 1" );
			label$368:;
		}
		struct $5IFAKE* vr$193 = _ZptR6ComPtrI5IFAKEE( &G2$1 );
		struct $5IFAKE* vr$196 = _ZptR6ComPtrI5IFAKEE( &G2$1 );
		int32 vr$194 = (*(tmp$2127*)((uint8*)*(void***)vr$196 + 24ll))( vr$193 );
		if( (int64)vr$194 > 0ll) goto label$370;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 293ll, (char*)"__FB_MODLEVELPROC__", (char*)"g2->Poke( ) > 0" );
			label$370:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &G2$1 );
	}
	if( (int64)G_DESTROYED$ == 2ll) goto label$372;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 295ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 2" );
		label$372:;
	}
	G_ONDESTROY$ = (tmp$252)0ull;
	G_DESTROYED$ = 0;
	G_ZWASNULLINHOOK$ = -1;
	{
		struct $5IFAKE* vr$201 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &G_Z$, vr$201 );
		G_ONDESTROY$ = (tmp$252)&INSPECTZ;
		_ZN6ComPtrI5IFAKEE7RELEASEEv( &G_Z$ );
		if( (int64)G_DESTROYED$ == 1ll) goto label$377;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 317ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
			label$377:;
		}
		if( (int64)G_ZWASNULLINHOOK$ == 1ll) goto label$379;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 318ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_zWasNullInHook = 1" );
			label$379:;
		}
		boolean vr$204 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &G_Z$ );
		if( (int64)-(boolean)(vr$204 == (boolean)1ll) != 0ll) goto label$381;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 319ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_z.IsNull( ) = TRUE" );
			label$381:;
		}
	}
	G_ONDESTROY$ = (tmp$252)0ull;
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $5IFAKE* vr$208 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$208 );
		struct $5IFAKE* RAW$1;
		struct $5IFAKE* vr$211 = _ZN6ComPtrI5IFAKEE6DETACHEv( &A$1 );
		RAW$1 = vr$211;
		boolean vr$213 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &A$1 );
		if( (int64)-(boolean)(vr$213 == (boolean)1ll) != 0ll) goto label$383;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 330ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsNull( ) = TRUE" );
			label$383:;
		}
		int32 vr$216 = REFSOF( (void*)RAW$1 );
		if( (int64)vr$216 == 1ll) goto label$385;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 331ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( raw ) = 1" );
			label$385:;
		}
		if( (int64)G_DESTROYED$ == 0ll) goto label$387;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 332ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 0" );
			label$387:;
		}
		{
			struct $6ComPtrI5IFAKEE B$2;
			_ZN6ComPtrI5IFAKEEC1Ev( &B$2 );
			_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &B$2, RAW$1 );
			struct $5IFAKE* vr$222 = _ZN6ComPtrI5IFAKEE3GETEv( &B$2 );
			int32 vr$223 = REFSOF( (void*)vr$222 );
			if( (int64)vr$223 == 1ll) goto label$389;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 339ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( b.Get( ) ) = 1" );
				label$389:;
			}
			_ZN6ComPtrI5IFAKEED1Ev( &B$2 );
		}
		if( (int64)G_DESTROYED$ == 1ll) goto label$391;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 341ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
			label$391:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $5IFAKE* vr$229 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$229 );
		_ZN6ComPtrI5IFAKEE7RELEASEEv( &A$1 );
		if( (int64)G_DESTROYED$ == 1ll) goto label$393;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 349ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
			label$393:;
		}
		boolean vr$234 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &A$1 );
		if( (int64)-(boolean)(vr$234 == (boolean)1ll) != 0ll) goto label$395;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 350ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsNull( ) = TRUE" );
			label$395:;
		}
		_ZN6ComPtrI5IFAKEE7RELEASEEv( &A$1 );
		if( (int64)G_DESTROYED$ == 1ll) goto label$397;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 352ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
			label$397:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $5IFAKE* vr$241 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$241 );
		struct $5IFAKE* OUT_$1;
		__builtin_memset( &OUT_$1, 0, 8ll );
		int32 vr$246 = _ZN6ComPtrI5IFAKEE6COPYTOEPPS0_( &A$1, &OUT_$1 );
		if( (int64)vr$246 == 0ll) goto label$399;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 363ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.CopyTo( @out_ ) = S_OK" );
			label$399:;
		}
		struct $5IFAKE* vr$249 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		if( OUT_$1 == vr$249) goto label$401;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 364ll, (char*)"__FB_MODLEVELPROC__", (char*)"out_ = a.Get( )" );
			label$401:;
		}
		struct $5IFAKE* vr$251 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$252 = REFSOF( (void*)vr$251 );
		if( (int64)vr$252 == 2ll) goto label$403;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 365ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 2" );
			label$403:;
		}
		int32 vr$255 = _ZN6ComPtrI5IFAKEE6COPYTOEPPS0_( &A$1, (struct $5IFAKE**)0ull );
		if( (int64)vr$255 == -2147467261ll) goto label$405;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 367ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.CopyTo( 0 ) = cast(HRESULT, &h80004003)" );
			label$405:;
		}
		struct $5IFAKE* vr$258 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$259 = REFSOF( (void*)vr$258 );
		if( (int64)vr$259 == 2ll) goto label$407;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 368ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 2" );
			label$407:;
		}
		(*(tmp$2119*)((uint8*)*(void***)OUT_$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)OUT_$1 );
		struct $5IFAKE* vr$264 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$265 = REFSOF( (void*)vr$264 );
		if( (int64)vr$265 == 1ll) goto label$409;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 371ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$409:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$411;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 373ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$411:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $5IFAKE** SLOT$1;
		struct $5IFAKE** vr$271 = _ZN6ComPtrI5IFAKEE6PUTREFEv( &A$1 );
		SLOT$1 = vr$271;
		if( SLOT$1 == (struct $5IFAKE**)&A$1) goto label$413;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 381ll, (char*)"__FB_MODLEVELPROC__", (char*)"slot = @a.p" );
			label$413:;
		}
		struct $5IFAKE* vr$273 = NEWFAKE(  );
		*SLOT$1 = vr$273;
		boolean vr$276 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &A$1 );
		if( (int64)-(boolean)(vr$276 == (boolean)0ll) != 0ll) goto label$415;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 383ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsNull( ) = FALSE" );
			label$415:;
		}
		struct $5IFAKE* vr$280 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$281 = REFSOF( (void*)vr$280 );
		if( (int64)vr$281 == 1ll) goto label$417;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 384ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$417:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$419;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 386ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$419:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $5IFAKE* vr$286 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$286 );
		int32 BEFORE$1;
		struct $5IFAKE* vr$289 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$290 = REFSOF( (void*)vr$289 );
		BEFORE$1 = vr$290;
		struct $5IFAKE* vr$292 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		if( vr$292 != (struct $5IFAKE*)0ull) goto label$421;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 398ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Get( ) <> 0" );
			label$421:;
		}
		struct $N2FB10COMUNKNOWNE* vr$294 = _ZN6ComPtrI5IFAKEE7UNKNOWNEv( &A$1 );
		if( vr$294 != (struct $N2FB10COMUNKNOWNE*)0ull) goto label$423;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 399ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Unknown( ) <> 0" );
			label$423:;
		}
		struct $N2FB10COMUNKNOWNE* vr$296 = _ZN6ComPtrI5IFAKEE7UNKNOWNEv( &A$1 );
		struct $5IFAKE* vr$298 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		if( (void*)vr$296 == (void*)vr$298) goto label$425;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 400ll, (char*)"__FB_MODLEVELPROC__", (char*)"cast( any ptr, a.Unknown( ) ) = cast( any ptr, a.Get( ) )" );
			label$425:;
		}
		struct $5IFAKE* vr$300 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$301 = REFSOF( (void*)vr$300 );
		if( (int64)vr$301 == (int64)BEFORE$1) goto label$427;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 401ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = before" );
			label$427:;
		}
		struct $5IFAKE* vr$305 = _ZN6ComPtrI5IFAKEE3REFEv( &A$1 );
		struct $5IFAKE* vr$308 = _ZN6ComPtrI5IFAKEE3REFEv( &A$1 );
		int32 vr$306 = (*(tmp$2127*)((uint8*)*(void***)vr$308 + 24ll))( vr$305 );
		if( (int64)vr$306 == 1ll) goto label$429;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 403ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.Ref( ).Poke( ) = 1" );
			label$429:;
		}
		struct $5IFAKE* vr$312 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$313 = REFSOF( (void*)vr$312 );
		if( (int64)vr$313 == (int64)BEFORE$1) goto label$431;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 404ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = before" );
			label$431:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$433;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 406ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$433:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $6ComPtrI5IFAKEE B$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &B$1 );
		struct $6ComPtrI5IFAKEE C$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &C$1 );
		struct $5IFAKE* vr$321 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$321 );
		_ZN6ComPtrI5IFAKEEaSERS1_( &B$1, &A$1 );
		struct $5IFAKE* vr$325 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &C$1, vr$325 );
		struct $5IFAKE* vr$328 = _ZN6ComPtrI5IFAKEE3GETEv( &B$1 );
		boolean vr$330 = _ZN6ComPtrI5IFAKEE13ISEQUALOBJECTEPv( &A$1, (void*)vr$328 );
		if( (int64)-(boolean)(vr$330 == (boolean)1ll) != 0ll) goto label$435;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 419ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsEqualObject( b.Get( ) ) = TRUE" );
			label$435:;
		}
		struct $5IFAKE* vr$334 = _ZN6ComPtrI5IFAKEE3GETEv( &C$1 );
		boolean vr$336 = _ZN6ComPtrI5IFAKEE13ISEQUALOBJECTEPv( &A$1, (void*)vr$334 );
		if( (int64)-(boolean)(vr$336 == (boolean)0ll) != 0ll) goto label$437;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 420ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsEqualObject( c.Get( ) ) = FALSE" );
			label$437:;
		}
		boolean vr$340 = _ZN6ComPtrI5IFAKEE13ISEQUALOBJECTEPv( &A$1, (void*)0ull );
		if( (int64)-(boolean)(vr$340 == (boolean)0ll) != 0ll) goto label$439;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 421ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsEqualObject( 0 ) = FALSE" );
			label$439:;
		}
		struct $5IFAKE* vr$344 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$345 = REFSOF( (void*)vr$344 );
		if( (int64)vr$345 == 2ll) goto label$441;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 424ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 2" );
			label$441:;
		}
		struct $5IFAKE* vr$348 = _ZN6ComPtrI5IFAKEE3GETEv( &C$1 );
		int32 vr$349 = REFSOF( (void*)vr$348 );
		if( (int64)vr$349 == 1ll) goto label$443;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 425ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( c.Get( ) ) = 1" );
			label$443:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &C$1 );
		_ZN6ComPtrI5IFAKEED1Ev( &B$1 );
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 2ll) goto label$445;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 427ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 2" );
		label$445:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $5IFAKE* vr$356 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$356 );
		struct $5IFAKE* vr$359 = _ZptR6ComPtrI5IFAKEE( &A$1 );
		struct $5IFAKE* vr$362 = _ZptR6ComPtrI5IFAKEE( &A$1 );
		int32 vr$360 = (*(tmp$2127*)((uint8*)*(void***)vr$362 + 24ll))( vr$359 );
		if( (int64)vr$360 == 1ll) goto label$447;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 436ll, (char*)"__FB_MODLEVELPROC__", (char*)"a->Poke( ) = 1" );
			label$447:;
		}
		struct $5IFAKE* vr$366 = _ZptR6ComPtrI5IFAKEE( &A$1 );
		struct $5IFAKE* vr$369 = _ZptR6ComPtrI5IFAKEE( &A$1 );
		int32 vr$367 = (*(tmp$2127*)((uint8*)*(void***)vr$369 + 24ll))( vr$366 );
		if( (int64)vr$367 == 2ll) goto label$449;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 437ll, (char*)"__FB_MODLEVELPROC__", (char*)"a->Poke( ) = 2" );
			label$449:;
		}
		struct $5IFAKE* vr$373 = _ZdeR6ComPtrI5IFAKEE( &A$1 );
		struct $5IFAKE* vr$376 = _ZdeR6ComPtrI5IFAKEE( &A$1 );
		int32 vr$374 = (*(tmp$2127*)((uint8*)*(void***)vr$376 + 24ll))( vr$373 );
		if( (int64)vr$374 == 3ll) goto label$451;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 438ll, (char*)"__FB_MODLEVELPROC__", (char*)"(*a).Poke( ) = 3" );
			label$451:;
		}
		struct $5IFAKE* vr$380 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$381 = REFSOF( (void*)vr$380 );
		if( (int64)vr$381 == 1ll) goto label$453;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 439ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$453:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$457;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 441ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$457:;
	}
	G_DESTROYED$ = 0;
	int32 vr$385 = EARLYRETURN( (boolean)1ll );
	if( (int64)vr$385 == 1ll) goto label$463;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 453ll, (char*)"__FB_MODLEVELPROC__", (char*)"EarlyReturn( TRUE ) = 1" );
		label$463:;
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$465;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 454ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$465:;
	}
	int32 vr$388 = EARLYRETURN( (boolean)0ll );
	if( (int64)vr$388 == 0ll) goto label$467;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 455ll, (char*)"__FB_MODLEVELPROC__", (char*)"EarlyReturn( FALSE ) = 0" );
		label$467:;
	}
	if( (int64)G_DESTROYED$ == 2ll) goto label$469;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 456ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 2" );
		label$469:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI5IFAKEE TMP$2159$1;
		struct $6ComPtrI5IFAKEE A$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
		struct $5IFAKE* vr$392 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$392 );
		int32 SEEN$1;
		__builtin_memset( &SEEN$1, 0, 4ll );
		TAKESBYREF( &A$1, &SEEN$1 );
		if( (int64)SEEN$1 == 1ll) goto label$475;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 475ll, (char*)"__FB_MODLEVELPROC__", (char*)"seen = 1" );
			label$475:;
		}
		struct $5IFAKE* vr$399 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$400 = REFSOF( (void*)vr$399 );
		if( (int64)vr$400 == 1ll) goto label$477;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 476ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$477:;
		}
		_ZN6ComPtrI5IFAKEEC1ERS1_( &TMP$2159$1, &A$1 );
		TAKESBYVAL( &TMP$2159$1, &SEEN$1 );
		_ZN6ComPtrI5IFAKEED1Ev( &TMP$2159$1 );
		if( (int64)SEEN$1 == 2ll) goto label$479;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 479ll, (char*)"__FB_MODLEVELPROC__", (char*)"seen = 2" );
			label$479:;
		}
		struct $5IFAKE* vr$409 = _ZN6ComPtrI5IFAKEE3GETEv( &A$1 );
		int32 vr$410 = REFSOF( (void*)vr$409 );
		if( (int64)vr$410 == 1ll) goto label$481;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 480ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( a.Get( ) ) = 1" );
			label$481:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$483;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 482ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$483:;
	}
	G_DESTROYED$ = 0;
	{
		struct $5ArrayI6ComPtrI5IFAKEEE V$1;
		_ZN5ArrayI6ComPtrI5IFAKEEEC1Ev( &V$1 );
		struct $6ComPtrI5IFAKEE SHARED_$1;
		_ZN6ComPtrI5IFAKEEC1Ev( &SHARED_$1 );
		struct $5IFAKE* vr$416 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &SHARED_$1, vr$416 );
		{
			int64 I$2;
			I$2 = 1ll;
			label$497:;
			{
				_ZN5ArrayI6ComPtrI5IFAKEEE4PUSHERS2_( &V$1, &SHARED_$1 );
			}
			label$495:;
			I$2 = I$2 + 1ll;
			label$494:;
			if( I$2 <= 64ll) goto label$497;
			label$496:;
		}
		int32 vr$422 = _ZN5ArrayI6ComPtrI5IFAKEEE5COUNTEv( &V$1 );
		if( (int64)vr$422 == 64ll) goto label$499;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 495ll, (char*)"__FB_MODLEVELPROC__", (char*)"v.Count( ) = 64" );
			label$499:;
		}
		struct $5IFAKE* vr$425 = _ZN6ComPtrI5IFAKEE3GETEv( &SHARED_$1 );
		int32 vr$426 = REFSOF( (void*)vr$425 );
		if( (int64)vr$426 == 65ll) goto label$501;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 496ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( shared_.Get( ) ) = 65" );
			label$501:;
		}
		if( (int64)G_DESTROYED$ == 0ll) goto label$503;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 497ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 0" );
			label$503:;
		}
		_ZN6ComPtrI5IFAKEED1Ev( &SHARED_$1 );
		_ZN5ArrayI6ComPtrI5IFAKEEED1Ev( &V$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$577;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 499ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$577:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6HOLDER H$1;
		_ZN6HOLDERC1Ev( &H$1 );
		struct $5IFAKE* vr$433 = NEWFAKE(  );
		_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( (struct $6ComPtrI5IFAKEE*)&H$1, vr$433 );
		struct $5IFAKE* vr$436 = _ZN6ComPtrI5IFAKEE3GETEv( (struct $6ComPtrI5IFAKEE*)&H$1 );
		int32 vr$437 = REFSOF( (void*)vr$436 );
		if( (int64)vr$437 == 1ll) goto label$587;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 511ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( h.inner.Get( ) ) = 1" );
			label$587:;
		}
		_ZN6HOLDERD1Ev( &H$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$589;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 513ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$589:;
	}
	{
		struct $5_GUID CLSID_$1;
		*(uint32*)&CLSID_$1 = 136193u;
		*(uint16*)((uint8*)&CLSID_$1 + 4ll) = (uint16)0u;
		*(uint16*)((uint8*)&CLSID_$1 + 6ll) = (uint16)0u;
		*(uint8*)((uint8*)&CLSID_$1 + 8ll) = (uint8)192u;
		*(uint8*)((uint8*)&CLSID_$1 + 9ll) = (uint8)0u;
		*(uint8*)((uint8*)&CLSID_$1 + 10ll) = (uint8)0u;
		*(uint8*)((uint8*)&CLSID_$1 + 11ll) = (uint8)0u;
		*(uint8*)((uint8*)&CLSID_$1 + 12ll) = (uint8)0u;
		*(uint8*)((uint8*)&CLSID_$1 + 13ll) = (uint8)0u;
		*(uint8*)((uint8*)&CLSID_$1 + 14ll) = (uint8)0u;
		*(uint8*)((uint8*)&CLSID_$1 + 15ll) = (uint8)70u;
		struct $5_GUID IID_$1;
		*(uint32*)&IID_$1 = 136441u;
		*(uint16*)((uint8*)&IID_$1 + 4ll) = (uint16)0u;
		*(uint16*)((uint8*)&IID_$1 + 6ll) = (uint16)0u;
		*(uint8*)((uint8*)&IID_$1 + 8ll) = (uint8)192u;
		*(uint8*)((uint8*)&IID_$1 + 9ll) = (uint8)0u;
		*(uint8*)((uint8*)&IID_$1 + 10ll) = (uint8)0u;
		*(uint8*)((uint8*)&IID_$1 + 11ll) = (uint8)0u;
		*(uint8*)((uint8*)&IID_$1 + 12ll) = (uint8)0u;
		*(uint8*)((uint8*)&IID_$1 + 13ll) = (uint8)0u;
		*(uint8*)((uint8*)&IID_$1 + 14ll) = (uint8)0u;
		*(uint8*)((uint8*)&IID_$1 + 15ll) = (uint8)70u;
		int32 vr$441 = CoInitializeEx( (void*)0ull, 2u );
		if( (int64)vr$441 >= 0ll) goto label$591;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 529ll, (char*)"__FB_MODLEVELPROC__", (char*)"(cast(HRESULT, (CoInitializeEx( 0, COINIT_APARTMENTTHREADED ))) >= 0)" );
			label$591:;
		}
		struct $6ComPtrIN2FB10COMUNKNOWNEE LINK$1;
		_ZN6ComPtrIN2FB10COMUNKNOWNEEC1Ev( &LINK$1 );
		int32 HR$1;
		struct $N2FB10COMUNKNOWNE** vr$445 = _ZN6ComPtrIN2FB10COMUNKNOWNEE6PUTREFEv( &LINK$1 );
		int32 vr$448 = CoCreateInstance( (struct $5_GUID*)&CLSID_$1, (struct $9IUnknown_*)0ull, 1u, (struct $5_GUID*)&IID_$1, (void**)vr$445 );
		HR$1 = vr$448;
		if( (int64)HR$1 >= 0ll) goto label$593;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 534ll, (char*)"__FB_MODLEVELPROC__", (char*)"(cast(HRESULT, (hr)) >= 0)" );
			label$593:;
		}
		boolean vr$451 = _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( &LINK$1 );
		if( (int64)-(boolean)(vr$451 == (boolean)0ll) != 0ll) goto label$595;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 535ll, (char*)"__FB_MODLEVELPROC__", (char*)"link.IsNull( ) = FALSE" );
			label$595:;
		}
		uint32 BASE_$1;
		struct $N2FB10COMUNKNOWNE* vr$455 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
		struct $N2FB10COMUNKNOWNE* vr$458 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
		uint32 vr$456 = (*(tmp$2119*)((uint8*)*(void***)vr$458 + 8ll))( vr$455 );
		BASE_$1 = vr$456;
		struct $N2FB10COMUNKNOWNE* vr$461 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
		struct $N2FB10COMUNKNOWNE* vr$463 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
		(*(tmp$2119*)((uint8*)*(void***)vr$463 + 16ll))( vr$461 );
		{
			struct $6ComPtrIN2FB10COMUNKNOWNEE COPY_$2;
			_ZN6ComPtrIN2FB10COMUNKNOWNEEC1ERS2_( &COPY_$2, &LINK$1 );
			uint32 WITHCOPY$2;
			struct $N2FB10COMUNKNOWNE* vr$468 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
			struct $N2FB10COMUNKNOWNE* vr$471 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
			uint32 vr$469 = (*(tmp$2119*)((uint8*)*(void***)vr$471 + 8ll))( vr$468 );
			WITHCOPY$2 = vr$469;
			struct $N2FB10COMUNKNOWNE* vr$474 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
			struct $N2FB10COMUNKNOWNE* vr$476 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
			(*(tmp$2119*)((uint8*)*(void***)vr$476 + 16ll))( vr$474 );
			if( (int64)WITHCOPY$2 == ((int64)BASE_$1 + 1ll)) goto label$597;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 544ll, (char*)"__FB_MODLEVELPROC__", (char*)"withCopy = base_ + 1" );
				label$597:;
			}
			_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &COPY_$2 );
		}
		uint32 AFTER$1;
		struct $N2FB10COMUNKNOWNE* vr$483 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
		struct $N2FB10COMUNKNOWNE* vr$486 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
		uint32 vr$484 = (*(tmp$2119*)((uint8*)*(void***)vr$486 + 8ll))( vr$483 );
		AFTER$1 = vr$484;
		struct $N2FB10COMUNKNOWNE* vr$489 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
		struct $N2FB10COMUNKNOWNE* vr$491 = _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( &LINK$1 );
		(*(tmp$2119*)((uint8*)*(void***)vr$491 + 16ll))( vr$489 );
		if( (int64)AFTER$1 == (int64)BASE_$1) goto label$599;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 548ll, (char*)"__FB_MODLEVELPROC__", (char*)"after = base_" );
			label$599:;
		}
		struct $N2FB10COMUNKNOWNE* RAW$1;
		__builtin_memset( &RAW$1, 0, 8ll );
		int32 vr$498 = _ZN6ComPtrIN2FB10COMUNKNOWNEE6COPYTOEPPS1_( &LINK$1, &RAW$1 );
		if( (int64)vr$498 == 0ll) goto label$601;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 552ll, (char*)"__FB_MODLEVELPROC__", (char*)"link.CopyTo( @raw ) = S_OK" );
			label$601:;
		}
		boolean vr$501 = _ZN6ComPtrIN2FB10COMUNKNOWNEE13ISEQUALOBJECTEPv( &LINK$1, (void*)RAW$1 );
		if( (int64)-(boolean)(vr$501 == (boolean)1ll) != 0ll) goto label$603;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr.bas", 553ll, (char*)"__FB_MODLEVELPROC__", (char*)"link.IsEqualObject( raw ) = TRUE" );
			label$603:;
		}
		(*(tmp$2119*)((uint8*)*(void***)RAW$1 + 16ll))( RAW$1 );
		_ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( &LINK$1 );
		CoUninitialize(  );
		_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &LINK$1 );
	}
	FBSTRING* vr$508 = fb_StrAllocTempDescZEx( (char*)"comptr: ok", 10ll );
	fb_PrintString( 0, (FBSTRING*)vr$508, 1 );
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

static void _ZN5IFAKEaSERKS_( struct $5IFAKE* THIS$1, struct $5IFAKE* __FB_RHS__$1 )
{
	label$117:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$118:;
}

static int32 FAKEQI( struct $4FAKE* SELF_$1, struct $5_GUID* RIID$1, void** PPV$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$121:;
	if( PPV$1 != (void**)0ull) goto label$124;
	{
		fb$result$1 = -2147467261;
		goto label$122;
		label$124:;
	}
	*PPV$1 = (void*)SELF_$1;
	*(int32*)((uint8*)SELF_$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)SELF_$1 + 8ll) + 1ll);
	fb$result$1 = 0;
	goto label$122;
	label$122:;
	return fb$result$1;
}

static uint32 FAKEADDREF( struct $4FAKE* SELF_$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$125:;
	*(int32*)((uint8*)SELF_$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)SELF_$1 + 8ll) + 1ll);
	fb$result$1 = *(uint32*)((uint8*)SELF_$1 + 8ll);
	goto label$126;
	label$126:;
	return fb$result$1;
}

static uint32 FAKERELEASE( struct $4FAKE* SELF_$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$127:;
	*(int32*)((uint8*)SELF_$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)SELF_$1 + 8ll) + -1ll);
	int32 N$1;
	N$1 = *(int32*)((uint8*)SELF_$1 + 8ll);
	if( (int64)N$1 != 0ll) goto label$130;
	{
		G_DESTROYED$ = (int32)((int64)G_DESTROYED$ + 1ll);
		free( (void*)SELF_$1 );
		if( G_ONDESTROY$ == (tmp$252)0ull) goto label$132;
		{
			tmp$252 HOOK$3;
			HOOK$3 = G_ONDESTROY$;
			G_ONDESTROY$ = (tmp$252)0ull;
			(HOOK$3)(  );
		}
		label$132:;
		label$131:;
	}
	label$130:;
	label$129:;
	fb$result$1 = (uint32)N$1;
	goto label$128;
	label$128:;
	return fb$result$1;
}

static int32 FAKEPOKE( struct $4FAKE* SELF_$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$133:;
	*(int32*)((uint8*)SELF_$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)SELF_$1 + 12ll) + 1ll);
	fb$result$1 = *(int32*)((uint8*)SELF_$1 + 12ll);
	goto label$134;
	label$134:;
	return fb$result$1;
}

static struct $5IFAKE* NEWFAKE( void )
{
	struct $5IFAKE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$135:;
	struct $4FAKE* F$1;
	void* vr$1 = calloc( 16ull, 1ull );
	F$1 = (struct $4FAKE*)vr$1;
	*(struct $8FAKEVTBL**)F$1 = &G_VTBL$;
	*(int32*)((uint8*)F$1 + 8ll) = 1;
	fb$result$1 = (struct $5IFAKE*)F$1;
	goto label$136;
	label$136:;
	return fb$result$1;
}

static int32 REFSOF( void* P$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$137:;
	if( P$1 != (void*)0ull) goto label$140;
	{
		fb$result$1 = -1;
		goto label$138;
		label$140:;
	}
	fb$result$1 = *(int32*)((uint8*)P$1 + 8ll);
	goto label$138;
	label$138:;
	return fb$result$1;
}

static void DROPY( void )
{
	label$355:;
	_ZN6ComPtrI5IFAKEE7RELEASEEv( &G_Y$ );
	label$356:;
}

static void INSPECTZ( void )
{
	int64 TMP$2136$1;
	label$373:;
	boolean vr$0 = _ZN6ComPtrI5IFAKEE6ISNULLEv( &G_Z$ );
	if( vr$0 == (boolean)0ll) goto label$375;
	TMP$2136$1 = 1ll;
	goto label$681;
	label$375:;
	TMP$2136$1 = 0ll;
	label$681:;
	G_ZWASNULLINHOOK$ = (int32)TMP$2136$1;
	label$374:;
}

static int32 EARLYRETURN( boolean BAIL$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$458:;
	struct $6ComPtrI5IFAKEE A$1;
	_ZN6ComPtrI5IFAKEEC1Ev( &A$1 );
	struct $5IFAKE* vr$2 = NEWFAKE(  );
	_ZN6ComPtrI5IFAKEE6ATTACHEPS0_( &A$1, vr$2 );
	if( BAIL$1 == (boolean)0ll) goto label$461;
	{
		fb$result$1 = 1;
		_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
		goto label$459;
		label$461:;
	}
	fb$result$1 = 0;
	_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	goto label$459;
	_ZN6ComPtrI5IFAKEED1Ev( &A$1 );
	label$459:;
	return fb$result$1;
}

static void TAKESBYREF( struct $6ComPtrI5IFAKEE* A$1, int32* N$1 )
{
	label$470:;
	struct $5IFAKE* vr$0 = _ZN6ComPtrI5IFAKEE3GETEv( A$1 );
	int32 vr$1 = REFSOF( (void*)vr$0 );
	*N$1 = vr$1;
	label$471:;
}

static void TAKESBYVAL( struct $6ComPtrI5IFAKEE* A$1, int32* N$1 )
{
	label$472:;
	struct $5IFAKE* vr$0 = _ZN6ComPtrI5IFAKEE3GETEv( A$1 );
	int32 vr$1 = REFSOF( (void*)vr$0 );
	*N$1 = vr$1;
	label$473:;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEEC1Ev( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1 )
{
	*(struct $6ComPtrI5IFAKEE**)THIS$1 = (struct $6ComPtrI5IFAKEE*)0ull;
	*(struct $6ComPtrI5IFAKEE**)((uint8*)THIS$1 + 8ll) = (struct $6ComPtrI5IFAKEE*)0ull;
	*(int64*)((uint8*)THIS$1 + 16ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 24ll) = 8ll;
	*(int64*)((uint8*)THIS$1 + 32ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 40ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 48ll), 0, 24ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 72ll), 0, 4ll );
	label$484:;
	label$485:;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEEaSERKS3_( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1, struct $5ArrayI6ComPtrI5IFAKEEE* __FB_RHS__$1 )
{
	struct $6ComPtrI5IFAKEE* TMP$2162$1;
	struct $6ComPtrI5IFAKEE* TMP$2163$1;
	struct $6ComPtrI5IFAKEE* TMP$2164$1;
	label$486:;
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)THIS$1, (struct $7FBARRAYIvE*)__FB_RHS__$1, 0, (void*)&_ZN6ComPtrI5IFAKEEC1Ev, (void*)&_ZN6ComPtrI5IFAKEED1Ev );
	TMP$2162$1 = *(struct $6ComPtrI5IFAKEE**)((uint8*)THIS$1 + 8ll);
	TMP$2163$1 = *(struct $6ComPtrI5IFAKEE**)((uint8*)__FB_RHS__$1 + 8ll);
	TMP$2164$1 = (struct $6ComPtrI5IFAKEE*)((uint8*)TMP$2163$1 + *(uint64*)((uint8*)__FB_RHS__$1 + 16ll));
	label$488:;
	if( TMP$2163$1 >= TMP$2164$1) goto label$489;
	_ZN6ComPtrI5IFAKEEaSERS1_( TMP$2162$1, TMP$2163$1 );
	TMP$2162$1 = (struct $6ComPtrI5IFAKEE*)((uint8*)TMP$2162$1 + 8ll);
	TMP$2163$1 = (struct $6ComPtrI5IFAKEE*)((uint8*)TMP$2163$1 + 8ll);
	goto label$488;
	label$489:;
	*(int32*)((uint8*)THIS$1 + 72ll) = *(int32*)((uint8*)__FB_RHS__$1 + 72ll);
	label$487:;
}

static void _ZN5ArrayI6ComPtrI5IFAKEEED1Ev( struct $5ArrayI6ComPtrI5IFAKEEE* THIS$1 )
{
	label$492:;
	label$493:;
	fb_ArrayEraseObj( (struct $7FBARRAYIvE*)THIS$1, (void*)&_ZN6ComPtrI5IFAKEEC1Ev, (void*)&_ZN6ComPtrI5IFAKEED1Ev );
}

static void _ZN6HOLDERC1Ev( struct $6HOLDER* THIS$1 )
{
	_ZN6ComPtrI5IFAKEEC1Ev( (struct $6ComPtrI5IFAKEE*)THIS$1 );
	label$578:;
	label$579:;
}

static void _ZN6HOLDERaSERKS_( struct $6HOLDER* THIS$1, struct $6HOLDER* __FB_RHS__$1 )
{
	label$580:;
	_ZN6ComPtrI5IFAKEEaSERS1_( (struct $6ComPtrI5IFAKEE*)THIS$1, (struct $6ComPtrI5IFAKEE*)__FB_RHS__$1 );
	label$581:;
}

static void _ZN6HOLDERD1Ev( struct $6HOLDER* THIS$1 )
{
	label$584:;
	label$585:;
	_ZN6ComPtrI5IFAKEED1Ev( (struct $6ComPtrI5IFAKEE*)THIS$1 );
}

__attribute__(( constructor )) static void _GLOBAL__I( void )
{
	label$673:;
	_ZN6ComPtrI5IFAKEEC1Ev( &G_Y$ );
	_ZN6ComPtrI5IFAKEEC1Ev( &G_Z$ );
	label$674:;
}

__attribute__(( destructor )) static void _GLOBAL__D( void )
{
	label$676:;
	_ZN6ComPtrI5IFAKEED1Ev( &G_Z$ );
	_ZN6ComPtrI5IFAKEED1Ev( &G_Y$ );
	label$677:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0kernel32\0-l\0gdi32\0-l\0msimg32\0-l\0user32\0-l\0version\0-l\0advapi32\0-l\0imm32\0-l\0uuid\0-l\0ole32\0-l\0oleaut32";
