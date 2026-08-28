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
uint32 fb_Color( int32, int32, uint32 );
void fb_PrintString( int32, FBSTRING*, int32 );
FBSTRING* fb_StrAllocTempDescZEx( char*, int64 );
static void fb_ctor__examplelib( void ) __attribute__(( constructor ));

int64 GET123( void )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2:;
	fb$result$1 = 123ll;
	goto label$3;
	label$3:;
	return fb$result$1;
}

void PRINT_HELLO( void )
{
	label$4:;
	FBSTRING* vr$0 = fb_StrAllocTempDescZEx( (char*)"hello ", 6ll );
	fb_PrintString( 0, (FBSTRING*)vr$0, 0 );
	uint32 OLDCOLORS$1;
	uint32 vr$1 = fb_Color( 1, 0, 2u );
	OLDCOLORS$1 = vr$1;
	FBSTRING* vr$2 = fb_StrAllocTempDescZEx( (char*)"hello ", 6ll );
	fb_PrintString( 0, (FBSTRING*)vr$2, 0 );
	fb_Color( (int32)((uint64)OLDCOLORS$1 & 65535ull), 0, 2u );
	FBSTRING* vr$6 = fb_StrAllocTempDescZEx( (char*)"hello ", 6ll );
	fb_PrintString( 0, (FBSTRING*)vr$6, 0 );
	label$5:;
}
