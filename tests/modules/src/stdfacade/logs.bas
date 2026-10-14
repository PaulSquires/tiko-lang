'' std/logs, a real module: an enum, its members and procedures; the default logger -- the
'' module's own, no FB_LOG_IMPLEMENT -- through an AsyncSink drained by LogShutdown; and the
'' exported macros, whose site is this file's.
#import "std/logs"
private function Named( byval lv as logs.LogLevel ) as string
    return logs.LevelName( lv )
end function
dim as logs.LogLevel lv = logs.LOG_WARN
print Named( lv ); " "; logs.LevelNameShort( logs.LOG_ERROR )
dim as logs.LogLevel back
print logs.LevelFromName( "info", back ); " "; back = logs.LOG_INFO
dim shared as logs.TextRenderer txt
txt.stamp = logs.TS_NONE
txt.showsite = true
dim as logs.ConsoleSink con = logs.ConsoleSink( logs.CT_STDOUT, @txt )
dim as logs.AsyncSink aq = logs.AsyncSink( @con, 8 )
aq.policy = logs.OP_BLOCK
logs.LogInit( @aq, logs.LOG_INFO )
logs.DefaultLogger( ).Info( ).AddInt( "n", 7 ).Msg( "via the module" )
logs.LogInfo( "by the macro" )
logs.LogEventWarn( AddInt( "code", 3 ), "an event" )
logs.LogDebug( "below the level" )
logs.LogShutdown( )
print "dropped"; aq.DroppedCount( )
