'' 'operator []' -- THE OVERLOADED SUBSCRIPT.
''
'' Every container in the runtime headers has one, and 'a[ i ]' over such a type is a
'' CALL rather than an address computation. Three things were wrong, in three places:
''
''   - THE NAME IS TWO TOKENS AND ONE NAME. The parser took only the '[', leaving the
''     ']' where the parameter list was expected -- so the LIST WAS LOST TOO and the
''     operator reached lowering with nothing but a receiver.
''   - THE MANGLED CODE IS 'ix', like every other Itanium operator, not the
''     vendor-extended fallback.
''   - THE SUBSCRIPT NEEDED LOWERING IN TWO PLACES. LowerAddr emits the call; the
''     EXPRESSION path has to know the result TYPE, which is what the operator returns,
''     or the load carries MT_VOID and is refused with the call sitting right there.
''
'' The operator returns BYREF, so what comes back is a pointer to the element and the
'' caller loads through it exactly as it would through any other address.

namespace M

type T
    v as long
    declare operator [] ( byval i as long ) byref as long
end type

operator T.[] ( byval i as long ) byref as long
    return this.v
end operator

end namespace

sub P( byref t as M.T )
    dim as long n = t[ 0 ]
end sub
