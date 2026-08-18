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
