'' A MEMBER OF A FUNCTION's RESULT that the result's type does not have -- fbc's error 18 on
'' lines 23 to 27 (fbc-modern 1.20; line 26 is its error 9, the same refusal). tiko judged a variable, a parameter and a field base only,
'' and printed nothing for each of these. Lines 29 to 33 are members that exist.
type U
    a as long
    declare function Get( ) as long
end type
function U.Get( ) as long : return a : end function
function MkU( ) as U
    return type<U>( 5 )
end function
function MkT( ) as (long, string)
    return (3, "s")
end function
dim shared as U gu
function MkP( ) as U ptr
    return @gu
end function
dim as long n
dim as string s
dim as U ptr pu

n = MkU( ).nope
n = MkT( ).x
n = MkT( )._3
n = MkP( )->nope
n = MkU( ).Nope( )

n = MkU( ).a
s = MkT( )._2
n = MkP( )->a
n = MkU( ).Get( )
pu = MkP( )
