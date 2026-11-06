'' 'trycast' is contextual: a program's own procedure of that name, declared above the call,
'' keeps its meaning (docs/tiko-interfaces §17 Q6).
function trycast( byval a as long, byval b as long ) as long
    return a + b
end function
print trycast( 1, 2 )
