'' lowerdev.bas -- the DEVICE and FILE-POSITION statements: SEEK and COLOR.
''
'' Split out of lowerintr.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.

'' 'seek #n, pos' -- MOVE THE FILE POSITION.
''
'' Measured: 'seek #1, 2' is 'fb_FileSeekLarge( 1, 2ll )' and nothing else. It is
'' the LARGE entry point on both targets -- fbc emits it for a plain integer
'' position as readily as for a longint -- so there is no width to choose.
''
'' The FUNCTION spelling, 'seek( 1 )', is a different entry point and already
'' lowers: this is the two-argument STATEMENT.
private function LowerSeekStmt_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->count <> 2 then return false
    dim as Tko.NodeId chE = cast( Tko.NodeId, c.ast->children[sp->first] )
    dim as Tko.NodeId poE = cast( Tko.NodeId, c.ast->children[sp->first + 1] )
    if (c.ast->Kind( chE ) = Tko.N_ELIDED) orelse _
       (c.ast->Kind( poE ) = Tko.N_ELIDED) then return false

    dim as MirValue ch = LowerExpr( c, chE )
    if ch.kind = cast( ubyte, MV_NONE ) then return false
    ch = Coerce( c, ch, MT_I32, IsUnsignedType( c, c.info->TypeOf_( chE ) ) )
    dim as MirValue po = LowerExpr( c, poE )
    if po.kind = cast( ubyte, MV_NONE ) then return false
    po = Coerce( c, po, MT_I64, IsUnsignedType( c, c.info->TypeOf_( poE ) ) )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, ch.kind ) ) : args.Push( cast( ulong, ch.id ) )
    args.Push( cast( ulong, po.kind ) ) : args.Push( cast( ulong, po.id ) )
    EmitRtl( c, RTL_FILE_SEEK, args )
    return true
end function

'' 'color fg, bg' -- and its THIRD argument is a mask of what was OMITTED.
''
'' Measured, one probe per spelling:
''
''   color 1, 2    fb_Color( 1, 2, 0u )
''   color 3       fb_Color( 3, 0, 2u )
''   color , 4     fb_Color( 0, 4, 1u )
''   color         fb_Color( 0, 0, 3u )
''
'' -- so bit 1 says the FOREGROUND was not written and bit 2 the BACKGROUND, an
'' omitted argument passes 0, and the mask is the only thing that tells the
'' runtime which of those zeros to believe. Guessing it as a COUNT would answer
'' correctly for two of the four.
'' COLOR's arguments and its mask, from wherever they were written. The STATEMENT
'' keeps them on an N_INTRINSIC and the EXPRESSION on an N_CALL, and the emission
'' is the same either way -- 'var oldcolors = color( 1 )' is 'fb_Color( 1, 0, 2u )',
'' the same call the statement makes with its result discarded.
private function LowerColorArgs_ _
    ( byref c as Ctx, byval first as long, byval count as long, _
      byref outv as MirValue ) as boolean

    if count > 2 then return false
    dim as long mask = 0
    dim as FB.Array( of ulong ) args
    for k as long = 0 to 1
        dim as Tko.NodeId e = Tko.NODE_NONE
        if k < count then e = cast( Tko.NodeId, c.ast->children[first + k] )
        if e <> Tko.NODE_NONE then
            if c.ast->Kind( e ) = Tko.N_ELIDED then e = Tko.NODE_NONE
        end if
        if e = Tko.NODE_NONE then
            mask or= (1 shl k)
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        else
            dim as MirValue v = LowerExpr( c, e )
            if v.kind = cast( ubyte, MV_NONE ) then return false
            v = Coerce( c, v, MT_I32, IsUnsignedType( c, c.info->TypeOf_( e ) ) )
            args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
        end if
    next
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, mask ) )
    outv = EmitRtl( c, RTL_COLOR, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 'color( fg )' IN EXPRESSION POSITION yields the PREVIOUS colours, which is what
'' the runtime returns and what 'var oldcolors = color( 1 )' is for.
function LowerColorCall_ _
    ( byref c as Ctx, byval calleeNode as Tko.NodeId, byval argFirst as long, _
      byval argCount as long, byref outv as MirValue ) as boolean

    if calleeNode = Tko.NODE_NONE then return false
    if c.ast->Kind( calleeNode ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, calleeNode )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "color" then
        return false
    end if
    return LowerColorArgs_( c, argFirst, argCount, outv )
end function

private function LowerColorStmt_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    dim as MirValue cv
    return LowerColorArgs_( c, sp->first, sp->count, cv )
end function

