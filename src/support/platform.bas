'' platform.bas -- see platform.bi

#import "std/containers"
#include once "support/platform.bi"

#ifdef __FB_WIN32__
    '' Declared by hand rather than including windows.bi: five entry points against
    '' roughly 35,000 declarations is a compile-time difference worth having.
    extern "windows"
        declare function GetStdHandle( byval nStdHandle as ulong ) as any ptr
        declare function GetFileType( byval hFile as any ptr ) as ulong
        declare function GetConsoleMode( byval hConsole as any ptr, _
                                         byval lpMode as ulong ptr ) as long
        declare function SetConsoleMode( byval hConsole as any ptr, _
                                         byval dwMode as ulong ) as long
        declare function GetModuleHandleExW( byval flags as ulong, byval addr as any ptr, _
                                             byval hmod as any ptr ptr ) as long
        declare function GetModuleFileNameW( byval hmod as any ptr, byval buf as wstring ptr, _
                                             byval size as ulong ) as ulong
        declare function WideCharToMultiByte( byval cp as ulong, byval flags as ulong, _
            byval src as wstring ptr, byval srcLen as long, byval dst as zstring ptr, _
            byval dstLen as long, byval def_ as zstring ptr, byval usedDef as long ptr ) as long
    end extern

    const WIN_STD_OUTPUT_HANDLE as ulong = &hFFFFFFF5    '' (DWORD)-11
    const WIN_STD_ERROR_HANDLE  as ulong = &hFFFFFFF4    '' (DWORD)-12
    const WIN_FILE_TYPE_CHAR    as ulong = 2
    const WIN_ENABLE_VT         as ulong = 4             '' VIRTUAL_TERMINAL_PROCESSING
#else
    extern "c"
        declare function isatty( byval fd as long ) as long
        declare function readlink( byval path_ as zstring ptr, byval buf as zstring ptr, _
                                   byval size as uinteger ) as integer
    end extern
#endif

namespace Tko.Platform

#ifdef __FB_WIN32__
private function HandleFor( byval s as StdStream ) as any ptr
    if s = STREAM_ERR then return GetStdHandle( WIN_STD_ERROR_HANDLE )
    return GetStdHandle( WIN_STD_OUTPUT_HANDLE )
end function
#endif

function IsTerminal( byval s as StdStream ) as boolean
#ifdef __FB_WIN32__
    dim as any ptr h = HandleFor( s )
    if h = 0 then return false
    return (GetFileType( h ) = WIN_FILE_TYPE_CHAR)
#else
    dim as long fd = 1
    if s = STREAM_ERR then fd = 2
    return (isatty( fd ) <> 0)
#endif
end function

function SelfPath( ) as string
#ifdef __FB_WIN32__
    '' FROM_ADDRESS (4) of this very function, UNCHANGED_REFCOUNT (2).
    dim as any ptr hmod = 0
    if GetModuleHandleExW( 6, cast( any ptr, @SelfPath ), @hmod ) = 0 then return ""
    dim as wstring * 32768 wbuf
    dim as ulong n = GetModuleFileNameW( hmod, @wbuf, 32768 )
    if (n = 0) orelse (n >= 32768) then return ""
    dim as long need = WideCharToMultiByte( 65001, 0, @wbuf, -1, 0, 0, 0, 0 )
    if need <= 1 then return ""
    dim as string u8 = space( need - 1 )
    WideCharToMultiByte( 65001, 0, @wbuf, -1, strptr( u8 ), need, 0, 0 )
    return u8
#else
    dim as zstring * 4097 buf
    dim as integer n = readlink( "/proc/self/exe", @buf, 4096 )
    if n <= 0 then return ""
    return left( buf, n )
#endif
end function

sub EnableAnsi( )
#ifdef __FB_WIN32__
    for s as long = STREAM_OUT to STREAM_ERR
        dim as any ptr h = HandleFor( cast( StdStream, s ) )
        if h <> 0 then
            dim as ulong mode = 0
            if GetConsoleMode( h, @mode ) <> 0 then
                SetConsoleMode( h, mode or WIN_ENABLE_VT )
            end if
        end if
    next
#endif
end sub

end namespace
