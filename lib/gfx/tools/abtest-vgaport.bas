'' abtest-vgaport.bas -- A/B the VGA DAC port emulation against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' INP and OUT on a graphics screen are redirected into gfxlib2 through the
'' inproc/outproc hooks, so they can be driven directly and compared against our
'' own state machine.
''
'' What is covered, and why each part earns its place:
''
''   1. DAC WRITE SEQUENCES. Three OUTs to &h3C9 commit one colour. Checked by
''      reading the result back with PALETTE GET, so the 6-bit-to-8-bit scaling
''      is compared and not merely the accumulation.
''
''   2. THE AUTO-INCREMENT. After a commit the index advances and wraps by MASK.
''      A run of colours is written from one index and every entry read back,
''      including one past the end of the run.
''
''   3. DAC READS. INP(&h3C9) returns the channels of the current entry and then
''      advances, so a read run walks the palette.
''
''   4. INTERLEAVED READ AND WRITE -- the case that motivated the file. The C
''      keeps ONE shift/index/colour triple shared by both directions, so an INP
''      in the middle of a write sequence hijacks it: the committed colour and
''      the landing index both differ from the naive answer. An implementation
''      with separate read and write state passes 1 to 3 and fails only here.
''
''   5. A PARTIAL SEQUENCE ACROSS A MODE CHANGE. The state is never reset by
''      SCREEN, so two bytes written before and one after commit a colour built
''      from both sides.
''
''   6. UNHANDLED PORTS return -1, and the depth rule is ASYMMETRIC -- the C
''      guards the data port with a depth check but leaves &h3DA reachable
''      above 8bpp.
''
'' OUT'S RETURN VALUE IS NOT COMPARED. fb_GfxOut returns 0 or -1, but FB's OUT
'' is a STATEMENT and discards it, so there is no way to observe it from FB
'' source. Only its effect on the palette is comparable. Recorded so the gap is
'' not mistaken for an oversight.
''
'' &h3DA is exercised for its return value only. It also waits for vsync, which
'' is a driver behaviour and not comparable headlessly.
''
'' Split into roles (abtest.bi). Two changes were needed to make the case
'' sequence independent of the reference: the depth now comes from the MODE
'' TABLE rather than SCREENINFO (abtest-mode proves the two agree), and the OUT
'' statements are wrapped in REFOUT so the subject drives only its own state
'' machine. Nothing else moved -- the single shared VgaPortState still spans
'' every mode, for the reason above it.

#include once "../core/vgaport.ti"
#include once "abtest.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
#endif

using TkoGfx
#ifdef ABTEST_HAS_GFXLIB2
using FB
#endif

'' OUT and SCREEN are statements, so they cannot go through REF(); these
'' evaporate in the subject role the same way.
#ifdef ABTEST_HAS_GFXLIB2
#macro REFOUT( port_, v_ )
    out port_, v_
#endmacro
#macro REFSCREEN( m_ )
    screen m_
#endmacro
#else
#macro REFOUT( port_, v_ )
#endmacro
#macro REFSCREEN( m_ )
#endmacro
#endif

sub chk( byref what as string, byval want as long, byval got as long )
    Abtest.Case_( what, want, got )
end sub

sub chkrgb( byref p as GfxPalette, byref what as string, byval e as long )
    dim as long wr, wg, wb, gr, gg, gb
#ifdef ABTEST_HAS_GFXLIB2
    palette get e, wr, wg, wb
#endif
    PaletteGetRgb( p, e, gr, gg, gb )
    chk( what + ".r", wr, gr )
    chk( what + ".g", wg, gg )
    chk( what + ".b", wb, gb )
end sub

Abtest.Begin( "abtest-vgaport", "the DAC state machine agrees" )

'' ONE state for the whole program, not one per mode. gfxlib2 keeps idx, shift
'' and colour as file statics that no mode change resets, so a per-mode reset
'' here desynchronises the two sides at every SCREEN -- which is how this first
'' presented: the very first DAC read on the second mode disagreed, because the
'' reference was still mid-sequence from the first.
'' NOT `st` -- fbc warning 47, "use of reserved global or backend symbol".
'' Ninth name collision found in this library; it compiles and runs, but the
'' warning is real.
dim shared as VgaPortState dac
VgaPortInit( dac )

dim as long modes(...) = { 13, 9, 1, 11, 18 }

for mi as integer = 0 to ubound( modes )
    dim as long mode = modes(mi)
    if ModeSupported( mode ) = 0 then continue for
    dim as long colors = ModePaletteColors( mode )

    REFSCREEN( mode )

    '' From the TABLE, not SCREENINFO: the case sequence below branches on it,
    '' and a sequence that depended on the reference could not be recorded.
    dim as long sdepth = ModeTable(mode).depth

    dim as GfxPalette p
    '' A mode above 8bpp has no default table; only the port and depth rules
    '' apply there, so give the state a well-formed palette and skip the rest.
    if PaletteLoadDefaults( p, mode ) = 0 then PaletteInit( p, 256 )

    dim as string tag = "m" + str(mode) + " "
    dim as long dirtied, vsynced

    '' ---- 6. unhandled port, and &h3DA at every depth ----
    ''
    '' AN UNHANDLED PORT CANNOT BE A/B TESTED THROUGH INP, and the reason is
    '' worth stating because the comparison looks obviously correct.
    ''
    '' rtlib/hook_ports.c does NOT return the hook's answer. It calls the hook,
    '' then `if (res < 0) res = fb_hIn(port)` -- A REAL HARDWARE PORT READ. So
    '' -1 from the hook means "not handled, fall through", not "the value is
    '' -1", and what INP finally returns for an unhandled port is whatever the
    '' machine has on that port.
    ''
    '' Measured: INP(&h3C0) on a graphics screen gives -8 on win32, where
    '' win32/sys_portio.c implements a real read, and -1 on win64, which has no
    '' implementation. Comparing the two made win32 fail five checks that were
    '' never about this library.
    ''
    '' So this is asserted as a UNIT check against the documented contract --
    '' the hook returns -1 -- rather than compared against INP.
    chk( tag + "unhandled port returns -1", -1, _
         VgaPortIn( dac, p, sdepth, &h3C0, vsynced ) )
    chk( tag + "in(3DA)", REF( inp( &h3DA ) ), VgaPortIn( dac, p, sdepth, &h3DA, vsynced ) )
    chk( tag + "in(3C9) depth-gated", REF( inp( &h3C9 ) ), _
         VgaPortIn( dac, p, sdepth, &h3C9, vsynced ) )

    '' DAC WRITES ARE ONLY COMPARABLE WHERE THE REFERENCE IS DETERMINISTIC.
    ''
    '' The low-colour commit path walks color_association looking for
    '' attributes bound to the index being written. That array is
    '' `malloc(16)` -- never zeroed -- and fb_GfxPalette only fills it for
    '' modes that HAVE an association table: the CGA pair (1, 2) and the EGA
    '' trio (7, 8, 9). For every other low-colour mode it is read
    '' uninitialised.
    ''
    '' Measured on SCREEN 11: OUT &h3C8,0 then three OUT &h3C9 leave entry 0
    '' unchanged. Nothing matched, so the write was silently dropped -- no
    '' error, just a colour that never arrives.
    ''
    '' We do not reproduce it. Our assoc() is always initialised, so the write
    '' lands where gfxlib2 INTENDED. Those modes keep their port and depth
    '' checks and skip the palette comparison, which is the honest thing to do
    '' with a reference that is reading its own uninitialised heap.
    dim as long assoc_ok = (colors >= 256) orelse (mode = 1) orelse (mode = 2) orelse _
                           (mode = 7) orelse (mode = 8) orelse (mode = 9)

    if (sdepth <= 8) andalso assoc_ok then
        '' ---- 1 + 2. write runs, then read the palette back ----
        for base_ as integer = 0 to 2
            dim as long start = (base_ * 37) and (colors - 1)
            REFOUT( &h3C8, cast( ubyte, start ) )
            VgaPortOut( dac, p, sdepth, &h3C8, cast( ubyte, start ), dirtied )

            for n as integer = 0 to 5
                for ch as integer = 0 to 2
                    dim as ubyte v = cast( ubyte, (n * 13 + ch * 7 + base_ * 5) and &h3F )
                    REFOUT( &h3C9, v )
                    VgaPortOut( dac, p, sdepth, &h3C9, v, dirtied )
                next
            next

            for n as integer = 0 to 6
                dim as long e = (start + n) and (colors - 1)
                chkrgb( p, tag + "wr entry" + str(e), e )
            next
        next

        '' ---- 3. read runs ----
        REFOUT( &h3C7, 4 )
        VgaPortOut( dac, p, sdepth, &h3C7, 4, dirtied )
        for n as integer = 0 to 17
            chk( tag + "rd" + str(n), REF( inp( &h3C9 ) ), _
                 VgaPortIn( dac, p, sdepth, &h3C9, vsynced ) )
        next

        '' ---- 4. interleaved read and write ----
        REFOUT( &h3C8, 9 )
        VgaPortOut( dac, p, sdepth, &h3C8, 9, dirtied )
        REFOUT( &h3C9, 63 )
        VgaPortOut( dac, p, sdepth, &h3C9, 63, dirtied )
        REFOUT( &h3C9, 21 )
        VgaPortOut( dac, p, sdepth, &h3C9, 21, dirtied )
        chk( tag + "interleaved read", REF( inp( &h3C9 ) ), _
             VgaPortIn( dac, p, sdepth, &h3C9, vsynced ) )
        REFOUT( &h3C9, 42 )
        VgaPortOut( dac, p, sdepth, &h3C9, 42, dirtied )
        REFOUT( &h3C9, 7 )
        VgaPortOut( dac, p, sdepth, &h3C9, 7, dirtied )
        for e as integer = 8 to 12
            chkrgb( p, tag + "ilv entry" + str(e and (colors - 1)), e and (colors - 1) )
        next
    end if

    REFSCREEN( 0 )
next

'' ---- 5. a partial sequence surviving a mode change ----
scope
    dim as GfxPalette p
    dim as VgaPortState dac
    dim as long d
    VgaPortInit( dac )

    REFSCREEN( 13 )
    PaletteLoadDefaults( p, 13 )
    REFOUT( &h3C8, 3 )  : VgaPortOut( dac, p, 8, &h3C8, 3, d )
    REFOUT( &h3C9, 60 ) : VgaPortOut( dac, p, 8, &h3C9, 60, d )
    REFOUT( &h3C9, 30 ) : VgaPortOut( dac, p, 8, &h3C9, 30, d )

    REFSCREEN( 0 )
    REFSCREEN( 13 )
    '' gfxlib2 reloads the default palette on a mode set, so reload ours too.
    '' What is under test is that the PORT STATE survived, not the palette.
    PaletteLoadDefaults( p, 13 )
    REFOUT( &h3C9, 15 ) : VgaPortOut( dac, p, 8, &h3C9, 15, d )
    chkrgb( p, "cross-SCREEN commit", 3 )
    REFSCREEN( 0 )
end scope

Abtest.Finish_( )
