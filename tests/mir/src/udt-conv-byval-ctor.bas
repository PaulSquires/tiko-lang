'' A CONVERTING CONSTRUCTOR WHOSE UDT PARAMETER IS BYVAL takes a caller-built copy, and the
'' copy lives to the END OF THE STATEMENT. fbc prints, and tiko's build of this now prints:
''
''    bar copy / foo_byval from bar 6 / ref 60 / bar dtor 6
''    bar copy / foo_byval from bar 6 / val 60 / bar dtor 6
''    foo_plain from plain 3 / pref 300 / foo_plain from plain 3 / pval 300 / done / bar dtor 5
''
'' tiko declined all four calls -- and before ArgNeedsUdtConv_ let a UDT argument through
'' at all, passed the argument's own bytes and never ran the constructor.
type bar
    n as integer
    declare constructor( )
    declare constructor( byref rhs as bar )
    declare destructor( )
end type
constructor bar( )
    n = 5
end constructor
constructor bar( byref rhs as bar )
    print "bar copy"
    n = rhs.n + 1
end constructor
type plain
    n as integer
end type
type foo_byval
    k as integer
    declare constructor( )
    declare constructor( byval v as bar )
end type
constructor foo_byval( )
    k = 0
end constructor
constructor foo_byval( byval v as bar )
    print "foo_byval from bar"; v.n
    k = v.n * 10
end constructor
type foo_plain
    k as integer
    declare constructor( byval v as plain )
end type
constructor foo_plain( byval v as plain )
    print "foo_plain from plain"; v.n
    k = v.n * 100
end constructor
sub take_ref( byref f as foo_byval )
    print "ref"; f.k
end sub
sub take_val( byval f as foo_byval )
    print "val"; f.k
end sub
sub takep_ref( byref f as foo_plain )
    print "pref"; f.k
end sub
sub takep_val( byval f as foo_plain )
    print "pval"; f.k
end sub
dim b as bar
dim pl as plain
pl.n = 3
take_ref( b )
take_val( b )
takep_ref( pl )
takep_val( pl )
print "done"
destructor bar( )
    print "bar dtor"; n
end destructor
