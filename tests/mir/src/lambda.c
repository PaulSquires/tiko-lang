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
typedef boolean (*tmp$3)( int32*, int32* );
typedef int32* (*tmp$5)( int32*, int32* );
typedef int32 (*tmp$2)( int32 );
void fb_PrintBool( int32, boolean, int32 );
void fb_PrintInt( int32, int32, int32 );
static void fb_ctor__lambda( void ) __attribute__(( constructor ));
void S1( void );
boolean L367F1D6984DDFFBD_LT_0004( int32*, int32* );
int32* L367F1D6984DDFFBD_LT_0006( int32*, int32* );
int32 L367F1D6984DDFFBD_LT_0007( int32 );

void S1( void )
{
	label$2:;
	tmp$3 LESS$1;
	LESS$1 = (tmp$3)&L367F1D6984DDFFBD_LT_0004;
	int32 A$1;
	A$1 = 1;
	int32 B$1;
	B$1 = 2;
	boolean vr$2 = (LESS$1)( &A$1, &B$1 );
	fb_PrintBool( 0, vr$2, 1 );
	tmp$5 PICK$1;
	PICK$1 = (tmp$5)&L367F1D6984DDFFBD_LT_0006;
	int32* vr$5 = (PICK$1)( &A$1, &B$1 );
	fb_PrintInt( 0, *vr$5, 1 );
	tmp$2 ONE$1;
	ONE$1 = (tmp$2)&L367F1D6984DDFFBD_LT_0007;
	int32 vr$6 = (ONE$1)( 1 );
	fb_PrintInt( 0, vr$6, 1 );
	label$3:;
}

boolean L367F1D6984DDFFBD_LT_0004( int32* X$1, int32* Y$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$4:;
	fb$result$1 = (boolean)((int64)-((int64)*X$1 < (int64)*Y$1) != 0ll);
	goto label$5;
	label$5:;
	return fb$result$1;
}

int32* L367F1D6984DDFFBD_LT_0006( int32* P$1, int32* Q$1 )
{
	int32* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$6:;
	if( (int64)*P$1 <= (int64)*Q$1) goto label$9;
	{
		fb$result$1 = P$1;
		goto label$7;
		label$9:;
	}
	fb$result$1 = Q$1;
	goto label$7;
	label$7:;
	return fb$result$1;
}

int32 L367F1D6984DDFFBD_LT_0007( int32 X$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$10:;
	fb$result$1 = (int32)((int64)X$1 + 100ll);
	goto label$11;
	label$11:;
	return fb$result$1;
}

__attribute__(( constructor )) static void fb_ctor__lambda( void )
{
	label$0:;
	S1(  );
	label$1:;
}
