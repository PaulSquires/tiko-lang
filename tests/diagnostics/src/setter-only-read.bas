type G
    declare property P( byval v as long )
    declare property Q( byval i as long, byval v as long )
    declare property R( ) as long
    declare property R( byval v as long )
    pv as long
end type
property G.P( byval v as long )
    pv = v
end property
property G.Q( byval i as long, byval v as long )
    pv = v
end property
property G.R( ) as long
    return pv
end property
property G.R( byval v as long )
    pv = v
end property
dim as G gx
gx.P = 5
dim as long n = gx.P
print "A["; gx.P; "]B"
n = gx.P + 1
gx.Q( 1 ) = 3
print gx.Q( 1 )
gx.R = 4
print gx.R
with gx
    print .P
end with
