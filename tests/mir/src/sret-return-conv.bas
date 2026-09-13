'' 'RETURN <other type>' INTO A UDT RETURNED THROUGH THE HIDDEN POINTER CONSTRUCTS the
'' result through the matching converting constructor. fbc-modern prints, and tiko now
'' prints too:
''
''    Janvier | Janvier | Janvier | ctor= 3 dtor= 3 let= 0
''
'' The result path only copy-constructed from the SAME type and otherwise stored the
'' value over the object: 'return "Janvier"' wrote the literal's ADDRESS into the first
'' field. AfxNova's DWSTRING then owned a pointer to static text, its destructor freed
'' it, and the next allocation found the heap corrupt -- PsCalendar's CAL_MonthName.
dim shared as integer nCtor, nDtor, nLet
type WB
    p as zstring ptr
    declare constructor( )
    declare constructor( byref z as const zstring )
    declare constructor( byref o as WB )
    declare destructor( )
    declare operator let( byref z as const zstring )
    declare operator let( byref o as WB )
end type
constructor WB( )
    nCtor += 1 : p = callocate( 16 )
end constructor
constructor WB( byref z as const zstring )
    nCtor += 1 : p = callocate( 16 ) : *p = left( z, 15 )
end constructor
constructor WB( byref o as WB )
    nCtor += 1 : p = callocate( 16 ) : *p = *o.p
end constructor
destructor WB( )
    nDtor += 1 : if p then deallocate( p ) : p = 0
end destructor
operator WB.let( byref z as const zstring )
    nLet += 1 : *p = left( z, 15 )
end operator
operator WB.let( byref o as WB )
    nLet += 1 : *p = *o.p
end operator
function mname( byval m as long ) as WB
    return "Janvier"
end function
for i as long = 1 to 3
    print *mname( 1 ).p
next
print "ctor="; nCtor; " dtor="; nDtor; " let="; nLet
