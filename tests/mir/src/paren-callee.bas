'' A PARENTHESISED CALLEE. '(p)( )' is how the corpus calls through a procedure pointer
'' chosen by an expression, and the N_PAREN carries no reference of its own -- so the
'' callee lookup found nothing, the call was abandoned, and the statement declined.
'' 'p( )' on the line beside it worked.
''
'' Run under fbc this prints ' 1 1 2'.

function f1( ) as integer : return 1 : end function
function f2( ) as integer : return 2 : end function

dim p1 as function( ) as integer = @f1
dim p2 as function( ) as integer = @f2

print p1( ); (p1)( ); (p2)( )
