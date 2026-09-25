'' A runtime procedure's name as a parameter or a local of a GENERIC procedure is accepted
'' by fbc (fbc-modern 1.20) -- template and instance alike -- and in an ordinary procedure,
'' line 12, it is error 4.
sub Keep( of T )( byval x as T, byref out as T )
    dim as T timer = x
    out = timer
end sub
dim as integer v
Keep( 3, v )
print v

sub Plain( byref out as long )
end sub
