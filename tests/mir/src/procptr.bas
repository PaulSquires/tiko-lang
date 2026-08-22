declare sub F cdecl ( byval x as long )
declare sub G( byval p as sub cdecl ( byval x as long ) )
sub F cdecl ( byval x as long ) : end sub
G( procptr( F ) )

'' AN INDIRECT CALL'S RESULT TYPE COMES OFF THE PROCEDURE TYPE. A DIM initialiser names
'' no type for its right-hand side, so 'dim as double a = f( x, ctx )' through a
'' function-pointer PARAMETER reached lowering with nothing asked for: the call went out
'' as 'call.ind void' and the initialiser declined with the call sitting right there. A
'' DIRECT call takes its type from the callee's symbol; an indirect one has no symbol,
'' and the pointee is where it lives.
type FN as function( byval x as double, byval c as any ptr ) as double

sub IndirectResult( byval f as FN, byval ctx as any ptr )
    dim as double a = f( 1.0, ctx )
    dim as double b
    b = f( 2.0, ctx )
end sub
