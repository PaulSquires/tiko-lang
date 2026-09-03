'' probe-rtlseam.bas -- prove we share gfxlib2's per-thread context, not a copy.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' fb_TlsGetCtx( FB_TLSKEY_GFX, ... ) must hand back THE SAME block gfxlib2 is
'' using. If the slot index were wrong we would get a different slot; if
'' FB_GFXCTX's size were wrong the runtime would allocate the wrong length; if
'' the field offsets were wrong we would read the right block at the wrong
'' places. All three are invisible to the compiler and all three corrupt memory
'' later, so the check is behavioural:
''
''   open a 320x200x32 screen, draw something to force gfxlib2 to populate its
''   context, then read that context through OUR mirror and see the screen's own
''   geometry come back.
''
'' 320/200/4 cannot appear by accident in a wrong slot.
''
'' PRINT is routed into the framebuffer while a graphics screen is open, so all
'' reporting happens after SCREEN 0.

#include once "../abi/rtlseam.bi"
#include once "fbgfx.bi"

using TkoAbi
using FB

screenres 320, 200, 32, 1, GFX_NULL

'' Force the context to be built and the viewport to be set.
pset ( 10, 10 ), rgb( 255, 0, 0 )

dim as FB_GFXCTX ptr ctx = GetContext( )

dim as long got_null   = iif( ctx = 0, 1, 0 )
dim as long got_bpp    = -1
dim as long got_view_w = -1
dim as long got_view_h = -1
dim as long got_maxh   = -1

if ctx <> 0 then
    got_bpp    = ctx->target_bpp
    got_view_w = ctx->view(2)
    got_view_h = ctx->view(3)
    got_maxh   = ctx->max_h
end if

'' The lock is a no-op in a non-MT build; here we only check it links and runs.
GfxLock( )
GfxUnlock( )

screen 0

dim as long failures = 0

sub Check( byref what as string, byval got as long, byval want as long, byref fails as long )
    print "  "; what; " = "; got;
    if got = want then
        print "   ok"
    else
        print "   FAIL (expected "; want; ")"
        fails += 1
    end if
end sub

print "rtlseam probe -- TLS slot "; FB_TLSKEY_GFX; ", sizeof(FB_GFXCTX) = "; sizeof( FB_GFXCTX )

if got_null then
    print "  GetContext() returned NULL   FAIL"
    failures += 1
else
    print "  GetContext() non-NULL   ok"
    Check( "target_bpp", got_bpp,    4,   failures )   '' 32bpp -> 4 bytes/pixel
    Check( "view_w    ", got_view_w, 320, failures )
    Check( "view_h    ", got_view_h, 200, failures )
    Check( "max_h     ", got_maxh,   200, failures )
end if

print "  GfxLock/GfxUnlock linked and ran   ok"

if failures = 0 then
    print "rtlseam probe: PASS -- we share gfxlib2's context through the real TLS slot"
    end 0
else
    print "rtlseam probe: FAIL -- "; failures; " check(s) failed"
    end 1
end if
