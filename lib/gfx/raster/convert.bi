'' convert.bi -- the row converters behind IMAGECONVERTROW and the blitter table.
''
'' Derived from: gfx_image_convert.c (the fb_image_convert_* family,
'' fb_GfxImageConvertRow). LGPL-2.1-or-later with the static-linking exception.
''
'' These are the same conversions the 24-entry blitter table uses to move a
'' framebuffer onto a device of a different depth. The blitter itself is internal
'' and only observable by looking at a window; IMAGECONVERTROW exposes exactly
'' the same converters as a public statement, so that is what these are checked
'' against.
''
'' THE isrgb FLAG PICKS BETWEEN A SWAP AND A COPY. It is not a cosmetic hint:
''
''   32to32     (c shr 16) or (c and &hFF00FF00) or (c shl 16)   -- SWAPS r and b
''   32bgrto32  a straight copy
''
'' Both are "32 to 32". Choosing the wrong one leaves the image looking right in
'' greys and inverted in colour, which is the sort of bug that survives a casual
'' look at a screenshot.
''
'' THE 8-BIT CONVERTERS READ THE DEVICE PALETTE, so they need one passed in.
'' gfxlib2 reaches through the global `__fb_gfx->device_palette`; here it is an
'' argument, because a converter that silently depends on global state cannot be
'' tested a row at a time.
''
'' 8to8 MASKS WITH color_mask, not with &hFF. On a mode with fewer than 256
'' colours the mask is narrower, so the copy is not the identity.

#pragma once

#include once "../core/palette.bi"

namespace TkoGfx

'' 8 -> 8. A masked copy, not a plain one.
private sub Convert8to8( _
        byval src as ubyte ptr, byval dst as ubyte ptr, _
        byval w as long, byval color_mask as ulong )
    dim as integer i = 0
    while i < w
        dst[i] = cast( ubyte, src[i] and color_mask )
        i += 1
    wend
end sub

'' 8 -> 16, through the palette. Note the channel order: the palette entry has
'' RED in the low byte, and the 565 result puts BLUE low.
private sub Convert8to16( _
        byval src as ubyte ptr, byval dst as ushort ptr, _
        byval w as long, byref pal as GfxPalette )
    dim as integer i = 0
    while i < w
        dim as ulong c = pal.entry( src[i] )
        dim as ulong r = c and &hFF
        dim as ulong g = (c shr 8) and &hFF
        dim as ulong b = (c shr 16) and &hFF
        dst[i] = cast( ushort, (b shr 3) or ((g shl 3) and &h07E0) or ((r shl 8) and &hF800) )
        i += 1
    wend
end sub

'' 8 -> 32, through the palette. Opaque alpha, and r/b transposed relative to
'' the palette entry's own order.
private sub Convert8to32( _
        byval src as ubyte ptr, byval dst as ulong ptr, _
        byval w as long, byref pal as GfxPalette )
    dim as integer i = 0
    while i < w
        dim as ulong c = pal.entry( src[i] )
        dim as ulong r = c and &hFF
        dim as ulong g = (c shr 8) and &hFF
        dim as ulong b = (c shr 16) and &hFF
        dst[i] = &hFF000000 or b or (g shl 8) or (r shl 16)
        i += 1
    wend
end sub

'' 32 -> 16, source RGB.
private sub Convert32to16( _
        byval src as ulong ptr, byval dst as ushort ptr, byval w as long )
    dim as integer i = 0
    while i < w
        dim as ulong c = src[i] and &h00FFFFFF
        dst[i] = cast( ushort, (c shr 19) or ((c shr 5) and &h07E0) or ((c shl 8) and &hF800) )
        i += 1
    wend
end sub

'' 32 -> 32, source RGB. The red/blue swap -- see the header.
private sub Convert32to32( _
        byval src as ulong ptr, byval dst as ulong ptr, byval w as long )
    dim as integer i = 0
    while i < w
        dim as ulong c = src[i]
        dst[i] = (c shr 16) or (c and &hFF00FF00) or (c shl 16)
        i += 1
    wend
end sub

'' 32 -> 16, source BGR.
private sub Convert32bgrto16( _
        byval src as ulong ptr, byval dst as ushort ptr, byval w as long )
    dim as integer i = 0
    while i < w
        dim as ulong c = src[i]
        dst[i] = cast( ushort, ((c and &hFF) shr 3) or ((c shr 5) and &h07E0) or ((c shr 8) and &hF800) )
        i += 1
    wend
end sub

'' 32 -> 32, source BGR. A straight copy.
private sub Convert32bgrto32( _
        byval src as ulong ptr, byval dst as ulong ptr, byval w as long )
    dim as integer i = 0
    while i < w
        dst[i] = src[i]
        i += 1
    wend
end sub

'' 24 -> 16 and 24 -> 32, both orders. The 24-bit source is three bytes per
'' pixel; the BGR-to-32 case reads a whole DWORD and masks, which reads one byte
'' past the last pixel -- harmless in gfxlib2 because its buffers are padded, and
'' reproduced here as a byte-wise build for the same result without the overread.
private sub Convert24bgrto32( _
        byval src as ubyte ptr, byval dst as ulong ptr, byval w as long )
    dim as integer i = 0
    while i < w
        dst[i] = &hFF000000 or cast( ulong, src[i*3] ) or _
                 (cast( ulong, src[i*3+1] ) shl 8) or (cast( ulong, src[i*3+2] ) shl 16)
        i += 1
    wend
end sub

'' 24 -> 32 and 24 -> 16 with the source in RGB byte order -- IMAGECONVERTROW's
'' isrgb = 1 path, which the blitter table never needed. The FIRST byte is red.
private sub Convert24to32( _
        byval src as ubyte ptr, byval dst as ulong ptr, byval w as long )
    dim as integer i = 0
    while i < w
        dst[i] = &hFF000000 or (cast( ulong, src[i*3] ) shl 16) or _
                 (cast( ulong, src[i*3+1] ) shl 8) or cast( ulong, src[i*3+2] )
        i += 1
    wend
end sub

private sub Convert24to16( _
        byval src as ubyte ptr, byval dst as ushort ptr, byval w as long )
    dim as integer i = 0
    while i < w
        dst[i] = cast( ushort, ((cast( ushort, src[i*3] ) shl 8) and &hF800) or _
                 ((cast( ushort, src[i*3+1] ) shl 3) and &h07E0) or _
                 (cast( ushort, src[i*3+2] ) shr 3) )
        i += 1
    wend
end sub

private sub Convert24bgrto16( _
        byval src as ubyte ptr, byval dst as ushort ptr, byval w as long )
    dim as integer i = 0
    while i < w
        dst[i] = cast( ushort, (cast( ushort, src[i*3] ) shr 3) or _
                 ((cast( ushort, src[i*3+1] ) shl 3) and &h07E0) or _
                 ((cast( ushort, src[i*3+2] ) shl 8) and &hF800) )
        i += 1
    wend
end sub

end namespace
