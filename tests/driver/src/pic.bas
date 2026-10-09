'' A public variable and two public procedures: what -pic changes the code model for.
extern pubg as long
dim shared as long pubg = 5
function f( ) as long
    return pubg
end function
function h( ) as long
    return f( )
end function
