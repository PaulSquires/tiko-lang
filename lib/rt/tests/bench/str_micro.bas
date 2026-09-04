'' str_micro.bas -- isolate WHICH string operation differs.
''
'' str_concat came out 2.6x slower on the first Gate 4 run and a whole-benchmark
'' number cannot say why. Each loop below leans on one path:
''
''   assign_literal   fb_StrAssign  -> fb_hStrRealloc, granule unchanged
''   assign_grow      fb_StrAssign  -> fb_hStrRealloc, granule changes often
''   append           fb_StrConcatAssign -> in-place growth
''   temp_churn       fb_hStrAllocTemp / fb_hStrDelTemp, one temporary per pass
''
'' Printed one line per case, "<name> <seconds>", so bench.sh's median logic
'' works unchanged.

const N = 200000

dim as double t0
dim as string s, a, b
dim as integer guard = 0

'' ---- assign of a fixed literal: same granule every time, no realloc expected
s = ""
t0 = timer
for i as integer = 1 to N
    s = "0123456789"
next
guard += len( s )
print "assign_literal "; timer - t0

'' ---- assign of varying length: crosses granule boundaries constantly
t0 = timer
for i as integer = 1 to N
    s = space( (i and 63) + 1 )
next
guard += len( s )
print "assign_grow "; timer - t0

'' ---- append in place
t0 = timer
s = ""
for i as integer = 1 to N
    s &= "abcdefgh"
    if (i and 511) = 0 then guard += len( s ) : s = ""
next
print "append "; timer - t0

'' ---- one temporary per iteration, allocated and released
a = "abcdefgh" : b = "12345678"
t0 = timer
for i as integer = 1 to N
    guard += len( a + b )
next
print "temp_churn "; timer - t0

if guard < 0 then print "impossible"
