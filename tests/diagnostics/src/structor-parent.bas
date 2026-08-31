'' ONLY A UDT MAY OWN A CONSTRUCTOR OR DESTRUCTOR -- fbc error 168, "Parent is not a class
'' or UDT", and error 160 when the name is not visible at all.
''
'' 'constructor ns( )' resolved 'ns' to something that HAS AN INNER SCOPE, which was the
'' whole test, so the body opened inside the NAMESPACE and the structor was accepted --
'' with 'this' typed as nothing.
namespace ns
    type UDT
        dummy as integer
        declare constructor( )
        declare destructor( )
    end type
end namespace

namespace ns
    constructor UDT( )
    end constructor
    destructor UDT( )
    end destructor
end namespace

type Plain
    dummy as integer
    declare constructor( )
end type

'' -- refused ------------------------------------------------------------------
constructor ns( )
end constructor

destructor ns( )
end destructor

'' -- accepted -----------------------------------------------------------------
constructor Plain( )
end constructor
