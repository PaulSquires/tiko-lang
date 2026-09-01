'' THREE RULES, all measured.
''
'' AN 'extern' OR 'common' VARIABLE CANNOT BE INITIALISED -- fbc error 135. Both are
'' declarations of storage that belongs to another module, so there is nothing here to
'' write into. The same declarations without an initialiser are fine.
''
'' A UDT WHOSE CONSTRUCTORS INCLUDE NO DEFAULT ONE cannot be declared without an
'' initialiser -- fbc error 183, "TYPE or CLASS has no default constructor". The same rule
'' as a base's, one level down: 'dim as T x' has nothing to call, while
'' 'dim as T x = T( 1 )' names what to call. A type with NO constructor at all is fine.
''
'' AND A DECLARATION MAY NOT CROSS THE STRING/NUMBER DIVIDE, for a variable exactly as for
'' a constant -- fbc error 24.
type NeedsArg
    dummy as integer
    declare constructor( byval n as integer )
end type

constructor NeedsArg( byval n as integer )
end constructor

type PlainType
    dummy as integer
end type

'' -- refused ------------------------------------------------------------------
extern externInit as integer = 1
dim shared noDefault as NeedsArg

'' LOCAL, because a SHARED var-len string cannot be initialised at all -- that is fbc
'' error 87 and a different rule, checked by tests/diagnostics/static-string-init.
sub declRefused( )
    dim badStr as string = 1
    dim badNum as integer = "x"
end sub

'' -- accepted -----------------------------------------------------------------
extern externPlain as integer
dim shared okNum as integer = 1
dim shared constructed as NeedsArg = NeedsArg( 1 )
dim shared plain_ as PlainType

sub declAccepted( )
    dim okStr as string = "x"
end sub
