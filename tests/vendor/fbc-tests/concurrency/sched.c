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
struct $15ChannelIteratorIbE {
	void* SRC;
	boolean CUR;
	boolean OK;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $15ChannelIteratorIbE ) == 16 );
struct $7ChannelIbE {
	void* ST;
};
__FB_STATIC_ASSERT( sizeof( struct $7ChannelIbE ) == 8 );
struct $N2FB14CHANWAITERCOREE;
struct $N2FB14CHANWAITERCOREE {
	void* PARKER;
	boolean CLAIMED;
	boolean CLOSEDWAKE;
	struct $N2FB14CHANWAITERCOREE* PREVW;
	struct $N2FB14CHANWAITERCOREE* NEXTW;
	boolean* SELDONE;
	int32 CASEIDX;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB14CHANWAITERCOREE ) == 48 );
struct $N2FB8CHANCOREE {
	void* LOK;
	int32 CAP;
	int32 NUM;
	int32 HEAD;
	int32 TAIL;
	boolean ISCLOSED;
	int32 REFS;
	struct $N2FB14CHANWAITERCOREE* SFIRST;
	struct $N2FB14CHANWAITERCOREE* SLAST;
	struct $N2FB14CHANWAITERCOREE* RFIRST;
	struct $N2FB14CHANWAITERCOREE* RLAST;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB8CHANCOREE ) == 64 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
struct $8FBARRAY1IbE {
	boolean* DATA;
	boolean* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1IbE ) == 72 );
struct $9ChanStateIbE {
	struct $N2FB8CHANCOREE CORE;
	struct $8FBARRAY1IbE BUF;
};
__FB_STATIC_ASSERT( sizeof( struct $9ChanStateIbE ) == 136 );
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
struct $10ChanWaiterIbE {
	struct $N2FB14CHANWAITERCOREE C;
	boolean* SLOT;
};
__FB_STATIC_ASSERT( sizeof( struct $10ChanWaiterIbE ) == 56 );
struct $15ChannelIteratorIiE {
	void* SRC;
	int32 CUR;
	boolean OK;
};
__FB_STATIC_ASSERT( sizeof( struct $15ChannelIteratorIiE ) == 16 );
struct $7ChannelIiE {
	void* ST;
};
__FB_STATIC_ASSERT( sizeof( struct $7ChannelIiE ) == 8 );
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
struct $9ChanStateIiE {
	struct $N2FB8CHANCOREE CORE;
	struct $8FBARRAY1IiE BUF;
};
__FB_STATIC_ASSERT( sizeof( struct $9ChanStateIiE ) == 136 );
struct $10ChanWaiterIiE {
	struct $N2FB14CHANWAITERCOREE C;
	int32* SLOT;
};
__FB_STATIC_ASSERT( sizeof( struct $10ChanWaiterIiE ) == 56 );
struct $10fb_Object$ {
	void* VPTR$;
};
__FB_STATIC_ASSERT( sizeof( struct $10fb_Object$ ) == 8 );
struct $N2FB9SPAWNWORKE {
	struct $10fb_Object$ BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB9SPAWNWORKE ) == 8 );
struct $16__fbspawnframe_1Iu7INTEGERE {
	struct $N2FB9SPAWNWORKE BASE$;
	int64 A0;
};
__FB_STATIC_ASSERT( sizeof( struct $16__fbspawnframe_1Iu7INTEGERE ) == 16 );
typedef void (*tmp$1)( void* );
struct $N2FB10SELECTCASEE {
	struct $N2FB8CHANCOREE* CORE;
	struct $N2FB14CHANWAITERCOREE* REC;
	int32 KIND;
	boolean ENQUEUED;
	boolean OWNSSLOT;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB10SELECTCASEE ) == 24 );
struct $N2FB9SELECTCTXE {
	struct $N2FB10SELECTCASEE CASES[32];
	int32 N;
	boolean DONE;
	boolean HASTIMEOUT;
	uint32 TIMEOUTMS;
	boolean HASELSE;
	void* PARKER;
	uint32 SEED;
	boolean POLLED;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB9SELECTCTXE ) == 800 );
struct $16__fbspawnframe_2IiE {
	struct $N2FB9SPAWNWORKE BASE$;
	int32 A0;
};
__FB_STATIC_ASSERT( sizeof( struct $16__fbspawnframe_2IiE ) == 16 );
struct $16__fbspawnframe_3IiE {
	struct $N2FB9SPAWNWORKE BASE$;
	int32 A0;
};
__FB_STATIC_ASSERT( sizeof( struct $16__fbspawnframe_3IiE ) == 16 );
struct $16__fbspawnframe_4Iu7INTEGERE {
	struct $N2FB9SPAWNWORKE BASE$;
	int64 A0;
};
__FB_STATIC_ASSERT( sizeof( struct $16__fbspawnframe_4Iu7INTEGERE ) == 16 );
struct $16__fbspawnframe_5Iu7INTEGERE {
	struct $N2FB9SPAWNWORKE BASE$;
	int64 A0;
};
__FB_STATIC_ASSERT( sizeof( struct $16__fbspawnframe_5Iu7INTEGERE ) == 16 );
struct $16__fbspawnframe_6Iu7INTEGERE {
	struct $N2FB9SPAWNWORKE BASE$;
	int64 A0;
};
__FB_STATIC_ASSERT( sizeof( struct $16__fbspawnframe_6Iu7INTEGERE ) == 16 );
struct $N2FB8WGWAITERE;
struct $N2FB8WGWAITERE {
	void* PARKER;
	struct $N2FB8WGWAITERE* NEXTW;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB8WGWAITERE ) == 16 );
struct $N2FB9WAITGROUPE {
	void* LOK;
	int32 N;
	int32 WAITING;
	struct $N2FB8WGWAITERE* FIRST;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB9WAITGROUPE ) == 24 );
struct $N2FB8CTXSTATEE;
struct $N2FB8CTXSTATEE {
	void* LOK;
	int32 REFS;
	boolean CANCELLED;
	boolean DEADLINE_;
	struct $7ChannelIbE DONE_;
	struct $N2FB8CTXSTATEE* PARENT;
	struct $N2FB8CTXSTATEE* CHILDREN[64];
	int32 NCHILDREN;
	void* TIMERPARKER;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB8CTXSTATEE ) == 560 );
struct $N2FB7CONTEXTE {
	void* ST;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB7CONTEXTE ) == 8 );
struct $N2FB13CANCELCONTEXTE {
	struct $N2FB7CONTEXTE BASE$;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB13CANCELCONTEXTE ) == 8 );
struct $N2FB11CTXTIMERARGE {
	struct $N2FB8CTXSTATEE* S;
	uint32 MS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB11CTXTIMERARGE ) == 16 );
struct $7FBARRAYIPN2FB8CHANCOREEE {
	struct $N2FB8CHANCOREE** DATA;
	struct $N2FB8CHANCOREE** PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYIPN2FB8CHANCOREEE ) == 240 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
void _ZN10fb_Object$C1Ev( struct $10fb_Object$* );
int32 fb_ArrayRedimEx( struct $7FBARRAYIvE*, uint64, int32, int32, uint64, ... );
int32 fb_ArrayRedimTo( struct $7FBARRAYIvE*, struct $7FBARRAYIvE*, int32, void*, void* );
int32 fb_ArrayErase( struct $7FBARRAYIvE* );
void* fb_ErrorThrowEx( int32, int32, char*, void*, void* );
void* calloc( uint64, uint64 );
void free( void* );
FBSTRING* fb_StrInit( void*, int64, void*, int64, int32 );
FBSTRING* fb_StrAllocTempResult( FBSTRING* );
double fb_Timer( void );
int32 fb_SleepEx( int32, int32 );
void* fb_MutexCreate( void );
void fb_MutexDestroy( void* );
void fb_MutexLock( void* );
void fb_MutexUnlock( void* );
static void fb_ctor__sched( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void* fb_ParkerSelf( void );
void fb_Park( void* );
int32 fb_ParkTimed( void*, uint32 );
void fb_Unpark( void* );
void fb_ClaimLock( void );
void fb_ClaimUnlock( void );
static void _ZN2FB9HPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( struct $N2FB8CHANCOREE*, struct $N2FB14CHANWAITERCOREE* );
static void _ZN2FB9HPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( struct $N2FB8CHANCOREE*, struct $N2FB14CHANWAITERCOREE* );
static void _ZN2FB7HUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( struct $N2FB8CHANCOREE*, struct $N2FB14CHANWAITERCOREE*, boolean );
static boolean _ZN2FB6HCLAIMEPNS_14CHANWAITERCOREE( struct $N2FB14CHANWAITERCOREE* );
static struct $N2FB14CHANWAITERCOREE* _ZN2FB8HPOPSENDEPNS_8CHANCOREE( struct $N2FB8CHANCOREE* );
static struct $N2FB14CHANWAITERCOREE* _ZN2FB8HPOPRECVEPNS_8CHANCOREE( struct $N2FB8CHANCOREE* );
static void _ZN2FB12CHANPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( struct $N2FB8CHANCOREE*, struct $N2FB14CHANWAITERCOREE* );
static void _ZN2FB12CHANPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( struct $N2FB8CHANCOREE*, struct $N2FB14CHANWAITERCOREE* );
static void _ZN2FB10CHANUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( struct $N2FB8CHANCOREE*, struct $N2FB14CHANWAITERCOREE*, boolean );
static void _ZN2FB13HBLOCKFOREVEREv( void );
static void _ZN2FB9SPAWNWORKD1Ev( struct $N2FB9SPAWNWORKE* );
static void _ZN2FB9SPAWNWORKC1Ev( struct $N2FB9SPAWNWORKE* );
static void _ZN2FB9SPAWNWORKaSERKS0_( struct $N2FB9SPAWNWORKE*, struct $N2FB9SPAWNWORKE* );
static void _ZN2FB15SPAWNTRAMPOLINEEPv( void* );
void fb_Spawn( tmp$1, void* );
int32 fb_GoroutineCount( void );
int32 fb_SchedWorkerCount( void );
static void _ZN2FB9WAITGROUPC1Ev( struct $N2FB9WAITGROUPE* );
static void _ZN2FB9WAITGROUPD1Ev( struct $N2FB9WAITGROUPE* );
static void _ZN2FB9WAITGROUP3ADDEi( struct $N2FB9WAITGROUPE*, int32 );
static void _ZN2FB9WAITGROUP4DONEEv( struct $N2FB9WAITGROUPE* );
static void _ZN2FB9WAITGROUP4WAITEv( struct $N2FB9WAITGROUPE* );
static boolean _ZN2FB9WAITGROUP5HWAITEbj( struct $N2FB9WAITGROUPE*, boolean, uint32 );
static void _ZN2FB8CTXSTATEC1Ev( struct $N2FB8CTXSTATEE* );
static void _ZN2FB8CTXSTATEaSERKS0_( struct $N2FB8CTXSTATEE*, struct $N2FB8CTXSTATEE* );
static void _ZN2FB8CTXSTATED1Ev( struct $N2FB8CTXSTATEE* );
static void _ZN2FB7CONTEXTC1Ev( struct $N2FB7CONTEXTE* );
static void _ZN2FB7CONTEXTD1Ev( struct $N2FB7CONTEXTE* );
static void _ZN2FB7CONTEXTaSERS0_( struct $N2FB7CONTEXTE*, struct $N2FB7CONTEXTE* );
static void _ZN2FB13CANCELCONTEXTC1Ev( struct $N2FB13CANCELCONTEXTE* );
static void _ZN2FB13CANCELCONTEXTaSERKS0_( struct $N2FB13CANCELCONTEXTE*, struct $N2FB13CANCELCONTEXTE* );
static void _ZN2FB13CANCELCONTEXTC1ERKS0_( struct $N2FB13CANCELCONTEXTE*, struct $N2FB13CANCELCONTEXTE* );
static void _ZN2FB13CANCELCONTEXTD1Ev( struct $N2FB13CANCELCONTEXTE* );
static void _ZN2FB10HCTXCANCELEPNS_8CTXSTATEEb( struct $N2FB8CTXSTATEE*, boolean );
static void _ZN2FB11HCTXRELEASEEPNS_8CTXSTATEE( struct $N2FB8CTXSTATEE* );
static struct $N2FB8CTXSTATEE* _ZN2FB7HCTXNEWEPNS_8CTXSTATEE( struct $N2FB8CTXSTATEE* );
static void _ZN2FB13HCTXTIMERPROCEPv( void* );
static void _ZN2FB9SELECTCTXC1Ev( struct $N2FB9SELECTCTXE* );
static void _ZN2FB9SELECTCTX10SETTIMEOUTEj( struct $N2FB9SELECTCTXE*, uint32 );
static void _ZN2FB9SELECTCTX7SETELSEEv( struct $N2FB9SELECTCTXE* );
static boolean _ZN2FB9SELECTCTX11POLLEDREADYEv( struct $N2FB9SELECTCTXE* );
static boolean _ZN2FB6HREADYEPNS_8CHANCOREEi( struct $N2FB8CHANCOREE*, int32 );
static void _ZN2FB8HLOCKALLERNS_9SELECTCTXER7FBARRAYIPNS_8CHANCOREEERi( struct $N2FB9SELECTCTXE*, struct $7FBARRAYIPN2FB8CHANCOREEE*, int32* );
static void _ZN2FB13HUNLOCKALLBUTER7FBARRAYIPNS_8CHANCOREEEiS1_( struct $7FBARRAYIPN2FB8CHANCOREEE*, int32, struct $N2FB8CHANCOREE* );
static int32 _ZN2FB9SELECTRUNERNS_9SELECTCTXE( struct $N2FB9SELECTCTXE* );
static void _ZN7ChannelIbEC1Ev( struct $7ChannelIbE* );
static void _ZN7ChannelIbEC1Ei( struct $7ChannelIbE*, int32 );
static void _ZN7ChannelIbEC1ERS0_( struct $7ChannelIbE*, struct $7ChannelIbE* );
static void _ZN7ChannelIbED1Ev( struct $7ChannelIbE* );
static void _ZN7ChannelIbEaSERS0_( struct $7ChannelIbE*, struct $7ChannelIbE* );
static boolean _ZN7ChannelIbE7RECEIVEERb( struct $7ChannelIbE*, boolean* );
static void _ZN7ChannelIbE5CLOSEEv( struct $7ChannelIbE* );
static boolean _ZN7ChannelIbE8ISCLOSEDEv( struct $7ChannelIbE* );
static boolean _ZN7ChannelIbE5ISNILEv( struct $7ChannelIbE* );
static boolean _ZN7ChannelIbE5HWAITER10ChanWaiterIbEbbj( struct $7ChannelIbE*, struct $10ChanWaiterIbE*, boolean, boolean, uint32 );
static void _ZN9ChanStateIbEC1Ev( struct $9ChanStateIbE* );
static void _ZN9ChanStateIbEaSERKS0_( struct $9ChanStateIbE*, struct $9ChanStateIbE* );
static void _ZN9ChanStateIbED1Ev( struct $9ChanStateIbE* );
static void _ZN7ChannelIiEC1Ev( struct $7ChannelIiE* );
static void _ZN7ChannelIiEC1Ei( struct $7ChannelIiE*, int32 );
static void _ZN7ChannelIiEC1ERS0_( struct $7ChannelIiE*, struct $7ChannelIiE* );
static void _ZN7ChannelIiED1Ev( struct $7ChannelIiE* );
static void _ZN7ChannelIiEaSERS0_( struct $7ChannelIiE*, struct $7ChannelIiE* );
static boolean _ZN7ChannelIiE4SENDERi( struct $7ChannelIiE*, int32* );
static boolean _ZN7ChannelIiE7RECEIVEERi( struct $7ChannelIiE*, int32* );
static boolean _ZN7ChannelIiE7TRYSENDERi( struct $7ChannelIiE*, int32* );
static boolean _ZN7ChannelIiE10RECEIVEFORERij( struct $7ChannelIiE*, int32*, uint32 );
static void _ZN7ChannelIiE5CLOSEEv( struct $7ChannelIiE* );
static int32* _ZN7ChannelIiE7ELEMPTREv( struct $7ChannelIiE* );
static boolean _ZN7ChannelIiE5HWAITER10ChanWaiterIiEbbj( struct $7ChannelIiE*, struct $10ChanWaiterIiE*, boolean, boolean, uint32 );
static void _ZN9ChanStateIiEC1Ev( struct $9ChanStateIiE* );
static void _ZN9ChanStateIiEaSERKS0_( struct $9ChanStateIiE*, struct $9ChanStateIiE* );
static void _ZN9ChanStateIiED1Ev( struct $9ChanStateIiE* );
static void TALLY( int32 );
static void NESTED( int32 );
static void _Z15__fbspawnmake_1Iu7INTEGERES0_( int64 );
static void _ZN16__fbspawnframe_1Iu7INTEGERE6INVOKEEv( struct $16__fbspawnframe_1Iu7INTEGERE* );
static void _ZN16__fbspawnframe_1Iu7INTEGEREC1Ev( struct $16__fbspawnframe_1Iu7INTEGERE* );
static void _ZN16__fbspawnframe_1Iu7INTEGEREaSERKS1_( struct $16__fbspawnframe_1Iu7INTEGERE*, struct $16__fbspawnframe_1Iu7INTEGERE* );
static void _ZN16__fbspawnframe_1Iu7INTEGERED1Ev( struct $16__fbspawnframe_1Iu7INTEGERE* );
static void FEEDER( int32 );
void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED34WORKERCOUNT_IS_POSITIVE_AND_STABLEEv( void );
static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED39WORKERCOUNT_IS_POSITIVE_AND_STABLE_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED32GOROUTINECOUNT_RISES_AND_RETURNSEv( void );
static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED37GOROUTINECOUNT_RISES_AND_RETURNS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED31GOROUTINES_MAY_SPAWN_GOROUTINESEv( void );
static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED36GOROUTINES_MAY_SPAWN_GOROUTINES_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED24SELECT_ELSE_NEVER_BLOCKSEv( void );
static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED29SELECT_ELSE_NEVER_BLOCKS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED33SELECT_TIMEOUT_IS_THE_LAST_RESORTEv( void );
static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED38SELECT_TIMEOUT_IS_THE_LAST_RESORT_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED27SELECT_NIL_CASE_IS_DISABLEDEv( void );
static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED32SELECT_NIL_CASE_IS_DISABLED_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED34SELECT_PARKS_UNTIL_A_CASE_IS_READYEv( void );
static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED39SELECT_PARKS_UNTIL_A_CASE_IS_READY_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED37SELECT_SEES_A_CLOSED_CHANNEL_AS_READYEv( void );
static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED42SELECT_SEES_A_CLOSED_CHANNEL_AS_READY_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED13SUITE_CTOR305Ev( void ) __attribute__(( constructor ));
static void _Z15__fbspawnmake_2IiEi( int32 );
static void _Z15__fbspawnmake_3IiEi( int32 );
static void _Z15__fbspawnmake_4Iu7INTEGERES0_( int64 );
static boolean _Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( struct $N2FB9SELECTCTXE*, int32, struct $7ChannelIiE*, int32* );
static void _Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( struct $N2FB9SELECTCTXE*, int32, struct $7ChannelIiE* );
static boolean _Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( struct $N2FB9SELECTCTXE*, int32, struct $7ChannelIiE* );
static boolean _Z13SelectAddSendIiERN2FB9SELECTCTXEiR7ChannelIiERi( struct $N2FB9SELECTCTXE*, int32, struct $7ChannelIiE*, int32* );
static void _Z17SelectReleaseSendIiERN2FB9SELECTCTXEiR7ChannelIiE( struct $N2FB9SELECTCTXE*, int32, struct $7ChannelIiE* );
static boolean _Z16SelectCommitSendIiERN2FB9SELECTCTXEiR7ChannelIiE( struct $N2FB9SELECTCTXE*, int32, struct $7ChannelIiE* );
static void _Z15__fbspawnmake_5Iu7INTEGERES0_( int64 );
static void _Z15__fbspawnmake_6Iu7INTEGERES0_( int64 );
static void _ZN16__fbspawnframe_2IiE6INVOKEEv( struct $16__fbspawnframe_2IiE* );
static void _ZN16__fbspawnframe_2IiEC1Ev( struct $16__fbspawnframe_2IiE* );
static void _ZN16__fbspawnframe_2IiEaSERKS0_( struct $16__fbspawnframe_2IiE*, struct $16__fbspawnframe_2IiE* );
static void _ZN16__fbspawnframe_2IiED1Ev( struct $16__fbspawnframe_2IiE* );
static void _ZN16__fbspawnframe_3IiE6INVOKEEv( struct $16__fbspawnframe_3IiE* );
static void _ZN16__fbspawnframe_3IiEC1Ev( struct $16__fbspawnframe_3IiE* );
static void _ZN16__fbspawnframe_3IiEaSERKS0_( struct $16__fbspawnframe_3IiE*, struct $16__fbspawnframe_3IiE* );
static void _ZN16__fbspawnframe_3IiED1Ev( struct $16__fbspawnframe_3IiE* );
static void _ZN16__fbspawnframe_4Iu7INTEGERE6INVOKEEv( struct $16__fbspawnframe_4Iu7INTEGERE* );
static void _ZN16__fbspawnframe_4Iu7INTEGEREC1Ev( struct $16__fbspawnframe_4Iu7INTEGERE* );
static void _ZN16__fbspawnframe_4Iu7INTEGEREaSERKS1_( struct $16__fbspawnframe_4Iu7INTEGERE*, struct $16__fbspawnframe_4Iu7INTEGERE* );
static void _ZN16__fbspawnframe_4Iu7INTEGERED1Ev( struct $16__fbspawnframe_4Iu7INTEGERE* );
static boolean _Z20ChanCommitRecvLockedIiER7ChannelIiEPi( struct $7ChannelIiE*, int32* );
static boolean _Z20ChanCommitSendLockedIiER7ChannelIiEPi( struct $7ChannelIiE*, int32* );
static void _ZN16__fbspawnframe_5Iu7INTEGERE6INVOKEEv( struct $16__fbspawnframe_5Iu7INTEGERE* );
static void _ZN16__fbspawnframe_5Iu7INTEGEREC1Ev( struct $16__fbspawnframe_5Iu7INTEGERE* );
static void _ZN16__fbspawnframe_5Iu7INTEGEREaSERKS1_( struct $16__fbspawnframe_5Iu7INTEGERE*, struct $16__fbspawnframe_5Iu7INTEGERE* );
static void _ZN16__fbspawnframe_5Iu7INTEGERED1Ev( struct $16__fbspawnframe_5Iu7INTEGERE* );
static void _ZN16__fbspawnframe_6Iu7INTEGERE6INVOKEEv( struct $16__fbspawnframe_6Iu7INTEGERE* );
static void _ZN16__fbspawnframe_6Iu7INTEGEREC1Ev( struct $16__fbspawnframe_6Iu7INTEGERE* );
static void _ZN16__fbspawnframe_6Iu7INTEGEREaSERKS1_( struct $16__fbspawnframe_6Iu7INTEGERE*, struct $16__fbspawnframe_6Iu7INTEGERE* );
static void _ZN16__fbspawnframe_6Iu7INTEGERED1Ev( struct $16__fbspawnframe_6Iu7INTEGERE* );
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
static struct $8fb_RTTI$ _ZTSN2FB9SPAWNWORKE = { (void*)0ull, (char*)"N2FB9SPAWNWORKE", &__fb_ZTS6Object };
static void* _ZTVN2FB9SPAWNWORKE[4] = { (void*)0ull, (void*)&_ZTSN2FB9SPAWNWORKE, (void*)0ull, (void*)&_ZN2FB9SPAWNWORKD1Ev };
static struct $N2FB9WAITGROUPE G_WG$;
static struct $7ChannelIiE G_OUT$;
static struct $7ChannelIiE G_A$;
static struct $7ChannelIiE G_B$;
static int32 G_SEEN$;
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_1Iu7INTEGEREE;
static void* _ZTVN16__fbspawnframe_1Iu7INTEGEREE[4];
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_2IiEE;
static void* _ZTVN16__fbspawnframe_2IiEE[4];
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_3IiEE;
static void* _ZTVN16__fbspawnframe_3IiEE[4];
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_4Iu7INTEGEREE;
static void* _ZTVN16__fbspawnframe_4Iu7INTEGEREE[4];
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_5Iu7INTEGEREE;
static void* _ZTVN16__fbspawnframe_5Iu7INTEGEREE[4];
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_6Iu7INTEGEREE;
static void* _ZTVN16__fbspawnframe_6Iu7INTEGEREE[4];
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_1Iu7INTEGEREE = { (void*)0ull, (char*)"16__fbspawnframe_1Iu7INTEGERE", &_ZTSN2FB9SPAWNWORKE };
static void* _ZTVN16__fbspawnframe_1Iu7INTEGEREE[4] = { (void*)0ull, (void*)&_ZTSN16__fbspawnframe_1Iu7INTEGEREE, (void*)&_ZN16__fbspawnframe_1Iu7INTEGERE6INVOKEEv, (void*)&_ZN16__fbspawnframe_1Iu7INTEGERED1Ev };
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_2IiEE = { (void*)0ull, (char*)"16__fbspawnframe_2IiE", &_ZTSN2FB9SPAWNWORKE };
static void* _ZTVN16__fbspawnframe_2IiEE[4] = { (void*)0ull, (void*)&_ZTSN16__fbspawnframe_2IiEE, (void*)&_ZN16__fbspawnframe_2IiE6INVOKEEv, (void*)&_ZN16__fbspawnframe_2IiED1Ev };
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_3IiEE = { (void*)0ull, (char*)"16__fbspawnframe_3IiE", &_ZTSN2FB9SPAWNWORKE };
static void* _ZTVN16__fbspawnframe_3IiEE[4] = { (void*)0ull, (void*)&_ZTSN16__fbspawnframe_3IiEE, (void*)&_ZN16__fbspawnframe_3IiE6INVOKEEv, (void*)&_ZN16__fbspawnframe_3IiED1Ev };
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_4Iu7INTEGEREE = { (void*)0ull, (char*)"16__fbspawnframe_4Iu7INTEGERE", &_ZTSN2FB9SPAWNWORKE };
static void* _ZTVN16__fbspawnframe_4Iu7INTEGEREE[4] = { (void*)0ull, (void*)&_ZTSN16__fbspawnframe_4Iu7INTEGEREE, (void*)&_ZN16__fbspawnframe_4Iu7INTEGERE6INVOKEEv, (void*)&_ZN16__fbspawnframe_4Iu7INTEGERED1Ev };
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_5Iu7INTEGEREE = { (void*)0ull, (char*)"16__fbspawnframe_5Iu7INTEGERE", &_ZTSN2FB9SPAWNWORKE };
static void* _ZTVN16__fbspawnframe_5Iu7INTEGEREE[4] = { (void*)0ull, (void*)&_ZTSN16__fbspawnframe_5Iu7INTEGEREE, (void*)&_ZN16__fbspawnframe_5Iu7INTEGERE6INVOKEEv, (void*)&_ZN16__fbspawnframe_5Iu7INTEGERED1Ev };
static struct $8fb_RTTI$ _ZTSN16__fbspawnframe_6Iu7INTEGEREE = { (void*)0ull, (char*)"16__fbspawnframe_6Iu7INTEGERE", &_ZTSN2FB9SPAWNWORKE };
static void* _ZTVN16__fbspawnframe_6Iu7INTEGEREE[4] = { (void*)0ull, (void*)&_ZTSN16__fbspawnframe_6Iu7INTEGEREE, (void*)&_ZN16__fbspawnframe_6Iu7INTEGERE6INVOKEEv, (void*)&_ZN16__fbspawnframe_6Iu7INTEGERED1Ev };

static boolean _ZN15ChannelIteratorIbE7ISVALIDEv( struct $15ChannelIteratorIbE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$229:;
	fb$result$1 = *(boolean*)((uint8*)THIS$1 + 9ll);
	goto label$230;
	label$230:;
	return fb$result$1;
}

static boolean _ZN15ChannelIteratorIbE5VALUEEv( struct $15ChannelIteratorIbE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$231:;
	fb$result$1 = *(boolean*)((uint8*)THIS$1 + 8ll);
	goto label$232;
	label$232:;
	return fb$result$1;
}

static void _ZN15ChannelIteratorIbE8MOVENEXTEv( struct $15ChannelIteratorIbE* THIS$1 )
{
	label$233:;
	struct $7ChannelIbE* C$1;
	C$1 = *(struct $7ChannelIbE**)THIS$1;
	boolean vr$3 = _ZN7ChannelIbE7RECEIVEERb( C$1, (boolean*)((uint8*)THIS$1 + 8ll) );
	*(boolean*)((uint8*)THIS$1 + 9ll) = vr$3;
	label$234:;
}

static void _ZN7ChannelIbEC1Ev( struct $7ChannelIbE* THIS$1 )
{
	label$235:;
	__builtin_memset( (void**)THIS$1, 0, 8ll );
	*(void**)THIS$1 = (void*)0ull;
	label$236:;
}

static void _ZN7ChannelIbEC1Ei( struct $7ChannelIbE* THIS$1, int32 BUFCAP$1 )
{
	struct $9ChanStateIbE* TMP$35$1;
	label$237:;
	__builtin_memset( (void**)THIS$1, 0, 8ll );
	if( (int64)BUFCAP$1 >= 0ll) goto label$240;
	{
		label$241:;
		void* vr$3 = fb_ErrorThrowEx( 1, 313, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$3;
		label$242:;
		*(void**)THIS$1 = (void*)0ull;
		goto label$238;
	}
	label$240:;
	label$239:;
	struct $9ChanStateIbE* S$1;
	void* vr$5 = calloc( 136ull, 1ull );
	TMP$35$1 = (struct $9ChanStateIbE*)vr$5;
	if( TMP$35$1 == (struct $9ChanStateIbE*)0ull) goto label$253;
	_ZN9ChanStateIbEC1Ev( TMP$35$1 );
	label$253:;
	S$1 = TMP$35$1;
	void* vr$6 = fb_MutexCreate(  );
	*(void**)S$1 = vr$6;
	*(int32*)((uint8*)S$1 + 8ll) = BUFCAP$1;
	*(int32*)((uint8*)S$1 + 12ll) = 0;
	*(int32*)((uint8*)S$1 + 16ll) = 0;
	*(int32*)((uint8*)S$1 + 20ll) = 0;
	*(boolean*)((uint8*)S$1 + 24ll) = (boolean)0ll;
	*(int32*)((uint8*)S$1 + 28ll) = 1;
	if( (int64)BUFCAP$1 <= 0ll) goto label$255;
	{
		fb_ArrayRedimEx( (struct $7FBARRAYIvE*)((uint8*)S$1 + 64ll), 1ull, -1, 0, 1ull, 0ll, (int64)BUFCAP$1 + -1ll );
	}
	label$255:;
	label$254:;
	*(void**)THIS$1 = (void*)S$1;
	label$238:;
}

static void _ZN7ChannelIbEC1ERS0_( struct $7ChannelIbE* THIS$1, struct $7ChannelIbE* RHS$1 )
{
	label$256:;
	__builtin_memset( (void**)THIS$1, 0, 8ll );
	*(void**)THIS$1 = *(void**)RHS$1;
	if( *(void**)THIS$1 == (void*)0ull) goto label$259;
	{
		struct $9ChanStateIbE* S$2;
		S$2 = *(struct $9ChanStateIbE**)THIS$1;
		fb_MutexLock( *(void**)S$2 );
		*(int32*)((uint8*)S$2 + 28ll) = (int32)((int64)*(int32*)((uint8*)S$2 + 28ll) + 1ll);
		fb_MutexUnlock( *(void**)S$2 );
	}
	label$259:;
	label$258:;
	label$257:;
}

static void _ZN7ChannelIbED1Ev( struct $7ChannelIbE* THIS$1 )
{
	label$260:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$263;
	{
		goto label$261;
		label$263:;
	}
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	*(int32*)((uint8*)S$1 + 28ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 28ll) + -1ll);
	boolean DEAD$1;
	DEAD$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)S$1 + 28ll) == 0ll) != 0ll);
	fb_MutexUnlock( *(void**)S$1 );
	if( DEAD$1 == (boolean)0ll) goto label$265;
	{
		fb_MutexDestroy( *(void**)S$1 );
		if( S$1 == (struct $9ChanStateIbE*)0ull) goto label$266;
		_ZN9ChanStateIbED1Ev( S$1 );
		free( (void*)S$1 );
		label$266:;
	}
	label$265:;
	label$264:;
	*(void**)THIS$1 = (void*)0ull;
	label$261:;
}

static void _ZN7ChannelIbEaSERS0_( struct $7ChannelIbE* THIS$1, struct $7ChannelIbE* RHS$1 )
{
	label$267:;
	if( *(void**)THIS$1 != *(void**)RHS$1) goto label$270;
	{
		goto label$268;
		label$270:;
	}
	if( *(void**)THIS$1 == (void*)0ull) goto label$272;
	{
		struct $9ChanStateIbE* S$2;
		S$2 = *(struct $9ChanStateIbE**)THIS$1;
		fb_MutexLock( *(void**)S$2 );
		*(int32*)((uint8*)S$2 + 28ll) = (int32)((int64)*(int32*)((uint8*)S$2 + 28ll) + -1ll);
		boolean DEAD$2;
		DEAD$2 = (boolean)((int64)-((int64)*(int32*)((uint8*)S$2 + 28ll) == 0ll) != 0ll);
		fb_MutexUnlock( *(void**)S$2 );
		if( DEAD$2 == (boolean)0ll) goto label$274;
		{
			fb_MutexDestroy( *(void**)S$2 );
			if( S$2 == (struct $9ChanStateIbE*)0ull) goto label$275;
			_ZN9ChanStateIbED1Ev( S$2 );
			free( (void*)S$2 );
			label$275:;
		}
		label$274:;
		label$273:;
	}
	label$272:;
	label$271:;
	*(void**)THIS$1 = *(void**)RHS$1;
	if( *(void**)THIS$1 == (void*)0ull) goto label$277;
	{
		struct $9ChanStateIbE* S2$2;
		S2$2 = *(struct $9ChanStateIbE**)THIS$1;
		fb_MutexLock( *(void**)S2$2 );
		*(int32*)((uint8*)S2$2 + 28ll) = (int32)((int64)*(int32*)((uint8*)S2$2 + 28ll) + 1ll);
		fb_MutexUnlock( *(void**)S2$2 );
	}
	label$277:;
	label$276:;
	label$268:;
}

static boolean _ZN7ChannelIbE5ISNILEv( struct $7ChannelIbE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$278:;
	fb$result$1 = (boolean)((int64)-(*(void**)THIS$1 == (void*)0ull) != 0ll);
	goto label$279;
	label$279:;
	return fb$result$1;
}

static boolean _ZN7ChannelIbE8ISCLOSEDEv( struct $7ChannelIbE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$280:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$283;
	{
		fb$result$1 = (boolean)0ll;
		goto label$281;
		label$283:;
	}
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	boolean R$1;
	R$1 = *(boolean*)((uint8*)S$1 + 24ll);
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = R$1;
	goto label$281;
	label$281:;
	return fb$result$1;
}

static int32 _ZN7ChannelIbE5COUNTEv( struct $7ChannelIbE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$284:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$287;
	{
		fb$result$1 = 0;
		goto label$285;
		label$287:;
	}
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	int32 R$1;
	R$1 = *(int32*)((uint8*)S$1 + 12ll);
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = R$1;
	goto label$285;
	label$285:;
	return fb$result$1;
}

static int32 _ZN7ChannelIbE8CAPACITYEv( struct $7ChannelIbE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$288:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$291;
	{
		fb$result$1 = 0;
		goto label$289;
		label$291:;
	}
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb$result$1 = *(int32*)((uint8*)S$1 + 8ll);
	goto label$289;
	label$289:;
	return fb$result$1;
}

static boolean _ZN7ChannelIbE5HWAITER10ChanWaiterIbEbbj( struct $7ChannelIbE* THIS$1, struct $10ChanWaiterIbE* W$1, boolean ISSEND$1, boolean TIMED$1, uint32 MS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$292:;
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	if( TIMED$1 == (boolean)0ll) goto label$295;
	{
		fb_ParkTimed( *(void**)W$1, MS$1 );
	}
	goto label$294;
	label$295:;
	{
		fb_Park( *(void**)W$1 );
	}
	label$294:;
	fb_MutexLock( *(void**)S$1 );
	boolean GOT$1;
	GOT$1 = *(boolean*)((uint8*)W$1 + 8ll);
	if( GOT$1 != (boolean)0ll) goto label$297;
	{
		_ZN2FB7HUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)W$1, ISSEND$1 );
	}
	label$297:;
	label$296:;
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = GOT$1;
	goto label$293;
	label$293:;
	return fb$result$1;
}

static boolean _ZN7ChannelIbE4SENDERb( struct $7ChannelIbE* THIS$1, boolean* V$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$298:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$301;
	{
		_ZN2FB13HBLOCKFOREVEREv(  );
		fb$result$1 = (boolean)0ll;
		goto label$299;
	}
	label$301:;
	label$300:;
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$303;
	{
		fb_MutexUnlock( *(void**)S$1 );
		label$304:;
		void* vr$6 = fb_ErrorThrowEx( 1, 455, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$6;
		label$305:;
		fb$result$1 = (boolean)0ll;
		goto label$299;
	}
	label$303:;
	label$302:;
	struct $N2FB14CHANWAITERCOREE* W$1;
	struct $N2FB14CHANWAITERCOREE* vr$9 = _ZN2FB8HPOPRECVEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W$1 = vr$9;
	if( W$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$307;
	{
		*(*(boolean**)((uint8*)W$1 + 48ll)) = *V$1;
		*(boolean*)((uint8*)W$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W$1 );
		fb$result$1 = (boolean)1ll;
		goto label$299;
	}
	label$307:;
	label$306:;
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) >= (int64)*(int32*)((uint8*)S$1 + 8ll)) goto label$309;
	{
		*(boolean*)((uint8*)*(boolean**)((uint8*)S$1 + 64ll) + (int64)*(int32*)((uint8*)S$1 + 20ll)) = *V$1;
		*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$299;
	}
	label$309:;
	label$308:;
	struct $10ChanWaiterIbE W2$1;
	__builtin_memset( &W2$1, 0, 56ll );
	void* vr$40 = fb_ParkerSelf(  );
	*(void**)&W2$1 = vr$40;
	*(boolean**)((uint8*)&W2$1 + 48ll) = V$1;
	*(boolean*)((uint8*)&W2$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)&W2$1 + 9ll) = (boolean)0ll;
	_ZN2FB9HPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)&W2$1 );
	fb_MutexUnlock( *(void**)S$1 );
	boolean vr$46 = _ZN7ChannelIbE5HWAITER10ChanWaiterIbEbbj( THIS$1, &W2$1, (boolean)1ll, (boolean)0ll, 0u );
	if( vr$46 != (boolean)0ll) goto label$311;
	{
		fb$result$1 = (boolean)0ll;
		goto label$299;
	}
	label$311:;
	label$310:;
	if( *(boolean*)((uint8*)&W2$1 + 9ll) == (boolean)0ll) goto label$313;
	{
		label$314:;
		void* vr$47 = fb_ErrorThrowEx( 1, 455, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$47;
		label$315:;
		fb$result$1 = (boolean)0ll;
		goto label$299;
	}
	label$313:;
	label$312:;
	fb$result$1 = (boolean)1ll;
	goto label$299;
	label$299:;
	return fb$result$1;
}

static boolean _ZN7ChannelIbE7TRYSENDERb( struct $7ChannelIbE* THIS$1, boolean* V$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$316:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$319;
	{
		fb$result$1 = (boolean)0ll;
		goto label$317;
		label$319:;
	}
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$321;
	{
		fb_MutexUnlock( *(void**)S$1 );
		label$322:;
		void* vr$6 = fb_ErrorThrowEx( 1, 515, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$6;
		label$323:;
		fb$result$1 = (boolean)0ll;
		goto label$317;
	}
	label$321:;
	label$320:;
	struct $N2FB14CHANWAITERCOREE* W$1;
	struct $N2FB14CHANWAITERCOREE* vr$9 = _ZN2FB8HPOPRECVEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W$1 = vr$9;
	if( W$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$325;
	{
		*(*(boolean**)((uint8*)W$1 + 48ll)) = *V$1;
		*(boolean*)((uint8*)W$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W$1 );
		fb$result$1 = (boolean)1ll;
		goto label$317;
	}
	label$325:;
	label$324:;
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) >= (int64)*(int32*)((uint8*)S$1 + 8ll)) goto label$327;
	{
		*(boolean*)((uint8*)*(boolean**)((uint8*)S$1 + 64ll) + (int64)*(int32*)((uint8*)S$1 + 20ll)) = *V$1;
		*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$317;
	}
	label$327:;
	label$326:;
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = (boolean)0ll;
	goto label$317;
	label$317:;
	return fb$result$1;
}

static boolean _ZN7ChannelIbE7SENDFORERbj( struct $7ChannelIbE* THIS$1, boolean* V$1, uint32 MS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$328:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$331;
	{
		void* P$2;
		void* vr$2 = fb_ParkerSelf(  );
		P$2 = vr$2;
		fb_ParkTimed( P$2, MS$1 );
		fb$result$1 = (boolean)0ll;
		goto label$329;
	}
	label$331:;
	label$330:;
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$333;
	{
		fb_MutexUnlock( *(void**)S$1 );
		label$334:;
		void* vr$7 = fb_ErrorThrowEx( 1, 548, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$7;
		label$335:;
		fb$result$1 = (boolean)0ll;
		goto label$329;
	}
	label$333:;
	label$332:;
	struct $N2FB14CHANWAITERCOREE* W$1;
	struct $N2FB14CHANWAITERCOREE* vr$10 = _ZN2FB8HPOPRECVEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W$1 = vr$10;
	if( W$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$337;
	{
		*(*(boolean**)((uint8*)W$1 + 48ll)) = *V$1;
		*(boolean*)((uint8*)W$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W$1 );
		fb$result$1 = (boolean)1ll;
		goto label$329;
	}
	label$337:;
	label$336:;
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) >= (int64)*(int32*)((uint8*)S$1 + 8ll)) goto label$339;
	{
		*(boolean*)((uint8*)*(boolean**)((uint8*)S$1 + 64ll) + (int64)*(int32*)((uint8*)S$1 + 20ll)) = *V$1;
		*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$329;
	}
	label$339:;
	label$338:;
	struct $10ChanWaiterIbE W2$1;
	__builtin_memset( &W2$1, 0, 56ll );
	void* vr$41 = fb_ParkerSelf(  );
	*(void**)&W2$1 = vr$41;
	*(boolean**)((uint8*)&W2$1 + 48ll) = V$1;
	*(boolean*)((uint8*)&W2$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)&W2$1 + 9ll) = (boolean)0ll;
	_ZN2FB9HPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)&W2$1 );
	fb_MutexUnlock( *(void**)S$1 );
	boolean vr$47 = _ZN7ChannelIbE5HWAITER10ChanWaiterIbEbbj( THIS$1, &W2$1, (boolean)1ll, (boolean)1ll, MS$1 );
	if( vr$47 != (boolean)0ll) goto label$341;
	{
		fb$result$1 = (boolean)0ll;
		goto label$329;
	}
	label$341:;
	label$340:;
	if( *(boolean*)((uint8*)&W2$1 + 9ll) == (boolean)0ll) goto label$343;
	{
		label$344:;
		void* vr$48 = fb_ErrorThrowEx( 1, 548, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$48;
		label$345:;
		fb$result$1 = (boolean)0ll;
		goto label$329;
	}
	label$343:;
	label$342:;
	fb$result$1 = (boolean)1ll;
	goto label$329;
	label$329:;
	return fb$result$1;
}

static boolean _ZN7ChannelIbE7RECEIVEERb( struct $7ChannelIbE* THIS$1, boolean* OUT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$346:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$349;
	{
		_ZN2FB13HBLOCKFOREVEREv(  );
		fb$result$1 = (boolean)0ll;
		goto label$347;
	}
	label$349:;
	label$348:;
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) <= 0ll) goto label$351;
	{
		*OUT$1 = *(boolean*)((uint8*)*(boolean**)((uint8*)S$1 + 64ll) + (int64)*(int32*)((uint8*)S$1 + 16ll));
		*(int32*)((uint8*)S$1 + 16ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 16ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + -1ll);
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$26 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$26;
		if( W$2 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$353;
		{
			*(boolean*)((uint8*)*(boolean**)((uint8*)S$1 + 64ll) + (int64)*(int32*)((uint8*)S$1 + 20ll)) = *(*(boolean**)((uint8*)W$2 + 48ll));
			*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
			*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
			*(boolean*)((uint8*)W$2 + 9ll) = (boolean)0ll;
			fb_MutexUnlock( *(void**)S$1 );
			fb_Unpark( *(void**)W$2 );
			fb$result$1 = (boolean)1ll;
			goto label$347;
		}
		label$353:;
		label$352:;
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$347;
	}
	label$351:;
	label$350:;
	struct $N2FB14CHANWAITERCOREE* W2$1;
	struct $N2FB14CHANWAITERCOREE* vr$52 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W2$1 = vr$52;
	if( W2$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$355;
	{
		*OUT$1 = *(*(boolean**)((uint8*)W2$1 + 48ll));
		*(boolean*)((uint8*)W2$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W2$1 );
		fb$result$1 = (boolean)1ll;
		goto label$347;
	}
	label$355:;
	label$354:;
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$357;
	{
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)0ll;
		goto label$347;
	}
	label$357:;
	label$356:;
	struct $10ChanWaiterIbE W3$1;
	__builtin_memset( &W3$1, 0, 56ll );
	void* vr$62 = fb_ParkerSelf(  );
	*(void**)&W3$1 = vr$62;
	*(boolean**)((uint8*)&W3$1 + 48ll) = OUT$1;
	*(boolean*)((uint8*)&W3$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)&W3$1 + 9ll) = (boolean)0ll;
	_ZN2FB9HPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)&W3$1 );
	fb_MutexUnlock( *(void**)S$1 );
	boolean vr$68 = _ZN7ChannelIbE5HWAITER10ChanWaiterIbEbbj( THIS$1, &W3$1, (boolean)0ll, (boolean)0ll, 0u );
	if( vr$68 != (boolean)0ll) goto label$359;
	{
		fb$result$1 = (boolean)0ll;
		goto label$347;
	}
	label$359:;
	label$358:;
	fb$result$1 = (boolean)(*(boolean*)((uint8*)&W3$1 + 9ll) == (boolean)0ll);
	goto label$347;
	label$347:;
	return fb$result$1;
}

static boolean _ZN7ChannelIbE10TRYRECEIVEERb( struct $7ChannelIbE* THIS$1, boolean* OUT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$360:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$363;
	{
		fb$result$1 = (boolean)0ll;
		goto label$361;
		label$363:;
	}
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) <= 0ll) goto label$365;
	{
		*OUT$1 = *(boolean*)((uint8*)*(boolean**)((uint8*)S$1 + 64ll) + (int64)*(int32*)((uint8*)S$1 + 16ll));
		*(int32*)((uint8*)S$1 + 16ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 16ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + -1ll);
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$26 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$26;
		if( W$2 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$367;
		{
			*(boolean*)((uint8*)*(boolean**)((uint8*)S$1 + 64ll) + (int64)*(int32*)((uint8*)S$1 + 20ll)) = *(*(boolean**)((uint8*)W$2 + 48ll));
			*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
			*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
			*(boolean*)((uint8*)W$2 + 9ll) = (boolean)0ll;
			fb_MutexUnlock( *(void**)S$1 );
			fb_Unpark( *(void**)W$2 );
			fb$result$1 = (boolean)1ll;
			goto label$361;
		}
		label$367:;
		label$366:;
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$361;
	}
	label$365:;
	label$364:;
	struct $N2FB14CHANWAITERCOREE* W2$1;
	struct $N2FB14CHANWAITERCOREE* vr$52 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W2$1 = vr$52;
	if( W2$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$369;
	{
		*OUT$1 = *(*(boolean**)((uint8*)W2$1 + 48ll));
		*(boolean*)((uint8*)W2$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W2$1 );
		fb$result$1 = (boolean)1ll;
		goto label$361;
	}
	label$369:;
	label$368:;
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = (boolean)0ll;
	goto label$361;
	label$361:;
	return fb$result$1;
}

static boolean _ZN7ChannelIbE10RECEIVEFORERbj( struct $7ChannelIbE* THIS$1, boolean* OUT$1, uint32 MS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$370:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$373;
	{
		void* P$2;
		void* vr$2 = fb_ParkerSelf(  );
		P$2 = vr$2;
		fb_ParkTimed( P$2, MS$1 );
		fb$result$1 = (boolean)0ll;
		goto label$371;
	}
	label$373:;
	label$372:;
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) <= 0ll) goto label$375;
	{
		*OUT$1 = *(boolean*)((uint8*)*(boolean**)((uint8*)S$1 + 64ll) + (int64)*(int32*)((uint8*)S$1 + 16ll));
		*(int32*)((uint8*)S$1 + 16ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 16ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + -1ll);
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$27 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$27;
		if( W$2 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$377;
		{
			*(boolean*)((uint8*)*(boolean**)((uint8*)S$1 + 64ll) + (int64)*(int32*)((uint8*)S$1 + 20ll)) = *(*(boolean**)((uint8*)W$2 + 48ll));
			*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
			*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
			*(boolean*)((uint8*)W$2 + 9ll) = (boolean)0ll;
			fb_MutexUnlock( *(void**)S$1 );
			fb_Unpark( *(void**)W$2 );
			fb$result$1 = (boolean)1ll;
			goto label$371;
		}
		label$377:;
		label$376:;
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$371;
	}
	label$375:;
	label$374:;
	struct $N2FB14CHANWAITERCOREE* W2$1;
	struct $N2FB14CHANWAITERCOREE* vr$53 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W2$1 = vr$53;
	if( W2$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$379;
	{
		*OUT$1 = *(*(boolean**)((uint8*)W2$1 + 48ll));
		*(boolean*)((uint8*)W2$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W2$1 );
		fb$result$1 = (boolean)1ll;
		goto label$371;
	}
	label$379:;
	label$378:;
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$381;
	{
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)0ll;
		goto label$371;
	}
	label$381:;
	label$380:;
	struct $10ChanWaiterIbE W3$1;
	__builtin_memset( &W3$1, 0, 56ll );
	void* vr$63 = fb_ParkerSelf(  );
	*(void**)&W3$1 = vr$63;
	*(boolean**)((uint8*)&W3$1 + 48ll) = OUT$1;
	*(boolean*)((uint8*)&W3$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)&W3$1 + 9ll) = (boolean)0ll;
	_ZN2FB9HPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)&W3$1 );
	fb_MutexUnlock( *(void**)S$1 );
	boolean vr$69 = _ZN7ChannelIbE5HWAITER10ChanWaiterIbEbbj( THIS$1, &W3$1, (boolean)0ll, (boolean)1ll, MS$1 );
	if( vr$69 != (boolean)0ll) goto label$383;
	{
		fb$result$1 = (boolean)0ll;
		goto label$371;
	}
	label$383:;
	label$382:;
	fb$result$1 = (boolean)(*(boolean*)((uint8*)&W3$1 + 9ll) == (boolean)0ll);
	goto label$371;
	label$371:;
	return fb$result$1;
}

static void _ZN7ChannelIbE5CLOSEEv( struct $7ChannelIbE* THIS$1 )
{
	label$384:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$387;
	{
		label$388:;
		void* vr$1 = fb_ErrorThrowEx( 1, 770, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$1;
		label$389:;
		goto label$385;
	}
	label$387:;
	label$386:;
	struct $9ChanStateIbE* S$1;
	S$1 = *(struct $9ChanStateIbE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$391;
	{
		fb_MutexUnlock( *(void**)S$1 );
		label$392:;
		void* vr$6 = fb_ErrorThrowEx( 1, 770, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$6;
		label$393:;
		goto label$385;
	}
	label$391:;
	label$390:;
	*(boolean*)((uint8*)S$1 + 24ll) = (boolean)1ll;
	struct $N2FB14CHANWAITERCOREE* WOKEN$1;
	WOKEN$1 = (struct $N2FB14CHANWAITERCOREE*)0ull;
	struct $N2FB14CHANWAITERCOREE* TAIL_$1;
	TAIL_$1 = (struct $N2FB14CHANWAITERCOREE*)0ull;
	label$394:;
	{
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$10 = _ZN2FB8HPOPRECVEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$10;
		if( W$2 != (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$398;
		{
			goto label$395;
			label$398:;
		}
		*(boolean*)((uint8*)W$2 + 9ll) = (boolean)1ll;
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$2 + 24ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
		if( TAIL_$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$400;
		{
			*(struct $N2FB14CHANWAITERCOREE**)((uint8*)TAIL_$1 + 24ll) = W$2;
		}
		goto label$399;
		label$400:;
		{
			WOKEN$1 = W$2;
			label$399:;
		}
		TAIL_$1 = W$2;
	}
	label$396:;
	goto label$394;
	label$395:;
	label$401:;
	{
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$16 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$16;
		if( W$2 != (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$405;
		{
			goto label$402;
			label$405:;
		}
		*(boolean*)((uint8*)W$2 + 9ll) = (boolean)1ll;
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$2 + 24ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
		if( TAIL_$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$407;
		{
			*(struct $N2FB14CHANWAITERCOREE**)((uint8*)TAIL_$1 + 24ll) = W$2;
		}
		goto label$406;
		label$407:;
		{
			WOKEN$1 = W$2;
			label$406:;
		}
		TAIL_$1 = W$2;
	}
	label$403:;
	goto label$401;
	label$402:;
	fb_MutexUnlock( *(void**)S$1 );
	label$408:;
	if( WOKEN$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$409;
	{
		struct $N2FB14CHANWAITERCOREE* NXT$2;
		NXT$2 = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)WOKEN$1 + 24ll);
		fb_Unpark( *(void**)WOKEN$1 );
		WOKEN$1 = NXT$2;
	}
	goto label$408;
	label$409:;
	label$385:;
}

static boolean* _ZN7ChannelIbE7ELEMPTREv( struct $7ChannelIbE* THIS$1 )
{
	boolean* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$410:;
	fb$result$1 = (boolean*)0ull;
	goto label$411;
	label$411:;
	return fb$result$1;
}

static struct $15ChannelIteratorIbE _ZN7ChannelIbE11GETITERATOREv( struct $7ChannelIbE* THIS$1 )
{
	struct $15ChannelIteratorIbE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$412:;
	struct $15ChannelIteratorIbE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	boolean vr$3 = _ZN7ChannelIbE7RECEIVEERb( THIS$1, (boolean*)((uint8*)&IT$1 + 8ll) );
	*(boolean*)((uint8*)&IT$1 + 9ll) = vr$3;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$413;
	label$413:;
	return fb$result$1;
}

static boolean _ZN15ChannelIteratorIiE7ISVALIDEv( struct $15ChannelIteratorIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$515:;
	fb$result$1 = *(boolean*)((uint8*)THIS$1 + 12ll);
	goto label$516;
	label$516:;
	return fb$result$1;
}

static int32 _ZN15ChannelIteratorIiE5VALUEEv( struct $15ChannelIteratorIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$517:;
	fb$result$1 = *(int32*)((uint8*)THIS$1 + 8ll);
	goto label$518;
	label$518:;
	return fb$result$1;
}

static void _ZN15ChannelIteratorIiE8MOVENEXTEv( struct $15ChannelIteratorIiE* THIS$1 )
{
	label$519:;
	struct $7ChannelIiE* C$1;
	C$1 = *(struct $7ChannelIiE**)THIS$1;
	boolean vr$3 = _ZN7ChannelIiE7RECEIVEERi( C$1, (int32*)((uint8*)THIS$1 + 8ll) );
	*(boolean*)((uint8*)THIS$1 + 12ll) = vr$3;
	label$520:;
}

static void _ZN7ChannelIiEC1Ev( struct $7ChannelIiE* THIS$1 )
{
	label$521:;
	__builtin_memset( (void**)THIS$1, 0, 8ll );
	*(void**)THIS$1 = (void*)0ull;
	label$522:;
}

static void _ZN7ChannelIiEC1Ei( struct $7ChannelIiE* THIS$1, int32 BUFCAP$1 )
{
	struct $9ChanStateIiE* TMP$48$1;
	label$523:;
	__builtin_memset( (void**)THIS$1, 0, 8ll );
	if( (int64)BUFCAP$1 >= 0ll) goto label$526;
	{
		label$527:;
		void* vr$3 = fb_ErrorThrowEx( 1, 313, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$3;
		label$528:;
		*(void**)THIS$1 = (void*)0ull;
		goto label$524;
	}
	label$526:;
	label$525:;
	struct $9ChanStateIiE* S$1;
	void* vr$5 = calloc( 136ull, 1ull );
	TMP$48$1 = (struct $9ChanStateIiE*)vr$5;
	if( TMP$48$1 == (struct $9ChanStateIiE*)0ull) goto label$539;
	_ZN9ChanStateIiEC1Ev( TMP$48$1 );
	label$539:;
	S$1 = TMP$48$1;
	void* vr$6 = fb_MutexCreate(  );
	*(void**)S$1 = vr$6;
	*(int32*)((uint8*)S$1 + 8ll) = BUFCAP$1;
	*(int32*)((uint8*)S$1 + 12ll) = 0;
	*(int32*)((uint8*)S$1 + 16ll) = 0;
	*(int32*)((uint8*)S$1 + 20ll) = 0;
	*(boolean*)((uint8*)S$1 + 24ll) = (boolean)0ll;
	*(int32*)((uint8*)S$1 + 28ll) = 1;
	if( (int64)BUFCAP$1 <= 0ll) goto label$541;
	{
		fb_ArrayRedimEx( (struct $7FBARRAYIvE*)((uint8*)S$1 + 64ll), 4ull, -1, 0, 1ull, 0ll, (int64)BUFCAP$1 + -1ll );
	}
	label$541:;
	label$540:;
	*(void**)THIS$1 = (void*)S$1;
	label$524:;
}

static void _ZN7ChannelIiEC1ERS0_( struct $7ChannelIiE* THIS$1, struct $7ChannelIiE* RHS$1 )
{
	label$542:;
	__builtin_memset( (void**)THIS$1, 0, 8ll );
	*(void**)THIS$1 = *(void**)RHS$1;
	if( *(void**)THIS$1 == (void*)0ull) goto label$545;
	{
		struct $9ChanStateIiE* S$2;
		S$2 = *(struct $9ChanStateIiE**)THIS$1;
		fb_MutexLock( *(void**)S$2 );
		*(int32*)((uint8*)S$2 + 28ll) = (int32)((int64)*(int32*)((uint8*)S$2 + 28ll) + 1ll);
		fb_MutexUnlock( *(void**)S$2 );
	}
	label$545:;
	label$544:;
	label$543:;
}

static void _ZN7ChannelIiED1Ev( struct $7ChannelIiE* THIS$1 )
{
	label$546:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$549;
	{
		goto label$547;
		label$549:;
	}
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	*(int32*)((uint8*)S$1 + 28ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 28ll) + -1ll);
	boolean DEAD$1;
	DEAD$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)S$1 + 28ll) == 0ll) != 0ll);
	fb_MutexUnlock( *(void**)S$1 );
	if( DEAD$1 == (boolean)0ll) goto label$551;
	{
		fb_MutexDestroy( *(void**)S$1 );
		if( S$1 == (struct $9ChanStateIiE*)0ull) goto label$552;
		_ZN9ChanStateIiED1Ev( S$1 );
		free( (void*)S$1 );
		label$552:;
	}
	label$551:;
	label$550:;
	*(void**)THIS$1 = (void*)0ull;
	label$547:;
}

static void _ZN7ChannelIiEaSERS0_( struct $7ChannelIiE* THIS$1, struct $7ChannelIiE* RHS$1 )
{
	label$553:;
	if( *(void**)THIS$1 != *(void**)RHS$1) goto label$556;
	{
		goto label$554;
		label$556:;
	}
	if( *(void**)THIS$1 == (void*)0ull) goto label$558;
	{
		struct $9ChanStateIiE* S$2;
		S$2 = *(struct $9ChanStateIiE**)THIS$1;
		fb_MutexLock( *(void**)S$2 );
		*(int32*)((uint8*)S$2 + 28ll) = (int32)((int64)*(int32*)((uint8*)S$2 + 28ll) + -1ll);
		boolean DEAD$2;
		DEAD$2 = (boolean)((int64)-((int64)*(int32*)((uint8*)S$2 + 28ll) == 0ll) != 0ll);
		fb_MutexUnlock( *(void**)S$2 );
		if( DEAD$2 == (boolean)0ll) goto label$560;
		{
			fb_MutexDestroy( *(void**)S$2 );
			if( S$2 == (struct $9ChanStateIiE*)0ull) goto label$561;
			_ZN9ChanStateIiED1Ev( S$2 );
			free( (void*)S$2 );
			label$561:;
		}
		label$560:;
		label$559:;
	}
	label$558:;
	label$557:;
	*(void**)THIS$1 = *(void**)RHS$1;
	if( *(void**)THIS$1 == (void*)0ull) goto label$563;
	{
		struct $9ChanStateIiE* S2$2;
		S2$2 = *(struct $9ChanStateIiE**)THIS$1;
		fb_MutexLock( *(void**)S2$2 );
		*(int32*)((uint8*)S2$2 + 28ll) = (int32)((int64)*(int32*)((uint8*)S2$2 + 28ll) + 1ll);
		fb_MutexUnlock( *(void**)S2$2 );
	}
	label$563:;
	label$562:;
	label$554:;
}

static boolean _ZN7ChannelIiE5ISNILEv( struct $7ChannelIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$564:;
	fb$result$1 = (boolean)((int64)-(*(void**)THIS$1 == (void*)0ull) != 0ll);
	goto label$565;
	label$565:;
	return fb$result$1;
}

static boolean _ZN7ChannelIiE8ISCLOSEDEv( struct $7ChannelIiE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$566:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$569;
	{
		fb$result$1 = (boolean)0ll;
		goto label$567;
		label$569:;
	}
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	boolean R$1;
	R$1 = *(boolean*)((uint8*)S$1 + 24ll);
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = R$1;
	goto label$567;
	label$567:;
	return fb$result$1;
}

static int32 _ZN7ChannelIiE5COUNTEv( struct $7ChannelIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$570:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$573;
	{
		fb$result$1 = 0;
		goto label$571;
		label$573:;
	}
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	int32 R$1;
	R$1 = *(int32*)((uint8*)S$1 + 12ll);
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = R$1;
	goto label$571;
	label$571:;
	return fb$result$1;
}

static int32 _ZN7ChannelIiE8CAPACITYEv( struct $7ChannelIiE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$574:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$577;
	{
		fb$result$1 = 0;
		goto label$575;
		label$577:;
	}
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb$result$1 = *(int32*)((uint8*)S$1 + 8ll);
	goto label$575;
	label$575:;
	return fb$result$1;
}

static boolean _ZN7ChannelIiE5HWAITER10ChanWaiterIiEbbj( struct $7ChannelIiE* THIS$1, struct $10ChanWaiterIiE* W$1, boolean ISSEND$1, boolean TIMED$1, uint32 MS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$578:;
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	if( TIMED$1 == (boolean)0ll) goto label$581;
	{
		fb_ParkTimed( *(void**)W$1, MS$1 );
	}
	goto label$580;
	label$581:;
	{
		fb_Park( *(void**)W$1 );
	}
	label$580:;
	fb_MutexLock( *(void**)S$1 );
	boolean GOT$1;
	GOT$1 = *(boolean*)((uint8*)W$1 + 8ll);
	if( GOT$1 != (boolean)0ll) goto label$583;
	{
		_ZN2FB7HUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)W$1, ISSEND$1 );
	}
	label$583:;
	label$582:;
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = GOT$1;
	goto label$579;
	label$579:;
	return fb$result$1;
}

static boolean _ZN7ChannelIiE4SENDERi( struct $7ChannelIiE* THIS$1, int32* V$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$584:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$587;
	{
		_ZN2FB13HBLOCKFOREVEREv(  );
		fb$result$1 = (boolean)0ll;
		goto label$585;
	}
	label$587:;
	label$586:;
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$589;
	{
		fb_MutexUnlock( *(void**)S$1 );
		label$590:;
		void* vr$6 = fb_ErrorThrowEx( 1, 455, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$6;
		label$591:;
		fb$result$1 = (boolean)0ll;
		goto label$585;
	}
	label$589:;
	label$588:;
	struct $N2FB14CHANWAITERCOREE* W$1;
	struct $N2FB14CHANWAITERCOREE* vr$9 = _ZN2FB8HPOPRECVEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W$1 = vr$9;
	if( W$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$593;
	{
		*(*(int32**)((uint8*)W$1 + 48ll)) = *V$1;
		*(boolean*)((uint8*)W$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W$1 );
		fb$result$1 = (boolean)1ll;
		goto label$585;
	}
	label$593:;
	label$592:;
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) >= (int64)*(int32*)((uint8*)S$1 + 8ll)) goto label$595;
	{
		*(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 20ll) << (2ll & 63ll))) = *V$1;
		*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$585;
	}
	label$595:;
	label$594:;
	struct $10ChanWaiterIiE W2$1;
	__builtin_memset( &W2$1, 0, 56ll );
	void* vr$41 = fb_ParkerSelf(  );
	*(void**)&W2$1 = vr$41;
	*(int32**)((uint8*)&W2$1 + 48ll) = V$1;
	*(boolean*)((uint8*)&W2$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)&W2$1 + 9ll) = (boolean)0ll;
	_ZN2FB9HPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)&W2$1 );
	fb_MutexUnlock( *(void**)S$1 );
	boolean vr$47 = _ZN7ChannelIiE5HWAITER10ChanWaiterIiEbbj( THIS$1, &W2$1, (boolean)1ll, (boolean)0ll, 0u );
	if( vr$47 != (boolean)0ll) goto label$597;
	{
		fb$result$1 = (boolean)0ll;
		goto label$585;
	}
	label$597:;
	label$596:;
	if( *(boolean*)((uint8*)&W2$1 + 9ll) == (boolean)0ll) goto label$599;
	{
		label$600:;
		void* vr$48 = fb_ErrorThrowEx( 1, 455, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$48;
		label$601:;
		fb$result$1 = (boolean)0ll;
		goto label$585;
	}
	label$599:;
	label$598:;
	fb$result$1 = (boolean)1ll;
	goto label$585;
	label$585:;
	return fb$result$1;
}

static boolean _ZN7ChannelIiE7TRYSENDERi( struct $7ChannelIiE* THIS$1, int32* V$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$602:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$605;
	{
		fb$result$1 = (boolean)0ll;
		goto label$603;
		label$605:;
	}
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$607;
	{
		fb_MutexUnlock( *(void**)S$1 );
		label$608:;
		void* vr$6 = fb_ErrorThrowEx( 1, 515, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$6;
		label$609:;
		fb$result$1 = (boolean)0ll;
		goto label$603;
	}
	label$607:;
	label$606:;
	struct $N2FB14CHANWAITERCOREE* W$1;
	struct $N2FB14CHANWAITERCOREE* vr$9 = _ZN2FB8HPOPRECVEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W$1 = vr$9;
	if( W$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$611;
	{
		*(*(int32**)((uint8*)W$1 + 48ll)) = *V$1;
		*(boolean*)((uint8*)W$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W$1 );
		fb$result$1 = (boolean)1ll;
		goto label$603;
	}
	label$611:;
	label$610:;
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) >= (int64)*(int32*)((uint8*)S$1 + 8ll)) goto label$613;
	{
		*(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 20ll) << (2ll & 63ll))) = *V$1;
		*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$603;
	}
	label$613:;
	label$612:;
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = (boolean)0ll;
	goto label$603;
	label$603:;
	return fb$result$1;
}

static boolean _ZN7ChannelIiE7SENDFORERij( struct $7ChannelIiE* THIS$1, int32* V$1, uint32 MS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$614:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$617;
	{
		void* P$2;
		void* vr$2 = fb_ParkerSelf(  );
		P$2 = vr$2;
		fb_ParkTimed( P$2, MS$1 );
		fb$result$1 = (boolean)0ll;
		goto label$615;
	}
	label$617:;
	label$616:;
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$619;
	{
		fb_MutexUnlock( *(void**)S$1 );
		label$620:;
		void* vr$7 = fb_ErrorThrowEx( 1, 548, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$7;
		label$621:;
		fb$result$1 = (boolean)0ll;
		goto label$615;
	}
	label$619:;
	label$618:;
	struct $N2FB14CHANWAITERCOREE* W$1;
	struct $N2FB14CHANWAITERCOREE* vr$10 = _ZN2FB8HPOPRECVEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W$1 = vr$10;
	if( W$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$623;
	{
		*(*(int32**)((uint8*)W$1 + 48ll)) = *V$1;
		*(boolean*)((uint8*)W$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W$1 );
		fb$result$1 = (boolean)1ll;
		goto label$615;
	}
	label$623:;
	label$622:;
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) >= (int64)*(int32*)((uint8*)S$1 + 8ll)) goto label$625;
	{
		*(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 20ll) << (2ll & 63ll))) = *V$1;
		*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$615;
	}
	label$625:;
	label$624:;
	struct $10ChanWaiterIiE W2$1;
	__builtin_memset( &W2$1, 0, 56ll );
	void* vr$42 = fb_ParkerSelf(  );
	*(void**)&W2$1 = vr$42;
	*(int32**)((uint8*)&W2$1 + 48ll) = V$1;
	*(boolean*)((uint8*)&W2$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)&W2$1 + 9ll) = (boolean)0ll;
	_ZN2FB9HPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)&W2$1 );
	fb_MutexUnlock( *(void**)S$1 );
	boolean vr$48 = _ZN7ChannelIiE5HWAITER10ChanWaiterIiEbbj( THIS$1, &W2$1, (boolean)1ll, (boolean)1ll, MS$1 );
	if( vr$48 != (boolean)0ll) goto label$627;
	{
		fb$result$1 = (boolean)0ll;
		goto label$615;
	}
	label$627:;
	label$626:;
	if( *(boolean*)((uint8*)&W2$1 + 9ll) == (boolean)0ll) goto label$629;
	{
		label$630:;
		void* vr$49 = fb_ErrorThrowEx( 1, 548, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$49;
		label$631:;
		fb$result$1 = (boolean)0ll;
		goto label$615;
	}
	label$629:;
	label$628:;
	fb$result$1 = (boolean)1ll;
	goto label$615;
	label$615:;
	return fb$result$1;
}

static boolean _ZN7ChannelIiE7RECEIVEERi( struct $7ChannelIiE* THIS$1, int32* OUT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$632:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$635;
	{
		_ZN2FB13HBLOCKFOREVEREv(  );
		fb$result$1 = (boolean)0ll;
		goto label$633;
	}
	label$635:;
	label$634:;
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) <= 0ll) goto label$637;
	{
		*OUT$1 = *(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 16ll) << (2ll & 63ll)));
		*(int32*)((uint8*)S$1 + 16ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 16ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + -1ll);
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$27 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$27;
		if( W$2 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$639;
		{
			*(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 20ll) << (2ll & 63ll))) = *(*(int32**)((uint8*)W$2 + 48ll));
			*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
			*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
			*(boolean*)((uint8*)W$2 + 9ll) = (boolean)0ll;
			fb_MutexUnlock( *(void**)S$1 );
			fb_Unpark( *(void**)W$2 );
			fb$result$1 = (boolean)1ll;
			goto label$633;
		}
		label$639:;
		label$638:;
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$633;
	}
	label$637:;
	label$636:;
	struct $N2FB14CHANWAITERCOREE* W2$1;
	struct $N2FB14CHANWAITERCOREE* vr$54 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W2$1 = vr$54;
	if( W2$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$641;
	{
		*OUT$1 = *(*(int32**)((uint8*)W2$1 + 48ll));
		*(boolean*)((uint8*)W2$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W2$1 );
		fb$result$1 = (boolean)1ll;
		goto label$633;
	}
	label$641:;
	label$640:;
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$643;
	{
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)0ll;
		goto label$633;
	}
	label$643:;
	label$642:;
	struct $10ChanWaiterIiE W3$1;
	__builtin_memset( &W3$1, 0, 56ll );
	void* vr$64 = fb_ParkerSelf(  );
	*(void**)&W3$1 = vr$64;
	*(int32**)((uint8*)&W3$1 + 48ll) = OUT$1;
	*(boolean*)((uint8*)&W3$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)&W3$1 + 9ll) = (boolean)0ll;
	_ZN2FB9HPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)&W3$1 );
	fb_MutexUnlock( *(void**)S$1 );
	boolean vr$70 = _ZN7ChannelIiE5HWAITER10ChanWaiterIiEbbj( THIS$1, &W3$1, (boolean)0ll, (boolean)0ll, 0u );
	if( vr$70 != (boolean)0ll) goto label$645;
	{
		fb$result$1 = (boolean)0ll;
		goto label$633;
	}
	label$645:;
	label$644:;
	fb$result$1 = (boolean)(*(boolean*)((uint8*)&W3$1 + 9ll) == (boolean)0ll);
	goto label$633;
	label$633:;
	return fb$result$1;
}

static boolean _ZN7ChannelIiE10TRYRECEIVEERi( struct $7ChannelIiE* THIS$1, int32* OUT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$646:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$649;
	{
		fb$result$1 = (boolean)0ll;
		goto label$647;
		label$649:;
	}
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) <= 0ll) goto label$651;
	{
		*OUT$1 = *(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 16ll) << (2ll & 63ll)));
		*(int32*)((uint8*)S$1 + 16ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 16ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + -1ll);
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$27 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$27;
		if( W$2 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$653;
		{
			*(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 20ll) << (2ll & 63ll))) = *(*(int32**)((uint8*)W$2 + 48ll));
			*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
			*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
			*(boolean*)((uint8*)W$2 + 9ll) = (boolean)0ll;
			fb_MutexUnlock( *(void**)S$1 );
			fb_Unpark( *(void**)W$2 );
			fb$result$1 = (boolean)1ll;
			goto label$647;
		}
		label$653:;
		label$652:;
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$647;
	}
	label$651:;
	label$650:;
	struct $N2FB14CHANWAITERCOREE* W2$1;
	struct $N2FB14CHANWAITERCOREE* vr$54 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W2$1 = vr$54;
	if( W2$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$655;
	{
		*OUT$1 = *(*(int32**)((uint8*)W2$1 + 48ll));
		*(boolean*)((uint8*)W2$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W2$1 );
		fb$result$1 = (boolean)1ll;
		goto label$647;
	}
	label$655:;
	label$654:;
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = (boolean)0ll;
	goto label$647;
	label$647:;
	return fb$result$1;
}

static boolean _ZN7ChannelIiE10RECEIVEFORERij( struct $7ChannelIiE* THIS$1, int32* OUT$1, uint32 MS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$656:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$659;
	{
		void* P$2;
		void* vr$2 = fb_ParkerSelf(  );
		P$2 = vr$2;
		fb_ParkTimed( P$2, MS$1 );
		fb$result$1 = (boolean)0ll;
		goto label$657;
	}
	label$659:;
	label$658:;
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) <= 0ll) goto label$661;
	{
		*OUT$1 = *(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 16ll) << (2ll & 63ll)));
		*(int32*)((uint8*)S$1 + 16ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 16ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + -1ll);
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$28 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$28;
		if( W$2 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$663;
		{
			*(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 20ll) << (2ll & 63ll))) = *(*(int32**)((uint8*)W$2 + 48ll));
			*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
			*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
			*(boolean*)((uint8*)W$2 + 9ll) = (boolean)0ll;
			fb_MutexUnlock( *(void**)S$1 );
			fb_Unpark( *(void**)W$2 );
			fb$result$1 = (boolean)1ll;
			goto label$657;
		}
		label$663:;
		label$662:;
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$657;
	}
	label$661:;
	label$660:;
	struct $N2FB14CHANWAITERCOREE* W2$1;
	struct $N2FB14CHANWAITERCOREE* vr$55 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W2$1 = vr$55;
	if( W2$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$665;
	{
		*OUT$1 = *(*(int32**)((uint8*)W2$1 + 48ll));
		*(boolean*)((uint8*)W2$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W2$1 );
		fb$result$1 = (boolean)1ll;
		goto label$657;
	}
	label$665:;
	label$664:;
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$667;
	{
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)0ll;
		goto label$657;
	}
	label$667:;
	label$666:;
	struct $10ChanWaiterIiE W3$1;
	__builtin_memset( &W3$1, 0, 56ll );
	void* vr$65 = fb_ParkerSelf(  );
	*(void**)&W3$1 = vr$65;
	*(int32**)((uint8*)&W3$1 + 48ll) = OUT$1;
	*(boolean*)((uint8*)&W3$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)&W3$1 + 9ll) = (boolean)0ll;
	_ZN2FB9HPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( (struct $N2FB8CHANCOREE*)S$1, (struct $N2FB14CHANWAITERCOREE*)&W3$1 );
	fb_MutexUnlock( *(void**)S$1 );
	boolean vr$71 = _ZN7ChannelIiE5HWAITER10ChanWaiterIiEbbj( THIS$1, &W3$1, (boolean)0ll, (boolean)1ll, MS$1 );
	if( vr$71 != (boolean)0ll) goto label$669;
	{
		fb$result$1 = (boolean)0ll;
		goto label$657;
	}
	label$669:;
	label$668:;
	fb$result$1 = (boolean)(*(boolean*)((uint8*)&W3$1 + 9ll) == (boolean)0ll);
	goto label$657;
	label$657:;
	return fb$result$1;
}

static void _ZN7ChannelIiE5CLOSEEv( struct $7ChannelIiE* THIS$1 )
{
	label$670:;
	if( *(void**)THIS$1 != (void*)0ull) goto label$673;
	{
		label$674:;
		void* vr$1 = fb_ErrorThrowEx( 1, 770, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$1;
		label$675:;
		goto label$671;
	}
	label$673:;
	label$672:;
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)THIS$1;
	fb_MutexLock( *(void**)S$1 );
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$677;
	{
		fb_MutexUnlock( *(void**)S$1 );
		label$678:;
		void* vr$6 = fb_ErrorThrowEx( 1, 770, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$6;
		label$679:;
		goto label$671;
	}
	label$677:;
	label$676:;
	*(boolean*)((uint8*)S$1 + 24ll) = (boolean)1ll;
	struct $N2FB14CHANWAITERCOREE* WOKEN$1;
	WOKEN$1 = (struct $N2FB14CHANWAITERCOREE*)0ull;
	struct $N2FB14CHANWAITERCOREE* TAIL_$1;
	TAIL_$1 = (struct $N2FB14CHANWAITERCOREE*)0ull;
	label$680:;
	{
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$10 = _ZN2FB8HPOPRECVEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$10;
		if( W$2 != (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$684;
		{
			goto label$681;
			label$684:;
		}
		*(boolean*)((uint8*)W$2 + 9ll) = (boolean)1ll;
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$2 + 24ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
		if( TAIL_$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$686;
		{
			*(struct $N2FB14CHANWAITERCOREE**)((uint8*)TAIL_$1 + 24ll) = W$2;
		}
		goto label$685;
		label$686:;
		{
			WOKEN$1 = W$2;
			label$685:;
		}
		TAIL_$1 = W$2;
	}
	label$682:;
	goto label$680;
	label$681:;
	label$687:;
	{
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$16 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$16;
		if( W$2 != (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$691;
		{
			goto label$688;
			label$691:;
		}
		*(boolean*)((uint8*)W$2 + 9ll) = (boolean)1ll;
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$2 + 24ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
		if( TAIL_$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$693;
		{
			*(struct $N2FB14CHANWAITERCOREE**)((uint8*)TAIL_$1 + 24ll) = W$2;
		}
		goto label$692;
		label$693:;
		{
			WOKEN$1 = W$2;
			label$692:;
		}
		TAIL_$1 = W$2;
	}
	label$689:;
	goto label$687;
	label$688:;
	fb_MutexUnlock( *(void**)S$1 );
	label$694:;
	if( WOKEN$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$695;
	{
		struct $N2FB14CHANWAITERCOREE* NXT$2;
		NXT$2 = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)WOKEN$1 + 24ll);
		fb_Unpark( *(void**)WOKEN$1 );
		WOKEN$1 = NXT$2;
	}
	goto label$694;
	label$695:;
	label$671:;
}

static int32* _ZN7ChannelIiE7ELEMPTREv( struct $7ChannelIiE* THIS$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$696:;
	fb$result$1 = (int32*)0ull;
	goto label$697;
	label$697:;
	return fb$result$1;
}

static struct $15ChannelIteratorIiE _ZN7ChannelIiE11GETITERATOREv( struct $7ChannelIiE* THIS$1 )
{
	struct $15ChannelIteratorIiE fb$result$1;
	__builtin_memset( &fb$result$1, 0, 16ll );
	label$698:;
	struct $15ChannelIteratorIiE IT$1;
	__builtin_memset( &IT$1, 0, 16ll );
	*(void**)&IT$1 = (void*)THIS$1;
	boolean vr$3 = _ZN7ChannelIiE7RECEIVEERi( THIS$1, (int32*)((uint8*)&IT$1 + 8ll) );
	*(boolean*)((uint8*)&IT$1 + 12ll) = vr$3;
	__builtin_memcpy( &fb$result$1, &IT$1, 16 );
	goto label$699;
	label$699:;
	return fb$result$1;
}

static void _Z15__fbspawnmake_1Iu7INTEGERES0_( int64 A0$1 )
{
	struct $16__fbspawnframe_1Iu7INTEGERE* TMP$54$1;
	label$706:;
	struct $16__fbspawnframe_1Iu7INTEGERE* F$1;
	void* vr$0 = calloc( 16ull, 1ull );
	TMP$54$1 = (struct $16__fbspawnframe_1Iu7INTEGERE*)vr$0;
	if( TMP$54$1 == (struct $16__fbspawnframe_1Iu7INTEGERE*)0ull) goto label$716;
	_ZN16__fbspawnframe_1Iu7INTEGEREC1Ev( TMP$54$1 );
	label$716:;
	F$1 = TMP$54$1;
	*(int64*)((uint8*)F$1 + 8ll) = A0$1;
	fb_Spawn( (tmp$1)&_ZN2FB15SPAWNTRAMPOLINEEPv, (void*)F$1 );
	label$707:;
}

static void _ZN16__fbspawnframe_1Iu7INTEGERE6INVOKEEv( struct $16__fbspawnframe_1Iu7INTEGERE* THIS$1 )
{
	label$717:;
	NESTED( (int32)*(int64*)((uint8*)THIS$1 + 8ll) );
	label$718:;
}

void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED34WORKERCOUNT_IS_POSITIVE_AND_STABLEEv( void )
{
	struct $7ChannelIiE TMP$79$1;
	label$723:;
	int32 W$1;
	int32 vr$0 = fb_SchedWorkerCount(  );
	W$1 = vr$0;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)W$1 >= 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 63, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.WORKERCOUNT_IS_POSITIVE_AND_STABLE", (char*)"CU_ASSERT_TRUE(w >= 1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)W$1 < 4096ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 64, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.WORKERCOUNT_IS_POSITIVE_AND_STABLE", (char*)"CU_ASSERT_TRUE(w < 4096)" );
	{
		int32 I$2;
		I$2 = 1;
		label$728:;
		{
			int32 vr$7 = fb_SchedWorkerCount(  );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$7 == (int64)W$1) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 67, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.WORKERCOUNT_IS_POSITIVE_AND_STABLE", (char*)"CU_ASSERT_EQUAL(WorkerCount( ),w)" );
		}
		label$726:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$725:;
		if( (int64)I$2 <= 20ll) goto label$728;
		label$727:;
	}
	_ZN7ChannelIiEC1Ei( &TMP$79$1, 256 );
	_ZN7ChannelIiEaSERS0_( &G_OUT$, &TMP$79$1 );
	_ZN7ChannelIiED1Ev( &TMP$79$1 );
	_ZN2FB9WAITGROUP3ADDEi( &G_WG$, 64 );
	{
		int32 I$2;
		I$2 = 1;
		label$732:;
		{
			_Z15__fbspawnmake_2IiEi( I$2 );
		}
		label$730:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$729:;
		if( (int64)I$2 <= 64ll) goto label$732;
		label$731:;
	}
	_ZN2FB9WAITGROUP4WAITEv( &G_WG$ );
	int32 vr$23 = fb_SchedWorkerCount(  );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$23 == (int64)W$1) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 78, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.WORKERCOUNT_IS_POSITIVE_AND_STABLE", (char*)"CU_ASSERT_EQUAL(WorkerCount( ),w)" );
	_ZN7ChannelIiE5CLOSEEv( &G_OUT$ );
	label$724:;
}

void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED32GOROUTINECOUNT_RISES_AND_RETURNSEv( void )
{
	struct $7ChannelIiE TMP$86$1;
	label$735:;
	int32 BASE_$1;
	int32 vr$0 = fb_GoroutineCount(  );
	BASE_$1 = vr$0;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)BASE_$1 >= 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 88, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.GOROUTINECOUNT_RISES_AND_RETURNS", (char*)"CU_ASSERT_TRUE(base_ >= 0)" );
	_ZN7ChannelIiEC1Ei( &TMP$86$1, 0 );
	_ZN7ChannelIiEaSERS0_( &G_OUT$, &TMP$86$1 );
	_ZN7ChannelIiED1Ev( &TMP$86$1 );
	_ZN2FB9WAITGROUP3ADDEi( &G_WG$, 32 );
	{
		int32 I$2;
		I$2 = 1;
		label$740:;
		{
			_Z15__fbspawnmake_3IiEi( I$2 );
		}
		label$738:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$737:;
		if( (int64)I$2 <= 32ll) goto label$740;
		label$739:;
	}
	double T0$1;
	double vr$11 = fb_Timer(  );
	T0$1 = vr$11;
	boolean ROSE$1;
	ROSE$1 = (boolean)0ll;
	label$741:;
	{
		int32 vr$12 = fb_GoroutineCount(  );
		if( (int64)vr$12 <= (int64)BASE_$1) goto label$745;
		{
			ROSE$1 = (boolean)1ll;
			goto label$742;
			label$745:;
		}
		fb_SleepEx( 5, 1 );
	}
	label$743:;
	double vr$15 = fb_Timer(  );
	if( !((vr$15 - T0$1) > 0x1.4p+3)) goto label$741;
	label$742:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(ROSE$1 != (boolean)0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 104, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.GOROUTINECOUNT_RISES_AND_RETURNS", (char*)"CU_ASSERT_TRUE(rose)" );
	int32 V$1;
	__builtin_memset( &V$1, 0, 4ll );
	int32 SUM$1;
	SUM$1 = 0;
	{
		int32 I$2;
		I$2 = 1;
		label$749:;
		{
			boolean vr$20 = _ZN7ChannelIiE10RECEIVEFORERij( &G_OUT$, &V$1, 20000u );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$20 != (boolean)0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 109, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.GOROUTINECOUNT_RISES_AND_RETURNS", (char*)"CU_ASSERT_TRUE(g_out.ReceiveFor( v, 20000 ))" );
			SUM$1 = (int32)((int64)SUM$1 + (int64)V$1);
		}
		label$747:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$746:;
		if( (int64)I$2 <= 32ll) goto label$749;
		label$748:;
	}
	_ZN2FB9WAITGROUP4WAITEv( &G_WG$ );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)SUM$1 == 528ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 113, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.GOROUTINECOUNT_RISES_AND_RETURNS", (char*)"CU_ASSERT_EQUAL(sum,32 * 33 \x5C 2)" );
	double vr$33 = fb_Timer(  );
	T0$1 = vr$33;
	label$750:;
	{
		int32 vr$34 = fb_GoroutineCount(  );
		if( (int64)vr$34 > (int64)BASE_$1) goto label$754;
		{
			goto label$751;
			label$754:;
		}
		fb_SleepEx( 5, 1 );
	}
	label$752:;
	double vr$37 = fb_Timer(  );
	if( !((vr$37 - T0$1) > 0x1.4p+3)) goto label$750;
	label$751:;
	int32 vr$39 = fb_GoroutineCount(  );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$39 <= (int64)BASE_$1) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 120, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.GOROUTINECOUNT_RISES_AND_RETURNS", (char*)"CU_ASSERT_TRUE(GoroutineCount( ) <= base_)" );
	_ZN7ChannelIiE5CLOSEEv( &G_OUT$ );
	label$736:;
}

void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED31GOROUTINES_MAY_SPAWN_GOROUTINESEv( void )
{
	struct $7ChannelIiE TMP$104$1;
	label$757:;
	_ZN7ChannelIiEC1Ei( &TMP$104$1, 64 );
	_ZN7ChannelIiEaSERS0_( &G_OUT$, &TMP$104$1 );
	_ZN7ChannelIiED1Ev( &TMP$104$1 );
	_ZN2FB9WAITGROUP3ADDEi( &G_WG$, 1 );
	_Z15__fbspawnmake_4Iu7INTEGERES0_( 20ll );
	int32 N$1;
	N$1 = 0;
	int32 V$1;
	__builtin_memset( &V$1, 0, 4ll );
	{
		int32 I$2;
		I$2 = 0;
		label$762:;
		{
			boolean vr$5 = _ZN7ChannelIiE10RECEIVEFORERij( &G_OUT$, &V$1, 20000u );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$5 != (boolean)0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 137, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.GOROUTINES_MAY_SPAWN_GOROUTINES", (char*)"CU_ASSERT_TRUE(g_out.ReceiveFor( v, 20000 ))" );
			N$1 = (int32)((int64)N$1 + 1ll);
		}
		label$760:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$759:;
		if( (int64)I$2 <= 20ll) goto label$762;
		label$761:;
	}
	_ZN2FB9WAITGROUP4WAITEv( &G_WG$ );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)N$1 == 21ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 142, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.GOROUTINES_MAY_SPAWN_GOROUTINES", (char*)"CU_ASSERT_EQUAL(n,DEPTH + 1)" );
	_ZN7ChannelIiE5CLOSEEv( &G_OUT$ );
	label$758:;
}

void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED24SELECT_ELSE_NEVER_BLOCKSEv( void )
{
	int32 TMP$126$1;
	int32 TMP$137$1;
	label$765:;
	struct $7ChannelIiE CH$1;
	_ZN7ChannelIiEC1Ei( &CH$1, 1 );
	int32 V$1;
	__builtin_memset( &V$1, 0, 4ll );
	int32 FIRED$1;
	FIRED$1 = -1;
	double T0$1;
	double vr$2 = fb_Timer(  );
	T0$1 = vr$2;
	{
		struct $N2FB9SELECTCTXE __FBSEL1_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL1_SC$2 );
		struct $7ChannelIiE __FBSEL1_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL1_C0$2, &CH$1 );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL1_SC$2, 0, &__FBSEL1_C0$2, &V$1 );
		_ZN2FB9SELECTCTX7SETELSEEv( &__FBSEL1_SC$2 );
		int32 __FBSEL1_F$2;
		int32 vr$11 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL1_SC$2 );
		__FBSEL1_F$2 = vr$11;
		if( (int64)__FBSEL1_F$2 != 0ll) goto label$768;
		{
			boolean vr$14 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL1_SC$2 );
			if( vr$14 == (boolean)0ll) goto label$770;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL1_SC$2, 0, &__FBSEL1_C0$2 );
				label$770:;
			}
			FIRED$1 = 0;
		}
		goto label$767;
		label$768:;
		if( (int64)__FBSEL1_F$2 != -3ll) goto label$771;
		{
			FIRED$1 = 1;
		}
		label$771:;
		label$767:;
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL1_SC$2, 0, &__FBSEL1_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL1_C0$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 160, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_ELSE_NEVER_BLOCKS", (char*)"CU_ASSERT_EQUAL(fired,1)" );
	double vr$24 = fb_Timer(  );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((vr$24 - T0$1) * 0x1.F4p+9) < 0x1.F4p+8) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 161, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_ELSE_NEVER_BLOCKS", (char*)"CU_ASSERT_TRUE(( timer - t0 ) * 1000 < 500)" );
	TMP$126$1 = 7;
	_ZN7ChannelIiE7TRYSENDERi( &CH$1, &TMP$126$1 );
	FIRED$1 = -1;
	{
		struct $N2FB9SELECTCTXE __FBSEL2_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL2_SC$2 );
		struct $7ChannelIiE __FBSEL2_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL2_C0$2, &CH$1 );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL2_SC$2, 0, &__FBSEL2_C0$2, &V$1 );
		_ZN2FB9SELECTCTX7SETELSEEv( &__FBSEL2_SC$2 );
		int32 __FBSEL2_F$2;
		int32 vr$39 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL2_SC$2 );
		__FBSEL2_F$2 = vr$39;
		if( (int64)__FBSEL2_F$2 != 0ll) goto label$773;
		{
			boolean vr$42 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL2_SC$2 );
			if( vr$42 == (boolean)0ll) goto label$775;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL2_SC$2, 0, &__FBSEL2_C0$2 );
				label$775:;
			}
			FIRED$1 = 0;
		}
		goto label$772;
		label$773:;
		if( (int64)__FBSEL2_F$2 != -3ll) goto label$776;
		{
			FIRED$1 = 1;
		}
		label$776:;
		label$772:;
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL2_SC$2, 0, &__FBSEL2_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL2_C0$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 170, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_ELSE_NEVER_BLOCKS", (char*)"CU_ASSERT_EQUAL(fired,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)V$1 == 7ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 171, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_ELSE_NEVER_BLOCKS", (char*)"CU_ASSERT_EQUAL(v,7)" );
	TMP$137$1 = 1;
	_ZN7ChannelIiE7TRYSENDERi( &CH$1, &TMP$137$1 );
	FIRED$1 = -1;
	{
		struct $N2FB9SELECTCTXE __FBSEL3_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL3_SC$2 );
		struct $7ChannelIiE __FBSEL3_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL3_C0$2, &CH$1 );
		int32 __FBSEL3_V0$2;
		__FBSEL3_V0$2 = 2;
		_Z13SelectAddSendIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL3_SC$2, 0, &__FBSEL3_C0$2, &__FBSEL3_V0$2 );
		_ZN2FB9SELECTCTX7SETELSEEv( &__FBSEL3_SC$2 );
		int32 __FBSEL3_F$2;
		int32 vr$65 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL3_SC$2 );
		__FBSEL3_F$2 = vr$65;
		if( (int64)__FBSEL3_F$2 != 0ll) goto label$778;
		{
			boolean vr$68 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL3_SC$2 );
			if( vr$68 == (boolean)0ll) goto label$780;
			{
				_Z16SelectCommitSendIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL3_SC$2, 0, &__FBSEL3_C0$2 );
				label$780:;
			}
			FIRED$1 = 0;
		}
		goto label$777;
		label$778:;
		if( (int64)__FBSEL3_F$2 != -3ll) goto label$781;
		{
			FIRED$1 = 1;
		}
		label$781:;
		label$777:;
		_Z17SelectReleaseSendIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL3_SC$2, 0, &__FBSEL3_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL3_C0$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 180, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_ELSE_NEVER_BLOCKS", (char*)"CU_ASSERT_EQUAL(fired,1)" );
	_ZN7ChannelIiE5CLOSEEv( &CH$1 );
	_ZN7ChannelIiED1Ev( &CH$1 );
	label$766:;
}

void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED33SELECT_TIMEOUT_IS_THE_LAST_RESORTEv( void )
{
	int32 TMP$147$1;
	label$784:;
	struct $7ChannelIiE CH$1;
	_ZN7ChannelIiEC1Ei( &CH$1, 1 );
	int32 V$1;
	__builtin_memset( &V$1, 0, 4ll );
	int32 FIRED$1;
	FIRED$1 = -1;
	double T0$1;
	double vr$2 = fb_Timer(  );
	T0$1 = vr$2;
	{
		struct $N2FB9SELECTCTXE __FBSEL4_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL4_SC$2 );
		struct $7ChannelIiE __FBSEL4_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL4_C0$2, &CH$1 );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL4_SC$2, 0, &__FBSEL4_C0$2, &V$1 );
		_ZN2FB9SELECTCTX10SETTIMEOUTEj( &__FBSEL4_SC$2, 200u );
		int32 __FBSEL4_F$2;
		int32 vr$11 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL4_SC$2 );
		__FBSEL4_F$2 = vr$11;
		if( (int64)__FBSEL4_F$2 != 0ll) goto label$787;
		{
			boolean vr$14 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL4_SC$2 );
			if( vr$14 == (boolean)0ll) goto label$789;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL4_SC$2, 0, &__FBSEL4_C0$2 );
				label$789:;
			}
			FIRED$1 = 0;
		}
		goto label$786;
		label$787:;
		if( (int64)__FBSEL4_F$2 != -2ll) goto label$790;
		{
			FIRED$1 = 1;
		}
		label$790:;
		label$786:;
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL4_SC$2, 0, &__FBSEL4_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL4_C0$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 197, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_TIMEOUT_IS_THE_LAST_RESORT", (char*)"CU_ASSERT_EQUAL(fired,1)" );
	double vr$24 = fb_Timer(  );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((vr$24 - T0$1) * 0x1.F4p+9) >= 0x1.2Cp+7) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 198, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_TIMEOUT_IS_THE_LAST_RESORT", (char*)"CU_ASSERT_TRUE(( timer - t0 ) * 1000 >= 150)" );
	TMP$147$1 = 5;
	_ZN7ChannelIiE7TRYSENDERi( &CH$1, &TMP$147$1 );
	FIRED$1 = -1;
	double vr$31 = fb_Timer(  );
	T0$1 = vr$31;
	{
		struct $N2FB9SELECTCTXE __FBSEL5_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL5_SC$2 );
		struct $7ChannelIiE __FBSEL5_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL5_C0$2, &CH$1 );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL5_SC$2, 0, &__FBSEL5_C0$2, &V$1 );
		_ZN2FB9SELECTCTX10SETTIMEOUTEj( &__FBSEL5_SC$2, 20000u );
		int32 __FBSEL5_F$2;
		int32 vr$40 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL5_SC$2 );
		__FBSEL5_F$2 = vr$40;
		if( (int64)__FBSEL5_F$2 != 0ll) goto label$792;
		{
			boolean vr$43 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL5_SC$2 );
			if( vr$43 == (boolean)0ll) goto label$794;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL5_SC$2, 0, &__FBSEL5_C0$2 );
				label$794:;
			}
			FIRED$1 = 0;
		}
		goto label$791;
		label$792:;
		if( (int64)__FBSEL5_F$2 != -2ll) goto label$795;
		{
			FIRED$1 = 1;
		}
		label$795:;
		label$791:;
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL5_SC$2, 0, &__FBSEL5_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL5_C0$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 208, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_TIMEOUT_IS_THE_LAST_RESORT", (char*)"CU_ASSERT_EQUAL(fired,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)V$1 == 5ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 209, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_TIMEOUT_IS_THE_LAST_RESORT", (char*)"CU_ASSERT_EQUAL(v,5)" );
	double vr$56 = fb_Timer(  );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((vr$56 - T0$1) * 0x1.F4p+9) < 0x1.F4p+9) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 210, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_TIMEOUT_IS_THE_LAST_RESORT", (char*)"CU_ASSERT_TRUE(( timer - t0 ) * 1000 < 1000)" );
	_ZN7ChannelIiE5CLOSEEv( &CH$1 );
	_ZN7ChannelIiED1Ev( &CH$1 );
	label$785:;
}

void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED27SELECT_NIL_CASE_IS_DISABLEDEv( void )
{
	int32 TMP$158$1;
	label$798:;
	struct $7ChannelIiE NEVER$1;
	_ZN7ChannelIiEC1Ev( &NEVER$1 );
	struct $7ChannelIiE READY$1;
	_ZN7ChannelIiEC1Ei( &READY$1, 1 );
	TMP$158$1 = 3;
	_ZN7ChannelIiE7TRYSENDERi( &READY$1, &TMP$158$1 );
	int32 V$1;
	__builtin_memset( &V$1, 0, 4ll );
	int32 W$1;
	__builtin_memset( &W$1, 0, 4ll );
	int32 FIRED$1;
	FIRED$1 = -1;
	{
		struct $N2FB9SELECTCTXE __FBSEL6_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL6_SC$2 );
		struct $7ChannelIiE __FBSEL6_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL6_C0$2, &NEVER$1 );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL6_SC$2, 0, &__FBSEL6_C0$2, &V$1 );
		struct $7ChannelIiE __FBSEL6_C1$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL6_C1$2, &READY$1 );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL6_SC$2, 1, &__FBSEL6_C1$2, &W$1 );
		_ZN2FB9SELECTCTX10SETTIMEOUTEj( &__FBSEL6_SC$2, 20000u );
		int32 __FBSEL6_F$2;
		int32 vr$19 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL6_SC$2 );
		__FBSEL6_F$2 = vr$19;
		if( (int64)__FBSEL6_F$2 != 0ll) goto label$801;
		{
			boolean vr$22 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL6_SC$2 );
			if( vr$22 == (boolean)0ll) goto label$803;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL6_SC$2, 0, &__FBSEL6_C0$2 );
				label$803:;
			}
			FIRED$1 = 0;
		}
		goto label$800;
		label$801:;
		if( (int64)__FBSEL6_F$2 != 1ll) goto label$804;
		{
			boolean vr$27 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL6_SC$2 );
			if( vr$27 == (boolean)0ll) goto label$806;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL6_SC$2, 1, &__FBSEL6_C1$2 );
				label$806:;
			}
			FIRED$1 = 1;
		}
		goto label$800;
		label$804:;
		if( (int64)__FBSEL6_F$2 != -2ll) goto label$807;
		{
			FIRED$1 = 2;
		}
		label$807:;
		label$800:;
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL6_SC$2, 1, &__FBSEL6_C1$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL6_C1$2 );
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL6_SC$2, 0, &__FBSEL6_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL6_C0$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 230, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_NIL_CASE_IS_DISABLED", (char*)"CU_ASSERT_EQUAL(fired,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)W$1 == 3ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 231, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_NIL_CASE_IS_DISABLED", (char*)"CU_ASSERT_EQUAL(w,3)" );
	FIRED$1 = -1;
	double T0$1;
	double vr$43 = fb_Timer(  );
	T0$1 = vr$43;
	{
		struct $N2FB9SELECTCTXE __FBSEL7_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL7_SC$2 );
		struct $7ChannelIiE __FBSEL7_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL7_C0$2, &NEVER$1 );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL7_SC$2, 0, &__FBSEL7_C0$2, &V$1 );
		_ZN2FB9SELECTCTX7SETELSEEv( &__FBSEL7_SC$2 );
		int32 __FBSEL7_F$2;
		int32 vr$52 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL7_SC$2 );
		__FBSEL7_F$2 = vr$52;
		if( (int64)__FBSEL7_F$2 != 0ll) goto label$809;
		{
			boolean vr$55 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL7_SC$2 );
			if( vr$55 == (boolean)0ll) goto label$811;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL7_SC$2, 0, &__FBSEL7_C0$2 );
				label$811:;
			}
			FIRED$1 = 0;
		}
		goto label$808;
		label$809:;
		if( (int64)__FBSEL7_F$2 != -3ll) goto label$812;
		{
			FIRED$1 = 1;
		}
		label$812:;
		label$808:;
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL7_SC$2, 0, &__FBSEL7_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL7_C0$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 240, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_NIL_CASE_IS_DISABLED", (char*)"CU_ASSERT_EQUAL(fired,1)" );
	double vr$65 = fb_Timer(  );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((vr$65 - T0$1) * 0x1.F4p+9) < 0x1.F4p+8) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 241, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_NIL_CASE_IS_DISABLED", (char*)"CU_ASSERT_TRUE(( timer - t0 ) * 1000 < 500)" );
	_ZN7ChannelIiE5CLOSEEv( &READY$1 );
	_ZN7ChannelIiED1Ev( &READY$1 );
	_ZN7ChannelIiED1Ev( &NEVER$1 );
	label$799:;
}

void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED34SELECT_PARKS_UNTIL_A_CASE_IS_READYEv( void )
{
	struct $7ChannelIiE TMP$170$1;
	struct $7ChannelIiE TMP$171$1;
	label$815:;
	_ZN7ChannelIiEC1Ei( &TMP$170$1, 1 );
	_ZN7ChannelIiEaSERS0_( &G_A$, &TMP$170$1 );
	_ZN7ChannelIiED1Ev( &TMP$170$1 );
	_ZN7ChannelIiEC1Ei( &TMP$171$1, 1 );
	_ZN7ChannelIiEaSERS0_( &G_B$, &TMP$171$1 );
	_ZN7ChannelIiED1Ev( &TMP$171$1 );
	_ZN2FB9WAITGROUP3ADDEi( &G_WG$, 1 );
	_Z15__fbspawnmake_5Iu7INTEGERES0_( 1ll );
	int32 V$1;
	__builtin_memset( &V$1, 0, 4ll );
	int32 W$1;
	__builtin_memset( &W$1, 0, 4ll );
	int32 FIRED$1;
	FIRED$1 = -1;
	{
		struct $N2FB9SELECTCTXE __FBSEL8_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL8_SC$2 );
		struct $7ChannelIiE __FBSEL8_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL8_C0$2, &G_A$ );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL8_SC$2, 0, &__FBSEL8_C0$2, &V$1 );
		struct $7ChannelIiE __FBSEL8_C1$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL8_C1$2, &G_B$ );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL8_SC$2, 1, &__FBSEL8_C1$2, &W$1 );
		_ZN2FB9SELECTCTX10SETTIMEOUTEj( &__FBSEL8_SC$2, 20000u );
		int32 __FBSEL8_F$2;
		int32 vr$19 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL8_SC$2 );
		__FBSEL8_F$2 = vr$19;
		if( (int64)__FBSEL8_F$2 != 0ll) goto label$818;
		{
			boolean vr$22 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL8_SC$2 );
			if( vr$22 == (boolean)0ll) goto label$820;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL8_SC$2, 0, &__FBSEL8_C0$2 );
				label$820:;
			}
			FIRED$1 = 0;
		}
		goto label$817;
		label$818:;
		if( (int64)__FBSEL8_F$2 != 1ll) goto label$821;
		{
			boolean vr$27 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL8_SC$2 );
			if( vr$27 == (boolean)0ll) goto label$823;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL8_SC$2, 1, &__FBSEL8_C1$2 );
				label$823:;
			}
			FIRED$1 = 1;
		}
		goto label$817;
		label$821:;
		if( (int64)__FBSEL8_F$2 != -2ll) goto label$824;
		{
			FIRED$1 = 2;
		}
		label$824:;
		label$817:;
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL8_SC$2, 1, &__FBSEL8_C1$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL8_C1$2 );
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL8_SC$2, 0, &__FBSEL8_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL8_C0$2 );
	}
	_ZN2FB9WAITGROUP4WAITEv( &G_WG$ );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 1ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 265, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_PARKS_UNTIL_A_CASE_IS_READY", (char*)"CU_ASSERT_EQUAL(fired,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)W$1 == 20ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 266, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_PARKS_UNTIL_A_CASE_IS_READY", (char*)"CU_ASSERT_EQUAL(w,20)" );
	_ZN2FB9WAITGROUP3ADDEi( &G_WG$, 1 );
	_Z15__fbspawnmake_6Iu7INTEGERES0_( 0ll );
	FIRED$1 = -1;
	{
		struct $N2FB9SELECTCTXE __FBSEL9_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL9_SC$2 );
		struct $7ChannelIiE __FBSEL9_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL9_C0$2, &G_A$ );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL9_SC$2, 0, &__FBSEL9_C0$2, &V$1 );
		struct $7ChannelIiE __FBSEL9_C1$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL9_C1$2, &G_B$ );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL9_SC$2, 1, &__FBSEL9_C1$2, &W$1 );
		_ZN2FB9SELECTCTX10SETTIMEOUTEj( &__FBSEL9_SC$2, 20000u );
		int32 __FBSEL9_F$2;
		int32 vr$54 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL9_SC$2 );
		__FBSEL9_F$2 = vr$54;
		if( (int64)__FBSEL9_F$2 != 0ll) goto label$826;
		{
			boolean vr$57 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL9_SC$2 );
			if( vr$57 == (boolean)0ll) goto label$828;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL9_SC$2, 0, &__FBSEL9_C0$2 );
				label$828:;
			}
			FIRED$1 = 0;
		}
		goto label$825;
		label$826:;
		if( (int64)__FBSEL9_F$2 != 1ll) goto label$829;
		{
			boolean vr$62 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL9_SC$2 );
			if( vr$62 == (boolean)0ll) goto label$831;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL9_SC$2, 1, &__FBSEL9_C1$2 );
				label$831:;
			}
			FIRED$1 = 1;
		}
		goto label$825;
		label$829:;
		if( (int64)__FBSEL9_F$2 != -2ll) goto label$832;
		{
			FIRED$1 = 2;
		}
		label$832:;
		label$825:;
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL9_SC$2, 1, &__FBSEL9_C1$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL9_C1$2 );
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL9_SC$2, 0, &__FBSEL9_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL9_C0$2 );
	}
	_ZN2FB9WAITGROUP4WAITEv( &G_WG$ );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 280, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_PARKS_UNTIL_A_CASE_IS_READY", (char*)"CU_ASSERT_EQUAL(fired,0)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)V$1 == 10ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 281, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_PARKS_UNTIL_A_CASE_IS_READY", (char*)"CU_ASSERT_EQUAL(v,10)" );
	_ZN7ChannelIiE5CLOSEEv( &G_A$ );
	_ZN7ChannelIiE5CLOSEEv( &G_B$ );
	label$816:;
}

void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED37SELECT_SEES_A_CLOSED_CHANNEL_AS_READYEv( void )
{
	label$835:;
	struct $7ChannelIiE CH$1;
	_ZN7ChannelIiEC1Ei( &CH$1, 1 );
	_ZN7ChannelIiE5CLOSEEv( &CH$1 );
	int32 V$1;
	__builtin_memset( &V$1, 0, 4ll );
	int32 FIRED$1;
	FIRED$1 = -1;
	double T0$1;
	double vr$3 = fb_Timer(  );
	T0$1 = vr$3;
	{
		struct $N2FB9SELECTCTXE __FBSEL10_SC$2;
		_ZN2FB9SELECTCTXC1Ev( &__FBSEL10_SC$2 );
		struct $7ChannelIiE __FBSEL10_C0$2;
		_ZN7ChannelIiEC1ERS0_( &__FBSEL10_C0$2, &CH$1 );
		_Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( &__FBSEL10_SC$2, 0, &__FBSEL10_C0$2, &V$1 );
		_ZN2FB9SELECTCTX10SETTIMEOUTEj( &__FBSEL10_SC$2, 20000u );
		int32 __FBSEL10_F$2;
		int32 vr$12 = _ZN2FB9SELECTRUNERNS_9SELECTCTXE( &__FBSEL10_SC$2 );
		__FBSEL10_F$2 = vr$12;
		if( (int64)__FBSEL10_F$2 != 0ll) goto label$838;
		{
			boolean vr$15 = _ZN2FB9SELECTCTX11POLLEDREADYEv( &__FBSEL10_SC$2 );
			if( vr$15 == (boolean)0ll) goto label$840;
			{
				_Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL10_SC$2, 0, &__FBSEL10_C0$2 );
				label$840:;
			}
			FIRED$1 = 0;
		}
		goto label$837;
		label$838:;
		if( (int64)__FBSEL10_F$2 != -2ll) goto label$841;
		{
			FIRED$1 = 1;
		}
		label$841:;
		label$837:;
		_Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( &__FBSEL10_SC$2, 0, &__FBSEL10_C0$2 );
		_ZN7ChannelIiED1Ev( &__FBSEL10_C0$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)FIRED$1 == 0ll) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 301, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_SEES_A_CLOSED_CHANNEL_AS_READY", (char*)"CU_ASSERT_EQUAL(fired,0)" );
	double vr$25 = fb_Timer(  );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(((vr$25 - T0$1) * 0x1.F4p+9) < 0x1.F4p+9) != 0ll), (char*)"C:\x5C" "dev\x5Ctiko-lang\x5Ctests\x5Cvendor\x5C" "fbc-tests\x5C" "concurrency\x5Csched.bas", 302, (char*)"TESTS.FBC_TESTS.CONCURRENCY.SCHED.SELECT_SEES_A_CLOSED_CHANNEL_AS_READY", (char*)"CU_ASSERT_TRUE(( timer - t0 ) * 1000 < 1000)" );
	_ZN7ChannelIiED1Ev( &CH$1 );
	label$836:;
}

static void _Z15__fbspawnmake_2IiEi( int32 A0$1 )
{
	struct $16__fbspawnframe_2IiE* TMP$193$1;
	label$846:;
	struct $16__fbspawnframe_2IiE* F$1;
	void* vr$0 = calloc( 16ull, 1ull );
	TMP$193$1 = (struct $16__fbspawnframe_2IiE*)vr$0;
	if( TMP$193$1 == (struct $16__fbspawnframe_2IiE*)0ull) goto label$856;
	_ZN16__fbspawnframe_2IiEC1Ev( TMP$193$1 );
	label$856:;
	F$1 = TMP$193$1;
	*(int32*)((uint8*)F$1 + 8ll) = A0$1;
	fb_Spawn( (tmp$1)&_ZN2FB15SPAWNTRAMPOLINEEPv, (void*)F$1 );
	label$847:;
}

static void _Z15__fbspawnmake_3IiEi( int32 A0$1 )
{
	struct $16__fbspawnframe_3IiE* TMP$200$1;
	label$857:;
	struct $16__fbspawnframe_3IiE* F$1;
	void* vr$0 = calloc( 16ull, 1ull );
	TMP$200$1 = (struct $16__fbspawnframe_3IiE*)vr$0;
	if( TMP$200$1 == (struct $16__fbspawnframe_3IiE*)0ull) goto label$867;
	_ZN16__fbspawnframe_3IiEC1Ev( TMP$200$1 );
	label$867:;
	F$1 = TMP$200$1;
	*(int32*)((uint8*)F$1 + 8ll) = A0$1;
	fb_Spawn( (tmp$1)&_ZN2FB15SPAWNTRAMPOLINEEPv, (void*)F$1 );
	label$858:;
}

static void _Z15__fbspawnmake_4Iu7INTEGERES0_( int64 A0$1 )
{
	struct $16__fbspawnframe_4Iu7INTEGERE* TMP$207$1;
	label$868:;
	struct $16__fbspawnframe_4Iu7INTEGERE* F$1;
	void* vr$0 = calloc( 16ull, 1ull );
	TMP$207$1 = (struct $16__fbspawnframe_4Iu7INTEGERE*)vr$0;
	if( TMP$207$1 == (struct $16__fbspawnframe_4Iu7INTEGERE*)0ull) goto label$878;
	_ZN16__fbspawnframe_4Iu7INTEGEREC1Ev( TMP$207$1 );
	label$878:;
	F$1 = TMP$207$1;
	*(int64*)((uint8*)F$1 + 8ll) = A0$1;
	fb_Spawn( (tmp$1)&_ZN2FB15SPAWNTRAMPOLINEEPv, (void*)F$1 );
	label$869:;
}

static boolean _Z13SelectAddRecvIiERN2FB9SELECTCTXEiR7ChannelIiERi( struct $N2FB9SELECTCTXE* SC$1, int32 IDX$1, struct $7ChannelIiE* CH$1, int32* OUT$1 )
{
	struct $10ChanWaiterIiE* TMP$210$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$879:;
	struct $10ChanWaiterIiE* W$1;
	void* vr$1 = calloc( 56ull, 1ull );
	TMP$210$1 = (struct $10ChanWaiterIiE*)vr$1;
	if( TMP$210$1 == (struct $10ChanWaiterIiE*)0ull) goto label$881;
	label$881:;
	W$1 = TMP$210$1;
	*(void**)W$1 = *(void**)((uint8*)SC$1 + 784ll);
	*(boolean*)((uint8*)W$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)W$1 + 9ll) = (boolean)0ll;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	*(boolean**)((uint8*)W$1 + 32ll) = (boolean*)((uint8*)SC$1 + 772ll);
	*(int32*)((uint8*)W$1 + 40ll) = IDX$1;
	*(int32**)((uint8*)W$1 + 48ll) = OUT$1;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 8ll) = (struct $N2FB14CHANWAITERCOREE*)W$1;
	*(int32*)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 16ll) = 0;
	*(boolean*)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 20ll) = (boolean)0ll;
	*(boolean*)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 21ll) = (boolean)0ll;
	if( *(void**)CH$1 != (void*)0ull) goto label$883;
	{
		*(struct $N2FB8CHANCOREE**)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) = (struct $N2FB8CHANCOREE*)0ull;
	}
	goto label$882;
	label$883:;
	{
		*(struct $N2FB8CHANCOREE**)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) = (struct $N2FB8CHANCOREE*)*(struct $9ChanStateIiE**)CH$1;
	}
	label$882:;
	if( (int64)IDX$1 < (int64)*(int32*)((uint8*)SC$1 + 768ll)) goto label$885;
	{
		*(int32*)((uint8*)SC$1 + 768ll) = (int32)((int64)IDX$1 + 1ll);
		label$885:;
	}
	fb$result$1 = (boolean)1ll;
	goto label$880;
	label$880:;
	return fb$result$1;
}

static void _Z17SelectReleaseRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( struct $N2FB9SELECTCTXE* SC$1, int32 IDX$1, struct $7ChannelIiE* CH$1 )
{
	int64 TMP$211$1;
	label$886:;
	struct $10ChanWaiterIiE* W$1;
	W$1 = *(struct $10ChanWaiterIiE**)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 8ll);
	boolean FREESLOT$1;
	if( (int64)-(*(boolean*)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 21ll)) == 0ll) goto label$888;
	TMP$211$1 = (int64)-(*(int32**)((uint8*)W$1 + 48ll) != (int32*)0ull);
	goto label$893;
	label$888:;
	TMP$211$1 = 0ll;
	label$893:;
	FREESLOT$1 = (boolean)(TMP$211$1 != 0ll);
	if( FREESLOT$1 == (boolean)0ll) goto label$890;
	{
		if( *(int32**)((uint8*)W$1 + 48ll) == (int32*)0ull) goto label$891;
		free( *(void**)((uint8*)W$1 + 48ll) );
		label$891:;
		label$890:;
	}
	if( W$1 == (struct $10ChanWaiterIiE*)0ull) goto label$892;
	free( (void*)W$1 );
	label$892:;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 8ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	label$887:;
}

static boolean _Z16SelectCommitRecvIiERN2FB9SELECTCTXEiR7ChannelIiE( struct $N2FB9SELECTCTXE* SC$1, int32 IDX$1, struct $7ChannelIiE* CH$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$894:;
	struct $10ChanWaiterIiE* W$1;
	W$1 = *(struct $10ChanWaiterIiE**)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 8ll);
	boolean vr$5 = _Z20ChanCommitRecvLockedIiER7ChannelIiEPi( CH$1, *(int32**)((uint8*)W$1 + 48ll) );
	fb$result$1 = vr$5;
	goto label$895;
	label$895:;
	return fb$result$1;
}

static boolean _Z13SelectAddSendIiERN2FB9SELECTCTXEiR7ChannelIiERi( struct $N2FB9SELECTCTXE* SC$1, int32 IDX$1, struct $7ChannelIiE* CH$1, int32* V$1 )
{
	struct $10ChanWaiterIiE* TMP$212$1;
	int32* TMP$213$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$896:;
	struct $10ChanWaiterIiE* W$1;
	void* vr$1 = calloc( 56ull, 1ull );
	TMP$212$1 = (struct $10ChanWaiterIiE*)vr$1;
	if( TMP$212$1 == (struct $10ChanWaiterIiE*)0ull) goto label$898;
	label$898:;
	W$1 = TMP$212$1;
	int32* HELD$1;
	void* vr$2 = calloc( 4ull, 1ull );
	TMP$213$1 = (int32*)vr$2;
	if( TMP$213$1 == (int32*)0ull) goto label$899;
	label$899:;
	HELD$1 = TMP$213$1;
	*HELD$1 = *V$1;
	*(void**)W$1 = *(void**)((uint8*)SC$1 + 784ll);
	*(boolean*)((uint8*)W$1 + 8ll) = (boolean)0ll;
	*(boolean*)((uint8*)W$1 + 9ll) = (boolean)0ll;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	*(boolean**)((uint8*)W$1 + 32ll) = (boolean*)((uint8*)SC$1 + 772ll);
	*(int32*)((uint8*)W$1 + 40ll) = IDX$1;
	*(int32**)((uint8*)W$1 + 48ll) = HELD$1;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 8ll) = (struct $N2FB14CHANWAITERCOREE*)W$1;
	*(int32*)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 16ll) = 1;
	*(boolean*)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 20ll) = (boolean)0ll;
	if( *(void**)CH$1 != (void*)0ull) goto label$901;
	{
		*(struct $N2FB8CHANCOREE**)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) = (struct $N2FB8CHANCOREE*)0ull;
	}
	goto label$900;
	label$901:;
	{
		*(struct $N2FB8CHANCOREE**)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) = (struct $N2FB8CHANCOREE*)*(struct $9ChanStateIiE**)CH$1;
	}
	label$900:;
	if( (int64)IDX$1 < (int64)*(int32*)((uint8*)SC$1 + 768ll)) goto label$903;
	{
		*(int32*)((uint8*)SC$1 + 768ll) = (int32)((int64)IDX$1 + 1ll);
		label$903:;
	}
	fb$result$1 = (boolean)1ll;
	goto label$897;
	label$897:;
	return fb$result$1;
}

static void _Z17SelectReleaseSendIiERN2FB9SELECTCTXEiR7ChannelIiE( struct $N2FB9SELECTCTXE* SC$1, int32 IDX$1, struct $7ChannelIiE* CH$1 )
{
	label$904:;
	struct $10ChanWaiterIiE* W$1;
	W$1 = *(struct $10ChanWaiterIiE**)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 8ll);
	if( *(int32**)((uint8*)W$1 + 48ll) == (int32*)0ull) goto label$907;
	{
		if( *(int32**)((uint8*)W$1 + 48ll) == (int32*)0ull) goto label$908;
		free( *(void**)((uint8*)W$1 + 48ll) );
		label$908:;
		label$907:;
	}
	if( W$1 == (struct $10ChanWaiterIiE*)0ull) goto label$909;
	free( (void*)W$1 );
	label$909:;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 8ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	label$905:;
}

static boolean _Z16SelectCommitSendIiERN2FB9SELECTCTXEiR7ChannelIiE( struct $N2FB9SELECTCTXE* SC$1, int32 IDX$1, struct $7ChannelIiE* CH$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$910:;
	struct $10ChanWaiterIiE* W$1;
	W$1 = *(struct $10ChanWaiterIiE**)((uint8*)((uint8*)SC$1 + ((int64)IDX$1 * 24ll)) + 8ll);
	boolean vr$5 = _Z20ChanCommitSendLockedIiER7ChannelIiEPi( CH$1, *(int32**)((uint8*)W$1 + 48ll) );
	fb$result$1 = vr$5;
	goto label$911;
	label$911:;
	return fb$result$1;
}

static void _Z15__fbspawnmake_5Iu7INTEGERES0_( int64 A0$1 )
{
	struct $16__fbspawnframe_5Iu7INTEGERE* TMP$218$1;
	label$912:;
	struct $16__fbspawnframe_5Iu7INTEGERE* F$1;
	void* vr$0 = calloc( 16ull, 1ull );
	TMP$218$1 = (struct $16__fbspawnframe_5Iu7INTEGERE*)vr$0;
	if( TMP$218$1 == (struct $16__fbspawnframe_5Iu7INTEGERE*)0ull) goto label$922;
	_ZN16__fbspawnframe_5Iu7INTEGEREC1Ev( TMP$218$1 );
	label$922:;
	F$1 = TMP$218$1;
	*(int64*)((uint8*)F$1 + 8ll) = A0$1;
	fb_Spawn( (tmp$1)&_ZN2FB15SPAWNTRAMPOLINEEPv, (void*)F$1 );
	label$913:;
}

static void _Z15__fbspawnmake_6Iu7INTEGERES0_( int64 A0$1 )
{
	struct $16__fbspawnframe_6Iu7INTEGERE* TMP$225$1;
	label$923:;
	struct $16__fbspawnframe_6Iu7INTEGERE* F$1;
	void* vr$0 = calloc( 16ull, 1ull );
	TMP$225$1 = (struct $16__fbspawnframe_6Iu7INTEGERE*)vr$0;
	if( TMP$225$1 == (struct $16__fbspawnframe_6Iu7INTEGERE*)0ull) goto label$933;
	_ZN16__fbspawnframe_6Iu7INTEGEREC1Ev( TMP$225$1 );
	label$933:;
	F$1 = TMP$225$1;
	*(int64*)((uint8*)F$1 + 8ll) = A0$1;
	fb_Spawn( (tmp$1)&_ZN2FB15SPAWNTRAMPOLINEEPv, (void*)F$1 );
	label$924:;
}

static void _ZN16__fbspawnframe_2IiE6INVOKEEv( struct $16__fbspawnframe_2IiE* THIS$1 )
{
	label$934:;
	TALLY( *(int32*)((uint8*)THIS$1 + 8ll) );
	label$935:;
}

static void _ZN16__fbspawnframe_3IiE6INVOKEEv( struct $16__fbspawnframe_3IiE* THIS$1 )
{
	label$936:;
	TALLY( *(int32*)((uint8*)THIS$1 + 8ll) );
	label$937:;
}

static void _ZN16__fbspawnframe_4Iu7INTEGERE6INVOKEEv( struct $16__fbspawnframe_4Iu7INTEGERE* THIS$1 )
{
	label$938:;
	NESTED( (int32)*(int64*)((uint8*)THIS$1 + 8ll) );
	label$939:;
}

static boolean _Z20ChanCommitRecvLockedIiER7ChannelIiEPi( struct $7ChannelIiE* CH$1, int32* DST$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$940:;
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)CH$1;
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) <= 0ll) goto label$943;
	{
		*DST$1 = *(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 16ll) << (2ll & 63ll)));
		*(int32*)((uint8*)S$1 + 16ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 16ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + -1ll);
		struct $N2FB14CHANWAITERCOREE* W$2;
		struct $N2FB14CHANWAITERCOREE* vr$25 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
		W$2 = vr$25;
		if( W$2 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$945;
		{
			*(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 20ll) << (2ll & 63ll))) = *(*(int32**)((uint8*)W$2 + 48ll));
			*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
			*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
			*(boolean*)((uint8*)W$2 + 9ll) = (boolean)0ll;
			fb_MutexUnlock( *(void**)S$1 );
			fb_Unpark( *(void**)W$2 );
			fb$result$1 = (boolean)1ll;
			goto label$941;
		}
		label$945:;
		label$944:;
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$941;
	}
	label$943:;
	label$942:;
	struct $N2FB14CHANWAITERCOREE* W2$1;
	struct $N2FB14CHANWAITERCOREE* vr$52 = _ZN2FB8HPOPSENDEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W2$1 = vr$52;
	if( W2$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$947;
	{
		*DST$1 = *(*(int32**)((uint8*)W2$1 + 48ll));
		*(boolean*)((uint8*)W2$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W2$1 );
		fb$result$1 = (boolean)1ll;
		goto label$941;
	}
	label$947:;
	label$946:;
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = (boolean)0ll;
	goto label$941;
	label$941:;
	return fb$result$1;
}

static boolean _Z20ChanCommitSendLockedIiER7ChannelIiEPi( struct $7ChannelIiE* CH$1, int32* SRC$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$948:;
	struct $9ChanStateIiE* S$1;
	S$1 = *(struct $9ChanStateIiE**)CH$1;
	if( *(boolean*)((uint8*)S$1 + 24ll) == (boolean)0ll) goto label$951;
	{
		fb_MutexUnlock( *(void**)S$1 );
		label$952:;
		void* vr$4 = fb_ErrorThrowEx( 1, 898, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5C" "channel.bi", (void*)0ull, (void*)0ull );
		goto *vr$4;
		label$953:;
		fb$result$1 = (boolean)0ll;
		goto label$949;
	}
	label$951:;
	label$950:;
	struct $N2FB14CHANWAITERCOREE* W$1;
	struct $N2FB14CHANWAITERCOREE* vr$7 = _ZN2FB8HPOPRECVEPNS_8CHANCOREE( (struct $N2FB8CHANCOREE*)S$1 );
	W$1 = vr$7;
	if( W$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$955;
	{
		*(*(int32**)((uint8*)W$1 + 48ll)) = *SRC$1;
		*(boolean*)((uint8*)W$1 + 9ll) = (boolean)0ll;
		fb_MutexUnlock( *(void**)S$1 );
		fb_Unpark( *(void**)W$1 );
		fb$result$1 = (boolean)1ll;
		goto label$949;
	}
	label$955:;
	label$954:;
	if( (int64)*(int32*)((uint8*)S$1 + 12ll) >= (int64)*(int32*)((uint8*)S$1 + 8ll)) goto label$957;
	{
		*(int32*)((uint8*)*(int32**)((uint8*)S$1 + 64ll) + ((int64)*(int32*)((uint8*)S$1 + 20ll) << (2ll & 63ll))) = *SRC$1;
		*(int32*)((uint8*)S$1 + 20ll) = (int32)(((int64)*(int32*)((uint8*)S$1 + 20ll) + 1ll) % (int64)*(int32*)((uint8*)S$1 + 8ll));
		*(int32*)((uint8*)S$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 12ll) + 1ll);
		fb_MutexUnlock( *(void**)S$1 );
		fb$result$1 = (boolean)1ll;
		goto label$949;
	}
	label$957:;
	label$956:;
	fb_MutexUnlock( *(void**)S$1 );
	fb$result$1 = (boolean)0ll;
	goto label$949;
	label$949:;
	return fb$result$1;
}

static void _ZN16__fbspawnframe_5Iu7INTEGERE6INVOKEEv( struct $16__fbspawnframe_5Iu7INTEGERE* THIS$1 )
{
	label$958:;
	FEEDER( (int32)*(int64*)((uint8*)THIS$1 + 8ll) );
	label$959:;
}

static void _ZN16__fbspawnframe_6Iu7INTEGERE6INVOKEEv( struct $16__fbspawnframe_6Iu7INTEGERE* THIS$1 )
{
	label$960:;
	FEEDER( (int32)*(int64*)((uint8*)THIS$1 + 8ll) );
	label$961:;
}

__attribute__(( constructor )) static void fb_ctor__sched( void )
{
	label$0:;
	label$1:;
}

static void _ZN2FB9HPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( struct $N2FB8CHANCOREE* S$1, struct $N2FB14CHANWAITERCOREE* W$1 )
{
	label$2:;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll) = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 40ll);
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 40ll) == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$5;
	{
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 40ll) + 24ll) = W$1;
	}
	goto label$4;
	label$5:;
	{
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 32ll) = W$1;
		label$4:;
	}
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 40ll) = W$1;
	label$3:;
}

static void _ZN2FB9HPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( struct $N2FB8CHANCOREE* S$1, struct $N2FB14CHANWAITERCOREE* W$1 )
{
	label$6:;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll) = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 56ll);
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 56ll) == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$9;
	{
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 56ll) + 24ll) = W$1;
	}
	goto label$8;
	label$9:;
	{
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 48ll) = W$1;
		label$8:;
	}
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 56ll) = W$1;
	label$7:;
}

static void _ZN2FB7HUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( struct $N2FB8CHANCOREE* S$1, struct $N2FB14CHANWAITERCOREE* W$1, boolean ISSEND$1 )
{
	label$10:;
	if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll) == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$13;
	{
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll) + 24ll) = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll);
		label$13:;
	}
	if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll) == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$15;
	{
		*(struct $N2FB14CHANWAITERCOREE**)((uint8*)*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll) + 16ll) = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll);
		label$15:;
	}
	if( ISSEND$1 == (boolean)0ll) goto label$17;
	{
		if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 32ll) != W$1) goto label$19;
		{
			*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 32ll) = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll);
			label$19:;
		}
		if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 40ll) != W$1) goto label$21;
		{
			*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 40ll) = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll);
			label$21:;
		}
	}
	goto label$16;
	label$17:;
	{
		if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 48ll) != W$1) goto label$23;
		{
			*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 48ll) = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll);
			label$23:;
		}
		if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 56ll) != W$1) goto label$25;
		{
			*(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 56ll) = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll);
			label$25:;
		}
	}
	label$16:;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 16ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	*(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll) = (struct $N2FB14CHANWAITERCOREE*)0ull;
	label$11:;
}

static boolean _ZN2FB6HCLAIMEPNS_14CHANWAITERCOREE( struct $N2FB14CHANWAITERCOREE* W$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$26:;
	boolean WON$1;
	fb_ClaimLock(  );
	if( *(boolean**)((uint8*)W$1 + 32ll) == (boolean*)0ull) goto label$29;
	{
		WON$1 = (boolean)(*(*(boolean**)((uint8*)W$1 + 32ll)) == (boolean)0ll);
		if( WON$1 == (boolean)0ll) goto label$31;
		{
			*(*(boolean**)((uint8*)W$1 + 32ll)) = (boolean)1ll;
			*(boolean*)((uint8*)W$1 + 8ll) = (boolean)1ll;
		}
		label$31:;
		label$30:;
	}
	goto label$28;
	label$29:;
	{
		WON$1 = (boolean)(*(boolean*)((uint8*)W$1 + 8ll) == (boolean)0ll);
		if( WON$1 == (boolean)0ll) goto label$33;
		{
			*(boolean*)((uint8*)W$1 + 8ll) = (boolean)1ll;
			label$33:;
		}
	}
	label$28:;
	fb_ClaimUnlock(  );
	fb$result$1 = WON$1;
	goto label$27;
	label$27:;
	return fb$result$1;
}

static struct $N2FB14CHANWAITERCOREE* _ZN2FB8HPOPSENDEPNS_8CHANCOREE( struct $N2FB8CHANCOREE* S$1 )
{
	struct $N2FB14CHANWAITERCOREE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$34:;
	struct $N2FB14CHANWAITERCOREE* W$1;
	W$1 = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 32ll);
	label$36:;
	if( W$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$37;
	{
		struct $N2FB14CHANWAITERCOREE* NXT$2;
		NXT$2 = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll);
		_ZN2FB7HUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( S$1, W$1, (boolean)1ll );
		boolean vr$3 = _ZN2FB6HCLAIMEPNS_14CHANWAITERCOREE( W$1 );
		if( vr$3 == (boolean)0ll) goto label$39;
		{
			fb$result$1 = W$1;
			goto label$35;
		}
		label$39:;
		label$38:;
		W$1 = NXT$2;
	}
	goto label$36;
	label$37:;
	fb$result$1 = (struct $N2FB14CHANWAITERCOREE*)0ull;
	goto label$35;
	label$35:;
	return fb$result$1;
}

static struct $N2FB14CHANWAITERCOREE* _ZN2FB8HPOPRECVEPNS_8CHANCOREE( struct $N2FB8CHANCOREE* S$1 )
{
	struct $N2FB14CHANWAITERCOREE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$40:;
	struct $N2FB14CHANWAITERCOREE* W$1;
	W$1 = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)S$1 + 48ll);
	label$42:;
	if( W$1 == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$43;
	{
		struct $N2FB14CHANWAITERCOREE* NXT$2;
		NXT$2 = *(struct $N2FB14CHANWAITERCOREE**)((uint8*)W$1 + 24ll);
		_ZN2FB7HUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( S$1, W$1, (boolean)0ll );
		boolean vr$3 = _ZN2FB6HCLAIMEPNS_14CHANWAITERCOREE( W$1 );
		if( vr$3 == (boolean)0ll) goto label$45;
		{
			fb$result$1 = W$1;
			goto label$41;
		}
		label$45:;
		label$44:;
		W$1 = NXT$2;
	}
	goto label$42;
	label$43:;
	fb$result$1 = (struct $N2FB14CHANWAITERCOREE*)0ull;
	goto label$41;
	label$41:;
	return fb$result$1;
}

static void _ZN2FB12CHANPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( struct $N2FB8CHANCOREE* C$1, struct $N2FB14CHANWAITERCOREE* W$1 )
{
	label$46:;
	_ZN2FB9HPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( C$1, W$1 );
	label$47:;
}

static void _ZN2FB12CHANPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( struct $N2FB8CHANCOREE* C$1, struct $N2FB14CHANWAITERCOREE* W$1 )
{
	label$48:;
	_ZN2FB9HPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( C$1, W$1 );
	label$49:;
}

static void _ZN2FB10CHANUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( struct $N2FB8CHANCOREE* C$1, struct $N2FB14CHANWAITERCOREE* W$1, boolean ISSEND$1 )
{
	label$50:;
	_ZN2FB7HUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( C$1, W$1, ISSEND$1 );
	label$51:;
}

static void _ZN2FB13HBLOCKFOREVEREv( void )
{
	label$52:;
	void* P$1;
	void* vr$0 = fb_ParkerSelf(  );
	P$1 = vr$0;
	label$54:;
	{
		fb_Park( P$1 );
	}
	label$56:;
	goto label$54;
	label$55:;
	label$53:;
}

static void _ZN2FB9SPAWNWORKC1Ev( struct $N2FB9SPAWNWORKE* THIS$1 )
{
	_ZN10fb_Object$C1Ev( (struct $10fb_Object$*)THIS$1 );
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN2FB9SPAWNWORKE + 16ll);
	label$57:;
	label$58:;
}

static void _ZN2FB9SPAWNWORKaSERKS0_( struct $N2FB9SPAWNWORKE* THIS$1, struct $N2FB9SPAWNWORKE* __FB_RHS__$1 )
{
	label$59:;
	label$60:;
}

static void _ZN2FB9SPAWNWORKD1Ev( struct $N2FB9SPAWNWORKE* THIS$1 )
{
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN2FB9SPAWNWORKE + 16ll);
	label$63:;
	label$64:;
}

static void _ZN2FB15SPAWNTRAMPOLINEEPv( void* P$1 )
{
	label$65:;
	if( P$1 != (void*)0ull) goto label$68;
	{
		goto label$66;
		label$68:;
	}
	struct $N2FB9SPAWNWORKE* W$1;
	W$1 = (struct $N2FB9SPAWNWORKE*)P$1;
	typedef void (*_ZN2FB5tmp$9Ev)( struct $N2FB9SPAWNWORKE* );
	(*(_ZN2FB5tmp$9Ev*)*(void***)W$1)( W$1 );
	if( W$1 == (struct $N2FB9SPAWNWORKE*)0ull) goto label$69;
	typedef void (*_ZN2FB6tmp$10Ev)( struct $N2FB9SPAWNWORKE* );
	(*(_ZN2FB6tmp$10Ev*)((uint8*)*(void***)W$1 + 8ll))( W$1 );
	free( (void*)W$1 );
	label$69:;
	label$66:;
}

static void _ZN2FB9WAITGROUPC1Ev( struct $N2FB9WAITGROUPE* THIS$1 )
{
	label$70:;
	__builtin_memset( (void**)THIS$1, 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 8ll), 0, 4ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 12ll), 0, 4ll );
	__builtin_memset( (struct $N2FB8WGWAITERE**)((uint8*)THIS$1 + 16ll), 0, 8ll );
	void* vr$8 = fb_MutexCreate(  );
	*(void**)THIS$1 = vr$8;
	*(int32*)((uint8*)THIS$1 + 8ll) = 0;
	*(int32*)((uint8*)THIS$1 + 12ll) = 0;
	*(struct $N2FB8WGWAITERE**)((uint8*)THIS$1 + 16ll) = (struct $N2FB8WGWAITERE*)0ull;
	label$71:;
}

static void _ZN2FB9WAITGROUPD1Ev( struct $N2FB9WAITGROUPE* THIS$1 )
{
	label$72:;
	fb_MutexLock( *(void**)THIS$1 );
	boolean HADWAITERS$1;
	HADWAITERS$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 12ll) > 0ll) != 0ll);
	fb_MutexUnlock( *(void**)THIS$1 );
	if( HADWAITERS$1 == (boolean)0ll) goto label$75;
	{
		label$76:;
		void* vr$6 = fb_ErrorThrowEx( 1, 91, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5Csync.bi", (void*)0ull, (void*)0ull );
		goto *vr$6;
		label$77:;
	}
	label$75:;
	label$74:;
	fb_MutexDestroy( *(void**)THIS$1 );
	*(void**)THIS$1 = (void*)0ull;
	label$73:;
}

static void _ZN2FB9WAITGROUP3ADDEi( struct $N2FB9WAITGROUPE* THIS$1, int32 DELTA$1 )
{
	int64 TMP$12$1;
	int64 TMP$13$1;
	label$78:;
	fb_MutexLock( *(void**)THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 8ll) != 0ll) goto label$80;
	TMP$12$1 = (int64)-((int64)*(int32*)((uint8*)THIS$1 + 12ll) > 0ll);
	goto label$968;
	label$80:;
	TMP$12$1 = 0ll;
	label$968:;
	if( TMP$12$1 == 0ll) goto label$81;
	TMP$13$1 = (int64)-((int64)DELTA$1 > 0ll);
	goto label$969;
	label$81:;
	TMP$13$1 = 0ll;
	label$969:;
	if( TMP$13$1 == 0ll) goto label$83;
	{
		fb_MutexUnlock( *(void**)THIS$1 );
		label$84:;
		void* vr$9 = fb_ErrorThrowEx( 1, 108, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5Csync.bi", (void*)0ull, (void*)0ull );
		goto *vr$9;
		label$85:;
		goto label$79;
	}
	label$83:;
	label$82:;
	*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) + (int64)DELTA$1);
	if( (int64)*(int32*)((uint8*)THIS$1 + 8ll) >= 0ll) goto label$87;
	{
		*(int32*)((uint8*)THIS$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 8ll) - (int64)DELTA$1);
		fb_MutexUnlock( *(void**)THIS$1 );
		label$88:;
		void* vr$25 = fb_ErrorThrowEx( 1, 117, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5Csync.bi", (void*)0ull, (void*)0ull );
		goto *vr$25;
		label$89:;
		goto label$79;
	}
	label$87:;
	label$86:;
	struct $N2FB8WGWAITERE* WOKEN$1;
	WOKEN$1 = (struct $N2FB8WGWAITERE*)0ull;
	if( (int64)*(int32*)((uint8*)THIS$1 + 8ll) != 0ll) goto label$91;
	{
		WOKEN$1 = *(struct $N2FB8WGWAITERE**)((uint8*)THIS$1 + 16ll);
		*(struct $N2FB8WGWAITERE**)((uint8*)THIS$1 + 16ll) = (struct $N2FB8WGWAITERE*)0ull;
	}
	label$91:;
	label$90:;
	fb_MutexUnlock( *(void**)THIS$1 );
	label$92:;
	if( WOKEN$1 == (struct $N2FB8WGWAITERE*)0ull) goto label$93;
	{
		struct $N2FB8WGWAITERE* NXT$2;
		NXT$2 = *(struct $N2FB8WGWAITERE**)((uint8*)WOKEN$1 + 8ll);
		fb_Unpark( *(void**)WOKEN$1 );
		WOKEN$1 = NXT$2;
	}
	goto label$92;
	label$93:;
	label$79:;
}

static void _ZN2FB9WAITGROUP4DONEEv( struct $N2FB9WAITGROUPE* THIS$1 )
{
	label$94:;
	_ZN2FB9WAITGROUP3ADDEi( THIS$1, -1 );
	label$95:;
}

static void _ZN2FB9WAITGROUP4WAITEv( struct $N2FB9WAITGROUPE* THIS$1 )
{
	label$96:;
	_ZN2FB9WAITGROUP5HWAITEbj( THIS$1, (boolean)1ll, 0u );
	label$97:;
}

static boolean _ZN2FB9WAITGROUP5HWAITEbj( struct $N2FB9WAITGROUPE* THIS$1, boolean FOREVER$1, uint32 MS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$100:;
	fb_MutexLock( *(void**)THIS$1 );
	if( (int64)*(int32*)((uint8*)THIS$1 + 8ll) != 0ll) goto label$103;
	{
		fb_MutexUnlock( *(void**)THIS$1 );
		fb$result$1 = (boolean)1ll;
		goto label$101;
	}
	label$103:;
	label$102:;
	struct $N2FB8WGWAITERE W$1;
	__builtin_memset( &W$1, 0, 16ll );
	void* vr$6 = fb_ParkerSelf(  );
	*(void**)&W$1 = vr$6;
	*(struct $N2FB8WGWAITERE**)((uint8*)&W$1 + 8ll) = *(struct $N2FB8WGWAITERE**)((uint8*)THIS$1 + 16ll);
	*(struct $N2FB8WGWAITERE**)((uint8*)THIS$1 + 16ll) = &W$1;
	*(int32*)((uint8*)THIS$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 12ll) + 1ll);
	fb_MutexUnlock( *(void**)THIS$1 );
	if( FOREVER$1 == (boolean)0ll) goto label$105;
	{
		label$106:;
		{
			fb_Park( *(void**)&W$1 );
			fb_MutexLock( *(void**)THIS$1 );
			boolean DONE_$3;
			DONE_$3 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) == 0ll) != 0ll);
			fb_MutexUnlock( *(void**)THIS$1 );
			if( DONE_$3 == (boolean)0ll) goto label$110;
			{
				goto label$107;
				label$110:;
			}
		}
		label$108:;
		goto label$106;
		label$107:;
	}
	goto label$104;
	label$105:;
	{
		fb_ParkTimed( *(void**)&W$1, MS$1 );
	}
	label$104:;
	fb_MutexLock( *(void**)THIS$1 );
	boolean OK$1;
	OK$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)THIS$1 + 8ll) == 0ll) != 0ll);
	*(int32*)((uint8*)THIS$1 + 12ll) = (int32)((int64)*(int32*)((uint8*)THIS$1 + 12ll) + -1ll);
	if( *(struct $N2FB8WGWAITERE**)((uint8*)THIS$1 + 16ll) != &W$1) goto label$112;
	{
		*(struct $N2FB8WGWAITERE**)((uint8*)THIS$1 + 16ll) = *(struct $N2FB8WGWAITERE**)((uint8*)&W$1 + 8ll);
	}
	goto label$111;
	label$112:;
	{
		struct $N2FB8WGWAITERE* P$2;
		P$2 = *(struct $N2FB8WGWAITERE**)((uint8*)THIS$1 + 16ll);
		label$113:;
		if( P$2 == (struct $N2FB8WGWAITERE*)0ull) goto label$114;
		{
			if( *(struct $N2FB8WGWAITERE**)((uint8*)P$2 + 8ll) != &W$1) goto label$116;
			{
				*(struct $N2FB8WGWAITERE**)((uint8*)P$2 + 8ll) = *(struct $N2FB8WGWAITERE**)((uint8*)&W$1 + 8ll);
				goto label$114;
			}
			label$116:;
			label$115:;
			P$2 = *(struct $N2FB8WGWAITERE**)((uint8*)P$2 + 8ll);
		}
		goto label$113;
		label$114:;
	}
	label$111:;
	fb_MutexUnlock( *(void**)THIS$1 );
	fb$result$1 = OK$1;
	goto label$101;
	label$101:;
	return fb$result$1;
}

static void _ZN2FB8CTXSTATEC1Ev( struct $N2FB8CTXSTATEE* THIS$1 )
{
	__builtin_memset( (void**)THIS$1, 0, 8ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 8ll), 0, 4ll );
	__builtin_memset( (boolean*)((uint8*)THIS$1 + 12ll), 0, 1ll );
	__builtin_memset( (boolean*)((uint8*)THIS$1 + 13ll), 0, 1ll );
	_ZN7ChannelIbEC1Ev( (struct $7ChannelIbE*)((uint8*)THIS$1 + 16ll) );
	__builtin_memset( (struct $N2FB8CTXSTATEE**)((uint8*)THIS$1 + 24ll), 0, 8ll );
	__builtin_memset( (struct $N2FB8CTXSTATEE**)((uint8*)THIS$1 + 32ll), 0, 512ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 544ll), 0, 4ll );
	__builtin_memset( (void**)((uint8*)THIS$1 + 552ll), 0, 8ll );
	label$119:;
	label$120:;
}

static void _ZN2FB8CTXSTATEaSERKS0_( struct $N2FB8CTXSTATEE* THIS$1, struct $N2FB8CTXSTATEE* __FB_RHS__$1 )
{
	int64 TMP$14$1;
	struct $N2FB8CTXSTATEE** TMP$15$1;
	struct $N2FB8CTXSTATEE** TMP$16$1;
	label$121:;
	*(void**)THIS$1 = *(void**)__FB_RHS__$1;
	*(int32*)((uint8*)THIS$1 + 8ll) = *(int32*)((uint8*)__FB_RHS__$1 + 8ll);
	*(boolean*)((uint8*)THIS$1 + 12ll) = *(boolean*)((uint8*)__FB_RHS__$1 + 12ll);
	*(boolean*)((uint8*)THIS$1 + 13ll) = *(boolean*)((uint8*)__FB_RHS__$1 + 13ll);
	_ZN7ChannelIbEaSERS0_( (struct $7ChannelIbE*)((uint8*)THIS$1 + 16ll), (struct $7ChannelIbE*)((uint8*)__FB_RHS__$1 + 16ll) );
	*(struct $N2FB8CTXSTATEE**)((uint8*)THIS$1 + 24ll) = *(struct $N2FB8CTXSTATEE**)((uint8*)__FB_RHS__$1 + 24ll);
	TMP$15$1 = (struct $N2FB8CTXSTATEE**)((uint8*)THIS$1 + 32ll);
	TMP$16$1 = (struct $N2FB8CTXSTATEE**)((uint8*)__FB_RHS__$1 + 32ll);
	TMP$14$1 = 0ll;
	label$123:;
	*TMP$15$1 = *TMP$16$1;
	TMP$15$1 = (struct $N2FB8CTXSTATEE**)((uint8*)TMP$15$1 + 8ll);
	TMP$16$1 = (struct $N2FB8CTXSTATEE**)((uint8*)TMP$16$1 + 8ll);
	TMP$14$1 = TMP$14$1 + 1ll;
	if( TMP$14$1 != 64ll) goto label$123;
	*(int32*)((uint8*)THIS$1 + 544ll) = *(int32*)((uint8*)__FB_RHS__$1 + 544ll);
	*(void**)((uint8*)THIS$1 + 552ll) = *(void**)((uint8*)__FB_RHS__$1 + 552ll);
	label$122:;
}

static void _ZN2FB8CTXSTATED1Ev( struct $N2FB8CTXSTATEE* THIS$1 )
{
	label$126:;
	label$127:;
	_ZN7ChannelIbED1Ev( (struct $7ChannelIbE*)((uint8*)THIS$1 + 16ll) );
}

static void _ZN2FB13CANCELCONTEXTC1Ev( struct $N2FB13CANCELCONTEXTE* THIS$1 )
{
	_ZN2FB7CONTEXTC1Ev( (struct $N2FB7CONTEXTE*)THIS$1 );
	label$128:;
	label$129:;
}

static void _ZN2FB13CANCELCONTEXTaSERKS0_( struct $N2FB13CANCELCONTEXTE* THIS$1, struct $N2FB13CANCELCONTEXTE* __FB_RHS__$1 )
{
	label$130:;
	_ZN2FB7CONTEXTaSERS0_( (struct $N2FB7CONTEXTE*)THIS$1, (struct $N2FB7CONTEXTE*)__FB_RHS__$1 );
	label$131:;
}

static void _ZN2FB13CANCELCONTEXTC1ERKS0_( struct $N2FB13CANCELCONTEXTE* THIS$1, struct $N2FB13CANCELCONTEXTE* __FB_RHS__$1 )
{
	label$132:;
	_ZN2FB7CONTEXTC1Ev( (struct $N2FB7CONTEXTE*)THIS$1 );
	_ZN2FB13CANCELCONTEXTaSERKS0_( THIS$1, __FB_RHS__$1 );
	label$133:;
}

static void _ZN2FB13CANCELCONTEXTD1Ev( struct $N2FB13CANCELCONTEXTE* THIS$1 )
{
	label$134:;
	label$135:;
	_ZN2FB7CONTEXTD1Ev( (struct $N2FB7CONTEXTE*)THIS$1 );
}

static void _ZN2FB11HCTXRELEASEEPNS_8CTXSTATEE( struct $N2FB8CTXSTATEE* S$1 )
{
	label$136:;
	if( S$1 != (struct $N2FB8CTXSTATEE*)0ull) goto label$139;
	{
		goto label$137;
		label$139:;
	}
	fb_MutexLock( *(void**)S$1 );
	*(int32*)((uint8*)S$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)S$1 + 8ll) + -1ll);
	boolean DEAD$1;
	DEAD$1 = (boolean)((int64)-((int64)*(int32*)((uint8*)S$1 + 8ll) == 0ll) != 0ll);
	fb_MutexUnlock( *(void**)S$1 );
	if( DEAD$1 != (boolean)0ll) goto label$141;
	{
		goto label$137;
		label$141:;
	}
	struct $N2FB8CTXSTATEE* P$1;
	P$1 = *(struct $N2FB8CTXSTATEE**)((uint8*)S$1 + 24ll);
	if( P$1 == (struct $N2FB8CTXSTATEE*)0ull) goto label$143;
	{
		fb_MutexLock( *(void**)P$1 );
		{
			int32 I$3;
			I$3 = 0;
			int32 TMP$17$3;
			TMP$17$3 = (int32)((int64)*(int32*)((uint8*)P$1 + 544ll) + -1ll);
			goto label$144;
			label$147:;
			{
				if( *(struct $N2FB8CTXSTATEE**)((uint8*)((uint8*)P$1 + ((int64)I$3 << (3ll & 63ll))) + 32ll) != S$1) goto label$149;
				{
					*(struct $N2FB8CTXSTATEE**)((uint8*)((uint8*)P$1 + ((int64)I$3 << (3ll & 63ll))) + 32ll) = *(struct $N2FB8CTXSTATEE**)((uint8*)((uint8*)P$1 + ((int64)*(int32*)((uint8*)P$1 + 544ll) << (3ll & 63ll))) + 24ll);
					*(int32*)((uint8*)P$1 + 544ll) = (int32)((int64)*(int32*)((uint8*)P$1 + 544ll) + -1ll);
					goto label$146;
				}
				label$149:;
				label$148:;
			}
			label$145:;
			I$3 = (int32)((int64)I$3 + 1ll);
			label$144:;
			if( (int64)I$3 <= (int64)TMP$17$3) goto label$147;
			label$146:;
		}
		fb_MutexUnlock( *(void**)P$1 );
		_ZN2FB11HCTXRELEASEEPNS_8CTXSTATEE( P$1 );
	}
	label$143:;
	label$142:;
	fb_MutexDestroy( *(void**)S$1 );
	if( S$1 == (struct $N2FB8CTXSTATEE*)0ull) goto label$150;
	_ZN2FB8CTXSTATED1Ev( S$1 );
	free( (void*)S$1 );
	label$150:;
	label$137:;
}

static void _ZN2FB10HCTXCANCELEPNS_8CTXSTATEEb( struct $N2FB8CTXSTATEE* S$1, boolean ISDEADLINE$1 )
{
	label$151:;
	if( S$1 != (struct $N2FB8CTXSTATEE*)0ull) goto label$154;
	{
		goto label$152;
		label$154:;
	}
	fb_MutexLock( *(void**)S$1 );
	if( *(boolean*)((uint8*)S$1 + 12ll) == (boolean)0ll) goto label$156;
	{
		fb_MutexUnlock( *(void**)S$1 );
		goto label$152;
	}
	label$156:;
	label$155:;
	*(boolean*)((uint8*)S$1 + 12ll) = (boolean)1ll;
	*(boolean*)((uint8*)S$1 + 13ll) = ISDEADLINE$1;
	struct $N2FB8CTXSTATEE* KIDS$1[64];
	__builtin_memset( (struct $N2FB8CTXSTATEE**)KIDS$1, 0, 512ll );
	struct $N2FB10FBARRAY1$1IPNS_8CTXSTATEEEE {
		struct $N2FB8CTXSTATEE** DATA;
		struct $N2FB8CTXSTATEE** PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N2FB10FBARRAY1$1IPNS_8CTXSTATEEEE ) == 72 );
	struct $N2FB10FBARRAY1$1IPNS_8CTXSTATEEEE tmp$18$1;
	*(struct $N2FB8CTXSTATEE***)&tmp$18$1 = (struct $N2FB8CTXSTATEE**)KIDS$1;
	*(struct $N2FB8CTXSTATEE***)((uint8*)&tmp$18$1 + 8ll) = (struct $N2FB8CTXSTATEE**)KIDS$1;
	*(int64*)((uint8*)&tmp$18$1 + 16ll) = 512ll;
	*(int64*)((uint8*)&tmp$18$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&tmp$18$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$18$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$18$1 + 48ll) = 64ll;
	*(int64*)((uint8*)&tmp$18$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$18$1 + 64ll) = 63ll;
	int32 NK$1;
	NK$1 = *(int32*)((uint8*)S$1 + 544ll);
	{
		int32 I$2;
		I$2 = 0;
		int32 TMP$19$2;
		TMP$19$2 = (int32)((int64)NK$1 + -1ll);
		goto label$157;
		label$160:;
		{
			*(struct $N2FB8CTXSTATEE**)((int64)(struct $N2FB8CTXSTATEE**)KIDS$1 + ((int64)I$2 << (3ll & 63ll))) = *(struct $N2FB8CTXSTATEE**)((uint8*)((uint8*)S$1 + ((int64)I$2 << (3ll & 63ll))) + 32ll);
			fb_MutexLock( *(void**)*(struct $N2FB8CTXSTATEE**)((int64)(struct $N2FB8CTXSTATEE**)KIDS$1 + ((int64)I$2 << (3ll & 63ll))) );
			*(int32*)((uint8*)*(struct $N2FB8CTXSTATEE**)((int64)(struct $N2FB8CTXSTATEE**)KIDS$1 + ((int64)I$2 << (3ll & 63ll))) + 8ll) = (int32)((int64)*(int32*)((uint8*)*(struct $N2FB8CTXSTATEE**)((int64)(struct $N2FB8CTXSTATEE**)KIDS$1 + ((int64)I$2 << (3ll & 63ll))) + 8ll) + 1ll);
			fb_MutexUnlock( *(void**)*(struct $N2FB8CTXSTATEE**)((int64)(struct $N2FB8CTXSTATEE**)KIDS$1 + ((int64)I$2 << (3ll & 63ll))) );
		}
		label$158:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$157:;
		if( (int64)I$2 <= (int64)TMP$19$2) goto label$160;
		label$159:;
	}
	void* TP$1;
	TP$1 = *(void**)((uint8*)S$1 + 552ll);
	fb_MutexUnlock( *(void**)S$1 );
	boolean vr$41 = _ZN7ChannelIbE5ISNILEv( (struct $7ChannelIbE*)((uint8*)S$1 + 16ll) );
	if( vr$41 != (boolean)0ll) goto label$162;
	{
		boolean vr$44 = _ZN7ChannelIbE8ISCLOSEDEv( (struct $7ChannelIbE*)((uint8*)S$1 + 16ll) );
		if( vr$44 != (boolean)0ll) goto label$164;
		{
			_ZN7ChannelIbE5CLOSEEv( (struct $7ChannelIbE*)((uint8*)S$1 + 16ll) );
		}
		label$164:;
		label$163:;
	}
	label$162:;
	label$161:;
	if( TP$1 == (void*)0ull) goto label$166;
	{
		fb_Unpark( TP$1 );
		label$166:;
	}
	{
		int32 I$2;
		I$2 = 0;
		int32 TMP$20$2;
		TMP$20$2 = (int32)((int64)NK$1 + -1ll);
		goto label$167;
		label$170:;
		{
			_ZN2FB10HCTXCANCELEPNS_8CTXSTATEEb( *(struct $N2FB8CTXSTATEE**)((int64)(struct $N2FB8CTXSTATEE**)KIDS$1 + ((int64)I$2 << (3ll & 63ll))), ISDEADLINE$1 );
			_ZN2FB11HCTXRELEASEEPNS_8CTXSTATEE( *(struct $N2FB8CTXSTATEE**)((int64)(struct $N2FB8CTXSTATEE**)KIDS$1 + ((int64)I$2 << (3ll & 63ll))) );
		}
		label$168:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$167:;
		if( (int64)I$2 <= (int64)TMP$20$2) goto label$170;
		label$169:;
	}
	label$152:;
}

static struct $N2FB8CTXSTATEE* _ZN2FB7HCTXNEWEPNS_8CTXSTATEE( struct $N2FB8CTXSTATEE* PARENT$1 )
{
	struct $N2FB8CTXSTATEE* TMP$21$1;
	struct $7ChannelIbE TMP$23$1;
	struct $N2FB8CTXSTATEE* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$171:;
	struct $N2FB8CTXSTATEE* S$1;
	void* vr$1 = calloc( 560ull, 1ull );
	TMP$21$1 = (struct $N2FB8CTXSTATEE*)vr$1;
	if( TMP$21$1 == (struct $N2FB8CTXSTATEE*)0ull) goto label$173;
	_ZN2FB8CTXSTATEC1Ev( TMP$21$1 );
	label$173:;
	S$1 = TMP$21$1;
	void* vr$2 = fb_MutexCreate(  );
	*(void**)S$1 = vr$2;
	*(int32*)((uint8*)S$1 + 8ll) = 1;
	*(boolean*)((uint8*)S$1 + 12ll) = (boolean)0ll;
	*(boolean*)((uint8*)S$1 + 13ll) = (boolean)0ll;
	_ZN7ChannelIbEC1Ei( &TMP$23$1, 1 );
	_ZN7ChannelIbEaSERS0_( (struct $7ChannelIbE*)((uint8*)S$1 + 16ll), &TMP$23$1 );
	_ZN7ChannelIbED1Ev( &TMP$23$1 );
	*(struct $N2FB8CTXSTATEE**)((uint8*)S$1 + 24ll) = PARENT$1;
	*(int32*)((uint8*)S$1 + 544ll) = 0;
	*(void**)((uint8*)S$1 + 552ll) = (void*)0ull;
	if( PARENT$1 == (struct $N2FB8CTXSTATEE*)0ull) goto label$175;
	{
		fb_MutexLock( *(void**)PARENT$1 );
		if( (int64)*(int32*)((uint8*)PARENT$1 + 544ll) < 64ll) goto label$177;
		{
			fb_MutexUnlock( *(void**)PARENT$1 );
			fb_MutexDestroy( *(void**)S$1 );
			if( S$1 == (struct $N2FB8CTXSTATEE*)0ull) goto label$178;
			_ZN2FB8CTXSTATED1Ev( S$1 );
			free( (void*)S$1 );
			label$178:;
			label$179:;
			void* vr$20 = fb_ErrorThrowEx( 1, 350, (char*)"C:\x5C" "dev\x5C" "fbc-modern\x5Ctoolchains\x5C" "fbc-modern-windows\x5Cinc\x5C" "fb\x5Csync.bi", (void*)0ull, (void*)0ull );
			goto *vr$20;
			label$180:;
			fb$result$1 = (struct $N2FB8CTXSTATEE*)0ull;
			goto label$172;
		}
		label$177:;
		label$176:;
		*(struct $N2FB8CTXSTATEE**)((uint8*)((uint8*)PARENT$1 + ((int64)*(int32*)((uint8*)PARENT$1 + 544ll) << (3ll & 63ll))) + 32ll) = S$1;
		*(int32*)((uint8*)PARENT$1 + 544ll) = (int32)((int64)*(int32*)((uint8*)PARENT$1 + 544ll) + 1ll);
		*(int32*)((uint8*)PARENT$1 + 8ll) = (int32)((int64)*(int32*)((uint8*)PARENT$1 + 8ll) + 1ll);
		boolean ALREADY$2;
		ALREADY$2 = *(boolean*)((uint8*)PARENT$1 + 12ll);
		fb_MutexUnlock( *(void**)PARENT$1 );
		if( ALREADY$2 == (boolean)0ll) goto label$182;
		{
			_ZN2FB10HCTXCANCELEPNS_8CTXSTATEEb( S$1, *(boolean*)((uint8*)PARENT$1 + 13ll) );
		}
		label$182:;
		label$181:;
	}
	label$175:;
	label$174:;
	fb$result$1 = S$1;
	goto label$172;
	label$172:;
	return fb$result$1;
}

static void _ZN2FB7CONTEXTC1Ev( struct $N2FB7CONTEXTE* THIS$1 )
{
	label$183:;
	__builtin_memset( (void**)THIS$1, 0, 8ll );
	*(void**)THIS$1 = (void*)0ull;
	label$184:;
}

static void _ZN2FB7CONTEXTD1Ev( struct $N2FB7CONTEXTE* THIS$1 )
{
	label$189:;
	_ZN2FB11HCTXRELEASEEPNS_8CTXSTATEE( *(struct $N2FB8CTXSTATEE**)THIS$1 );
	*(void**)THIS$1 = (void*)0ull;
	label$190:;
}

static void _ZN2FB7CONTEXTaSERS0_( struct $N2FB7CONTEXTE* THIS$1, struct $N2FB7CONTEXTE* RHS$1 )
{
	label$191:;
	if( *(void**)THIS$1 != *(void**)RHS$1) goto label$194;
	{
		goto label$192;
		label$194:;
	}
	_ZN2FB11HCTXRELEASEEPNS_8CTXSTATEE( *(struct $N2FB8CTXSTATEE**)THIS$1 );
	*(void**)THIS$1 = *(void**)RHS$1;
	if( *(void**)THIS$1 == (void*)0ull) goto label$196;
	{
		struct $N2FB8CTXSTATEE* S$2;
		S$2 = *(struct $N2FB8CTXSTATEE**)THIS$1;
		fb_MutexLock( *(void**)S$2 );
		*(int32*)((uint8*)S$2 + 8ll) = (int32)((int64)*(int32*)((uint8*)S$2 + 8ll) + 1ll);
		fb_MutexUnlock( *(void**)S$2 );
	}
	label$196:;
	label$195:;
	label$192:;
}

static void _ZN2FB13HCTXTIMERPROCEPv( void* P$1 )
{
	label$217:;
	struct $N2FB11CTXTIMERARGE* A$1;
	A$1 = (struct $N2FB11CTXTIMERARGE*)P$1;
	struct $N2FB8CTXSTATEE* S$1;
	S$1 = *(struct $N2FB8CTXSTATEE**)A$1;
	uint32 MS$1;
	MS$1 = *(uint32*)((uint8*)A$1 + 8ll);
	if( A$1 == (struct $N2FB11CTXTIMERARGE*)0ull) goto label$219;
	free( (void*)A$1 );
	label$219:;
	void* PARKER$1;
	void* vr$2 = fb_ParkerSelf(  );
	PARKER$1 = vr$2;
	fb_MutexLock( *(void**)S$1 );
	*(void**)((uint8*)S$1 + 552ll) = PARKER$1;
	boolean ALREADY$1;
	ALREADY$1 = *(boolean*)((uint8*)S$1 + 12ll);
	fb_MutexUnlock( *(void**)S$1 );
	if( ALREADY$1 != (boolean)0ll) goto label$221;
	{
		int32 vr$7 = fb_ParkTimed( PARKER$1, MS$1 );
		if( (int64)vr$7 != 0ll) goto label$223;
		{
			_ZN2FB10HCTXCANCELEPNS_8CTXSTATEEb( S$1, (boolean)1ll );
		}
		label$223:;
		label$222:;
	}
	label$221:;
	label$220:;
	fb_MutexLock( *(void**)S$1 );
	*(void**)((uint8*)S$1 + 552ll) = (void*)0ull;
	fb_MutexUnlock( *(void**)S$1 );
	_ZN2FB11HCTXRELEASEEPNS_8CTXSTATEE( S$1 );
	label$218:;
}

static void _ZN9ChanStateIbEC1Ev( struct $9ChanStateIbE* THIS$1 )
{
	__builtin_memset( (struct $N2FB8CHANCOREE*)THIS$1, 0, 64ll );
	*(boolean**)((uint8*)THIS$1 + 64ll) = (boolean*)0ull;
	*(boolean**)((uint8*)THIS$1 + 72ll) = (boolean*)0ull;
	*(int64*)((uint8*)THIS$1 + 80ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 88ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 96ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 104ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 112ll), 0, 24ll );
	label$243:;
	label$244:;
}

static void _ZN9ChanStateIbEaSERKS0_( struct $9ChanStateIbE* THIS$1, struct $9ChanStateIbE* __FB_RHS__$1 )
{
	boolean* TMP$32$1;
	boolean* TMP$33$1;
	boolean* TMP$34$1;
	label$245:;
	__builtin_memcpy( (struct $N2FB8CHANCOREE*)THIS$1, (struct $N2FB8CHANCOREE*)__FB_RHS__$1, 64 );
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)((uint8*)THIS$1 + 64ll), (struct $7FBARRAYIvE*)((uint8*)__FB_RHS__$1 + 64ll), 0, (void*)0ull, (void*)0ull );
	TMP$32$1 = *(boolean**)((uint8*)((uint8*)THIS$1 + 64ll) + 8ll);
	TMP$33$1 = *(boolean**)((uint8*)((uint8*)__FB_RHS__$1 + 64ll) + 8ll);
	TMP$34$1 = (boolean*)((uint8*)TMP$33$1 + *(uint64*)((uint8*)((uint8*)__FB_RHS__$1 + 64ll) + 16ll));
	label$247:;
	if( TMP$33$1 >= TMP$34$1) goto label$248;
	*TMP$32$1 = *TMP$33$1;
	TMP$32$1 = (boolean*)((uint8*)TMP$32$1 + 1ll);
	TMP$33$1 = (boolean*)((uint8*)TMP$33$1 + 1ll);
	goto label$247;
	label$248:;
	label$246:;
}

static void _ZN9ChanStateIbED1Ev( struct $9ChanStateIbE* THIS$1 )
{
	label$251:;
	label$252:;
	fb_ArrayErase( (struct $7FBARRAYIvE*)((uint8*)THIS$1 + 64ll) );
}

static void _ZN2FB9SELECTCTXC1Ev( struct $N2FB9SELECTCTXE* THIS$1 )
{
	label$414:;
	__builtin_memset( (struct $N2FB10SELECTCASEE*)THIS$1, 0, 768ll );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 768ll), 0, 4ll );
	__builtin_memset( (boolean*)((uint8*)THIS$1 + 772ll), 0, 1ll );
	__builtin_memset( (boolean*)((uint8*)THIS$1 + 773ll), 0, 1ll );
	__builtin_memset( (uint32*)((uint8*)THIS$1 + 776ll), 0, 4ll );
	__builtin_memset( (boolean*)((uint8*)THIS$1 + 780ll), 0, 1ll );
	__builtin_memset( (void**)((uint8*)THIS$1 + 784ll), 0, 8ll );
	__builtin_memset( (uint32*)((uint8*)THIS$1 + 792ll), 0, 4ll );
	__builtin_memset( (boolean*)((uint8*)THIS$1 + 796ll), 0, 1ll );
	*(int32*)((uint8*)THIS$1 + 768ll) = 0;
	*(boolean*)((uint8*)THIS$1 + 772ll) = (boolean)0ll;
	*(boolean*)((uint8*)THIS$1 + 773ll) = (boolean)0ll;
	*(uint32*)((uint8*)THIS$1 + 776ll) = 0u;
	*(boolean*)((uint8*)THIS$1 + 780ll) = (boolean)0ll;
	*(boolean*)((uint8*)THIS$1 + 796ll) = (boolean)0ll;
	void* vr$24 = fb_ParkerSelf(  );
	*(void**)((uint8*)THIS$1 + 784ll) = vr$24;
	void* vr$26 = fb_ParkerSelf(  );
	*(uint32*)((uint8*)THIS$1 + 792ll) = (uint32)((int64)(uint32)(uint64)vr$26 | 1ll);
	label$415:;
}

static void _ZN2FB9SELECTCTX10SETTIMEOUTEj( struct $N2FB9SELECTCTXE* THIS$1, uint32 MS$1 )
{
	label$416:;
	*(boolean*)((uint8*)THIS$1 + 773ll) = (boolean)1ll;
	*(uint32*)((uint8*)THIS$1 + 776ll) = MS$1;
	label$417:;
}

static void _ZN2FB9SELECTCTX7SETELSEEv( struct $N2FB9SELECTCTXE* THIS$1 )
{
	label$418:;
	*(boolean*)((uint8*)THIS$1 + 780ll) = (boolean)1ll;
	label$419:;
}

static boolean _ZN2FB9SELECTCTX11POLLEDREADYEv( struct $N2FB9SELECTCTXE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$420:;
	fb$result$1 = *(boolean*)((uint8*)THIS$1 + 796ll);
	goto label$421;
	label$421:;
	return fb$result$1;
}

static boolean _ZN2FB6HREADYEPNS_8CHANCOREEi( struct $N2FB8CHANCOREE* C$1, int32 KIND$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$422:;
	if( C$1 != (struct $N2FB8CHANCOREE*)0ull) goto label$425;
	{
		fb$result$1 = (boolean)0ll;
		goto label$423;
		label$425:;
	}
	if( (int64)KIND$1 != 0ll) goto label$427;
	{
		if( (int64)*(int32*)((uint8*)C$1 + 12ll) <= 0ll) goto label$429;
		{
			fb$result$1 = (boolean)1ll;
			goto label$423;
			label$429:;
		}
		if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)C$1 + 32ll) == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$431;
		{
			fb$result$1 = (boolean)1ll;
			goto label$423;
			label$431:;
		}
		if( *(boolean*)((uint8*)C$1 + 24ll) == (boolean)0ll) goto label$433;
		{
			fb$result$1 = (boolean)1ll;
			goto label$423;
			label$433:;
		}
		fb$result$1 = (boolean)0ll;
		goto label$423;
	}
	goto label$426;
	label$427:;
	{
		if( *(boolean*)((uint8*)C$1 + 24ll) == (boolean)0ll) goto label$435;
		{
			fb$result$1 = (boolean)1ll;
			goto label$423;
			label$435:;
		}
		if( *(struct $N2FB14CHANWAITERCOREE**)((uint8*)C$1 + 48ll) == (struct $N2FB14CHANWAITERCOREE*)0ull) goto label$437;
		{
			fb$result$1 = (boolean)1ll;
			goto label$423;
			label$437:;
		}
		if( (int64)*(int32*)((uint8*)C$1 + 12ll) >= (int64)*(int32*)((uint8*)C$1 + 8ll)) goto label$439;
		{
			fb$result$1 = (boolean)1ll;
			goto label$423;
			label$439:;
		}
		fb$result$1 = (boolean)0ll;
		goto label$423;
	}
	label$426:;
	label$423:;
	return fb$result$1;
}

static void _ZN2FB8HLOCKALLERNS_9SELECTCTXER7FBARRAYIPNS_8CHANCOREEERi( struct $N2FB9SELECTCTXE* SC$1, struct $7FBARRAYIPN2FB8CHANCOREEE* ORDER$1, int32* CNT$1 )
{
	label$440:;
	*CNT$1 = 0;
	{
		int32 I$2;
		I$2 = 0;
		int32 TMP$37$2;
		TMP$37$2 = (int32)((int64)*(int32*)((uint8*)SC$1 + 768ll) + -1ll);
		goto label$442;
		label$445:;
		{
			int64 TMP$39$3;
			struct $N2FB8CHANCOREE* C$3;
			C$3 = *(struct $N2FB8CHANCOREE**)((uint8*)SC$1 + ((int64)I$2 * 24ll));
			if( C$3 != (struct $N2FB8CHANCOREE*)0ull) goto label$447;
			{
				goto label$443;
				label$447:;
			}
			boolean DUP$3;
			DUP$3 = (boolean)0ll;
			{
				int32 J$4;
				J$4 = 0;
				int32 TMP$38$4;
				TMP$38$4 = (int32)((int64)*CNT$1 + -1ll);
				goto label$448;
				label$451:;
				{
					if( *(struct $N2FB8CHANCOREE**)(((int64)J$4 << (3ll & 63ll)) + *(int64*)ORDER$1) != C$3) goto label$453;
					{
						DUP$3 = (boolean)1ll;
						goto label$450;
						label$453:;
					}
				}
				label$449:;
				J$4 = (int32)((int64)J$4 + 1ll);
				label$448:;
				if( (int64)J$4 <= (int64)TMP$38$4) goto label$451;
				label$450:;
			}
			if( DUP$3 == (boolean)0ll) goto label$455;
			{
				goto label$443;
				label$455:;
			}
			int32 K$3;
			K$3 = *CNT$1;
			label$456:;
			if( (int64)K$3 <= 0ll) goto label$458;
			TMP$39$3 = (int64)-(*(uint64*)((uint8*)(((int64)K$3 << (3ll & 63ll)) + *(int64*)ORDER$1) + -8ll) > (uint64)C$3);
			goto label$970;
			label$458:;
			TMP$39$3 = 0ll;
			label$970:;
			if( TMP$39$3 == 0ll) goto label$457;
			{
				*(struct $N2FB8CHANCOREE**)(((int64)K$3 << (3ll & 63ll)) + *(int64*)ORDER$1) = *(struct $N2FB8CHANCOREE**)((uint8*)(((int64)K$3 << (3ll & 63ll)) + *(int64*)ORDER$1) + -8ll);
				K$3 = (int32)((int64)K$3 + -1ll);
			}
			goto label$456;
			label$457:;
			*(struct $N2FB8CHANCOREE**)(((int64)K$3 << (3ll & 63ll)) + *(int64*)ORDER$1) = C$3;
			*CNT$1 = (int32)((int64)*CNT$1 + 1ll);
		}
		label$443:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$442:;
		if( (int64)I$2 <= (int64)TMP$37$2) goto label$445;
		label$444:;
	}
	{
		int32 I$2;
		I$2 = 0;
		int32 TMP$40$2;
		TMP$40$2 = (int32)((int64)*CNT$1 + -1ll);
		goto label$459;
		label$462:;
		{
			fb_MutexLock( *(void**)*(struct $N2FB8CHANCOREE**)(((int64)I$2 << (3ll & 63ll)) + *(int64*)ORDER$1) );
		}
		label$460:;
		I$2 = (int32)((int64)I$2 + 1ll);
		label$459:;
		if( (int64)I$2 <= (int64)TMP$40$2) goto label$462;
		label$461:;
	}
	label$441:;
}

static void _ZN2FB13HUNLOCKALLBUTER7FBARRAYIPNS_8CHANCOREEEiS1_( struct $7FBARRAYIPN2FB8CHANCOREEE* ORDER$1, int32 CNT$1, struct $N2FB8CHANCOREE* KEEP$1 )
{
	label$463:;
	{
		int32 I$2;
		I$2 = (int32)((int64)CNT$1 + -1ll);
		goto label$465;
		label$468:;
		{
			if( *(struct $N2FB8CHANCOREE**)(((int64)I$2 << (3ll & 63ll)) + *(int64*)ORDER$1) == KEEP$1) goto label$470;
			{
				fb_MutexUnlock( *(void**)*(struct $N2FB8CHANCOREE**)(((int64)I$2 << (3ll & 63ll)) + *(int64*)ORDER$1) );
			}
			label$470:;
			label$469:;
		}
		label$466:;
		I$2 = (int32)((int64)I$2 + -1ll);
		label$465:;
		if( (int64)I$2 >= 0ll) goto label$468;
		label$467:;
	}
	label$464:;
}

static int32 _ZN2FB9SELECTRUNERNS_9SELECTCTXE( struct $N2FB9SELECTCTXE* SC$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$471:;
	struct $N2FB8CHANCOREE* ORDER$1[32];
	__builtin_memset( (struct $N2FB8CHANCOREE**)ORDER$1, 0, 256ll );
	struct $N2FB10FBARRAY1$2IPNS_8CHANCOREEEE {
		struct $N2FB8CHANCOREE** DATA;
		struct $N2FB8CHANCOREE** PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N2FB10FBARRAY1$2IPNS_8CHANCOREEEE ) == 72 );
	struct $N2FB10FBARRAY1$2IPNS_8CHANCOREEEE tmp$41$1;
	*(struct $N2FB8CHANCOREE***)&tmp$41$1 = (struct $N2FB8CHANCOREE**)ORDER$1;
	*(struct $N2FB8CHANCOREE***)((uint8*)&tmp$41$1 + 8ll) = (struct $N2FB8CHANCOREE**)ORDER$1;
	*(int64*)((uint8*)&tmp$41$1 + 16ll) = 256ll;
	*(int64*)((uint8*)&tmp$41$1 + 24ll) = 8ll;
	*(int64*)((uint8*)&tmp$41$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$41$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$41$1 + 48ll) = 32ll;
	*(int64*)((uint8*)&tmp$41$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$41$1 + 64ll) = 31ll;
	int32 CNT$1;
	label$473:;
	{
		_ZN2FB8HLOCKALLERNS_9SELECTCTXER7FBARRAYIPNS_8CHANCOREEERi( SC$1, (struct $7FBARRAYIPN2FB8CHANCOREEE*)&tmp$41$1, &CNT$1 );
		static uint32 SEEDSTATE$2;
		int32 START$2;
		START$2 = 0;
		if( (int64)*(int32*)((uint8*)SC$1 + 768ll) <= 1ll) goto label$477;
		{
			if( (int64)SEEDSTATE$2 != 0ll) goto label$479;
			{
				SEEDSTATE$2 = (uint32)((int64)(uint32)*(uint64*)((uint8*)SC$1 + 784ll) | 1ll);
			}
			label$479:;
			label$478:;
			SEEDSTATE$2 = (uint32)((int64)SEEDSTATE$2 ^ ((int64)SEEDSTATE$2 << (13ll & 63ll)));
			SEEDSTATE$2 = (uint32)((int64)SEEDSTATE$2 ^ ((int64)SEEDSTATE$2 >> (17ll & 63ll)));
			SEEDSTATE$2 = (uint32)((int64)SEEDSTATE$2 ^ ((int64)SEEDSTATE$2 << (5ll & 63ll)));
			START$2 = (int32)(uint64)(SEEDSTATE$2 % *(uint32*)((uint8*)SC$1 + 768ll));
		}
		label$477:;
		label$476:;
		{
			int32 K$3;
			K$3 = 0;
			int32 TMP$42$3;
			TMP$42$3 = (int32)((int64)*(int32*)((uint8*)SC$1 + 768ll) + -1ll);
			goto label$480;
			label$483:;
			{
				int32 I$4;
				I$4 = (int32)(((int64)START$2 + (int64)K$3) % (int64)*(int32*)((uint8*)SC$1 + 768ll));
				boolean vr$50 = _ZN2FB6HREADYEPNS_8CHANCOREEi( *(struct $N2FB8CHANCOREE**)((uint8*)SC$1 + ((int64)I$4 * 24ll)), *(int32*)((uint8*)((uint8*)SC$1 + ((int64)I$4 * 24ll)) + 16ll) );
				if( vr$50 == (boolean)0ll) goto label$485;
				{
					fb_ClaimLock(  );
					boolean WON$5;
					WON$5 = (boolean)(*(boolean*)((uint8*)SC$1 + 772ll) == (boolean)0ll);
					if( WON$5 == (boolean)0ll) goto label$487;
					{
						*(boolean*)((uint8*)SC$1 + 772ll) = (boolean)1ll;
						label$487:;
					}
					fb_ClaimUnlock(  );
					if( WON$5 != (boolean)0ll) goto label$489;
					{
						goto label$482;
					}
					label$489:;
					label$488:;
					_ZN2FB13HUNLOCKALLBUTER7FBARRAYIPNS_8CHANCOREEEiS1_( (struct $7FBARRAYIPN2FB8CHANCOREEE*)&tmp$41$1, CNT$1, *(struct $N2FB8CHANCOREE**)((uint8*)SC$1 + ((int64)I$4 * 24ll)) );
					*(boolean*)((uint8*)SC$1 + 796ll) = (boolean)1ll;
					fb$result$1 = I$4;
					goto label$472;
				}
				label$485:;
				label$484:;
			}
			label$481:;
			K$3 = (int32)((int64)K$3 + 1ll);
			label$480:;
			if( (int64)K$3 <= (int64)TMP$42$3) goto label$483;
			label$482:;
		}
		if( *(boolean*)((uint8*)SC$1 + 780ll) == (boolean)0ll) goto label$491;
		{
			_ZN2FB13HUNLOCKALLBUTER7FBARRAYIPNS_8CHANCOREEEiS1_( (struct $7FBARRAYIPN2FB8CHANCOREEE*)&tmp$41$1, CNT$1, (struct $N2FB8CHANCOREE*)0ull );
			fb$result$1 = -3;
			goto label$472;
		}
		label$491:;
		label$490:;
		{
			int32 I$3;
			I$3 = 0;
			int32 TMP$43$3;
			TMP$43$3 = (int32)((int64)*(int32*)((uint8*)SC$1 + 768ll) + -1ll);
			goto label$492;
			label$495:;
			{
				struct $N2FB8CHANCOREE* C$4;
				C$4 = *(struct $N2FB8CHANCOREE**)((uint8*)SC$1 + ((int64)I$3 * 24ll));
				if( C$4 != (struct $N2FB8CHANCOREE*)0ull) goto label$497;
				{
					goto label$493;
					label$497:;
				}
				if( (int64)*(int32*)((uint8*)((uint8*)SC$1 + ((int64)I$3 * 24ll)) + 16ll) != 0ll) goto label$499;
				{
					_ZN2FB12CHANPUSHRECVEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( C$4, *(struct $N2FB14CHANWAITERCOREE**)((uint8*)((uint8*)SC$1 + ((int64)I$3 * 24ll)) + 8ll) );
				}
				goto label$498;
				label$499:;
				{
					_ZN2FB12CHANPUSHSENDEPNS_8CHANCOREEPNS_14CHANWAITERCOREE( C$4, *(struct $N2FB14CHANWAITERCOREE**)((uint8*)((uint8*)SC$1 + ((int64)I$3 * 24ll)) + 8ll) );
				}
				label$498:;
				*(boolean*)((uint8*)((uint8*)SC$1 + ((int64)I$3 * 24ll)) + 20ll) = (boolean)1ll;
			}
			label$493:;
			I$3 = (int32)((int64)I$3 + 1ll);
			label$492:;
			if( (int64)I$3 <= (int64)TMP$43$3) goto label$495;
			label$494:;
		}
		_ZN2FB13HUNLOCKALLBUTER7FBARRAYIPNS_8CHANCOREEEiS1_( (struct $7FBARRAYIPN2FB8CHANCOREEE*)&tmp$41$1, CNT$1, (struct $N2FB8CHANCOREE*)0ull );
		boolean TIMEDOUT$2;
		TIMEDOUT$2 = (boolean)0ll;
		if( *(boolean*)((uint8*)SC$1 + 773ll) == (boolean)0ll) goto label$501;
		{
			int32 vr$95 = fb_ParkTimed( *(void**)((uint8*)SC$1 + 784ll), *(uint32*)((uint8*)SC$1 + 776ll) );
			TIMEDOUT$2 = (boolean)((int64)-((int64)vr$95 == 0ll) != 0ll);
		}
		goto label$500;
		label$501:;
		{
			fb_Park( *(void**)((uint8*)SC$1 + 784ll) );
		}
		label$500:;
		_ZN2FB8HLOCKALLERNS_9SELECTCTXER7FBARRAYIPNS_8CHANCOREEERi( SC$1, (struct $7FBARRAYIPN2FB8CHANCOREEE*)&tmp$41$1, &CNT$1 );
		int32 FIRED$2;
		FIRED$2 = -1;
		{
			int32 I$3;
			I$3 = 0;
			int32 TMP$44$3;
			TMP$44$3 = (int32)((int64)*(int32*)((uint8*)SC$1 + 768ll) + -1ll);
			goto label$502;
			label$505:;
			{
				struct $N2FB8CHANCOREE* C$4;
				C$4 = *(struct $N2FB8CHANCOREE**)((uint8*)SC$1 + ((int64)I$3 * 24ll));
				if( C$4 != (struct $N2FB8CHANCOREE*)0ull) goto label$507;
				{
					goto label$503;
					label$507:;
				}
				if( *(boolean*)((uint8*)*(struct $N2FB14CHANWAITERCOREE**)((uint8*)((uint8*)SC$1 + ((int64)I$3 * 24ll)) + 8ll) + 8ll) == (boolean)0ll) goto label$509;
				{
					FIRED$2 = I$3;
				}
				goto label$508;
				label$509:;
				if( *(boolean*)((uint8*)((uint8*)SC$1 + ((int64)I$3 * 24ll)) + 20ll) == (boolean)0ll) goto label$510;
				{
					_ZN2FB10CHANUNLINKEPNS_8CHANCOREEPNS_14CHANWAITERCOREEb( C$4, *(struct $N2FB14CHANWAITERCOREE**)((uint8*)((uint8*)SC$1 + ((int64)I$3 * 24ll)) + 8ll), (boolean)((int64)-((int64)*(int32*)((uint8*)((uint8*)SC$1 + ((int64)I$3 * 24ll)) + 16ll) == 1ll) != 0ll) );
				}
				label$510:;
				label$508:;
				*(boolean*)((uint8*)((uint8*)SC$1 + ((int64)I$3 * 24ll)) + 20ll) = (boolean)0ll;
			}
			label$503:;
			I$3 = (int32)((int64)I$3 + 1ll);
			label$502:;
			if( (int64)I$3 <= (int64)TMP$44$3) goto label$505;
			label$504:;
		}
		_ZN2FB13HUNLOCKALLBUTER7FBARRAYIPNS_8CHANCOREEEiS1_( (struct $7FBARRAYIPN2FB8CHANCOREEE*)&tmp$41$1, CNT$1, (struct $N2FB8CHANCOREE*)0ull );
		if( (int64)FIRED$2 < 0ll) goto label$512;
		{
			*(boolean*)((uint8*)SC$1 + 796ll) = (boolean)0ll;
			fb$result$1 = FIRED$2;
			goto label$472;
		}
		label$512:;
		label$511:;
		if( TIMEDOUT$2 == (boolean)0ll) goto label$514;
		{
			fb$result$1 = -2;
			goto label$472;
		}
		label$514:;
		label$513:;
	}
	label$475:;
	goto label$473;
	label$474:;
	label$472:;
	return fb$result$1;
}

static void _ZN9ChanStateIiEC1Ev( struct $9ChanStateIiE* THIS$1 )
{
	__builtin_memset( (struct $N2FB8CHANCOREE*)THIS$1, 0, 64ll );
	*(int32**)((uint8*)THIS$1 + 64ll) = (int32*)0ull;
	*(int32**)((uint8*)THIS$1 + 72ll) = (int32*)0ull;
	*(int64*)((uint8*)THIS$1 + 80ll) = 0ll;
	*(int64*)((uint8*)THIS$1 + 88ll) = 4ll;
	*(int64*)((uint8*)THIS$1 + 96ll) = 1ll;
	*(int64*)((uint8*)THIS$1 + 104ll) = 17ll;
	__builtin_memset( (void*)((uint8*)THIS$1 + 112ll), 0, 24ll );
	label$529:;
	label$530:;
}

static void _ZN9ChanStateIiEaSERKS0_( struct $9ChanStateIiE* THIS$1, struct $9ChanStateIiE* __FB_RHS__$1 )
{
	int32* TMP$45$1;
	int32* TMP$46$1;
	int32* TMP$47$1;
	label$531:;
	__builtin_memcpy( (struct $N2FB8CHANCOREE*)THIS$1, (struct $N2FB8CHANCOREE*)__FB_RHS__$1, 64 );
	fb_ArrayRedimTo( (struct $7FBARRAYIvE*)((uint8*)THIS$1 + 64ll), (struct $7FBARRAYIvE*)((uint8*)__FB_RHS__$1 + 64ll), 0, (void*)0ull, (void*)0ull );
	TMP$45$1 = *(int32**)((uint8*)((uint8*)THIS$1 + 64ll) + 8ll);
	TMP$46$1 = *(int32**)((uint8*)((uint8*)__FB_RHS__$1 + 64ll) + 8ll);
	TMP$47$1 = (int32*)((uint8*)TMP$46$1 + *(uint64*)((uint8*)((uint8*)__FB_RHS__$1 + 64ll) + 16ll));
	label$533:;
	if( TMP$46$1 >= TMP$47$1) goto label$534;
	*TMP$45$1 = *TMP$46$1;
	TMP$45$1 = (int32*)((uint8*)TMP$45$1 + 4ll);
	TMP$46$1 = (int32*)((uint8*)TMP$46$1 + 4ll);
	goto label$533;
	label$534:;
	label$532:;
}

static void _ZN9ChanStateIiED1Ev( struct $9ChanStateIiE* THIS$1 )
{
	label$537:;
	label$538:;
	fb_ArrayErase( (struct $7FBARRAYIvE*)((uint8*)THIS$1 + 64ll) );
}

static void TALLY( int32 N$1 )
{
	label$700:;
	_ZN7ChannelIiE4SENDERi( &G_OUT$, &N$1 );
	_ZN2FB9WAITGROUP4DONEEv( &G_WG$ );
	label$701:;
}

static void NESTED( int32 DEPTH$1 )
{
	label$702:;
	if( (int64)DEPTH$1 <= 0ll) goto label$705;
	{
		_ZN2FB9WAITGROUP3ADDEi( &G_WG$, 1 );
		_Z15__fbspawnmake_1Iu7INTEGERES0_( (int64)DEPTH$1 + -1ll );
	}
	label$705:;
	label$704:;
	_ZN7ChannelIiE4SENDERi( &G_OUT$, &DEPTH$1 );
	_ZN2FB9WAITGROUP4DONEEv( &G_WG$ );
	label$703:;
}

static void _ZN16__fbspawnframe_1Iu7INTEGEREC1Ev( struct $16__fbspawnframe_1Iu7INTEGERE* THIS$1 )
{
	_ZN2FB9SPAWNWORKC1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_1Iu7INTEGEREE + 16ll);
	label$708:;
	label$709:;
}

static void _ZN16__fbspawnframe_1Iu7INTEGEREaSERKS1_( struct $16__fbspawnframe_1Iu7INTEGERE* THIS$1, struct $16__fbspawnframe_1Iu7INTEGERE* __FB_RHS__$1 )
{
	label$710:;
	_ZN2FB9SPAWNWORKaSERKS0_( (struct $N2FB9SPAWNWORKE*)THIS$1, (struct $N2FB9SPAWNWORKE*)__FB_RHS__$1 );
	*(int64*)((uint8*)THIS$1 + 8ll) = *(int64*)((uint8*)__FB_RHS__$1 + 8ll);
	label$711:;
}

static void _ZN16__fbspawnframe_1Iu7INTEGERED1Ev( struct $16__fbspawnframe_1Iu7INTEGERE* THIS$1 )
{
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_1Iu7INTEGEREE + 16ll);
	label$714:;
	label$715:;
	_ZN2FB9SPAWNWORKD1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
}

static void FEEDER( int32 WHICH_$1 )
{
	label$719:;
	fb_SleepEx( 80, 1 );
	if( (int64)WHICH_$1 != 0ll) goto label$722;
	{
		int32 TMP$57$2;
		TMP$57$2 = 10;
		_ZN7ChannelIiE4SENDERi( &G_A$, &TMP$57$2 );
	}
	goto label$721;
	label$722:;
	{
		int32 TMP$58$2;
		TMP$58$2 = 20;
		_ZN7ChannelIiE4SENDERi( &G_B$, &TMP$58$2 );
		label$721:;
	}
	_ZN2FB9WAITGROUP4DONEEv( &G_WG$ );
	label$720:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED39WORKERCOUNT_IS_POSITIVE_AND_STABLE_CTOREv( void )
{
	label$733:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.concurrency.sched", (char*)"workercount_is_positive_and_stable", (tmp$5)&_ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED34WORKERCOUNT_IS_POSITIVE_AND_STABLEEv, (boolean)0ll );
	label$734:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED37GOROUTINECOUNT_RISES_AND_RETURNS_CTOREv( void )
{
	label$755:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.concurrency.sched", (char*)"goroutinecount_rises_and_returns", (tmp$5)&_ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED32GOROUTINECOUNT_RISES_AND_RETURNSEv, (boolean)0ll );
	label$756:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED36GOROUTINES_MAY_SPAWN_GOROUTINES_CTOREv( void )
{
	label$763:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.concurrency.sched", (char*)"goroutines_may_spawn_goroutines", (tmp$5)&_ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED31GOROUTINES_MAY_SPAWN_GOROUTINESEv, (boolean)0ll );
	label$764:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED29SELECT_ELSE_NEVER_BLOCKS_CTOREv( void )
{
	label$782:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.concurrency.sched", (char*)"select_else_never_blocks", (tmp$5)&_ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED24SELECT_ELSE_NEVER_BLOCKSEv, (boolean)0ll );
	label$783:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED38SELECT_TIMEOUT_IS_THE_LAST_RESORT_CTOREv( void )
{
	label$796:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.concurrency.sched", (char*)"select_timeout_is_the_last_resort", (tmp$5)&_ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED33SELECT_TIMEOUT_IS_THE_LAST_RESORTEv, (boolean)0ll );
	label$797:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED32SELECT_NIL_CASE_IS_DISABLED_CTOREv( void )
{
	label$813:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.concurrency.sched", (char*)"select_nil_case_is_disabled", (tmp$5)&_ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED27SELECT_NIL_CASE_IS_DISABLEDEv, (boolean)0ll );
	label$814:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED39SELECT_PARKS_UNTIL_A_CASE_IS_READY_CTOREv( void )
{
	label$833:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.concurrency.sched", (char*)"select_parks_until_a_case_is_ready", (tmp$5)&_ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED34SELECT_PARKS_UNTIL_A_CASE_IS_READYEv, (boolean)0ll );
	label$834:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED42SELECT_SEES_A_CLOSED_CHANNEL_AS_READY_CTOREv( void )
{
	label$842:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.concurrency.sched", (char*)"select_sees_a_closed_channel_as_ready", (tmp$5)&_ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED37SELECT_SEES_A_CLOSED_CHANNEL_AS_READYEv, (boolean)0ll );
	label$843:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11CONCURRENCY5SCHED13SUITE_CTOR305Ev( void )
{
	label$844:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.concurrency.sched", (tmp$4)0ull, (tmp$4)0ull );
	label$845:;
}

static void _ZN16__fbspawnframe_2IiEC1Ev( struct $16__fbspawnframe_2IiE* THIS$1 )
{
	_ZN2FB9SPAWNWORKC1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 8ll), 0, 4ll );
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_2IiEE + 16ll);
	label$848:;
	label$849:;
}

static void _ZN16__fbspawnframe_2IiEaSERKS0_( struct $16__fbspawnframe_2IiE* THIS$1, struct $16__fbspawnframe_2IiE* __FB_RHS__$1 )
{
	label$850:;
	_ZN2FB9SPAWNWORKaSERKS0_( (struct $N2FB9SPAWNWORKE*)THIS$1, (struct $N2FB9SPAWNWORKE*)__FB_RHS__$1 );
	*(int32*)((uint8*)THIS$1 + 8ll) = *(int32*)((uint8*)__FB_RHS__$1 + 8ll);
	label$851:;
}

static void _ZN16__fbspawnframe_2IiED1Ev( struct $16__fbspawnframe_2IiE* THIS$1 )
{
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_2IiEE + 16ll);
	label$854:;
	label$855:;
	_ZN2FB9SPAWNWORKD1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
}

static void _ZN16__fbspawnframe_3IiEC1Ev( struct $16__fbspawnframe_3IiE* THIS$1 )
{
	_ZN2FB9SPAWNWORKC1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
	__builtin_memset( (int32*)((uint8*)THIS$1 + 8ll), 0, 4ll );
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_3IiEE + 16ll);
	label$859:;
	label$860:;
}

static void _ZN16__fbspawnframe_3IiEaSERKS0_( struct $16__fbspawnframe_3IiE* THIS$1, struct $16__fbspawnframe_3IiE* __FB_RHS__$1 )
{
	label$861:;
	_ZN2FB9SPAWNWORKaSERKS0_( (struct $N2FB9SPAWNWORKE*)THIS$1, (struct $N2FB9SPAWNWORKE*)__FB_RHS__$1 );
	*(int32*)((uint8*)THIS$1 + 8ll) = *(int32*)((uint8*)__FB_RHS__$1 + 8ll);
	label$862:;
}

static void _ZN16__fbspawnframe_3IiED1Ev( struct $16__fbspawnframe_3IiE* THIS$1 )
{
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_3IiEE + 16ll);
	label$865:;
	label$866:;
	_ZN2FB9SPAWNWORKD1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
}

static void _ZN16__fbspawnframe_4Iu7INTEGEREC1Ev( struct $16__fbspawnframe_4Iu7INTEGERE* THIS$1 )
{
	_ZN2FB9SPAWNWORKC1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_4Iu7INTEGEREE + 16ll);
	label$870:;
	label$871:;
}

static void _ZN16__fbspawnframe_4Iu7INTEGEREaSERKS1_( struct $16__fbspawnframe_4Iu7INTEGERE* THIS$1, struct $16__fbspawnframe_4Iu7INTEGERE* __FB_RHS__$1 )
{
	label$872:;
	_ZN2FB9SPAWNWORKaSERKS0_( (struct $N2FB9SPAWNWORKE*)THIS$1, (struct $N2FB9SPAWNWORKE*)__FB_RHS__$1 );
	*(int64*)((uint8*)THIS$1 + 8ll) = *(int64*)((uint8*)__FB_RHS__$1 + 8ll);
	label$873:;
}

static void _ZN16__fbspawnframe_4Iu7INTEGERED1Ev( struct $16__fbspawnframe_4Iu7INTEGERE* THIS$1 )
{
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_4Iu7INTEGEREE + 16ll);
	label$876:;
	label$877:;
	_ZN2FB9SPAWNWORKD1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
}

static void _ZN16__fbspawnframe_5Iu7INTEGEREC1Ev( struct $16__fbspawnframe_5Iu7INTEGERE* THIS$1 )
{
	_ZN2FB9SPAWNWORKC1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_5Iu7INTEGEREE + 16ll);
	label$914:;
	label$915:;
}

static void _ZN16__fbspawnframe_5Iu7INTEGEREaSERKS1_( struct $16__fbspawnframe_5Iu7INTEGERE* THIS$1, struct $16__fbspawnframe_5Iu7INTEGERE* __FB_RHS__$1 )
{
	label$916:;
	_ZN2FB9SPAWNWORKaSERKS0_( (struct $N2FB9SPAWNWORKE*)THIS$1, (struct $N2FB9SPAWNWORKE*)__FB_RHS__$1 );
	*(int64*)((uint8*)THIS$1 + 8ll) = *(int64*)((uint8*)__FB_RHS__$1 + 8ll);
	label$917:;
}

static void _ZN16__fbspawnframe_5Iu7INTEGERED1Ev( struct $16__fbspawnframe_5Iu7INTEGERE* THIS$1 )
{
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_5Iu7INTEGEREE + 16ll);
	label$920:;
	label$921:;
	_ZN2FB9SPAWNWORKD1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
}

static void _ZN16__fbspawnframe_6Iu7INTEGEREC1Ev( struct $16__fbspawnframe_6Iu7INTEGERE* THIS$1 )
{
	_ZN2FB9SPAWNWORKC1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_6Iu7INTEGEREE + 16ll);
	label$925:;
	label$926:;
}

static void _ZN16__fbspawnframe_6Iu7INTEGEREaSERKS1_( struct $16__fbspawnframe_6Iu7INTEGERE* THIS$1, struct $16__fbspawnframe_6Iu7INTEGERE* __FB_RHS__$1 )
{
	label$927:;
	_ZN2FB9SPAWNWORKaSERKS0_( (struct $N2FB9SPAWNWORKE*)THIS$1, (struct $N2FB9SPAWNWORKE*)__FB_RHS__$1 );
	*(int64*)((uint8*)THIS$1 + 8ll) = *(int64*)((uint8*)__FB_RHS__$1 + 8ll);
	label$928:;
}

static void _ZN16__fbspawnframe_6Iu7INTEGERED1Ev( struct $16__fbspawnframe_6Iu7INTEGERE* THIS$1 )
{
	*(void**)THIS$1 = (void*)((uint8*)_ZTVN16__fbspawnframe_6Iu7INTEGEREE + 16ll);
	label$931:;
	label$932:;
	_ZN2FB9SPAWNWORKD1Ev( (struct $N2FB9SPAWNWORKE*)THIS$1 );
}

__attribute__(( constructor )) static void _GLOBAL__I( void )
{
	label$963:;
	_ZN2FB9WAITGROUPC1Ev( &G_WG$ );
	_ZN7ChannelIiEC1Ev( &G_OUT$ );
	_ZN7ChannelIiEC1Ev( &G_A$ );
	_ZN7ChannelIiEC1Ev( &G_B$ );
	label$964:;
}

__attribute__(( destructor )) static void _GLOBAL__D( void )
{
	label$966:;
	_ZN7ChannelIiED1Ev( &G_B$ );
	_ZN7ChannelIiED1Ev( &G_A$ );
	_ZN7ChannelIiED1Ev( &G_OUT$ );
	_ZN2FB9WAITGROUPD1Ev( &G_WG$ );
	label$967:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
