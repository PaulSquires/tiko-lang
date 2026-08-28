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
struct $5VTBLA {
	void* QUERYINTERFACE;
	void* ADDREF;
	void* RELEASE;
	void* POKEA;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $5VTBLA ) == 32 );
struct $5VTBLB {
	void* QUERYINTERFACE;
	void* ADDREF;
	void* RELEASE;
	void* POKEB;
};
__FB_STATIC_ASSERT( sizeof( struct $5VTBLB ) == 32 );
struct $3OBJ;
struct $4SUBB {
	struct $5VTBLB* LPVTBL;
	struct $3OBJ* OWNER;
};
__FB_STATIC_ASSERT( sizeof( struct $4SUBB ) == 16 );
struct $3OBJ {
	struct $5VTBLA* LPVTBL;
	int32 REFS;
	int32 POKEDA;
	int32 POKEDB;
	struct $4SUBB B;
};
__FB_STATIC_ASSERT( sizeof( struct $3OBJ ) == 40 );
struct $10fb_Object$ {
	void* VPTR$;
};
__FB_STATIC_ASSERT( sizeof( struct $10fb_Object$ ) == 8 );
struct $N2FB10COMUNKNOWNE {
	struct $10fb_Object$ BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB10COMUNKNOWNE ) == 8 );
struct $6IFAKEA {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $6IFAKEA ) == 8 );
struct $6ComPtrI6IFAKEAE {
	struct $6IFAKEA* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrI6IFAKEAE ) == 8 );
struct $8INOTRAIT {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $8INOTRAIT ) == 8 );
struct $6ComPtrI8INOTRAITE {
	struct $8INOTRAIT* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrI8INOTRAITE ) == 8 );
struct $5_GUID {
	uint32 DATA1;
	uint16 DATA2;
	uint16 DATA3;
	uint8 DATA4[8];
};
__FB_STATIC_ASSERT( sizeof( struct $5_GUID ) == 16 );
struct $6IFAKEB {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $6IFAKEB ) == 8 );
struct $6ComPtrI6IFAKEBE {
	struct $6IFAKEB* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrI6IFAKEBE ) == 8 );
struct $6IidTagI6IFAKEBE {
	int32 UNUSED;
};
__FB_STATIC_ASSERT( sizeof( struct $6IidTagI6IFAKEBE ) == 4 );
struct $12IUNSUPPORTED {
	struct $N2FB10COMUNKNOWNE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $12IUNSUPPORTED ) == 8 );
struct $6ComPtrI12IUNSUPPORTEDE {
	struct $12IUNSUPPORTED* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrI12IUNSUPPORTEDE ) == 8 );
struct $6IidTagI12IUNSUPPORTEDE {
	int32 UNUSED;
};
__FB_STATIC_ASSERT( sizeof( struct $6IidTagI12IUNSUPPORTEDE ) == 4 );
struct $8ComQIPtrI6IFAKEBE {
	struct $6ComPtrI6IFAKEBE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $8ComQIPtrI6IFAKEBE ) == 8 );
struct $8ComQIPtrI12IUNSUPPORTEDE {
	struct $6ComPtrI12IUNSUPPORTEDE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $8ComQIPtrI12IUNSUPPORTEDE ) == 8 );
struct $6IidTagI6IFAKEAE {
	int32 UNUSED;
};
__FB_STATIC_ASSERT( sizeof( struct $6IidTagI6IFAKEAE ) == 4 );
struct $6ComPtrIN2FB10COMUNKNOWNEE {
	struct $N2FB10COMUNKNOWNE* P;
};
__FB_STATIC_ASSERT( sizeof( struct $6ComPtrIN2FB10COMUNKNOWNEE ) == 8 );
struct $6IidTagIN2FB10COMUNKNOWNEE {
	int32 UNUSED;
};
__FB_STATIC_ASSERT( sizeof( struct $6IidTagIN2FB10COMUNKNOWNEE ) == 4 );
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
typedef int32 (*tmp$2187)( struct $6IFAKEB* );
typedef uint32 (*tmp$2217)( struct $N2FB10COMUNKNOWNE* );
typedef int32 (*tmp$2224)( struct $6IFAKEA* );
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
void _ZN10fb_Object$C1Ev( struct $10fb_Object$* );
void* fb_ErrorThrowEx( int32, int32, char*, void*, void* );
void fb_Assert( char*, int64, char*, char* );
void* calloc( uint64, uint64 );
void free( void* );
void fb_PrintString( int32, FBSTRING*, int32 );
FBSTRING* fb_StrAllocTempDescZEx( char*, int64 );
static void fb_ctor__comptrzqi( void ) __attribute__(( constructor ));
int32 memcmp( void*, void*, uint64 );
int64 _InterlockedExchangeAdd64( int64*, int64 );
int32 _InterlockedExchangeAdd( int32*, int32 );
void CoUninitialize( void );
int32 CoInitializeEx( void*, uint32 );
int32 CoCreateInstance( struct $5_GUID*, struct $9IUnknown_*, uint32, struct $5_GUID*, void** );
int32 CLSIDFromProgID( uint16*, struct $5_GUID* );
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
static struct $5_GUID* _Z5IIDOF6IidTagIN2FB10COMUNKNOWNEE( struct $6IidTagIN2FB10COMUNKNOWNEE );
static void _ZN6IFAKEAaSERKS_( struct $6IFAKEA*, struct $6IFAKEA* );
static void _ZN6IFAKEBaSERKS_( struct $6IFAKEB*, struct $6IFAKEB* );
static void _ZN12IUNSUPPORTEDaSERKS_( struct $12IUNSUPPORTED*, struct $12IUNSUPPORTED* );
static void _ZN8INOTRAITaSERKS_( struct $8INOTRAIT*, struct $8INOTRAIT* );
static struct $5_GUID* _Z5IIDOF6IidTagI6IFAKEAE( struct $6IidTagI6IFAKEAE );
static struct $5_GUID* _Z5IIDOF6IidTagI6IFAKEBE( struct $6IidTagI6IFAKEBE );
static struct $5_GUID* _Z5IIDOF6IidTagI12IUNSUPPORTEDE( struct $6IidTagI12IUNSUPPORTEDE );
static int32 OBJQI( struct $3OBJ*, struct $5_GUID*, void** );
static uint32 OBJADDREF( struct $3OBJ* );
static uint32 OBJRELEASE( struct $3OBJ* );
static struct $5_GUID* HIIDUNKNOWNFORTEST( void );
struct $3OBJ* ASOBJ( void* );
static int32 OBJPOKEA( struct $3OBJ* );
static int32 SUBQI( struct $4SUBB*, struct $5_GUID*, void** );
static uint32 SUBADDREF( struct $4SUBB* );
static uint32 SUBRELEASE( struct $4SUBB* );
static int32 SUBPOKEB( struct $4SUBB* );
static struct $6IFAKEA* NEWOBJ( void );
static int32 REFSOF( void* );
static void _ZN6ComPtrI6IFAKEAEC1Ev( struct $6ComPtrI6IFAKEAE* );
static void _ZN6ComPtrI6IFAKEAED1Ev( struct $6ComPtrI6IFAKEAE* );
static struct $6IFAKEA* _ZN6ComPtrI6IFAKEAE3GETEv( struct $6ComPtrI6IFAKEAE* );
static boolean _ZN6ComPtrI6IFAKEAE6ISNULLEv( struct $6ComPtrI6IFAKEAE* );
static void _ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( struct $6ComPtrI6IFAKEAE*, struct $6IFAKEA* );
static void _ZN6ComPtrI6IFAKEAE7RELEASEEv( struct $6ComPtrI6IFAKEAE* );
static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI6IFAKEAE7UNKNOWNEv( struct $6ComPtrI6IFAKEAE* );
static boolean _ZN6ComPtrI6IFAKEAE13ISEQUALOBJECTEPv( struct $6ComPtrI6IFAKEAE*, void* );
static void _ZN6ComPtrI8INOTRAITEC1Ev( struct $6ComPtrI8INOTRAITE* );
static void _ZN6ComPtrI8INOTRAITED1Ev( struct $6ComPtrI8INOTRAITE* );
static boolean _ZN6ComPtrI8INOTRAITE6ISNULLEv( struct $6ComPtrI8INOTRAITE* );
static void _ZN6ComPtrI8INOTRAITE6ATTACHEPS0_( struct $6ComPtrI8INOTRAITE*, struct $8INOTRAIT* );
static void _ZN6ComPtrI8INOTRAITE7RELEASEEv( struct $6ComPtrI8INOTRAITE* );
static int32 _Z5ComQII8INOTRAITEPvPK5_GUIDR6ComPtrI8INOTRAITE( void*, struct $5_GUID*, struct $6ComPtrI8INOTRAITE* );
static void _ZN6ComPtrI6IFAKEBEC1Ev( struct $6ComPtrI6IFAKEBE* );
static void _ZN6ComPtrI6IFAKEBED1Ev( struct $6ComPtrI6IFAKEBE* );
static void _ZN6ComPtrI6IFAKEBEaSERS1_( struct $6ComPtrI6IFAKEBE*, struct $6ComPtrI6IFAKEBE* );
static struct $6IFAKEB* _ZN6ComPtrI6IFAKEBE3GETEv( struct $6ComPtrI6IFAKEBE* );
static struct $6IFAKEB* _ZN6ComPtrI6IFAKEBE3REFEv( struct $6ComPtrI6IFAKEBE* );
static boolean _ZN6ComPtrI6IFAKEBE6ISNULLEv( struct $6ComPtrI6IFAKEBE* );
static void _ZN6ComPtrI6IFAKEBE6ATTACHEPS0_( struct $6ComPtrI6IFAKEBE*, struct $6IFAKEB* );
static struct $6IFAKEB* _ZN6ComPtrI6IFAKEBE6DETACHEv( struct $6ComPtrI6IFAKEBE* );
static void _ZN6ComPtrI6IFAKEBE7RELEASEEv( struct $6ComPtrI6IFAKEBE* );
static int32 _ZN6ComPtrI6IFAKEBE6COPYTOEPPS0_( struct $6ComPtrI6IFAKEBE*, struct $6IFAKEB** );
static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI6IFAKEBE7UNKNOWNEv( struct $6ComPtrI6IFAKEBE* );
static boolean _ZN6ComPtrI6IFAKEBE13ISEQUALOBJECTEPv( struct $6ComPtrI6IFAKEBE*, void* );
static int32 _Z5ComQII6IFAKEBEPvPK5_GUIDR6ComPtrI6IFAKEBE( void*, struct $5_GUID*, struct $6ComPtrI6IFAKEBE* );
static int32 _Z7ComQIAsI6IFAKEBEPvR6ComPtrI6IFAKEBE( void*, struct $6ComPtrI6IFAKEBE* );
static void _ZN6ComPtrI12IUNSUPPORTEDEC1Ev( struct $6ComPtrI12IUNSUPPORTEDE* );
static void _ZN6ComPtrI12IUNSUPPORTEDED1Ev( struct $6ComPtrI12IUNSUPPORTEDE* );
static void _ZN6ComPtrI12IUNSUPPORTEDEaSERS1_( struct $6ComPtrI12IUNSUPPORTEDE*, struct $6ComPtrI12IUNSUPPORTEDE* );
static boolean _ZN6ComPtrI12IUNSUPPORTEDE6ISNULLEv( struct $6ComPtrI12IUNSUPPORTEDE* );
static void _ZN6ComPtrI12IUNSUPPORTEDE6ATTACHEPS0_( struct $6ComPtrI12IUNSUPPORTEDE*, struct $12IUNSUPPORTED* );
static void _ZN6ComPtrI12IUNSUPPORTEDE7RELEASEEv( struct $6ComPtrI12IUNSUPPORTEDE* );
static int32 _Z7ComQIAsI12IUNSUPPORTEDEPvR6ComPtrI12IUNSUPPORTEDE( void*, struct $6ComPtrI12IUNSUPPORTEDE* );
static int32 _Z5ComQII12IUNSUPPORTEDEPvPK5_GUIDR6ComPtrI12IUNSUPPORTEDE( void*, struct $5_GUID*, struct $6ComPtrI12IUNSUPPORTEDE* );
static void _ZN8ComQIPtrI6IFAKEBEC1Ev( struct $8ComQIPtrI6IFAKEBE* );
static void _ZN8ComQIPtrI6IFAKEBEC1EPv( struct $8ComQIPtrI6IFAKEBE*, void* );
static void _ZN8ComQIPtrI6IFAKEBEC1ERS1_( struct $8ComQIPtrI6IFAKEBE*, struct $8ComQIPtrI6IFAKEBE* );
static void _ZN8ComQIPtrI6IFAKEBEaSEPv( struct $8ComQIPtrI6IFAKEBE*, void* );
static void _ZN8ComQIPtrI6IFAKEBEaSERS1_( struct $8ComQIPtrI6IFAKEBE*, struct $8ComQIPtrI6IFAKEBE* );
static void _ZN8ComQIPtrI6IFAKEBEaSERKS1_( struct $8ComQIPtrI6IFAKEBE*, struct $8ComQIPtrI6IFAKEBE* );
static void _ZN8ComQIPtrI6IFAKEBED1Ev( struct $8ComQIPtrI6IFAKEBE* );
static struct $6IFAKEB* _ZptR8ComQIPtrI6IFAKEBE( struct $8ComQIPtrI6IFAKEBE* );
static void _ZN8ComQIPtrI12IUNSUPPORTEDEC1Ev( struct $8ComQIPtrI12IUNSUPPORTEDE* );
static void _ZN8ComQIPtrI12IUNSUPPORTEDEC1EPv( struct $8ComQIPtrI12IUNSUPPORTEDE*, void* );
static void _ZN8ComQIPtrI12IUNSUPPORTEDEaSEPv( struct $8ComQIPtrI12IUNSUPPORTEDE*, void* );
static void _ZN8ComQIPtrI12IUNSUPPORTEDEaSERKS1_( struct $8ComQIPtrI12IUNSUPPORTEDE*, struct $8ComQIPtrI12IUNSUPPORTEDE* );
static void _ZN8ComQIPtrI12IUNSUPPORTEDED1Ev( struct $8ComQIPtrI12IUNSUPPORTEDE* );
static struct $6IFAKEB* _ZdeR8ComQIPtrI6IFAKEBE( struct $8ComQIPtrI6IFAKEBE* );
static int32 _Z7ComCastI6IFAKEA6IFAKEBER6ComPtrI6IFAKEAER6ComPtrI6IFAKEBE( struct $6ComPtrI6IFAKEAE*, struct $6ComPtrI6IFAKEBE* );
static struct $6IFAKEB* _ZptR6ComPtrI6IFAKEBE( struct $6ComPtrI6IFAKEBE* );
static int32 _Z7ComCastI6IFAKEB6IFAKEAER6ComPtrI6IFAKEBER6ComPtrI6IFAKEAE( struct $6ComPtrI6IFAKEBE*, struct $6ComPtrI6IFAKEAE* );
static struct $6IFAKEA* _ZptR6ComPtrI6IFAKEAE( struct $6ComPtrI6IFAKEAE* );
static int32 _Z7ComCastI6IFAKEA12IUNSUPPORTEDER6ComPtrI6IFAKEAER6ComPtrI12IUNSUPPORTEDE( struct $6ComPtrI6IFAKEAE*, struct $6ComPtrI12IUNSUPPORTEDE* );
static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1Ev( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1ERS2_( struct $6ComPtrIN2FB10COMUNKNOWNEE*, struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static void _ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE3GETEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static boolean _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static void _ZN6ComPtrIN2FB10COMUNKNOWNEE6ATTACHEPS1_( struct $6ComPtrIN2FB10COMUNKNOWNEE*, struct $N2FB10COMUNKNOWNE* );
static void _ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* );
static boolean _ZN6ComPtrIN2FB10COMUNKNOWNEE13ISEQUALOBJECTEPv( struct $6ComPtrIN2FB10COMUNKNOWNEE*, void* );
static struct $6ComPtrIN2FB10COMUNKNOWNEE* _Z9ComCreateIN2FB10COMUNKNOWNEEPK5_GUIDjPv( struct $6ComPtrIN2FB10COMUNKNOWNEE*, struct $5_GUID*, uint32, void* );
static struct $6ComPtrIN2FB10COMUNKNOWNEE* _Z19ComCreateFromProgIDIN2FB10COMUNKNOWNEERKwjPv( struct $6ComPtrIN2FB10COMUNKNOWNEE*, uint16*, uint32, void* );
static int32 _Z5ComQIIN2FB10COMUNKNOWNEEPvPK5_GUIDR6ComPtrIN2FB10COMUNKNOWNEE( void*, struct $5_GUID*, struct $6ComPtrIN2FB10COMUNKNOWNEE* );
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
static struct $8fb_RTTI$ _ZTSN6IFAKEAE = { (void*)0ull, (char*)"6IFAKEA", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN6IFAKEAE[6] = { (void*)0ull, (void*)&_ZTSN6IFAKEAE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8fb_RTTI$ _ZTSN6IFAKEBE = { (void*)0ull, (char*)"6IFAKEB", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN6IFAKEBE[6] = { (void*)0ull, (void*)&_ZTSN6IFAKEBE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8fb_RTTI$ _ZTSN12IUNSUPPORTEDE = { (void*)0ull, (char*)"12IUNSUPPORTED", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN12IUNSUPPORTEDE[6] = { (void*)0ull, (void*)&_ZTSN12IUNSUPPORTEDE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $8fb_RTTI$ _ZTSN8INOTRAITE = { (void*)0ull, (char*)"8INOTRAIT", &_ZTSN2FB10COMUNKNOWNE };
static void* _ZTVN8INOTRAITE[6] = { (void*)0ull, (void*)&_ZTSN8INOTRAITE, (void*)0ull, (void*)0ull, (void*)0ull, (void*)0ull };
static struct $5_GUID IID_FAKEA$ = { 286326784u, (uint16)1u, (uint16)2u, { (uint8)1u, (uint8)2u, (uint8)3u, (uint8)4u, (uint8)5u, (uint8)6u, (uint8)7u, (uint8)8u } };
static struct $5_GUID IID_FAKEB$ = { 572653568u, (uint16)1u, (uint16)2u, { (uint8)1u, (uint8)2u, (uint8)3u, (uint8)4u, (uint8)5u, (uint8)6u, (uint8)7u, (uint8)8u } };
static struct $5_GUID IID_UNSUP$ = { 858980352u, (uint16)1u, (uint16)2u, { (uint8)1u, (uint8)2u, (uint8)3u, (uint8)4u, (uint8)5u, (uint8)6u, (uint8)7u, (uint8)8u } };
static struct $5VTBLA G_VTBLA$;
static struct $5VTBLB G_VTBLB$;
static int32 G_DESTROYED$;

struct $3OBJ* ASOBJ( void* P$1 )
{
	struct $3OBJ* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$171:;
	fb$result$1 = (struct $3OBJ*)P$1;
	goto label$172;
	label$172:;
	return fb$result$1;
}

static void _ZN6ComPtrI6IFAKEAEC1Ev( struct $6ComPtrI6IFAKEAE* THIS$1 )
{
	label$205:;
	__builtin_memset( (struct $6IFAKEA**)THIS$1, 0, 8ll );
	*(struct $6IFAKEA**)THIS$1 = (struct $6IFAKEA*)0ull;
	label$206:;
}

static void _ZN6ComPtrI6IFAKEAEC1EPS0_( struct $6ComPtrI6IFAKEAE* THIS$1, struct $6IFAKEA* RAW$1 )
{
	label$207:;
	__builtin_memset( (struct $6IFAKEA**)THIS$1, 0, 8ll );
	*(struct $6IFAKEA**)THIS$1 = RAW$1;
	if( *(struct $6IFAKEA**)THIS$1 == (struct $6IFAKEA*)0ull) goto label$210;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEAE8tmp$2113Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEAE8tmp$2113Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$210:;
	}
	label$208:;
}

static void _ZN6ComPtrI6IFAKEAEC1ERS1_( struct $6ComPtrI6IFAKEAE* THIS$1, struct $6ComPtrI6IFAKEAE* RHS$1 )
{
	label$211:;
	__builtin_memset( (struct $6IFAKEA**)THIS$1, 0, 8ll );
	*(struct $6IFAKEA**)THIS$1 = *(struct $6IFAKEA**)RHS$1;
	if( *(struct $6IFAKEA**)THIS$1 == (struct $6IFAKEA*)0ull) goto label$214;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEAE8tmp$2114Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEAE8tmp$2114Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$214:;
	}
	label$212:;
}

static void _ZN6ComPtrI6IFAKEAED1Ev( struct $6ComPtrI6IFAKEAE* THIS$1 )
{
	label$215:;
	_ZN6ComPtrI6IFAKEAE7RELEASEEv( THIS$1 );
	label$216:;
}

static void _ZN6ComPtrI6IFAKEAEaSERS1_( struct $6ComPtrI6IFAKEAE* THIS$1, struct $6ComPtrI6IFAKEAE* RHS$1 )
{
	label$217:;
	if( *(struct $6IFAKEA**)THIS$1 != *(struct $6IFAKEA**)RHS$1) goto label$220;
	{
		goto label$218;
		label$220:;
	}
	struct $6IFAKEA* OLD$1;
	OLD$1 = *(struct $6IFAKEA**)THIS$1;
	*(struct $6IFAKEA**)THIS$1 = *(struct $6IFAKEA**)RHS$1;
	if( *(struct $6IFAKEA**)THIS$1 == (struct $6IFAKEA*)0ull) goto label$222;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEAE8tmp$2115Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEAE8tmp$2115Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$222:;
	}
	if( OLD$1 == (struct $6IFAKEA*)0ull) goto label$224;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEAE8tmp$2116Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEAE8tmp$2116Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$224:;
	}
	label$218:;
}

static struct $6IFAKEA* _ZN6ComPtrI6IFAKEAE3GETEv( struct $6ComPtrI6IFAKEAE* THIS$1 )
{
	struct $6IFAKEA* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$225:;
	fb$result$1 = *(struct $6IFAKEA**)THIS$1;
	goto label$226;
	label$226:;
	return fb$result$1;
}

static struct $6IFAKEA* _ZN6ComPtrI6IFAKEAE3REFEv( struct $6ComPtrI6IFAKEAE* THIS$1 )
{
	struct $6IFAKEA* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$227:;
	if( *(struct $6IFAKEA**)THIS$1 != (struct $6IFAKEA*)0ull) goto label$230;
	{
		label$231:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$232:;
	}
	label$230:;
	label$229:;
	fb$result$1 = *(struct $6IFAKEA**)THIS$1;
	goto label$228;
	label$228:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI6IFAKEAE6ISNULLEv( struct $6ComPtrI6IFAKEAE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$233:;
	fb$result$1 = (boolean)((int64)-(*(struct $6IFAKEA**)THIS$1 == (struct $6IFAKEA*)0ull) != 0ll);
	goto label$234;
	label$234:;
	return fb$result$1;
}

static void _ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( struct $6ComPtrI6IFAKEAE* THIS$1, struct $6IFAKEA* RAW$1 )
{
	label$235:;
	_ZN6ComPtrI6IFAKEAE7RELEASEEv( THIS$1 );
	*(struct $6IFAKEA**)THIS$1 = RAW$1;
	label$236:;
}

static struct $6IFAKEA* _ZN6ComPtrI6IFAKEAE6DETACHEv( struct $6ComPtrI6IFAKEAE* THIS$1 )
{
	struct $6IFAKEA* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$237:;
	struct $6IFAKEA* R$1;
	R$1 = *(struct $6IFAKEA**)THIS$1;
	*(struct $6IFAKEA**)THIS$1 = (struct $6IFAKEA*)0ull;
	fb$result$1 = R$1;
	goto label$238;
	label$238:;
	return fb$result$1;
}

static void _ZN6ComPtrI6IFAKEAE7RELEASEEv( struct $6ComPtrI6IFAKEAE* THIS$1 )
{
	label$239:;
	if( *(struct $6IFAKEA**)THIS$1 == (struct $6IFAKEA*)0ull) goto label$242;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $6IFAKEA**)THIS$1 = (struct $6IFAKEA*)0ull;
		typedef uint32 (*_ZN6ComPtrI6IFAKEAE8tmp$2118Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEAE8tmp$2118Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$242:;
	label$241:;
	label$240:;
}

static int32 _ZN6ComPtrI6IFAKEAE6COPYTOEPPS0_( struct $6ComPtrI6IFAKEAE* THIS$1, struct $6IFAKEA** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$243:;
	if( PP$1 != (struct $6IFAKEA**)0ull) goto label$246;
	{
		fb$result$1 = -2147467261;
		goto label$244;
		label$246:;
	}
	*PP$1 = *(struct $6IFAKEA**)THIS$1;
	if( *(struct $6IFAKEA**)THIS$1 == (struct $6IFAKEA*)0ull) goto label$248;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEAE8tmp$2119Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEAE8tmp$2119Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$248:;
	}
	fb$result$1 = 0;
	goto label$244;
	label$244:;
	return fb$result$1;
}

static struct $6IFAKEA** _ZN6ComPtrI6IFAKEAE6PUTREFEv( struct $6ComPtrI6IFAKEAE* THIS$1 )
{
	struct $6IFAKEA** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$249:;
	if( *(struct $6IFAKEA**)THIS$1 == (struct $6IFAKEA*)0ull) goto label$252;
	{
		label$253:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$254:;
		label$252:;
	}
	fb$result$1 = (struct $6IFAKEA**)THIS$1;
	goto label$250;
	label$250:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI6IFAKEAE7UNKNOWNEv( struct $6ComPtrI6IFAKEAE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$255:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$256;
	label$256:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI6IFAKEAE13ISEQUALOBJECTEPv( struct $6ComPtrI6IFAKEAE* THIS$1, void* OTHER$1 )
{
	int64 TMP$2120$1;
	int64 TMP$2121$1;
	int64 TMP$2122$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$257:;
	if( *(struct $6IFAKEA**)THIS$1 != (struct $6IFAKEA*)0ull) goto label$259;
	TMP$2120$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$270;
	label$259:;
	TMP$2120$1 = 0ll;
	label$270:;
	if( TMP$2120$1 == 0ll) goto label$261;
	{
		fb$result$1 = (boolean)1ll;
		goto label$258;
		label$261:;
	}
	if( *(struct $6IFAKEA**)THIS$1 == (struct $6IFAKEA*)0ull) goto label$262;
	TMP$2121$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$271;
	label$262:;
	TMP$2121$1 = -1ll;
	label$271:;
	if( TMP$2121$1 == 0ll) goto label$264;
	{
		fb$result$1 = (boolean)0ll;
		goto label$258;
		label$264:;
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
	if( A$1 == (void*)0ull) goto label$265;
	TMP$2122$1 = (int64)-(A$1 == B$1);
	goto label$272;
	label$265:;
	TMP$2122$1 = 0ll;
	label$272:;
	SAME$1 = (boolean)(TMP$2122$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$267;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEAE8tmp$2123Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEAE8tmp$2123Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$267:;
	}
	if( B$1 == (void*)0ull) goto label$269;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEAE8tmp$2124Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEAE8tmp$2124Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$269:;
	}
	fb$result$1 = SAME$1;
	goto label$258;
	label$258:;
	return fb$result$1;
}

static void _ZN6ComPtrI8INOTRAITEC1Ev( struct $6ComPtrI8INOTRAITE* THIS$1 )
{
	label$273:;
	__builtin_memset( (struct $8INOTRAIT**)THIS$1, 0, 8ll );
	*(struct $8INOTRAIT**)THIS$1 = (struct $8INOTRAIT*)0ull;
	label$274:;
}

static void _ZN6ComPtrI8INOTRAITEC1EPS0_( struct $6ComPtrI8INOTRAITE* THIS$1, struct $8INOTRAIT* RAW$1 )
{
	label$275:;
	__builtin_memset( (struct $8INOTRAIT**)THIS$1, 0, 8ll );
	*(struct $8INOTRAIT**)THIS$1 = RAW$1;
	if( *(struct $8INOTRAIT**)THIS$1 == (struct $8INOTRAIT*)0ull) goto label$278;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI8INOTRAITE8tmp$2125Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI8INOTRAITE8tmp$2125Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$278:;
	}
	label$276:;
}

static void _ZN6ComPtrI8INOTRAITEC1ERS1_( struct $6ComPtrI8INOTRAITE* THIS$1, struct $6ComPtrI8INOTRAITE* RHS$1 )
{
	label$279:;
	__builtin_memset( (struct $8INOTRAIT**)THIS$1, 0, 8ll );
	*(struct $8INOTRAIT**)THIS$1 = *(struct $8INOTRAIT**)RHS$1;
	if( *(struct $8INOTRAIT**)THIS$1 == (struct $8INOTRAIT*)0ull) goto label$282;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI8INOTRAITE8tmp$2126Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI8INOTRAITE8tmp$2126Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$282:;
	}
	label$280:;
}

static void _ZN6ComPtrI8INOTRAITED1Ev( struct $6ComPtrI8INOTRAITE* THIS$1 )
{
	label$283:;
	_ZN6ComPtrI8INOTRAITE7RELEASEEv( THIS$1 );
	label$284:;
}

static void _ZN6ComPtrI8INOTRAITEaSERS1_( struct $6ComPtrI8INOTRAITE* THIS$1, struct $6ComPtrI8INOTRAITE* RHS$1 )
{
	label$285:;
	if( *(struct $8INOTRAIT**)THIS$1 != *(struct $8INOTRAIT**)RHS$1) goto label$288;
	{
		goto label$286;
		label$288:;
	}
	struct $8INOTRAIT* OLD$1;
	OLD$1 = *(struct $8INOTRAIT**)THIS$1;
	*(struct $8INOTRAIT**)THIS$1 = *(struct $8INOTRAIT**)RHS$1;
	if( *(struct $8INOTRAIT**)THIS$1 == (struct $8INOTRAIT*)0ull) goto label$290;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI8INOTRAITE8tmp$2127Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI8INOTRAITE8tmp$2127Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$290:;
	}
	if( OLD$1 == (struct $8INOTRAIT*)0ull) goto label$292;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI8INOTRAITE8tmp$2128Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI8INOTRAITE8tmp$2128Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$292:;
	}
	label$286:;
}

static struct $8INOTRAIT* _ZN6ComPtrI8INOTRAITE3GETEv( struct $6ComPtrI8INOTRAITE* THIS$1 )
{
	struct $8INOTRAIT* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$293:;
	fb$result$1 = *(struct $8INOTRAIT**)THIS$1;
	goto label$294;
	label$294:;
	return fb$result$1;
}

static struct $8INOTRAIT* _ZN6ComPtrI8INOTRAITE3REFEv( struct $6ComPtrI8INOTRAITE* THIS$1 )
{
	struct $8INOTRAIT* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$295:;
	if( *(struct $8INOTRAIT**)THIS$1 != (struct $8INOTRAIT*)0ull) goto label$298;
	{
		label$299:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$300:;
	}
	label$298:;
	label$297:;
	fb$result$1 = *(struct $8INOTRAIT**)THIS$1;
	goto label$296;
	label$296:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI8INOTRAITE6ISNULLEv( struct $6ComPtrI8INOTRAITE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$301:;
	fb$result$1 = (boolean)((int64)-(*(struct $8INOTRAIT**)THIS$1 == (struct $8INOTRAIT*)0ull) != 0ll);
	goto label$302;
	label$302:;
	return fb$result$1;
}

static void _ZN6ComPtrI8INOTRAITE6ATTACHEPS0_( struct $6ComPtrI8INOTRAITE* THIS$1, struct $8INOTRAIT* RAW$1 )
{
	label$303:;
	_ZN6ComPtrI8INOTRAITE7RELEASEEv( THIS$1 );
	*(struct $8INOTRAIT**)THIS$1 = RAW$1;
	label$304:;
}

static struct $8INOTRAIT* _ZN6ComPtrI8INOTRAITE6DETACHEv( struct $6ComPtrI8INOTRAITE* THIS$1 )
{
	struct $8INOTRAIT* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$305:;
	struct $8INOTRAIT* R$1;
	R$1 = *(struct $8INOTRAIT**)THIS$1;
	*(struct $8INOTRAIT**)THIS$1 = (struct $8INOTRAIT*)0ull;
	fb$result$1 = R$1;
	goto label$306;
	label$306:;
	return fb$result$1;
}

static void _ZN6ComPtrI8INOTRAITE7RELEASEEv( struct $6ComPtrI8INOTRAITE* THIS$1 )
{
	label$307:;
	if( *(struct $8INOTRAIT**)THIS$1 == (struct $8INOTRAIT*)0ull) goto label$310;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $8INOTRAIT**)THIS$1 = (struct $8INOTRAIT*)0ull;
		typedef uint32 (*_ZN6ComPtrI8INOTRAITE8tmp$2129Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI8INOTRAITE8tmp$2129Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$310:;
	label$309:;
	label$308:;
}

static int32 _ZN6ComPtrI8INOTRAITE6COPYTOEPPS0_( struct $6ComPtrI8INOTRAITE* THIS$1, struct $8INOTRAIT** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$311:;
	if( PP$1 != (struct $8INOTRAIT**)0ull) goto label$314;
	{
		fb$result$1 = -2147467261;
		goto label$312;
		label$314:;
	}
	*PP$1 = *(struct $8INOTRAIT**)THIS$1;
	if( *(struct $8INOTRAIT**)THIS$1 == (struct $8INOTRAIT*)0ull) goto label$316;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI8INOTRAITE8tmp$2130Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI8INOTRAITE8tmp$2130Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$316:;
	}
	fb$result$1 = 0;
	goto label$312;
	label$312:;
	return fb$result$1;
}

static struct $8INOTRAIT** _ZN6ComPtrI8INOTRAITE6PUTREFEv( struct $6ComPtrI8INOTRAITE* THIS$1 )
{
	struct $8INOTRAIT** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$317:;
	if( *(struct $8INOTRAIT**)THIS$1 == (struct $8INOTRAIT*)0ull) goto label$320;
	{
		label$321:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$322:;
		label$320:;
	}
	fb$result$1 = (struct $8INOTRAIT**)THIS$1;
	goto label$318;
	label$318:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI8INOTRAITE7UNKNOWNEv( struct $6ComPtrI8INOTRAITE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$323:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$324;
	label$324:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI8INOTRAITE13ISEQUALOBJECTEPv( struct $6ComPtrI8INOTRAITE* THIS$1, void* OTHER$1 )
{
	int64 TMP$2131$1;
	int64 TMP$2132$1;
	int64 TMP$2133$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$325:;
	if( *(struct $8INOTRAIT**)THIS$1 != (struct $8INOTRAIT*)0ull) goto label$327;
	TMP$2131$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$338;
	label$327:;
	TMP$2131$1 = 0ll;
	label$338:;
	if( TMP$2131$1 == 0ll) goto label$329;
	{
		fb$result$1 = (boolean)1ll;
		goto label$326;
		label$329:;
	}
	if( *(struct $8INOTRAIT**)THIS$1 == (struct $8INOTRAIT*)0ull) goto label$330;
	TMP$2132$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$339;
	label$330:;
	TMP$2132$1 = -1ll;
	label$339:;
	if( TMP$2132$1 == 0ll) goto label$332;
	{
		fb$result$1 = (boolean)0ll;
		goto label$326;
		label$332:;
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
	if( A$1 == (void*)0ull) goto label$333;
	TMP$2133$1 = (int64)-(A$1 == B$1);
	goto label$340;
	label$333:;
	TMP$2133$1 = 0ll;
	label$340:;
	SAME$1 = (boolean)(TMP$2133$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$335;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI8INOTRAITE8tmp$2134Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI8INOTRAITE8tmp$2134Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$335:;
	}
	if( B$1 == (void*)0ull) goto label$337;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI8INOTRAITE8tmp$2135Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI8INOTRAITE8tmp$2135Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$337:;
	}
	fb$result$1 = SAME$1;
	goto label$326;
	label$326:;
	return fb$result$1;
}

static int32 _Z5ComQII8INOTRAITEPvPK5_GUIDR6ComPtrI8INOTRAITE( void* SRC$1, struct $5_GUID* IID$1, struct $6ComPtrI8INOTRAITE* DST$1 )
{
	int64 TMP$2136$1;
	int64 TMP$2138$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$341:;
	_ZN6ComPtrI8INOTRAITE7RELEASEEv( DST$1 );
	if( SRC$1 == (void*)0ull) goto label$343;
	TMP$2136$1 = (int64)-(IID$1 == (struct $5_GUID*)0ull);
	goto label$349;
	label$343:;
	TMP$2136$1 = -1ll;
	label$349:;
	if( TMP$2136$1 == 0ll) goto label$345;
	{
		fb$result$1 = -2147467261;
		goto label$342;
		label$345:;
	}
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $N2FB10COMUNKNOWNE* vr$3 = _ZN2FB6HASUNKEPv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( SRC$1 );
	typedef int32 (*_Z8tmp$2137PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$4 = (*(_Z8tmp$2137PK5_GUIDPPv*)*(void***)vr$5)( vr$3, IID$1, &OUT_$1 );
	HR$1 = vr$4;
	if( (int64)HR$1 < 0ll) goto label$346;
	TMP$2138$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$350;
	label$346:;
	TMP$2138$1 = 0ll;
	label$350:;
	if( TMP$2138$1 == 0ll) goto label$348;
	{
		_ZN6ComPtrI8INOTRAITE6ATTACHEPS0_( DST$1, (struct $8INOTRAIT*)OUT_$1 );
	}
	label$348:;
	label$347:;
	fb$result$1 = HR$1;
	goto label$342;
	label$342:;
	return fb$result$1;
}

static void _ZN6ComPtrI6IFAKEBEC1Ev( struct $6ComPtrI6IFAKEBE* THIS$1 )
{
	label$361:;
	__builtin_memset( (struct $6IFAKEB**)THIS$1, 0, 8ll );
	*(struct $6IFAKEB**)THIS$1 = (struct $6IFAKEB*)0ull;
	label$362:;
}

static void _ZN6ComPtrI6IFAKEBEC1EPS0_( struct $6ComPtrI6IFAKEBE* THIS$1, struct $6IFAKEB* RAW$1 )
{
	label$363:;
	__builtin_memset( (struct $6IFAKEB**)THIS$1, 0, 8ll );
	*(struct $6IFAKEB**)THIS$1 = RAW$1;
	if( *(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) goto label$366;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEBE8tmp$2144Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEBE8tmp$2144Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$366:;
	}
	label$364:;
}

static void _ZN6ComPtrI6IFAKEBEC1ERS1_( struct $6ComPtrI6IFAKEBE* THIS$1, struct $6ComPtrI6IFAKEBE* RHS$1 )
{
	label$367:;
	__builtin_memset( (struct $6IFAKEB**)THIS$1, 0, 8ll );
	*(struct $6IFAKEB**)THIS$1 = *(struct $6IFAKEB**)RHS$1;
	if( *(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) goto label$370;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEBE8tmp$2145Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEBE8tmp$2145Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$370:;
	}
	label$368:;
}

static void _ZN6ComPtrI6IFAKEBED1Ev( struct $6ComPtrI6IFAKEBE* THIS$1 )
{
	label$371:;
	_ZN6ComPtrI6IFAKEBE7RELEASEEv( THIS$1 );
	label$372:;
}

static void _ZN6ComPtrI6IFAKEBEaSERS1_( struct $6ComPtrI6IFAKEBE* THIS$1, struct $6ComPtrI6IFAKEBE* RHS$1 )
{
	label$373:;
	if( *(struct $6IFAKEB**)THIS$1 != *(struct $6IFAKEB**)RHS$1) goto label$376;
	{
		goto label$374;
		label$376:;
	}
	struct $6IFAKEB* OLD$1;
	OLD$1 = *(struct $6IFAKEB**)THIS$1;
	*(struct $6IFAKEB**)THIS$1 = *(struct $6IFAKEB**)RHS$1;
	if( *(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) goto label$378;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEBE8tmp$2146Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEBE8tmp$2146Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$378:;
	}
	if( OLD$1 == (struct $6IFAKEB*)0ull) goto label$380;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEBE8tmp$2147Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEBE8tmp$2147Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$380:;
	}
	label$374:;
}

static struct $6IFAKEB* _ZN6ComPtrI6IFAKEBE3GETEv( struct $6ComPtrI6IFAKEBE* THIS$1 )
{
	struct $6IFAKEB* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$381:;
	fb$result$1 = *(struct $6IFAKEB**)THIS$1;
	goto label$382;
	label$382:;
	return fb$result$1;
}

static struct $6IFAKEB* _ZN6ComPtrI6IFAKEBE3REFEv( struct $6ComPtrI6IFAKEBE* THIS$1 )
{
	struct $6IFAKEB* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$383:;
	if( *(struct $6IFAKEB**)THIS$1 != (struct $6IFAKEB*)0ull) goto label$386;
	{
		label$387:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$388:;
	}
	label$386:;
	label$385:;
	fb$result$1 = *(struct $6IFAKEB**)THIS$1;
	goto label$384;
	label$384:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI6IFAKEBE6ISNULLEv( struct $6ComPtrI6IFAKEBE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$389:;
	fb$result$1 = (boolean)((int64)-(*(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) != 0ll);
	goto label$390;
	label$390:;
	return fb$result$1;
}

static void _ZN6ComPtrI6IFAKEBE6ATTACHEPS0_( struct $6ComPtrI6IFAKEBE* THIS$1, struct $6IFAKEB* RAW$1 )
{
	label$391:;
	_ZN6ComPtrI6IFAKEBE7RELEASEEv( THIS$1 );
	*(struct $6IFAKEB**)THIS$1 = RAW$1;
	label$392:;
}

static struct $6IFAKEB* _ZN6ComPtrI6IFAKEBE6DETACHEv( struct $6ComPtrI6IFAKEBE* THIS$1 )
{
	struct $6IFAKEB* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$393:;
	struct $6IFAKEB* R$1;
	R$1 = *(struct $6IFAKEB**)THIS$1;
	*(struct $6IFAKEB**)THIS$1 = (struct $6IFAKEB*)0ull;
	fb$result$1 = R$1;
	goto label$394;
	label$394:;
	return fb$result$1;
}

static void _ZN6ComPtrI6IFAKEBE7RELEASEEv( struct $6ComPtrI6IFAKEBE* THIS$1 )
{
	label$395:;
	if( *(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) goto label$398;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $6IFAKEB**)THIS$1 = (struct $6IFAKEB*)0ull;
		typedef uint32 (*_ZN6ComPtrI6IFAKEBE8tmp$2148Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEBE8tmp$2148Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$398:;
	label$397:;
	label$396:;
}

static int32 _ZN6ComPtrI6IFAKEBE6COPYTOEPPS0_( struct $6ComPtrI6IFAKEBE* THIS$1, struct $6IFAKEB** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$399:;
	if( PP$1 != (struct $6IFAKEB**)0ull) goto label$402;
	{
		fb$result$1 = -2147467261;
		goto label$400;
		label$402:;
	}
	*PP$1 = *(struct $6IFAKEB**)THIS$1;
	if( *(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) goto label$404;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEBE8tmp$2149Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEBE8tmp$2149Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$404:;
	}
	fb$result$1 = 0;
	goto label$400;
	label$400:;
	return fb$result$1;
}

static struct $6IFAKEB** _ZN6ComPtrI6IFAKEBE6PUTREFEv( struct $6ComPtrI6IFAKEBE* THIS$1 )
{
	struct $6IFAKEB** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$405:;
	if( *(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) goto label$408;
	{
		label$409:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$410:;
		label$408:;
	}
	fb$result$1 = (struct $6IFAKEB**)THIS$1;
	goto label$406;
	label$406:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI6IFAKEBE7UNKNOWNEv( struct $6ComPtrI6IFAKEBE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$411:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$412;
	label$412:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI6IFAKEBE13ISEQUALOBJECTEPv( struct $6ComPtrI6IFAKEBE* THIS$1, void* OTHER$1 )
{
	int64 TMP$2150$1;
	int64 TMP$2151$1;
	int64 TMP$2152$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$413:;
	if( *(struct $6IFAKEB**)THIS$1 != (struct $6IFAKEB*)0ull) goto label$415;
	TMP$2150$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$426;
	label$415:;
	TMP$2150$1 = 0ll;
	label$426:;
	if( TMP$2150$1 == 0ll) goto label$417;
	{
		fb$result$1 = (boolean)1ll;
		goto label$414;
		label$417:;
	}
	if( *(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) goto label$418;
	TMP$2151$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$427;
	label$418:;
	TMP$2151$1 = -1ll;
	label$427:;
	if( TMP$2151$1 == 0ll) goto label$420;
	{
		fb$result$1 = (boolean)0ll;
		goto label$414;
		label$420:;
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
	if( A$1 == (void*)0ull) goto label$421;
	TMP$2152$1 = (int64)-(A$1 == B$1);
	goto label$428;
	label$421:;
	TMP$2152$1 = 0ll;
	label$428:;
	SAME$1 = (boolean)(TMP$2152$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$423;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEBE8tmp$2153Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEBE8tmp$2153Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$423:;
	}
	if( B$1 == (void*)0ull) goto label$425;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI6IFAKEBE8tmp$2154Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI6IFAKEBE8tmp$2154Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$425:;
	}
	fb$result$1 = SAME$1;
	goto label$414;
	label$414:;
	return fb$result$1;
}

static int32 _Z5ComQII6IFAKEBEPvPK5_GUIDR6ComPtrI6IFAKEBE( void* SRC$1, struct $5_GUID* IID$1, struct $6ComPtrI6IFAKEBE* DST$1 )
{
	int64 TMP$2155$1;
	int64 TMP$2157$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$429:;
	_ZN6ComPtrI6IFAKEBE7RELEASEEv( DST$1 );
	if( SRC$1 == (void*)0ull) goto label$431;
	TMP$2155$1 = (int64)-(IID$1 == (struct $5_GUID*)0ull);
	goto label$437;
	label$431:;
	TMP$2155$1 = -1ll;
	label$437:;
	if( TMP$2155$1 == 0ll) goto label$433;
	{
		fb$result$1 = -2147467261;
		goto label$430;
		label$433:;
	}
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $N2FB10COMUNKNOWNE* vr$3 = _ZN2FB6HASUNKEPv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( SRC$1 );
	typedef int32 (*_Z8tmp$2156PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$4 = (*(_Z8tmp$2156PK5_GUIDPPv*)*(void***)vr$5)( vr$3, IID$1, &OUT_$1 );
	HR$1 = vr$4;
	if( (int64)HR$1 < 0ll) goto label$434;
	TMP$2157$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$438;
	label$434:;
	TMP$2157$1 = 0ll;
	label$438:;
	if( TMP$2157$1 == 0ll) goto label$436;
	{
		_ZN6ComPtrI6IFAKEBE6ATTACHEPS0_( DST$1, (struct $6IFAKEB*)OUT_$1 );
	}
	label$436:;
	label$435:;
	fb$result$1 = HR$1;
	goto label$430;
	label$430:;
	return fb$result$1;
}

static int32 _Z7ComQIAsI6IFAKEBEPvR6ComPtrI6IFAKEBE( void* SRC$1, struct $6ComPtrI6IFAKEBE* DST$1 )
{
	int64 TMP$2159$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$439:;
	_ZN6ComPtrI6IFAKEBE7RELEASEEv( DST$1 );
	if( SRC$1 != (void*)0ull) goto label$442;
	{
		fb$result$1 = -2147467261;
		goto label$440;
		label$442:;
	}
	struct $6IidTagI6IFAKEBE TAG$1;
	__builtin_memset( &TAG$1, 0, 4ll );
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $5_GUID* vr$3 = _Z5IIDOF6IidTagI6IFAKEBE( TAG$1 );
	struct $N2FB10COMUNKNOWNE* vr$4 = _ZN2FB6HASUNKEPv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( SRC$1 );
	typedef int32 (*_Z8tmp$2158PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$5 = (*(_Z8tmp$2158PK5_GUIDPPv*)*(void***)vr$6)( vr$4, vr$3, &OUT_$1 );
	HR$1 = vr$5;
	if( (int64)HR$1 < 0ll) goto label$443;
	TMP$2159$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$446;
	label$443:;
	TMP$2159$1 = 0ll;
	label$446:;
	if( TMP$2159$1 == 0ll) goto label$445;
	{
		_ZN6ComPtrI6IFAKEBE6ATTACHEPS0_( DST$1, (struct $6IFAKEB*)OUT_$1 );
	}
	label$445:;
	label$444:;
	fb$result$1 = HR$1;
	goto label$440;
	label$440:;
	return fb$result$1;
}

static void _ZN6ComPtrI12IUNSUPPORTEDEC1Ev( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1 )
{
	label$481:;
	__builtin_memset( (struct $12IUNSUPPORTED**)THIS$1, 0, 8ll );
	*(struct $12IUNSUPPORTED**)THIS$1 = (struct $12IUNSUPPORTED*)0ull;
	label$482:;
}

static void _ZN6ComPtrI12IUNSUPPORTEDEC1EPS0_( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1, struct $12IUNSUPPORTED* RAW$1 )
{
	label$483:;
	__builtin_memset( (struct $12IUNSUPPORTED**)THIS$1, 0, 8ll );
	*(struct $12IUNSUPPORTED**)THIS$1 = RAW$1;
	if( *(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) goto label$486;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2170Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2170Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$486:;
	}
	label$484:;
}

static void _ZN6ComPtrI12IUNSUPPORTEDEC1ERS1_( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1, struct $6ComPtrI12IUNSUPPORTEDE* RHS$1 )
{
	label$487:;
	__builtin_memset( (struct $12IUNSUPPORTED**)THIS$1, 0, 8ll );
	*(struct $12IUNSUPPORTED**)THIS$1 = *(struct $12IUNSUPPORTED**)RHS$1;
	if( *(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) goto label$490;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2171Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2171Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$490:;
	}
	label$488:;
}

static void _ZN6ComPtrI12IUNSUPPORTEDED1Ev( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1 )
{
	label$491:;
	_ZN6ComPtrI12IUNSUPPORTEDE7RELEASEEv( THIS$1 );
	label$492:;
}

static void _ZN6ComPtrI12IUNSUPPORTEDEaSERS1_( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1, struct $6ComPtrI12IUNSUPPORTEDE* RHS$1 )
{
	label$493:;
	if( *(struct $12IUNSUPPORTED**)THIS$1 != *(struct $12IUNSUPPORTED**)RHS$1) goto label$496;
	{
		goto label$494;
		label$496:;
	}
	struct $12IUNSUPPORTED* OLD$1;
	OLD$1 = *(struct $12IUNSUPPORTED**)THIS$1;
	*(struct $12IUNSUPPORTED**)THIS$1 = *(struct $12IUNSUPPORTED**)RHS$1;
	if( *(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) goto label$498;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2172Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2172Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$498:;
	}
	if( OLD$1 == (struct $12IUNSUPPORTED*)0ull) goto label$500;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2173Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2173Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$500:;
	}
	label$494:;
}

static struct $12IUNSUPPORTED* _ZN6ComPtrI12IUNSUPPORTEDE3GETEv( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1 )
{
	struct $12IUNSUPPORTED* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$501:;
	fb$result$1 = *(struct $12IUNSUPPORTED**)THIS$1;
	goto label$502;
	label$502:;
	return fb$result$1;
}

static struct $12IUNSUPPORTED* _ZN6ComPtrI12IUNSUPPORTEDE3REFEv( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1 )
{
	struct $12IUNSUPPORTED* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$503:;
	if( *(struct $12IUNSUPPORTED**)THIS$1 != (struct $12IUNSUPPORTED*)0ull) goto label$506;
	{
		label$507:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$508:;
	}
	label$506:;
	label$505:;
	fb$result$1 = *(struct $12IUNSUPPORTED**)THIS$1;
	goto label$504;
	label$504:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI12IUNSUPPORTEDE6ISNULLEv( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$509:;
	fb$result$1 = (boolean)((int64)-(*(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) != 0ll);
	goto label$510;
	label$510:;
	return fb$result$1;
}

static void _ZN6ComPtrI12IUNSUPPORTEDE6ATTACHEPS0_( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1, struct $12IUNSUPPORTED* RAW$1 )
{
	label$511:;
	_ZN6ComPtrI12IUNSUPPORTEDE7RELEASEEv( THIS$1 );
	*(struct $12IUNSUPPORTED**)THIS$1 = RAW$1;
	label$512:;
}

static struct $12IUNSUPPORTED* _ZN6ComPtrI12IUNSUPPORTEDE6DETACHEv( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1 )
{
	struct $12IUNSUPPORTED* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$513:;
	struct $12IUNSUPPORTED* R$1;
	R$1 = *(struct $12IUNSUPPORTED**)THIS$1;
	*(struct $12IUNSUPPORTED**)THIS$1 = (struct $12IUNSUPPORTED*)0ull;
	fb$result$1 = R$1;
	goto label$514;
	label$514:;
	return fb$result$1;
}

static void _ZN6ComPtrI12IUNSUPPORTEDE7RELEASEEv( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1 )
{
	label$515:;
	if( *(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) goto label$518;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $12IUNSUPPORTED**)THIS$1 = (struct $12IUNSUPPORTED*)0ull;
		typedef uint32 (*_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2174Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2174Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$518:;
	label$517:;
	label$516:;
}

static int32 _ZN6ComPtrI12IUNSUPPORTEDE6COPYTOEPPS0_( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1, struct $12IUNSUPPORTED** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$519:;
	if( PP$1 != (struct $12IUNSUPPORTED**)0ull) goto label$522;
	{
		fb$result$1 = -2147467261;
		goto label$520;
		label$522:;
	}
	*PP$1 = *(struct $12IUNSUPPORTED**)THIS$1;
	if( *(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) goto label$524;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2175Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2175Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$524:;
	}
	fb$result$1 = 0;
	goto label$520;
	label$520:;
	return fb$result$1;
}

static struct $12IUNSUPPORTED** _ZN6ComPtrI12IUNSUPPORTEDE6PUTREFEv( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1 )
{
	struct $12IUNSUPPORTED** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$525:;
	if( *(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) goto label$528;
	{
		label$529:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$530:;
		label$528:;
	}
	fb$result$1 = (struct $12IUNSUPPORTED**)THIS$1;
	goto label$526;
	label$526:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrI12IUNSUPPORTEDE7UNKNOWNEv( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$531:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$532;
	label$532:;
	return fb$result$1;
}

static boolean _ZN6ComPtrI12IUNSUPPORTEDE13ISEQUALOBJECTEPv( struct $6ComPtrI12IUNSUPPORTEDE* THIS$1, void* OTHER$1 )
{
	int64 TMP$2176$1;
	int64 TMP$2177$1;
	int64 TMP$2178$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$533:;
	if( *(struct $12IUNSUPPORTED**)THIS$1 != (struct $12IUNSUPPORTED*)0ull) goto label$535;
	TMP$2176$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$546;
	label$535:;
	TMP$2176$1 = 0ll;
	label$546:;
	if( TMP$2176$1 == 0ll) goto label$537;
	{
		fb$result$1 = (boolean)1ll;
		goto label$534;
		label$537:;
	}
	if( *(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) goto label$538;
	TMP$2177$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$547;
	label$538:;
	TMP$2177$1 = -1ll;
	label$547:;
	if( TMP$2177$1 == 0ll) goto label$540;
	{
		fb$result$1 = (boolean)0ll;
		goto label$534;
		label$540:;
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
	if( A$1 == (void*)0ull) goto label$541;
	TMP$2178$1 = (int64)-(A$1 == B$1);
	goto label$548;
	label$541:;
	TMP$2178$1 = 0ll;
	label$548:;
	SAME$1 = (boolean)(TMP$2178$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$543;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2179Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2179Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$543:;
	}
	if( B$1 == (void*)0ull) goto label$545;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2180Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrI12IUNSUPPORTEDE8tmp$2180Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$545:;
	}
	fb$result$1 = SAME$1;
	goto label$534;
	label$534:;
	return fb$result$1;
}

static int32 _Z7ComQIAsI12IUNSUPPORTEDEPvR6ComPtrI12IUNSUPPORTEDE( void* SRC$1, struct $6ComPtrI12IUNSUPPORTEDE* DST$1 )
{
	int64 TMP$2182$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$549:;
	_ZN6ComPtrI12IUNSUPPORTEDE7RELEASEEv( DST$1 );
	if( SRC$1 != (void*)0ull) goto label$552;
	{
		fb$result$1 = -2147467261;
		goto label$550;
		label$552:;
	}
	struct $6IidTagI12IUNSUPPORTEDE TAG$1;
	__builtin_memset( &TAG$1, 0, 4ll );
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $5_GUID* vr$3 = _Z5IIDOF6IidTagI12IUNSUPPORTEDE( TAG$1 );
	struct $N2FB10COMUNKNOWNE* vr$4 = _ZN2FB6HASUNKEPv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( SRC$1 );
	typedef int32 (*_Z8tmp$2181PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$5 = (*(_Z8tmp$2181PK5_GUIDPPv*)*(void***)vr$6)( vr$4, vr$3, &OUT_$1 );
	HR$1 = vr$5;
	if( (int64)HR$1 < 0ll) goto label$553;
	TMP$2182$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$556;
	label$553:;
	TMP$2182$1 = 0ll;
	label$556:;
	if( TMP$2182$1 == 0ll) goto label$555;
	{
		_ZN6ComPtrI12IUNSUPPORTEDE6ATTACHEPS0_( DST$1, (struct $12IUNSUPPORTED*)OUT_$1 );
	}
	label$555:;
	label$554:;
	fb$result$1 = HR$1;
	goto label$550;
	label$550:;
	return fb$result$1;
}

static int32 _Z5ComQII12IUNSUPPORTEDEPvPK5_GUIDR6ComPtrI12IUNSUPPORTEDE( void* SRC$1, struct $5_GUID* IID$1, struct $6ComPtrI12IUNSUPPORTEDE* DST$1 )
{
	int64 TMP$2183$1;
	int64 TMP$2185$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$557:;
	_ZN6ComPtrI12IUNSUPPORTEDE7RELEASEEv( DST$1 );
	if( SRC$1 == (void*)0ull) goto label$559;
	TMP$2183$1 = (int64)-(IID$1 == (struct $5_GUID*)0ull);
	goto label$565;
	label$559:;
	TMP$2183$1 = -1ll;
	label$565:;
	if( TMP$2183$1 == 0ll) goto label$561;
	{
		fb$result$1 = -2147467261;
		goto label$558;
		label$561:;
	}
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $N2FB10COMUNKNOWNE* vr$3 = _ZN2FB6HASUNKEPv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( SRC$1 );
	typedef int32 (*_Z8tmp$2184PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$4 = (*(_Z8tmp$2184PK5_GUIDPPv*)*(void***)vr$5)( vr$3, IID$1, &OUT_$1 );
	HR$1 = vr$4;
	if( (int64)HR$1 < 0ll) goto label$562;
	TMP$2185$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$566;
	label$562:;
	TMP$2185$1 = 0ll;
	label$566:;
	if( TMP$2185$1 == 0ll) goto label$564;
	{
		_ZN6ComPtrI12IUNSUPPORTEDE6ATTACHEPS0_( DST$1, (struct $12IUNSUPPORTED*)OUT_$1 );
	}
	label$564:;
	label$563:;
	fb$result$1 = HR$1;
	goto label$558;
	label$558:;
	return fb$result$1;
}

static void _ZN8ComQIPtrI6IFAKEBEC1Ev( struct $8ComQIPtrI6IFAKEBE* THIS$1 )
{
	label$599:;
	_ZN6ComPtrI6IFAKEBEC1Ev( (struct $6ComPtrI6IFAKEBE*)THIS$1 );
	*(struct $6IFAKEB**)THIS$1 = (struct $6IFAKEB*)0ull;
	label$600:;
}

static void _ZN8ComQIPtrI6IFAKEBEC1EPv( struct $8ComQIPtrI6IFAKEBE* THIS$1, void* SRC$1 )
{
	label$601:;
	_ZN6ComPtrI6IFAKEBEC1Ev( (struct $6ComPtrI6IFAKEBE*)THIS$1 );
	*(struct $6IFAKEB**)THIS$1 = (struct $6IFAKEB*)0ull;
	if( SRC$1 == (void*)0ull) goto label$604;
	{
		struct $6IidTagI6IFAKEBE TAG$2;
		__builtin_memset( &TAG$2, 0, 4ll );
		void* OUT_$2;
		OUT_$2 = (void*)0ull;
		struct $5_GUID* vr$5 = _Z5IIDOF6IidTagI6IFAKEBE( TAG$2 );
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( SRC$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( SRC$1 );
		typedef int32 (*_ZN8ComQIPtrI6IFAKEBE8tmp$2191EPK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
		int32 vr$7 = (*(_ZN8ComQIPtrI6IFAKEBE8tmp$2191EPK5_GUIDPPv*)*(void***)vr$8)( vr$6, vr$5, &OUT_$2 );
		if( (int64)vr$7 < 0ll) goto label$606;
		{
			*(struct $6IFAKEB**)THIS$1 = (struct $6IFAKEB*)OUT_$2;
		}
		label$606:;
		label$605:;
	}
	label$604:;
	label$603:;
	label$602:;
}

static void _ZN8ComQIPtrI6IFAKEBEC1ERS1_( struct $8ComQIPtrI6IFAKEBE* THIS$1, struct $8ComQIPtrI6IFAKEBE* RHS$1 )
{
	label$607:;
	_ZN6ComPtrI6IFAKEBEC1Ev( (struct $6ComPtrI6IFAKEBE*)THIS$1 );
	*(struct $6IFAKEB**)THIS$1 = *(struct $6IFAKEB**)RHS$1;
	if( *(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) goto label$610;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN8ComQIPtrI6IFAKEBE8tmp$2192Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN8ComQIPtrI6IFAKEBE8tmp$2192Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$610:;
	}
	label$608:;
}

static void _ZN8ComQIPtrI6IFAKEBEaSEPv( struct $8ComQIPtrI6IFAKEBE* THIS$1, void* SRC$1 )
{
	label$611:;
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	if( SRC$1 == (void*)0ull) goto label$614;
	{
		struct $6IidTagI6IFAKEBE TAG$2;
		__builtin_memset( &TAG$2, 0, 4ll );
		struct $5_GUID* vr$2 = _Z5IIDOF6IidTagI6IFAKEBE( TAG$2 );
		struct $N2FB10COMUNKNOWNE* vr$3 = _ZN2FB6HASUNKEPv( SRC$1 );
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( SRC$1 );
		typedef int32 (*_ZN8ComQIPtrI6IFAKEBE8tmp$2193EPK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
		int32 vr$4 = (*(_ZN8ComQIPtrI6IFAKEBE8tmp$2193EPK5_GUIDPPv*)*(void***)vr$5)( vr$3, vr$2, &OUT_$1 );
		if( (int64)vr$4 >= 0ll) goto label$616;
		{
			OUT_$1 = (void*)0ull;
			label$616:;
		}
	}
	label$614:;
	label$613:;
	struct $6IFAKEB* OLD$1;
	OLD$1 = *(struct $6IFAKEB**)THIS$1;
	*(struct $6IFAKEB**)THIS$1 = (struct $6IFAKEB*)OUT_$1;
	if( OLD$1 == (struct $6IFAKEB*)0ull) goto label$618;
	{
		struct $N2FB10COMUNKNOWNE* vr$10 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN8ComQIPtrI6IFAKEBE8tmp$2194Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN8ComQIPtrI6IFAKEBE8tmp$2194Ev*)((uint8*)*(void***)vr$11 + 16ll))( vr$10 );
		label$618:;
	}
	label$612:;
}

static void _ZN8ComQIPtrI6IFAKEBEaSERS1_( struct $8ComQIPtrI6IFAKEBE* THIS$1, struct $8ComQIPtrI6IFAKEBE* RHS$1 )
{
	label$619:;
	if( *(struct $6IFAKEB**)THIS$1 != *(struct $6IFAKEB**)RHS$1) goto label$622;
	{
		goto label$620;
		label$622:;
	}
	struct $6IFAKEB* OLD$1;
	OLD$1 = *(struct $6IFAKEB**)THIS$1;
	*(struct $6IFAKEB**)THIS$1 = *(struct $6IFAKEB**)RHS$1;
	if( *(struct $6IFAKEB**)THIS$1 == (struct $6IFAKEB*)0ull) goto label$624;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN8ComQIPtrI6IFAKEBE8tmp$2195Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN8ComQIPtrI6IFAKEBE8tmp$2195Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$624:;
	}
	if( OLD$1 == (struct $6IFAKEB*)0ull) goto label$626;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN8ComQIPtrI6IFAKEBE8tmp$2196Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN8ComQIPtrI6IFAKEBE8tmp$2196Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$626:;
	}
	label$620:;
}

static struct $6IFAKEB* _ZptR8ComQIPtrI6IFAKEBE( struct $8ComQIPtrI6IFAKEBE* H$1 )
{
	struct $6IFAKEB* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$627:;
	fb$result$1 = *(struct $6IFAKEB**)H$1;
	goto label$628;
	label$628:;
	return fb$result$1;
}

static void _ZN8ComQIPtrI12IUNSUPPORTEDEC1Ev( struct $8ComQIPtrI12IUNSUPPORTEDE* THIS$1 )
{
	label$629:;
	_ZN6ComPtrI12IUNSUPPORTEDEC1Ev( (struct $6ComPtrI12IUNSUPPORTEDE*)THIS$1 );
	*(struct $12IUNSUPPORTED**)THIS$1 = (struct $12IUNSUPPORTED*)0ull;
	label$630:;
}

static void _ZN8ComQIPtrI12IUNSUPPORTEDEC1EPv( struct $8ComQIPtrI12IUNSUPPORTEDE* THIS$1, void* SRC$1 )
{
	label$631:;
	_ZN6ComPtrI12IUNSUPPORTEDEC1Ev( (struct $6ComPtrI12IUNSUPPORTEDE*)THIS$1 );
	*(struct $12IUNSUPPORTED**)THIS$1 = (struct $12IUNSUPPORTED*)0ull;
	if( SRC$1 == (void*)0ull) goto label$634;
	{
		struct $6IidTagI12IUNSUPPORTEDE TAG$2;
		__builtin_memset( &TAG$2, 0, 4ll );
		void* OUT_$2;
		OUT_$2 = (void*)0ull;
		struct $5_GUID* vr$5 = _Z5IIDOF6IidTagI12IUNSUPPORTEDE( TAG$2 );
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( SRC$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( SRC$1 );
		typedef int32 (*_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2197EPK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
		int32 vr$7 = (*(_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2197EPK5_GUIDPPv*)*(void***)vr$8)( vr$6, vr$5, &OUT_$2 );
		if( (int64)vr$7 < 0ll) goto label$636;
		{
			*(struct $12IUNSUPPORTED**)THIS$1 = (struct $12IUNSUPPORTED*)OUT_$2;
		}
		label$636:;
		label$635:;
	}
	label$634:;
	label$633:;
	label$632:;
}

static void _ZN8ComQIPtrI12IUNSUPPORTEDEC1ERS1_( struct $8ComQIPtrI12IUNSUPPORTEDE* THIS$1, struct $8ComQIPtrI12IUNSUPPORTEDE* RHS$1 )
{
	label$637:;
	_ZN6ComPtrI12IUNSUPPORTEDEC1Ev( (struct $6ComPtrI12IUNSUPPORTEDE*)THIS$1 );
	*(struct $12IUNSUPPORTED**)THIS$1 = *(struct $12IUNSUPPORTED**)RHS$1;
	if( *(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) goto label$640;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2198Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2198Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$640:;
	}
	label$638:;
}

static void _ZN8ComQIPtrI12IUNSUPPORTEDEaSEPv( struct $8ComQIPtrI12IUNSUPPORTEDE* THIS$1, void* SRC$1 )
{
	label$641:;
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	if( SRC$1 == (void*)0ull) goto label$644;
	{
		struct $6IidTagI12IUNSUPPORTEDE TAG$2;
		__builtin_memset( &TAG$2, 0, 4ll );
		struct $5_GUID* vr$2 = _Z5IIDOF6IidTagI12IUNSUPPORTEDE( TAG$2 );
		struct $N2FB10COMUNKNOWNE* vr$3 = _ZN2FB6HASUNKEPv( SRC$1 );
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( SRC$1 );
		typedef int32 (*_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2199EPK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
		int32 vr$4 = (*(_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2199EPK5_GUIDPPv*)*(void***)vr$5)( vr$3, vr$2, &OUT_$1 );
		if( (int64)vr$4 >= 0ll) goto label$646;
		{
			OUT_$1 = (void*)0ull;
			label$646:;
		}
	}
	label$644:;
	label$643:;
	struct $12IUNSUPPORTED* OLD$1;
	OLD$1 = *(struct $12IUNSUPPORTED**)THIS$1;
	*(struct $12IUNSUPPORTED**)THIS$1 = (struct $12IUNSUPPORTED*)OUT_$1;
	if( OLD$1 == (struct $12IUNSUPPORTED*)0ull) goto label$648;
	{
		struct $N2FB10COMUNKNOWNE* vr$10 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2200Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2200Ev*)((uint8*)*(void***)vr$11 + 16ll))( vr$10 );
		label$648:;
	}
	label$642:;
}

static void _ZN8ComQIPtrI12IUNSUPPORTEDEaSERS1_( struct $8ComQIPtrI12IUNSUPPORTEDE* THIS$1, struct $8ComQIPtrI12IUNSUPPORTEDE* RHS$1 )
{
	label$649:;
	if( *(struct $12IUNSUPPORTED**)THIS$1 != *(struct $12IUNSUPPORTED**)RHS$1) goto label$652;
	{
		goto label$650;
		label$652:;
	}
	struct $12IUNSUPPORTED* OLD$1;
	OLD$1 = *(struct $12IUNSUPPORTED**)THIS$1;
	*(struct $12IUNSUPPORTED**)THIS$1 = *(struct $12IUNSUPPORTED**)RHS$1;
	if( *(struct $12IUNSUPPORTED**)THIS$1 == (struct $12IUNSUPPORTED*)0ull) goto label$654;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2201Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2201Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$654:;
	}
	if( OLD$1 == (struct $12IUNSUPPORTED*)0ull) goto label$656;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2202Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN8ComQIPtrI12IUNSUPPORTEDE8tmp$2202Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$656:;
	}
	label$650:;
}

static struct $6IFAKEB* _ZdeR8ComQIPtrI6IFAKEBE( struct $8ComQIPtrI6IFAKEBE* H$1 )
{
	struct $6IFAKEB* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$721:;
	fb$result$1 = *(struct $6IFAKEB**)H$1;
	goto label$722;
	label$722:;
	return fb$result$1;
}

static int32 _Z7ComCastI6IFAKEA6IFAKEBER6ComPtrI6IFAKEAER6ComPtrI6IFAKEBE( struct $6ComPtrI6IFAKEAE* SRC$1, struct $6ComPtrI6IFAKEBE* DST$1 )
{
	int64 TMP$2232$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$755:;
	_ZN6ComPtrI6IFAKEBE7RELEASEEv( DST$1 );
	boolean vr$1 = _ZN6ComPtrI6IFAKEAE6ISNULLEv( SRC$1 );
	if( vr$1 == (boolean)0ll) goto label$758;
	{
		fb$result$1 = -2147467261;
		goto label$756;
		label$758:;
	}
	struct $6IidTagI6IFAKEBE TAG$1;
	__builtin_memset( &TAG$1, 0, 4ll );
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $5_GUID* vr$4 = _Z5IIDOF6IidTagI6IFAKEBE( TAG$1 );
	struct $N2FB10COMUNKNOWNE* vr$5 = _ZN6ComPtrI6IFAKEAE7UNKNOWNEv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$7 = _ZN6ComPtrI6IFAKEAE7UNKNOWNEv( SRC$1 );
	typedef int32 (*_Z8tmp$2231PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$6 = (*(_Z8tmp$2231PK5_GUIDPPv*)*(void***)vr$7)( vr$5, vr$4, &OUT_$1 );
	HR$1 = vr$6;
	if( (int64)HR$1 < 0ll) goto label$759;
	TMP$2232$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$762;
	label$759:;
	TMP$2232$1 = 0ll;
	label$762:;
	if( TMP$2232$1 == 0ll) goto label$761;
	{
		_ZN6ComPtrI6IFAKEBE6ATTACHEPS0_( DST$1, (struct $6IFAKEB*)OUT_$1 );
	}
	label$761:;
	label$760:;
	fb$result$1 = HR$1;
	goto label$756;
	label$756:;
	return fb$result$1;
}

static struct $6IFAKEB* _ZptR6ComPtrI6IFAKEBE( struct $6ComPtrI6IFAKEBE* H$1 )
{
	struct $6IFAKEB* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$763:;
	fb$result$1 = *(struct $6IFAKEB**)H$1;
	goto label$764;
	label$764:;
	return fb$result$1;
}

static int32 _Z7ComCastI6IFAKEB6IFAKEAER6ComPtrI6IFAKEBER6ComPtrI6IFAKEAE( struct $6ComPtrI6IFAKEBE* SRC$1, struct $6ComPtrI6IFAKEAE* DST$1 )
{
	int64 TMP$2234$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$765:;
	_ZN6ComPtrI6IFAKEAE7RELEASEEv( DST$1 );
	boolean vr$1 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( SRC$1 );
	if( vr$1 == (boolean)0ll) goto label$768;
	{
		fb$result$1 = -2147467261;
		goto label$766;
		label$768:;
	}
	struct $6IidTagI6IFAKEAE TAG$1;
	__builtin_memset( &TAG$1, 0, 4ll );
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $5_GUID* vr$4 = _Z5IIDOF6IidTagI6IFAKEAE( TAG$1 );
	struct $N2FB10COMUNKNOWNE* vr$5 = _ZN6ComPtrI6IFAKEBE7UNKNOWNEv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$7 = _ZN6ComPtrI6IFAKEBE7UNKNOWNEv( SRC$1 );
	typedef int32 (*_Z8tmp$2233PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$6 = (*(_Z8tmp$2233PK5_GUIDPPv*)*(void***)vr$7)( vr$5, vr$4, &OUT_$1 );
	HR$1 = vr$6;
	if( (int64)HR$1 < 0ll) goto label$769;
	TMP$2234$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$772;
	label$769:;
	TMP$2234$1 = 0ll;
	label$772:;
	if( TMP$2234$1 == 0ll) goto label$771;
	{
		_ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( DST$1, (struct $6IFAKEA*)OUT_$1 );
	}
	label$771:;
	label$770:;
	fb$result$1 = HR$1;
	goto label$766;
	label$766:;
	return fb$result$1;
}

static struct $6IFAKEA* _ZptR6ComPtrI6IFAKEAE( struct $6ComPtrI6IFAKEAE* H$1 )
{
	struct $6IFAKEA* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$773:;
	fb$result$1 = *(struct $6IFAKEA**)H$1;
	goto label$774;
	label$774:;
	return fb$result$1;
}

static int32 _Z7ComCastI6IFAKEA12IUNSUPPORTEDER6ComPtrI6IFAKEAER6ComPtrI12IUNSUPPORTEDE( struct $6ComPtrI6IFAKEAE* SRC$1, struct $6ComPtrI12IUNSUPPORTEDE* DST$1 )
{
	int64 TMP$2236$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$775:;
	_ZN6ComPtrI12IUNSUPPORTEDE7RELEASEEv( DST$1 );
	boolean vr$1 = _ZN6ComPtrI6IFAKEAE6ISNULLEv( SRC$1 );
	if( vr$1 == (boolean)0ll) goto label$778;
	{
		fb$result$1 = -2147467261;
		goto label$776;
		label$778:;
	}
	struct $6IidTagI12IUNSUPPORTEDE TAG$1;
	__builtin_memset( &TAG$1, 0, 4ll );
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $5_GUID* vr$4 = _Z5IIDOF6IidTagI12IUNSUPPORTEDE( TAG$1 );
	struct $N2FB10COMUNKNOWNE* vr$5 = _ZN6ComPtrI6IFAKEAE7UNKNOWNEv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$7 = _ZN6ComPtrI6IFAKEAE7UNKNOWNEv( SRC$1 );
	typedef int32 (*_Z8tmp$2235PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$6 = (*(_Z8tmp$2235PK5_GUIDPPv*)*(void***)vr$7)( vr$5, vr$4, &OUT_$1 );
	HR$1 = vr$6;
	if( (int64)HR$1 < 0ll) goto label$779;
	TMP$2236$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$782;
	label$779:;
	TMP$2236$1 = 0ll;
	label$782:;
	if( TMP$2236$1 == 0ll) goto label$781;
	{
		_ZN6ComPtrI12IUNSUPPORTEDE6ATTACHEPS0_( DST$1, (struct $12IUNSUPPORTED*)OUT_$1 );
	}
	label$781:;
	label$780:;
	fb$result$1 = HR$1;
	goto label$776;
	label$776:;
	return fb$result$1;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1Ev( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	label$801:;
	__builtin_memset( (struct $N2FB10COMUNKNOWNE**)THIS$1, 0, 8ll );
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = (struct $N2FB10COMUNKNOWNE*)0ull;
	label$802:;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1EPS1_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $N2FB10COMUNKNOWNE* RAW$1 )
{
	label$803:;
	__builtin_memset( (struct $N2FB10COMUNKNOWNE**)THIS$1, 0, 8ll );
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = RAW$1;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$806;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2258Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2258Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$806:;
	}
	label$804:;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEEC1ERS2_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $6ComPtrIN2FB10COMUNKNOWNEE* RHS$1 )
{
	label$807:;
	__builtin_memset( (struct $N2FB10COMUNKNOWNE**)THIS$1, 0, 8ll );
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = *(struct $N2FB10COMUNKNOWNE**)RHS$1;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$810;
	{
		struct $N2FB10COMUNKNOWNE* vr$6 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$8 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2259Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2259Ev*)((uint8*)*(void***)vr$8 + 8ll))( vr$6 );
		label$810:;
	}
	label$808:;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	label$811:;
	_ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( THIS$1 );
	label$812:;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEEaSERS2_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $6ComPtrIN2FB10COMUNKNOWNEE* RHS$1 )
{
	label$813:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 != *(struct $N2FB10COMUNKNOWNE**)RHS$1) goto label$816;
	{
		goto label$814;
		label$816:;
	}
	struct $N2FB10COMUNKNOWNE* OLD$1;
	OLD$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = *(struct $N2FB10COMUNKNOWNE**)RHS$1;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$818;
	{
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$9 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2260Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2260Ev*)((uint8*)*(void***)vr$9 + 8ll))( vr$7 );
		label$818:;
	}
	if( OLD$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$820;
	{
		struct $N2FB10COMUNKNOWNE* vr$11 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( (void*)OLD$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2261Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2261Ev*)((uint8*)*(void***)vr$12 + 16ll))( vr$11 );
		label$820:;
	}
	label$814:;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE3GETEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$821:;
	fb$result$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	goto label$822;
	label$822:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE3REFEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$823:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 != (struct $N2FB10COMUNKNOWNE*)0ull) goto label$826;
	{
		label$827:;
		void* vr$2 = fb_ErrorThrowEx( 1, 292, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$828:;
	}
	label$826:;
	label$825:;
	fb$result$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	goto label$824;
	label$824:;
	return fb$result$1;
}

static boolean _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$829:;
	fb$result$1 = (boolean)((int64)-(*(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) != 0ll);
	goto label$830;
	label$830:;
	return fb$result$1;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEE6ATTACHEPS1_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $N2FB10COMUNKNOWNE* RAW$1 )
{
	label$831:;
	_ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( THIS$1 );
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = RAW$1;
	label$832:;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE6DETACHEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$833:;
	struct $N2FB10COMUNKNOWNE* R$1;
	R$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	*(struct $N2FB10COMUNKNOWNE**)THIS$1 = (struct $N2FB10COMUNKNOWNE*)0ull;
	fb$result$1 = R$1;
	goto label$834;
	label$834:;
	return fb$result$1;
}

static void _ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	label$835:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$838;
	{
		struct $N2FB10COMUNKNOWNE* U$2;
		struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		U$2 = vr$2;
		*(struct $N2FB10COMUNKNOWNE**)THIS$1 = (struct $N2FB10COMUNKNOWNE*)0ull;
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2262Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2262Ev*)((uint8*)*(void***)U$2 + 16ll))( U$2 );
	}
	label$838:;
	label$837:;
	label$836:;
}

static int32 _ZN6ComPtrIN2FB10COMUNKNOWNEE6COPYTOEPPS1_( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, struct $N2FB10COMUNKNOWNE** PP$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$839:;
	if( PP$1 != (struct $N2FB10COMUNKNOWNE**)0ull) goto label$842;
	{
		fb$result$1 = -2147467261;
		goto label$840;
		label$842:;
	}
	*PP$1 = *(struct $N2FB10COMUNKNOWNE**)THIS$1;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$844;
	{
		struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		struct $N2FB10COMUNKNOWNE* vr$7 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2263Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2263Ev*)((uint8*)*(void***)vr$7 + 8ll))( vr$5 );
		label$844:;
	}
	fb$result$1 = 0;
	goto label$840;
	label$840:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE** _ZN6ComPtrIN2FB10COMUNKNOWNEE6PUTREFEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE** fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$845:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$848;
	{
		label$849:;
		void* vr$2 = fb_ErrorThrowEx( 1, 347, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "comptr.bi", (void*)0ull, (void*)0ull );
		goto *vr$2;
		label$850:;
		label$848:;
	}
	fb$result$1 = (struct $N2FB10COMUNKNOWNE**)THIS$1;
	goto label$846;
	label$846:;
	return fb$result$1;
}

static struct $N2FB10COMUNKNOWNE* _ZN6ComPtrIN2FB10COMUNKNOWNEE7UNKNOWNEv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1 )
{
	struct $N2FB10COMUNKNOWNE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$851:;
	struct $N2FB10COMUNKNOWNE* vr$2 = _ZN2FB6HASUNKEPv( *(void**)THIS$1 );
	fb$result$1 = vr$2;
	goto label$852;
	label$852:;
	return fb$result$1;
}

static boolean _ZN6ComPtrIN2FB10COMUNKNOWNEE13ISEQUALOBJECTEPv( struct $6ComPtrIN2FB10COMUNKNOWNEE* THIS$1, void* OTHER$1 )
{
	int64 TMP$2264$1;
	int64 TMP$2265$1;
	int64 TMP$2266$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$853:;
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 != (struct $N2FB10COMUNKNOWNE*)0ull) goto label$855;
	TMP$2264$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$866;
	label$855:;
	TMP$2264$1 = 0ll;
	label$866:;
	if( TMP$2264$1 == 0ll) goto label$857;
	{
		fb$result$1 = (boolean)1ll;
		goto label$854;
		label$857:;
	}
	if( *(struct $N2FB10COMUNKNOWNE**)THIS$1 == (struct $N2FB10COMUNKNOWNE*)0ull) goto label$858;
	TMP$2265$1 = (int64)-(OTHER$1 == (void*)0ull);
	goto label$867;
	label$858:;
	TMP$2265$1 = -1ll;
	label$867:;
	if( TMP$2265$1 == 0ll) goto label$860;
	{
		fb$result$1 = (boolean)0ll;
		goto label$854;
		label$860:;
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
	if( A$1 == (void*)0ull) goto label$861;
	TMP$2266$1 = (int64)-(A$1 == B$1);
	goto label$868;
	label$861:;
	TMP$2266$1 = 0ll;
	label$868:;
	SAME$1 = (boolean)(TMP$2266$1 != 0ll);
	if( A$1 == (void*)0ull) goto label$863;
	{
		struct $N2FB10COMUNKNOWNE* vr$12 = _ZN2FB6HASUNKEPv( A$1 );
		struct $N2FB10COMUNKNOWNE* vr$13 = _ZN2FB6HASUNKEPv( A$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2267Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2267Ev*)((uint8*)*(void***)vr$13 + 16ll))( vr$12 );
		label$863:;
	}
	if( B$1 == (void*)0ull) goto label$865;
	{
		struct $N2FB10COMUNKNOWNE* vr$15 = _ZN2FB6HASUNKEPv( B$1 );
		struct $N2FB10COMUNKNOWNE* vr$16 = _ZN2FB6HASUNKEPv( B$1 );
		typedef uint32 (*_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2268Ev)( struct $N2FB10COMUNKNOWNE* );
		(*(_ZN6ComPtrIN2FB10COMUNKNOWNEE8tmp$2268Ev*)((uint8*)*(void***)vr$16 + 16ll))( vr$15 );
		label$865:;
	}
	fb$result$1 = SAME$1;
	goto label$854;
	label$854:;
	return fb$result$1;
}

static struct $6ComPtrIN2FB10COMUNKNOWNEE* _Z9ComCreateIN2FB10COMUNKNOWNEEPK5_GUIDjPv( struct $6ComPtrIN2FB10COMUNKNOWNEE* tmp$2269$1, struct $5_GUID* RCLSID$1, uint32 CTX$1, void* OUTER$1 )
{
	int64 TMP$2270$1;
	label$869:;
	struct $6ComPtrIN2FB10COMUNKNOWNEE R$1;
	_ZN6ComPtrIN2FB10COMUNKNOWNEEC1Ev( &R$1 );
	if( RCLSID$1 != (struct $5_GUID*)0ull) goto label$872;
	{
		_ZN6ComPtrIN2FB10COMUNKNOWNEEC1ERS2_( tmp$2269$1, &R$1 );
		_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &R$1 );
		goto label$870;
		label$872:;
	}
	struct $6IidTagIN2FB10COMUNKNOWNEE TAG$1;
	__builtin_memset( &TAG$1, 0, 4ll );
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	struct $5_GUID* vr$5 = _Z5IIDOF6IidTagIN2FB10COMUNKNOWNEE( TAG$1 );
	int32 vr$6 = CoCreateInstance( (struct $5_GUID*)RCLSID$1, (struct $9IUnknown_*)OUTER$1, CTX$1, (struct $5_GUID*)vr$5, &OUT_$1 );
	if( (int64)vr$6 < 0ll) goto label$873;
	TMP$2270$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$876;
	label$873:;
	TMP$2270$1 = 0ll;
	label$876:;
	if( TMP$2270$1 == 0ll) goto label$875;
	{
		_ZN6ComPtrIN2FB10COMUNKNOWNEE6ATTACHEPS1_( &R$1, (struct $N2FB10COMUNKNOWNE*)OUT_$1 );
	}
	label$875:;
	label$874:;
	_ZN6ComPtrIN2FB10COMUNKNOWNEEC1ERS2_( tmp$2269$1, &R$1 );
	_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &R$1 );
	goto label$870;
	_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &R$1 );
	label$870:;
	return tmp$2269$1;
}

static struct $6ComPtrIN2FB10COMUNKNOWNEE* _Z19ComCreateFromProgIDIN2FB10COMUNKNOWNEERKwjPv( struct $6ComPtrIN2FB10COMUNKNOWNEE* tmp$2271$1, uint16* PROGID$1, uint32 CTX$1, void* OUTER$1 )
{
	int64 TMP$2272$1;
	label$877:;
	struct $6ComPtrIN2FB10COMUNKNOWNEE R$1;
	_ZN6ComPtrIN2FB10COMUNKNOWNEEC1Ev( &R$1 );
	struct $5_GUID CLSID_$1;
	__builtin_memset( &CLSID_$1, 0, 16ll );
	int32 vr$3 = CLSIDFromProgID( PROGID$1, &CLSID_$1 );
	if( (int64)vr$3 >= 0ll) goto label$880;
	{
		_ZN6ComPtrIN2FB10COMUNKNOWNEEC1ERS2_( tmp$2271$1, &R$1 );
		_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &R$1 );
		goto label$878;
		label$880:;
	}
	struct $6IidTagIN2FB10COMUNKNOWNEE TAG$1;
	__builtin_memset( &TAG$1, 0, 4ll );
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	struct $5_GUID* vr$9 = _Z5IIDOF6IidTagIN2FB10COMUNKNOWNEE( TAG$1 );
	int32 vr$11 = CoCreateInstance( (struct $5_GUID*)&CLSID_$1, (struct $9IUnknown_*)OUTER$1, CTX$1, (struct $5_GUID*)vr$9, &OUT_$1 );
	if( (int64)vr$11 < 0ll) goto label$881;
	TMP$2272$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$884;
	label$881:;
	TMP$2272$1 = 0ll;
	label$884:;
	if( TMP$2272$1 == 0ll) goto label$883;
	{
		_ZN6ComPtrIN2FB10COMUNKNOWNEE6ATTACHEPS1_( &R$1, (struct $N2FB10COMUNKNOWNE*)OUT_$1 );
	}
	label$883:;
	label$882:;
	_ZN6ComPtrIN2FB10COMUNKNOWNEEC1ERS2_( tmp$2271$1, &R$1 );
	_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &R$1 );
	goto label$878;
	_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &R$1 );
	label$878:;
	return tmp$2271$1;
}

static int32 _Z5ComQIIN2FB10COMUNKNOWNEEPvPK5_GUIDR6ComPtrIN2FB10COMUNKNOWNEE( void* SRC$1, struct $5_GUID* IID$1, struct $6ComPtrIN2FB10COMUNKNOWNEE* DST$1 )
{
	int64 TMP$2273$1;
	int64 TMP$2275$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$885:;
	_ZN6ComPtrIN2FB10COMUNKNOWNEE7RELEASEEv( DST$1 );
	if( SRC$1 == (void*)0ull) goto label$887;
	TMP$2273$1 = (int64)-(IID$1 == (struct $5_GUID*)0ull);
	goto label$893;
	label$887:;
	TMP$2273$1 = -1ll;
	label$893:;
	if( TMP$2273$1 == 0ll) goto label$889;
	{
		fb$result$1 = -2147467261;
		goto label$886;
		label$889:;
	}
	void* OUT_$1;
	OUT_$1 = (void*)0ull;
	int32 HR$1;
	struct $N2FB10COMUNKNOWNE* vr$3 = _ZN2FB6HASUNKEPv( SRC$1 );
	struct $N2FB10COMUNKNOWNE* vr$5 = _ZN2FB6HASUNKEPv( SRC$1 );
	typedef int32 (*_Z8tmp$2274PK5_GUIDPPv)( struct $N2FB10COMUNKNOWNE*, struct $5_GUID*, void** );
	int32 vr$4 = (*(_Z8tmp$2274PK5_GUIDPPv*)*(void***)vr$5)( vr$3, IID$1, &OUT_$1 );
	HR$1 = vr$4;
	if( (int64)HR$1 < 0ll) goto label$890;
	TMP$2275$1 = (int64)-(OUT_$1 != (void*)0ull);
	goto label$894;
	label$890:;
	TMP$2275$1 = 0ll;
	label$894:;
	if( TMP$2275$1 == 0ll) goto label$892;
	{
		_ZN6ComPtrIN2FB10COMUNKNOWNEE6ATTACHEPS1_( DST$1, (struct $N2FB10COMUNKNOWNE*)OUT_$1 );
	}
	label$892:;
	label$891:;
	fb$result$1 = HR$1;
	goto label$886;
	label$886:;
	return fb$result$1;
}

__attribute__(( constructor )) static void fb_ctor__comptrzqi( void )
{
	label$0:;
	*(void**)&G_VTBLA$ = (void*)&OBJQI;
	*(void**)((uint8*)&G_VTBLA$ + 8ll) = (void*)&OBJADDREF;
	*(void**)((uint8*)&G_VTBLA$ + 16ll) = (void*)&OBJRELEASE;
	*(void**)((uint8*)&G_VTBLA$ + 24ll) = (void*)&OBJPOKEA;
	*(void**)&G_VTBLB$ = (void*)&SUBQI;
	*(void**)((uint8*)&G_VTBLB$ + 8ll) = (void*)&SUBADDREF;
	*(void**)((uint8*)&G_VTBLB$ + 16ll) = (void*)&SUBRELEASE;
	*(void**)((uint8*)&G_VTBLB$ + 24ll) = (void*)&SUBPOKEB;
	{
		struct $6IidTagI6IFAKEAE TAGA$1;
		__builtin_memset( &TAGA$1, 0, 4ll );
		struct $6IidTagI6IFAKEBE TAGB$1;
		__builtin_memset( &TAGB$1, 0, 4ll );
		struct $5_GUID* vr$2 = _Z5IIDOF6IidTagI6IFAKEAE( TAGA$1 );
		if( vr$2 == &IID_FAKEA$) goto label$180;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 175ll, (char*)"__FB_MODLEVELPROC__", (char*)"IidOf( tagA ) = @IID_FakeA" );
			label$180:;
		}
		struct $5_GUID* vr$3 = _Z5IIDOF6IidTagI6IFAKEBE( TAGB$1 );
		if( vr$3 == &IID_FAKEB$) goto label$182;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 176ll, (char*)"__FB_MODLEVELPROC__", (char*)"IidOf( tagB ) = @IID_FakeB" );
			label$182:;
		}
		struct $5_GUID* vr$4 = _Z5IIDOF6IidTagI6IFAKEAE( TAGA$1 );
		int32 vr$5 = memcmp( (void*)vr$4, (void*)&IID_FAKEA$, 16ull );
		if( (int64)vr$5 == 0ll) goto label$184;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 177ll, (char*)"__FB_MODLEVELPROC__", (char*)"(memcmp(IidOf( tagA ), @IID_FakeA, sizeof(GUID)) = 0) <> 0" );
			label$184:;
		}
		struct $5_GUID* vr$7 = _Z5IIDOF6IidTagI6IFAKEAE( TAGA$1 );
		int32 vr$8 = memcmp( (void*)vr$7, (void*)&IID_FAKEB$, 16ull );
		if( (int64)vr$8 != 0ll) goto label$186;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 178ll, (char*)"__FB_MODLEVELPROC__", (char*)"(memcmp(IidOf( tagA ), @IID_FakeB, sizeof(GUID)) = 0) = 0" );
			label$186:;
		}
		struct $6IidTagIN2FB10COMUNKNOWNEE TAGU$1;
		__builtin_memset( &TAGU$1, 0, 4ll );
		struct $5_GUID IIDUNKNOWN$1;
		*(uint32*)&IIDUNKNOWN$1 = 0u;
		*(uint16*)((uint8*)&IIDUNKNOWN$1 + 4ll) = (uint16)0u;
		*(uint16*)((uint8*)&IIDUNKNOWN$1 + 6ll) = (uint16)0u;
		*(uint8*)((uint8*)&IIDUNKNOWN$1 + 8ll) = (uint8)192u;
		*(uint8*)((uint8*)&IIDUNKNOWN$1 + 9ll) = (uint8)0u;
		*(uint8*)((uint8*)&IIDUNKNOWN$1 + 10ll) = (uint8)0u;
		*(uint8*)((uint8*)&IIDUNKNOWN$1 + 11ll) = (uint8)0u;
		*(uint8*)((uint8*)&IIDUNKNOWN$1 + 12ll) = (uint8)0u;
		*(uint8*)((uint8*)&IIDUNKNOWN$1 + 13ll) = (uint8)0u;
		*(uint8*)((uint8*)&IIDUNKNOWN$1 + 14ll) = (uint8)0u;
		*(uint8*)((uint8*)&IIDUNKNOWN$1 + 15ll) = (uint8)70u;
		struct $5_GUID* vr$12 = _Z5IIDOF6IidTagIN2FB10COMUNKNOWNEE( TAGU$1 );
		int32 vr$13 = memcmp( (void*)vr$12, (void*)&IIDUNKNOWN$1, 16ull );
		if( (int64)vr$13 == 0ll) goto label$188;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 184ll, (char*)"__FB_MODLEVELPROC__", (char*)"(memcmp(IidOf( tagU ), @iidUnknown, sizeof(GUID)) = 0) <> 0" );
			label$188:;
		}
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI6IFAKEAE SRC$1;
		_ZN6ComPtrI6IFAKEAEC1Ev( &SRC$1 );
		struct $6IFAKEA* vr$16 = NEWOBJ(  );
		_ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( &SRC$1, vr$16 );
		struct $6ComPtrI8INOTRAITE NT$1;
		_ZN6ComPtrI8INOTRAITEC1Ev( &NT$1 );
		struct $6IFAKEA* vr$21 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$22 = _Z5ComQII8INOTRAITEPvPK5_GUIDR6ComPtrI8INOTRAITE( (void*)vr$21, (struct $5_GUID*)&IID_FAKEA$, &NT$1 );
		if( (int64)vr$22 == 0ll) goto label$190;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 196ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQI( src.Get( ), @IID_FakeA, nt ) = S_OK" );
			label$190:;
		}
		boolean vr$25 = _ZN6ComPtrI8INOTRAITE6ISNULLEv( &NT$1 );
		if( (int64)-(boolean)(vr$25 == (boolean)0ll) != 0ll) goto label$192;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 197ll, (char*)"__FB_MODLEVELPROC__", (char*)"nt.IsNull( ) = FALSE" );
			label$192:;
		}
		struct $6IFAKEA* vr$29 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$30 = REFSOF( (void*)vr$29 );
		if( (int64)vr$30 == 2ll) goto label$194;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 198ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
			label$194:;
		}
		_ZN6ComPtrI8INOTRAITE7RELEASEEv( &NT$1 );
		struct $6IFAKEA* vr$34 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$35 = REFSOF( (void*)vr$34 );
		if( (int64)vr$35 == 1ll) goto label$196;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 200ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 1" );
			label$196:;
		}
		struct $6ComPtrI8INOTRAITE NT2$1;
		_ZN6ComPtrI8INOTRAITEC1Ev( &NT2$1 );
		int32 vr$39 = _Z5ComQII8INOTRAITEPvPK5_GUIDR6ComPtrI8INOTRAITE( (void*)0ull, (struct $5_GUID*)&IID_FAKEA$, &NT2$1 );
		if( (int64)vr$39 == -2147467261ll) goto label$198;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 204ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQI( cast( any ptr, 0 ), @IID_FakeA, nt2 ) = cast(HRESULT, &h80004003)" );
			label$198:;
		}
		boolean vr$42 = _ZN6ComPtrI8INOTRAITE6ISNULLEv( &NT2$1 );
		if( (int64)-(boolean)(vr$42 == (boolean)1ll) != 0ll) goto label$200;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 205ll, (char*)"__FB_MODLEVELPROC__", (char*)"nt2.IsNull( ) = TRUE" );
			label$200:;
		}
		struct $6IFAKEA* vr$47 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$48 = _Z5ComQII8INOTRAITEPvPK5_GUIDR6ComPtrI8INOTRAITE( (void*)vr$47, (struct $5_GUID*)0ull, &NT2$1 );
		if( (int64)vr$48 == -2147467261ll) goto label$202;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 206ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQI( src.Get( ), 0, nt2 ) = cast(HRESULT, &h80004003)" );
			label$202:;
		}
		boolean vr$51 = _ZN6ComPtrI8INOTRAITE6ISNULLEv( &NT2$1 );
		if( (int64)-(boolean)(vr$51 == (boolean)1ll) != 0ll) goto label$204;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 207ll, (char*)"__FB_MODLEVELPROC__", (char*)"nt2.IsNull( ) = TRUE" );
			label$204:;
		}
		_ZN6ComPtrI8INOTRAITED1Ev( &NT2$1 );
		_ZN6ComPtrI8INOTRAITED1Ev( &NT$1 );
		_ZN6ComPtrI6IFAKEAED1Ev( &SRC$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$352;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 209ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$352:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI6IFAKEAE SRC$1;
		_ZN6ComPtrI6IFAKEAEC1Ev( &SRC$1 );
		struct $6IFAKEA* vr$59 = NEWOBJ(  );
		_ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( &SRC$1, vr$59 );
		struct $6ComPtrI6IFAKEBE VIAEXPLICIT$1;
		_ZN6ComPtrI6IFAKEBEC1Ev( &VIAEXPLICIT$1 );
		struct $6ComPtrI6IFAKEBE VIATRAIT$1;
		_ZN6ComPtrI6IFAKEBEC1Ev( &VIATRAIT$1 );
		struct $6IFAKEA* vr$65 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$66 = _Z5ComQII6IFAKEBEPvPK5_GUIDR6ComPtrI6IFAKEBE( (void*)vr$65, (struct $5_GUID*)&IID_FAKEB$, &VIAEXPLICIT$1 );
		if( (int64)vr$66 == 0ll) goto label$354;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 219ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQI( src.Get( ), @IID_FakeB, viaExplicit ) = S_OK" );
			label$354:;
		}
		struct $6IFAKEA* vr$70 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$71 = _Z7ComQIAsI6IFAKEBEPvR6ComPtrI6IFAKEBE( (void*)vr$70, &VIATRAIT$1 );
		if( (int64)vr$71 == 0ll) goto label$356;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 220ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQIAs( src.Get( ), viaTrait ) = S_OK" );
			label$356:;
		}
		struct $6IFAKEB* vr$74 = _ZN6ComPtrI6IFAKEBE3GETEv( &VIAEXPLICIT$1 );
		struct $6IFAKEB* vr$76 = _ZN6ComPtrI6IFAKEBE3GETEv( &VIATRAIT$1 );
		if( vr$74 == vr$76) goto label$358;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 221ll, (char*)"__FB_MODLEVELPROC__", (char*)"viaExplicit.Get( ) = viaTrait.Get( )" );
			label$358:;
		}
		struct $6IFAKEA* vr$78 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$79 = REFSOF( (void*)vr$78 );
		if( (int64)vr$79 == 3ll) goto label$360;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 222ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 3" );
			label$360:;
		}
		_ZN6ComPtrI6IFAKEBED1Ev( &VIATRAIT$1 );
		_ZN6ComPtrI6IFAKEBED1Ev( &VIAEXPLICIT$1 );
		_ZN6ComPtrI6IFAKEAED1Ev( &SRC$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$448;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 224ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$448:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI6IFAKEAE SRC$1;
		_ZN6ComPtrI6IFAKEAEC1Ev( &SRC$1 );
		struct $6IFAKEA* vr$86 = NEWOBJ(  );
		_ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( &SRC$1, vr$86 );
		struct $6ComPtrI12IUNSUPPORTEDE U$1;
		_ZN6ComPtrI12IUNSUPPORTEDEC1Ev( &U$1 );
		struct $6IFAKEA* vr$91 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$92 = _Z7ComQIAsI12IUNSUPPORTEDEPvR6ComPtrI12IUNSUPPORTEDE( (void*)vr$91, &U$1 );
		if( (int64)vr$92 == -2147467262ll) goto label$450;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 234ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQIAs( src.Get( ), u ) = cast(HRESULT, &h80004002)" );
			label$450:;
		}
		boolean vr$95 = _ZN6ComPtrI12IUNSUPPORTEDE6ISNULLEv( &U$1 );
		if( (int64)-(boolean)(vr$95 == (boolean)1ll) != 0ll) goto label$452;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 235ll, (char*)"__FB_MODLEVELPROC__", (char*)"u.IsNull( ) = TRUE" );
			label$452:;
		}
		struct $6IFAKEA* vr$99 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$100 = REFSOF( (void*)vr$99 );
		if( (int64)vr$100 == 1ll) goto label$454;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 236ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 1" );
			label$454:;
		}
		struct $6ComPtrI6IFAKEBE HELD$1;
		_ZN6ComPtrI6IFAKEBEC1Ev( &HELD$1 );
		struct $6IFAKEA* vr$105 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$106 = _Z7ComQIAsI6IFAKEBEPvR6ComPtrI6IFAKEBE( (void*)vr$105, &HELD$1 );
		if( (int64)vr$106 == 0ll) goto label$456;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 240ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQIAs( src.Get( ), held ) = S_OK" );
			label$456:;
		}
		struct $6IFAKEA* vr$109 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$110 = REFSOF( (void*)vr$109 );
		if( (int64)vr$110 == 2ll) goto label$458;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 241ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
			label$458:;
		}
		struct $6ComPtrI6IFAKEBE REUSED$1;
		_ZN6ComPtrI6IFAKEBEC1Ev( &REUSED$1 );
		struct $6IFAKEA* vr$115 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$116 = _Z7ComQIAsI6IFAKEBEPvR6ComPtrI6IFAKEBE( (void*)vr$115, &REUSED$1 );
		if( (int64)vr$116 == 0ll) goto label$460;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 243ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQIAs( src.Get( ), reused ) = S_OK" );
			label$460:;
		}
		struct $6IFAKEA* vr$119 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$120 = REFSOF( (void*)vr$119 );
		if( (int64)vr$120 == 3ll) goto label$462;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 244ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 3" );
			label$462:;
		}
		struct $6IFAKEA* vr$124 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$125 = _Z5ComQII6IFAKEBEPvPK5_GUIDR6ComPtrI6IFAKEBE( (void*)vr$124, (struct $5_GUID*)&IID_UNSUP$, &REUSED$1 );
		if( (int64)vr$125 == -2147467262ll) goto label$464;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 245ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQI( src.Get( ), @IID_Unsup, reused ) = cast(HRESULT, &h80004002)" );
			label$464:;
		}
		boolean vr$128 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( &REUSED$1 );
		if( (int64)-(boolean)(vr$128 == (boolean)1ll) != 0ll) goto label$466;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 246ll, (char*)"__FB_MODLEVELPROC__", (char*)"reused.IsNull( ) = TRUE" );
			label$466:;
		}
		struct $6IFAKEA* vr$132 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$133 = REFSOF( (void*)vr$132 );
		if( (int64)vr$133 == 2ll) goto label$468;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 247ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
			label$468:;
		}
		struct $6ComPtrI12IUNSUPPORTEDE PRELOADED$1;
		_ZN6ComPtrI12IUNSUPPORTEDEC1Ev( &PRELOADED$1 );
		struct $6IFAKEA* vr$138 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$139 = _Z5ComQII12IUNSUPPORTEDEPvPK5_GUIDR6ComPtrI12IUNSUPPORTEDE( (void*)vr$138, (struct $5_GUID*)&IID_FAKEA$, &PRELOADED$1 );
		if( (int64)vr$139 == 0ll) goto label$470;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 254ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQI( src.Get( ), @IID_FakeA, preloaded ) = S_OK" );
			label$470:;
		}
		boolean vr$142 = _ZN6ComPtrI12IUNSUPPORTEDE6ISNULLEv( &PRELOADED$1 );
		if( (int64)-(boolean)(vr$142 == (boolean)0ll) != 0ll) goto label$472;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 255ll, (char*)"__FB_MODLEVELPROC__", (char*)"preloaded.IsNull( ) = FALSE" );
			label$472:;
		}
		struct $6IFAKEA* vr$146 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$147 = REFSOF( (void*)vr$146 );
		if( (int64)vr$147 == 3ll) goto label$474;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 256ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 3" );
			label$474:;
		}
		struct $6IFAKEA* vr$151 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$152 = _Z7ComQIAsI12IUNSUPPORTEDEPvR6ComPtrI12IUNSUPPORTEDE( (void*)vr$151, &PRELOADED$1 );
		if( (int64)vr$152 == -2147467262ll) goto label$476;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 257ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQIAs( src.Get( ), preloaded ) = cast(HRESULT, &h80004002)" );
			label$476:;
		}
		boolean vr$155 = _ZN6ComPtrI12IUNSUPPORTEDE6ISNULLEv( &PRELOADED$1 );
		if( (int64)-(boolean)(vr$155 == (boolean)1ll) != 0ll) goto label$478;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 258ll, (char*)"__FB_MODLEVELPROC__", (char*)"preloaded.IsNull( ) = TRUE" );
			label$478:;
		}
		struct $6IFAKEA* vr$159 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$160 = REFSOF( (void*)vr$159 );
		if( (int64)vr$160 == 2ll) goto label$480;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 259ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
			label$480:;
		}
		_ZN6ComPtrI12IUNSUPPORTEDED1Ev( &PRELOADED$1 );
		_ZN6ComPtrI6IFAKEBED1Ev( &REUSED$1 );
		_ZN6ComPtrI6IFAKEBED1Ev( &HELD$1 );
		_ZN6ComPtrI12IUNSUPPORTEDED1Ev( &U$1 );
		_ZN6ComPtrI6IFAKEAED1Ev( &SRC$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$568;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 261ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$568:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI6IFAKEAE SRC$1;
		_ZN6ComPtrI6IFAKEAEC1Ev( &SRC$1 );
		struct $6IFAKEA* vr$169 = NEWOBJ(  );
		_ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( &SRC$1, vr$169 );
		{
			struct $8ComQIPtrI6IFAKEBE B$2;
			struct $6IFAKEA* vr$172 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
			_ZN8ComQIPtrI6IFAKEBEC1EPv( &B$2, (void*)vr$172 );
			boolean vr$175 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( (struct $6ComPtrI6IFAKEBE*)&B$2 );
			if( (int64)-(boolean)(vr$175 == (boolean)0ll) != 0ll) goto label$576;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 272ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.IsNull( ) = FALSE" );
				label$576:;
			}
			struct $6IFAKEA* vr$179 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
			int32 vr$180 = REFSOF( (void*)vr$179 );
			if( (int64)vr$180 == 2ll) goto label$578;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 273ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
				label$578:;
			}
			struct $6IFAKEB* vr$183 = _ZptR8ComQIPtrI6IFAKEBE( &B$2 );
			struct $6IFAKEB* vr$186 = _ZptR8ComQIPtrI6IFAKEBE( &B$2 );
			int32 vr$184 = (*(tmp$2187*)((uint8*)*(void***)vr$186 + 24ll))( vr$183 );
			if( (int64)vr$184 == 1ll) goto label$580;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 274ll, (char*)"__FB_MODLEVELPROC__", (char*)"b->PokeB( ) = 1" );
				label$580:;
			}
			struct $8ComQIPtrI12IUNSUPPORTEDE U$2;
			struct $6IFAKEA* vr$190 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
			_ZN8ComQIPtrI12IUNSUPPORTEDEC1EPv( &U$2, (void*)vr$190 );
			boolean vr$193 = _ZN6ComPtrI12IUNSUPPORTEDE6ISNULLEv( (struct $6ComPtrI12IUNSUPPORTEDE*)&U$2 );
			if( (int64)-(boolean)(vr$193 == (boolean)1ll) != 0ll) goto label$588;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 277ll, (char*)"__FB_MODLEVELPROC__", (char*)"u.IsNull( ) = TRUE" );
				label$588:;
			}
			struct $6IFAKEA* vr$197 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
			int32 vr$198 = REFSOF( (void*)vr$197 );
			if( (int64)vr$198 == 2ll) goto label$590;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 278ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
				label$590:;
			}
			struct $8ComQIPtrI6IFAKEBE EMPTY_$2;
			_ZN8ComQIPtrI6IFAKEBEC1EPv( &EMPTY_$2, (void*)0ull );
			boolean vr$202 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( (struct $6ComPtrI6IFAKEBE*)&EMPTY_$2 );
			if( (int64)-(boolean)(vr$202 == (boolean)1ll) != 0ll) goto label$592;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 281ll, (char*)"__FB_MODLEVELPROC__", (char*)"empty_.IsNull( ) = TRUE" );
				label$592:;
			}
			struct $8ComQIPtrI6IFAKEBE COPY_$2;
			_ZN8ComQIPtrI6IFAKEBEC1ERS1_( &COPY_$2, &B$2 );
			struct $6IFAKEB* vr$208 = _ZN6ComPtrI6IFAKEBE3GETEv( (struct $6ComPtrI6IFAKEBE*)&COPY_$2 );
			struct $6IFAKEB* vr$210 = _ZN6ComPtrI6IFAKEBE3GETEv( (struct $6ComPtrI6IFAKEBE*)&B$2 );
			if( vr$208 == vr$210) goto label$594;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 284ll, (char*)"__FB_MODLEVELPROC__", (char*)"copy_.Get( ) = b.Get( )" );
				label$594:;
			}
			struct $6IFAKEA* vr$212 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
			int32 vr$213 = REFSOF( (void*)vr$212 );
			if( (int64)vr$213 == 3ll) goto label$596;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 285ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 3" );
				label$596:;
			}
			_ZN8ComQIPtrI6IFAKEBED1Ev( &COPY_$2 );
			_ZN8ComQIPtrI6IFAKEBED1Ev( &EMPTY_$2 );
			_ZN8ComQIPtrI12IUNSUPPORTEDED1Ev( &U$2 );
			_ZN8ComQIPtrI6IFAKEBED1Ev( &B$2 );
		}
		struct $6IFAKEA* vr$220 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$221 = REFSOF( (void*)vr$220 );
		if( (int64)vr$221 == 1ll) goto label$598;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 287ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 1" );
			label$598:;
		}
		_ZN6ComPtrI6IFAKEAED1Ev( &SRC$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$658;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 289ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$658:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI6IFAKEAE SRC$1;
		_ZN6ComPtrI6IFAKEAEC1Ev( &SRC$1 );
		struct $6IFAKEA* vr$226 = NEWOBJ(  );
		_ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( &SRC$1, vr$226 );
		struct $8ComQIPtrI6IFAKEBE B$1;
		_ZN8ComQIPtrI6IFAKEBEC1Ev( &B$1 );
		struct $6IFAKEA* vr$230 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		_ZN8ComQIPtrI6IFAKEBEaSEPv( &B$1, (void*)vr$230 );
		boolean vr$233 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		if( (int64)-(boolean)(vr$233 == (boolean)0ll) != 0ll) goto label$660;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 300ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.IsNull( ) = FALSE" );
			label$660:;
		}
		struct $6IFAKEA* vr$237 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$238 = REFSOF( (void*)vr$237 );
		if( (int64)vr$238 == 2ll) goto label$662;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 301ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
			label$662:;
		}
		struct $6IFAKEA* vr$241 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		_ZN8ComQIPtrI6IFAKEBEaSEPv( &B$1, (void*)vr$241 );
		boolean vr$244 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		if( (int64)-(boolean)(vr$244 == (boolean)0ll) != 0ll) goto label$664;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 304ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.IsNull( ) = FALSE" );
			label$664:;
		}
		struct $6IFAKEA* vr$248 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$249 = REFSOF( (void*)vr$248 );
		if( (int64)vr$249 == 2ll) goto label$666;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 305ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
			label$666:;
		}
		struct $8ComQIPtrI6IFAKEBE C$1;
		_ZN8ComQIPtrI6IFAKEBEC1Ev( &C$1 );
		_ZN8ComQIPtrI6IFAKEBEaSERS1_( &C$1, &B$1 );
		struct $6IFAKEB* vr$255 = _ZN6ComPtrI6IFAKEBE3GETEv( (struct $6ComPtrI6IFAKEBE*)&C$1 );
		struct $6IFAKEB* vr$257 = _ZN6ComPtrI6IFAKEBE3GETEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		if( vr$255 == vr$257) goto label$668;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 309ll, (char*)"__FB_MODLEVELPROC__", (char*)"c.Get( ) = b.Get( )" );
			label$668:;
		}
		struct $6IFAKEA* vr$259 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$260 = REFSOF( (void*)vr$259 );
		if( (int64)vr$260 == 3ll) goto label$670;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 310ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 3" );
			label$670:;
		}
		_ZN8ComQIPtrI6IFAKEBEaSERS1_( &C$1, &C$1 );
		struct $6IFAKEA* vr$265 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$266 = REFSOF( (void*)vr$265 );
		if( (int64)vr$266 == 3ll) goto label$672;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 312ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 3" );
			label$672:;
		}
		struct $8ComQIPtrI12IUNSUPPORTEDE U$1;
		_ZN8ComQIPtrI12IUNSUPPORTEDEC1Ev( &U$1 );
		struct $6IFAKEA* vr$270 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		_ZN8ComQIPtrI12IUNSUPPORTEDEaSEPv( &U$1, (void*)vr$270 );
		boolean vr$273 = _ZN6ComPtrI12IUNSUPPORTEDE6ISNULLEv( (struct $6ComPtrI12IUNSUPPORTEDE*)&U$1 );
		if( (int64)-(boolean)(vr$273 == (boolean)1ll) != 0ll) goto label$674;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 317ll, (char*)"__FB_MODLEVELPROC__", (char*)"u.IsNull( ) = TRUE" );
			label$674:;
		}
		_ZN8ComQIPtrI6IFAKEBEaSEPv( &B$1, (void*)0ull );
		boolean vr$278 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		if( (int64)-(boolean)(vr$278 == (boolean)1ll) != 0ll) goto label$676;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 321ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.IsNull( ) = TRUE" );
			label$676:;
		}
		struct $6IFAKEA* vr$282 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$283 = REFSOF( (void*)vr$282 );
		if( (int64)vr$283 == 2ll) goto label$678;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 322ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
			label$678:;
		}
		_ZN8ComQIPtrI12IUNSUPPORTEDED1Ev( &U$1 );
		_ZN8ComQIPtrI6IFAKEBED1Ev( &C$1 );
		_ZN8ComQIPtrI6IFAKEBED1Ev( &B$1 );
		_ZN6ComPtrI6IFAKEAED1Ev( &SRC$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$680;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 324ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$680:;
	}
	G_DESTROYED$ = 0;
	{
		void* RAWA$1;
		__builtin_memset( &RAWA$1, 0, 8ll );
		struct $8ComQIPtrI6IFAKEBE SOLO$1;
		_ZN8ComQIPtrI6IFAKEBEC1Ev( &SOLO$1 );
		{
			struct $6ComPtrI6IFAKEAE TMP$2;
			_ZN6ComPtrI6IFAKEAEC1Ev( &TMP$2 );
			struct $6IFAKEA* vr$293 = NEWOBJ(  );
			_ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( &TMP$2, vr$293 );
			struct $6IFAKEA* vr$296 = _ZN6ComPtrI6IFAKEAE3GETEv( &TMP$2 );
			RAWA$1 = (void*)vr$296;
			struct $6IFAKEA* vr$298 = _ZN6ComPtrI6IFAKEAE3GETEv( &TMP$2 );
			_ZN8ComQIPtrI6IFAKEBEaSEPv( &SOLO$1, (void*)vr$298 );
			boolean vr$301 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( (struct $6ComPtrI6IFAKEBE*)&SOLO$1 );
			if( (int64)-(boolean)(vr$301 == (boolean)0ll) != 0ll) goto label$682;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 347ll, (char*)"__FB_MODLEVELPROC__", (char*)"solo.IsNull( ) = FALSE" );
				label$682:;
			}
			_ZN6ComPtrI6IFAKEAED1Ev( &TMP$2 );
		}
		if( (int64)G_DESTROYED$ == 0ll) goto label$684;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 349ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 0" );
			label$684:;
		}
		int32 vr$306 = REFSOF( RAWA$1 );
		if( (int64)vr$306 == 1ll) goto label$686;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 350ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( rawA ) = 1" );
			label$686:;
		}
		struct $6IFAKEB* vr$309 = _ZN6ComPtrI6IFAKEBE3GETEv( (struct $6ComPtrI6IFAKEBE*)&SOLO$1 );
		if( (void*)vr$309 != RAWA$1) goto label$688;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 351ll, (char*)"__FB_MODLEVELPROC__", (char*)"cast( any ptr, solo.Get( ) ) <> rawA" );
			label$688:;
		}
		struct $6IFAKEB* vr$311 = _ZN6ComPtrI6IFAKEBE3GETEv( (struct $6ComPtrI6IFAKEBE*)&SOLO$1 );
		_ZN8ComQIPtrI6IFAKEBEaSEPv( &SOLO$1, (void*)vr$311 );
		if( (int64)G_DESTROYED$ == 0ll) goto label$690;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 354ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 0" );
			label$690:;
		}
		boolean vr$315 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( (struct $6ComPtrI6IFAKEBE*)&SOLO$1 );
		if( (int64)-(boolean)(vr$315 == (boolean)0ll) != 0ll) goto label$692;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 355ll, (char*)"__FB_MODLEVELPROC__", (char*)"solo.IsNull( ) = FALSE" );
			label$692:;
		}
		int32 vr$318 = REFSOF( RAWA$1 );
		if( (int64)vr$318 == 1ll) goto label$694;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 356ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( rawA ) = 1" );
			label$694:;
		}
		struct $6IFAKEB* vr$321 = _ZptR8ComQIPtrI6IFAKEBE( &SOLO$1 );
		struct $6IFAKEB* vr$324 = _ZptR8ComQIPtrI6IFAKEBE( &SOLO$1 );
		int32 vr$322 = (*(tmp$2187*)((uint8*)*(void***)vr$324 + 24ll))( vr$321 );
		if( (int64)vr$322 > 0ll) goto label$696;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 357ll, (char*)"__FB_MODLEVELPROC__", (char*)"solo->PokeB( ) > 0" );
			label$696:;
		}
		_ZN8ComQIPtrI6IFAKEBED1Ev( &SOLO$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$698;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 359ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$698:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI6IFAKEAE SRC$1;
		_ZN6ComPtrI6IFAKEAEC1Ev( &SRC$1 );
		struct $6IFAKEA* vr$330 = NEWOBJ(  );
		_ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( &SRC$1, vr$330 );
		struct $8ComQIPtrI6IFAKEBE B$1;
		struct $6IFAKEA* vr$333 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		_ZN8ComQIPtrI6IFAKEBEC1EPv( &B$1, (void*)vr$333 );
		struct $6IFAKEB* vr$336 = _ZN6ComPtrI6IFAKEBE3GETEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		if( vr$336 != (struct $6IFAKEB*)0ull) goto label$700;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 369ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.Get( ) <> 0" );
			label$700:;
		}
		struct $N2FB10COMUNKNOWNE* vr$338 = _ZN6ComPtrI6IFAKEBE7UNKNOWNEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		if( vr$338 != (struct $N2FB10COMUNKNOWNE*)0ull) goto label$702;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 370ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.Unknown( ) <> 0" );
			label$702:;
		}
		boolean vr$340 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		if( (int64)-(boolean)(vr$340 == (boolean)0ll) != 0ll) goto label$704;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 371ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.IsNull( ) = FALSE" );
			label$704:;
		}
		struct $6IFAKEB* vr$344 = _ZN6ComPtrI6IFAKEBE3REFEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		struct $6IFAKEB* vr$347 = _ZN6ComPtrI6IFAKEBE3REFEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		int32 vr$345 = (*(tmp$2187*)((uint8*)*(void***)vr$347 + 24ll))( vr$344 );
		if( (int64)vr$345 > 0ll) goto label$706;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 372ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.Ref( ).PokeB( ) > 0" );
			label$706:;
		}
		struct $6IFAKEB* vr$351 = _ZptR8ComQIPtrI6IFAKEBE( &B$1 );
		struct $6IFAKEB* vr$354 = _ZptR8ComQIPtrI6IFAKEBE( &B$1 );
		int32 vr$352 = (*(tmp$2187*)((uint8*)*(void***)vr$354 + 24ll))( vr$351 );
		if( (int64)vr$352 > 0ll) goto label$708;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 373ll, (char*)"__FB_MODLEVELPROC__", (char*)"b->PokeB( ) > 0" );
			label$708:;
		}
		struct $6IFAKEB* vr$358 = _ZdeR8ComQIPtrI6IFAKEBE( &B$1 );
		struct $6IFAKEB* vr$361 = _ZdeR8ComQIPtrI6IFAKEBE( &B$1 );
		int32 vr$359 = (*(tmp$2187*)((uint8*)*(void***)vr$361 + 24ll))( vr$358 );
		if( (int64)vr$359 > 0ll) goto label$710;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 374ll, (char*)"__FB_MODLEVELPROC__", (char*)"(*b).PokeB( ) > 0" );
			label$710:;
		}
		struct $6IFAKEA* vr$365 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		boolean vr$367 = _ZN6ComPtrI6IFAKEBE13ISEQUALOBJECTEPv( (struct $6ComPtrI6IFAKEBE*)&B$1, (void*)vr$365 );
		if( (int64)-(boolean)(vr$367 == (boolean)1ll) != 0ll) goto label$712;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 375ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.IsEqualObject( src.Get( ) ) = TRUE" );
			label$712:;
		}
		struct $6IFAKEB* OUT_$1;
		__builtin_memset( &OUT_$1, 0, 8ll );
		int32 vr$373 = _ZN6ComPtrI6IFAKEBE6COPYTOEPPS0_( (struct $6ComPtrI6IFAKEBE*)&B$1, &OUT_$1 );
		if( (int64)vr$373 == 0ll) goto label$714;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 378ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.CopyTo( @out_ ) = S_OK" );
			label$714:;
		}
		struct $6IFAKEA* vr$376 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$377 = REFSOF( (void*)vr$376 );
		if( (int64)vr$377 == 3ll) goto label$716;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 379ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 3" );
			label$716:;
		}
		(*(tmp$2217*)((uint8*)*(void***)OUT_$1 + 16ll))( (struct $N2FB10COMUNKNOWNE*)OUT_$1 );
		struct $6IFAKEB* DET$1;
		struct $6IFAKEB* vr$382 = _ZN6ComPtrI6IFAKEBE6DETACHEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		DET$1 = vr$382;
		boolean vr$384 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( (struct $6ComPtrI6IFAKEBE*)&B$1 );
		if( (int64)-(boolean)(vr$384 == (boolean)1ll) != 0ll) goto label$718;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 383ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.IsNull( ) = TRUE" );
			label$718:;
		}
		struct $6ComPtrI6IFAKEBE ADOPT$1;
		_ZN6ComPtrI6IFAKEBEC1Ev( &ADOPT$1 );
		_ZN6ComPtrI6IFAKEBE6ATTACHEPS0_( &ADOPT$1, DET$1 );
		struct $6IFAKEA* vr$390 = _ZN6ComPtrI6IFAKEAE3GETEv( &SRC$1 );
		int32 vr$391 = REFSOF( (void*)vr$390 );
		if( (int64)vr$391 == 2ll) goto label$720;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 386ll, (char*)"__FB_MODLEVELPROC__", (char*)"RefsOf( src.Get( ) ) = 2" );
			label$720:;
		}
		_ZN6ComPtrI6IFAKEBED1Ev( &ADOPT$1 );
		_ZN8ComQIPtrI6IFAKEBED1Ev( &B$1 );
		_ZN6ComPtrI6IFAKEAED1Ev( &SRC$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$724;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 388ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$724:;
	}
	G_DESTROYED$ = 0;
	{
		struct $6ComPtrI6IFAKEAE A$1;
		_ZN6ComPtrI6IFAKEAEC1Ev( &A$1 );
		struct $6IFAKEA* vr$398 = NEWOBJ(  );
		_ZN6ComPtrI6IFAKEAE6ATTACHEPS0_( &A$1, vr$398 );
		struct $6ComPtrI6IFAKEBE B$1;
		_ZN6ComPtrI6IFAKEBEC1Ev( &B$1 );
		int32 vr$403 = _Z7ComCastI6IFAKEA6IFAKEBER6ComPtrI6IFAKEAER6ComPtrI6IFAKEBE( &A$1, &B$1 );
		if( (int64)vr$403 == 0ll) goto label$726;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 399ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComCast( of IFakeA, IFakeB )( a, b ) = S_OK" );
			label$726:;
		}
		boolean vr$406 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( &B$1 );
		if( (int64)-(boolean)(vr$406 == (boolean)0ll) != 0ll) goto label$728;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 400ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.IsNull( ) = FALSE" );
			label$728:;
		}
		struct $6IFAKEB* vr$410 = _ZN6ComPtrI6IFAKEBE3GETEv( &B$1 );
		struct $6IFAKEA* vr$412 = _ZN6ComPtrI6IFAKEAE3GETEv( &A$1 );
		if( (void*)vr$410 != (void*)vr$412) goto label$730;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 405ll, (char*)"__FB_MODLEVELPROC__", (char*)"cast( any ptr, b.Get( ) ) <> cast( any ptr, a.Get( ) )" );
			label$730:;
		}
		struct $6IFAKEB* vr$414 = _ZptR6ComPtrI6IFAKEBE( &B$1 );
		struct $6IFAKEB* vr$417 = _ZptR6ComPtrI6IFAKEBE( &B$1 );
		int32 vr$415 = (*(tmp$2187*)((uint8*)*(void***)vr$417 + 24ll))( vr$414 );
		if( (int64)vr$415 == 1ll) goto label$732;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 406ll, (char*)"__FB_MODLEVELPROC__", (char*)"b->PokeB( ) = 1" );
			label$732:;
		}
		struct $6IFAKEA* vr$421 = _ZN6ComPtrI6IFAKEAE3GETEv( &A$1 );
		struct $3OBJ* vr$422 = ASOBJ( (void*)vr$421 );
		if( (int64)*(int32*)((uint8*)vr$422 + 16ll) == 1ll) goto label$734;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 407ll, (char*)"__FB_MODLEVELPROC__", (char*)"AsObj( a.Get( ) )->pokedB = 1" );
			label$734:;
		}
		struct $6IFAKEA* vr$425 = _ZN6ComPtrI6IFAKEAE3GETEv( &A$1 );
		struct $3OBJ* vr$426 = ASOBJ( (void*)vr$425 );
		if( (int64)*(int32*)((uint8*)vr$426 + 12ll) == 0ll) goto label$736;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 408ll, (char*)"__FB_MODLEVELPROC__", (char*)"AsObj( a.Get( ) )->pokedA = 0" );
			label$736:;
		}
		struct $6ComPtrI6IFAKEAE A2$1;
		_ZN6ComPtrI6IFAKEAEC1Ev( &A2$1 );
		int32 vr$431 = _Z7ComCastI6IFAKEB6IFAKEAER6ComPtrI6IFAKEBER6ComPtrI6IFAKEAE( &B$1, &A2$1 );
		if( (int64)vr$431 == 0ll) goto label$738;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 412ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComCast( of IFakeB, IFakeA )( b, a2 ) = S_OK" );
			label$738:;
		}
		struct $6IFAKEA* vr$434 = _ZN6ComPtrI6IFAKEAE3GETEv( &A2$1 );
		struct $6IFAKEA* vr$436 = _ZN6ComPtrI6IFAKEAE3GETEv( &A$1 );
		if( vr$434 == vr$436) goto label$740;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 413ll, (char*)"__FB_MODLEVELPROC__", (char*)"a2.Get( ) = a.Get( )" );
			label$740:;
		}
		struct $6IFAKEA* vr$438 = _ZptR6ComPtrI6IFAKEAE( &A2$1 );
		struct $6IFAKEA* vr$441 = _ZptR6ComPtrI6IFAKEAE( &A2$1 );
		int32 vr$439 = (*(tmp$2224*)((uint8*)*(void***)vr$441 + 24ll))( vr$438 );
		if( (int64)vr$439 == 1ll) goto label$742;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 414ll, (char*)"__FB_MODLEVELPROC__", (char*)"a2->PokeA( ) = 1" );
			label$742:;
		}
		struct $6IFAKEB* vr$445 = _ZN6ComPtrI6IFAKEBE3GETEv( &B$1 );
		boolean vr$447 = _ZN6ComPtrI6IFAKEAE13ISEQUALOBJECTEPv( &A$1, (void*)vr$445 );
		if( (int64)-(boolean)(vr$447 == (boolean)1ll) != 0ll) goto label$744;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 417ll, (char*)"__FB_MODLEVELPROC__", (char*)"a.IsEqualObject( b.Get( ) ) = TRUE" );
			label$744:;
		}
		struct $6IFAKEA* vr$451 = _ZN6ComPtrI6IFAKEAE3GETEv( &A$1 );
		boolean vr$453 = _ZN6ComPtrI6IFAKEBE13ISEQUALOBJECTEPv( &B$1, (void*)vr$451 );
		if( (int64)-(boolean)(vr$453 == (boolean)1ll) != 0ll) goto label$746;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 418ll, (char*)"__FB_MODLEVELPROC__", (char*)"b.IsEqualObject( a.Get( ) ) = TRUE" );
			label$746:;
		}
		struct $6ComPtrI12IUNSUPPORTEDE U$1;
		_ZN6ComPtrI12IUNSUPPORTEDEC1Ev( &U$1 );
		int32 vr$459 = _Z7ComCastI6IFAKEA12IUNSUPPORTEDER6ComPtrI6IFAKEAER6ComPtrI12IUNSUPPORTEDE( &A$1, &U$1 );
		if( (int64)vr$459 == -2147467262ll) goto label$748;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 422ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComCast( of IFakeA, IUnsupported )( a, u ) = cast(HRESULT, &h80004002)" );
			label$748:;
		}
		boolean vr$462 = _ZN6ComPtrI12IUNSUPPORTEDE6ISNULLEv( &U$1 );
		if( (int64)-(boolean)(vr$462 == (boolean)1ll) != 0ll) goto label$750;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 423ll, (char*)"__FB_MODLEVELPROC__", (char*)"u.IsNull( ) = TRUE" );
			label$750:;
		}
		struct $6ComPtrI6IFAKEAE NONE_$1;
		_ZN6ComPtrI6IFAKEAEC1Ev( &NONE_$1 );
		struct $6ComPtrI6IFAKEBE DST2$1;
		_ZN6ComPtrI6IFAKEBEC1Ev( &DST2$1 );
		int32 vr$469 = _Z7ComCastI6IFAKEA6IFAKEBER6ComPtrI6IFAKEAER6ComPtrI6IFAKEBE( &NONE_$1, &DST2$1 );
		if( (int64)vr$469 == -2147467261ll) goto label$752;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 428ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComCast( of IFakeA, IFakeB )( none_, dst2 ) = cast(HRESULT, &h80004003)" );
			label$752:;
		}
		boolean vr$472 = _ZN6ComPtrI6IFAKEBE6ISNULLEv( &DST2$1 );
		if( (int64)-(boolean)(vr$472 == (boolean)1ll) != 0ll) goto label$754;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 429ll, (char*)"__FB_MODLEVELPROC__", (char*)"dst2.IsNull( ) = TRUE" );
			label$754:;
		}
		_ZN6ComPtrI6IFAKEBED1Ev( &DST2$1 );
		_ZN6ComPtrI6IFAKEAED1Ev( &NONE_$1 );
		_ZN6ComPtrI12IUNSUPPORTEDED1Ev( &U$1 );
		_ZN6ComPtrI6IFAKEAED1Ev( &A2$1 );
		_ZN6ComPtrI6IFAKEBED1Ev( &B$1 );
		_ZN6ComPtrI6IFAKEAED1Ev( &A$1 );
	}
	if( (int64)G_DESTROYED$ == 1ll) goto label$784;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 431ll, (char*)"__FB_MODLEVELPROC__", (char*)"g_destroyed = 1" );
		label$784:;
	}
	{
		int32 vr$482 = CoInitializeEx( (void*)0ull, 2u );
		if( (int64)vr$482 >= 0ll) goto label$786;
		{
			fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 436ll, (char*)"__FB_MODLEVELPROC__", (char*)"(cast(HRESULT, (CoInitializeEx( 0, COINIT_APARTMENTTHREADED ))) >= 0)" );
			label$786:;
		}
		{
			struct $5_GUID CLSID_SHELLLINK_$2;
			*(uint32*)&CLSID_SHELLLINK_$2 = 136193u;
			*(uint16*)((uint8*)&CLSID_SHELLLINK_$2 + 4ll) = (uint16)0u;
			*(uint16*)((uint8*)&CLSID_SHELLLINK_$2 + 6ll) = (uint16)0u;
			*(uint8*)((uint8*)&CLSID_SHELLLINK_$2 + 8ll) = (uint8)192u;
			*(uint8*)((uint8*)&CLSID_SHELLLINK_$2 + 9ll) = (uint8)0u;
			*(uint8*)((uint8*)&CLSID_SHELLLINK_$2 + 10ll) = (uint8)0u;
			*(uint8*)((uint8*)&CLSID_SHELLLINK_$2 + 11ll) = (uint8)0u;
			*(uint8*)((uint8*)&CLSID_SHELLLINK_$2 + 12ll) = (uint8)0u;
			*(uint8*)((uint8*)&CLSID_SHELLLINK_$2 + 13ll) = (uint8)0u;
			*(uint8*)((uint8*)&CLSID_SHELLLINK_$2 + 14ll) = (uint8)0u;
			*(uint8*)((uint8*)&CLSID_SHELLLINK_$2 + 15ll) = (uint8)70u;
			struct $6ComPtrIN2FB10COMUNKNOWNEE BYCLSID$2;
			_Z9ComCreateIN2FB10COMUNKNOWNEEPK5_GUIDjPv( &BYCLSID$2, (struct $5_GUID*)&CLSID_SHELLLINK_$2, 1u, (void*)0ull );
			boolean vr$487 = _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( &BYCLSID$2 );
			if( (int64)-(boolean)(vr$487 == (boolean)0ll) != 0ll) goto label$788;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 449ll, (char*)"__FB_MODLEVELPROC__", (char*)"byClsid.IsNull( ) = FALSE" );
				label$788:;
			}
			struct $6ComPtrIN2FB10COMUNKNOWNEE BYPROGID$2;
			_Z19ComCreateFromProgIDIN2FB10COMUNKNOWNEERKwjPv( &BYPROGID$2, (uint16*)L"Shell.Application", 23u, (void*)0ull );
			boolean vr$492 = _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( &BYPROGID$2 );
			if( (int64)-(boolean)(vr$492 == (boolean)0ll) != 0ll) goto label$790;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 452ll, (char*)"__FB_MODLEVELPROC__", (char*)"byProgid.IsNull( ) = FALSE" );
				label$790:;
			}
			struct $5_GUID BOGUS$2;
			*(uint32*)&BOGUS$2 = 3735928559u;
			*(uint16*)((uint8*)&BOGUS$2 + 4ll) = (uint16)4660u;
			*(uint16*)((uint8*)&BOGUS$2 + 6ll) = (uint16)22136u;
			*(uint8*)((uint8*)&BOGUS$2 + 8ll) = (uint8)1u;
			*(uint8*)((uint8*)&BOGUS$2 + 9ll) = (uint8)2u;
			*(uint8*)((uint8*)&BOGUS$2 + 10ll) = (uint8)3u;
			*(uint8*)((uint8*)&BOGUS$2 + 11ll) = (uint8)4u;
			*(uint8*)((uint8*)&BOGUS$2 + 12ll) = (uint8)5u;
			*(uint8*)((uint8*)&BOGUS$2 + 13ll) = (uint8)6u;
			*(uint8*)((uint8*)&BOGUS$2 + 14ll) = (uint8)7u;
			*(uint8*)((uint8*)&BOGUS$2 + 15ll) = (uint8)8u;
			struct $6ComPtrIN2FB10COMUNKNOWNEE BAD$2;
			_Z9ComCreateIN2FB10COMUNKNOWNEEPK5_GUIDjPv( &BAD$2, (struct $5_GUID*)&BOGUS$2, 23u, (void*)0ull );
			boolean vr$498 = _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( &BAD$2 );
			if( (int64)-(boolean)(vr$498 == (boolean)1ll) != 0ll) goto label$792;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 457ll, (char*)"__FB_MODLEVELPROC__", (char*)"bad.IsNull( ) = TRUE" );
				label$792:;
			}
			struct $6ComPtrIN2FB10COMUNKNOWNEE BADPROGID$2;
			_Z19ComCreateFromProgIDIN2FB10COMUNKNOWNEERKwjPv( &BADPROGID$2, (uint16*)L"No.Such.ProgID.Here", 23u, (void*)0ull );
			boolean vr$503 = _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( &BADPROGID$2 );
			if( (int64)-(boolean)(vr$503 == (boolean)1ll) != 0ll) goto label$794;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 460ll, (char*)"__FB_MODLEVELPROC__", (char*)"badProgid.IsNull( ) = TRUE" );
				label$794:;
			}
			struct $5_GUID IID_IPERSISTFILE_$2;
			*(uint32*)&IID_IPERSISTFILE_$2 = 267u;
			*(uint16*)((uint8*)&IID_IPERSISTFILE_$2 + 4ll) = (uint16)0u;
			*(uint16*)((uint8*)&IID_IPERSISTFILE_$2 + 6ll) = (uint16)0u;
			*(uint8*)((uint8*)&IID_IPERSISTFILE_$2 + 8ll) = (uint8)192u;
			*(uint8*)((uint8*)&IID_IPERSISTFILE_$2 + 9ll) = (uint8)0u;
			*(uint8*)((uint8*)&IID_IPERSISTFILE_$2 + 10ll) = (uint8)0u;
			*(uint8*)((uint8*)&IID_IPERSISTFILE_$2 + 11ll) = (uint8)0u;
			*(uint8*)((uint8*)&IID_IPERSISTFILE_$2 + 12ll) = (uint8)0u;
			*(uint8*)((uint8*)&IID_IPERSISTFILE_$2 + 13ll) = (uint8)0u;
			*(uint8*)((uint8*)&IID_IPERSISTFILE_$2 + 14ll) = (uint8)0u;
			*(uint8*)((uint8*)&IID_IPERSISTFILE_$2 + 15ll) = (uint8)70u;
			struct $6ComPtrIN2FB10COMUNKNOWNEE PERSIST$2;
			_ZN6ComPtrIN2FB10COMUNKNOWNEEC1Ev( &PERSIST$2 );
			struct $N2FB10COMUNKNOWNE* vr$510 = _ZN6ComPtrIN2FB10COMUNKNOWNEE3GETEv( &BYCLSID$2 );
			int32 vr$511 = _Z5ComQIIN2FB10COMUNKNOWNEEPvPK5_GUIDR6ComPtrIN2FB10COMUNKNOWNEE( (void*)vr$510, (struct $5_GUID*)&IID_IPERSISTFILE_$2, &PERSIST$2 );
			if( (int64)vr$511 == 0ll) goto label$796;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 466ll, (char*)"__FB_MODLEVELPROC__", (char*)"ComQI( byClsid.Get( ), @IID_IPersistFile_, persist ) = S_OK" );
				label$796:;
			}
			boolean vr$514 = _ZN6ComPtrIN2FB10COMUNKNOWNEE6ISNULLEv( &PERSIST$2 );
			if( (int64)-(boolean)(vr$514 == (boolean)0ll) != 0ll) goto label$798;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 467ll, (char*)"__FB_MODLEVELPROC__", (char*)"persist.IsNull( ) = FALSE" );
				label$798:;
			}
			struct $N2FB10COMUNKNOWNE* vr$518 = _ZN6ComPtrIN2FB10COMUNKNOWNEE3GETEv( &PERSIST$2 );
			boolean vr$520 = _ZN6ComPtrIN2FB10COMUNKNOWNEE13ISEQUALOBJECTEPv( &BYCLSID$2, (void*)vr$518 );
			if( (int64)-(boolean)(vr$520 == (boolean)1ll) != 0ll) goto label$800;
			{
				fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "com\x5C" "comptr-qi.bas", 469ll, (char*)"__FB_MODLEVELPROC__", (char*)"byClsid.IsEqualObject( persist.Get( ) ) = TRUE" );
				label$800:;
			}
			_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &PERSIST$2 );
			_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &BADPROGID$2 );
			_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &BAD$2 );
			_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &BYPROGID$2 );
			_ZN6ComPtrIN2FB10COMUNKNOWNEED1Ev( &BYCLSID$2 );
		}
		CoUninitialize(  );
	}
	FBSTRING* vr$528 = fb_StrAllocTempDescZEx( (char*)"comptr-qi: ok", 13ll );
	fb_PrintString( 0, (FBSTRING*)vr$528, 1 );
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

static struct $5_GUID* _Z5IIDOF6IidTagIN2FB10COMUNKNOWNEE( struct $6IidTagIN2FB10COMUNKNOWNEE TAG$1 )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$111:;
	static struct $5_GUID G$1 = { 0u, (uint16)0u, (uint16)0u, { (uint8)192u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)70u } };
	fb$result$1 = (struct $5_GUID*)&G$1;
	goto label$112;
	label$112:;
	return fb$result$1;
}

static void _ZN6IFAKEAaSERKS_( struct $6IFAKEA* THIS$1, struct $6IFAKEA* __FB_RHS__$1 )
{
	label$117:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$118:;
}

static void _ZN6IFAKEBaSERKS_( struct $6IFAKEB* THIS$1, struct $6IFAKEB* __FB_RHS__$1 )
{
	label$123:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$124:;
}

static void _ZN12IUNSUPPORTEDaSERKS_( struct $12IUNSUPPORTED* THIS$1, struct $12IUNSUPPORTED* __FB_RHS__$1 )
{
	label$129:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$130:;
}

static void _ZN8INOTRAITaSERKS_( struct $8INOTRAIT* THIS$1, struct $8INOTRAIT* __FB_RHS__$1 )
{
	label$135:;
	_ZN2FB10COMUNKNOWNaSERKS0_( (struct $N2FB10COMUNKNOWNE*)THIS$1, (struct $N2FB10COMUNKNOWNE*)__FB_RHS__$1 );
	label$136:;
}

static struct $5_GUID* _Z5IIDOF6IidTagI6IFAKEAE( struct $6IidTagI6IFAKEAE TAG$1 )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$139:;
	fb$result$1 = (struct $5_GUID*)&IID_FAKEA$;
	goto label$140;
	label$140:;
	return fb$result$1;
}

static struct $5_GUID* _Z5IIDOF6IidTagI6IFAKEBE( struct $6IidTagI6IFAKEBE TAG$1 )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$141:;
	fb$result$1 = (struct $5_GUID*)&IID_FAKEB$;
	goto label$142;
	label$142:;
	return fb$result$1;
}

static struct $5_GUID* _Z5IIDOF6IidTagI12IUNSUPPORTEDE( struct $6IidTagI12IUNSUPPORTEDE TAG$1 )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$143:;
	fb$result$1 = (struct $5_GUID*)&IID_UNSUP$;
	goto label$144;
	label$144:;
	return fb$result$1;
}

static int32 OBJQI( struct $3OBJ* SELF_$1, struct $5_GUID* RIID$1, void** PPV$1 )
{
	int64 TMP$2090$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$145:;
	if( PPV$1 != (void**)0ull) goto label$148;
	{
		fb$result$1 = -2147467261;
		goto label$146;
		label$148:;
	}
	*PPV$1 = (void*)0ull;
	int32 vr$2 = memcmp( (void*)RIID$1, (void*)&IID_FAKEA$, 16ull );
	if( (int64)vr$2 == 0ll) goto label$149;
	struct $5_GUID* vr$4 = HIIDUNKNOWNFORTEST(  );
	int32 vr$5 = memcmp( (void*)RIID$1, (void*)vr$4, 16ull );
	TMP$2090$1 = (int64)-((int64)vr$5 == 0ll);
	goto label$898;
	label$149:;
	TMP$2090$1 = -1ll;
	label$898:;
	if( TMP$2090$1 == 0ll) goto label$151;
	{
		*PPV$1 = (void*)SELF_$1;
	}
	goto label$150;
	label$151:;
	int32 vr$9 = memcmp( (void*)RIID$1, (void*)&IID_FAKEB$, 16ull );
	if( (int64)vr$9 != 0ll) goto label$152;
	{
		*PPV$1 = (void*)((uint8*)SELF_$1 + 24ll);
	}
	goto label$150;
	label$152:;
	{
		fb$result$1 = -2147467262;
		goto label$146;
	}
	label$150:;
	OBJADDREF( SELF_$1 );
	fb$result$1 = 0;
	goto label$146;
	label$146:;
	return fb$result$1;
}

static uint32 OBJADDREF( struct $3OBJ* SELF_$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$153:;
	*(int32*)((uint8*)SELF_$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)SELF_$1 + 8ll) + 1ll);
	fb$result$1 = *(uint32*)((uint8*)SELF_$1 + 8ll);
	goto label$154;
	label$154:;
	return fb$result$1;
}

static uint32 OBJRELEASE( struct $3OBJ* SELF_$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$155:;
	*(int32*)((uint8*)SELF_$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)SELF_$1 + 8ll) + -1ll);
	int32 N$1;
	N$1 = *(int32*)((uint8*)SELF_$1 + 8ll);
	if( (int64)N$1 != 0ll) goto label$158;
	{
		G_DESTROYED$ = (int32)((int64)G_DESTROYED$ + 1ll);
		free( (void*)SELF_$1 );
		label$158:;
	}
	fb$result$1 = (uint32)N$1;
	goto label$156;
	label$156:;
	return fb$result$1;
}

static int32 OBJPOKEA( struct $3OBJ* SELF_$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$159:;
	*(int32*)((uint8*)SELF_$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)SELF_$1 + 12ll) + 1ll);
	fb$result$1 = *(int32*)((uint8*)SELF_$1 + 12ll);
	goto label$160;
	label$160:;
	return fb$result$1;
}

static int32 SUBQI( struct $4SUBB* SELF_$1, struct $5_GUID* RIID$1, void** PPV$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$161:;
	int32 vr$2 = OBJQI( *(struct $3OBJ**)((uint8*)SELF_$1 + 8ll), RIID$1, PPV$1 );
	fb$result$1 = vr$2;
	goto label$162;
	label$162:;
	return fb$result$1;
}

static uint32 SUBADDREF( struct $4SUBB* SELF_$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$163:;
	uint32 vr$2 = OBJADDREF( *(struct $3OBJ**)((uint8*)SELF_$1 + 8ll) );
	fb$result$1 = vr$2;
	goto label$164;
	label$164:;
	return fb$result$1;
}

static uint32 SUBRELEASE( struct $4SUBB* SELF_$1 )
{
	uint32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$165:;
	uint32 vr$2 = OBJRELEASE( *(struct $3OBJ**)((uint8*)SELF_$1 + 8ll) );
	fb$result$1 = vr$2;
	goto label$166;
	label$166:;
	return fb$result$1;
}

static int32 SUBPOKEB( struct $4SUBB* SELF_$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$167:;
	*(int32*)((uint8*)*(struct $3OBJ**)((uint8*)SELF_$1 + 8ll) + 16ll) = (int32)((int64)*(int32*)((uint8*)*(struct $3OBJ**)((uint8*)SELF_$1 + 8ll) + 16ll) + 1ll);
	fb$result$1 = *(int32*)((uint8*)*(struct $3OBJ**)((uint8*)SELF_$1 + 8ll) + 16ll);
	goto label$168;
	label$168:;
	return fb$result$1;
}

static struct $5_GUID* HIIDUNKNOWNFORTEST( void )
{
	struct $5_GUID* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$169:;
	static struct $5_GUID G$1 = { 0u, (uint16)0u, (uint16)0u, { (uint8)192u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)0u, (uint8)70u } };
	fb$result$1 = (struct $5_GUID*)&G$1;
	goto label$170;
	label$170:;
	return fb$result$1;
}

static struct $6IFAKEA* NEWOBJ( void )
{
	struct $6IFAKEA* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$173:;
	struct $3OBJ* O$1;
	void* vr$1 = calloc( 40ull, 1ull );
	O$1 = (struct $3OBJ*)vr$1;
	*(struct $5VTBLA**)O$1 = &G_VTBLA$;
	*(int32*)((uint8*)O$1 + 8ll) = 1;
	*(struct $5VTBLB**)((uint8*)O$1 + 24ll) = &G_VTBLB$;
	*(struct $3OBJ**)((uint8*)O$1 + 32ll) = O$1;
	fb$result$1 = (struct $6IFAKEA*)O$1;
	goto label$174;
	label$174:;
	return fb$result$1;
}

static int32 REFSOF( void* P$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$175:;
	if( P$1 != (void*)0ull) goto label$178;
	{
		fb$result$1 = -1;
		goto label$176;
		label$178:;
	}
	struct $3OBJ* vr$1 = ASOBJ( P$1 );
	fb$result$1 = *(int32*)((uint8*)vr$1 + 8ll);
	goto label$176;
	label$176:;
	return fb$result$1;
}

static void _ZN8ComQIPtrI6IFAKEBEaSERKS1_( struct $8ComQIPtrI6IFAKEBE* THIS$1, struct $8ComQIPtrI6IFAKEBE* __FB_RHS__$1 )
{
	label$569:;
	_ZN6ComPtrI6IFAKEBEaSERS1_( (struct $6ComPtrI6IFAKEBE*)THIS$1, (struct $6ComPtrI6IFAKEBE*)__FB_RHS__$1 );
	label$570:;
}

static void _ZN8ComQIPtrI6IFAKEBED1Ev( struct $8ComQIPtrI6IFAKEBE* THIS$1 )
{
	label$573:;
	label$574:;
	_ZN6ComPtrI6IFAKEBED1Ev( (struct $6ComPtrI6IFAKEBE*)THIS$1 );
}

static void _ZN8ComQIPtrI12IUNSUPPORTEDEaSERKS1_( struct $8ComQIPtrI12IUNSUPPORTEDE* THIS$1, struct $8ComQIPtrI12IUNSUPPORTEDE* __FB_RHS__$1 )
{
	label$581:;
	_ZN6ComPtrI12IUNSUPPORTEDEaSERS1_( (struct $6ComPtrI12IUNSUPPORTEDE*)THIS$1, (struct $6ComPtrI12IUNSUPPORTEDE*)__FB_RHS__$1 );
	label$582:;
}

static void _ZN8ComQIPtrI12IUNSUPPORTEDED1Ev( struct $8ComQIPtrI12IUNSUPPORTEDE* THIS$1 )
{
	label$585:;
	label$586:;
	_ZN6ComPtrI12IUNSUPPORTEDED1Ev( (struct $6ComPtrI12IUNSUPPORTEDE*)THIS$1 );
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0kernel32\0-l\0gdi32\0-l\0msimg32\0-l\0user32\0-l\0version\0-l\0advapi32\0-l\0imm32\0-l\0uuid\0-l\0ole32\0-l\0oleaut32";
