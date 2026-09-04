'' abtest-blit.bas -- A/B the device blitters against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' The individual blitters are `static` in the C and not reachable by name, but
'' `fb_hGetBlitter` is exported and hands back a function POINTER. So the
'' reference's own blitter is fetched and CALLED, and its bytes compared with
'' ours for the same parameters. That tests the dispatch and the conversion
'' together: a correct blitter reached through a wrong dispatch still fails.
''
'' `device_depth` IS A PARAMETER, NOT THE MODE'S DEPTH. fb_hGetBlitter takes the
'' device format as an argument, so every combination is reachable from an
'' ordinary SCREEN without any exotic display. That is what makes 15bpp and
'' 24bpp -- formats no machine here has -- testable at all.
''
'' Covered: source depths 8, 16 and 32 (via modes and IMAGECREATE), against
'' device depths 8, 15, 16, 24 and 32, in both channel orders, over widths chosen
'' to hit every tail:
''
''   - EVEN and ODD widths, because the 15/16bpp blitters process pixels in PAIRS
''     and handle a final odd pixel separately;
''   - widths congruent to 0, 1, 2 and 3 mod 4, because 16->24 packs FOUR pixels
''     into three dwords and has both a two-pixel and a one-pixel tail;
''   - a DOUBLED SCANLINE mode, so the frame loop's `scanline_size` replication is
''     exercised rather than assumed;
''   - a partially dirty framebuffer, so rows that must be SKIPPED are, and the
''     destination still advances past them.
''
'' TWO OF THE REFERENCE'S BLITTERS ARE BUGGY AND WE REPRODUCE THEM. 8to15RGB and
'' 8to16RGB have a missing-parenthesis error and take the wrong five bits of
'' blue. This suite is what confirms that reading, and what will notice if the
'' reference is ever fixed -- at which point these stop matching and the gate
'' fails loudly rather than the divergence going unseen. See raster/blit.bi.

#include once "../raster/blit.bi"
#include once "../abi/rtlctx.bi"
#include once "../core/mode.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

type BLITTER as sub cdecl ( byval dest as ubyte ptr, byval pitch as long )
declare function fb_hGetBlitter cdecl alias "fb_hGetBlitter" ( _
    byval device_depth as long, byval is_rgb as long ) as BLITTER

dim shared as string report
dim shared as long failures = 0
dim shared as long ran = 0
dim shared as long mmxknown = 0
dim shared as long mmxpath = 0

sub chk( byref what as string, byval want as longint, byval got as longint )
    ran += 1
    if want <> got then
        report += "  MISMATCH " + what + " want " + str(want) + " got " + str(got) + chr(10)
        failures += 1
    end if
end sub

'' Bytes per destination row for a device depth. 15bpp occupies two bytes like
'' 16bpp -- it is a 16-bit container with one bit unused, not 15 bits packed.
function DevBytes( byval device_depth as long ) as long
    select case device_depth
    case 8  : return 1
    case 15 : return 2
    case 16 : return 2
    case 24 : return 3
    case 32 : return 4
    end select
    return 0
end function

'' A generous destination pitch, deliberately LARGER than the row needs, so a
'' blitter that advances by the wrong stride writes into the slack and is caught
'' rather than silently landing on the next row's start.
const SLACK = 64

dim shared as long depths(...) = { 8, 15, 16, 24, 32 }

'' Run both blitters over the same source and compare the destinations.
'' `dirty_step` sets the dirty pattern INSIDE the lock: 1 marks every row, n
'' marks every nth. Setting it outside and calling in was a residual race --
'' the presenter clears the array every 10ms, so between the two lock scopes the
'' pattern could vanish, both sides would then skip everything and AGREE, and
'' the divergence count moved between runs (145/25 one run, 144/26 the next).
'' A flaky count in a suite that still says PASS is worse than a failure.
sub Compare( byref tag as string, byref src as BlitSrc, byval srcdepth as long, _
             byval device_depth as long, byval isrgb as long, byval dirty_step as long )

    dim as BLITTER ref = fb_hGetBlitter( device_depth, isrgb )
    dim as BlitRowProc ours = BlitSelect( srcdepth, device_depth, isrgb )

    ran += 1
    if (ref = 0) andalso (ours = 0) then exit sub          '' both decline: agree
    if (ref = 0) orelse (ours = 0) then
        report += "  DISPATCH " + tag + " reference=" + str(iif(ref<>0,1,0)) + _
                  " ours=" + str(iif(ours<>0,1,0)) + chr(10)
        failures += 1
        exit sub
    end if

    '' ---- THE win32 MMX BLOCK ----
    ''
    '' fb_hGetBlitter selects an entirely different set of hand-written MMX
    '' blitters when the host is 32-bit AND scanline_size is 1 AND the width is
    '' a multiple of four:
    ''
    ''     if ((flags & X86_MMX_ENABLED) && (scanline_size == 1) && !(w & 3))
    ''         blitter = &blitter[24];
    ''
    '' Their output is NOT identical to the C blitters they replace -- measured,
    '' 26 of 170 cases differ on win32 while win64 matches exactly, and the 24bpp
    '' RGB and BGR results come back swapped. So gfxlib2 disagrees with ITSELF
    '' across the two targets here, the same way it does for CIRCLE arcs and
    '' PMAP under x87 excess precision.
    ''
    '' tiko rejects inline asm by policy (TKO0407) and obj/win64 ships no
    '' *_mmx.o at all, so there is no MMX path to match. These cases are counted
    '' as a KNOWN TARGET DIVERGENCE rather than silently skipped, and every case
    '' outside the condition must still match exactly on win32 -- which is what
    '' keeps this from becoming a blanket excuse.
    #ifndef __FB_64BIT__
        if (src.scanline_size = 1) andalso ((src.w and 3) = 0) then
            mmxpath += 1
        end if
    #endif

    dim as long rowbytes = src.w * DevBytes( device_depth )
    dim as long pitch = rowbytes + SLACK
    dim as long rows = src.h * src.scanline_size
    dim as integer total = cast( integer, pitch ) * rows

    dim as ubyte ptr a = callocate( total )
    dim as ubyte ptr b = callocate( total )
    memset( a, &hCD, total )
    memset( b, &hCD, total )

    '' HOLD THE SCREEN LOCK ACROSS BOTH CALLS.
    ''
    '' gfxlib2's presenter thread runs every 10ms and CLEARS the dirty array at
    '' the end of each frame. Both blitters read that array, so without the lock
    '' the reference can blit a row and the presenter can clear it before we
    '' reach it -- our side then skips the row and the destination keeps the
    '' fill byte. That showed up as three failures out of fifty, at different
    '' rows on each run, which is the signature of a race rather than a
    '' conversion bug.
    ''
    '' SCREENLOCK takes the same critical section the presenter does.
    screenlock
    if src.dirty <> 0 then
        for y as integer = 0 to src.h - 1
            src.dirty[y] = iif( (y mod dirty_step) = 0, 1, 0 )
        next
    end if
    ref( a, pitch )
    BlitFrame( src, b, pitch, ours )
    screenunlock

    dim as long differs = iif( memcmp( a, b, total ) <> 0, 1, 0 )

    #ifndef __FB_64BIT__
        '' inside the MMX condition, a difference is expected -- but an
        '' AGREEMENT there is fine too and is not counted
        if differs andalso (src.scanline_size = 1) andalso ((src.w and 3) = 0) then
            mmxknown += 1
            deallocate( a )
            deallocate( b )
            exit sub
        end if
    #endif

    if differs then
        '' locate the first difference, so the report says WHERE
        dim as long at = -1
        for i as integer = 0 to total - 1
            if a[i] <> b[i] then at = i : exit for
        next
        report += "  MISMATCH " + tag + " first differing byte " + str(at) + _
                  " (row " + str(at \ pitch) + " col " + str(at mod pitch) + ")" + _
                  " ref=" + hex(a[at],2) + " ours=" + hex(b[at],2) + chr(10)
        failures += 1
    end if

    deallocate( a )
    deallocate( b )
end sub

'' ---- 8bpp sources, from real legacy modes ----
''
'' Mode 13 is 320x200 with scanline_size 1; mode 11 is 640x480. A doubled
'' scanline mode is added below for the replication path.
dim as long modes(...) = { 13, 11, 1, 9 }

for mi as integer = 0 to ubound( modes )
    dim as long mode = modes(mi)
    if ModeSupported( mode ) = 0 then continue for

    screen mode
    dim as long sw, sh, sdepth, sbpp, spitch, srr
    screeninfo sw, sh, sdepth, sbpp, spitch, srr

    '' something with structure in it, and every palette index exercised
    for y as integer = 0 to sh - 1
        for x as integer = 0 to sw - 1
            pset (x, y), (x * 7 + y * 13) and &hFF
        next
    next

    '' BOTH SIDES MUST READ THE SAME DIRTY ARRAY.
    ''
    '' The reference reads `__fb_gfx->dirty` and skips every clean row. Passing
    '' null here and letting our frame loop treat that as "all dirty" made 40 of
    '' 50 cases fail with the reference having written NOTHING -- its array had
    '' been cleared, so it skipped everything while we blitted everything. The
    '' comparison was between two different questions.
    ''
    '' So the real array is reached through the ABI seam and driven explicitly.
    dim as TkoAbi.FBGFX ptr g = cast( TkoAbi.FBGFX ptr, RtlGfxState )
    if g = 0 then
        report += "  SETUP: __fb_gfx is null on mode " + str(mode) + chr(10)
        failures += 1
        screen 0
        continue for
    end if
    dim as ubyte ptr dirty = cast( ubyte ptr, g->dirty )

    dim as BlitSrc s
    s.pixels        = cptr( ubyte ptr, screenptr( ) )
    s.pitch         = spitch
    s.w             = sw
    s.h             = sh
    s.scanline_size = g->scanline_size
    s.dirty         = dirty
    dim as ulong conv(0 to 511)
    s.conv          = @conv(0)

    '' THE DEVICE PALETTE COMES FROM THE SEAM, NOT FROM PALETTE GET.
    ''
    '' PALETTE GET masks its index to the mode's palette size, so on a 2-colour
    '' mode it answers for index 200 as though it were index 0. The blitter does
    '' NOT mask -- it indexes device_palette directly with whatever byte is in
    '' the framebuffer, and entries past the palette size are zero. Rebuilding
    '' the array through PALETTE GET therefore disagrees with the reference for
    '' every out-of-range index, which is what made mode 11 fail from the second
    '' pixel on. Read the actual array.
    s.palette = g->device_palette

    for di as integer = 0 to ubound( depths )
        for isrgb as integer = 0 to 1
            '' fb_hGetBlitter POPULATES the 16->32 table as a side effect of the
            '' call, so ours is rebuilt with the same flag before every compare.
            BlitConvInit( s.conv, isrgb )
            Compare( "m" + str(mode) + " dev" + str(depths(di)) + " rgb" + str(isrgb), _
                     s, sdepth, depths(di), isrgb, 1 )
        next
    next

    screen 0
next

'' ---- 16bpp and 32bpp sources, at every width tail ----
''
'' The legacy SCREEN modes only reach depth 8 and are all 320 or 640 wide, so
'' the 16bpp and 32bpp blitters and EVERY tail path were unreached by the
'' section above. SCREENRES takes an arbitrary width and depth, which covers
'' both.
''
'' Widths 320..323 give w mod 4 = 0, 1, 2, 3. That matters most for 16->24,
'' which packs FOUR pixels into three dwords and then has a two-pixel tail and a
'' one-pixel tail written in a different byte order from the packed path --
'' about the only code here where reading it is not enough to be sure.
scope
    '' A DEPTH THE DRIVER DECLINES WOULD SILENTLY SKIP, so it is counted and
    '' reported as a failure -- a suite that quietly tests only 8bpp while
    '' claiming to cover 16 and 32 is the dead-branch problem again.
    dim as long covered(0 to 2)
    dim as long widths(...) = { 320, 321, 322, 323 }
    dim as long sdepths(...) = { 8, 16, 32 }

    for wi as integer = 0 to ubound( widths )
        for pi2 as integer = 0 to ubound( sdepths )
            dim as long cw = widths(wi)
            dim as long cd = sdepths(pi2)

            screenres cw, 64, cd
            dim as long sw, sh, sdp, sbp, spt, srf
            screeninfo sw, sh, sdp, sbp, spt, srf
            if sdp <> cd then
                report += "  SKIPPED res " + str(cw) + " depth " + str(cd) + _
                          " -- got depth " + str(sdp) + chr(10)
                failures += 1
                screen 0
                continue for
            end if
            covered(pi2) += 1

            '' a pattern that varies in every channel and every column
            for y as integer = 0 to sh - 1
                for x as integer = 0 to sw - 1
                    pset (x, y), iif( cd = 8, (x * 5 + y * 11) and &hFF, _
                                      rgb( (x * 7) and &hFF, (y * 13) and &hFF, (x + y) and &hFF ) )
                next
            next

            dim as TkoAbi.FBGFX ptr g2 = cast( TkoAbi.FBGFX ptr, RtlGfxState )
            if g2 = 0 then
                screen 0
                continue for
            end if

            dim as BlitSrc s2
            s2.pixels        = cptr( ubyte ptr, screenptr( ) )
            s2.pitch         = spt
            s2.w             = sw
            s2.h             = sh
            s2.scanline_size = g2->scanline_size
            s2.dirty         = cast( ubyte ptr, g2->dirty )
            s2.palette       = g2->device_palette
            dim as ulong conv2(0 to 511)
            s2.conv          = @conv2(0)

            for di as integer = 0 to ubound( depths )
                for isrgb as integer = 0 to 1
                    BlitConvInit( s2.conv, isrgb )
                    Compare( "res" + str(cw) + "x" + str(cd) + _
                             " dev" + str(depths(di)) + " rgb" + str(isrgb), _
                             s2, sdp, depths(di), isrgb, 1 )
                next
            next
            screen 0
        next
    next

    for k as integer = 0 to 2
        if covered(k) = 0 then
            report += "  NO CASES RAN at source depth " + str(sdepths(k)) + chr(10)
            failures += 1
        end if
    next
    report += "  [coverage] source depth 8/16/32 ran " + str(covered(0)) + "/" + _
              str(covered(1)) + "/" + str(covered(2)) + " width variants" + chr(10)
end scope

'' ---- a partially dirty frame ----
''
'' Clean rows must be SKIPPED and the destination must still advance past them.
'' A blitter that forgets the advance shears the image; one that forgets the
'' skip overwrites rows it should not touch. The &hCD fill makes an untouched
'' row visible.
scope
    screen 13
    dim as long sw, sh, sd, sb, sp, sr
    screeninfo sw, sh, sd, sb, sp, sr
    for y as integer = 0 to sh - 1
        for x as integer = 0 to sw - 1
            pset (x, y), (x + y * 3) and &hFF
        next
    next

    '' THE SAME DIRTY ARRAY FOR BOTH SIDES. The reference reads
    '' `__fb_gfx->dirty`; handing our own array to BlitFrame would compare two
    '' different dirty maps and every case would fail for a reason that has
    '' nothing to do with blitting. So the real one is reached through the ABI
    '' seam and the pattern written into it -- the reference then skips exactly
    '' the rows we skip.
    dim as TkoAbi.FBGFX ptr g = cast( TkoAbi.FBGFX ptr, RtlGfxState )
    if g = 0 then
        report += "  SETUP: __fb_gfx is null -- cannot share the dirty array" + chr(10)
        failures += 1
        screen 0
        end 1
    end if
    dim as ubyte ptr dirty = cast( ubyte ptr, g->dirty )

    dim as ulong pal(0 to 255), conv(0 to 511)
    for i as integer = 0 to 255
        dim as long r, g, b
        palette get i, r, g, b
        pal(i) = cast( ulong, r and &hFF ) or (cast( ulong, g and &hFF ) shl 8) or _
                 (cast( ulong, b and &hFF ) shl 16)
    next

    dim as BlitSrc s
    s.pixels = cptr( ubyte ptr, screenptr( ) )
    s.pitch = sp : s.w = sw : s.h = sh : s.scanline_size = 1
    s.dirty = dirty : s.palette = @pal(0) : s.conv = @conv(0)

    '' Re-write the pattern before each compare: the reference's blitter does
    '' not clear the dirty array, but nothing guarantees another call has not.
    for di as integer = 0 to ubound( depths )
        for isrgb as integer = 0 to 1
            BlitConvInit( s.conv, isrgb )
            Compare( "dirty dev" + str(depths(di)) + " rgb" + str(isrgb), _
                     s, sd, depths(di), isrgb, 3 )
        next
    next
    screen 0
end scope

print "abtest-blit -- "; ran; " blitter comparisons against gfxlib2"
#ifndef __FB_64BIT__
    print "abtest-blit: "; mmxknown; " known win32 MMX divergence(s) of "; mmxpath; _
          " cases that take the MMX path (gfxlib2 win32 disagrees with gfxlib2 win64)"
    '' If NO case ever took the MMX path the excuse above is inert and the
    '' suite is quietly weaker on win32 than it claims. Say so.
    if mmxpath = 0 then
        report += "  NO CASE TOOK THE MMX PATH -- the win32 divergence rule is untested" + chr(10)
        failures += 1
    end if
#endif
if failures = 0 then
    print report;
    #ifdef __FB_64BIT__
        print "abtest-blit: PASS -- every blitter and the dispatch agree"
    #else
        print "abtest-blit: PASS -- "; ran - mmxknown; " exact, "; mmxknown; _
              " known target divergence(s)"
    #endif
    end 0
else
    print report;
    print "abtest-blit: FAIL -- "; failures; " of"; ran; " differ"
    end 1
end if
