'' 'dim as T x = f( )' WHERE f RETURNS BYREF, over a T holding a dynamic array. A call's
'' result is moved rather than copied when the type carries an array -- right for a BY
'' VALUE result, a temporary nobody else holds, and wrong for a byref one, which is
'' somebody else's object: tracks' 'dim as TdbDatabase db2 = back.Value( )' aliased the
'' Result's arrays and both freed them, 0xC0000374. Measured, fbc-modern copy-constructs
'' and prints ' 2026 2 9 other', ' 7 lbl' and 'done'.
type Db
    as long year
    as long items( any )
    as string label
end type
type Holder
    as Db v
    declare function Value( ) byref as Db
end type
function Holder.Value( ) byref as Db
    return this.v
end function
scope
    dim as Holder h
    h.v.year = 2026
    redim h.v.items( 2 )
    h.v.items( 1 ) = 7
    h.v.label = "lbl"
    scope
        dim as Db d2 = h.Value( )
        d2.items( 1 ) = 9
        d2.label = "other"
        print d2.year; ubound( d2.items ); d2.items( 1 ); " "; d2.label
    end scope
    print h.v.items( 1 ); " "; h.v.label
end scope
print "done"
