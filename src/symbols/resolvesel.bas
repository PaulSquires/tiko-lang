'' resolvesel.bas -- what 'SELECT CASE AS CONST' refuses that a plain SELECT accepts.
''
'' Included from resolve.bas, inside its namespace.
''
'' AS CONST is not a hint. fbc builds a JUMP TABLE for it, and a table has to be
'' indexed by a number that is known now, so four things it accepts in a plain SELECT
'' become errors here. Measured, one probe each:
''
''     case is > 5            error 9    refused at the 'is' -- in the PARSER
''     case y                 error 11   "Expected constant"
''     case 1 to 0            error 323  start greater than end
''     case 0 to 8192         error 69   "Range too large"
''
'' THE SPAN IS ACROSS THE WHOLE STATEMENT, not per case, and that is the part a
'' per-case test gets wrong. 'case 0 to 100' followed by 'case 11000 to 11100' is 202
'' values and fbc still refuses it, at the SECOND case: what it measures is
'' max - min + 1 over every case seen so far, and the limit is 8192. Bisected:
''
''     case 0 to 8191                     8192 values   accepted
''     case 0 to 8192                     8193          error 69
''     case 1 to 8192                     8192          accepted
''     case 0 / case 8191                 span 8192     accepted
''     case 0 / case 8192                 span 8193     error 69
''     case -4000 to 0 / case 1 to 4191   span 8192     accepted
''     case -4000 to 0 / case 1 to 4192   span 8193     error 69
''
'' -- so it is the SPAN and not the count, and a negative start is no different.
''
'' NOT DONE HERE: fbc's error 24, "Invalid data types", for a non-integral subject
'' ('select case as const' over a string). That needs the subject's TYPE, and this
'' runs while types are still being resolved.
const SELCONST_SPAN_MAX = 8192

'' One case value, folded. Returns false when it does not fold -- the caller reports.
private function SelConstVal_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval here as Tko.ScopeId, _
      byref outv as longint ) as boolean

    dim as Tko.Check.ConstVal v = Tko.Check.ConstOf( _
        *c.ast, id, *c.srcMgr, *c.names, 64, c.syms, here )
    if v.known = false then return false
    outv = v.value
    return true
end function

'' INTEGER DIVISION BY A CONSTANT ZERO -- fbc error 100, at CONSTANT-EVALUATION time.
'' The fold already declines on a zero divisor; it declined SILENTLY, so 'print 1 \\ 0'
'' compiled.
''
'' MEASURED, and every part of the boundary matters:
''     print 1 \\ 0                  error 100
''     print 1 mod 0                error 100
''     const K = 0 : print 1 \\ K    error 100   a NAMED constant counts
''     print 1 / 0                  OK          FLOAT division is not this
''     dim z as integer = 0
''     print 1 \\ z                  OK          a variable is not constant
private sub DivByConstZero_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval here as Tko.ScopeId )

    dim as Tko.BinaryPayload ptr bp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    select case cast( Tko.TokenKind, bp->op )
    case Tko.TK_BACKSLASH, Tko.KW_MOD
    case else
        return
    end select
    if bp->rhs = Tko.NODE_NONE then return
    dim as longint rv = 0
    if SelConstVal_( c, bp->rhs, here, rv ) = false then return
    if rv <> 0 then return
    c.diags->Report( Tko.TKO0671, Tko.PointRange( c.ast->Loc( id ) ) )
end sub

'' Reports on the FIRST case that pushes the span over, which is where fbc reports it.
private sub SelectConstCheck_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval here as Tko.ScopeId )

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp = 0 then return
    if cast( Tko.TokenKind, sp->op ) <> Tko.KW_CONST then return
    if sp->b = Tko.NODE_NONE then return

    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->b )].data )]

    dim as boolean seen = false
    dim as longint lo = 0, hi = 0

    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId cs = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( cs ) <> Tko.N_CASE then continue for
        dim as Tko.StmtPayload ptr csp = StmtOf( c, cs )
        if csp = 0 then continue for

        for j as long = 0 to csp->count - 1
            dim as Tko.NodeId pn = cast( Tko.NodeId, c.ast->children[csp->first + j] )
            if pn = Tko.NODE_NONE then continue for

            dim as longint a = 0, b = 0
            dim as Tko.NodeId loc = pn

            if c.ast->Kind( pn ) = Tko.N_CASE_RANGE then
                dim as Tko.StmtPayload ptr rp = StmtOf( c, pn )
                if rp = 0 then continue for
                '' 'case is <rel>' already drew TKO0419 in the parser; folding it
                '' here would draw a second error for one mistake.
                if cast( Tko.TokenKind, rp->op ) <> 0 then continue for
                if SelConstVal_( c, rp->a, here, a ) = false then
                    c.diags->Report( Tko.TKO0614, Tko.PointRange( c.ast->Loc( rp->a ) ) )
                    continue for
                end if
                if SelConstVal_( c, rp->b, here, b ) = false then
                    c.diags->Report( Tko.TKO0614, Tko.PointRange( c.ast->Loc( rp->b ) ) )
                    continue for
                end if
                if a > b then
                    c.diags->Report( Tko.TKO0615, Tko.PointRange( c.ast->Loc( pn ) ) )
                    continue for
                end if
            else
                if SelConstVal_( c, pn, here, a ) = false then
                    c.diags->Report( Tko.TKO0614, Tko.PointRange( c.ast->Loc( pn ) ) )
                    continue for
                end if
                b = a
            end if

            if seen = false then
                seen = true
                lo = a
                hi = b
            else
                if a < lo then lo = a
                if b > hi then hi = b
            end if

            if (hi - lo + 1) > SELCONST_SPAN_MAX then
                c.diags->Report( Tko.TKO0616, Tko.PointRange( c.ast->Loc( loc ) ), _
                                 str( SELCONST_SPAN_MAX ) )
                return
            end if
        next
    next
end sub
