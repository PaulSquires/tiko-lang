'' rnd-parity.bas -- RND, RND32, RANDOMIZE and the PRNG state: four entry
'' points over five generators.
''
'' NEEDS-GEN-LLVM
''
'' FOUR OF THE FIVE GENERATORS ARE DETERMINISTIC and are compared value by
'' value from a fixed seed. FB_RND_REAL is not -- it reads OS entropy -- so it
'' is checked only for its STRUCTURE: that the state block reports the right
'' algorithm and length, and that consecutive draws differ.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - RND without RANDOMIZE must work, seeding on first use
''   - RANDOMIZE with CRT DISCARDS one value, so the first RND is the second
''     of the sequence
''   - QB seeds from the HIGH word of the double and keeps the previous seed's
''     low byte, so the same RANDOMIZE twice is not the same sequence
''   - QB divides in SINGLE, so its values differ in the low bits from a
''     double division
''   - RND(0) is the last value from fb_Rnd for CRT/MTWIST/REAL, but is
''     recomputed from the seed for FAST and QB
''   - a NEGATIVE argument reseeds QB and is ignored by everything else
''   - MTWIST must match MT19937 exactly, tempering shifts included

'' advapi32 IS NAMED EXPLICITLY, and it has to be.
''
'' FB_RND_REAL calls CryptAcquireContext/CryptGenRandom, which live in
'' advapi32. fbc's driver adds that library when the SOURCE uses the RND or
'' RANDOMIZE keywords -- but this test calls the entry points directly through
'' DECLARE, so the driver never sees a keyword and never adds it. The stock
'' program then fails to link on fbc's OWN math_rnd.o, before tiko-rt is
'' involved at all. A probe using the keywords links fine, which is what
'' identified the mechanism.
#inclib "advapi32"

extern "rtlib"
	declare sub pRandomize alias "fb_Randomize" ( byval seed as double, byval algo as long )
	declare function pRnd alias "fb_Rnd" ( byval n as single ) as double
	declare function pRnd32 alias "fb_Rnd32" ( ) as ulong
	declare function pGetState alias "fb_RndGetState" ( ) as any ptr
end extern

const RND_AUTO = 0, RND_CRT = 1, RND_FAST = 2, RND_MTWIST = 3, RND_QB = 4, RND_REAL = 5

dim as long i = any, k = any

print "-- RND with no RANDOMIZE at all (startup path)"
for i = 1 to 5
	print "  "; pRnd( 1.0 )
next
print "  rnd32="; pRnd32( )
print "  rnd(0)="; pRnd( 0.0 )

print "-- each deterministic generator from a fixed seed"
dim shared as long algos(0 to 3) = { RND_CRT, RND_FAST, RND_MTWIST, RND_QB }
dim shared as string anames(0 to 3)
anames(0) = "CRT" : anames(1) = "FAST" : anames(2) = "MTWIST" : anames(3) = "QB"
for k = 0 to 3
	print "  === "; anames(k)
	pRandomize( 42.0, algos(k) )
	for i = 1 to 8
		print "    "; pRnd( 1.0 )
	next
	print "    rnd32:";
	for i = 1 to 4
		print " "; pRnd32( )
	next
	print
	print "    rnd(0)="; pRnd( 0.0 )
	print "    rnd(-1)="; pRnd( -1.0 )
	print "    rnd(-1) again="; pRnd( -1.0 )
	print "    after neg, rnd(1)="; pRnd( 1.0 )
next

print "-- the same seed twice: QB is the one that does not repeat"
for k = 0 to 3
	pRandomize( 7.0, algos(k) )
	dim as double a1 = pRnd( 1.0 ), a2 = pRnd( 1.0 )
	pRandomize( 7.0, algos(k) )
	dim as double b1 = pRnd( 1.0 ), b2 = pRnd( 1.0 )
	print "  "; anames(k); " repeats="; iif( (a1 = b1) andalso (a2 = b2), 1, 0 )
next

print "-- extreme seeds"
dim shared as double seeds(0 to 6) = { 0.0, 1.0, -2.0, 1e10, -1e10, 4294967295.0, 0.5 }
for k = 0 to 3
	print "  === "; anames(k)
	for i = 0 to 6
		pRandomize( seeds(i), algos(k) )
		print "    seed="; seeds(i); " -> "; pRnd( 1.0 ); " "; pRnd32( )
	next
next

print "-- the state block: algorithm and length per generator"
'' Read positionally; the layout is fixed by fbc and is what callers see.
for k = 0 to 3
	pRandomize( 1.0, algos(k) )
	dim as ulong ptr sp = cptr( ulong ptr, pGetState( ) )
	print "  "; anames(k); " algorithm="; sp[0]; " length="; sp[1]
next
pRandomize( 1.0, RND_REAL )
dim as ulong ptr sp2 = cptr( ulong ptr, pGetState( ) )
print "  REAL algorithm="; sp2[0]; " length="; sp2[1]

print "-- REAL is non-deterministic, so only its shape is checked"
dim as ulong r1 = pRnd32( ), r2 = pRnd32( ), r3 = pRnd32( )
print "  three draws differ="; iif( (r1 <> r2) andalso (r2 <> r3), 1, 0 )
dim as double rr = pRnd( 1.0 )
print "  in range="; iif( (rr >= 0.0) andalso (rr < 1.0), 1, 0 )
print "  rnd(0) is the last value="; iif( pRnd( 0.0 ) = rr, 1, 0 )

print "-- AUTO picks the dialect default"
pRandomize( 1.0, RND_AUTO )
dim as ulong ptr sp3 = cptr( ulong ptr, pGetState( ) )
print "  auto algorithm="; sp3[0]

print "-- MTWIST across a regeneration boundary (624 words)"
pRandomize( 12345.0, RND_MTWIST )
dim as ulongint acc = 0
for i = 1 to 700
	acc += pRnd32( )
next
print "  checksum after 700="; acc
print "  next three:"; pRnd32( ); pRnd32( ); pRnd32( )

print "-- every generator over a long run, checksummed"
for k = 0 to 3
	pRandomize( 99.0, algos(k) )
	acc = 0
	for i = 1 to 2000
		acc += pRnd32( )
	next
	print "  "; anames(k); " sum="; acc
	pRandomize( 99.0, algos(k) )
	dim as double dacc = 0.0
	for i = 1 to 2000
		dacc += pRnd( 1.0 )
	next
	print "  "; anames(k); " dsum="; dacc
next

print "-- randomize with the default seed argument still produces a value"
pRandomize( -1.0, RND_MTWIST )
dim as double t1 = pRnd( 1.0 )
print "  in range="; iif( (t1 >= 0.0) andalso (t1 < 1.0), 1, 0 )

print "done"
