'' ANDALSO AND ORELSE, whose ANSWER LIVES IN A SLOT.
''
'' MIR has no phis, so the join block cannot name "whichever side ran". The lowering
'' used to return the RIGHT operand's value from the join -- correct only when the right
'' side actually ran, and UNDEFINED on exactly the path short-circuiting exists for. It
'' verified, because a value is a value.
''
'' fbc keeps the answer in a temporary and NORMALISES it. Measured:
''
''     r = (a <> 0) andalso (b <> 0)
''         if( A == 0 ) goto SHORT;  TMP = -(B != 0);  goto JOIN;
''         SHORT: TMP = 0;  JOIN: R = (int32)TMP;
''
''     q = (a <> 0) orelse (b <> 0)
''         if( A != 0 ) goto SHORT;  TMP = -(B != 0);  goto JOIN;
''         SHORT: TMP = -1;  JOIN: Q = (int32)TMP;
''
'' so the short-circuit constant is 0 for ANDALSO and -1 for ORELSE, and the taken side
'' contributes its own value -- which a comparison has already negated.
''
'' THE RIGHT SIDE MUST NOT RUN when the left decides it: 'sidefx( )' below is called
'' once, not twice.
dim shared as long calls

function sidefx( ) as long
	calls += 1
	return 1
end function

dim as long a = 0, b = 2

dim as long r = (a <> 0) andalso (b <> 0)
dim as long q = (a <> 0) orelse (b <> 0)
print r, q

if (a <> 0) andalso (b <> 0) then print "and"
if (a <> 0) orelse (b <> 0) then print "or"

'' The short-circuit path itself: the left decides and the right is never evaluated.
if (a <> 0) andalso (sidefx( ) <> 0) then print "never"
print calls

'' ...and a chain, which folds left.
dim as long t = (a = 0) andalso (b = 2) andalso (b <> 0)
print t
