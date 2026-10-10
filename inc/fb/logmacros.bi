'' fb/logmacros.bi -- FB.Logging's macro layer: call sites and compile-time elision
''
''     #include once "fb/logmacros.bi"        '' brings fb/logging.bi with it
''     FB_LOG_IMPLEMENT( )                     '' once, in one module
''
''     FB_LOG_INFO( "server started" )
''     FB_LOG_EVENT_WARN( Str( "path", p ).Int_( "code", c ), "write failed" )
''
''     ...  INFO   server started  (C:\src\main.bas:12 MAIN)
''
'' RFC-0002 section 8 -- C:\dev\docs\logging\RFC-0002-logger.md. Phase 5.
''
'' Two things only a macro can do, because only a macro is expanded AT THE CALL:
''
''   1. CALL-SITE CAPTURE. __FILE__, __LINE__ and __FUNCTION__ inside a macro
''      resolve where the macro is USED -- line 25 inside DoWork reports 25 and
''      DOWORK. Every record these macros make carries its site, which
''      TextRenderer.showsite and JsonRenderer.showsite print. (__FUNCTION__ is
''      upper case, and at module level it is the main procedure's name.)
''   2. COMPILE-TIME ELISION. Below FB_LOG_MIN_LEVEL a macro expands to NOTHING:
''      the call, its arguments and the message expression are gone from the
''      program, not skipped at run time. Build with
''
''          fbc -d FB_LOG_MIN_LEVEL=30 ...          (tiko: the same -d)
''
''      and every LOG_TRACE and LOG_DEBUG is absent from the emitted code --
''      which the phase-5 test checks in the ASSEMBLY, not by the absence of
''      output.
''
'' A level that is compiled in is still filtered at run time by the logger's
'' MinLevel. Then the event builds nothing (phase 1), but the MESSAGE EXPRESSION
'' is an argument and is evaluated: FB_LOG_DEBUG( "x=" & x ) concatenates whether or
'' not DEBUG is on. Wrapping the call in `if FB.DefaultLogger( ).Enabled( ... ) then` would
'' skip that, and was rejected: a macro that expands to a single-line IF steals
'' the ELSE of a caller's `if a then FB_LOG_INFO( "x" ) else ...` -- measured.
''
'' ---------------------------------------------------------------------------
'' WHY FB_LOG_INFO( m ) AND NOT LOG_INFO( m )
''
'' RFC-0002 section 8 named the macros after the levels, LOG_INFO( m ), on the
'' grounds that a macro with parameters only expands before '('. That part is
'' true, and it is not enough. In fbc a macro named LOG_INFO and the constant
'' FB.LOG_INFO cannot both be reached by the bare name -- measured:
''
''     macro first, then `using FB`:   `dim lv = LOG_INFO` is error 42,
''                                     Variable not declared
''     `using FB` first, then macro:   the #define itself is error 4,
''                                     Duplicated definition
''
'' Only the qualified FB.LOG_INFO survived, and `lg.MinLevel = LOG_INFO` after
'' `using FB` is exactly how phase 1 taught programs to write it. (tiko accepts
'' all three forms -- a gap there, not a licence.) So the macros carry the
'' FB_LOG_ prefix the module's other global names already have, and the level
'' constants are untouched.
''
'' A SEPARATE HEADER, never included by fb/logging.bi: macros cannot be
'' namespaced, and the module adds nothing global unless asked. These are its
'' global names: FB_LOG_MIN_LEVEL, FB_LOG_SITE, FB_LOG_TRACE ... FB_LOG_FATAL
'' and FB_LOG_EVENT_TRACE ... FB_LOG_EVENT_FATAL.
''
'' The macros log to the DEFAULT logger, FB.DefaultLogger( ), so a program that uses them
'' expands FB_LOG_IMPLEMENT( ) in one module (fb/logdefault.bi).

#pragma once

#include once "fb/logging.bi"

'' The lowest level compiled in. A NUMBER, because the preprocessor cannot read
'' an enum: 10 TRACE, 20 DEBUG, 30 INFO, 40 WARN, 50 ERROR, 60 FATAL, 1000 OFF.
'' The default compiles everything in.
#ifndef FB_LOG_MIN_LEVEL
	#define FB_LOG_MIN_LEVEL 10
#endif

'' __FILE__, not __FILE_NQ__: the unquoted form expands to a bare C:\... and
'' fails to compile (error 42, error 3) -- measured.
#define FB_LOG_SITE __FILE__, __LINE__, __FUNCTION__

'' ------------------------------------------------------------- the message form
#if FB_LOG_MIN_LEVEL <= 10
	#define FB_LOG_TRACE( m ) FB.DefaultLogger( ).Trace( ).Site( FB_LOG_SITE ).Msg( m )
#else
	#define FB_LOG_TRACE( m )
#endif

#if FB_LOG_MIN_LEVEL <= 20
	#define FB_LOG_DEBUG( m ) FB.DefaultLogger( ).Debug( ).Site( FB_LOG_SITE ).Msg( m )
#else
	#define FB_LOG_DEBUG( m )
#endif

#if FB_LOG_MIN_LEVEL <= 30
	#define FB_LOG_INFO( m ) FB.DefaultLogger( ).Info( ).Site( FB_LOG_SITE ).Msg( m )
#else
	#define FB_LOG_INFO( m )
#endif

#if FB_LOG_MIN_LEVEL <= 40
	#define FB_LOG_WARN( m ) FB.DefaultLogger( ).Warn( ).Site( FB_LOG_SITE ).Msg( m )
#else
	#define FB_LOG_WARN( m )
#endif

#if FB_LOG_MIN_LEVEL <= 50
	#define FB_LOG_ERROR( m ) FB.DefaultLogger( ).Error( ).Site( FB_LOG_SITE ).Msg( m )
#else
	#define FB_LOG_ERROR( m )
#endif

#if FB_LOG_MIN_LEVEL <= 60
	#define FB_LOG_FATAL( m ) FB.DefaultLogger( ).Fatal( ).Site( FB_LOG_SITE ).Msg( m )
#else
	#define FB_LOG_FATAL( m )
#endif

'' --------------------------------------------------------------- the field form
''
''     FB_LOG_EVENT_WARN( Str( "path", p ).Int_( "code", c ), "write failed" )
''
'' The first argument is the builder chain WITHOUT its leading dot; the macro
'' supplies it. The commas inside the chain's own parentheses do not split the
'' macro's arguments.
#if FB_LOG_MIN_LEVEL <= 10
	#define FB_LOG_EVENT_TRACE( fields, m ) FB.DefaultLogger( ).Trace( ).Site( FB_LOG_SITE ).fields.Msg( m )
#else
	#define FB_LOG_EVENT_TRACE( fields, m )
#endif

#if FB_LOG_MIN_LEVEL <= 20
	#define FB_LOG_EVENT_DEBUG( fields, m ) FB.DefaultLogger( ).Debug( ).Site( FB_LOG_SITE ).fields.Msg( m )
#else
	#define FB_LOG_EVENT_DEBUG( fields, m )
#endif

#if FB_LOG_MIN_LEVEL <= 30
	#define FB_LOG_EVENT_INFO( fields, m ) FB.DefaultLogger( ).Info( ).Site( FB_LOG_SITE ).fields.Msg( m )
#else
	#define FB_LOG_EVENT_INFO( fields, m )
#endif

#if FB_LOG_MIN_LEVEL <= 40
	#define FB_LOG_EVENT_WARN( fields, m ) FB.DefaultLogger( ).Warn( ).Site( FB_LOG_SITE ).fields.Msg( m )
#else
	#define FB_LOG_EVENT_WARN( fields, m )
#endif

#if FB_LOG_MIN_LEVEL <= 50
	#define FB_LOG_EVENT_ERROR( fields, m ) FB.DefaultLogger( ).Error( ).Site( FB_LOG_SITE ).fields.Msg( m )
#else
	#define FB_LOG_EVENT_ERROR( fields, m )
#endif

#if FB_LOG_MIN_LEVEL <= 60
	#define FB_LOG_EVENT_FATAL( fields, m ) FB.DefaultLogger( ).Fatal( ).Site( FB_LOG_SITE ).fields.Msg( m )
#else
	#define FB_LOG_EVENT_FATAL( fields, m )
#endif
