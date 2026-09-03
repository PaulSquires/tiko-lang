'' put.bi -- the ten PUT blend modes, 32bpp.
''
'' Derived from: gfx_put_pset.c, _preset.c, _trans.c, _and.c, _or.c, _xor.c,
'' _alpha.c, _add.c, _blend.c, _custom.c. LGPL-2.1-or-later with the
'' static-linking exception.
''
'' THE TEN MODES SPLIT INTO THREE FAMILIES, and they are not implemented alike:
''
''   PSET                     a straight pixel copy
''   PRESET, AND, OR, XOR     BYTEWISE -- they do not know about pixels at all.
''                            gfxlib2 converts the width with `w <<= bpp >> 1`
''                            (bpp 1,2,4 -> shift 0,1,2) and then works in
''                            bytes/shorts/ints. The result is identical at every
''                            depth, which is why there is one implementation
''                            rather than three.
''   TRANS, ALPHA, ADD, BLEND per-pixel arithmetic, one variant per depth
''
'' MASK_COLOR_32 IS &hFF00FF -- MAGENTA. TRANS and ADD skip a source pixel whose
'' low 24 bits equal it. That is a colour a program can legitimately want, and it
'' will be invisible under those modes. Not a bug to fix: it is the documented
'' transparent colour.
''
'' ALPHA USES (a + 1), NOT a. `a = (sc shr 24) + 1` so the multiplier runs 1..256
'' rather than 0..255, which makes a fully opaque source exactly replace the
'' destination. Using `a` directly leaves a fully opaque pixel one part in 255
'' short, which is invisible on one blend and drifts over many.
''
'' ADD IS SATURATING, done branchlessly with the classic carry-mask trick rather
'' than a per-channel min(). Transcribed as-is: the sequence is not obvious and
'' rewriting it "clearly" is how the saturation boundary gets lost.

#pragma once

#include once "../core/surface.bi"

namespace TkoGfx

const MASK_COLOR_32 = &h00FF00FF
const MASK_RB_32    = &h00FF00FF
const MASK_GA_32    = &hFF00FF00
const MASK_A_32     = &hFF000000

'' The transparent colour at each depth. NOT the same value, and not the same
'' KIND of value: at 8bpp it is palette index 0, at 16bpp it is magenta in 565,
'' at 32bpp magenta in 888.
const MASK_COLOR_8  = 0
const MASK_COLOR_16 = &hF81F

'' A blender callback, for the BLEND and CUSTOM modes.
type PutBlender as function cdecl ( byval src as ulong, byval dst as ulong, byval param as any ptr ) as ulong

'' Every putter takes the same shape: a w-by-h block from `src` to `dst`, with
'' pitches in BYTES. Rows are walked explicitly rather than by advancing a
'' pointer, which keeps the inner loop a simple indexed run over `integer`
'' counters -- the form that vectorises.
#macro TKO_PUT_ROWS( body )
    dim as integer row = 0
    while row < h
        dim as ulong ptr s = cptr( ulong ptr, cptr( ubyte ptr, src ) + row * src_pitch )
        dim as ulong ptr d = cptr( ulong ptr, cptr( ubyte ptr, dst ) + row * dst_pitch )
        dim as integer i = 0
        while i < w
            body
            i += 1
        wend
        row += 1
    wend
#endmacro

private sub PutPSet32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    TKO_PUT_ROWS( d[i] = s[i] )
end sub

private sub PutPReset32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    TKO_PUT_ROWS( d[i] = (not s[i]) )
end sub

private sub PutAnd32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    TKO_PUT_ROWS( d[i] = d[i] and s[i] )
end sub

private sub PutOr32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    TKO_PUT_ROWS( d[i] = d[i] or s[i] )
end sub

private sub PutXor32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    TKO_PUT_ROWS( d[i] = d[i] xor s[i] )
end sub

'' Skip magenta -- and STRIP THE ALPHA CHANNEL from what is written.
''
'' gfxlib2 computes `c = *s and &h00FFFFFF` and writes `c`, not `*s`. So TRANS
'' does not copy the source pixel: it copies the source pixel with alpha forced
'' to zero. Writing `d[i] = s[i]` is the obvious reading, passes on any source
'' whose alpha happens to be 0, and was caught here only because the test source
'' carries VARIED alpha.
private sub PutTrans32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    TKO_PUT_ROWS( dim as ulong c = s[i] and &hFFFFFF : if c <> MASK_COLOR_32 then d[i] = c )
end sub

'' Source alpha over destination. Multiplier is a+1 -- see the header.
private sub PutAlpha32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    dim as integer row = 0
    while row < h
        dim as ulong ptr s = cptr( ulong ptr, cptr( ubyte ptr, src ) + row * src_pitch )
        dim as ulong ptr d = cptr( ulong ptr, cptr( ubyte ptr, dst ) + row * dst_pitch )
        dim as integer i = 0
        while i < w
            dim as ulong sc = s[i]
            dim as ulong dc = d[i]
            dim as ulong a = (sc shr 24) + 1
            dim as ulong srb = sc and MASK_RB_32
            dim as ulong sga = sc and MASK_GA_32
            dim as ulong drb = dc and MASK_RB_32
            dim as ulong dga = dc and MASK_GA_32
            srb = ((srb - drb) * a) shr 8
            sga = ((sga shr 8) - (dga shr 8)) * a
            d[i] = ((drb + srb) and MASK_RB_32) or ((dga + sga) and MASK_GA_32)
            i += 1
        wend
        row += 1
    wend
end sub

'' Saturating add, scaled by `alpha`. Branchless carry-mask trick, transcribed.
private sub PutAdd32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long )
    dim as integer row = 0
    while row < h
        dim as ulong ptr s = cptr( ulong ptr, cptr( ubyte ptr, src ) + row * src_pitch )
        dim as ulong ptr d = cptr( ulong ptr, cptr( ubyte ptr, dst ) + row * dst_pitch )
        dim as integer i = 0
        while i < w
            dim as ulong sc = s[i]
            dim as ulong dc = d[i]
            if (sc and &hFFFFFF) <> MASK_COLOR_32 then
                dim as ulong t1 = sc and &h00FF00FF
                dim as ulong t2 = (sc shr 8) and &h00FF00FF
                t1 = ((t1 * alpha) shr 8) and &h00FF00FF
                t2 = (t2 * alpha) and &hFF00FF00
                sc = t1 or t2
                t1 = sc and &h80808080
                t2 = dc and &h80808080
                sc = (sc and &h7F7F7F7F) + (dc and &h7F7F7F7F)
                dc = t1
                t1 = t1 or t2
                t2 = dc and t2
                dc = t1 and sc
                sc or= (((((t2 or dc) shr 7) + &h7F7F7F7F) xor &h7F7F7F7F) or t1)
                d[i] = sc
            end if
            i += 1
        wend
        row += 1
    wend
end sub

'' BLEND IS NOT A CALLBACK. The name suggests one, and the putter signature
'' carries a blender pointer, but fb_hPutBlend4C ignores it entirely: BLEND is
'' ALPHA driven by the `alpha` PARAMETER instead of by the source's alpha
'' channel, and it skips magenta the way TRANS does.
''
'' So the pair is:
''   BLEND   uniform alpha from the argument, transparent-colour aware
''   ALPHA   per-pixel alpha from the source, NOT transparent-colour aware
''   CUSTOM  the only mode that actually calls out per pixel
''
'' `alpha` is incremented first, same 1..256 reasoning as ALPHA.
''
'' UNVERIFIED. `PUT ..., BLEND` is a syntax error -- fbc does not expose BLEND as
'' a PUT mode keyword, so there is no way to drive gfxlib2's version of it from a
'' test. Every other mode here is A/B-checked; this one is transcribed and
'' unchecked, and says so. It becomes testable when DRAW STRING lands, which is
'' the caller that actually reaches it.
private sub PutBlend32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long )
    alpha += 1
    dim as integer row = 0
    while row < h
        dim as ulong ptr s = cptr( ulong ptr, cptr( ubyte ptr, src ) + row * src_pitch )
        dim as ulong ptr d = cptr( ulong ptr, cptr( ubyte ptr, dst ) + row * dst_pitch )
        dim as integer i = 0
        while i < w
            dim as ulong sc = s[i]
            if (sc and &hFFFFFF) <> MASK_COLOR_32 then
                dim as ulong dc = d[i]
                dim as ulong srb = sc and MASK_RB_32
                dim as ulong sga = sc and MASK_GA_32
                dim as ulong drb = dc and MASK_RB_32
                dim as ulong dga = dc and MASK_GA_32
                srb = ((srb - drb) * alpha) shr 8
                sga = ((sga shr 8) - (dga shr 8)) * alpha
                d[i] = ((drb + srb) and MASK_RB_32) or ((dga + sga) and MASK_GA_32)
            end if
            i += 1
        wend
        row += 1
    wend
end sub

'' CUSTOM: the user's function decides every pixel. Note it is called for EVERY
'' pixel including magenta -- CUSTOM has no transparent-colour handling, because
'' the callback is free to implement whatever it wants.
private sub PutCustom32( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long, _
        byval blender as PutBlender, byval param as any ptr )
    if blender = 0 then exit sub
    dim as integer row = 0
    while row < h
        dim as ulong ptr s = cptr( ulong ptr, cptr( ubyte ptr, src ) + row * src_pitch )
        dim as ulong ptr d = cptr( ulong ptr, cptr( ubyte ptr, dst ) + row * dst_pitch )
        dim as integer i = 0
        while i < w
            d[i] = blender( s[i], d[i], param )
            i += 1
        wend
        row += 1
    wend
end sub

'' ---------------------------------------------------------------- 8 and 16 bpp
''
'' THREE MODES SILENTLY BECOME OTHER MODES AT LOW DEPTH. gfxlib2's per-mode
'' dispatch tables are indexed by bpp, and several entries point at a DIFFERENT
'' putter rather than at a narrow variant of the same one:
''
''   ALPHA at 8bpp   -> PSET   (fb_hPutPSetC)
''   ALPHA at 16bpp  -> PSET   (fb_hPutPSetC)
''   ADD   at 8bpp   -> OR     (fb_hPutOrC)
''
'' So `PUT ..., ALPHA` on an 8bpp image is a plain copy, and `PUT ..., ADD` on
'' one is a bitwise OR. Neither is documented as such and neither is obvious from
'' the mode name; both are visible only in the dispatch table.
''
'' TRANS has real variants at every depth, but the transparent colour differs --
'' index 0 at 8bpp, 565 magenta at 16bpp.

private sub PutPSet8( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    dim as integer row = 0
    while row < h
        dim as ubyte ptr s = cptr( ubyte ptr, src ) + row * src_pitch
        dim as ubyte ptr d = cptr( ubyte ptr, dst ) + row * dst_pitch
        dim as integer i = 0
        while i < w
            d[i] = s[i]
            i += 1
        wend
        row += 1
    wend
end sub

private sub PutPSet16( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    dim as integer row = 0
    while row < h
        dim as ushort ptr s = cptr( ushort ptr, cptr( ubyte ptr, src ) + row * src_pitch )
        dim as ushort ptr d = cptr( ushort ptr, cptr( ubyte ptr, dst ) + row * dst_pitch )
        dim as integer i = 0
        while i < w
            d[i] = s[i]
            i += 1
        wend
        row += 1
    wend
end sub

'' TRANS at 8bpp skips index 0, not magenta.
private sub PutTrans8( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    dim as integer row = 0
    while row < h
        dim as ubyte ptr s = cptr( ubyte ptr, src ) + row * src_pitch
        dim as ubyte ptr d = cptr( ubyte ptr, dst ) + row * dst_pitch
        dim as integer i = 0
        while i < w
            if s[i] <> MASK_COLOR_8 then d[i] = s[i]
            i += 1
        wend
        row += 1
    wend
end sub

private sub PutTrans16( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long )
    dim as integer row = 0
    while row < h
        dim as ushort ptr s = cptr( ushort ptr, cptr( ubyte ptr, src ) + row * src_pitch )
        dim as ushort ptr d = cptr( ushort ptr, cptr( ubyte ptr, dst ) + row * dst_pitch )
        dim as integer i = 0
        while i < w
            if s[i] <> MASK_COLOR_16 then d[i] = s[i]
            i += 1
        wend
        row += 1
    wend
end sub

'' ADD at 16bpp: the 565 channels are unpacked into one 32-bit word with the
'' 0x07C0F81F trick, scaled, added, then the carries are folded back. `alpha` is
'' rescaled to 0..32 first -- (alpha + 7) shr 3 -- because the channels are five
'' and six bits wide rather than eight.
private sub PutAdd16( byval src as any ptr, byval dst as any ptr, _
        byval w as long, byval h as long, byval src_pitch as long, byval dst_pitch as long, _
        byval alpha as long )
    alpha = (alpha + 7) shr 3
    dim as integer row = 0
    while row < h
        dim as ushort ptr s = cptr( ushort ptr, cptr( ubyte ptr, src ) + row * src_pitch )
        dim as ushort ptr d = cptr( ushort ptr, cptr( ubyte ptr, dst ) + row * dst_pitch )
        dim as integer i = 0
        while i < w
            dim as ulong sc = s[i]
            dim as ulong dc = d[i]
            if sc <> MASK_COLOR_16 then
                sc = ((sc shl 16) or sc) and &h07C0F81F
                sc = ((sc * alpha) shr 5) and &h07C0F81F
                dc = ((dc shl 16) or dc) and &h07C0F81F
                sc += dc
                dim as ulong overflow = sc and &h08010020
                overflow -= (overflow shr 5)
                sc or= overflow
                sc and= &h07C0F81F
                sc or= (sc shr 16)
                d[i] = cast( ushort, sc and &hFFFF )
            end if
            i += 1
        wend
        row += 1
    wend
end sub

end namespace
