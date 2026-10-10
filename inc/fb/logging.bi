'' fb/logging.bi -- umbrella header for FB.Logging
''
''     #include once "fb/logging.bi"
''     using FB
''
''     dim con as ConsoleSink
''     dim lg  as Logger
''     lg.AddSink( @con )
''     lg.Info( "server started" )
''     lg.Warn( ).Str( "user", u ).Int( "attempts", n ).Msg( "login failed" )
''
'' Specified in C:\dev\docs\logging\. Mirrors inc/containers.bi and
'' inc/fb/filesystem.bi: including this one file gets the whole module.
''
'' LIBRARY ONLY. No compiler change and no logging C in the runtime -- unlike
'' fb/filesystem.bi, every line of this module is FreeBASIC.
''
'' | File            | RFC     | What it is                                  |
'' |-----------------|---------|---------------------------------------------|
'' | fb/logrecord.bi | 0001    | LogLevel, LogValue, LogField, LogRecord     |
'' | fb/logrender.bi | 0003    | Renderer, TextRenderer, JsonRenderer        |
'' | fb/logerror.bi  | 0005    | OnLogError, the OS plumbing                 |
'' | fb/logsink.bi   | 0004    | Sink, ConsoleSink                           |
'' | fb/logfile.bi   | 0004    | FileSink, RotatePolicy                      |
'' | fb/logasync.bi  | 0005    | AsyncSink, OverflowPolicy                   |
'' | fb/logger.bi    | 0002    | Logger, LogEvent                            |
'' | fb/logdefault.bi| 0002    | FB.DefaultLogger( ), LogInit, LogShutdown             |
''
'' PHASES 1-6.
''
'' NOT INCLUDED HERE, BY DESIGN: fb/logmacros.bi -- FB_LOG_INFO( m ) and the
'' rest, with call-site capture and compile-time elision. Macros cannot be
'' namespaced, so that header is the one you opt into.
''
'' THE DEFAULT LOGGER NEEDS ONE LINE FROM YOU: FB_LOG_IMPLEMENT( ) in exactly
'' one module -- a header cannot make a process-wide object. See
'' fb/logdefault.bi. Explicit Logger instances need nothing.
''
'' Nothing here is a keyword. `Logger`, `Sink` and the rest stay available as
'' your own identifiers until you say `using FB` -- and the macro layer, which
'' cannot be namespaced, is a separate opt-in header by design.

#pragma once

#include once "fb/logrecord.bi"
#include once "fb/logrender.bi"
#include once "fb/logsink.bi"
#include once "fb/logfile.bi"
#include once "fb/logasync.bi"
#include once "fb/logger.bi"
#include once "fb/logdefault.bi"
