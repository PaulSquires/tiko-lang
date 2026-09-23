'' lowerwstrof.bas -- LowerWstrOf: 'wstr( x )' over every operand shape it takes.
'' Split out of lowerstr.bas on 2026-09-10 for the 1500-line cap; nothing about the
'' code changed in the move.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

'' Defined in lowerwstr.bas. A WIDE result is an allocation the caller owns, and this is
'' what parks it in a temporary and registers that for the fb_WstrDelete at the end of
'' the statement. Declared here because this is its own compilation unit.
declare function WideConcatStep_ _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), byval r as RtlId, _
      byref acc as MirValue ) as boolean

'' Defined in lowerstrkind.bas: which fixed-string flavour a type is, and its length.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

function LowerWstrOf _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 1 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "wstr" then return false

    dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[lp->first] )

    '' A STRING LITERAL is FOLDED, not converted. Measured: fbc emits L"abc" and no
    '' call at all -- 'wstr( "  ab  " )' becomes '(uint16*)L"  ab  "'. Sending it
    '' through fb_StrToWstr would have needed a descriptor the literal does not have,
    '' which is why this declined: 2,496 corpus statements, all of them
    '' 'dim w as wstring * 50 = trim( wstr( "..." ) )' and its relatives.
    if c.ast->Kind( a ) = Tko.N_STRING_LIT then
        '' Through the wide reader, so a '\uXXXX' is a CODE UNIT here and not six
        '' characters of spelling.
        dim as long wch2 = 0
        dim as long wg2 = WideLitGlobal_( c, a, wch2 )
        if wg2 < 0 then return false
        outv.kind = cast( ubyte, MV_GLOBAL )
        outv.ty = cast( ubyte, MT_PTR )
        outv.id = wg2
        return true
    end if

    '' ...AND SO IS ANY CONSTANT STRING: a concatenation of literals, 'chr( 34 )',
    '' 'str( 12 )', a string constant. Measured, fbc folds every one --
    '' '@wstr( "a" & chr( 34 ) )' is '(uint16*)L"a\x0022"'. Converted at run time
    '' instead, '@wstr( ... )' was the address of a temporary freed at the end of the
    '' statement, and fbx's TaskDialog footer 'pszFooter = @WSTR( "..." & CHR( 34 ) & ... )'
    '' displayed whatever reused the memory.
    dim as string cft
    if ConstStringTextOf_( c, a, cft ) then
        dim as long cfn = 0
        outv.kind = cast( ubyte, MV_GLOBAL )
        outv.ty = cast( ubyte, MT_PTR )
        outv.id = WideFoldedText_( c, a, cft, cfn )
        return true
    end if

    '' THE ARGUMENT MAY BE A WIDE CONCATENATION, which has no type of its own -- so
    '' asking for one and giving up is how 'wstr(  & wstr( w ) &  )' declined:
    '' the inner conversions lowered and the wstr around them did not.
    if ConcatHasWideTerm_( c, a ) then
        if WideOperand_( c, a, outv ) then return true
    end if

    dim as Tko.TypeId at = c.info->TypeOf_( a )
    if at = Tko.TYPE_NONE then return false

    '' AN ALREADY-WIDE ARGUMENT IS THE IDENTITY, and fbc emits no call at all:
    '' 'print wstr( cmp )' over a 'wstring * 20' is 'fb_PrintWstr( 0, (uint16*)CMP, 1 )'.
    '' Falling through instead made the whole expression decline.
    if IsWideString_( c, at ) then
        outv = LowerAddr( c, a )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' A USTRING IS TRANSCODED FIRST. Its descriptor's data pointer is UTF-16, and
    '' handing that to fb_StrToWstr read it as narrow bytes and stopped at the first
    '' embedded NUL: 'print wstr( u )' over "u0" printed "u". Measured, fbc converts and
    '' then widens what comes back, for a variable and a call alike:
    ''
    ''   vr$41 = fb_UStrToStr( (void*)vr$40, -1ll );
    ''   fb_StrAssign( (void*)&TMP$14$0, -1ll, (void*)vr$41, -1ll, 0 );
    ''   vr$43 = fb_StrToWstr( (char*)*(char**)&TMP$14$0 );
    ''
    '' -- the narrow temporary because fb_UStrToStr hands back a POOL descriptor, which
    '' the assignment consumes. UStrOutOperand_ gives the ustring descriptor whatever
    '' shape it was written in, and its copy, if it made one, dies here.
    '' A VAR-LENGTH ONE ONLY: fbc REFUSES 'wstr( uf )' over a 'ustring * N' with its
    '' error 24, "Invalid data types", so there is nothing to reproduce here. It goes on
    '' declining, which is what it did before -- reporting it belongs in Check.
    dim as longint uzn
    if IsUStringType( c, at ) andalso (StrSwapKind_( c, at, uzn ) <> 4) then
        dim as MirValue uo
        dim as long uoslot = -1
        if UStrOutOperand_( c, a, uo, uoslot ) = false then return false
        dim as FB.Array( of ulong ) ua
        ua.Push( cast( ulong, uo.kind ) ) : ua.Push( cast( ulong, uo.id ) )
        PushStrLen_( c, ua, -1 )
        dim as MirValue nv = EmitRtl( c, RTL_USTR_TO_STR, ua )
        ReleaseUStrOut_( c, uoslot )
        if nv.kind = cast( ubyte, MV_NONE ) then return false
        dim as long uslot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
        if uslot < 0 then return false
        dim as MirValue und
        und.kind = cast( ubyte, MV_LOCAL ) : und.ty = cast( ubyte, MT_PTR ) : und.id = uslot
        ZeroStrDescriptor( c, und )
        dim as FB.Array( of ulong ) sa
        sa.Push( cast( ulong, und.kind ) ) : sa.Push( cast( ulong, und.id ) )
        PushStrLen_( c, sa, -1 )
        sa.Push( cast( ulong, nv.kind ) ) : sa.Push( cast( ulong, nv.id ) )
        PushStrLen_( c, sa, -1 )
        sa.Push( cast( ulong, MV_CONST_INT ) ) : sa.Push( 0 )
        EmitRtl( c, RTL_STR_ASSIGN, sa )
        c.strTemps.Push( cast( ulong, uslot ) )
        dim as MirInst ufa
        ufa.op = cast( ushort, M_FIELD_ADDR ) : ufa.ty = cast( ubyte, MT_PTR )
        ufa.a = und : ufa.imm = 0
        dim as MirValue upa = Emit( c, ufa )
        if upa.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue uraw = LowerExprLoad( c, upa, MT_PTR )
        if uraw.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) wargs
        wargs.Push( cast( ulong, uraw.kind ) ) : wargs.Push( cast( ulong, uraw.id ) )
        return WideConcatStep_( c, wargs, RTL_STR_TO_WSTR, outv )
    end if

    '' A NARROW STRING: the raw data pointer, not the descriptor.
    dim as longint zn
    dim as long sk = StrSwapKind_( c, at, zn )
    if sk = 0 then
        '' A PAREN-LESS CALL HAS NO ADDRESS EITHER -- 'wstr( o.GetS )' took LowerAddr's
        '' answer, the procedure's CODE address, as the descriptor -- so it is left to
        '' the rvalue temporary below exactly as 'wstr( o.GetS( ) )' is. Measured, fbc
        '' writes the same for both: 'fb_StrAssign( &TMP, -1, vr, -1, 0 )' and then
        '' fb_StrToWstr over TMP's data pointer.
        dim as MirValue d
        if NamesProc_( c, a ) = false then d = LowerAddr( c, a )
        '' A NARROW CONCATENATION HAS NO ADDRESS. Measured, fbc builds it into a
        '' temporary descriptor and converts THAT:
        ''
        ''     vr$6 = fb_StrConcat( &TMP$4$0, "asd", 4, vr$3, -1 );
        ''     vr$8 = fb_StrToWstr( (char*)*(char**)&TMP$5$0 );
        ''
        '' -- which is 'wstr( "asd" + chr( 0 ) )', the shape wstring/instr_0.bas is
        '' written out of. Asking only for an address declined every one of them.
        if d.kind = cast( ubyte, MV_NONE ) then
            if ConcatToTemp_( c, a, d ) = false then
                '' NOR HAS A CALL. 'f( hex( 1 ) )' against a 'byref w as wstring'
                '' parameter is measured as a NARROW temporary and then the
                '' conversion:
                ''
                ''     vr$20 = fb_HEX_l( 1 );
                ''     fb_StrAssign( &TMP$6$0, -1, vr$20, -1, 0 );
                ''     vr$22 = fb_StrToWstr( (char*)*(char**)&TMP$6$0 );
                ''
                '' -- the same temporary a byval string parameter gets. Without it
                '' every narrow RVALUE handed to a wide parameter declined:
                '' functions/temp-strings.bas writes the shape twelve times.
                dim as long nslot = _
                    NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
                if nslot < 0 then return false
                dim as MirValue nd
                nd.kind = cast( ubyte, MV_LOCAL )
                nd.ty = cast( ubyte, MT_PTR )
                nd.id = nslot
                ZeroStrDescriptor( c, nd )
                if StrInitFrom_( c, nd, a ) = false then return false
                '' Released at the END OF THE STATEMENT, beside the other string
                '' temporaries, which is the life fbc gives it.
                c.strTemps.Push( cast( ulong, nslot ) )
                d = nd
            end if
        end if
        if d.kind = cast( ubyte, MV_NONE ) then return false
        '' Field 0 of the descriptor is its data pointer.
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = d
        fa.imm = 0
        dim as MirValue pa = Emit( c, fa )
        if pa.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue raw = LowerExprLoad( c, pa, MT_PTR )
        if raw.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) sargs
        sargs.Push( cast( ulong, raw.kind ) ) : sargs.Push( cast( ulong, raw.id ) )
        '' AND THE RESULT IS OWNED. fbc writes 'vr = fb_StrToWstr( ... )' and a
        '' matching fb_WstrDelete at the end of the statement -- measured over all
        '' three narrow shapes, six conversions and six deletes. EmitRtl alone
        '' dropped the pointer, so every 'wstr( s )' leaked.
        return WideConcatStep_( c, sargs, RTL_STR_TO_WSTR, outv )
    elseif sk = 1 then
        '' A ZSTRING * N IS already a char array: its address is the char*.
        dim as MirValue za = LowerAddr( c, a )
        if za.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) zargs
        zargs.Push( cast( ulong, za.kind ) ) : zargs.Push( cast( ulong, za.id ) )
        return WideConcatStep_( c, zargs, RTL_STR_TO_WSTR, outv )
    elseif sk = 3 then
        '' A 'string * N' IS NOT A CHAR ARRAY THE WAY A ZSTRING IS: it is SPACE-PADDED
        '' and carries no terminator, so its N bytes cannot be handed to fb_StrToWstr
        '' as a C string. Measured, fbc copies it into a var-length temporary first and
        '' converts THAT:
        ''
        ''   fb_StrAssign( &TMP$2$0, -1ll, (void*)FS$0, -9223372036854775798ll, 0 );
        ''   vr$6 = fb_StrToWstr( (char*)*(char**)&TMP$2$0 );
        ''
        '' -- the second argument being the TAGGED length of the fixed string, which is
        '' what tells the runtime to stop at N bytes and trim the padding.
        ''
        '' fbc emits a third call after those two, copying the temporary BACK into the
        '' fixed string, which is its general byref-temp protocol; nothing here writes
        '' the temporary, so it is a no-op and is not reproduced.
        ''
        '' Without this row 'wstr( fs )' produced nothing, and it takes the enclosing
        '' statement with it: overload/strings_ptr.bas is twelve calls that each pass
        '' one.
        dim as MirValue fa2 = LowerAddr( c, a )
        if fa2.kind = cast( ubyte, MV_NONE ) then return false
        dim as long fslot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
        if fslot < 0 then return false
        dim as MirValue fd
        fd.kind = cast( ubyte, MV_LOCAL )
        fd.ty = cast( ubyte, MT_PTR )
        fd.id = fslot
        ZeroStrDescriptor( c, fd )
        dim as FB.Array( of ulong ) faa
        faa.Push( cast( ulong, fd.kind ) ) : faa.Push( cast( ulong, fd.id ) )
        faa.Push( cast( ulong, MV_CONST_INT ) )
        faa.Push( cast( ulong, cast( ulongint, -1 ) ) )
        faa.Push( cast( ulong, fa2.kind ) ) : faa.Push( cast( ulong, fa2.id ) )
        '' ALREADY ENCODED: StrSwapKind_ hands back a FIXSTR's length in the tagged
        '' form, because that is the only form any runtime call wants it in --
        '' encoding it a second time here would set the tag bit on a value that
        '' already has it. And it is a 64-BIT constant, so it goes through
        '' PushStrLen_: pushing it as a ulong truncates the tag away and the runtime
        '' reads a plain length of 10.
        PushStrLen_( c, faa, zn )
        faa.Push( cast( ulong, MV_CONST_INT ) ) : faa.Push( 0 )
        EmitRtl( c, RTL_STR_ASSIGN, faa )
        '' Released at the END OF THE STATEMENT, with the other string temporaries.
        c.strTemps.Push( cast( ulong, fslot ) )

        dim as MirInst ffa
        ffa.op = cast( ushort, M_FIELD_ADDR )
        ffa.ty = cast( ubyte, MT_PTR )
        ffa.a = fd
        ffa.imm = 0
        dim as MirValue fpa = Emit( c, ffa )
        if fpa.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue fraw = LowerExprLoad( c, fpa, MT_PTR )
        if fraw.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) fargs
        fargs.Push( cast( ulong, fraw.kind ) ) : fargs.Push( cast( ulong, fraw.id ) )
        return WideConcatStep_( c, fargs, RTL_STR_TO_WSTR, outv )
    end if

    '' A UDT WITH 'operator cast'. 'wstr( u )' over one whose cast yields a WSTRING is
    '' the identity, and over one that yields a narrow string it is the ordinary
    '' conversion -- WideOperand_ knows the first and NarrowToWideTemp_ the second.
    if c.types->Kind( at ) = Tko.TK_UDT then
        if WideOperand_( c, a, outv ) then return true
        return NarrowToWideTemp_( c, a, outv )
    end if

    '' A SCALAR. Which entry point, and what the argument widens to, both come from the
    '' operand's own type.
    '' A POINTER RENDERS AS ITS ADDRESS, unsigned -- measured, 'wstr( p )' is
    '' 'fb_ULongintToWstr( (uint64)P$0 )' for every pointer type. It is not a
    '' BUILTIN, so the test below refused it and the call came out untyped.
    dim as boolean atPtr = (c.types->Kind( at ) = Tko.TK_POINTER)
    if (c.types->Kind( at ) <> Tko.TK_BUILTIN) andalso (atPtr = false) then return false
    dim as RtlId r = RTL_NONE
    dim as MirType want = MT_I32
    if atPtr then r = RTL_ULONGINT_TO_WSTR : want = MT_I64
    if atPtr = false then
        select case c.types->BuiltinOf( at )
    '' BOOLEAN IS ITS OWN RENDERER, not an integer one -- measured, 'wstr( b )' is
    '' 'fb_BoolToWstr( B$0 )', and fb_IntToWstr writes -1 and 0 where fbc writes
    '' "true" and "false". The narrow half of this table already had the distinction.
    case Tko.TY_BOOLEAN
        r = RTL_BOOL_TO_WSTR : want = MT_I8
    case Tko.TY_BYTE, Tko.TY_SHORT, Tko.TY_LONG
        r = RTL_INT_TO_WSTR
    case Tko.TY_UBYTE, Tko.TY_USHORT, Tko.TY_ULONG
        r = RTL_UINT_TO_WSTR
    case Tko.TY_INTEGER, Tko.TY_LONGINT
        r = RTL_LONGINT_TO_WSTR : want = MT_I64
    case Tko.TY_UINTEGER, Tko.TY_ULONGINT
        r = RTL_ULONGINT_TO_WSTR : want = MT_I64
    case Tko.TY_SINGLE
        r = RTL_FLOAT_TO_WSTR : want = MT_F32
    case Tko.TY_DOUBLE
        r = RTL_DOUBLE_TO_WSTR : want = MT_F64
    case else
        return false
    end select
    end if

    dim as MirValue av = LowerExpr( c, a )
    if av.kind = cast( ubyte, MV_NONE ) then return false
    av = CoerceTy( c, av, want, at)
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    '' THROUGH WideConcatStep_, WHICH REGISTERS THE RESULT FOR ITS fb_WstrDelete, as the
    '' string rows above already did. EmitRtl alone dropped the pointer: 'print "a" &
    '' wstr( i )' leaked one allocation per run, and so did every scalar wstr( ) in a
    '' chain. Measured, fbc parks it in a TMP and deletes it after the statement.
    return WideConcatStep_( c, args, r, outv )
end function

end namespace
