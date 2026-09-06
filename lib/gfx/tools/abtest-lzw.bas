'' abtest-lzw.bas -- A/B the LZW codec against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' NO FB STATEMENT REACHES THIS CODEC, so it cannot be driven the way every
'' other suite here drives its subject. `fb_hDecode` has one caller in the whole
'' tree -- the startup expansion of the built-in font and palette blob -- and
'' `fb_hEncode` has none at all; it exists so that blob can be produced offline.
''
'' Both are FBCALL exports, so they are called DIRECTLY and compared. That is a
'' weaker kind of A/B than a statement-level one -- it tests the symbol, not the
'' path a program takes to it -- and the difference is worth stating rather than
'' letting the suite look equivalent to the others.
''
'' Four comparisons per case, because byte-identical output is the strong claim
'' and interoperability is the useful one:
''
''   1. OUR ENCODER vs THEIRS, byte for byte, including the produced length.
''      Two LZW encoders agreeing on the decoded result is easy; agreeing on the
''      exact packed bytes requires the same table, the same hash probe, the
''      same code-assignment order and the same nibble packing.
''   2. THEIR STREAM THROUGH OUR DECODER -> the original input.
''   3. OUR STREAM THROUGH THEIR DECODER -> the original input. This is the one
''      that matters for a drop-in: their decoder is what expands the blob.
''   4. OUR STREAM THROUGH OUR DECODER, so a matched pair of bugs that cancel
''      is still visible as a difference from 2 and 3.
''
'' Inputs are chosen for the codec's failure modes, not for realism:
''   - runs and repeats, where the dictionary fills fastest
''   - incompressible data, where the output is LONGER than the input
''   - every byte value, so the 256 literal codes are all exercised
''   - lengths around the pairing boundary, since codes pack two per three bytes
''     and an odd count leaves a pending byte the trailer must account for
''   - input long enough to exhaust the 4096-code table
''
'' Split into roles (abtest.bi). Comparison 1 -- byte-identical encoder output
'' -- survives the split, because a digest of the reference's stream is exactly
'' what a recording can carry. Comparisons 2 and 3 do not: each feeds a stream
'' ONE codec produced to the OTHER codec, which has to be present to consume
'' it. Those are Interop_, and the subject reports them as skips.
''
'' THE OUTPUT-OVERFLOW PATH IS ASSERTED, NOT COMPARED. The reference computes
'' its decode limit after already advancing past the first byte, so it overruns
'' the caller's buffer by one on a maximally-sized output. We bound at the true
'' capacity. They differ only at that boundary, and reproducing a buffer overrun
'' to match is not worth doing.

#include once "../core/lzw.bi"
#include once "crt/string.bi"
#include once "abtest.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
#endif

using TkoGfx

'' NOT `name` and NOT `inp`. `NAME` is the file-rename statement and `INP` is
'' the port intrinsic -- the tenth and eleventh identifier collisions found in
'' this library. Both are hard errors here; the dangerous ones are the
'' intrinsics that bind SILENTLY.

'' gfxlib2's exports. FBCALL is cdecl on every target here.
'' FBCALL IS NOT ONE CALLING CONVENTION. It is cdecl on win64 and Linux and
'' STDCALL on win32, where the exported names carry both a leading underscore
'' and an @16 argument-size suffix: `_fb_hEncode@16`. Verified with nm against
'' the shipped archive.
''
'' Declaring them cdecl builds and runs on win64 and fails to LINK on win32 --
'' and the two symbols fail differently. The linker's stdcall-fixup silently
'' resolves `fb_hDecode` to `_fb_hDecode@16` with only a warning, because
'' gfx_lzw.o is already in the link (gfx_data.c calls it). `fb_hEncode` has no
'' other caller anywhere, so gfx_lzw_enc.o is never pulled from the archive and
'' nothing is there to fix up to.
''
'' The alias is the PLAIN name in both branches. The backend adds the leading
'' underscore itself, and stdcall appends @16, giving `_fb_hEncode@16`. Writing
'' the underscore into the alias produces `__fb_hEncode@16` -- and ld prints
'' that error as "undefined reference to `_fb_hEncode@16`", stripping one
'' underscore, so the message names exactly the symbol that DOES exist and the
'' mistake reads as a missing library.
#ifdef ABTEST_HAS_GFXLIB2
#ifdef __FB_64BIT__
    declare function fb_hEncode cdecl alias "fb_hEncode" ( _
        byval in_buffer as const ubyte ptr, byval in_size as integer, _
        byval out_buffer as ubyte ptr, byval out_size as integer ptr ) as long
    declare function fb_hDecode cdecl alias "fb_hDecode" ( _
        byval in_buffer as const ubyte ptr, byval in_size as integer, _
        byval out_buffer as ubyte ptr, byval out_size as integer ptr ) as long
#else
    declare function fb_hEncode stdcall alias "fb_hEncode" ( _
        byval in_buffer as const ubyte ptr, byval in_size as integer, _
        byval out_buffer as ubyte ptr, byval out_size as integer ptr ) as long
    declare function fb_hDecode stdcall alias "fb_hDecode" ( _
        byval in_buffer as const ubyte ptr, byval in_size as integer, _
        byval out_buffer as ubyte ptr, byval out_size as integer ptr ) as long
#endif
#endif

Abtest.Begin( "abtest-lzw", "streams are byte-identical and interoperable" )

sub chk( byref what as string, byval want as longint, byval got as longint )
    Abtest.Case_( what, want, got )
end sub

'' A check that needs the reference codec present to consume something we made
'' (or to have made something we consume). See Interop_ in abtest.bi.
sub rchk( byref what as string, byval want as longint, byval got as longint )
    Abtest.Interop_( what, want, got )
end sub

const CAP = 1 shl 20

dim shared as LzwTable tbl

'' TOUCH A GRAPHICS STATEMENT so fbc links the graphics library at all. Nothing
'' else in this file uses one -- the codec is reached by symbol, not by
'' statement -- and without this the fb_hEncode/fb_hDecode references are
'' undefined at link time. Doing it through SCREEN rather than #inclib picks
'' the right variant automatically across the mt and non-mt builds.
#ifdef ABTEST_HAS_GFXLIB2
screen 13
screen 0
#endif

'' One case: encode both ways, decode both ways, compare everything.
sub runcase( byref label_ as string, byref src as string )
    dim as integer n = len( src )
    if n = 0 then exit sub

    dim as ubyte ptr srcbuf = allocate( n )
    memcpy( srcbuf, strptr( src ), n )

    dim as ubyte ptr encA = allocate( CAP )   '' gfxlib2
    dim as ubyte ptr encB = allocate( CAP )   '' ours
    dim as ubyte ptr decA = allocate( CAP )
    dim as ubyte ptr decB = allocate( CAP )
    dim as ubyte ptr decC = allocate( CAP )

    dim as integer sizeA = CAP
    dim as integer sizeB = CAP
    dim as long rcA = 0
    dim as ulongint digA = 0
#ifdef ABTEST_HAS_GFXLIB2
    rcA = fb_hEncode( srcbuf, n, encA, @sizeA )
    if rcA = 0 then digA = Abtest.Digest( encA, sizeA )
#endif
    dim as long rcB = LzwEncode( tbl, srcbuf, n, encB, sizeB )
    dim as ulongint digB = 0
    if rcB = 0 then digB = Abtest.Digest( encB, sizeB )

    chk( label_ + " encode rc", rcA, rcB )
    chk( label_ + " encode size", sizeA, sizeB )

    '' ---- 1. byte-identical encoded stream ----
    ''
    '' Was a byte scan; now a digest, which says the same thing and is what a
    '' recording can carry. The scan still runs where both streams exist and
    '' names the first differing index in the detail line.
    dim as string detail = ""
#ifdef ABTEST_HAS_GFXLIB2
    if (rcA = 0) andalso (rcB = 0) andalso (sizeA = sizeB) then
        for i as integer = 0 to sizeA - 1
            if encA[i] <> encB[i] then
                detail = "first differing index " + str(i)
                exit for
            end if
        next
    end if
#endif
    Abtest.Case_( label_ + " encode bytes", digA, digB, detail )

    '' ---- 2. their stream, our decoder ----
    ''
    '' Needs a stream the reference produced. The subject cannot make one and a
    '' digest is not a stream, so the whole direction is reference-only.
    dim as long r2ok = 0, r2len = 0, r2bytes = 0
#ifdef ABTEST_HAS_GFXLIB2
    if rcA = 0 then
        dim as integer dn = CAP
        dim as long r2 = LzwDecode( tbl, encA, sizeA, decA, dn )
        r2ok = iif( r2 = 0, 1, 0 )
        r2len = iif( dn = n, 1, 0 )
        if (r2 = 0) andalso (dn = n) then r2bytes = iif( memcmp( decA, srcbuf, n ) = 0, 1, 0 )
    end if
#endif
    rchk( label_ + " theirs->ours rc", 1, r2ok )
    rchk( label_ + " theirs->ours len", 1, r2len )
    rchk( label_ + " theirs->ours bytes", 1, r2bytes )

    '' ---- 3. our stream, their decoder ----
    ''
    '' The direction that matters most for a drop-in: their decoder is what
    '' expands the built-in font blob. It needs their decoder present.
    dim as long r3ok = 0, r3len = 0, r3bytes = 0
#ifdef ABTEST_HAS_GFXLIB2
    if rcB = 0 then
        dim as integer dn2 = CAP
        dim as long r3 = fb_hDecode( encB, sizeB, decB, @dn2 )
        r3ok = iif( r3 = 0, 1, 0 )
        r3len = iif( dn2 = n, 1, 0 )
        if (r3 = 0) andalso (dn2 = n) then r3bytes = iif( memcmp( decB, srcbuf, n ) = 0, 1, 0 )
    end if
#endif
    rchk( label_ + " ours->theirs rc", 1, r3ok )
    rchk( label_ + " ours->theirs len", 1, r3len )
    rchk( label_ + " ours->theirs bytes", 1, r3bytes )

    '' ---- 4. our stream, our decoder ----
    ''
    '' Entirely ours, so it runs everywhere. Together with 1 it is what carries
    '' the claim under MSVC: our stream is byte-identical to the recorded one,
    '' and our decoder round-trips it.
    dim as long r4ok = 0, r4len = 0, r4bytes = 0
    if rcB = 0 then
        dim as integer dn3 = CAP
        dim as long r4 = LzwDecode( tbl, encB, sizeB, decC, dn3 )
        r4ok = iif( r4 = 0, 1, 0 )
        r4len = iif( dn3 = n, 1, 0 )
        if (r4 = 0) andalso (dn3 = n) then r4bytes = iif( memcmp( decC, srcbuf, n ) = 0, 1, 0 )
    end if
    chk( label_ + " ours->ours rc", 1, r4ok )
    chk( label_ + " ours->ours len", 1, r4len )
    chk( label_ + " ours->ours bytes", 1, r4bytes )

    deallocate( srcbuf )
    deallocate( encA ) : deallocate( encB )
    deallocate( decA ) : deallocate( decB ) : deallocate( decC )
end sub

'' ---- the corpus ----

'' lengths around the two-codes-per-three-bytes pairing boundary
for n as integer = 1 to 40
    dim as string s
    for i as integer = 1 to n
        s += chr( 65 + (i mod 3) )
    next
    runcase( "runs n=" + str(n), s )
next

'' a single repeated byte -- the fastest possible dictionary growth
for n as integer = 1 to 20
    runcase( "same n=" + str(n), string( n, "Q" ) )
next

'' every byte value, twice, so all 256 literal codes are used
scope
    dim as string s
    for pass as integer = 1 to 2
        for i as integer = 0 to 255
            s += chr( i )
        next
    next
    runcase( "all-bytes", s )
end scope

'' incompressible: a full-period LCG, so the encoder's output is LONGER than
'' its input and the pending-byte accounting is exercised under growth
scope
    dim as string s
    dim as ulong x = 12345
    for i as integer = 1 to 4096
        x = x * 1103515245ul + 12345ul
        s += chr( (x shr 16) and &hFF )
    next
    runcase( "random 4096", s )
end scope

'' long enough to exhaust the 4096-code table and pin next_code at MAX_CODE
scope
    dim as string s
    dim as ulong x = 999
    for i as integer = 1 to 70000
        x = x * 1103515245ul + 12345ul
        s += chr( (x shr 16) and &h3F )     '' 64 symbols -- fills the table fast
    next
    runcase( "table-exhausting 70000", s )
end scope

'' highly structured: nested repeats, where the KwKwK case fires
scope
    dim as string unit_ = "abcabcabcXYZ"
    dim as string s
    for i as integer = 1 to 400
        s += unit_
    next
    runcase( "nested repeats", s )
end scope

'' ---- error paths ----

'' A TRUNCATED STREAM IS AN ERROR, not a short read: the decoder returns -1 if
'' it runs out of input before the MAX_CODE terminator.
scope
    dim as string src = string( 300, "R" ) + "tail"
    dim as ubyte ptr srcbuf = allocate( len( src ) )
    memcpy( srcbuf, strptr( src ), len( src ) )
    dim as ubyte ptr enc = allocate( CAP )
    dim as integer sz = CAP
    '' Both halves need the reference's stream and the reference's decoder.
    for cut as integer = 1 to 4
        dim as long agreed = 0
#ifdef ABTEST_HAS_GFXLIB2
        if fb_hEncode( srcbuf, len( src ), enc, @sz ) = 0 then
            dim as integer short_ = sz - cut
            if short_ > 2 then
                dim as ubyte ptr d1 = allocate( CAP )
                dim as ubyte ptr d2 = allocate( CAP )
                dim as integer n1 = CAP, n2 = CAP
                dim as long ra = fb_hDecode( enc, short_, d1, @n1 )
                dim as long rb = LzwDecode( tbl, enc, short_, d2, n2 )
                agreed = iif( ra = rb, 1, 0 )
                deallocate( d1 ) : deallocate( d2 )
            end if
        end if
#endif
        rchk( "truncated -" + str(cut) + " rc", 1, agreed )
    next
    deallocate( srcbuf ) : deallocate( enc )
end scope

'' ENCODER OUTPUT OVERFLOW: too small a buffer must report -1 rather than write
'' past it. Compared, because the encoder's bound has no off-by-one.
scope
    dim as string src = string( 2000, "z" ) + "abcdefghij"
    dim as ubyte ptr srcbuf = allocate( len( src ) )
    memcpy( srcbuf, strptr( src ), len( src ) )
    for lim as integer = 1 to 24
        dim as ubyte ptr e1 = allocate( 4096 )
        dim as ubyte ptr e2 = allocate( 4096 )
        dim as integer s1 = lim, s2 = lim
        dim as long ra = 0
#ifdef ABTEST_HAS_GFXLIB2
        ra = fb_hEncode( srcbuf, len( src ), e1, @s1 )
#endif
        dim as long rb = LzwEncode( tbl, srcbuf, len( src ), e2, s2 )
        chk( "enc overflow cap=" + str(lim) + " rc", ra, rb )
        deallocate( e1 ) : deallocate( e2 )
    next
    deallocate( srcbuf )
end scope

'' DECODER OUTPUT OVERFLOW IS ASSERTED, NOT COMPARED -- see the file header.
'' The reference's limit is one byte past the caller's buffer, so at exactly the
'' boundary it writes one too many and we return -1. Our own contract is checked
'' instead: a capacity below the true output length must fail.
scope
    dim as string src = string( 500, "K" ) + "0123456789"
    dim as ubyte ptr srcbuf = allocate( len( src ) )
    memcpy( srcbuf, strptr( src ), len( src ) )
    dim as ubyte ptr enc = allocate( CAP )
    dim as integer sz = CAP
    if LzwEncode( tbl, srcbuf, len( src ), enc, sz ) = 0 then
        dim as ubyte ptr d = allocate( CAP )
        dim as integer n = len( src ) - 1
        chk( "dec overflow below length", -1, LzwDecode( tbl, enc, sz, d, n ) )
        n = len( src )
        chk( "dec exact capacity ok", 0, LzwDecode( tbl, enc, sz, d, n ) )
        chk( "dec exact capacity len", len( src ), n )
        deallocate( d )
    end if
    deallocate( srcbuf ) : deallocate( enc )
end scope

'' EMPTY INPUT. The C reads the first byte before testing the size, so an empty
'' input reads out of bounds; we refuse it. Asserted, and deliberately NOT
'' passed to the reference.
scope
    dim as ubyte b = 0
    dim as ubyte ptr o = allocate( 64 )
    dim as integer n = 64
    chk( "empty input refused", -1, LzwEncode( tbl, @b, 0, o, n ) )
    deallocate( o )
end scope

'' ---- THE ENCODER MUST CLEAR ITS TABLE ----
''
'' A missing clear does not produce wrong output: with no -1 marker anywhere the
'' probe never terminates and the process HANGS, so a negative test for it locks
'' up the suite instead of failing. Encoding the same input twice through the
'' SAME table turns that into an ordinary comparison -- the second stream must
'' equal the first, and equal the reference.
scope
    dim as string src = "the quick brown fox jumps over the lazy dog, twice over"
    src += src + src
    dim as ubyte ptr b = allocate( len( src ) )
    memcpy( b, strptr( src ), len( src ) )

    dim as ubyte ptr e1 = allocate( CAP )
    dim as ubyte ptr e2 = allocate( CAP )
    dim as integer n1 = CAP, n2 = CAP
    chk( "reuse: first encode rc",  0, LzwEncode( tbl, b, len( src ), e1, n1 ) )
    chk( "reuse: second encode rc", 0, LzwEncode( tbl, b, len( src ), e2, n2 ) )
    chk( "reuse: same length", n1, n2 )
    if n1 = n2 then chk( "reuse: same bytes", 0, memcmp( e1, e2, n1 ) )

    '' and still identical to the reference after the reuse
    dim as ubyte ptr e3 = allocate( CAP )
    dim as integer n3 = CAP
    dim as long rrc = 0
    dim as ulongint d3 = 0
#ifdef ABTEST_HAS_GFXLIB2
    rrc = fb_hEncode( b, len( src ), e3, @n3 )
    if rrc = 0 then d3 = Abtest.Digest( e3, n3 )
#endif
    chk( "reuse: reference rc", rrc, 0 )
    chk( "reuse: reference length", n3, n2 )
    chk( "reuse: reference bytes", d3, Abtest.Digest( e2, n2 ) )

    deallocate( b ) : deallocate( e1 ) : deallocate( e2 ) : deallocate( e3 )
end scope

Abtest.Finish_( )
