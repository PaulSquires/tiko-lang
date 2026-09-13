'' A FIXED ARRAY FIELD OF A TYPE WITH A CONSTRUCTOR CONSTRUCTS EVERY ELEMENT. fbc-modern
'' prints, and tiko now prints too:
''
''    [Fevrier][]
''    ctor= 3 dtor= 3 let= 1
''
'' The synthesised constructor zero-filled the field and stopped -- InitMember_ said the
'' element loop was owed -- while the destructor already destroyed all three. Each element
'' started with a null buffer, so the first assignment wrote through it: AfxNova's
'' DWSTRING.Clear, reached from PsCalendar's 'wszMonthName(1 to 12) as DWSTRING'.
dim shared as integer nCtor, nDtor, nLet
type EL
    p as zstring ptr
    declare constructor( )
    declare destructor( )
    declare operator let( byref s as string )
end type
constructor EL( )
    nCtor += 1 : p = callocate( 16 )
end constructor
destructor EL( )
    nDtor += 1 : if p then deallocate( p ) : p = 0
end destructor
operator EL.let( byref s as string )
    nLet += 1 : *p = left( s, 15 )
end operator
type HOLD
    e(1 to 3) as EL
end type
scope
    dim as HOLD h
    h.e(2) = "Fevrier"
    print "["; *h.e(2).p; "]["; *h.e(1).p; "]"
end scope
print "ctor="; nCtor; " dtor="; nDtor; " let="; nLet
