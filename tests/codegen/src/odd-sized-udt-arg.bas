#lang "fb"
#macro build( N )
type UDT##N field = 1
    a(0 to (N)-1) as byte
end type
sub fudt##N( byval pre as uinteger, byval x as UDT##N, byval post as uinteger )
    if pre <> &hAABBAABB then print "PRE BAD"; N
    if post <> &hCCDDCCDD then print "POST BAD"; N
    for i as integer = 0 to (N)-1
        if x.a(i) <> i + 1 then print "VAL BAD"; N; i; x.a(i)
    next
end sub
#endmacro
build( 1 )
build( 2 )
build( 3 )
build( 5 )
build( 7 )
build( 8 )

#macro run_( N )
scope
    dim as uinteger pre = &hAABBAABB, post = &hCCDDCCDD
    print sizeof( UDT##N );
    dim as UDT##N x
    for i as integer = 0 to (N)-1
        x.a(i) = i + 1
    next
    fudt##N( pre, x, post )
    dim as UDT##N ptr p = callocate( sizeof( UDT##N ) )
    for i as integer = 0 to (N)-1
        p->a(i) = i + 1
    next
    fudt##N( pre, *p, post )
    deallocate( p )
    dim as UDT##N arr(0 to 7)
    for j as integer = 0 to 7
        for i as integer = 0 to (N)-1
            arr(j).a(i) = i + 1
        next
        fudt##N( pre, arr(j), post )
    next
    dim as UDT##N ptr pa = callocate( sizeof( UDT##N ) * 8 )
    for j as integer = 0 to 7
        for i as integer = 0 to (N)-1
            pa[j].a(i) = i + 1
        next
        fudt##N( pre, pa[j], post )
    next
    deallocate( pa )
end scope
#endmacro
run_( 1 )
run_( 2 )
run_( 3 )
run_( 5 )
run_( 7 )
run_( 8 )
print
print "done"
