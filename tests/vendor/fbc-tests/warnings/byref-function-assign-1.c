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
static void fb_ctor__byrefzfunctionzassignz1( void ) __attribute__(( constructor ));
int64 F0BYVAL( void );
int64* F0BYREF( void );
int64 F1BYVAL( int64 );
int64* F1BYREF( int64 );
int64 F1XBYVAL( int64 );
int64* F1XBYREF( int64 );
int64 F2BYVAL( int64, int64 );
int64* F2BYREF( int64, int64 );
int64 F2XBYVAL( int64, int64 );
int64* F2XBYREF( int64, int64 );
int64 F2XXBYVAL( int64, int64 );
int64* F2XXBYREF( int64, int64 );

int64 F0BYVAL( void )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2:;
	fb$result$1 = 0ll;
	label$3:;
	return fb$result$1;
}

int64* F0BYREF( void )
{
	int64* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$4:;
	static int64 J$1;
	fb$result$1 = &J$1;
	label$5:;
	return fb$result$1;
}

int64 F1BYVAL( int64 I$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$6:;
	fb$result$1 = 0ll;
	label$7:;
	return fb$result$1;
}

int64* F1BYREF( int64 I$1 )
{
	int64* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$8:;
	static int64 J$1;
	fb$result$1 = &J$1;
	label$9:;
	return fb$result$1;
}

int64 F1XBYVAL( int64 I$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$10:;
	fb$result$1 = 0ll;
	label$11:;
	return fb$result$1;
}

int64* F1XBYREF( int64 I$1 )
{
	int64* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$12:;
	static int64 J$1;
	fb$result$1 = &J$1;
	label$13:;
	return fb$result$1;
}

int64 F2BYVAL( int64 I$1, int64 J$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$14:;
	fb$result$1 = 0ll;
	label$15:;
	return fb$result$1;
}

int64* F2BYREF( int64 I$1, int64 J$1 )
{
	int64* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$16:;
	static int64 K$1;
	fb$result$1 = &K$1;
	label$17:;
	return fb$result$1;
}

int64 F2XBYVAL( int64 I$1, int64 J$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$18:;
	fb$result$1 = 0ll;
	label$19:;
	return fb$result$1;
}

int64* F2XBYREF( int64 I$1, int64 J$1 )
{
	int64* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$20:;
	static int64 K$1;
	fb$result$1 = &K$1;
	label$21:;
	return fb$result$1;
}

int64 F2XXBYVAL( int64 I$1, int64 J$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$22:;
	fb$result$1 = 0ll;
	label$23:;
	return fb$result$1;
}

int64* F2XXBYREF( int64 I$1, int64 J$1 )
{
	int64* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$24:;
	static int64 K$1;
	fb$result$1 = &K$1;
	label$25:;
	return fb$result$1;
}

__attribute__(( constructor )) static void fb_ctor__byrefzfunctionzassignz1( void )
{
	label$0:;
	F0BYVAL(  );
	F0BYREF(  );
	F1BYVAL( 1ll );
	F1BYREF( 1ll );
	F1XBYVAL( 0ll );
	F1XBYREF( 0ll );
	F1XBYVAL( 1ll );
	F1XBYREF( 1ll );
	F2BYVAL( 1ll, 1ll );
	F2BYREF( 1ll, 1ll );
	F2XBYVAL( 1ll, 0ll );
	F2XBYREF( 1ll, 0ll );
	F2XBYVAL( 1ll, 1ll );
	F2XBYREF( 1ll, 1ll );
	F2XXBYVAL( 0ll, 0ll );
	F2XXBYREF( 0ll, 0ll );
	F2XXBYVAL( 1ll, 0ll );
	F2XXBYREF( 1ll, 0ll );
	F2XXBYVAL( 1ll, 1ll );
	F2XXBYREF( 1ll, 1ll );
	F0BYVAL(  );
	F0BYREF(  );
	F1BYVAL( 1ll );
	F1BYREF( 1ll );
	F1XBYVAL( 0ll );
	F1XBYREF( 0ll );
	F1XBYVAL( 1ll );
	F1XBYREF( 1ll );
	F2BYVAL( 1ll, 1ll );
	F2BYREF( 1ll, 1ll );
	F2XBYVAL( 1ll, 0ll );
	F2XBYREF( 1ll, 0ll );
	F2XBYVAL( 1ll, 1ll );
	F2XBYREF( 1ll, 1ll );
	F2XXBYVAL( 0ll, 0ll );
	F2XXBYREF( 0ll, 0ll );
	F2XXBYVAL( 1ll, 0ll );
	F2XXBYREF( 1ll, 0ll );
	F2XXBYVAL( 1ll, 1ll );
	F2XXBYREF( 1ll, 1ll );
	int64* vr$0 = F0BYREF(  );
	*vr$0 = 0ll;
	F1BYVAL( 0ll );
	F1BYREF( 0ll );
	int64* vr$1 = F1XBYREF( 0ll );
	*vr$1 = 0ll;
	F1XBYVAL( 0ll );
	F1XBYREF( 0ll );
	int64* vr$2 = F2BYREF( 1ll, 1ll );
	*vr$2 = 0ll;
	F2XBYVAL( 0ll, 0ll );
	F2XBYREF( 0ll, 0ll );
	int64* vr$3 = F2XBYREF( 1ll, 1ll );
	*vr$3 = 0ll;
	int64* vr$4 = F2XXBYREF( 0ll, 0ll );
	*vr$4 = 0ll;
	F2XXBYVAL( 0ll, 0ll );
	F2XXBYREF( 0ll, 0ll );
	int64* vr$5 = F2XXBYREF( 1ll, 1ll );
	*vr$5 = 0ll;
	F1BYVAL( 0ll );
	F1BYREF( 0ll );
	F1XBYVAL( 0ll );
	F1XBYREF( 0ll );
	F2BYVAL( 1ll, 0ll );
	F2BYREF( 1ll, 0ll );
	F2BYVAL( 0ll, 1ll );
	F2BYREF( 0ll, 1ll );
	F2XBYVAL( 0ll, 0ll );
	F2XBYREF( 0ll, 0ll );
	F2XBYVAL( 1ll, 0ll );
	F2XBYREF( 1ll, 0ll );
	F2XBYVAL( 0ll, 1ll );
	F2XBYREF( 0ll, 1ll );
	F2XXBYVAL( 0ll, 0ll );
	F2XXBYREF( 0ll, 0ll );
	F2XXBYVAL( 1ll, 0ll );
	F2XXBYREF( 1ll, 0ll );
	F2XXBYVAL( 0ll, 1ll );
	F2XXBYREF( 0ll, 1ll );
	label$1:;
}
