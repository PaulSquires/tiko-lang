'' entry/palette.bi -- the seven PALETTE entry points.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' MEASURED, NOT INFERRED. docs/language/graphics-abi.md records three of these;
'' the other four were probed for this file with `fbc -r -gen gcc`, which is the
'' project's own rule -- a fact with no measurement behind it is a guess. What
'' the probe said:
''
''     palette using a(0)        long array     fb_GfxPaletteUsing( int32* )
''     palette using b(0)        integer array  fb_GfxPaletteUsing64( int64* )
''     palette get using a(0)                   fb_GfxPaletteGetUsing( int32* )
''     palette get using b(0)                   fb_GfxPaletteGetUsing64( int64* )
''     palette 3, 10, 20, 30                    fb_GfxPalette( 3, 10, 20, 30 )
''     palette 3, 99                            fb_GfxPalette( 3, 99, -1, -1 )
''     palette get 3, r, g, b     long          fb_GfxPaletteGet( 3, &r, &g, &b )
''     palette get 3, r           long          fb_GfxPaletteGet( 3, &r, NULL, NULL )
''     palette get 3, r, g, b     integer        fb_GfxPaletteGet64( 3, ... int64* )
''
'' So "64" IS THE ELEMENT WIDTH OF THE CALLER'S ARRAY, not a 6-bit DAC range.
'' `dim as integer` is 64-bit on win64 and fbc emits a different symbol for it
'' rather than converting at the call site. Guessing that "64" meant 0..63
'' values would have produced a library that compiles, links, and writes the
'' wrong numbers through a correctly-typed pointer.
''
'' THE TWO SCALAR FORMS ARE TOLD APART BY -1, NOT BY AN ARGUMENT COUNT. Both
'' `PALETTE i, r, g, b` and `PALETTE i, value` reach fb_GfxPalette with four
'' arguments; the second passes -1 for g and b. Likewise PALETTE GET's packed
'' form passes NULL for the two it does not want. core/palette.bi already
'' implements both paths and tools/abtest-palette.bas compares both against
'' gfxlib2, so this file is dispatch and nothing else.
''
'' PALETTE IS A NO-OP ABOVE 8BPP, and with no screen open there is no palette at
'' all -- both are silent, as they are in fbc.

#pragma once

extern "c"

'' PALETTE index, r, g, b   -- or PALETTE index, value when g and b are -1.
''
'' An omitted INDEX is -1 and means "restore the mode's defaults", which is how
'' a bare `PALETTE` is spelled.
sub TkoGfxPalette alias "fb_GfxPalette" ( _
        byval index as long, _
        byval r as long, byval g as long, byval b as long )

    dim as TkoGfx.GfxPalette ptr p = TkoGfx.PaletteCurrent( )
    if p = 0 then exit sub

    if index < 0 then
        TkoGfx.PaletteForget( )
        exit sub
    end if

    if (g < 0) andalso (b < 0) then
        '' the two-argument form: a 6-bit packed colour on a 256-colour mode, a
        '' REGISTER NUMBER on the low-colour ones. core/palette.bi knows which.
        TkoGfx.PaletteSetPacked( *p, index, cast( ulong, r ) )
    else
        TkoGfx.PaletteSetRgb( *p, index, r, g, b )
    end if
end sub

'' PALETTE GET index, r [, g, b]
''
'' OMITTED OUTPUTS ARE NULL POINTERS, not temporaries -- the opposite of what
'' SCREENINFO does. So a NULL g and b is the packed form, not "discard these".
sub TkoGfxPaletteGet alias "fb_GfxPaletteGet" ( _
        byval index as long, _
        byval r as long ptr, byval g as long ptr, byval b as long ptr )

    dim as TkoGfx.GfxPalette ptr p = TkoGfx.PaletteCurrent( )
    if p = 0 then exit sub

    if (g = 0) andalso (b = 0) then
        if r <> 0 then *r = TkoGfx.PaletteGetPacked( *p, index )
        exit sub
    end if

    dim as long rr, gg, bb
    TkoGfx.PaletteGetRgb( *p, index, rr, gg, bb )
    if r <> 0 then *r = rr
    if g <> 0 then *g = gg
    if b <> 0 then *b = bb
end sub

'' The same, through a caller array of FreeBASIC `integer` -- 64-bit on win64.
'' A separate symbol rather than a conversion at the call site, measured.
sub TkoGfxPaletteGet64 alias "fb_GfxPaletteGet64" ( _
        byval index as long, _
        byval r as longint ptr, byval g as longint ptr, byval b as longint ptr )

    dim as TkoGfx.GfxPalette ptr p = TkoGfx.PaletteCurrent( )
    if p = 0 then exit sub

    if (g = 0) andalso (b = 0) then
        if r <> 0 then *r = TkoGfx.PaletteGetPacked( *p, index )
        exit sub
    end if

    dim as long rr, gg, bb
    TkoGfx.PaletteGetRgb( *p, index, rr, gg, bb )
    if r <> 0 then *r = rr
    if g <> 0 then *g = gg
    if b <> 0 then *b = bb
end sub

'' PALETTE USING array(0)
''
'' THE RAW DATA POINTER, WITH NO ARRAY DESCRIPTOR: fbc passes &a(0) and nothing
'' else, so there is no bound to check against. The count comes from the MODE --
'' as many entries as the mode has colours -- which is the only source available
'' and is what gfxlib2 uses too.
''
'' Each element is a packed 6-bit-per-channel value, the same encoding the
'' two-argument PALETTE takes.
sub TkoGfxPaletteUsing alias "fb_GfxPaletteUsing" ( byval src as long ptr )
    dim as TkoGfx.GfxPalette ptr p = TkoGfx.PaletteCurrent( )
    if (p = 0) orelse (src = 0) then exit sub
    dim as long n = TkoGfx.ModePaletteColors( TkoGfx.TheScreen.mode )
    for i as integer = 0 to n - 1
        TkoGfx.PaletteSetPacked( *p, i, cast( ulong, src[i] ) )
    next
end sub

sub TkoGfxPaletteUsing64 alias "fb_GfxPaletteUsing64" ( byval src as longint ptr )
    dim as TkoGfx.GfxPalette ptr p = TkoGfx.PaletteCurrent( )
    if (p = 0) orelse (src = 0) then exit sub
    dim as long n = TkoGfx.ModePaletteColors( TkoGfx.TheScreen.mode )
    for i as integer = 0 to n - 1
        TkoGfx.PaletteSetPacked( *p, i, cast( ulong, src[i] ) )
    next
end sub

'' PALETTE GET USING array(0) -- the same, outward.
sub TkoGfxPaletteGetUsing alias "fb_GfxPaletteGetUsing" ( byval dst as long ptr )
    dim as TkoGfx.GfxPalette ptr p = TkoGfx.PaletteCurrent( )
    if (p = 0) orelse (dst = 0) then exit sub
    dim as long n = TkoGfx.ModePaletteColors( TkoGfx.TheScreen.mode )
    for i as integer = 0 to n - 1
        dst[i] = TkoGfx.PaletteGetPacked( *p, i )
    next
end sub

sub TkoGfxPaletteGetUsing64 alias "fb_GfxPaletteGetUsing64" ( byval dst as longint ptr )
    dim as TkoGfx.GfxPalette ptr p = TkoGfx.PaletteCurrent( )
    if (p = 0) orelse (dst = 0) then exit sub
    dim as long n = TkoGfx.ModePaletteColors( TkoGfx.TheScreen.mode )
    for i as integer = 0 to n - 1
        dst[i] = TkoGfx.PaletteGetPacked( *p, i )
    next
end sub

end extern
