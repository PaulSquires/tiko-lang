'' lowergetput.bas -- file GET and PUT, the binary forms.
''
'' Split out of lowerio.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.

'' FILE GET AND PUT -- the BINARY forms. Measured:
''
''     get( #f, 1, b )   fb_FileGetLarge( F$0, 1ll, (void*)&B$0, 1ull )
''     put #f, 1, b      fb_FilePutLarge( F$0, 1ll, (void*)&B$0, 1ull )
''     get #f, , b       the position is 0 when it is elided
''
'' and the result is the error code, so both are EXPRESSIONS as well as statements --
'' 'CU_ASSERT( get( #f, 1, b ) = 0 )' is how the corpus writes every one of them.
''
'' A STRING OPERAND TAKES A DIFFERENT ENTRY POINT, fb_FileGetStrLarge, whose last
'' argument is a signed length rather than a byte count. Not modelled here: it declines,
'' which is the honest answer for a shape whose argument means something else.
'' THE BYTES-READ VARIABLE, 'get #f, pos, v, n, nread' -- its ADDRESS, appended, and the
'' position widened to the IOB entry points' int64. Measured, fbc:
''
''     fb_FileGetLargeIOB( 2, 33ll, (void*)Q$0, 8ull, &NREAD$0 )
''
'' tiko read only the first two items, so nread stayed 0 where fbc's is 8. False when there
'' is none; 'ok' false when there is one and its address cannot be taken.
private function FileGetIob_ _
    ( byref c as Ctx, byval sp as Tko.StmtPayload ptr, byval isPut as boolean, _
      byref args as FB.Array( of ulong ), byref ok as boolean ) as boolean
    ok = true
    if isPut orelse (sp->count < 4) then return false
    dim as Tko.NodeId nrN = cast( Tko.NodeId, c.ast->children[sp->first + 3] )
    if nrN = Tko.NODE_NONE then return false
    if c.ast->Kind( nrN ) = Tko.N_ELIDED then return false
    dim as MirValue na = LowerAddr( c, nrN )
    if na.kind = cast( ubyte, MV_NONE ) then
        ok = false
        return false
    end if
    '' args[2..3] is the position: the IOB forms take it as an int64 on every target.
    dim as MirValue pv
    pv.kind = cast( ubyte, args[2] ) : pv.id = args[3]
    pv.ty = cast( ubyte, iif( c.types->target.pointerBits = 32, MT_I32, MT_I64 ) )
    pv = Coerce( c, pv, MT_I64 )
    args[2] = cast( ulong, pv.kind ) : args[3] = pv.id
    args.Push( cast( ulong, na.kind ) ) : args.Push( cast( ulong, na.id ) )
    return true
end function

function LowerFileGetPut _
    ( byref c as Ctx, byval id as Tko.NodeId, byval isPut as boolean, _
      byref outv as MirValue ) as boolean

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    '' Bit 1 of 'extra' is the FILE form; bit 2 is the graphics one, which has its own
    '' coordinate grammar and its own lowering.
    if (sp->extra and 1) = 0 then return false
    if sp->count < 1 then return false

    '' The channel.
    dim as MirValue chan
    chan.kind = cast( ubyte, MV_CONST_INT )
    chan.ty = cast( ubyte, MT_I32 )
    chan.id = 0
    if sp->a <> Tko.NODE_NONE then
        dim as MirValue ch = LowerExpr( c, sp->a )
        if ch.kind = cast( ubyte, MV_NONE ) then return false
        chan = CoerceTy( c, ch, MT_I32, c.info->TypeOf_( sp->a ))
    end if

    '' 'get #f, pos, v' -- the POSITION then the VARIABLE. With one item written the
    '' position was elided and is 0.
    dim as Tko.NodeId posN = Tko.NODE_NONE
    dim as Tko.NodeId varN = Tko.NODE_NONE
    if sp->count = 1 then
        varN = cast( Tko.NodeId, c.ast->children[sp->first] )
    else
        posN = cast( Tko.NodeId, c.ast->children[sp->first] )
        varN = cast( Tko.NodeId, c.ast->children[sp->first + 1] )
    end if
    if varN = Tko.NODE_NONE then return false
    if c.ast->Kind( varN ) = Tko.N_ELIDED then return false

    dim as MirType zt = MT_I64
    if c.types->target.pointerBits = 32 then zt = MT_I32

    dim as MirValue pv = ConstInt( c, 0, zt )
    if posN <> Tko.NODE_NONE then
        if c.ast->Kind( posN ) <> Tko.N_ELIDED then
            dim as MirValue p0 = LowerExpr( c, posN )
            if p0.kind = cast( ubyte, MV_NONE ) then return false
            pv = CoerceTy( c, p0, zt, c.info->TypeOf_( posN ))
        end if
    end if

    '' The DESTINATION is written through, so its address and its size in bytes. A
    '' var-length string is a descriptor and takes the other entry point entirely.
    dim as Tko.TypeId vt = c.info->TypeOf_( varN )
    if vt = Tko.TYPE_NONE then return false

    '' A VAR-LENGTH STRING TAKES ITS OWN ENTRY POINT, and it is not the byte-count
    '' one: the destination is a DESCRIPTOR, and the runtime resizes it. Measured --
    ''
    ''   fb_FileGetStrLarge( F$0, 1ll, (void*)&S$0, -1ll );
    ''
    '' -- the trailing -1 being 'as many bytes as the string already holds', which is
    '' what the var-length form passes. Refused outright before this, so every
    '' 'get( #f, 1, s )' declined; file/get.bas writes twelve.
    '' 'put #1, 1, "abcdefgh"' -- A LITERAL, its bytes AND its terminator: measured,
    '' 'fb_FilePutStrLarge( 1, 1ll, (void*)"abcdefgh", 9ll )'. It has no address to take.
    if isPut andalso (c.ast->Kind( varN ) = Tko.N_STRING_LIT) then
        dim as string ltxt = StringLitText_( c, varN )
        dim as FB.Array( of ulong ) largs
        largs.Push( cast( ulong, chan.kind ) ) : largs.Push( cast( ulong, chan.id ) )
        largs.Push( cast( ulong, pv.kind ) ) : largs.Push( cast( ulong, pv.id ) )
        largs.Push( cast( ulong, MV_GLOBAL ) )
        largs.Push( cast( ulong, c.m->AddStringLiteral( ltxt, *c.names ) ) )
        dim as MirValue ln = ConstInt( c, len( ltxt ) + 1, zt )
        largs.Push( cast( ulong, ln.kind ) ) : largs.Push( cast( ulong, ln.id ) )
        outv = EmitRtl( c, RTL_FILE_PUT_STR, largs )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if IsStringType( c, vt ) then
        '' NARROW ONLY: a ustring descriptor is UTF-16 and fb_FileGetStrLarge would
        '' fill it with bytes.
        if IsUStringType( c, vt ) then return false
        dim as MirValue sa = LowerAddr( c, varN )
        '' A PUT OF A STRING RVALUE -- 'put #1, , gs( )', 'put #1, , s & "x"' -- writes its
        '' descriptor (StrDescriptorOf_): measured, fbc passes the call's result or the
        '' concatenation's temporary to fb_FilePutStrLarge with -1. It has no address.
        if (sa.kind = cast( ubyte, MV_NONE )) andalso isPut then StrDescriptorOf_( c, varN, sa )
        if sa.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) sargs
        sargs.Push( cast( ulong, chan.kind ) ) : sargs.Push( cast( ulong, chan.id ) )
        sargs.Push( cast( ulong, pv.kind ) ) : sargs.Push( cast( ulong, pv.id ) )
        sargs.Push( cast( ulong, sa.kind ) ) : sargs.Push( cast( ulong, sa.id ) )
        PushStrLen_( c, sargs, -1 )
        dim as boolean sok
        if FileGetIob_( c, sp, isPut, sargs, sok ) then
            outv = EmitRtl( c, RTL_FILE_GET_STR_LARGE_IOB, sargs )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
        if sok = false then return false
        outv = EmitRtl( c, iif( isPut, RTL_FILE_PUT_STR, RTL_FILE_GET_STR ), sargs )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' A FIXED WIDE STRING HAS ITS OWN GET, and the pair is NOT symmetric. Measured,
    '' over a 'wstring * 8' at position 0:
    ''
    ''     get:  fb_FileGetWstrLarge( 1, 0ll, (uint16*)W$0, 8ll );
    ''     put:  fb_FilePutStrLarge ( 1, 0ll, (void*)W$0,   8ll );
    ''
    '' -- the WIDE entry point on the way in and the NARROW one on the way out, with
    '' the same count in both: the DECLARED CHARACTER count, not a byte size. That
    '' asymmetry is measured and is not a transcription slip.
    ''
    '' Without this a fixed wstring fell through to the byte-count path below and was
    '' read with fb_FileGetLarge -- raw bytes into a UTF-16 buffer, in a statement that
    '' lowered and verified. fb_FileGetWstrLarge was already in the table with no
    '' caller.
    if IsWideString_( c, vt ) then
        '' AN UNBOUNDED WSTRING PASSES ZERO, not a refusal. Through a pointer --
        '' 'get( #f, 1, *pw )' -- there is no declared length, and measured fbc emits
        '' 'fb_FileGetWstrLarge( 1, 1ll, PW$0, 0ll )'. Refusing it declined the four
        '' statements file/get.bas writes in that spelling, which is how this was
        '' caught: the corpus went 749 -> 753 and the scoped sweep named the file.
        dim as long nel = WideStringElems( c, vt )
        if nel < 0 then nel = 0
        dim as MirValue wa = LowerAddr( c, varN )
        if wa.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) wargs
        wargs.Push( cast( ulong, chan.kind ) ) : wargs.Push( cast( ulong, chan.id ) )
        wargs.Push( cast( ulong, pv.kind ) ) : wargs.Push( cast( ulong, pv.id ) )
        wargs.Push( cast( ulong, wa.kind ) ) : wargs.Push( cast( ulong, wa.id ) )
        dim as MirValue wn = ConstInt( c, nel, zt )
        wargs.Push( cast( ulong, wn.kind ) ) : wargs.Push( cast( ulong, wn.id ) )
        dim as boolean wok
        if FileGetIob_( c, sp, isPut, wargs, wok ) then
            outv = EmitRtl( c, RTL_FILE_GET_WSTR_LARGE_IOB, wargs )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
        if wok = false then return false
        outv = EmitRtl( c, iif( isPut, RTL_FILE_PUT_STR, RTL_FILE_GET_WSTR ), wargs )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' A FIXED NARROW STRING TAKES THE STRING ENTRY POINTS with its length -- tagged for
    '' 'string * N' -- not a byte count. Measured: 'fb_FileGetStrLarge( 1, 1ll, Z$0, 4ll )'
    '' over a 'zstring * 4', which reads three characters and terminates them; the byte
    '' path read four and no terminator, and the next read of z ran past it.
    scope
        dim as longint fzn
        dim as long fsk = StrSwapKind_( c, vt, fzn )
        if ((fsk = 1) andalso (fzn > 0)) orelse (fsk = 3) then
            dim as MirValue fa = LowerAddr( c, varN )
            if fa.kind = cast( ubyte, MV_NONE ) then return false
            dim as FB.Array( of ulong ) fargs
            fargs.Push( cast( ulong, chan.kind ) ) : fargs.Push( cast( ulong, chan.id ) )
            fargs.Push( cast( ulong, pv.kind ) ) : fargs.Push( cast( ulong, pv.id ) )
            fargs.Push( cast( ulong, fa.kind ) ) : fargs.Push( cast( ulong, fa.id ) )
            PushStrLen_( c, fargs, fzn )
            dim as boolean fok
            if FileGetIob_( c, sp, isPut, fargs, fok ) then
                outv = EmitRtl( c, RTL_FILE_GET_STR_LARGE_IOB, fargs )
                return (outv.kind <> cast( ubyte, MV_NONE ))
            end if
            if fok = false then return false
            outv = EmitRtl( c, iif( isPut, RTL_FILE_PUT_STR, RTL_FILE_GET_STR ), fargs )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
    end scope

    '' AN ARRAY TAKES A DESCRIPTOR TOO, and a different one again: 'get( #f, 1, a() )'
    '' is fb_FileGetArrayLarge over the array's FBARRAY descriptor, which is the same
    '' descriptor ERASE builds for a fixed array. Only the FIXED form: a dynamic
    '' array's descriptor is not built at all yet, so passing whatever its slot holds
    '' would hand the runtime a wild pointer.
    '' THE ARRAY IS SPELLED 'a()' -- an EMPTY CALL over a name whose type is an array,
    '' which is not an N_IDENT and has no array type of its own. ArrayDescArg_ is what
    '' already recognises that shape and builds the descriptor for it; asking
    '' TypeOf( varN ) instead answered nothing and the statement declined.
    ''
    '' It handles the DYNAMIC form too, by passing the descriptor the slot already
    '' holds -- which tiko-lang does not build, so a dynamic array is refused here
    '' rather than handing the runtime whatever that slot contains.
    dim as boolean isEmptyCall = false
    if c.ast->Kind( varN ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr avp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, varN )].data )]
        isEmptyCall = (avp->count = 0) andalso (avp->target <> Tko.NODE_NONE)
    end if
    dim as boolean isArrName = (c.types->Kind( vt ) = Tko.TK_ARRAY)
    if isArrName then isArrName = (CharElemSize_( c, vt ) = 0)
    if isEmptyCall orelse isArrName then
        dim as MirValue adesc
        if ArrayDescArg_( c, varN, true, adesc ) then
            dim as Tko.TypeId aet = c.info->TypeOf_( varN )
            if c.ast->Kind( varN ) = Tko.N_CALL then
                dim as Tko.ListPayload ptr avp2 = _
                    @c.ast->lists[cast( long, c.ast->nodes[cast( long, varN )].data )]
                aet = c.info->TypeOf_( avp2->target )
            end if
            '' A DYNAMIC ARRAY TOO: its slot IS the descriptor fbc passes, '&DYN$0'. It was
            '' refused when tiko built none, and 'get #f, 1, dyn()' left the array zero.
            scope
                dim as FB.Array( of ulong ) aargs
                aargs.Push( cast( ulong, chan.kind ) ) : aargs.Push( cast( ulong, chan.id ) )
                aargs.Push( cast( ulong, pv.kind ) ) : aargs.Push( cast( ulong, pv.id ) )
                aargs.Push( cast( ulong, adesc.kind ) ) : aargs.Push( cast( ulong, adesc.id ) )
                dim as boolean aok
                if FileGetIob_( c, sp, isPut, aargs, aok ) then
                    outv = EmitRtl( c, RTL_FILE_GET_ARRAY_LARGE_IOB, aargs )
                    return (outv.kind <> cast( ubyte, MV_NONE ))
                end if
                if aok = false then return false
                outv = EmitRtl( c, iif( isPut, RTL_FILE_PUT_ARRAY, RTL_FILE_GET_ARRAY ), aargs )
                return (outv.kind <> cast( ubyte, MV_NONE ))
            end scope
        end if
    end if
    dim as long vsz = SizeOfType( c, vt )
    if vsz <= 0 then return false
    dim as MirValue va = LowerAddr( c, varN )
    if va.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, chan.kind ) ) : args.Push( cast( ulong, chan.id ) )
    args.Push( cast( ulong, pv.kind ) ) : args.Push( cast( ulong, pv.id ) )
    args.Push( cast( ulong, va.kind ) ) : args.Push( cast( ulong, va.id ) )
    dim as MirValue sv = ConstInt( c, vsz, zt )
    '' THE AMOUNT IS IN ELEMENTS: 'put #1, , buf( 0 ), 10' over a LONG array is 40 bytes,
    '' measured ('fb_FilePutLarge( 1, 0ll, BUF$0, 40ull )'). tiko wrote one element.
    if sp->count >= 3 then
        dim as Tko.NodeId amtN = cast( Tko.NodeId, c.ast->children[sp->first + 2] )
        if amtN <> Tko.NODE_NONE then
            if c.ast->Kind( amtN ) <> Tko.N_ELIDED then
                dim as MirValue av = LowerExprN_( c, amtN )
                if av.kind = cast( ubyte, MV_NONE ) then return false
                av = CoerceTy( c, av, zt, NumSrcType_( c, amtN ) )
                dim as MirInst mi
                mi.op = cast( ushort, M_MUL )
                mi.ty = cast( ubyte, zt )
                mi.a = av
                mi.b = sv
                sv = Emit( c, mi )
                if sv.kind = cast( ubyte, MV_NONE ) then return false
            end if
        end if
    end if
    args.Push( cast( ulong, sv.kind ) ) : args.Push( cast( ulong, sv.id ) )
    dim as boolean gok
    if FileGetIob_( c, sp, isPut, args, gok ) then
        outv = EmitRtl( c, RTL_FILE_GET_LARGE_IOB, args )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if gok = false then return false
    outv = EmitRtl( c, iif( isPut, RTL_FILE_PUT, RTL_FILE_GET ), args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function
