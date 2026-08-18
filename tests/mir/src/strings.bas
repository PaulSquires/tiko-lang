'' String lowering. A var-length string is a 24-byte DESCRIPTOR, and every runtime
'' call takes it as (pointer, -1) -- the runtime reads the length from the descriptor.
sub Assign( )
    dim as string a
    dim as string b
    a = b
    a = a + b
end sub

'' The delete is registered as a cleanup action, so it obeys the same measured order
'' as destructors and defers: reverse declaration, and every scope on an early exit.
sub Scoped( byval f as long )
    dim as string outer_
    scope
        dim as string inner_
        if f then return
    end scope
end sub

'' A '+' chain flattens into one assign and N concat-assigns -- no temporary, which
'' is what fbc emits. A literal is passed as its own bytes with length strlen+1.
sub Concat( )
    dim as string a, b, c
    a = "x"
    a = b + c
    a = b + c + b
end sub
