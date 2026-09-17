'' A BUILTIN KEEPS ITS NAME WHEN NO OVERLOAD TAKES THE ARGUMENT'S UDT.
''
'' DVARIANT.inc declares 'Val OVERLOAD ( byref dv as DVARIANT )' and nothing else named
'' 'val'. 'val( aDwstring )' handed the name to it, converted the DWSTRING into a
'' DVARIANT, and the overload's own '.VAL( dws )' -- the leading dot meaning the builtin
'' -- was resolved the same way and converted back. Infinite recursion: tiko-editor died
'' with a STACK OVERFLOW reading its own settings file.
''
'' The shape below is that one: V stands in for DVARIANT, W for DWSTRING. fbc prints
'' 42 and 7 and never calls the overload with a W.
type W
    as wstring * 32 buf
    declare constructor( byref s as const wstring = "" )
    declare operator cast( ) byref as const wstring
end type
constructor W( byref s as const wstring = "" ) : buf = s : end constructor
operator W.cast( ) byref as const wstring : operator = buf : end operator

type V
    as double d
    declare constructor( byref w_ as W )
end type
constructor V( byref w_ as W ) : d = 7 : end constructor

function Val overload ( byref dv as V ) as double
    print "  [V overload ran]"
    return dv.d
end function

dim as W numeric_ = W( "42" )
print "builtin over the UDT : "; val( numeric_ )

'' ...and the overload still runs for its OWN type, which is what keeps this from
'' passing by simply ignoring the overload.
dim as V vv = V( numeric_ )
print "overload over its own: "; Val( vv )
