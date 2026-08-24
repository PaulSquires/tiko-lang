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


'' WRITE.
''
'' One-to-one with PRINT minus SPC, TAB and USING, and it shares PRINT's mask
'' encoding -- but its ONLY separator is ',' (fbc rejects 'write s;' with error 3), so
'' the only masks it can produce are 2 for 'a comma follows' and 1 for
'' end-of-statement. A trailing comma keeps mask 2 and emits no newline.
function LowerWrite( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )

    '' 'write using' does not exist; if the parser ever marks one, decline rather
    '' than silently writing without the format.
    if sp->extra <> 0 then return false

    dim as MirValue chan
    chan.kind = cast( ubyte, MV_CONST_INT )
    chan.ty = cast( ubyte, MT_I32 )
    chan.id = 0
    if sp->a <> Tko.NODE_NONE then
        dim as MirValue ch = LowerExpr( c, sp->a )
        if ch.kind = cast( ubyte, MV_NONE ) then return false
        chan = Coerce( c, ch, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
    end if

    '' A bare 'write' is a newline on its own.
    if sp->count = 0 then
        dim as FB.Array( of ulong ) va
        va.Push( cast( ulong, chan.kind ) ) : va.Push( cast( ulong, chan.id ) )
        PushConst( va, 1 )
        EmitRtl( c, RTL_WRITE_VOID, va )
        return true
    end if

    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId it = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( it ) = Tko.N_PRINT_SEP then continue for

        '' A comma FOLLOWING this item pads to the next zone; running out of children
        '' ends the line. A trailing comma is still a pad, which is why the 2 stands
        '' whether or not anything comes after it.
        dim as long mask = 1
        if i + 1 < sp->count then
            if c.ast->Kind( cast( Tko.NodeId, c.ast->children[sp->first + i + 1] ) ) = _
               Tko.N_PRINT_SEP then
                mask = 2
            end if
        end if

        if WriteOne_( c, it, mask, chan ) = false then return false
    next
    return true
end function

private function WriteOne_ _
    ( byref c as Ctx, byval it as Tko.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean

    dim as Tko.TypeId t = c.info->TypeOf_( it )
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, chan.kind ) ) : args.Push( cast( ulong, chan.id ) )

    if IsWideString_( c, t ) then
        dim as MirValue wa = LowerAddr( c, it )
        if wa.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, wa.kind ) ) : args.Push( cast( ulong, wa.id ) )
        PushConst( args, mask )
        EmitRtl( c, RTL_WRITE_WSTR, args )
        return true
    end if

    '' A string RVALUE -- 'write trim( s )' -- before the type test, for the same
    '' reason PRINT does it: Check types those calls as STRING, so the test below
    '' catches them and then LowerAddr on a call fails.
    dim as MirValue srv
    if LowerStrRvalue( c, it, srv ) then
        args.Push( cast( ulong, srv.kind ) ) : args.Push( cast( ulong, srv.id ) )
        PushConst( args, mask )
        EmitRtl( c, RTL_WRITE_STRING, args )
        return true
    end if

    if IsStringType( c, t ) then
        dim as MirValue desc
        if c.ast->Kind( it ) = Tko.N_STRING_LIT then
            dim as string litText = StringLitText_( c, it )
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
        EmitRtl( c, RTL_WRITE_STRING, args )
        return true
    end if

    if t = Tko.TYPE_NONE then t = IifArmType_( c, it )
    dim as RtlId which = WriteRtlFor_( c, t )
    if which = RTL_NONE then return false
    dim as MirValue v = LowerExpr( c, it )
    if v.kind = cast( ubyte, MV_NONE ) then return false
    v = Coerce( c, v, LowerType( t, *c.types ) )
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    PushConst( args, mask )
    EmitRtl( c, which, args )
    return true
end function

'' The WRITE entry point for a type. The same per-width family PRINT has, including
'' the target-dependent rows: a POINTER and an INTEGER are 64-bit on win64 and 32-bit
'' on win32, and fbc picks a different entry accordingly.
private function WriteRtlFor_( byref c as Ctx, byval t as Tko.TypeId ) as RtlId
    if t = Tko.TYPE_NONE then return RTL_NONE
    select case c.types->Kind( t )
    case Tko.TK_POINTER, Tko.TK_PROC
        if c.types->target.pointerBits = 32 then return RTL_WRITE_UINT
        return RTL_WRITE_ULONGINT
    case Tko.TK_ENUM
        if c.types->target.pointerBits = 32 then return RTL_WRITE_INT
        return RTL_WRITE_LONGINT
    case Tko.TK_BUILTIN
        select case c.types->BuiltinOf( t )
        case Tko.TY_BYTE      : return RTL_WRITE_BYTE
        case Tko.TY_UBYTE     : return RTL_WRITE_UBYTE
        case Tko.TY_SHORT     : return RTL_WRITE_SHORT
        case Tko.TY_USHORT    : return RTL_WRITE_USHORT
        case Tko.TY_LONG      : return RTL_WRITE_INT
        case Tko.TY_ULONG     : return RTL_WRITE_UINT
        case Tko.TY_LONGINT   : return RTL_WRITE_LONGINT
        case Tko.TY_ULONGINT  : return RTL_WRITE_ULONGINT
        case Tko.TY_SINGLE    : return RTL_WRITE_SINGLE
        case Tko.TY_DOUBLE    : return RTL_WRITE_DOUBLE
        case Tko.TY_BOOLEAN   : return RTL_WRITE_BOOL
        case Tko.TY_INTEGER
            if c.types->target.pointerBits = 32 then return RTL_WRITE_INT
            return RTL_WRITE_LONGINT
        case Tko.TY_UINTEGER
            if c.types->target.pointerBits = 32 then return RTL_WRITE_UINT
            return RTL_WRITE_ULONGINT
        end select
    end select
    return RTL_NONE
end function


'' POKE.
''
'' Not a runtime call: a typed STORE through an address. Measured --
''
''     poke byte, @p, 5     P$0 = (int8)5;
''     poke integer, @p, 7  P$0 = 7ll;
''     poke @p, 3           P$0 = (uint8)3u;      the two-argument form is UBYTE
''
'' The named type is a TYPEREF argument, not an expression, which is what makes the
'' two forms tell apart: three arguments means the first is the type.
function LowerPoke( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if (sp->count < 2) orelse (sp->count > 3) then return false

    '' The TYPE ARGUMENT arrives as an N_IDENT, not an N_TYPEREF: the intrinsic
    '' argument parser reads every argument as an expression, and 'byte' is a keyword
    '' that parses as a name. So it is matched by SPELLING here rather than by node
    '' kind, which is what a type-kind test would have got wrong.
    dim as long base_ = sp->first
    dim as Tko.TypeId dt = c.types->Builtin( Tko.TY_UBYTE )
    if sp->count = 3 then
        dim as Tko.BuiltinType b = _
            PokeTypeName_( c, cast( Tko.NodeId, c.ast->children[base_] ) )
        if b = Tko.TY_NONE then return false
        dt = c.types->Builtin( b )
        base_ += 1
    end if

    dim as MirType mt = LowerType( dt, *c.types )
    if (mt = MT_VOID) orelse (mt = MT_AGG) then return false

    dim as MirValue addr = LowerExpr( c, cast( Tko.NodeId, c.ast->children[base_] ) )
    if addr.kind = cast( ubyte, MV_NONE ) then return false
    dim as Tko.NodeId vn = cast( Tko.NodeId, c.ast->children[base_ + 1] )
    dim as MirValue val = LowerExpr( c, vn )
    if val.kind = cast( ubyte, MV_NONE ) then return false
    val = Coerce( c, val, mt, IsUnsignedType( c, c.info->TypeOf_( vn ) ) )

    '' THE DESTINATION MUST BE A POINTER VALUE, not a slot. In this IR 'store @p, v'
    '' means 'into the slot p' and 'store %t, v' means 'through the pointer in %t' --
    '' and '@p' lowers to the slot reference. Materialising it through a zero-offset
    '' field address is the same idiom the wide-string code uses to turn a base into a
    '' pointer temp. Without it 'poke byte, @p, 5' stored an i8 INTO an i64 slot, which
    '' the verifier caught.
    dim as MirValue dst = addr
    if (dst.kind = cast( ubyte, MV_LOCAL )) orelse (dst.kind = cast( ubyte, MV_GLOBAL )) then
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = addr
        fa.imm = 0
        dst = Emit( c, fa )
        if dst.kind = cast( ubyte, MV_NONE ) then return false
    end if

    dim as MirInst st
    st.op = cast( ushort, M_STORE )
    st.ty = cast( ubyte, MT_VOID )
    st.a = dst
    st.b = val
    Emit( c, st )
    return true
end function

'' The BUILTIN named by a POKE's or PEEK's type argument. Only the fixed-width scalars
'' can be poked, which is what fbc accepts.
private function PokeTypeName_ _
    ( byref c as Ctx, byval n as Tko.NodeId ) as Tko.BuiltinType

    if c.ast->Kind( n ) <> Tko.N_IDENT then return Tko.TY_NONE
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )]
    select case Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
    case "byte"     : return Tko.TY_BYTE
    case "ubyte"    : return Tko.TY_UBYTE
    case "short"    : return Tko.TY_SHORT
    case "ushort"   : return Tko.TY_USHORT
    case "long"     : return Tko.TY_LONG
    case "ulong"    : return Tko.TY_ULONG
    case "integer"  : return Tko.TY_INTEGER
    case "uinteger" : return Tko.TY_UINTEGER
    case "longint"  : return Tko.TY_LONGINT
    case "ulongint" : return Tko.TY_ULONGINT
    case "single"   : return Tko.TY_SINGLE
    case "double"   : return Tko.TY_DOUBLE
    end select
    return Tko.TY_NONE
end function


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
    dim as MirValue dst = LowerAddr( c, dstE )
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) args

    '' A WIDE destination takes the wide pair, and only a wide source.
    if IsWideString_( c, dt ) then
        if IsWideString_( c, c.info->TypeOf_( srcE ) ) = false then return false
        dim as MirValue wsrc = LowerAddr( c, srcE )
        if wsrc.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
        args.Push( cast( ulong, wsrc.kind ) ) : args.Push( cast( ulong, wsrc.id ) )
        EmitRtl( c, iif( isRight, RTL_WSTR_RSET, RTL_WSTR_LSET ), args )
        return true
    end if

    '' A ZSTRING destination borrows a temporary descriptor over its own bytes.
    dim as longint zn
    dim as long dk = StrSwapKind_( c, dt, zn )
    if dk = 1 then
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, dst.kind ) ) : ta.Push( cast( ulong, dst.id ) )
        dst = EmitRtl( c, RTL_STR_TEMPZ_NOLEN, ta )
        if dst.kind = cast( ubyte, MV_NONE ) then return false
    elseif dk <> 0 then
        return false
    end if

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
    return RTL_PRINT_STRING
end function

function PrintOne _
    ( byref c as Ctx, byval it as Tko.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean

    '' SPC and TAB are POSITIONING items, not values: they take no mask and print
    '' nothing themselves, so they are recognised before anything asks for a type.
    if LowerPrintPos( c, it, chan ) then return true

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
    dim as longint fpn
    if StrSwapKind_( c, t, fpn ) = 3 then
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
        dim as boolean isCallish = (c.ast->Kind( it ) = Tko.N_CALL) orelse _
                                   (c.ast->Kind( it ) = Tko.N_IDENT)
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
    v = Coerce( c, v, LowerType( t, *c.types ) )
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
        chan = Coerce( c, ch, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
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
            pv = Coerce( c, p0, zt, IsUnsignedType( c, c.info->TypeOf_( posN ) ) )
        end if
    end if

    '' The DESTINATION is written through, so its address and its size in bytes. A
    '' var-length string is a descriptor and takes the other entry point entirely.
    dim as Tko.TypeId vt = c.info->TypeOf_( varN )
    if vt = Tko.TYPE_NONE then return false
    if IsStringType( c, vt ) then return false
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

    '' THE FILENAME IS A DESCRIPTOR POINTER whatever it was spelled as -- a variable, a
    '' literal, a concatenation. fb_FileOpen takes FBSTRING*, not the (ptr, len) pair
    '' most of the string runtime wants.
    dim as MirValue fn
    if StrDescriptorOf_( c, sp->a, fn ) = false then return false

    dim as MirValue num = LowerExpr( c, sp->b )
    if num.kind = cast( ubyte, MV_NONE ) then return false
    num = Coerce( c, num, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->b ) ) )
    if num.kind = cast( ubyte, MV_NONE ) then return false

    '' The record length, or 0 -- NOT 128. Lowered before the argument list is built so
    '' a failure declines rather than leaving half a call behind.
    dim as MirValue rl
    if sp->c <> Tko.NODE_NONE then
        rl = LowerExpr( c, sp->c )
        if rl.kind = cast( ubyte, MV_NONE ) then return false
        rl = Coerce( c, rl, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->c ) ) )
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
    if enc.kind <> cast( ubyte, MV_NONE ) then
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
        fn = Coerce( c, fn, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
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
    case Tko.TY_UBYTE, Tko.TY_BOOLEAN : return RTL_INPUT_UBYTE
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
        chan = Coerce( c, ch, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
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
