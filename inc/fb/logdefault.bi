'' fb/logdefault.bi -- the process-wide default logger, FB.DefaultLogger( )
''
''     #include once "fb/logging.bi"
''
''     FB_LOG_IMPLEMENT( )                       '' in EXACTLY ONE module
''
''     dim con as FB.ConsoleSink
''     FB.LogInit( @con, FB.LOG_DEBUG )
''     FB.DefaultLogger( ).Info( "server started" )        '' from any module
''     ...
''     FB.LogShutdown( )
''
'' RFC-0002 section 6 -- C:\dev\docs\logging\RFC-0002-logger.md. Phase 4.
''
'' ---------------------------------------------------------------------------
'' WHY A MACRO
''
'' A header cannot make a process-wide object. A `dim shared` in a .bi gives
'' every module that includes it ITS OWN copy, and there is no lock to guard a
'' lazy first-use construction either. fb/scheduler.bi hits the same wall and
'' answers it with C in the runtime; this module promised no new runtime C, so
'' the program defines the object instead, once:
''
''     FB_LOG_IMPLEMENT( )
''
'' at module level, in one module. Every other module only ever sees the
'' `extern` below. Forgetting the macro is a LINK error naming the logger:
''
''     fbc:   undefined reference to `FB::HLOGDEFAULT$'
''     tiko:  undefined symbol: HLOGDEFAULT$
''
'' EXPANDING IT TWICE IS CAUGHT BY A GUARD, not by the logger itself. A
'' module-level `dim` of a constructed type is emitted as a COMMON symbol, so
'' two definitions of hLogDefault MERGE SILENTLY -- measured -- and the one
'' object would be constructed and destructed twice. hLogImplemented is
'' INITIALISED data, a strong symbol, so a second expansion is a link error:
''
''     fbc:   multiple definition of `FB::HLOGIMPLEMENTED$'
''     tiko:  duplicate symbol: HLOGIMPLEMENTED$
''
'' A program that never calls FB.DefaultLogger( ), LogInit or LogShutdown needs no macro
'' at all: these are private and unused, so nothing references the symbol.
'' Explicit Logger instances are untouched by any of this.
''
'' The macro is the module's ONE GLOBAL NAME -- macros cannot be namespaced.
''
'' ---------------------------------------------------------------------------
'' WHY DefaultLogger( ) AND NOT Log( )
''
'' RFC-0002 section 6 named it FB.DefaultLogger( ), and phase 4 shipped that -- tested only
'' from OUTSIDE namespace FB, where a bare log( x ) still means the logarithm. INSIDE
'' namespace FB the namespace's own Log( ) is found first, so every log( x ) there
'' became a call to the logger: fb/random.bi, fb/complex.bi and fb/fintvm.bi all
'' call log( ), and with fb/logging.bi included before fb/random.bi, fbc refused
'' random.bi -- error 7 at both of its log( ) calls (measured, fbc-modern 1.20).
'' A library that sits in namespace FB cannot take the name of an intrinsic.

#pragma once

#include once "fb/logger.bi"

namespace FB

'' Defined by FB_LOG_IMPLEMENT( ). Constructed at that module's start: a
'' module constructor elsewhere that logs before then reaches an unconstructed
'' (zeroed) Logger, which has no sinks and so writes nothing.
extern hLogDefault as Logger
extern hLogImplemented as long      '' the twice-expanded guard, above

declare function DefaultLogger( ) byref as Logger
declare sub LogInit( byval s as Sink ptr, byval lv as LogLevel = LOG_INFO )
declare sub LogShutdown( )

'' The default logger. Before LogInit it has NO SINKS and a minimum level of
'' LOG_INFO: every call is well-formed and goes nowhere, so a library that
'' logs before its host configures logging is silent rather than crashing or
'' writing somewhere unexpected.
private function DefaultLogger( ) byref as Logger
	return hLogDefault
end function

'' Adds a sink (NULL adds none) and sets the level. May be called more than
'' once to add more sinks. Configuration-time, like Logger.AddSink: not safe
'' against concurrent logging.
''
'' THE FB_LOG ENVIRONMENT VARIABLE (RFC-0002 section 9), read here: FB_LOG=debug,
'' FB_LOG=WRN or FB_LOG=20 sets the level instead of 'lv' -- an operator can turn
'' logging up without a rebuild. An UNPARSEABLE value is ignored and 'lv' stands:
'' a typo in an environment variable must not silently turn logging off.
private sub LogInit( byval s as Sink ptr, byval lv as LogLevel )
	if( s <> 0 ) then hLogDefault.AddSink( s )
	dim as LogLevel envlv
	dim as ustring ev = environ( "FB_LOG" )
	if( (len( ev ) > 0) andalso LevelFromName( ev, envlv ) ) then lv = envlv
	hLogDefault.MinLevel = lv
end sub

'' Flushes and closes every sink the default logger holds, then forgets them.
'' Idempotent.
''
'' NOT CALLED AUTOMATICALLY AT EXIT. FreeBASIC's module destructor order across
'' compilation units is not something to bet a flush on, and a lost final line
'' is exactly what would be blamed on the logger. Call it last.
private sub LogShutdown( )
	for i as long = 0 to hLogDefault.m_sinks.Count( ) - 1
		dim as Sink ptr s = hLogDefault.m_sinks[i]
		if( s <> 0 ) then
			s->Flush( )
			s->Close( )
		end if
	next
	hLogDefault.ClearSinks( )
end sub

end namespace

#macro FB_LOG_IMPLEMENT( )
	namespace FB
		dim hLogImplemented as long = 1
		dim hLogDefault as Logger
	end namespace
#endmacro
