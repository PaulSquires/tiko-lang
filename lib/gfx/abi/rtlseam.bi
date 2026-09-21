'' rtlseam.bi -- the runtime services libtkogfx calls INTO.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' rtlctx.bi reaches runtime STATE; this file declares runtime FUNCTIONS: the
'' per-thread context slot, the graphics mutex, and error reporting. Between the
'' two, they are the whole of the seam -- everything else libtkogfx does is its
'' own code.
''
'' CALLING CONVENTION. The runtime declares these FBCALL, which is __stdcall on
'' win32 and the default elsewhere. FreeBASIC's EXTERN "windows" is exactly that
'' mapping, and fbc applies the @N decoration itself. Verified against the
'' shipped libraries:
''
''   win64   fb_TlsGetCtx        fb_ErrorSetNum        fb_GraphicsLock
''   win32   _fb_TlsGetCtx@12    _fb_ErrorSetNum@4     _fb_GraphicsLock@0
''
'' The TLS destructor is NOT FBCALL -- it is a plain C function-pointer typedef,
'' `void (*)(void *)`, so it is declared CDECL. Getting that backwards would
'' corrupt the stack on win32 only, which is the worst way to find out.

#pragma once

#include once "rtlabi.bi"

namespace TkoAbi

'' Runtime error codes, in the runtime's enum order. Only the ones this library
'' can actually raise are listed; the enum continues past these.
const FB_RTERROR_OK                  = 0
const FB_RTERROR_ILLEGALFUNCTIONCALL = 1
const FB_RTERROR_FILENOTFOUND        = 2
const FB_RTERROR_FILEIO              = 3
const FB_RTERROR_OUTOFMEM            = 4
const FB_RTERROR_ILLEGALRESUME       = 5
const FB_RTERROR_OUTOFBOUNDS         = 6
const FB_RTERROR_NULLPTR             = 7

'' The TLS slot index the runtime reserves for graphics. Measured, not assumed:
'' it is position 4 in the runtime's FB_TLSKEY enum, and abi/offsets/*.txt
'' records the value the gate re-checks.
const FB_TLSKEY_GFX = 4

type FB_TLS_DESTRUCTOR as sub cdecl ( byval tlsData as any ptr )

end namespace

'' Declared outside the namespace: fbc mangles namespaced externs and ALIAS does
'' not override that. Same reason as RtlCtxBase in rtlctx.bi.
'' NOTE: the FB identifiers are Rtl*, not fb_*. An fbc built-in RTL identifier
'' cannot be redeclared -- `declare sub fb_ErrorSetNum` fails with error 4,
'' "Duplicated definition", because fbc already has that name in its symbol
'' table. ALIAS carries the real link name, so nothing is lost.
extern "windows"
    declare function RtlTlsGetCtx alias "fb_TlsGetCtx" ( _
        byval index as long, _
        byval length as uinteger, _
        byval destructor as TkoAbi.FB_TLS_DESTRUCTOR ) as any ptr

    declare sub RtlErrorSetNum alias "fb_ErrorSetNum" ( byval errnum as long )

    '' A TEMPORARY STRING HANDED TO AN ENTRY POINT IS THE ENTRY POINT'S TO FREE.
    '' fbc passes `windowtitle "a" & b` as a temp descriptor and never frees it
    '' itself; gfxlib2 calls fb_hStrDelTemp on it, which releases the data and
    '' the descriptor if -- and only if -- the descriptor is marked temporary.
    '' Harmless on anything else, so it is called unconditionally, as the C does.
    declare function RtlStrDelTemp alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
end extern

'' THE KEYBOARD TRANSLATION IS THE RUNTIME'S, as it is gfxlib2's: its window
'' procedure turns a key message into SCREENEVENT's scancode and ascii with these
'' two, which live in the console layer of libfb and tiko-rt alike. Declared plain
'' -- fb_private_console.h gives them no FBCALL.
extern "c"
    declare function RtlConsoleTranslateKey alias "fb_hConsoleTranslateKey" ( _
        byval ascii_char as byte, byval vs_code as ushort, byval vk_code as ushort, _
        byval control_state as ulong, byval enhanced_only as long ) as long
    declare function RtlVirtualToScancode alias "fb_hVirtualToScancode" ( _
        byval vkey as long ) as long
end extern

extern "windows"

    '' MT BUILDS ONLY. These symbols exist in libfbmt/libfbgfxmt and NOT in
    '' libfb -- in a single-threaded build the runtime's own FB_GRAPHICS_LOCK
    '' macros compile away to nothing, so there is no function to call and
    '' referencing one fails the link. Guarded below in GfxLock/GfxUnlock.
    ''
    '' THE GUARD IS `#if`, NOT `#ifdef`. __FB_MT__ is ALWAYS defined -- it is 0
    '' without -mt and non-zero with it. `#ifdef` is therefore always true, and
    '' the non-MT build emits calls to symbols that only exist in libfbmt; it
    '' compiles clean and fails at link. Measured both ways.
    #if __FB_MT__
        declare sub RtlGraphicsLock alias "fb_GraphicsLock" ( )
        declare sub RtlGraphicsUnlock alias "fb_GraphicsUnlock" ( )
    #endif
end extern

namespace TkoAbi

'' Every public entry point of this library must hold this across its body, for
'' the same reason gfxlib2 does: the drawing context, the page pointers and the
'' dirty-line array are shared, and the window runs on another thread.
''
'' In a non-MT build this is a no-op, exactly as the runtime's own macro is.
private sub GfxLock( )
    #if __FB_MT__
        RtlGraphicsLock( )
    #endif
end sub

private sub GfxUnlock( )
    #if __FB_MT__
        RtlGraphicsUnlock( )
    #endif
end sub

'' The per-thread drawing context.
''
'' The runtime owns the TLS slot and allocates the block; we supply the size and
'' a destructor, and it hands back the same pointer for the life of the thread.
'' This is the FB spelling of gfxlib2's FB_TLSGETCTX(GFX).
''
'' The destructor is called by the runtime when a thread exits. Ours has nothing
'' to free today -- the context holds no owned allocations, only borrowed
'' pointers into the screen or an image -- but the slot must still be claimed
'' with one, because that is the signature the runtime stores, and a NULL there
'' would have to stay NULL forever.
private sub GfxCtxDestructor cdecl ( byval tlsData as any ptr )
    '' Intentionally empty. If FB_GFXCTX ever gains an owned allocation, free it
    '' here -- and note this runs on the DYING thread, not the main one.
end sub

private function GetContext( ) as FB_GFXCTX ptr
    return cptr( FB_GFXCTX ptr, _
        RtlTlsGetCtx( FB_TLSKEY_GFX, sizeof( FB_GFXCTX ), @GfxCtxDestructor ) )
end function

end namespace
