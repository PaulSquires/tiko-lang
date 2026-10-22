' A STRING iif whose arms build UDT temporaries: only the TAKEN arm's are destroyed.
' Each Tag counts its constructions and destructions; the untaken arm builds nothing, so
' it must destroy nothing -- tiko destroyed it anyway, on storage no constructor touched.

dim shared as long nCtor, nDtor

type Tag
    s as string
    declare constructor( byref z as const string )
    declare constructor( byref t as const Tag )
    declare destructor( )
end type
constructor Tag( byref z as const string )
    s = z
    nCtor += 1
end constructor
constructor Tag( byref t as const Tag )
    s = t.s
    nCtor += 1
end constructor
destructor Tag( )
    nDtor += 1
end destructor

function ByRefTag( byref t as const Tag ) as string
    return "r:" & t.s
end function
function ByValTag( byval t as Tag ) as string
    return "v:" & t.s
end function
function MakeTag( byref z as const string ) as Tag
    return Tag( z )
end function
function UByRefTag( byref t as const Tag ) as ustring
    return "u:" & t.s
end function

sub Show( byref what as string, byref r as string )
    print what; " = "; r; "  balance "; nCtor - nDtor
end sub

dim as long n = 2
dim as string r

r = iif( n > 1, ByRefTag( "taken" ), ByRefTag( "untaken" ) )
Show( "byref then", r )
r = iif( n < 1, ByRefTag( "untaken" ), ByRefTag( "taken" ) )
Show( "byref else", r )
r = iif( n > 1, ByValTag( "taken" ), ByValTag( "untaken" ) )
Show( "byval", r )
r = iif( n > 1, MakeTag( "taken" ).s, MakeTag( "untaken" ).s )
Show( "returned", r )
dim as ustring u = iif( n > 1, UByRefTag( "taken" ), UByRefTag( "untaken" ) )
Show( "ustring", u )
r = iif( n > 1, iif( n > 5, ByRefTag( "a" ), ByRefTag( "b" ) ), ByRefTag( "c" ) )
Show( "nested", r )
r = iif( n > 1, ByRefTag( "x" ), "lit" )
Show( "one arm", r )

for i as long = 1 to 100
    r = iif( (i and 1) = 0, ByRefTag( "even" ), ByValTag( "odd" ) )
next
Show( "loop", r )
print "ctors "; nCtor; " dtors "; nDtor
