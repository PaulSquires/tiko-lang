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
void fb_Assert( char*, int64, char*, char* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_IntToStr( int32 );
FBSTRING* fb_IntToStrQB( int32 );
FBSTRING* fb_UIntToStrQB( uint32 );
FBSTRING* fb_LongintToStrQB( int64 );
FBSTRING* fb_ULongintToStrQB( uint64 );
FBSTRING* fb_FloatToStrQB( float );
FBSTRING* fb_DoubleToStr( double );
FBSTRING* fb_DoubleToStrQB( double );
static void fb_ctor__str( void ) __attribute__(( constructor ));

__attribute__(( constructor )) static void fb_ctor__str( void )
{
	FBSTRING TMP$9$0;
	FBSTRING TMP$17$0;
	label$0:;
	int16 I$0;
	__builtin_memset( &I$0, 0, 2ll );
	int32 L$0;
	__builtin_memset( &L$0, 0, 4ll );
	float S$0;
	__builtin_memset( &S$0, 0, 4ll );
	double D$0;
	__builtin_memset( &D$0, 0, 8ll );
	uint32 UL$0;
	__builtin_memset( &UL$0, 0, 4ll );
	int64 LL$0;
	__builtin_memset( &LL$0, 0, 8ll );
	uint64 ULL$0;
	__builtin_memset( &ULL$0, 0, 8ll );
	I$0 = (int16)1;
	S$0 = 0x1.p+0f;
	D$0 = 0x1.p+0;
	L$0 = 1;
	FBSTRING* vr$8 = fb_IntToStrQB( (int32)I$0 );
	int32 vr$9 = fb_StrCompare( (void*)vr$8, -1ll, (void*)" 1", 3ll );
	if( (int64)vr$9 == 0ll) goto label$3;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 17ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(i)  = \x22 1\x22" );
		label$3:;
	}
	FBSTRING* vr$11 = fb_FloatToStrQB( S$0 );
	int32 vr$12 = fb_StrCompare( (void*)vr$11, -1ll, (void*)" 1", 3ll );
	if( (int64)vr$12 == 0ll) goto label$5;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 18ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(s)  = \x22 1\x22" );
		label$5:;
	}
	FBSTRING* vr$14 = fb_DoubleToStrQB( D$0 );
	int32 vr$15 = fb_StrCompare( (void*)vr$14, -1ll, (void*)" 1", 3ll );
	if( (int64)vr$15 == 0ll) goto label$7;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 19ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(d)  = \x22 1\x22" );
		label$7:;
	}
	FBSTRING* vr$17 = fb_IntToStrQB( L$0 );
	int32 vr$18 = fb_StrCompare( (void*)vr$17, -1ll, (void*)" 1", 3ll );
	if( (int64)vr$18 == 0ll) goto label$9;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 20ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(l)  = \x22 1\x22" );
		label$9:;
	}
	FBSTRING* vr$20 = fb_DoubleToStr( D$0 );
	FBSTRING* vr$22 = fb_IntToStr( (int32)I$0 );
	__builtin_memset( &TMP$9$0, 0, 24ll );
	FBSTRING* vr$25 = fb_StrConcat( &TMP$9$0, (void*)vr$22, -1ll, (void*)vr$20, -1ll );
	int32 vr$26 = fb_StrCompare( (void*)vr$25, -1ll, (void*)"11", 3ll );
	if( (int64)vr$26 == 0ll) goto label$11;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 22ll, (char*)"__FB_MODLEVELPROC__", (char*)"(i & d) = \x22" "11\x22" );
		label$11:;
	}
	I$0 = (int16)-1;
	S$0 = -0x1.p+0f;
	D$0 = -0x1.p+0;
	L$0 = -1;
	FBSTRING* vr$29 = fb_IntToStrQB( (int32)I$0 );
	int32 vr$30 = fb_StrCompare( (void*)vr$29, -1ll, (void*)"-1", 3ll );
	if( (int64)vr$30 == 0ll) goto label$13;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 30ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(i)  = \x22-1\x22" );
		label$13:;
	}
	FBSTRING* vr$32 = fb_FloatToStrQB( S$0 );
	int32 vr$33 = fb_StrCompare( (void*)vr$32, -1ll, (void*)"-1", 3ll );
	if( (int64)vr$33 == 0ll) goto label$15;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 31ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(s)  = \x22-1\x22" );
		label$15:;
	}
	FBSTRING* vr$35 = fb_DoubleToStrQB( D$0 );
	int32 vr$36 = fb_StrCompare( (void*)vr$35, -1ll, (void*)"-1", 3ll );
	if( (int64)vr$36 == 0ll) goto label$17;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 32ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(d)  = \x22-1\x22" );
		label$17:;
	}
	FBSTRING* vr$38 = fb_IntToStrQB( L$0 );
	int32 vr$39 = fb_StrCompare( (void*)vr$38, -1ll, (void*)"-1", 3ll );
	if( (int64)vr$39 == 0ll) goto label$19;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 33ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(l)  = \x22-1\x22" );
		label$19:;
	}
	FBSTRING* vr$41 = fb_DoubleToStr( D$0 );
	FBSTRING* vr$43 = fb_IntToStr( (int32)I$0 );
	__builtin_memset( &TMP$17$0, 0, 24ll );
	FBSTRING* vr$46 = fb_StrConcat( &TMP$17$0, (void*)vr$43, -1ll, (void*)vr$41, -1ll );
	int32 vr$47 = fb_StrCompare( (void*)vr$46, -1ll, (void*)"-1-1", 5ll );
	if( (int64)vr$47 == 0ll) goto label$21;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 35ll, (char*)"__FB_MODLEVELPROC__", (char*)"(i & d) = \x22-1-1\x22" );
		label$21:;
	}
	goto label$23;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 38ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(1%)    = \x22 1\x22" );
		label$23:;
	}
	goto label$25;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 39ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(1!)   = \x22 1\x22" );
		label$25:;
	}
	goto label$27;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 40ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(1#)   = \x22 1\x22" );
		label$27:;
	}
	goto label$29;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 41ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(1&)  = \x22 1\x22" );
		label$29:;
	}
	goto label$31;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 43ll, (char*)"__FB_MODLEVELPROC__", (char*)"( 1% &  1#) = \x22" "11\x22" );
		label$31:;
	}
	goto label$33;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 45ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(-1%)    = \x22-1\x22" );
		label$33:;
	}
	goto label$35;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 46ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(-1!)   = \x22-1\x22" );
		label$35:;
	}
	goto label$37;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 47ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(-1#)   = \x22-1\x22" );
		label$37:;
	}
	goto label$39;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 48ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(-1&)  = \x22-1\x22" );
		label$39:;
	}
	goto label$41;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 50ll, (char*)"__FB_MODLEVELPROC__", (char*)"(-1% & -1#) = \x22-1-1\x22" );
		label$41:;
	}
	UL$0 = 2147483648u;
	FBSTRING* vr$49 = fb_UIntToStrQB( UL$0 );
	int32 vr$50 = fb_StrCompare( (void*)vr$49, -1ll, (void*)" 2147483648", 12ll );
	if( (int64)vr$50 == 0ll) goto label$43;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 57ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(ul) = \x22 2147483648\x22" );
		label$43:;
	}
	goto label$45;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 59ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(&h80000000u) = \x22 2147483648\x22" );
		label$45:;
	}
	LL$0 = 9223372036854775807ll;
	ULL$0 = 9223372036854775807ull;
	FBSTRING* vr$52 = fb_LongintToStrQB( LL$0 );
	int32 vr$53 = fb_StrCompare( (void*)vr$52, -1ll, (void*)" 9223372036854775807", 21ll );
	if( (int64)vr$53 == 0ll) goto label$47;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 68ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(ll)   = \x22 9223372036854775807\x22" );
		label$47:;
	}
	FBSTRING* vr$55 = fb_ULongintToStrQB( ULL$0 );
	int32 vr$56 = fb_StrCompare( (void*)vr$55, -1ll, (void*)" 9223372036854775807", 21ll );
	if( (int64)vr$56 == 0ll) goto label$49;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 69ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(ull)  = \x22 9223372036854775807\x22" );
		label$49:;
	}
	goto label$51;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 71ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(&h7fffffffffffffffll)   = \x22 9223372036854775807\x22" );
		label$51:;
	}
	goto label$53;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 72ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(&h7fffffffffffffffull)  = \x22 9223372036854775807\x22" );
		label$53:;
	}
	LL$0 = (int64)-9223372036854775808ull;
	ULL$0 = 9223372036854775808ull;
	FBSTRING* vr$58 = fb_LongintToStrQB( LL$0 );
	int32 vr$59 = fb_StrCompare( (void*)vr$58, -1ll, (void*)"-9223372036854775808", 21ll );
	if( (int64)vr$59 == 0ll) goto label$55;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 78ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(ll)   = \x22-9223372036854775808\x22" );
		label$55:;
	}
	FBSTRING* vr$61 = fb_ULongintToStrQB( ULL$0 );
	int32 vr$62 = fb_StrCompare( (void*)vr$61, -1ll, (void*)" 9223372036854775808", 21ll );
	if( (int64)vr$62 == 0ll) goto label$57;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 79ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(ull)  = \x22 9223372036854775808\x22" );
		label$57:;
	}
	goto label$59;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 81ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(&h8000000000000000ll)   = \x22-9223372036854775808\x22" );
		label$59:;
	}
	goto label$61;
	{
		fb_Assert( (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5Cqb\x5Cstr.bas", 82ll, (char*)"__FB_MODLEVELPROC__", (char*)"str$(&h8000000000000000ull)  = \x22 9223372036854775808\x22" );
		label$61:;
	}
	label$1:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-lang\0qb";
