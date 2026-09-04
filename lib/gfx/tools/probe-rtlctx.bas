'' probe-rtlctx.bas -- prove the generated FB_RTLIB_CTX offsets point at the
'' real fields, not at plausible-looking garbage.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' A wrong offset still compiles and still reads SOMETHING. The only honest
'' check is behavioural: drive the REAL gfxlib2 through a state change we know
'' must move those fields, and watch them move.
''
''   1. before any SCREEN   -- the hook table must be all zero
''   2. after SCREENRES     -- gfxlib2 installs 28 hooks; the table must be
''                             populated and exit_gfxlib2 must be set
''   3. after SCREEN 0      -- gfxlib2 memsets the table; back to all zero
''
'' Garbage cannot pass all three: step 1 rules out a live region that merely
'' looks non-zero, and step 3 rules out one that is merely constant.
''
'' NOTE: once a graphics screen is open, PRINT is routed through the graphics
'' console hooks into the framebuffer and never reaches stdout. Results go to a
'' file, and the summary is printed only after SCREEN 0.

#include once "../abi/rtlctx.bi"
#include once "fbgfx.bi"

using TkoAbi
using FB

'' How many of the 28 hook slots are non-NULL right now.
function LiveHooks( ) as long
    dim as any ptr ptr h = cptr( any ptr ptr, RtlHooks( ) )
    dim as long n = 0
    for i as integer = 0 to 27
        if h[i] <> 0 then n += 1
    next
    return n
end function

dim as long before_ = LiveHooks( )

dim as long ok_res = screenres( 64, 32, 32, 1, GFX_NULL )
dim as long during = LiveHooks( )
dim as any ptr ptr hp = cptr( any ptr ptr, RtlHooks( ) )
dim as long first_set  = iif( hp[0] <> 0, 1, 0 )   '' inkeyproc    -- installed
dim as long last_clear = iif( hp[27] <> 0, 1, 0 )  '' posteventproc -- not
dim as any ptr exitcb = *RtlExitGfxSlot( )

screen 0
dim as long after_ = LiveHooks( )

dim as long failures = 0
print "rtlctx probe -- hooks at offset "; RTLCTX_HOOKS_OFS; _
      ", exit_gfxlib2 at "; RTLCTX_EXITGFX_OFS

print "  before SCREEN : "; before_; " / 28 hooks live";
if before_ = 0 then print "   ok" else print "   FAIL (expected 0)": failures += 1

print "  after SCREENRES: "; during; " / 28 hooks live";
if during = 27 then print "   ok" else print "   FAIL (expected exactly 27)": failures += 1

'' A THRESHOLD IS NOT ENOUGH. Shifting the offset by one pointer slides the whole
'' table down a slot: the count stays 27 and a ">= 20" test passes. Measured --
'' offset 64 instead of 72 gave a false PASS. So check the SHAPE too: slot 0
'' (inkeyproc) is installed and slot 27 (posteventproc) is not, under GFX_NULL.
'' A shift in either direction breaks exactly one of those.
print "  slot 0 set, slot 27 clear";
if first_set andalso (last_clear = 0) then
    print "   ok"
else
    print "   FAIL (table is shifted)"
    failures += 1
end if

print "  after SCREEN 0 : "; after_; " / 28 hooks live";
if after_ = 0 then print "   ok" else print "   FAIL (expected 0)": failures += 1

print "  exit_gfxlib2   : ";
if exitcb <> 0 then print "set   ok" else print "NULL  FAIL": failures += 1

if failures = 0 then
    print "rtlctx probe: PASS -- the generated offsets address the real fields"
    end 0
else
    print "rtlctx probe: FAIL -- "; failures; " check(s) failed"
    end 1
end if
