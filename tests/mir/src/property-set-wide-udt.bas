'' A PROPERTY SETTER TAKING 'byref as const wstring', GIVEN A UDT WITH A WIDE CAST, over a
'' getter returning that UDT -- AfxNova's CRegExp.Pattern given a DWSTRING. The setter was
'' scored unreachable, so the same-type LET claimed 'h.Pattern = v': it took the target's
'' address, which is the GETTER'S CODE, and ran WS's 'operator let' over it. DWStrRemove
'' crashed there. Measured, fbc-modern calls the cast and then the setter, and prints [abc].
type WS
    as wstring * 16 text
    declare operator cast( ) byref as wstring
    declare operator let( byref rhs as WS )
end type
operator WS.cast( ) byref as wstring
    return this.text
end operator
operator WS.let( byref rhs as WS )
    this.text = rhs.text
end operator
type Holder
    as wstring * 16 stored
    declare property Pattern( ) as WS
    declare property Pattern( byref w as const wstring )
end type
property Holder.Pattern( ) as WS
    dim as WS r
    r.text = this.stored
    return r
end property
property Holder.Pattern( byref w as const wstring )
    this.stored = w
end property
dim as Holder h
dim as WS v
v.text = "abc"
h.Pattern = v
print "[" & h.stored & "]"
