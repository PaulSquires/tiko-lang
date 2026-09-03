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
struct $3FOO {
	int64 __BAR[10];
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $3FOO ) == 80 );
void fb_PrintLongint( int32, int64, int32 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
int64 fb_VALLNG( FBSTRING* );
static void fb_ctor__propzindexed( void ) __attribute__(( constructor ));
int64 _ZN3FOO10BAR__get__Eu7INTEGER( struct $3FOO*, int64 );
int64 _ZN3FOO10BAR__get__ER8FBSTRING( struct $3FOO*, FBSTRING* );
void _ZN3FOO10BAR__set__Eu7INTEGERS0_( struct $3FOO*, int64, int64 );
void _ZN3FOO10BAR__set__ER8FBSTRINGu7INTEGER( struct $3FOO*, FBSTRING*, int64 );

int64 _ZN3FOO10BAR__get__Eu7INTEGER( struct $3FOO* THIS$1, int64 INDEX$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2:;
	fb$result$1 = *(int64*)((uint8*)THIS$1 + (INDEX$1 << (3ll & 63ll)));
	goto label$3;
	label$3:;
	return fb$result$1;
}

int64 _ZN3FOO10BAR__get__ER8FBSTRING( struct $3FOO* THIS$1, FBSTRING* INDEX$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$4:;
	int64 vr$1 = fb_VALLNG( (FBSTRING*)INDEX$1 );
	fb$result$1 = *(int64*)((uint8*)THIS$1 + (vr$1 << (3ll & 63ll)));
	goto label$5;
	label$5:;
	return fb$result$1;
}

void _ZN3FOO10BAR__set__Eu7INTEGERS0_( struct $3FOO* THIS$1, int64 INDEX$1, int64 VALUE$1 )
{
	label$6:;
	*(int64*)((uint8*)THIS$1 + (INDEX$1 << (3ll & 63ll))) = VALUE$1;
	label$7:;
}

void _ZN3FOO10BAR__set__ER8FBSTRINGu7INTEGER( struct $3FOO* THIS$1, FBSTRING* INDEX$1, int64 VALUE$1 )
{
	label$8:;
	int64 vr$0 = fb_VALLNG( (FBSTRING*)INDEX$1 );
	*(int64*)((uint8*)THIS$1 + (vr$0 << (3ll & 63ll))) = VALUE$1;
	label$9:;
}

__attribute__(( constructor )) static void fb_ctor__propzindexed( void )
{
	FBSTRING TMP$3$0;
	FBSTRING TMP$4$0;
	label$0:;
	struct $3FOO F$0;
	__builtin_memset( &F$0, 0, 80ll );
	_ZN3FOO10BAR__set__Eu7INTEGERS0_( &F$0, 0ll, 1234ll );
	__builtin_memset( &TMP$3$0, 0, 24ll );
	fb_StrAssign( (void*)&TMP$3$0, -1ll, (void*)"1", 2ll, 0 );
	_ZN3FOO10BAR__set__ER8FBSTRINGu7INTEGER( &F$0, &TMP$3$0, 5678ll );
	fb_StrDelete( (FBSTRING*)&TMP$3$0 );
	int64 vr$8 = _ZN3FOO10BAR__get__Eu7INTEGER( &F$0, 0ll );
	fb_PrintLongint( 0, vr$8, 2 );
	__builtin_memset( &TMP$4$0, 0, 24ll );
	fb_StrAssign( (void*)&TMP$4$0, -1ll, (void*)"1", 2ll, 0 );
	int64 vr$13 = _ZN3FOO10BAR__get__ER8FBSTRING( &F$0, &TMP$4$0 );
	fb_PrintLongint( 0, vr$13, 1 );
	fb_StrDelete( (FBSTRING*)&TMP$4$0 );
	label$1:;
}
