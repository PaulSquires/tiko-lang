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
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
static void fb_ctor__identifierzlength( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH25PAST_BOUNDARY_SAME_SYMBOLEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH30PAST_BOUNDARY_SAME_SYMBOL_CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH32BEFORE_BOUNDARY_DISTINCT_SYMBOLSEv( void );
static void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH37BEFORE_BOUNDARY_DISTINCT_SYMBOLS_CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH12SUITE_CTOR32Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH25PAST_BOUNDARY_SAME_SYMBOLEv( void )
{
	label$2:;
	int32 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA$1;
	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA$1 = 7;
	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA$1 = 9;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA$1 == 9ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cidentifier-length.bas", 21, (char*)"TESTS.FBC_TESTS.DIM_.IDENTIFIER_LENGTH.PAST_BOUNDARY_SAME_SYMBOL", (char*)"CU_ASSERT_EQUAL(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa,9)" );
	label$3:;
}

void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH32BEFORE_BOUNDARY_DISTINCT_SYMBOLSEv( void )
{
	label$6:;
	int32 BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBX$1;
	BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBX$1 = 7;
	int32 BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBY$1;
	BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBY$1 = 9;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBX$1 == 7ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cidentifier-length.bas", 28, (char*)"TESTS.FBC_TESTS.DIM_.IDENTIFIER_LENGTH.BEFORE_BOUNDARY_DISTINCT_SYMBOLS", (char*)"CU_ASSERT_EQUAL(bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbX,7)" );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBY$1 == 9ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "dim\x5Cidentifier-length.bas", 29, (char*)"TESTS.FBC_TESTS.DIM_.IDENTIFIER_LENGTH.BEFORE_BOUNDARY_DISTINCT_SYMBOLS", (char*)"CU_ASSERT_EQUAL(bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbY,9)" );
	label$7:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH30PAST_BOUNDARY_SAME_SYMBOL_CTOREv( void )
{
	label$4:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.identifier_length", (char*)"past_boundary_same_symbol", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH25PAST_BOUNDARY_SAME_SYMBOLEv, (boolean)0ll );
	label$5:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH37BEFORE_BOUNDARY_DISTINCT_SYMBOLS_CTOREv( void )
{
	label$8:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.dim_.identifier_length", (char*)"before_boundary_distinct_symbols", (tmp$5)&_ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH32BEFORE_BOUNDARY_DISTINCT_SYMBOLSEv, (boolean)0ll );
	label$9:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS4DIM_17IDENTIFIER_LENGTH12SUITE_CTOR32Ev( void )
{
	label$10:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.dim_.identifier_length", (tmp$4)0ull, (tmp$4)0ull );
	label$11:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
