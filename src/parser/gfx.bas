'' gfx.bas -- the graphics statements' own coordinate grammar.
''
'' '(x,y)-(x,y)' is not an expression. It was parsed as one -- a BINARY MINUS of two
'' tuples -- and 'step(1,2)' as a CALL to a procedure named 'step', which is faithful to
'' nothing: the tree said subtract where the source said "from here to there", and no
'' lowering could recover the difference between a relative point and a negated one.
''
'' The shape, common to LINE, PSET, PRESET, CIRCLE, PAINT, VIEW, WINDOW, DRAW, GET and
'' the graphics PUT:
''
''     STATEMENT [target,] [STEP](x,y)[-[STEP](x,y)] [, option ...]
''
'' A LEADING TARGET IS AMBIGUOUS WITH A FIRST COORDINATE and is decided by lookahead:
'' the target form is an expression followed by a COMMA and then a '(' or STEP, which no
'' coordinate can be.
''
'' What each statement stores is a FIXED CHILD ORDER with N_ELIDED for an absent slot,
'' so lowering reads positions rather than re-deriving a shape. The STEP bits, the
'' B/BF selector and SCREEN live in 'extra'. See docs/language/graphics-abi.md for the
'' measured call each becomes.

namespace Fbx.Parse

'' Forward declarations: the statement parser calls the option and finish helpers,
'' which are defined below it because they are the detail rather than the shape.
declare sub GfxTrailing _
    ( byref p as Fbx.ParserState, byval k as Fbx.TokenKind, _
      byref sp as Fbx.StmtPayload, byref items as Fbx.NodeIdVec )
declare sub GfxFinish _
    ( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload, _
      byref items as Fbx.NodeIdVec )
declare function GfxBoxWord( byref p as Fbx.ParserState ) as ushort
declare function GfxWordIs( byref p as Fbx.ParserState, byref want as string ) as boolean

'' 'extra' on a graphics N_INTRINSIC.
''
'' The two STEP bits follow fbc's own two-point convention -- bit 0 is the SECOND point
'' and bit 1 the FIRST -- so lowering passes them straight through for LINE, GET and PUT
'' rather than translating. The one-point statements use bit 0 for their single STEP,
'' which is the same bit fbc uses there too.
'' BITS 0 AND 1 ARE LINE'S OWN, and are not free here: LINE is two unrelated statements
'' sharing a keyword, and bit 0 already means LINE INPUT while bit 1 means the graphics
'' form. Reusing either would have made 'line input' and 'line (0,0)-step(1,1)' the same
'' statement to the dispatcher.
const GFX_STEP2     as ushort = &h0004
const GFX_STEP1     as ushort = &h0008
const GFX_BOX       as ushort = &h0010   '' LINE ... , B
const GFX_BOXFILL   as ushort = &h0020   '' LINE ... , BF
const GFX_FILL      as ushort = &h0040   '' CIRCLE ... , F
const GFX_SCREEN    as ushort = &h0080   '' VIEW SCREEN / WINDOW SCREEN
const GFX_NOSTART   as ushort = &h0100   '' 'line -(x,y)': the start point was omitted
const GFX_HASTARGET as ushort = &h0200

'' One '(x, y)', with an optional STEP in front of it. Returns false when there is no
'' coordinate here at all.
private function GfxPoint _
    ( byref p as Fbx.ParserState, byref items as Fbx.NodeIdVec, _
      byref stepped as boolean ) as boolean

    stepped = false
    if Peek( p ) = Fbx.KW_STEP then
        Advance( p )
        stepped = true
    end if
    if Accept( p, Fbx.TK_LPAREN ) = false then return false
    items.Push( cast( ulong, Expression( p ) ) )
    Expect( p, Fbx.TK_COMMA, "," )
    items.Push( cast( ulong, Expression( p ) ) )
    Expect( p, Fbx.TK_RPAREN, ")" )
    return true
end function

'' Does a coordinate start here? '(' or STEP, and nothing else.
private function AtGfxPoint( byref p as Fbx.ParserState ) as boolean
    return (Peek( p ) = Fbx.TK_LPAREN) orelse (Peek( p ) = Fbx.KW_STEP)
end function

'' A LEADING TARGET, if there is one.
''
'' 'line buffer, (10,10)-(20,20)' and 'line (10,10)-(20,20)' both start with something
'' that could be an expression, so the decision is lookahead: an expression, then a
'' COMMA, then a coordinate. Speculative, and the cursor goes back when it is not one.
private function GfxTarget( byref p as Fbx.ParserState ) as Fbx.NodeId
    if AtGfxPoint( p ) then return Fbx.NODE_NONE
    if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then return Fbx.NODE_NONE
    dim as long save = p.pos
    dim as Fbx.NodeId e = Expression( p )
    if e <> Fbx.NODE_NONE then
        if Accept( p, Fbx.TK_COMMA ) then
            if AtGfxPoint( p ) then return e
        end if
    end if
    p.pos = save
    return Fbx.NODE_NONE
end function

'' An elided slot: a child that stands for an argument nobody wrote.
private function GfxNone( byref p as Fbx.ParserState ) as Fbx.NodeId
    return NewNodeAt( p, Fbx.N_ELIDED, Cur( p ).loc, 0 )
end function

'' The next comma-separated option, or NOTHING when it was elided or the line ended.
'' Returns false once there are no more commas to read.
private function GfxOption _
    ( byref p as Fbx.ParserState, byref outv as Fbx.NodeId ) as boolean

    outv = Fbx.NODE_NONE
    if Accept( p, Fbx.TK_COMMA ) = false then return false
    '' Hoisted: mixing a comparison with a boolean in one 'orelse' chain is fbc
    '' warning 38.
    dim as boolean done_ = (Peek( p ) = Fbx.TK_COMMA) orelse (Peek( p ) = Fbx.TK_EOL)
    if done_ = false then done_ = AtEnd( p )
    if done_ then return true
    outv = Expression( p )
    return true
end function

'' Fill 'items' up to 'want' entries with elided slots.
private sub GfxPad _
    ( byref p as Fbx.ParserState, byref items as Fbx.NodeIdVec, byval want as long )
    while items.Count < want
        items.Push( cast( ulong, GfxNone( p ) ) )
    wend
end sub

'' The whole of a coordinate-syntax graphics statement. 'k' is the keyword, and it
'' decides how many points there are and what the trailing options mean.
function ParseGfxStmt _
    ( byref p as Fbx.ParserState, byref t as Fbx.Token, _
      byval k as Fbx.TokenKind, byref sp as Fbx.StmtPayload ) as boolean

    dim as Fbx.NodeIdVec items

    '' VIEW and WINDOW take an optional SCREEN before anything else.
    if (k = Fbx.KW_VIEW) orelse (k = Fbx.KW_WINDOW) then
        if Peek( p ) = Fbx.KW_SCREEN then
            Advance( p )
            sp.extra or= GFX_SCREEN
        end if
    end if

    sp.a = GfxTarget( p )
    if sp.a <> Fbx.NODE_NONE then sp.extra or= GFX_HASTARGET

    '' DRAW is the odd one: a target and then a STRING, no coordinates at all.
    if k = Fbx.KW_DRAW then
        if (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false) then
            items.Push( cast( ulong, Expression( p ) ) )
        end if
        GfxPad( p, items, 1 )
        GfxFinish( p, sp, items )
        return true
    end if

    dim as boolean twoPoints = (k = Fbx.KW_LINE) orelse (k = Fbx.KW_VIEW) orelse _
                               (k = Fbx.KW_WINDOW)
    dim as boolean s1 = false, s2 = false

    '' 'line -(20,20)' -- the start point omitted entirely. Measured: fbc emits x1 = y1
    '' = 0.0f WITH the first-point-relative bit set, so it means "from where we are".
    if twoPoints andalso (Peek( p ) = Fbx.TK_MINUS) then
        sp.extra or= GFX_NOSTART
        items.Push( cast( ulong, GfxNone( p ) ) )
        items.Push( cast( ulong, GfxNone( p ) ) )
    else
        if GfxPoint( p, items, s1 ) = false then
            '' No coordinates at all: 'view' and 'window' on their own are legal and
            '' mean "reset", and every slot is elided.
            GfxPad( p, items, iif( twoPoints, 4, 2 ) )
            GfxTrailing( p, k, sp, items )
            GfxFinish( p, sp, items )
            return true
        end if
        if s1 then sp.extra or= GFX_STEP1
    end if

    if twoPoints then
        if Accept( p, Fbx.TK_MINUS ) then
            if GfxPoint( p, items, s2 ) then
                if s2 then sp.extra or= GFX_STEP2
            else
                GfxPad( p, items, 4 )
            end if
        else
            GfxPad( p, items, 4 )
        end if
    end if

    GfxTrailing( p, k, sp, items )
    GfxFinish( p, sp, items )
    return true
end function

'' The comma-separated options after the coordinates. Each statement has its own list,
'' and every one of them is positional with an elided slot where nothing was written.
sub GfxTrailing _
    ( byref p as Fbx.ParserState, byval k as Fbx.TokenKind, _
      byref sp as Fbx.StmtPayload, byref items as Fbx.NodeIdVec )

    dim as Fbx.NodeId o = Fbx.NODE_NONE

    select case k
    case Fbx.KW_LINE
        '' colour, then B or BF, then the line style.
        if GfxOption( p, o ) then
            items.Push( cast( ulong, iif( o = Fbx.NODE_NONE, GfxNone( p ), o ) ) )
        end if
        GfxPad( p, items, 5 )
        '' 'B' and 'BF' arrive as IDENTIFIERS -- neither is a keyword -- so the option
        '' is read as an expression and recognised by its spelling.
        if Accept( p, Fbx.TK_COMMA ) then
            dim as ushort box = GfxBoxWord( p )
            sp.extra or= box
        end if
        if GfxOption( p, o ) then
            items.Push( cast( ulong, iif( o = Fbx.NODE_NONE, GfxNone( p ), o ) ) )
        end if
        GfxPad( p, items, 6 )

    case Fbx.KW_PSET, Fbx.KW_PRESET
        if GfxOption( p, o ) then
            items.Push( cast( ulong, iif( o = Fbx.NODE_NONE, GfxNone( p ), o ) ) )
        end if
        GfxPad( p, items, 3 )

    case Fbx.KW_CIRCLE
        '' radius, colour, start, end, aspect, then F.
        for i as long = 0 to 4
            if GfxOption( p, o ) = false then exit for
            items.Push( cast( ulong, iif( o = Fbx.NODE_NONE, GfxNone( p ), o ) ) )
        next
        GfxPad( p, items, 7 )
        if Accept( p, Fbx.TK_COMMA ) then
            if GfxWordIs( p, "f" ) then sp.extra or= GFX_FILL
        end if

    case Fbx.KW_PAINT
        '' fill colour or pattern, then the border colour.
        for i as long = 0 to 1
            if GfxOption( p, o ) = false then exit for
            items.Push( cast( ulong, iif( o = Fbx.NODE_NONE, GfxNone( p ), o ) ) )
        next
        GfxPad( p, items, 4 )

    case Fbx.KW_VIEW
        '' fill colour, then the border colour.
        for i as long = 0 to 1
            if GfxOption( p, o ) = false then exit for
            items.Push( cast( ulong, iif( o = Fbx.NODE_NONE, GfxNone( p ), o ) ) )
        next
        GfxPad( p, items, 6 )

    case else
        '' WINDOW has no options at all.
    end select
end sub

'' 'B' or 'BF' after a LINE's colour. Neither is a keyword, so this reads the identifier
'' and compares its spelling; anything else is left where it is.
function GfxBoxWord( byref p as Fbx.ParserState ) as ushort
    if Peek( p ) <> Fbx.TK_IDENT then return 0
    dim as string w = Fbx.Text.LowerAscii( _
        p.names->Spelling( cast( Fbx.InternId, Cur( p ).literal ) ) )
    if w = "b" then
        Advance( p )
        return GFX_BOX
    end if
    if w = "bf" then
        Advance( p )
        return GFX_BOXFILL
    end if
    return 0
end function

'' The identifier at the cursor, compared case-insensitively and consumed on a match.
function GfxWordIs( byref p as Fbx.ParserState, byref want as string ) as boolean
    if Peek( p ) <> Fbx.TK_IDENT then return false
    dim as string w = Fbx.Text.LowerAscii( _
        p.names->Spelling( cast( Fbx.InternId, Cur( p ).literal ) ) )
    if w <> want then return false
    Advance( p )
    return true
end function

'' Move the collected children into the shared pool.
sub GfxFinish _
    ( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload, _
      byref items as Fbx.NodeIdVec )

    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

end namespace
