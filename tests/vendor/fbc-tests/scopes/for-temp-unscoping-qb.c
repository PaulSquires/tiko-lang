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
static void fb_ctor__forztempzunscopingzqb( void ) __attribute__(( constructor ));

__attribute__(( constructor )) static void fb_ctor__forztempzunscopingzqb( void )
{
	label$0:;
	float IEND$0;
	__builtin_memset( &IEND$0, 0, 4ll );
	float JEND$0;
	__builtin_memset( &JEND$0, 0, 4ll );
	float I$0;
	__builtin_memset( &I$0, 0, 4ll );
	float TMP$1$0;
	__builtin_memset( &TMP$1$0, 0, 4ll );
	float J$0;
	__builtin_memset( &J$0, 0, 4ll );
	float TMP$2$0;
	__builtin_memset( &TMP$2$0, 0, 4ll );
	IEND$0 = 0x1.4p+3f;
	JEND$0 = 0x1.4p+4f;
	{
		I$0 = 0x1.p+0f;
		TMP$1$0 = IEND$0;
		goto label$2;
		label$5:;
		{
			goto label$6;
			label$7:;
		}
		label$3:;
		I$0 = I$0 + 0x1.p+0f;
		label$2:;
		if( I$0 <= TMP$1$0) goto label$5;
		label$4:;
	}
	goto label$8;
	label$6:;
	{
		J$0 = 0x1.p+0f;
		TMP$2$0 = JEND$0;
		goto label$9;
		label$12:;
		{
		}
		label$10:;
		J$0 = J$0 + 0x1.p+0f;
		label$9:;
		if( J$0 <= TMP$2$0) goto label$12;
		label$11:;
	}
	goto label$7;
	label$8:;
	label$1:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-lang\0qb";
