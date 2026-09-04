'' str_concat -- the hottest path in libfb, and the first benchmark.
''
'' This is an ORDINARY FreeBASIC program. It is compiled by fbc, it uses STRING
'' and PRINT freely, and the only thing that changes between the two runs is
'' which libfb.a the linker finds. The freestanding subset does not apply here
'' (build/lint.sh checks src/ and tests/unit/ only).
''
'' It times itself and prints "<name> <seconds>" so that process startup, which
'' is dominated by fb_Init and console attach, stays outside the measurement.
'' build/bench.sh takes the MEDIAN of several runs.
''
'' What it exercises, deliberately, in one loop:
''   - fb_StrConcat into a temporary, and the temp-descriptor list behind it
''   - fb_StrAssign, including the realloc path as the accumulator grows
''   - fb_StrDelete on every temporary
''
'' The accumulator is reset periodically rather than grown without bound: an
'' ever-growing string turns this into a memcpy benchmark, which measures the
'' allocator and libc rather than the string layer.

const ITERS = 200000
const RESET_EVERY = 512

dim as double t0, t1
dim as string acc, piece
dim as integer i, guard

piece = "abcdefghijklmnop"
acc = ""
guard = 0

t0 = timer

for i = 1 to ITERS
    acc = acc + piece
    if (i mod RESET_EVERY) = 0 then
        '' Keep the result live so nothing can be optimised away, and keep the
        '' accumulator bounded so this stays a string-layer measurement.
        guard += len( acc )
        acc = ""
    end if
next

t1 = timer

'' Printed so the compiler cannot discard the work, but AFTER the clock stops.
if guard < 0 then print "impossible"; guard

print "str_concat "; t1 - t0
