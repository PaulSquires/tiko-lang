'' SWAP is TWO lowerings, and which one depends on the operand type.

sub P( )
    dim as long a, b
    dim as string s, t
    dim as double d, e
    swap a, b
    swap s, t
    swap d, e
end sub

'' THE OPERANDS MAY DIFFER IN TYPE. fbc allows this and CONVERTS across the assignments:
'' the temporary is typed to the LEFT operand and each store converts into its
'' destination. Loading both sides through one type instead reinterprets the bits, which
'' lowers cleanly, verifies, and is wrong -- this was exactly that bug for one commit.
sub Mixed( )
    dim as long m
    dim as double n
    swap m, n
end sub
