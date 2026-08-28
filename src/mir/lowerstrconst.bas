'' lowerstrconst.bas -- the TEXT of a STRING CONSTANT.
''
'' Split out of lowerstr.bas at the 1500-line cap. Nothing about it changed in the move.

#include once "mir/lowerctx.bi"
#include once "support/fbstr.bi"

namespace Tko.Mir

using Tko

'' THE TEXT OF A STRING CONSTANT, folded here because the constant evaluator cannot
'' carry one: ConstVal.value is a longint, so 'const F = "f.txt"' has no value it can
'' return and every use of F declined -- the assignment, the PRINT, and the filename of
'' every OPEN in the corpus's file tests, which is how they all name their file.
''
'' Literals, the concatenation of literals, and the two intrinsics fbc itself folds into
'' a constant -- 'str' and 'chr'. Everything else is rejected here because fbc rejects it
'' as a constant initialiser: see the measurement beside the N_CALL case.
'' THE SCOPE A NAMED CONSTANT ARGUMENT IS LOOKED UP IN travels with the recursion.
'' Resolve records no scope against a constant INITIALISER's nodes -- ScopeOf comes
'' back 0 for every one of them -- so folding 'const cs as string = str( b )' asked
'' for 'b' in scope 0 and found nothing. The constant's OWN parent scope is what to
'' ask, and the ident case below hands it down; SCOPE_GLOBAL is the default because
'' a caller reaching a bare call rather than a name is at module level.
function ConstStringTextOf_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outText as string, _
      byval depth as long = 0, _
      byval scope_ as Tko.ScopeId = Tko.SCOPE_GLOBAL ) as boolean

    if id = Tko.NODE_NONE then return false
    if depth > 16 then return false

    select case c.ast->Kind( id )
    case Tko.N_STRING_LIT
        outText = StringLitText_( c, id )
        return true

    case Tko.N_STRCAT
        '' ADJACENT LITERALS ARE ONE STRING. '"a" "1"' is a single literal in
        '' FreeBASIC, folded before it reaches any call -- measured, fbc emits
        '' 'fb_StrAssign( B$0, 5ll, "a1", 3ll, 0 )'. Only the CONCATENATION path knew
        '' that, so a fixed-length initialiser, an assignment and a PRINT all declined
        '' while 'dim as string c = "a" "1"' beside them worked.
        return StrCatText_( c, id, outText )

    case Tko.N_PAREN
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if lp->count <> 1 then return false
        return ConstStringTextOf_( c, cast( Tko.NodeId, c.ast->children[lp->first] ), _
                                   outText, depth + 1, scope_ )

    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.TokenKind op = cast( Tko.TokenKind, bp->op )
        if (op <> Tko.TK_AMP) andalso (op <> Tko.TK_PLUS) then return false
        dim as string lt, rt
        if ConstStringTextOf_( c, bp->lhs, lt, depth + 1, scope_ ) = false then return false
        if ConstStringTextOf_( c, bp->rhs, rt, depth + 1, scope_ ) = false then return false
        outText = lt + rt
        return true

    case Tko.N_CALL
        '' 'const S = wstr( "ab" )' -- A WIDE STRING CONSTANT. Its initialiser is a
        '' CALL, and the text is the call's own argument: the conversion changes the
        '' width, not the characters, and a wide literal is what the width is for.
        '' Without this a wide constant had no text at all, so 'w = S' and
        '' 'asc( S, 1 )' both declined.
        dim as Tko.ListPayload ptr wp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' NO ARITY GUARD HERE. Each name below checks its own, and a blanket 'exactly
        '' one argument' at the top silently excluded every two-argument form -- which
        '' is the only form of lcase and ucase that fbc folds at all.
        if wp->count < 1 then return false
        if wp->target = Tko.NODE_NONE then return false
        if c.ast->Kind( wp->target ) <> Tko.N_IDENT then return false
        dim as Tko.IdentPayload ptr wip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, wp->target )].data )]
        dim as string wnm = Tko.Text.LowerAscii( c.names->Spelling( wip->name ) )

        '' 'const S = str( 16 )' AND 'const C = chr( 65 )' -- THE TWO STRING INTRINSICS
        '' FBC FOLDS, and only those two. Measured, by asking fbc to accept each as a
        '' constant initialiser:
        ''
        ''     const a = str( 16 )        "16"      accepted
        ''     const b = str( -3 )        "-3"
        ''     const g = str( 1.5 )       "1.5"
        ''     const k = str( 1e-7 )      "1e-07"
        ''     const e = chr( 65 )        "A"
        ''     const j = chr( 65, 66 )    "AB"      -- chr is VARIADIC
        ''     const f = hex( 255 )                 fbc error 11, expected constant
        ''     const c = lcase( "AbC" )             fbc error 11
        ''     const h = trim( "  x  " )            fbc error 11
        ''
        '' So hex, oct, bin, lcase, ucase, left, right, mid and trim are NOT folded here:
        '' fbc rejects every one of them outright, and folding them would accept a
        '' program fbc refuses.
        '' VARIADIC, as fbc's is: measured, 'const a = chr( 65, 66 )' is
        '' 'fb_StrInit( &S, -1, "AB", 3, 0 )'. The loop below always handled it; only
        '' an arity guard above it said otherwise.
        ''
        '' 'wchr' FOLDS THE SAME WAY, and fbc folds it too --
        '' 'const b = wchr( 65, 66 )' is
        '' 'fb_UStrInit( &U, -1, (uint16[]){0x0041,0x0042,0x0000}, ... )'. The codes
        '' go into the SAME BYTE TEXT every other constant here uses, and the wide
        '' consumer widens it one unit per byte, which is exactly fbc's answer for
        '' a code that fits in a byte: 'wchr( &hE9 )' is 0x00E9 either way.
        ''
        '' A CODE ABOVE 255 DECLINES rather than folding. fbc accepts it --
        '' 'wchr( &h4E2D )' is 0x4E2D -- but this carrier is a byte string and has
        '' nowhere to put it, so folding it would truncate a character silently.
        '' The decline is the same one there was before.
        if (wnm = "chr") orelse (wnm = "wchr") then
            dim as string ct
            for i as long = 0 to wp->count - 1
                dim as Tko.NodeId cArg = cast( Tko.NodeId, c.ast->children[wp->first + i] )
                dim as Tko.Check.ConstVal cv = Tko.Check.ConstOf( _
                    *c.ast, cArg, *c.srcMgr, *c.names, c.types->target.pointerBits, _
                    c.syms, scope_ )
                if cv.known = false then return false
                if (cv.value < 0) orelse (cv.value > 255) then return false
                ct += chr( cast( long, cv.value ) )
            next
            outText = ct
            return true
        end if

        '' 'lcase( s, 1 )' AND 'ucase( s, 1 )' -- AND ONLY WITH THE MODE ARGUMENT, and
        '' only when it is 1. Measured, by asking fbc to accept each as a constant:
        ''
        ''     const a = lcase( "XYZ123", 1 )   "xyz123"   accepted
        ''     const b = ucase( "abc", 1 )      "ABC"
        ''     const c = lcase( "XYZ" )                    fbc error 11
        ''     const d = lcase( "XYZ", 0 )                  fbc error 11
        ''
        '' Mode 1 is the locale-independent one, which is the only one whose answer is
        '' knowable at compile time -- so folding the others would be folding something
        '' fbc deliberately does not.
        if (wnm = "lcase") orelse (wnm = "ucase") then
            if wp->count <> 2 then return false
            dim as Tko.NodeId mArg = cast( Tko.NodeId, c.ast->children[wp->first + 1] )
            dim as Tko.Check.ConstVal mv = Tko.Check.ConstOf( _
                *c.ast, mArg, *c.srcMgr, *c.names, c.types->target.pointerBits, _
                c.syms, scope_ )
            if mv.known = false then return false
            if mv.value <> 1 then return false
            dim as string ct2
            if ConstStringTextOf_( c, cast( Tko.NodeId, c.ast->children[wp->first] ), _
                                   ct2, depth + 1, scope_ ) = false then return false
            if wnm = "lcase" then
                outText = Tko.Text.LowerAscii( ct2 )
            else
                outText = Tko.Text.UpperAscii( ct2 )
            end if
            return true
        end if

        if wnm = "str" then
            if wp->count <> 1 then return false
            dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[wp->first] )
            '' A FLOAT ARGUMENT RENDERS THROUGH StrOfDouble, which is the same
            '' sixteen-significant-digit expansion fbc's own STR( ) produces and the one
            '' check-str gates. Reading it as an integer instead would answer 1 for 1.5.
            dim as Tko.TypeId at0 = c.types->Unqualify( c.info->TypeOf_( a0 ) )
            dim as boolean isFlt = false
            if c.types->Kind( at0 ) = Tko.TK_BUILTIN then
                select case c.types->BuiltinOf( at0 )
                case Tko.TY_SINGLE, Tko.TY_DOUBLE : isFlt = true
                end select
            end if
            if isFlt then
                dim as double fd = 0
                if Tko.Check.ConstFloatOf( *c.ast, a0, fd, 0, c.syms, scope_ ) = false then
                    return false
                end if
                outText = Tko.Text.StrOfDouble( fd )
                return true
            end if
            '' WITH THE ARGUMENT'S OWN SCOPE. Passing none left scope 0, so a NAMED
            '' constant argument was never found: 'const cs as string = str( b )'
            '' folded to nothing, and it is every USE of cs that then declined --
            '' numbers/const_op.bas writes it 8 times and the lines that gave up
            '' never mention str. 'str( 5 )' folded, which is why this looked fine.
            dim as Tko.Check.ConstVal iv = Tko.Check.ConstOf( _
                *c.ast, a0, *c.srcMgr, *c.names, c.types->target.pointerBits, _
                c.syms, scope_ )
            if iv.known = false then return false
            '' FreeBASIC's STR( ) writes no leading blank for a positive number --
            '' measured, '"16"' with length 3 including the terminator. That is not QB's
            '' STR$.
            outText = trim( str( iv.value ) )
            return true
        end if

        '' 'const S = wstr( "ab" )' -- A WIDE STRING CONSTANT. The text is the call's own
        '' argument: the conversion changes the WIDTH, not the characters.
        if wnm <> "wstr" then return false
        if wp->count <> 1 then return false
        return ConstStringTextOf_( c, cast( Tko.NodeId, c.ast->children[wp->first] ), _
                                   outText, depth + 1, scope_ )

    case Tko.N_IDENT, Tko.N_MEMBER
        '' A DOTTED PATH TO A CONSTANT IS STILL A CONSTANT -- 'T.zs' over a 'const zs =
        '' "hello"' declared inside a type, and 'ns.s' over one in a namespace. Only the
        '' bare name was folded, so 'len( T.zs )' had no text to measure and every use
        '' of a member constant declined. Resolve has already bound the member to its
        '' symbol, so the two spellings read exactly the same way from here.
        '' The constant's payload is its N_VAR_ITEM, whose 'b' is the initialiser --
        '' the same shape the integer folder reads, and read as the same pool.
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( c.info->RefOf( id ) )
        if cs = 0 then return false
        if cs->kind <> cast( ubyte, Tko.SYM_CONSTANT ) then return false
        if (cs->flags and Tko.SYMF_BUILTIN) <> 0 then return false
        if cs->payload = 0 then return false
        dim as Tko.NodeId item = cast( Tko.NodeId, cs->payload )
        if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then return false
        return ConstStringTextOf_( c, StmtOf( c, item )->b, outText, depth + 1, cs->parent )
    end select
    return false
end function

end namespace
