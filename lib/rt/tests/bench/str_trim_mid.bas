'' str_trim_mid.bas -- the ASCII counterpart of wstr_micro.
''
'' RFC-0004 section 3.3 named the TRIM family as the most likely place for
'' FreeBASIC to lose, on the grounds that it is built out of `static __inline__`
'' helpers and fbc has no inliner. wstr_micro tested that prediction on the WIDE
'' side and it did not happen (0.92x-0.98x). This tests the narrow side, where
'' the helpers are fb_hStrSkipChar / fb_hStrSkipCharRev -- real FBCALL functions
'' in fbc, and an inline loop here, so the comparison is the opposite way round:
'' tiko-rt should be at an advantage, and a REGRESSION would be the surprise.
''
'' trim_nul exists because the right-hand scan now tests two characters rather
'' than one (0x20 and 0x00, RFC-0002 section 4.8) -- a contract that cost a
'' Linux gate to find, and one extra comparison per trailing byte to honour.
''
'' Each loop consumes its result with LEN so nothing is optimised away, and
'' allocates a fresh temporary every pass, which is what the entry points do.

const N = 100000

dim as double t0
dim as string padded, clean_, lead, trail, nul_, long_
dim as integer guard = 0

padded = "          the quick brown fox          "
clean_ = "the quick brown fox"
lead   = "          the quick brown fox"
trail  = "the quick brown fox          "
nul_   = "the quick brown fox" + chr(0,0,0,0,0,0,0,0,0,0)
long_  = string( 4096, "x" )

t0 = timer
for i as integer = 1 to N
    guard += len( trim( padded ) )
next
print "trim_padded "; timer - t0

'' The no-op case. fbc still copies -- it does not hand the source back -- so
'' this measures the scan plus an allocation, not an early exit.
t0 = timer
for i as integer = 1 to N
    guard += len( trim( clean_ ) )
next
print "trim_nothing "; timer - t0

t0 = timer
for i as integer = 1 to N
    guard += len( ltrim( lead ) )
next
print "ltrim "; timer - t0

t0 = timer
for i as integer = 1 to N
    guard += len( rtrim( trail ) )
next
print "rtrim "; timer - t0

'' Trailing NULs: the right-hand scan's second comparison, ten times per call.
t0 = timer
for i as integer = 1 to N
    guard += len( rtrim( nul_ ) )
next
print "rtrim_nul "; timer - t0

'' A long operand with nothing to trim: the scan is one comparison and the copy
'' is 4 KB, so this weighs fb_hStrCopy rather than the scan.
t0 = timer
for i as integer = 1 to N \ 10
    guard += len( trim( long_ ) )
next
print "trim_long "; timer - t0

t0 = timer
for i as integer = 1 to N
    guard += len( mid( padded, 11, 19 ) )
next
print "mid_middle "; timer - t0

'' Length omitted -- the "to the end" path, which is a different branch.
t0 = timer
for i as integer = 1 to N
    guard += len( mid( padded, 11 ) )
next
print "mid_toend "; timer - t0

t0 = timer
for i as integer = 1 to N
    guard += len( left( padded, 12 ) )
next
print "left "; timer - t0

t0 = timer
for i as integer = 1 to N
    guard += len( right( padded, 12 ) )
next
print "right "; timer - t0

if guard < 0 then print "impossible"
