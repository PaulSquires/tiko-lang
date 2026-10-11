'' main.bas -- tiko-lang entry point.
''
'' Deliberately trivial: collect the argument vector and hand it to the driver. Every
'' decision, including how to fail, belongs to Driver.Run so that the whole compiler is
'' reachable in-process from the test runner and from a fuzz harness.

#import "std/containers"
#include once "driver/driver.bi"
#include once "build/build.bi"

using Tko

dim as StrVec args

'' THE ARGUMENTS, BY COUNT AND AS UTF-8 (audit F-48, F-64). command( i ) is the ANSI code
'' page on Windows, and the compiler reads every string as UTF-8: 'tiko "ünï/hé.bas"'
'' could not open its own input where fbc builds it. And 'while len( command( i ) ) > 0'
'' stopped at the first EMPTY argument -- 'tiko "" a.bas' compiled nothing; fbc skips it.
#ifdef __FB_WIN32__
    extern "windows"
        declare function W_GetCommandLineW_ alias "GetCommandLineW" ( ) as wstring ptr
        declare function W_CommandLineToArgvW_ alias "CommandLineToArgvW" _
            ( byval cmd as wstring ptr, byval argc as long ptr ) as wstring ptr ptr
        declare function W_LocalFree_ alias "LocalFree" ( byval h as any ptr ) as any ptr
        declare function W_WideCharToMultiByte_ alias "WideCharToMultiByte" _
            ( byval cp as ulong, byval flags as ulong, byval src as wstring ptr, byval srcLen as long, _
              byval dst as zstring ptr, byval dstLen as long, byval def_ as zstring ptr, _
              byval usedDef as long ptr ) as long
    end extern
    #inclib "shell32"
    dim as long wargc = 0
    dim as wstring ptr ptr wargv = W_CommandLineToArgvW_( W_GetCommandLineW_( ), @wargc )
    if wargv <> 0 then
        for i as long = 1 to wargc - 1
            dim as long need = W_WideCharToMultiByte_( 65001, 0, wargv[i], -1, 0, 0, 0, 0 )
            dim as string u8 = space( iif( need > 0, need - 1, 0 ) )
            if need > 1 then W_WideCharToMultiByte_( 65001, 0, wargv[i], -1, strptr( u8 ), need, 0, 0 )
            if len( u8 ) > 0 then args.Push( u8 )   '' an EMPTY argument is skipped, as fbc skips it
        next
        W_LocalFree_( wargv )
    else
        for i as long = 1 to __FB_ARGC__ - 1
            if len( *__FB_ARGV__[i] ) > 0 then args.Push( *__FB_ARGV__[i] )
        next
    end if
#else
    for i as long = 1 to __FB_ARGC__ - 1
        if len( *__FB_ARGV__[i] ) > 0 then args.Push( *__FB_ARGV__[i] )
    next
#endif

'' THE COMPILER RUNS ON A 1 GB STACK. Every stage recurses over the tree, and on the 2 MB
'' main stack 200 nested IFs, a 3,000-term '+' chain or 1,000 nested parentheses crashed
'' with 0xC0000005 and no diagnostic (F-46). 64 MB stopped at ~20,000 terms, below fbc's
'' 25,000 '+' and its 50,000+ '&' (audit Phase 5); 1 GB took a 200,000-term chain. A
'' thread is the one portable way to choose the size -- Linux gives the main thread
'' whatever ulimit says -- and the size is RESERVED, not committed: on Windows
'' threadcreate COMMITS its whole stack (1 GB of commit charge per compile, measured),
'' so CreateThread is called with STACK_SIZE_PARAM_IS_A_RESERVATION; Linux maps it lazily.
'' Should the thread not start, the compile runs here as it always did.
const BIG_STACK_ as uinteger = 1024ull * 1024 * 1024
type RunJob_
    as StrVec ptr args
    as long rc
end type

private sub RunOnBigStack_( byval p as any ptr )
    dim as RunJob_ ptr j = p
    j->rc = Tko.Build.Entry( *j->args )
end sub

dim as RunJob_ job
job.args = @args
#ifdef __FB_WIN32__
    extern "Windows"
        declare function CreateThread_ alias "CreateThread" ( byval attrs as any ptr, byval stackSize as uinteger, _
            byval start as function( byval as any ptr ) as ulong, byval param as any ptr, _
            byval flags as ulong, byval tid as ulong ptr ) as any ptr
        declare function WaitForSingleObject_ alias "WaitForSingleObject" ( byval h as any ptr, byval ms as ulong ) as ulong
        declare function CloseHandle_ alias "CloseHandle" ( byval h as any ptr ) as long
    end extern
    private function BigStackEntry_ stdcall( byval p as any ptr ) as ulong
        RunOnBigStack_( p )
        return 0
    end function
    dim as any ptr wth = CreateThread_( 0, BIG_STACK_, @BigStackEntry_, @job, &h00010000, 0 )
    if wth = 0 then end Tko.Build.Entry( args )
    WaitForSingleObject_( wth, &hFFFFFFFFul )
    CloseHandle_( wth )
#else
    dim as any ptr th = threadcreate( @RunOnBigStack_, @job, BIG_STACK_ )
    if th = 0 then end Tko.Build.Entry( args )
    threadwait( th )
#endif
end job.rc
