'' REDIM THROUGH A POINTER -- 'redim p->items( 0 to n )'. REDIM builds that target as a
'' '.' node carrying NF_ARROW, and the '.'-through-a-pointer rule read the operator
'' rather than the flag, so it reported TKO0630 against a statement that wrote the
'' arrow. fb/channel.bi does it in Channel's constructor. Measured, fbc-modern: both
'' statements compile, and ubound reads back 3 and then 7.
type T
    items( any ) as long
end type

sub grow( byval p as T ptr )
    redim p->items( 0 to 3 )
    redim preserve p->items( 0 to 7 )
end sub
