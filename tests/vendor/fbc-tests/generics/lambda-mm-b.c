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
typedef int32 (*tmp$2)( int32 );
struct $25L4E566AB588D6B678_Lt_0004IiE {
	int32* __CAP_ACC;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $25L4E566AB588D6B678_Lt_0004IiE ) == 8 );
static void fb_ctor__lambdazmmzb( void ) __attribute__(( constructor ));
int32 L4E566AB588D6B678_LT_0003( int32 );
static void _ZN25L4E566AB588D6B678_Lt_0004IiE10__FBINVOKEEi( struct $25L4E566AB588D6B678_Lt_0004IiE*, int32 );

int32 MODULEB( void )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$2:;
	tmp$2 F$1;
	F$1 = (tmp$2)&L4E566AB588D6B678_LT_0003;
	int32 vr$1 = (F$1)( 20 );
	fb$result$1 = vr$1;
	goto label$3;
	label$3:;
	return fb$result$1;
}

int32 L4E566AB588D6B678_LT_0003( int32 X$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$4:;
	fb$result$1 = (int32)((int64)X$1 + 2ll);
	goto label$5;
	label$5:;
	return fb$result$1;
}

int32 MODULEBCAPTURE( void )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$6:;
	int32 ACC$1;
	ACC$1 = 0;
	struct $25L4E566AB588D6B678_Lt_0004IiE TMP$5$1;
	__builtin_memset( &TMP$5$1, 0, 8ll );
	*(int32**)&TMP$5$1 = &ACC$1;
	struct $25L4E566AB588D6B678_Lt_0004IiE C$1;
	__builtin_memcpy( &C$1, &TMP$5$1, 8 );
	_ZN25L4E566AB588D6B678_Lt_0004IiE10__FBINVOKEEi( &C$1, 20 );
	fb$result$1 = ACC$1;
	goto label$7;
	label$7:;
	return fb$result$1;
}

static void _ZN25L4E566AB588D6B678_Lt_0004IiE10__FBINVOKEEi( struct $25L4E566AB588D6B678_Lt_0004IiE* THIS$1, int32 V$1 )
{
	label$8:;
	int32* ACC$1;
	ACC$1 = *(int32**)THIS$1;
	*ACC$1 = (int32)((int64)*ACC$1 + (int64)V$1);
	label$9:;
}
