'' entry/misc.bi -- BSAVE, BLOAD, PMAP, POINTCOORD, SCREENLIST, and PUT ADD.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' These six are graphics entry points that src/mir/rtl.bi does NOT name
'' RTL_GFX_* -- they sit under RTL_BLOAD, RTL_BSAVE, RTL_PMAP, RTL_POINTCOORD,
'' RTL_SCREENLIST and RTL_H_PUT_ADD. Counting only the RTL_GFX_ prefix stops six
'' symbols short of a program that links.
''
'' MEASURED with `fbc -r -gen gcc`, five of the six:
''
''     bsave "a.bmp", img          fb_GfxBsave( str, img,  0u, NULL )
''     bsave "a.bsv", @b(0), 64    fb_GfxBsave( str, buf, 64u, NULL )
''     bload "a.bsv", @b(0)        fb_GfxBload( str, buf, NULL )
''     pmap( 1.0, 0 )              float fb_GfxPMap( float, int32 )
''     screenlist( 8 )             int32 fb_GfxScreenList( int32 )
''
'' A SIZE OF 0 MEANS "src IS AN IMAGE", which is how one entry point serves both
'' `BSAVE file, image` and `BSAVE file, buffer, size`. The fourth argument is a
'' palette and was NULL in every form probed.
''
'' fb_GfxCursor IS THE ONE THAT IS NOT MEASURED, and it is the one to distrust.
'' No 1.10.1 syntax found emits it -- `point(n)` goes to fb_GfxPoint with the
'' sentinel in y, which entry/draw2d.bi already implements. Its semantics here
'' come from tiko's own intrinsic name (`pointcoord`, src/mir/lowerintr.bas) and
'' its "f","l" signature: an axis selector in, a COORDINATE out. That is a
'' reading, not a measurement, and it is written down as one.

#pragma once

extern "c"

'' BSAVE file, source [, size] [, palette]
''
'' size 0 -> source is an image; otherwise a plain buffer of that many bytes.
''
'' THE EXTENSION SELECTS THE FORMAT, and the asymmetry is measured
'' (tools/abtest-bmp.bas): BSAVE of an IMAGE to a non-.bmp name writes NOTHING
'' but still leaves a ZERO-LENGTH FILE behind, because gfxlib2 rejects the
'' combination only after opening the file. Reproduced, because a program that
'' checks for the file's existence sees what it saw before.
function TkoGfxBsave alias "fb_GfxBsave" ( _
        byval path as any ptr, _
        byval src as any ptr, _
        byval size as ulong, _
        byval pal as any ptr ) as long

    scope : dim as any ptr ignored = pal : end scope

    dim as string fn = TkoGfx.StrFromDescriptor( path )
    if (len( fn ) = 0) orelse (src = 0) then return FB_RTERROR_ILLEGALFUNCTIONCALL

    dim as string ext = lcase( right( fn, 4 ) )

    if size = 0 then
        '' an image
        if ext <> ".bmp" then
            '' the measured asymmetry: open, refuse, leave the empty file
            dim as long f = freefile
            if open( fn, for output, as #f ) = 0 then close #f
            return FB_RTERROR_ILLEGALFUNCTIONCALL
        end if

        dim as TkoAbi.PUT_HEADER ptr img = cptr( TkoAbi.PUT_HEADER ptr, src )
        dim as long w, h, bpp, pitch, isz
        dim as any ptr px
        if TkoGfx.TkoImageQuery( img, w, h, bpp, pitch, px, isz ) <> 0 then
            return FB_RTERROR_ILLEGALFUNCTIONCALL
        end if

        if bpp = 1 then
            dim as TkoGfx.GfxPalette ptr p = TkoGfx.PaletteCurrent( )
            if p = 0 then return FB_RTERROR_ILLEGALFUNCTIONCALL
            return TkoGfx.BmpSave8( fn, img, *p )
        end if
        return TkoGfx.BmpSave32( fn, img )
    end if

    return TkoGfx.BSaveRaw( fn, src, size )
end function

'' BLOAD file, dest [, palette]
''
'' THE .bmp DIRECTION IS NOT IMPLEMENTED. core/bmp.bi writes BMPs and does not
'' read them -- there is no loader to call. A .bmp here returns an error rather
'' than loading nothing and reporting success, which is the difference between a
'' missing feature and a silent one.
function TkoGfxBload alias "fb_GfxBload" ( _
        byval path as any ptr, _
        byval dest as any ptr, _
        byval pal as any ptr ) as long

    scope : dim as any ptr ignored = pal : end scope

    dim as string fn = TkoGfx.StrFromDescriptor( path )
    if (len( fn ) = 0) orelse (dest = 0) then return FB_RTERROR_ILLEGALFUNCTIONCALL

    if lcase( right( fn, 4 ) ) = ".bmp" then return FB_RTERROR_ILLEGALFUNCTIONCALL

    '' The raw path needs a capacity and BLOAD has no size argument, so the file
    '' says how long it is: BLoadRaw reads the recorded length out of the header
    '' and refuses anything longer than the bound given. ULONG_MAX is the only
    '' honest bound available here -- the caller's buffer size is not passed, in
    '' fbc either.
    dim as ulong got
    return TkoGfx.BLoadRaw( fn, dest, &hFFFFFFFFul, got )
end function

'' PMAP( coord, func )
''
'' 0 logical x -> physical, 1 logical y -> physical, 2 and 3 the reverse.
'' core/viewport.bi implements it and tools/abtest-view.bas compares all four
'' against gfxlib2 to the BIT -- PMAP is where the (view_w - 1) discrepancy is
'' observable as a number rather than as a pixel.
function TkoGfxPMap alias "fb_GfxPMap" ( _
        byval coord as single, byval func_ as long ) as single

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( 0 )
    if c = 0 then return 0.0
    return TkoGfx.PMap32( c->vp, coord, func_ )
end function

'' The cursor's position on one axis, as a COORDINATE.
''
'' INFERRED, NOT MEASURED -- see the file header. The selectors are read the
'' same way POINT(n)'s are, which is the only reading consistent with both
'' names, and the value is the LOGICAL cursor because that is what a `single`
'' return is for; the physical one is an integer and POINT already returns it.
function TkoGfxCursor alias "fb_GfxCursor" ( byval func_ as long ) as single
    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( 0 )
    if c = 0 then return 0.0
    select case func_
    case 0 : return TkoGfx.PMap32( c->vp, c->draw.last_x, 0 )
    case 1 : return TkoGfx.PMap32( c->vp, c->draw.last_y, 1 )
    case 2 : return c->draw.last_x
    case 3 : return c->draw.last_y
    end select
    return 0.0
end function

'' SCREENLIST( depth ) -- iterate the modes available at a depth.
''
'' Each call returns the next (w shl 16) or h, and 0 when the list is done. A
'' depth of 0 means "any".
''
'' WINDOWED ONLY. gfxlib2 enumerates fullscreen display modes from the driver;
'' this library has no fullscreen path, so the list is the legacy MODE TABLE --
'' the resolutions SCREEN can actually open here. That is a different list from
'' fbc's on the same machine, and it is the honest one for what this presenter
'' can do.
function TkoGfxScreenList alias "fb_GfxScreenList" ( byval depth as long ) as long
    static as long nextmode = 1
    if depth < 0 then return 0

    '' A new query restarts the walk: fbc's SCREENLIST is called with the depth
    '' first and then repeatedly with the same one.
    static as long lastdepth = -1
    if depth <> lastdepth then
        lastdepth = depth
        nextmode = 1
    end if

    while nextmode < TkoGfx.NUM_MODES
        dim as long m = nextmode
        nextmode += 1
        if TkoGfx.ModeSupported( m ) then
            if (depth = 0) orelse (TkoGfx.ModeTable(m).depth = depth) then
                return (TkoGfx.ModeTable(m).w shl 16) or TkoGfx.ModeTable(m).h
            end if
        end if
    wend

    nextmode = 1
    lastdepth = -1
    return 0
end function

'' SCREENCONTROL selector, a [, b [, c [, d ]]]
''
'' NOT IN src/mir/rtl.bi, like fb_GfxImageDestroy: tiko has no RTL entry for it.
'' fbc emits it for SCREENCONTROL, and without it a program cannot ask for its
'' own window handle -- which is also what tools/gate-entry.sh needs to read
'' pixels back off the presented window. Probed: the signature is
'' ( int32, int32*, int32*, int32*, int32* ) and every omitted output is a
'' temporary, never NULL.
''
'' THE DRIVER SELECTORS ARE ANSWERED HERE, NOT IN core/control.bi. That file
'' declines all four on purpose -- it is a pure function of the SCREEN STATE and
'' has no driver to ask -- and tools/abtest-control.bas compares that decision
'' against gfxlib2. This layer has the window, so it answers the two it can and
'' leaves the rest declined.
''
'' GET_WINDOW_POS and GET_DESKTOP_SIZE are still not answered: the first has a
'' set direction this does not implement, and the second needs a monitor
'' enumeration nothing else here does. An unanswered selector leaves the
'' caller's outputs untouched, which is what fbc does with one its driver
'' refuses.
sub TkoGfxControl alias "fb_GfxControl_i32" ( _
        byval selector as long, _
        byval pa as long ptr, byval pb as long ptr, _
        byval pc as long ptr, byval pd as long ptr )

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( 0 )
    if c = 0 then exit sub

    if selector = TkoGfx.GET_WINDOW_HANDLE then
        '' An HWND is pointer-wide and the output is int32. That is fbc's own
        '' signature, not a narrowing introduced here -- SCREENCONTROL predates
        '' 64-bit handles and the value is passed back through `integer` at the
        '' BASIC level. Truncating is what the reference does too.
        if pa <> 0 then *pa = cast( long, cast( integer, TkoGfx.TheScreen.wnd.hwnd ) )
        exit sub
    end if

    dim as long cfg, cbg
    cfg = cast( long, c->draw.fg_color )
    cbg = cast( long, c->draw.bg_color )

    dim as TkoGfx.GfxScreenState st
    if TkoGfx.ScreenStateFromMode( st, TkoGfx.TheScreen.mode, c->surf.pitch ) = 0 then
        '' SCREENRES has no legacy mode number, so build the state from the
        '' surface instead of the table.
        st.w = c->surf.w
        st.h = c->surf.h
        st.depth = c->surf.bpp * 8
        st.bpp = c->surf.bpp
        st.pitch = c->surf.pitch
    end if

    dim as integer g1, g2, g3, g4
    if TkoGfx.ScreenControlGet( st, c->vp, cfg, cbg, 0, 0, selector, g1, g2, g3, g4 ) = 0 then
        exit sub
    end if
    if pa <> 0 then *pa = cast( long, g1 )
    if pb <> 0 then *pb = cast( long, g2 )
    if pc <> 0 then *pc = cast( long, g3 )
    if pd <> 0 then *pd = cast( long, g4 )
end sub

'' PUT ..., ADD -- the tenth blender, and the one src/mir/rtl.bi files under
'' RTL_H_PUT_ADD rather than with the other nine.
''
'' 16bpp has its own, A/B-checked in tools/abtest-putbpp.bas; 8bpp is bytewise
'' and reaches the 32-bit routine through fb_GfxPut's width conversion.
sub TkoPutAdd alias "fb_hPutAdd" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    if (blender <> 0) orelse (param <> 0) then : end if
    if TkoGfx.PutBlendBpp = 2 then
        TkoGfx.PutAdd16( src, dst, w, h, src_pitch, dst_pitch, alpha )
    else
        TkoGfx.PutAdd32( src, dst, w, h, src_pitch, dst_pitch, alpha )
    end if
end sub

end extern
