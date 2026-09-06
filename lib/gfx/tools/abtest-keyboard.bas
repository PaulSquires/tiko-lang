'' abtest-keyboard.bas -- A/B the key ring and MULTIKEY against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' `fb_hPostKey` is an exported symbol and is exactly what the driver calls when
'' a key arrives, so keys are pushed into gfxlib2's own ring and into ours in
'' lockstep and the reads compared. That is a real A/B and it needs NO
'' synthesised input.
''
'' NOTHING HERE INJECTS KEYSTROKES, AND THAT IS DELIBERATE. SendInput and
'' keybd_event deliver to whatever window has focus; if focus moves -- and it
'' does, because these suites open and close windows -- the keystrokes land in
'' whatever the author happens to have open. Posting to the library's own buffer
'' tests the same code path the driver drives, without ever touching the
'' desktop.
''
'' What is covered:
''
''   1. FIFO ORDER, and the empty case returning an empty string.
''   2. INKEY'S ENCODING, over the boundary. A code of 255 or less is ONE
''      character; anything larger is TWO, low byte first. Measured, and checked
''      here at 254, 255, 256 and 257 -- an implementation that special-cases the
''      chr(255) extended-key prefix instead of emitting the low byte agrees on
''      every real extended key and differs at 256 and 300.
''   3. KEYHIT does not consume, and agrees with the ring being non-empty.
''   4. OVERFLOW DROPS THE OLDEST. Sixteen slots means fifteen usable, so
''      twenty posts leave fifteen and the first one out is NOT the first one in.
''   5. WRAPAROUND, by posting and reading more times than the ring is long.
''   6. MULTIKEY's bounds: 0..127 answer from the table, everything outside
''      answers FALSE rather than erroring, and with no key held every scancode
''      is false.
''
'' MULTIKEY'S LIVE STATE IS NOT COMPARED, and that gap is real: the table is
'' refreshed from GetKeyboardState in the driver's frame loop, so making it
'' report TRUE means physically holding a key. What IS compared is the bounds
'' behaviour and the all-clear case, which is what the reference gives when no
'' key is down. Actual key-down reporting is left to the author's interactive
'' pass.

#include once "../core/keyboard.bi"
#include once "abtest.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

'' The driver's own entry point. A plain exported symbol, cdecl on every target.
#ifdef ABTEST_HAS_GFXLIB2
declare sub fb_hPostKey cdecl alias "fb_hPostKey" ( byval k as long )
#endif

Abtest.Begin( "abtest-keyboard", "the key ring and MULTIKEY agree" )

sub chk( byref what as string, byval want as longint, byval got as longint )
    Abtest.Case_( what, want, got )
end sub

'' Strings are compared through their digest, because that is the only thing a
'' recording can carry. The byte dump is still produced and handed to Case_ as
'' the detail line, so a mismatch reports what it always did.
sub chkstr( byref what as string, byref want as string, byref got as string )
    dim as string wd, gd
    for i as integer = 0 to len(want) - 1  : wd += " " + str(want[i])  : next
    for i as integer = 0 to len(got) - 1   : gd += " " + str(got[i])   : next
    Abtest.Case_( what, Abtest.Digest( want ), Abtest.Digest( got ), _
                  "want [" + wd + " ] got [" + gd + " ]" )
end sub

'' A check ABOUT the reference rather than against it -- see Interop_ in
'' abtest.bi. It keeps its slot in the recording and the subject skips it.
sub rchkstr( byref what as string, byref want as string, byref got as string )
    Abtest.Interop_( what, Abtest.Digest( want ), Abtest.Digest( got ) )
end sub

sub rchk( byref what as string, byval want as longint, byval got as longint )
    Abtest.Interop_( what, want, got )
end sub

'' The reference seam. INKEY answers the empty string in the subject role, which
'' is what an absent reference should look like to everything downstream.
function RefInkey( ) as string
#ifdef ABTEST_HAS_GFXLIB2
    return inkey
#else
    return ""
#endif
end function

'' The reference's ring may already hold keys from opening the screen.
sub DrainReference( )
#ifdef ABTEST_HAS_GFXLIB2
    dim as long guard = 0
    while (inkey <> "") andalso (guard < 4096)
        guard += 1
    wend
#endif
end sub

'' fb_hPostKey expects the driver lock held -- that is what SCREENLOCK takes.
sub PostRef( byval code as long )
#ifdef ABTEST_HAS_GFXLIB2
    screenlock
    fb_hPostKey( code )
    screenunlock
#endif
end sub

#ifdef ABTEST_HAS_GFXLIB2
screen 13
#endif

dim as KeyRing k
KeyRingInit( k )
DrainReference( )

'' ---- 1. empty, then FIFO ----
rchkstr( "empty: reference", "", RefInkey( ) )
chkstr( "empty: ours", "", KeyInkeyStr( KeyGet( k ) ) )
rchk( "empty: keyhit reference", 0, iif( RefInkey( ) <> "", 1, 0 ) )
chk( "empty: keyhit ours", 0, KeyHit( k ) )

dim as long codes(...) = { 65, 97, 13, 27, 32, 126 }
for i as integer = 0 to ubound( codes )
    PostRef( codes(i) )
    KeyPost( k, codes(i) )
next
for i as integer = 0 to ubound( codes )
    chkstr( "fifo " + str(codes(i)), RefInkey( ), KeyInkeyStr( KeyGet( k ) ) )
next
chkstr( "drained", RefInkey( ), KeyInkeyStr( KeyGet( k ) ) )

'' ---- 2. the encoding, across the one-byte boundary ----
''
'' 254 and 255 are single characters; 256 and 257 are two. The extended-key form
'' (scancode shl 8) or 255 is included because it is the common case, and 256 and
'' 300 are included because they are the ones a chr(255)-special-case gets wrong.
dim as long enc(...) = { 1, 65, 254, 255, 256, 257, 300, 511, 512, _
                         (72 shl 8) or 255, (77 shl 8) or 255, 1000, 65535 }
for i as integer = 0 to ubound( enc )
    PostRef( enc(i) )
    KeyPost( k, enc(i) )
    chkstr( "encode " + str(enc(i)), RefInkey( ), KeyInkeyStr( KeyGet( k ) ) )
next

'' ---- 3. KEYHIT does not consume ----
scope
    PostRef( 88 )
    KeyPost( k, 88 )
    '' asking twice must not eat it
    for t as integer = 1 to 2
        chk( "keyhit " + str(t) + " ours", 1, KeyHit( k ) )
    next
    chkstr( "still there after keyhit", RefInkey( ), KeyInkeyStr( KeyGet( k ) ) )
    chk( "empty after the read", 0, KeyHit( k ) )
end scope

'' ---- 4. overflow drops the OLDEST ----
scope
    DrainReference( )
    KeyRingInit( k )

    const EXTRA = 4
    for i as integer = 0 to KEY_BUFFER_LEN + EXTRA - 1
        PostRef( 1000 + i )
        KeyPost( k, 1000 + i )
    next

    chk( "capacity is KEY_BUFFER_LEN - 1", KEY_BUFFER_LEN - 1, KeyCount( k ) )

    '' Bounded by OUR ring, not by whichever side runs dry first: a loop whose
    '' trip count comes from the reference has a different trip count in a role
    '' with no reference, and the recording would not line up.
    dim as long n = 0
    dim as long first_ours = -1
    for t as integer = 0 to KEY_BUFFER_LEN - 2
        dim as string a = RefInkey( )
        dim as long bc = KeyGet( k )
        dim as string b = KeyInkeyStr( bc )
        chkstr( "overflow " + str(t), a, b )
        if b = "" then exit for
        if first_ours < 0 then first_ours = bc
        n += 1
    next

    chk( "overflow: same number survived", KEY_BUFFER_LEN - 1, n )
    '' and the drop really happened -- otherwise this section proves nothing
    chk( "overflow: the oldest posts were dropped", 0, iif( first_ours <> 1000, 0, 1 ) )
    chk( "overflow: dropped exactly EXTRA + 1", 1000 + EXTRA + 1, first_ours )
end scope

'' ---- 5. wraparound ----
scope
    DrainReference( )
    KeyRingInit( k )
    for i as integer = 0 to KEY_BUFFER_LEN * 3 + 5
        dim as long c = 33 + (i mod 90)
        PostRef( c )
        KeyPost( k, c )
        chkstr( "wrap " + str(i), RefInkey( ), KeyInkeyStr( KeyGet( k ) ) )
    next
end scope

'' ---- 6. MULTIKEY bounds, and all-clear ----
''
'' With no key held the reference answers false for every scancode. Out of range
'' is false too, not an error. Our table is cleared to match.
scope
    dim as KeyTable t
    KeyTableClear( t )

    dim as long probes(...) = { -1000, -1, 0, 1, 27, 64, 126, 127, 128, 200, 1000 }
    for i as integer = 0 to ubound( probes )
        chk( "multikey " + str(probes(i)), REF( multikey( probes(i) ) ), _
             KeyMultikey( t, probes(i) ) )
    next

    '' every in-range scancode, since a table indexed one byte wide would still
    '' pass a handful of spot checks
    dim as long diffs = 0
    for sc as integer = 0 to KEY_TABLE_LEN - 1
        if REF( multikey( sc ) ) <> KeyMultikey( t, sc ) then diffs += 1
    next
    chk( "multikey: all 128 scancodes agree with nothing held", 0, diffs )
end scope

#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
