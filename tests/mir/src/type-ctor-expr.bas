'' 'T( args )' -- A TYPE CONSTRUCTOR USED AS AN EXPRESSION.
''
'' 'return TimeSpan( this.m_ticks )' is how the chrono and finance headers build almost
'' every value they return, and there was no case for it at all: the callee is a TYPE,
'' not a procedure, so the ordinary call path found nothing to call and the statement
'' declined.
''
'' 'dim as T a = T( 3 )' already worked, because a DIM initialiser constructs in place.
'' The gap was every other position -- a return, an argument, an operand.
''
'' A temporary is built and constructed, and its VALUE comes back; an aggregate value is
'' first class in this IR, so nothing new was needed to carry one.
''
'' ONE DIVERGENCE, recorded rather than hidden: fbc constructs STRAIGHT INTO THE RESULT
'' SLOT when the expression is the whole of a 'return' --
'' '_ZN1TC1Ex( &fb$result$1, N$1 ); return fb$result$1;' -- which is one copy fewer.
'' Same value.
''
'' The arguments are coerced to the CONSTRUCTOR'S OWN parameter types: 'TimeSpan( 0 )'
'' passes an INTEGER literal to a 'byval as longint', and handing the runtime the narrow
'' value would put half a quantity in a 64-bit slot.

type T
    m as longint
    declare constructor( )
    declare constructor( byval t as longint )
end type
constructor T( )
end constructor
constructor T( byval t as longint )
    this.m = t
end constructor
function F( byval n as longint ) as T
    return T( n )
end function
sub P( )
    dim as T a = T( 3 )
end sub
