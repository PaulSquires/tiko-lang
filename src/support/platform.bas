'' platform.bas -- see platform.bi

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
    end extern

    const WIN_STD_OUTPUT_HANDLE as ulong = &hFFFFFFF5    '' (DWORD)-11
    const WIN_STD_ERROR_HANDLE  as ulong = &hFFFFFFF4    '' (DWORD)-12
    const WIN_FILE_TYPE_CHAR    as ulong = 2
    const WIN_ENABLE_VT         as ulong = 4             '' VIRTUAL_TERMINAL_PROCESSING
#else
    extern "c"
        declare function isatty( byval fd as long ) as long
    end extern
#endif

namespace Fbx.Platform

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
