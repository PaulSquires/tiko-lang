'' A CAPTURING LAMBDA PASSED BY REFERENCE IS AN OBJECT IN A TEMPORARY. It is a literal,
'' so it has no address of its own, and the byref-argument temporary builder can only
'' store an already-lowered rvalue -- it cannot build an aggregate. Measured, passing one
'' to 'sub Apply( of F )( byval n as long, byref f as F )':
''
''   struct $25L...IiE TMP$3$0;
''   __builtin_memset( &TMP$3$0, 0, 8ll );
''   *(int32**)&TMP$3$0 = &SUM_$0;
''   _Z5ApplyI25L...IiEEiRS1_( 4, &TMP$3$0 );
''
'' -- which is exactly the object the closure lowering already builds for a declaration;
'' only its ADDRESS had to be reachable separately from its value.
sub Apply( of F )( byval n as long, byref f as F )
	for i as long = 1 to n
		f( i )
	next
end sub
dim as long sum_ = 0
Apply( 4, sub[ byref sum_ ]( byval v as long )
	sum_ += v
end sub )
print sum_
