'' probe-driver.bas -- the driver registry and the presentation path.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' There is no gfxlib2 counterpart to A/B against here -- its driver table is
'' internal and its presentation is only observable by looking at a window. So
'' this is a behavioural unit test, and it checks the things that actually go
'' wrong in a presenter:
''
''   - a present with nothing dirty must blit NOTHING, not the whole screen
''   - a present must blit exactly the rows that were marked
''   - a present must CLEAR the dirty state, so an immediate second present is
''     a no-op (the classic bug: every frame repaints everything because the
''     array is never cleared, and it looks like it works)
''   - drawing after a present must mark again from scratch

#include once "../driver/mem.bi"
#include once "../raster/line.bi"
#include once "../raster/box.bi"
#include once "crt/string.bi"

using TkoGfx

const W = 64
const H = 48

dim as long failures = 0

sub Check( byref what as string, byval got as long, byval want as long, byref fails as long )
    print "  "; what; " = "; got;
    if got = want then
        print "   ok"
    else
        print "   FAIL (expected "; want; ")"
        fails += 1
    end if
end sub

'' ---- registry ----
dim as DriverRegistry reg
DriverRegister( reg, @DriverNull )
DriverRegister( reg, @DriverMem )

print "probe-driver -- registry"
Check( "registered count ", reg.count, 2, failures )
Check( "find MEM         ", iif( DriverFind( reg, "MEM" ) = @DriverMem, 1, 0 ), 1, failures )
Check( "find mem (case)  ", iif( DriverFind( reg, "mem" ) = @DriverMem, 1, 0 ), 1, failures )
Check( "find NULL        ", iif( DriverFind( reg, "NULL" ) = @DriverNull, 1, 0 ), 1, failures )
Check( "find absent      ", iif( DriverFind( reg, "GDI" ) = 0, 1, 0 ), 1, failures )
Check( "NULL init ok     ", DriverNull.init( @"t", W, H, 32, 0, 0 ), 0, failures )

'' ---- presentation ----
dim as ubyte ptr dirty = allocate( H )
dim as any ptr pix = allocate( W * 4 * H )
memset( dirty, 0, H )

dim as Surface s
SurfaceInit( s, pix, W, H, W * 4, 4 )
s.dirty = dirty

MemReset( @s )
print "probe-driver -- presentation"

'' nothing drawn yet
DriverMem.update( )
Check( "clean present rows", MemLog.last_rows, 0, failures )

'' one horizontal line on row 10
DrawLine32( s, 0, 10, W - 1, 10, &hFFFFFFFF )
DriverMem.update( )
Check( "one line: rows    ", MemLog.last_rows, 1, failures )
Check( "one line: y1      ", MemLog.last_y1, 10, failures )

'' immediately present again -- the span must have been cleared
DriverMem.update( )
Check( "re-present rows   ", MemLog.last_rows, 0, failures )

'' a filled box over rows 20..29
LineBox32( s, 5, 20, 40, 29, &hFF00FF00, 1 )
DriverMem.update( )
Check( "box: rows         ", MemLog.last_rows, 10, failures )
Check( "box: y1           ", MemLog.last_y1, 20, failures )
Check( "box: y2           ", MemLog.last_y2, 29, failures )

'' two separate marks present as ONE span covering both, matching gfxlib2
DrawLine32( s, 0, 2, W - 1, 2, &hFFFFFFFF )
DrawLine32( s, 0, 44, W - 1, 44, &hFFFFFFFF )
DriverMem.update( )
Check( "two lines: y1     ", MemLog.last_y1, 2, failures )
Check( "two lines: y2     ", MemLog.last_y2, 44, failures )

Check( "total presents    ", MemLog.presents, 5, failures )

'' an untracked surface must never mark
dim as Surface img
SurfaceInit( img, pix, W, H, W * 4, 4 )      '' dirty stays NULL
LineBox32( img, 0, 0, W - 1, H - 1, &hFF0000FF, 1 )
dim as long q1, q2
Check( "untracked marks   ", DirtySpan( img, q1, q2 ), 0, failures )

deallocate( pix )
deallocate( dirty )

if failures = 0 then
    print "probe-driver: PASS"
    end 0
else
    print "probe-driver: FAIL -- "; failures; " check(s) failed"
    end 1
end if
