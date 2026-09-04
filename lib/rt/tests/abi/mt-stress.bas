'' mt-stress.bas -- the temporary-descriptor pool under real contention.
''
'' Everything measured so far has been single-threaded. The locking in
'' src/str/core.bas was derived from PROBE-15 -- fb_hStrAllocTemp( NULL, n )
'' takes a descriptor from the pool, which is why the _NoLock twins exist -- and
'' has never actually run with threads competing for it.
''
'' The pool is 256 entries shared by every thread. Under FB_STRLOCK it should be
'' safe; without it, two threads can be handed the SAME descriptor, and the
'' symptom would be a wrong string rather than a crash.
''
'' Each thread builds strings whose contents encode its own id, so a descriptor
'' handed to two threads at once produces a value that cannot occur otherwise.
'' Every thread checks its own results and reports a count; the totals are then
'' compared between the two runtimes.
''
'' NEEDS-MT
''
'' The marker is not decoration: fbc's driver already links libfbmt.a for a
'' program that uses THREADCREATE, so before it existed this test was linked
'' against tiko-rt's SINGLE-THREADED objects and fbc's MULTI-THREADED archive.
'' That happened to work only while tiko-rt owned no threading member; the
'' moment it did, the two disagreed about fb_TlsGetCtx and the link failed --
'' which is the honest failure, because ENABLE_MT changes what the TLS table
'' IS and an st-linked threading test measures the wrong library.
''
'' Run it several times: a lock bug that shows up one run in ten still shows up.

#include once "fbthread.bi"

const NTHREADS = 8
const NITERS   = 20000

dim shared as integer errCount( 0 to NTHREADS - 1 )
dim shared as integer okCount( 0 to NTHREADS - 1 )

sub worker( byval pid as any ptr )
    dim as integer id = cint( cast( integer, pid ) )
    dim as string tag = str( id )
    dim as integer bad = 0, good = 0

    for i as integer = 1 to NITERS
        '' Several temporaries live at once, all carrying this thread's id.
        dim as string a = tag + "-a"
        dim as string b = tag + "-b"
        dim as string c = (a + "|") + (b + "|")

        '' If a descriptor were shared with another thread, c would contain a
        '' different id than this thread's.
        if( c <> tag + "-a|" + tag + "-b|" ) then
            bad += 1
        else
            good += 1
        end if

        '' Churn the pool harder: a temporary that is created and dropped.
        if( len( (a + b) + (b + a) ) <> 4 * len( tag ) + 8 ) then bad += 1
    next

    errCount( id ) = bad
    okCount( id ) = good
end sub

dim as any ptr h( 0 to NTHREADS - 1 )

for i as integer = 0 to NTHREADS - 1
    h( i ) = threadcreate( @worker, cast( any ptr, cast( integer, i ) ) )
next
for i as integer = 0 to NTHREADS - 1
    if( h( i ) <> 0 ) then threadwait( h( i ) )
next

dim as integer totalBad = 0, totalOk = 0
for i as integer = 0 to NTHREADS - 1
    totalBad += errCount( i )
    totalOk += okCount( i )
next

print "threads="; NTHREADS; " iters="; NITERS
print "ok="; totalOk; " corrupt="; totalBad
if( totalBad = 0 ) then
    print "mt-stress: clean"
else
    print "mt-stress: CORRUPTION"
end if
end totalBad
