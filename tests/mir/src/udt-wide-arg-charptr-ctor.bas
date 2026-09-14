'' A WIDE argument for a UDT parameter whose type declares a 'wstring ptr' constructor
'' beside 'byref as const wstring' and 'byref as string' -- AfxNova DWSTRING's set --
'' and a UDT with 'operator cast( ) as wstring' as an OPEN file name.
type WS
    as wstring * 64 buf
    as zstring * 8 how
    declare constructor( )
    declare constructor( byref s as const wstring )
    declare constructor( byval p as wstring ptr )
    declare constructor( byref a as string, byval cp as ulong = 0 )
    declare constructor( byref o as WS )
    declare destructor( )
    declare operator cast( ) byref as const wstring
end type

dim shared as long live

constructor WS( )
    how = "default" : live += 1
end constructor
constructor WS( byref s as const wstring )
    buf = s : how = "wref" : live += 1
end constructor
constructor WS( byval p as wstring ptr )
    buf = *p : how = "wptr" : live += 1
end constructor
constructor WS( byref a as string, byval cp as ulong = 0 )
    buf = a : how = "str" : live += 1
end constructor
constructor WS( byref o as WS )
    buf = o.buf : how = "copy" : live += 1
end constructor
destructor WS( )
    live -= 1
end destructor
operator WS.cast( ) byref as const wstring
    return buf
end operator

function Ask( byref t as WS ) as long
    print "ask "; t.how; len( t.buf ); asc( t.buf, len( t.buf ) )
    return 7
end function

sub Show( byval t as WS )
    print "show "; t.how; len( t.buf ); asc( t.buf ); asc( t.buf, len( t.buf ) )
end sub

function FileName_( ) as WS
    return "udt-wide-arg.tmp"
end function

sub Place( )
    dim as long f = freefile( )
    if open( FileName_( ) for output as #f ) <> 0 then print "open failed" : exit sub
    print #f, "x"
    close #f
    print "placed"
end sub

scope
    dim as WS what_ = "row 3"
    if Ask( "Delete?" + chr( 10 ) + what_ ) <> 6 then print "cancelled"
    dim as long r = Ask( "Plain" + what_ )
    Show( wchr( &h25BE ) )
    dim as wstring * 4 w = wchr( &h25B8 )
    Show( w )
    Show( what_ + " -- not built yet" )
    Show( "lit" )
end scope
Place( )
print "live"; live
