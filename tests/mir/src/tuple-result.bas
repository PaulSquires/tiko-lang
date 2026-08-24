'' 'function = ( a, b )' OUT OF A TUPLE-RETURNING FUNCTION.
''
'' The bare parenthesised field list is error 7 in fbc over a plain UDT -- "expected ')',
'' found ','" -- and that measurement is what the existing rule was built on. It is NOT
'' an error when the RESULT IS A TUPLE, where it is the only spelling there is:
'' fb/mathint.bi's DivMod is written exactly this way and every integer type
'' instantiates it.
''
'' Both facts are here: the tuple form lowers, and the UDT form still takes the
'' 'type( ... )' spelling.
type P
	as long a, b
end type

function mkP( ) as P
	function = type( 5, 6 )
end function

function divmod( byval a as long, byval b as long ) as (long, long)
	function = ( a \ b, a mod b )
end function

function divmodNamed( byval a as long, byval b as long ) _
		as (quotient as long, remainder as long)
	function = ( a \ b, a mod b )
end function

dim as P p = mkP( )
print p.a, p.b

dim as (long, long) d = divmod( 7, 2 )
print d._1, d._2

dim as (quotient as long, remainder as long) n = divmodNamed( 7, 2 )
print n._1, n._2
