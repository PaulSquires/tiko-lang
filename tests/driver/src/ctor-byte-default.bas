'' A DEFAULTED NARROW PARAMETER OF AN IMPLICITLY CALLED CONSTRUCTOR is converted to its
'' own type before the call, as a written argument is.
''
'' 'dim as U v' calls U's constructor with every argument defaulted, and the defaults
'' were passed as the expressions they are -- '= 2' is an INTEGER. Over a 'byval as
'' byte', whose slot the signature widens to i32, the emitter then extended the i64 as
'' though it were a byte:
''
''     %t58 = sext i64 0 to i32         clang: invalid cast opcode
''
'' so the module did not assemble. fbx's CDialog declares exactly that constructor --
'' 'byval fontStyle as BYTE = 0, byval charset as BYTE = DEFAULT_CHARSET' -- and every
'' one of its 37 examples failed to build, while 'dim as U v = U( 5 )', written, built.
''
'' fbc prints, one per line:
''      923    523    9 2 3    -12    7
type U
    dim as long x
    declare constructor( byval a as long = 9, byval b as byte = 2, byval c as byte = 3 )
end type
constructor U( byval a as long = 9, byval b as byte = 2, byval c as byte = 3 )
    x = a * 100 + b * 10 + c
end constructor

'' Every defaulted width, signed and not.
type W
    dim as long x
    declare constructor( byval s as short = -12, byval u as ubyte = 7 )
end type
constructor W( byval s as short = -12, byval u as ubyte = 7 )
    x = s
    print x
    print u
end constructor

sub S( byval a as long = 9, byval b as byte = 2, byval c as byte = 3 )
    print a; b; c
end sub

dim as U v1
print v1.x
dim as U v2 = U( 5 )
print v2.x
S( )
dim as W wv
