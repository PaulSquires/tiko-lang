'' fbc error 98. MEASURED: two candidates both viable with no argument -- one of them
'' reaching zero through a DEFAULTED parameter -- is refused; the same pair with only
'' one viable is accepted, so the tie itself is what is refused, not the pair.
sub f overload( byval p1 as integer = 0 )
end sub

sub f overload( )
end sub

sub g overload( byval p1 as integer )
end sub

sub g overload( )
end sub

f( )
g( )
