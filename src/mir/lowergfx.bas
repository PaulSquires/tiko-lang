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
const PGFX_PAL_GET   as ushort = &h0400
const PGFX_PAL_USING as ushort = &h0800

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

'' GET [target,] (x1,y1)-(x2,y2), destination
''
'' The eighth argument is an ARRAY DESCRIPTOR when the destination is an array element
'' and NULL when it is a plain pointer. fbx passes null always: it has no way to
'' materialise a descriptor over an arbitrary element expression here, and passing a
'' wrong one would be worse than passing none.
function LowerGfxGet( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true
    dim as MirValue tgt = GfxTargetVal( c, sp, ok )
    dim as MirValue x1 = GfxCoord( c, sp, 0, ok )
    dim as MirValue y1 = GfxCoord( c, sp, 1, ok )
    dim as MirValue x2 = GfxCoord( c, sp, 2, ok )
    dim as MirValue y2 = GfxCoord( c, sp, 3, ok )
    if ok = false then return false

    dim as Fbx.NodeId dn = GfxArg( c, sp, 4 )
    if dn = Fbx.NODE_NONE then return false
    dim as MirValue dst = LowerAddr( c, dn )
    if dst.kind = cast( ubyte, MV_NONE ) then dst = LowerExpr( c, dn )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    dst = Coerce( c, dst, MT_PTR )

    dim as FB.Array( of ulong ) args
    PushV( args, tgt )
    PushV( args, x1 ) : PushV( args, y1 ) : PushV( args, x2 ) : PushV( args, y2 )
    PushV( args, dst )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, GfxFlags2( sp->extra ) ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_GFX_GET, args )
    return true
end function

'' The blender each PUT mode carries. Measured: every mode has one, and ALPHA WITH A
'' VALUE is a different mode from ALPHA without -- 9 rather than 6 -- with a different
'' blender again.
private function PutBlender( byval mode as long ) as RtlId
    select case mode
    case 0 : return RTL_GFX_PUT_TRANS
    case 1 : return RTL_GFX_PUT_PSET
    case 2 : return RTL_GFX_PUT_PRESET
    case 3 : return RTL_GFX_PUT_AND
    case 4 : return RTL_GFX_PUT_OR
    case 5 : return RTL_GFX_PUT_XOR
    case 6 : return RTL_GFX_PUT_ALPHA
    case 8 : return RTL_GFX_PUT_CUSTOM
    case 9 : return RTL_GFX_PUT_BLEND
    end select
    return RTL_GFX_PUT_XOR
end function

'' PUT [target,] (x,y), source [, mode [, alpha]]
''
'' THE DEFAULT MODE IS XOR, not TRANS -- measured, and the opposite of DRAW STRING's.
'' The four source-rectangle integers are -65536 each, a sentinel for "the whole
'' image"; no 1.10.1 syntax was found that sets them.
function LowerGfxPut( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true
    dim as MirValue tgt = GfxTargetVal( c, sp, ok )
    dim as MirValue x = GfxCoord( c, sp, 0, ok )
    dim as MirValue y = GfxCoord( c, sp, 1, ok )
    if ok = false then return false

    dim as Fbx.NodeId sn = GfxArg( c, sp, 2 )
    if sn = Fbx.NODE_NONE then return false
    dim as MirValue src = LowerExpr( c, sn )
    if src.kind = cast( ubyte, MV_NONE ) then src = LowerAddr( c, sn )
    if src.kind = cast( ubyte, MV_NONE ) then return false
    src = Coerce( c, src, MT_PTR )

    dim as long mode = 5
    dim as long mbits = cast( long, (sp->extra shr 12) and &hF )
    if (mbits and 8) <> 0 then mode = (mbits and 7)

    '' ALPHA with a level is mode 9; CUSTOM takes a procedure pointer instead. They
    '' share the slot because no form has both.
    dim as Fbx.NodeId extraN = GfxArg( c, sp, 3 )
    dim as MirValue alpha = ConstInt( c, -1, MT_I32 )
    dim as MirValue custom = ConstInt( c, 0, MT_PTR )
    if extraN <> Fbx.NODE_NONE then
        if mode = 8 then
            dim as MirValue cv = LowerExpr( c, extraN )
            if cv.kind = cast( ubyte, MV_NONE ) then return false
            custom = Coerce( c, cv, MT_PTR )
        else
            dim as MirValue av = LowerExpr( c, extraN )
            if av.kind = cast( ubyte, MV_NONE ) then return false
            alpha = Coerce( c, av, MT_I32 )
            if mode = 6 then mode = 9
        end if
    end if

    dim as MirValue bl = FuncAddrOfRtl( c, PutBlender( mode ) )
    if bl.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) args
    PushV( args, tgt )
    PushV( args, x ) : PushV( args, y )
    PushV( args, src )
    for i as long = 0 to 3
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, -65536 ) )
    next
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, GfxFlags2( sp->extra ) ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, mode ) )
    PushV( args, bl )
    PushV( args, alpha )
    PushV( args, custom )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_GFX_PUT, args )
    return true
end function

'' PALETTE, in its three forms. Their omitted arguments do NOT agree with each other:
'' the plain form pads with -1, and PALETTE GET pads with a NULL POINTER rather than a
'' temporary -- the opposite of what SCREENINFO does.
'' Does this palette output want the 64-BIT entry point? Every PALETTE that writes
'' back has a twin -- fb_GfxPaletteGet64, fb_GfxPaletteUsing64,
'' fb_GfxPaletteGetUsing64 -- chosen by the WIDTH of what it writes into, so an
'' 'integer' array takes the 64 form on win64 and the 32 form on win32. That falls out
'' of asking LowerType rather than the spelling.
''
'' The width is the ELEMENT's, not the argument's: an array and a pointer both stand
'' for the thing they hold.
private function PaletteIs64_( byref c as Ctx, byval e as Fbx.NodeId ) as boolean
    if e = Fbx.NODE_NONE then return false
    dim as Fbx.TypeId t = c.info->TypeOf_( e )
    if t = Fbx.TYPE_NONE then return false
    select case c.types->Kind( t )
    case Fbx.TK_ARRAY, Fbx.TK_POINTER
        t = c.types->Inner( t )
    end select
    if t = Fbx.TYPE_NONE then return false
    return (LowerType( t, *c.types ) = MT_I64)
end function

function LowerGfxPalette( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true

    if (sp->extra and PGFX_PAL_USING) <> 0 then
        dim as Fbx.NodeId an = GfxArg( c, sp, 0 )
        if an = Fbx.NODE_NONE then return false
        '' A POINTER ARGUMENT IS ITS VALUE, everything else its ADDRESS. Measured:
        '' 'palette get using pp' over a 'ulong ptr' is 'fb_GfxPaletteGetUsing(
        '' (int32*)PP )', where the array form passes the array's own address. Taking
        '' the address of the pointer VARIABLE would hand the runtime a pointer to a
        '' pointer, which it would then fill with palette entries.
        dim as MirValue av
        if c.types->Kind( c.info->TypeOf_( an ) ) = Fbx.TK_POINTER then
            av = LowerExpr( c, an )
        else
            av = LowerAddr( c, an )
            if av.kind = cast( ubyte, MV_NONE ) then av = LowerExpr( c, an )
        end if
        if av.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) ua
        PushV( ua, Coerce( c, av, MT_PTR ) )
        '' 'PALETTE GET USING' IS A FOURTH FORM with its own entry point -- reading it
        '' as a GET meant the array was taken for GET's colour index.
        dim as boolean w64 = PaletteIs64_( c, an )
        if (sp->extra and PGFX_PAL_GET) <> 0 then
            EmitRtl( c, iif( w64, RTL_GFX_PALETTE_GETUSING64, RTL_GFX_PALETTE_GETUSING ), ua )
        else
            EmitRtl( c, iif( w64, RTL_GFX_PALETTE_USING64, RTL_GFX_PALETTE_USING ), ua )
        end if
        return true
    end if

    if (sp->extra and PGFX_PAL_GET) <> 0 then
        dim as boolean w = false
        dim as MirValue n = GfxInt( c, sp, 0, 0, w, ok )
        if ok = false then return false
        dim as FB.Array( of ulong ) ga
        PushV( ga, n )
        for i as long = 1 to 3
            dim as Fbx.NodeId on_ = GfxArg( c, sp, i )
            if on_ = Fbx.NODE_NONE then
                ga.Push( cast( ulong, MV_CONST_INT ) ) : ga.Push( 0 )
            else
                dim as MirValue oa = LowerAddr( c, on_ )
                if oa.kind = cast( ubyte, MV_NONE ) then return false
                PushV( ga, oa )
            end if
        next
        EmitRtl( c, iif( PaletteIs64_( c, GfxArg( c, sp, 1 ) ), _
                         RTL_GFX_PALETTE_GET64, RTL_GFX_PALETTE_GET ), ga )
        return true
    end if

    dim as FB.Array( of ulong ) pa
    for i as long = 0 to 3
        dim as boolean w = false
        dim as MirValue v = GfxInt( c, sp, i, -1, w, ok )
        if ok = false then return false
        PushV( pa, v )
    next
    EmitRtl( c, RTL_GFX_PALETTE, pa )
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
    case Fbx.KW_GET    : return LowerGfxGet( c, id )
    case Fbx.KW_PUT    : return LowerGfxPut( c, id )
    case Fbx.KW_PALETTE : return LowerGfxPalette( c, id )
    case Fbx.KW_SCREEN : return LowerGfxScreen( c, id )
    end select
    return false
end function


'' SCREEN mode [, depth [, pages [, flags [, refresh ]]]]
''
'' THE DEPTH DEFAULTS TO THE LITERAL 8 FOR EVERY MODE -- verified across modes 12, 13,
'' 18 and 21, where a per-mode table would be the obvious guess. Everything else is 0.
function LowerGfxScreen( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as boolean ok = true
    dim as FB.Array( of ulong ) args
    for i as long = 0 to 4
        dim as boolean w = false
        dim as longint dflt = 0
        if i = 1 then dflt = 8
        dim as MirValue v = GfxInt( c, sp, i, dflt, w, ok )
        if ok = false then return false
        PushV( args, v )
    next
    EmitRtl( c, RTL_GFX_SCREEN, args )
    return true
end function


'' 'imagecreate( w, h [, colour [, depth ]] )' and 'point( x, y [, target ] )', the two
'' graphics EXPRESSIONS. They are keywords rather than declared procedures, so they
'' cannot live in the prelude with the rest of the graphics surface.
''
''   imagecreate( 16, 16 )        fb_GfxImageCreate( 16, 16, 0u, 0, (int32)-2147483648u )
''   imagecreate( 16, 16, 7 )     fb_GfxImageCreate( 16, 16, 7u, 0, 0 )
''
'' AN OMITTED COLOUR IS THE SAME TWO-PART ANSWER THE DRAWING STATEMENTS GIVE: 0 in the
'' colour slot plus a flag bit, here &h80000000 in the FIFTH argument.
''
''   point( 1, 2 )       fb_GfxPoint( (void*)0, 1.0f, 2.0f )
''   point( 0 )          fb_GfxPoint( (void*)0, 0.0f, -8388607.0f )
''   point( 1, 2, img )  fb_GfxPoint( img, 1.0f, 2.0f )
''
'' THE ONE-ARGUMENT FORM IS THE SAME FUNCTION: the axis selector goes in x and y
'' carries a sentinel. And the TARGET, written LAST in BASIC, is passed FIRST.
function LowerGfxExprCall_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )

    dim as Fbx.StmtPayload lp
    lp.first = cp->first
    lp.count = cp->count
    dim as boolean ok = true

    if nm = "imagecreate" then
        if (cp->count < 2) orelse (cp->count > 4) then return false
        dim as FB.Array( of ulong ) args
        for i as long = 0 to 1
            dim as boolean w = false
            dim as MirValue v = GfxInt( c, @lp, i, 0, w, ok )
            if ok = false then return false
            PushV( args, v )
        next
        dim as boolean hasCol = false
        dim as MirValue col = GfxInt( c, @lp, 2, 0, hasCol, ok )
        if ok = false then return false
        PushV( args, col )
        dim as boolean w3 = false
        dim as MirValue dep = GfxInt( c, @lp, 3, 0, w3, ok )
        if ok = false then return false
        PushV( args, dep )
        dim as longint flags = 0
        if hasCol = false then flags = &h80000000
        PushV( args, ConstInt( c, flags, MT_I32 ) )
        outv = EmitRtl( c, RTL_GFX_IMAGECREATE, args )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    if nm = "point" then
        if (cp->count < 1) orelse (cp->count > 3) then return false
        dim as MirValue tgt = ConstInt( c, 0, MT_PTR )
        if cp->count = 3 then
            dim as MirValue tv = LowerExpr( c, cast( Fbx.NodeId, c.ast->children[cp->first + 2] ) )
            if tv.kind = cast( ubyte, MV_NONE ) then return false
            tgt = Coerce( c, tv, MT_PTR )
        end if
        dim as MirValue x = GfxCoord( c, @lp, 0, ok )
        if ok = false then return false
        dim as MirValue y
        if cp->count >= 2 then
            y = GfxCoord( c, @lp, 1, ok )
            if ok = false then return false
        else
            '' The sentinel that says "this is the one-argument form".
            y = ConstFloat( c, -8388607.0, MT_F32 )
        end if
        dim as FB.Array( of ulong ) args
        PushV( args, tgt )
        PushV( args, x )
        PushV( args, y )
        outv = EmitRtl( c, RTL_GFX_POINT, args )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    return false
end function

end namespace
