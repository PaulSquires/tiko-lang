'' TWO RULES, both measured.
''
'' A BASE WITH NO DEFAULT CONSTRUCTOR CANNOT BE INITIALISED FOR YOU -- fbc errors 186 and
'' 188, "base UDT without default constructor requires manual initialization":
''
''     base declares constructor( byval as integer ) only,
''       derived declares a constructor                    error 188
''       derived declares none                             error 186
''     base declares constructor( ) as well                OK
''     base declares NO constructor at all                 OK -- the implicit one
''
'' What makes it an error is the base HAVING constructors and none being callable with no
'' argument: there is then nothing the derived type's own construction can call.
''
'' AND 'iif' RETURNS ONE TYPE, so its two arms may not disagree -- fbc error 24:
''
''     iif( c, an_integer, a_string )        error 24
''     iif( c, @sub1, @sub2 )                error 24   two DIFFERENT procedure pointers
''     iif( c, an_integer_ptr, a_byte_ptr )  error 24   pointers must match EXACTLY
''     iif( c, a_long, a_double )            OK         numbers convert to each other
type NeedsArg
    dummy as integer
    declare constructor( byval n as integer )
end type

constructor NeedsArg( byval n as integer )
end constructor

type HasDefault
    dummy as integer
    declare constructor( )
    declare constructor( byval n as integer )
end type

constructor HasDefault( )
end constructor

constructor HasDefault( byval n as integer )
end constructor

type NoCtorAtAll
    dummy as integer
end type

dim shared as integer c, n1, n2
dim shared as long lv
dim shared as double dv
dim shared as string sv
dim shared as integer ptr ip
dim shared as byte ptr bp

'' -- refused ------------------------------------------------------------------
type BadDerived extends NeedsArg
    other as integer
end type

sub iifRefused( )
    print iif( c, n1, sv )
    print cast( integer, iif( c, ip, bp ) )
end sub

'' -- accepted -----------------------------------------------------------------
type OkDerived extends HasDefault
    other as integer
end type

type OkDerived2 extends NoCtorAtAll
    other as integer
end type

sub iifAccepted( )
    print iif( c, n1, n2 )
    print iif( c, lv, dv )
end sub
