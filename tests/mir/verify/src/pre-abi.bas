'' A 20-byte UDT by value: the frontend's MIR passes it as an aggregate, the ABI pass as a pointer.
type P
    as long a, b, c, d, e
end type
function F( byval p as P ) as long
    return p.a + p.e
end function
dim as P q
q.e = 4
print F( q )
