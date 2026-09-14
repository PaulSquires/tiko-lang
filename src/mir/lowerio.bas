'' lowerio.bas -- the FILE and CONSOLE statements: WRITE, POKE, PEEK, LSET, RSET,
'' PRINT's per-item lowering, OPEN, and the INPUT family.
''
'' Each is one runtime call or one store, with the shape MEASURED from fbc rather than
'' assumed from the keyword. INPUT and LINE INPUT moved here from lowerstr.bas when
'' that file passed the 1500-line cap: they are I/O that happens to produce a string,
'' and nothing about them changed in the move.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko

declare function PokeTypeName_ _
    ( byref c as Ctx, byval n as Tko.NodeId ) as Tko.BuiltinType
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long
declare function WriteRtlFor_( byref c as Ctx, byval t as Tko.TypeId ) as RtlId
declare function WriteOne_ _
    ( byref c as Ctx, byval it as Tko.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean
'' WRITE -- the statement and its per-type entry points -- split out at the
'' 1500-line cap and INCLUDED here, inside the same namespace. Nothing moved
'' changed in the move.
#include once "mir/lowerwrite.bas"



#include once "mir/lowerpeekpoke.bas"


'' One two-operand instruction, emitted and handed back as a value.
private function EmitBin_ _
    ( byref c as Ctx, byval op as MirOp, byval ty as MirType, _
      byref a as MirValue, byref b as MirValue ) as MirValue

    dim as MirInst ins
    ins.op = cast( ushort, op )
    ins.ty = cast( ubyte, ty )
    ins.a = a
    ins.b = b
    return Emit( c, ins )
end function

'' BIT / BITSET / BITRESET -- three expressions over one bit, and none of them a call.
''
'' Measured, over a LONG and over a UBYTE alike -- fbc widens the operand to LONGINT
'' and keeps it there, and masks the index with 63 whatever the operand's width:
''
''   bit( c, j )        (int64)-((C$0 & (1ll << (J$0 & 63ll))) != 0ll)
''   bitset( c, j )     C$0 | (1ll << (J$0 & 63ll))
''   bitreset( c, j )   C$0 & ~(1ll << (J$0 & 63ll))
''
'' BIT's result is 0 or -1, not 0 or 1: it is the NEGATED comparison, which is what
'' makes 'bit( 224, 5 ) = -1' true. Reading it as a plain mask would have given 32.
''
'' The mask is 63 even for a 32-bit operand -- measured, not assumed -- so the shift
'' is built at LONGINT width and the narrowing back, where there is one, comes from
'' the assignment around the intrinsic rather than from here.
function LowerBitOp _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->count <> 2 then return false
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr tip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( tip->name ) )
    dim as long which = 0
    select case nm
    case "bit"      : which = 1
    case "bitset"   : which = 2
    case "bitreset" : which = 3
    case else       : return false
    end select

    '' A NAME THE SOURCE DECLARED IS NOT THE INTRINSIC. fbc reserves these words, but
    '' nothing here does, so a resolved reference wins over the builtin.
    if c.info->RefOf( cp->target ) <> Tko.SYMBOL_NONE then return false

    dim as Tko.NodeId an = cast( Tko.NodeId, c.ast->children[cp->first] )
    dim as Tko.NodeId bn = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
    dim as MirValue av = LowerExpr( c, an )
    if av.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue bv = LowerExpr( c, bn )
    if bv.kind = cast( ubyte, MV_NONE ) then return false
    av = CoerceTy( c, av, MT_I64, c.info->TypeOf_( an ))
    bv = CoerceTy( c, bv, MT_I64, c.info->TypeOf_( bn ))

    dim as MirValue k63
    k63.kind = cast( ubyte, MV_CONST_INT )
    k63.ty = cast( ubyte, MT_I64 )
    k63.id = 63
    dim as MirValue idx = EmitBin_( c, M_AND, MT_I64, bv, k63 )
    if idx.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue one
    one.kind = cast( ubyte, MV_CONST_INT )
    one.ty = cast( ubyte, MT_I64 )
    one.id = 1
    dim as MirValue mask = EmitBin_( c, M_SHL, MT_I64, one, idx )
    if mask.kind = cast( ubyte, MV_NONE ) then return false

    if which = 2 then
        outv = EmitBin_( c, M_OR, MT_I64, av, mask )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if which = 3 then
        dim as MirInst nt
        nt.op = cast( ushort, M_NOT )
        nt.ty = cast( ubyte, MT_I64 )
        nt.a = mask
        dim as MirValue inv = Emit( c, nt )
        if inv.kind = cast( ubyte, MV_NONE ) then return false
        outv = EmitBin_( c, M_AND, MT_I64, av, inv )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    dim as MirValue got = EmitBin_( c, M_AND, MT_I64, av, mask )
    if got.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue zero
    zero.kind = cast( ubyte, MV_CONST_INT )
    zero.ty = cast( ubyte, MT_I64 )
    zero.id = 0
    dim as MirValue ne = EmitBin_( c, M_ICMP_NE, MT_I64, got, zero )
    if ne.kind = cast( ubyte, MV_NONE ) then return false
    '' 0 or -1, which is the NEGATION of the 0-or-1 comparison.
    dim as MirInst ng
    ng.op = cast( ushort, M_NEG )
    ng.ty = cast( ubyte, MT_I64 )
    ng.a = ne
    outv = Emit( c, ng )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

#include once "mir/lowerstrintr.bas"



'' LSET and RSET -- pad or truncate a string INTO a destination that already has
'' storage.
''
'' Measured, and the destination's kind picks both the entry point and what has to
'' happen to the source first:
''
''     lset s1 = s2    fb_StrLset( &S1, &S2 )
''     lset z  = s2    vr = fb_StrAllocTempDescZ( Z ) : fb_StrLset( vr, &S2 )
''     lset w  = w2    fb_WstrLset( W, W2 )
''
'' A ZSTRING destination is a char array with no descriptor, so it borrows a temporary
'' one -- the NO-LENGTH variant, which works the length out from the terminator.
''
'' A WIDE destination with a NARROW source needs the source converted first, and fbc
'' deletes that temporary afterwards. Not reproduced: tiko-lang does not model the wide
'' temporary's lifetime, so that pairing declines rather than leaking one per call in
'' a statement whose whole purpose is padding a fixed buffer.
function LowerLrset( byref c as Ctx, byval id as Tko.NodeId, byval isRight as boolean ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    '' The payload is ONE child -- an N_BINARY '=' -- not two. 'lset a = b' parses as
    '' an assignment expression, because that is exactly what its argument list looks
    '' like to the generic intrinsic parser.
    if sp->count < 1 then return false
    dim as Tko.NodeId asn = cast( Tko.NodeId, c.ast->children[sp->first] )
    if c.ast->Kind( asn ) <> Tko.N_BINARY then return false
    dim as Tko.BinaryPayload ptr bp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, asn )].data )]
    if cast( Tko.TokenKind, bp->op ) <> Tko.TK_EQ then return false
    dim as Tko.NodeId dstE = bp->lhs
    dim as Tko.NodeId srcE = bp->rhs

    dim as Tko.TypeId dt = c.info->TypeOf_( dstE )

    '' A UDT DESTINATION IS ITS OWN 'operator cast', and from that point the lowering is
    '' byte-identical to a plain string of the same flavour: measured, fbc calls the
    '' operator on the DESTINATION too and feeds the bare char*/uint16* it returns
    '' straight to fb_StrAllocTempDescZ or fb_WstrLset. There is no runtime entry point
    '' for the UDT and no temporary of its own.
    ''
    '' udt-zstring/lrset.bas and udt-wstring/lrset.bas are written entirely in this
    '' shape, and every one of them declined -- the destination has an address, but it
    '' is the address of a STRUCT, and passing that as a descriptor would have been
    '' worse than declining.
    dim as boolean dstIsWideRaw = false
    dim as MirValue dst
    dim as boolean dstFromCast = false
    if c.types->Kind( c.types->Unqualify( dt ) ) = Tko.TK_UDT then
        if UserCastToWide_( c, dstE, dst ) then
            dstIsWideRaw = true
            dstFromCast = true
        else
            dim as boolean narrowRaw = false
            if UserCastToStr_( c, dstE, dst, narrowRaw ) = false then return false
            if narrowRaw = false then return false
            dstFromCast = true
        end if
    else
        dst = LowerAddr( c, dstE )
    end if
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) args

    '' A WIDE destination takes the wide pair, and only a wide source -- which may
    '' itself be a UDT with a wide 'operator cast'.
    if dstIsWideRaw orelse IsWideString_( c, dt ) then
        dim as MirValue wsrc
        if IsWideString_( c, c.info->TypeOf_( srcE ) ) then
            wsrc = LowerAddr( c, srcE )
        elseif UserCastToWide_( c, srcE, wsrc ) = false then
            return false
        end if
        if wsrc.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
        args.Push( cast( ulong, wsrc.kind ) ) : args.Push( cast( ulong, wsrc.id ) )
        EmitRtl( c, iif( isRight, RTL_WSTR_RSET, RTL_WSTR_LSET ), args )
        return true
    end if

    '' A ZSTRING destination borrows a temporary descriptor over its own bytes.
    dim as longint zn
    dim as long dk = StrSwapKind_( c, dt, zn )
    '' A NARROW UDT DESTINATION IS ALREADY ITS OWN char*, so it borrows one the same
    '' way: measured, fbc wraps the operator's result in fb_StrAllocTempDescZ exactly as
    '' it wraps a zstring variable's address. StrSwapKind_ answers -1 for the UDT, which
    '' is the honest answer about the TYPE and the wrong one about the value in hand.
    if dstFromCast andalso (dstIsWideRaw = false) then dk = 1
    if dk = 1 then
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, dst.kind ) ) : ta.Push( cast( ulong, dst.id ) )
        dst = EmitRtl( c, RTL_STR_TEMPZ_NOLEN, ta )
        if dst.kind = cast( ubyte, MV_NONE ) then return false
    elseif dk = 3 then
        '' A 'string * N' DESTINATION IS NOT A DESCRIPTOR AND CANNOT BORROW ONE. It has
        '' entry points of its own that take the bytes and the TAGGED length -- measured
        '' from fbc's C, 'fb_StrLsetANA( (void*)F1, -9223372036854775800ll, S2 )', where
        '' the constant is &h8000000000000000 or N and the sign bit is the tag that says
        '' "fixed-length". Sending one through fb_StrLset instead would hand the runtime
        '' eight bytes of PADDING as a descriptor pointer.
        dim as MirValue fsrc
        if StrDescriptorOf_( c, srcE, fsrc ) = false then return false
        args.Push( cast( ulong, dst.kind ) )  : args.Push( cast( ulong, dst.id ) )
        PushStrLen_( c, args, zn )
        args.Push( cast( ulong, fsrc.kind ) ) : args.Push( cast( ulong, fsrc.id ) )
        EmitRtl( c, iif( isRight, RTL_STR_RSET_ANA, RTL_STR_LSET_ANA ), args )
        return true
    elseif (dk = 4) orelse IsUStringType( c, dt ) then
        '' A USTRING DESTINATION IS NOT AN FBSTRING. Its bytes and its TAGGED length go
        '' to fb_UStrLset, and the SOURCE is always transcoded into a fresh FBUSTRING
        '' first -- measured, 'fb_WstrToUStr( W2 )' for a wide source and
        '' 'fb_StrToUStr( Z2, 50ll )' for a narrow one, then
        '' 'fb_UStrLset( US1, <tag>, vr, -1ll )'.
        ''
        '' Without this the statement fell through to fb_StrLset and passed an FBUSTRING
        '' where an FBSTRING belongs. It lowered, it verified, and it was wrong -- the
        '' one shape here that was not a decline.
        ''
        '' A USTRING SOURCE is not legal for lset at all: fbc rejects every spelling of
        '' it with error 24, "Invalid data types", so there is nothing to model.
        if IsUStringType( c, c.info->TypeOf_( srcE ) ) then return false
        dim as MirValue uconv
        if IsWideString_( c, c.info->TypeOf_( srcE ) ) then
            dim as MirValue wp = LowerAddr( c, srcE )
            if wp.kind = cast( ubyte, MV_NONE ) then return false
            dim as FB.Array( of ulong ) wa
            wa.Push( cast( ulong, wp.kind ) ) : wa.Push( cast( ulong, wp.id ) )
            uconv = EmitRtl( c, RTL_WSTR_TO_USTR, wa )
        else
            dim as MirValue np
            dim as longint nn
            dim as long sk = StrSwapKind_( c, c.info->TypeOf_( srcE ), nn )
            if sk < 0 then return false
            np = LowerAddr( c, srcE )
            if np.kind = cast( ubyte, MV_NONE ) then return false
            dim as FB.Array( of ulong ) na
            na.Push( cast( ulong, np.kind ) ) : na.Push( cast( ulong, np.id ) )
            PushStrLen_( c, na, nn )
            uconv = EmitRtl( c, RTL_STR_TO_USTR, na )
        end if
        if uconv.kind = cast( ubyte, MV_NONE ) then return false
        '' A var-length ustring passes -1 where a fixed one passes its tag.
        dim as longint dlen = -1
        if dk = 4 then dlen = zn
        dim as FB.Array( of ulong ) ua
        ua.Push( cast( ulong, dst.kind ) ) : ua.Push( cast( ulong, dst.id ) )
        PushStrLen_( c, ua, dlen )
        ua.Push( cast( ulong, uconv.kind ) ) : ua.Push( cast( ulong, uconv.id ) )
        PushStrLen_( c, ua, -1 )
        EmitRtl( c, iif( isRight, RTL_USTR_RSET, RTL_USTR_LSET ), ua )
        return true
    elseif dk <> 0 then
        return false
    end if

    '' ...and a USTRING never reaches the narrow pair. See above.
    if IsUStringType( c, dt ) then return false

    dim as MirValue src
    if StrDescriptorOf_( c, srcE, src ) = false then return false
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    EmitRtl( c, iif( isRight, RTL_STR_RSET, RTL_STR_LSET ), args )
    return true
end function

'' One PRINT item. 'chan' is the file number, already lowered to a value by the caller
'' -- the console is 0 and 'print #n' passes n. It is the SAME argument slot either way:
'' measured from fbc's C, 'print #1, x' is 'fb_PrintInt( 1, x, 1 )' against
'' 'fb_PrintInt( 0, x, 1 )' for the console, and no other call and no other shape.
'' THE PRINT ENTRY POINT FOR A STRING ITEM, narrow or UTF-16. fbc has a separate
'' fb_PrintUStr, and sending a UTF-16 descriptor through fb_PrintString prints its
'' bytes as if they were narrow -- which lowers, verifies and prints mojibake.
private function PrintStrRtl_( byref c as Ctx, byval it as Tko.NodeId ) as RtlId
    if IsUStringType( c, c.info->TypeOf_( it ) ) then return RTL_PRINT_USTR
    '' ...AND A CONCATENATION WITH A USTRING TERM. Check types every '&' as STRING, but
    '' ConcatToTempDesc_ builds a USTRING temporary for one (ConcatTermsAreU_), so the
    '' type said narrow while the bytes were UTF-16: 'print "FAIL: " & what' printed
    '' "F A I L : ". fbc types that concatenation USTRING and calls fb_PrintUStr.
    if c.ast->Kind( it ) = Tko.N_BINARY then
        dim as FB.Array( of ulong ) pts
        FlattenConcat( c, it, pts )
        if ConcatTermsAreU_( c, pts ) then return RTL_PRINT_USTR
    end if
    return RTL_PRINT_STRING
end function

function PrintOne _
    ( byref c as Ctx, byval it as Tko.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean

    '' SPC and TAB are POSITIONING items, not values: they take no mask and print
    '' nothing themselves, so they are recognised before anything asks for a type.
    if LowerPrintPos( c, it, chan ) then return true
    '' PARENTHESES ARE NOT A VALUE. 'print "<"; (s2 & s1); ">"' hid the '&' chain the
    '' shape test below recovers a type from, so the item declined and took the rest of
    '' the statement with it -- '<' and nothing else. 47 of 48 differential-fuzz
    '' mismatches were this.
    it = Unparen_( c, it )

    dim as Tko.TypeId t = c.info->TypeOf_( it )

    '' A CONCATENATION HAS NO TYPE OF ITS OWN HERE, so it is recognised from its LEFT
    '' TERM instead: Check does not type a '&' chain, and asking the node gave nothing,
    '' so 'print w & c' fell past the wide branch to the numeric one while 'print w'
    '' beside it worked. The narrow path below already flattens a concat; only the wide
    '' one had to be told which kind of string it was looking at.
    if t = Tko.TYPE_NONE then
        if c.ast->Kind( it ) = Tko.N_BINARY then
            dim as Tko.BinaryPayload ptr cbp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, it )].data )]
            dim as Tko.TokenKind cbop = cast( Tko.TokenKind, cbp->op )
            if (cbop = Tko.TK_PLUS) orelse (cbop = Tko.TK_AMP) then
                t = c.info->TypeOf_( cbp->lhs )
            end if
        end if
    end if

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, chan.kind ) ) : args.Push( cast( ulong, chan.id ) )

    '' A WIDE STRING has its own entry point, and the same (channel, value, mask)
    '' shape as the narrow one -- fbc emits 'fb_PrintWstr( 0, (uint16*)W, 1 )'. It
    '' takes the POINTER, not a descriptor, because a wide string has none.
    '' A WIDE CONCATENATION, by SHAPE rather than by type: 'print w & c' declined
    '' while 'print w' beside it worked, because Check gives a '&' chain no type of its
    '' own and the wide test below saw nothing. WideOperand_ builds the temporary.
    '' ...and only when the chain HAS a wide term. Without that test a concatenation
    '' of two literals printed as a WIDE one, through fb_WstrConcat over the wide
    '' literal pool, because a literal answers "wide" to anything that asks.
    dim as MirValue wcc
    if ConcatHasWideTerm_( c, it ) andalso WideConcatToTemp_( c, it, wcc ) then
        args.Push( cast( ulong, wcc.kind ) ) : args.Push( cast( ulong, wcc.id ) )
        PushConst( args, mask )
        EmitRtl( c, RTL_PRINT_WSTR, args )
        return true
    end if

    '' 'print wstr( x )' -- a wide value whose TYPE is empty, because Check computes
    '' none for the call. The type test below never saw it.
    if IsWstrCall_( c, it ) then
        dim as MirValue wv
        if WideOperand_( c, it, wv ) = false then return false
        args.Push( cast( ulong, wv.kind ) ) : args.Push( cast( ulong, wv.id ) )
        PushConst( args, mask )
        EmitRtl( c, RTL_PRINT_WSTR, args )
        return true
    end if

    if IsWideString_( c, t ) then
        '' NOT ONLY AN ADDRESSABLE ONE. WideOperand_ knows every spelling a wide value
        '' takes -- a variable, 'wstr( x )', the trim family, a CONCATENATION, a literal
        '' -- and asking LowerAddr alone meant 'print w & c' declined while 'print w'
        '' beside it worked.
        dim as MirValue wa
        if WideOperand_( c, it, wa ) = false then return false
        args.Push( cast( ulong, wa.kind ) ) : args.Push( cast( ulong, wa.id ) )
        PushConst( args, mask )
        EmitRtl( c, RTL_PRINT_WSTR, args )
        return true
    end if

    '' A 'string * N' borrows a descriptor from its OWN entry point and prints through
    '' fb_PrintString like any other narrow string -- measured, fbc wraps it in
    '' fb_StrAllocTempDescF first. StrDescriptorOf_ already knows how; PRINT simply had
    '' no branch that reached it for this flavour.
    '' KIND 1 IS A ZSTRING -- 'zstring * N' and the unsized one a 'zstring ptr' points
    '' at -- and it borrows a descriptor the same way, from its own entry point.
    '' Measured: 'print *pz' is 'fb_StrAllocTempDescZ( PZ )' and then fb_PrintString.
    '' Only the fixed narrow flavour had a branch here, so every print through a
    '' zstring pointer declined.
    dim as longint fpn
    dim as long fpk = StrSwapKind_( c, t, fpn )
    if (fpk = 3) orelse (fpk = 1) then
        dim as MirValue fd
        if StrDescriptorOf_( c, it, fd ) = false then return false
        args.Push( cast( ulong, fd.kind ) ) : args.Push( cast( ulong, fd.id ) )
        PushConst( args, mask )
        EmitRtl( c, PrintStrRtl_( c, it ), args )
        return true
    end if

    '' A STRING 'iif'. Like the trim family below, this must come BEFORE the
    '' IsStringType test: Check DOES type an iif call now, so the test above catches
    '' it, LowerAddr on a call then fails, and the whole print declines. That is the
    '' SECOND time this exact ordering has bitten -- typing an expression correctly
    '' is what moves it into the type test's path.
    ''
    '' Only the STRING form is taken here. A scalar iif must fall through to the
    '' general path below -- and must NOT have been lowered on the way, because
    '' LowerIif emits an entire branch sequence and doing it twice would evaluate the
    '' arms twice. So the shape is decided from the ARM's type before anything is
    '' emitted, not from what LowerIif hands back afterwards.
    if IsStringIif_( c, it ) then
        dim as MirValue iv
        if LowerIif( c, it, MT_VOID, iv ) = false then return false
        if iv.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, iv.kind ) ) : args.Push( cast( ulong, iv.id ) )
        PushConst( args, mask )
        EmitRtl( c, PrintStrRtl_( c, it ), args )
        return true
    end if

    '' 'print trim( s )'. This must come BEFORE the IsStringType test, not after it:
    '' Check DOES type these calls as STRING, so the test above catches them, and
    '' LowerAddr on a call then fails and the whole print declines. That is exactly
    '' what happened -- 'b = trim( a )' lowered while 'print trim( a )' beside it did
    '' not, because the assignment path had the same branch in the right order.
    dim as MirValue srv
    if LowerStrRvalue( c, it, srv ) then
        args.Push( cast( ulong, srv.kind ) ) : args.Push( cast( ulong, srv.id ) )
        PushConst( args, mask )
        EmitRtl( c, PrintStrRtl_( c, it ), args )
        return true
    end if

    '' A USER OPERATOR THAT RETURNS A STRING hands back a descriptor pointer, exactly
    '' as a string-returning function does -- and it is spelled '-a' or 'a + b', so it
    '' arrives as a UNARY or a BINARY and neither the rvalue test above nor the type
    '' test below looks at one. 'print -a' over a UDT whose 'operator -' returns a
    '' string declined with the operator sitting right there; structs/ops.bas is
    '' nothing but those.
    dim as MirValue uov
    if LowerStrOperandOp_( c, it, uov ) then
        args.Push( cast( ulong, uov.kind ) ) : args.Push( cast( ulong, uov.id ) )
        PushConst( args, mask )
        EmitRtl( c, PrintStrRtl_( c, it ), args )
        return true
    end if

    if IsStringType( c, t ) then
        '' fb_PrintString takes an FBSTRING DESCRIPTOR, not a (pointer, length) pair
        '' like fb_StrAssign does. A literal has no descriptor, so fbc borrows a
        '' temporary one from the runtime and prints that:
        ''
        ''     FBSTRING* vr$4 = fb_StrAllocTempDescZEx( "lit", 3 );
        ''     fb_PrintString( 0, vr$4, 1 );
        ''
        '' Passing the literal's BYTES here instead would have the runtime read a
        '' descriptor out of string data.
        '' A CALL TO A STRING-RETURNING FUNCTION, and a BARE one used as a value.
        '' Both are string-typed and neither has an address, so LowerAddr below
        '' answered NONE and 'print f( 2 )' declined outright. StrDescriptorOf_ knows
        '' both shapes and every other one this branch would otherwise repeat.
        '' ...and ADJACENT LITERALS, which are one literal: '"a" "1"' folds to "a1"
        '' before it reaches any call, so it has a TEXT and StrDescriptorOf_ borrows a
        '' temporary descriptor over it exactly as it does for a single literal.
        '' ...AND AN INTRINSIC THAT YIELDS A STRING, which is 'input( n )' and its
        '' wide twin. It hands back a descriptor exactly as a string-returning call
        '' does -- 'FBSTRING* vr$4 = fb_FileStrInput( 2ll, 1 )' -- and StrDescriptorOf_
        '' has known that shape since it was written. Only this list did not, so
        '' 'print input( 3 )' fell through to LowerAddr, which has no address to give
        '' for an intrinsic, while 'print input( 3 ) & ""' beside it lowered through
        '' the concatenation path.
        dim as boolean isCallish = (c.ast->Kind( it ) = Tko.N_CALL) orelse _
                                   (c.ast->Kind( it ) = Tko.N_IDENT) orelse _
                                   (c.ast->Kind( it ) = Tko.N_INTRINSIC) orelse _
                                   (c.ast->Kind( it ) = Tko.N_STRCAT)
        '' ...AND A MEMBER THAT IS A PROPERTY, because that is a CALL. 'print a.first'
        '' over 'property first( ) as string' is string-typed, so this branch claimed it
        '' and then fell to LowerAddr -- whose answer for a name that resolves to a
        '' PROCEDURE is the GETTER'S CODE ADDRESS, printed as a descriptor, and an
        '' access violation. TESTED ON THE MEMBER'S OWN SYMBOL: adding N_MEMBER
        '' unconditionally made generics/generic-procptr-typearg.bas fail its ViaSlot
        '' assertion, and a hand-cut reduction of that file reads uninitialised memory
        '' and answers either way, so it was bisected against the file itself.
        if isCallish = false then
            if c.ast->Kind( it ) = Tko.N_MEMBER then
                dim as Tko.Symbol ptr pmy = c.syms->SymbolAt( c.info->RefOf( it ) )
                if pmy <> 0 then
                    if pmy->kind = cast( ubyte, Tko.SYM_PROC ) then
                        dim as Tko.NodeId ppn4 = cast( Tko.NodeId, pmy->payload )
                        if ppn4 <> Tko.NODE_NONE then
                            if c.ast->Kind( ppn4 ) = Tko.N_PROC then
                                isCallish = (StmtOf( c, ppn4 )->op = _
                                    cast( ushort, Tko.KW_PROPERTY ))
                            end if
                        end if
                    end if
                end if
            end if
        end if
        if isCallish then
            dim as MirValue cd
            if StrDescriptorOf_( c, it, cd ) then
                args.Push( cast( ulong, cd.kind ) ) : args.Push( cast( ulong, cd.id ) )
                PushConst( args, mask )
                EmitRtl( c, PrintStrRtl_( c, it ), args )
                return true
            end if
        end if

        '' A NARROW CONCATENATION has no address either: it is built in a temporary
        '' descriptor and that is what gets printed.
        dim as MirValue cat
        if ConcatToTempDesc_( c, it, cat ) then
            args.Push( cast( ulong, cat.kind ) ) : args.Push( cast( ulong, cat.id ) )
            PushConst( args, mask )
            EmitRtl( c, PrintStrRtl_( c, it ), args )
            return true
        end if
        dim as MirValue desc
        if c.ast->Kind( it ) = Tko.N_STRING_LIT then
            dim as string litText = StringLitText_( c, it )
            '' The length here is the literal's EXACT length, not the len+1 that
            '' fb_StrAssign and fb_StrConcat take. Measured: fbc passes 2 for "x" to
            '' fb_StrAssign but 3 for "lit" to fb_StrAllocTempDescZEx. The Z in the
            '' name is the difference -- it already knows the bytes are terminated,
            '' so it is not being told to include the terminator in the count.
            dim as FB.Array( of ulong ) ta
            ta.Push( cast( ulong, MV_GLOBAL ) )
            ta.Push( cast( ulong, c.m->AddStringLiteral( litText, *c.names ) ) )
            ta.Push( cast( ulong, MV_CONST_INT ) )
            ta.Push( cast( ulong, len( litText ) ) )
            desc = EmitRtl( c, RTL_STR_TEMPZ, ta )
        else
            desc = LowerAddr( c, it )
        end if
        if desc.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, desc.kind ) ) : args.Push( cast( ulong, desc.id ) )
        PushConst( args, mask )
        EmitRtl( c, PrintStrRtl_( c, it ), args )
        return true
    end if

    '' A UDT WITH 'operator cast' TO A STRING PRINTS AS ONE. The conversion is what
    '' makes it a string at all, and every other string path already tries it --
    '' assignment, concatenation, the trim family -- so 's = u' worked while 'print u'
    '' beside it declined. 270 declines in the six udt-zstring and udt-wstring corpus
    '' files, which exist to exercise exactly this type.
    if c.types->Kind( t ) = Tko.TK_UDT then
        dim as MirValue uv
        if StrDescriptorOf_( c, it, uv ) then
            args.Push( cast( ulong, uv.kind ) ) : args.Push( cast( ulong, uv.id ) )
            PushConst( args, mask )
            EmitRtl( c, PrintStrRtl_( c, it ), args )
            return true
        end if
        if WideOperand_( c, it, uv ) then
            args.Push( cast( ulong, uv.kind ) ) : args.Push( cast( ulong, uv.id ) )
            PushConst( args, mask )
            EmitRtl( c, RTL_PRINT_WSTR, args )
            return true
        end if
    end if

    '' Check computes no type for an 'iif' call, so a SCALAR iif reached here with
    '' TYPE_NONE and no entry point could be chosen -- 'print iif( c, 1, 2 )'
    '' declined while 'n = iif( c, 1, 2 )' worked. The arms carry the type.
    if t = Tko.TYPE_NONE then t = IifArmType_( c, it )

    dim as RtlId which = PrintRtlFor( c, t )
    if which = RTL_NONE then return false
    dim as MirValue v = LowerExpr( c, it )
    if v.kind = cast( ubyte, MV_NONE ) then return false

    '' A POINTER PRINTS AS AN UNSIGNED INTEGER, and it must be COERCED into one first.
    '' LowerType of a pointer is MT_PTR, so this coercion was a no-op and the ptr went
    '' into fb_PrintULongint's i64 slot unchanged: "'%t8' defined with type 'ptr' but
    '' expected 'i64'" and clang refused the module -- not a wrong number, no module at
    '' all. Measured, fbc writes the cast out: 'fb_PrintULongint( 0, (uint64)P$0, 1 )'.
    '' The width is the POINTER'S, matching the entry point PrintRtlFor chose.
    dim as MirType pty = LowerType( t, *c.types )
    if pty = MT_PTR then
        pty = MT_I64
        if c.types->target.pointerBits = 32 then pty = MT_I32
    end if
    v = Coerce( c, v, pty )
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    PushConst( args, mask )
    EmitRtl( c, which, args )
    return true
end function

'' OPEN.
''
'' Its clause words were consumed and DISCARDED by the parser, so every OPEN reached
'' lowering with no idea what it was opening the file for -- and none of them lowered.
'' Measured from fbc's own C output:
''
''     fb_FileOpen( filename, mode, access, lock, filenum, reclen )
''
'' The codes are in nodes.bi beside the field that carries them. What matters here is
'' that the clause words are ARGUMENTS, not separate entry points, so one call shape
'' covers every spelling -- and that a missing FOR is RANDOM rather than zero, which
'' the parser has already applied.
''
'' NOT DONE, and DECLINED rather than approximated:
''   ENCODING, which switches to fb_FileOpenEncod with a trailing raw char* -- a
''     different entry point, and one this inventory does not carry.
''   The DEVICE forms (CONS, ERR, SCRN, PIPE, LPT, COM), which are separate functions
''     rather than a device code.
'' As a STATEMENT the error code is discarded; as an EXPRESSION -- 'if open( f for
'' input as #1 ) <> 0' -- it is the value. One body, because they are the same call.
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
    if IsStringType( c, vt ) then
        '' NARROW ONLY: a ustring descriptor is UTF-16 and fb_FileGetStrLarge would
        '' fill it with bytes.
        if IsUStringType( c, vt ) then return false
        dim as MirValue sa = LowerAddr( c, varN )
        if sa.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) sargs
        sargs.Push( cast( ulong, chan.kind ) ) : sargs.Push( cast( ulong, chan.id ) )
        sargs.Push( cast( ulong, pv.kind ) ) : sargs.Push( cast( ulong, pv.id ) )
        sargs.Push( cast( ulong, sa.kind ) ) : sargs.Push( cast( ulong, sa.id ) )
        PushStrLen_( c, sargs, -1 )
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
        outv = EmitRtl( c, iif( isPut, RTL_FILE_PUT_STR, RTL_FILE_GET_WSTR ), wargs )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

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
            if c.types->IsDynArray( aet ) = false then
                dim as FB.Array( of ulong ) aargs
                aargs.Push( cast( ulong, chan.kind ) ) : aargs.Push( cast( ulong, chan.id ) )
                aargs.Push( cast( ulong, pv.kind ) ) : aargs.Push( cast( ulong, pv.id ) )
                aargs.Push( cast( ulong, adesc.kind ) ) : aargs.Push( cast( ulong, adesc.id ) )
                outv = EmitRtl( c, iif( isPut, RTL_FILE_PUT_ARRAY, RTL_FILE_GET_ARRAY ), aargs )
                return (outv.kind <> cast( ubyte, MV_NONE ))
            end if
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
    args.Push( cast( ulong, sv.kind ) ) : args.Push( cast( ulong, sv.id ) )
    outv = EmitRtl( c, iif( isPut, RTL_FILE_PUT, RTL_FILE_GET ), args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

function LowerOpen_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as MirValue ignored
    return LowerOpenCall_( c, id, ignored )
end function

'' A DEVICE WORD IS AN ORDINARY IDENTIFIER, and only the SYMBOL TABLE tells it from a
'' filename. Measured on fbc, both ways round:
''
''     open cons for output as #1              fb_FileOpenCons
''     dim as string cons = "t.txt"
''     open cons for output as #1              fb_FileOpen -- cons is the FILENAME
''
'' ...so the parser cannot decide this: it runs before Resolve and has no table. The
'' decision is made HERE instead, which is the stage that can ask whether the name
'' bound to anything.
''
'' ERR IS THE EXCEPTION and is reserved: 'dim as string err' is fbc error 4, so
'' 'open err' is always fb_FileOpenErr. tiko's 'err' is a KEYWORD and would never
'' reach an identifier lookup anyway -- and until this, 'open err for output' lowered
'' to fb_FileOpen taking the result of fb_ErrorGetNum AS THE FILENAME DESCRIPTOR. It
'' verified. It did not decline. That is the whole reason this was worth doing.
''
'' THREE OF THEM TAKE AN OPERAND and three do not, and both shapes reach the same
'' entry-point signature -- seven arguments, the ENCODING form's, with a NULL encoding:
''
''     open cons for output as #1          fb_FileOpenCons( ""desc,        3u,0,0, 1,0, NULL )
''     open pipe "echo hi" for input as #2 fb_FileOpenPipe( "echo hi"desc, 2u,0,0, 2,0, NULL )
''
'' The one with no operand passes an EMPTY string descriptor, not a null pointer.
private function OpenDeviceRtl_ _
    ( byref c as Ctx, byval a as Tko.NodeId ) as RtlId

    if a = Tko.NODE_NONE then return RTL_NONE
    dim as string dw = ""
    select case c.ast->Kind( a )
    case Tko.N_IDENT
        dim as Tko.IdentPayload ptr ip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, a )].data )]
        dw = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
        '' ERR IS ASKED BEFORE THE BINDING TEST, and that order is the fix rather than
        '' a detail. tiko's prelude declares 'err' as an alias for fb_ErrorGetNum, so
        '' the name DOES bind -- and 'open err for output' lowered to fb_FileOpen
        '' taking the error number's return value AS THE FILENAME DESCRIPTOR. It
        '' verified and it did not decline. fbc reserves the name ('dim as string err'
        '' is its error 4), so there is no filename it could ever be.
        if dw <> "err" then
            '' A NAME THAT BOUND IS A FILENAME. Only an UNBOUND one can be a device.
            if c.info->RefOf( a ) <> Tko.SYMBOL_NONE then return RTL_NONE
        end if
    case else
        return RTL_NONE
    end select

    select case dw
    case "cons" : return RTL_FILE_OPEN_CONS
    case "err"  : return RTL_FILE_OPEN_ERR
    case "scrn" : return RTL_FILE_OPEN_SCRN
    case "pipe" : return RTL_FILE_OPEN_PIPE
    case "lpt"  : return RTL_FILE_OPEN_LPT
    case "com"  : return RTL_FILE_OPEN_COM
    end select
    return RTL_NONE
end function

function LowerOpenCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_INTRINSIC then return false
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->op <> cast( ushort, Tko.KW_OPEN ) then return false
    if sp->a = Tko.NODE_NONE then return false
    if sp->b = Tko.NODE_NONE then return false
    '' THE ENCODING FORM IS A DIFFERENT ENTRY POINT taking a trailing char*, not an
    '' extra integer: 'fb_FileOpenEncod( f, 3u, 0u, 0u, 1, 0, (char*)"utf-16" )'. The
    '' string goes through as a DATA POINTER, by the same rule a byref zstring argument
    '' follows -- a literal's bytes, or the pointer loaded out of a descriptor -- and
    '' fbc does not validate it: 'encoding "bogus"' compiles.
    ''
    '' The encoding expression is the FIRST child: the clause loop pushes it there, and
    '' nothing else in a well-formed OPEN pushes a child before it.
    dim as MirValue enc
    if (sp->extra and Tko.OPEN_HAS_ENCODING) <> 0 then
        if sp->count < 1 then return false
        dim as Tko.NodeId en = cast( Tko.NodeId, c.ast->children[sp->first] )
        if ZstrDataOf_( c, en, enc ) = false then return false
    end if

    '' A DEVICE FORM TAKES ITS OPERAND FROM THE CHILD LIST, or an EMPTY string when
    '' none was written -- measured, 'open cons for output' passes
    '' 'fb_StrAllocTempDescZEx( "", 0 )' and not a null pointer.
    dim as RtlId devR = OpenDeviceRtl_( c, sp->a )

    '' THE FILENAME IS A DESCRIPTOR POINTER whatever it was spelled as -- a variable, a
    '' literal, a concatenation. fb_FileOpen takes FBSTRING*, not the (ptr, len) pair
    '' most of the string runtime wants.
    dim as MirValue fn
    if devR <> RTL_NONE then
        dim as Tko.NodeId opN = Tko.NODE_NONE
        if (sp->extra and Tko.OPEN_HAS_ENCODING) = 0 then
            if sp->count >= 1 then opN = cast( Tko.NodeId, c.ast->children[sp->first] )
        end if
        if opN <> Tko.NODE_NONE then
            if StrDescriptorOf_( c, opN, fn ) = false then return false
        else
            dim as FB.Array( of ulong ) ea
            ea.Push( cast( ulong, MV_GLOBAL ) )
            ea.Push( cast( ulong, c.m->AddStringLiteral( "", *c.names ) ) )
            ea.Push( cast( ulong, MV_CONST_INT ) ) : ea.Push( 0 )
            fn = EmitRtl( c, RTL_STR_TEMPZ, ea )
        end if
        if fn.kind = cast( ubyte, MV_NONE ) then return false
    else
        if StrDescriptorOf_( c, sp->a, fn ) = false then return false
    end if

    dim as MirValue num = LowerExpr( c, sp->b )
    if num.kind = cast( ubyte, MV_NONE ) then return false
    num = CoerceTy( c, num, MT_I32, c.info->TypeOf_( sp->b ))
    if num.kind = cast( ubyte, MV_NONE ) then return false

    '' The record length, or 0 -- NOT 128. Lowered before the argument list is built so
    '' a failure declines rather than leaving half a call behind.
    dim as MirValue rl
    if sp->c <> Tko.NODE_NONE then
        rl = LowerExpr( c, sp->c )
        if rl.kind = cast( ubyte, MV_NONE ) then return false
        rl = CoerceTy( c, rl, MT_I32, c.info->TypeOf_( sp->c ))
        if rl.kind = cast( ubyte, MV_NONE ) then return false
    else
        rl = ConstInt( c, 0, MT_I32 )
    end if

    dim as MirValue md = ConstInt( c, cast( longint, sp->extra and Tko.OPEN_MODE_MASK ), MT_I32 )
    dim as MirValue ac = ConstInt( c, cast( longint, _
        (sp->extra and Tko.OPEN_ACCESS_MASK) shr Tko.OPEN_ACCESS_SHIFT ), MT_I32 )
    dim as MirValue lk = ConstInt( c, cast( longint, _
        (sp->extra and Tko.OPEN_LOCK_MASK) shr Tko.OPEN_LOCK_SHIFT ), MT_I32 )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, fn.kind ) ) : args.Push( cast( ulong, fn.id ) )
    args.Push( cast( ulong, md.kind ) ) : args.Push( cast( ulong, md.id ) )
    args.Push( cast( ulong, ac.kind ) ) : args.Push( cast( ulong, ac.id ) )
    args.Push( cast( ulong, lk.kind ) ) : args.Push( cast( ulong, lk.id ) )
    args.Push( cast( ulong, num.kind ) ) : args.Push( cast( ulong, num.id ) )
    args.Push( cast( ulong, rl.kind ) ) : args.Push( cast( ulong, rl.id ) )
    if devR <> RTL_NONE then
        '' SEVEN ARGUMENTS, the ENCODING form's, with a NULL encoding pointer -- measured
        '' on all six: 'fb_FileOpenCons( ""desc, 3u, 0u, 0u, 1, 0, (char*)0ull )'.
        dim as MirValue nul = ConstInt( c, 0, MT_PTR )
        args.Push( cast( ulong, nul.kind ) ) : args.Push( cast( ulong, nul.id ) )
        outv = EmitRtl( c, devR, args )
    elseif enc.kind <> cast( ubyte, MV_NONE ) then
        args.Push( cast( ulong, enc.kind ) ) : args.Push( cast( ulong, enc.id ) )
        outv = EmitRtl( c, RTL_FILE_OPEN_ENCOD, args )
    else
        outv = EmitRtl( c, RTL_FILE_OPEN, args )
    end if
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


'' LINE INPUT, in its four entry points.
''
'' Measured, and the split is not where the keyword suggests. A WIDE destination is a
'' DIFFERENT FUNCTION rather than a flag -- tiko-lang was sending one through the narrow one,
'' which reads bytes into a uint16 buffer -- and the CONSOLE form is different again,
'' taking a prompt descriptor and two trailing flags the file form has not got:
''
''   line input #1, s        fb_FileLineInput( 1, &S, -1ll, 0 )
''   line input #1, fw       fb_FileLineInputWstr( 1, FW, 20ll )
''   line input "", s        fb_LineInput( vr, &S, -1ll, 0, 0, -1 )
''   line input "", fw       fb_LineInputWstr( (uint16*)L"", FW, 20ll, 0, -1 )
''
'' THE LENGTH IS THE WRITTEN MAXIMUM WHEN THERE IS ONE. 'line input #1, *z, 10' passes
'' 10 -- an unsized zstring has no length of its own, so without the extra argument the
'' runtime would be told 0.
''
'' A LEADING ';' -- 'line input; "", s' -- makes the last argument 0 rather than -1:
'' the runtime does not echo the newline.
function LowerLineInput( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->count < 1 then return false

    '' WHICH CHILD IS THE DESTINATION depends on the form. With a file number the
    '' first one is; without, a second child means the FIRST was a prompt -- 'line
    '' input ps, s' -- which the parser cannot tell from a second destination because
    '' plain INPUT takes a list and LINE INPUT never does.
    dim as long dstIdx = 0
    dim as Tko.NodeId prompt = sp->c
    if sp->a = Tko.NODE_NONE then
        if (prompt = Tko.NODE_NONE) andalso (sp->count >= 2) then
            prompt = cast( Tko.NodeId, c.ast->children[sp->first] )
            dstIdx = 1
        end if
    end if
    if dstIdx >= sp->count then return false

    dim as Tko.NodeId dst = cast( Tko.NodeId, c.ast->children[sp->first + dstIdx] )
    dim as Tko.TypeId dt = c.info->TypeOf_( dst )
    dim as longint dlen
    dim as long dk = StrSwapKind_( c, dt, dlen )
    if dk < 0 then return false
    dim as boolean wide = (dk = 2)

    dim as MirValue da = LowerAddr( c, dst )
    if da.kind = cast( ubyte, MV_NONE ) then return false

    '' The explicit maximum, when one was written.
    dim as MirValue mx
    if dstIdx + 1 < sp->count then
        dim as Tko.NodeId mn = cast( Tko.NodeId, c.ast->children[sp->first + dstIdx + 1] )
        mx = LowerExpr( c, mn )
        if mx.kind = cast( ubyte, MV_NONE ) then return false
        mx = Coerce( c, mx, iif( c.types->target.pointerBits = 32, MT_I32, MT_I64 ), false )
    end if

    dim as FB.Array( of ulong ) args
    if sp->a <> Tko.NODE_NONE then
        dim as MirValue fn = LowerExpr( c, sp->a )
        if fn.kind = cast( ubyte, MV_NONE ) then return false
        fn = CoerceTy( c, fn, MT_I32, c.info->TypeOf_( sp->a ))
        args.Push( cast( ulong, fn.kind ) ) : args.Push( cast( ulong, fn.id ) )
    else
        '' THE PROMPT IS A DESCRIPTOR on the narrow path and a uint16* on the wide one,
        '' and an absent prompt is the EMPTY STRING rather than a null pointer.
        dim as MirValue pv
        if wide then
            if prompt = Tko.NODE_NONE then
                pv.kind = cast( ubyte, MV_GLOBAL )
                pv.ty = cast( ubyte, MT_PTR )
                pv.id = c.m->AddWideStringLiteral( "", *c.names )
            elseif WideOperand_( c, prompt, pv ) = false then
                '' A NARROW prompt on the wide path is CONVERTED, not refused: fbc
                '' emits fb_StrToWstr over its data pointer and deletes the result.
                if NarrowToWideTemp_( c, prompt, pv ) = false then return false
            end if
        else
            if prompt = Tko.NODE_NONE then
                dim as FB.Array( of ulong ) ea
                ea.Push( cast( ulong, MV_GLOBAL ) )
                ea.Push( cast( ulong, c.m->AddStringLiteral( "", *c.names ) ) )
                ea.Push( cast( ulong, MV_CONST_INT ) )
                ea.Push( 0 )
                pv = EmitRtl( c, RTL_STR_TEMPZ, ea )
            elseif StrDescriptorOf_( c, prompt, pv ) = false then
                '' A WIDE prompt with a narrow destination, which the corpus's syntax
                '' test writes twenty times: fbc converts it into a real descriptor.
                if WideToNarrowTemp_( c, prompt, pv ) = false then return false
            end if
        end if
        if pv.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, pv.kind ) ) : args.Push( cast( ulong, pv.id ) )
    end if

    args.Push( cast( ulong, da.kind ) ) : args.Push( cast( ulong, da.id ) )
    if mx.kind <> cast( ubyte, MV_NONE ) then
        args.Push( cast( ulong, mx.kind ) ) : args.Push( cast( ulong, mx.id ) )
    else
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dlen ) )
    end if

    if sp->a <> Tko.NODE_NONE then
        if wide then
            EmitRtl( c, RTL_FILE_LINEINPUT_W, args )
        else
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
            EmitRtl( c, RTL_FILE_LINEINPUT, args )
        end if
        return true
    end if

    '' The console form's trailing flags: a reserved 0 the narrow one has twice, then
    '' the newline flag, which the leading ';' turns off.
    dim as long addNewline = -1
    if (sp->extra and 4) <> 0 then addNewline = 0
    if wide = false then
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    end if
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, addNewline ) )
    if wide then
        EmitRtl( c, RTL_LINEINPUT_W, args )
    else
        EmitRtl( c, RTL_LINEINPUT, args )
    end if
    return true
end function

'' The runtime entry point for reading ONE destination of a given type.
private function InputRtlFor _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as RtlId

    n = -1
    if t = Tko.TYPE_NONE then return RTL_NONE
    if IsWideString_( c, t ) then
        n = WideStringElems( c, t )
        return RTL_INPUT_WSTR
    end if
    dim as longint zn
    dim as long sk = StrSwapKind_( c, t, zn )
    if sk = 0 then return RTL_INPUT_STRING
    if sk = 1 then
        n = zn
        return RTL_INPUT_STRING
    end if
    if c.types->Kind( t ) <> Tko.TK_BUILTIN then return RTL_NONE
    select case c.types->BuiltinOf( t )
    case Tko.TY_BYTE      : return RTL_INPUT_BYTE
    case Tko.TY_UBYTE     : return RTL_INPUT_UBYTE
    '' A BOOLEAN READS THE WORD, not a byte: fbc has fb_InputBool for it, which
    '' parses "true" the way fb_VALBOOL does. Sharing the UBYTE row read a NUMBER,
    '' so a file holding "true" gave 0 -- the same mistake cbool over a string made.
    case Tko.TY_BOOLEAN   : return RTL_INPUT_BOOL
    case Tko.TY_SHORT     : return RTL_INPUT_SHORT
    case Tko.TY_USHORT    : return RTL_INPUT_USHORT
    case Tko.TY_LONG      : return RTL_INPUT_INT
    case Tko.TY_ULONG     : return RTL_INPUT_UINT
    case Tko.TY_INTEGER, Tko.TY_LONGINT   : return RTL_INPUT_LONGINT
    case Tko.TY_UINTEGER, Tko.TY_ULONGINT : return RTL_INPUT_ULONGINT
    case Tko.TY_SINGLE    : return RTL_INPUT_SINGLE
    case Tko.TY_DOUBLE    : return RTL_INPUT_DOUBLE
    end select
    return RTL_NONE
end function

'' A PROMPT DESCRIPTOR. fbc always passes one, borrowed from the runtime, and an
'' ABSENT prompt is the empty string rather than a null pointer.
private function InputPrompt( byref c as Ctx, byval promptE as Tko.NodeId ) as MirValue
    '' NOT named 'text': inside namespace Tko.Mir that resolves to the Tko.Text
    '' NAMESPACE, and the error it produces names a period rather than the collision.
    dim as string ptext = ""
    if promptE <> Tko.NODE_NONE then
        if c.ast->Kind( promptE ) = Tko.N_STRING_LIT then
            ptext = StringLitText_( c, promptE )
        end if
    end if
    dim as FB.Array( of ulong ) ta
    ta.Push( cast( ulong, MV_GLOBAL ) )
    ta.Push( cast( ulong, c.m->AddStringLiteral( ptext, *c.names ) ) )
    ta.Push( cast( ulong, MV_CONST_INT ) )
    ta.Push( cast( ulong, len( ptext ) ) )
    return EmitRtl( c, RTL_STR_TEMPZ, ta )
end function

'' INPUT and LINE INPUT.
''
'' Measured from fbc. INPUT is a START call and then one call per destination, each
'' passed BY ADDRESS:
''
''     fb_ConsoleInput( promptDesc, -1, -1 );  fb_InputInt( addr )
''     fb_FileInput( 1 );                      fb_InputInt( addr )
''
'' The two flags are addQuestionMark and echoNewline, -1 for true. A LEADING semicolon
'' clears the second.
''
'' LINE INPUT is a different shape entirely -- ONE call with the destination inside it:
''
''     fb_LineInput( promptDesc, dst, -1ll, 0, addQuestion, echoNewline )
''     fb_FileLineInput( 1, dst, -1ll, 0 )
function LowerInput _
    ( byref c as Ctx, byval id as Tko.NodeId, byval isLine as boolean ) as boolean

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )

    '' A LEADING semicolon suppresses the echoed newline. The parser marks it with
    '' bit 4, because bit 1 already meant LINE INPUT.
    dim as long echoNewline = -1
    if (sp->extra and 4) <> 0 then echoNewline = 0
    '' A comma after the prompt suppresses the question mark and a semicolon keeps it.
    '' The parser does not record which, so it is kept -- fbc's default and the
    '' commoner spelling.
    dim as long addQuestion = -1

    dim as boolean toFile = (sp->a <> Tko.NODE_NONE)
    dim as MirValue chan
    if toFile then
        dim as MirValue ch = LowerExpr( c, sp->a )
        if ch.kind = cast( ubyte, MV_NONE ) then return false
        chan = CoerceTy( c, ch, MT_I32, c.info->TypeOf_( sp->a ))
    end if

    if isLine then
        if sp->count <> 1 then return false
        dim as Tko.NodeId dst = cast( Tko.NodeId, c.ast->children[sp->first] )
        dim as longint dn
        if InputRtlFor( c, c.info->TypeOf_( dst ), dn ) = RTL_NONE then return false
        dim as MirValue da = LowerAddr( c, dst )
        if da.kind = cast( ubyte, MV_NONE ) then return false

        dim as FB.Array( of ulong ) args
        if toFile then
            args.Push( cast( ulong, chan.kind ) ) : args.Push( cast( ulong, chan.id ) )
            args.Push( cast( ulong, da.kind ) ) : args.Push( cast( ulong, da.id ) )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dn ) )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
            EmitRtl( c, RTL_FILE_LINEINPUT, args )
            return true
        end if
        dim as MirValue pr = InputPrompt( c, sp->c )
        if pr.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, pr.kind ) ) : args.Push( cast( ulong, pr.id ) )
        args.Push( cast( ulong, da.kind ) ) : args.Push( cast( ulong, da.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dn ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, addQuestion ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, echoNewline ) )
        EmitRtl( c, RTL_LINEINPUT, args )
        return true
    end if

    if sp->count = 0 then return false

    '' EVERY DESTINATION IS CHECKED FIRST. Emitting the start call and then declining
    '' on the third variable would leave the program prompting for input it never
    '' reads.
    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId d = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        dim as longint dn2
        if InputRtlFor( c, c.info->TypeOf_( d ), dn2 ) = RTL_NONE then return false
    next

    dim as FB.Array( of ulong ) sargs
    if toFile then
        sargs.Push( cast( ulong, chan.kind ) ) : sargs.Push( cast( ulong, chan.id ) )
        EmitRtl( c, RTL_FILE_INPUT, sargs )
    else
        dim as MirValue pr2 = InputPrompt( c, sp->c )
        if pr2.kind = cast( ubyte, MV_NONE ) then return false
        sargs.Push( cast( ulong, pr2.kind ) ) : sargs.Push( cast( ulong, pr2.id ) )
        sargs.Push( cast( ulong, MV_CONST_INT ) ) : sargs.Push( cast( ulong, addQuestion ) )
        sargs.Push( cast( ulong, MV_CONST_INT ) ) : sargs.Push( cast( ulong, echoNewline ) )
        EmitRtl( c, RTL_CONSOLE_INPUT, sargs )
    end if

    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId d = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        dim as longint dn3
        dim as RtlId r = InputRtlFor( c, c.info->TypeOf_( d ), dn3 )
        dim as MirValue da2 = LowerAddr( c, d )
        if da2.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) dargs
        dargs.Push( cast( ulong, da2.kind ) ) : dargs.Push( cast( ulong, da2.id ) )
        if r = RTL_INPUT_STRING then
            dargs.Push( cast( ulong, MV_CONST_INT ) ) : dargs.Push( cast( ulong, dn3 ) )
            dargs.Push( cast( ulong, MV_CONST_INT ) ) : dargs.Push( 0 )
        elseif r = RTL_INPUT_WSTR then
            dargs.Push( cast( ulong, MV_CONST_INT ) ) : dargs.Push( cast( ulong, dn3 ) )
        end if
        EmitRtl( c, r, dargs )
    next
    return true
end function

end namespace
