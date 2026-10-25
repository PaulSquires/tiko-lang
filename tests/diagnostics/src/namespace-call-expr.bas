'' A call in an expression whose head is a namespace: inside 'namespace tests.clamp',
'' 'Clamp( 3 )' finds the namespace first. fbc says 120 "Expected period" at the call when
'' the function comes later (fbc-modern 1.20, 2026-10-25): TKO0602 at line 6.
namespace tests.clamp
    sub Run( )
        print Clamp( 3 )
    end sub
end namespace
function Clamp( byval x as long ) as long
    return x
end function
