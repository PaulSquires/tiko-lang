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
struct $N2FB7INSTANTE {
	int64 M_TICKS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB7INSTANTE ) == 8 );
struct $N2FB9LOCALDATEE {
	int32 M_DAYS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB9LOCALDATEE ) == 4 );
struct $N2FB9LOCALTIMEE {
	int64 M_TICKS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB9LOCALTIMEE ) == 8 );
struct $N2FB8TIMESPANE {
	int64 M_TICKS;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB8TIMESPANE ) == 8 );
struct $16__FB_ARRAYDIMTB$ {
	int64 ELEMENTS;
	int64 LBOUND;
	int64 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 24 );
struct $7FBARRAYIvE {
	void* DATA;
	void* PTR;
	int64 SIZE;
	int64 ELEMENT_LEN;
	int64 DIMENSIONS;
	int64 FLAGS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[8];
};
__FB_STATIC_ASSERT( sizeof( struct $7FBARRAYIvE ) == 240 );
struct $N2FB9STOPWATCHE {
	int64 M_ELAPSED;
	int64 M_STARTED;
	boolean M_RUNNING;
};
__FB_STATIC_ASSERT( sizeof( struct $N2FB9STOPWATCHE ) == 24 );
typedef void (*tmp$5)( void );
typedef int32 (*tmp$4)( void );
#define fb_D2L( value ) ((int64)__builtin_nearbyint( value ))
void fb_ArrayDestructStr( struct $7FBARRAYIvE* );
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
static void fb_ctor__iso( void ) __attribute__(( constructor ));
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
static void _ZN2FB8TIMESPANC1Eiiiii( struct $N2FB8TIMESPANE*, int32, int32, int32, int32, int32 );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN8FROMDAYSEd( double );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN9FROMHOURSEd( double );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN11FROMMINUTESEd( double );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN11FROMSECONDSEd( double );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN16FROMMILLISECONDSEd( double );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN9FROMTICKSEx( int64 );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN4ZEROEv( void );
static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN7INVALIDEv( void );
static int64 _ZN2FB8TIMESPAN12TICKS__get__Ev( struct $N2FB8TIMESPANE* );
static double _ZN2FB8TIMESPAN16TOTALDAYS__get__Ev( struct $N2FB8TIMESPANE* );
static double _ZN2FB8TIMESPAN17TOTALHOURS__get__Ev( struct $N2FB8TIMESPANE* );
static double _ZN2FB8TIMESPAN19TOTALMINUTES__get__Ev( struct $N2FB8TIMESPANE* );
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
static void _ZN2FB9LOCALTIMEC1Eiiii( struct $N2FB9LOCALTIMEE*, int32, int32, int32, int32 );
static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME9FROMTICKSEx( int64 );
static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME8MAXVALUEEv( void );
static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME7INVALIDEv( void );
static boolean _ZN2FB9LOCALTIME14ISVALID__get__Ev( struct $N2FB9LOCALTIMEE* );
static int64 _ZN2FB9LOCALTIME12TICKS__get__Ev( struct $N2FB9LOCALTIMEE* );
static int32 _ZN2FB9LOCALTIME11HOUR__get__Ev( struct $N2FB9LOCALTIMEE* );
static int32 _ZN2FB9LOCALTIME13MINUTE__get__Ev( struct $N2FB9LOCALTIMEE* );
static int32 _ZN2FB9LOCALTIME13SECOND__get__Ev( struct $N2FB9LOCALTIMEE* );
static int32 _ZN2FB9LOCALTIME9COMPARETOERS0_( struct $N2FB9LOCALTIMEE*, struct $N2FB9LOCALTIMEE* );
static FBSTRING* _ZN2FB9LOCALTIME11TOISOSTRINGEv( struct $N2FB9LOCALTIMEE* );
static boolean _ZN2FB9LOCALTIME11TRYPARSEISOER8FBSTRINGRS0_( FBSTRING*, struct $N2FB9LOCALTIMEE* );
static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME8PARSEISOER8FBSTRING( FBSTRING* );
static void _ZN2FB7INSTANTC1Ev( struct $N2FB7INSTANTE* );
static void _ZN2FB7INSTANTC1Ex( struct $N2FB7INSTANTE*, int64 );
static struct $N2FB7INSTANTE _ZN2FB7INSTANT9FROMTICKSEx( int64 );
static struct $N2FB7INSTANTE _ZN2FB7INSTANT8MINVALUEEv( void );
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
static int32 _ZN2FB8DATETIME13MINUTE__get__Ev( struct $N2FB8DATETIMEE* );
static int32 _ZN2FB8DATETIME13SECOND__get__Ev( struct $N2FB8DATETIMEE* );
static int64 _ZN2FB8DATETIME16TICKOFDAY__get__Ev( struct $N2FB8DATETIMEE* );
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
static FBSTRING* _ZN2FB8DATETIME8TOSTRINGEv( struct $N2FB8DATETIMEE* );
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
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO14EMIT_DATETIME_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO19EMIT_DATETIME__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO17EMIT_OTHER_TYPES_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO22EMIT_OTHER_TYPES__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO14EMIT_DURATION_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO19EMIT_DURATION__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO21PARSE_ACCEPTED_FORMS_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO26PARSE_ACCEPTED_FORMS__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO16PARSE_FRACTIONS_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO21PARSE_FRACTIONS__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO23PARSE_REJECTION_CORPUS_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO28PARSE_REJECTION_CORPUS__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO24INSTANT_REQUIRES_OFFSET_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO29INSTANT_REQUIRES_OFFSET__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO18PARSE_OTHER_TYPES_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO23PARSE_OTHER_TYPES__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO17DURATION_GRAMMAR_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO22DURATION_GRAMMAR__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO21ROUNDTRIP_EXHAUSTIVE_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO26ROUNDTRIP_EXHAUSTIVE__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO19STRING_FIXED_POINT_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO24STRING_FIXED_POINT__CTOREv( void ) __attribute__(( constructor ));
void _ZN5TESTS9FBC_TESTS6CHRONO3ISO18NO_LOCALE_LEAKAGE_Ev( void );
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO23NO_LOCALE_LEAKAGE__CTOREv( void ) __attribute__(( constructor ));
static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO13SUITE_CTOR350Ev( void ) __attribute__(( constructor ));

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO14EMIT_DATETIME_Ev( void )
{
	struct $N2FB8DATETIMEE TMP$128$1;
	struct $N2FB8DATETIMEE TMP$137$1;
	struct $N2FB8DATETIMEE TMP$138$1;
	struct $N2FB8DATETIMEE TMP$143$1;
	struct $N2FB8DATETIMEE TMP$144$1;
	struct $N2FB8DATETIMEE TMP$149$1;
	struct $N2FB8DATETIMEE TMP$150$1;
	struct $N2FB8DATETIMEE TMP$155$1;
	struct $N2FB8DATETIMEE TMP$156$1;
	struct $N2FB8DATETIMEE TMP$161$1;
	struct $N2FB8DATETIMEE TMP$162$1;
	struct $N2FB8DATETIMEE TMP$167$1;
	struct $N2FB8DATETIMEE TMP$168$1;
	struct $N2FB8DATETIMEE TMP$173$1;
	struct $N2FB8DATETIMEE TMP$178$1;
	struct $N2FB8DATETIMEE TMP$179$1;
	struct $N2FB8DATETIMEE TMP$187$1;
	struct $N2FB8DATETIMEE TMP$188$1;
	struct $N2FB8DATETIMEE TMP$196$1;
	struct $N2FB8DATETIMEE TMP$201$1;
	struct $N2FB8DATETIMEE TMP$206$1;
	struct $N2FB8DATETIMEE TMP$207$1;
	struct $N2FB8DATETIMEE TMP$212$1;
	struct $N2FB8DATETIMEE TMP$217$1;
	struct $N2FB7INSTANTE TMP$221$1;
	struct $N2FB9LOCALDATEE TMP$225$1;
	struct $N2FB9LOCALTIMEE TMP$229$1;
	struct $N2FB8DATETIMEE TMP$233$1;
	struct $N2FB8DATETIMEE TMP$234$1;
	label$1082:;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$128$1, 2025, 3, 4, 14, 30, 5, 0 );
	FBSTRING* vr$2 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$128$1 );
	int32 vr$3 = fb_StrCompare( (void*)vr$2, -1ll, (void*)"2025-03-04T14:30:05", 20ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$3 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 17, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 0 ).ToIsoString( ) = \x22" "2025-03-04T14:30:05\x22)" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$137$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE vr$9 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$137$1, (int16)0 );
	TMP$138$1 = vr$9;
	FBSTRING* vr$11 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$138$1 );
	int32 vr$12 = fb_StrCompare( (void*)vr$11, -1ll, (void*)"2025-03-04T14:30:05Z", 21ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$12 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 18, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 0 ).WithOffset( 0 ).ToIsoString( ) = \x22" "2025-03-04T14:30:05Z\x22)" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$143$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE vr$18 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$143$1, (int16)330 );
	TMP$144$1 = vr$18;
	FBSTRING* vr$20 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$144$1 );
	int32 vr$21 = fb_StrCompare( (void*)vr$20, -1ll, (void*)"2025-03-04T14:30:05+05:30", 26ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$21 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 19, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 0 ).WithOffset( 330 ).ToIsoString( ) = \x22" "2025-03-04T14:30:05+05:30\x22)" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$149$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE vr$27 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$149$1, (int16)-300 );
	TMP$150$1 = vr$27;
	FBSTRING* vr$29 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$150$1 );
	int32 vr$30 = fb_StrCompare( (void*)vr$29, -1ll, (void*)"2025-03-04T14:30:05-05:00", 26ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$30 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 20, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 0 ).WithOffset( -300 ).ToIsoString( ) = \x22" "2025-03-04T14:30:05-05:00\x22)" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$155$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE vr$36 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$155$1, (int16)345 );
	TMP$156$1 = vr$36;
	FBSTRING* vr$38 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$156$1 );
	int32 vr$39 = fb_StrCompare( (void*)vr$38, -1ll, (void*)"2025-03-04T14:30:05+05:45", 26ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$39 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 21, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 0 ).WithOffset( 345 ).ToIsoString( ) = \x22" "2025-03-04T14:30:05+05:45\x22)" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$161$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE vr$45 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$161$1, (int16)1080 );
	TMP$162$1 = vr$45;
	FBSTRING* vr$47 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$162$1 );
	int32 vr$48 = fb_StrCompare( (void*)vr$47, -1ll, (void*)"2025-03-04T14:30:05+18:00", 26ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$48 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 22, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 0 ).WithOffset( 1080 ).ToIsoString( ) = \x22" "2025-03-04T14:30:05+18:00\x22)" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$167$1, 2025, 3, 4, 14, 30, 5, 0 );
	struct $N2FB8DATETIMEE vr$54 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$167$1, (int16)-1080 );
	TMP$168$1 = vr$54;
	FBSTRING* vr$56 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$168$1 );
	int32 vr$57 = fb_StrCompare( (void*)vr$56, -1ll, (void*)"2025-03-04T14:30:05-18:00", 26ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$57 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 23, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 0 ).WithOffset( -1080 ).ToIsoString( ) = \x22" "2025-03-04T14:30:05-18:00\x22)" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$173$1, 2025, 3, 4, 14, 30, 5, 123 );
	FBSTRING* vr$63 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$173$1 );
	int32 vr$64 = fb_StrCompare( (void*)vr$63, -1ll, (void*)"2025-03-04T14:30:05.1230000", 28ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$64 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 26, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 123 ).ToIsoString( ) = \x22" "2025-03-04T14:30:05.1230000\x22)" );
	_ZN2FB8DATETIMEC1Eiii( &TMP$178$1, 2025, 1, 1 );
	int64 vr$70 = _ZN2FB8DATETIME12TICKS__get__Ev( &TMP$178$1 );
	struct $N2FB8DATETIMEE vr$72 = _ZN2FB8DATETIME9FROMTICKSExs( vr$70 + 1ll, (int16)32767 );
	TMP$179$1 = vr$72;
	FBSTRING* vr$74 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$179$1 );
	int32 vr$75 = fb_StrCompare( (void*)vr$74, -1ll, (void*)"2025-01-01T00:00:00.0000001", 28ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$75 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 28, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime.FromTicks( DateTime( 2025, 1, 1 ).Ticks + 1, DT_OFFSET_UNSPECIFIED ).ToIsoString( ) = \x09            \x22" "2025-01-01T00:00:00.0000001\x22)" );
	_ZN2FB8DATETIMEC1Eiii( &TMP$187$1, 2025, 1, 1 );
	int64 vr$81 = _ZN2FB8DATETIME12TICKS__get__Ev( &TMP$187$1 );
	struct $N2FB8DATETIMEE vr$83 = _ZN2FB8DATETIME9FROMTICKSExs( vr$81 + 1000000ll, (int16)32767 );
	TMP$188$1 = vr$83;
	FBSTRING* vr$85 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$188$1 );
	int32 vr$86 = fb_StrCompare( (void*)vr$85, -1ll, (void*)"2025-01-01T00:00:00.1000000", 28ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$86 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 30, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime.FromTicks( DateTime( 2025, 1, 1 ).Ticks + 1000000, DT_OFFSET_UNSPECIFIED ).ToIsoString( ) = \x09            \x22" "2025-01-01T00:00:00.1000000\x22)" );
	struct $N2FB8DATETIMEE vr$90 = _ZN2FB8DATETIME8MINVALUEEv(  );
	TMP$196$1 = vr$90;
	FBSTRING* vr$92 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$196$1 );
	int32 vr$93 = fb_StrCompare( (void*)vr$92, -1ll, (void*)"0001-01-01T00:00:00", 20ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$93 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 33, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime.MinValue.ToIsoString( ) = \x22" "0001-01-01T00:00:00\x22)" );
	struct $N2FB8DATETIMEE vr$97 = _ZN2FB8DATETIME8MAXVALUEEv(  );
	TMP$201$1 = vr$97;
	FBSTRING* vr$99 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$201$1 );
	int32 vr$100 = fb_StrCompare( (void*)vr$99, -1ll, (void*)"9999-12-31T23:59:59.9999999", 28ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$100 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 34, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime.MaxValue.ToIsoString( ) = \x22" "9999-12-31T23:59:59.9999999\x22)" );
	_ZN2FB8DATETIMEC1Eiii( &TMP$206$1, 1, 1, 1 );
	struct $N2FB8DATETIMEE vr$106 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$206$1, (int16)0 );
	TMP$207$1 = vr$106;
	FBSTRING* vr$108 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$207$1 );
	int32 vr$109 = fb_StrCompare( (void*)vr$108, -1ll, (void*)"0001-01-01T00:00:00Z", 21ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$109 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 35, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 1, 1, 1 ).WithOffset( 0 ).ToIsoString( ) = \x22" "0001-01-01T00:00:00Z\x22)" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$212$1, 2025, 1, 2, 3, 4, 5, 0 );
	FBSTRING* vr$115 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$212$1 );
	int32 vr$116 = fb_StrCompare( (void*)vr$115, -1ll, (void*)"2025-01-02T03:04:05", 20ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$116 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 38, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 1, 2, 3, 4, 5, 0 ).ToIsoString( ) = \x22" "2025-01-02T03:04:05\x22)" );
	struct $N2FB8DATETIMEE vr$120 = _ZN2FB8DATETIME7INVALIDEv(  );
	TMP$217$1 = vr$120;
	FBSTRING* vr$122 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$217$1 );
	int32 vr$123 = fb_StrCompare( (void*)vr$122, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$123 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 41, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime.Invalid.ToIsoString( ) = \x22\x22)" );
	struct $N2FB7INSTANTE vr$127 = _ZN2FB7INSTANT7INVALIDEv(  );
	TMP$221$1 = vr$127;
	FBSTRING* vr$129 = _ZN2FB7INSTANT11TOISOSTRINGEv( &TMP$221$1 );
	int32 vr$130 = fb_StrCompare( (void*)vr$129, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$130 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 42, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(Instant.Invalid.ToIsoString( ) = \x22\x22)" );
	struct $N2FB9LOCALDATEE vr$134 = _ZN2FB9LOCALDATE7INVALIDEv(  );
	TMP$225$1 = vr$134;
	FBSTRING* vr$136 = _ZN2FB9LOCALDATE11TOISOSTRINGEv( &TMP$225$1 );
	int32 vr$137 = fb_StrCompare( (void*)vr$136, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$137 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 43, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(LocalDate.Invalid.ToIsoString( ) = \x22\x22)" );
	struct $N2FB9LOCALTIMEE vr$141 = _ZN2FB9LOCALTIME7INVALIDEv(  );
	TMP$229$1 = vr$141;
	FBSTRING* vr$143 = _ZN2FB9LOCALTIME11TOISOSTRINGEv( &TMP$229$1 );
	int32 vr$144 = fb_StrCompare( (void*)vr$143, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$144 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 44, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(LocalTime.Invalid.ToIsoString( ) = \x22\x22)" );
	_ZN2FB8DATETIMEC1Eiii( &TMP$234$1, 2025, 3, 4 );
	FBSTRING* vr$150 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$234$1 );
	_ZN2FB8DATETIMEC1Eiii( &TMP$233$1, 2025, 3, 4 );
	FBSTRING* vr$153 = _ZN2FB8DATETIME8TOSTRINGEv( &TMP$233$1 );
	int32 vr$154 = fb_StrCompare( (void*)vr$153, -1ll, (void*)vr$150, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$154 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 47, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DATETIME_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4 ).ToString( ) = DateTime( 2025, 3, 4 ).ToIsoString( ))" );
	label$1083:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO17EMIT_OTHER_TYPES_Ev( void )
{
	struct $N2FB8DATETIMEE TMP$240$1;
	struct $N2FB7INSTANTE TMP$241$1;
	struct $N2FB7INSTANTE TMP$248$1;
	struct $N2FB9LOCALDATEE TMP$252$1;
	struct $N2FB9LOCALDATEE TMP$257$1;
	struct $N2FB9LOCALDATEE TMP$262$1;
	struct $N2FB9LOCALTIMEE TMP$267$1;
	struct $N2FB9LOCALTIMEE TMP$272$1;
	struct $N2FB9LOCALTIMEE TMP$277$1;
	struct $N2FB9LOCALTIMEE TMP$282$1;
	label$1086:;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$240$1, 2025, 3, 4, 14, 30, 5, 0 );
	int64 vr$2 = _ZN2FB8DATETIME12TICKS__get__Ev( &TMP$240$1 );
	struct $N2FB7INSTANTE vr$3 = _ZN2FB7INSTANT9FROMTICKSEx( vr$2 );
	TMP$241$1 = vr$3;
	FBSTRING* vr$5 = _ZN2FB7INSTANT11TOISOSTRINGEv( &TMP$241$1 );
	int32 vr$6 = fb_StrCompare( (void*)vr$5, -1ll, (void*)"2025-03-04T14:30:05Z", 21ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$6 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 52, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_OTHER_TYPES_", (char*)"CU_ASSERT(Instant.FromTicks( DateTime( 2025, 3, 4, 14, 30, 5, 0 ).Ticks ).ToIsoString( ) = \x09            \x22" "2025-03-04T14:30:05Z\x22)" );
	struct $N2FB7INSTANTE vr$10 = _ZN2FB7INSTANT8MINVALUEEv(  );
	TMP$248$1 = vr$10;
	FBSTRING* vr$12 = _ZN2FB7INSTANT11TOISOSTRINGEv( &TMP$248$1 );
	int32 vr$13 = fb_StrCompare( (void*)vr$12, -1ll, (void*)"0001-01-01T00:00:00Z", 21ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$13 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 53, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_OTHER_TYPES_", (char*)"CU_ASSERT(Instant.MinValue.ToIsoString( ) = \x22" "0001-01-01T00:00:00Z\x22)" );
	_ZN2FB9LOCALDATEC1Eiii( &TMP$252$1, 2025, 3, 4 );
	FBSTRING* vr$19 = _ZN2FB9LOCALDATE11TOISOSTRINGEv( &TMP$252$1 );
	int32 vr$20 = fb_StrCompare( (void*)vr$19, -1ll, (void*)"2025-03-04", 11ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$20 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 55, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_OTHER_TYPES_", (char*)"CU_ASSERT(LocalDate( 2025, 3, 4 ).ToIsoString( ) = \x22" "2025-03-04\x22)" );
	_ZN2FB9LOCALDATEC1Eiii( &TMP$257$1, 1, 1, 1 );
	FBSTRING* vr$26 = _ZN2FB9LOCALDATE11TOISOSTRINGEv( &TMP$257$1 );
	int32 vr$27 = fb_StrCompare( (void*)vr$26, -1ll, (void*)"0001-01-01", 11ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$27 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 56, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_OTHER_TYPES_", (char*)"CU_ASSERT(LocalDate( 1, 1, 1 ).ToIsoString( ) = \x22" "0001-01-01\x22)" );
	_ZN2FB9LOCALDATEC1Eiii( &TMP$262$1, 9999, 12, 31 );
	FBSTRING* vr$33 = _ZN2FB9LOCALDATE11TOISOSTRINGEv( &TMP$262$1 );
	int32 vr$34 = fb_StrCompare( (void*)vr$33, -1ll, (void*)"9999-12-31", 11ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$34 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 57, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_OTHER_TYPES_", (char*)"CU_ASSERT(LocalDate( 9999, 12, 31 ).ToIsoString( ) = \x22" "9999-12-31\x22)" );
	_ZN2FB9LOCALTIMEC1Eiiii( &TMP$267$1, 14, 30, 5, 0 );
	FBSTRING* vr$40 = _ZN2FB9LOCALTIME11TOISOSTRINGEv( &TMP$267$1 );
	int32 vr$41 = fb_StrCompare( (void*)vr$40, -1ll, (void*)"14:30:05", 9ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$41 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 59, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_OTHER_TYPES_", (char*)"CU_ASSERT(LocalTime( 14, 30, 5, 0 ).ToIsoString( ) = \x22" "14:30:05\x22)" );
	_ZN2FB9LOCALTIMEC1Eiiii( &TMP$272$1, 0, 0, 0, 0 );
	FBSTRING* vr$47 = _ZN2FB9LOCALTIME11TOISOSTRINGEv( &TMP$272$1 );
	int32 vr$48 = fb_StrCompare( (void*)vr$47, -1ll, (void*)"00:00:00", 9ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$48 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 60, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_OTHER_TYPES_", (char*)"CU_ASSERT(LocalTime( 0, 0, 0, 0 ).ToIsoString( ) = \x22" "00:00:00\x22)" );
	_ZN2FB9LOCALTIMEC1Eiiii( &TMP$277$1, 14, 30, 5, 123 );
	FBSTRING* vr$54 = _ZN2FB9LOCALTIME11TOISOSTRINGEv( &TMP$277$1 );
	int32 vr$55 = fb_StrCompare( (void*)vr$54, -1ll, (void*)"14:30:05.1230000", 17ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$55 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 61, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_OTHER_TYPES_", (char*)"CU_ASSERT(LocalTime( 14, 30, 5, 123 ).ToIsoString( ) = \x22" "14:30:05.1230000\x22)" );
	struct $N2FB9LOCALTIMEE vr$59 = _ZN2FB9LOCALTIME8MAXVALUEEv(  );
	TMP$282$1 = vr$59;
	FBSTRING* vr$61 = _ZN2FB9LOCALTIME11TOISOSTRINGEv( &TMP$282$1 );
	int32 vr$62 = fb_StrCompare( (void*)vr$61, -1ll, (void*)"23:59:59.9999999", 17ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$62 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 62, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_OTHER_TYPES_", (char*)"CU_ASSERT(LocalTime.MaxValue.ToIsoString( ) = \x22" "23:59:59.9999999\x22)" );
	label$1087:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO14EMIT_DURATION_Ev( void )
{
	struct $N2FB8TIMESPANE TMP$289$1;
	struct $N2FB8TIMESPANE TMP$295$1;
	struct $N2FB8TIMESPANE TMP$300$1;
	struct $N2FB8TIMESPANE TMP$305$1;
	struct $N2FB8TIMESPANE TMP$310$1;
	struct $N2FB8TIMESPANE TMP$315$1;
	struct $N2FB8TIMESPANE TMP$320$1;
	struct $N2FB8TIMESPANE TMP$325$1;
	struct $N2FB8TIMESPANE TMP$330$1;
	struct $N2FB8TIMESPANE TMP$335$1;
	label$1090:;
	struct $N2FB8TIMESPANE vr$0 = _ZN2FB8TIMESPAN4ZEROEv(  );
	TMP$289$1 = vr$0;
	FBSTRING* vr$2 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$289$1 );
	int32 vr$3 = fb_StrCompare( (void*)vr$2, -1ll, (void*)"PT0S", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$3 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 68, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan.Zero.ToIsoString( ) = \x22PT0S\x22)" );
	_ZN2FB8TIMESPANC1Eiiiii( &TMP$295$1, 1, 2, 3, 4, 500 );
	FBSTRING* vr$9 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$295$1 );
	int32 vr$10 = fb_StrCompare( (void*)vr$9, -1ll, (void*)"P1DT2H3M4.5S", 13ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$10 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 69, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan( 1, 2, 3, 4, 500 ).ToIsoString( ) = \x22P1DT2H3M4.5S\x22)" );
	struct $N2FB8TIMESPANE vr$14 = _ZN2FB8TIMESPAN8FROMDAYSEd( 0x1.p+0 );
	TMP$300$1 = vr$14;
	FBSTRING* vr$16 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$300$1 );
	int32 vr$17 = fb_StrCompare( (void*)vr$16, -1ll, (void*)"P1D", 4ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$17 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 70, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan.FromDays( 1 ).ToIsoString( ) = \x22P1D\x22)" );
	struct $N2FB8TIMESPANE vr$21 = _ZN2FB8TIMESPAN9FROMHOURSEd( 0x1.p+1 );
	TMP$305$1 = vr$21;
	FBSTRING* vr$23 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$305$1 );
	int32 vr$24 = fb_StrCompare( (void*)vr$23, -1ll, (void*)"PT2H", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$24 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 71, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan.FromHours( 2 ).ToIsoString( ) = \x22PT2H\x22)" );
	struct $N2FB8TIMESPANE vr$28 = _ZN2FB8TIMESPAN11FROMMINUTESEd( 0x1.8p+1 );
	TMP$310$1 = vr$28;
	FBSTRING* vr$30 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$310$1 );
	int32 vr$31 = fb_StrCompare( (void*)vr$30, -1ll, (void*)"PT3M", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$31 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 72, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan.FromMinutes( 3 ).ToIsoString( ) = \x22PT3M\x22)" );
	struct $N2FB8TIMESPANE vr$35 = _ZN2FB8TIMESPAN11FROMSECONDSEd( 0x1.p+2 );
	TMP$315$1 = vr$35;
	FBSTRING* vr$37 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$315$1 );
	int32 vr$38 = fb_StrCompare( (void*)vr$37, -1ll, (void*)"PT4S", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$38 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 73, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan.FromSeconds( 4 ).ToIsoString( ) = \x22PT4S\x22)" );
	struct $N2FB8TIMESPANE vr$42 = _ZN2FB8TIMESPAN9FROMHOURSEd( -0x1.8p+0 );
	TMP$320$1 = vr$42;
	FBSTRING* vr$44 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$320$1 );
	int32 vr$45 = fb_StrCompare( (void*)vr$44, -1ll, (void*)"-PT1H30M", 9ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$45 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 74, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan.FromHours( -1.5 ).ToIsoString( ) = \x22-PT1H30M\x22)" );
	struct $N2FB8TIMESPANE vr$49 = _ZN2FB8TIMESPAN9FROMTICKSEx( 1ll );
	TMP$325$1 = vr$49;
	FBSTRING* vr$51 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$325$1 );
	int32 vr$52 = fb_StrCompare( (void*)vr$51, -1ll, (void*)"PT0.0000001S", 13ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$52 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 75, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan.FromTicks( 1 ).ToIsoString( ) = \x22PT0.0000001S\x22)" );
	struct $N2FB8TIMESPANE vr$56 = _ZN2FB8TIMESPAN16FROMMILLISECONDSEd( 0x1.77p+10 );
	TMP$330$1 = vr$56;
	FBSTRING* vr$58 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$330$1 );
	int32 vr$59 = fb_StrCompare( (void*)vr$58, -1ll, (void*)"PT1.5S", 7ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$59 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 76, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan.FromMilliseconds( 1500 ).ToIsoString( ) = \x22PT1.5S\x22)" );
	struct $N2FB8TIMESPANE vr$63 = _ZN2FB8TIMESPAN7INVALIDEv(  );
	TMP$335$1 = vr$63;
	FBSTRING* vr$65 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$335$1 );
	int32 vr$66 = fb_StrCompare( (void*)vr$65, -1ll, (void*)"", 1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$66 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 77, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.EMIT_DURATION_", (char*)"CU_ASSERT(TimeSpan.Invalid.ToIsoString( ) = \x22\x22)" );
	label$1091:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO21PARSE_ACCEPTED_FORMS_Ev( void )
{
	struct $N2FB8DATETIMEE TMP$341$1;
	FBSTRING TMP$342$1;
	int64 TMP$347$1;
	FBSTRING TMP$352$1;
	FBSTRING TMP$360$1;
	FBSTRING TMP$365$1;
	FBSTRING TMP$370$1;
	int64 TMP$374$1;
	int64 TMP$375$1;
	FBSTRING TMP$380$1;
	int64 TMP$384$1;
	FBSTRING TMP$389$1;
	FBSTRING TMP$397$1;
	FBSTRING TMP$402$1;
	FBSTRING TMP$407$1;
	FBSTRING TMP$415$1;
	FBSTRING TMP$423$1;
	FBSTRING TMP$430$1;
	FBSTRING TMP$440$1;
	FBSTRING TMP$448$1;
	int64 TMP$452$1;
	int64 TMP$453$1;
	FBSTRING TMP$458$1;
	FBSTRING TMP$463$1;
	label$1094:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Ev( &D$1 );
	int64 WANT$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$341$1, 2025, 3, 4, 14, 30, 5, 0 );
	int64 vr$3 = _ZN2FB8DATETIME12TICKS__get__Ev( &TMP$341$1 );
	WANT$1 = vr$3;
	__builtin_memset( &TMP$342$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$342$1, -1ll, (void*)"2025-03-04T14:30:05Z", 21ll, 0 );
	boolean vr$8 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$342$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$8, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 85, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$342$1 );
	int64 vr$11 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	if( vr$11 != WANT$1) goto label$1096;
	int16 vr$13 = _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( &D$1 );
	TMP$347$1 = (int64)-((int64)vr$13 == 0ll);
	goto label$1102;
	label$1096:;
	TMP$347$1 = 0ll;
	label$1102:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$347$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 86, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Ticks = want andalso d.OffsetMinutes = 0)" );
	__builtin_memset( &TMP$352$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$352$1, -1ll, (void*)"20250304T143005Z", 17ll, 0 );
	boolean vr$21 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$352$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$21, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 89, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "20250304T143005Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$352$1 );
	int64 vr$24 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$24 == WANT$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 90, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Ticks = want)" );
	__builtin_memset( &TMP$360$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$360$1, -1ll, (void*)"2025-063T14:30:05Z", 19ll, 0 );
	boolean vr$31 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$360$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$31, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 93, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-063T14:30:05Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$360$1 );
	int64 vr$34 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$34 == WANT$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 94, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Ticks = want)" );
	__builtin_memset( &TMP$365$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$365$1, -1ll, (void*)"2025063T143005Z", 16ll, 0 );
	boolean vr$41 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$365$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$41, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 95, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025063T143005Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$365$1 );
	int64 vr$44 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$44 == WANT$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 96, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Ticks = want)" );
	__builtin_memset( &TMP$370$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$370$1, -1ll, (void*)"2025-W10-2", 11ll, 0 );
	boolean vr$51 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$370$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$51, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 99, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-W10-2\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$370$1 );
	int32 vr$54 = _ZN2FB8DATETIME11YEAR__get__Ev( &D$1 );
	if( (int64)vr$54 != 2025ll) goto label$1097;
	int32 vr$57 = _ZN2FB8DATETIME12MONTH__get__Ev( &D$1 );
	TMP$374$1 = (int64)-((int64)vr$57 == 3ll);
	goto label$1103;
	label$1097:;
	TMP$374$1 = 0ll;
	label$1103:;
	if( TMP$374$1 == 0ll) goto label$1098;
	int32 vr$61 = _ZN2FB8DATETIME10DAY__get__Ev( &D$1 );
	TMP$375$1 = (int64)-((int64)vr$61 == 4ll);
	goto label$1104;
	label$1098:;
	TMP$375$1 = 0ll;
	label$1104:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$375$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 100, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Year = 2025 andalso d.Month = 3 andalso d.Day = 4)" );
	__builtin_memset( &TMP$380$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$380$1, -1ll, (void*)"2025W102", 9ll, 0 );
	boolean vr$69 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$380$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$69, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 101, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025W102\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$380$1 );
	int32 vr$72 = _ZN2FB8DATETIME12MONTH__get__Ev( &D$1 );
	if( (int64)vr$72 != 3ll) goto label$1099;
	int32 vr$75 = _ZN2FB8DATETIME10DAY__get__Ev( &D$1 );
	TMP$384$1 = (int64)-((int64)vr$75 == 4ll);
	goto label$1105;
	label$1099:;
	TMP$384$1 = 0ll;
	label$1105:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$384$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 102, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Month = 3 andalso d.Day = 4)" );
	__builtin_memset( &TMP$389$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$389$1, -1ll, (void*)"2025-03-04T14:30:05,5Z", 23ll, 0 );
	boolean vr$83 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$389$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$83, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 105, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05,5Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$389$1 );
	int64 vr$86 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$86 == (WANT$1 + 5000000ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 106, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Ticks = want + 5000000)" );
	__builtin_memset( &TMP$397$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$397$1, -1ll, (void*)"2025-03-04 14:30:05Z", 21ll, 0 );
	boolean vr$94 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$397$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$94, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 109, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04 14:30:05Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$397$1 );
	int64 vr$97 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$97 == WANT$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 110, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Ticks = want)" );
	__builtin_memset( &TMP$402$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$402$1, -1ll, (void*)"2025-03-04t14:30:05z", 21ll, 0 );
	boolean vr$104 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$402$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$104, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 113, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04t14:30:05z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$402$1 );
	int64 vr$107 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$107 == WANT$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 114, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Ticks = want)" );
	__builtin_memset( &TMP$407$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$407$1, -1ll, (void*)"2025-03-04T14:30:05+05", 23ll, 0 );
	boolean vr$114 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$407$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$114, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 117, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05+05\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$407$1 );
	int16 vr$117 = _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$117 == 300ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 118, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.OffsetMinutes = 300)" );
	__builtin_memset( &TMP$415$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$415$1, -1ll, (void*)"2025-03-04T14:30:05+0530", 25ll, 0 );
	boolean vr$125 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$415$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$125, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 119, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05+0530\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$415$1 );
	int16 vr$128 = _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$128 == 330ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 120, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.OffsetMinutes = 330)" );
	__builtin_memset( &TMP$423$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$423$1, -1ll, (void*)"2025-03-04T14:30:05-05:30", 26ll, 0 );
	boolean vr$136 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$423$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$136, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 121, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05-05:30\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$423$1 );
	int16 vr$139 = _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$139 == -330ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 122, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.OffsetMinutes = -330)" );
	__builtin_memset( &TMP$430$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$430$1, -1ll, (void*)"2025-03-04T14:30:05", 20ll, 0 );
	boolean vr$147 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$430$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$147, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 125, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$430$1 );
	int16 vr$150 = _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$150 == 32767ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 126, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.OffsetMinutes = DT_OFFSET_UNSPECIFIED)" );
	boolean vr$155 = _ZN2FB8DATETIME16HASOFFSET__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$155 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 127, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.HasOffset = false)" );
	__builtin_memset( &TMP$440$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$440$1, -1ll, (void*)"2025-03-04", 11ll, 0 );
	boolean vr$161 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$440$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$161, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 130, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$440$1 );
	int64 vr$164 = _ZN2FB8DATETIME16TICKOFDAY__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$164 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 131, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.TickOfDay = 0)" );
	__builtin_memset( &TMP$448$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$448$1, -1ll, (void*)"2025-03-04T14:30Z", 18ll, 0 );
	boolean vr$171 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$448$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$171, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 134, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$448$1 );
	int32 vr$174 = _ZN2FB8DATETIME11HOUR__get__Ev( &D$1 );
	if( (int64)vr$174 != 14ll) goto label$1100;
	int32 vr$177 = _ZN2FB8DATETIME13MINUTE__get__Ev( &D$1 );
	TMP$452$1 = (int64)-((int64)vr$177 == 30ll);
	goto label$1106;
	label$1100:;
	TMP$452$1 = 0ll;
	label$1106:;
	if( TMP$452$1 == 0ll) goto label$1101;
	int32 vr$181 = _ZN2FB8DATETIME13SECOND__get__Ev( &D$1 );
	TMP$453$1 = (int64)-((int64)vr$181 == 0ll);
	goto label$1107;
	label$1101:;
	TMP$453$1 = 0ll;
	label$1107:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$453$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 135, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Hour = 14 andalso d.Minute = 30 andalso d.Second = 0)" );
	__builtin_memset( &TMP$458$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$458$1, -1ll, (void*)"  2025-03-04T14:30:05Z  ", 25ll, 0 );
	boolean vr$189 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$458$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$189, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 138, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22  2025-03-04T14:30:05Z  \x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$458$1 );
	int64 vr$192 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$192 == WANT$1) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 139, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Ticks = want)" );
	__builtin_memset( &TMP$463$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$463$1, -1ll, (void*)"2024-02-29", 11ll, 0 );
	boolean vr$199 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$463$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$199, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 142, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2024-02-29\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$463$1 );
	int32 vr$202 = _ZN2FB8DATETIME10DAY__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$202 == 29ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 143, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_ACCEPTED_FORMS_", (char*)"CU_ASSERT(d.Day = 29)" );
	label$1095:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO16PARSE_FRACTIONS_Ev( void )
{
	struct $N2FB8DATETIMEE TMP$472$1;
	FBSTRING TMP$474$1;
	FBSTRING TMP$483$1;
	FBSTRING TMP$491$1;
	FBSTRING TMP$496$1;
	FBSTRING TMP$501$1;
	label$1110:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Ev( &D$1 );
	int64 BAS$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$472$1, 2025, 3, 4, 14, 30, 5, 0 );
	int64 vr$3 = _ZN2FB8DATETIME12TICKS__get__Ev( &TMP$472$1 );
	BAS$1 = vr$3;
	__builtin_memset( &TMP$474$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$474$1, -1ll, (void*)"2025-03-04T14:30:05.1Z", 23ll, 0 );
	boolean vr$8 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$474$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$8, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 152, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05.1Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$474$1 );
	int64 vr$11 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$11 == (BAS$1 + 1000000ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 153, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(d.Ticks = bas + 1000000)" );
	__builtin_memset( &TMP$483$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$483$1, -1ll, (void*)"2025-03-04T14:30:05.1234567Z", 29ll, 0 );
	boolean vr$19 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$483$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$19, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 154, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05.1234567Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$483$1 );
	int64 vr$22 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$22 == (BAS$1 + 1234567ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 155, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(d.Ticks = bas + 1234567)" );
	__builtin_memset( &TMP$491$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$491$1, -1ll, (void*)"2025-03-04T14:30:05.12345678Z", 30ll, 0 );
	boolean vr$30 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$491$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$30, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 157, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05.12345678Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$491$1 );
	int64 vr$33 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$33 == (BAS$1 + 1234567ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 158, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(d.Ticks = bas + 1234567)" );
	__builtin_memset( &TMP$496$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$496$1, -1ll, (void*)"2025-03-04T14:30:05.123456789Z", 31ll, 0 );
	boolean vr$41 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$496$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$41, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 159, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05.123456789Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$496$1 );
	int64 vr$44 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$44 == (BAS$1 + 1234567ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 160, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(d.Ticks = bas + 1234567)" );
	__builtin_memset( &TMP$501$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$501$1, -1ll, (void*)"2025-03-04T14:30:05.99999999Z", 30ll, 0 );
	boolean vr$52 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$501$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$52, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 161, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05.99999999Z\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$501$1 );
	int64 vr$55 = _ZN2FB8DATETIME12TICKS__get__Ev( &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$55 == (BAS$1 + 9999999ll)) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 162, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_FRACTIONS_", (char*)"CU_ASSERT(d.Ticks = bas + 9999999)" );
	label$1111:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO23PARSE_REJECTION_CORPUS_Ev( void )
{
	FBSTRING TMP$555$1;
	FBSTRING TMP$557$1;
	FBSTRING TMP$562$1;
	FBSTRING TMP$567$1;
	FBSTRING TMP$572$1;
	FBSTRING TMP$576$1;
	label$1114:;
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Ev( &D$1 );
	FBSTRING BAD$1[34];
	struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$1I8FBSTRINGEE {
		FBSTRING* DATA;
		FBSTRING* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$1I8FBSTRINGEE ) == 72 );
	struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$1I8FBSTRINGEE tmp$510$1;
	*(FBSTRING**)&tmp$510$1 = (FBSTRING*)BAD$1;
	*(FBSTRING**)((uint8*)&tmp$510$1 + 8ll) = (FBSTRING*)BAD$1;
	*(int64*)((uint8*)&tmp$510$1 + 16ll) = 816ll;
	*(int64*)((uint8*)&tmp$510$1 + 24ll) = 24ll;
	*(int64*)((uint8*)&tmp$510$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$510$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$510$1 + 48ll) = 34ll;
	*(int64*)((uint8*)&tmp$510$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$510$1 + 64ll) = 33ll;
	fb_StrInit( (void*)BAD$1, -1ll, (void*)"", 1ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 24ll), -1ll, (void*)" ", 2ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 48ll), -1ll, (void*)"   ", 4ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 72ll), -1ll, (void*)"2025-13-01", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 96ll), -1ll, (void*)"2025-00-01", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 120ll), -1ll, (void*)"2025-01-00", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 144ll), -1ll, (void*)"2025-01-32", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 168ll), -1ll, (void*)"2025-02-30", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 192ll), -1ll, (void*)"2025-02-29", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 216ll), -1ll, (void*)"1900-02-29", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 240ll), -1ll, (void*)"2100-02-29", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 264ll), -1ll, (void*)"2025-04-31", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 288ll), -1ll, (void*)"25-03-04", 9ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 312ll), -1ll, (void*)"225-03-04", 10ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 336ll), -1ll, (void*)"20250-03-04", 12ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 360ll), -1ll, (void*)"2025-03-04T24:00:00", 20ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 384ll), -1ll, (void*)"2025-03-04T23:59:60", 20ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 408ll), -1ll, (void*)"2025-03-04T25:00:00", 20ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 432ll), -1ll, (void*)"2025-03-04T14:60:00", 20ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 456ll), -1ll, (void*)"2025-03-04T14:30:05+19:00", 26ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 480ll), -1ll, (void*)"2025-03-04T14:30:05-19:00", 26ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 504ll), -1ll, (void*)"2025-03-04T14:30:05+05:70", 26ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 528ll), -1ll, (void*)"2025-03-04T14:30:05Zx", 22ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 552ll), -1ll, (void*)"2025-03-04xx", 13ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 576ll), -1ll, (void*)"x2025-03-04", 12ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 600ll), -1ll, (void*)"2025-03-04T", 12ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 624ll), -1ll, (void*)"T14:30:05", 10ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 648ll), -1ll, (void*)"2025-03-04T14:30:05.", 21ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 672ll), -1ll, (void*)"+002025-03-04", 14ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 696ll), -1ll, (void*)"-2025-03-04", 12ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 720ll), -1ll, (void*)"2025-W54-1", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 744ll), -1ll, (void*)"2025-W00-1", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 768ll), -1ll, (void*)"2025-367", 9ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)BAD$1 + 792ll), -1ll, (void*)"2025-000", 9ll, 0 );
	{
		int64 I$2;
		I$2 = 0ll;
		label$1119:;
		{
			struct $N2FB8DATETIMEE TMP$551$3;
			struct $N2FB8DATETIMEE R$3;
			_ZN2FB8DATETIMEC1Eiii( &R$3, 2025, 1, 1 );
			boolean vr$41 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( (FBSTRING*)((int64)(FBSTRING*)BAD$1 + (I$2 * 24ll)), &R$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$41 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 186, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_REJECTION_CORPUS_", (char*)"CU_ASSERT(DateTime.TryParseIso( bad( i ), r ) = false)" );
			boolean vr$44 = _ZN2FB8DATETIME14ISVALID__get__Ev( &R$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$44 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 188, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_REJECTION_CORPUS_", (char*)"CU_ASSERT(r.IsValid = false)" );
			struct $N2FB8DATETIMEE vr$48 = _ZN2FB8DATETIME8PARSEISOER8FBSTRING( (FBSTRING*)((int64)(FBSTRING*)BAD$1 + (I$2 * 24ll)) );
			TMP$551$3 = vr$48;
			boolean vr$50 = _ZN2FB8DATETIME14ISVALID__get__Ev( &TMP$551$3 );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$50 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 189, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_REJECTION_CORPUS_", (char*)"CU_ASSERT(DateTime.ParseIso( bad( i ) ).IsValid = false)" );
		}
		label$1117:;
		I$2 = I$2 + 1ll;
		label$1116:;
		if( I$2 <= 33ll) goto label$1119;
		label$1118:;
	}
	__builtin_memset( &TMP$555$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$555$1, -1ll, (void*)"2024-02-29", 11ll, 0 );
	boolean vr$57 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$555$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$57, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 193, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_REJECTION_CORPUS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2024-02-29\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$555$1 );
	__builtin_memset( &TMP$557$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$557$1, -1ll, (void*)"2000-02-29", 11ll, 0 );
	boolean vr$63 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$557$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$63, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 194, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_REJECTION_CORPUS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2000-02-29\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$557$1 );
	__builtin_memset( &TMP$562$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$562$1, -1ll, (void*)"2025-W01-1", 11ll, 0 );
	boolean vr$69 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$562$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$69, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 195, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_REJECTION_CORPUS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-W01-1\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$562$1 );
	__builtin_memset( &TMP$567$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$567$1, -1ll, (void*)"2025-365", 9ll, 0 );
	boolean vr$75 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$567$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$75, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 196, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_REJECTION_CORPUS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-365\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$567$1 );
	__builtin_memset( &TMP$572$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$572$1, -1ll, (void*)"2024-366", 9ll, 0 );
	boolean vr$81 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$572$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$81, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 197, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_REJECTION_CORPUS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2024-366\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$572$1 );
	__builtin_memset( &TMP$576$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$576$1, -1ll, (void*)"2025-03-04T14:30:05+18:00", 26ll, 0 );
	boolean vr$87 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$576$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$87, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 198, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_REJECTION_CORPUS_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05+18:00\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$576$1 );
	fb_ArrayDestructStr( (struct $7FBARRAYIvE*)&tmp$510$1 );
	label$1115:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO24INSTANT_REQUIRES_OFFSET_Ev( void )
{
	FBSTRING TMP$582$1;
	FBSTRING TMP$590$1;
	FBSTRING TMP$591$1;
	struct $N2FB8DATETIMEE TMP$595$1;
	FBSTRING TMP$600$1;
	struct $N2FB8DATETIMEE TMP$604$1;
	label$1122:;
	struct $N2FB7INSTANTE I$1;
	_ZN2FB7INSTANTC1Ev( &I$1 );
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Ev( &D$1 );
	__builtin_memset( &TMP$582$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$582$1, -1ll, (void*)"2025-03-04T14:30:05", 20ll, 0 );
	boolean vr$6 = _ZN2FB7INSTANT11TRYPARSEISOER8FBSTRINGRS0_( &TMP$582$1, &I$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$6 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 207, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.INSTANT_REQUIRES_OFFSET_", (char*)"CU_ASSERT(Instant.TryParseIso( \x22" "2025-03-04T14:30:05\x22, i ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$582$1 );
	boolean vr$10 = _ZN2FB7INSTANT14ISVALID__get__Ev( &I$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$10 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 208, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.INSTANT_REQUIRES_OFFSET_", (char*)"CU_ASSERT(i.IsValid = false)" );
	__builtin_memset( &TMP$590$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$590$1, -1ll, (void*)"2025-03-04T14:30:05", 20ll, 0 );
	boolean vr$16 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$590$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$16, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 209, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.INSTANT_REQUIRES_OFFSET_", (char*)"CU_ASSERT(DateTime.TryParseIso( \x22" "2025-03-04T14:30:05\x22, d ))" );
	fb_StrDelete( (FBSTRING*)&TMP$590$1 );
	__builtin_memset( &TMP$591$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$591$1, -1ll, (void*)"2025-03-04T14:30:05Z", 21ll, 0 );
	boolean vr$22 = _ZN2FB7INSTANT11TRYPARSEISOER8FBSTRINGRS0_( &TMP$591$1, &I$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$22, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 211, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.INSTANT_REQUIRES_OFFSET_", (char*)"CU_ASSERT(Instant.TryParseIso( \x22" "2025-03-04T14:30:05Z\x22, i ))" );
	fb_StrDelete( (FBSTRING*)&TMP$591$1 );
	int64 vr$25 = _ZN2FB7INSTANT12TICKS__get__Ev( &I$1 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$595$1, 2025, 3, 4, 14, 30, 5, 0 );
	int64 vr$28 = _ZN2FB8DATETIME12TICKS__get__Ev( &TMP$595$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$25 == vr$28) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 212, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.INSTANT_REQUIRES_OFFSET_", (char*)"CU_ASSERT(i.Ticks = DateTime( 2025, 3, 4, 14, 30, 5, 0 ).Ticks)" );
	__builtin_memset( &TMP$600$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$600$1, -1ll, (void*)"2025-03-04T14:30:05+01:00", 26ll, 0 );
	boolean vr$35 = _ZN2FB7INSTANT11TRYPARSEISOER8FBSTRINGRS0_( &TMP$600$1, &I$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$35, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 215, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.INSTANT_REQUIRES_OFFSET_", (char*)"CU_ASSERT(Instant.TryParseIso( \x22" "2025-03-04T14:30:05+01:00\x22, i ))" );
	fb_StrDelete( (FBSTRING*)&TMP$600$1 );
	int64 vr$38 = _ZN2FB7INSTANT12TICKS__get__Ev( &I$1 );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$604$1, 2025, 3, 4, 13, 30, 5, 0 );
	int64 vr$41 = _ZN2FB8DATETIME12TICKS__get__Ev( &TMP$604$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$38 == vr$41) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 216, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.INSTANT_REQUIRES_OFFSET_", (char*)"CU_ASSERT(i.Ticks = DateTime( 2025, 3, 4, 13, 30, 5, 0 ).Ticks)" );
	label$1123:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO18PARSE_OTHER_TYPES_Ev( void )
{
	FBSTRING TMP$610$1;
	int64 TMP$615$1;
	int64 TMP$616$1;
	FBSTRING TMP$621$1;
	FBSTRING TMP$629$1;
	FBSTRING TMP$633$1;
	FBSTRING TMP$637$1;
	int64 TMP$641$1;
	int64 TMP$642$1;
	FBSTRING TMP$647$1;
	FBSTRING TMP$655$1;
	FBSTRING TMP$663$1;
	FBSTRING TMP$668$1;
	label$1126:;
	struct $N2FB9LOCALDATEE LD$1;
	_ZN2FB9LOCALDATEC1Ev( &LD$1 );
	struct $N2FB9LOCALTIMEE LT$1;
	_ZN2FB9LOCALTIMEC1Ev( &LT$1 );
	__builtin_memset( &TMP$610$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$610$1, -1ll, (void*)"2025-03-04", 11ll, 0 );
	boolean vr$6 = _ZN2FB9LOCALDATE11TRYPARSEISOER8FBSTRINGRS0_( &TMP$610$1, &LD$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$6, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 223, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(LocalDate.TryParseIso( \x22" "2025-03-04\x22, ld ))" );
	fb_StrDelete( (FBSTRING*)&TMP$610$1 );
	int32 vr$9 = _ZN2FB9LOCALDATE11YEAR__get__Ev( &LD$1 );
	if( (int64)vr$9 != 2025ll) goto label$1128;
	int32 vr$12 = _ZN2FB9LOCALDATE12MONTH__get__Ev( &LD$1 );
	TMP$615$1 = (int64)-((int64)vr$12 == 3ll);
	goto label$1132;
	label$1128:;
	TMP$615$1 = 0ll;
	label$1132:;
	if( TMP$615$1 == 0ll) goto label$1129;
	int32 vr$16 = _ZN2FB9LOCALDATE10DAY__get__Ev( &LD$1 );
	TMP$616$1 = (int64)-((int64)vr$16 == 4ll);
	goto label$1133;
	label$1129:;
	TMP$616$1 = 0ll;
	label$1133:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$616$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 224, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(ld.Year = 2025 andalso ld.Month = 3 andalso ld.Day = 4)" );
	__builtin_memset( &TMP$621$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$621$1, -1ll, (void*)"20250304", 9ll, 0 );
	boolean vr$24 = _ZN2FB9LOCALDATE11TRYPARSEISOER8FBSTRINGRS0_( &TMP$621$1, &LD$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$24, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 225, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(LocalDate.TryParseIso( \x22" "20250304\x22, ld ))" );
	fb_StrDelete( (FBSTRING*)&TMP$621$1 );
	int32 vr$27 = _ZN2FB9LOCALDATE10DAY__get__Ev( &LD$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$27 == 4ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 226, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(ld.Day = 4)" );
	__builtin_memset( &TMP$629$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$629$1, -1ll, (void*)"2025-03-04T00:00:00", 20ll, 0 );
	boolean vr$35 = _ZN2FB9LOCALDATE11TRYPARSEISOER8FBSTRINGRS0_( &TMP$629$1, &LD$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$35 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 227, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(LocalDate.TryParseIso( \x22" "2025-03-04T00:00:00\x22, ld ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$629$1 );
	__builtin_memset( &TMP$633$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$633$1, -1ll, (void*)"2025-02-30", 11ll, 0 );
	boolean vr$42 = _ZN2FB9LOCALDATE11TRYPARSEISOER8FBSTRINGRS0_( &TMP$633$1, &LD$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$42 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 228, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(LocalDate.TryParseIso( \x22" "2025-02-30\x22, ld ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$633$1 );
	__builtin_memset( &TMP$637$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$637$1, -1ll, (void*)"14:30:05", 9ll, 0 );
	boolean vr$49 = _ZN2FB9LOCALTIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$637$1, &LT$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$49, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 230, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(LocalTime.TryParseIso( \x22" "14:30:05\x22, lt ))" );
	fb_StrDelete( (FBSTRING*)&TMP$637$1 );
	int32 vr$52 = _ZN2FB9LOCALTIME11HOUR__get__Ev( &LT$1 );
	if( (int64)vr$52 != 14ll) goto label$1130;
	int32 vr$55 = _ZN2FB9LOCALTIME13MINUTE__get__Ev( &LT$1 );
	TMP$641$1 = (int64)-((int64)vr$55 == 30ll);
	goto label$1134;
	label$1130:;
	TMP$641$1 = 0ll;
	label$1134:;
	if( TMP$641$1 == 0ll) goto label$1131;
	int32 vr$59 = _ZN2FB9LOCALTIME13SECOND__get__Ev( &LT$1 );
	TMP$642$1 = (int64)-((int64)vr$59 == 5ll);
	goto label$1135;
	label$1131:;
	TMP$642$1 = 0ll;
	label$1135:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$642$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 231, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(lt.Hour = 14 andalso lt.Minute = 30 andalso lt.Second = 5)" );
	__builtin_memset( &TMP$647$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$647$1, -1ll, (void*)"143005", 7ll, 0 );
	boolean vr$67 = _ZN2FB9LOCALTIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$647$1, &LT$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$67, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 232, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(LocalTime.TryParseIso( \x22" "143005\x22, lt ))" );
	fb_StrDelete( (FBSTRING*)&TMP$647$1 );
	int32 vr$70 = _ZN2FB9LOCALTIME13SECOND__get__Ev( &LT$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$70 == 5ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 233, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(lt.Second = 5)" );
	__builtin_memset( &TMP$655$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$655$1, -1ll, (void*)"14:30", 6ll, 0 );
	boolean vr$78 = _ZN2FB9LOCALTIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$655$1, &LT$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$78, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 234, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(LocalTime.TryParseIso( \x22" "14:30\x22, lt ))" );
	fb_StrDelete( (FBSTRING*)&TMP$655$1 );
	int32 vr$81 = _ZN2FB9LOCALTIME13MINUTE__get__Ev( &LT$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$81 == 30ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 235, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(lt.Minute = 30)" );
	__builtin_memset( &TMP$663$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$663$1, -1ll, (void*)"24:00:00", 9ll, 0 );
	boolean vr$89 = _ZN2FB9LOCALTIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$663$1, &LT$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$89 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 236, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(LocalTime.TryParseIso( \x22" "24:00:00\x22, lt ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$663$1 );
	__builtin_memset( &TMP$668$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$668$1, -1ll, (void*)"14:30:05Z", 10ll, 0 );
	boolean vr$96 = _ZN2FB9LOCALTIME11TRYPARSEISOER8FBSTRINGRS0_( &TMP$668$1, &LT$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$96 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 237, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.PARSE_OTHER_TYPES_", (char*)"CU_ASSERT(LocalTime.TryParseIso( \x22" "14:30:05Z\x22, lt ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$668$1 );
	label$1127:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO17DURATION_GRAMMAR_Ev( void )
{
	FBSTRING TMP$674$1;
	int64 TMP$675$1;
	FBSTRING TMP$680$1;
	struct $N2FB8TIMESPANE TMP$684$1;
	FBSTRING TMP$688$1;
	int64 TMP$689$1;
	FBSTRING TMP$693$1;
	int64 TMP$694$1;
	FBSTRING TMP$699$1;
	int64 TMP$700$1;
	FBSTRING TMP$704$1;
	int64 TMP$705$1;
	FBSTRING TMP$710$1;
	int64 TMP$711$1;
	FBSTRING TMP$716$1;
	int64 TMP$717$1;
	FBSTRING TMP$726$1;
	FBSTRING TMP$731$1;
	FBSTRING TMP$736$1;
	FBSTRING TMP$740$1;
	FBSTRING TMP$745$1;
	FBSTRING TMP$749$1;
	FBSTRING TMP$754$1;
	FBSTRING TMP$759$1;
	FBSTRING TMP$764$1;
	FBSTRING TMP$769$1;
	FBSTRING TMP$774$1;
	FBSTRING TMP$779$1;
	FBSTRING TMP$784$1;
	label$1138:;
	struct $N2FB8TIMESPANE T$1;
	_ZN2FB8TIMESPANC1Ev( &T$1 );
	__builtin_memset( &TMP$674$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$674$1, -1ll, (void*)"PT0S", 5ll, 0 );
	boolean vr$5 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$674$1, &T$1 );
	if( (int64)-vr$5 == 0ll) goto label$1140;
	int64 vr$8 = _ZN2FB8TIMESPAN12TICKS__get__Ev( &T$1 );
	TMP$675$1 = (int64)-(vr$8 == 0ll);
	goto label$1147;
	label$1140:;
	TMP$675$1 = 0ll;
	label$1147:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$675$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 243, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22PT0S\x22, t ) andalso t.Ticks = 0)" );
	fb_StrDelete( (FBSTRING*)&TMP$674$1 );
	__builtin_memset( &TMP$680$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$680$1, -1ll, (void*)"P1DT2H3M4.5S", 13ll, 0 );
	boolean vr$16 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$680$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$16, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 244, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P1DT2H3M4.5S\x22, t ))" );
	fb_StrDelete( (FBSTRING*)&TMP$680$1 );
	int64 vr$19 = _ZN2FB8TIMESPAN12TICKS__get__Ev( &T$1 );
	_ZN2FB8TIMESPANC1Eiiiii( &TMP$684$1, 1, 2, 3, 4, 500 );
	int64 vr$22 = _ZN2FB8TIMESPAN12TICKS__get__Ev( &TMP$684$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$19 == vr$22) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 245, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(t.Ticks = TimeSpan( 1, 2, 3, 4, 500 ).Ticks)" );
	__builtin_memset( &TMP$688$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$688$1, -1ll, (void*)"P1D", 4ll, 0 );
	boolean vr$29 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$688$1, &T$1 );
	if( (int64)-vr$29 == 0ll) goto label$1141;
	double vr$32 = _ZN2FB8TIMESPAN16TOTALDAYS__get__Ev( &T$1 );
	TMP$689$1 = (int64)-(vr$32 == 0x1.p+0);
	goto label$1148;
	label$1141:;
	TMP$689$1 = 0ll;
	label$1148:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$689$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 246, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P1D\x22, t ) andalso t.TotalDays = 1)" );
	fb_StrDelete( (FBSTRING*)&TMP$688$1 );
	__builtin_memset( &TMP$693$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$693$1, -1ll, (void*)"PT2H", 5ll, 0 );
	boolean vr$40 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$693$1, &T$1 );
	if( (int64)-vr$40 == 0ll) goto label$1142;
	double vr$43 = _ZN2FB8TIMESPAN17TOTALHOURS__get__Ev( &T$1 );
	TMP$694$1 = (int64)-(vr$43 == 0x1.p+1);
	goto label$1149;
	label$1142:;
	TMP$694$1 = 0ll;
	label$1149:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$694$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 247, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22PT2H\x22, t ) andalso t.TotalHours = 2)" );
	fb_StrDelete( (FBSTRING*)&TMP$693$1 );
	__builtin_memset( &TMP$699$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$699$1, -1ll, (void*)"PT1M", 5ll, 0 );
	boolean vr$51 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$699$1, &T$1 );
	if( (int64)-vr$51 == 0ll) goto label$1143;
	double vr$54 = _ZN2FB8TIMESPAN19TOTALMINUTES__get__Ev( &T$1 );
	TMP$700$1 = (int64)-(vr$54 == 0x1.p+0);
	goto label$1150;
	label$1143:;
	TMP$700$1 = 0ll;
	label$1150:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$700$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 248, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22PT1M\x22, t ) andalso t.TotalMinutes = 1)" );
	fb_StrDelete( (FBSTRING*)&TMP$699$1 );
	__builtin_memset( &TMP$704$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$704$1, -1ll, (void*)"-PT1H30M", 9ll, 0 );
	boolean vr$62 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$704$1, &T$1 );
	if( (int64)-vr$62 == 0ll) goto label$1144;
	double vr$65 = _ZN2FB8TIMESPAN17TOTALHOURS__get__Ev( &T$1 );
	TMP$705$1 = (int64)-(vr$65 == -0x1.8p+0);
	goto label$1151;
	label$1144:;
	TMP$705$1 = 0ll;
	label$1151:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$705$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 249, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22-PT1H30M\x22, t ) andalso t.TotalHours = -1.5)" );
	fb_StrDelete( (FBSTRING*)&TMP$704$1 );
	__builtin_memset( &TMP$710$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$710$1, -1ll, (void*)"PT4,5S", 7ll, 0 );
	boolean vr$73 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$710$1, &T$1 );
	if( (int64)-vr$73 == 0ll) goto label$1145;
	int64 vr$76 = _ZN2FB8TIMESPAN12TICKS__get__Ev( &T$1 );
	TMP$711$1 = (int64)-(vr$76 == 45000000ll);
	goto label$1152;
	label$1145:;
	TMP$711$1 = 0ll;
	label$1152:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$711$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 250, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22PT4,5S\x22, t ) andalso t.Ticks = 45000000)" );
	fb_StrDelete( (FBSTRING*)&TMP$710$1 );
	__builtin_memset( &TMP$716$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$716$1, -1ll, (void*)"P2W", 4ll, 0 );
	boolean vr$84 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$716$1, &T$1 );
	if( (int64)-vr$84 == 0ll) goto label$1146;
	double vr$87 = _ZN2FB8TIMESPAN16TOTALDAYS__get__Ev( &T$1 );
	TMP$717$1 = (int64)-(vr$87 == 0x1.Cp+3);
	goto label$1153;
	label$1146:;
	TMP$717$1 = 0ll;
	label$1153:;
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(TMP$717$1 != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 253, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P2W\x22, t ) andalso t.TotalDays = 14)" );
	fb_StrDelete( (FBSTRING*)&TMP$716$1 );
	FBSTRING* vr$92 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &T$1 );
	int32 vr$93 = fb_StrCompare( (void*)vr$92, -1ll, (void*)"P14D", 5ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$93 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 254, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(t.ToIsoString( ) = \x22P14D\x22)" );
	__builtin_memset( &TMP$726$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$726$1, -1ll, (void*)"P1Y", 4ll, 0 );
	boolean vr$101 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$726$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$101 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 258, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P1Y\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$726$1 );
	__builtin_memset( &TMP$731$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$731$1, -1ll, (void*)"P1M", 4ll, 0 );
	boolean vr$108 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$731$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$108 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 259, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P1M\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$731$1 );
	__builtin_memset( &TMP$736$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$736$1, -1ll, (void*)"P1Y2M", 6ll, 0 );
	boolean vr$115 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$736$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$115 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 260, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P1Y2M\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$736$1 );
	__builtin_memset( &TMP$740$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$740$1, -1ll, (void*)"PT1M", 5ll, 0 );
	boolean vr$122 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$740$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$122, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 262, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22PT1M\x22, t ))" );
	fb_StrDelete( (FBSTRING*)&TMP$740$1 );
	__builtin_memset( &TMP$745$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$745$1, -1ll, (void*)"P", 2ll, 0 );
	boolean vr$128 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$745$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$128 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 265, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$745$1 );
	__builtin_memset( &TMP$749$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$749$1, -1ll, (void*)"", 1ll, 0 );
	boolean vr$135 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$749$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$135 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 266, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$749$1 );
	__builtin_memset( &TMP$754$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$754$1, -1ll, (void*)"1D", 3ll, 0 );
	boolean vr$142 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$754$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$142 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 267, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22" "1D\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$754$1 );
	__builtin_memset( &TMP$759$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$759$1, -1ll, (void*)"PD", 3ll, 0 );
	boolean vr$149 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$759$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$149 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 268, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22PD\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$759$1 );
	__builtin_memset( &TMP$764$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$764$1, -1ll, (void*)"PT", 3ll, 0 );
	boolean vr$156 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$764$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$156 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 269, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22PT\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$764$1 );
	__builtin_memset( &TMP$769$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$769$1, -1ll, (void*)"P1H", 4ll, 0 );
	boolean vr$163 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$769$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$163 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 270, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P1H\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$769$1 );
	__builtin_memset( &TMP$774$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$774$1, -1ll, (void*)"PT1D", 5ll, 0 );
	boolean vr$170 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$774$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$170 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 271, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22PT1D\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$774$1 );
	__builtin_memset( &TMP$779$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$779$1, -1ll, (void*)"P1.5D", 6ll, 0 );
	boolean vr$177 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$779$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$177 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 272, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P1.5D\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$779$1 );
	__builtin_memset( &TMP$784$1, 0, 24ll );
	fb_StrAssign( (void*)&TMP$784$1, -1ll, (void*)"P1DX", 5ll, 0 );
	boolean vr$184 = _ZN2FB8TIMESPAN11TRYPARSEISOER8FBSTRINGRS0_( &TMP$784$1, &T$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)(vr$184 == (boolean)0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 273, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.DURATION_GRAMMAR_", (char*)"CU_ASSERT(TimeSpan.TryParseIso( \x22P1DX\x22, t ) = false)" );
	fb_StrDelete( (FBSTRING*)&TMP$784$1 );
	label$1139:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO21ROUNDTRIP_EXHAUSTIVE_Ev( void )
{
	label$1156:;
	uint64 SEED$1;
	SEED$1 = 3141592653ull;
	int16 OFFS$1[8];
	struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$2IsEE {
		int16* DATA;
		int16* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$2IsEE ) == 72 );
	struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$2IsEE tmp$790$1;
	*(int16**)&tmp$790$1 = (int16*)OFFS$1;
	*(int16**)((uint8*)&tmp$790$1 + 8ll) = (int16*)OFFS$1;
	*(int64*)((uint8*)&tmp$790$1 + 16ll) = 16ll;
	*(int64*)((uint8*)&tmp$790$1 + 24ll) = 2ll;
	*(int64*)((uint8*)&tmp$790$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$790$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$790$1 + 48ll) = 8ll;
	*(int64*)((uint8*)&tmp$790$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$790$1 + 64ll) = 7ll;
	*(int16*)OFFS$1 = (int16)0;
	*(int16*)((int64)(int16*)OFFS$1 + 2ll) = (int16)32767;
	*(int16*)((int64)(int16*)OFFS$1 + 4ll) = (int16)-1080;
	*(int16*)((int64)(int16*)OFFS$1 + 6ll) = (int16)-300;
	*(int16*)((int64)(int16*)OFFS$1 + 8ll) = (int16)0;
	*(int16*)((int64)(int16*)OFFS$1 + 10ll) = (int16)330;
	*(int16*)((int64)(int16*)OFFS$1 + 12ll) = (int16)345;
	*(int16*)((int64)(int16*)OFFS$1 + 14ll) = (int16)1080;
	{
		int64 I$2;
		I$2 = 1ll;
		label$1161:;
		{
			SEED$1 = (SEED$1 * 6364136223846793005ull) + 1442695040888963407ull;
			int64 T$3;
			T$3 = (int64)(SEED$1 % 3155378975999999999ull);
			{
				int64 K$4;
				K$4 = 0ll;
				label$1165:;
				{
					FBSTRING TMP$791$5;
					struct $N2FB8DATETIMEE A$5;
					struct $N2FB8DATETIMEE vr$6 = _ZN2FB8DATETIME9FROMTICKSExs( T$3, *(int16*)((int64)(int16*)OFFS$1 + (K$4 << (1ll & 63ll))) );
					A$5 = vr$6;
					boolean vr$8 = _ZN2FB8DATETIME14ISVALID__get__Ev( &A$5 );
					if( vr$8 != (boolean)0ll) goto label$1167;
					{
						goto label$1163;
						label$1167:;
					}
					struct $N2FB8DATETIMEE B$5;
					__builtin_memset( &TMP$791$5, 0, 24ll );
					FBSTRING* vr$11 = _ZN2FB8DATETIME11TOISOSTRINGEv( &A$5 );
					fb_StrAssign( (void*)&TMP$791$5, -1ll, (void*)vr$11, -1ll, 0 );
					struct $N2FB8DATETIMEE vr$14 = _ZN2FB8DATETIME8PARSEISOER8FBSTRING( &TMP$791$5 );
					B$5 = vr$14;
					fb_StrDelete( (FBSTRING*)&TMP$791$5 );
					boolean vr$17 = _ZN2FB8DATETIME14ISVALID__get__Ev( &B$5 );
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$17, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 291, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.ROUNDTRIP_EXHAUSTIVE_", (char*)"CU_ASSERT(b.IsValid)" );
					int64 vr$19 = _ZN2FB8DATETIME12TICKS__get__Ev( &B$5 );
					int64 vr$21 = _ZN2FB8DATETIME12TICKS__get__Ev( &A$5 );
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$19 == vr$21) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 292, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.ROUNDTRIP_EXHAUSTIVE_", (char*)"CU_ASSERT(b.Ticks = a.Ticks)" );
					int16 vr$25 = _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( &B$5 );
					int16 vr$28 = _ZN2FB8DATETIME20OFFSETMINUTES__get__Ev( &A$5 );
					_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$25 == (int64)vr$28) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 293, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.ROUNDTRIP_EXHAUSTIVE_", (char*)"CU_ASSERT(b.OffsetMinutes = a.OffsetMinutes)" );
				}
				label$1163:;
				K$4 = K$4 + 1ll;
				label$1162:;
				if( K$4 <= 7ll) goto label$1165;
				label$1164:;
			}
		}
		label$1159:;
		I$2 = I$2 + 1ll;
		label$1158:;
		if( I$2 <= 12500ll) goto label$1161;
		label$1160:;
	}
	label$1157:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO19STRING_FIXED_POINT_Ev( void )
{
	label$1170:;
	FBSTRING SRC$1[12];
	struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$3I8FBSTRINGEE {
		FBSTRING* DATA;
		FBSTRING* PTR;
		int64 SIZE;
		int64 ELEMENT_LEN;
		int64 DIMENSIONS;
		int64 FLAGS;
		struct $16__FB_ARRAYDIMTB$ DIMTB[1];
	};
	__FB_STATIC_ASSERT( sizeof( struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$3I8FBSTRINGEE ) == 72 );
	struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$3I8FBSTRINGEE tmp$804$1;
	*(FBSTRING**)&tmp$804$1 = (FBSTRING*)SRC$1;
	*(FBSTRING**)((uint8*)&tmp$804$1 + 8ll) = (FBSTRING*)SRC$1;
	*(int64*)((uint8*)&tmp$804$1 + 16ll) = 288ll;
	*(int64*)((uint8*)&tmp$804$1 + 24ll) = 24ll;
	*(int64*)((uint8*)&tmp$804$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$804$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$804$1 + 48ll) = 12ll;
	*(int64*)((uint8*)&tmp$804$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$804$1 + 64ll) = 11ll;
	fb_StrInit( (void*)SRC$1, -1ll, (void*)"20250304T143005Z", 17ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 24ll), -1ll, (void*)"2025-063T14:30:05Z", 19ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 48ll), -1ll, (void*)"2025-W10-2", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 72ll), -1ll, (void*)"2025-03-04T14:30:05,5Z", 23ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 96ll), -1ll, (void*)"2025-03-04 14:30:05Z", 21ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 120ll), -1ll, (void*)"2025-03-04t14:30:05z", 21ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 144ll), -1ll, (void*)"2025-03-04T14:30:05+05", 23ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 168ll), -1ll, (void*)"2025-03-04T14:30:05+0530", 25ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 192ll), -1ll, (void*)"2025-03-04T14:30:05.123456789Z", 31ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 216ll), -1ll, (void*)"2025-03-04", 11ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 240ll), -1ll, (void*)"2025-03-04T14:30Z", 18ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)SRC$1 + 264ll), -1ll, (void*)"  2025-03-04T14:30:05Z  ", 25ll, 0 );
	{
		int64 I$2;
		I$2 = 0ll;
		label$1175:;
		{
			struct $N2FB8DATETIMEE TMP$805$3;
			struct $N2FB8DATETIMEE TMP$806$3;
			FBSTRING S2$3;
			struct $N2FB8DATETIMEE vr$16 = _ZN2FB8DATETIME8PARSEISOER8FBSTRING( (FBSTRING*)((int64)(FBSTRING*)SRC$1 + (I$2 * 24ll)) );
			TMP$805$3 = vr$16;
			FBSTRING* vr$18 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$805$3 );
			fb_StrInit( (void*)&S2$3, -1ll, (void*)vr$18, -1ll, 0 );
			FBSTRING S3$3;
			struct $N2FB8DATETIMEE vr$21 = _ZN2FB8DATETIME8PARSEISOER8FBSTRING( &S2$3 );
			TMP$806$3 = vr$21;
			FBSTRING* vr$23 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$806$3 );
			fb_StrInit( (void*)&S3$3, -1ll, (void*)vr$23, -1ll, 0 );
			int64 vr$26 = fb_StrLen( (void*)&S2$3, -1ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-(vr$26 > 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 311, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.STRING_FIXED_POINT_", (char*)"CU_ASSERT(len( s2 ) > 0)" );
			int32 vr$31 = fb_StrCompare( (void*)&S2$3, -1ll, (void*)&S3$3, -1ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$31 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 312, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.STRING_FIXED_POINT_", (char*)"CU_ASSERT(s2 = s3)" );
			fb_StrDelete( (FBSTRING*)&S3$3 );
			fb_StrDelete( (FBSTRING*)&S2$3 );
		}
		label$1173:;
		I$2 = I$2 + 1ll;
		label$1172:;
		if( I$2 <= 11ll) goto label$1175;
		label$1174:;
	}
	FBSTRING DS$1[5];
	struct $N5TESTS9FBC_TESTS6CHRONO3ISO10FBARRAY1$3I8FBSTRINGEE tmp$814$1;
	*(FBSTRING**)&tmp$814$1 = (FBSTRING*)DS$1;
	*(FBSTRING**)((uint8*)&tmp$814$1 + 8ll) = (FBSTRING*)DS$1;
	*(int64*)((uint8*)&tmp$814$1 + 16ll) = 120ll;
	*(int64*)((uint8*)&tmp$814$1 + 24ll) = 24ll;
	*(int64*)((uint8*)&tmp$814$1 + 32ll) = 1ll;
	*(int64*)((uint8*)&tmp$814$1 + 40ll) = 49ll;
	*(int64*)((uint8*)&tmp$814$1 + 48ll) = 5ll;
	*(int64*)((uint8*)&tmp$814$1 + 56ll) = 0ll;
	*(int64*)((uint8*)&tmp$814$1 + 64ll) = 4ll;
	fb_StrInit( (void*)DS$1, -1ll, (void*)"P2W", 4ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)DS$1 + 24ll), -1ll, (void*)"PT4,5S", 7ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)DS$1 + 48ll), -1ll, (void*)"P1DT2H3M4.5S", 13ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)DS$1 + 72ll), -1ll, (void*)"PT0S", 5ll, 0 );
	fb_StrInit( (void*)((int64)(FBSTRING*)DS$1 + 96ll), -1ll, (void*)"-PT1H30M", 9ll, 0 );
	{
		int64 I$2;
		I$2 = 0ll;
		label$1179:;
		{
			struct $N2FB8TIMESPANE TMP$815$3;
			struct $N2FB8TIMESPANE TMP$816$3;
			FBSTRING S2$3;
			struct $N2FB8TIMESPANE vr$47 = _ZN2FB8TIMESPAN8PARSEISOER8FBSTRING( (FBSTRING*)((int64)(FBSTRING*)DS$1 + (I$2 * 24ll)) );
			TMP$815$3 = vr$47;
			FBSTRING* vr$49 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$815$3 );
			fb_StrInit( (void*)&S2$3, -1ll, (void*)vr$49, -1ll, 0 );
			FBSTRING S3$3;
			struct $N2FB8TIMESPANE vr$52 = _ZN2FB8TIMESPAN8PARSEISOER8FBSTRING( &S2$3 );
			TMP$816$3 = vr$52;
			FBSTRING* vr$54 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$816$3 );
			fb_StrInit( (void*)&S3$3, -1ll, (void*)vr$54, -1ll, 0 );
			int32 vr$58 = fb_StrCompare( (void*)&S2$3, -1ll, (void*)&S3$3, -1ll );
			_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$58 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 320, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.STRING_FIXED_POINT_", (char*)"CU_ASSERT(s2 = s3)" );
			fb_StrDelete( (FBSTRING*)&S3$3 );
			fb_StrDelete( (FBSTRING*)&S2$3 );
		}
		label$1177:;
		I$2 = I$2 + 1ll;
		label$1176:;
		if( I$2 <= 4ll) goto label$1179;
		label$1178:;
	}
	fb_ArrayDestructStr( (struct $7FBARRAYIvE*)&tmp$814$1 );
	fb_ArrayDestructStr( (struct $7FBARRAYIvE*)&tmp$804$1 );
	label$1171:;
}

void _ZN5TESTS9FBC_TESTS6CHRONO3ISO18NO_LOCALE_LEAKAGE_Ev( void )
{
	struct $N2FB8DATETIMEE TMP$819$1;
	struct $N2FB8DATETIMEE TMP$820$1;
	struct $N2FB8TIMESPANE TMP$821$1;
	struct $N2FB8DATETIMEE TMP$822$1;
	struct $N2FB8DATETIMEE TMP$823$1;
	struct $N2FB8TIMESPANE TMP$828$1;
	struct $N2FB8DATETIMEE TMP$833$1;
	struct $N2FB8DATETIMEE TMP$834$1;
	struct $N2FB8TIMESPANE TMP$835$1;
	label$1182:;
	FBSTRING WANT$1;
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$819$1, 2025, 3, 4, 14, 30, 5, 123 );
	struct $N2FB8DATETIMEE vr$2 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$819$1, (int16)330 );
	TMP$820$1 = vr$2;
	FBSTRING* vr$4 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$820$1 );
	fb_StrInit( (void*)&WANT$1, -1ll, (void*)vr$4, -1ll, 0 );
	FBSTRING WANTDUR$1;
	_ZN2FB8TIMESPANC1Eiiiii( &TMP$821$1, 1, 2, 3, 4, 500 );
	FBSTRING* vr$8 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$821$1 );
	fb_StrInit( (void*)&WANTDUR$1, -1ll, (void*)vr$8, -1ll, 0 );
	char* PREV$1;
	char* vr$10 = setlocale( 6, (char*)0ull );
	PREV$1 = vr$10;
	FBSTRING SAVED$1;
	fb_StrInit( (void*)&SAVED$1, -1ll, (void*)"", 1ll, 0 );
	if( PREV$1 == (char*)0ull) goto label$1185;
	{
		fb_StrAssign( (void*)&SAVED$1, -1ll, (void*)PREV$1, 0ll, 0 );
		label$1185:;
	}
	setlocale( 6, (char*)"" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$822$1, 2025, 3, 4, 14, 30, 5, 123 );
	struct $N2FB8DATETIMEE vr$16 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$822$1, (int16)330 );
	TMP$823$1 = vr$16;
	FBSTRING* vr$18 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$823$1 );
	int32 vr$19 = fb_StrCompare( (void*)vr$18, -1ll, (void*)&WANT$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$19 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 336, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 123 ).WithOffset( 330 ).ToIsoString( ) = want)" );
	_ZN2FB8TIMESPANC1Eiiiii( &TMP$828$1, 1, 2, 3, 4, 500 );
	FBSTRING* vr$26 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$828$1 );
	int32 vr$27 = fb_StrCompare( (void*)vr$26, -1ll, (void*)&WANTDUR$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$27 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 337, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(TimeSpan( 1, 2, 3, 4, 500 ).ToIsoString( ) = wantDur)" );
	setlocale( 6, (char*)"German_Germany" );
	_ZN2FB8DATETIMEC1Eiiiiiii( &TMP$833$1, 2025, 3, 4, 14, 30, 5, 123 );
	struct $N2FB8DATETIMEE vr$34 = _ZN2FB8DATETIME10WITHOFFSETEs( &TMP$833$1, (int16)330 );
	TMP$834$1 = vr$34;
	FBSTRING* vr$36 = _ZN2FB8DATETIME11TOISOSTRINGEv( &TMP$834$1 );
	int32 vr$37 = fb_StrCompare( (void*)vr$36, -1ll, (void*)&WANT$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$37 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 340, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(DateTime( 2025, 3, 4, 14, 30, 5, 123 ).WithOffset( 330 ).ToIsoString( ) = want)" );
	_ZN2FB8TIMESPANC1Eiiiii( &TMP$835$1, 1, 2, 3, 4, 500 );
	FBSTRING* vr$44 = _ZN2FB8TIMESPAN11TOISOSTRINGEv( &TMP$835$1 );
	int32 vr$45 = fb_StrCompare( (void*)vr$44, -1ll, (void*)&WANTDUR$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$45 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 341, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(TimeSpan( 1, 2, 3, 4, 500 ).ToIsoString( ) = wantDur)" );
	struct $N2FB8DATETIMEE D$1;
	_ZN2FB8DATETIMEC1Ev( &D$1 );
	boolean vr$52 = _ZN2FB8DATETIME11TRYPARSEISOER8FBSTRINGRS0_( &WANT$1, &D$1 );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( vr$52, (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 344, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(DateTime.TryParseIso( want, d ))" );
	FBSTRING* vr$55 = _ZN2FB8DATETIME11TOISOSTRINGEv( &D$1 );
	int32 vr$56 = fb_StrCompare( (void*)vr$55, -1ll, (void*)&WANT$1, -1ll );
	_ZN4FBCU10CU_ASSERT_EbPciS0_S0_( (boolean)((int64)-((int64)vr$56 == 0ll) != 0ll), (char*)"tests\x5Cvendor\x5C" "fbc-tests\x5C" "chrono\x5Ciso.bas", 345, (char*)"TESTS.FBC_TESTS.CHRONO.ISO.NO_LOCALE_LEAKAGE_", (char*)"CU_ASSERT(d.ToIsoString( ) = want)" );
	int64 vr$61 = fb_StrLen( (void*)&SAVED$1, -1ll );
	if( vr$61 <= 0ll) goto label$1187;
	{
		setlocale( 6, (char*)*(char**)&SAVED$1 );
		label$1187:;
	}
	fb_StrDelete( (FBSTRING*)&SAVED$1 );
	fb_StrDelete( (FBSTRING*)&WANTDUR$1 );
	fb_StrDelete( (FBSTRING*)&WANT$1 );
	label$1183:;
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
	goto label$1192;
	label$17:;
	TMP$7$1 = (boolean)1ll;
	label$1192:;
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

static void _ZN2FB8TIMESPANC1Eiiiii( struct $N2FB8TIMESPANE* THIS$1, int32 D$1, int32 H$1, int32 MI$1, int32 S$1, int32 MS$1 )
{
	label$26:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	*(int64*)THIS$1 = (((((int64)D$1 * 864000000000ll) + ((int64)H$1 * 36000000000ll)) + ((int64)MI$1 * 600000000ll)) + ((int64)S$1 * 10000000ll)) + ((int64)MS$1 * 10000ll);
	label$27:;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN8FROMDAYSEd( double V$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$28:;
	int64 vr$1 = _ZN2FB17DTTICKSFROMDOUBLEEd( V$1 * 0x1.9254D38p+39 );
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, vr$1 );
	goto label$29;
	label$29:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN9FROMHOURSEd( double V$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$30:;
	int64 vr$1 = _ZN2FB17DTTICKSFROMDOUBLEEd( V$1 * 0x1.0C388Dp+35 );
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, vr$1 );
	goto label$31;
	label$31:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN11FROMMINUTESEd( double V$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$32:;
	int64 vr$1 = _ZN2FB17DTTICKSFROMDOUBLEEd( V$1 * 0x1.1E1A3p+29 );
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, vr$1 );
	goto label$33;
	label$33:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN11FROMSECONDSEd( double V$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$34:;
	int64 vr$1 = _ZN2FB17DTTICKSFROMDOUBLEEd( V$1 * 0x1.312Dp+23 );
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, vr$1 );
	goto label$35;
	label$35:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN16FROMMILLISECONDSEd( double V$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$36:;
	int64 vr$1 = _ZN2FB17DTTICKSFROMDOUBLEEd( V$1 * 0x1.388p+13 );
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, vr$1 );
	goto label$37;
	label$37:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN9FROMTICKSEx( int64 V$1 )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$44:;
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, V$1 );
	goto label$45;
	label$45:;
	return fb$result$1;
}

static struct $N2FB8TIMESPANE _ZN2FB8TIMESPAN4ZEROEv( void )
{
	struct $N2FB8TIMESPANE fb$result$1;
	label$46:;
	_ZN2FB8TIMESPANC1Ex( &fb$result$1, 0ll );
	goto label$47;
	label$47:;
	return fb$result$1;
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

static double _ZN2FB8TIMESPAN16TOTALDAYS__get__Ev( struct $N2FB8TIMESPANE* THIS$1 )
{
	double fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$63:;
	fb$result$1 = (double)*(int64*)THIS$1 / 0x1.9254D38p+39;
	goto label$64;
	label$64:;
	return fb$result$1;
}

static double _ZN2FB8TIMESPAN17TOTALHOURS__get__Ev( struct $N2FB8TIMESPANE* THIS$1 )
{
	double fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$65:;
	fb$result$1 = (double)*(int64*)THIS$1 / 0x1.0C388Dp+35;
	goto label$66;
	label$66:;
	return fb$result$1;
}

static double _ZN2FB8TIMESPAN19TOTALMINUTES__get__Ev( struct $N2FB8TIMESPANE* THIS$1 )
{
	double fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$67:;
	fb$result$1 = (double)*(int64*)THIS$1 / 0x1.1E1A3p+29;
	goto label$68;
	label$68:;
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
	goto label$1194;
	label$99:;
	TMP$27$1 = (boolean)1ll;
	label$1194:;
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
	goto label$1195;
	label$106:;
	TMP$31$1 = (boolean)1ll;
	label$1195:;
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
	goto label$1197;
	label$130:;
	TMP$41$1 = (boolean)1ll;
	label$1197:;
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
	goto label$1200;
	label$171:;
	TMP$44$1 = (boolean)1ll;
	label$1200:;
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
	goto label$1201;
	label$208:;
	TMP$45$1 = (boolean)1ll;
	label$1201:;
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
	goto label$1202;
	label$237:;
	TMP$46$1 = (boolean)1ll;
	label$1202:;
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
	goto label$1203;
	label$258:;
	TMP$49$1 = (boolean)1ll;
	label$1203:;
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

static void _ZN2FB9LOCALTIMEC1Eiiii( struct $N2FB9LOCALTIMEE* THIS$1, int32 H$1, int32 MI$1, int32 S$1, int32 MS$1 )
{
	label$286:;
	__builtin_memset( (int64*)THIS$1, 0, 8ll );
	int32 vr$4 = fb_DtIsValidTime( H$1, MI$1, S$1, (int64)MS$1 * 10000ll );
	if( (int64)vr$4 != 0ll) goto label$289;
	{
		*(int64*)THIS$1 = (int64)-9223372036854775808ull;
	}
	goto label$288;
	label$289:;
	{
		*(int64*)THIS$1 = ((((int64)H$1 * 36000000000ll) + ((int64)MI$1 * 600000000ll)) + ((int64)S$1 * 10000000ll)) + ((int64)MS$1 * 10000ll);
	}
	label$288:;
	label$287:;
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
	goto label$1207;
	label$292:;
	TMP$53$1 = (boolean)1ll;
	label$1207:;
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

static struct $N2FB9LOCALTIMEE _ZN2FB9LOCALTIME8MAXVALUEEv( void )
{
	struct $N2FB9LOCALTIMEE fb$result$1;
	label$299:;
	struct $N2FB9LOCALTIMEE vr$0 = _ZN2FB9LOCALTIME9FROMTICKSEx( 863999999999ll );
	fb$result$1 = vr$0;
	goto label$300;
	label$300:;
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
	goto label$1208;
	label$305:;
	TMP$54$1 = (boolean)0ll;
	label$1208:;
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

static int32 _ZN2FB9LOCALTIME11HOUR__get__Ev( struct $N2FB9LOCALTIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$308:;
	boolean vr$1 = _ZN2FB9LOCALTIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$311;
	{
		fb$result$1 = 0;
		goto label$309;
		label$311:;
	}
	fb$result$1 = (int32)(*(int64*)THIS$1 / 36000000000ll);
	goto label$309;
	label$309:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALTIME13MINUTE__get__Ev( struct $N2FB9LOCALTIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$312:;
	boolean vr$1 = _ZN2FB9LOCALTIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$315;
	{
		fb$result$1 = 0;
		goto label$313;
		label$315:;
	}
	fb$result$1 = (int32)((*(int64*)THIS$1 / 600000000ll) % 60ll);
	goto label$313;
	label$313:;
	return fb$result$1;
}

static int32 _ZN2FB9LOCALTIME13SECOND__get__Ev( struct $N2FB9LOCALTIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$316:;
	boolean vr$1 = _ZN2FB9LOCALTIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$319;
	{
		fb$result$1 = 0;
		goto label$317;
		label$319:;
	}
	fb$result$1 = (int32)((*(int64*)THIS$1 / 10000000ll) % 60ll);
	goto label$317;
	label$317:;
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
	goto label$1209;
	label$330:;
	TMP$55$1 = (boolean)1ll;
	label$1209:;
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

static struct $N2FB7INSTANTE _ZN2FB7INSTANT9FROMTICKSEx( int64 T$1 )
{
	struct $N2FB7INSTANTE fb$result$1;
	label$362:;
	_ZN2FB7INSTANTC1Ex( &fb$result$1, T$1 );
	goto label$363;
	label$363:;
	return fb$result$1;
}

static struct $N2FB7INSTANTE _ZN2FB7INSTANT8MINVALUEEv( void )
{
	struct $N2FB7INSTANTE fb$result$1;
	label$364:;
	_ZN2FB7INSTANTC1Ex( &fb$result$1, 0ll );
	goto label$365;
	label$365:;
	return fb$result$1;
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
	goto label$1213;
	label$376:;
	TMP$64$1 = (boolean)1ll;
	label$1213:;
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
	goto label$1214;
	label$383:;
	TMP$66$1 = (boolean)1ll;
	label$1214:;
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
	goto label$1215;
	label$390:;
	TMP$68$1 = (boolean)1ll;
	label$1215:;
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
	goto label$1219;
	label$424:;
	TMP$74$1 = (boolean)0ll;
	label$1219:;
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
	goto label$1220;
	label$437:;
	TMP$75$1 = (boolean)0ll;
	label$1220:;
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

static int64 _ZN2FB8DATETIME16TICKOFDAY__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int64 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 8ll );
	label$487:;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$490;
	{
		fb$result$1 = 0ll;
		goto label$488;
		label$490:;
	}
	fb$result$1 = *(int64*)THIS$1 % 864000000000ll;
	goto label$488;
	label$488:;
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

static int32 _ZN2FB8DATETIME13MINUTE__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$495:;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$498;
	{
		fb$result$1 = 0;
		goto label$496;
		label$498:;
	}
	fb$result$1 = (int32)((*(int64*)THIS$1 / 600000000ll) % 60ll);
	goto label$496;
	label$496:;
	return fb$result$1;
}

static int32 _ZN2FB8DATETIME13SECOND__get__Ev( struct $N2FB8DATETIMEE* THIS$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4ll );
	label$499:;
	boolean vr$1 = _ZN2FB8DATETIME14ISVALID__get__Ev( THIS$1 );
	if( vr$1 != (boolean)0ll) goto label$502;
	{
		fb$result$1 = 0;
		goto label$500;
		label$502:;
	}
	fb$result$1 = (int32)((*(int64*)THIS$1 / 10000000ll) % 60ll);
	goto label$500;
	label$500:;
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
	goto label$1225;
	label$694:;
	TMP$90$1 = (boolean)1ll;
	label$1225:;
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

static FBSTRING* _ZN2FB8DATETIME8TOSTRINGEv( struct $N2FB8DATETIMEE* THIS$1 )
{
	FBSTRING fb$result$1;
	__builtin_memset( &fb$result$1, 0, 24ll );
	label$736:;
	FBSTRING* vr$1 = _ZN2FB8DATETIME11TOISOSTRINGEv( THIS$1 );
	fb_StrInit( (void*)&fb$result$1, -1ll, (void*)vr$1, -1ll, 0 );
	goto label$737;
	label$737:;
	FBSTRING* vr$4 = fb_StrAllocTempResult( (FBSTRING*)&fb$result$1 );
	return vr$4;
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
	goto label$1229;
	label$882:;
	TMP$105$1 = 0ll;
	label$1229:;
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
	goto label$1230;
	label$887:;
	TMP$106$1 = 0ll;
	label$1230:;
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

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO19EMIT_DATETIME__CTOREv( void )
{
	label$1084:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"emit_datetime_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO14EMIT_DATETIME_Ev, (boolean)0ll );
	label$1085:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO22EMIT_OTHER_TYPES__CTOREv( void )
{
	label$1088:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"emit_other_types_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO17EMIT_OTHER_TYPES_Ev, (boolean)0ll );
	label$1089:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO19EMIT_DURATION__CTOREv( void )
{
	label$1092:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"emit_duration_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO14EMIT_DURATION_Ev, (boolean)0ll );
	label$1093:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO26PARSE_ACCEPTED_FORMS__CTOREv( void )
{
	label$1108:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"parse_accepted_forms_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO21PARSE_ACCEPTED_FORMS_Ev, (boolean)0ll );
	label$1109:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO21PARSE_FRACTIONS__CTOREv( void )
{
	label$1112:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"parse_fractions_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO16PARSE_FRACTIONS_Ev, (boolean)0ll );
	label$1113:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO28PARSE_REJECTION_CORPUS__CTOREv( void )
{
	label$1120:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"parse_rejection_corpus_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO23PARSE_REJECTION_CORPUS_Ev, (boolean)0ll );
	label$1121:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO29INSTANT_REQUIRES_OFFSET__CTOREv( void )
{
	label$1124:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"instant_requires_offset_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO24INSTANT_REQUIRES_OFFSET_Ev, (boolean)0ll );
	label$1125:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO23PARSE_OTHER_TYPES__CTOREv( void )
{
	label$1136:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"parse_other_types_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO18PARSE_OTHER_TYPES_Ev, (boolean)0ll );
	label$1137:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO22DURATION_GRAMMAR__CTOREv( void )
{
	label$1154:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"duration_grammar_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO17DURATION_GRAMMAR_Ev, (boolean)0ll );
	label$1155:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO26ROUNDTRIP_EXHAUSTIVE__CTOREv( void )
{
	label$1168:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"roundtrip_exhaustive_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO21ROUNDTRIP_EXHAUSTIVE_Ev, (boolean)0ll );
	label$1169:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO24STRING_FIXED_POINT__CTOREv( void )
{
	label$1180:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"string_fixed_point_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO19STRING_FIXED_POINT_Ev, (boolean)0ll );
	label$1181:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO23NO_LOCALE_LEAKAGE__CTOREv( void )
{
	label$1188:;
	_ZN4FBCU8ADD_TESTEPcS0_PFvvEb( (char*)"fbc_tests.chrono.iso", (char*)"no_locale_leakage_", (tmp$5)&_ZN5TESTS9FBC_TESTS6CHRONO3ISO18NO_LOCALE_LEAKAGE_Ev, (boolean)0ll );
	label$1189:;
}

__attribute__(( constructor )) static void _ZN5TESTS9FBC_TESTS6CHRONO3ISO13SUITE_CTOR350Ev( void )
{
	label$1190:;
	_ZN4FBCU9ADD_SUITEEPcPFivES2_( (char*)"fbc_tests.chrono.iso", (tmp$4)0ull, (tmp$4)0ull );
	label$1191:;
}

static const char __attribute__((used, section(".fbctinf"))) __fbctinf[] = "-l\0fbcunit";
