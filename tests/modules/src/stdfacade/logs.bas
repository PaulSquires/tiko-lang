'' std/logs (RFC-0009): an enum, its members and procedures through the facade, beside
'' fb/logging.bi included directly -- a logs.LogLevel IS an FB.LogLevel.
#import "std/logs"
#include once "fb/logging.bi"
private function Named( byval lv as FB.LogLevel ) as string
    return logs.LevelName( lv )
end function
dim as logs.LogLevel lv = logs.LOG_WARN
print Named( lv ); " "; logs.LevelNameShort( logs.LOG_ERROR )
dim as logs.LogLevel back
print logs.LevelFromName( "info", back ); " "; back = logs.LOG_INFO
