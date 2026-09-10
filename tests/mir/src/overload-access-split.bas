'' ACCESSIBILITY IS CHECKED ON THE OVERLOAD THE ARGUMENTS CHOSE, not on the head of the
'' overload chain. Resolve binds a name to the head; only Check's costing knows which
'' overload a call selected. The visibility pass asked the question of the head, so an
'' overload set split across access modes was refused on a member that was never a
'' candidate:
''
''     private: declare function bar( ) as integer
''     public:  declare function bar( i as integer ) as integer
''     f.bar( 1 )      tiko: 'bar' is not accessible here.  fbc: ACCEPTED
''
'' -- the private one takes NO arguments.
''
'' THIS IS NOT ACCESSIBILITY-FILTERED OVERLOADING, and that was measured before it was
'' written. With 'private s( integer )' and 'public s( double )', 'x.s( 1 )' is fbc's
'' error 202: it picks the private one on argument cost and THEN refuses it rather than
'' falling back to the reachable overload. Choose first, check second -- so the fix reads
'' the winner rather than making an inaccessible overload invisible. The second type
'' below is that case, and it must still be refused; it is in tests/diagnostics.
''
'' RECORDED IN THE VISIBILITY PASS, NOT WRITTEN ONTO THE CALLEE NODE. Doing it in
'' overload.bas broke four tests -- mir/byref-args, byref-overload,
'' property-overload-read and spawn -- because lowering reads the callee's binding and
'' walks the chain from it, so replacing the head with the winner loses the other
'' overloads. A map local to the visibility pass cannot reach lowering at all.
type foo
	as byte pad

	private:
	declare function bar( ) as integer

	public:
	declare function bar( i as integer ) as integer
end type

function foo.bar( i as integer ) as integer
	function = 42
end function

dim shared f as foo
print f.bar( 1 )
