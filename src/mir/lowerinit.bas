'' lowerinit.bas -- THE SMALL PREDICATES AND HELPERS THE ASSIGNMENT AND DECLARATION
'' PATHS ASK: a copy constructor by shape, a result field list, and 'any' as an
'' initialiser.
''
'' Split out of lower.bas at the 1500-line cap and included from it in the same place.
'' Nothing in them changed in the move.

'' THE COPY CONSTRUCTOR of a UDT: the one-argument constructor whose parameter is that
'' same type. StructorWithArity answers any one-argument constructor at all, which is
'' not the same question -- a type whose only constructor takes a long had that one
'' chosen to copy it with.
private function CopyCtorOf_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    dim as Tko.SymbolId s = StructorWithArity( c, StructorOf( c, t, "__ctor" ), 1 )
    if s = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId pt = ParamTypeAt( c, s, 0 )
    if pt = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    if c.types->Kind( pt ) = Tko.TK_REFERENCE then pt = c.types->Inner( pt )
    if c.types->Unqualify( pt ) <> c.types->Unqualify( t ) then return Tko.SYMBOL_NONE
    return s
end function

'' A FIELD LIST ASSIGNED TO THE RESULT -- 'function = ( 1, 2 )' and 'function =
'' type( 1, 2 )'. The result slot IS the object, so this is the declaration
'' initialiser with the result's type standing in for the declared one.
private function ResultFieldListInit_ _
    ( byref c as Ctx, byval e as Tko.NodeId ) as boolean

    if c.resultSlot < 0 then return false
    if c.resultType = Tko.TYPE_NONE then return false
    if e = Tko.NODE_NONE then return false
    '' ONLY THE 'type( ... )' SPELLING. Measured: fbc accepts 'function = type( 5, 6 )'
    '' and rejects 'function = ( 5, 6 )' with error 7, expecting ')' where the comma
    '' is. The two build the same node, so the parser marks which was written.
    if c.ast->Kind( e ) <> Tko.N_TUPLE then return false
    '' ...UNLESS THE RESULT IS A TUPLE, where the bare spelling is the ONLY one:
    '' 'function = ( a \ b, a mod b )' out of a '(quotient as T, remainder as T)' is
    '' what fb/mathint.bi's DivMod is, and fbc-modern accepts it. It is still error 7
    '' over a plain UDT, which is what the rule above was measured on.
    if (c.ast->nodes[cast( long, e )].flags and Tko.NF_TYPE_LITERAL) = 0 then
        if IsTupleType_( c, c.resultType ) = false then return false
    end if
    return LowerUdtParenInit_( c, c.resultSlot, c.resultType, e )
end function

'' 'dim x as T = ANY' -- the explicit request for an UNINITIALISED variable, which
'' emits no store. 'any' is a keyword, so no variable can be spelled that way and
'' matching the name alone is safe.
private function IsAnyInit_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    if id = Tko.NODE_NONE then return false
    if c.ast->Kind( id ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, id )].data )]
    return (Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) = "any")
end function
