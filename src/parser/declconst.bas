'' declconst.bas -- a const's VALUE, for the preprocessor to read in an '#if'.
''
'' Split out of decl.bas at the 1500-line cap and INCLUDED by it, inside the same
'' namespace, exactly as declparam.bas and decltype.bas are. Nothing moved changed
'' in the move.

'' A CONST'S VALUE, WHEN IT FOLDS AT PARSE TIME -- what the preprocessor needs to read
'' it in an '#if'. See PpEngine.constMark: FreeBASIC's '#if' takes a const like any
'' other term, and win/_mingw.bi declares '_WIN32_WINNT' as one.
''
'' A LITERAL, A NEGATED LITERAL, OR ANOTHER CONST ALREADY RECORDED -- and parentheses and
'' '+ - * ' over those, which 'type T field = ( 1 )' and 'field = PK * 2' need.
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
    case Tko.N_PAREN
        dim as Tko.ListPayload ptr pl = _
            @p.ast->lists[cast( long, p.ast->nodes[cast( long, e )].data )]
        if pl->count <> 1 then return false
        return ConstFoldsToInt_( p, cast( Tko.NodeId, p.ast->children[pl->first] ), outv )
    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = _
            @p.ast->binaries[cast( long, p.ast->nodes[cast( long, e )].data )]
        dim as longint lv = 0, rv = 0
        if ConstFoldsToInt_( p, bp->lhs, lv ) = false then return false
        if ConstFoldsToInt_( p, bp->rhs, rv ) = false then return false
        select case cast( Tko.TokenKind, bp->op )
        case Tko.TK_PLUS  : outv = lv + rv
        case Tko.TK_MINUS : outv = lv - rv
        case Tko.TK_STAR  : outv = lv * rv
        case Tko.TK_BACKSLASH
            if rv = 0 then return false
            outv = lv \ rv
        case else : return false
        end select
        return true
    case Tko.N_IDENT
        if p.stream = 0 then return false
        dim as Tko.InternId inm = _
            p.ast->idents[cast( long, p.ast->nodes[cast( long, e )].data )].name
        return Tko.PpNotedConst( *cast( Tko.PpStream ptr, p.stream ), inm, outv )
    end select
    return false
end function
