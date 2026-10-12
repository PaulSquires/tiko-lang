'' abtest-events.bas -- A/B the event ring against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' gfxlib2's queue can be driven directly: `fb_hPostEvent` is a plain exported
'' symbol, and `SCREENEVENT` reads the same ring. So events are pushed into the
'' reference and into our queue in lockstep and the reads compared -- a real
'' A/B, not a restatement of the C.
''
'' Nothing here needs input from a human. Synthetic events are posted, which is
'' exactly how the driver thread posts real ones.
''
'' What is covered:
''
''   1. FIFO ORDER and the empty case.
''   2. THE PEEK. SCREENEVENT with no argument reports a pending event WITHOUT
''      consuming it, because the C only advances the head `if (event)`. Called
''      twice it must answer the same thing twice, and the following read must
''      still return the same event. An implementation that consumes on peek
''      passes every ordinary FIFO test.
''   3. WRAPAROUND. More than MAX_EVENTS posts and reads, so the mask is
''      exercised rather than the first 128 slots.
''   4. OVERFLOW DROPS THE OLDEST, SILENTLY. Post MAX_EVENTS + N without reading:
''      the first N are gone, the post still "succeeded", and the queue holds
''      MAX_EVENTS - 1. This is the case a "refuse when full" implementation
''      fails and nothing else does.
''   5. THE CAPACITY IS MAX_EVENTS - 1, not MAX_EVENTS. A head-equals-tail ring
''      cannot distinguish full from empty, so one slot is always sacrificed.
''      Off by one here and the drop happens a post too early or too late.
''
'' Split into roles (abtest.bi). Two loops had to change shape to be split at
'' all: they used to call chk only when the two sides disagreed, so the number
'' of cases depended on the reference and could not be recorded. They now report
'' every iteration, and the overflow drain is driven by OUR queue rather than by
'' whichever side runs dry first. That is more cases, not fewer.
''
'' A NOTE ON WHAT IS COMPARED. Event payloads are compared field by field on the
'' fields the type actually defines for the posted kind, not by a blind memcmp:
'' EVENT is a union, so the bytes outside the active member are whatever the
'' poster left there and are not part of the contract.

#include once "../core/events.ti"
#include once "abtest.bi"
#include once "crt/string.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

'' gfxlib2's poster. A plain exported symbol -- NOT FBCALL -- so it is cdecl on
'' every target here and needs no per-target declaration, unlike fb_hEncode.
'' Verified with nm on the win32 archive rather than assumed.
#ifdef ABTEST_HAS_GFXLIB2
declare sub fb_hPostEvent cdecl alias "fb_hPostEvent" ( byval e as TkoAbi.EVENT ptr )
#endif

#ifndef ABTEST_HAS_GFXLIB2
'' libtkogfx has no event-type constants of its own yet, so the reference role
'' takes this from fbgfx.bi and the subject role restates it. Restating a value
'' is exactly the thing that rots, so it is pinned by a recorded case below --
'' if fbgfx.bi ever renumbers, the recording changes and the subject fails.
const EVENT_KEY_PRESS = 1
#endif

sub chk( byref what as string, byval want as longint, byval got as longint )
    Abtest.Case_( what, want, got )
end sub

'' A check whose SUBJECT is the reference -- "gfxlib2's ring is empty now" --
'' rather than a comparison between the two. There is nothing for the subject
'' role to run, so it holds its place in the recording and is reported as a skip.
sub rchk( byref what as string, byval want as longint, byval got as longint )
    Abtest.Interop_( what, want, got )
end sub

'' The reference seam, in one place. Each of these is the whole of the A side
'' for one operation, and each answers zero in the subject role -- where Case_
'' ignores the answer and compares against the recording instead.
sub RefPost( byref e as TkoAbi.EVENT )
#ifdef ABTEST_HAS_GFXLIB2
    fb_hPostEvent( @e )
#endif
end sub

function RefGet( byref e as TkoAbi.EVENT ) as long
#ifdef ABTEST_HAS_GFXLIB2
    return iif( screenevent( @e ) <> 0, 1, 0 )
#else
    '' Zeroed rather than left alone: the fields are read straight after this
    '' and handed to Case_, which discards them, but reading a local nobody
    '' wrote is not a habit worth keeping in a test.
    memset( @e, 0, sizeof( TkoAbi.EVENT ) )
    return 0
#endif
end function

function RefPeek( ) as long
#ifdef ABTEST_HAS_GFXLIB2
    return iif( screenevent( ) <> 0, 1, 0 )
#else
    return 0
#endif
end function

'' Drain whatever the driver has already posted, so the comparison starts from a
'' known state. Without this, focus and mouse-enter events from opening the
'' screen are sitting in the reference's ring and every index is off.
sub DrainReference( )
#ifdef ABTEST_HAS_GFXLIB2
    dim as TkoAbi.EVENT e
    dim as long guard = 0
    while (screenevent( @e ) <> 0) andalso (guard < 4096)
        guard += 1
    wend
#endif
end sub

#ifdef ABTEST_HAS_GFXLIB2
screen 13
#endif

Abtest.Begin( "abtest-events", "the ring agrees, including the drops" )

dim as EventQueue q
EventQueueInit( q )
DrainReference( )

'' A distinguishable synthetic event. EVENT_KEY_PRESS carries scancode/ascii.
sub MakeKey( byref e as TkoAbi.EVENT, byval n as long )
    e.etype    = EVENT_KEY_PRESS
    e.scancode = 1000 + n
    e.ascii    = 65 + (n mod 26)
end sub

'' ---- 1. FIFO order, and empty ----
dim as TkoAbi.EVENT probe
chk( "EVENT_KEY_PRESS matches fbgfx.bi", REF( FB.EVENT_KEY_PRESS ), EVENT_KEY_PRESS )
rchk( "empty: reference", 0, RefGet( probe ) )
chk( "empty: ours", 0, EventGet( q, probe, 1 ) )

for n as integer = 0 to 9
    dim as TkoAbi.EVENT e
    MakeKey( e, n )
    RefPost( e )
    EventPost( q, e )
next

for n as integer = 0 to 9
    dim as TkoAbi.EVENT a, b
    dim as long ra = RefGet( a )
    dim as long rb = EventGet( q, b, 1 )
    chk( "fifo " + str(n) + " available", ra, rb )
    chk( "fifo " + str(n) + " type", a.etype, b.etype )
    chk( "fifo " + str(n) + " scancode", a.scancode, b.scancode )
    chk( "fifo " + str(n) + " ascii", a.ascii, b.ascii )
next

rchk( "drained: reference", 0, RefGet( probe ) )
chk( "drained: ours", 0, EventGet( q, probe, 1 ) )

'' ---- 2. the PEEK ----
scope
    dim as TkoAbi.EVENT e
    MakeKey( e, 77 )
    RefPost( e )
    EventPost( q, e )

    '' no argument: pending, but NOT consumed -- twice, to prove it
    for k as integer = 1 to 2
        rchk( "peek " + str(k) + ": reference", 1, RefPeek( ) )
        dim as TkoAbi.EVENT tmp
        chk( "peek " + str(k) + ": ours", 1, EventGet( q, tmp, 0 ) )
    next

    '' and the event survived both peeks
    dim as TkoAbi.EVENT a, b
    rchk( "after peek: reference still has it", 1, RefGet( a ) )
    chk( "after peek: ours still has it", 1, EventGet( q, b, 1 ) )
    chk( "after peek: same scancode", a.scancode, b.scancode )
    rchk( "after peek: now empty (reference)", 0, RefGet( a ) )
    chk( "after peek: now empty (ours)", 0, EventGet( q, b, 1 ) )
end scope

'' ---- 3. wraparound ----
scope
    '' post and read one at a time, more times than the ring is long, so the
    '' indices wrap repeatedly. Reported every iteration rather than only on
    '' disagreement, so the case count is the same in every role.
    for n as integer = 0 to MAX_EVENTS * 2 + 5
        dim as TkoAbi.EVENT e
        MakeKey( e, n )
        RefPost( e )
        EventPost( q, e )

        dim as TkoAbi.EVENT a, b
        dim as long ra = RefGet( a )
        dim as long rb = EventGet( q, b, 1 )
        chk( "wrap " + str(n) + " available", ra, rb )
        chk( "wrap " + str(n) + " scancode", a.scancode, b.scancode )
    next
end scope

'' ---- 4 + 5. overflow drops the OLDEST, and capacity is MAX_EVENTS - 1 ----
scope
    DrainReference( )
    EventQueueInit( q )

    const EXTRA = 10
    for n as integer = 0 to MAX_EVENTS + EXTRA - 1
        dim as TkoAbi.EVENT e
        MakeKey( e, n )
        RefPost( e )
        EventPost( q, e )
    next

    '' A head-equals-tail ring sacrifices one slot, so it holds MAX_EVENTS - 1.
    chk( "capacity is MAX_EVENTS - 1", MAX_EVENTS - 1, EventCount( q ) )

    '' Read everything back from both and compare the SEQUENCE. The survivors
    '' must be the NEWEST MAX_EVENTS - 1 posts, so the first one out is not
    '' event 0 -- that is the whole point.
    ''
    '' Driven by OUR queue: the loop used to stop when either side ran dry, and
    '' a bound set by the reference is a bound the subject cannot reproduce.
    '' A reference that stops early now shows up as a run of availability
    '' mismatches, which is what it should have been reporting all along.
    dim as long i = 0
    dim as long first_ref = -1
    dim as long first_ours = -1
    for k as integer = 0 to MAX_EVENTS - 2
        dim as TkoAbi.EVENT a, b
        dim as long ra = RefGet( a )
        dim as long rb = EventGet( q, b, 1 )
        chk( "overflow " + str(k) + " availability", ra, rb )
        chk( "overflow " + str(k) + " scancode", a.scancode, b.scancode )
        if rb = 0 then exit for
        if first_ref < 0 then
            first_ref = a.scancode
            first_ours = b.scancode
        end if
        i += 1
    next

    chk( "overflow: same number survived", MAX_EVENTS - 1, i )
    chk( "overflow: same oldest survivor", first_ref, first_ours )

    '' and it is NOT the first thing posted -- otherwise the drop never happened
    '' and this whole section proves nothing
    chk( "overflow: the oldest posts were dropped", _
         0, iif( first_ours <> 1000, 0, 1 ) )
    chk( "overflow: dropped exactly EXTRA + 1", 1000 + EXTRA + 1, first_ours )
end scope

#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
