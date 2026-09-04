'' alloc-parity.bas -- Gate 3: does tiko-rt's allocator behave like fbc's?
''
'' PROBE-13 measured the C runtime's growth law by sweeping lengths and reading
'' `size` out of the descriptor fbc-int/string.bi publishes. This turns that
'' measurement into a test: the same sweep, printed, so the SAME BINARY built
'' against each runtime can be diffed.
''
''   fbc  tests/abi/alloc-parity.bas -p <fbc lib>     > c.txt
''   fbc  tests/abi/alloc-parity.bas -p <tiko-rt lib> > fb.txt
''   diff c.txt fb.txt      # must be empty
''
'' Why this exists as well as Gate 2: fbc's suite asserts what programs OBSERVE,
'' and `size` is not observable from ordinary FreeBASIC. A tiko-rt that allocated
'' exact-fit blocks would pass every one of the 4.9M assertions and still be the
'' wrong thing to benchmark, because allocation policy is most of what a
'' concatenation benchmark measures (RFC-0004 section 4).

#include once "fbc-int/string.bi"

dim as string s
dim as FBC.FBSTRING ptr d
dim as integer prev = -1

print "-- growth law: every step in len 0..1200"
for n as integer = 0 to 1200
    s = string( n, "a" )
    d = cptr( FBC.FBSTRING ptr, @s )
    if( d->size <> prev ) then
        print "  step len="; n; " size="; d->size
        prev = d->size
    end if
next

print "-- block is KEPT while the granule count is unchanged"
s = ""
dim as any ptr last = 0
dim as integer moves = 0
for n as integer = 1 to 64
    s = string( n, "b" )
    d = cptr( FBC.FBSTRING ptr, @s )
    if( last <> 0 andalso d->data <> last ) then moves += 1
    last = d->data
next
print "  pointer moves over len 1..64: "; moves

print "-- empty string owns no block"
s = ""
d = cptr( FBC.FBSTRING ptr, @s )
print "  len="; d->len; " size="; d->size; " data null? "; iif( d->data = 0, "yes", "no" )

print "-- concat results"
dim as string a = string( 30, "a" ), b = string( 40, "b" )
s = a + b
d = cptr( FBC.FBSTRING ptr, @s )
print "  30+40 -> len="; d->len; " size="; d->size

print "-- temp bit is never visible in a settled variable"
print "  len<0? "; iif( d->len < 0, "YES (bug)", "no" )
