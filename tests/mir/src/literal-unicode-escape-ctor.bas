'' AN ESCAPED LITERAL WITH A UNICODE ESCAPE IS A WSTRING, so it takes a type's wstring
'' constructor. Check types every literal STRING, and the narrow constructor turned the glyph
'' into '?'. Measured, fbc-modern prints 'w 57910'.
type T
    as long kind
    as long code
    declare constructor( byref s as string )
    declare constructor( byref w as const wstring )
end type
constructor T( byref s as string )
    this.kind = 0 : this.code = asc( s )
end constructor
constructor T( byref w as const wstring )
    this.kind = 1 : this.code = asc( w )
end constructor
dim as T x = !"\uE236"
print iif( x.kind = 1, "w", "s" ); x.code
