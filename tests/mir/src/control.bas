'' SELECT CASE in all four of its forms, and GOTO across a scope that owns a cleanup.

sub Sel( byval n as long )
    dim as long r
    select case n
        case 1
            r = 1
        case 2, 3
            r = 2
        case 4 to 6
            r = 3
        case is > 10
            r = 4
        case else
            r = 5
    end select
end sub

sub Jump( byval n as long )
    dim as long r
    if n = 1 then goto done
    scope
        dim as string s = "x"
        if n = 2 then goto done
        r = 1
    end scope
    r = 2
done:
    r = 3
end sub

'' Two labels of the SAME NAME in one procedure. Labels are scoped in FreeBASIC, so
'' sibling scopes may each declare 'again' -- fbcunit's TEST macro produces exactly this
'' shape. Slots are keyed by name alone and cannot tell them apart.
sub Dup( byval n as long )
    dim as long r
    scope
        again:
        r = 1
    end scope
    scope
        again:
        r = 2
    end scope
end sub

'' 'END [exitcode]' terminates the program. Two things are measured rather than assumed:
'' it is a DIRECT fb_End call, not a jump to the function's exit, and it runs NO CLEANUPS
'' at all -- a trace holding a live destructor and a live string prints neither.
sub Ending( byval n as long )
    dim as string s = "x"
    if n = 1 then end 3
    if n = 2 then end
end sub

'' A NAMESPACE-QUALIFIED name. 'ns.Greet( 1 )' is a qualified NAME, not a member access
'' on a value, so the member resolves inside the namespace's own scope. Before this the
'' head of the statement was a namespace and it was rejected as "not a procedure" --
'' which was the single largest cause of unlowered statements in the corpus.
namespace nsq
    sub Greet( byval n as long )
    end sub
    dim shared as long counter
end namespace

sub UseNs( )
    nsq.Greet( 1 )
    nsq.counter = 2
end sub
