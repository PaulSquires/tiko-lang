'' lowerstrintr.bas -- MID AS AN ASSIGNMENT TARGET, and DIR.
''
'' Split out of lowerio.bas at the 1500-line cap and included from it in the same
'' place, so nothing about the compile order changes. Neither belongs to I/O; both
'' are intrinsics whose lowering is a runtime call PICKED BY THE SHAPE of an
'' argument, which is what they have in common. Nothing in them changed in the move.

'' 'mid( dst, start [, len ] ) = value' -- MID AS AN ASSIGNMENT TARGET, which was not
'' lowered at all: the whole statement produced nothing and the string was left
'' untouched. string/mid_set.bas is eighteen of them and is the largest in-scope file
'' left.
''
'' Measured, every destination shape, and the DESTINATION is where they differ -- the
'' runtime call always wants a DESCRIPTOR:
''
''   string s            fb_StrAssignMid( &S$0, ... )
''   string ptr *ps      fb_StrAssignMid( PS$0, ... )        -- already a descriptor
''   *strptr( s )        fb_StrAllocTempDescZ( *(char**)&S$0 )   then Mid over that
''   zstring * 8 z       fb_StrAllocTempDescZ( (char*)Z$0 )      then Mid over that
''   zstring ptr *pz     fb_StrAllocTempDescZ( (char*)PZ$0 )     then Mid over that
''   string * 8 f        fb_StrAllocTempDescF( (void*)F$0, <tagged 8> )
''   wstring * 8 w       fb_WstrAssignMid( (uint16*)W$0, 8, start, len, src )
''
'' -- so a char BUFFER is wrapped in a temporary descriptor and a real descriptor is
'' passed as it stands. An OMITTED LENGTH is -1, not 0 and not the source's length.
''
'' THE UTF-16 VAR-LENGTH FLAVOUR IS NOT MODELLED HERE and declines: 'mid( u, 1 ) = x'
'' over a ustring is fb_UStrAssignMid, a SIX-argument entry point with tagged lengths
'' on both sides, which is not in the inventory. Approximating it with the narrow call
'' would write UTF-8 bytes into a UTF-16 buffer, which is the exact mistake the string
'' work has already made once.
function LowerMidAssign _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    if c.ast->Kind( target ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, target )].data )]
    if (cp->count < 2) orelse (cp->count > 3) then return false
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr tip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( tip->name ) ) <> "mid" then return false
    '' A NAME THE SOURCE DECLARED IS NOT THE INTRINSIC.
    if c.info->RefOf( cp->target ) <> Tko.SYMBOL_NONE then return false

    dim as Tko.NodeId dstN = cast( Tko.NodeId, c.ast->children[cp->first] )
    dim as Tko.NodeId startN = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
    dim as Tko.NodeId lenN = Tko.NODE_NONE
    if cp->count = 3 then lenN = cast( Tko.NodeId, c.ast->children[cp->first + 2] )

    dim as MirValue sv = LowerExpr( c, startN )
    if sv.kind = cast( ubyte, MV_NONE ) then return false
    sv = CoerceTy( c, sv, MT_I64, c.info->TypeOf_( startN ))

    '' AN OMITTED LENGTH IS -1 -- 'to the end' -- and not 0.
    dim as MirValue lv
    lv.kind = cast( ubyte, MV_CONST_INT )
    lv.ty = cast( ubyte, MT_I64 )
    lv.id = cast( ulong, cast( ulongint, -1 ) )
    if lenN <> Tko.NODE_NONE then
        lv = LowerExpr( c, lenN )
        if lv.kind = cast( ubyte, MV_NONE ) then return false
        lv = CoerceTy( c, lv, MT_I64, c.info->TypeOf_( lenN ))
    end if

    dim as Tko.TypeId dt = c.info->TypeOf_( dstN )
    dim as longint dn
    dim as long dk = StrSwapKind_( c, dt, dn )

    '' A UDT THAT CASTS TO A WSTRING IS A WIDE DESTINATION. StrSwapKind_ answers -1 for
    '' one -- it classifies TYPES, and a UDT is not a string type -- so the wide branch
    '' below was never reached and 'mid( u, 2 ) = w' declined, while 'w = u' beside it
    '' lowered. Measured: fbc calls the cast operator and passes its result with LENGTH
    '' ZERO, which is the runtime's 'work it out from the terminator'.
    if (dk < 0) andalso TermIsWide_( c, dstN ) then
        dk = 2
        dn = 0
    end if

    '' ...AND A UDT THAT CASTS TO A NARROW ZSTRING IS A CHARACTER BUFFER. Measured:
    '' fbc calls the operator, wraps the char* it returns in fb_StrAllocTempDescZ and
    '' passes THAT -- byte-identical to the plain 'zstring * N' row below, with the
    '' pointer coming from the cast instead of from the destination's address.
    '' udt-zstring/midstmt.bas writes four of these.
    dim as MirValue castPtr
    dim as boolean haveCastPtr = false
    if dk < 0 then
        if c.types->Kind( c.types->Unqualify( dt ) ) = Tko.TK_UDT then
            dim as boolean narrowRaw = false
            if UserCastToStr_( c, dstN, castPtr, narrowRaw ) then
                if narrowRaw then
                    dk = 1
                    haveCastPtr = true
                end if
            end if
        end if
    end if

    '' THE WIDE FLAVOUR takes the buffer POINTER and its CHARACTER COUNT, not a
    '' descriptor -- a wstring has none.
    if dk = 2 then
        dim as MirValue wd
        if WideOperand_( c, dstN, wd ) = false then return false
        dim as MirValue wsrc
        if WideOperand_( c, value, wsrc ) = false then return false
        dim as FB.Array( of ulong ) wa
        wa.Push( cast( ulong, wd.kind ) ) : wa.Push( cast( ulong, wd.id ) )
        wa.Push( cast( ulong, MV_CONST_INT ) ) : wa.Push( cast( ulong, dn ) )
        wa.Push( cast( ulong, sv.kind ) ) : wa.Push( cast( ulong, sv.id ) )
        wa.Push( cast( ulong, lv.kind ) ) : wa.Push( cast( ulong, lv.id ) )
        wa.Push( cast( ulong, wsrc.kind ) ) : wa.Push( cast( ulong, wsrc.id ) )
        '' A VOID RESULT IS STILL A CALL. EmitRtl hands back MV_NONE for one, so
        '' reading that as failure declined every MID that had just been emitted --
        '' the call went out AND the statement was counted as not lowered.
        EmitRtl( c, RTL_WSTR_ASSIGN_MID, wa )
        return true
    end if

    '' A UTF-16 DESCRIPTOR IS NOT A NARROW ONE: it has its own entry point, and
    '' handing it to the narrow call would write UTF-8 bytes into a UTF-16 buffer.
    ''
    ''     mid( a, 2 ) = b        fb_UStrAssignMid( &A, -1, 2, -1, &B, -1 )
    ''     mid( a, 5, 2 ) = b     fb_UStrAssignMid( &A, -1, 5,  2, &B, -1 )
    ''
    '' -- six arguments, a (pointer, length) pair at each end, -1 meaning 'as
    '' declared'. Measured.
    ''
    '' THE SOURCE MUST BE A USTRING TOO. fbc converts a narrow one first --
    '' 'mid( a, 2 ) = n' over a STRING passes the result of a conversion, and a
    '' LITERAL becomes a UTF-16 array with a tagged length -- and neither
    '' conversion is modelled here, so those still decline rather than pass bytes
    '' of the wrong width. fb/string.bi's Join writes both of its mids with a
    '' ustring on the right, which is the 14 corpus statements this is for.
    if IsUStringType( c, dt ) then
        if IsUStringType( c, c.info->TypeOf_( value ) ) = false then return false
        dim as MirValue ud
        if StrDescriptorOf_( c, dstN, ud ) = false then return false
        dim as MirValue us
        if StrDescriptorOf_( c, value, us ) = false then return false
        dim as FB.Array( of ulong ) ua
        PushStrArg( ua, ud )
        ua.Push( cast( ulong, sv.kind ) ) : ua.Push( cast( ulong, sv.id ) )
        ua.Push( cast( ulong, lv.kind ) ) : ua.Push( cast( ulong, lv.id ) )
        PushStrArg( ua, us )
        '' A VOID RESULT IS STILL A CALL -- see the wide branch above.
        EmitRtl( c, RTL_USTR_ASSIGN_MID, ua )
        return true
    end if
    if dk = 4 then return false

    dim as MirValue ddesc
    if dk = 0 then
        '' A REAL DESCRIPTOR, passed as it stands.
        ddesc = LowerAddr( c, dstN )
        if ddesc.kind = cast( ubyte, MV_NONE ) then return false
    elseif (dk = 1) orelse (dk = 3) then
        '' A CHARACTER BUFFER, wrapped in a temporary descriptor -- whose pointer is
        '' the cast's result when the destination was a UDT.
        dim as MirValue bufp = castPtr
        if haveCastPtr = false then bufp = LowerAddr( c, dstN )
        if bufp.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, bufp.kind ) ) : ta.Push( cast( ulong, bufp.id ) )
        if dk = 3 then
            '' A FIXED-LENGTH narrow string carries its TAGGED length.
            ta.Push( cast( ulong, MV_CONST_INT ) )
            ta.Push( cast( ulong, FixedStrLenArg_( c, dn ) ) )
            ddesc = EmitRtl( c, RTL_STR_TEMPF, ta )
        else
            ddesc = EmitRtl( c, RTL_STR_TEMPZ_NOLEN, ta )
        end if
        if ddesc.kind = cast( ubyte, MV_NONE ) then return false
    else
        return false
    end if

    dim as MirValue src
    if StrDescriptorOf_( c, value, src ) = false then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, ddesc.kind ) ) : args.Push( cast( ulong, ddesc.id ) )
    args.Push( cast( ulong, sv.kind ) ) : args.Push( cast( ulong, sv.id ) )
    args.Push( cast( ulong, lv.kind ) ) : args.Push( cast( ulong, lv.id ) )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    EmitRtl( c, RTL_STR_ASSIGN_MID, args )
    return true
end function

'' DIR, all five spellings. Measured, every row:
''
''   dir( )                   fb_DirNext( (int32*)0 )
''   dir( "*" )               fb_Dir( desc, 33, (int32*)0 )
''   dir( "*", fbNormal )     fb_Dir( desc, 33, (int32*)0 )
''   dir( "*", , l )          fb_Dir( desc, 33, &L )
''   dir( "*", , ll )         fb_Dir64( desc, 33, &LL )
''   dir( l )                 fb_DirNext( &L )
''   dir( ll )                fb_DirNext64( &LL )
''
'' THREE THINGS THAT ARE NOT GUESSABLE. The default attribute is 33, which is
'' fbNormal -- fbReadOnly or fbArchive -- and not 0. The OUT PARAMETER'S WIDTH picks
'' the entry point: 4 bytes takes fb_Dir / fb_DirNext and 8 takes fb_Dir64 /
'' fb_DirNext64, which are separate symbols; 'integer' is 8 bytes on win64, so the
'' plain spelling takes the 64 form there. And 'dir( l )' with a NUMBER where the
'' pattern goes is not a pattern at all -- it is the continuation form with an out
'' parameter, so what the first argument's TYPE is decides which of the two families
'' this is.
''
'' The out argument is passed BY ADDRESS when it is an lvalue and BY VALUE when it is
'' already a pointer -- 'dir( "*", , l )' and 'dir( "*", , @l )' both reach the
'' runtime as '&L$0', measured.
''
'' None of it was implemented: 'dir' was not in the intrinsic type table either, so
'' every assignment from one had nothing to store.
function LowerDir _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->count > 3 then return false
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr tip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( tip->name ) ) <> "dir" then return false
    '' A NAME THE SOURCE DECLARED IS NOT THE INTRINSIC.
    if c.info->RefOf( cp->target ) <> Tko.SYMBOL_NONE then return false

    '' WHICH FAMILY. A STRING first argument is a pattern and starts a new walk; a
    '' number, a pointer or no argument at all continues the one already running.
    dim as Tko.NodeId pat = Tko.NODE_NONE
    dim as Tko.NodeId attr = Tko.NODE_NONE
    dim as Tko.NodeId outn = Tko.NODE_NONE
    if cp->count >= 1 then
        dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[cp->first] )
        if IsStringType( c, c.info->TypeOf_( a0 ) ) then
            pat = a0
            if cp->count >= 2 then attr = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
            if cp->count >= 3 then outn = cast( Tko.NodeId, c.ast->children[cp->first + 2] )
        else
            '' The continuation form takes at most the out parameter.
            if cp->count <> 1 then return false
            outn = a0
        end if
    end if
    '' AN ELIDED ARGUMENT IS NOT AN ARGUMENT: 'dir( "*", , l )' writes the attribute
    '' slot empty, and the parser records that as a node rather than a gap so the
    '' ARITY survives.
    if attr <> Tko.NODE_NONE then
        select case c.ast->Kind( attr )
        case Tko.N_ELIDED, Tko.N_ERROR : attr = Tko.NODE_NONE
        end select
    end if
    if outn <> Tko.NODE_NONE then
        select case c.ast->Kind( outn )
        case Tko.N_ELIDED, Tko.N_ERROR : outn = Tko.NODE_NONE
        end select
    end if

    '' THE OUT POINTER, and its WIDTH, which is what picks the entry point. Already a
    '' pointer: its value, and the pointee's size. An lvalue: its address, and its own
    '' size. Nothing at all: a null pointer, and the 32-bit family.
    dim as MirValue outp
    dim as boolean wide = false
    if outn = Tko.NODE_NONE then
        outp.kind = cast( ubyte, MV_CONST_INT )
        outp.ty = cast( ubyte, MT_PTR )
        outp.id = 0
    else
        dim as Tko.TypeId ot = c.types->Unqualify( c.info->TypeOf_( outn ) )
        if c.types->Kind( ot ) = Tko.TK_POINTER then
            outp = LowerExpr( c, outn )
            dim as Tko.TypeId pe = c.types->Inner( ot )
            if pe <> Tko.TYPE_NONE then wide = (SizeOfType( c, pe ) >= 8)
        else
            outp = LowerAddr( c, outn )
            wide = (SizeOfType( c, ot ) >= 8)
        end if
        if outp.kind = cast( ubyte, MV_NONE ) then return false
    end if

    dim as FB.Array( of ulong ) args
    if pat = Tko.NODE_NONE then
        args.Push( cast( ulong, outp.kind ) ) : args.Push( cast( ulong, outp.id ) )
        dim as long which = RTL_DIR_NEXT
        if wide then which = RTL_DIR_NEXT64
        outv = EmitRtl( c, which, args )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' The pattern is a STRING DESCRIPTOR, which is what every runtime entry point
    '' taking a string wants and what a literal has to be wrapped into. A USTRING is
    '' converted first -- its own descriptor read as narrow is the one-character "C" of
    '' "C:\..." -- as fbc does: 'fb_Dir( fb_UStrToStr( &ROOT, -1 ), 16, 0 )'.
    dim as MirValue pv
    if UStrToStrTemp_( c, pat, pv ) = false then
        if StrDescriptorOf_( c, pat, pv ) = false then return false
    end if
    args.Push( cast( ulong, pv.kind ) ) : args.Push( cast( ulong, pv.id ) )

    '' 33 -- fbNormal, which is fbReadOnly or fbArchive -- and NOT 0.
    if attr = Tko.NODE_NONE then
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 33 )
    else
        dim as MirValue av = LowerExpr( c, attr )
        if av.kind = cast( ubyte, MV_NONE ) then return false
        av = CoerceTy( c, av, MT_I32, c.info->TypeOf_( attr ))
        args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    end if
    args.Push( cast( ulong, outp.kind ) ) : args.Push( cast( ulong, outp.id ) )

    dim as long which2 = RTL_DIR
    if wide then which2 = RTL_DIR64
    outv = EmitRtl( c, which2, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

