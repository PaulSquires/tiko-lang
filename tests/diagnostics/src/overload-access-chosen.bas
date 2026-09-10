'' THE OTHER HALF OF THE SAME RULE, and the reason accessibility must not FILTER the
'' candidates. Measured on fbc:
''
''     private: declare sub s( byval i as integer )
''     public:  declare sub s( byval d as double )
''     x.s( 1 )        fbc: error 202, Illegal member access
''
'' The INTEGER argument matches the private overload exactly. fbc picks it on argument
'' cost and THEN refuses it -- it does NOT fall back to the reachable 'double' one. So a
'' fix that made an inaccessible overload invisible would accept this program, which is
'' why the rule is "choose first, check second" and this file exists beside
'' tests/mir/overload-access-split, which is the accepted half.
type T
	as byte pad

	private:
	declare sub s( byval i as integer )

	public:
	declare sub s( byval d as double )
end type

private sub T.s( byval i as integer )
end sub

sub T.s( byval d as double )
end sub

dim shared x as T
x.s( 1 )
