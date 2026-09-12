'' THE ELEMENT SIZE POINTER ARITHMETIC SCALES BY, or 0 when the type is not a
'' pointer at all.
''
'' An ANY POINTEE COUNTS AS ONE. 'any' has size 0 in the type table -- it is the
'' absence of a type -- and fbc still advances an 'any ptr' by ONE per unit:
'' 'A$0 = (void*)((uint8*)A$0 + 1ll)'. Taking the size raw would multiply by zero
'' and never move.
function PtrArithElem_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as long

    if t = Tko.TYPE_NONE then return 0
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = Tko.TK_REFERENCE then
        u = c.types->Unqualify( c.types->Inner( u ) )
    end if
    if c.types->Kind( u ) <> Tko.TK_POINTER then return 0
    dim as Tko.TypeId el = c.types->Inner( u )
    if el = Tko.TYPE_NONE then return 1
    dim as long sz = SizeOfType( c, el )
    if sz < 1 then sz = 1
    return sz
end function

'' lowerexpr.bas -- LowerExpr, the expression dispatcher.
''
'' Split out of lower.bas at the 1500-line cap and INCLUDED from it, in the same place,
'' exactly as lowerassign.bas and lowerinit.bas are: lower.bas is one compilation unit
'' made of several files, and several of the helpers here are module-private to it.
'' Nothing about the code changed in the move.



'' THE BITWISE AND SHIFT OPERATORS, as tokens. MIR needs the question for its own
'' reason -- neither has a FLOAT form, so a float operand is converted rather than
'' widened to -- and check.bas's IsBitwise_ is private to that pass.
private function IsBitwiseTk_( byval tk as Tko.TokenKind ) as boolean
    select case tk
    case Tko.KW_AND, Tko.KW_OR, Tko.KW_XOR, Tko.KW_EQV, Tko.KW_IMP
        return true
    end select
    return false
end function

private function IsShiftTk_( byval tk as Tko.TokenKind ) as boolean
    return (tk = Tko.KW_SHL) orelse (tk = Tko.KW_SHR)
end function

function LowerExpr _
    ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue

    dim as MirValue v
    if id = Tko.NODE_NONE then return v

    dim as Tko.TypeId ft = c.info->TypeOf_( id )
    dim as MirType mt = LowerType( ft, *c.types )

    select case c.ast->Kind( id )
    '' 'open( f for input as #1 )' IN EXPRESSION POSITION yields the error code. The
    '' parser builds the same N_INTRINSIC node either way, so the statement form's own
    '' lowering serves -- it was only the expression path that had no case, and a DIM
    '' initialised from one allocated its slot and stored nothing.
    case Tko.N_INTRINSIC
        dim as MirValue ov
        '' 'threadcall f( a )' YIELDS THE THREAD HANDLE, and that is how every real
        '' use in the corpus writes it: 'dim as any ptr t = threadcall f( 1 )'.
        if LowerThreadCall_( c, id, ov ) then return ov
        if LowerOpenCall_( c, id, ov ) then return ov
        '' 'get( #f, 1, b )' YIELDS THE ERROR CODE, and that is how the corpus writes
        '' every one: 'CU_ASSERT( get( #f, 1, b ) = 0 )'. Same node either way, so the
        '' statement form's own lowering serves here too.
        dim as Tko.StmtPayload ptr isp = StmtOf( c, id )
        dim as Tko.TokenKind iop = cast( Tko.TokenKind, isp->op )
        if (iop = Tko.KW_GET) orelse (iop = Tko.KW_PUT) then
            dim as MirValue gv
            if LowerFileGetPut( c, id, (iop = Tko.KW_PUT), gv ) then return gv
        end if
        '' 'close( n )' YIELDS THE ERROR CODE the same way, and that is how the corpus
        '' asks about a bad channel: 'CU_ASSERT_EQUAL( close(0), ILLEGALFUNCTIONCALL )'.
        '' Measured -- 'e = close(0)' is 'vr$1 = fb_FileClose( 0 )', the same call the
        '' statement form makes with its result discarded.
        if iop = Tko.KW_CLOSE then
            dim as MirValue cv2
            if LowerCloseCall_( c, id, cv2 ) then return cv2
        end if
        '' 'input( n [, [#]f] )' AND 'winput( ... )' -- n characters read as a VALUE.
        '' A different construct from the INPUT STATEMENT, which reads variables, and
        '' RTL_FILE_STR_INPUT and RTL_FILE_WSTR_INPUT had been declared with no emit
        '' site at all. Measured:
        ''
        ''     input( 2, #1 )   fb_FileStrInput ( 2ll, 1 )
        ''     input( 2 )       fb_FileStrInput ( 2ll, 0 )   -- no channel is 0
        ''     winput( 2, #1 )  fb_FileWstrInput( 2ll, 1 )
        ''
        '' and run over a file holding 'aabbcc', they read 'aa' then 'b b '.
        dim as boolean isInputExpr = (isp->extra and 8) <> 0
        if isInputExpr then
            isInputExpr = (iop = Tko.KW_INPUT) orelse (iop = Tko.KW_WINPUT)
        end if
        if isInputExpr then
            dim as MirValue nv = LowerExpr( c, isp->a )
            if nv.kind = cast( ubyte, MV_NONE ) then return v
            nv = Coerce( c, nv, MT_I64, false )
            if nv.kind = cast( ubyte, MV_NONE ) then return v
            dim as MirValue fv
            if isp->b <> Tko.NODE_NONE then
                fv = LowerExpr( c, isp->b )
                if fv.kind = cast( ubyte, MV_NONE ) then return v
                fv = Coerce( c, fv, MT_I32, false )
            else
                fv = ConstInt( c, 0, MT_I32 )
            end if
            if fv.kind = cast( ubyte, MV_NONE ) then return v
            dim as FB.Array( of ulong ) iargs
            iargs.Push( cast( ulong, nv.kind ) ) : iargs.Push( cast( ulong, nv.id ) )
            iargs.Push( cast( ulong, fv.kind ) ) : iargs.Push( cast( ulong, fv.id ) )
            dim as long iw = RTL_FILE_STR_INPUT
            if iop = Tko.KW_WINPUT then iw = RTL_FILE_WSTR_INPUT
            return EmitRtl( c, iw, iargs )
        end if
        return v

    case Tko.N_CLOSURE
        '' A CAPTURING LAMBDA'S OBJECT. See lowerclosure.bas.
        dim as MirValue clv
        if LowerClosure_( c, id, clv ) then return clv
        return v

    case Tko.N_STRING_LIT
        return LowerStringLitAddr( c, id )

    case Tko.N_INT_LIT
        dim as Tko.LiteralPayload ptr lp = _
            @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
        if mt = MT_VOID then mt = MT_I64
        return ConstInt( c, cast( longint, lp->intValue ), mt )

    case Tko.N_FLOAT_LIT
        dim as Tko.LiteralPayload ptr lp = _
            @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
        if mt = MT_VOID then mt = MT_F64
        return ConstFloat( c, lp->fltValue, mt )

    case Tko.N_TUPLE
        '' 'type<P>( 5, 6 )' IN VALUE POSITION -- an argument, a parameter default.
        '' fbc builds a temporary and field-initialises it. A bare tuple has no type
        '' target and is not one of these.
        '' ...and the same spelling over a type that is NOT a UDT is a plain
        '' CONVERSION. See LowerTypeLitConvert_.
        dim as MirValue tcv
        if LowerTypeLitConvert_( c, id, tcv ) then return tcv

        dim as MirValue ulv
        if LowerUdtLiteralValue_( c, id, ulv ) then return ulv
        return v

    case Tko.N_PAREN
        dim as Tko.ListPayload ptr pp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if pp->count <> 1 then return v
        return LowerExpr( c, cast( Tko.NodeId, c.ast->children[pp->first] ) )

    case Tko.N_IDENT, Tko.N_MEMBER
        '' 'NS.K' AND 'NS.SOME_ENUM_MEMBER' FOLD TO THEIR VALUES, exactly as the
        '' unqualified spellings do. Splitting this case for the property branch below
        '' dropped that -- and the bitfield read with it -- so a qualified constant lost
        '' its fold and 'x.f' over a bitfield went back to loading the whole packed unit.
        '' The two kinds share every step but one; only the property call is
        '' member-specific.
        dim as MirValue pre = LowerPredeclared( c, id )
        if pre.kind <> cast( ubyte, MV_NONE ) then return pre

        '' A BITFIELD HAS NO ADDRESS OF ITS OWN: it is bits inside a unit its
        '' neighbours share, so it is read by masking rather than by loading.
        dim as MirValue bfv
        if LowerBitfieldRead( c, id, bfv ) then return bfv

        '' 't.V' WITH NO PARENTHESES over a property is a call to its GETTER. With them
        '' it is an ordinary call and never reaches here -- so the only spelling that
        '' was missing is the one properties are actually used in.
        if c.ast->Kind( id ) = Tko.N_MEMBER then
            dim as MirValue pgv
            if LowerPropertyGet_( c, id, pgv ) then return pgv
        end if

        '' A BARE FUNCTION NAME IN VALUE POSITION IS A CALL. 'd = timer' and
        '' 's = curdir' are how FreeBASIC spells a no-argument call, and LowerAddr
        '' answers with the function's ADDRESS -- so the address of fb_Timer was stored
        '' in a double and the address of fb_CurDir was handed to fb_StrInit as a
        '' string. It verified: a pointer is a well-typed value.
        ''
        '' '@f' and 'procptr( f )' go through LowerAddr and are unaffected; there is no
        '' spelling that means "the address" without one of them.
        dim as MirValue bpc
        if LowerBareProcCall_( c, id, mt, bpc ) then return bpc

        dim as MirValue addr = LowerAddr( c, id )
        if addr.kind = cast( ubyte, MV_NONE ) then return v
        dim as MirInst ins
        ins.op = cast( ushort, M_LOAD )
        ins.ty = cast( ubyte, mt )
        ins.a = addr
        '' AN AGGREGATE LOAD CARRIES ITS SIZE, because the address alone cannot answer
        '' for it: reading a BYREF UDT parameter loads through a TEMP holding the
        '' pointer, and a temp has no slot to be sized by. It emitted
        '' '%4 = load [0 x i8], ptr %t3' -- a zero-byte load clang rejects against the
        '' 8-byte store beside it. Measured on 'operator ->( byref lhs as foo ) as foo'
        '' returning lhs, which is exactly that shape.
        '' ...AND A REFERENCE IS SIZED BY ITS REFERENT. 'ft' for a byref parameter
        '' is the REFERENCE type, whose own size is a pointer's or nothing at all,
        '' so the guard below saw no size and the load went out '[0 x i8]' again --
        '' one unwrap short of the fix this comment describes. Measured on
        '' 'base( p0 )' inside 'constructor C3( byref p0 as P )', which copies the
        '' base subobject out of the reference: the program printed two stack
        '' addresses where fbc prints 9 and 8.
        if mt = MT_AGG then
            dim as Tko.TypeId aft = ft
            if aft <> Tko.TYPE_NONE then
                dim as Tko.TypeId afu = c.types->Unqualify( aft )
                if c.types->Kind( afu ) = Tko.TK_REFERENCE then
                    aft = c.types->Inner( afu )
                end if
            end if
            dim as long asz = SizeOfType( c, aft )
            if asz > 0 then ins.imm = cast( longint, asz )
        end if
        return Emit( c, ins )

    case Tko.N_ADDROF
        '' '@x' IS THE ADDRESS, which is what LowerAddr already computes for every
        '' lvalue -- a local, a global, a field, an array element, a byref parameter.
        '' There was no case for it at all, so every '@' in the tree produced NOTHING:
        '' 'dim as T ptr p = @obj' allocated p, stored nothing, and 'p->v = 1' then
        '' wrote through whatever the stack held. Silent, because a DIM initialiser
        '' that would not lower skipped its store without counting it.
        dim as Tko.UnaryPayload ptr ap = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' '@this' IS THE OBJECT'S ADDRESS, which is the slot's VALUE and not the
        '' slot. The receiver is held as a POINTER -- IsThisPointerIdent_ exists
        '' because several sites need to know it -- so LowerAddr answers with the
        '' slot's own address, and '@this' handed back a pointer to a pointer.
        ''
        '' Measured: fbc writes 'fb$result$1 = (void*)THIS$1;' and '@p' and
        '' 'p.Addr( )' compare EQUAL; under tiko they differed by the frame offset
        '' of the receiver slot. '@this.field' was right all along -- only the bare
        '' spelling was wrong -- and every fb/*.bi iterator is built on it
        '' ('it.src = @this' in array.bi, set.bi, map.bi, channel.bi, orderedmap.bi),
        '' so 'for each' over any container walked from the wrong address.
        ''
        '' NOT IN AddrOfVar, which is where the pointer-ness is otherwise handled:
        '' its four callers that pass the receiver symbol ALREADY follow it with a
        '' load of their own, and moving the load inside would make every one of
        '' them read through the object instead of to it.
        if IsThisPointerIdent_( c, ap->operand ) then
            dim as MirValue tsl = LowerAddr( c, ap->operand )
            if tsl.kind <> cast( ubyte, MV_NONE ) then
                return LowerExprLoad( c, tsl, MT_PTR )
            end if
        end if
        '' A UDT MAY OVERLOAD '@', and then '@f' is a CALL. Measured, fbc emits
        '' 'int64* vr$2 = _ZN3FOOadEv( &F$0 );' and prints the field the operator
        '' points at, 999, where the object's own address reads the one before it,
        '' 111 -- so this was WRONG rather than declined, with 0 statements not
        '' lowered to say so. overload/op_addrof.bas.
        dim as Tko.TypeId aoT = c.info->TypeOf_( ap->operand )
        if aoT <> Tko.TYPE_NONE then
            if c.types->Kind( c.types->Unqualify( aoT ) ) = Tko.TK_UDT then
                dim as Tko.SymbolId aoOp = _
                    UdtMemberNamed_( c, c.types->Unqualify( aoT ), "@" )
                if aoOp <> Tko.SYMBOL_NONE then
                    dim as MirValue aoSelf = LowerAddr( c, ap->operand )
                    if aoSelf.kind <> cast( ubyte, MV_NONE ) then
                        dim as FB.Array( of ulong ) aoArgs
                        aoArgs.Push( cast( ulong, aoSelf.kind ) )
                        aoArgs.Push( cast( ulong, aoSelf.id ) )
                        return EmitDirectCall_( c, aoOp, MT_PTR, aoArgs )
                    end if
                end if
            end if
        end if
        '' '@"lit"' IS THE ADDRESS OF THE BYTES, which is what a 'zstring ptr'
        '' parameter wants. A literal has no lvalue, so LowerAddr answered NOTHING and
        '' every 'printf( @"%d", n )' passed an unresolved value as its format.
        if c.ast->Kind( ap->operand ) = Tko.N_STRING_LIT then
            return LowerStringLitAddr( c, ap->operand )
        end if
        '' ...AND SO IS '@S' OVER A STRING CONSTANT. 'const s = "abc"' emits no
        '' variable -- it folds -- so LowerAddr had nothing to take and
        '' 'dim as byte ptr p = @s' declined. Measured, fbc hands back the
        '' LITERAL'S OWN STORAGE: 'P$0 = (int8*)"abc"'.
        if c.ast->Kind( ap->operand ) = Tko.N_IDENT then
            dim as Tko.Symbol ptr acs = c.syms->SymbolAt( c.info->RefOf( ap->operand ) )
            if acs <> 0 then
                if acs->kind = cast( ubyte, Tko.SYM_CONSTANT ) then
                    dim as string actx
                    if ConstStringTextOf_( c, ap->operand, actx ) then
                        dim as MirValue acv
                        acv.kind = cast( ubyte, MV_GLOBAL )
                        acv.ty = cast( ubyte, MT_PTR )
                        acv.id = c.m->AddStringLiteral( actx, *c.names )
                        return acv
                    end if
                end if
            end if
        end if
        '' '@wstr( "w1" )' -- A WIDE STRING IS ALREADY A POINTER, so its address is
        '' that pointer and not the address of a temporary holding one. Measured: fbc
        '' folds the whole thing to '(uint16*)L"w1"', the literal's own storage. Asking
        '' LowerAddr for a CALL's address instead gave nothing, and the parameter
        '' default 'byval pw as const wstring ptr = @wstr( "w1" )' declined with it --
        '' which is how functions/paraminit writes every wide default.
        '' '@( @x )' OVER A BYREF PARAMETER IS THE PARAMETER'S OWN SLOT. A byref
        '' parameter IS a pointer variable, so '@x' names its CONTENTS and '@( @x )'
        '' its address -- measured, 'void S2( int8* X$1 ) { ... = (uint64)&X$1; }' --
        '' and fbc REJECTS the same spelling over any other variable, error 24, so
        '' there is nothing else to model beside it.
        ''
        '' LowerAddr was asked for the address of an rvalue and answered nothing.
        '' pointers/arith.bas puts every byref case through one macro that writes it
        '' four times.
        dim as Tko.NodeId inA = Unparen_( c, ap->operand )
        if c.ast->Kind( inA ) = Tko.N_ADDROF then
            dim as Tko.UnaryPayload ptr ap2 = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, inA )].data )]
            dim as Tko.NodeId nmA = Unparen_( c, ap2->operand )
            if c.ast->Kind( nmA ) = Tko.N_IDENT then
                dim as Tko.Symbol ptr syA = c.syms->SymbolAt( c.info->RefOf( nmA ) )
                if syA <> 0 then
                    dim as boolean isParam = _
                        (syA->kind = cast( ubyte, Tko.SYM_PARAMETER ))
                    dim as boolean isRef = false
                    if syA->type_ <> Tko.TYPE_NONE then
                        isRef = (c.types->Kind( syA->type_ ) = Tko.TK_REFERENCE)
                    end if
                    if isParam andalso isRef then
                        dim as long pslot = LocalFor( c, c.info->RefOf( nmA ) )
                        if pslot >= 0 then
                            dim as MirValue pv
                            pv.kind = cast( ubyte, MV_LOCAL )
                            pv.ty = cast( ubyte, MT_PTR )
                            pv.id = pslot
                            return pv
                        end if
                    end if
                end if
            end if
        end if

        dim as MirValue wrv
        if WideOperand_( c, ap->operand, wrv ) then
            if wrv.kind <> cast( ubyte, MV_NONE ) then return wrv
        end if
        return LowerAddr( c, ap->operand )

    case Tko.N_NEW
        '' 'new T' -- an ALLOCATION, not a call. It arrives here rather than at the
        '' N_CALL case because it is its own node kind.
        dim as MirValue nwv2
        if LowerNew_( c, id, nwv2 ) then return nwv2
        return v

    case Tko.N_INDEX
        '' 'p[i]' reads through the computed element address. Check does not type an
        '' N_INDEX, so the load's type comes from the POINTEE when the caller has not
        '' asked for one -- without it the load carried MT_VOID, was refused by Emit
        '' and declined, which is how 'dim as integer v = p[1]' still emitted nothing
        '' after the address itself was lowering correctly.
        '' A UDT WITH 'operator []' IS ONE CALL, and its shape is the operator's. A
        '' BYVAL operator returns the value -- there is no address, and LowerAddr below
        '' would have to invent one -- while a BYREF operator returns the element's
        '' address and is loaded through here. Asked before anything else so the call is
        '' emitted once: going through LowerAddr as well would emit a second.
        dim as MirValue ixv
        dim as boolean ixByref = false
        if LowerUdtIndexOp_( c, id, ixv, ixByref ) then
            if ixByref = false then return ixv
            dim as Tko.ListPayload ptr xp0 = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
            dim as Tko.TypeId xt0 = c.info->TypeOf_( xp0->target )
            dim as Tko.SymbolId ixs0 = UdtMemberNamed_( c, xt0, "[]" )
            dim as Tko.Symbol ptr ixsy0 = c.syms->SymbolAt( ixs0 )
            if ixsy0 = 0 then return v
            dim as MirType rmt = LowerType( ixsy0->type_, *c.types )
            if rmt = MT_VOID then return v
            '' AN AGGREGATE NEEDS ITS SIZE HERE. The address is the CALL'S RESULT, a
            '' temp with no slot to measure, so the load came out 'load [0 x i8]' and
            '' the store of it into a real 16-byte slot was refused. The operator's
            '' RETURN TYPE is the size -- a byref result is a reference to the
            '' element, so the referent is what crosses.
            dim as long rsz = 0
            if rmt = MT_AGG then
                dim as Tko.TypeId ret0 = c.types->Unqualify( ixsy0->type_ )
                if c.types->Kind( ret0 ) = Tko.TK_REFERENCE then
                    ret0 = c.types->Unqualify( c.types->Inner( ret0 ) )
                end if
                rsz = SizeOfType( c, ret0 )
            end if
            return LowerExprLoad( c, ixv, rmt, rsz )
        end if

        dim as MirType imt = mt
        if imt = MT_VOID then
            dim as Tko.ListPayload ptr xp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
            dim as Tko.TypeId xt = c.info->TypeOf_( xp->target )
            if xt <> Tko.TYPE_NONE then
                '' A STRING SUBSCRIPTED IS ITS CHARACTER -- one byte narrow, TWO wide,
                '' and UNSIGNED, because fbc writes '(int32)*(uint16*)(...)' and a sign
                '' extension would turn a character above 0x7FFF negative. Asked FIRST,
                '' because a 'zstring ptr' is a pointer too and its POINTEE is the
                '' unsized builtin, which lowers to no MIR type at all: the load then
                '' carried MT_VOID and Emit refused it.
                '' A UDT WITH 'operator []' -- the load's type is what the operator
                '' returns. LowerAddr already emits the call; without a type here the
                '' load carried MT_VOID and Emit refused it, so every 'a[ i ]' over a
                '' container declined with the call sitting right there.
                if c.types->Kind( xt ) = Tko.TK_UDT then
                    dim as Tko.SymbolId ixs2 = UdtMemberNamed_( c, xt, "[]" )
                    if ixs2 <> Tko.SYMBOL_NONE then
                        dim as Tko.Symbol ptr ixsym = c.syms->SymbolAt( ixs2 )
                        if ixsym <> 0 then
                            imt = LowerType( ixsym->type_, *c.types )
                        end if
                    end if
                end if

                dim as long cesz = CharElemSize_( c, xt )
                if cesz = 1 then
                    imt = MT_I8
                elseif cesz = 2 then
                    imt = MT_I16
                elseif c.types->Kind( xt ) = Tko.TK_POINTER then
                    imt = LowerType( c.types->Inner( xt ), *c.types )
                    dim as long pesz = CharElemSize_( c, c.types->Inner( xt ) )
                    if pesz = 1 then
                        imt = MT_I8
                    elseif pesz = 2 then
                        imt = MT_I16
                    end if
                end if
            end if
        end if
        if imt = MT_VOID then return v
        dim as MirValue ia = LowerAddr( c, id )
        if ia.kind = cast( ubyte, MV_NONE ) then return v
        '' AND AN AGGREGATE ELEMENT NEEDS ITS SIZE. The address is a computed
        '' temp -- a getelementptr -- so the emitter has no slot to measure and
        '' wrote '[0 x i8]'; 'f( pre, parray[j], post )' over a one-byte UDT
        '' stored that into a real [1 x i8] slot and clang refused the module.
        '' Check does not type an N_INDEX, so the ELEMENT type comes from the
        '' target's when the node itself has none.
        dim as long ixsz = 0
        if imt = MT_AGG then
            dim as Tko.TypeId iet = c.info->TypeOf_( id )
            if iet = Tko.TYPE_NONE then
                dim as Tko.ListPayload ptr xp2 = _
                    @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
                dim as Tko.TypeId xt2 = c.info->TypeOf_( xp2->target )
                if xt2 <> Tko.TYPE_NONE then
                    dim as Tko.TypeId bt2 = c.types->Unqualify( xt2 )
                    if c.types->Kind( bt2 ) = Tko.TK_REFERENCE then
                        bt2 = c.types->Unqualify( c.types->Inner( bt2 ) )
                    end if
                    select case c.types->Kind( bt2 )
                    case Tko.TK_POINTER, Tko.TK_ARRAY
                        iet = c.types->Inner( bt2 )
                    end select
                end if
            end if
            if iet <> Tko.TYPE_NONE then ixsz = SizeOfType( c, iet )
        end if
        return LowerExprLoad( c, ia, imt, ixsz )

    case Tko.N_DEREF
        '' A USER 'operator *' THAT RETURNS BY VALUE IS THE VALUE, not an address.
        ''
        '' LowerAddr calls the operator and hands back its result AS AN ADDRESS,
        '' which is right for the BYREF form that fb/sharedptr.bi and fb/comptr.bi
        '' declare -- the load below then reaches the object. A BY-VALUE operator
        '' returns the thing itself, and loading through it read memory at the
        '' integer it answered: 'operator *( byref lhs as foo ) as integer' gave
        '' '%t23 = load i64, ptr %t22' over a %t22 defined as i64.
        ''
        '' The two are spelled with the same token, so only the operator's OWN
        '' result type tells them apart.
        dim as Tko.SymbolId dop = c.info->RefOf( id )
        if dop <> Tko.SYMBOL_NONE then
            dim as Tko.Symbol ptr dos = c.syms->SymbolAt( dop )
            if dos <> 0 then
                '' BYREF-NESS IS ON THE DECLARATION NODE'S FLAGS, which is where
                '' LowerCall reads it too -- NF_BYREF on the N_PROC. NOT the
                '' symbol's type: a procedure's symbol carries its RESULT type, and
                '' 'byref as integer' leaves that an integer, so asking the type
                '' made every BYREF operator take the by-value path and print the
                '' ADDRESS -- 23711448096 where fbc prints 7.
                dim as boolean byrefRes = false
                dim as Tko.NodeId don = cast( Tko.NodeId, dos->payload )
                if don <> Tko.NODE_NONE then
                    if c.ast->Kind( don ) = Tko.N_PROC then
                        byrefRes = ((c.ast->nodes[cast( long, don )].flags and _
                                     Tko.NF_BYREF) <> 0)
                    end if
                end if
                if byrefRes = false then
                    dim as Tko.UnaryPayload ptr dvp = _
                        @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
                    dim as MirValue dvv
                    if LowerUserUnaryOp_( c, id, dvp, mt, dvv ) then return dvv
                end if
            end if
        end if
        '' '*p' is a LOAD THROUGH the pointer. LowerAddr already knows the shape --
        '' the address is the pointer's VALUE -- so this is the load around it.
        dim as MirValue da = LowerAddr( c, id )
        if da.kind = cast( ubyte, MV_NONE ) then return v
        '' '*pz' AND '*pw' AS A NUMBER ARE ONE CHARACTER, unsigned. Measured:
        '' 'd = *pz' over a 'zstring ptr' is '(double)(uint8)*PZ$0' and over a
        '' 'wstring ptr' it is '(double)*PW$0' out of a uint16*. The ordinary load
        '' asked for the POINTEE's type, which is a string, so it produced an
        '' aggregate the arithmetic could not take and the statement declined. A
        '' STRING context never reaches here: it goes through StrDescriptorOf_.
        '' The widening is the CONSUMER's, and unsigned -- see IsUnsignedType.
        dim as MirType cmt = DerefCharTy_( c, id )
        if cmt <> MT_VOID then return LowerExprLoad( c, da, cmt )
        '' AN AGGREGATE LOAD NEEDS ITS SIZE, and this one had no way to get it:
        '' the address is a TEMP, so the emitter cannot size it from a slot and
        '' wrote '[0 x i8]'. 'f( pre, *p, post )' over a one-byte UDT emitted
        ''
        ''     %t65 = load [0 x i8], ptr %t64
        ''     store [1 x i8] %t65, ptr %s91
        ''
        '' and clang refused the module. MIR carries an aggregate's width beside
        '' the value rather than in its type, so the load has to be told.
        if mt = MT_AGG then
            return LowerExprLoad( c, da, mt, _
                                  SizeOfType( c, c.info->TypeOf_( id ) ) )
        end if
        return LowerExprLoad( c, da, mt )

    case Tko.N_UNARY
        dim as Tko.UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]

        '' A user-defined unary operator is a call, as the binary one is.
        dim as MirValue uuv
        if LowerUserUnaryOp_( c, id, up, mt, uuv ) then return uuv

        '' A UDT THAT ONLY CASTS TO A NUMBER IS THAT NUMBER HERE -- '-v' is a call to
        '' 'operator cast( ) as integer' and a negation of its result, measured. The
        '' binary case has had this since the operator was implemented; the unary one
        '' lowered the UDT itself and negated an aggregate.
        dim as MirValue x
        if UserCastToNum_( c, up->operand, x ) = false then
            x = LowerExpr( c, up->operand )
        end if
        if x.kind = cast( ubyte, MV_NONE ) then return v
        '' THE OPERAND IS COERCED TO THE RESULT'S TYPE, which the BINARY path has
        '' always done and this one did not. Check types 'not flags' over a ULONG as a
        '' 64-bit value while the operand stays i32, and the instruction was emitted
        '' with the node's type over the operand's:
        ''
        ''     %t14 = load i32, ptr %s3
        ''     %t15 = xor i64 %t14, -1     <- i32 operand, i64 instruction
        ''
        '' -- "'%t14' defined with type 'i32' but expected 'i64'", which is fourteen
        '' of the corpus's codegen failures, every one of them fb/tui's input-mode
        '' mask. The widening follows the OPERAND's signedness, so a ULONG
        '' zero-extends and a LONG sign-extends.
        x = CoerceTy( c, x, mt, c.info->TypeOf_( up->operand ), ft )
        if x.kind = cast( ubyte, MV_NONE ) then return v
        dim as MirInst ins
        ins.ty = cast( ubyte, mt )
        ins.a = x
        select case cast( Tko.TokenKind, up->op )
        case Tko.TK_MINUS : ins.op = cast( ushort, M_NEG )
        case Tko.TK_PLUS  : return x
        case Tko.KW_NOT
            '' 'NOT' OVER A BOOLEAN IS A LOGICAL NEGATION, not a bitwise one.
            '' Measured:
            ''
            ''     dim as boolean t = true
            ''     print cint( not t )      fbc: 0      tiko: -1
            ''
            '' A BOOLEAN IS STORED AS 1, not as -1: complementing it gives -2,
            '' which is still non-zero and so still TRUE. 'not t' answered TRUE
            '' for a true operand -- and answered correctly for a FALSE one,
            '' which is why every probe that started from false agreed with fbc.
            '' The INTEGER 'not' is right and stays: 'not -1' is 0 in both.
            ''
            '' Found by build/suiterun.sh: the corpus asserts it in four files at
            '' once -- str( not b1 ), wstr( not b1 ), 'not b1 or b2' and
            '' 'not (a)' -- and every one of them had been compiled and never run.
            if IsBooleanType( c, c.info->TypeOf_( up->operand ) ) then
                dim as MirInst bz
                bz.op = cast( ushort, M_ICMP_EQ )
                bz.ty = cast( ubyte, MT_I8 )
                bz.a = x
                bz.b = ConstInt( c, 0, cast( MirType, x.ty ) )
                dim as MirValue bv = Emit( c, bz )
                if bv.kind = cast( ubyte, MV_NONE ) then return v
                return CoerceTy( c, bv, mt, c.info->TypeOf_( id ), ft )
            end if
            ins.op = cast( ushort, M_NOT )
        case else         : return v
        end select
        return Emit( c, ins )

    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.TokenKind tk = cast( Tko.TokenKind, bp->op )

        '' 'a IS T' -- the RTTI type test, and not an arithmetic operator at all.
        '' Measured:
        ''
        ''   int32 vr$2 = fb_IsTypeOf( (void*)A$0, (void*)&_ZTSN3DOGE );
        ''
        '' -- the OBJECT'S ADDRESS and the named type's RTTI record, both of which the
        '' lowerer already knows how to produce. '*p is Dog' passes the pointer itself,
        '' which is the same address by another route.
        if tk = Tko.KW_IS then
            dim as MirValue isv
            if LowerIsTypeOf_( c, bp->lhs, bp->rhs, isv ) then return isv
            return v
        end if

        '' A USER-DEFINED OPERATOR IS A CALL. Without it 'x - y' over two UDTs
        '' subtracted the raw aggregates as integers -- emitted, verified, wrong.
        dim as MirValue uov
        if LowerUserBinaryOp_( c, id, bp, mt, uov ) then return uov

        '' TUPLE EQUALITY is a SHORT-CIRCUIT CHAIN over the elements, not a comparison
        '' of two objects -- see LowerTupleCompare for the shape fbc emits.
        dim as MirValue tcv
        if LowerTupleCompare( c, id, bp, tk, tcv ) then return tcv


        '' ANDALSO and ORELSE must not evaluate the right side unless they have to,
        '' so they are control flow, not an opcode.
        if (tk = Tko.KW_ANDALSO) orelse (tk = Tko.KW_ORELSE) then
            return LowerShortCircuit( c, id, bp, mt )
        end if

        '' A STRING comparison is a runtime call, not an opcode. Without this the
        '' operands are loaded as 24-byte descriptors and compared as if they were
        '' integers -- which verifies, lowers, and means nothing.
        '' A WIDE string is not IsStringType -- it is an ARRAY of the wstring builtin
        '' -- so it fell straight past this guard and its operands were loaded as
        '' aggregates and compared as integers. Exactly the failure the comment above
        '' describes, one type along.
        '' EITHER SIDE DECIDES. Asking only the LHS meant 'trim( w ) = b' fell to the
        '' numeric path -- Check computes no type for an intrinsic call, so the left
        '' side looks like nothing -- and its operands were loaded as aggregates and
        '' compared as integers. The same file's comment says exactly that about the
        '' wide case; this is the same mistake one operand along.
        dim as boolean cmpStr = IsStringType( c, c.info->TypeOf_( bp->lhs ) ) orelse _
                                (IsWideString_( c, c.info->TypeOf_( bp->lhs ) ))
        if cmpStr = false then
            cmpStr = IsStringType( c, c.info->TypeOf_( bp->rhs ) ) orelse _
                     (IsWideString_( c, c.info->TypeOf_( bp->rhs ) ))
        end if
        '' EVERY NARROW FLAVOUR, not just the var-length one. A 'zstring * 8', a
        '' 'string * 32' and an unsized zstring through a pointer are none of them
        '' IsStringType, so 'if z1 = z2' fell to the NUMERIC path and compared the
        '' objects as INTEGERS -- silently, with no decline, where fbc calls
        '' 'fb_StrCompare( Z1, 8ll, Z2, 8ll )'. It lowered, it verified, and it was
        '' wrong.
        if cmpStr = false then
            dim as longint fcn
            dim as long lk = StrSwapKind_( c, c.info->TypeOf_( bp->lhs ), fcn )
            dim as long rk = StrSwapKind_( c, c.info->TypeOf_( bp->rhs ), fcn )
            '' ...AND THE UTF FLAVOURS, 2 and 4. 'ustring * 4' is an ARRAY of the
            '' fixustr builtin, which is neither IsStringType nor IsWideString_, so
            '' 'return ( text = o.text )' over two of them fell to the NUMERIC path
            '' and emitted 'icmp eq [8 x i8]' -- not an instruction, so the module
            '' was refused. fb/tuibuffer.bi's TuiCell.Equals is that line.
            dim as boolean lStr = (lk >= 1) andalso (lk <= 4)
            dim as boolean rStr = (rk >= 1) andalso (rk <= 4)
            cmpStr = lStr orelse rStr
        end if
        '' AND BY SHAPE, for the calls Check gives no type at all: 'wbin( b ) =
        '' wstr( "10000000" )' is two of them, so neither side looked like a string and
        '' the comparison fell to the NUMERIC path -- which then declined, taking the
        '' CU_ASSERT around it with it, 228 times in one corpus file.
        if cmpStr = false then
            cmpStr = TermIsWide_( c, bp->lhs ) orelse TermIsWide_( c, bp->rhs )
        end if
        '' ...UNLESS ONE SIDE IS A SINGLE CHARACTER AND THE OTHER A NUMBER. Measured:
        '' 'pw[0] = asc( "1" )' is '(uint64)(int64)*PW$0 == 49ull' -- an unsigned
        '' INTEGER comparison of one element -- while '*pz = "723"' beside it stays a
        '' string compare, because there the other side is a string too.
        ''
        '' The string test claimed both, and the wide compare then had no string on
        '' the numeric side: quirk/zwstr-deref.bas asserts the shape eight times.
        if cmpStr then
            dim as boolean lChar = (CharLvalueTy_( c, bp->lhs ) <> MT_VOID)
            dim as boolean rChar = (CharLvalueTy_( c, bp->rhs ) <> MT_VOID)
            if lChar andalso NumericTerm_( c, bp->rhs ) then cmpStr = false
            if rChar andalso NumericTerm_( c, bp->lhs ) then cmpStr = false
        end if
        if cmpStr then
            dim as MirValue sc = LowerStrCompare( c, id, bp, tk )
            if sc.kind <> cast( ubyte, MV_NONE ) then return sc
            return v
        end if

        '' AND WHEN THERE IS NO OPERATOR TO CALL, THE ANSWER IS NOTHING. A UDT operand
        '' with no bound operator and no type of its own fell through to the arithmetic
        '' path below and ADDED THE RAW AGGREGATES as integers -- the failure the
        '' user-operator comment above describes, one case along: it happens whenever
        '' Check could not BIND the operator rather than whenever there is none, and a
        '' GENERIC global operator is exactly that case. 'x + y' over two
        '' 'Box( of long )' emitted 'add' on the two objects, verified, and was wrong.
        ''
        '' AFTER the string tests, not before them: a UDT with 'operator cast' to a
        '' string is compared as a STRING and has no type of its own either, so
        '' refusing it here as well took 'ut = st' with it -- 350 corpus statements
        '' across the udt-wstring and udt-zstring families.
        ''
        '' The node's own TYPE is what separates the remaining two: a UDT that reaches
        '' the numeric path legitimately does so through 'operator cast', and Check
        '' types the expression when it does.
        '' A UDT OPERAND REACHES THE NUMERIC PATH THROUGH ITS OWN 'operator cast',
        '' and asking it for a value directly gets nothing. ASKED BEFORE the refusal
        '' below, because a type that HAS such an operator is exactly the case that
        '' refusal must not take: 'result = u <> 0' over a type declaring only
        '' 'operator cast( ) as integer' is measured as a call to it and a comparison
        '' of the RESULT. See UserCastToNum_.
        dim as MirValue l
        dim as MirValue r
        dim as boolean lCast = UserCastToNum_( c, bp->lhs, l )
        dim as boolean rCast = UserCastToNum_( c, bp->rhs, r )

        dim as boolean noType = (c.info->TypeOf_( id ) = Tko.TYPE_NONE)
        dim as boolean noCast = (lCast = false) andalso (rCast = false)
        if noType andalso noCast then
            dim as Tko.TypeId lud = c.types->Unqualify( c.info->TypeOf_( bp->lhs ) )
            dim as Tko.TypeId rud = c.types->Unqualify( c.info->TypeOf_( bp->rhs ) )
            dim as boolean udtOperand = (c.types->Kind( lud ) = Tko.TK_UDT) orelse _
                                        (c.types->Kind( rud ) = Tko.TK_UDT)
            if udtOperand then return v
        end if

        if lCast = false then l = LowerExpr( c, bp->lhs )
        if rCast = false then r = LowerExpr( c, bp->rhs )
        if (l.kind = cast( ubyte, MV_NONE )) orelse (r.kind = cast( ubyte, MV_NONE )) then
            return v
        end if

        '' '^' IS A LIBC CALL, not an opcode, and BOTH OPERANDS BECOME DOUBLES whatever
        '' they were: measured, 'n ^ n' over two LONGs is
        '' 'pow( (double)(int64)N, (double)(int64)N )' and the result is a double the
        '' surrounding expression narrows. It had no entry in the operator table at all,
        '' so every '^' declined.
        ''
        '' ONE DIVERGENCE, deliberate: fbc folds an exponent of exactly 2 into a
        '' MULTIPLY -- 'x ^ 2.0' is 'X * X' -- which it can only do safely for an
        '' operand it may evaluate twice. tiko-lang always calls pow. Same value, different
        '' code, and no risk of evaluating a call twice.
        if tk = Tko.TK_CARET then
            dim as MirValue pl = CoerceTy( c, l, MT_F64, c.info->TypeOf_( bp->lhs ))
            dim as MirValue pr = CoerceTy( c, r, MT_F64, c.info->TypeOf_( bp->rhs ))
            dim as FB.Array( of ulong ) pa
            pa.Push( cast( ulong, pl.kind ) ) : pa.Push( cast( ulong, pl.id ) )
            pa.Push( cast( ulong, pr.kind ) ) : pa.Push( cast( ulong, pr.id ) )
            return EmitRtl( c, RTL_POW, pa )
        end if
        '' The operand type decides signed versus unsigned, and it is the OPERANDS'
        '' type, not the result's: a comparison yields an integer either way.
        dim as Tko.TypeId lt = c.info->TypeOf_( bp->lhs )
        dim as Tko.TypeId rt = c.info->TypeOf_( bp->rhs )
        '' POINTER PLUS INTEGER IS M_PTR_ADD, and it has to be decided BEFORE the
        '' operands are widened: the widening below brings both to the WIDER type,
        '' which for a pointer operand is MT_PTR, so the integer was bitcast to a
        '' pointer and the two were added as pointers --
        ''
        ''     %t16 = add ptr %t12, %t15
        ''
        '' -- which is not an LLVM instruction. 'print *(p + 1)' over any pointer at
        '' all was 'invalid operand type for instruction' and the module was refused.
        '' NOT A NARROW CASE: every '+' and '-' between a pointer and an integer, of
        '' any width, constant or not. What kept it hidden is that 'p[ i ]' takes the
        '' INDEX path and emits M_PTR_ADD properly, and that is how the corpus and
        '' the runtime headers spell a pointer walk almost everywhere.
        ''
        '' The scaling is the same measured rule as before -- the byte offset is the
        '' index times the POINTEE's size, an ANY pointee being 1 -- and M_PTR_ADD
        '' takes a byte offset already, so nothing scales twice.
        dim as boolean lpA = PtrArithElem_( c, lt ) > 0
        dim as boolean rpA = PtrArithElem_( c, rt ) > 0
        dim as boolean addSubA = (tk = Tko.TK_PLUS) orelse (tk = Tko.TK_MINUS)
        if addSubA andalso (lpA <> rpA) then
            dim as MirType offTy = MT_I64
            if c.types->target.pointerBits = 32 then offTy = MT_I32
            dim as MirValue pv = l
            dim as MirValue ov = r
            dim as Tko.TypeId ot = rt
            if lpA = false then
                pv = r
                ov = l
                ot = lt
            end if
            pv = Coerce( c, pv, MT_PTR, false )
            ov = CoerceTy( c, ov, offTy, ot )
            dim as long eszA = PtrArithElem_( c, iif( lpA, lt, rt ) )
            if eszA > 1 then
                dim as MirInst scA
                scA.op = cast( ushort, M_MUL )
                scA.ty = cast( ubyte, offTy )
                scA.a = ov
                scA.b = ConstInt( c, eszA, offTy )
                ov = Emit( c, scA )
                if ov.kind = cast( ubyte, MV_NONE ) then return v
            end if
            '' 'p - n' IS 'p + (-n)'. M_PTR_ADD has no subtracting form and fbc
            '' writes the same thing: 'r - 2' over an 'integer ptr' is
            '' '(uint8*)R + -16'.
            if tk = Tko.TK_MINUS then
                dim as MirInst ngA
                ngA.op = cast( ushort, M_SUB )
                ngA.ty = cast( ubyte, offTy )
                ngA.a = ConstInt( c, 0, offTy )
                ngA.b = ov
                ov = Emit( c, ngA )
                if ov.kind = cast( ubyte, MV_NONE ) then return v
            end if
            dim as MirInst paA
            paA.op = cast( ushort, M_PTR_ADD )
            paA.ty = cast( ubyte, MT_PTR )
            paA.a = pv
            paA.b = ov
            return Emit( c, paA )
        end if

        dim as MirType opTy = LowerType( lt, *c.types )
        '' Both operands are brought to the WIDER of the two; the frontend's measured
        '' promotion rules already decided what the result type is.
        if TyWidth( cast( MirType, r.ty ) ) > TyWidth( opTy ) then
            opTy = cast( MirType, r.ty )
        end if
        if IsFloatTy( cast( MirType, r.ty ) ) then opTy = cast( MirType, r.ty )
        '' ...BUT A BITWISE OPERATOR HAS NO FLOAT FORM. Measured, in one probe:
        ''
        ''     #print typeof( a ^ b )        DOUBLE
        ''     #print typeof( a ^ b xor c )  INTEGER
        ''     print a ^ b xor c             13      -- (2^3) xor 5, 8 xor 5
        ''
        '' '^' is POWER and answers a double, and XOR over it converts to an INTEGER
        '' first. Widening to the float operand emitted 'xor double', which is not an
        '' instruction: clang refused the module and tests/parser/src/prec.bas -- 121
        '' lines of exactly these pairings -- produced no executable at all.
        ''
        '' Check ALREADY answers INTEGER for the expression, so the node's own type
        '' is the width to use; MT_I64 only if the node has none.
        if (IsBitwiseTk_( tk ) orelse IsShiftTk_( tk )) andalso IsFloatTy( opTy ) then
            if (mt <> MT_VOID) andalso (IsFloatTy( mt ) = false) then
                opTy = mt
            else
                opTy = MT_I64
            end if
        end if
        l = CoerceTy( c, l, opTy, lt)
        r = CoerceTy( c, r, opTy, rt)

        '' POINTER ARITHMETIC IS SCALED BY THE POINTEE, and none of it was.
        '' 'dim as short ptr q = p + 1' emitted 'add p, 1' -- one BYTE -- where fbc
        '' writes '(int16*)((uint8*)P$0 + 2ll)'. Every pointer walk over anything
        '' wider than a byte was off, silently, and it verified.
        ''
        '' Measured, all four shapes from one probe:
        ''
        ''   p + 1     over 'short ptr'    (uint8*)P + 2
        ''   1 + p     the same                          -- either side scales
        ''   r - 2     over 'integer ptr'  (uint8*)R + -16
        ''   a + 1     over 'any ptr'      (uint8*)A + 1  -- an ANY pointee is 1
        ''   q - p     both pointers       ((int64)Q - (int64)P) / 2
        ''
        '' The last is a DIVISION of the byte difference, not a scaling of an
        '' operand, so it is done after the subtract.
        dim as boolean lPtr = PtrArithElem_( c, lt ) > 0
        dim as boolean rPtr = PtrArithElem_( c, rt ) > 0
        dim as boolean addSub = (tk = Tko.TK_PLUS) orelse (tk = Tko.TK_MINUS)
        if addSub andalso (lPtr <> rPtr) then
            dim as long esz = PtrArithElem_( c, lt )
            if lPtr = false then esz = PtrArithElem_( c, rt )
            if esz > 1 then
                dim as MirInst sc
                sc.op = cast( ushort, M_MUL )
                sc.ty = cast( ubyte, opTy )
                sc.b = ConstInt( c, esz, opTy )
                if lPtr then
                    sc.a = r
                    r = Emit( c, sc )
                    if r.kind = cast( ubyte, MV_NONE ) then return v
                else
                    sc.a = l
                    l = Emit( c, sc )
                    if l.kind = cast( ubyte, MV_NONE ) then return v
                end if
            end if
        end if
        '' IMP and EQV are two instructions each and so have no entry in the table.
        if (tk = Tko.KW_IMP) orelse (tk = Tko.KW_EQV) then
            return EmitImpEqv_( c, tk, opTy, l, r )
        end if
        dim as MirOp op = BinOpFor( tk, opTy, IsUnsignedType( c, lt ) )
        if op = M_NONE then return v
        dim as MirInst ins
        ins.op = cast( ushort, op )
        ins.ty = cast( ubyte, iif( mt = MT_VOID, opTy, mt ) )
        '' A COMPARISON'S RESULT IS AN INTEGER, whatever the expression around it
        '' wants. Taking the EXPRESSION's type typed the compare itself as a float
        '' where one was expected -- 'zext i1 %t51.c to double', which is not a cast
        '' LLVM has, so the module was refused. The conversion to the wanted type
        '' happens AFTER the negation below, which is where it belongs: fbc writes
        '' '-(A < B)' and then converts that.
        if IsCmpOp_( op ) andalso IsFloatTy( cast( MirType, ins.ty ) ) then
            ins.ty = cast( ubyte, MT_I32 )
        end if

        '' THE OPERANDS ARE WIDENED TO THE RESULT, for an operation whose result IS a
        '' value of that type. The result type comes from what Check decided the
        '' expression is; the operands were coerced above to a type derived from the
        '' OPERANDS. Where FreeBASIC's promotion makes the result wider than either
        '' operand -- 'long + long' is an INTEGER, measured -- those two disagree and
        '' the instruction is malformed: 'add i64' over two i32 values.
        ''
        '' fbc widens both and truncates the store, which is exactly this:
        ''
        ''     *(int32*)&R$0 = (int32)((int64)*(int32*)&A$0 + (int64)*(int32*)&B$0);
        ''
        '' NOT FOR A COMPARISON. Its result is an integer whatever the operands are, so
        '' widening them to it would compare two values at a width neither has -- and
        '' the comment above on signedness is making the same point from the other side.
        dim as MirType resTy = cast( MirType, ins.ty )
        dim as boolean isCmp = false
        select case op
        case M_ICMP_EQ, M_ICMP_NE, M_ICMP_SLT, M_ICMP_SGT, M_ICMP_SLE, M_ICMP_SGE, _
             M_ICMP_ULT, M_ICMP_UGT, M_FCMP_EQ, M_FCMP_NE, M_FCMP_LT, M_FCMP_GT, _
             M_FCMP_LE, M_FCMP_GE
            isCmp = true
        end select
        if isCmp = false then
            if (resTy <> opTy) andalso (resTy <> MT_VOID) andalso (resTy <> MT_AGG) then
                l = CoerceTy( c, l, resTy, lt)
                r = CoerceTy( c, r, resTy, rt)
            end if
        end if
        '' A BOOLEAN COMPARED AGAINST A BOOLEAN IS COMPARED BY ITS STORAGE VALUE.
        ''
        '' A boolean CONSTANT is not already 0 or 1: 'true' is the integer -1, which
        '' is its widened MEANING and not what a boolean variable holds. So
        ''
        ''     %15 = load @b        '' 1, the stored value
        ''     %16 = const i8 -1    '' true, the widened meaning
        ''     %17 = icmp.eq %15, %16
        ''
        '' answered FALSE for a variable that is true. Measured: fbc prints true for
        '' '(b = true)' and tiko printed false, while '(b = c)' between two boolean
        '' VARIABLES was right in both and '(b = false)' was right too -- false is 0
        '' either way, which is exactly what hid it.
        ''
        '' NormaliseBool is what the STORE path already applies for the same reason,
        '' and its comment says so; this is that rule on the comparison side. Both
        '' operands are normalised rather than just the constant, because a loaded
        '' boolean is already 0 or 1 and the redundant compare is the cheap half of
        '' the trade -- the same bargain the store path struck.
        if isCmp then
            dim as boolean lBool = IsBooleanType( c, lt )
            dim as boolean rBool = IsBooleanType( c, rt )
            if lBool andalso rBool then
                l = NormaliseBool( c, l )
                r = NormaliseBool( c, r )
                if l.kind = cast( ubyte, MV_NONE ) then return v
                if r.kind = cast( ubyte, MV_NONE ) then return v
            end if
        end if
        ins.a = l
        ins.b = r
        dim as MirValue res = Emit( c, ins )

        '' ...AND THE DIFFERENCE OF TWO POINTERS IS DIVIDED by the element size,
        '' which is the one shape that scales the RESULT rather than an operand.
        dim as boolean isSub = (tk = Tko.TK_MINUS)
        dim as boolean bothPtr = lPtr andalso rPtr
        if isSub andalso bothPtr then
            dim as long dsz = PtrArithElem_( c, lt )
            if dsz > 1 then
                dim as MirInst dv
                dv.op = cast( ushort, M_SDIV )
                dv.ty = cast( ubyte, ins.ty )
                dv.a = res
                dv.b = ConstInt( c, dsz, cast( MirType, ins.ty ) )
                res = Emit( c, dv )
                if res.kind = cast( ubyte, MV_NONE ) then return v
            end if
        end if

        '' A COMPARISON USED AS A VALUE IS NEGATED. Measured, in every value position
        '' fbc has: 'R = -(A < B)', 'print -(A < B)', 'Y = (int8)-(A < B)' -- so the
        '' answer is -1 and 0, not 1 and 0. tiko-lang emitted the bare comparison, and
        '' every printed, stored or passed comparison in the corpus was off by a sign.
        ''
        '' NOT for the one node being lowered as a CONDITION: a branch only asks
        '' whether it is nonzero, and fbc emits no negation there either.
        if IsCmpOp_( op ) andalso (id <> c.rawCmpNode) then
            dim as MirInst neg
            neg.op = cast( ushort, M_NEG )
            neg.ty = ins.ty
            neg.a = res
            res = Emit( c, neg )
            if res.kind = cast( ubyte, MV_NONE ) then return v
            '' ...AND THEN CONVERTED, for the float case the compare could not
            '' carry itself. -1 and 0 become -1.0 and 0.0.
            if (mt <> MT_VOID) andalso (mt <> MT_AGG) then
                if cast( MirType, res.ty ) <> mt then
                    res = Coerce( c, res, mt, false )
                end if
            end if
            return res
        end if
        return res

    case Tko.N_CALL
        '' THE EXPRESSION CALL CHAIN -- a dozen constructs that are spelled like a
        '' call and are not one. It lives in lowerintr.bas, with the intrinsics it
        '' dispatches to, because this file is at its size limit.
        return LowerCallExpr_( c, id, mt )
    end select

    return v
end function
