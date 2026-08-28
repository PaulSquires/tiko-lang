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
struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1E {
	int64 I;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1E ) == 8 );
struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2E {
	struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1E BASE$;
	int64 J;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2E ) == 16 );
struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E {
	struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2E BASE$;
	int64 K;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E ) == 24 );
struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4E {
	struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E BASE$;
	int64 L;
};
__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4E ) == 32 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
static void fb_ctor__udtzupcastz4( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1D1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1E* );
void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2D1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2E* );
void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3D1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E* );
void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4D1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4E* );
void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411RESET_COUNTEv( void );
void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_47DEFAULTEv( void );
static void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_412DEFAULT_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_412SUITE_CTOR89Ev( void ) __attribute__(( constructor ));
static int64 _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT1$E = 0ll;
static int64 _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT2$E = 0ll;
static int64 _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT3$E = 0ll;
static int64 _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT4$E = 0ll;

void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411RESET_COUNTEv( void )
{
	label$2:;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT1$E = 0ll;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT2$E = 0ll;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT3$E = 0ll;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT4$E = 0ll;
	label$3:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1D1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1E* THIS$1 )
{
	label$4:;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT1$E = _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT1$E + 1ll;
	label$5:;
}

void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2D1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2E* THIS$1 )
{
	label$6:;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT2$E = _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT2$E + 1ll;
	label$7:;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1D1Ev( (struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1E*)THIS$1 );
}

void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3D1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E* THIS$1 )
{
	label$8:;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT3$E = _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT3$E + 1ll;
	label$9:;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2D1Ev( (struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2E*)THIS$1 );
}

void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4D1Ev( struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4E* THIS$1 )
{
	label$10:;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT4$E = _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT4$E + 1ll;
	label$11:;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3D1Ev( (struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E*)THIS$1 );
}

void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_47DEFAULTEv( void )
{
	label$12:;
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411RESET_COUNTEv(  );
	{
		struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4E X4$2;
		*(int64*)&X4$2 = 1ll;
		*(int64*)((uint8*)&X4$2 + 8ll) = 2ll;
		*(int64*)((uint8*)&X4$2 + 16ll) = 3ll;
		*(int64*)((uint8*)&X4$2 + 24ll) = 4ll;
		_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4D1Ev( &X4$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT1$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 51, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount1,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT2$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 51, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount2,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT3$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 51, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount3,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT4$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 51, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount4,1)" );
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411RESET_COUNTEv(  );
	{
		struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E U3$2;
		*(int64*)&U3$2 = 1ll;
		*(int64*)((uint8*)&U3$2 + 8ll) = 2ll;
		*(int64*)((uint8*)&U3$2 + 16ll) = 3ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&U3$2 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 56, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u3.i,1)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U3$2 + 8ll) == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 57, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u3.j,2)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U3$2 + 16ll) == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 58, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u3.k,3)" );
		_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3D1Ev( &U3$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT1$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 60, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount1,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT2$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 60, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount2,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT3$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 60, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount3,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT4$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 60, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount4,0)" );
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411RESET_COUNTEv(  );
	{
		struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E U3$2;
		*(int64*)&U3$2 = 1ll;
		*(int64*)((uint8*)&U3$2 + 8ll) = 2ll;
		*(int64*)((uint8*)&U3$2 + 16ll) = 3ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&U3$2 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 65, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u3.i,1)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U3$2 + 8ll) == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 66, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u3.j,2)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U3$2 + 16ll) == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 67, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u3.k,3)" );
		_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3D1Ev( &U3$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT1$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 69, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount1,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT2$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 69, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount2,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT3$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 69, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount3,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT4$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 69, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount4,0)" );
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411RESET_COUNTEv(  );
	{
		struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E U3$2;
		*(int64*)&U3$2 = 1ll;
		*(int64*)((uint8*)&U3$2 + 8ll) = 2ll;
		*(int64*)((uint8*)&U3$2 + 16ll) = 3ll;
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&U3$2 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 74, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u3.i,1)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U3$2 + 8ll) == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 75, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u3.j,2)" );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)((uint8*)&U3$2 + 16ll) == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 76, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u3.k,3)" );
		_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3D1Ev( &U3$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT1$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 78, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount1,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT2$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 78, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount2,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT3$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 78, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount3,1)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT4$E == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 78, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount4,0)" );
	_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411RESET_COUNTEv(  );
	{
		struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2E TMP$63$2;
		struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3E TMP$64$2;
		struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4E TMP$65$2;
		*(int64*)&TMP$65$2 = 1ll;
		*(int64*)((uint8*)&TMP$65$2 + 8ll) = 2ll;
		*(int64*)((uint8*)&TMP$65$2 + 16ll) = 3ll;
		*(int64*)((uint8*)&TMP$65$2 + 24ll) = 4ll;
		__builtin_memcpy( &TMP$64$2, &TMP$65$2, 24 );
		__builtin_memcpy( &TMP$63$2, &TMP$64$2, 16 );
		struct $N5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1E U1$2;
		__builtin_memcpy( &U1$2, &TMP$63$2, 8 );
		_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T4D1Ev( &TMP$65$2 );
		_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T3D1Ev( &TMP$64$2 );
		_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T2D1Ev( &TMP$63$2 );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(*(int64*)&U1$2 == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 83, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(u1.i,1)" );
		_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_42T1D1Ev( &U1$2 );
	}
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT1$E == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 85, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount1,4)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT2$E == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 85, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount2,3)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT3$E == 2ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 85, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount3,2)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_411DTORCOUNT4$E == 1ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cstructs\x5Cudt-upcast-4.bas", 85, (char*)"TESTS.FBC_TESTS.STRUCTS.UDT_UPCAST_4.DEFAULT", (char*)"CU_ASSERT_EQUAL(dtorcount4,1)" );
	label$13:;
}

__attribute__(( constructor )) static void fb_ctor__udtzupcastz4( void )
{
	label$0:;
	label$1:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_412DEFAULT_CTOREv( void )
{
	label$14:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.structs.udt_upcast_4", (char*)"default", (tmp$5)&_ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_47DEFAULTEv, (boolean)0ll );
	label$15:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7STRUCTS12UDT_UPCAST_412SUITE_CTOR89Ev( void )
{
	label$16:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.structs.udt_upcast_4", (tmp$4)0ull, (tmp$4)0ull );
	label$17:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
