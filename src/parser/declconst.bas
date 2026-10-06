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
            if (rv = -1) andalso (lv = &h8000000000000000ll) then outv = 0 : return true   '' fbc folds MIN \ -1 to 0; dividing traps
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

'' 'iif( CONST, a, b )' IS THE CHOSEN ARM -- fbc folds it before anything is typed: measured,
'' 'iif( 1, "a", 2 )' prints a and 'iif( 0, "a", 2 )' prints 2, and '#print typeof( iif( 1,
'' 1, 2.5 ) )' is INTEGER where a run-time condition makes it DOUBLE. tiko refused the first
'' two (TKO0655) and typed the third DOUBLE (audit F-70). The arm not chosen is not
'' evaluated, which is what the fold means. Only what ConstFoldsToInt_ can read counts.
function FoldConstIif_( byref p as Tko.ParserState, byval n as Tko.NodeId ) as Tko.NodeId
    if p.ast->Kind( n ) <> Tko.N_CALL then return n
    dim as Tko.ListPayload ptr lp = @p.ast->lists[cast( long, p.ast->nodes[cast( long, n )].data )]
    if (lp->count <> 3) orelse (lp->target = Tko.NODE_NONE) then return n
    if p.ast->Kind( lp->target ) <> Tko.N_IDENT then return n
    dim as Tko.InternId nm = p.ast->idents[cast( long, p.ast->nodes[cast( long, lp->target )].data )].name
    if lcase( p.names->Spelling( nm ) ) <> "iif" then return n
    dim as longint v = 0
    if ConstFoldsToInt_( p, cast( Tko.NodeId, p.ast->children[lp->first] ), v ) = false then return n
    return cast( Tko.NodeId, p.ast->children[lp->first + iif( v <> 0, 1, 2 )] )
end function

'' A CONST WHOSE VALUE IS A STRING LITERAL, told to the preprocessor as its text --
'' '#if "abc" = S1' over 'const S1 = "abc"' is true to fbc (pp/if.bas), local or not.
private sub NoteConstStr_( byref p as Tko.ParserState, byval nm as Tko.InternId, byval v as Tko.NodeId )
    if (v = Tko.NODE_NONE) orelse (p.stream = 0) then return
    if p.ast->Kind( v ) <> Tko.N_STRING_LIT then return
    dim as Tko.LiteralPayload ptr lp = @p.ast->literals[cast( long, p.ast->nodes[cast( long, v )].data )]
    dim as Tko.SourceFile ptr f = p.src->FileAt( cast( Tko.FileId, lp->strFile ) )
    if f = 0 then return
    if (lp->strOffset < 0) orelse (lp->strOffset + lp->strLength > f->text.Count) then return
    dim as string tx = space( lp->strLength )
    for i as long = 0 to lp->strLength - 1
        tx[i] = f->text[lp->strOffset + i]
    next
    Tko.PpNoteConstStr( *cast( Tko.PpStream ptr, p.stream ), nm, tx, cbool( p.procDepth <> 0 ) )
end sub
