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
'' ...and the names fbc-modern's logging phases 5-6 added: the default logger, through an
'' AsyncSink whose Close( ) -- reached by LogShutdown -- drains it before the program ends.
FB_LOG_IMPLEMENT( )
dim shared as logs.TextRenderer txt
txt.stamp = logs.TS_NONE
dim as logs.ConsoleSink con = logs.ConsoleSink( logs.CT_STDOUT, @txt )
dim as logs.AsyncSink aq = logs.AsyncSink( @con, 8 )
aq.policy = logs.OP_BLOCK
logs.LogInit( @aq, logs.LOG_INFO )
logs.DefaultLogger( ).Info( ).Int_( "n", 7 ).Msg( "via the facade" )
logs.LogShutdown( )
print "dropped"; aq.DroppedCount( )
