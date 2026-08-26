'' A FIELD WHOSE TYPE IS 'typeof( procptr( T.m ) )' -- the low-level delegate.
''
'' Three separate faults, and the first is the worst kind:
''
''   A FIELD THAT STAYS UNTYPED TAKES THE WHOLE UDT WITH IT. 'typeof( EXPR )' can
''   only be answered by Check, and only variables and constants were being filled
''   in there. A field left untyped makes ComputeUdtLayouts refuse the type
''   outright, so it vanished from the table with NOTHING SAID -- '--dump-udt'
''   simply did not list it -- and every use of the delegate declined.
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
''   AN EMPTY VARIADIC ARGUMENT IS NOT AN ARGUMENT. The corpus macro is written
''   'procptr( typeName.procName, signature )' over 'signature...', and all ten of
''   its call sites leave the signature out -- so what fbc actually sees is
''   'procptr( T.proc1, )', a trailing comma with nothing after it, which it
''   accepts. Read as TWO arguments it went down the overload-selection path,
''   matched nothing, and the expression came out untyped.
''
'' Run under fbc this prints ' 24' and then 'T.proc1' / 'T.proc2'.

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

'' The empty-variadic spelling, which is what the corpus macro expands to.
type Deleg2
	proc as typeof( procptr( T.proc1, ) )
	indx as integer
	inst as T ptr
end type

dim d as Deleg
dim e as Deleg2
dim x as T

print sizeof( Deleg ); sizeof( Deleg2 )

d.proc = procptr( T.proc1 )
d.indx = procptr( T.proc1, virtual )
d.inst = @x
d.proc( *(d.inst) )

'' ...and through an expression, with no name to look up.
dim c as integer = 0
( iif( c, procptr( T.proc1 ), procptr( T.proc2 ) ) )( *(d.inst) )
