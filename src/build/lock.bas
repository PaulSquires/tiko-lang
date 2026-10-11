'' lock.bas -- see lock.bi.

#import "std/containers"
#include once "build/lock.bi"

#ifdef __FB_WIN32__
    extern "windows"
        declare function W_CreateFileW_ alias "CreateFileW" _
            ( byval name_ as wstring ptr, byval access_ as ulong, byval share as ulong, _
              byval sec as any ptr, byval disp as ulong, byval flags as ulong, _
              byval tmpl as any ptr ) as any ptr
        declare function W_CloseHandle_ alias "CloseHandle" ( byval h as any ptr ) as long
        declare function W_GetLastError_ alias "GetLastError" ( ) as ulong
        declare function W_MultiByteToWideChar_ alias "MultiByteToWideChar" _
            ( byval cp as ulong, byval flags as ulong, byval src as zstring ptr, byval srcLen as long, _
              byval dst as wstring ptr, byval dstLen as long ) as long
    end extern
#else
    extern "C"
        declare function C_open_ alias "open" ( byval p as zstring ptr, byval flags as long, ... ) as long
        declare function C_flock_ alias "flock" ( byval fd as long, byval op as long ) as long
        declare function C_close_ alias "close" ( byval fd as long ) as long
        declare function C_unlink_ alias "unlink" ( byval p as zstring ptr ) as long
    end extern
#endif

namespace Tko.Build

function TakeLock( byref lk as BuildLock, byref path_ as string ) as LockResult
    lk.h = -1
    lk.path_ = path_
    #ifdef __FB_WIN32__
        '' UTF-8 to UTF-16: the path may hold anything a source path holds.
        dim as long n = W_MultiByteToWideChar_( 65001, 0, strptr( path_ ), -1, 0, 0 )
        if n <= 0 then return LOCK_UNAVAILABLE
        dim as wstring ptr w = callocate( ( n + 1 ) * 2 )
        W_MultiByteToWideChar_( 65001, 0, strptr( path_ ), -1, w, n )
        '' GENERIC_WRITE, share NOTHING, CREATE_ALWAYS, FILE_FLAG_DELETE_ON_CLOSE. A second
        '' open while this handle lives is a sharing violation (32), or access denied (5)
        '' for a file already marked for deletion: both mean another build has it.
        dim as any ptr h = W_CreateFileW_( w, &h40000000ul, 0, 0, 2, &h04000080ul, 0 )
        dim as ulong le = W_GetLastError_( )
        deallocate( w )
        if h = cast( any ptr, -1 ) then
            if ( le = 32 ) orelse ( le = 5 ) then return LOCK_BUSY
            return LOCK_UNAVAILABLE
        end if
        lk.h = cast( longint, h )
        return LOCK_TAKEN
    #else
        '' O_RDWR | O_CREAT, 0644; then LOCK_EX | LOCK_NB, which fails at once when held.
        dim as long fd = C_open_( strptr( path_ ), &h42, &o644 )
        if fd < 0 then return LOCK_UNAVAILABLE
        if C_flock_( fd, 2 or 4 ) <> 0 then
            C_close_( fd )
            return LOCK_BUSY
        end if
        lk.h = fd
        return LOCK_TAKEN
    #endif
end function

sub ReleaseLock( byref lk as BuildLock )
    if lk.h = -1 then return
    #ifdef __FB_WIN32__
        W_CloseHandle_( cast( any ptr, lk.h ) )      '' and the file goes with it
    #else
        '' Unlinked while still held, so no build can lock a name this one is about to drop.
        C_unlink_( strptr( lk.path_ ) )
        C_close_( cast( long, lk.h ) )
    #endif
    lk.h = -1
end sub

end namespace
