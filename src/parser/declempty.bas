'' declempty.bas -- AN EMPTY TYPE, UNION OR ENUM. Included by decl.bas, INSIDE namespace
'' Tko.Parse, just above ParseAggregateBody.
''
'' Measured on fbc-modern 1.20, 2026-09-28: error 256, "An ENUM, TYPE or UNION cannot be empty",
'' on the 'end' line of a TYPE or UNION with no data field --
''
''     type T : end type                   a TYPE with only methods, a constructor, an operator,
''     a 'static as long s', a 'const' or fields an '#if 0' removed
''     union : end union                   inside a TYPE, and then the TYPE around it as well
''
'' -- and of an ENUM with no member. 'extends' is a field (ParseAggregateBody adds 'base'), so
'' 'type T extends object' with only methods is fbc's, and so is a 'redim a( any ) as long'
'' member, which is a field parsed as an N_VAR. tiko accepted every empty one.
''
'' ONLY AT ITS OWN 'end'. A named 'type' nested in a UNION is fbc's 17 and 19, and the UNION's
'' 'end union' closed it here -- a TYPE with nothing in it, but not an empty one.
private function EndsHere_ ( byref p as Tko.ParserState, byval what as Tko.TokenKind ) as boolean
    if Peek( p ) <> Tko.KW_END then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    return (cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = what)
end function

'' Does this member list hold a field, directly or through an anonymous union or type.
private function AggHasField_ ( byref p as Tko.ParserState, byval first as long, byval count as long ) as boolean
    for i as long = first to first + count - 1
        dim as Tko.NodeId m = cast( Tko.NodeId, p.ast->children[i] )
        if m = Tko.NODE_NONE then continue for
        select case p.ast->nodes[cast( long, m )].kind
        case Tko.N_FIELD
            return true
        case Tko.N_VAR
            if p.ast->stmts[cast( long, p.ast->nodes[cast( long, m )].data )].op = cast( ushort, Tko.KW_REDIM ) then return true
        case Tko.N_TYPE
            dim as Tko.StmtPayload ptr mp = @p.ast->stmts[cast( long, p.ast->nodes[cast( long, m )].data )]
            if AggHasField_( p, mp->first, mp->count ) then return true
        end select
    next
    return false
end function

'' Asked with the member list pushed and the 'end' as the current token.
private sub EmptyAggCheck_ ( byref p as Tko.ParserState, byref sp as Tko.StmtPayload, byval isUnion as boolean )
    if EndsHere_( p, iif( isUnion, Tko.KW_UNION, Tko.KW_TYPE ) ) = false then return
    if AggHasField_( p, sp.first, sp.count ) then return
    p.diags->Report( Tko.TKO0876, Tko.PointRange( Cur( p ).loc ), iif( isUnion, "UNION", "TYPE" ) )
end sub
