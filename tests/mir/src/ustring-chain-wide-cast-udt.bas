'' A UDT THAT CASTS TO A WSTRING, IN A USTRING CHAIN. AfxNova's DWSTRING is the case: tracks
'' writes 's &= "TwsHost=" & this.TwsHost & nl' and a CATEGORY line of the same shape, and both
'' statements were DROPPED -- no diagnostic, one more statement not lowered -- so every
'' settings save lost those lines. IsRenderedNumberTerm_ called every UDT a rendered number
'' and LowerUStrChain forced the term NARROW, where EmitStrTerm has no form for it.
''
'' DS copies DWSTRING's shape and needs no AfxNova: three global byref 'operator &'
'' overloads returning DS by value, a 'byref as const wstring' cast, no converting
'' constructors.
''
'' fbc routes these chains through the user operators and converts the USTRING side with
'' fb_UStrToStr, which turns non-ANSI text into its UTF-8 bytes read back as separate
'' units. tiko keeps every term UTF-16 instead -- the same text for ANSI, and non-ANSI text
'' intact. That is deliberate.
type DS
    as wstring * 64 w
    declare constructor( )
    declare constructor( byref other as DS )
    declare destructor( )
    declare operator cast( ) byref as const wstring
    declare operator cast( ) as any ptr
end type
constructor DS( )
end constructor
constructor DS( byref other as DS )
    this.w = other.w
end constructor
destructor DS( )
end destructor
operator DS.cast( ) byref as const wstring
    return this.w
end operator
operator DS.cast( ) as any ptr
    return @this.w
end operator

operator & ( byref a as DS, byref b as DS ) as DS
    dim as DS r
    r.w = a.w & b.w
    return r
end operator
operator & ( byref a as DS, byref b as string ) as DS
    dim as DS r
    r.w = a.w & b
    return r
end operator
operator & ( byref a as string, byref b as DS ) as DS
    dim as DS r
    r.w = a & b.w
    return r
end operator

function MkDS( ) as DS
    dim as DS r
    r.w = "made"
    return r
end function

type Cfg
    as DS host
    as DS cat(2)
    declare function Build( ) as ustring
end type

'' tracks' two lines, in their own shape.
function Cfg.Build( ) as ustring
    dim as ustring nl = chr(10)
    dim as ustring s
    s &= "TwsHost=" & this.host & nl
    for i as long = lbound(this.cat) to ubound(this.cat)
        s &= "CATEGORY=" & str(i) & "|" & this.cat(i) & nl
    next
    return s
end function

sub Shapes( )
    dim as DS d
    d.w = "host"
    dim as ustring nl = chr(10)
    dim as ustring u = "U"
    dim as longint n = 25

    dim as ustring t1 = "x=" & d                    '' declaration initialiser
    print "init   [" & t1 & "]"
    dim as ustring s2 = "["
    s2 = s2 & "x=" & d & nl                         '' assignment
    print "assign [" & s2 & "]"
    dim as ustring s3 = "["
    s3 &= "x=" & d & nl                             '' compound append
    print "append [" & s3 & "]"
    dim as ustring s4 = "["
    s4 &= "call=" & MkDS( ) & nl                    '' an rvalue: MkDS's result temporary
    print "rvalue [" & s4 & "]"
    dim as ustring t5
    t5 = u & n & d                                  '' a rendered number beside it
    print "number [" & t5 & "]"

    dim as string nar = "x=" & d                    '' narrow controls: already lowered
    nar = nar & d
    print "narrow [" & nar & "]"
end sub

Shapes( )
dim as Cfg g
g.host.w = "127.0.0.1"
g.cat(1).w = "Wheel"
print g.Build( );
