'' '.' AND '->' ARE NOT INTERCHANGEABLE. Measured, over 'x as UDT', 'p as UDT ptr' and
'' 'pp as UDT ptr ptr':
''
''     x.i        OK        p.i        error 265   a DOT through a pointer
''     p->i       OK        x->i       error 28    an ARROW through a value
''     (*p).i     OK        pp->i      error 24    the pointee is not a UDT
''     (*pp)->i   OK        (*pp).i    error 265
''
'' 'this' IS EXEMPT FROM THE DOT RULE. tiko-lang types it as a POINTER because that is
'' what the ABI passes -- fbc's own C spells the receiver 'struct $1T*' -- so 'this.i'
'' looks exactly like a dot through a pointer, and it is the commonest line in a method.
''
'' AN ARROW THROUGH A UDT IS NOT REPORTED, only through a builtin: a type may overload
'' 'operator ->', and that question is not measured here.
type UDT
    i as integer
    declare sub m( )
end type

sub UDT.m( )
    this.i = 1
end sub

dim shared x as UDT
dim shared p as UDT ptr
dim shared pp as UDT ptr ptr
dim shared n as integer

'' -- refused ------------------------------------------------------------------
sub refused( )
    print p.i
    print pp.i
    print pp->i
    print (*pp).i
    print n->i
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    print x.i
    print p->i
    print (*p).i
    print (*pp)->i
    print p[0].i
end sub
