'' THREE RULES, all measured.
''
'' AN 'extern' OR 'common' VARIABLE CANNOT BE INITIALISED -- fbc error 135. Both are
'' declarations of storage that belongs to another module, so there is nothing here to
'' write into. The same declarations without an initialiser are fine. A STATIC MEMBER IS
'' REALLY AN EXTERN -- its storage lives outside the type and is defined elsewhere -- so
'' 'static i as integer = 1' inside a TYPE is the same error.
''
'' AND A DYNAMIC ARRAY CANNOT BE A MEMBER OF A UNION -- fbc error 162. It is a DESCRIPTOR
'' that has to be constructed and destroyed, and a union's members overlap: there is no way
'' to say which of them owns the storage. A dynamic array records a NEGATIVE rank whose
'' magnitude is rank + 1, so 'a( any )' is -2 and testing for -1 alone found none of them.
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

type StaticInit
    dummy as integer
    static si as integer = 1
end type

union DynInUnion
    arr( any ) as integer
    other as integer
end union

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
