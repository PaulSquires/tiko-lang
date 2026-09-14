'' A WIDE VALUE APPENDED TO A NARROW STRING. tracks-style 's &= "host=" & this.Host & "|"' over a
'' DWSTRING field -- and every '&=' of a wstring, a 'wstr( )' or a wide chain onto a var-length
'' string -- was DROPPED: no diagnostic, one more statement not lowered. With a USTRING in the
'' same chain it lowered and was wrong: 'h &= u & wz' held "nU w i".
''
'' Measured, fbc-modern prints, one per line:
''
''     nahost  nhost  nahostb  nwide  nawide  nawideb  nwide7
''     ncall=made  n5  nahost7  nhost  abbwide  nUwide  nnarrow  nanarrow
''     [host=127.0.0.1|
''
'' fbc builds the value wide, then fb_WstrConcatAW onto the destination and fb_WstrAssignToA
'' back. For DS it goes through the user 'operator &' overloads first; tiko keeps the wide
'' runtime route, and the text is the same because the destination is narrow either way.
''
'' DS copies DWSTRING's shape (see ustring-chain-wide-cast-udt.bas). DUAL casts both ways and fbc
'' picks the NARROW cast, so it stays on the narrow path.
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

type DUAL
    as wstring * 16 w
    declare operator cast( ) as string
    declare operator cast( ) byref as const wstring
end type
operator DUAL.cast( ) as string
    return "narrow"
end operator
operator DUAL.cast( ) byref as const wstring
    return this.w
end operator

type Cfg
    as DS host
    declare function Build( ) as string
end type

function Cfg.Build( ) as string
    dim as string s = "["
    s &= "host=" & this.host & "|"
    return s
end function

sub Shapes( )
    dim as DS d
    d.w = "host"
    dim as DUAL du
    du.w = "wideside"
    dim as wstring * 16 wz = "wide"
    dim as wstring ptr wp = @wz
    dim as ustring u = "U"

    dim as string a1 = "n" : a1 &= "a" & d          '' DWSTRING-shaped
    print a1
    dim as string a2 = "n" : a2 &= d
    print a2
    dim as string a3 = "n" : a3 &= "a" & d & "b"
    print a3
    dim as string w1 = "n" : w1 &= wz               '' plain wide
    print w1
    dim as string w2 = "n" : w2 &= "a" & wz
    print w2
    dim as string w3 = "n" : w3 &= "a" & *wp & "b"
    print w3
    dim as string w4 = "n" : w4 &= wz & 7
    print w4
    dim as string r1 = "n" : r1 &= "call=" & MkDS( ) '' an rvalue UDT
    print r1
    dim as string r2 = "n" : r2 &= wstr( 5 )
    print r2
    dim as string r3 = "n" : r3 &= "a" & d & 7
    print r3
    dim as string r4 = "n" : r4 += d                 '' '+=' is the same statement
    print r4
    dim as string k = "ab" : k &= mid( k, 2 ) & wz  '' the value reads the destination
    print k
    dim as string h = "n" : h &= u & wz             '' a ustring in the chain
    print h
    dim as string c1 = "n" : c1 &= du               '' dual cast: narrow, both
    print c1
    dim as string c2 = "n" : c2 &= "a" & du
    print c2
end sub

Shapes( )
dim as Cfg g
g.host.w = "127.0.0.1"
print g.Build( )
