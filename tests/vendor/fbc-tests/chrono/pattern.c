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
struct $N2FB8DATETIMEE {
	int64 M_TICKS;
	int16 M_OFFSET;
};
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
__FB_STATIC_ASSERT( sizeof( struct $N2FB8DATETIMEE ) == 16 );
struct $N2FB8TIMESPANE {
	int64 M_TICKS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB8TIMESPANE ) == 8 );
struct $N2FB9LOCALDATEE {
	int32 M_DAYS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB9LOCALDATEE ) == 4 );
struct $N2FB9LOCALTIMEE {
	int64 M_TICKS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB9LOCALTIMEE ) == 8 );
struct $N2FB7INSTANTE {
	int64 M_TICKS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB7INSTANTE ) == 8 );
struct $N2FB9STOPWATCHE {
	int64 M_ELAPSED;
	int64 M_STARTED;
	boolean M_RUNNING;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB9STOPWATCHE ) == 24 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
#define fb_D2L( value ) ((int64)__builtin_nearbyint( value ))
FBSTRING* fb_StrInit( void*, int64, void*, int64, int32 );
FBSTRING* fb_StrAssign( void*, int64, void*, int64, int32 );
void fb_StrDelete( FBSTRING* );
FBSTRING* fb_StrConcat( FBSTRING*, void*, int64, void*, int64 );
int32 fb_StrCompare( void*, int64, void*, int64 );
FBSTRING* fb_StrAllocTempResult( FBSTRING* );
FBSTRING* fb_StrAllocTempDescZ( char* );
int64 fb_StrLen( void*, int64 );
FBSTRING* fb_LEFT( FBSTRING*, int64 );
FBUSTRING* fb_UStrAssignFromA( void*, int64, void*, int64, int32, int32 );
FBSTRING* fb_UStrAssignToA( void*, int64, void*, int64, int32, int32 );
FBUSTRING* fb_UStrAllocTempResult( FBUSTRING* );
static void fb_ctor__pattern( void ) __attribute__(( constructor ));
void _ZN4FBCU9ADD_SUITEEPcPFivES2_( char*, tmp$4, tmp$4 );
void _ZN4FBCU8ADD_TESTEPcS0_PFvvEb( char*, char*, tmp$5, boolean );
void _ZN4FBCU10CU_ASSERT_EbPciS0_S0_( boolean, char*, int32, char*, char* );
char* setlocale( int32, char* );
int32 fb_DtFromCivil( int32, int32, int32, int32, int32, int32, int64, int64* );
int32 fb_DtDaysFromCivil( int32, int32, int32 );
void fb_DtCivilFromDays( int32, int32*, int32*, int32* );
int32 fb_DtIsLeapYear( int32 );
int32 fb_DtDaysInMonth( int32, int32 );
int32 fb_DtDaysInYear( int32 );
int32 fb_DtDayOfWeek( int32 );
int32 fb_DtDayOfYear( int32, int32, int32 );
int32 fb_DtIsoWeek( int32, int32, int32, int32* );
int32 fb_DtIsoWeeksInYear( int32 );
int32 fb_DtIsValidDate( int32, int32, int32 );
int32 fb_DtIsValidTime( int32, int32, int32, int64 );
int32 fb_DtIsValidTicks( int64 );
int64 fb_DtClockUtcNow( void );
int64 fb_DtClockResolution( void );
int32 fb_DtClockLocalOffsetNow( void );
int64 fb_DtMonoTimestamp( void );
int64 fb_DtMonoFrequency( void );
int32 fb_DtMonoIsHighRes( void );
int64 fb_DtTicksFromCounts( int64, int64 );
int32 fb_DtCpuProcessTime( int64*, int64* );
int32 fb_DtCpuThreadTime( int64*, int64* );
int32 fb_DtCpuIsSupported( void );
int32 fb_DtIsoFormat( int64, int32, char*, int32 );
int32 fb_DtIsoFormatDate( int32, char*, int32 );
int32 fb_DtIsoFormatTime( int64, char*, int32 );
int32 fb_DtIsoFormatDuration( int64, char*, int32 );
int32 fb_DtIsoParse( char*, int32, int64*, int32* );
int32 fb_DtIsoParseDate( char*, int32, int32* );
int32 fb_DtIsoParseTime( char*, int32, int64* );
int32 fb_DtIsoParseDuration( char*, int32, int64* );
int32 fb_DtPatFormat( int64, int32, char*, int32, char*, int32 );
int32 fb_DtPatParse( char*, int32, char*, int32, int64*, int32* );
int32 fb_DtZoneOffsetAt( int64 );
int32 fb_DtZoneIsDst( int64 );
int32 fb_DtZoneSupportsDst( void );
int32 fb_DtZoneStandardName( char*, int32 );
int32 fb_DtZoneDaylightName( char*, int32 );
int32 fb_DtLocaleDateString( int64, int32, char*, int32 );
int32 fb_DtLocaleTimeString( int64, int32, char*, int32 );
int32 fb_DtLocaleMonthName( int32, int32, char*, int32 );
int32 fb_DtLocaleWeekdayName( int32, int32, char*, int32 );
static double _ZN2FB5DTNANEv( void );
static boolean _ZN2FB14DTADDOVERFLOWSExx( int64, int64 );
static double _ZN2FB15DTROUNDHALFAWAYEd( double );
static int64 _ZN2FB17DTTICKSFROMDOUBLEEd( double );
static void _ZN2FB8TIMESPANC1Ev( struct $N2FB8TIMESPANE* );
static void _ZN2FB8TIMESPANC1Ex( struct $N2FB8TIMESPANE*, int64 );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN7INVALIDEv( void );
static int64 _ZN2FB8TIMESPAN12TICKS__get__Ev( struct $N2FB8TIMESPANE* );
static boolean _ZN2FB8TIMESPAN14ISVALID__get__Ev( struct $N2FB8TIMESPANE* );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN6NEGATEEv( struct $N2FB8TIMESPANE* );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN3ADDERS0_( struct $N2FB8TIMESPANE*, struct $N2FB8TIMESPANE* );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN8SUBTRACTERS0_( struct $N2FB8TIMESPANE*, struct $N2FB8TIMESPANE* );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN8MULTIPLYEd( struct $N2FB8TIMESPANE*, double );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN6DIVIDEEd( struct $N2FB8TIMESPANE*, double );
static int32 _ZN2FB8TIMESPAN9COMPARETOERS0_( struct $N2FB8TIMESPANE*, struct $N2FB8TIMESPANE* );
static FBSTRING* _ZN2FB8TIMESPAN11TOISOSTRINGEv( struct $N2FB8TIMESPANE* );
static boolean _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING*, struct $N2FB8TIMESPANE* );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN8PARSEISOER8FBSTRING( FBSTRING* );
static void _ZN2FB9LOCALDATEC1Ev( struct $N2FB9LOCALDATEE* );
static void _ZN2FB9LOCALDATEC1Eiii( struct $N2FB9LOCALDATEE*, int32, int32, int32 );
static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE13FROMDAYNUMBEREi( int32 );
static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE7INVALIDEv( void );
static boolean _ZN2FB9LOCALDATE14ISVALID__get__Ev( struct $N2FB9LOCALDATEE* );
static int32 _ZN2FB9LOCALDATE16DAYNUMBER__get__Ev( struct $N2FB9LOCALDATEE* );
static int32 _ZN2FB9LOCALDATE11YEAR__get__Ev( struct $N2FB9LOCALDATEE* );
static int32 _ZN2FB9LOCALDATE12MONTH__get__Ev( struct $N2FB9LOCALDATEE* );
static int32 _ZN2FB9LOCALDATE10DAY__get__Ev( struct $N2FB9LOCALDATEE* );
static int32 _ZN2FB9LOCALDATE14ISOWEEK__get__Ev( struct $N2FB9LOCALDATEE* );
static int32 _ZN2FB9LOCALDATE18ISOWEEKYEAR__get__Ev( struct $N2FB9LOCALDATEE* );
static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE7ADDDAYSEi( struct $N2FB9LOCALDATEE*, int32 );
static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE9ADDMONTHSEi( struct $N2FB9LOCALDATEE*, int32 );
static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE12STARTOFMONTHEv( struct $N2FB9LOCALDATEE* );
static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE10ENDOFMONTHEv( struct $N2FB9LOCALDATEE* );
static int32 _ZN2FB9LOCALDATE9COMPARETOERS0_( struct $N2FB9LOCALDATEE*, struct $N2FB9LOCALDATEE* );
static FBSTRING* _ZN2FB9LOCALDATE11TOISOSTRINGEv( struct $N2FB9LOCALDATEE* );
static boolean _ZN2FB9LOCALDATE11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING*, struct $N2FB9LOCALDATEE* );
static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE8PARSEISOER8FBSTRING( FBSTRING* );
static void _ZN2FB9LOCALTIMEC1Ev( struct $N2FB9LOCALTIMEE* );
static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME9FROMTICKSEx( int64 );
static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME7INVALIDEv( void );
static boolean _ZN2FB9LOCALTIME14ISVALID__get__Ev( struct $N2FB9LOCALTIMEE* );
static int64 _ZN2FB9LOCALTIME12TICKS__get__Ev( struct $N2FB9LOCALTIMEE* );
static int32 _ZN2FB9LOCALTIME9COMPARETOERS0_( struct $N2FB9LOCALTIMEE*, struct $N2FB9LOCALTIMEE* );
static FBSTRING* _ZN2FB9LOCALTIME11TOISOSTRINGEv( struct $N2FB9LOCALTIMEE* );
static boolean _ZN2FB9LOCALTIME11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING*, struct $N2FB9LOCALTIMEE* );
static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME8PARSEISOER8FBSTRING( FBSTRING* );
static void _ZN2FB7INSTANTC1Ev( struct $N2FB7INSTANTE* );
static void _ZN2FB7INSTANTC1Ex( struct $N2FB7INSTANTE*, int64 );
static struct $N2FB7INSTANTE _ZN2FB7INSTANT7INVALIDEv( void );
static boolean _ZN2FB7INSTANT14ISVALID__get__Ev( struct $N2FB7INSTANTE* );
static int64 _ZN2FB7INSTANT12TICKS__get__Ev( struct $N2FB7INSTANTE* );
static struct $N2FB7INSTANTE _ZN2FB7INSTANT3ADDERNS_8TIMESPANE( struct $N2FB7INSTANTE*, struct $N2FB8TIMESPANE* );
static struct $N2FB7INSTANTE _ZN2FB7INSTANT8SUBTRACTERNS_8TIMESPANE( struct $N2FB7INSTANTE*, struct $N2FB8TIMESPANE* );
static int32 _ZN2FB7INSTANT9COMPARETOERS0_( struct $N2FB7INSTANTE*, struct $N2FB7INSTANTE* );
static FBSTRING* _ZN2FB7INSTANT11TOISOSTRINGEv( struct $N2FB7INSTANTE* );
static boolean _ZN2FB7INSTANT11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING*, struct $N2FB7INSTANTE* );
static struct $N2FB7INSTANTE _ZN2FB7INSTANT8PARSEISOER8FBSTRING( FBSTRING* );
static struct $N2FB7INSTANTE _ZN2FB7INSTANT15FROMUNIXSECONDSEx( int64 );
static struct $N2FB7INSTANTE _ZN2FB7INSTANT20FROMUNIXMILLISECONDSEx( int64 );
static int64 _ZN2FB7INSTANT18UNIXSECONDS__get__Ev( struct $N2FB7INSTANTE* );
static int64 _ZN2FB7INSTANT23UNIXMILLISECONDS__get__Ev( struct $N2FB7INSTANTE* );
static int64 _ZN2FB7INSTANT23UNIXMICROSECONDS__get__Ev( struct $N2FB7INSTANTE* );
static void _ZN2FB8DATETIMEC1Ev( struct $N2FB8DATETIMEE* );
static void _ZN2FB8DATETIMEC1Eiii( struct $N2FB8DATETIMEE*, int32, int32, int32 );
static void _ZN2FB8DATETIMEC1Eiiiiiii( struct $N2FB8DATETIMEE*, int32, int32, int32, int32, int32, int32, int32 );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME9FROMTICKSExs( int64, int16 );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME11FROMINSTANTERNS_7INSTANTEs( struct $N2FB7INSTANTE*, int16 );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8MINVALUEEv( void );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8MAXVALUEEv( void );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME7INVALIDEv( void );
static boolean _ZN2FB8DATETIME14ISVALID__get__Ev( struct $N2FB8DATETIMEE* );
static int64 _ZN2FB8DATETIME12TICKS__get__Ev( struct $N2FB8DATETIMEE* );
static int16 _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( struct $N2FB8DATETIMEE* );
static boolean _ZN2FB8DATETIME16HASOFFSET__get__Ev( struct $N2FB8DATETIMEE* );
static int32 _ZN2FB8DATETIME11YEAR__get__Ev( struct $N2FB8DATETIMEE* );
static int32 _ZN2FB8DATETIME12MONTH__get__Ev( struct $N2FB8DATETIMEE* );
static int32 _ZN2FB8DATETIME10DAY__get__Ev( struct $N2FB8DATETIMEE* );
static int32 _ZN2FB8DATETIME11HOUR__get__Ev( struct $N2FB8DATETIMEE* );
static int32 _ZN2FB8DATETIME16DAYOFWEEK__get__Ev( struct $N2FB8DATETIMEE* );
static struct $N2FB9LOCALDATEE _ZN2FB8DATETIME7GETDATEEv( struct $N2FB8DATETIMEE* );
static struct $N2FB9LOCALTIMEE _ZN2FB8DATETIME12GETTIMEOFDAYEv( struct $N2FB8DATETIMEE* );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME10WITHOFFSETEs( struct $N2FB8DATETIMEE*, int16 );
static struct $N2FB7INSTANTE _ZN2FB8DATETIME9ASSUMEUTCEv( struct $N2FB8DATETIMEE* );
static struct $N2FB7INSTANTE _ZN2FB8DATETIME9TOINSTANTEv( struct $N2FB8DATETIMEE* );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME3ADDERNS_8TIMESPANE( struct $N2FB8DATETIMEE*, struct $N2FB8TIMESPANE* );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8SUBTRACTERNS_8TIMESPANE( struct $N2FB8DATETIMEE*, struct $N2FB8TIMESPANE* );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8ADDTICKSEx( struct $N2FB8DATETIMEE*, int64 );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME9ADDMONTHSEi( struct $N2FB8DATETIMEE*, int32 );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME10STARTOFDAYEv( struct $N2FB8DATETIMEE* );
static int32 _ZN2FB8DATETIME9COMPARETOERS0_( struct $N2FB8DATETIMEE*, struct $N2FB8DATETIMEE* );
static FBSTRING* _ZN2FB8DATETIME11TOISOSTRINGEv( struct $N2FB8DATETIMEE* );
static boolean _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING*, struct $N2FB8DATETIMEE* );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8PARSEISOER8FBSTRING( FBSTRING* );
static FBSTRING* _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( struct $N2FB8DATETIMEE*, FBSTRING* );
static boolean _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( struct $N2FB8DATETIMEE*, FBSTRING*, FBSTRING* );
static boolean _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( FBSTRING*, FBSTRING*, struct $N2FB8DATETIMEE* );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME10PARSEEXACTER8FBSTRINGS2_( FBSTRING*, FBSTRING* );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME17ADDCALENDARMONTHSEi( struct $N2FB8DATETIMEE*, int32 );
static FBSTRING* _ZN2FB8DATETIME18TOLOCALEDATESTRINGEi( struct $N2FB8DATETIMEE*, int32 );
static FBSTRING* _ZN2FB8DATETIME18TOLOCALETIMESTRINGEi( struct $N2FB8DATETIMEE*, int32 );
static FBSTRING* _ZN2FB8DATETIME14TOLOCALESTRINGEi( struct $N2FB8DATETIMEE*, int32 );
static FBSTRING* _ZN2FB8DATETIME9MONTHNAMEEib( int32, boolean );
static FBSTRING* _ZN2FB8DATETIME11WEEKDAYNAMEEib( int32, boolean );
static struct $N2FB8DATETIMEE _ZN2FB8DATETIME10FROMSERIALEd( double );
static double _ZN2FB8DATETIME13SERIAL__get__Ev( struct $N2FB8DATETIMEE* );
static boolean _ZN2FB15DTOFFSETISVALIDEs( int16 );
static int64 _ZN2FB10DTFLOORDIVExx( int64, int64 );
static struct $N2FB8DATETIMEE _ZN2FB9WALLCLOCK3NOWEv( void );
static void _ZN2FB9STOPWATCHC1Ev( struct $N2FB9STOPWATCHE* );
static void _ZN2FB9STOPWATCH5STARTEv( struct $N2FB9STOPWATCHE* );
static int64 _ZN2FB9STOPWATCH19ELAPSEDTICKS__get__Ev( struct $N2FB9STOPWATCHE* );
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN19FORMAT_DATE_FIELDS_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN24FORMAT_DATE_FIELDS__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN19FORMAT_TIME_FIELDS_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN24FORMAT_TIME_FIELDS__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN17FORMAT_FRACTIONS_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN22FORMAT_FRACTIONS__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN15FORMAT_OFFSETS_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN20FORMAT_OFFSETS__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN22LITERALS_AND_ESCAPING_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN27LITERALS_AND_ESCAPING__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN17CONSTANT_FORMATS_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN22CONSTANT_FORMATS__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN12PARSE_EXACT_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN17PARSE_EXACT__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN16PARSE_REJECTION_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN21PARSE_REJECTION__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN19ROUNDTRIP_PATTERNS_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN24ROUNDTRIP_PATTERNS__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN18NO_LOCALE_LEAKAGE_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN23NO_LOCALE_LEAKAGE__CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN13SUITE_CTOR329Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN19FORMAT_DATE_FIELDS_Ev( void )
{
	FBSTRING TMP$130$1;
	FBSTRING TMP$140$1;
	FBSTRING TMP$146$1;
	FBSTRING TMP$151$1;
	struct $N2FB8DATETIMEE TMP$156$1;
	FBSTRING TMP$157$1;
	FBSTRING TMP$163$1;
	FBSTRING TMP$169$1;
	FBSTRING TMP$175$1;
	FBSTRING TMP$181$1;
	struct $N2FB8DATETIMEE TMP$186$1;
	FBSTRING TMP$187$1;
	FBSTRING TMP$193$1;
	FBSTRING TMP$199$1;
	FBSTRING TMP$205$1;
	FBSTRING TMP$211$1;
	FBSTRING TMP$217$1;
	FBSTRING TMP$223$1;
	FBSTRING TMP$229$1;
	struct $N2FB8DATETIMEE TMP$234$1;
	FBSTRING TMP$235$1;
	FBSTRING TMP$241$1;
	struct $N2FB8DATETIMEE TMP$246$1;
	FBSTRING TMP$247$1;
	struct $N2FB8DATETIMEE TMP$252$1;
	FBSTRING TMP$254$1;
	struct $N2FB8DATETIMEE TMP$259$1;
	FBSTRING TMP$260$1;
	FBSTRING TMP$265$1;
	label$1082:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &D$1, 2025, 3, 4, 14, 30, 5, 0 );
	__builtin_memset( &TMP$130$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$130$1, -1ll, (void*)"y", 2ll, 0 );
	FBSTRING* vr$5 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$130$1 );
	int32 vr$6 = fb_StrCompare( (void*)vr$5, -1ll, (void*)"2025", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$6 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 17, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22y\x22 ) = \x22" "2025\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$130$1 );
	__builtin_memset( &TMP$140$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$140$1, -1ll, (void*)"yy", 3ll, 0 );
	FBSTRING* vr$15 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$140$1 );
	int32 vr$16 = fb_StrCompare( (void*)vr$15, -1ll, (void*)"25", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$16 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 18, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22yy\x22 ) = \x22" "25\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$140$1 );
	__builtin_memset( &TMP$146$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$146$1, -1ll, (void*)"yyyy", 5ll, 0 );
	FBSTRING* vr$25 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$146$1 );
	int32 vr$26 = fb_StrCompare( (void*)vr$25, -1ll, (void*)"2025", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$26 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 19, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22yyyy\x22 ) = \x22" "2025\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$146$1 );
	__builtin_memset( &TMP$151$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$151$1, -1ll, (void*)"yyyyy", 6ll, 0 );
	FBSTRING* vr$35 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$151$1 );
	int32 vr$36 = fb_StrCompare( (void*)vr$35, -1ll, (void*)"02025", 6ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$36 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 20, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22yyyyy\x22 ) = \x22" "02025\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$151$1 );
	__builtin_memset( &TMP$157$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$157$1, -1ll, (void*)"yyyy", 5ll, 0 );
	_ZN2FB8DATETIMEC1Eiii( &TMP$156$1, 1, 1, 1 );
	FBSTRING* vr$46 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$156$1, &TMP$157$1 );
	int32 vr$47 = fb_StrCompare( (void*)vr$46, -1ll, (void*)"0001", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$47 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 21, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(DateTime( 1, 1, 1 ).ToString( \x22yyyy\x22 ) = \x22" "0001\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$157$1 );
	__builtin_memset( &TMP$163$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$163$1, -1ll, (void*)"M", 2ll, 0 );
	FBSTRING* vr$56 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$163$1 );
	int32 vr$57 = fb_StrCompare( (void*)vr$56, -1ll, (void*)"3", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$57 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 23, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22M\x22 ) = \x22" "3\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$163$1 );
	__builtin_memset( &TMP$169$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$169$1, -1ll, (void*)"MM", 3ll, 0 );
	FBSTRING* vr$66 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$169$1 );
	int32 vr$67 = fb_StrCompare( (void*)vr$66, -1ll, (void*)"03", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$67 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 24, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22MM\x22 ) = \x22" "03\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$169$1 );
	__builtin_memset( &TMP$175$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$175$1, -1ll, (void*)"MMM", 4ll, 0 );
	FBSTRING* vr$76 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$175$1 );
	int32 vr$77 = fb_StrCompare( (void*)vr$76, -1ll, (void*)"Mar", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$77 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 25, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22MMM\x22 ) = \x22Mar\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$175$1 );
	__builtin_memset( &TMP$181$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$181$1, -1ll, (void*)"MMMM", 5ll, 0 );
	FBSTRING* vr$86 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$181$1 );
	int32 vr$87 = fb_StrCompare( (void*)vr$86, -1ll, (void*)"March", 6ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$87 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 26, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22MMMM\x22 ) = \x22March\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$181$1 );
	__builtin_memset( &TMP$187$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$187$1, -1ll, (void*)"MMMM", 5ll, 0 );
	_ZN2FB8DATETIMEC1Eiii( &TMP$186$1, 2025, 12, 1 );
	FBSTRING* vr$97 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$186$1, &TMP$187$1 );
	int32 vr$98 = fb_StrCompare( (void*)vr$97, -1ll, (void*)"December", 9ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$98 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 27, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 12, 1 ).ToString( \x22MMMM\x22 ) = \x22" "December\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$187$1 );
	__builtin_memset( &TMP$193$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$193$1, -1ll, (void*)"d,", 3ll, 0 );
	FBSTRING* vr$107 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$193$1 );
	int32 vr$108 = fb_StrCompare( (void*)vr$107, -1ll, (void*)"4,", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$108 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 29, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22" "d,\x22 ) = \x22" "4,\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$193$1 );
	__builtin_memset( &TMP$199$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$199$1, -1ll, (void*)"dd", 3ll, 0 );
	FBSTRING* vr$117 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$199$1 );
	int32 vr$118 = fb_StrCompare( (void*)vr$117, -1ll, (void*)"04", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$118 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 30, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22" "dd\x22 ) = \x22" "04\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$199$1 );
	__builtin_memset( &TMP$205$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$205$1, -1ll, (void*)"ddd", 4ll, 0 );
	FBSTRING* vr$127 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$205$1 );
	int32 vr$128 = fb_StrCompare( (void*)vr$127, -1ll, (void*)"Tue", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$128 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 31, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22" "ddd\x22 ) = \x22Tue\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$205$1 );
	__builtin_memset( &TMP$211$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$211$1, -1ll, (void*)"dddd", 5ll, 0 );
	FBSTRING* vr$137 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$211$1 );
	int32 vr$138 = fb_StrCompare( (void*)vr$137, -1ll, (void*)"Tuesday", 8ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$138 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 32, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22" "dddd\x22 ) = \x22Tuesday\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$211$1 );
	__builtin_memset( &TMP$217$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$217$1, -1ll, (void*)"D,", 3ll, 0 );
	FBSTRING* vr$147 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$217$1 );
	int32 vr$148 = fb_StrCompare( (void*)vr$147, -1ll, (void*)"63,", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$148 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 34, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22" "D,\x22 ) = \x22" "63,\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$217$1 );
	__builtin_memset( &TMP$223$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$223$1, -1ll, (void*)"DDD", 4ll, 0 );
	FBSTRING* vr$157 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$223$1 );
	int32 vr$158 = fb_StrCompare( (void*)vr$157, -1ll, (void*)"063", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$158 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 35, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22" "DDD\x22 ) = \x22" "063\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$223$1 );
	__builtin_memset( &TMP$229$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$229$1, -1ll, (void*)"Q", 2ll, 0 );
	FBSTRING* vr$167 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$229$1 );
	int32 vr$168 = fb_StrCompare( (void*)vr$167, -1ll, (void*)"1", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$168 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 36, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22Q\x22 ) = \x22" "1\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$229$1 );
	__builtin_memset( &TMP$235$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$235$1, -1ll, (void*)"Q", 2ll, 0 );
	_ZN2FB8DATETIMEC1Eiii( &TMP$234$1, 2025, 12, 1 );
	FBSTRING* vr$178 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$234$1, &TMP$235$1 );
	int32 vr$179 = fb_StrCompare( (void*)vr$178, -1ll, (void*)"4", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$179 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 37, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 12, 1 ).ToString( \x22Q\x22 ) = \x22" "4\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$235$1 );
	__builtin_memset( &TMP$241$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$241$1, -1ll, (void*)"ww", 3ll, 0 );
	FBSTRING* vr$188 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$241$1 );
	int32 vr$189 = fb_StrCompare( (void*)vr$188, -1ll, (void*)"10", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$189 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 38, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22ww\x22 ) = \x22" "10\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$241$1 );
	__builtin_memset( &TMP$247$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$247$1, -1ll, (void*)"ww", 3ll, 0 );
	_ZN2FB8DATETIMEC1Eiii( &TMP$246$1, 2025, 12, 29 );
	FBSTRING* vr$199 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$246$1, &TMP$247$1 );
	int32 vr$200 = fb_StrCompare( (void*)vr$199, -1ll, (void*)"01", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$200 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 39, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 12, 29 ).ToString( \x22ww\x22 ) = \x22" "01\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$247$1 );
	__builtin_memset( &TMP$254$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$254$1, -1ll, (void*)"Y", 2ll, 0 );
	_ZN2FB8DATETIMEC1Eiii( &TMP$252$1, 2025, 12, 29 );
	FBSTRING* vr$210 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$252$1, &TMP$254$1 );
	int32 vr$211 = fb_StrCompare( (void*)vr$210, -1ll, (void*)"2026", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$211 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 40, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 12, 29 ).ToString( \x22Y\x22 ) = \x22" "2026\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$254$1 );
	__builtin_memset( &TMP$260$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$260$1, -1ll, (void*)"yyyy", 5ll, 0 );
	_ZN2FB8DATETIMEC1Eiii( &TMP$259$1, 2025, 12, 29 );
	FBSTRING* vr$221 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$259$1, &TMP$260$1 );
	int32 vr$222 = fb_StrCompare( (void*)vr$221, -1ll, (void*)"2025", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$222 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 41, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 12, 29 ).ToString( \x22yyyy\x22 ) = \x22" "2025\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$260$1 );
	__builtin_memset( &TMP$265$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$265$1, -1ll, (void*)"g", 2ll, 0 );
	FBSTRING* vr$231 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$265$1 );
	int32 vr$232 = fb_StrCompare( (void*)vr$231, -1ll, (void*)"A.D.", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$232 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 42, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_DATE_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22g\x22 ) = \x22" "A.D.\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$265$1 );
	label$1083:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN19FORMAT_TIME_FIELDS_Ev( void )
{
	FBSTRING TMP$274$1;
	FBSTRING TMP$281$1;
	FBSTRING TMP$287$1;
	FBSTRING TMP$293$1;
	FBSTRING TMP$299$1;
	FBSTRING TMP$305$1;
	FBSTRING TMP$311$1;
	FBSTRING TMP$317$1;
	FBSTRING TMP$323$1;
	FBSTRING TMP$329$1;
	struct $N2FB8DATETIMEE TMP$334$1;
	FBSTRING TMP$336$1;
	struct $N2FB8DATETIMEE TMP$341$1;
	FBSTRING TMP$342$1;
	struct $N2FB8DATETIMEE TMP$347$1;
	FBSTRING TMP$348$1;
	struct $N2FB8DATETIMEE TMP$353$1;
	FBSTRING TMP$354$1;
	struct $N2FB8DATETIMEE TMP$359$1;
	FBSTRING TMP$361$1;
	struct $N2FB8DATETIMEE TMP$366$1;
	FBSTRING TMP$368$1;
	label$1086:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &D$1, 2025, 3, 4, 14, 30, 5, 0 );
	__builtin_memset( &TMP$274$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$274$1, -1ll, (void*)"H,", 3ll, 0 );
	FBSTRING* vr$5 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$274$1 );
	int32 vr$6 = fb_StrCompare( (void*)vr$5, -1ll, (void*)"14,", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$6 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 48, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22H,\x22 ) = \x22" "14,\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$274$1 );
	__builtin_memset( &TMP$281$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$281$1, -1ll, (void*)"HH", 3ll, 0 );
	FBSTRING* vr$15 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$281$1 );
	int32 vr$16 = fb_StrCompare( (void*)vr$15, -1ll, (void*)"14", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$16 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 49, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22HH\x22 ) = \x22" "14\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$281$1 );
	__builtin_memset( &TMP$287$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$287$1, -1ll, (void*)"h,", 3ll, 0 );
	FBSTRING* vr$25 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$287$1 );
	int32 vr$26 = fb_StrCompare( (void*)vr$25, -1ll, (void*)"2,", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$26 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 50, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22h,\x22 ) = \x22" "2,\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$287$1 );
	__builtin_memset( &TMP$293$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$293$1, -1ll, (void*)"hh", 3ll, 0 );
	FBSTRING* vr$35 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$293$1 );
	int32 vr$36 = fb_StrCompare( (void*)vr$35, -1ll, (void*)"02", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$36 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 51, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22hh\x22 ) = \x22" "02\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$293$1 );
	__builtin_memset( &TMP$299$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$299$1, -1ll, (void*)"m,", 3ll, 0 );
	FBSTRING* vr$45 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$299$1 );
	int32 vr$46 = fb_StrCompare( (void*)vr$45, -1ll, (void*)"30,", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$46 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 52, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22m,\x22 ) = \x22" "30,\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$299$1 );
	__builtin_memset( &TMP$305$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$305$1, -1ll, (void*)"mm", 3ll, 0 );
	FBSTRING* vr$55 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$305$1 );
	int32 vr$56 = fb_StrCompare( (void*)vr$55, -1ll, (void*)"30", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$56 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 53, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22mm\x22 ) = \x22" "30\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$305$1 );
	__builtin_memset( &TMP$311$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$311$1, -1ll, (void*)"s,", 3ll, 0 );
	FBSTRING* vr$65 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$311$1 );
	int32 vr$66 = fb_StrCompare( (void*)vr$65, -1ll, (void*)"5,", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$66 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 54, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22s,\x22 ) = \x22" "5,\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$311$1 );
	__builtin_memset( &TMP$317$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$317$1, -1ll, (void*)"ss", 3ll, 0 );
	FBSTRING* vr$75 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$317$1 );
	int32 vr$76 = fb_StrCompare( (void*)vr$75, -1ll, (void*)"05", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$76 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 55, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22ss\x22 ) = \x22" "05\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$317$1 );
	__builtin_memset( &TMP$323$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$323$1, -1ll, (void*)"t,", 3ll, 0 );
	FBSTRING* vr$85 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$323$1 );
	int32 vr$86 = fb_StrCompare( (void*)vr$85, -1ll, (void*)"P,", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$86 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 56, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22t,\x22 ) = \x22P,\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$323$1 );
	__builtin_memset( &TMP$329$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$329$1, -1ll, (void*)"tt", 3ll, 0 );
	FBSTRING* vr$95 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$329$1 );
	int32 vr$96 = fb_StrCompare( (void*)vr$95, -1ll, (void*)"PM", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$96 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 57, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(d.ToString( \x22tt\x22 ) = \x22PM\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$329$1 );
	__builtin_memset( &TMP$336$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$336$1, -1ll, (void*)"h tt", 5ll, 0 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$334$1, 2025, 3, 4, 0, 0, 0, 0 );
	FBSTRING* vr$106 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$334$1, &TMP$336$1 );
	int32 vr$107 = fb_StrCompare( (void*)vr$106, -1ll, (void*)"12 AM", 6ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$107 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 60, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 0, 0, 0, 0 ).ToString( \x22h tt\x22 ) = \x22" "12 AM\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$336$1 );
	__builtin_memset( &TMP$342$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$342$1, -1ll, (void*)"h tt", 5ll, 0 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$341$1, 2025, 3, 4, 12, 0, 0, 0 );
	FBSTRING* vr$117 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$341$1, &TMP$342$1 );
	int32 vr$118 = fb_StrCompare( (void*)vr$117, -1ll, (void*)"12 PM", 6ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$118 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 61, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 12, 0, 0, 0 ).ToString( \x22h tt\x22 ) = \x22" "12 PM\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$342$1 );
	__builtin_memset( &TMP$348$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$348$1, -1ll, (void*)"h tt", 5ll, 0 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$347$1, 2025, 3, 4, 11, 59, 0, 0 );
	FBSTRING* vr$128 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$347$1, &TMP$348$1 );
	int32 vr$129 = fb_StrCompare( (void*)vr$128, -1ll, (void*)"11 AM", 6ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$129 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 62, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 11, 59, 0, 0 ).ToString( \x22h tt\x22 ) = \x22" "11 AM\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$348$1 );
	__builtin_memset( &TMP$354$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$354$1, -1ll, (void*)"h tt", 5ll, 0 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$353$1, 2025, 3, 4, 13, 0, 0, 0 );
	FBSTRING* vr$139 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$353$1, &TMP$354$1 );
	int32 vr$140 = fb_StrCompare( (void*)vr$139, -1ll, (void*)"1 PM", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$140 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 63, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 13, 0, 0, 0 ).ToString( \x22h tt\x22 ) = \x22" "1 PM\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$354$1 );
	__builtin_memset( &TMP$361$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$361$1, -1ll, (void*)"hh tt", 6ll, 0 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$359$1, 2025, 3, 4, 23, 0, 0, 0 );
	FBSTRING* vr$150 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$359$1, &TMP$361$1 );
	int32 vr$151 = fb_StrCompare( (void*)vr$150, -1ll, (void*)"11 PM", 6ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$151 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 64, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 23, 0, 0, 0 ).ToString( \x22hh tt\x22 ) = \x22" "11 PM\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$361$1 );
	__builtin_memset( &TMP$368$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$368$1, -1ll, (void*)"yyyy-MM-dd HH:mm:ss", 20ll, 0 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$366$1, 2025, 1, 2, 3, 4, 5, 0 );
	FBSTRING* vr$161 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$366$1, &TMP$368$1 );
	int32 vr$162 = fb_StrCompare( (void*)vr$161, -1ll, (void*)"2025-01-02 03:04:05", 20ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$162 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 67, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_TIME_FIELDS_", (char*)"CU_ASSERT(DateTime( 2025, 1, 2, 3, 4, 5, 0 ).ToString( \x22yyyy-MM-dd HH:mm:ss\x22 ) = \x09            \x22" "2025-01-02 03:04:05\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$368$1 );
	label$1087:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN17FORMAT_FRACTIONS_Ev( void )
{
	FBSTRING TMP$378$1;
	FBSTRING TMP$385$1;
	FBSTRING TMP$391$1;
	FBSTRING TMP$397$1;
	FBSTRING TMP$403$1;
	FBSTRING TMP$407$1;
	FBSTRING TMP$412$1;
	FBSTRING TMP$417$1;
	FBSTRING TMP$422$1;
	FBSTRING TMP$428$1;
	label$1090:;
	struct $N2FB8DATETIMEE A$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &A$1, 2025, 3, 4, 0, 0, 0, 120 );
	struct $N2FB8DATETIMEE Z$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &Z$1, 2025, 3, 4, 0, 0, 0, 0 );
	__builtin_memset( &TMP$378$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$378$1, -1ll, (void*)"fff", 4ll, 0 );
	FBSTRING* vr$6 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &A$1, &TMP$378$1 );
	int32 vr$7 = fb_StrCompare( (void*)vr$6, -1ll, (void*)"120", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$7 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 75, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(a.ToString( \x22" "fff\x22 ) = \x22" "120\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$378$1 );
	__builtin_memset( &TMP$385$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$385$1, -1ll, (void*)"FFF", 4ll, 0 );
	FBSTRING* vr$16 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &A$1, &TMP$385$1 );
	int32 vr$17 = fb_StrCompare( (void*)vr$16, -1ll, (void*)"12", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$17 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 76, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(a.ToString( \x22" "FFF\x22 ) = \x22" "12\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$385$1 );
	__builtin_memset( &TMP$391$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$391$1, -1ll, (void*)"f,", 3ll, 0 );
	FBSTRING* vr$26 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &A$1, &TMP$391$1 );
	int32 vr$27 = fb_StrCompare( (void*)vr$26, -1ll, (void*)"1,", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$27 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 77, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(a.ToString( \x22" "f,\x22 ) = \x22" "1,\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$391$1 );
	__builtin_memset( &TMP$397$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$397$1, -1ll, (void*)"fffffff", 8ll, 0 );
	FBSTRING* vr$36 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &A$1, &TMP$397$1 );
	int32 vr$37 = fb_StrCompare( (void*)vr$36, -1ll, (void*)"1200000", 8ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$37 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 78, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(a.ToString( \x22" "fffffff\x22 ) = \x22" "1200000\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$397$1 );
	__builtin_memset( &TMP$403$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$403$1, -1ll, (void*)"FFFFFFF", 8ll, 0 );
	FBSTRING* vr$46 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &A$1, &TMP$403$1 );
	int32 vr$47 = fb_StrCompare( (void*)vr$46, -1ll, (void*)"12", 3ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$47 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 79, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(a.ToString( \x22" "FFFFFFF\x22 ) = \x22" "12\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$403$1 );
	__builtin_memset( &TMP$407$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$407$1, -1ll, (void*)"fff", 4ll, 0 );
	FBSTRING* vr$56 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &Z$1, &TMP$407$1 );
	int32 vr$57 = fb_StrCompare( (void*)vr$56, -1ll, (void*)"000", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$57 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 81, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(z.ToString( \x22" "fff\x22 ) = \x22" "000\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$407$1 );
	__builtin_memset( &TMP$412$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$412$1, -1ll, (void*)"FFF", 4ll, 0 );
	FBSTRING* vr$66 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &Z$1, &TMP$412$1 );
	int32 vr$67 = fb_StrCompare( (void*)vr$66, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$67 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 82, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(z.ToString( \x22" "FFF\x22 ) = \x22\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$412$1 );
	__builtin_memset( &TMP$417$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$417$1, -1ll, (void*)"HH:mm:ss.FFF", 13ll, 0 );
	FBSTRING* vr$76 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &Z$1, &TMP$417$1 );
	int32 vr$77 = fb_StrCompare( (void*)vr$76, -1ll, (void*)"00:00:00", 9ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$77 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 85, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(z.ToString( \x22HH:mm:ss.FFF\x22 ) = \x22" "00:00:00\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$417$1 );
	__builtin_memset( &TMP$422$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$422$1, -1ll, (void*)"HH:mm:ss.FFF", 13ll, 0 );
	FBSTRING* vr$86 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &A$1, &TMP$422$1 );
	int32 vr$87 = fb_StrCompare( (void*)vr$86, -1ll, (void*)"00:00:00.12", 12ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$87 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 86, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(a.ToString( \x22HH:mm:ss.FFF\x22 ) = \x22" "00:00:00.12\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$422$1 );
	__builtin_memset( &TMP$428$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$428$1, -1ll, (void*)"HH:mm:ss.fff", 13ll, 0 );
	FBSTRING* vr$96 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &Z$1, &TMP$428$1 );
	int32 vr$97 = fb_StrCompare( (void*)vr$96, -1ll, (void*)"00:00:00.000", 13ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$97 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 87, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_FRACTIONS_", (char*)"CU_ASSERT(z.ToString( \x22HH:mm:ss.fff\x22 ) = \x22" "00:00:00.000\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$428$1 );
	label$1091:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN15FORMAT_OFFSETS_Ev( void )
{
	struct $N2FB8DATETIMEE TMP$435$1;
	struct $N2FB8DATETIMEE TMP$436$1;
	struct $N2FB8DATETIMEE TMP$438$1;
	FBSTRING TMP$440$1;
	FBSTRING TMP$447$1;
	FBSTRING TMP$453$1;
	FBSTRING TMP$458$1;
	FBSTRING TMP$464$1;
	FBSTRING TMP$469$1;
	FBSTRING TMP$473$1;
	FBSTRING TMP$477$1;
	label$1094:;
	struct $N2FB8DATETIMEE O$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$435$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE vr$2 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$435$1, (int16)330 );
	O$1 = vr$2;
	struct $N2FB8DATETIMEE U$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$436$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE vr$5 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$436$1, (int16)0 );
	U$1 = vr$5;
	struct $N2FB8DATETIMEE N$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &N$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE W$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$438$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE vr$9 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$438$1, (int16)-300 );
	W$1 = vr$9;
	__builtin_memset( &TMP$440$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$440$1, -1ll, (void*)"zzz", 4ll, 0 );
	FBSTRING* vr$14 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &O$1, &TMP$440$1 );
	int32 vr$15 = fb_StrCompare( (void*)vr$14, -1ll, (void*)"+05:30", 7ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$15 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 96, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_OFFSETS_", (char*)"CU_ASSERT(o.ToString( \x22zzz\x22 ) = \x22+05:30\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$440$1 );
	__builtin_memset( &TMP$447$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$447$1, -1ll, (void*)"zz", 3ll, 0 );
	FBSTRING* vr$24 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &O$1, &TMP$447$1 );
	int32 vr$25 = fb_StrCompare( (void*)vr$24, -1ll, (void*)"+05", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$25 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 97, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_OFFSETS_", (char*)"CU_ASSERT(o.ToString( \x22zz\x22 ) = \x22+05\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$447$1 );
	__builtin_memset( &TMP$453$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$453$1, -1ll, (void*)"z,", 3ll, 0 );
	FBSTRING* vr$34 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &O$1, &TMP$453$1 );
	int32 vr$35 = fb_StrCompare( (void*)vr$34, -1ll, (void*)"+5,", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$35 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 98, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_OFFSETS_", (char*)"CU_ASSERT(o.ToString( \x22z,\x22 ) = \x22+5,\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$453$1 );
	__builtin_memset( &TMP$458$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$458$1, -1ll, (void*)"zzz", 4ll, 0 );
	FBSTRING* vr$44 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &W$1, &TMP$458$1 );
	int32 vr$45 = fb_StrCompare( (void*)vr$44, -1ll, (void*)"-05:00", 7ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$45 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 99, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_OFFSETS_", (char*)"CU_ASSERT(w.ToString( \x22zzz\x22 ) = \x22-05:00\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$458$1 );
	__builtin_memset( &TMP$464$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$464$1, -1ll, (void*)"K", 2ll, 0 );
	FBSTRING* vr$54 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &U$1, &TMP$464$1 );
	int32 vr$55 = fb_StrCompare( (void*)vr$54, -1ll, (void*)"Z", 2ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$55 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 101, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_OFFSETS_", (char*)"CU_ASSERT(u.ToString( \x22K\x22 ) = \x22Z\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$464$1 );
	__builtin_memset( &TMP$469$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$469$1, -1ll, (void*)"K", 2ll, 0 );
	FBSTRING* vr$64 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &O$1, &TMP$469$1 );
	int32 vr$65 = fb_StrCompare( (void*)vr$64, -1ll, (void*)"+05:30", 7ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$65 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 102, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_OFFSETS_", (char*)"CU_ASSERT(o.ToString( \x22K\x22 ) = \x22+05:30\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$469$1 );
	__builtin_memset( &TMP$473$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$473$1, -1ll, (void*)"K", 2ll, 0 );
	FBSTRING* vr$74 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &N$1, &TMP$473$1 );
	int32 vr$75 = fb_StrCompare( (void*)vr$74, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$75 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 103, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_OFFSETS_", (char*)"CU_ASSERT(n.ToString( \x22K\x22 ) = \x22\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$473$1 );
	FBSTRING R$1;
	__builtin_memset( &R$1, 0, 24ll );
	__builtin_memset( &TMP$477$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$477$1, -1ll, (void*)"K", 2ll, 0 );
	boolean vr$86 = _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( &N$1, &TMP$477$1, &R$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$86, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 106, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_OFFSETS_", (char*)"CU_ASSERT(n.TryFormat( \x22K\x22, r ))" );
	fb_StrDelete( (FBSTRING*)&TMP$477$1 );
	int32 vr$89 = fb_StrCompare( (void*)&R$1, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$89 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 107, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.FORMAT_OFFSETS_", (char*)"CU_ASSERT(r = \x22\x22)" );
	fb_StrDelete( (FBSTRING*)&R$1 );
	label$1095:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN22LITERALS_AND_ESCAPING_Ev( void )
{
	FBSTRING TMP$488$1;
	FBSTRING TMP$495$1;
	FBSTRING TMP$501$1;
	FBSTRING TMP$507$1;
	FBSTRING TMP$513$1;
	FBSTRING TMP$519$1;
	FBSTRING TMP$524$1;
	FBSTRING TMP$530$1;
	FBSTRING TMP$536$1;
	FBSTRING TMP$540$1;
	FBSTRING TMP$545$1;
	FBSTRING TMP$550$1;
	FBSTRING TMP$555$1;
	FBSTRING TMP$560$1;
	FBSTRING TMP$565$1;
	struct $N2FB8DATETIMEE TMP$569$1;
	FBSTRING TMP$570$1;
	struct $N2FB8DATETIMEE TMP$574$1;
	FBSTRING TMP$575$1;
	label$1098:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &D$1, 2025, 3, 4, 14, 30, 5, 0 );
	FBSTRING R$1;
	__builtin_memset( &R$1, 0, 24ll );
	__builtin_memset( &TMP$488$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$488$1, -1ll, (void*)"'at' HH:mm", 11ll, 0 );
	FBSTRING* vr$6 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$488$1 );
	int32 vr$7 = fb_StrCompare( (void*)vr$6, -1ll, (void*)"at 14:30", 9ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$7 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 114, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.ToString( \x22'at' HH:mm\x22 ) = \x22" "at 14:30\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$488$1 );
	__builtin_memset( &TMP$495$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$495$1, -1ll, (void*)"\x5CH\x5CHmm", 7ll, 0 );
	FBSTRING* vr$16 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$495$1 );
	int32 vr$17 = fb_StrCompare( (void*)vr$16, -1ll, (void*)"HH30", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$17 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 115, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.ToString( \x22\x5CH\x5CHmm\x22 ) = \x22HH30\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$495$1 );
	__builtin_memset( &TMP$501$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$501$1, -1ll, (void*)"yyyy-MM-dd", 11ll, 0 );
	FBSTRING* vr$26 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$501$1 );
	int32 vr$27 = fb_StrCompare( (void*)vr$26, -1ll, (void*)"2025-03-04", 11ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$27 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 116, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.ToString( \x22yyyy-MM-dd\x22 ) = \x22" "2025-03-04\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$501$1 );
	__builtin_memset( &TMP$507$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$507$1, -1ll, (void*)"HH:mm:ss", 9ll, 0 );
	FBSTRING* vr$36 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$507$1 );
	int32 vr$37 = fb_StrCompare( (void*)vr$36, -1ll, (void*)"14:30:05", 9ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$37 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 117, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.ToString( \x22HH:mm:ss\x22 ) = \x22" "14:30:05\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$507$1 );
	__builtin_memset( &TMP$513$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$513$1, -1ll, (void*)"'it''s' HH", 11ll, 0 );
	FBSTRING* vr$46 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$513$1 );
	int32 vr$47 = fb_StrCompare( (void*)vr$46, -1ll, (void*)"it's 14", 8ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$47 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 120, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.ToString( \x22'it''s' HH\x22 ) = \x22it's 14\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$513$1 );
	__builtin_memset( &TMP$519$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$519$1, -1ll, (void*)"''", 3ll, 0 );
	FBSTRING* vr$56 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$519$1 );
	int32 vr$57 = fb_StrCompare( (void*)vr$56, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$57 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 121, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.ToString( \x22''\x22 ) = \x22\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$519$1 );
	__builtin_memset( &TMP$524$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$524$1, -1ll, (void*)"\x5C'HH", 5ll, 0 );
	FBSTRING* vr$66 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$524$1 );
	int32 vr$67 = fb_StrCompare( (void*)vr$66, -1ll, (void*)"'14", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$67 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 122, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.ToString( \x22\x5C'HH\x22 ) = \x22'14\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$524$1 );
	__builtin_memset( &TMP$530$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$530$1, -1ll, (void*)"[HH]", 5ll, 0 );
	FBSTRING* vr$76 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$530$1 );
	int32 vr$77 = fb_StrCompare( (void*)vr$76, -1ll, (void*)"[14]", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$77 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 123, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.ToString( \x22[HH]\x22 ) = \x22[14]\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$530$1 );
	__builtin_memset( &TMP$536$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$536$1, -1ll, (void*)"'abc", 5ll, 0 );
	boolean vr$87 = _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( &D$1, &TMP$536$1, &R$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$87 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 126, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.TryFormat( \x22'abc\x22, r ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$536$1 );
	__builtin_memset( &TMP$540$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$540$1, -1ll, (void*)"'abc", 5ll, 0 );
	FBSTRING* vr$94 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$540$1 );
	int32 vr$95 = fb_StrCompare( (void*)vr$94, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$95 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 127, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.ToString( \x22'abc\x22 ) = \x22\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$540$1 );
	__builtin_memset( &TMP$545$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$545$1, -1ll, (void*)"yyyy P", 7ll, 0 );
	boolean vr$105 = _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( &D$1, &TMP$545$1, &R$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$105 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 128, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.TryFormat( \x22yyyy P\x22, r ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$545$1 );
	__builtin_memset( &TMP$550$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$550$1, -1ll, (void*)"yyyy x", 7ll, 0 );
	boolean vr$113 = _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( &D$1, &TMP$550$1, &R$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$113 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 129, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.TryFormat( \x22yyyy x\x22, r ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$550$1 );
	__builtin_memset( &TMP$555$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$555$1, -1ll, (void*)"\x5C", 2ll, 0 );
	boolean vr$121 = _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( &D$1, &TMP$555$1, &R$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$121 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 130, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.TryFormat( \x22\x5C\x22, r ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$555$1 );
	__builtin_memset( &TMP$560$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$560$1, -1ll, (void*)"MMMMM", 6ll, 0 );
	boolean vr$129 = _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( &D$1, &TMP$560$1, &R$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$129 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 131, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.TryFormat( \x22MMMMM\x22, r ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$560$1 );
	__builtin_memset( &TMP$565$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$565$1, -1ll, (void*)"HHH", 4ll, 0 );
	boolean vr$137 = _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( &D$1, &TMP$565$1, &R$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$137 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 132, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(d.TryFormat( \x22HHH\x22, r ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$565$1 );
	__builtin_memset( &TMP$570$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$570$1, -1ll, (void*)"yyyy", 5ll, 0 );
	struct $N2FB8DATETIMEE vr$144 = _ZN2FB8DATETIME7INVALIDEv(  );
	TMP$569$1 = vr$144;
	boolean vr$146 = _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( &TMP$569$1, &TMP$570$1, &R$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$146 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 135, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(DateTime.Invalid.TryFormat( \x22yyyy\x22, r ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$570$1 );
	__builtin_memset( &TMP$575$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$575$1, -1ll, (void*)"yyyy", 5ll, 0 );
	struct $N2FB8DATETIMEE vr$152 = _ZN2FB8DATETIME7INVALIDEv(  );
	TMP$574$1 = vr$152;
	FBSTRING* vr$154 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$574$1, &TMP$575$1 );
	int32 vr$155 = fb_StrCompare( (void*)vr$154, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$155 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 136, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.LITERALS_AND_ESCAPING_", (char*)"CU_ASSERT(DateTime.Invalid.ToString( \x22yyyy\x22 ) = \x22\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$575$1 );
	fb_StrDelete( (FBSTRING*)&R$1 );
	label$1099:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN17CONSTANT_FORMATS_Ev( void )
{
	struct $N2FB8DATETIMEE TMP$581$1;
	FBSTRING TMP$583$1;
	FBSTRING TMP$589$1;
	struct $N2FB8DATETIMEE TMP$593$1;
	FBSTRING TMP$594$1;
	struct $N2FB8DATETIMEE TMP$595$1;
	struct $N2FB8DATETIMEE TMP$599$1;
	FBSTRING TMP$600$1;
	struct $N2FB8DATETIMEE TMP$601$1;
	struct $N2FB8DATETIMEE TMP$605$1;
	FBSTRING TMP$606$1;
	struct $N2FB8DATETIMEE TMP$607$1;
	FBSTRING TMP$612$1;
	FBSTRING TMP$618$1;
	FBSTRING TMP$623$1;
	FBSTRING TMP$628$1;
	FBSTRING TMP$634$1;
	struct $N2FB8DATETIMEE TMP$639$1;
	struct $N2FB8DATETIMEE TMP$640$1;
	FBSTRING TMP$641$1;
	label$1102:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$581$1, 2025, 3, 4, 14, 30, 5, 120 );
	struct $N2FB8DATETIMEE vr$2 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$581$1, (int16)330 );
	D$1 = vr$2;
	FBSTRING* vr$4 = _ZN2FB8DATETIME11TOISOSTRINGEv( &D$1 );
	__builtin_memset( &TMP$583$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$583$1, -1ll, (void*)"o", 2ll, 0 );
	FBSTRING* vr$9 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$583$1 );
	int32 vr$10 = fb_StrCompare( (void*)vr$9, -1ll, (void*)vr$4, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$10 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 145, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(d.ToString( \x22o\x22 ) = d.ToIsoString( ))" );
	fb_StrDelete( (FBSTRING*)&TMP$583$1 );
	FBSTRING* vr$16 = _ZN2FB8DATETIME11TOISOSTRINGEv( &D$1 );
	__builtin_memset( &TMP$589$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$589$1, -1ll, (void*)"O", 2ll, 0 );
	FBSTRING* vr$21 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$589$1 );
	int32 vr$22 = fb_StrCompare( (void*)vr$21, -1ll, (void*)vr$16, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$22 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 146, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(d.ToString( \x22O\x22 ) = d.ToIsoString( ))" );
	fb_StrDelete( (FBSTRING*)&TMP$589$1 );
	struct $N2FB8DATETIMEE vr$27 = _ZN2FB8DATETIME8MINVALUEEv(  );
	TMP$595$1 = vr$27;
	FBSTRING* vr$29 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$595$1 );
	__builtin_memset( &TMP$594$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$594$1, -1ll, (void*)"o", 2ll, 0 );
	struct $N2FB8DATETIMEE vr$33 = _ZN2FB8DATETIME8MINVALUEEv(  );
	TMP$593$1 = vr$33;
	FBSTRING* vr$35 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$593$1, &TMP$594$1 );
	int32 vr$36 = fb_StrCompare( (void*)vr$35, -1ll, (void*)vr$29, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$36 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 147, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(DateTime.MinValue.ToString( \x22o\x22 ) = DateTime.MinValue.ToIsoString( ))" );
	fb_StrDelete( (FBSTRING*)&TMP$594$1 );
	struct $N2FB8DATETIMEE vr$41 = _ZN2FB8DATETIME8MAXVALUEEv(  );
	TMP$601$1 = vr$41;
	FBSTRING* vr$43 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$601$1 );
	__builtin_memset( &TMP$600$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$600$1, -1ll, (void*)"o", 2ll, 0 );
	struct $N2FB8DATETIMEE vr$47 = _ZN2FB8DATETIME8MAXVALUEEv(  );
	TMP$599$1 = vr$47;
	FBSTRING* vr$49 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$599$1, &TMP$600$1 );
	int32 vr$50 = fb_StrCompare( (void*)vr$49, -1ll, (void*)vr$43, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$50 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 148, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(DateTime.MaxValue.ToString( \x22o\x22 ) = DateTime.MaxValue.ToIsoString( ))" );
	fb_StrDelete( (FBSTRING*)&TMP$600$1 );
	_ZN2FB8DATETIMEC1Eiii( &TMP$607$1, 2025, 3, 4 );
	FBSTRING* vr$57 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$607$1 );
	__builtin_memset( &TMP$606$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$606$1, -1ll, (void*)"o", 2ll, 0 );
	_ZN2FB8DATETIMEC1Eiii( &TMP$605$1, 2025, 3, 4 );
	FBSTRING* vr$63 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$605$1, &TMP$606$1 );
	int32 vr$64 = fb_StrCompare( (void*)vr$63, -1ll, (void*)vr$57, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$64 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 149, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4 ).ToString( \x22o\x22 ) = DateTime( 2025, 3, 4 ).ToIsoString( ))" );
	fb_StrDelete( (FBSTRING*)&TMP$606$1 );
	__builtin_memset( &TMP$612$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$612$1, -1ll, (void*)"s", 2ll, 0 );
	FBSTRING* vr$73 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$612$1 );
	int32 vr$74 = fb_StrCompare( (void*)vr$73, -1ll, (void*)"2025-03-04T14:30:05", 20ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$74 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 151, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(d.ToString( \x22s\x22 ) = \x22" "2025-03-04T14:30:05\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$612$1 );
	__builtin_memset( &TMP$618$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$618$1, -1ll, (void*)"d", 2ll, 0 );
	FBSTRING* vr$83 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$618$1 );
	int32 vr$84 = fb_StrCompare( (void*)vr$83, -1ll, (void*)"2025-03-04", 11ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$84 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 152, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(d.ToString( \x22" "d\x22 ) = \x22" "2025-03-04\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$618$1 );
	__builtin_memset( &TMP$623$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$623$1, -1ll, (void*)"T", 2ll, 0 );
	FBSTRING* vr$93 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$623$1 );
	int32 vr$94 = fb_StrCompare( (void*)vr$93, -1ll, (void*)"14:30:05", 9ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$94 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 153, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(d.ToString( \x22T\x22 ) = \x22" "14:30:05\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$623$1 );
	__builtin_memset( &TMP$628$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$628$1, -1ll, (void*)"u", 2ll, 0 );
	FBSTRING* vr$103 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$628$1 );
	int32 vr$104 = fb_StrCompare( (void*)vr$103, -1ll, (void*)"2025-03-04 09:00:05Z", 21ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$104 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 156, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(d.ToString( \x22u\x22 ) = \x22" "2025-03-04 09:00:05Z\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$628$1 );
	__builtin_memset( &TMP$634$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$634$1, -1ll, (void*)"R", 2ll, 0 );
	FBSTRING* vr$113 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$634$1 );
	int32 vr$114 = fb_StrCompare( (void*)vr$113, -1ll, (void*)"Tue, 04 Mar 2025 09:00:05 GMT", 30ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$114 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 157, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(d.ToString( \x22R\x22 ) = \x22Tue, 04 Mar 2025 09:00:05 GMT\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$634$1 );
	__builtin_memset( &TMP$641$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$641$1, -1ll, (void*)"R", 2ll, 0 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$639$1, 2025, 3, 4, 9, 0, 5, 0 );
	struct $N2FB8DATETIMEE vr$124 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$639$1, (int16)0 );
	TMP$640$1 = vr$124;
	FBSTRING* vr$126 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &TMP$640$1, &TMP$641$1 );
	int32 vr$127 = fb_StrCompare( (void*)vr$126, -1ll, (void*)"Tue, 04 Mar 2025 09:00:05 GMT", 30ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$127 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 161, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.CONSTANT_FORMATS_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 9, 0, 5, 0 ).WithOffset( 0 ).ToString( \x22R\x22 ) = \x09            \x22Tue, 04 Mar 2025 09:00:05 GMT\x22)" );
	fb_StrDelete( (FBSTRING*)&TMP$641$1 );
	label$1103:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN12PARSE_EXACT_Ev( void )
{
	FBSTRING TMP$650$1;
	FBSTRING TMP$651$1;
	struct $N2FB8DATETIMEE TMP$656$1;
	FBSTRING TMP$662$1;
	FBSTRING TMP$663$1;
	int64 TMP$667$1;
	FBSTRING TMP$673$1;
	FBSTRING TMP$674$1;
	int64 TMP$678$1;
	int64 TMP$679$1;
	FBSTRING TMP$685$1;
	FBSTRING TMP$686$1;
	FBSTRING TMP$694$1;
	FBSTRING TMP$695$1;
	FBSTRING TMP$701$1;
	FBSTRING TMP$702$1;
	FBSTRING TMP$710$1;
	FBSTRING TMP$711$1;
	FBSTRING TMP$719$1;
	FBSTRING TMP$720$1;
	FBSTRING TMP$729$1;
	FBSTRING TMP$730$1;
	FBSTRING TMP$736$1;
	FBSTRING TMP$737$1;
	FBSTRING TMP$746$1;
	FBSTRING TMP$747$1;
	FBSTRING TMP$756$1;
	FBSTRING TMP$757$1;
	int64 TMP$761$1;
	FBSTRING TMP$765$1;
	FBSTRING TMP$766$1;
	int64 TMP$770$1;
	int64 TMP$771$1;
	FBSTRING TMP$777$1;
	FBSTRING TMP$778$1;
	int64 TMP$782$1;
	FBSTRING TMP$784$1;
	FBSTRING TMP$785$1;
	int64 TMP$789$1;
	label$1106:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Ev( &D$1 );
	__builtin_memset( &TMP$651$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$651$1, -1ll, (void*)"yyyy-MM-dd HH:mm:ss", 20ll, 0 );
	__builtin_memset( &TMP$650$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$650$1, -1ll, (void*)"2025-03-04 14:30:05", 20ll, 0 );
	boolean vr$8 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$650$1, &TMP$651$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$8, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 167, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 14:30:05\x22, \x22yyyy-MM-dd HH:mm:ss\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$651$1 );
	fb_StrDelete( (FBSTRING*)&TMP$650$1 );
	int64 vr$12 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$656$1, 2025, 3, 4, 14, 30, 5, 0 );
	int64 vr$15 = _ZN2FB8DATETIME12TICKS__get__Ev( &TMP$656$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$12 == vr$15) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 168, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Ticks = DateTime( 2025, 3, 4, 14, 30, 5, 0 ).Ticks)" );
	__builtin_memset( &TMP$663$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$663$1, -1ll, (void*)"dd/MM/yyyy", 11ll, 0 );
	__builtin_memset( &TMP$662$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$662$1, -1ll, (void*)"04/03/2025", 11ll, 0 );
	boolean vr$25 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$662$1, &TMP$663$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$25, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 170, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "04/03/2025\x22, \x22" "dd/MM/yyyy\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$663$1 );
	fb_StrDelete( (FBSTRING*)&TMP$662$1 );
	int32 vr$29 = _ZN2FB8DATETIME10DAY__get__Ev( &D$1 );
	if( (int64)vr$29 != 4ll) goto label$1108;
	int32 vr$32 = _ZN2FB8DATETIME12MONTH__get__Ev( &D$1 );
	TMP$667$1 = (int64)-((int64)vr$32 == 3ll);
	goto label$1116;
	label$1108:;
	TMP$667$1 = 0ll;
	label$1116:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$667$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 171, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Day = 4 andalso d.Month = 3)" );
	__builtin_memset( &TMP$674$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$674$1, -1ll, (void*)"dddd, dd MMMM yyyy", 19ll, 0 );
	__builtin_memset( &TMP$673$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$673$1, -1ll, (void*)"Tuesday, 04 March 2025", 23ll, 0 );
	boolean vr$43 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$673$1, &TMP$674$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$43, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 173, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22Tuesday, 04 March 2025\x22, \x22" "dddd, dd MMMM yyyy\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$674$1 );
	fb_StrDelete( (FBSTRING*)&TMP$673$1 );
	int32 vr$47 = _ZN2FB8DATETIME10DAY__get__Ev( &D$1 );
	if( (int64)vr$47 != 4ll) goto label$1109;
	int32 vr$50 = _ZN2FB8DATETIME12MONTH__get__Ev( &D$1 );
	TMP$678$1 = (int64)-((int64)vr$50 == 3ll);
	goto label$1117;
	label$1109:;
	TMP$678$1 = 0ll;
	label$1117:;
	if( TMP$678$1 == 0ll) goto label$1110;
	int32 vr$54 = _ZN2FB8DATETIME11YEAR__get__Ev( &D$1 );
	TMP$679$1 = (int64)-((int64)vr$54 == 2025ll);
	goto label$1118;
	label$1110:;
	TMP$679$1 = 0ll;
	label$1118:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$679$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 174, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Day = 4 andalso d.Month = 3 andalso d.Year = 2025)" );
	__builtin_memset( &TMP$686$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$686$1, -1ll, (void*)"ddd dd MMM yyyy", 16ll, 0 );
	__builtin_memset( &TMP$685$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$685$1, -1ll, (void*)"Tue 04 Mar 2025", 16ll, 0 );
	boolean vr$65 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$685$1, &TMP$686$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$65, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 175, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22Tue 04 Mar 2025\x22, \x22" "ddd dd MMM yyyy\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$686$1 );
	fb_StrDelete( (FBSTRING*)&TMP$685$1 );
	int32 vr$69 = _ZN2FB8DATETIME12MONTH__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$69 == 3ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 176, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Month = 3)" );
	__builtin_memset( &TMP$695$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$695$1, -1ll, (void*)"dddd, dd MMMM yyyy", 19ll, 0 );
	__builtin_memset( &TMP$694$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$694$1, -1ll, (void*)"tuesday, 04 MARCH 2025", 23ll, 0 );
	boolean vr$80 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$694$1, &TMP$695$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$80, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 179, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22tuesday, 04 MARCH 2025\x22, \x22" "dddd, dd MMMM yyyy\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$695$1 );
	fb_StrDelete( (FBSTRING*)&TMP$694$1 );
	__builtin_memset( &TMP$702$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$702$1, -1ll, (void*)"yyyy-MM-dd hh:mm tt", 20ll, 0 );
	__builtin_memset( &TMP$701$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$701$1, -1ll, (void*)"2025-03-04 02:30 PM", 20ll, 0 );
	boolean vr$90 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$701$1, &TMP$702$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$90, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 182, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 02:30 PM\x22, \x22yyyy-MM-dd hh:mm tt\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$702$1 );
	fb_StrDelete( (FBSTRING*)&TMP$701$1 );
	int32 vr$94 = _ZN2FB8DATETIME11HOUR__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$94 == 14ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 183, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Hour = 14)" );
	__builtin_memset( &TMP$711$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$711$1, -1ll, (void*)"yyyy-MM-dd hh:mm tt", 20ll, 0 );
	__builtin_memset( &TMP$710$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$710$1, -1ll, (void*)"2025-03-04 12:00 AM", 20ll, 0 );
	boolean vr$105 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$710$1, &TMP$711$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$105, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 184, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 12:00 AM\x22, \x22yyyy-MM-dd hh:mm tt\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$711$1 );
	fb_StrDelete( (FBSTRING*)&TMP$710$1 );
	int32 vr$109 = _ZN2FB8DATETIME11HOUR__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$109 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 185, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Hour = 0)" );
	__builtin_memset( &TMP$720$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$720$1, -1ll, (void*)"yyyy-MM-dd hh:mm tt", 20ll, 0 );
	__builtin_memset( &TMP$719$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$719$1, -1ll, (void*)"2025-03-04 12:00 PM", 20ll, 0 );
	boolean vr$120 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$719$1, &TMP$720$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$120, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 186, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 12:00 PM\x22, \x22yyyy-MM-dd hh:mm tt\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$720$1 );
	fb_StrDelete( (FBSTRING*)&TMP$719$1 );
	int32 vr$124 = _ZN2FB8DATETIME11HOUR__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$124 == 12ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 187, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Hour = 12)" );
	__builtin_memset( &TMP$730$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$730$1, -1ll, (void*)"yyyy-MM-ddTHH:mm:sszzz", 23ll, 0 );
	__builtin_memset( &TMP$729$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$729$1, -1ll, (void*)"2025-03-04T14:30:05+05:30", 26ll, 0 );
	boolean vr$135 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$729$1, &TMP$730$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$135 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 190, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04T14:30:05+05:30\x22, \x22yyyy-MM-ddTHH:mm:sszzz\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$730$1 );
	fb_StrDelete( (FBSTRING*)&TMP$729$1 );
	__builtin_memset( &TMP$737$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$737$1, -1ll, (void*)"yyyy-MM-dd HH:mm:ss zzz", 24ll, 0 );
	__builtin_memset( &TMP$736$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$736$1, -1ll, (void*)"2025-03-04 14:30:05 +05:30", 27ll, 0 );
	boolean vr$146 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$736$1, &TMP$737$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$146, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 191, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 14:30:05 +05:30\x22, \x22yyyy-MM-dd HH:mm:ss zzz\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$737$1 );
	fb_StrDelete( (FBSTRING*)&TMP$736$1 );
	int16 vr$150 = _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$150 == 330ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 192, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.OffsetMinutes = 330)" );
	__builtin_memset( &TMP$747$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$747$1, -1ll, (void*)"yyyy-MM-dd HH:mm:ss K", 22ll, 0 );
	__builtin_memset( &TMP$746$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$746$1, -1ll, (void*)"2025-03-04 14:30:05 Z", 22ll, 0 );
	boolean vr$161 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$746$1, &TMP$747$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$161, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 193, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 14:30:05 Z\x22, \x22yyyy-MM-dd HH:mm:ss K\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$747$1 );
	fb_StrDelete( (FBSTRING*)&TMP$746$1 );
	int16 vr$165 = _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$165 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 194, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.OffsetMinutes = 0)" );
	__builtin_memset( &TMP$757$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$757$1, -1ll, (void*)"yyyy-DDD", 9ll, 0 );
	__builtin_memset( &TMP$756$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$756$1, -1ll, (void*)"2025-063", 9ll, 0 );
	boolean vr$176 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$756$1, &TMP$757$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$176, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 197, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-063\x22, \x22yyyy-DDD\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$757$1 );
	fb_StrDelete( (FBSTRING*)&TMP$756$1 );
	int32 vr$180 = _ZN2FB8DATETIME12MONTH__get__Ev( &D$1 );
	if( (int64)vr$180 != 3ll) goto label$1111;
	int32 vr$183 = _ZN2FB8DATETIME10DAY__get__Ev( &D$1 );
	TMP$761$1 = (int64)-((int64)vr$183 == 4ll);
	goto label$1119;
	label$1111:;
	TMP$761$1 = 0ll;
	label$1119:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$761$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 198, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Month = 3 andalso d.Day = 4)" );
	__builtin_memset( &TMP$766$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$766$1, -1ll, (void*)"yyyy", 5ll, 0 );
	__builtin_memset( &TMP$765$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$765$1, -1ll, (void*)"2025", 5ll, 0 );
	boolean vr$194 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$765$1, &TMP$766$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$194, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 201, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025\x22, \x22yyyy\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$766$1 );
	fb_StrDelete( (FBSTRING*)&TMP$765$1 );
	int32 vr$198 = _ZN2FB8DATETIME12MONTH__get__Ev( &D$1 );
	if( (int64)vr$198 != 1ll) goto label$1112;
	int32 vr$201 = _ZN2FB8DATETIME10DAY__get__Ev( &D$1 );
	TMP$770$1 = (int64)-((int64)vr$201 == 1ll);
	goto label$1120;
	label$1112:;
	TMP$770$1 = 0ll;
	label$1120:;
	if( TMP$770$1 == 0ll) goto label$1113;
	int32 vr$205 = _ZN2FB8DATETIME11HOUR__get__Ev( &D$1 );
	TMP$771$1 = (int64)-((int64)vr$205 == 0ll);
	goto label$1121;
	label$1113:;
	TMP$771$1 = 0ll;
	label$1121:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$771$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 202, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Month = 1 andalso d.Day = 1 andalso d.Hour = 0)" );
	__builtin_memset( &TMP$778$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$778$1, -1ll, (void*)"yyyy-M-d", 9ll, 0 );
	__builtin_memset( &TMP$777$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$777$1, -1ll, (void*)"2025-3-4", 9ll, 0 );
	boolean vr$216 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$777$1, &TMP$778$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$216, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 205, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-3-4\x22, \x22yyyy-M-d\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$778$1 );
	fb_StrDelete( (FBSTRING*)&TMP$777$1 );
	int32 vr$220 = _ZN2FB8DATETIME12MONTH__get__Ev( &D$1 );
	if( (int64)vr$220 != 3ll) goto label$1114;
	int32 vr$223 = _ZN2FB8DATETIME10DAY__get__Ev( &D$1 );
	TMP$782$1 = (int64)-((int64)vr$223 == 4ll);
	goto label$1122;
	label$1114:;
	TMP$782$1 = 0ll;
	label$1122:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$782$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 206, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Month = 3 andalso d.Day = 4)" );
	__builtin_memset( &TMP$785$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$785$1, -1ll, (void*)"yyyy-M-d", 9ll, 0 );
	__builtin_memset( &TMP$784$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$784$1, -1ll, (void*)"2025-12-31", 11ll, 0 );
	boolean vr$234 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$784$1, &TMP$785$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$234, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 207, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-12-31\x22, \x22yyyy-M-d\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$785$1 );
	fb_StrDelete( (FBSTRING*)&TMP$784$1 );
	int32 vr$238 = _ZN2FB8DATETIME12MONTH__get__Ev( &D$1 );
	if( (int64)vr$238 != 12ll) goto label$1115;
	int32 vr$241 = _ZN2FB8DATETIME10DAY__get__Ev( &D$1 );
	TMP$789$1 = (int64)-((int64)vr$241 == 31ll);
	goto label$1123;
	label$1115:;
	TMP$789$1 = 0ll;
	label$1123:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$789$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 208, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_EXACT_", (char*)"CU_ASSERT(d.Month = 12 andalso d.Day = 31)" );
	label$1107:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN16PARSE_REJECTION_Ev( void )
{
	FBSTRING TMP$796$1;
	FBSTRING TMP$797$1;
	FBSTRING TMP$803$1;
	FBSTRING TMP$804$1;
	FBSTRING TMP$809$1;
	FBSTRING TMP$810$1;
	FBSTRING TMP$815$1;
	FBSTRING TMP$816$1;
	FBSTRING TMP$821$1;
	FBSTRING TMP$822$1;
	FBSTRING TMP$827$1;
	FBSTRING TMP$828$1;
	FBSTRING TMP$833$1;
	FBSTRING TMP$834$1;
	FBSTRING TMP$840$1;
	FBSTRING TMP$841$1;
	FBSTRING TMP$847$1;
	FBSTRING TMP$848$1;
	FBSTRING TMP$853$1;
	FBSTRING TMP$854$1;
	FBSTRING TMP$858$1;
	FBSTRING TMP$859$1;
	FBSTRING TMP$865$1;
	FBSTRING TMP$866$1;
	FBSTRING TMP$875$1;
	FBSTRING TMP$876$1;
	FBSTRING TMP$882$1;
	FBSTRING TMP$883$1;
	FBSTRING TMP$889$1;
	FBSTRING TMP$890$1;
	FBSTRING TMP$895$1;
	FBSTRING TMP$896$1;
	FBSTRING TMP$901$1;
	FBSTRING TMP$902$1;
	FBSTRING TMP$906$1;
	FBSTRING TMP$907$1;
	FBSTRING TMP$910$1;
	FBSTRING TMP$911$1;
	FBSTRING TMP$915$1;
	FBSTRING TMP$916$1;
	FBSTRING TMP$922$1;
	FBSTRING TMP$923$1;
	FBSTRING TMP$927$1;
	FBSTRING TMP$928$1;
	FBSTRING TMP$932$1;
	FBSTRING TMP$933$1;
	label$1126:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Ev( &D$1 );
	__builtin_memset( &TMP$797$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$797$1, -1ll, (void*)"yyyy-MM-dd", 11ll, 0 );
	__builtin_memset( &TMP$796$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$796$1, -1ll, (void*)"2025-03-04x", 12ll, 0 );
	boolean vr$8 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$796$1, &TMP$797$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$8 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 215, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04x\x22, \x22yyyy-MM-dd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$797$1 );
	fb_StrDelete( (FBSTRING*)&TMP$796$1 );
	__builtin_memset( &TMP$804$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$804$1, -1ll, (void*)"yyyy-MM-dd", 11ll, 0 );
	__builtin_memset( &TMP$803$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$803$1, -1ll, (void*)"x2025-03-04", 12ll, 0 );
	boolean vr$19 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$803$1, &TMP$804$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$19 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 217, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22x2025-03-04\x22, \x22yyyy-MM-dd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$804$1 );
	fb_StrDelete( (FBSTRING*)&TMP$803$1 );
	__builtin_memset( &TMP$810$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$810$1, -1ll, (void*)"yyyy-MM-dd", 11ll, 0 );
	__builtin_memset( &TMP$809$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$809$1, -1ll, (void*)"2025-03", 8ll, 0 );
	boolean vr$30 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$809$1, &TMP$810$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$30 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 219, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03\x22, \x22yyyy-MM-dd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$810$1 );
	fb_StrDelete( (FBSTRING*)&TMP$809$1 );
	__builtin_memset( &TMP$816$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$816$1, -1ll, (void*)"yyyy-MM-dd", 11ll, 0 );
	__builtin_memset( &TMP$815$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$815$1, -1ll, (void*)"2025/03/04", 11ll, 0 );
	boolean vr$41 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$815$1, &TMP$816$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$41 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 221, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025/03/04\x22, \x22yyyy-MM-dd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$816$1 );
	fb_StrDelete( (FBSTRING*)&TMP$815$1 );
	__builtin_memset( &TMP$822$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$822$1, -1ll, (void*)"yyyy-MM-dd", 11ll, 0 );
	__builtin_memset( &TMP$821$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$821$1, -1ll, (void*)"2025-3-04", 10ll, 0 );
	boolean vr$52 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$821$1, &TMP$822$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$52 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 223, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-3-04\x22, \x22yyyy-MM-dd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$822$1 );
	fb_StrDelete( (FBSTRING*)&TMP$821$1 );
	__builtin_memset( &TMP$828$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$828$1, -1ll, (void*)"yyyy-MM-dd", 11ll, 0 );
	__builtin_memset( &TMP$827$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$827$1, -1ll, (void*)"2025-13-04", 11ll, 0 );
	boolean vr$63 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$827$1, &TMP$828$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$63 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 225, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-13-04\x22, \x22yyyy-MM-dd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$828$1 );
	fb_StrDelete( (FBSTRING*)&TMP$827$1 );
	__builtin_memset( &TMP$834$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$834$1, -1ll, (void*)"yyyy-MM-dd", 11ll, 0 );
	__builtin_memset( &TMP$833$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$833$1, -1ll, (void*)"2025-02-30", 11ll, 0 );
	boolean vr$74 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$833$1, &TMP$834$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$74 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 226, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-02-30\x22, \x22yyyy-MM-dd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$834$1 );
	fb_StrDelete( (FBSTRING*)&TMP$833$1 );
	__builtin_memset( &TMP$841$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$841$1, -1ll, (void*)"yyyy-MM-dd HH:mm", 17ll, 0 );
	__builtin_memset( &TMP$840$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$840$1, -1ll, (void*)"2025-03-04 25:00", 17ll, 0 );
	boolean vr$85 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$840$1, &TMP$841$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$85 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 227, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 25:00\x22, \x22yyyy-MM-dd HH:mm\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$841$1 );
	fb_StrDelete( (FBSTRING*)&TMP$840$1 );
	__builtin_memset( &TMP$848$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$848$1, -1ll, (void*)"MMMM dd yyyy", 13ll, 0 );
	__builtin_memset( &TMP$847$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$847$1, -1ll, (void*)"Smarch 04 2025", 15ll, 0 );
	boolean vr$96 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$847$1, &TMP$848$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$96 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 229, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22Smarch 04 2025\x22, \x22MMMM dd yyyy\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$848$1 );
	fb_StrDelete( (FBSTRING*)&TMP$847$1 );
	__builtin_memset( &TMP$854$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$854$1, -1ll, (void*)"yyyy-MM-dd HH:mm", 17ll, 0 );
	__builtin_memset( &TMP$853$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$853$1, -1ll, (void*)"2025-03-04  14:30", 18ll, 0 );
	boolean vr$107 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$853$1, &TMP$854$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$107 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 231, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04  14:30\x22, \x22yyyy-MM-dd HH:mm\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$854$1 );
	fb_StrDelete( (FBSTRING*)&TMP$853$1 );
	__builtin_memset( &TMP$859$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$859$1, -1ll, (void*)"yyyy-MM-dd", 11ll, 0 );
	__builtin_memset( &TMP$858$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$858$1, -1ll, (void*)"", 1ll, 0 );
	boolean vr$118 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$858$1, &TMP$859$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$118 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 233, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22\x22, \x22yyyy-MM-dd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$859$1 );
	fb_StrDelete( (FBSTRING*)&TMP$858$1 );
	struct $N2FB8DATETIMEE SEEDED$1;
	_ZN2FB8DATETIMEC1Eiii( &SEEDED$1, 2025, 1, 1 );
	__builtin_memset( &TMP$866$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$866$1, -1ll, (void*)"yyyy", 5ll, 0 );
	__builtin_memset( &TMP$865$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$865$1, -1ll, (void*)"garbage", 8ll, 0 );
	boolean vr$130 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$865$1, &TMP$866$1, &SEEDED$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$130 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 237, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22garbage\x22, \x22yyyy\x22, seeded ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$866$1 );
	fb_StrDelete( (FBSTRING*)&TMP$865$1 );
	boolean vr$135 = _ZN2FB8DATETIME14ISVALID__get__Ev( &SEEDED$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$135 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 238, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(seeded.IsValid = false)" );
	__builtin_memset( &TMP$876$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$876$1, -1ll, (void*)"Md", 3ll, 0 );
	__builtin_memset( &TMP$875$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$875$1, -1ll, (void*)"34", 3ll, 0 );
	boolean vr$144 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$875$1, &TMP$876$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$144 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 242, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "34\x22, \x22Md\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$876$1 );
	fb_StrDelete( (FBSTRING*)&TMP$875$1 );
	__builtin_memset( &TMP$883$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$883$1, -1ll, (void*)"yyyyMd", 7ll, 0 );
	__builtin_memset( &TMP$882$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$882$1, -1ll, (void*)"2025034", 8ll, 0 );
	boolean vr$155 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$882$1, &TMP$883$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$155 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 243, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025034\x22, \x22yyyyMd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$883$1 );
	fb_StrDelete( (FBSTRING*)&TMP$882$1 );
	__builtin_memset( &TMP$890$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$890$1, -1ll, (void*)"yyyy-MM-dd MM", 14ll, 0 );
	__builtin_memset( &TMP$889$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$889$1, -1ll, (void*)"2025-03-04 05", 14ll, 0 );
	boolean vr$166 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$889$1, &TMP$890$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$166 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 246, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 05\x22, \x22yyyy-MM-dd MM\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$890$1 );
	fb_StrDelete( (FBSTRING*)&TMP$889$1 );
	__builtin_memset( &TMP$896$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$896$1, -1ll, (void*)"yyyy-MM-dd MM", 14ll, 0 );
	__builtin_memset( &TMP$895$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$895$1, -1ll, (void*)"2025-03-04 03", 14ll, 0 );
	boolean vr$177 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$895$1, &TMP$896$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$177, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 248, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 03\x22, \x22yyyy-MM-dd MM\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$896$1 );
	fb_StrDelete( (FBSTRING*)&TMP$895$1 );
	__builtin_memset( &TMP$902$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$902$1, -1ll, (void*)"dddd, dd MMMM yyyy", 19ll, 0 );
	__builtin_memset( &TMP$901$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$901$1, -1ll, (void*)"Monday, 04 March 2025", 22ll, 0 );
	boolean vr$187 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$901$1, &TMP$902$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$187 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 251, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22Monday, 04 March 2025\x22, \x22" "dddd, dd MMMM yyyy\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$902$1 );
	fb_StrDelete( (FBSTRING*)&TMP$901$1 );
	__builtin_memset( &TMP$907$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$907$1, -1ll, (void*)"dddd, dd MMMM yyyy", 19ll, 0 );
	__builtin_memset( &TMP$906$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$906$1, -1ll, (void*)"Tuesday, 04 March 2025", 23ll, 0 );
	boolean vr$198 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$906$1, &TMP$907$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$198, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 252, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22Tuesday, 04 March 2025\x22, \x22" "dddd, dd MMMM yyyy\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$907$1 );
	fb_StrDelete( (FBSTRING*)&TMP$906$1 );
	__builtin_memset( &TMP$911$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$911$1, -1ll, (void*)"yy-MM-dd", 9ll, 0 );
	__builtin_memset( &TMP$910$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$910$1, -1ll, (void*)"25-03-04", 9ll, 0 );
	boolean vr$208 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$910$1, &TMP$911$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$208 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 255, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "25-03-04\x22, \x22yy-MM-dd\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$911$1 );
	fb_StrDelete( (FBSTRING*)&TMP$910$1 );
	__builtin_memset( &TMP$916$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$916$1, -1ll, (void*)"Q", 2ll, 0 );
	__builtin_memset( &TMP$915$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$915$1, -1ll, (void*)"1", 2ll, 0 );
	boolean vr$219 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$915$1, &TMP$916$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$219 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 258, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "1\x22, \x22Q\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$916$1 );
	fb_StrDelete( (FBSTRING*)&TMP$915$1 );
	__builtin_memset( &TMP$923$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$923$1, -1ll, (void*)"yyyy ww", 8ll, 0 );
	__builtin_memset( &TMP$922$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$922$1, -1ll, (void*)"2025 10", 8ll, 0 );
	boolean vr$230 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$922$1, &TMP$923$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$230 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 259, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025 10\x22, \x22yyyy ww\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$923$1 );
	fb_StrDelete( (FBSTRING*)&TMP$922$1 );
	__builtin_memset( &TMP$928$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$928$1, -1ll, (void*)"R", 2ll, 0 );
	__builtin_memset( &TMP$927$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$927$1, -1ll, (void*)"Tue, 04 Mar 2025 09:00:05 GMT", 30ll, 0 );
	boolean vr$241 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$927$1, &TMP$928$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$241 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 260, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22Tue, 04 Mar 2025 09:00:05 GMT\x22, \x22R\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$928$1 );
	fb_StrDelete( (FBSTRING*)&TMP$927$1 );
	__builtin_memset( &TMP$933$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$933$1, -1ll, (void*)"u", 2ll, 0 );
	__builtin_memset( &TMP$932$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$932$1, -1ll, (void*)"2025-03-04 09:00:05Z", 21ll, 0 );
	boolean vr$252 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$932$1, &TMP$933$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$252 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 261, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.PARSE_REJECTION_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22" "2025-03-04 09:00:05Z\x22, \x22u\x22, d ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$933$1 );
	fb_StrDelete( (FBSTRING*)&TMP$932$1 );
	label$1127:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN19ROUNDTRIP_PATTERNS_Ev( void )
{
	label$1130:;
	uint64 SEED$1;
	SEED$1 = 271828182ull;
	{
		int64 I$2;
		I$2 = 1ll;
		label$1135:;
		{
			FBSTRING TMP$939$3;
			FBSTRING TMP$940$3;
			FBSTRING TMP$941$3;
			int64 TMP$942$3;
			FBSTRING TMP$947$3;
			FBSTRING TMP$948$3;
			FBSTRING TMP$949$3;
			FBSTRING TMP$957$3;
			FBSTRING TMP$958$3;
			FBSTRING TMP$959$3;
			int64 TMP$960$3;
			FBSTRING TMP$964$3;
			FBSTRING TMP$965$3;
			FBSTRING TMP$966$3;
			SEED$1 = (SEED$1 * 6364136223846793005ull) + 1442695040888963407ull;
			int64 T$3;
			T$3 = (int64)(SEED$1 % 3155378975999999999ull);
			struct $N2FB8DATETIMEE A$3;
			struct $N2FB8DATETIMEE vr$3 = _ZN2FB8DATETIME9FROMTICKSExs( T$3, (int16)0 );
			A$3 = vr$3;
			struct $N2FB8DATETIMEE B$3;
			__builtin_memset( &TMP$941$3, 0, 24ll );
			fb_StrAssign( (void*)&TMP$941$3, -1ll, (void*)"o", 2ll, 0 );
			__builtin_memset( &TMP$940$3, 0, 24ll );
			__builtin_memset( &TMP$939$3, 0, 24ll );
			fb_StrAssign( (void*)&TMP$939$3, -1ll, (void*)"o", 2ll, 0 );
			FBSTRING* vr$12 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &A$3, &TMP$939$3 );
			fb_StrAssign( (void*)&TMP$940$3, -1ll, (void*)vr$12, -1ll, 0 );
			struct $N2FB8DATETIMEE vr$15 = _ZN2FB8DATETIME10PARSEEXACTER8FBSTRINGS2_( &TMP$940$3, &TMP$941$3 );
			B$3 = vr$15;
			fb_StrDelete( (FBSTRING*)&TMP$941$3 );
			fb_StrDelete( (FBSTRING*)&TMP$940$3 );
			fb_StrDelete( (FBSTRING*)&TMP$939$3 );
			boolean vr$20 = _ZN2FB8DATETIME14ISVALID__get__Ev( &B$3 );
			if( (int64)-vr$20 == 0ll) goto label$1136;
			int64 vr$23 = _ZN2FB8DATETIME12TICKS__get__Ev( &B$3 );
			int64 vr$25 = _ZN2FB8DATETIME12TICKS__get__Ev( &A$3 );
			TMP$942$3 = (int64)-(vr$23 == vr$25);
			goto label$1138;
			label$1136:;
			TMP$942$3 = 0ll;
			label$1138:;
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$942$3 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 277, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.ROUNDTRIP_PATTERNS_", (char*)"CU_ASSERT(b.IsValid andalso b.Ticks = a.Ticks)" );
			struct $N2FB8DATETIMEE C$3;
			struct $N2FB8DATETIMEE vr$28 = _ZN2FB8DATETIME9FROMTICKSExs( T$3, (int16)32767 );
			C$3 = vr$28;
			struct $N2FB8DATETIMEE E$3;
			__builtin_memset( &TMP$949$3, 0, 24ll );
			fb_StrAssign( (void*)&TMP$949$3, -1ll, (void*)"yyyy-MM-dd HH:mm:ss", 20ll, 0 );
			__builtin_memset( &TMP$948$3, 0, 24ll );
			__builtin_memset( &TMP$947$3, 0, 24ll );
			fb_StrAssign( (void*)&TMP$947$3, -1ll, (void*)"yyyy-MM-dd HH:mm:ss", 20ll, 0 );
			FBSTRING* vr$37 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &C$3, &TMP$947$3 );
			fb_StrAssign( (void*)&TMP$948$3, -1ll, (void*)vr$37, -1ll, 0 );
			struct $N2FB8DATETIMEE vr$40 = _ZN2FB8DATETIME10PARSEEXACTER8FBSTRINGS2_( &TMP$948$3, &TMP$949$3 );
			E$3 = vr$40;
			fb_StrDelete( (FBSTRING*)&TMP$949$3 );
			fb_StrDelete( (FBSTRING*)&TMP$948$3 );
			fb_StrDelete( (FBSTRING*)&TMP$947$3 );
			boolean vr$45 = _ZN2FB8DATETIME14ISVALID__get__Ev( &E$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$45, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 283, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.ROUNDTRIP_PATTERNS_", (char*)"CU_ASSERT(e.IsValid)" );
			int64 vr$47 = _ZN2FB8DATETIME12TICKS__get__Ev( &E$3 );
			int64 vr$49 = _ZN2FB8DATETIME12TICKS__get__Ev( &C$3 );
			int64 vr$51 = _ZN2FB8DATETIME12TICKS__get__Ev( &C$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$47 == (vr$49 - (vr$51 % 10000000ll))) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 284, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.ROUNDTRIP_PATTERNS_", (char*)"CU_ASSERT(e.Ticks = c.Ticks - ( c.Ticks mod DT_TICKS_PER_SECOND ))" );
			struct $N2FB8DATETIMEE G$3;
			__builtin_memset( &TMP$959$3, 0, 24ll );
			fb_StrAssign( (void*)&TMP$959$3, -1ll, (void*)"yyyy-MM-dd HH:mm:ss.fffffff", 28ll, 0 );
			__builtin_memset( &TMP$958$3, 0, 24ll );
			__builtin_memset( &TMP$957$3, 0, 24ll );
			fb_StrAssign( (void*)&TMP$957$3, -1ll, (void*)"yyyy-MM-dd HH:mm:ss.fffffff", 28ll, 0 );
			FBSTRING* vr$64 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &C$3, &TMP$957$3 );
			fb_StrAssign( (void*)&TMP$958$3, -1ll, (void*)vr$64, -1ll, 0 );
			struct $N2FB8DATETIMEE vr$67 = _ZN2FB8DATETIME10PARSEEXACTER8FBSTRINGS2_( &TMP$958$3, &TMP$959$3 );
			G$3 = vr$67;
			fb_StrDelete( (FBSTRING*)&TMP$959$3 );
			fb_StrDelete( (FBSTRING*)&TMP$958$3 );
			fb_StrDelete( (FBSTRING*)&TMP$957$3 );
			boolean vr$72 = _ZN2FB8DATETIME14ISVALID__get__Ev( &G$3 );
			if( (int64)-vr$72 == 0ll) goto label$1137;
			int64 vr$75 = _ZN2FB8DATETIME12TICKS__get__Ev( &G$3 );
			int64 vr$77 = _ZN2FB8DATETIME12TICKS__get__Ev( &C$3 );
			TMP$960$3 = (int64)-(vr$75 == vr$77);
			goto label$1139;
			label$1137:;
			TMP$960$3 = 0ll;
			label$1139:;
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$960$3 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 289, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.ROUNDTRIP_PATTERNS_", (char*)"CU_ASSERT(g.IsValid andalso g.Ticks = c.Ticks)" );
			struct $N2FB8DATETIMEE H$3;
			__builtin_memset( &TMP$966$3, 0, 24ll );
			fb_StrAssign( (void*)&TMP$966$3, -1ll, (void*)"s", 2ll, 0 );
			__builtin_memset( &TMP$965$3, 0, 24ll );
			__builtin_memset( &TMP$964$3, 0, 24ll );
			fb_StrAssign( (void*)&TMP$964$3, -1ll, (void*)"s", 2ll, 0 );
			FBSTRING* vr$88 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &C$3, &TMP$964$3 );
			fb_StrAssign( (void*)&TMP$965$3, -1ll, (void*)vr$88, -1ll, 0 );
			struct $N2FB8DATETIMEE vr$91 = _ZN2FB8DATETIME10PARSEEXACTER8FBSTRINGS2_( &TMP$965$3, &TMP$966$3 );
			H$3 = vr$91;
			fb_StrDelete( (FBSTRING*)&TMP$966$3 );
			fb_StrDelete( (FBSTRING*)&TMP$965$3 );
			fb_StrDelete( (FBSTRING*)&TMP$964$3 );
			boolean vr$96 = _ZN2FB8DATETIME14ISVALID__get__Ev( &H$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$96, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 293, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.ROUNDTRIP_PATTERNS_", (char*)"CU_ASSERT(h.IsValid)" );
			int64 vr$98 = _ZN2FB8DATETIME12TICKS__get__Ev( &H$3 );
			int64 vr$100 = _ZN2FB8DATETIME12TICKS__get__Ev( &C$3 );
			int64 vr$102 = _ZN2FB8DATETIME12TICKS__get__Ev( &C$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$98 == (vr$100 - (vr$102 % 10000000ll))) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 294, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.ROUNDTRIP_PATTERNS_", (char*)"CU_ASSERT(h.Ticks = c.Ticks - ( c.Ticks mod DT_TICKS_PER_SECOND ))" );
		}
		label$1133:;
		I$2 = I$2 + 1ll;
		label$1132:;
		if( I$2 <= 4000ll) goto label$1135;
		label$1134:;
	}
	label$1131:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN18NO_LOCALE_LEAKAGE_Ev( void )
{
	struct $N2FB8DATETIMEE TMP$975$1;
	FBSTRING TMP$977$1;
	FBSTRING TMP$978$1;
	FBSTRING TMP$979$1;
	FBSTRING TMP$988$1;
	FBSTRING TMP$992$1;
	FBSTRING TMP$996$1;
	FBSTRING TMP$1001$1;
	FBSTRING TMP$1002$1;
	FBSTRING TMP$1003$1;
	FBSTRING TMP$1004$1;
	FBSTRING TMP$1005$1;
	label$1142:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$975$1, 2025, 3, 4, 14, 30, 5, 120 );
	struct $N2FB8DATETIMEE vr$2 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$975$1, (int16)330 );
	D$1 = vr$2;
	FBSTRING WANTLONG$1;
	__builtin_memset( &TMP$977$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$977$1, -1ll, (void*)"dddd dd MMMM yyyy", 18ll, 0 );
	FBSTRING* vr$7 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$977$1 );
	fb_StrInit( (void*)&WANTLONG$1, -1ll, (void*)vr$7, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&TMP$977$1 );
	FBSTRING WANTR$1;
	__builtin_memset( &TMP$978$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$978$1, -1ll, (void*)"R", 2ll, 0 );
	FBSTRING* vr$14 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$978$1 );
	fb_StrInit( (void*)&WANTR$1, -1ll, (void*)vr$14, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&TMP$978$1 );
	FBSTRING WANTFRAC$1;
	__builtin_memset( &TMP$979$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$979$1, -1ll, (void*)"HH:mm:ss.fff", 13ll, 0 );
	FBSTRING* vr$21 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$979$1 );
	fb_StrInit( (void*)&WANTFRAC$1, -1ll, (void*)vr$21, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&TMP$979$1 );
	int32 vr$25 = fb_StrCompare( (void*)&WANTLONG$1, -1ll, (void*)"Tuesday 04 March 2025", 22ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$25 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 305, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(wantLong = \x22Tuesday 04 March 2025\x22)" );
	int32 vr$30 = fb_StrCompare( (void*)&WANTR$1, -1ll, (void*)"Tue, 04 Mar 2025 09:00:05 GMT", 30ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$30 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 306, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(wantR = \x22Tue, 04 Mar 2025 09:00:05 GMT\x22)" );
	char* PREV$1;
	char* vr$34 = setlocale( 6, (char*)0ull );
	PREV$1 = vr$34;
	FBSTRING SAVED$1;
	fb_StrInit( (void*)&SAVED$1, -1ll, (void*)"", 1ll, 0 );
	if( PREV$1 == (char*)0ull) goto label$1145;
	{
		fb_StrAssign( (void*)&SAVED$1, -1ll, (void*)PREV$1, 0ll, 0 );
		label$1145:;
	}
	setlocale( 6, (char*)"" );
	__builtin_memset( &TMP$988$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$988$1, -1ll, (void*)"dddd dd MMMM yyyy", 18ll, 0 );
	FBSTRING* vr$42 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$988$1 );
	int32 vr$43 = fb_StrCompare( (void*)vr$42, -1ll, (void*)&WANTLONG$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$43 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 313, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(d.ToString( \x22" "dddd dd MMMM yyyy\x22 ) = wantLong)" );
	fb_StrDelete( (FBSTRING*)&TMP$988$1 );
	__builtin_memset( &TMP$992$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$992$1, -1ll, (void*)"R", 2ll, 0 );
	FBSTRING* vr$53 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$992$1 );
	int32 vr$54 = fb_StrCompare( (void*)vr$53, -1ll, (void*)&WANTR$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$54 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 314, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(d.ToString( \x22R\x22 ) = wantR)" );
	fb_StrDelete( (FBSTRING*)&TMP$992$1 );
	__builtin_memset( &TMP$996$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$996$1, -1ll, (void*)"HH:mm:ss.fff", 13ll, 0 );
	FBSTRING* vr$64 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$996$1 );
	int32 vr$65 = fb_StrCompare( (void*)vr$64, -1ll, (void*)&WANTFRAC$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$65 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 315, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(d.ToString( \x22HH:mm:ss.fff\x22 ) = wantFrac)" );
	fb_StrDelete( (FBSTRING*)&TMP$996$1 );
	setlocale( 6, (char*)"German_Germany" );
	__builtin_memset( &TMP$1001$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$1001$1, -1ll, (void*)"dddd dd MMMM yyyy", 18ll, 0 );
	FBSTRING* vr$75 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$1001$1 );
	int32 vr$76 = fb_StrCompare( (void*)vr$75, -1ll, (void*)&WANTLONG$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$76 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 318, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(d.ToString( \x22" "dddd dd MMMM yyyy\x22 ) = wantLong)" );
	fb_StrDelete( (FBSTRING*)&TMP$1001$1 );
	__builtin_memset( &TMP$1002$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$1002$1, -1ll, (void*)"R", 2ll, 0 );
	FBSTRING* vr$86 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$1002$1 );
	int32 vr$87 = fb_StrCompare( (void*)vr$86, -1ll, (void*)&WANTR$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$87 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 319, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(d.ToString( \x22R\x22 ) = wantR)" );
	fb_StrDelete( (FBSTRING*)&TMP$1002$1 );
	__builtin_memset( &TMP$1003$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$1003$1, -1ll, (void*)"HH:mm:ss.fff", 13ll, 0 );
	FBSTRING* vr$97 = _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( &D$1, &TMP$1003$1 );
	int32 vr$98 = fb_StrCompare( (void*)vr$97, -1ll, (void*)&WANTFRAC$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$98 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 320, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(d.ToString( \x22HH:mm:ss.fff\x22 ) = wantFrac)" );
	fb_StrDelete( (FBSTRING*)&TMP$1003$1 );
	struct $N2FB8DATETIMEE P$1;
	_ZN2FB8DATETIMEC1Ev( &P$1 );
	__builtin_memset( &TMP$1005$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$1005$1, -1ll, (void*)"dddd dd MMMM yyyy", 18ll, 0 );
	__builtin_memset( &TMP$1004$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$1004$1, -1ll, (void*)"Tuesday 04 March 2025", 22ll, 0 );
	boolean vr$111 = _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( &TMP$1004$1, &TMP$1005$1, &P$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$111, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 323, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(DateTime.TryParseExact( \x22Tuesday 04 March 2025\x22, \x22" "dddd dd MMMM yyyy\x22, p ))" );
	fb_StrDelete( (FBSTRING*)&TMP$1005$1 );
	fb_StrDelete( (FBSTRING*)&TMP$1004$1 );
	int32 vr$115 = _ZN2FB8DATETIME10DAY__get__Ev( &P$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$115 == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Cpattern.bas", 324, (char*)"TESTS.FBC_TESTS.CHRONO.PATTERN.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(p.Day = 4)" );
	int64 vr$120 = fb_StrLen( (void*)&SAVED$1, -1ll );
	if( vr$120 <= 0ll) goto label$1147;
	{
		setlocale( 6, (char*)*(char**)&SAVED$1 );
		label$1147:;
	}
	fb_StrDelete( (FBSTRING*)&SAVED$1 );
	fb_StrDelete( (FBSTRING*)&WANTFRAC$1 );
	fb_StrDelete( (FBSTRING*)&WANTR$1 );
	fb_StrDelete( (FBSTRING*)&WANTLONG$1 );
	label$1143:;
}

static double _ZN2FB5DTNANEv( void )
{
	double fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$2:;
	uint64 U$1;
	U$1 = 18444492273895866368ull;
	fb$result$1 = *(double*)&U$1;
	goto label$3;
	label$3:;
	return fb$result$1;
}

static boolean _ZN2FB14DTADDOVERFLOWSExx( int64 A$1, int64 B$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$4:;
	if( B$1 <= 0ll) goto label$7;
	{
		fb$result$1 = (boolean)((int64)-(A$1 > (-B$1 + 9223372036854775807ll)) != 0ll);
		goto label$5;
	}
	goto label$6;
	label$7:;
	if( B$1 >= 0ll) goto label$8;
	{
		fb$result$1 = (boolean)((int64)-(A$1 < (-B$1 + -9223372036854775807ll)) != 0ll);
		goto label$5;
	}
	label$8:;
	label$6:;
	fb$result$1 = (boolean)0ll;
	goto label$5;
	label$5:;
	return fb$result$1;
}

static double _ZN2FB15DTROUNDHALFAWAYEd( double V$1 )
{
	double fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$9:;
	if( !(V$1 >= 0x0p+0)) goto label$12;
	{
		fb$result$1 = __builtin_floor( (V$1 + 0x1.p-1) );
		goto label$10;
	}
	label$12:;
	label$11:;
	fb$result$1 = -(__builtin_floor( (0x1.p-1 - V$1) ));
	goto label$10;
	label$10:;
	return fb$result$1;
}

static int64 _ZN2FB17DTTICKSFROMDOUBLEEd( double V$1 )
{
	boolean TMP$7$1;
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$13:;
	if( !(V$1 != V$1)) goto label$16;
	{
		fb$result$1 = (int64)-9223372036854775808ull;
		goto label$14;
		label$16:;
	}
	boolean TOOBIG$1;
	TOOBIG$1 = (boolean)((int64)-(V$1 >= 0x1.FEB3DD06766p+62) != 0ll);
	boolean TOOSMALL$1;
	TOOSMALL$1 = (boolean)((int64)-(V$1 <= -0x1.FEB3DD06766p+62) != 0ll);
	if( TOOBIG$1 != (boolean)0ll) goto label$17;
	TMP$7$1 = (boolean)(TOOSMALL$1 != (boolean)0ll);
	goto label$1152;
	label$17:;
	TMP$7$1 = (boolean)1ll;
	label$1152:;
	if( TMP$7$1 == (boolean)0ll) goto label$19;
	{
		fb$result$1 = (int64)-9223372036854775808ull;
		goto label$14;
		label$19:;
	}
	double vr$6 = _ZN2FB15DTROUNDHALFAWAYEd( V$1 );
	fb$result$1 = fb_D2L( vr$6 );
	goto label$14;
	label$14:;
	return fb$result$1;
}

static void _ZN2FB8TIMESPANC1Ev( struct $N2FB8TIMESPANE* THIS$1 )
{
	label$20:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	*(int64*)THIS$1 = 0ll;
	label$21:;
}

static void _ZN2FB8TIMESPANC1Ex( struct $N2FB8TIMESPANE* THIS$1, int64 T$1 )
{
	label$22:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	*(int64*)THIS$1 = T$1;
	label$23:;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN7INVALIDEv( void )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$52:;
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, (int64)-9223372036854775808ull );
	goto label$53;
	label$53:;
	return fb$result$1;
}

static int64 _ZN2FB8TIMESPAN12TICKS__get__Ev( struct $N2FB8TIMESPANE* THIS$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$54:;
	fb$result$1 = *(int64*)THIS$1;
	goto label$55;
	label$55:;
	return fb$result$1;
}

static boolean _ZN2FB8TIMESPAN14ISVALID__get__Ev( struct $N2FB8TIMESPANE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$56:;
	fb$result$1 = (boolean)((int64)-(*(int64*)THIS$1 != (int64)-9223372036854775808ull) != 0ll);
	goto label$57;
	label$57:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN6NEGATEEv( struct $N2FB8TIMESPANE* THIS$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$87:;
	if( *(int64*)THIS$1 != (int64)-9223372036854775808ull) goto label$90;
	{
		_ZN2FB8TIMESPANC1Ex( &fb$result$1, (int64)-9223372036854775808ull );
		goto label$88;
		label$90:;
	}
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, -(*(int64*)THIS$1) );
	goto label$88;
	label$88:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN3ADDERS0_( struct $N2FB8TIMESPANE* THIS$1, struct $N2FB8TIMESPANE* O$1 )
{
	boolean TMP$27$1;
	struct $N2FB8TIMESPANE fb$result$1;
	label$97:;
	boolean BAD$1;
	BAD$1 = (boolean)((int64)-(*(int64*)THIS$1 == (int64)-9223372036854775808ull) != 0ll);
	boolean BADO$1;
	BADO$1 = (boolean)((int64)-(*(int64*)O$1 == (int64)-9223372036854775808ull) != 0ll);
	if( BAD$1 != (boolean)0ll) goto label$99;
	TMP$27$1 = (boolean)(BADO$1 != (boolean)0ll);
	goto label$1154;
	label$99:;
	TMP$27$1 = (boolean)1ll;
	label$1154:;
	if( TMP$27$1 == (boolean)0ll) goto label$101;
	{
		_ZN2FB8TIMESPANC1Ex( &fb$result$1, (int64)-9223372036854775808ull );
		goto label$98;
		label$101:;
	}
	boolean vr$10 = _ZN2FB14DTADDOVERFLOWSExx( *(int64*)THIS$1, *(int64*)O$1 );
	if( vr$10 == (boolean)0ll) goto label$103;
	{
		_ZN2FB8TIMESPANC1Ex( &fb$result$1, (int64)-9223372036854775808ull );
		goto label$98;
		label$103:;
	}
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, *(int64*)THIS$1 + *(int64*)O$1 );
	goto label$98;
	label$98:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN8SUBTRACTERS0_( struct $N2FB8TIMESPANE* THIS$1, struct $N2FB8TIMESPANE* O$1 )
{
	boolean TMP$31$1;
	struct $N2FB8TIMESPANE fb$result$1;
	label$104:;
	boolean BAD$1;
	BAD$1 = (boolean)((int64)-(*(int64*)THIS$1 == (int64)-9223372036854775808ull) != 0ll);
	boolean BADO$1;
	BADO$1 = (boolean)((int64)-(*(int64*)O$1 == (int64)-9223372036854775808ull) != 0ll);
	if( BAD$1 != (boolean)0ll) goto label$106;
	TMP$31$1 = (boolean)(BADO$1 != (boolean)0ll);
	goto label$1155;
	label$106:;
	TMP$31$1 = (boolean)1ll;
	label$1155:;
	if( TMP$31$1 == (boolean)0ll) goto label$108;
	{
		_ZN2FB8TIMESPANC1Ex( &fb$result$1, (int64)-9223372036854775808ull );
		goto label$105;
		label$108:;
	}
	boolean vr$11 = _ZN2FB14DTADDOVERFLOWSExx( *(int64*)THIS$1, -(*(int64*)O$1) );
	if( vr$11 == (boolean)0ll) goto label$110;
	{
		_ZN2FB8TIMESPANC1Ex( &fb$result$1, (int64)-9223372036854775808ull );
		goto label$105;
		label$110:;
	}
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, *(int64*)THIS$1 - *(int64*)O$1 );
	goto label$105;
	label$105:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN8MULTIPLYEd( struct $N2FB8TIMESPANE* THIS$1, double F$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$111:;
	if( *(int64*)THIS$1 != (int64)-9223372036854775808ull) goto label$114;
	{
		_ZN2FB8TIMESPANC1Ex( &fb$result$1, (int64)-9223372036854775808ull );
		goto label$112;
		label$114:;
	}
	int64 vr$5 = _ZN2FB17DTTICKSFROMDOUBLEEd( (double)*(int64*)THIS$1 * F$1 );
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, vr$5 );
	goto label$112;
	label$112:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN6DIVIDEEd( struct $N2FB8TIMESPANE* THIS$1, double F$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$115:;
	if( *(int64*)THIS$1 != (int64)-9223372036854775808ull) goto label$118;
	{
		_ZN2FB8TIMESPANC1Ex( &fb$result$1, (int64)-9223372036854775808ull );
		goto label$116;
		label$118:;
	}
	if( !(F$1 == 0x0p+0)) goto label$120;
	{
		_ZN2FB8TIMESPANC1Ex( &fb$result$1, (int64)-9223372036854775808ull );
		goto label$116;
		label$120:;
	}
	int64 vr$6 = _ZN2FB17DTTICKSFROMDOUBLEEd( (double)*(int64*)THIS$1 / F$1 );
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, vr$6 );
	goto label$116;
	label$116:;
	return fb$result$1;
}

static int32 _ZN2FB8TIMESPAN9COMPARETOERS0_( struct $N2FB8TIMESPANE* THIS$1, struct $N2FB8TIMESPANE* O$1 )
{
	boolean TMP$41$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$128:;
	boolean BAD$1;
	BAD$1 = (boolean)((int64)-(*(int64*)THIS$1 == (int64)-9223372036854775808ull) != 0ll);
	boolean BADO$1;
	BADO$1 = (boolean)((int64)-(*(int64*)O$1 == (int64)-9223372036854775808ull) != 0ll);
	if( BAD$1 != (boolean)0ll) goto label$130;
	TMP$41$1 = (boolean)(BADO$1 != (boolean)0ll);
	goto label$1157;
	label$130:;
	TMP$41$1 = (boolean)1ll;
	label$1157:;
	if( TMP$41$1 == (boolean)0ll) goto label$132;
	{
		fb$result$1 = -2;
		goto label$129;
		label$132:;
	}
	if( *(int64*)THIS$1 >= *(int64*)O$1) goto label$134;
	{
		fb$result$1 = -1;
		goto label$129;
		label$134:;
	}
	if( *(int64*)THIS$1 <= *(int64*)O$1) goto label$136;
	{
		fb$result$1 = 1;
		goto label$129;
		label$136:;
	}
	fb$result$1 = 0;
	goto label$129;
	label$129:;
	return fb$result$1;
}

static void _ZN2FB9LOCALDATEC1Ev( struct $N2FB9LOCALDATEE* THIS$1 )
{
	label$163:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	*(int32*)THIS$1 = (int32)-2147483648u;
	label$164:;
}

static void _ZN2FB9LOCALDATEC1Eiii( struct $N2FB9LOCALDATEE* THIS$1, int32 Y$1, int32 MO$1, int32 D$1 )
{
	label$165:;
	__builtin_memset( (int32*)THIS$1, 0, 4ll );
	int32 vr$2 = fb_DtIsValidDate( Y$1, MO$1, D$1 );
	if( (int64)vr$2 != 0ll) goto label$168;
	{
		*(int32*)THIS$1 = (int32)-2147483648u;
	}
	goto label$167;
	label$168:;
	{
		int32 vr$5 = fb_DtDaysFromCivil( Y$1, MO$1, D$1 );
		*(int32*)THIS$1 = vr$5;
	}
	label$167:;
	label$166:;
}

static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE13FROMDAYNUMBEREi( int32 DAYS$1 )
{
	boolean TMP$44$1;
	struct $N2FB9LOCALDATEE fb$result$1;
	label$169:;
	struct $N2FB9LOCALDATEE R$1;
	_ZN2FB9LOCALDATEC1Ev( &R$1 );
	boolean LO$1;
	LO$1 = (boolean)((int64)-((int64)DAYS$1 < 0ll) != 0ll);
	boolean HI$1;
	HI$1 = (boolean)((int64)-((int64)DAYS$1 > 3652058ll) != 0ll);
	if( LO$1 != (boolean)0ll) goto label$171;
	TMP$44$1 = (boolean)(HI$1 != (boolean)0ll);
	goto label$1160;
	label$171:;
	TMP$44$1 = (boolean)1ll;
	label$1160:;
	if( TMP$44$1 == (boolean)0ll) goto label$173;
	{
		*(int32*)&R$1 = (int32)-2147483648u;
	}
	goto label$172;
	label$173:;
	{
		*(int32*)&R$1 = DAYS$1;
	}
	label$172:;
	__builtin_memcpy( &fb$result$1, &R$1, 4 );
	goto label$170;
	label$170:;
	return fb$result$1;
}

static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE7INVALIDEv( void )
{
	struct $N2FB9LOCALDATEE fb$result$1;
	label$178:;
	struct $N2FB9LOCALDATEE R$1;
	_ZN2FB9LOCALDATEC1Ev( &R$1 );
	*(int32*)&R$1 = (int32)-2147483648u;
	__builtin_memcpy( &fb$result$1, &R$1, 4 );
	goto label$179;
	label$179:;
	return fb$result$1;
}

static boolean _ZN2FB9LOCALDATE14ISVALID__get__Ev( struct $N2FB9LOCALDATEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$180:;
	fb$result$1 = (boolean)((int64)-((int64)*(int32*)THIS$1 != -2147483648ll) != 0ll);
	goto label$181;
	label$181:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALDATE16DAYNUMBER__get__Ev( struct $N2FB9LOCALDATEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$182:;
	fb$result$1 = *(int32*)THIS$1;
	goto label$183;
	label$183:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALDATE11YEAR__get__Ev( struct $N2FB9LOCALDATEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$184:;
	if( (int64)*(int32*)THIS$1 != -2147483648ll) goto label$187;
	{
		fb$result$1 = 0;
		goto label$185;
		label$187:;
	}
	int32 Y$1;
	__builtin_memset( &Y$1, 0, 4ll );
	int32 MO$1;
	__builtin_memset( &MO$1, 0, 4ll );
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	fb_DtCivilFromDays( *(int32*)THIS$1, &Y$1, &MO$1, &D$1 );
	fb$result$1 = Y$1;
	goto label$185;
	label$185:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALDATE12MONTH__get__Ev( struct $N2FB9LOCALDATEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$188:;
	if( (int64)*(int32*)THIS$1 != -2147483648ll) goto label$191;
	{
		fb$result$1 = 0;
		goto label$189;
		label$191:;
	}
	int32 Y$1;
	__builtin_memset( &Y$1, 0, 4ll );
	int32 MO$1;
	__builtin_memset( &MO$1, 0, 4ll );
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	fb_DtCivilFromDays( *(int32*)THIS$1, &Y$1, &MO$1, &D$1 );
	fb$result$1 = MO$1;
	goto label$189;
	label$189:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALDATE10DAY__get__Ev( struct $N2FB9LOCALDATEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$192:;
	if( (int64)*(int32*)THIS$1 != -2147483648ll) goto label$195;
	{
		fb$result$1 = 0;
		goto label$193;
		label$195:;
	}
	int32 Y$1;
	__builtin_memset( &Y$1, 0, 4ll );
	int32 MO$1;
	__builtin_memset( &MO$1, 0, 4ll );
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	fb_DtCivilFromDays( *(int32*)THIS$1, &Y$1, &MO$1, &D$1 );
	fb$result$1 = D$1;
	goto label$193;
	label$193:;
	return fb$result$1;
}

static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE7ADDDAYSEi( struct $N2FB9LOCALDATEE* THIS$1, int32 N$1 )
{
	boolean TMP$45$1;
	struct $N2FB9LOCALDATEE fb$result$1;
	label$204:;
	if( (int64)*(int32*)THIS$1 != -2147483648ll) goto label$207;
	{
		struct $N2FB9LOCALDATEE vr$2 = _ZN2FB9LOCALDATE7INVALIDEv(  );
		fb$result$1 = vr$2;
		goto label$205;
		label$207:;
	}
	int64 R$1;
	R$1 = (int64)*(int32*)THIS$1 + (int64)N$1;
	boolean LO$1;
	LO$1 = (boolean)((int64)-(R$1 < 0ll) != 0ll);
	boolean HI$1;
	HI$1 = (boolean)((int64)-(R$1 > 3652058ll) != 0ll);
	if( LO$1 != (boolean)0ll) goto label$208;
	TMP$45$1 = (boolean)(HI$1 != (boolean)0ll);
	goto label$1161;
	label$208:;
	TMP$45$1 = (boolean)1ll;
	label$1161:;
	if( TMP$45$1 == (boolean)0ll) goto label$210;
	{
		struct $N2FB9LOCALDATEE vr$12 = _ZN2FB9LOCALDATE7INVALIDEv(  );
		fb$result$1 = vr$12;
		goto label$205;
		label$210:;
	}
	struct $N2FB9LOCALDATEE vr$14 = _ZN2FB9LOCALDATE13FROMDAYNUMBEREi( (int32)R$1 );
	fb$result$1 = vr$14;
	goto label$205;
	label$205:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALDATE14ISOWEEK__get__Ev( struct $N2FB9LOCALDATEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$211:;
	if( (int64)*(int32*)THIS$1 != -2147483648ll) goto label$214;
	{
		fb$result$1 = 0;
		goto label$212;
		label$214:;
	}
	int32 Y$1;
	__builtin_memset( &Y$1, 0, 4ll );
	int32 MO$1;
	__builtin_memset( &MO$1, 0, 4ll );
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	fb_DtCivilFromDays( *(int32*)THIS$1, &Y$1, &MO$1, &D$1 );
	int32 vr$10 = fb_DtIsoWeek( Y$1, MO$1, D$1, (int32*)0ull );
	fb$result$1 = vr$10;
	goto label$212;
	label$212:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALDATE18ISOWEEKYEAR__get__Ev( struct $N2FB9LOCALDATEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$215:;
	if( (int64)*(int32*)THIS$1 != -2147483648ll) goto label$218;
	{
		fb$result$1 = 0;
		goto label$216;
		label$218:;
	}
	int32 Y$1;
	__builtin_memset( &Y$1, 0, 4ll );
	int32 MO$1;
	__builtin_memset( &MO$1, 0, 4ll );
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	int32 IY$1;
	__builtin_memset( &IY$1, 0, 4ll );
	fb_DtCivilFromDays( *(int32*)THIS$1, &Y$1, &MO$1, &D$1 );
	fb_DtIsoWeek( Y$1, MO$1, D$1, &IY$1 );
	fb$result$1 = IY$1;
	goto label$216;
	label$216:;
	return fb$result$1;
}

static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE9ADDMONTHSEi( struct $N2FB9LOCALDATEE* THIS$1, int32 N$1 )
{
	boolean TMP$46$1;
	struct $N2FB9LOCALDATEE fb$result$1;
	label$231:;
	if( (int64)*(int32*)THIS$1 != -2147483648ll) goto label$234;
	{
		struct $N2FB9LOCALDATEE vr$2 = _ZN2FB9LOCALDATE7INVALIDEv(  );
		fb$result$1 = vr$2;
		goto label$232;
		label$234:;
	}
	int32 Y$1;
	__builtin_memset( &Y$1, 0, 4ll );
	int32 MO$1;
	__builtin_memset( &MO$1, 0, 4ll );
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	fb_DtCivilFromDays( *(int32*)THIS$1, &Y$1, &MO$1, &D$1 );
	int64 TOTAL$1;
	TOTAL$1 = (((int64)Y$1 * 12ll) + ((int64)MO$1 + -1ll)) + (int64)N$1;
	int64 NY$1;
	NY$1 = TOTAL$1 / 12ll;
	int64 RM$1;
	RM$1 = TOTAL$1 % 12ll;
	if( RM$1 >= 0ll) goto label$236;
	{
		RM$1 = RM$1 + 12ll;
		NY$1 = NY$1 + -1ll;
	}
	label$236:;
	label$235:;
	boolean LO$1;
	LO$1 = (boolean)((int64)-(NY$1 < 1ll) != 0ll);
	boolean HI$1;
	HI$1 = (boolean)((int64)-(NY$1 > 9999ll) != 0ll);
	if( LO$1 != (boolean)0ll) goto label$237;
	TMP$46$1 = (boolean)(HI$1 != (boolean)0ll);
	goto label$1162;
	label$237:;
	TMP$46$1 = (boolean)1ll;
	label$1162:;
	if( TMP$46$1 == (boolean)0ll) goto label$239;
	{
		struct $N2FB9LOCALDATEE vr$26 = _ZN2FB9LOCALDATE7INVALIDEv(  );
		fb$result$1 = vr$26;
		goto label$232;
		label$239:;
	}
	int32 NM$1;
	NM$1 = (int32)((int64)(int32)RM$1 + 1ll);
	int32 LAST$1;
	int32 vr$32 = fb_DtDaysInMonth( (int32)NY$1, NM$1 );
	LAST$1 = vr$32;
	if( (int64)D$1 <= (int64)LAST$1) goto label$241;
	{
		D$1 = LAST$1;
		label$241:;
	}
	int32 vr$36 = fb_DtDaysFromCivil( (int32)NY$1, NM$1, D$1 );
	struct $N2FB9LOCALDATEE vr$37 = _ZN2FB9LOCALDATE13FROMDAYNUMBEREi( vr$36 );
	fb$result$1 = vr$37;
	goto label$232;
	label$232:;
	return fb$result$1;
}

static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE12STARTOFMONTHEv( struct $N2FB9LOCALDATEE* THIS$1 )
{
	struct $N2FB9LOCALDATEE fb$result$1;
	label$248:;
	if( (int64)*(int32*)THIS$1 != -2147483648ll) goto label$251;
	{
		struct $N2FB9LOCALDATEE vr$2 = _ZN2FB9LOCALDATE7INVALIDEv(  );
		fb$result$1 = vr$2;
		goto label$249;
		label$251:;
	}
	int32 vr$3 = _ZN2FB9LOCALDATE12MONTH__get__Ev( THIS$1 );
	int32 vr$4 = _ZN2FB9LOCALDATE11YEAR__get__Ev( THIS$1 );
	_ZN2FB9LOCALDATEC1Eiii( &fb$result$1, vr$4, vr$3, 1 );
	goto label$249;
	label$249:;
	return fb$result$1;
}

static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE10ENDOFMONTHEv( struct $N2FB9LOCALDATEE* THIS$1 )
{
	struct $N2FB9LOCALDATEE fb$result$1;
	label$252:;
	if( (int64)*(int32*)THIS$1 != -2147483648ll) goto label$255;
	{
		struct $N2FB9LOCALDATEE vr$2 = _ZN2FB9LOCALDATE7INVALIDEv(  );
		fb$result$1 = vr$2;
		goto label$253;
		label$255:;
	}
	int32 vr$3 = _ZN2FB9LOCALDATE12MONTH__get__Ev( THIS$1 );
	int32 vr$4 = _ZN2FB9LOCALDATE11YEAR__get__Ev( THIS$1 );
	int32 vr$5 = fb_DtDaysInMonth( vr$4, vr$3 );
	int32 vr$6 = _ZN2FB9LOCALDATE12MONTH__get__Ev( THIS$1 );
	int32 vr$7 = _ZN2FB9LOCALDATE11YEAR__get__Ev( THIS$1 );
	_ZN2FB9LOCALDATEC1Eiii( &fb$result$1, vr$7, vr$6, vr$5 );
	goto label$253;
	label$253:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALDATE9COMPARETOERS0_( struct $N2FB9LOCALDATEE* THIS$1, struct $N2FB9LOCALDATEE* O$1 )
{
	boolean TMP$49$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$256:;
	boolean BAD$1;
	BAD$1 = (boolean)((int64)-((int64)*(int32*)THIS$1 == -2147483648ll) != 0ll);
	boolean BADO$1;
	BADO$1 = (boolean)((int64)-((int64)*(int32*)O$1 == -2147483648ll) != 0ll);
	if( BAD$1 != (boolean)0ll) goto label$258;
	TMP$49$1 = (boolean)(BADO$1 != (boolean)0ll);
	goto label$1163;
	label$258:;
	TMP$49$1 = (boolean)1ll;
	label$1163:;
	if( TMP$49$1 == (boolean)0ll) goto label$260;
	{
		fb$result$1 = -2;
		goto label$257;
		label$260:;
	}
	if( (int64)*(int32*)THIS$1 >= (int64)*(int32*)O$1) goto label$262;
	{
		fb$result$1 = -1;
		goto label$257;
		label$262:;
	}
	if( (int64)*(int32*)THIS$1 <= (int64)*(int32*)O$1) goto label$264;
	{
		fb$result$1 = 1;
		goto label$257;
		label$264:;
	}
	fb$result$1 = 0;
	goto label$257;
	label$257:;
	return fb$result$1;
}

static void _ZN2FB9LOCALTIMEC1Ev( struct $N2FB9LOCALTIMEE* THIS$1 )
{
	label$284:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	*(int64*)THIS$1 = 0ll;
	label$285:;
}

static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME9FROMTICKSEx( int64 T$1 )
{
	boolean TMP$53$1;
	struct $N2FB9LOCALTIMEE fb$result$1;
	label$290:;
	struct $N2FB9LOCALTIMEE R$1;
	_ZN2FB9LOCALTIMEC1Ev( &R$1 );
	boolean LO$1;
	LO$1 = (boolean)((int64)-(T$1 < 0ll) != 0ll);
	boolean HI$1;
	HI$1 = (boolean)((int64)-(T$1 >= 864000000000ll) != 0ll);
	if( LO$1 != (boolean)0ll) goto label$292;
	TMP$53$1 = (boolean)(HI$1 != (boolean)0ll);
	goto label$1167;
	label$292:;
	TMP$53$1 = (boolean)1ll;
	label$1167:;
	if( TMP$53$1 == (boolean)0ll) goto label$294;
	{
		*(int64*)&R$1 = (int64)-9223372036854775808ull;
	}
	goto label$293;
	label$294:;
	{
		*(int64*)&R$1 = T$1;
	}
	label$293:;
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$291;
	label$291:;
	return fb$result$1;
}

static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME7INVALIDEv( void )
{
	struct $N2FB9LOCALTIMEE fb$result$1;
	label$301:;
	struct $N2FB9LOCALTIMEE R$1;
	_ZN2FB9LOCALTIMEC1Ev( &R$1 );
	*(int64*)&R$1 = (int64)-9223372036854775808ull;
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$302;
	label$302:;
	return fb$result$1;
}

static boolean _ZN2FB9LOCALTIME14ISVALID__get__Ev( struct $N2FB9LOCALTIMEE* THIS$1 )
{
	boolean TMP$54$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$303:;
	boolean LO$1;
	LO$1 = (boolean)((int64)-(*(int64*)THIS$1 >= 0ll) != 0ll);
	boolean HI$1;
	HI$1 = (boolean)((int64)-(*(int64*)THIS$1 < 864000000000ll) != 0ll);
	if( LO$1 == (boolean)0ll) goto label$305;
	TMP$54$1 = (boolean)(HI$1 != (boolean)0ll);
	goto label$1168;
	label$305:;
	TMP$54$1 = (boolean)0ll;
	label$1168:;
	fb$result$1 = TMP$54$1;
	goto label$304;
	label$304:;
	return fb$result$1;
}

static int64 _ZN2FB9LOCALTIME12TICKS__get__Ev( struct $N2FB9LOCALTIMEE* THIS$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$306:;
	fb$result$1 = *(int64*)THIS$1;
	goto label$307;
	label$307:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALTIME9COMPARETOERS0_( struct $N2FB9LOCALTIMEE* THIS$1, struct $N2FB9LOCALTIMEE* O$1 )
{
	boolean TMP$55$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$328:;
	boolean BAD$1;
	boolean vr$1 = _ZN2FB9LOCALTIME14ISVALID__get__Ev( THIS$1 );
	BAD$1 = (boolean)(vr$1 == (boolean)0ll);
	boolean BADO$1;
	boolean vr$3 = _ZN2FB9LOCALTIME14ISVALID__get__Ev( O$1 );
	BADO$1 = (boolean)(vr$3 == (boolean)0ll);
	if( BAD$1 != (boolean)0ll) goto label$330;
	TMP$55$1 = (boolean)(BADO$1 != (boolean)0ll);
	goto label$1169;
	label$330:;
	TMP$55$1 = (boolean)1ll;
	label$1169:;
	if( TMP$55$1 == (boolean)0ll) goto label$332;
	{
		fb$result$1 = -2;
		goto label$329;
		label$332:;
	}
	if( *(int64*)THIS$1 >= *(int64*)O$1) goto label$334;
	{
		fb$result$1 = -1;
		goto label$329;
		label$334:;
	}
	if( *(int64*)THIS$1 <= *(int64*)O$1) goto label$336;
	{
		fb$result$1 = 1;
		goto label$329;
		label$336:;
	}
	fb$result$1 = 0;
	goto label$329;
	label$329:;
	return fb$result$1;
}

static void _ZN2FB7INSTANTC1Ev( struct $N2FB7INSTANTE* THIS$1 )
{
	label$356:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	*(int64*)THIS$1 = (int64)-9223372036854775808ull;
	label$357:;
}

static void _ZN2FB7INSTANTC1Ex( struct $N2FB7INSTANTE* THIS$1, int64 T$1 )
{
	label$358:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	int32 vr$2 = fb_DtIsValidTicks( T$1 );
	if( (int64)vr$2 != 0ll) goto label$361;
	{
		*(int64*)THIS$1 = (int64)-9223372036854775808ull;
	}
	goto label$360;
	label$361:;
	{
		*(int64*)THIS$1 = T$1;
	}
	label$360:;
	label$359:;
}

static struct $N2FB7INSTANTE _ZN2FB7INSTANT7INVALIDEv( void )
{
	struct $N2FB7INSTANTE fb$result$1;
	label$368:;
	struct $N2FB7INSTANTE R$1;
	_ZN2FB7INSTANTC1Ev( &R$1 );
	*(int64*)&R$1 = (int64)-9223372036854775808ull;
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$369;
	label$369:;
	return fb$result$1;
}

static boolean _ZN2FB7INSTANT14ISVALID__get__Ev( struct $N2FB7INSTANTE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$370:;
	int32 vr$2 = fb_DtIsValidTicks( *(int64*)THIS$1 );
	fb$result$1 = (boolean)((int64)-((int64)vr$2 != 0ll) != 0ll);
	goto label$371;
	label$371:;
	return fb$result$1;
}

static int64 _ZN2FB7INSTANT12TICKS__get__Ev( struct $N2FB7INSTANTE* THIS$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$372:;
	fb$result$1 = *(int64*)THIS$1;
	goto label$373;
	label$373:;
	return fb$result$1;
}

static struct $N2FB7INSTANTE _ZN2FB7INSTANT3ADDERNS_8TIMESPANE( struct $N2FB7INSTANTE* THIS$1, struct $N2FB8TIMESPANE* S$1 )
{
	boolean TMP$64$1;
	struct $N2FB7INSTANTE fb$result$1;
	label$374:;
	boolean BAD$1;
	boolean vr$0 = _ZN2FB7INSTANT14ISVALID__get__Ev( THIS$1 );
	BAD$1 = (boolean)(vr$0 == (boolean)0ll);
	boolean BADS$1;
	boolean vr$2 = _ZN2FB8TIMESPAN14ISVALID__get__Ev( S$1 );
	BADS$1 = (boolean)(vr$2 == (boolean)0ll);
	if( BAD$1 != (boolean)0ll) goto label$376;
	TMP$64$1 = (boolean)(BADS$1 != (boolean)0ll);
	goto label$1173;
	label$376:;
	TMP$64$1 = (boolean)1ll;
	label$1173:;
	if( TMP$64$1 == (boolean)0ll) goto label$378;
	{
		struct $N2FB7INSTANTE vr$5 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$5;
		goto label$375;
		label$378:;
	}
	int64 vr$6 = _ZN2FB8TIMESPAN12TICKS__get__Ev( S$1 );
	boolean vr$8 = _ZN2FB14DTADDOVERFLOWSExx( *(int64*)THIS$1, vr$6 );
	if( vr$8 == (boolean)0ll) goto label$380;
	{
		struct $N2FB7INSTANTE vr$9 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$9;
		goto label$375;
		label$380:;
	}
	int64 vr$11 = _ZN2FB8TIMESPAN12TICKS__get__Ev( S$1 );
	_ZN2FB7INSTANTC1Ex( &fb$result$1, *(int64*)THIS$1 + vr$11 );
	goto label$375;
	label$375:;
	return fb$result$1;
}

static struct $N2FB7INSTANTE _ZN2FB7INSTANT8SUBTRACTERNS_8TIMESPANE( struct $N2FB7INSTANTE* THIS$1, struct $N2FB8TIMESPANE* S$1 )
{
	boolean TMP$66$1;
	struct $N2FB7INSTANTE fb$result$1;
	label$381:;
	boolean BAD$1;
	boolean vr$0 = _ZN2FB7INSTANT14ISVALID__get__Ev( THIS$1 );
	BAD$1 = (boolean)(vr$0 == (boolean)0ll);
	boolean BADS$1;
	boolean vr$2 = _ZN2FB8TIMESPAN14ISVALID__get__Ev( S$1 );
	BADS$1 = (boolean)(vr$2 == (boolean)0ll);
	if( BAD$1 != (boolean)0ll) goto label$383;
	TMP$66$1 = (boolean)(BADS$1 != (boolean)0ll);
	goto label$1174;
	label$383:;
	TMP$66$1 = (boolean)1ll;
	label$1174:;
	if( TMP$66$1 == (boolean)0ll) goto label$385;
	{
		struct $N2FB7INSTANTE vr$5 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$5;
		goto label$382;
		label$385:;
	}
	int64 vr$6 = _ZN2FB8TIMESPAN12TICKS__get__Ev( S$1 );
	boolean vr$9 = _ZN2FB14DTADDOVERFLOWSExx( *(int64*)THIS$1, -vr$6 );
	if( vr$9 == (boolean)0ll) goto label$387;
	{
		struct $N2FB7INSTANTE vr$10 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$10;
		goto label$382;
		label$387:;
	}
	int64 vr$12 = _ZN2FB8TIMESPAN12TICKS__get__Ev( S$1 );
	_ZN2FB7INSTANTC1Ex( &fb$result$1, *(int64*)THIS$1 - vr$12 );
	goto label$382;
	label$382:;
	return fb$result$1;
}

static int32 _ZN2FB7INSTANT9COMPARETOERS0_( struct $N2FB7INSTANTE* THIS$1, struct $N2FB7INSTANTE* O$1 )
{
	boolean TMP$68$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$388:;
	boolean BAD$1;
	boolean vr$1 = _ZN2FB7INSTANT14ISVALID__get__Ev( THIS$1 );
	BAD$1 = (boolean)(vr$1 == (boolean)0ll);
	boolean BADO$1;
	boolean vr$3 = _ZN2FB7INSTANT14ISVALID__get__Ev( O$1 );
	BADO$1 = (boolean)(vr$3 == (boolean)0ll);
	if( BAD$1 != (boolean)0ll) goto label$390;
	TMP$68$1 = (boolean)(BADO$1 != (boolean)0ll);
	goto label$1175;
	label$390:;
	TMP$68$1 = (boolean)1ll;
	label$1175:;
	if( TMP$68$1 == (boolean)0ll) goto label$392;
	{
		fb$result$1 = -2;
		goto label$389;
		label$392:;
	}
	if( *(int64*)THIS$1 >= *(int64*)O$1) goto label$394;
	{
		fb$result$1 = -1;
		goto label$389;
		label$394:;
	}
	if( *(int64*)THIS$1 <= *(int64*)O$1) goto label$396;
	{
		fb$result$1 = 1;
		goto label$389;
		label$396:;
	}
	fb$result$1 = 0;
	goto label$389;
	label$389:;
	return fb$result$1;
}

static boolean _ZN2FB15DTOFFSETISVALIDEs( int16 M$1 )
{
	boolean TMP$74$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$420:;
	if( (int64)M$1 != 32767ll) goto label$423;
	{
		fb$result$1 = (boolean)1ll;
		goto label$421;
		label$423:;
	}
	boolean LO$1;
	LO$1 = (boolean)((int64)-((int64)M$1 >= -1080ll) != 0ll);
	boolean HI$1;
	HI$1 = (boolean)((int64)-((int64)M$1 <= 1080ll) != 0ll);
	if( LO$1 == (boolean)0ll) goto label$424;
	TMP$74$1 = (boolean)(HI$1 != (boolean)0ll);
	goto label$1179;
	label$424:;
	TMP$74$1 = (boolean)0ll;
	label$1179:;
	fb$result$1 = TMP$74$1;
	goto label$421;
	label$421:;
	return fb$result$1;
}

static void _ZN2FB8DATETIMEC1Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	label$425:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	__builtin_memset( (int16*)((uint8*)THIS$1 + 8ll), 0, 2ll );
	*(int64*)THIS$1 = (int64)-9223372036854775808ull;
	*(int16*)((uint8*)THIS$1 + 8ll) = (int16)32767;
	label$426:;
}

static void _ZN2FB8DATETIMEC1Eiii( struct $N2FB8DATETIMEE* THIS$1, int32 Y$1, int32 MO$1, int32 D$1 )
{
	label$427:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	__builtin_memset( (int16*)((uint8*)THIS$1 + 8ll), 0, 2ll );
	*(int16*)((uint8*)THIS$1 + 8ll) = (int16)32767;
	int32 vr$7 = fb_DtFromCivil( Y$1, MO$1, D$1, 0, 0, 0, 0ll, (int64*)THIS$1 );
	if( (int64)vr$7 == 0ll) goto label$430;
	{
		*(int64*)THIS$1 = (int64)-9223372036854775808ull;
	}
	label$430:;
	label$429:;
	label$428:;
}

static void _ZN2FB8DATETIMEC1Eiiiiiii( struct $N2FB8DATETIMEE* THIS$1, int32 Y$1, int32 MO$1, int32 D$1, int32 H$1, int32 MI$1, int32 S$1, int32 MS$1 )
{
	label$431:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	__builtin_memset( (int16*)((uint8*)THIS$1 + 8ll), 0, 2ll );
	*(int16*)((uint8*)THIS$1 + 8ll) = (int16)32767;
	int32 vr$9 = fb_DtFromCivil( Y$1, MO$1, D$1, H$1, MI$1, S$1, (int64)MS$1 * 10000ll, (int64*)THIS$1 );
	if( (int64)vr$9 == 0ll) goto label$434;
	{
		*(int64*)THIS$1 = (int64)-9223372036854775808ull;
	}
	label$434:;
	label$433:;
	label$432:;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME9FROMTICKSExs( int64 T$1, int16 OFFMIN$1 )
{
	boolean TMP$75$1;
	struct $N2FB8DATETIMEE fb$result$1;
	label$435:;
	struct $N2FB8DATETIMEE R$1;
	_ZN2FB8DATETIMEC1Ev( &R$1 );
	boolean OKTICKS$1;
	int32 vr$1 = fb_DtIsValidTicks( T$1 );
	OKTICKS$1 = (boolean)((int64)-((int64)vr$1 != 0ll) != 0ll);
	boolean OKOFF$1;
	boolean vr$5 = _ZN2FB15DTOFFSETISVALIDEs( OFFMIN$1 );
	OKOFF$1 = vr$5;
	if( OKTICKS$1 == (boolean)0ll) goto label$437;
	TMP$75$1 = (boolean)(OKOFF$1 != (boolean)0ll);
	goto label$1180;
	label$437:;
	TMP$75$1 = (boolean)0ll;
	label$1180:;
	if( TMP$75$1 == (boolean)0ll) goto label$439;
	{
		*(int64*)&R$1 = T$1;
		*(int16*)((uint8*)&R$1 + 8ll) = OFFMIN$1;
	}
	label$439:;
	label$438:;
	__builtin_memcpy( &fb$result$1, &R$1, 16 );
	goto label$436;
	label$436:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME11FROMINSTANTERNS_7INSTANTEs( struct $N2FB7INSTANTE* I$1, int16 OFFMIN$1 )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$449:;
	boolean vr$0 = _ZN2FB7INSTANT14ISVALID__get__Ev( I$1 );
	if( vr$0 != (boolean)0ll) goto label$452;
	{
		struct $N2FB8DATETIMEE vr$1 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$450;
		label$452:;
	}
	boolean vr$2 = _ZN2FB15DTOFFSETISVALIDEs( OFFMIN$1 );
	if( vr$2 != (boolean)0ll) goto label$454;
	{
		struct $N2FB8DATETIMEE vr$3 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$3;
		goto label$450;
		label$454:;
	}
	if( (int64)OFFMIN$1 != 32767ll) goto label$456;
	{
		struct $N2FB8DATETIMEE vr$5 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$5;
		goto label$450;
		label$456:;
	}
	int64 SHIFT$1;
	SHIFT$1 = (int64)OFFMIN$1 * 600000000ll;
	int64 vr$8 = _ZN2FB7INSTANT12TICKS__get__Ev( I$1 );
	boolean vr$9 = _ZN2FB14DTADDOVERFLOWSExx( vr$8, SHIFT$1 );
	if( vr$9 == (boolean)0ll) goto label$458;
	{
		struct $N2FB8DATETIMEE vr$10 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$10;
		goto label$450;
		label$458:;
	}
	int64 vr$11 = _ZN2FB7INSTANT12TICKS__get__Ev( I$1 );
	struct $N2FB8DATETIMEE vr$13 = _ZN2FB8DATETIME9FROMTICKSExs( vr$11 + SHIFT$1, OFFMIN$1 );
	fb$result$1 = vr$13;
	goto label$450;
	label$450:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8MINVALUEEv( void )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$459:;
	struct $N2FB8DATETIMEE vr$0 = _ZN2FB8DATETIME9FROMTICKSExs( 0ll, (int16)32767 );
	fb$result$1 = vr$0;
	goto label$460;
	label$460:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8MAXVALUEEv( void )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$461:;
	struct $N2FB8DATETIMEE vr$0 = _ZN2FB8DATETIME9FROMTICKSExs( 3155378975999999999ll, (int16)32767 );
	fb$result$1 = vr$0;
	goto label$462;
	label$462:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME7INVALIDEv( void )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$463:;
	struct $N2FB8DATETIMEE R$1;
	_ZN2FB8DATETIMEC1Ev( &R$1 );
	__builtin_memcpy( &fb$result$1, &R$1, 16 );
	goto label$464;
	label$464:;
	return fb$result$1;
}

static boolean _ZN2FB8DATETIME14ISVALID__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$465:;
	int32 vr$2 = fb_DtIsValidTicks( *(int64*)THIS$1 );
	fb$result$1 = (boolean)((int64)-((int64)vr$2 != 0ll) != 0ll);
	goto label$466;
	label$466:;
	return fb$result$1;
}

static int64 _ZN2FB8DATETIME12TICKS__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$467:;
	fb$result$1 = *(int64*)THIS$1;
	goto label$468;
	label$468:;
	return fb$result$1;
}

static int16 _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int16 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 2ll );
	label$469:;
	fb$result$1 = *(int16*)((uint8*)THIS$1 + 8ll);
	goto label$470;
	label$470:;
	return fb$result$1;
}

static boolean _ZN2FB8DATETIME16HASOFFSET__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$471:;
	fb$result$1 = (boolean)((int64)-((int64)*(int16*)((uint8*)THIS$1 + 8ll) != 32767ll) != 0ll);
	goto label$472;
	label$472:;
	return fb$result$1;
}

static int32 _ZN2FB8DATETIME11YEAR__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$475:;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$478;
	{
		fb$result$1 = 0;
		goto label$476;
		label$478:;
	}
	int32 Y$1;
	__builtin_memset( &Y$1, 0, 4ll );
	int32 MO$1;
	__builtin_memset( &MO$1, 0, 4ll );
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	fb_DtCivilFromDays( (int32)(*(int64*)THIS$1 / 864000000000ll), &Y$1, &MO$1, &D$1 );
	fb$result$1 = Y$1;
	goto label$476;
	label$476:;
	return fb$result$1;
}

static int32 _ZN2FB8DATETIME12MONTH__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$479:;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$482;
	{
		fb$result$1 = 0;
		goto label$480;
		label$482:;
	}
	int32 Y$1;
	__builtin_memset( &Y$1, 0, 4ll );
	int32 MO$1;
	__builtin_memset( &MO$1, 0, 4ll );
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	fb_DtCivilFromDays( (int32)(*(int64*)THIS$1 / 864000000000ll), &Y$1, &MO$1, &D$1 );
	fb$result$1 = MO$1;
	goto label$480;
	label$480:;
	return fb$result$1;
}

static int32 _ZN2FB8DATETIME10DAY__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$483:;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$486;
	{
		fb$result$1 = 0;
		goto label$484;
		label$486:;
	}
	int32 Y$1;
	__builtin_memset( &Y$1, 0, 4ll );
	int32 MO$1;
	__builtin_memset( &MO$1, 0, 4ll );
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	fb_DtCivilFromDays( (int32)(*(int64*)THIS$1 / 864000000000ll), &Y$1, &MO$1, &D$1 );
	fb$result$1 = D$1;
	goto label$484;
	label$484:;
	return fb$result$1;
}

static int32 _ZN2FB8DATETIME11HOUR__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$491:;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$494;
	{
		fb$result$1 = 0;
		goto label$492;
		label$494:;
	}
	fb$result$1 = (int32)((*(int64*)THIS$1 % 864000000000ll) / 36000000000ll);
	goto label$492;
	label$492:;
	return fb$result$1;
}

static int32 _ZN2FB8DATETIME16DAYOFWEEK__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$511:;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$514;
	{
		fb$result$1 = 0;
		goto label$512;
		label$514:;
	}
	int32 vr$5 = fb_DtDayOfWeek( (int32)(*(int64*)THIS$1 / 864000000000ll) );
	fb$result$1 = vr$5;
	goto label$512;
	label$512:;
	return fb$result$1;
}

static struct $N2FB9LOCALDATEE _ZN2FB8DATETIME7GETDATEEv( struct $N2FB8DATETIMEE* THIS$1 )
{
	struct $N2FB9LOCALDATEE fb$result$1;
	label$519:;
	boolean vr$0 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$0 != (boolean)0ll) goto label$522;
	{
		struct $N2FB9LOCALDATEE vr$1 = _ZN2FB9LOCALDATE7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$520;
		label$522:;
	}
	struct $N2FB9LOCALDATEE vr$5 = _ZN2FB9LOCALDATE13FROMDAYNUMBEREi( (int32)(*(int64*)THIS$1 / 864000000000ll) );
	fb$result$1 = vr$5;
	goto label$520;
	label$520:;
	return fb$result$1;
}

static struct $N2FB9LOCALTIMEE _ZN2FB8DATETIME12GETTIMEOFDAYEv( struct $N2FB8DATETIMEE* THIS$1 )
{
	struct $N2FB9LOCALTIMEE fb$result$1;
	label$523:;
	boolean vr$0 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$0 != (boolean)0ll) goto label$526;
	{
		struct $N2FB9LOCALTIMEE vr$1 = _ZN2FB9LOCALTIME7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$524;
		label$526:;
	}
	struct $N2FB9LOCALTIMEE vr$4 = _ZN2FB9LOCALTIME9FROMTICKSEx( *(int64*)THIS$1 % 864000000000ll );
	fb$result$1 = vr$4;
	goto label$524;
	label$524:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME10WITHOFFSETEs( struct $N2FB8DATETIMEE* THIS$1, int16 OFFMIN$1 )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$527:;
	boolean vr$0 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$0 != (boolean)0ll) goto label$530;
	{
		struct $N2FB8DATETIMEE vr$1 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$528;
		label$530:;
	}
	struct $N2FB8DATETIMEE vr$3 = _ZN2FB8DATETIME9FROMTICKSExs( *(int64*)THIS$1, OFFMIN$1 );
	fb$result$1 = vr$3;
	goto label$528;
	label$528:;
	return fb$result$1;
}

static struct $N2FB7INSTANTE _ZN2FB8DATETIME9ASSUMEUTCEv( struct $N2FB8DATETIMEE* THIS$1 )
{
	struct $N2FB7INSTANTE fb$result$1;
	label$543:;
	boolean vr$0 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$0 != (boolean)0ll) goto label$546;
	{
		struct $N2FB7INSTANTE vr$1 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$544;
		label$546:;
	}
	_ZN2FB7INSTANTC1Ex( &fb$result$1, *(int64*)THIS$1 );
	goto label$544;
	label$544:;
	return fb$result$1;
}

static struct $N2FB7INSTANTE _ZN2FB8DATETIME9TOINSTANTEv( struct $N2FB8DATETIMEE* THIS$1 )
{
	struct $N2FB7INSTANTE fb$result$1;
	label$547:;
	boolean vr$0 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$0 != (boolean)0ll) goto label$550;
	{
		struct $N2FB7INSTANTE vr$1 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$548;
		label$550:;
	}
	boolean vr$2 = _ZN2FB8DATETIME16HASOFFSET__get__Ev( THIS$1 );
	if( vr$2 != (boolean)0ll) goto label$552;
	{
		struct $N2FB7INSTANTE vr$3 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$3;
		goto label$548;
		label$552:;
	}
	int64 SHIFT$1;
	SHIFT$1 = (int64)*(int16*)((uint8*)THIS$1 + 8ll) * 600000000ll;
	boolean vr$9 = _ZN2FB14DTADDOVERFLOWSExx( *(int64*)THIS$1, -SHIFT$1 );
	if( vr$9 == (boolean)0ll) goto label$554;
	{
		struct $N2FB7INSTANTE vr$10 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$10;
		goto label$548;
		label$554:;
	}
	_ZN2FB7INSTANTC1Ex( &fb$result$1, *(int64*)THIS$1 - SHIFT$1 );
	goto label$548;
	label$548:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8ADDTICKSEx( struct $N2FB8DATETIMEE* THIS$1, int64 N$1 )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$555:;
	boolean vr$0 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$0 != (boolean)0ll) goto label$558;
	{
		struct $N2FB8DATETIMEE vr$1 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$556;
		label$558:;
	}
	boolean vr$3 = _ZN2FB14DTADDOVERFLOWSExx( *(int64*)THIS$1, N$1 );
	if( vr$3 == (boolean)0ll) goto label$560;
	{
		struct $N2FB8DATETIMEE vr$4 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$4;
		goto label$556;
		label$560:;
	}
	struct $N2FB8DATETIMEE vr$8 = _ZN2FB8DATETIME9FROMTICKSExs( *(int64*)THIS$1 + N$1, *(int16*)((uint8*)THIS$1 + 8ll) );
	fb$result$1 = vr$8;
	goto label$556;
	label$556:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME3ADDERNS_8TIMESPANE( struct $N2FB8DATETIMEE* THIS$1, struct $N2FB8TIMESPANE* S$1 )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$561:;
	boolean vr$0 = _ZN2FB8TIMESPAN14ISVALID__get__Ev( S$1 );
	if( vr$0 != (boolean)0ll) goto label$564;
	{
		struct $N2FB8DATETIMEE vr$1 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$562;
		label$564:;
	}
	int64 vr$2 = _ZN2FB8TIMESPAN12TICKS__get__Ev( S$1 );
	struct $N2FB8DATETIMEE vr$3 = _ZN2FB8DATETIME8ADDTICKSEx( THIS$1, vr$2 );
	fb$result$1 = vr$3;
	goto label$562;
	label$562:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8SUBTRACTERNS_8TIMESPANE( struct $N2FB8DATETIMEE* THIS$1, struct $N2FB8TIMESPANE* S$1 )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$565:;
	boolean vr$0 = _ZN2FB8TIMESPAN14ISVALID__get__Ev( S$1 );
	if( vr$0 != (boolean)0ll) goto label$568;
	{
		struct $N2FB8DATETIMEE vr$1 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$566;
		label$568:;
	}
	int64 vr$2 = _ZN2FB8TIMESPAN12TICKS__get__Ev( S$1 );
	struct $N2FB8DATETIMEE vr$4 = _ZN2FB8DATETIME8ADDTICKSEx( THIS$1, -vr$2 );
	fb$result$1 = vr$4;
	goto label$566;
	label$566:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME9ADDMONTHSEi( struct $N2FB8DATETIMEE* THIS$1, int32 N$1 )
{
	struct $N2FB9LOCALDATEE TMP$79$1;
	struct $N2FB8DATETIMEE fb$result$1;
	label$589:;
	boolean vr$0 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$0 != (boolean)0ll) goto label$592;
	{
		struct $N2FB8DATETIMEE vr$1 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$590;
		label$592:;
	}
	struct $N2FB9LOCALDATEE D$1;
	struct $N2FB9LOCALDATEE vr$2 = _ZN2FB8DATETIME7GETDATEEv( THIS$1 );
	TMP$79$1 = vr$2;
	struct $N2FB9LOCALDATEE vr$4 = _ZN2FB9LOCALDATE9ADDMONTHSEi( &TMP$79$1, N$1 );
	D$1 = vr$4;
	boolean vr$6 = _ZN2FB9LOCALDATE14ISVALID__get__Ev( &D$1 );
	if( vr$6 != (boolean)0ll) goto label$594;
	{
		struct $N2FB8DATETIMEE vr$7 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$7;
		goto label$590;
		label$594:;
	}
	int32 vr$10 = _ZN2FB9LOCALDATE16DAYNUMBER__get__Ev( &D$1 );
	struct $N2FB8DATETIMEE vr$16 = _ZN2FB8DATETIME9FROMTICKSExs( ((int64)vr$10 * 864000000000ll) + (*(int64*)THIS$1 % 864000000000ll), *(int16*)((uint8*)THIS$1 + 8ll) );
	fb$result$1 = vr$16;
	goto label$590;
	label$590:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME10STARTOFDAYEv( struct $N2FB8DATETIMEE* THIS$1 )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$629:;
	boolean vr$0 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$0 != (boolean)0ll) goto label$632;
	{
		struct $N2FB8DATETIMEE vr$1 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$630;
		label$632:;
	}
	struct $N2FB8DATETIMEE vr$6 = _ZN2FB8DATETIME9FROMTICKSExs( (*(int64*)THIS$1 / 864000000000ll) * 864000000000ll, *(int16*)((uint8*)THIS$1 + 8ll) );
	fb$result$1 = vr$6;
	goto label$630;
	label$630:;
	return fb$result$1;
}

static int32 _ZN2FB8DATETIME9COMPARETOERS0_( struct $N2FB8DATETIMEE* THIS$1, struct $N2FB8DATETIMEE* O$1 )
{
	boolean TMP$90$1;
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$692:;
	boolean BAD$1;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	BAD$1 = (boolean)(vr$1 == (boolean)0ll);
	boolean BADO$1;
	boolean vr$3 = _ZN2FB8DATETIME14ISVALID__get__Ev( O$1 );
	BADO$1 = (boolean)(vr$3 == (boolean)0ll);
	if( BAD$1 != (boolean)0ll) goto label$694;
	TMP$90$1 = (boolean)(BADO$1 != (boolean)0ll);
	goto label$1185;
	label$694:;
	TMP$90$1 = (boolean)1ll;
	label$1185:;
	if( TMP$90$1 == (boolean)0ll) goto label$696;
	{
		fb$result$1 = -2;
		goto label$693;
		label$696:;
	}
	boolean HASA$1;
	boolean vr$6 = _ZN2FB8DATETIME16HASOFFSET__get__Ev( THIS$1 );
	HASA$1 = vr$6;
	boolean HASB$1;
	boolean vr$7 = _ZN2FB8DATETIME16HASOFFSET__get__Ev( O$1 );
	HASB$1 = vr$7;
	if( HASA$1 == HASB$1) goto label$698;
	{
		fb$result$1 = -2;
		goto label$693;
		label$698:;
	}
	int64 TA$1;
	TA$1 = *(int64*)THIS$1;
	int64 TB$1;
	TB$1 = *(int64*)O$1;
	if( HASA$1 == (boolean)0ll) goto label$700;
	{
		TA$1 = TA$1 - ((int64)*(int16*)((uint8*)THIS$1 + 8ll) * 600000000ll);
		TB$1 = TB$1 - ((int64)*(int16*)((uint8*)O$1 + 8ll) * 600000000ll);
	}
	label$700:;
	label$699:;
	if( TA$1 >= TB$1) goto label$702;
	{
		fb$result$1 = -1;
		goto label$693;
		label$702:;
	}
	if( TA$1 <= TB$1) goto label$704;
	{
		fb$result$1 = 1;
		goto label$693;
		label$704:;
	}
	fb$result$1 = 0;
	goto label$693;
	label$693:;
	return fb$result$1;
}

static FBSTRING* _ZN2FB8DATETIME11TOISOSTRINGEv( struct $N2FB8DATETIMEE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$732:;
	char BUF$1[40];
	__builtin_memset( (char*)BUF$1, 0, 40ll );
	int32 N$1;
	int32 vr$6 = fb_DtIsoFormat( *(int64*)THIS$1, (int32)*(int16*)((uint8*)THIS$1 + 8ll), (char*)BUF$1, 40 );
	N$1 = vr$6;
	if( (int64)N$1 > 0ll) goto label$735;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$733;
		label$735:;
	}
	FBSTRING* vr$11 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$12 = fb_LEFT( (FBSTRING*)vr$11, (int64)N$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$12, -1ll, 0 );
	goto label$733;
	label$733:;
	FBSTRING* vr$15 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$15;
}

static boolean _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING* S$1, struct $N2FB8DATETIMEE* RESULT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$738:;
	int64 T$1;
	__builtin_memset( &T$1, 0, 8ll );
	int32 OFF$1;
	__builtin_memset( &OFF$1, 0, 4ll );
	struct $N2FB8DATETIMEE vr$3 = _ZN2FB8DATETIME7INVALIDEv(  );
	*RESULT$1 = vr$3;
	int64 vr$7 = fb_StrLen( (void*)S$1, -1ll );
	int32 vr$10 = fb_DtIsoParse( (char*)*(char**)S$1, (int32)vr$7, &T$1, &OFF$1 );
	if( (int64)vr$10 == 0ll) goto label$741;
	{
		fb$result$1 = (boolean)0ll;
		goto label$739;
		label$741:;
	}
	struct $N2FB8DATETIMEE vr$13 = _ZN2FB8DATETIME9FROMTICKSExs( T$1, (int16)OFF$1 );
	*RESULT$1 = vr$13;
	boolean vr$15 = _ZN2FB8DATETIME14ISVALID__get__Ev( RESULT$1 );
	fb$result$1 = vr$15;
	goto label$739;
	label$739:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME8PARSEISOER8FBSTRING( FBSTRING* S$1 )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$744:;
	struct $N2FB8DATETIMEE R$1;
	_ZN2FB8DATETIMEC1Ev( &R$1 );
	_ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( S$1, &R$1 );
	__builtin_memcpy( &fb$result$1, &R$1, 16 );
	goto label$745;
	label$745:;
	return fb$result$1;
}

static FBSTRING* _ZN2FB7INSTANT11TOISOSTRINGEv( struct $N2FB7INSTANTE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$746:;
	char BUF$1[40];
	__builtin_memset( (char*)BUF$1, 0, 40ll );
	int32 N$1;
	int32 vr$4 = fb_DtIsoFormat( *(int64*)THIS$1, 0, (char*)BUF$1, 40 );
	N$1 = vr$4;
	if( (int64)N$1 > 0ll) goto label$749;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$747;
		label$749:;
	}
	FBSTRING* vr$9 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$10 = fb_LEFT( (FBSTRING*)vr$9, (int64)N$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$10, -1ll, 0 );
	goto label$747;
	label$747:;
	FBSTRING* vr$13 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$13;
}

static boolean _ZN2FB7INSTANT11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING* S$1, struct $N2FB7INSTANTE* RESULT$1 )
{
	struct $N2FB7INSTANTE TMP$97$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$752:;
	int64 T$1;
	__builtin_memset( &T$1, 0, 8ll );
	int32 OFF$1;
	__builtin_memset( &OFF$1, 0, 4ll );
	struct $N2FB7INSTANTE vr$3 = _ZN2FB7INSTANT7INVALIDEv(  );
	*RESULT$1 = vr$3;
	int64 vr$7 = fb_StrLen( (void*)S$1, -1ll );
	int32 vr$10 = fb_DtIsoParse( (char*)*(char**)S$1, (int32)vr$7, &T$1, &OFF$1 );
	if( (int64)vr$10 == 0ll) goto label$755;
	{
		fb$result$1 = (boolean)0ll;
		goto label$753;
		label$755:;
	}
	if( (int64)OFF$1 != 32767ll) goto label$757;
	{
		fb$result$1 = (boolean)0ll;
		goto label$753;
		label$757:;
	}
	int64 SHIFT$1;
	SHIFT$1 = (int64)OFF$1 * 600000000ll;
	boolean vr$16 = _ZN2FB14DTADDOVERFLOWSExx( T$1, -SHIFT$1 );
	if( vr$16 == (boolean)0ll) goto label$759;
	{
		fb$result$1 = (boolean)0ll;
		goto label$753;
		label$759:;
	}
	_ZN2FB7INSTANTC1Ex( &TMP$97$1, T$1 - SHIFT$1 );
	__builtin_memcpy( RESULT$1, &TMP$97$1, 8 );
	boolean vr$20 = _ZN2FB7INSTANT14ISVALID__get__Ev( RESULT$1 );
	fb$result$1 = vr$20;
	goto label$753;
	label$753:;
	return fb$result$1;
}

static struct $N2FB7INSTANTE _ZN2FB7INSTANT8PARSEISOER8FBSTRING( FBSTRING* S$1 )
{
	struct $N2FB7INSTANTE fb$result$1;
	label$760:;
	struct $N2FB7INSTANTE R$1;
	_ZN2FB7INSTANTC1Ev( &R$1 );
	_ZN2FB7INSTANT11TRYPARSEISOER8FBSTRINGRS0_( S$1, &R$1 );
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$761;
	label$761:;
	return fb$result$1;
}

static FBSTRING* _ZN2FB9LOCALDATE11TOISOSTRINGEv( struct $N2FB9LOCALDATEE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$762:;
	char BUF$1[16];
	__builtin_memset( (char*)BUF$1, 0, 16ll );
	int32 N$1;
	int32 vr$4 = fb_DtIsoFormatDate( *(int32*)THIS$1, (char*)BUF$1, 16 );
	N$1 = vr$4;
	if( (int64)N$1 > 0ll) goto label$765;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$763;
		label$765:;
	}
	FBSTRING* vr$9 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$10 = fb_LEFT( (FBSTRING*)vr$9, (int64)N$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$10, -1ll, 0 );
	goto label$763;
	label$763:;
	FBSTRING* vr$13 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$13;
}

static boolean _ZN2FB9LOCALDATE11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING* S$1, struct $N2FB9LOCALDATEE* RESULT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$768:;
	int32 D$1;
	__builtin_memset( &D$1, 0, 4ll );
	struct $N2FB9LOCALDATEE vr$2 = _ZN2FB9LOCALDATE7INVALIDEv(  );
	*RESULT$1 = vr$2;
	int64 vr$5 = fb_StrLen( (void*)S$1, -1ll );
	int32 vr$8 = fb_DtIsoParseDate( (char*)*(char**)S$1, (int32)vr$5, &D$1 );
	if( (int64)vr$8 == 0ll) goto label$771;
	{
		fb$result$1 = (boolean)0ll;
		goto label$769;
		label$771:;
	}
	struct $N2FB9LOCALDATEE vr$10 = _ZN2FB9LOCALDATE13FROMDAYNUMBEREi( D$1 );
	*RESULT$1 = vr$10;
	boolean vr$12 = _ZN2FB9LOCALDATE14ISVALID__get__Ev( RESULT$1 );
	fb$result$1 = vr$12;
	goto label$769;
	label$769:;
	return fb$result$1;
}

static struct $N2FB9LOCALDATEE _ZN2FB9LOCALDATE8PARSEISOER8FBSTRING( FBSTRING* S$1 )
{
	struct $N2FB9LOCALDATEE fb$result$1;
	label$772:;
	struct $N2FB9LOCALDATEE R$1;
	_ZN2FB9LOCALDATEC1Ev( &R$1 );
	_ZN2FB9LOCALDATE11TRYPARSEISOER8FBSTRINGRS0_( S$1, &R$1 );
	__builtin_memcpy( &fb$result$1, &R$1, 4 );
	goto label$773;
	label$773:;
	return fb$result$1;
}

static FBSTRING* _ZN2FB9LOCALTIME11TOISOSTRINGEv( struct $N2FB9LOCALTIMEE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$774:;
	char BUF$1[24];
	__builtin_memset( (char*)BUF$1, 0, 24ll );
	int32 N$1;
	int32 vr$4 = fb_DtIsoFormatTime( *(int64*)THIS$1, (char*)BUF$1, 24 );
	N$1 = vr$4;
	if( (int64)N$1 > 0ll) goto label$777;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$775;
		label$777:;
	}
	FBSTRING* vr$9 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$10 = fb_LEFT( (FBSTRING*)vr$9, (int64)N$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$10, -1ll, 0 );
	goto label$775;
	label$775:;
	FBSTRING* vr$13 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$13;
}

static boolean _ZN2FB9LOCALTIME11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING* S$1, struct $N2FB9LOCALTIMEE* RESULT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$780:;
	int64 T$1;
	__builtin_memset( &T$1, 0, 8ll );
	struct $N2FB9LOCALTIMEE vr$2 = _ZN2FB9LOCALTIME7INVALIDEv(  );
	*RESULT$1 = vr$2;
	int64 vr$5 = fb_StrLen( (void*)S$1, -1ll );
	int32 vr$8 = fb_DtIsoParseTime( (char*)*(char**)S$1, (int32)vr$5, &T$1 );
	if( (int64)vr$8 == 0ll) goto label$783;
	{
		fb$result$1 = (boolean)0ll;
		goto label$781;
		label$783:;
	}
	struct $N2FB9LOCALTIMEE vr$10 = _ZN2FB9LOCALTIME9FROMTICKSEx( T$1 );
	*RESULT$1 = vr$10;
	boolean vr$12 = _ZN2FB9LOCALTIME14ISVALID__get__Ev( RESULT$1 );
	fb$result$1 = vr$12;
	goto label$781;
	label$781:;
	return fb$result$1;
}

static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME8PARSEISOER8FBSTRING( FBSTRING* S$1 )
{
	struct $N2FB9LOCALTIMEE fb$result$1;
	label$784:;
	struct $N2FB9LOCALTIMEE R$1;
	_ZN2FB9LOCALTIMEC1Ev( &R$1 );
	_ZN2FB9LOCALTIME11TRYPARSEISOER8FBSTRINGRS0_( S$1, &R$1 );
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$785;
	label$785:;
	return fb$result$1;
}

static FBSTRING* _ZN2FB8DATETIME8TOSTRINGER8FBSTRING( struct $N2FB8DATETIMEE* THIS$1, FBSTRING* PATTERN$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$786:;
	FBSTRING R$1;
	__builtin_memset( &R$1, 0, 24ll );
	boolean vr$3 = _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( THIS$1, PATTERN$1, &R$1 );
	if( vr$3 != (boolean)0ll) goto label$789;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		fb_StrDelete( (FBSTRING*)&R$1 );
		goto label$787;
		label$789:;
	}
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&R$1, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&R$1 );
	goto label$787;
	fb_StrDelete( (FBSTRING*)&R$1 );
	label$787:;
	FBSTRING* vr$11 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$11;
}

static boolean _ZN2FB8DATETIME9TRYFORMATER8FBSTRINGS2_( struct $N2FB8DATETIMEE* THIS$1, FBSTRING* PATTERN$1, FBSTRING* RESULT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$790:;
	char BUF$1[256];
	__builtin_memset( (char*)BUF$1, 0, 256ll );
	fb_StrAssign( (void*)RESULT$1, -1ll, (void*)"", 1ll, 0 );
	int32 N$1;
	int64 vr$3 = fb_StrLen( (void*)PATTERN$1, -1ll );
	int32 vr$9 = fb_DtPatFormat( *(int64*)THIS$1, (int32)*(int16*)((uint8*)THIS$1 + 8ll), (char*)*(char**)PATTERN$1, (int32)vr$3, (char*)BUF$1, 256 );
	N$1 = vr$9;
	if( (int64)N$1 >= 0ll) goto label$793;
	{
		fb$result$1 = (boolean)0ll;
		goto label$791;
		label$793:;
	}
	FBSTRING* vr$13 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$14 = fb_LEFT( (FBSTRING*)vr$13, (int64)N$1 );
	fb_StrAssign( (void*)RESULT$1, -1ll, (void*)vr$14, -1ll, 0 );
	fb$result$1 = (boolean)1ll;
	goto label$791;
	label$791:;
	return fb$result$1;
}

static boolean _ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( FBSTRING* S$1, FBSTRING* PATTERN$1, struct $N2FB8DATETIMEE* RESULT$1 )
{
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$794:;
	int64 T$1;
	__builtin_memset( &T$1, 0, 8ll );
	int32 OFF$1;
	__builtin_memset( &OFF$1, 0, 4ll );
	struct $N2FB8DATETIMEE vr$3 = _ZN2FB8DATETIME7INVALIDEv(  );
	*RESULT$1 = vr$3;
	int64 vr$7 = fb_StrLen( (void*)PATTERN$1, -1ll );
	int64 vr$10 = fb_StrLen( (void*)S$1, -1ll );
	int32 vr$13 = fb_DtPatParse( (char*)*(char**)S$1, (int32)vr$10, (char*)*(char**)PATTERN$1, (int32)vr$7, &T$1, &OFF$1 );
	if( (int64)vr$13 == 0ll) goto label$797;
	{
		fb$result$1 = (boolean)0ll;
		goto label$795;
		label$797:;
	}
	struct $N2FB8DATETIMEE vr$16 = _ZN2FB8DATETIME9FROMTICKSExs( T$1, (int16)OFF$1 );
	*RESULT$1 = vr$16;
	boolean vr$18 = _ZN2FB8DATETIME14ISVALID__get__Ev( RESULT$1 );
	fb$result$1 = vr$18;
	goto label$795;
	label$795:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME10PARSEEXACTER8FBSTRINGS2_( FBSTRING* S$1, FBSTRING* PATTERN$1 )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$798:;
	struct $N2FB8DATETIMEE R$1;
	_ZN2FB8DATETIMEC1Ev( &R$1 );
	_ZN2FB8DATETIME13TRYPARSEEXACTER8FBSTRINGS2_RS0_( S$1, PATTERN$1, &R$1 );
	__builtin_memcpy( &fb$result$1, &R$1, 16 );
	goto label$799;
	label$799:;
	return fb$result$1;
}

static FBSTRING* _ZN2FB8TIMESPAN11TOISOSTRINGEv( struct $N2FB8TIMESPANE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$800:;
	char BUF$1[48];
	__builtin_memset( (char*)BUF$1, 0, 48ll );
	int32 N$1;
	int32 vr$4 = fb_DtIsoFormatDuration( *(int64*)THIS$1, (char*)BUF$1, 48 );
	N$1 = vr$4;
	if( (int64)N$1 > 0ll) goto label$803;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$801;
		label$803:;
	}
	FBSTRING* vr$9 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$10 = fb_LEFT( (FBSTRING*)vr$9, (int64)N$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$10, -1ll, 0 );
	goto label$801;
	label$801:;
	FBSTRING* vr$13 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$13;
}

static boolean _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING* S$1, struct $N2FB8TIMESPANE* RESULT$1 )
{
	struct $N2FB8TIMESPANE TMP$98$1;
	boolean fb$result$1;
	__builtin_memset( &fb$result$1, 0, 1ll );
	label$806:;
	int64 T$1;
	__builtin_memset( &T$1, 0, 8ll );
	struct $N2FB8TIMESPANE vr$2 = _ZN2FB8TIMESPAN7INVALIDEv(  );
	*RESULT$1 = vr$2;
	int64 vr$5 = fb_StrLen( (void*)S$1, -1ll );
	int32 vr$8 = fb_DtIsoParseDuration( (char*)*(char**)S$1, (int32)vr$5, &T$1 );
	if( (int64)vr$8 == 0ll) goto label$809;
	{
		fb$result$1 = (boolean)0ll;
		goto label$807;
		label$809:;
	}
	_ZN2FB8TIMESPANC1Ex( &TMP$98$1, T$1 );
	__builtin_memcpy( RESULT$1, &TMP$98$1, 8 );
	boolean vr$12 = _ZN2FB8TIMESPAN14ISVALID__get__Ev( RESULT$1 );
	fb$result$1 = vr$12;
	goto label$807;
	label$807:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN8PARSEISOER8FBSTRING( FBSTRING* S$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$810:;
	struct $N2FB8TIMESPANE R$1;
	_ZN2FB8TIMESPANC1Ev( &R$1 );
	_ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( S$1, &R$1 );
	__builtin_memcpy( &fb$result$1, &R$1, 8 );
	goto label$811;
	label$811:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME17ADDCALENDARMONTHSEi( struct $N2FB8DATETIMEE* THIS$1, int32 N$1 )
{
	struct $N2FB7INSTANTE TMP$101$1;
	struct $N2FB8DATETIMEE fb$result$1;
	label$850:;
	struct $N2FB8DATETIMEE R$1;
	struct $N2FB8DATETIMEE vr$0 = _ZN2FB8DATETIME9ADDMONTHSEi( THIS$1, N$1 );
	R$1 = vr$0;
	boolean vr$2 = _ZN2FB8DATETIME14ISVALID__get__Ev( &R$1 );
	if( vr$2 != (boolean)0ll) goto label$853;
	{
		struct $N2FB8DATETIMEE vr$3 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$3;
		goto label$851;
		label$853:;
	}
	boolean vr$4 = _ZN2FB8DATETIME16HASOFFSET__get__Ev( THIS$1 );
	if( vr$4 != (boolean)0ll) goto label$855;
	{
		__builtin_memcpy( &fb$result$1, &R$1, 16 );
		goto label$851;
		label$855:;
	}
	struct $N2FB7INSTANTE vr$8 = _ZN2FB8DATETIME9ASSUMEUTCEv( &R$1 );
	TMP$101$1 = vr$8;
	int64 vr$10 = _ZN2FB7INSTANT12TICKS__get__Ev( &TMP$101$1 );
	int32 vr$11 = fb_DtZoneOffsetAt( vr$10 );
	struct $N2FB8DATETIMEE vr$14 = _ZN2FB8DATETIME10WITHOFFSETEs( &R$1, (int16)vr$11 );
	fb$result$1 = vr$14;
	goto label$851;
	label$851:;
	return fb$result$1;
}

static FBSTRING* _ZN2FB8DATETIME18TOLOCALEDATESTRINGEi( struct $N2FB8DATETIMEE* THIS$1, int32 STYLE$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$862:;
	char BUF$1[256];
	__builtin_memset( (char*)BUF$1, 0, 256ll );
	boolean vr$2 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$2 != (boolean)0ll) goto label$865;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$863;
		label$865:;
	}
	int32 N$1;
	int32 vr$6 = fb_DtLocaleDateString( *(int64*)THIS$1, STYLE$1, (char*)BUF$1, 256 );
	N$1 = vr$6;
	if( (int64)N$1 > 0ll) goto label$867;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$863;
		label$867:;
	}
	FBSTRING* vr$11 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$12 = fb_LEFT( (FBSTRING*)vr$11, (int64)N$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$12, -1ll, 0 );
	goto label$863;
	label$863:;
	FBSTRING* vr$15 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$15;
}

static FBSTRING* _ZN2FB8DATETIME18TOLOCALETIMESTRINGEi( struct $N2FB8DATETIMEE* THIS$1, int32 STYLE$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$868:;
	char BUF$1[256];
	__builtin_memset( (char*)BUF$1, 0, 256ll );
	boolean vr$2 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$2 != (boolean)0ll) goto label$871;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$869;
		label$871:;
	}
	int32 N$1;
	int32 vr$6 = fb_DtLocaleTimeString( *(int64*)THIS$1, STYLE$1, (char*)BUF$1, 256 );
	N$1 = vr$6;
	if( (int64)N$1 > 0ll) goto label$873;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$869;
		label$873:;
	}
	FBSTRING* vr$11 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$12 = fb_LEFT( (FBSTRING*)vr$11, (int64)N$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$12, -1ll, 0 );
	goto label$869;
	label$869:;
	FBSTRING* vr$15 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$15;
}

static FBSTRING* _ZN2FB8DATETIME14TOLOCALESTRINGEi( struct $N2FB8DATETIMEE* THIS$1, int32 STYLE$1 )
{
	FBSTRING TMP$103$1;
	FBSTRING TMP$104$1;
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$874:;
	FBSTRING D$1;
	FBSTRING* vr$1 = _ZN2FB8DATETIME18TOLOCALEDATESTRINGEi( THIS$1, STYLE$1 );
	fb_StrInit( (void*)&D$1, -1ll, (void*)vr$1, -1ll, 0 );
	FBSTRING T$1;
	FBSTRING* vr$3 = _ZN2FB8DATETIME18TOLOCALETIMESTRINGEi( THIS$1, STYLE$1 );
	fb_StrInit( (void*)&T$1, -1ll, (void*)vr$3, -1ll, 0 );
	int64 vr$6 = fb_StrLen( (void*)&D$1, -1ll );
	if( vr$6 != 0ll) goto label$877;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&T$1, -1ll, 0 );
		fb_StrDelete( (FBSTRING*)&T$1 );
		fb_StrDelete( (FBSTRING*)&D$1 );
		goto label$875;
		label$877:;
	}
	int64 vr$12 = fb_StrLen( (void*)&T$1, -1ll );
	if( vr$12 != 0ll) goto label$879;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)&D$1, -1ll, 0 );
		fb_StrDelete( (FBSTRING*)&T$1 );
		fb_StrDelete( (FBSTRING*)&D$1 );
		goto label$875;
		label$879:;
	}
	__builtin_memset( &TMP$103$1, 0, 24ll );
	FBSTRING* vr$21 = fb_StrConcat( &TMP$103$1, (void*)&D$1, -1ll, (void*)" ", 2ll );
	__builtin_memset( &TMP$104$1, 0, 24ll );
	FBSTRING* vr$24 = fb_StrConcat( &TMP$104$1, (void*)vr$21, -1ll, (void*)&T$1, -1ll );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$24, -1ll, 0 );
	fb_StrDelete( (FBSTRING*)&T$1 );
	fb_StrDelete( (FBSTRING*)&D$1 );
	goto label$875;
	fb_StrDelete( (FBSTRING*)&T$1 );
	fb_StrDelete( (FBSTRING*)&D$1 );
	label$875:;
	FBSTRING* vr$31 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$31;
}

static FBSTRING* _ZN2FB8DATETIME9MONTHNAMEEib( int32 MO$1, boolean ABBREVIATED$1 )
{
	int64 TMP$105$1;
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$880:;
	char BUF$1[128];
	__builtin_memset( (char*)BUF$1, 0, 128ll );
	int32 N$1;
	if( ABBREVIATED$1 == (boolean)0ll) goto label$882;
	TMP$105$1 = 1ll;
	goto label$1189;
	label$882:;
	TMP$105$1 = 0ll;
	label$1189:;
	int32 vr$4 = fb_DtLocaleMonthName( MO$1, (int32)TMP$105$1, (char*)BUF$1, 128 );
	N$1 = vr$4;
	if( (int64)N$1 > 0ll) goto label$884;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$881;
		label$884:;
	}
	FBSTRING* vr$9 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$10 = fb_LEFT( (FBSTRING*)vr$9, (int64)N$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$10, -1ll, 0 );
	goto label$881;
	label$881:;
	FBSTRING* vr$13 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$13;
}

static FBSTRING* _ZN2FB8DATETIME11WEEKDAYNAMEEib( int32 DOW$1, boolean ABBREVIATED$1 )
{
	int64 TMP$106$1;
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$885:;
	char BUF$1[128];
	__builtin_memset( (char*)BUF$1, 0, 128ll );
	int32 N$1;
	if( ABBREVIATED$1 == (boolean)0ll) goto label$887;
	TMP$106$1 = 1ll;
	goto label$1190;
	label$887:;
	TMP$106$1 = 0ll;
	label$1190:;
	int32 vr$4 = fb_DtLocaleWeekdayName( DOW$1, (int32)TMP$106$1, (char*)BUF$1, 128 );
	N$1 = vr$4;
	if( (int64)N$1 > 0ll) goto label$889;
	{
		fb_StrInit( (void*)&fb$result$1, -1ll, (void*)"", 1ll, 0 );
		goto label$886;
		label$889:;
	}
	FBSTRING* vr$9 = fb_StrAllocTempDescZ( (char*)BUF$1 );
	FBSTRING* vr$10 = fb_LEFT( (FBSTRING*)vr$9, (int64)N$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$10, -1ll, 0 );
	goto label$886;
	label$886:;
	FBSTRING* vr$13 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$13;
}

static struct $N2FB7INSTANTE _ZN2FB7INSTANT15FROMUNIXSECONDSEx( int64 V$1 )
{
	struct $N2FB7INSTANTE fb$result$1;
	label$890:;
	if( V$1 <= 2147483647000ll) goto label$893;
	{
		struct $N2FB7INSTANTE vr$0 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$0;
		goto label$891;
		label$893:;
	}
	if( V$1 >= -2147483647000ll) goto label$895;
	{
		struct $N2FB7INSTANTE vr$1 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$891;
		label$895:;
	}
	_ZN2FB7INSTANTC1Ex( &fb$result$1, (V$1 * 10000000ll) + 621355968000000000ll );
	goto label$891;
	label$891:;
	return fb$result$1;
}

static struct $N2FB7INSTANTE _ZN2FB7INSTANT20FROMUNIXMILLISECONDSEx( int64 V$1 )
{
	struct $N2FB7INSTANTE fb$result$1;
	label$896:;
	if( V$1 <= 2147483647000000ll) goto label$899;
	{
		struct $N2FB7INSTANTE vr$0 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$0;
		goto label$897;
		label$899:;
	}
	if( V$1 >= -2147483647000000ll) goto label$901;
	{
		struct $N2FB7INSTANTE vr$1 = _ZN2FB7INSTANT7INVALIDEv(  );
		fb$result$1 = vr$1;
		goto label$897;
		label$901:;
	}
	_ZN2FB7INSTANTC1Ex( &fb$result$1, (V$1 * 10000ll) + 621355968000000000ll );
	goto label$897;
	label$897:;
	return fb$result$1;
}

static int64 _ZN2FB10DTFLOORDIVExx( int64 A$1, int64 B$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$908:;
	int64 Q$1;
	Q$1 = A$1 / B$1;
	if( (A$1 % B$1) == 0ll) goto label$911;
	{
		boolean NEGA$2;
		NEGA$2 = (boolean)((int64)-(A$1 < 0ll) != 0ll);
		boolean NEGB$2;
		NEGB$2 = (boolean)((int64)-(B$1 < 0ll) != 0ll);
		if( NEGA$2 == NEGB$2) goto label$913;
		{
			Q$1 = Q$1 + -1ll;
			label$913:;
		}
	}
	label$911:;
	label$910:;
	fb$result$1 = Q$1;
	goto label$909;
	label$909:;
	return fb$result$1;
}

static int64 _ZN2FB7INSTANT18UNIXSECONDS__get__Ev( struct $N2FB7INSTANTE* THIS$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$914:;
	boolean vr$1 = _ZN2FB7INSTANT14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$917;
	{
		fb$result$1 = (int64)-9223372036854775808ull;
		goto label$915;
		label$917:;
	}
	int64 vr$4 = _ZN2FB10DTFLOORDIVExx( *(int64*)THIS$1 + -621355968000000000ll, 10000000ll );
	fb$result$1 = vr$4;
	goto label$915;
	label$915:;
	return fb$result$1;
}

static int64 _ZN2FB7INSTANT23UNIXMILLISECONDS__get__Ev( struct $N2FB7INSTANTE* THIS$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$918:;
	boolean vr$1 = _ZN2FB7INSTANT14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$921;
	{
		fb$result$1 = (int64)-9223372036854775808ull;
		goto label$919;
		label$921:;
	}
	int64 vr$4 = _ZN2FB10DTFLOORDIVExx( *(int64*)THIS$1 + -621355968000000000ll, 10000ll );
	fb$result$1 = vr$4;
	goto label$919;
	label$919:;
	return fb$result$1;
}

static int64 _ZN2FB7INSTANT23UNIXMICROSECONDS__get__Ev( struct $N2FB7INSTANTE* THIS$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$922:;
	boolean vr$1 = _ZN2FB7INSTANT14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$925;
	{
		fb$result$1 = (int64)-9223372036854775808ull;
		goto label$923;
		label$925:;
	}
	int64 vr$4 = _ZN2FB10DTFLOORDIVExx( *(int64*)THIS$1 + -621355968000000000ll, 10ll );
	fb$result$1 = vr$4;
	goto label$923;
	label$923:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB8DATETIME10FROMSERIALEd( double D$1 )
{
	struct $N2FB8DATETIMEE fb$result$1;
	label$940:;
	int64 T$1;
	int64 vr$1 = _ZN2FB17DTTICKSFROMDOUBLEEd( D$1 * 0x1.9254D38p+39 );
	T$1 = vr$1;
	if( T$1 != (int64)-9223372036854775808ull) goto label$943;
	{
		struct $N2FB8DATETIMEE vr$2 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$2;
		goto label$941;
		label$943:;
	}
	boolean vr$3 = _ZN2FB14DTADDOVERFLOWSExx( T$1, 599264352000000000ll );
	if( vr$3 == (boolean)0ll) goto label$945;
	{
		struct $N2FB8DATETIMEE vr$4 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$4;
		goto label$941;
		label$945:;
	}
	struct $N2FB8DATETIMEE vr$6 = _ZN2FB8DATETIME9FROMTICKSExs( T$1 + 599264352000000000ll, (int16)32767 );
	fb$result$1 = vr$6;
	goto label$941;
	label$941:;
	return fb$result$1;
}

static double _ZN2FB8DATETIME13SERIAL__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	double fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$946:;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$949;
	{
		fb$result$1 = 0x0p+0;
		goto label$947;
		label$949:;
	}
	fb$result$1 = (double)(*(int64*)THIS$1 + -599264352000000000ll) / 0x1.9254D38p+39;
	goto label$947;
	label$947:;
	return fb$result$1;
}

static struct $N2FB8DATETIMEE _ZN2FB9WALLCLOCK3NOWEv( void )
{
	struct $N2FB7INSTANTE TMP$115$1;
	struct $N2FB8DATETIMEE fb$result$1;
	label$1016:;
	int64 UTC$1;
	int64 vr$0 = fb_DtClockUtcNow(  );
	UTC$1 = vr$0;
	int32 vr$1 = fb_DtIsValidTicks( UTC$1 );
	if( (int64)vr$1 != 0ll) goto label$1019;
	{
		struct $N2FB8DATETIMEE vr$3 = _ZN2FB8DATETIME7INVALIDEv(  );
		fb$result$1 = vr$3;
		goto label$1017;
		label$1019:;
	}
	int16 OFFMIN$1;
	int32 vr$4 = fb_DtClockLocalOffsetNow(  );
	OFFMIN$1 = (int16)vr$4;
	_ZN2FB7INSTANTC1Ex( &TMP$115$1, UTC$1 );
	struct $N2FB8DATETIMEE vr$8 = _ZN2FB8DATETIME11FROMINSTANTERNS_7INSTANTEs( &TMP$115$1, OFFMIN$1 );
	fb$result$1 = vr$8;
	goto label$1017;
	label$1017:;
	return fb$result$1;
}

static void _ZN2FB9STOPWATCHC1Ev( struct $N2FB9STOPWATCHE* THIS$1 )
{
	label$1026:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	__builtin_memset( (int64*)((uint8*)THIS$1 + 8ll), 0, 8ll );
	__builtin_memset( (boolean*)((uint8*)THIS$1 + 16ll), 0, 1ll );
	*(int64*)THIS$1 = 0ll;
	*(int64*)((uint8*)THIS$1 + 8ll) = 0ll;
	*(boolean*)((uint8*)THIS$1 + 16ll) = (boolean)0ll;
	label$1027:;
}

static void _ZN2FB9STOPWATCH5STARTEv( struct $N2FB9STOPWATCHE* THIS$1 )
{
	label$1030:;
	if( *(boolean*)((uint8*)THIS$1 + 16ll) == (boolean)0ll) goto label$1033;
	{
		goto label$1031;
		label$1033:;
	}
	int64 vr$1 = fb_DtMonoTimestamp(  );
	*(int64*)((uint8*)THIS$1 + 8ll) = vr$1;
	*(boolean*)((uint8*)THIS$1 + 16ll) = (boolean)1ll;
	label$1031:;
}

static int64 _ZN2FB9STOPWATCH19ELAPSEDTICKS__get__Ev( struct $N2FB9STOPWATCHE* THIS$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$1044:;
	int64 TOTAL$1;
	TOTAL$1 = *(int64*)THIS$1;
	if( *(boolean*)((uint8*)THIS$1 + 16ll) == (boolean)0ll) goto label$1047;
	{
		int64 COUNTS$2;
		int64 vr$3 = fb_DtMonoTimestamp(  );
		COUNTS$2 = vr$3 - *(int64*)((uint8*)THIS$1 + 8ll);
		int64 vr$6 = fb_DtMonoFrequency(  );
		int64 vr$7 = fb_DtTicksFromCounts( COUNTS$2, vr$6 );
		TOTAL$1 = TOTAL$1 + vr$7;
	}
	label$1047:;
	label$1046:;
	fb$result$1 = TOTAL$1;
	goto label$1045;
	label$1045:;
	return fb$result$1;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN24FORMAT_DATE_FIELDS__CTOREv( void )
{
	label$1084:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"format_date_fields_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN19FORMAT_DATE_FIELDS_Ev, (boolean)0ll );
	label$1085:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN24FORMAT_TIME_FIELDS__CTOREv( void )
{
	label$1088:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"format_time_fields_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN19FORMAT_TIME_FIELDS_Ev, (boolean)0ll );
	label$1089:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN22FORMAT_FRACTIONS__CTOREv( void )
{
	label$1092:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"format_fractions_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN17FORMAT_FRACTIONS_Ev, (boolean)0ll );
	label$1093:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN20FORMAT_OFFSETS__CTOREv( void )
{
	label$1096:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"format_offsets_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN15FORMAT_OFFSETS_Ev, (boolean)0ll );
	label$1097:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN27LITERALS_AND_ESCAPING__CTOREv( void )
{
	label$1100:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"literals_and_escaping_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN22LITERALS_AND_ESCAPING_Ev, (boolean)0ll );
	label$1101:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN22CONSTANT_FORMATS__CTOREv( void )
{
	label$1104:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"constant_formats_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN17CONSTANT_FORMATS_Ev, (boolean)0ll );
	label$1105:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN17PARSE_EXACT__CTOREv( void )
{
	label$1124:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"parse_exact_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN12PARSE_EXACT_Ev, (boolean)0ll );
	label$1125:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN21PARSE_REJECTION__CTOREv( void )
{
	label$1128:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"parse_rejection_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN16PARSE_REJECTION_Ev, (boolean)0ll );
	label$1129:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN24ROUNDTRIP_PATTERNS__CTOREv( void )
{
	label$1140:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"roundtrip_patterns_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN19ROUNDTRIP_PATTERNS_Ev, (boolean)0ll );
	label$1141:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN23NO_LOCALE_LEAKAGE__CTOREv( void )
{
	label$1148:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.pattern", (char*)"no_locale_leakage_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO7PATTERN18NO_LOCALE_LEAKAGE_Ev, (boolean)0ll );
	label$1149:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO7PATTERN13SUITE_CTOR329Ev( void )
{
	label$1150:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.chrono.pattern", (tmp$4)0ull, (tmp$4)0ull );
	label$1151:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
