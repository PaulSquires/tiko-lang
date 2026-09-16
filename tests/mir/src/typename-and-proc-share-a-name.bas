'' A TYPE NAME AND A PROCEDURE MAY SHARE A SPELLING, and FreeBASIC folds case, so
'' 'WNDPROC' and 'WndProc' are one name. win/winuser.bi declares the type and the
'' program declares, uses and then DEFINES the function -- three declarations of one
'' name, two classes -- and the definition used to be refused as a duplicate.
type FN as function( byval a as long ) as long

declare function Fn( byval a as long ) as long

'' The USE is what made the pair matter: without it the definition arrived before
'' anything had bound the name.
dim shared as FN p = @Fn

function Fn( byval a as long ) as long
    return a + 1
end function

print Fn( 10 ), p( 20 )
