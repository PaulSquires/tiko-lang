'' A FIELD WITH NOTHING ELSE TO INITIALISE IT IS ZEROED BY THE CONSTRUCTOR, and it was
'' left holding whatever the frame did. Measured from fbc's own C, and it is a PER-FIELD
'' memset of the field's declared size rather than one pass over the object:
''
''   static void _ZN5OUTERC1Ev( struct $5OUTER* THIS$1 )
''   {
''       *(int64*)THIS$1 = 9ll;
''       __builtin_memset( (struct $5INNER*)((uint8*)THIS$1 +  8ll), 0, 16ll );
''       __builtin_memset( (int64*)        ((uint8*)THIS$1 + 24ll), 0, 24ll );
''       __builtin_memset( (char*)         ((uint8*)THIS$1 + 48ll), 0,  8ll );
''   }
''
'' It is not conditional on how the constructor came about: a WRITTEN one gets the same
'' zeros in front of its own statements, and so does the one synthesised for 'extends
'' object'. This is the half of the field initialisers that a fully-initialised probe
'' cannot show -- 'k as integer = 9' printed 9 while the field beside it printed
'' whatever was there.
type Inner
    p as integer
    q as integer
end type

type Outer
    k as integer = 9
    inn as Inner
    arr(0 to 2) as integer
    z as zstring * 8
end type

'' A WRITTEN constructor: fbc zeroes both fields BEFORE the body's own assignment.
type Written
    n as integer
    m as integer
    declare constructor( )
end type

constructor Written( )
    n = 7
end constructor

sub dirty( )
    dim as long x1 = 111, x2 = 222, x3 = 333, x4 = 444
    print x1 + x2 + x3 + x4
end sub

sub show( )
    dim as Outer v
    dim as Written w
    print v.k, v.inn.p, v.arr(2), len( v.z ), w.n, w.m
end sub

dirty( )
show( )
