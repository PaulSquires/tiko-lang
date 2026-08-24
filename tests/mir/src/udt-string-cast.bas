'' A UDT WITH 'operator cast' TO A STRING, in the places that were still asking it for
'' something it has not got. Every one of these lowered as an ASSIGNMENT and declined
'' everywhere else, which is what the six udt-zstring and udt-wstring corpus files are
'' made of.
type U
    _d as zstring * 32
    declare constructor( )
    declare constructor( byval rhs as const zstring const ptr )
    declare operator cast( ) byref as zstring
end type
constructor U( )
end constructor
constructor U( byval rhs as const zstring const ptr )
end constructor
operator U.cast( ) byref as zstring
    return this._d
end operator

type W
    _d as wstring * 32
    declare operator cast( ) byref as wstring
end type
operator W.cast( ) byref as wstring
    return this._d
end operator

sub G( )
    dim u as U
    dim w as W
    dim as string s
    dim as long t = 5

    '' PRINT and STR of one: the conversion is what makes it a string at all.
    print u
    print str( u )
    print w

    '' 'dim u as U = s' IS A CONVERTING CONSTRUCTOR. Only the explicit 'U( s )'
    '' spelling was handled, so this fell through to the DEFAULT constructor and the
    '' initialiser was DROPPED -- built empty, no store, no decline, no diagnostic.
    dim u1 as U = s
    dim u2 as U = str( t )
    dim u3 as U = "lit"

    '' A UDT whose cast yields a WSTRING is a WIDE term, and asking that has to cost a
    '' walk rather than an emission -- the concatenation path decides before it emits.
    print w & ", " & wstr( "x" )
    print wstr( w )

    '' A NARROW RVALUE ASSIGNED TO A WIDE VARIABLE: 'mid( s, 1 )' has no address, and
    '' every branch of the wide assignment asked for one.
    dim rv as wstring * 50 = mid( s, 1 )
    dim ru as wstring * 50 = mid( u, 1 )

    '' A MIXED COMPARISON converts the narrow side -- fb_StrToWstr into a temporary,
    '' then fb_WstrCompare, and the temporary deleted afterwards.
    dim rt as zstring * 50
    dim r as boolean = ( rt = rv )
end sub

'' A UDT COMPARED AGAINST A FIXED STRING is a STRING comparison and has no type of its
'' own -- so a guard that refuses an untyped UDT operand before the string tests takes
'' this with it. It did, for one commit: 350 statements across the udt-wstring and
'' udt-zstring corpus families, which are made of exactly this line.
sub CompareAgainstFixed( )
    dim as zstring * 50 sz = "abc"
    dim as U uz = @"abc"
    if uz = sz then print "z"
    if sz = uz then print "z2"

    dim as wstring * 50 sw = wstr( "abc" )
    dim as W uw
    if uw = sw then print "w"
    if sw = uw then print "w2"
end sub
