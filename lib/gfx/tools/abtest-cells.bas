'' abtest-cells.bas -- A/B the character-cell plane against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' The cell plane is what SCREEN(row, col) reads. It is not derivable from
'' pixels -- a cell records the character and the colours it was printed with,
'' and survives being drawn over -- so it is compared by driving the statements
'' on both sides and reading the plane back.
''
'' What is covered:
''
''   1. THE INITIAL STATE, including the uneven one. A fresh screen clears only
''      the WORK page to spaces; every other page keeps ch = 0. Both are read.
''
''   2. SCREEN(row, col) AFTER PRINTING, over the full text grid, including the
''      four corners and every out-of-range direction (0, text_w + 1, negative).
''
''   3. THE COLOUR FORMS -- colorflag 1 and 2 -- at 4bpp, 8bpp and 16bpp, which
''      are three different packings. The 16bpp one expands 5-6-5 to 8-8-8 by
''      BIT REPLICATION, so colours are chosen with non-zero low bits; a
''      shift-only implementation agrees on everything else.
''
''   4. SCREEN() READS THE WORK PAGE, not the visible one. Verified by writing
''      different text to two pages and flipping which is which.
''
''   5. WIDTH's packed return, its pure-query form, and its SILENT NO-OP for an
''      unsupported size -- which returns exactly what a successful call returns.
''
''   6. PCOPY. The cells copy for the whole page even when a VIEW clips the
''      pixel copy, so the two planes are left disagreeing on purpose and both
''      are checked.
''
''   7. SCREENSET's packed return, whose packing is 8 bits apart where WIDTH's
''      is 16. Asserted, not compared -- FB discards it.
''
'' POS and CSRLIN are compared as part of 2: they are the cursor half of the
'' same state, and PRINT advances them.

#include once "../core/cells.bi"
#include once "../raster/pixelfmt.bi"
#include once "fbgfx.bi"

using TkoGfx
using FB

dim shared as string report
dim shared as long failures = 0
dim shared as long ran = 0

sub chk( byref what as string, byval want as longint, byval got as longint )
    ran += 1
    if want <> got then
        report += "  MISMATCH " + what + " want " + str(want) + " got " + str(got) + chr(10)
        failures += 1
    end if
end sub

'' Mirror of the reference's own text geometry for a mode.
'' Counts how many modes actually gave us two pages. If none did, every
'' multi-page check silently vanished and the suite would still report PASS --
'' so that is made a failure rather than a quiet skip.
dim shared as long twopage_modes = 0

dim as long modes(...) = { 13, 9, 11, 1, 18 }

for mi as integer = 0 to ubound( modes )
    dim as long mode = modes(mi)
    if ModeSupported( mode ) = 0 then continue for

    '' TWO PAGES. The argument order is SCREEN mode, depth, num_pages, flags --
    '' `screen mode, , 0, 1` asks for ZERO pages and a flag, not two pages, and
    '' every multi-page check below then runs against a single page and agrees
    '' with the wrong thing.
    screen mode, , 2
    dim as long sw, sh, sdepth, sbpp, spitch, srr
    screeninfo sw, sh, sdepth, sbpp, spitch, srr

    dim as long tw, th
    tw = loword( width( ) )
    th = hiword( width( ) )

    dim as string tag = "m" + str(mode) + " "

    '' ---- 1. initial state, both pages ----
    dim as CellPlane cp
    '' fg/bg after SCREEN are the mode defaults; read them from the reference
    '' rather than assuming, since the legacy COLOR rules differ per mode.
    dim as ulong dfg = cast( ulong, screen( 1, 1, 1 ) )
    if sdepth <= 4 then
        dfg = dfg and &hF
    elseif sdepth <= 8 then
        dfg = dfg and &hFF
    end if
    dim as ulong dbg
    if sdepth <= 4 then
        dbg = (cast( ulong, screen( 1, 1, 1 ) ) shr 4) and &hF
    elseif sdepth <= 8 then
        dbg = (cast( ulong, screen( 1, 1, 1 ) ) shr 8) and &hFF
    else
        dbg = cast( ulong, screen( 1, 1, 2 ) )
    end if

    if CellsReset( cp, tw, th, 2, 0, dfg, dbg ) = 0 then
        report += "  SETUP FAILED " + tag + chr(10)
        failures += 1
        screen 0
        continue for
    end if

    chk( tag + "init page0 ch", screen( 1, 1, 0 ), _
         CellReadXY( cp, 0, sdepth, 1, 1, 0 ) )

    '' DOES THIS MODE ACTUALLY HAVE TWO PAGES? A mode that cannot allocate them
    '' silently keeps one, and every page check below would then compare page 0
    '' against itself and pass. Probed rather than assumed: write a marker to
    '' page 1 and see whether page 0 escaped it.
    dim as long twopage = 0
    screenset 1, 0
    locate 1, 1, 0
    print "@";
    screenset 0, 0
    if screen( 1, 1, 0 ) <> asc( "@" ) then
        twopage = 1
        twopage_modes += 1
    end if
    screen mode, , 2      '' undo the probe

    if twopage then
        '' page 1 is calloc'd and never cleared -- ch = 0, not 32
        screenset 1, 0
        chk( tag + "init page1 ch (uncleared)", screen( 1, 1, 0 ), _
             CellReadXY( cp, 1, sdepth, 1, 1, 0 ) )
        screenset 0, 0
    end if

    '' ---- 2 + 3. print, then read the grid back ----
    dim as long fgv(...) = { 1, 2, 7, 12, 15 }
    dim as string txt = "Ab9 ~"

    for k as integer = 0 to 4
        dim as long r = 1 + (k * 3) mod th
        dim as long c = 1 + (k * 5) mod (tw - len( txt ))
        dim as long f = fgv(k mod 5)
        dim as long b = fgv((k + 2) mod 5)

        color f, b
        locate r, c, 0
        print txt;

        '' mirror it into our plane
        dim as ulong mfg, mbg
        if sdepth <= 8 then
            '' the legacy COLOR rules already verified in raster/color.bi apply;
            '' take the effective values from the reference rather than
            '' re-deriving them here, since this file is about CELLS
            mfg = cast( ulong, screen( r, c, 1 ) )
            if sdepth <= 4 then
                mbg = (mfg shr 4) and &hF : mfg = mfg and &hF
            else
                mbg = (mfg shr 8) and &hFF : mfg = mfg and &hFF
            end if
        else
            mfg = cast( ulong, screen( r, c, 1 ) )
            mbg = cast( ulong, screen( r, c, 2 ) )
        end if

        for i as integer = 0 to len( txt ) - 1
            dim as CharCell ptr cell = CellAt( cp, 0, c - 1 + i, r - 1 )
            if cell <> NULL then
                cell->ch = txt[i]
                '' store the RAW attribute the reference holds, so the packing
                '' in CellReadXY is what is under test rather than the colour
                '' bookkeeping
                if sdepth = 16 then
                    cell->fg = mfg : cell->bg = mbg
                else
                    cell->fg = mfg : cell->bg = mbg
                end if
            end if
        next

        '' characters
        for i as integer = 0 to len( txt ) - 1
            chk( tag + "ch(" + str(r) + "," + str(c + i) + ")", _
                 screen( r, c + i, 0 ), CellReadXY( cp, 0, sdepth, c + i, r, 0 ) )
        next

        '' POS and CSRLIN track the cursor, which PRINT advanced
        chk( tag + "pos after print", pos( ), c + len( txt ) )
        chk( tag + "csrlin after print", csrlin( ), r )
    next

    '' corners and every out-of-range direction
    dim as long probes(...) = { 0, 1, 2, tw - 1, tw, tw + 1, -1 }
    for a as integer = 0 to ubound( probes )
        for b as integer = 0 to ubound( probes )
            dim as long c = probes(a)
            dim as long r = probes(b)
            if r > th + 1 then continue for
            chk( tag + "oob ch(" + str(r) + "," + str(c) + ")", _
                 screen( r, c, 0 ), CellReadXY( cp, 0, sdepth, c, r, 0 ) )
            chk( tag + "oob col1(" + str(r) + "," + str(c) + ")", _
                 screen( r, c, 1 ), CellReadXY( cp, 0, sdepth, c, r, 1 ) )
        next
    next

    '' ---- 4. SCREEN() follows the WORK page ----
    if twopage then
    screenset 1, 0
    locate 2, 2, 0
    print "P1";
    dim as CharCell ptr q = CellAt( cp, 1, 1, 1 )
    if q <> NULL then q->ch = asc( "P" )
    q = CellAt( cp, 1, 2, 1 )
    if q <> NULL then q->ch = asc( "1" )

    chk( tag + "work=1 reads page1", screen( 2, 2, 0 ), _
         CellReadXY( cp, 1, sdepth, 2, 2, 0 ) )
    screenset 0, 0
    chk( tag + "work=0 reads page0", screen( 2, 2, 0 ), _
         CellReadXY( cp, 0, sdepth, 2, 2, 0 ) )
    end if

    '' ---- 6. PCOPY copies the whole cell page, view or no view ----
    if twopage then
    view (10, 10)-(50, 50)
    pcopy 0, 1
    CellPageCopy( cp, 0, 1 )
    view
    screenset 1, 0
    for k as integer = 0 to 4
        dim as long r = 1 + (k * 3) mod th
        dim as long c = 1 + (k * 5) mod (tw - len( txt ))
        chk( tag + "pcopy cell(" + str(r) + "," + str(c) + ")", _
             screen( r, c, 0 ), CellReadXY( cp, 1, sdepth, c, r, 0 ) )
    next
    screenset 0, 0
    end if

    '' ---- 7. SCREENSET's packed return is NOT OBSERVABLE from FB ----
    ''
    '' fb_GfxPageSet returns `work or (visible shl 8)`, the pages held before
    '' the call, but FB's SCREENSET is a STATEMENT and discards it -- the same
    '' situation as OUT in abtest-vgaport. So the packing is asserted as a unit
    '' check against the documented contract rather than A/B compared.
    chk( tag + "pageset packing", 1 or (0 shl 8), CellPageSetResult( 1, 0 ) )
    chk( tag + "pageset packing 0,1", 0 or (1 shl 8), CellPageSetResult( 0, 1 ) )

    CellsFree( cp )
    screen 0
next

'' ---- 5. WIDTH: packed return, pure query, and the silent no-op ----
scope
    screen 13
    dim as long sw, sh, d, bp, pi, rr
    screeninfo sw, sh, d, bp, pi, rr

    dim as CellPlane cp
    CellsReset( cp, loword( width( ) ), hiword( width( ) ), 1, 0, 15, 0 )

    dim as long nfw, nfh, nw, nh, changed

    '' pure query -- both arguments absent
    chk( "width query", width( ), _
         CellWidth( cp, sw, sh, 8, 8, 0, 0, nfw, nfh, nw, nh, changed ) )
    chk( "width query does not change", 0, changed )

    '' A SUPPORTED CHANGE. Note the PACKED OLD VALUE IS NOT OBSERVABLE: FB's
    '' `WIDTH cols, rows` is a statement and discards fb_GfxWidth's return, the
    '' same as OUT and SCREENSET. Only the query form `WIDTH()` yields it. So
    '' the old value is asserted against the contract and the EFFECT is what
    '' gets A/B compared.
    dim as ulong before = CellWidth( cp, sw, sh, 8, 8, 40, 25, nfw, nfh, nw, nh, changed )
    chk( "width 40,25 returns old (asserted)", 40 or (25 shl 16), before )
    width 40, 25
    chk( "width 40,25 took effect", 1, changed )
    if changed then
        cp.text_w = nw : cp.text_h = nh
    end if
    chk( "width 40,25 new size", width( ), _
         CellWidth( cp, sw, sh, 8, 8, 0, 0, nfw, nfh, nw, nh, changed ) )

    '' an UNSUPPORTED change: 100 columns of 320 is 3 wide -- silent no-op,
    '' and the return value is indistinguishable from a successful call
    before = CellWidth( cp, sw, sh, 8, 8, 100, 25, nfw, nfh, nw, nh, changed )
    chk( "width 100,25 returns old (asserted)", 40 or (25 shl 16), before )
    width 100, 25
    chk( "width 100,25 is a no-op", 0, changed )
    chk( "width unchanged after no-op", width( ), _
         CellWidth( cp, sw, sh, 8, 8, 0, 0, nfw, nfh, nw, nh, changed ) )

    CellsFree( cp )
    screen 0
end scope

if twopage_modes = 0 then
    report += "  NO MODE PROVIDED TWO PAGES -- every page check was skipped" + chr(10)
    failures += 1
end if

'' ---- 3b. THE 16bpp COLOUR FORM ----
''
'' NO LEGACY SCREEN MODE IS 16bpp. Measured: modes 1-21 are 1, 2, 4, 8 or 32
'' bits deep and nothing else, so the depth-16 branch of SCREEN(r, c, flag) is
'' UNREACHABLE from the loop above. It was written, and silently never run --
'' a negative test that removed the bit replication entirely still passed.
''
'' Only SCREENRES reaches it. The expansion refills each channel's low bits
'' from its own high bits, so full scale maps to 255 rather than 248 or 252;
'' the colours here are chosen with NON-ZERO low bits, because a shift-only
'' implementation agrees on every colour whose low bits are clear.
scope
    screenres 320, 200, 16
    dim as long sw, sh, d, bp, pi, rr
    screeninfo sw, sh, d, bp, pi, rr

    dim as CellPlane cp
    dim as long tw = loword( width( ) )
    dim as long th = hiword( width( ) )
    CellsReset( cp, tw, th, 1, 0, 0, 0 )

    dim as ulong cols(...) = { _
        rgb( 255, 128,  64 ), rgb( 255, 255, 255 ), rgb( 1, 2, 3 ), _
        rgb( 249, 253, 251 ), rgb( 8, 4, 8 ), rgb( 33, 77, 200 ), _
        rgb( 0, 0, 0 ), rgb( 254, 254, 254 ) }

    for k as integer = 0 to ubound( cols )
        dim as ulong f = cols(k)
        dim as ulong b = cols((k + 3) mod (ubound( cols ) + 1))
        color f, b
        locate 2, 2, 0
        print "Z";

        dim as CharCell ptr c = CellAt( cp, 0, 1, 1 )
        c->ch = asc( "Z" )
        '' the cell holds the CONVERTED 16-bit value, not the 32-bit argument
        c->fg = FixColor( 2, f )
        c->bg = FixColor( 2, b )

        chk( "16bpp ch", screen( 2, 2, 0 ), CellReadXY( cp, 0, d, 2, 2, 0 ) )
        chk( "16bpp fg " + hex( f ), screen( 2, 2, 1 ), _
             CellReadXY( cp, 0, d, 2, 2, 1 ) )
        chk( "16bpp bg " + hex( b ), screen( 2, 2, 2 ), _
             CellReadXY( cp, 0, d, 2, 2, 2 ) )
    next

    CellsFree( cp )
    screen 0
end scope

print "abtest-cells -- "; ran; " character-cell checks against gfxlib2 ("; _
      twopage_modes; " modes with two pages)"
if failures = 0 then
    print "abtest-cells: PASS -- the cell plane agrees"
    end 0
else
    print report;
    print "abtest-cells: FAIL -- "; failures; " of"; ran; " differ"
    end 1
end if
