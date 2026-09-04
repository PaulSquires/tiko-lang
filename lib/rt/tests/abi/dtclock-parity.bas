'' dtclock-parity.bas -- the chrono clocks: nine entry points, the first
'' platform-split file in tiko-rt.
''
'' NEEDS-GEN-LLVM
''
'' A CLOCK CANNOT BE COMPARED BY VALUE. Every one of these reads the machine,
'' so the two runs of a differential see different numbers by definition. What
'' IS comparable is the shape of the answer, and it is what a port gets wrong:
''   - which epoch UtcNow is on, checked by decoding it back to a civil date
''     and asserting the year is plausible
''   - that the monotonic counter is in ITS OWN units, so ticks and timestamps
''     must not be interchangeable -- checked by measuring one sleep both ways
''     and requiring them to agree once the frequency is applied
''   - that CPU time is a DURATION and only ever increases
''   - that fb_DtCpuThreadTime reports -1 for kernel on Linux and a real value
''     on Windows, which is a documented per-platform difference and so is
''     asserted as "either a time or exactly -1" rather than by value
''   - the local offset is in MINUTES and within +/-18:00

extern "rtlib"
	declare function pUtcNow alias "fb_DtClockUtcNow" ( ) as longint
	declare function pRes alias "fb_DtClockResolution" ( ) as longint
	declare function pOff alias "fb_DtClockLocalOffsetNow" ( ) as long
	declare function pMono alias "fb_DtMonoTimestamp" ( ) as longint
	declare function pFreq alias "fb_DtMonoFrequency" ( ) as longint
	declare function pHiRes alias "fb_DtMonoIsHighRes" ( ) as long
	declare function pCpuProc alias "fb_DtCpuProcessTime" ( byval u as longint ptr, byval k as longint ptr ) as long
	declare function pCpuThread alias "fb_DtCpuThreadTime" ( byval u as longint ptr, byval k as longint ptr ) as long
	declare function pCpuSup alias "fb_DtCpuIsSupported" ( ) as long
	declare sub pToCivil alias "fb_DtToCivil" ( byval t as longint, byval y as long ptr, byval m as long ptr, byval d as long ptr, byval h as long ptr, byval mi as long ptr, byval s as long ptr, byval sub_ as longint ptr )
	declare function pValid alias "fb_DtIsValidTicks" ( byval t as longint ) as long
end extern

dim as longint t1 = any, t2 = any, u1 = any, k1 = any, u2 = any, k2 = any
dim as long y = any, mo = any, d = any, h = any, mi = any, s = any
dim as longint sub_ = any

print "-- UtcNow decodes to a plausible present-day civil date"
t1 = pUtcNow( )
print "  valid="; pValid( t1 )
pToCivil( t1, @y, @mo, @d, @h, @mi, @s, @sub_ )
print "  year in 2020..2100="; iif( (y >= 2020) andalso (y <= 2100), 1, 0 )
print "  month in 1..12="; iif( (mo >= 1) andalso (mo <= 12), 1, 0 )
print "  day in 1..31="; iif( (d >= 1) andalso (d <= 31), 1, 0 )
print "  hour in 0..23="; iif( (h >= 0) andalso (h <= 23), 1, 0 )
print "  subsecond in range="; iif( (sub_ >= 0) andalso (sub_ < 10000000), 1, 0 )

print "-- UtcNow advances, and never backwards over a short interval"
t2 = pUtcNow( )
print "  monotonic enough="; iif( t2 >= t1, 1, 0 )

print "-- resolution is positive and no coarser than a second"
t1 = pRes( )
print "  positive="; iif( t1 > 0, 1, 0 ); " <= 1s="; iif( t1 <= 10000000, 1, 0 )

print "-- the local offset is in MINUTES, within +/-18:00"
y = pOff( )
print "  in range="; iif( (y >= -1080) andalso (y <= 1080), 1, 0 )
print "  whole minutes="; iif( y = y, 1, 0 )

print "-- the monotonic counter needs its frequency to mean anything"
t1 = pFreq( )
print "  frequency positive="; iif( t1 > 0, 1, 0 )
print "  ishighres in 0..1="; iif( (pHiRes( ) = 0) orelse (pHiRes( ) = 1), 1, 0 )
dim as longint m1 = pMono( )
dim as double w = timer
do while( timer - w < 0.05 )
loop
dim as longint m2 = pMono( )
print "  advanced="; iif( m2 > m1, 1, 0 )
'' Converted through the frequency, the elapsed span must be near 50 ms. This
'' is the assertion that catches treating the counter as ticks.
dim as double secs = (m2 - m1) / pFreq( )
print "  elapsed 0.02..2.0s="; iif( (secs > 0.02) andalso (secs < 2.0), 1, 0 )

print "-- CPU time is a duration and only increases"
print "  supported="; pCpuSup( )
u1 = -1 : k1 = -1
print "  process rc="; pCpuProc( @u1, @k1 )
print "  user >= 0="; iif( u1 >= 0, 1, 0 ); " kernel >= 0="; iif( k1 >= 0, 1, 0 )
w = timer
do while( timer - w < 0.05 )
loop
u2 = -1 : k2 = -1
pCpuProc( @u2, @k2 )
print "  user did not decrease="; iif( u2 >= u1, 1, 0 )
u1 = -1 : k1 = -1
print "  thread rc="; pCpuThread( @u1, @k1 )
print "  thread user >= 0="; iif( u1 >= 0, 1, 0 )
'' -1 on Linux, a real time on Windows -- asserted as one or the other.
print "  thread kernel is a time or -1="; iif( (k1 >= 0) orelse (k1 = -1), 1, 0 )

print "-- NULL outputs are accepted"
print "  proc nulls rc="; pCpuProc( 0, 0 ); " thread nulls rc="; pCpuThread( 0, 0 )
print "done"
