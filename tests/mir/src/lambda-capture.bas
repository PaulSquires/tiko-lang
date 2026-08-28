'' A CAPTURING LAMBDA IS A CLOSURE OBJECT. Measured from fbc, whose C for the first
'' one below is a generated struct with one '__CAP_ACC' field, a '__FBINVOKE' member
'' taking it as the receiver, and a temporary filled in at the site:
''
''   struct $25LF...E { int32* __CAP_ACC; };
''   *(int32**)&TMP$3$0 = &ACC$0;  C$0 = TMP$3$0;  __FBINVOKE( &C$0, 5 );
dim as long acc = 0
var c = sub[ byref acc ]( byval v as long )
	acc += v
end sub
c( 5 )
c( 7 )
print acc

'' A BYVAL CAPTURE IS STORED IN THE OBJECT AND MUTATED THERE. Measured by RUNNING it:
'' these two calls print 11 then 12, and the outer n is still 10 afterwards.
dim as long n = 10
var b = sub[ byval n ]( byval v as long )
	n += v
	print n
end sub
b( 1 )
b( 1 )
print n

'' TWO CAPTURES, one of each kind, and a RESULT.
dim as long lo = 2, hi = 9
var clamp_ = function[ byval lo, byref hi ]( byval x as long ) as long
	if x < lo then return lo
	if x > hi then return hi
	return x
end function
print clamp_( 1 ), clamp_( 5 ), clamp_( 99 )
