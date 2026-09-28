'' NON-GENERIC PROCEDURES WHOSE SIGNATURES NAME GENERIC INSTANCES -- a header's (FB.Map,
'' FB.Array) and the module's own (Box( of long )) -- are declared in the interface and
'' link to the module's one definition. Only a procedure with its OWN type parameters, and
'' a generic type's member, travel whole.
#module "gp"
#include once "containers.bi"
public dim shared calls as long
public type Box( of T )
    v as T
    declare function Get( ) as T
end type
function Box( of T ).Get( ) as T
    return v
end function
public type Acc
    total as long
    declare sub AddAll( byref a as FB.Array( of long ) )
end type
sub Acc.AddAll( byref a as FB.Array( of long ) )
    calls += 1
    for each x as long in a
        total += x
    next
end sub
'' A generic instance as a parameter.
public function Total( byref m as FB.Map( of string, long ) ) as long
    calls += 1
    dim as long t = 0
    for each v as long in m.Values( )
        t += v
    next
    return t
end function
'' ...as the result.
public function Evens( byval n as long ) as FB.Array( of long )
    calls += 1
    dim as FB.Array( of long ) r
    for i as long = 1 to n
        r.Push( i * 2 )
    next
    return r
end function
'' ...the module's own generic, instantiated, as the result.
public function MakeBox( byval x as long ) as Box( of long )
    calls += 1
    dim as Box( of long ) b
    b.v = x
    return b
end function
'' A generic procedure: carried whole, instantiated in the importer.
public function Largest( of T )( byref a as FB.Array( of T ) ) as T
    dim as T best = a[0]
    for each x as T in a
        if x > best then best = x
    next
    return best
end function
'' ...spelled 'Of': the word is no keyword, and case does not matter to it.
public function Smallest( Of T )( byref a as FB.Array( of T ) ) as T
    dim as T least = a[0]
    for each x as T in a
        if x < least then least = x
    next
    return least
end function
