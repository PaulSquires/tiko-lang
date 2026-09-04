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
'' A NOTE ON WHAT IS COMPARED. Event payloads are compared field by field on the
'' fields the type actually defines for the posted kind, not by a blind memcmp:
'' EVENT is a union, so the bytes outside the active member are whatever the
'' poster left there and are not part of the contract.

#include once "../core/events.bi"
#include once "fbgfx.bi"

using TkoGfx
using FB

'' gfxlib2's poster. A plain exported symbol -- NOT FBCALL -- so it is cdecl on
'' every target here and needs no per-target declaration, unlike fb_hEncode.
'' Verified with nm on the win32 archive rather than assumed.
declare sub fb_hPostEvent cdecl alias "fb_hPostEvent" ( byval e as TkoAbi.EVENT ptr )

dim shared as string report
dim shared as long failures = 0
dim shared as long ran = 0

sub chk( byref what as string, byval want as longint, byval got as longint )
    ran += 1
    if want <> got then
        report += "  MISMATCH " + what + " want " + str(want) + " got " + str(got) + chr(10)
        failures += 1
    end if
end sub

'' Drain whatever the driver has already posted, so the comparison starts from a
'' known state. Without this, focus and mouse-enter events from opening the
'' screen are sitting in the reference's ring and every index is off.
sub DrainReference( )
    dim as TkoAbi.EVENT e
    dim as long guard = 0
    while (screenevent( @e ) <> 0) andalso (guard < 4096)
        guard += 1
    wend
end sub

screen 13

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
chk( "empty: reference", 0, iif( screenevent( @probe ) <> 0, 1, 0 ) )
chk( "empty: ours", 0, EventGet( q, probe, 1 ) )

for n as integer = 0 to 9
    dim as TkoAbi.EVENT e
    MakeKey( e, n )
    fb_hPostEvent( @e )
    EventPost( q, e )
next

for n as integer = 0 to 9
    dim as TkoAbi.EVENT a, b
    dim as long ra = iif( screenevent( @a ) <> 0, 1, 0 )
    dim as long rb = EventGet( q, b, 1 )
    chk( "fifo " + str(n) + " available", ra, rb )
    chk( "fifo " + str(n) + " type", a.etype, b.etype )
    chk( "fifo " + str(n) + " scancode", a.scancode, b.scancode )
    chk( "fifo " + str(n) + " ascii", a.ascii, b.ascii )
next

chk( "drained: reference", 0, iif( screenevent( @probe ) <> 0, 1, 0 ) )
chk( "drained: ours", 0, EventGet( q, probe, 1 ) )

'' ---- 2. the PEEK ----
scope
    dim as TkoAbi.EVENT e
    MakeKey( e, 77 )
    fb_hPostEvent( @e )
    EventPost( q, e )

    '' no argument: pending, but NOT consumed -- twice, to prove it
    for k as integer = 1 to 2
        chk( "peek " + str(k) + ": reference", 1, iif( screenevent( ) <> 0, 1, 0 ) )
        dim as TkoAbi.EVENT tmp
        chk( "peek " + str(k) + ": ours", 1, EventGet( q, tmp, 0 ) )
    next

    '' and the event survived both peeks
    dim as TkoAbi.EVENT a, b
    chk( "after peek: reference still has it", 1, iif( screenevent( @a ) <> 0, 1, 0 ) )
    chk( "after peek: ours still has it", 1, EventGet( q, b, 1 ) )
    chk( "after peek: same scancode", a.scancode, b.scancode )
    chk( "after peek: now empty (reference)", 0, iif( screenevent( @a ) <> 0, 1, 0 ) )
    chk( "after peek: now empty (ours)", 0, EventGet( q, b, 1 ) )
end scope

'' ---- 3. wraparound ----
scope
    '' post and read one at a time, more times than the ring is long, so the
    '' indices wrap repeatedly
    for n as integer = 0 to MAX_EVENTS * 2 + 5
        dim as TkoAbi.EVENT e
        MakeKey( e, n )
        fb_hPostEvent( @e )
        EventPost( q, e )

        dim as TkoAbi.EVENT a, b
        dim as long ra = iif( screenevent( @a ) <> 0, 1, 0 )
        dim as long rb = EventGet( q, b, 1 )
        if (ra <> rb) orelse (a.scancode <> b.scancode) then
            chk( "wrap " + str(n) + " available", ra, rb )
            chk( "wrap " + str(n) + " scancode", a.scancode, b.scancode )
        end if
    next
    ran += 1        '' the loop above only reports on difference
end scope

'' ---- 4 + 5. overflow drops the OLDEST, and capacity is MAX_EVENTS - 1 ----
scope
    DrainReference( )
    EventQueueInit( q )

    const EXTRA = 10
    for n as integer = 0 to MAX_EVENTS + EXTRA - 1
        dim as TkoAbi.EVENT e
        MakeKey( e, n )
        fb_hPostEvent( @e )
        EventPost( q, e )
    next

    '' A head-equals-tail ring sacrifices one slot, so it holds MAX_EVENTS - 1.
    chk( "capacity is MAX_EVENTS - 1", MAX_EVENTS - 1, EventCount( q ) )

    '' Read everything back from both and compare the SEQUENCE. The survivors
    '' must be the NEWEST MAX_EVENTS - 1 posts, so the first one out is not
    '' event 0 -- that is the whole point.
    dim as long i = 0
    dim as long first_ref = -1
    dim as long first_ours = -1
    do
        dim as TkoAbi.EVENT a, b
        dim as long ra = iif( screenevent( @a ) <> 0, 1, 0 )
        dim as long rb = EventGet( q, b, 1 )
        if (ra = 0) andalso (rb = 0) then exit do
        if ra <> rb then
            chk( "overflow " + str(i) + " availability", ra, rb )
            exit do
        end if
        if first_ref < 0 then
            first_ref = a.scancode
            first_ours = b.scancode
        end if
        if a.scancode <> b.scancode then
            chk( "overflow " + str(i) + " scancode", a.scancode, b.scancode )
            exit do
        end if
        i += 1
    loop while i < MAX_EVENTS * 2

    chk( "overflow: same number survived", MAX_EVENTS - 1, i )
    chk( "overflow: same oldest survivor", first_ref, first_ours )

    '' and it is NOT the first thing posted -- otherwise the drop never happened
    '' and this whole section proves nothing
    chk( "overflow: the oldest posts were dropped", _
         0, iif( first_ours <> 1000, 0, 1 ) )
    chk( "overflow: dropped exactly EXTRA + 1", 1000 + EXTRA + 1, first_ours )
end scope

screen 0

print "abtest-events -- "; ran; " event-queue checks against gfxlib2"
if failures = 0 then
    print "abtest-events: PASS -- the ring agrees, including the drops"
    end 0
else
    print report;
    print "abtest-events: FAIL -- "; failures; " of"; ran; " differ"
    end 1
end if
