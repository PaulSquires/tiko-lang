'' THE ELEMENT TYPE HAS TO AGREE, and the parameter has to BE an array. Measured on
'' fbc 1.20.0: both of these are its error 4, unlike the FIELD rule, which declares a
'' local on a mismatch rather than refusing.
sub mismatch( arr( ) as double )
    redim arr( 2 ) as long
end sub

sub scalar_( byval x as long )
    redim x( 3 ) as long
end sub
