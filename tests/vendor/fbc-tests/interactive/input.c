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
typedef int32 (*tmp$4)( void );
int32 fb_ConsoleView( int32, int32 );
int32 fb_Width( int32, int32 );
int32 fb_Locate( int32, int32, int32, int32, int32 );
int32 fb_GetY( void );
void fb_Cls( int32 );
FBSTRING* fb_Inkey( void );
int32 fb_ConsoleInput( FBSTRING*, int32, int32 );
int32 fb_InputString( void*, int64, int32 );
int32 fb_Multikey( int32 );
int32 fb_GetMouse64( int64*, int64*, int64*, int64*, int64* );
void fb_PrintString( int32, FBSTRING*, int32 );
int32 fb_PrintUsingInit( FBSTRING* );
int32 fb_PrintUsingLongint( int32, int64, int32 );
int32 fb_PrintUsingEnd( int32 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_StrAllocTempDescZEx( char*, int64 );
FBSTRING* fb_UIntToStr( uint32 );
uint32 fb_ASC( FBSTRING*, int64 );
static void fb_ctor__input( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN5TESTS9FBC_TESTS7CONSOLE9DRAW_RECTEu7INTEGERS2_S2_S2_( int64, int64, int64, int64 );
void _ZN5TESTS9FBC_TESTS7CONSOLE6CENTEREu7INTEGERR8FBSTRING( int64, FBSTRING* );
void _ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_10INKEY_TESTER8FBSTRING( FBSTRING* );
static void _ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_13SUITE_CTOR141Ev( void ) __attribute__(( constructor ));
static int64 _ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_2W$E;
static int64 _ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_2H$E;

void _ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_10INKEY_TESTER8FBSTRING( FBSTRING* TITLE$1 )
{
	label$39:;
	FBSTRING S$1;
	__builtin_memset( &S$1, 0, 24ll );
	int64 Y$1;
	__builtin_memset( &Y$1, 0, 8ll );
	fb_Cls( -65536 );
	_ZN5TESTS9FBC_TESTS7CONSOLE9DRAW_RECTEu7INTEGERS2_S2_S2_( 1ll, 1ll, _ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_2W$E, _ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_2H$E );
	_ZN5TESTS9FBC_TESTS7CONSOLE6CENTEREu7INTEGERR8FBSTRING( 2ll, TITLE$1 );
	fb_ConsoleView( 5, (int32)(_ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_2H$E + -5ll) );
	label$41:;
	{
		FBSTRING TMP$37$2;
		FBSTRING TMP$38$2;
		FBSTRING TMP$39$2;
		FBSTRING* vr$4 = fb_Inkey(  );
		fb_StrAssign( (void*)&S$1, -1ll, (void*)vr$4, -1ll, 0 );
		label$44:;
		int32 vr$7 = fb_StrCompare( (void*)&S$1, -1ll, (void*)"", 1ll );
		if( (int64)vr$7 != 0ll) goto label$45;
		{
			FBSTRING* vr$9 = fb_Inkey(  );
			fb_StrAssign( (void*)&S$1, -1ll, (void*)vr$9, -1ll, 0 );
		}
		goto label$44;
		label$45:;
		fb_Locate( 0, 3, -1, 0, 0 );
		uint32 vr$12 = fb_ASC( (FBSTRING*)&S$1, 1ll );
		FBSTRING* vr$13 = fb_UIntToStr( vr$12 );
		__builtin_memset( &TMP$37$2, 0, 24ll );
		FBSTRING* vr$17 = fb_StrConcat( &TMP$37$2, (void*)&S$1, -1ll, (void*)" (ascii ", 9ll );
		__builtin_memset( &TMP$38$2, 0, 24ll );
		FBSTRING* vr$20 = fb_StrConcat( &TMP$38$2, (void*)vr$17, -1ll, (void*)vr$13, -1ll );
		__builtin_memset( &TMP$39$2, 0, 24ll );
		FBSTRING* vr$23 = fb_StrConcat( &TMP$39$2, (void*)vr$20, -1ll, (void*)")", 2ll );
		fb_PrintString( 0, (FBSTRING*)vr$23, 1 );
		int32 vr$24 = fb_GetY(  );
		Y$1 = (int64)vr$24;
		fb_Locate( (int32)(_ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_2H$E + -5ll), 1, -1, 0, 0 );
		FBSTRING* vr$28 = fb_StrAllocTempDescZEx( (char*)"\xB3", 1ll );
		fb_PrintString( 0, (FBSTRING*)vr$28, 0 );
		fb_Locate( (int32)(_ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_2H$E + -5ll), (int32)_ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_2W$E, -1, 0, 0 );
		FBSTRING* vr$32 = fb_StrAllocTempDescZEx( (char*)"\xB3", 1ll );
		fb_PrintString( 0, (FBSTRING*)vr$32, 0 );
		fb_Locate( (int32)Y$1, 0, -1, 0, 0 );
	}
	label$43:;
	int32 vr$35 = fb_StrCompare( (void*)&S$1, -1ll, (void*)"\x1B", 2ll );
	if( (int64)vr$35 != 0ll) goto label$41;
	label$42:;
	fb_ConsoleView( 0, 0 );
	fb_StrDelete( (FBSTRING*)&S$1 );
	label$40:;
}

__attribute__(( constructor )) static void fb_ctor__input( void )
{
	label$0:;
	label$1:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS11INTERACTIVE6INPUT_13SUITE_CTOR141Ev( void )
{
	label$46:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.interactive.input_", (tmp$4)0ull, (tmp$4)0ull );
	label$47:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
