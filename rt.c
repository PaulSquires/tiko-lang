typedef   signed char       int8;
typedef unsigned char      uint8;
typedef   signed short      int16;
typedef unsigned short     uint16;
typedef   signed int        int32;
typedef unsigned int       uint32;
typedef   signed long long  int64;
typedef unsigned long long uint64;
typedef struct { char *data; int32 len; int32 size; } FBSTRING;
typedef int8 boolean;
void __stdcall fb_PrintString( int32, FBSTRING*, int32 ) asm("_fb_PrintString@12");
FBSTRING* __stdcall fb_StrAssign( void*, int32, void*, int32, int32 ) asm("_fb_StrAssign@20");
void __stdcall fb_Init( int32, char**, int32 ) asm("_fb_Init@12");
void __stdcall fb_End( int32 ) asm("_fb_End@4");
static FBSTRING A$;
static FBSTRING B$;

int32 main( int32 __FB_ARGC__$0, char** __FB_ARGV__$0 )
{
	int32 fb$result$0;
	__builtin_memset( &fb$result$0, 0, 4 );
	fb_Init( __FB_ARGC__$0, (char**)__FB_ARGV__$0, 0 );
	label$0:;
	fb_StrAssign( (void*)&A$, -1, (void*)&B$, -1, 0 );
	fb_PrintString( 0, (FBSTRING*)&A$, 1 );
	label$1:;
	fb_End( 0 );
	return fb$result$0;
}
