'' AN ARRAY DECLARATION IS ALL 'any' OR ALL WRITTEN BOUNDS -- fbc's error 9 with the bounds
'' first and 94 with 'any' first, but one refusal either way. And a TYPE's array field is
'' declared with 'dim', not 'redim' (error 9 again). Measured, with the accepted forms
'' beside the refused ones.
'' Accepted: every dimension the same kind, and a single dimension of either kind.
dim allAny( any, any ) as integer
dim allBounds( 0 to 0, 0 to 1 ) as integer
dim oneAny( any ) as integer
dim oneBound( 0 to 3 ) as integer
type WithDynField
    field( any ) as integer
end type
type WithFixedField
    field( 0 to 3 ) as integer
end type
'' Accepted: REDIM inside a type WITH bounds -- it makes a dynamic array there even when
'' the bounds are constant, which is what the corpus says in a comment of its own.
type RedimWithBounds
    redim field( 0 to 0 ) as integer
end type
type RedimWithAny
    redim field( any ) as integer
end type
'' Refused: the two kinds mixed, in either order.
dim boundsThenAny( 0 to 0, any ) as integer
dim anyThenBounds( any, 0 to 0 ) as integer
'' Refused: a type's array field declared with REDIM and NOTHING between the parentheses.
type WithRedimField
    redim field( ) as integer
end type
