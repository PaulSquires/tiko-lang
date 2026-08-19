type T
    as long v
    declare sub M( )
    declare sub Caller( )
    declare function S( ) as T ptr
end type
sub T.M( ) : end sub
function T.S( ) as T ptr : return @this : end function
sub T.Caller( )
    this.M( )
    M( )
end sub
dim shared as T obj
dim shared as T ptr p = @obj
obj.M( )
p->M( )
(*p).M( )
obj.S( )->M( )
