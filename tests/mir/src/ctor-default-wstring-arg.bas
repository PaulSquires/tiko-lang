'' A CONSTRUCTOR'S 'byref as const wstring = ""' DEFAULT, filled by an implicit call. AfxNova's
'' CWindow declares exactly this, and 'dim as CWindow w' passed the NARROW literal: read as
'' UTF-16 it was a garbage class name, so the first window registered under it and every
'' later RegisterClassExW failed -- tracks came up with no list, no splitter and no status
'' bar. An explicit sub call with the same default was right all along. Measured,
'' fbc-modern prints 'a len 0 []', 'b len 2 [xy]', 'c len 0' and 'S len 0'.
type T
    as wstring * 260 name_
    declare constructor( byref w as const wstring = "" )
end type
constructor T( byref w as const wstring = "" )
    this.name_ = w
end constructor
dim as T a
print "a len"; len( a.name_ ); " [" & a.name_ & "]"
dim as T b = "xy"
print "b len"; len( b.name_ ); " [" & b.name_ & "]"
scope
    dim as T c
    print "c len"; len( c.name_ )
end scope
sub S( byref w as const wstring = "" )
    print "S len"; len( w )
end sub
S( )
