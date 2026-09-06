'' entry/putblend.bi -- the nine PUT blenders, as public symbols.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' These are the only entry points that are not called by user code. fbc emits a
'' POINTER to one of them as PUT's `blender` argument and PUT calls it back --
'' docs/language/graphics-abi.md, "Each mode carries its own blender pointer".
'' So they must exist as named symbols with a stable signature even though no
'' BASIC statement names them.
''
'' THE ARGUMENT ORDER IS INFERRED, NOT MEASURED, and that is worth stating
'' because it is the one thing here a test cannot currently catch.
''
'' src/mir/rtl.bi gives the shape -- "pplllllpp", two pointers, five longs, two
'' pointers -- and nothing more. graphics-abi.md records the blender POINTERS
'' but never the callee's own parameter list, because a probe compiled from
'' BASIC never calls one directly. Read as
''
''     ( src, dst, w, h, src_pitch, dst_pitch, alpha, blender, param )
''
'' which matches raster/put.bi's internals and gfxlib2's blitter convention.
'' A SELF-CONSISTENT PAIR PASSES EITHER WAY: our PUT calling our blender agrees
'' with itself whichever order both sides use, so tools/abtest-put.bas cannot
'' discriminate. What would is fbc-compiled code calling ours, or ours calling
'' fbc's -- the substitution harness in RFC-0001 section 6.1, which does not
'' exist yet. Until then this is resemblance.
''
'' THE TARGET DEPTH IS NOT AN ARGUMENT EITHER. gfxlib2 reads it from the drawing
'' context, so PutBlendBpp carries it: fb_GfxPut sets it before dispatching and
'' it defaults to 4, which is the screen. An 8- or 16-bpp image target selects
'' the narrow variants where raster/put.bi has one and falls through to the
'' 32-bit routine where it does not -- and where it does not is recorded per
'' mode below rather than left to be discovered.

#pragma once

namespace TkoGfx

'' BYTES per pixel of the destination the next blender call will write. Set by
'' fb_GfxPut, read here. Not a parameter because the ABI has no room for one.
dim shared as long PutBlendBpp = 4

end namespace

extern "c"

'' PSET -- a straight copy. 8 and 16 bpp have their own, A/B-checked in
'' tools/abtest-putbpp.bas.
sub TkoPutPSet alias "fb_hPutPSet" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    scope : dim as long ignored = alpha : end scope
    if (blender <> 0) orelse (param <> 0) then : end if
    select case TkoGfx.PutBlendBpp
    case 1 : TkoGfx.PutPSet8( src, dst, w, h, src_pitch, dst_pitch )
    case 2 : TkoGfx.PutPSet16( src, dst, w, h, src_pitch, dst_pitch )
    case else : TkoGfx.PutPSet32( src, dst, w, h, src_pitch, dst_pitch )
    end select
end sub

'' TRANS -- skip the transparent colour. 8 and 16 bpp have their own.
sub TkoPutTrans alias "fb_hPutTrans" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    scope : dim as long ignored = alpha : end scope
    if (blender <> 0) orelse (param <> 0) then : end if
    select case TkoGfx.PutBlendBpp
    case 1 : TkoGfx.PutTrans8( src, dst, w, h, src_pitch, dst_pitch )
    case 2 : TkoGfx.PutTrans16( src, dst, w, h, src_pitch, dst_pitch )
    case else : TkoGfx.PutTrans32( src, dst, w, h, src_pitch, dst_pitch )
    end select
end sub

'' PRESET, AND, OR, XOR -- bitwise, 32bpp only here.
''
'' NO NARROW VARIANT, and that is measured rather than an omission:
'' tools/abtest-putbpp.bas drives gfxlib2's 8- and 16-bpp PUT for these and
'' finds them bytewise, so the 32-bit routine over (w * bpp) \ 4 dwords is the
'' same operation. fb_GfxPut is what does that width conversion; a caller
'' reaching these directly at a narrow depth gets the 32-bit read.
sub TkoPutPReset alias "fb_hPutPReset" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    scope : dim as long ignored = alpha : end scope
    if (blender <> 0) orelse (param <> 0) then : end if
    TkoGfx.PutPReset32( src, dst, w, h, src_pitch, dst_pitch )
end sub

sub TkoPutAnd alias "fb_hPutAnd" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    scope : dim as long ignored = alpha : end scope
    if (blender <> 0) orelse (param <> 0) then : end if
    TkoGfx.PutAnd32( src, dst, w, h, src_pitch, dst_pitch )
end sub

sub TkoPutOr alias "fb_hPutOr" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    scope : dim as long ignored = alpha : end scope
    if (blender <> 0) orelse (param <> 0) then : end if
    TkoGfx.PutOr32( src, dst, w, h, src_pitch, dst_pitch )
end sub

sub TkoPutXor alias "fb_hPutXor" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    scope : dim as long ignored = alpha : end scope
    if (blender <> 0) orelse (param <> 0) then : end if
    TkoGfx.PutXor32( src, dst, w, h, src_pitch, dst_pitch )
end sub

'' ALPHA -- source alpha over destination, no alpha argument.
''
'' `PUT ..., ALPHA` and `PUT ..., ALPHA, n` are DIFFERENT MODES, 6 and 9, with
'' different blenders. This is 6; fb_hPutBlend is 9.
sub TkoPutAlpha alias "fb_hPutAlpha" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    scope : dim as long ignored = alpha : end scope
    if (blender <> 0) orelse (param <> 0) then : end if
    '' 16bpp has PutAdd16, which is the narrow ALPHA-with-value path, not this
    '' one. There is no narrow source-alpha routine: a paletted or RGB565 pixel
    '' carries no alpha channel to read.
    TkoGfx.PutAlpha32( src, dst, w, h, src_pitch, dst_pitch )
end sub

'' ALPHA, n -- mode 9. The constant alpha arrives in the seventh argument.
''
'' UNTESTED AGAINST gfxlib2. raster/put.bi says so at PutBlend32: it is the one
'' putter with no A/B case, because no PUT syntax reaches it -- DRAW STRING is
'' its caller. It becomes testable when that entry point is gated.
sub TkoPutBlend alias "fb_hPutBlend" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    if (blender <> 0) orelse (param <> 0) then : end if
    if TkoGfx.PutBlendBpp = 2 then
        TkoGfx.PutAdd16( src, dst, w, h, src_pitch, dst_pitch, alpha )
    else
        TkoGfx.PutBlend32( src, dst, w, h, src_pitch, dst_pitch, alpha )
    end if
end sub

'' CUSTOM -- the user's function decides every pixel, magenta included.
''
'' The callback is CDECL and is user code called from the library, which is the
'' one place on win32 where getting the convention wrong corrupts the stack
'' rather than producing a wrong picture. tools/abtest-put.bas drives it through
'' gfxlib2's own PUT, so the convention is checked there.
sub TkoPutCustom alias "fb_hPutCustom" ( _
        byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, _
        byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long, byval blender as any ptr, byval param as any ptr )
    scope : dim as long ignored = alpha : end scope
    TkoGfx.PutCustom32( src, dst, w, h, src_pitch, dst_pitch, _
                        cast( TkoGfx.PutBlender, blender ), param )
end sub

end extern
