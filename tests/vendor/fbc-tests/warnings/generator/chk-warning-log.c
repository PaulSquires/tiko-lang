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
int32 fb_FileOpen( FBSTRING*, uint32, uint32, uint32, int32, int32 );
int32 fb_FileClose( int32 );
int32 fb_FileLineInput( int32, void*, int64, int32 );
int32 fb_FileEof( int32 );
void fb_PrintString( int32, FBSTRING*, int32 );
void fb_StrDelete( FBSTRING* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_StrAllocTempDescZEx( char*, int64 );
FBSTRING* fb_LongintToStr( int64 );
FBSTRING* fb_StrMid( FBSTRING*, int64, int64 );
int64 fb_StrInstr( int64, FBSTRING*, FBSTRING* );
uint64 fb_VALULNG( FBSTRING* );
FBSTRING* fb_LEFT( FBSTRING*, int64 );
void fb_End( int32 );
FBSTRING* fb_Command( int32 );
static void fb_ctor__chkzwarningzlog( void ) __attribute__(( constructor ));

__attribute__(( constructor )) static void fb_ctor__chkzwarningzlog( void )
{
	label$0:;
	FBSTRING* vr$0 = fb_Command( 1 );
	int32 vr$1 = fb_StrCompare( (void*)vr$0, -1ll, (void*)"", 1ll );
	if( (int64)vr$1 != 0ll) goto label$3;
	{
		FBSTRING* vr$3 = fb_StrAllocTempDescZEx( (char*)"no file name", 12ll );
		fb_PrintString( 0, (FBSTRING*)vr$3, 1 );
		fb_End( 1 );
	}
	label$3:;
	label$2:;
	FBSTRING* vr$4 = fb_Command( 1 );
	int32 vr$5 = fb_FileOpen( (FBSTRING*)vr$4, 2u, 1u, 0u, 1, 0 );
	if( (int64)vr$5 == 0ll) goto label$5;
	{
		FBSTRING TMP$5$1;
		FBSTRING TMP$6$1;
		FBSTRING* vr$7 = fb_Command( 1 );
		__builtin_memset( &TMP$5$1, 0, 24ll );
		FBSTRING* vr$10 = fb_StrConcat( &TMP$5$1, (void*)"Error reading input file '", 27ll, (void*)vr$7, -1ll );
		__builtin_memset( &TMP$6$1, 0, 24ll );
		FBSTRING* vr$13 = fb_StrConcat( &TMP$6$1, (void*)vr$10, -1ll, (void*)"'", 2ll );
		fb_PrintString( 0, (FBSTRING*)vr$13, 1 );
		fb_End( 1 );
	}
	label$5:;
	label$4:;
	FBSTRING X$0;
	__builtin_memset( &X$0, 0, 24ll );
	int64 MODE$0;
	MODE$0 = 0ll;
	int64 LINENO$0;
	LINENO$0 = 0ll;
	label$6:;
	int32 vr$15 = fb_FileEof( 1 );
	if( (int64)vr$15 != 0ll) goto label$7;
	{
		LINENO$0 = LINENO$0 + 1ll;
		fb_FileLineInput( 1, (void*)&X$0, -1ll, 0 );
		FBSTRING* vr$20 = fb_LEFT( (FBSTRING*)&X$0, 4ll );
		int32 vr$21 = fb_StrCompare( (void*)vr$20, -1ll, (void*)"----", 5ll );
		if( (int64)vr$21 != 0ll) goto label$9;
		{
			goto label$7;
		}
		label$9:;
		label$8:;
	}
	goto label$6;
	label$7:;
	label$10:;
	int32 vr$23 = fb_FileEof( 1 );
	if( (int64)vr$23 != 0ll) goto label$11;
	{
		LINENO$0 = LINENO$0 + 1ll;
		fb_FileLineInput( 1, (void*)&X$0, -1ll, 0 );
		label$12:;
		if( MODE$0 != 0ll) goto label$14;
		{
			FBSTRING* vr$28 = fb_LEFT( (FBSTRING*)&X$0, 8ll );
			int32 vr$29 = fb_StrCompare( (void*)vr$28, -1ll, (void*)"warning ", 9ll );
			if( (int64)vr$29 != 0ll) goto label$16;
			{
				MODE$0 = 1ll;
			}
			goto label$15;
			label$16:;
			FBSTRING* vr$32 = fb_StrMid( (FBSTRING*)&X$0, 2ll, 10ll );
			int32 vr$33 = fb_StrCompare( (void*)vr$32, -1ll, (void*)" warnings ", 11ll );
			if( (int64)vr$33 != 0ll) goto label$17;
			{
				FBSTRING* vr$36 = fb_LEFT( (FBSTRING*)&X$0, 1ll );
				uint64 vr$37 = fb_VALULNG( (FBSTRING*)vr$36 );
				MODE$0 = (int64)vr$37;
			}
			goto label$15;
			label$17:;
			{
				FBSTRING* vr$38 = fb_StrAllocTempDescZEx( (char*)"warning", 7ll );
				int64 vr$40 = fb_StrInstr( 2ll, (FBSTRING*)&X$0, (FBSTRING*)vr$38 );
				if( vr$40 <= 0ll) goto label$19;
				{
					FBSTRING TMP$13$4;
					FBSTRING TMP$14$4;
					FBSTRING* vr$41 = fb_LongintToStr( LINENO$0 );
					__builtin_memset( &TMP$13$4, 0, 24ll );
					FBSTRING* vr$44 = fb_StrConcat( &TMP$13$4, (void*)"line ", 6ll, (void*)vr$41, -1ll );
					__builtin_memset( &TMP$14$4, 0, 24ll );
					FBSTRING* vr$47 = fb_StrConcat( &TMP$14$4, (void*)vr$44, -1ll, (void*)" - unexpected warning", 22ll );
					fb_PrintString( 0, (FBSTRING*)vr$47, 1 );
				}
				label$19:;
				label$18:;
			}
			label$15:;
		}
		goto label$13;
		label$14:;
		{
			FBSTRING* vr$48 = fb_StrAllocTempDescZEx( (char*)"warning", 7ll );
			int64 vr$50 = fb_StrInstr( 2ll, (FBSTRING*)&X$0, (FBSTRING*)vr$48 );
			if( vr$50 != 0ll) goto label$21;
			{
				FBSTRING TMP$16$3;
				FBSTRING TMP$17$3;
				FBSTRING* vr$51 = fb_LongintToStr( LINENO$0 );
				__builtin_memset( &TMP$16$3, 0, 24ll );
				FBSTRING* vr$54 = fb_StrConcat( &TMP$16$3, (void*)"line ", 6ll, (void*)vr$51, -1ll );
				__builtin_memset( &TMP$17$3, 0, 24ll );
				FBSTRING* vr$57 = fb_StrConcat( &TMP$17$3, (void*)vr$54, -1ll, (void*)" - expected warning", 20ll );
				fb_PrintString( 0, (FBSTRING*)vr$57, 1 );
				MODE$0 = 0ll;
				goto label$12;
			}
			goto label$20;
			label$21:;
			{
				MODE$0 = MODE$0 + -1ll;
			}
			label$20:;
		}
		label$13:;
	}
	goto label$10;
	label$11:;
	fb_FileClose( 1 );
	fb_StrDelete( (FBSTRING*)&X$0 );
	label$1:;
}
