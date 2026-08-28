'' linkage-check.bas -- does the gate actually EXECUTE tiko-rt's code?
''
'' A green gate proves nothing unless the tests reach the implementation under
'' test. The merged archive (build/gate.sh) contains ~1,200 fbc members and a
'' handful of ours, and if the merge ever silently fails to replace a member,
'' fbc's implementation is what links -- and the suite passes, reporting success
'' for code that was never called. That happened once already; see
'' docs/tiko-rt/status/spike.md, "Harness hygiene".
''
'' gate.sh now asserts each tiko-rt symbol is defined exactly once, which catches
'' the archive-level version of the problem. This catches the behavioural one.
''
'' PROCEDURE -- run it whenever a module is added to sources.txt:
''
''   1. Build and merge, then:
''        fbc tests/abi/linkage-check.bas -p obj/gate/<target>/lib -x check.exe
''      Expect every line to say OK.
''
''   2. Break one entry point ON PURPOSE -- delete a statement, not a whole
''      function, so it still links -- rebuild, re-merge, and run again.
''      The corresponding line MUST say WRONG.
''
''   3. Restore, rebuild, confirm OK again, and confirm `git diff` is empty.
''
'' If step 2 still says OK, the gate is not testing tiko-rt and no number it
'' produces means anything.
''
'' Recorded result, 2026-08-28, win64, fb_MemSwap:
''   unmutated                       -> OK
''   third memcpy of the swap removed -> WRONG
''   restored                        -> OK

#include once "fbc-int/memory.bi"

type BIG
	as ubyte b(0 to 63)
end type

dim as integer failures = 0

sub report( byref what as string, byval ok as integer )
	print what; ": "; iif( ok, "OK", "WRONG" )
end sub

'' ---------------------------------------------------- fb_MemSwap, via SWAP
''
'' A UDT large enough that fbc cannot inline the exchange into registers and
'' must call the runtime.
scope
	dim as BIG x, y
	dim as integer okx = 1, oky = 1

	for i as integer = 0 to 63
		x.b(i) = &h11
		y.b(i) = &h22
	next

	swap x, y

	for i as integer = 0 to 63
		if( x.b(i) <> &h22 ) then okx = 0
		if( y.b(i) <> &h11 ) then oky = 0
	next

	if( (okx = 0) orelse (oky = 0) ) then failures += 1
	report( "fb_MemSwap  (udt swap)   ", okx andalso oky )
end scope

'' ------------------------------------- fb_MemCopyClear, via FBC.copyclear
''
'' Called through the documented entry point in fbc-int/memory.bi rather than
'' inferred from a language construct.
''
'' The first attempt at this test asserted that `dim as zstring * 16 z : z =
'' "abc"` would zero the tail. It reported WRONG -- and so did fbc's OWN C
'' runtime when the same binary was linked against it. The test was wrong, not
'' the implementation: that assignment does not route here at all (`-r` output
'' shows fb_StrAssign and no fb_MemCopyClear). Recorded because "our code fails"
'' and "our expectation is wrong" look identical until you run the differential.
''
'' What is asserted is PROBE-10's measured contract: copy min(dstlen, srclen),
'' ZERO-FILL the remainder of dst, never write past dstlen.
scope
	dim as ubyte d(0 to 7), s(0 to 7)
	dim as integer ok = 1

	for i as integer = 0 to 7
		d(i) = &hAA
		s(i) = &h11 + i
	next

	'' src shorter than dst: the tail must be zeroed, not left holding &hAA.
	FBC.copyclear( @d(0), 8, @s(0), 3 )
	for i as integer = 0 to 2
		if( d(i) <> &h11 + i ) then ok = 0
	next
	for i as integer = 3 to 7
		if( d(i) <> 0 ) then ok = 0
	next

	'' src longer than dst: truncated, and nothing past dstlen is touched.
	for i as integer = 0 to 7 : d(i) = &hAA : next
	FBC.copyclear( @d(0), 4, @s(0), 8 )
	for i as integer = 0 to 3
		if( d(i) <> &h11 + i ) then ok = 0
	next
	for i as integer = 4 to 7
		if( d(i) <> &hAA ) then ok = 0
	next

	if( ok = 0 ) then failures += 1
	report( "fb_MemCopyClear (contract)", ok )
end scope

print
if( failures = 0 ) then
	print "linkage-check: all OK"
else
	print "linkage-check: "; failures; " FAILED"
end if
end failures
