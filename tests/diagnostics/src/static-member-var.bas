'' 'dim UDT.i as integer' DEFINES a static member variable, and fbc refuses it (error
'' 147) unless the type declared 'static i as ...'. MEASURED both ways of getting it
'' wrong: no such member at all, and a member that is an ordinary FIELD. The good
'' spelling below compiles, so it is the STATIC that is demanded, not the name.
type Good
    dummy as integer
    static ok as integer
end type

type Missing
    dummy as integer
end type

type Field_
    i as integer
end type

dim Good.ok as integer
dim Missing.i as integer
dim Field_.i as integer
