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
'' `BSAVE file, image` and `BSAVE file, buffer, size`. The fourth argument is the
'' caller's palette array, NULL when none is written. BSAVE and BLOAD themselves
'' are thin wrappers here; the ported bodies are in entry/bmpio.bi.
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
'' size 0 -> source is an image; otherwise a plain buffer of that many bytes. A
'' NULL source is the SCREEN -- `bsave "shot.bmp", 0`. The extension selects the
'' format. All of it is in entry/bmpio.bi.
function TkoGfxBsave alias "fb_GfxBsave" ( _
        byval path as any ptr, _
        byval src as any ptr, _
        byval size as ulong, _
        byval pal as any ptr ) as long

    dim as string fn = TkoGfx.StrFromDescriptor( path )
    RtlStrDelTemp( path )
    return TkoGfx.BlSave( fn, src, size, cptr( ulong ptr, pal ) )
end function

'' BLOAD file [, dest] [, palette]
''
'' A NULL dest is the SCREEN. The file's first byte selects the format: &hFE the
'' FB raw block, &hFD QB's, 'B' a BMP. All of it is in entry/bmpio.bi.
function TkoGfxBload alias "fb_GfxBload" ( _
        byval path as any ptr, _
        byval dest as any ptr, _
        byval pal as any ptr ) as long

    dim as string fn = TkoGfx.StrFromDescriptor( path )
    RtlStrDelTemp( path )
    return TkoGfx.BlLoad( fn, dest, cptr( ulong ptr, pal ) )
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

'' SCREENLIST( depth ) -- iterate the display modes.
''
'' A depth above 0 BUILDS the list and returns its first entry, (w shl 16) or h;
'' 0 or a negative depth returns the next one, and 0 once the list is spent --
'' and stays 0 until a depth above 0 is asked again. Transcribed from
'' gfx_screenlist.c: a sorted, de-duplicated union of every driver's modes.
''
'' WHICH MODES. gfxlib2 asks its Direct2D driver first, and that driver asks DXGI
'' for the desktop's 32-BIT modes WHATEVER DEPTH WAS PASSED -- which is why fbc
'' lists the same 27 modes here for depth 1, 8, 15, 16, 24 and 32. The GDI driver
'' adds EnumDisplaySettings' modes of the depth itself, 15 and 16 interchangeable
'' and 24 and 32. This takes both from EnumDisplaySettings: its 32-bit modes stand
'' for DXGI's, and measured on this machine the two lists are identical.
''
'' This replaced a walk over the legacy SCREEN mode table: `screenlist( 32 )` found
'' nothing, and `screenlist( )` restarted the walk -- so the help's own
'' ScreenList example printed one mode, not the list.
function TkoGfxScreenList alias "fb_GfxScreenList" ( byval depth as long ) as long
    if depth > 0 then
        deallocate( TkoGfx.SlList )
        TkoGfx.SlList = 0
        TkoGfx.SlSize = 0
        dim as DEVMODE dm
        dm.dmSize = sizeof( DEVMODE )
        dim as long i = 0
        while EnumDisplaySettings( NULL, i, @dm )
            dim as long b = dm.dmBitsPerPel
            dim as boolean d2d = (b = 32)
            dim as boolean same = (b = depth)
            dim as boolean hi = ((b = 15) andalso (depth = 16)) orelse ((b = 16) andalso (depth = 15))
            dim as boolean tc = ((b = 24) andalso (depth = 32)) orelse ((b = 32) andalso (depth = 24))
            if d2d orelse same orelse hi orelse tc then
                TkoGfx.SlAdd( (dm.dmPelsWidth shl 16) or dm.dmPelsHeight )
            end if
            i += 1
        wend
        TkoGfx.SlSort( )
        TkoGfx.SlCurrent = 0
    end if

    TkoGfx.SlCurrent += 1
    if (TkoGfx.SlList = 0) orelse (TkoGfx.SlCurrent > TkoGfx.SlSize) then return 0
    return TkoGfx.SlList[TkoGfx.SlCurrent - 1]
end function

'' SCREENCONTROL lives in entry/control.bi, with its 64-bit and string forms.

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
