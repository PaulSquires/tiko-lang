'' A GENERIC CALLED WITH A FIELD OR A DEREFERENCE infers its type argument from it. The
'' inference pass answered for a name, a literal, an index and an address, but not for
'' 'h.m', 'p->m' or '*p' -- so 'Take( h.m )' was never instantiated and went out as a call
'' to the template, which has no body. tracks' 'FB.SortBy( this.m_array, @Less )' is the
'' shape, and no grid was sorted. Measured, fbc-modern prints ' 7', ' 7', ' 7' and ' 7'.
type Box( of T )
    as T v
end type
sub Take( of T )( byref b as Box( of T ) )
    print b.v
end sub
type Holder
    as Box( of long ) m
    declare sub Show( )
end type
sub Holder.Show( )
    Take( this.m )
end sub
dim as Holder h
h.m.v = 7
Take( h.m )
dim as Holder ptr hp = @h
Take( hp->m )
dim as Box( of long ) ptr bp = @h.m
Take( *bp )
h.Show( )
