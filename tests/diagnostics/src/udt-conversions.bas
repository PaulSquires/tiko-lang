'' A UDT MEETS SOMETHING IT DOES NOT CONVERT TO; A MEMBER THAT DOES NOT EXIST; ERASE
'' WITHOUT A DEFAULT CONSTRUCTOR; A BYDESC ELEMENT MISMATCH; BYVAL-CONST TWINS.
'' Measured against fbc: errors 181 and 24 (conversions), 18 (member), 183 (erase),
'' 58 (bydesc) and 4 (duplicated definition); the accepted lines compile.
type AA
    v as integer
end type
type BB
    w as integer
end type
type CC extends AA
    x as integer
end type
type WithLet
    v as integer
    declare operator let( byval i as integer )
end type
operator WithLet.let( byval i as integer )
end operator
type WithCtor
    v as integer
    declare constructor( )
    declare constructor( byval i as integer )
end type
constructor WithCtor( )
end constructor
constructor WithCtor( byval i as integer )
end constructor
type WithCast
    v as integer
    declare operator cast( ) as integer
end type
operator WithCast.cast( ) as integer
    return 1
end operator
type T1
    as integer i
    declare constructor( byval as integer )
end type
constructor T1( byval i as integer )
end constructor
dim a as AA, b as BB, c as CC
dim wl as WithLet, wc as WithCtor, wk as WithCast
dim i as integer
dim s as string
dim p as any ptr
a = c
c = a
a = b
a = 1
i = a
s = a
p = a
a = p
wl = 1
wc = 1
i = wk
dim d1 as AA = c
dim d2 as CC = a
dim d3 as AA = type<BB>( 1 )
dim d4 as AA = 1
dim d5 as integer = a
dim d6 as WithCtor = 1
dim d7 as integer = wk
dim d8 as AA = ( 1 )
dim u as AA
u.v = 1
u.zzz = 1
dim as T1 x(0 to 0) = { T1( 5 ) }
erase x
dim as WithCtor y(0 to 0)
erase y
sub takesDouble( arr( ) as double )
end sub
sub takesInteger( arr( ) as integer )
end sub
'' 'arr( ) as any' is legal in a DECLARE only (its definition is fbc error 59).
declare sub takesAny( arr( ) as any )
dim ints(0 to 3) as integer
dim dbls(0 to 3) as double
takesDouble( dbls( ) )
takesDouble( ints( ) )
takesInteger( ints( ) )
takesAny( ints( ) )
takesAny( dbls( ) )
sub ov1 overload( byval p as sub( byval as integer ) )
end sub
sub ov1 overload( byval p as sub( byval as const integer ) )
end sub
sub ov2 overload( byval p as sub( byref as integer ) )
end sub
sub ov2 overload( byval p as sub( byref as const integer ) )
end sub
sub ov3 overload( byval a as integer )
end sub
sub ov3 overload( byval a as const integer )
end sub
