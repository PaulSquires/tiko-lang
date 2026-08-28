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
typedef void (*tmp$3)( void );
typedef int32 (*tmp$2)( void );
static void fb_ctor__ex07( void ) __attribute__(( constructor ));
void fbcu_add_suite_qb( char*, tmp$2, tmp$2 );
void fbcu_add_test_qb( char*, char*, tmp$3, boolean );
boolean fbcu_run_tests_qb( boolean, boolean );
void fbcu_CU_ASSERT_qb_( boolean, char*, int32, char*, char* );
int32 TESTS$QB_EXAMPLE$INIT( void );
int32 TESTS$QB_EXAMPLE$CLEANUP( void );
void TESTS$QB_EXAMPLE$ALWAYS_TRUE( void );
static void TESTS$QB_EXAMPLE$ALWAYS_TRUE_CTOR( void ) __attribute__(( constructor ));
static void TESTS$QB_EXAMPLE_CTOR34( void ) __attribute__(( constructor ));

int32 TESTS$QB_EXAMPLE$INIT( void )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$2:;
	fb$result$1 = 0;
	label$3:;
	return fb$result$1;
}

int32 TESTS$QB_EXAMPLE$CLEANUP( void )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$4:;
	fb$result$1 = 0;
	label$5:;
	return fb$result$1;
}

void TESTS$QB_EXAMPLE$ALWAYS_TRUE( void )
{
	label$6:;
	fbcu_CU_ASSERT_qb_( (boolean)1ll, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "fbcunit\x5C" "examples\x5C" "ex07.bas", 31, (char*)"TESTS.QB_EXAMPLE.ALWAYS_TRUE", (char*)"CU_ASSERT(true)" );
	label$7:;
}

__attribute__(( constructor )) static void fb_ctor__ex07( void )
{
	label$0:;
	fbcu_run_tests_qb( (boolean)1ll, (boolean)0ll );
	label$1:;
}

__attribute__(( constructor )) static void TESTS$QB_EXAMPLE$ALWAYS_TRUE_CTOR( void )
{
	label$8:;
	fbcu_add_test_qb( (char*)"qb_example", (char*)"always_true", (tmp$3)&TESTS$QB_EXAMPLE$ALWAYS_TRUE, (boolean)0ll );
	label$9:;
}

__attribute__(( constructor )) static void TESTS$QB_EXAMPLE_CTOR34( void )
{
	label$10:;
	fbcu_add_suite_qb( (char*)"qb_example", (tmp$2)&TESTS$QB_EXAMPLE$INIT, (tmp$2)&TESTS$QB_EXAMPLE$CLEANUP );
	label$11:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit\0-lang\0qb";
