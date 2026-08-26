'' A GENERIC PROCEDURE CALLED BY A QUALIFIED NAME WAS NEVER INSTANTIATED.
''
'' 'NS.Mk( 5L )' names the generic through its NAMESPACE, so the call's target is an
'' N_MEMBER and not an identifier -- and the instantiator refused anything that was not
'' an identifier, so no instantiation happened. The call still went out, to a mangled
'' name with no body behind it, or produced nothing at all where the result had to be a
'' value.
''
'' THE SAME CALL WRITTEN UNQUALIFIED, under 'using NS', instantiated correctly. That is
'' what says the fault is in finding the generic and not in instantiating it, and it is
'' how the shape was isolated: 'FB.Some( 5L )' out of fb/optional.bi declines while
'' 'using FB : Some( 5L )' does not.
''
'' TWO THINGS THE LOOKUP HAS TO GET RIGHT. A namespace's member scope is 'inner', not
'' 'payload'. And a QUALIFIED name looks only in THAT scope -- 'NS.Mk' means the Mk in
'' NS, and walking outward from it would find a different one or none.
''
'' It only shows up when the generic TYPE has a method: without one the call was emitted
'' anyway, to a body that was never generated, which is a link error rather than a
'' decline and so never appeared in the sweep.
namespace NS
    type Box( of T )
        as T v
        declare function Value( ) byref as T
    end type

    function Box( of T ).Value( ) byref as T
        return this.v
    end function

    function Five( ) as long
        return 5
    end function

    function Mk( of T )( byref x as T ) as Box( of T )
        dim as Box( of T ) r
        r.v = x
        return r
    end function
end namespace

dim as NS.Box( of long ) b = NS.Mk( 5L )
print b.Value( )

dim as NS.Box( of long ) c
c = NS.Mk( 7L )
print c.Value( )

'' AND AN ARGUMENT THAT IS ITSELF A QUALIFIED CALL, for the same reason one level in:
'' inferring the outer T reads the inner call's RESULT TYPE, and that lookup refused a
'' qualified callee too -- so the outer generic was uninferrable and the statement
'' declined.
dim as NS.Box( of long ) e = NS.Mk( NS.Five( ) )
print e.Value( )

'' WHAT STILL DECLINES, and deliberately: an inner call that is an OVERLOAD SET. One
'' return type per candidate, and picking the chain head would be picking one at
'' random -- Check resolves overloads later and this pass cannot. 'Some( IPow( 2L, 3L ) )'
'' in fb/mathint.bi is that, because IPow is macro-generated once per type.

'' ...and the unqualified spelling, which already worked
using NS
dim as Box( of double ) d = Mk( 2.5 )
print d.Value( )
