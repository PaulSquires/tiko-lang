'' hooks.bi -- installing libtkogfx into the runtime's console hook table.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' The runtime routes PRINT, LOCATE, CLS, COLOR, INKEY, INPUT, LINE INPUT,
'' SLEEP, MULTIKEY, GETMOUSE, PCOPY, SCREENSET, INP/OUT, WIDTH, POS/CSRLIN and
'' SCREEN(r,c) through __fb_ctx.hooks when they are set, and through its own
'' text console when they are not. Opening a graphics screen means installing
'' this table; SCREEN 0 means clearing it.
''
'' TWO THINGS THAT ARE EASY TO GET WRONG
''
'' 1. THE HOOK CALLBACKS ARE CDECL, NOT STDCALL. The runtime's hook typedefs
''    carry no FBCALL -- `typedef void (*FB_PRINTBUFFPROC)( const void *, size_t,
''    int )` -- even though the fb_PrintBuffer that consults them IS FBCALL.
''    Confirmed against the shipped win32 libfbgfx: every hook implementation is
''    undecorated (`_fb_GfxPrintBufferEx`, no `@N`), while entry points like
''    `_fb_GfxLine@36` are decorated. Declaring these STDCALL would corrupt the
''    stack on win32 only.
''
'' 2. NO MODULE-LEVEL CODE, NO GLOBAL DESTRUCTORS. Installation is an explicit
''    call, and teardown is the runtime's exit_gfxlib2 callback, because the
''    win32 backends run the window on a background thread: a module destructor
''    or atexit handler runs under the loader lock, and joining that thread there
''    deadlocks. gfxlib2 solves it the same way and says so in its own source.
''    RFC-0001 makes this a rule for the whole library.

#pragma once

#include once "../abi/rtlabi.bi"
#include once "../abi/rtlctx.bi"

namespace TkoGfx

'' The signatures the runtime will call us through. CDECL -- see above.
type FB_INKEYPROC      as function cdecl ( ) as any ptr
type FB_GETKEYPROC     as function cdecl ( ) as long
type FB_KEYHITPROC     as function cdecl ( ) as long
type FB_CLSPROC        as sub cdecl ( byval mode as long )
type FB_COLORPROC      as function cdecl ( byval fc as ulong, byval bc as ulong, byval flags as long ) as ulong
type FB_LOCATEPROC     as function cdecl ( byval row as long, byval col as long, byval cursor as long ) as long
type FB_WIDTHPROC      as function cdecl ( byval cols as long, byval rows as long ) as long
type FB_GETXPROC       as function cdecl ( ) as long
type FB_GETXYPROC      as sub cdecl ( byval col as long ptr, byval row as long ptr )
type FB_GETSIZEPROC    as sub cdecl ( byval cols as long ptr, byval rows as long ptr )
type FB_PRINTBUFFPROC  as sub cdecl ( byval buffer as const any ptr, byval length as uinteger, byval mask as long )
type FB_READSTRPROC    as function cdecl ( byval buffer as zstring ptr, byval length as integer ) as zstring ptr
type FB_MULTIKEYPROC   as function cdecl ( byval scancode as long ) as long
type FB_GETMOUSEPROC   as function cdecl ( byval x as long ptr, byval y as long ptr, byval z as long ptr, byval buttons as long ptr, byval clip as long ptr ) as long
type FB_SETMOUSEPROC   as function cdecl ( byval x as long, byval y as long, byval cursor as long, byval clip as long ) as long
type FB_VIEWUPDATEPROC as sub cdecl ( )
type FB_READXYPROC     as function cdecl ( byval col as long, byval row as long, byval colorflag as long ) as ulong
type FB_SLEEPPROC      as sub cdecl ( byval msecs as long )
type FB_ISREDIRPROC    as function cdecl ( byval is_input as long ) as long
type FB_PAGECOPYPROC   as function cdecl ( byval src as long, byval dst as long ) as long
type FB_PAGESETPROC    as function cdecl ( byval active as long, byval visible as long ) as long

'' Install a hook table. The runtime keeps the VALUES, not the pointer, so the
'' caller's table need not outlive this call.
''
'' Not guarded by the graphics lock here: gfxlib2 installs under the runtime's
'' own FB_LOCK, and the caller (mode setup) is the right place to hold it.
private sub HooksInstall( byval src as TkoAbi.FB_HOOKSTB ptr )
    if src = 0 then exit sub
    *TkoAbi.RtlHooks( ) = *src
end sub

'' Clear the table, handing the console back to the runtime. This is what
'' SCREEN 0 does.
private sub HooksClear( )
    dim as TkoAbi.FB_HOOKSTB empty
    *TkoAbi.RtlHooks( ) = empty
end sub

'' How many hooks are currently live. Diagnostic; also what the gate asserts.
private function HooksLive( ) as long
    dim as any ptr ptr h = cptr( any ptr ptr, TkoAbi.RtlHooks( ) )
    dim as long n = 0
    for i as integer = 0 to 27
        if h[i] <> 0 then n += 1
    next
    return n
end function

'' The teardown callback fb_End() invokes. Setting this is how the library gets
'' torn down at exit WITHOUT a global destructor -- see the note at the top.
private sub SetExitHook( byval fn as any ptr )
    *TkoAbi.RtlExitGfxSlot( ) = fn
end sub

private function GetExitHook( ) as any ptr
    return *TkoAbi.RtlExitGfxSlot( )
end function

end namespace
