' '@type<integer>( 123 )' as an argument and an initialiser: the address of a temporary.
sub show(byval p as integer ptr)
    print *p;
end sub
show(@type<integer>(123))
show(@type<integer>(2 + 3))
dim as double ptr q = @type<double>(2.5)
print *q
