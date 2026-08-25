type U
    as long k
end type
sub mut( u as U )
    u.k = 99
end sub
sub muts( s as string )
    s = "changed"
end sub
sub keeps( byval u as U )
    u.k = 1
end sub
dim as U a
a.k = 1
mut( a )
print a.k
dim as string t = "x"
muts( t )
print t
keeps( a )
print a.k
