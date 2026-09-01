'' A PRIVATE MEMBER NAMED WITHOUT A QUALIFIER IS STILL A MEMBER ACCESS -- fbc error 202,
'' the same it gives for 'x.privateThing'. Inside a DERIVED type's method the bare name
'' resolves to the base's member, and private does not reach that far; PROTECTED does,
'' which is what the accepted half below is for.
''
'' The check asks the question OF THE SYMBOL, not of the syntax: it reads whatever Check
'' bound to the node, so a bare name, a field, a method and a constant are one rule.
type Parent
    as integer i
    protected:
    const OPENC = 7
    declare sub openM( )
    private:
    const SHUTC = 123
    static shutV as integer
    declare sub shutM( )
end type

dim Parent.shutV as integer

sub Parent.openM( )
end sub

sub Parent.shutM( )
end sub

type Child extends Parent
    declare sub test( )
end type

sub Child.test( )
    dim as integer a = OPENC
    openM( )

    dim as integer b = SHUTC
    dim as integer c = shutV
    shutM( )
end sub
