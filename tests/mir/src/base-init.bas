'' 'base( ... )' WHERE THE BASE DECLARES NO CONSTRUCTOR IS A FIELD-WISE INITIALISER, not
'' a call -- there is nothing to call. The lowering returned false the moment there was
'' no constructor to pick, so the statement fell through to an ordinary call of a
'' procedure named 'base' and declined; seven corpus statements, in the four files whose
'' whole subject is base initialisers.
''
'' Measured against fbc, at the very top of the derived constructor's body:
''
''   base( 1, 2, 3 )   three stores into the leading base fields
''   base( 123 )       one store, and THE REST OF THE BASE SUBOBJECT ZEROED
''   base( p0 )        one whole-subobject memcpy, when the single argument is the
''                     base's own type
''
'' AND WITHOUT A 'base( ... )' AT ALL, a base with no constructor is ZEROED. fbc emits
'' 'memset( (P*)THIS, 0, sizeof(P) )' as the derived constructor's first statement, and
'' tiko-lang emitted nothing -- it did not decline either, it silently left the base
'' subobject holding whatever the allocation held.
type P
    as integer a, b, c
end type

type C1 extends P
    declare constructor( )
end type

constructor C1( )
    base( 1, 2, 3 )
end constructor

type C2 extends P
    declare constructor( )
end type

constructor C2( )
    base( 123 )
end constructor

type C3 extends P
    declare constructor( byref p0 as P )
end type

constructor C3( byref p0 as P )
    base( p0 )
end constructor

type C4 extends P
    as integer d
    declare constructor( )
end type

constructor C4( )
    d = 7
end constructor

sub s1( )
    dim x as C1
    dim y as C2
    dim pp as P
    pp.a = 9 : pp.b = 8
    dim z as C3 = C3( pp )
    dim w as C4
    print x.a, x.b, x.c
    print y.a, y.b, y.c
    print z.a, z.b, z.c
    print w.a, w.d
end sub

s1( )
