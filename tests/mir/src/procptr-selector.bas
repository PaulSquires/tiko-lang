'' A PROCPTR SIGNATURE SELECTOR MAY BE A TYPEDEF, OR A 'typeof' AROUND ONE.
''
'' 'type t as sub( byval as single )' followed by 'procptr( s, t )' writes the second
'' argument as an ORDINARY IDENTIFIER, not a type reference, so it carried no type of
'' its own: the selector matched nothing and the whole expression came out untyped --
'' while the spelled-out 'sub( byval as single )' beside it worked. And in EXPRESSION
'' position 'typeof' is a CALL, not a type reference, so it is unwrapped rather than
'' given a case of its own.
''
'' fbc answers the same address for all four spellings -- 'P1$0 = (tmp$4)&_Z1Sf' -- and
'' running it prints "single" every time.
sub s overload ( byval arg as single )
	print "single", arg
end sub
sub s overload ( byval arg as long )
	print "long", arg
end sub
type t as sub( byval as single )
var p1 = procptr( s, t )
p1( 1 )
var p2 = procptr( s, typeof( t ) )
p2( 2 )
var p3 = procptr( s, typeof( p1 ) )
p3( 3 )
dim as t p4 = procptr( s, sub( byval as single ) )
p4( 4 )
