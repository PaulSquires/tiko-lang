'' probe-fbabi.bas -- the FB side of the ABI gate.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' Prints the same table as tools/probe-rtlabi.c, in the same format, for the
'' mirrors in abi/rtlabi.ti. tools/gate-abi.sh diffs the two; any difference
'' means the FB mirror and the real runtime disagree, and that is a build
'' failure.
''
'' The C probe also prints alignof, which FreeBASIC has no operator for. The
'' gate strips those columns before comparing rather than guessing at them --
'' comparing what both sides can actually measure, and nothing more.

#include once "../abi/rtlabi.ti"

using TkoAbi

#macro T( ty )
    print #o, rpad( #ty, 16 ); " sizeof="; trim( str( sizeof( ty ) ) )
#endmacro

#macro F( ty, fld )
    print #o, rpad( #ty, 16 ); " ."; rpad( #fld, 18 ); _
              " off="; rpad( trim( str( offsetof( ty, fld ) ) ), 5 ); _
              " size="; trim( str( sizeof( cptr( ty ptr, 0 )->fld ) ) )
#endmacro

'' Five fields are renamed on the FB side because their C names are FreeBASIC
'' keywords (DATA, PTR, EXIT, LOCK, UNLOCK). FN prints the C name so the gate
'' still compares field NAMES and not just offsets -- the rename is ours, and it
'' must not become a hole in the check.
#macro FN( ty, fld, cname )
    print #o, rpad( #ty, 16 ); " ."; rpad( cname, 18 ); _
              " off="; rpad( trim( str( offsetof( ty, fld ) ) ), 5 ); _
              " size="; trim( str( sizeof( cptr( ty ptr, 0 )->fld ) ) )
#endmacro

'' Array fields. FB will not parse ->field(0) inside a macro, so the element
'' type is passed explicitly and multiplied out. n and elemty must match the C
'' declaration; the gate catches it if they do not.
#macro FA( ty, fld, elemty, n )
    print #o, rpad( #ty, 16 ); " ."; rpad( #fld, 18 ); _
              " off="; rpad( trim( str( offsetof( ty, fld(0) ) ) ), 5 ); _
              " size="; trim( str( sizeof( elemty ) * (n) ) )
#endmacro

function rpad( byref s as string, byval n as integer ) as string
    if len( s ) >= n then return s
    return s + space( n - len( s ) )
end function

dim as long o = freefile
if open( command(1), for output, as #o ) <> 0 then
    print "probe-fbabi: cannot open "; command(1)
    end 2
end if

print #o, "== types =="
T( FBSTRING ) : T( FBARRAY ) : T( FBARRAYDIM ) : T( EVENT )
T( FB_HOOKSTB ) : T( FB_GFXCTX ) : T( FBGFX )
T( GFXDRIVER ) : T( PUT_HEADER ) : T( GFX_CHAR_CELL )

print #o, "== FBSTRING =="
FN( FBSTRING, dat, "data" ) : F( FBSTRING, len ) : F( FBSTRING, size )

print #o, "== FBARRAY =="
FN( FBARRAY, dat, "data" ) : FN( FBARRAY, ptr_, "ptr" ) : F( FBARRAY, size )
F( FBARRAY, element_len ) : F( FBARRAY, dimensions ) : F( FBARRAY, flags )
FA( FBARRAY, dimTB, FBARRAYDIM, 1 )

print #o, "== FB_HOOKSTB =="
F( FB_HOOKSTB, inkeyproc )      : F( FB_HOOKSTB, getkeyproc )
F( FB_HOOKSTB, keyhitproc )     : F( FB_HOOKSTB, clsproc )
F( FB_HOOKSTB, colorproc )      : F( FB_HOOKSTB, locateproc )
F( FB_HOOKSTB, widthproc )      : F( FB_HOOKSTB, getxproc )
F( FB_HOOKSTB, getyproc )       : F( FB_HOOKSTB, getxyproc )
F( FB_HOOKSTB, getsizeproc )    : F( FB_HOOKSTB, printbuffproc )
F( FB_HOOKSTB, printbuffwproc ) : F( FB_HOOKSTB, readstrproc )
F( FB_HOOKSTB, multikeyproc )   : F( FB_HOOKSTB, getmouseproc )
F( FB_HOOKSTB, setmouseproc )   : F( FB_HOOKSTB, inproc )
F( FB_HOOKSTB, outproc )        : F( FB_HOOKSTB, viewupdateproc )
F( FB_HOOKSTB, lineinputproc )  : F( FB_HOOKSTB, lineinputwproc )
F( FB_HOOKSTB, readxyproc )     : F( FB_HOOKSTB, sleepproc )
F( FB_HOOKSTB, isredirproc )    : F( FB_HOOKSTB, pagecopyproc )
F( FB_HOOKSTB, pagesetproc )    : F( FB_HOOKSTB, posteventproc )

print #o, "== PUT_HEADER (the 32-byte image contract) =="
F( PUT_HEADER, bpp ) : F( PUT_HEADER, width ) : F( PUT_HEADER, height )
F( PUT_HEADER, pitch ) : F( PUT_HEADER, tex )

print #o, "== FB_GFXCTX =="
F( FB_GFXCTX, id ) : F( FB_GFXCTX, work_page ) : F( FB_GFXCTX, line )
F( FB_GFXCTX, max_h ) : F( FB_GFXCTX, target_bpp ) : F( FB_GFXCTX, target_pitch )
F( FB_GFXCTX, last_target ) : F( FB_GFXCTX, last_x ) : F( FB_GFXCTX, last_y )
FA( FB_GFXCTX, view, long, 4 ) : FA( FB_GFXCTX, old_view, long, 4 )
F( FB_GFXCTX, win_x ) : F( FB_GFXCTX, win_y ) : F( FB_GFXCTX, win_w ) : F( FB_GFXCTX, win_h )
F( FB_GFXCTX, fg_color ) : F( FB_GFXCTX, bg_color )
F( FB_GFXCTX, put_pixel ) : F( FB_GFXCTX, get_pixel ) : F( FB_GFXCTX, pixel_set )
FA( FB_GFXCTX, putter, any ptr, PUT_MODES ) : F( FB_GFXCTX, flags )

print #o, "== FBGFX =="
F( FBGFX, id ) : F( FBGFX, mode_num ) : F( FBGFX, page ) : F( FBGFX, num_pages )
F( FBGFX, visible_page ) : F( FBGFX, framebuffer ) : F( FBGFX, w ) : F( FBGFX, h )
F( FBGFX, depth ) : F( FBGFX, bpp ) : F( FBGFX, pitch ) : F( FBGFX, palette )
F( FBGFX, device_palette ) : F( FBGFX, color_association ) : F( FBGFX, dirty )
F( FBGFX, driver ) : F( FBGFX, color_mask ) : F( FBGFX, default_palette )
F( FBGFX, scanline_size ) : F( FBGFX, cursor_x ) : F( FBGFX, cursor_y )
F( FBGFX, font ) : F( FBGFX, text_w ) : F( FBGFX, text_h ) : F( FBGFX, aspect )
F( FBGFX, key ) : F( FBGFX, refresh_rate ) : F( FBGFX, con_pages )
F( FBGFX, event_queue ) : F( FBGFX, event_head ) : F( FBGFX, event_tail )
F( FBGFX, event_mutex ) : F( FBGFX, flags ) : F( FBGFX, lock_count )

print #o, "== GFXDRIVER =="
F( GFXDRIVER, name ) : F( GFXDRIVER, init ) : FN( GFXDRIVER, exit_, "exit" )
FN( GFXDRIVER, lock_, "lock" ) : FN( GFXDRIVER, unlock_, "unlock" ) : F( GFXDRIVER, set_palette )
F( GFXDRIVER, wait_vsync ) : F( GFXDRIVER, get_mouse ) : F( GFXDRIVER, set_mouse )
F( GFXDRIVER, set_window_title ) : F( GFXDRIVER, set_window_pos )
F( GFXDRIVER, fetch_modes ) : F( GFXDRIVER, flip ) : F( GFXDRIVER, poll_events )
F( GFXDRIVER, update )

print #o, "== GFX_CHAR_CELL =="
F( GFX_CHAR_CELL, ch ) : F( GFX_CHAR_CELL, fg ) : F( GFX_CHAR_CELL, bg )

close #o
end 0
