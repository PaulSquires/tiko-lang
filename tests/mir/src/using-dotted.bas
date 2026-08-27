'' 'using a.b' -- A DOTTED USING PATH, and the two lookups that ride on it.
''
'' The parser OVERWROTE the name per component, so 'using n1.n2' arrived as plain 'n2' --
'' which is not visible unqualified, so the lookup found nothing and AddUsing was never
'' called at all. The import brought in nothing and every name it was meant to make
'' visible declined. Seventeen corpus statements, and the single-component 'using n1'
'' beside them worked, which is what made it look like a scoping subtlety rather than a
'' dropped name.
''
'' The path is kept WHOLE and DOTTED in the one field -- the same shape a qualified type
'' reference and a member definition both use -- and walked a component at a time: only
'' the FIRST is visible from here, each later one is looked up INSIDE what the previous
'' opened.
''
'' AND A NAMESPACE MAY GET A NAME FROM ITS OWN USING. 'n3.v2' where n3 does 'using n1.n2'
'' went through LookupLocal, a single hash probe that never sees a using; the walking
'' Lookup follows the ENCLOSING-SCOPE chain and never descends into a named namespace. So
'' the qualified access found nothing, and so did a leading '.name' under a file-scope
'' using. LookupInNamespace follows them, depth-limited rather than visited-set because a
'' using chain can be CYCLIC -- namespace/using_rec.bas is.
namespace n1
    dim shared as integer v1 = 1
end namespace

namespace n1.n2
    dim shared as integer v2 = 2
end namespace

namespace n3
    using n1.n2
end namespace

dim shared as integer r

sub s1( )
    scope
        using n1.n2
        r = v2
        print r
    end scope

    r = n3.v2
    print r
end sub

sub s2( )
    using n1
    r = .v1
    print r
end sub

s1( )
s2( )
