'' A UDT THAT EXTENDS WSTRING MEETS A WIDE ARM IN 'iif'; the cast alone does not.
type DWS extends wstring
    as wstring * 32 buf
    declare constructor( )
    declare constructor( byval p as wstring ptr )
    declare destructor( )
    declare operator cast( ) byref as const wstring
end type
constructor DWS( ) : buf = "" : end constructor
constructor DWS( byval p as wstring ptr )
    if p <> 0 then buf = *p else buf = ""
end constructor
destructor DWS( ) : end destructor
operator DWS.cast( ) byref as const wstring
    operator = buf
end operator

dim as wstring * 32 w = "abcdef"
dim as long i = 2, n = 6
dim as DWS a = iif( i > n, DWS( @w ), mid( w, i, 1 ) )
print "else arm -> ["; a; "]"
dim as DWS b = iif( i < n, DWS( @w ), mid( w, i, 1 ) )
print "then arm -> ["; b; "]"
