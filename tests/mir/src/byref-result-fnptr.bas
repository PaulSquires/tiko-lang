'' A BYREF RESULT THROUGH A FUNCTION POINTER. The parser has recorded the result's
'' byref-ness as PF_BYREF_RESULT since the spelling was accepted and NOTHING EVER READ IT
'' BACK, so a procedure TYPE did not carry it and every consumer had to guess:
''
''   - 'dim byref as long r = pick( lo, hi )' found no address to alias and declined,
''     while the same call over a NAMED function -- where the PROC NODE carries the flag
''     -- lowered;
''   - 'print pick( a, b )' emitted the returned POINTER as an i32 and printed THAT.
''     It lowered and it verified. tests/mir/lambda's golden recorded it.
''
'' Measured, fbc: 'int32* vr$2 = (PICK$0)( &LO$0, &HI$0 ); R$0 = vr$2;', and printing one
'' reads through it. Run, this prints 11, 2 and -1.
dim shared as long g1 = 11

function pk( byref lo as long, byref hi as long ) byref as long
	if lo > hi then return lo
	return hi
end function

dim as long lo = 11, hi = 2
dim as function( byref as long, byref as long ) byref as long pick = @pk
dim byref as long r = pick( lo, hi )
print r
print pick( lo, hi )

'' ...and '@' over one is the pointer the call already returns.
function f1( ) byref as long
	return g1
end function

dim as function( ) byref as long p = @f1
print ( @(f1( )) = @(p( )) )
