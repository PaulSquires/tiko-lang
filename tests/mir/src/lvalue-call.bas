'' A BYREF-RETURNING CALL YIELDS AN ADDRESS, which is the whole point of one:
'' 'a.At( 2 ) = 88' stores THROUGH the returned reference. fbc writes
'' 'int32* vr = _ZN1T2ATEi( &A, 2 ); *vr = 88;'.
''
'' And 'a[ i ]' over a UDT had a working call path in LOWERING and no TYPE, so the
'' assignment through one declined on the target's type before it ever got there --
'' which is what a container is FOR.
type T
    items(0 to 9) as long
    declare operator [] ( byval i as long ) byref as long
    declare function At( byval i as long ) byref as long
end type
operator T.[] ( byval i as long ) byref as long
    return this.items( i )
end operator
function T.At( byval i as long ) byref as long
    return this.items( i )
end function

sub G( )
    dim a as T
    a[ 1 ] = 99
    dim as long q = a[ 1 ]
    dim as long r = a.At( 2 )
end sub

'' 'strptr( x )' is the character DATA POINTER, a different thing per flavour and
'' lowered for none of them -- and its TYPE follows the operand: '#print typeof(
'' strptr( w ) )' over a 'wstring * 4' is 'WSTRING * 4 PTR', not a zstring ptr.
sub H( )
    dim as string s
    dim z as zstring * 10
    dim w as wstring * 10
    dim pz as zstring ptr = strptr( s )
    dim pz2 as zstring ptr = strptr( z )
    dim pw as wstring ptr = strptr( w )
end sub

'' A STRING SUBJECT IS COMPARED, NOT LOADED. This was loading the DESCRIPTOR'S first
'' eight bytes and comparing them against the literal's ADDRESS truncated to 32 bits --
'' verifier-clean, no decline, and wrong every time.
sub I( )
    dim s as string
    dim w as wstring * 10
    select case s
    case "a"
    case "b", "c"
    case is > "d"
    case "e" to "g"
    case else
    end select
    select case w
    case "a"
    end select
end sub
