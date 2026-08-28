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
struct $4TEST {
	int64 X;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $4TEST ) == 8 );
typedef int64 $N4TEST6SECONDE;
static void fb_ctor__obj_access_const4( void ) __attribute__(( constructor ));

__attribute__(( constructor )) static void fb_ctor__obj_access_const4( void )
{
	label$0:;
	struct $4TEST T$0;
	__builtin_memset( &T$0, 0, 8ll );
	$N4TEST6SECONDE R$0;
	R$0 = 2ll;
	R$0 = 2ll;
	label$1:;
}
