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
int32 fb_Width( int32, int32 );
int32 fb_Locate( int32, int32, int32, int32, int32 );
void fb_Cls( int32 );
void fb_PrintString( int32, FBSTRING*, int32 );
FBSTRING* fb_CHR( int32, ... );
void fb_Sleep( int32 );
static void fb_ctor__ascii( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN5TESTS9FBC_TESTS7CONSOLE9DRAW_RECTEu7INTEGERS2_S2_S2_( int64, int64, int64, int64 );
static void _ZN5TESTS9FBC_TESTS7CONSOLE5ASCII12SUITE_CTOR45Ev( void ) __attribute__(( constructor ));

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS7CONSOLE5ASCII12SUITE_CTOR45Ev( void )
{
	label$12:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.console.ascii", (tmp$4)0ull, (tmp$4)0ull );
	label$13:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
