'' An integer divisor that is not a non-zero constant is tested before the divide, and a
'' zero branches to llvm.trap; a constant one is not guarded.
function dv( byval a as long, byval b as long ) as long
    return a \ b
end function
function md( byval a as long, byval b as long ) as long
    return a mod b
end function
function d3( byval a as long ) as long
    return a \ 3
end function
print dv( 7, 2 ), md( 7, 2 ), d3( 9 )
print "before"
print md( 7, 0 )
print "after"
