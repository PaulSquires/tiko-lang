'' lowerio.bas -- the FILE and CONSOLE statements: WRITE, POKE, PEEK, LSET, RSET,
'' PRINT's per-item lowering, OPEN, and the INPUT family.
''
'' Each is one runtime call or one store, with the shape MEASURED from fbc rather than
'' assumed from the keyword. INPUT and LINE INPUT moved here from lowerstr.bas when
'' that file passed the 1500-line cap: they are I/O that happens to produce a string,
'' and nothing about them changed in the move.

#include once "lowerctx.bi"

namespace Fbx.Mir

using Fbx

declare function PokeTypeName_ _
    ( byref c as Ctx, byval n as Fbx.NodeId ) as Fbx.BuiltinType
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long
declare function WriteRtlFor_( byref c as Ctx, byval t as Fbx.TypeId ) as RtlId
declare function WriteOne_ _
    ( byref c as Ctx, byval it as Fbx.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean


'' WRITE.
''
'' One-to-one with PRINT minus SPC, TAB and USING, and it shares PRINT's mask
'' encoding -- but its ONLY separator is ',' (fbc rejects 'write s;' with error 3), so
'' the only masks it can produce are 2 for 'a comma follows' and 1 for
'' end-of-statement. A trailing comma keeps mask 2 and emits no newline.
function LowerWrite( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )

    '' 'write using' does not exist; if the parser ever marks one, decline rather
    '' than silently writing without the format.
    if sp->extra <> 0 then return false

    dim as MirValue chan
    chan.kind = cast( ubyte, MV_CONST_INT )
    chan.ty = cast( ubyte, MT_I32 )
    chan.id = 0
    if sp->a <> Fbx.NODE_NONE then
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
        dim as Fbx.NodeId it = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( it ) = Fbx.N_PRINT_SEP then continue for

        '' A comma FOLLOWING this item pads to the next zone; running out of children
        '' ends the line. A trailing comma is still a pad, which is why the 2 stands
        '' whether or not anything comes after it.
        dim as long mask = 1
        if i + 1 < sp->count then
            if c.ast->Kind( cast( Fbx.NodeId, c.ast->children[sp->first + i + 1] ) ) = _
               Fbx.N_PRINT_SEP then
                mask = 2
            end if
        end if

        if WriteOne_( c, it, mask, chan ) = false then return false
    next
    return true
end function

private function WriteOne_ _
    ( byref c as Ctx, byval it as Fbx.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean

    dim as Fbx.TypeId t = c.info->TypeOf_( it )
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
        if c.ast->Kind( it ) = Fbx.N_STRING_LIT then
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

    if t = Fbx.TYPE_NONE then t = IifArmType_( c, it )
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
private function WriteRtlFor_( byref c as Ctx, byval t as Fbx.TypeId ) as RtlId
    if t = Fbx.TYPE_NONE then return RTL_NONE
    select case c.types->Kind( t )
    case Fbx.TK_POINTER, Fbx.TK_PROC
        if c.types->target.pointerBits = 32 then return RTL_WRITE_UINT
        return RTL_WRITE_ULONGINT
    case Fbx.TK_ENUM
        if c.types->target.pointerBits = 32 then return RTL_WRITE_INT
        return RTL_WRITE_LONGINT
    case Fbx.TK_BUILTIN
        select case c.types->BuiltinOf( t )
        case Fbx.TY_BYTE      : return RTL_WRITE_BYTE
        case Fbx.TY_UBYTE     : return RTL_WRITE_UBYTE
        case Fbx.TY_SHORT     : return RTL_WRITE_SHORT
        case Fbx.TY_USHORT    : return RTL_WRITE_USHORT
        case Fbx.TY_LONG      : return RTL_WRITE_INT
        case Fbx.TY_ULONG     : return RTL_WRITE_UINT
        case Fbx.TY_LONGINT   : return RTL_WRITE_LONGINT
        case Fbx.TY_ULONGINT  : return RTL_WRITE_ULONGINT
        case Fbx.TY_SINGLE    : return RTL_WRITE_SINGLE
        case Fbx.TY_DOUBLE    : return RTL_WRITE_DOUBLE
        case Fbx.TY_BOOLEAN   : return RTL_WRITE_BOOL
        case Fbx.TY_INTEGER
            if c.types->target.pointerBits = 32 then return RTL_WRITE_INT
            return RTL_WRITE_LONGINT
        case Fbx.TY_UINTEGER
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
function LowerPoke( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if (sp->count < 2) orelse (sp->count > 3) then return false

    '' The TYPE ARGUMENT arrives as an N_IDENT, not an N_TYPEREF: the intrinsic
    '' argument parser reads every argument as an expression, and 'byte' is a keyword
    '' that parses as a name. So it is matched by SPELLING here rather than by node
    '' kind, which is what a type-kind test would have got wrong.
    dim as long base_ = sp->first
    dim as Fbx.TypeId dt = c.types->Builtin( Fbx.TY_UBYTE )
    if sp->count = 3 then
        dim as Fbx.BuiltinType b = _
            PokeTypeName_( c, cast( Fbx.NodeId, c.ast->children[base_] ) )
        if b = Fbx.TY_NONE then return false
        dt = c.types->Builtin( b )
        base_ += 1
    end if

    dim as MirType mt = LowerType( dt, *c.types )
    if (mt = MT_VOID) orelse (mt = MT_AGG) then return false

    dim as MirValue addr = LowerExpr( c, cast( Fbx.NodeId, c.ast->children[base_] ) )
    if addr.kind = cast( ubyte, MV_NONE ) then return false
    dim as Fbx.NodeId vn = cast( Fbx.NodeId, c.ast->children[base_ + 1] )
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
    ( byref c as Ctx, byval n as Fbx.NodeId ) as Fbx.BuiltinType

    if c.ast->Kind( n ) <> Fbx.N_IDENT then return Fbx.TY_NONE
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )]
    select case Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )
    case "byte"     : return Fbx.TY_BYTE
    case "ubyte"    : return Fbx.TY_UBYTE
    case "short"    : return Fbx.TY_SHORT
    case "ushort"   : return Fbx.TY_USHORT
    case "long"     : return Fbx.TY_LONG
    case "ulong"    : return Fbx.TY_ULONG
    case "integer"  : return Fbx.TY_INTEGER
    case "uinteger" : return Fbx.TY_UINTEGER
    case "longint"  : return Fbx.TY_LONGINT
    case "ulongint" : return Fbx.TY_ULONGINT
    case "single"   : return Fbx.TY_SINGLE
    case "double"   : return Fbx.TY_DOUBLE
    end select
    return Fbx.TY_NONE
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
'' deletes that temporary afterwards. Not reproduced: fbx does not model the wide
'' temporary's lifetime, so that pairing declines rather than leaking one per call in
'' a statement whose whole purpose is padding a fixed buffer.
function LowerLrset( byref c as Ctx, byval id as Fbx.NodeId, byval isRight as boolean ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    '' The payload is ONE child -- an N_BINARY '=' -- not two. 'lset a = b' parses as
    '' an assignment expression, because that is exactly what its argument list looks
    '' like to the generic intrinsic parser.
    if sp->count < 1 then return false
    dim as Fbx.NodeId asn = cast( Fbx.NodeId, c.ast->children[sp->first] )
    if c.ast->Kind( asn ) <> Fbx.N_BINARY then return false
    dim as Fbx.BinaryPayload ptr bp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, asn )].data )]
    if cast( Fbx.TokenKind, bp->op ) <> Fbx.TK_EQ then return false
    dim as Fbx.NodeId dstE = bp->lhs
    dim as Fbx.NodeId srcE = bp->rhs

    dim as Fbx.TypeId dt = c.info->TypeOf_( dstE )
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
function PrintOne _
    ( byref c as Ctx, byval it as Fbx.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean

    '' SPC and TAB are POSITIONING items, not values: they take no mask and print
    '' nothing themselves, so they are recognised before anything asks for a type.
    if LowerPrintPos( c, it, chan ) then return true

    dim as Fbx.TypeId t = c.info->TypeOf_( it )

    '' A CONCATENATION HAS NO TYPE OF ITS OWN HERE, so it is recognised from its LEFT
    '' TERM instead: Check does not type a '&' chain, and asking the node gave nothing,
    '' so 'print w & c' fell past the wide branch to the numeric one while 'print w'
    '' beside it worked. The narrow path below already flattens a concat; only the wide
    '' one had to be told which kind of string it was looking at.
    if t = Fbx.TYPE_NONE then
        if c.ast->Kind( it ) = Fbx.N_BINARY then
            dim as Fbx.BinaryPayload ptr cbp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, it )].data )]
            dim as Fbx.TokenKind cbop = cast( Fbx.TokenKind, cbp->op )
            if (cbop = Fbx.TK_PLUS) orelse (cbop = Fbx.TK_AMP) then
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
        EmitRtl( c, RTL_PRINT_STRING, args )
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
        EmitRtl( c, RTL_PRINT_STRING, args )
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
        EmitRtl( c, RTL_PRINT_STRING, args )
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
        dim as boolean isCallish = (c.ast->Kind( it ) = Fbx.N_CALL) orelse _
                                   (c.ast->Kind( it ) = Fbx.N_IDENT)
        if isCallish then
            dim as MirValue cd
            if StrDescriptorOf_( c, it, cd ) then
                args.Push( cast( ulong, cd.kind ) ) : args.Push( cast( ulong, cd.id ) )
                PushConst( args, mask )
                EmitRtl( c, RTL_PRINT_STRING, args )
                return true
            end if
        end if

        '' A NARROW CONCATENATION has no address either: it is built in a temporary
        '' descriptor and that is what gets printed.
        dim as MirValue cat
        if ConcatToTempDesc_( c, it, cat ) then
            args.Push( cast( ulong, cat.kind ) ) : args.Push( cast( ulong, cat.id ) )
            PushConst( args, mask )
            EmitRtl( c, RTL_PRINT_STRING, args )
            return true
        end if
        dim as MirValue desc
        if c.ast->Kind( it ) = Fbx.N_STRING_LIT then
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
        EmitRtl( c, RTL_PRINT_STRING, args )
        return true
    end if

    '' Check computes no type for an 'iif' call, so a SCALAR iif reached here with
    '' TYPE_NONE and no entry point could be chosen -- 'print iif( c, 1, 2 )'
    '' declined while 'n = iif( c, 1, 2 )' worked. The arms carry the type.
    if t = Fbx.TYPE_NONE then t = IifArmType_( c, it )

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
function LowerOpen_( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as MirValue ignored
    return LowerOpenCall_( c, id, ignored )
end function

function LowerOpenCall_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_INTRINSIC then return false
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->op <> cast( ushort, Fbx.KW_OPEN ) then return false
    if sp->a = Fbx.NODE_NONE then return false
    if sp->b = Fbx.NODE_NONE then return false
    '' THE ENCODING FORM IS A DIFFERENT ENTRY POINT taking a trailing char*, not an
    '' extra integer: 'fb_FileOpenEncod( f, 3u, 0u, 0u, 1, 0, (char*)"utf-16" )'. The
    '' string goes through as a DATA POINTER, by the same rule a byref zstring argument
    '' follows -- a literal's bytes, or the pointer loaded out of a descriptor -- and
    '' fbc does not validate it: 'encoding "bogus"' compiles.
    ''
    '' The encoding expression is the FIRST child: the clause loop pushes it there, and
    '' nothing else in a well-formed OPEN pushes a child before it.
    dim as MirValue enc
    if (sp->extra and Fbx.OPEN_HAS_ENCODING) <> 0 then
        if sp->count < 1 then return false
        dim as Fbx.NodeId en = cast( Fbx.NodeId, c.ast->children[sp->first] )
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
    if sp->c <> Fbx.NODE_NONE then
        rl = LowerExpr( c, sp->c )
        if rl.kind = cast( ubyte, MV_NONE ) then return false
        rl = Coerce( c, rl, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->c ) ) )
        if rl.kind = cast( ubyte, MV_NONE ) then return false
    else
        rl = ConstInt( c, 0, MT_I32 )
    end if

    dim as MirValue md = ConstInt( c, cast( longint, sp->extra and Fbx.OPEN_MODE_MASK ), MT_I32 )
    dim as MirValue ac = ConstInt( c, cast( longint, _
        (sp->extra and Fbx.OPEN_ACCESS_MASK) shr Fbx.OPEN_ACCESS_SHIFT ), MT_I32 )
    dim as MirValue lk = ConstInt( c, cast( longint, _
        (sp->extra and Fbx.OPEN_LOCK_MASK) shr Fbx.OPEN_LOCK_SHIFT ), MT_I32 )

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


'' LINE INPUT #n, dst -- read a whole line from a file into a string.
''
'' Measured from fbc's C:
''
''     fb_FileLineInput( 1, (void*)&S$0, -1ll, 0 );      dst is a STRING
''     fb_FileLineInput( 1, (void*)Z$0,   8ll, 0 );      dst is a ZSTRING * 8
''
'' Same (pointer, length) convention as the swap runtime: -1 for a var-length string
'' and the element count for a fixed one. The fourth argument is 0 in every form fbc
'' emits here.
''
'' The CONSOLE form -- 'line input s', with or without a prompt -- is a different entry
'' point (fb_LineInput, six arguments including a prompt descriptor) and still declines.
function LowerLineInput( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->a = Fbx.NODE_NONE then return false      '' console form
    if sp->c <> Fbx.NODE_NONE then return false     '' a prompt: console form only
    if sp->count <> 1 then return false

    dim as Fbx.NodeId dst = cast( Fbx.NodeId, c.ast->children[sp->first] )
    dim as longint dlen
    if StrSwapKind_( c, c.info->TypeOf_( dst ), dlen ) < 0 then return false

    dim as MirValue fn = LowerExpr( c, sp->a )
    if fn.kind = cast( ubyte, MV_NONE ) then return false
    fn = Coerce( c, fn, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
    dim as MirValue da = LowerAddr( c, dst )
    if da.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, fn.kind ) ) : args.Push( cast( ulong, fn.id ) )
    args.Push( cast( ulong, da.kind ) ) : args.Push( cast( ulong, da.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dlen ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_FILE_LINEINPUT, args )
    return true
end function

'' The runtime entry point for reading ONE destination of a given type.
private function InputRtlFor _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as RtlId

    n = -1
    if t = Fbx.TYPE_NONE then return RTL_NONE
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
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return RTL_NONE
    select case c.types->BuiltinOf( t )
    case Fbx.TY_BYTE      : return RTL_INPUT_BYTE
    case Fbx.TY_UBYTE, Fbx.TY_BOOLEAN : return RTL_INPUT_UBYTE
    case Fbx.TY_SHORT     : return RTL_INPUT_SHORT
    case Fbx.TY_USHORT    : return RTL_INPUT_USHORT
    case Fbx.TY_LONG      : return RTL_INPUT_INT
    case Fbx.TY_ULONG     : return RTL_INPUT_UINT
    case Fbx.TY_INTEGER, Fbx.TY_LONGINT   : return RTL_INPUT_LONGINT
    case Fbx.TY_UINTEGER, Fbx.TY_ULONGINT : return RTL_INPUT_ULONGINT
    case Fbx.TY_SINGLE    : return RTL_INPUT_SINGLE
    case Fbx.TY_DOUBLE    : return RTL_INPUT_DOUBLE
    end select
    return RTL_NONE
end function

'' A PROMPT DESCRIPTOR. fbc always passes one, borrowed from the runtime, and an
'' ABSENT prompt is the empty string rather than a null pointer.
private function InputPrompt( byref c as Ctx, byval promptE as Fbx.NodeId ) as MirValue
    '' NOT named 'text': inside namespace Fbx.Mir that resolves to the Fbx.Text
    '' NAMESPACE, and the error it produces names a period rather than the collision.
    dim as string ptext = ""
    if promptE <> Fbx.NODE_NONE then
        if c.ast->Kind( promptE ) = Fbx.N_STRING_LIT then
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
    ( byref c as Ctx, byval id as Fbx.NodeId, byval isLine as boolean ) as boolean

    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )

    '' A LEADING semicolon suppresses the echoed newline. The parser marks it with
    '' bit 4, because bit 1 already meant LINE INPUT.
    dim as long echoNewline = -1
    if (sp->extra and 4) <> 0 then echoNewline = 0
    '' A comma after the prompt suppresses the question mark and a semicolon keeps it.
    '' The parser does not record which, so it is kept -- fbc's default and the
    '' commoner spelling.
    dim as long addQuestion = -1

    dim as boolean toFile = (sp->a <> Fbx.NODE_NONE)
    dim as MirValue chan
    if toFile then
        dim as MirValue ch = LowerExpr( c, sp->a )
        if ch.kind = cast( ubyte, MV_NONE ) then return false
        chan = Coerce( c, ch, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
    end if

    if isLine then
        if sp->count <> 1 then return false
        dim as Fbx.NodeId dst = cast( Fbx.NodeId, c.ast->children[sp->first] )
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
        dim as Fbx.NodeId d = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
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
        dim as Fbx.NodeId d = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
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
