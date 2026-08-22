'' lowergfx.bas -- the graphics statements, lowered.
''
'' The grammar is in parser/gfx.bas and the measured shape of every call in
'' docs/language/graphics-abi.md. What is here is the translation between them, and
'' almost all of it is the DEFAULTS: what fbc passes for an argument nobody wrote.
''
'' The three that would be guessed wrong:
''
''   COORDINATES ARE SINGLES. Every one is a separate 'float' -- never a struct, never
''   an int -- so an integer literal has to be converted before it is passed.
''
''   AN OMITTED COLOUR IS NOT AN ARGUMENT. It is `0` in the colour slot plus BIT 31 of
''   the coordinate flags, so the runtime can tell "black" from "whatever is current".
''
''   THERE ARE TWO FLAG CONVENTIONS. LINE, GET and PUT put the SECOND point's STEP in
''   bit 0; PSET, CIRCLE, PAINT and DRAW STRING put their single STEP there and carry a
''   base of 4 besides. Conflating them puts every relative coordinate on the wrong
''   point.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' fbc's own flag bits, which are NOT the parser's -- see parser/gfx.bas for those.
const GFXF_STEP2   as long = &h00000001
const GFXF_STEP1   as long = &h00000002
const GFXF_BASE1   as long = &h00000004   '' the one-point family's constant base
const GFXF_NOBORDER as long = &h40000000
const GFXF_NOCOLOUR as long = &h80000000

'' The parser's bits, repeated here rather than shared: the parser and the lowering are
'' separate layers and a shared constant would tie the tree's spelling to the runtime's.
const PGFX_STEP2     as ushort = &h0004
const PGFX_STEP1     as ushort = &h0008
const PGFX_BOX       as ushort = &h0010
const PGFX_BOXFILL   as ushort = &h0020
const PGFX_FILL      as ushort = &h0040
const PGFX_SCREEN    as ushort = &h0080
const PGFX_NOSTART   as ushort = &h0100
const PGFX_HASTARGET as ushort = &h0200

'' The n'th child of a graphics statement, or NOTHING when it was elided.
private function GfxArg _
    ( byref c as Ctx, byval sp as Fbx.StmtPayload ptr, byval i as long ) as Fbx.NodeId

    if (i < 0) orelse (i >= sp->count) then return Fbx.NODE_NONE
    dim as Fbx.NodeId n = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
    if n = Fbx.NODE_NONE then return Fbx.NODE_NONE
    if c.ast->Kind( n ) = Fbx.N_ELIDED then return Fbx.NODE_NONE
    return n
end function

'' One coordinate, as the SINGLE fbc passes. An omitted one is 0.0f, which is what fbc
'' writes for 'line -(x,y)' and for a reset 'window'.
private function GfxCoord _
    ( byref c as Ctx, byval sp as Fbx.StmtPayload ptr, byval i as long, _
      byref ok as boolean ) as MirValue

    dim as Fbx.NodeId n = GfxArg( c, sp, i )
    if n = Fbx.NODE_NONE then return ConstFloat( c, 0.0, MT_F32 )
    dim as MirValue v = LowerExpr( c, n )
    if v.kind = cast( ubyte, MV_NONE ) then
        ok = false
        return v
    end if
    return Coerce( c, v, MT_F32, false )
end function

'' One INTEGER option -- a colour, a style, a mode. Returns the default when it was not
'' written, and says so, because an omitted colour also sets a flag bit.
private function GfxInt _
    ( byref c as Ctx, byval sp as Fbx.StmtPayload ptr, byval i as long, _
      byval dflt as longint, byref written as boolean, byref ok as boolean ) as MirValue

    dim as Fbx.NodeId n = GfxArg( c, sp, i )
    written = (n <> Fbx.NODE_NONE)
    if written = false then return ConstInt( c, dflt, MT_I32 )
    dim as MirValue v = LowerExpr( c, n )
    if v.kind = cast( ubyte, MV_NONE ) then
        ok = false
        return v
    end if
    return Coerce( c, v, MT_I32, IsUnsignedType( c, c.info->TypeOf_( n ) ) )
end function

'' The TARGET buffer, or a null pointer. Every graphics statement takes one and fbc
'' passes '(void*)0' when it was not written.
private function GfxTargetVal _
    ( byref c as Ctx, byval sp as Fbx.StmtPayload ptr, byref ok as boolean ) as MirValue

    if sp->a = Fbx.NODE_NONE then return ConstInt( c, 0, MT_PTR )
    dim as MirValue v = LowerExpr( c, sp->a )
    if v.kind = cast( ubyte, MV_NONE ) then
        ok = false
        return v
    end if
    return Coerce( c, v, MT_PTR )
end function

private sub PushV( byref args as FB.Array( of ulong ), byref v as MirValue )
    args.Push( cast( ulong, v.kind ) )
    args.Push( cast( ulong, v.id ) )
end sub

'' The two-point coordinate flags: LINE, GET and PUT.
private function GfxFlags2( byval extra as ushort ) as long
    dim as long f = 0
    if (extra and PGFX_STEP2) <> 0 then f or= GFXF_STEP2
    if (extra and PGFX_STEP1) <> 0 then f or= GFXF_STEP1
    '' 'line -(x,y)' means "from where we are", which fbc spells as the first point
    '' being RELATIVE by (0,0) rather than as a flag of its own.
    if (extra and PGFX_NOSTART) <> 0 then f or= GFXF_STEP1
    return f
end function

'' ...and the one-point flags: PSET, PRESET, CIRCLE, PAINT. The base of 4 is on every
'' one of them and no source form clears it; its meaning was not determined.
private function GfxFlags1( byval extra as ushort ) as long
    dim as long f = GFXF_BASE1
    if (extra and PGFX_STEP1) <> 0 then f or= GFXF_STEP2
    return f
end function

'' LINE (x1,y1)-(x2,y2), colour, B|BF, style
function LowerGfxLine( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true

    dim as MirValue tgt = GfxTargetVal( c, sp, ok )
    dim as MirValue x1 = GfxCoord( c, sp, 0, ok )
    dim as MirValue y1 = GfxCoord( c, sp, 1, ok )
    dim as MirValue x2 = GfxCoord( c, sp, 2, ok )
    dim as MirValue y2 = GfxCoord( c, sp, 3, ok )
    dim as boolean hasCol = false
    dim as MirValue col = GfxInt( c, sp, 4, 0, hasCol, ok )
    '' The style defaults to &hFFFF, a solid line.
    dim as boolean hasSty = false
    dim as MirValue sty = GfxInt( c, sp, 5, 65535, hasSty, ok )
    if ok = false then return false

    '' B and BF are a SEPARATE INTEGER, not a bitmask: 0 plain, 1 B, 2 BF.
    dim as long box = 0
    if (sp->extra and PGFX_BOX) <> 0 then box = 1
    if (sp->extra and PGFX_BOXFILL) <> 0 then box = 2

    dim as long flags = GfxFlags2( sp->extra )
    if hasCol = false then flags or= GFXF_NOCOLOUR

    dim as FB.Array( of ulong ) args
    PushV( args, tgt )
    PushV( args, x1 ) : PushV( args, y1 )
    PushV( args, x2 ) : PushV( args, y2 )
    PushV( args, col )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, box ) )
    PushV( args, sty )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, flags ) )
    EmitRtl( c, RTL_GFX_LINE, args )
    return true
end function

'' PSET / PRESET (x,y), colour -- ONE function, told apart by a trailing -1.
function LowerGfxPset _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval isPreset as boolean ) as boolean

    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true
    dim as MirValue tgt = GfxTargetVal( c, sp, ok )
    dim as MirValue x = GfxCoord( c, sp, 0, ok )
    dim as MirValue y = GfxCoord( c, sp, 1, ok )
    dim as boolean hasCol = false
    dim as MirValue col = GfxInt( c, sp, 2, 0, hasCol, ok )
    if ok = false then return false

    dim as long flags = GfxFlags1( sp->extra )
    if hasCol = false then flags or= GFXF_NOCOLOUR

    dim as FB.Array( of ulong ) args
    PushV( args, tgt )
    PushV( args, x ) : PushV( args, y )
    PushV( args, col )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, flags ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, iif( isPreset, -1, 0 ) ) )
    EmitRtl( c, RTL_GFX_PSET, args )
    return true
end function

'' CIRCLE (x,y), r, colour, start, end, aspect, F
''
'' THE ASPECT COMES BEFORE START AND END IN THE CALL, the reverse of the BASIC syntax
'' order, and an omitted end angle is 2*pi rather than 0.
function LowerGfxCircle( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true
    dim as MirValue tgt = GfxTargetVal( c, sp, ok )
    dim as MirValue x = GfxCoord( c, sp, 0, ok )
    dim as MirValue y = GfxCoord( c, sp, 1, ok )
    dim as MirValue r = GfxCoord( c, sp, 2, ok )
    dim as boolean hasCol = false
    dim as MirValue col = GfxInt( c, sp, 3, 0, hasCol, ok )

    dim as MirValue st = GfxCoord( c, sp, 4, ok )
    dim as Fbx.NodeId en = GfxArg( c, sp, 5 )
    dim as MirValue ev
    if en = Fbx.NODE_NONE then
        ev = ConstFloat( c, 6.2831854820251465, MT_F32 )
    else
        ev = GfxCoord( c, sp, 5, ok )
    end if
    dim as MirValue asp = GfxCoord( c, sp, 6, ok )
    if ok = false then return false

    dim as long flags = GfxFlags1( sp->extra )
    if hasCol = false then flags or= GFXF_NOCOLOUR
    dim as long fill = iif( (sp->extra and PGFX_FILL) <> 0, -1, 0 )

    dim as FB.Array( of ulong ) args
    PushV( args, tgt )
    PushV( args, x ) : PushV( args, y ) : PushV( args, r )
    PushV( args, col )
    PushV( args, asp ) : PushV( args, st ) : PushV( args, ev )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, fill ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, flags ) )
    EmitRtl( c, RTL_GFX_ELLIPSE, args )
    return true
end function

'' PAINT (x,y), fill, border
''
'' The third argument is EITHER a colour or a PATTERN STRING, decided by its type. A
'' pattern forces the colour argument to &hFFFF0000 -- measured, and it discards any
'' colour that was written, which cannot happen because the two share the slot.
''
'' The pattern descriptor is ALWAYS passed, never null: with no pattern fbc allocates an
'' empty temporary for it.
function LowerGfxPaint( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true
    dim as MirValue tgt = GfxTargetVal( c, sp, ok )
    dim as MirValue x = GfxCoord( c, sp, 0, ok )
    dim as MirValue y = GfxCoord( c, sp, 1, ok )

    dim as Fbx.NodeId fillNode = GfxArg( c, sp, 2 )
    dim as boolean isPattern = false
    if fillNode <> Fbx.NODE_NONE then
        if c.ast->Kind( fillNode ) = Fbx.N_STRING_LIT then
            isPattern = true
        elseif IsStringType( c, c.info->TypeOf_( fillNode ) ) then
            isPattern = true
        end if
    end if

    dim as MirValue col
    dim as MirValue pat
    dim as boolean hasCol = false
    if isPattern then
        col = ConstInt( c, &hFFFF0000, MT_I32 )
        if StrDescriptorOf_( c, fillNode, pat ) = false then return false
        hasCol = true
    else
        col = GfxInt( c, sp, 2, 0, hasCol, ok )
        '' The empty temporary descriptor fbc passes when there is no pattern.
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, MV_GLOBAL ) )
        ta.Push( cast( ulong, c.m->AddStringLiteral( "", *c.names ) ) )
        ta.Push( cast( ulong, MV_CONST_INT ) )
        ta.Push( 0 )
        pat = EmitRtl( c, RTL_STR_TEMPZ, ta )
        if pat.kind = cast( ubyte, MV_NONE ) then return false
    end if

    dim as boolean hasBorder = false
    dim as MirValue bord = GfxInt( c, sp, 3, 0, hasBorder, ok )
    if ok = false then return false

    dim as long flags = GfxFlags1( sp->extra )
    if hasCol = false then flags or= GFXF_NOCOLOUR
    if hasBorder = false then flags or= GFXF_NOBORDER

    dim as FB.Array( of ulong ) args
    PushV( args, tgt )
    PushV( args, x ) : PushV( args, y )
    PushV( args, col ) : PushV( args, bord )
    PushV( args, pat )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, iif( isPattern, 1, 0 ) ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, flags ) )
    EmitRtl( c, RTL_GFX_PAINT, args )
    return true
end function

'' VIEW [SCREEN] (x1,y1)-(x2,y2), fill, border
''
'' VIEW'S COORDINATES ARE INTEGERS while WINDOW's are singles, which is measured and is
'' the opposite of what the shared syntax suggests. An omitted one is -32768.
function LowerGfxView( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true
    dim as boolean w = false
    dim as MirValue x1 = GfxInt( c, sp, 0, -32768, w, ok )
    dim as MirValue y1 = GfxInt( c, sp, 1, -32768, w, ok )
    dim as MirValue x2 = GfxInt( c, sp, 2, -32768, w, ok )
    dim as MirValue y2 = GfxInt( c, sp, 3, -32768, w, ok )
    dim as boolean hasCol = false
    dim as MirValue col = GfxInt( c, sp, 4, 0, hasCol, ok )
    dim as boolean hasBorder = false
    dim as MirValue bord = GfxInt( c, sp, 5, 0, hasBorder, ok )
    if ok = false then return false

    dim as long flags = 0
    if (sp->extra and PGFX_SCREEN) <> 0 then flags or= 1
    if hasCol = false then flags or= GFXF_NOCOLOUR
    if hasBorder = false then flags or= GFXF_NOBORDER

    dim as FB.Array( of ulong ) args
    PushV( args, x1 ) : PushV( args, y1 ) : PushV( args, x2 ) : PushV( args, y2 )
    PushV( args, col ) : PushV( args, bord )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, flags ) )
    EmitRtl( c, RTL_GFX_VIEW, args )
    return true
end function

'' WINDOW [SCREEN] (x1,y1)-(x2,y2)
function LowerGfxWindow( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true
    dim as MirValue x1 = GfxCoord( c, sp, 0, ok )
    dim as MirValue y1 = GfxCoord( c, sp, 1, ok )
    dim as MirValue x2 = GfxCoord( c, sp, 2, ok )
    dim as MirValue y2 = GfxCoord( c, sp, 3, ok )
    if ok = false then return false
    dim as long flags = iif( (sp->extra and PGFX_SCREEN) <> 0, 1, 0 )

    dim as FB.Array( of ulong ) args
    PushV( args, x1 ) : PushV( args, y1 ) : PushV( args, x2 ) : PushV( args, y2 )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, flags ) )
    EmitRtl( c, RTL_GFX_WINDOW, args )
    return true
end function

'' DRAW [target,] command-string
function LowerGfxDraw( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true
    dim as MirValue tgt = GfxTargetVal( c, sp, ok )
    if ok = false then return false
    dim as Fbx.NodeId sn = GfxArg( c, sp, 0 )
    if sn = Fbx.NODE_NONE then return false
    dim as MirValue sv
    if StrDescriptorOf_( c, sn, sv ) = false then return false

    dim as FB.Array( of ulong ) args
    PushV( args, tgt )
    PushV( args, sv )
    EmitRtl( c, RTL_GFX_DRAW, args )
    return true
end function

'' The dispatcher: which of them this N_INTRINSIC is.
function LowerGfxStmt( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    select case cast( Fbx.TokenKind, sp->op )
    case Fbx.KW_LINE   : return LowerGfxLine( c, id )
    case Fbx.KW_PSET   : return LowerGfxPset( c, id, false )
    case Fbx.KW_PRESET : return LowerGfxPset( c, id, true )
    case Fbx.KW_CIRCLE : return LowerGfxCircle( c, id )
    case Fbx.KW_PAINT  : return LowerGfxPaint( c, id )
    case Fbx.KW_VIEW   : return LowerGfxView( c, id )
    case Fbx.KW_WINDOW : return LowerGfxWindow( c, id )
    case Fbx.KW_DRAW   : return LowerGfxDraw( c, id )
    end select
    return false
end function

end namespace
