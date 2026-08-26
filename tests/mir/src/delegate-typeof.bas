'' A FIELD WHOSE TYPE IS 'typeof( procptr( T.m ) )' -- the low-level delegate.
''
'' Three separate faults, and the first is the worst kind:
''
''   STILL OPEN, and this file records it rather than hiding it: a FIELD whose type is
''   'typeof( EXPR )' is never typed. Only variables and constants are filled in
''   after Check, and a field left untyped makes ComputeUdtLayouts refuse the whole
''   UDT -- '--dump-udt' does not list 'Deleg' at all, with nothing said. Thirty of
''   the forty declines in pointers/procptr-low-level-delegate.bas are that, and
''   they are why this file's own sizeof line is not asserted.
''
''   AN INSTANCE MEMBER'S SIGNATURE STARTS WITH ITS RECEIVER. Measured:
''   '#print typeof( procptr( T.proc1 ) )' is SUB(AS T), and fbc declares that procedure
''   'void _ZN1T5PROC1Ev( struct $1T* )'. tiko answered 'sub( ) ptr' -- the wrong arity,
''   which every call through the pointer then disagreed with. A STATIC member has no
''   receiver, and neither has a free procedure.
''
''   A CALLEE THAT IS AN EXPRESSION is still a callee. The indirect path already knew
''   how to call a computed pointer; it just refused to start without a symbol.
''
'' Run under fbc this prints ' 24' and then 'T.proc1' / 'T.proc2'. tiko-lang gets
'' the two calls right and the size wrong, for the reason above.

type T
	__ as integer
	declare sub proc1( )
	declare sub proc2( )
end type

sub T.proc1( ) : print "T.proc1" : end sub
sub T.proc2( ) : print "T.proc2" : end sub

type Deleg
	proc as typeof( procptr( T.proc1 ) )
	indx as integer
	inst as T ptr
end type

dim d as Deleg
dim x as T

print sizeof( Deleg )

d.proc = procptr( T.proc1 )
d.indx = procptr( T.proc1, virtual )
d.inst = @x
d.proc( *(d.inst) )

'' ...and through an expression, with no name to look up.
dim c as integer = 0
( iif( c, procptr( T.proc1 ), procptr( T.proc2 ) ) )( *(d.inst) )
