'' 'N.UDT( )' over a type with nothing to construct -- fbc's error 42, or 1 as an argument,
'' as for the unqualified call. A method call and a type with a constructor are fine.
namespace N
    type Plain
        i as integer
        declare const function Get( ) as integer
    end type
    const function Plain.Get( ) as integer
        return i
    end function
    type Built
        i as integer
        declare constructor( )
    end type
    constructor Built( )
    end constructor
end namespace
function Pick( byref d as N.Plain ) byref as N.Plain
    return d
end function
dim p as N.Plain = N.Plain( )                       '' 42
print Pick( N.Plain( ) ).Get( )                     '' 1
dim b as N.Built = N.Built( )                       '' fine
print p.Get( )                                      '' fine
