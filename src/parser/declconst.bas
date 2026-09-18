'' declconst.bas -- a const's VALUE, for the preprocessor to read in an '#if'.
''
'' Split out of decl.bas at the 1500-line cap and INCLUDED by it, inside the same
'' namespace, exactly as declparam.bas and decltype.bas are. Nothing moved changed
'' in the move.

'' A CONST'S VALUE, WHEN IT FOLDS AT PARSE TIME -- what the preprocessor needs to read
'' it in an '#if'. See PpEngine.constMark: FreeBASIC's '#if' takes a const like any
'' other term, and win/_mingw.bi declares '_WIN32_WINNT' as one.
''
'' A LITERAL, A NEGATED LITERAL, OR ANOTHER CONST ALREADY RECORDED, and nothing else.
'' This runs in the PARSER, where there is no symbol table and no folder -- anything
'' richer would be guessing, and a name with no value keeps the old answer of 0 rather
'' than a wrong one. The chained form is what the headers actually write:
'' 'const WINVER = _WIN32_WINNT' on the line after '_WIN32_WINNT' itself.
private function ConstFoldsToInt_ _
    ( byref p as Tko.ParserState, byval e as Tko.NodeId, _
      byref outv as longint ) as boolean

    if e = Tko.NODE_NONE then return false
    select case p.ast->Kind( e )
    case Tko.N_INT_LIT
        dim as Tko.LiteralPayload ptr lp = _
            @p.ast->literals[cast( long, p.ast->nodes[cast( long, e )].data )]
        outv = cast( longint, lp->intValue )
        return true
    case Tko.N_UNARY
        dim as Tko.UnaryPayload ptr up = _
            @p.ast->unaries[cast( long, p.ast->nodes[cast( long, e )].data )]
        if cast( Tko.TokenKind, up->op ) <> Tko.TK_MINUS then return false
        dim as longint inner = 0
        if ConstFoldsToInt_( p, up->operand, inner ) = false then return false
        outv = -inner
        return true
    case Tko.N_IDENT
        if p.stream = 0 then return false
        dim as Tko.InternId inm = _
            p.ast->idents[cast( long, p.ast->nodes[cast( long, e )].data )].name
        return Tko.PpNotedConst( *cast( Tko.PpStream ptr, p.stream ), inm, outv )
    end select
    return false
end function
