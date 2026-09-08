'' lowerswap.bas -- SWAP.
''
'' Split out of lowerstr.bas, which is at its size limit. SWAP lives near the string
'' code because its string forms are most of its complexity, not because it is one.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko

declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

'' A SWAP operand's type.
''
'' Check does not type a POINTER SUBSCRIPT: TypeOf_( pa[i] ) is TYPE_NONE, so
'' 'swap pa[i], pb[i]' declined on its very first line while the array form beside it
'' lowered. The pointee is what the subscript yields, and asking the TARGET for it is
'' the same thing LowerPtrIndex already does to compute the element size.
'' THE OPERAND OF A 'str( x )' CALL, or the node itself when it is not one. SWAP over
'' a UDT that casts to a string is written 'swap str( u1 ), str( u2 )' in the corpus,
'' and the cast that answers for it hangs off the UDT, not off the call.
private function StrCallOperand_ _
    ( byref c as Ctx, byval e as Tko.NodeId ) as Tko.NodeId

    if e = Tko.NODE_NONE then return e
    if c.ast->Kind( e ) <> Tko.N_CALL then return e
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
    if cp->count <> 1 then return e
    if cp->target = Tko.NODE_NONE then return e
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return e
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "str" then return e
    return cast( Tko.NodeId, c.ast->children[cp->first] )
end function

private function SwapOperandType_ _
    ( byref c as Ctx, byval e as Tko.NodeId ) as Tko.TypeId

    dim as Tko.TypeId t = c.info->TypeOf_( e )
    if t <> Tko.TYPE_NONE then return t
    if e = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( e ) <> Tko.N_INDEX then return Tko.TYPE_NONE

    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
    if lp->target = Tko.NODE_NONE then return Tko.TYPE_NONE
    dim as Tko.TypeId pt = c.info->TypeOf_( lp->target )
    if pt = Tko.TYPE_NONE then return Tko.TYPE_NONE
    if c.types->Kind( pt ) <> Tko.TK_POINTER then return Tko.TYPE_NONE
    return c.types->Inner( pt )
end function


'' 'swap x.a, x.b' WHERE EITHER IS A BITFIELD.
''
'' Measured from fbc -- a temporary of the field's own type and three read-modify-writes
'' through the container word, no address taken anywhere:
''
''     TMP = x.a;  x.a = x.b;  x.b = TMP;
''
'' Each side is read and written through the ordinary bitfield helpers, so a bitfield
'' may be swapped with a plain lvalue and the masking is the same masking every other
'' bitfield write uses. Returns false when NEITHER side is one, which leaves the
'' address-first paths below untouched.
private function BitfieldSwap_ _
    ( byref c as Ctx, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean

    dim as MirValue av, bv
    dim as boolean aBf = LowerBitfieldRead( c, a, av )
    dim as boolean bBf = LowerBitfieldRead( c, b, bv )
    if (aBf orelse bBf) = false then return false

    '' EVERYTHING READ BEFORE ANYTHING IS WRITTEN. The two sides may name bits in the
    '' SAME unit, and writing the first before reading the second would swap a value
    '' with itself.
    if aBf = false then
        av = LowerExpr( c, a )
        if av.kind = cast( ubyte, MV_NONE ) then return false
    end if
    if bBf = false then
        bv = LowerExpr( c, b )
        if bv.kind = cast( ubyte, MV_NONE ) then return false
    end if

    if aBf then
        if LowerBitfieldStoreValue_( c, a, bv ) = false then return false
    else
        dim as MirValue aa = LowerAddr( c, a )
        if aa.kind = cast( ubyte, MV_NONE ) then return false
        StoreThrough( c, aa, bv )
    end if
    if bBf then
        if LowerBitfieldStoreValue_( c, b, av ) = false then return false
    else
        dim as MirValue ba = LowerAddr( c, b )
        if ba.kind = cast( ubyte, MV_NONE ) then return false
        StoreThrough( c, ba, av )
    end if
    return true
end function

function LowerSwap( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if (sp->a = Tko.NODE_NONE) orelse (sp->b = Tko.NODE_NONE) then return false

    '' AN OPERAND WITH NO ADDRESS BUT A WIDE VALUE. 'swap wstr( u1 ), wstr( u2 )' over
    '' a UDT whose 'operator cast( ) byref as wstring' hands back a uint16* is
    '' measured as
    ''
    ''     vr$3 = _ZN3UWHcvwEv( &U2$1 );
    ''     vr$5 = _ZN3UWHcvwEv( &U1$1 );
    ''     fb_WstrSwap( vr$5, 0ll, vr$3, 0ll );
    ''
    '' -- both through the operator, and LENGTH 0 for each, where an addressable
    '' 'wstring * 5' passes its own 5. A call has no address, so both sides answered
    '' nothing and the whole statement declined: udt-wstring/swap.bas writes the shape
    '' three times per element type.
    if TermIsWide_( c, sp->a ) andalso TermIsWide_( c, sp->b ) then
        dim as MirValue wa, wb
        dim as boolean gotA = WideOperand_( c, sp->a, wa )
        dim as boolean gotB = false
        if gotA then gotB = WideOperand_( c, sp->b, wb )
        if gotB then
            dim as FB.Array( of ulong ) wargs
            wargs.Push( cast( ulong, wa.kind ) ) : wargs.Push( cast( ulong, wa.id ) )
            wargs.Push( cast( ulong, MV_CONST_INT ) ) : wargs.Push( 0 )
            wargs.Push( cast( ulong, wb.kind ) ) : wargs.Push( cast( ulong, wb.id ) )
            wargs.Push( cast( ulong, MV_CONST_INT ) ) : wargs.Push( 0 )
            EmitRtl( c, RTL_WSTR_SWAP, wargs )
            return true
        end if
    end if

    '' ...AND THE NARROW TWIN OF IT, which is the same shape one flavour over: 'swap
    '' str( u1 ), str( u2 )' over a UDT whose 'operator cast( ) byref as zstring' hands
    '' back a char*. Measured:
    ''
    ''     vr$3 = _ZN1UcvcEv( &U2$0 );
    ''     vr$5 = _ZN1UcvcEv( &U1$0 );
    ''     fb_StrSwap( vr$5, 0ll, 0, vr$3, 0ll, 0 );
    ''
    '' -- both through the operator, LENGTH 0 for each where an addressable
    '' 'zstring * 50' passes its own 50, and the same fill argument the ordinary path
    '' passes. A call has no address, so both sides answered nothing and the whole
    '' statement declined; udt-zstring/swap.bas writes the shape twelve times.
    ''
    '' The MIXED spelling the same file writes -- 'swap str( u1 ), u2' -- is not this:
    '' one side is a raw pointer and the other a UDT, and what fbc emits for that
    '' pairing has not been measured, so it declines rather than being guessed at.
    '' UNWRAPPED FIRST. 'str( u1 )' is a CALL whose type is STRING, so asking it for
    '' a user cast finds none -- the cast lives on the UDT INSIDE it. fbc emits no
    '' conversion for this shape at all: 'str' of a value that casts to zstring is the
    '' cast and nothing more.
    dim as MirValue ra, rb
    dim as boolean rawA = false, rawB = false
    dim as Tko.NodeId ua = StrCallOperand_( c, sp->a )
    dim as Tko.NodeId ub = StrCallOperand_( c, sp->b )
    if UserCastToStr_( c, ua, ra, rawA ) andalso rawA then
        if UserCastToStr_( c, ub, rb, rawB ) andalso rawB then
            dim as FB.Array( of ulong ) zargs
            zargs.Push( cast( ulong, ra.kind ) ) : zargs.Push( cast( ulong, ra.id ) )
            zargs.Push( cast( ulong, MV_CONST_INT ) ) : zargs.Push( 0 )
            zargs.Push( cast( ulong, MV_CONST_INT ) ) : zargs.Push( 0 )
            zargs.Push( cast( ulong, rb.kind ) ) : zargs.Push( cast( ulong, rb.id ) )
            zargs.Push( cast( ulong, MV_CONST_INT ) ) : zargs.Push( 0 )
            zargs.Push( cast( ulong, MV_CONST_INT ) ) : zargs.Push( 0 )
            EmitRtl( c, RTL_STR_SWAP, zargs )
            return true
        end if
    end if

    dim as Tko.TypeId t = SwapOperandType_( c, sp->a )
    if t = Tko.TYPE_NONE then return false

    '' A BITFIELD HAS NO ADDRESS OF ITS OWN -- it is bits inside a unit its neighbours
    '' share -- so every path below, which is address-first, declined the whole
    '' statement. Measured: fbc emits a temporary of the FIELD'S type and three
    '' read-modify-writes through the container word, with no address taken anywhere.
    ''
    '' Either side may be one, and a bitfield may be swapped with an ordinary lvalue.
    dim as MirValue bfTmp
    if BitfieldSwap_( c, sp->a, sp->b ) then return true

    dim as MirValue la = LowerAddr( c, sp->a )
    dim as MirValue lb = LowerAddr( c, sp->b )

    if (la.kind = cast( ubyte, MV_NONE )) orelse (lb.kind = cast( ubyte, MV_NONE )) then
        return false
    end if

    '' THE LENGTH ARGUMENT IS NOT ALWAYS -1. Measured from fbc's own C:
    ''
    ''     fb_StrSwap( &S1, -1, 0, &S2, -1, 0 )        string  x string
    ''     fb_StrSwap( Z1,   5, 0, Z2,   5, 0 )        zstring * 5, both sides
    ''     fb_StrSwap( &S1, -1, 0, Z1,   5, 0 )        MIXED -- each side its own
    ''     fb_WstrSwap( W1, 5, W2, 5 )                 wstring, a DIFFERENT function
    ''
    '' Passing -1 for a fixed-length operand tells the runtime to read a descriptor out
    '' of character data. That was live for the mixed case: a var-length left operand
    '' took this branch and both sides went out as -1.
    dim as longint na, nb_
    dim as long ka = StrSwapKind_( c, t, na )
    dim as long kb = StrSwapKind_( c, SwapOperandType_( c, sp->b ), nb_ )
    if (ka >= 0) andalso (kb >= 0) then
        '' WSTRING has its own entry point and does not mix with the byte forms; fbc
        '' emits something else again for that pairing, so it is declined rather than
        '' guessed at.
        if (ka = 2) <> (kb = 2) then return false
        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, la.kind ) ) : args.Push( cast( ulong, la.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, na ) )
        if ka = 2 then
            args.Push( cast( ulong, lb.kind ) ) : args.Push( cast( ulong, lb.id ) )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, nb_ ) )
            EmitRtl( c, RTL_WSTR_SWAP, args )
            return true
        end if
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        args.Push( cast( ulong, lb.kind ) ) : args.Push( cast( ulong, lb.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, nb_ ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        EmitRtl( c, RTL_STR_SWAP, args )
        return true
    end if

    '' THE OPERANDS MAY DIFFER IN TYPE. fbc allows 'swap' between a long and a double
    '' and CONVERTS across the assignments -- the temporary is typed to the LEFT operand
    '' and each store converts into its destination:
    ''
    ''     int32 TMP = A;   A = fb_D2I( B );   B = (double)TMP;
    ''
    '' Loading both sides through one type instead reinterprets the bits, which lowers
    '' cleanly, verifies, and is wrong. This was exactly that bug for one commit.
    dim as Tko.TypeId rt = SwapOperandType_( c, sp->b )
    if rt = Tko.TYPE_NONE then return false
    dim as MirType mtl = LowerType( t, *c.types )
    dim as MirType mtr = LowerType( rt, *c.types )
    if (mtl = MT_VOID) orelse (mtr = MT_VOID) then return false
    '' An aggregate has no single load/store, so it is declined rather than
    '' half-swapped. Strings are the aggregate that matters and took the path above.
    '' TWO AGGREGATES of the same size swap as BYTES: fbc emits
    '' 'fb_MemSwap( &U1, &U2, 16 )' for a pair of 16-byte UDTs. Different sizes are
    '' not a swap fbc accepts, so they still decline.
    if (mtl = MT_AGG) andalso (mtr = MT_AGG) then
        '' A UDT's size lives in the LAYOUT TABLE, not in TypeContext.Layout -- the
        '' same two-step LocalFor makes when it sizes an aggregate slot. Asking the
        '' type alone gives 0 and the swap silently declined.
        dim as long sza = c.types->Layout( t ).size
        dim as long szb = c.types->Layout( rt ).size
        dim as long uia = c.udts->Find( t )
        if uia >= 0 then sza = c.udts->udts[uia].size
        dim as long uib = c.udts->Find( rt )
        if uib >= 0 then szb = c.udts->udts[uib].size
        if (sza > 0) andalso (sza = szb) then
            dim as FB.Array( of ulong ) margs
            margs.Push( cast( ulong, la.kind ) ) : margs.Push( cast( ulong, la.id ) )
            margs.Push( cast( ulong, lb.kind ) ) : margs.Push( cast( ulong, lb.id ) )
            margs.Push( cast( ulong, MV_CONST_INT ) ) : margs.Push( cast( ulong, sza ) )
            EmitRtl( c, RTL_MEM_SWAP, margs )
            return true
        end if
    end if
    if (mtl = MT_AGG) orelse (mtr = MT_AGG) then return false

    dim as long slot = NewTempLocal( c, mtl, c.types->Layout( t ).size )
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot

    StoreThrough( c, tmp, LowerExprLoad( c, la, mtl ) )
    StoreThrough( c, la, Coerce( c, LowerExprLoad( c, lb, mtr ), mtl ) )
    StoreThrough( c, lb, Coerce( c, LowerExprLoad( c, tmp, mtl ), mtr ) )
    return true
end function

'' Zeroes a 24-byte string descriptor.
''
'' fbc emits '__builtin_memset( &A, 0, 24 )' for a string local with no initialiser.
'' MIR has no memset, so this is three i64 stores -- which mem2reg folds away for a
'' local that is written before it is read anyway.
''
'' This is NOT cosmetic. A string local always registers an fb_StrDelete for its scope
'' exit, so a descriptor that was never written would hand the runtime a wild pointer
'' to free.
sub ZeroStrDescriptor( byref c as Ctx, byref dst as MirValue )
    for off as long = 0 to 16 step 8
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = dst
        fa.imm = off
        dim as MirValue p = Emit( c, fa )
        dim as MirValue z
        z.kind = cast( ubyte, MV_CONST_INT )
        z.ty = cast( ubyte, MT_I64 )
        z.id = 0
        dim as MirInst st_
        st_.op = cast( ushort, M_STORE )
        st_.ty = cast( ubyte, MT_VOID )
        st_.a = p
        st_.b = z
        Emit( c, st_ )
    next
end sub

'' 'T( args )' -- A TYPE CONSTRUCTOR USED AS AN EXPRESSION.
''
'' 'return TimeSpan( this.m_ticks )' is how the chrono and finance headers build almost
'' every value they return, and there was no case for it: the callee is a TYPE, not a
'' procedure, so the ordinary call path found nothing to call.
''
'' A temporary is built and constructed, and its VALUE is what comes back -- an
'' aggregate value is first class in this IR, so nothing new is needed to carry it.
''
'' fbc constructs STRAIGHT INTO THE RESULT SLOT when the expression is the whole of a
'' 'return' -- '_ZN1TC1Ex( &fb$result$1, N$1 ); return fb$result$1;' -- which is one
'' copy fewer. Same value; the copy is recorded here rather than hidden.
function LowerTypeCtorExpr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.TypeId t = TypeCtorTypeOf_( c, id )
    if t = Tko.TYPE_NONE then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]

    dim as long slot = NewTempLocal( c, MT_AGG, SizeOfType( c, t ) )
    if slot < 0 then return false
    if EmitTypeCtorInto_( c, t, slot, cp ) = false then return false

    dim as MirValue addr
    addr.kind = cast( ubyte, MV_LOCAL )
    addr.ty = cast( ubyte, MT_PTR )
    addr.id = slot
    outv = LowerExprLoad( c, addr, MT_AGG )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 'a[ i ]' OVER A UDT WITH 'operator []' -- the call, in the shape the operator itself
'' declares. Two things were assumed rather than read, and both were wrong for anything
'' but a container indexed by a 32-bit subscript:
''
''   THE INDEX WAS COERCED TO MT_I32. 'operator []( byval i as integer )' takes an i64
''   on win64 -- fbc emits '_ZN1VixEu7INTEGER( &X$0, 3ll )' -- so the argument was
''   truncated and handed to a parameter twice its width. clang refused the module:
''   "'%t8' defined with type 'i32' but expected 'i64'". EVERY 'operator []' declared
''   with the natural spelling was affected, byref and byval alike.
''
''   THE RESULT WAS ASSUMED BYREF. That is one of the two shapes: fbc writes
''   'int32* vr = _ZN1TixEi( &A, 1 ); *vr = 99;' for a BYREF operator, which is what
''   makes 'a[ 1 ] = 99' an lvalue, and 'int64 vr$2 = _ZN1VixEu7INTEGER( &X$0, 3ll );'
''   for a BYVAL one. Taking the pointer shape for both loaded through an integer.
''
'' 'outByref' says which came back, because the caller's next move differs: a byref
'' result IS an address and the value form loads through it, where a byval result is
'' the value and has no address at all.
function LowerUdtIndexOp_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
      byref outByref as boolean ) as boolean

    outByref = false
    if c.ast->Kind( id ) <> Tko.N_INDEX then return false
    dim as Tko.ListPayload ptr sp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->count <> 1 then return false
    if sp->target = Tko.NODE_NONE then return false
    dim as Tko.TypeId pt = c.info->TypeOf_( sp->target )
    if pt = Tko.TYPE_NONE then return false
    if c.types->Kind( pt ) <> Tko.TK_UDT then return false

    dim as Tko.SymbolId ixs = UdtMemberNamed_( c, pt, "[]" )
    if ixs = Tko.SYMBOL_NONE then return false

    '' 'operator []' MAY BE OVERLOADED, and UdtMemberNamed_ answers with the HEAD of the
    '' chain. overload/op-ptrindex.bas declares three on one type -- by integer, by
    '' string and by double -- so taking the head matched 'x[ "abc" ]' against the
    '' INTEGER one: at HEAD that silently passed a truncated string pointer as a
    '' subscript, and it lowered and verified.
    ''
    '' Chosen the way PropertyAt_ chooses between a getter and a setter: by conversion
    '' cost over the written index, uniquely or not at all. A tie is a decline rather
    '' than a guess -- picking either of two equal candidates is how the wrong one gets
    '' called with nothing to say so.
    dim as Tko.NodeId ie0 = cast( Tko.NodeId, c.ast->children[sp->first] )
    dim as Tko.TypeId at0 = c.types->Unqualify( c.info->TypeOf_( ie0 ) )
    if at0 <> Tko.TYPE_NONE then
        dim as Tko.SymbolId best = Tko.SYMBOL_NONE
        dim as long bestCost = Tko.Check.CONV_NONE
        dim as long ties = 0
        dim as Tko.SymbolId cur = ixs
        dim as long guard = 0
        while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
            guard += 1
            dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
            if cs = 0 then exit while
            dim as Tko.TypeId cpt = ParamTypeAt( c, cur, 0 )
            if cpt <> Tko.TYPE_NONE then
                dim as Tko.TypeId cpu = c.types->Unqualify( cpt )
                if c.types->Kind( cpu ) = Tko.TK_REFERENCE then
                    cpu = c.types->Unqualify( c.types->Inner( cpu ) )
                end if
                dim as long cst = Tko.Check.ConversionCost( at0, cpu, *c.types )
                if cst < Tko.Check.CONV_NONE then
                    if cst < bestCost then
                        bestCost = cst
                        best = cur
                        ties = 0
                    elseif cst = bestCost then
                        ties += 1
                    end if
                end if
            end if
            cur = cs->nextOverload
        wend
        if (best <> Tko.SYMBOL_NONE) andalso (ties = 0) then ixs = best
    end if

    dim as MirValue self_ = LowerAddr( c, sp->target )
    if self_.kind = cast( ubyte, MV_NONE ) then return false
    dim as Tko.NodeId ie = cast( Tko.NodeId, c.ast->children[sp->first] )

    '' THE ARGUMENT IN THE SHAPE THE PARAMETER ASKS FOR -- the same three-way answer an
    '' operator's operand already gets in lowerselfop.bas, and the reason this is not a
    '' width fix alone: fb/map.bi and fb/orderedmap.bi both declare
    '' 'operator []( byref k as TK )', so a KEY travels as an ADDRESS. Passing its value
    '' handed the operator a reference to nothing.
    dim as MirValue iv
    dim as Tko.TypeId ipt = ParamTypeAt( c, ixs, 0 )
    if ArrayDescArg_( c, ie, ParamIsArray( c, ixs, 0 ), iv ) then
    elseif ParamIsByref( c, ixs, 0 ) then
        '' A BYREF STRING PARAMETER TAKES A DESCRIPTOR, and a LITERAL has none. This is
        '' the whole of 'mc[ "nums" ].Count( )' -- a map keyed by string, indexed by a
        '' literal, which is how generics/container-map.bas writes it. LowerAddr answers
        '' nothing for a literal, so the index declined, the member call lost its
        '' receiver, and 'calls FB.ARRAY.COUNT with 0 arguments, which declares 1' is
        '' what the verifier made of it.
        ''
        '' StrDescriptorOf_ knows all four shapes -- a descriptor variable, a literal, a
        '' fixed-length string and a concatenation -- and is what an ordinary call's
        '' byref string argument already goes through.
        dim as boolean gotDesc = false
        if IsStringType( c, ipt ) then gotDesc = StrDescriptorOf_( c, ie, iv )
        if gotDesc = false then iv = LowerAddr( c, ie )
        '' AND A TEMPORARY FOR ANYTHING WITH NO ADDRESS, which is most subscripts:
        '' 'operator []( index as integer )' declares a BYREF parameter, because in the
        '' fb dialect a parameter is byref unless it says otherwise, and 'x[ 0 ]' passes
        '' a literal to it. overload/op-ptrindex.bas writes exactly that and is nothing
        '' but subscripts. The same temporary an ordinary call's byref argument gets.
        if iv.kind = cast( ubyte, MV_NONE ) then iv = ByrefTemp_( c, ie, ipt )
    else
        iv = LowerExpr( c, ie )
        '' TO THE PARAMETER'S WIDTH, not the subscript's. 'byval i as integer' is an i64
        '' on win64 -- fbc emits '_ZN1VixEu7INTEGER( &X$0, 3ll )' -- and this coerced to
        '' a fixed MT_I32, so the argument was truncated and handed to a parameter twice
        '' its width. clang refused the module outright.
        if iv.kind <> cast( ubyte, MV_NONE ) then
            dim as MirType imt = LowerType( ipt, *c.types )
            if (imt <> MT_VOID) andalso (imt <> MT_AGG) then
                iv = CoerceTy( c, iv, imt, c.info->TypeOf_( ie ), ipt )
            end if
        end if
    end if
    if iv.kind = cast( ubyte, MV_NONE ) then return false

    '' ...AND ITS OWN RESULT SHAPE. The BYREF flag lives on the declaration, which is
    '' where lowercall.bas reads it from for an ordinary call.
    dim as Tko.Symbol ptr ixsym = c.syms->SymbolAt( ixs )
    if ixsym = 0 then return false
    dim as Tko.NodeId ixpn = cast( Tko.NodeId, ixsym->payload )
    if ixpn <> Tko.NODE_NONE then
        if (c.ast->nodes[cast( long, ixpn )].flags and Tko.NF_BYREF) <> 0 then
            outByref = true
        end if
    end if

    dim as MirType rt = MT_PTR
    if outByref = false then
        rt = LowerType( ixsym->type_, *c.types )
        if rt = MT_VOID then return false
    end if

    dim as FB.Array( of ulong ) ia
    ia.Push( cast( ulong, iv.kind ) ) : ia.Push( cast( ulong, iv.id ) )
    outv = EmitMemberCallArgs_( c, ixs, self_, rt, @ia )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 'T( args )' AS AN ADDRESSABLE TEMPORARY -- what 'P( 3 ).v' and 'DateTime( y, m, d
'' ).AddMonths( 0 )' need. The value form loads the aggregate; a member access needs the
'' storage it was built in.
''
'' Without this a member on a CONSTRUCTOR temporary declined while the same member on a
'' FUNCTION's returned temporary worked -- the call-result path above it asks for a
'' SYM_PROC, and a type-constructor call binds to the UDT instead. fb/chrono.bi writes
'' most of its assertions this way.
function LowerTypeCtorTempAddr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.TypeId t = TypeCtorTypeOf_( c, id )
    if t = Tko.TYPE_NONE then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]

    dim as long slot = NewTempLocal( c, MT_AGG, SizeOfType( c, t ) )
    if slot < 0 then return false
    if EmitTypeCtorInto_( c, t, slot, cp ) = false then return false
    outv.kind = cast( ubyte, MV_LOCAL )
    outv.ty = cast( ubyte, MT_PTR )
    outv.id = slot
    return true
end function

'' The TYPE a 'T( args )' expression builds, or nothing when this is not one. A call
'' whose callee is bound to a UDT SYMBOL rather than to a procedure.
function TypeCtorTypeOf_( byref c as Ctx, byval id as Tko.NodeId ) as Tko.TypeId
    if c.ast->Kind( id ) <> Tko.N_CALL then return Tko.TYPE_NONE
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return Tko.TYPE_NONE
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( cp->target ) )
    if s = 0 then return Tko.TYPE_NONE
    '' ...OR TO A TYPEDEF FOR ONE. 'type Alias as T' is a SYM_TYPEDEF whose own type is
    '' a TK_TYPEDEF placeholder, so both tests below refused it and 'Alias( ).a'
    '' declined -- while 'T( ).a' and 'type<Alias>( ).a' beside it lowered.
    select case s->kind
    case cast( ubyte, Tko.SYM_UDT ), cast( ubyte, Tko.SYM_TYPEDEF )
    case else
        return Tko.TYPE_NONE
    end select
    dim as Tko.TypeId ct = c.types->Unqualify( c.info->TypeOf_( cp->target ) )
    if ct <> Tko.TYPE_NONE then
        if c.types->Kind( ct ) = Tko.TK_UDT then return ct
    end if
    if s->type_ = Tko.TYPE_NONE then return Tko.TYPE_NONE
    if c.types->Kind( s->type_ ) <> Tko.TK_UDT then return Tko.TYPE_NONE
    return s->type_
end function


'' A PROPERTY ACCESS -- 't.V' with no parentheses, and 't.V = x'.
''
'' Both are CALLS. fbc emits '_ZN1T8V__get__Ev( &T )' and '_ZN1T8V__set__Ei( &T, 5 )',
'' and the mangler here already knew the two suffixes -- it was lowering that had no
'' case, so a bare property read declined and a property WRITE went to the ordinary
'' store path, which looked for a field of that name, found a procedure and declined
'' too.
''
'' 't.V( )' with parentheses already worked, because that is an ordinary call. The
'' whole gap is the spelling without them, which is how properties are actually used --
'' 'd1.Year', 'd1.Month', 'd1.Day' in one line of the finance headers.
''
'' WHICH OVERLOAD IS DECIDED BY ARITY, not by the name: the getter takes none and the
'' setter one, they share a symbol chain, and taking the head of it picks whichever was
'' declared first.
'' WHAT ONE CANDIDATE'S INDEX PARAMETERS COST for this call's index arguments, or
'' CONV_NONE when it cannot take them. The parameters are matched positionally from the
'' front; a SETTER's trailing value parameter is not one of them and is not scored here.
'' THE INDEX ARGUMENTS of an indexed property, coerced to the chosen overload's own
'' parameters and pushed in written order. They come before the receiver's other
'' arguments in both accessors: getter = indices, setter = indices then the value.
private function PushPropIndexArgs_ _
    ( byref c as Ctx, byval prop as Tko.SymbolId, byval idxFirst as long, _
      byval idxCount as long, byref args as FB.Array( of ulong ) ) as boolean

    if idxCount = 0 then return true
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( prop )
    if s = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    dim as long seen = 0
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen >= idxCount then exit for
        dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[idxFirst + seen] )
        dim as Tko.TypeId pt = c.info->TypeOf_( StmtOf( c, prm )->a )
        dim as MirValue av
        dim as boolean byref_ = _
            ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
        '' A BYREF STRING PARAMETER TAKES A DESCRIPTOR, and a literal has none --
        '' measured, fbc materialises one and passes its address:
        '' '_ZN3FOO10BAR__set__ER8FBSTRINGu7INTEGER( &F$0, &TMP$3$0, 5678ll )'.
        '' LowerAddr has none to give, so every STRING-indexed property declined
        '' while the integer-indexed one lowered; and handing over the literal's own
        '' bytes instead would be a wild read, not a decline.
        if byref_ andalso IsStringType( c, pt ) then
            if StrDescriptorOf_( c, a, av ) = false then return false
        elseif byref_ then
            av = LowerAddr( c, a )
        else
            av = LowerExpr( c, a )
            if av.kind <> cast( ubyte, MV_NONE ) then
                dim as MirType pmt = LowerType( pt, *c.types )
                if (pmt <> MT_VOID) andalso (pmt <> MT_AGG) then
                    av = CoerceTy( c, av, pmt, c.info->TypeOf_( a ))
                end if
            end if
        end if
        if av.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, av.kind ) )
        args.Push( cast( ulong, av.id ) )
        seen += 1
    next
    return (seen = idxCount)
end function

'' A SETTER OVERLOAD IS ALSO CHOSEN BY ITS VALUE PARAMETER, not by its indices alone:
'' obj_property_idx.bas declares bar(integer,integer), bar(integer,string),
'' bar(string,integer) and bar(string,string), so scoring the index only leaves two
'' candidates tied on every call and the whole statement declined as ambiguous.
private function PropIndexCost_ _
    ( byref c as Ctx, byval prop as Tko.SymbolId, byval idxFirst as long, _
      byval idxCount as long, byval valNode as Tko.NodeId = Tko.NODE_NONE ) as long

    if (idxCount = 0) andalso (valNode = Tko.NODE_NONE) then return Tko.Check.CONV_EXACT
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( prop )
    if s = 0 then return Tko.Check.CONV_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return Tko.Check.CONV_NONE
    if c.ast->Kind( pn ) <> Tko.N_PROC then return Tko.Check.CONV_NONE
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    dim as long total = 0
    dim as long seen = 0
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen >= idxCount then exit for
        dim as Tko.TypeId pt = c.info->TypeOf_( StmtOf( c, prm )->a )
        dim as Tko.TypeId at = c.info->TypeOf_( _
            cast( Tko.NodeId, c.ast->children[idxFirst + seen] ) )
        if (pt = Tko.TYPE_NONE) orelse (at = Tko.TYPE_NONE) then return Tko.Check.CONV_NONE
        dim as Tko.TypeId pu = c.types->Unqualify( pt )
        if c.types->Kind( pu ) = Tko.TK_REFERENCE then
            pu = c.types->Unqualify( c.types->Inner( pu ) )
        end if
        dim as long cst = Tko.Check.ConversionCost( c.types->Unqualify( at ), pu, *c.types )
        if cst >= Tko.Check.CONV_NONE then return Tko.Check.CONV_NONE
        total += cst
        seen += 1
    next
    if seen <> idxCount then return Tko.Check.CONV_NONE

    '' ...and the TRAILING VALUE PARAMETER, which sits one past the indices.
    if valNode <> Tko.NODE_NONE then
        dim as long at2 = 0
        dim as Tko.TypeId vpt = Tko.TYPE_NONE
        for i as long = 0 to pp->count - 1
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            if at2 = idxCount then
                vpt = c.info->TypeOf_( StmtOf( c, prm )->a )
                exit for
            end if
            at2 += 1
        next
        dim as Tko.TypeId vat = c.info->TypeOf_( valNode )
        if (vpt = Tko.TYPE_NONE) orelse (vat = Tko.TYPE_NONE) then
            return Tko.Check.CONV_NONE
        end if
        dim as Tko.TypeId vpu = c.types->Unqualify( vpt )
        if c.types->Kind( vpu ) = Tko.TK_REFERENCE then
            vpu = c.types->Unqualify( c.types->Inner( vpu ) )
        end if
        dim as long vc = Tko.Check.ConversionCost( _
            c.types->Unqualify( vat ), vpu, *c.types )
        if vc >= Tko.Check.CONV_NONE then return Tko.Check.CONV_NONE
        total += vc
    end if
    return total
end function

function PropertyAt_ _
    ( byref c as Ctx, byval node as Tko.NodeId, byval want as long, _
      byref self_ as MirValue, byref outIdxFirst as long, _
      byref outIdxCount as long, _
      byval valNode as Tko.NodeId = Tko.NODE_NONE ) as Tko.SymbolId

    '' AN INDEXED PROPERTY IS SPELLED LIKE A CALL. 'f.bar( 0 )' is an N_CALL whose
    '' TARGET is the member, and this refused anything that was not a bare member on its
    '' first line -- so 'f.bar( 0 ) = v' fell through to the ordinary store path, which
    '' looked for a field of that name, found a procedure and declined.
    dim as Tko.NodeId member = node
    dim as long idxFirst = 0
    dim as long idxCount = 0
    if c.ast->Kind( node ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr ip2 = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, node )].data )]
        if ip2->target = Tko.NODE_NONE then return Tko.SYMBOL_NONE
        if c.ast->Kind( ip2->target ) <> Tko.N_MEMBER then return Tko.SYMBOL_NONE
        member = ip2->target
        idxFirst = ip2->first
        idxCount = ip2->count
    end if
    if c.ast->Kind( member ) <> Tko.N_MEMBER then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId sid = c.info->RefOf( member )
    if sid = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    outIdxFirst = idxFirst
    outIdxCount = idxCount

    '' The whole chain, because the getter and the setter share one symbol.
    ''
    '' FROM THE HEAD, not from whatever Resolve bound. A chain is singly linked and a
    '' name maps to the FIRST of its overloads, so starting at the bound symbol can only
    '' ever see the accessors declared AFTER it. With
    ''
    ''     declare property v( byval new_v as integer )
    ''     declare property v( ) as integer
    ''
    '' Resolve bound 'x.v' to the GETTER, the second of the two, and the walk for a
    '' SETTER found nothing behind it -- so 'x.v = 1' fell through to the ordinary store
    '' path and stored 1 through the address of the getter's own code. It verified: a
    '' store of an i64 into a pointer is well formed, and nothing here knew the pointer
    '' was a function.
    dim as Tko.SymbolId head = sid
    dim as Tko.Symbol ptr s0 = c.syms->SymbolAt( sid )
    if s0 <> 0 then
        dim as Tko.SymbolId h = c.syms->LookupLocal( s0->parent, s0->name )
        if h <> Tko.SYMBOL_NONE then head = h
    end if
    dim as Tko.SymbolId cur = head
    dim as Tko.SymbolId want_ = Tko.SYMBOL_NONE
    dim as long bestCost = Tko.Check.CONV_NONE
    dim as long ties = 0
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind = cast( ubyte, Tko.SYM_PROC ) then
            dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
            if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
                dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
                if pp->op = cast( ushort, Tko.KW_PROPERTY ) then
                    dim as long np = 0
                    for i as long = 0 to pp->count - 1
                        dim as Tko.NodeId prm = _
                            cast( Tko.NodeId, c.ast->children[pp->first + i] )
                        if c.ast->Kind( prm ) = Tko.N_PARAM then np += 1
                    next
                    '' WHICH ACCESSOR IT IS COMES FROM THE RESULT TYPE, not from the
                    '' parameter count: an INDEXED getter takes one parameter and is
                    '' still a getter. 'want' is 0 for a get and 1 for a set, and the
                    '' index arguments are added on top of it.
                    dim as boolean isGet = (pp->a <> Tko.NODE_NONE)
                    dim as boolean wantGet = (want = 0)
                    if (isGet = wantGet) andalso (np = idxCount + want) then
                        '' SCORED over the index arguments, because a type may declare
                        '' several -- obj_property_idx.bas overloads on the index type
                        '' AND the value type. A tie picks nothing.
                        dim as long cost = PropIndexCost_( _
                            c, cur, idxFirst, idxCount, valNode )
                        if cost < bestCost then
                            bestCost = cost
                            want_ = cur
                            ties = 0
                        elseif (cost = bestCost) andalso (cost < Tko.Check.CONV_NONE) then
                            ties += 1
                        end if
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    if want_ = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    if ties > 0 then return Tko.SYMBOL_NONE

    '' The RECEIVER is the member's base, by address -- 'p.V' through a pointer takes
    '' the pointer's value instead, exactly as a field access does.
    dim as Tko.BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, member )].data )]
    dim as Tko.TypeId bt = c.info->TypeOf_( mp->lhs )
    if (bt <> Tko.TYPE_NONE) andalso (c.types->Kind( bt ) = Tko.TK_POINTER) then
        self_ = LowerExpr( c, mp->lhs )
    else
        self_ = LowerAddr( c, mp->lhs )
    end if
    if self_.kind = cast( ubyte, MV_NONE ) then return Tko.SYMBOL_NONE
    return want_
end function

'' A USER-DEFINED BINARY OPERATOR, called. Check chose the overload and recorded it on
'' the expression node; what is left is passing the operands the way the parameters
'' want them -- BYREF is the usual spelling for a value type, and an operand with no
'' address of its own gets a temporary exactly as a call argument does.
''
'' A MEMBER operator takes the left operand as its RECEIVER and the right as its only
'' argument; a global one takes both.
declare function OperandValue_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byval pt as Tko.TypeId, _
      byval byref_ as boolean, byref args as FB.Array( of ulong ), _
      byref tmpSlots as FB.Array( of ulong ), _
      byref tmpTypes as FB.Array( of ulong ) ) as boolean

function LowerUserBinaryOp_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval bp as Tko.BinaryPayload ptr, _
      byval mt as MirType, byref outv as MirValue ) as boolean

    dim as Tko.SymbolId op = c.info->RefOf( id )
    if op = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr os = c.syms->SymbolAt( op )
    if os = 0 then return false
    if os->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, os->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    if pp->op <> cast( ushort, Tko.KW_OPERATOR ) then return false

    '' The parameters, in order, with their byref-ness.
    dim as FB.Array( of ulong ) ptypes
    dim as FB.Array( of ulong ) prefs
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        ptypes.Push( cast( ulong, c.info->TypeOf_( StmtOf( c, prm )->a ) ) )
        dim as ulong isRef = 0
        if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0 then isRef = 1
        prefs.Push( isRef )
    next
    if (ptypes.Count <> 1) andalso (ptypes.Count <> 2) then return false

    dim as MirType rmt = mt
    if os->type_ <> Tko.TYPE_NONE then rmt = LowerType( os->type_, *c.types )
    if IsStringType( c, os->type_ ) then rmt = MT_PTR
    if (c.ast->nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0 then rmt = MT_PTR

    '' A UDT RESULT TRAVELS THROUGH A HIDDEN POINTER, and the caller provides the
    '' landing place: a temporary passed as ARGUMENT 0, before the operands. fbc emits
    '' 'struct T* _ZplRK1TS1_( struct T* tmp, ... )' -- the declaration says a pointer,
    '' so a call typed 'agg' with no temporary was neither the right type nor the right
    '' argument list, and 'r = a + b' over a UDT-returning operator declined. That is
    '' every global arithmetic operator over a value type there is.
    ''
    '' The call's VALUE is the temporary's ADDRESS, which is what the assignment then
    '' reads through.
    dim as MirValue sretTmp
    dim as boolean usesSret = false
    if os->type_ <> Tko.TYPE_NONE then
        if UsesSretReturn( c, os->type_ ) then
            dim as long tslot = NewTempLocal( c, MT_AGG, SizeOfType( c, os->type_ ) )
            if tslot < 0 then return false
            sretTmp.kind = cast( ubyte, MV_LOCAL )
            sretTmp.ty = cast( ubyte, MT_PTR )
            sretTmp.id = tslot
            usesSret = true
            rmt = MT_PTR
        end if
    end if

    dim as FB.Array( of ulong ) args
    if usesSret then
        args.Push( cast( ulong, sretTmp.kind ) )
        args.Push( cast( ulong, sretTmp.id ) )
    end if
    dim as long firstArg = 0
    dim as FB.Array( of ulong ) opTmpSlots
    dim as FB.Array( of ulong ) opTmpTypes
    if ptypes.Count = 1 then
        '' The RECEIVER is the left operand, by address.
        dim as MirValue self_ = LowerAddr( c, bp->lhs )
        if self_.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, self_.kind ) ) : args.Push( cast( ulong, self_.id ) )
    else
        if OperandValue_( c, bp->lhs, cast( Tko.TypeId, ptypes[0] ), _
                          (prefs[0] <> 0), args, opTmpSlots, opTmpTypes ) = false then
            return false
        end if
        firstArg = 1
    end if
    if OperandValue_( c, bp->rhs, cast( Tko.TypeId, ptypes[firstArg] ), _
                      (prefs[firstArg] <> 0), args, opTmpSlots, opTmpTypes ) = false then
        return false
    end if

    outv = EmitDirectCall_( c, op, rmt, args, usesSret )
    '' A CONVERTED OPERAND'S TEMPORARY IS DESTRUCTED AFTER THE OPERATOR, which is
    '' where fbc puts it: '_ZN2TUD1Ev( &TMP$2$0 )' on the line after the call.
    DestroyOperandTemps_( c, opTmpSlots, opTmpTypes )
    if usesSret then
        '' The RESULT IS THE TEMPORARY, not what the call handed back: fbc returns the
        '' same pointer it was given, and reading the temporary is what every use of
        '' the result then does.
        if outv.kind = cast( ubyte, MV_NONE ) then return false
        outv = sretTmp
        return true
    end if
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' A USER-DEFINED UNARY OPERATOR, called. A GLOBAL one takes the operand as its only
'' parameter; a MEMBER one takes it as the receiver and nothing else.
function LowerUserUnaryOp_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval up as Tko.UnaryPayload ptr, _
      byval mt as MirType, byref outv as MirValue ) as boolean

    dim as Tko.SymbolId op = c.info->RefOf( id )
    if op = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr os = c.syms->SymbolAt( op )
    if os = 0 then return false
    if os->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, os->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    if pp->op <> cast( ushort, Tko.KW_OPERATOR ) then return false

    dim as Tko.TypeId pt = Tko.TYPE_NONE
    dim as boolean isRef = false
    dim as long np = 0
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if np = 0 then
            pt = c.info->TypeOf_( StmtOf( c, prm )->a )
            isRef = ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
        end if
        np += 1
    next

    dim as MirType rmt = mt
    if os->type_ <> Tko.TYPE_NONE then rmt = LowerType( os->type_, *c.types )
    '' A STRING RESULT IS A DESCRIPTOR POINTER, which is what the function's own
    '' declaration says: 'FBSTRING* F( void )'. Reading it as the string's MIR type put
    '' an 'agg' result on a call to a function declared to return a pointer.
    if IsStringType( c, os->type_ ) then rmt = MT_PTR
    '' A BYREF RETURN IS A POINTER, which is what the DECLARATION says too. Reading it
    '' as the referent's own MIR type put an i32 result on a function declared to return
    '' a pointer -- 'operator *' over a smart pointer is byref by construction.
    if (c.ast->nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0 then rmt = MT_PTR

    if np = 0 then
        dim as MirValue self_ = LowerAddr( c, up->operand )
        if self_.kind = cast( ubyte, MV_NONE ) then return false
        outv = EmitMemberCall( c, op, self_, rmt )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if np <> 1 then return false

    dim as FB.Array( of ulong ) args
    dim as FB.Array( of ulong ) unTmpSlots
    dim as FB.Array( of ulong ) unTmpTypes
    if OperandValue_( c, up->operand, pt, isRef, args, unTmpSlots, unTmpTypes ) = false then
        return false
    end if
     '' NO HIDDEN RESULT POINTER on this path: the unary operator does not push a
     '' destination temporary, so the declaration takes its parameters as written.
    outv = EmitDirectCall_( c, op, rmt, args )
    DestroyOperandTemps_( c, unTmpSlots, unTmpTypes )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' One operator operand, pushed as the parameter wants it.
private function OperandValue_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byval pt as Tko.TypeId, _
      byval byref_ as boolean, byref args as FB.Array( of ulong ), _
      byref tmpSlots as FB.Array( of ulong ), _
      byref tmpTypes as FB.Array( of ulong ) ) as boolean

    dim as MirValue v

    '' AN OPERAND THAT IS NOT THE PARAMETER'S TYPE IS A CONVERSION, and it is asked
    '' before anything else: neither branch below has anything to convert with, so
    '' 'u <> v' over an unrelated UDT handed the operator the RAW operand -- or, once
    '' the cost model refused it, declined outright.
    dim as long ucSlot = -1
    dim as Tko.TypeId ucType = Tko.TYPE_NONE
    if UserConvOperand_( c, e, pt, v, ucSlot, ucType ) then
        if ucSlot >= 0 then
            tmpSlots.Push( cast( ulong, ucSlot ) )
            tmpTypes.Push( cast( ulong, ucType ) )
        end if
        args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
        return true
    end if

    if byref_ then
        v = LowerAddr( c, e )
        if v.kind = cast( ubyte, MV_NONE ) then
            '' An operand with no address -- another operator's result -- gets a
            '' temporary, the same answer a byref call argument gets.
            dim as MirValue rv = LowerExpr( c, e )
            if rv.kind = cast( ubyte, MV_NONE ) then return false
            dim as MirType pmt = LowerType( pt, *c.types )
            if pmt = MT_VOID then return false
            dim as long sz = c.types->Layout( pt ).size
            if pmt = MT_AGG then sz = SizeOfType( c, pt )
            dim as long slot = NewTempLocal( c, pmt, sz )
            if slot < 0 then return false
            dim as MirValue tmp
            tmp.kind = cast( ubyte, MV_LOCAL )
            tmp.ty = cast( ubyte, MT_PTR )
            tmp.id = slot
            if pmt <> MT_AGG then rv = CoerceTy( c, rv, pmt, pt)
            StoreThrough( c, tmp, rv )
            v = tmp
        end if
    else
        v = LowerExpr( c, e )
        if v.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirType pmt = LowerType( pt, *c.types )
        if (pmt <> MT_VOID) andalso (pmt <> MT_AGG) then
            v = CoerceTy( c, v, pmt, pt)
        end if
    end if
    if v.kind = cast( ubyte, MV_NONE ) then return false
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    return true
end function

'' 't.V' as a value: the GETTER, called on the base.
function LowerPropertyGet_ _
    ( byref c as Ctx, byval node as Tko.NodeId, byref outv as MirValue ) as boolean
    dim as MirValue self_
    dim as long gFirst, gCount
    dim as Tko.SymbolId g = PropertyAt_( c, node, 0, self_, gFirst, gCount )
    if g = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr gs = c.syms->SymbolAt( g )
    if gs = 0 then return false
    '' The INDEX ARGUMENTS follow the receiver, in written order, coerced to the
    '' parameters the chosen overload declared -- measured, fbc emits
    '' '_ZN3FOO10BAR__get__Eu7INTEGER( &F$, 0ll )'.
    dim as FB.Array( of ulong ) gargs
    if PushPropIndexArgs_( c, g, gFirst, gCount, gargs ) = false then return false
    outv = EmitMemberCallArgs_( c, g, self_, LowerType( gs->type_, *c.types ), @gargs )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 't.V = x': the SETTER, called with the value after the receiver.
function LowerPropertySet_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean
    dim as MirValue self_
    dim as long sFirst, sCount
    dim as Tko.SymbolId sset = PropertyAt_( _
        c, target, 1, self_, sFirst, sCount, value )
    if sset = Tko.SYMBOL_NONE then return false

    '' The parameter's type, so the value is coerced the way the callee expects.
    dim as Tko.Symbol ptr ss = c.syms->SymbolAt( sset )
    if ss = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ss->payload )
    if pn = Tko.NODE_NONE then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    '' THE VALUE IS THE LAST PARAMETER, not the first. For an INDEXED setter the
    '' leading ones are the indices, and taking parameter zero for the value coerced
    '' the value to the INDEX's type.
    dim as Tko.TypeId pt = Tko.TYPE_NONE
    dim as long np2 = 0
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) = Tko.N_PARAM then
            pt = c.info->TypeOf_( StmtOf( c, prm )->a )
            np2 += 1
        end if
    next

    dim as FB.Array( of ulong ) args
    if PushPropIndexArgs_( c, sset, sFirst, sCount, args ) = false then
    end if

    dim as MirValue v = LowerExpr( c, value )
    if v.kind = cast( ubyte, MV_NONE ) then return false
    if pt <> Tko.TYPE_NONE then
        dim as MirType vmt = LowerType( pt, *c.types )
        if (vmt <> MT_VOID) andalso (vmt <> MT_AGG) then
            v = CoerceTy( c, v, vmt, pt)
            if v.kind = cast( ubyte, MV_NONE ) then return false
        end if
    end if
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    EmitStructorCall( c, sset, -1, @self_, @args )
    return true
end function

end namespace
