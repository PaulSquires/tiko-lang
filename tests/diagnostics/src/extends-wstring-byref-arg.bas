'' TWO UDTS THAT EACH EXTEND WSTRING ARE UNRELATED, NOT A HIERARCHY. fbc-modern compiles
'' this and runs 'Add( byref d as DW )' with a temporary built by DW's constructor, printing
'' 'dw 7' -- exactly what it does when neither type extends anything. tiko counted WSTRING
'' as a base and refused 'this.Add( b )' as a byref argument of an unrelated class (TKO0698):
'' AfxNova's DWSTRING.+= and DWSTRING.&= over a BSTRING are this shape.
type BS extends wstring
    p as wstring ptr
    declare constructor( byref w as const wstring )
    declare operator cast( ) byref as const wstring
    declare operator cast( ) as any ptr
end type
constructor BS( byref w as const wstring )
    p = cast( wstring ptr, @w )
end constructor
operator BS.cast( ) byref as const wstring
    return *p
end operator
operator BS.cast( ) as any ptr
    return p
end operator
type DW extends wstring
    n as integer
    declare constructor( )
    declare constructor( byref b as BS )
    declare function Add overload( byval pw as wstring ptr ) as boolean
    declare function Add( byref s as string, byval cp as ulong = 0 ) as boolean
    declare function Add( byref d as DW ) as boolean
    declare sub AddB( byref b as BS )
end type
constructor DW( )
    n = 0
end constructor
constructor DW( byref b as BS )
    n = 7
end constructor
function DW.Add( byval pw as wstring ptr ) as boolean
    print "ptr";
    return true
end function
function DW.Add( byref s as string, byval cp as ulong = 0 ) as boolean
    print "str";
    return true
end function
function DW.Add( byref d as DW ) as boolean
    print "dw"; d.n
    return true
end function
sub DW.AddB( byref b as BS )
    this.Add( b )
end sub
dim w as wstring * 8 = "hi"
dim b as BS = w
dim d as DW
d.AddB( b )
