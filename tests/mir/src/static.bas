'' STATIC locals: procedure scope, module lifetime.

sub P( )
    static as long n = 5
    static as string s
    n = n + 1
    s = s + "!"
end sub

'' The SAME NAME in another procedure. fbc calls both N$1 and lets C function scoping
'' keep them apart; MIR globals are one flat table with no such scoping.
sub Q( )
    static as long n
    n = n + 100
end sub

P( )
Q( )

'' Two statics of the same name in SIBLING SCOPES of one procedure. fbc names both N$2
'' and separates them by emitting each scope as a nested C block; MIR has no such
'' nesting, so keying storage by spelling merged them into one variable that both scopes
'' incremented.
sub Siblings( )
    scope
        static as long k
        k = k + 1
    end scope
    scope
        static as long k
        k = k + 2
    end scope
end sub
