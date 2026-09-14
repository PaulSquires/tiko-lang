'' A USTRING FROM A UDT THAT CASTS TO WSTRING -- AfxNova's DWSTRING is the case that
'' matters. The term's flavour was NEUTRAL, so neither the declaration nor the assignment
'' converted it, and all four statements below were DROPPED: the ustrings stayed empty
'' and nothing was declined. tracks' 'dim as ustring path_ = this.ConfigFilename' was
'' this shape, and every setting failed to load.
''
'' Measured, fbc-modern's C for the declaration from a variable:
''
''     uint16* vr$3 = _ZN2WScvwEv( &D$0 );
''     FBUSTRING* vr$4 = fb_WstrToUStr( (uint16*)vr$3 );
''     fb_UStrInit( (void*)&FROMVAR$0, -1ll, (void*)vr$4, -1ll, 0 );
''
'' and the program prints '[from-var]', '[from-call]', '[from-var]', '[from-field]'.
type WS
    as wstring * 32 w
    declare operator cast( ) byref as wstring
end type

operator WS.cast( ) byref as wstring
    return this.w
end operator

function MkWS( ) as WS
    dim as WS r
    r.w = "from-call"
    return r
end function

type Holder
    as WS f
    declare function Get( ) as long
end type

function Holder.Get( ) as long
    dim as ustring fromField = this.f
    print "field ["; fromField; "]"
    return len( fromField )
end function

dim as WS d
d.w = "from-var"
dim as ustring fromVar = d
print "var ["; fromVar; "]"
dim as ustring fromCall = MkWS( )
print "call ["; fromCall; "]"
dim as ustring assigned
assigned = d
print "assign ["; assigned; "]"
dim as Holder h
h.f.w = "from-field"
h.Get( )
