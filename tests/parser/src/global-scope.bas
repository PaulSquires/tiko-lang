'' '..x' is the GLOBAL-SCOPE prefix: inside a namespace it names the x at file scope
'' rather than the one in view. Measured against fbc, which accepts '..x', '..f( )',
'' the chain '..a.b.v', an assignment target, and the prefix at module level.
''
'' It lexes as TWO separate TK_DOTs, so the WITH-shorthand branch saw a dot followed by
'' a dot, found no identifier, and reported 'expected an expression'.
''
'' The base is an N_GLOBALSCOPE node rather than the absent base of '.field', so the two
'' prefixes cannot be confused: '.x' means the open WITH, '..x' means file scope.

dim shared as integer x = 7

namespace a
	namespace b
		dim shared as integer v = 3
	end namespace
end namespace

namespace ns
	dim shared as integer x = 9
	sub f( )
		print ..x
		..x = 5
		print ..a.b.v
	end sub
end namespace

'' At module level it names the same thing the bare name does.
print ..x
