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
