'' A USER 'operator &' WITH A USTRING OPERAND, INTO A STRING, A USTRING AND A WSTRING. fbx's
'' DVARIANT is the case: 'dim s2 as string = dv & " " & ustr' is two calls of
'' 'operator &( DVARIANT, DVARIANT )', the USTRING converted by DVARIANT's constructor, and
'' the result through its wide cast. tiko split the calls into a concatenation, found a
'' USTRING term that is not there, and dropped the initialiser -- s2 printed empty.
'' Measured, fbc-modern prints each line as [VARIANT UString].
type DVAR
    as wstring * 64 w
    declare constructor( )
    declare constructor( byref u as ustring )
    declare constructor( byref other as DVAR )
    declare destructor( )
    declare operator cast( ) byref as wstring
end type
constructor DVAR( )
end constructor
constructor DVAR( byref u as ustring )
    this.w = u
end constructor
constructor DVAR( byref other as DVAR )
    this.w = other.w
end constructor
destructor DVAR( )
end destructor
operator DVAR.cast( ) byref as wstring
    return this.w
end operator
operator & ( byref a as DVAR, byref b as DVAR ) as DVAR
    dim as DVAR r
    r.w = a.w & b.w
    return r
end operator

dim as ustring ustr = "UString"
dim as ustring vt = "VARIANT"
dim as DVAR dv = vt
dim as string s2 = dv & " " & ustr
print "[" & s2 & "]"
dim as ustring u2 = dv & " " & ustr
print "[" & u2 & "]"
dim as ustring u3
u3 = dv & " " & ustr
print "[" & u3 & "]"
dim as wstring * 64 w2 = dv & " " & ustr
print "[" & w2 & "]"
print "[" & ( dv & " " & ustr ) & "]"
