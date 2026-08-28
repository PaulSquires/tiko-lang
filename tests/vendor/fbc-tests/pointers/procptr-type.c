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
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
int32 fb_StrCompare( void*, int64, void*, int64 );
static void fb_ctor__procptrztype( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _Z1Sv( void );
void _Z1Sa( int8 );
void _Z1Ss( int16 );
void _Z1Si( int32 );
void _Z1Sx( int64 );
void _Z1Sf( float );
void _Z1Sd( double );
void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE4SUBSEv( void );
static void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE9SUBS_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE5TYPESEv( void );
static void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE10TYPES_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE13SUITE_CTOR117Ev( void ) __attribute__(( constructor ));
static FBSTRING ID$;

void _Z1Sv( void )
{
	label$2:;
	fb_StrAssign( (void*)&ID$, -1ll, (void*)"s()", 4ll, 0 );
	label$3:;
}

void _Z1Sa( int8 ARG$1 )
{
	label$4:;
	fb_StrAssign( (void*)&ID$, -1ll, (void*)"s( byval arg as byte )", 23ll, 0 );
	label$5:;
}

void _Z1Ss( int16 ARG$1 )
{
	label$6:;
	fb_StrAssign( (void*)&ID$, -1ll, (void*)"s( byval arg as short )", 24ll, 0 );
	label$7:;
}

void _Z1Si( int32 ARG$1 )
{
	label$8:;
	fb_StrAssign( (void*)&ID$, -1ll, (void*)"s( byval arg as long )", 23ll, 0 );
	label$9:;
}

void _Z1Sx( int64 ARG$1 )
{
	label$10:;
	fb_StrAssign( (void*)&ID$, -1ll, (void*)"s( byval arg as longint )", 26ll, 0 );
	label$11:;
}

void _Z1Sf( float ARG$1 )
{
	label$12:;
	fb_StrAssign( (void*)&ID$, -1ll, (void*)"s( byval arg as single )", 25ll, 0 );
	label$13:;
}

void _Z1Sd( double ARG$1 )
{
	label$14:;
	fb_StrAssign( (void*)&ID$, -1ll, (void*)"s( byval arg as double )", 25ll, 0 );
	label$15:;
}

void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE4SUBSEv( void )
{
	label$16:;
	{
		typedef void (*_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$15Ev)( void );
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$15Ev P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$15Ev)&_Z1Sv;
		(P1$2)(  );
		int32 vr$0 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s()", 4ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$0 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 41, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.SUBS", (char*)"CU_ASSERT(id = \x22s()\x22)" );
	}
	{
		typedef void (*_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$23Ev)( void );
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$23Ev P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$23Ev)&_Z1Sv;
		(P1$2)(  );
		int32 vr$4 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s()", 4ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$4 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 47, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.SUBS", (char*)"CU_ASSERT(id = \x22s()\x22)" );
	}
	{
		typedef void (*_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$24Ea)( int8 );
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$24Ea P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$24Ea)&_Z1Sa;
		(P1$2)( (int8)0 );
		int32 vr$8 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as byte )", 23ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$8 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 53, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.SUBS", (char*)"CU_ASSERT(id = \x22s( byval arg as byte )\x22)" );
	}
	{
		typedef void (*_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$28Es)( int16 );
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$28Es P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$28Es)&_Z1Ss;
		(P1$2)( (int16)0 );
		int32 vr$12 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as short )", 24ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$12 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 59, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.SUBS", (char*)"CU_ASSERT(id = \x22s( byval arg as short )\x22)" );
	}
	{
		typedef void (*_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$32Ei)( int32 );
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$32Ei P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$32Ei)&_Z1Si;
		(P1$2)( 0 );
		int32 vr$16 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as long )", 23ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$16 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 65, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.SUBS", (char*)"CU_ASSERT(id = \x22s( byval arg as long )\x22)" );
	}
	{
		typedef void (*_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$36Ex)( int64 );
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$36Ex P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$36Ex)&_Z1Sx;
		(P1$2)( 0ll );
		int32 vr$20 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as longint )", 26ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$20 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 71, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.SUBS", (char*)"CU_ASSERT(id = \x22s( byval arg as longint )\x22)" );
	}
	{
		typedef void (*_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$40Ef)( float );
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$40Ef P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$40Ef)&_Z1Sf;
		(P1$2)( 0x0p+0f );
		int32 vr$24 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as single )", 25ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$24 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 77, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.SUBS", (char*)"CU_ASSERT(id = \x22s( byval arg as single )\x22)" );
	}
	{
		typedef void (*_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$44Ed)( double );
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$44Ed P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$44Ed)&_Z1Sd;
		(P1$2)( 0x0p+0 );
		int32 vr$28 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as double )", 25ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$28 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 83, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.SUBS", (char*)"CU_ASSERT(id = \x22s( byval arg as double )\x22)" );
	}
	label$17:;
}

void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE5TYPESEv( void )
{
	label$20:;
	typedef void (*_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$50Ef)( float );
	{
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$50Ef P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$50Ef)&_Z1Sf;
		(P1$2)( 0x0p+0f );
		int32 vr$0 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as single )", 25ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$0 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 95, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.TYPES", (char*)"CU_ASSERT(id = \x22s( byval arg as single )\x22)" );
	}
	{
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$50Ef P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$50Ef)&_Z1Sf;
		(P1$2)( 0x0p+0f );
		int32 vr$4 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as single )", 25ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$4 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 101, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.TYPES", (char*)"CU_ASSERT(id = \x22s( byval arg as single )\x22)" );
	}
	{
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$50Ef P1$2;
		P1$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$50Ef)&_Z1Sf;
		(P1$2)( 0x0p+0f );
		int32 vr$8 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as single )", 25ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$8 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 107, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.TYPES", (char*)"CU_ASSERT(id = \x22s( byval arg as single )\x22)" );
		_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$50Ef P2$2;
		P2$2 = (_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE6tmp$50Ef)&_Z1Sf;
		(P2$2)( 0x0p+0f );
		int32 vr$12 = fb_StrCompare( (void*)&ID$, -1ll, (void*)"s( byval arg as single )", 25ll );
		_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$12 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cpointers\x5Cprocptr-type.bas", 111, (char*)"TESTS.FBC_TESTS.POINTERS.PROCPTR_TYPE.TYPES", (char*)"CU_ASSERT(id = \x22s( byval arg as single )\x22)" );
	}
	label$21:;
}

__attribute__(( constructor )) static void fb_ctor__procptrztype( void )
{
	label$0:;
	label$1:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE9SUBS_CTOREv( void )
{
	label$18:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.pointers.procptr_type", (char*)"subs", (tmp$5)&_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE4SUBSEv, (boolean)0ll );
	label$19:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE10TYPES_CTOREv( void )
{
	label$22:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.pointers.procptr_type", (char*)"types", (tmp$5)&_ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE5TYPESEv, (boolean)0ll );
	label$23:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS8POINTERS12PROCPTR_TYPE13SUITE_CTOR117Ev( void )
{
	label$24:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.pointers.procptr_type", (tmp$4)0ull, (tmp$4)0ull );
	label$25:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
