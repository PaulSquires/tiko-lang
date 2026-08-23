'' 'dim BYREF rb as integer = a' ALIASES a, and its slot holds a POINTER -- the same
'' shape a byref PARAMETER has, which is what made the rest fall out: Resolve types it
'' as a REFERENCE, so the slot lowers to a pointer and AddrOfVar loads it. Every read,
'' every write and every '@' of the alias then goes through the indirection, because
'' all of them ask that one function. Only the DECLARATION had to learn to store an
'' address: fbc writes 'int64* RB$0; RB$0 = &A$0;'.
dim a as integer = 5
dim byref rb as integer = a
rb = 7
dim as integer q = rb
dim as integer ptr pq = @rb

'' A STRING alias assigns THROUGH the pointer, and owns no cleanup: the descriptor
'' belongs to the thing it names.
dim s as string
dim byref rs as string = s
rs = "x"

'' A SHARED or STATIC alias is module storage holding an address. fbc initialises it
'' statically -- 'int64* RG$ = &G$;' -- and a MIR global carries an integer, a float or
'' a byte image, none of which is a relocation, so the address is stored where the
'' declaration is instead.
dim shared as integer g = 2
dim shared byref rg as integer = g

sub P( )
    static byref as integer sb = g
    sb = 3
end sub
