'' lowerstrdesc.bas -- a narrow string operand as a DESCRIPTOR POINTER.
''
'' Split out of lowersub.bas at the 1500-line cap. Nothing about it changed in the move.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

using Tko

'' Defined in lowerstr.bas: what kind of string a type is, for the runtime's argument
'' shape. Declared here for the same reason lowersub.bas declares it.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

'' IS 'id' A NAME BOUND TO A PROCEDURE -- 'FreeS', 'o.GetS', 'T.StS', a property 'o.PS'?
'' Read as a value, every one of them is a CALL, and LowerAddr's answer for one is the
'' procedure's CODE ADDRESS: a reader that falls back on LowerAddr for a string it
'' cannot otherwise place hands the runtime machine code as a descriptor. PRINT, WRITE,
'' PRINT USING and 'wstr( )' all did, for 'print o.GetS'. Asked of the NAME'S OWN SYMBOL
'' rather than of the node kind -- see PrintOne on why an N_MEMBER alone is not enough.
function NamesProc_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    id = Unparen_( c, id )
    if (c.ast->Kind( id ) <> Tko.N_IDENT) andalso (c.ast->Kind( id ) <> Tko.N_MEMBER) then
        return false
    end if
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
    if s = 0 then return false
    return (s->kind = cast( ubyte, Tko.SYM_PROC ))
end function

'' A narrow string operand as an FBSTRING DESCRIPTOR pointer, however it is spelled:
'' an addressable string, a literal (which borrows a temporary descriptor from the
'' runtime), a string 'iif', or another member of this family.
function StrDescriptorOf_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    id = Unparen_( c, id )

    '' A STRING-TO-STRING 'cast' IS THE IDENTITY -- see StrIdentityConvOperand_.
    dim as Tko.NodeId sic = StrIdentityConvOperand_( c, id )
    if sic <> Tko.NODE_NONE then id = Unparen_( c, sic )

    '' A STRING CONSTANT IS ITS TEXT. Recognised here rather than left to the type
    '' test below, which would claim it and then ask a constant for an address.
    '' ...and ADJACENT LITERALS, which are one literal: '"a" "1"' folds to "a1" before
    '' it reaches any call, so 'print "a" "1"' has a text and not an expression.
    dim as string constText
    dim as boolean constish = IsConstNameRef_( c, id )
    if c.ast->Kind( id ) = Tko.N_STRCAT then constish = true
    if constish then
        if ConstStringTextOf_( c, id, constText ) then
            dim as FB.Array( of ulong ) ca
            ca.Push( cast( ulong, MV_GLOBAL ) )
            ca.Push( cast( ulong, c.m->AddStringLiteral( constText, *c.names ) ) )
            ca.Push( cast( ulong, MV_CONST_INT ) )
            ca.Push( cast( ulong, len( constText ) ) )
            outv = EmitRtl( c, RTL_STR_TEMPZ, ca )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
    end if

    '' '__FUNCTION__' IS A STRING LITERAL, folded to the enclosing procedure's name.
    ''
    '' The VALUE path already knew that -- LowerPredeclared answers with the mangled
    '' name -- and every STRING path bypassed it, so 'print __FUNCTION__',
    '' 'dim s as string = __FUNCTION__' and 'len( __FUNCTION__ )' all asked a
    '' predeclared name for an address it has not got, and all three declined.
    ''
    '' Measured: fbc folds the whole thing at compile time --
    '' 'fb_StrAllocTempDescZEx( (char*)"S", 1ll )' -- and folds a concatenation
    '' containing one to a single literal.
    if c.ast->Kind( id ) = Tko.N_IDENT then
        dim as Tko.Symbol ptr fns = c.syms->SymbolAt( c.info->RefOf( id ) )
        if fns <> 0 then
            if (fns->flags and Tko.SYMF_FUNCNAME) <> 0 then
                dim as string fnText = Tko.Mangle.ProcNameOrMain( _
                    *c.syms, c.curProcSym, *c.names )
                dim as FB.Array( of ulong ) fa
                fa.Push( cast( ulong, MV_GLOBAL ) )
                fa.Push( cast( ulong, c.m->AddStringLiteral( fnText, *c.names ) ) )
                fa.Push( cast( ulong, MV_CONST_INT ) )
                fa.Push( cast( ulong, len( fnText ) ) )
                outv = EmitRtl( c, RTL_STR_TEMPZ, fa )
                return (outv.kind <> cast( ubyte, MV_NONE ))
            end if
        end if
    end if

    if c.ast->Kind( id ) = Tko.N_STRING_LIT then
        dim as string litText = StringLitText_( c, id )
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, MV_GLOBAL ) )
        ta.Push( cast( ulong, c.m->AddStringLiteral( litText, *c.names ) ) )
        ta.Push( cast( ulong, MV_CONST_INT ) )
        ta.Push( cast( ulong, len( litText ) ) )
        outv = EmitRtl( c, RTL_STR_TEMPZ, ta )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    '' 'dir( ... )' -- an INTRINSIC whose result is a descriptor pointer already, so it
    '' belongs here rather than on the value path: every use of it is a string, and
    '' 'print dir( "*" )' and 's = dir( "*" )' both arrive by this route.
    if LowerDir( c, id, outv ) then return true

    '' 'input( n [, [#]f] )' IN EXPRESSION POSITION HANDS BACK A DESCRIPTOR, exactly as
    '' a string-returning call does -- 'FBSTRING* vr$4 = fb_FileStrInput( 2ll, 1 );' --
    '' and its node is an N_INTRINSIC rather than an N_CALL, so nothing here claimed it
    '' and 'dim as string d = input( 2, #1 )' declined. The wide half lowered, because
    '' its consumer is structural about the shape rather than about the node kind.
    if c.ast->Kind( id ) = Tko.N_INTRINSIC then
        dim as Tko.StmtPayload ptr iisp = StmtOf( c, id )
        if (iisp->extra and 8) <> 0 then
            if cast( Tko.TokenKind, iisp->op ) = Tko.KW_INPUT then
                dim as MirValue iiv = LowerExpr( c, id )
                if iiv.kind <> cast( ubyte, MV_NONE ) then
                    outv = iiv
                    return true
                end if
            end if
        end if
    end if

    '' A CALL TO A STRING-RETURNING FUNCTION, before the type test claims it: an N_CALL
    '' is string-typed and has no address, so 'print f( 2 )' declined outright.
    ''
    '' Typed MT_PTR, not left to the expression's own type. A string is an AGGREGATE to
    '' LowerType, so the descriptor pointer would come back sign-extended and bitcast.
    if c.ast->Kind( id ) = Tko.N_CALL then
        if IsStringType( c, c.info->TypeOf_( id ) ) then
            dim as Tko.ListPayload ptr scp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
            dim as Tko.SymbolId scallee = c.info->RefOf( id )
            if scallee = Tko.SYMBOL_NONE then scallee = c.info->RefOf( scp->target )
            if scallee <> Tko.SYMBOL_NONE then
                dim as MirValue scv = LowerCallParts( c, scp->target, scallee, _
                                                      scp->first, scp->count, MT_PTR )
                if scv.kind <> cast( ubyte, MV_NONE ) then
                    outv = scv
                    return true
                end if
            end if
        end if
    end if

    '' A BARE STRING-RETURNING FUNCTION NAME, BEFORE THE TYPE TEST. 's = curdir' names
    '' a function whose TYPE is string, so the branch below claims it and asks for its
    '' ADDRESS -- and the address of a function is a well-typed pointer, so the whole
    '' thing verified with fb_CurDir's entry point handed to fb_StrAssign as a
    '' descriptor.
    ''
    '' The same ordering trap the narrow and wide concat paths set: a recogniser placed
    '' AFTER the type test that would swallow it. Fifth occurrence.
    ''
    '' The call's RESULT IS the descriptor pointer -- fbc writes 'FBSTRING* vr =
    '' fb_CurDir( ); fb_StrAssign( &S, -1, vr, -1, 0 )'.
    dim as MirValue bpv
    if LowerBareProcCall_( c, id, MT_PTR, bpv ) then
        outv = bpv
        return true
    end if

    '' A STRING-VALUED PROPERTY IS A CALL, and the type test below would swallow it.
    ''
    '' 'a.first' over 'property first( ) as string' IS string-typed, so the branch
    '' below claimed it and asked LowerAddr for an address -- and the thing it names
    '' is a PROCEDURE, so the answer was the GETTER'S CODE ADDRESS:
    ''
    ''     %6 = func.addr ptr _ZN4ARR312FIRST__get__Ev
    ''     call.rtl void fb_PrintString(0, %6, 1)
    ''
    '' -- the function's machine code printed as a descriptor, and an access
    '' violation. A property of any other type was right all along, because
    '' LowerExpr's N_MEMBER case asks LowerPropertyGet_ first; only the STRING read
    '' comes through here instead. Measured: fbc prints 'zero'.
    ''
    '' The same ordering trap as the bare-proc call just above -- a recogniser placed
    '' after the type test that would swallow it. Sixth occurrence.
    '' ONLY WHEN THE MEMBER REALLY IS A PROPERTY, tested on its OWN symbol rather than
    '' left to LowerPropertyGet_. That helper walks the member's whole OVERLOAD CHAIN
    '' looking for an accessor, and inside a generic instantiation the chain reaches
    '' one that does not belong to this member: it claimed 's.fn' -- a
    '' PROCEDURE-POINTER FIELD of 'Slot( of F )' -- and
    '' tests/vendor/fbc-tests/generics/generic-procptr-typearg.bas went from passing to
    '' failing its ViaSlot assertion. Bisected against that file, which is the only
    '' reliable signal here: a hand-cut reduction of it reads uninitialised memory and
    '' answers either way.
    if c.ast->Kind( id ) = Tko.N_MEMBER then
        dim as Tko.Symbol ptr msy3 = c.syms->SymbolAt( c.info->RefOf( id ) )
        dim as boolean isProp3 = false
        if msy3 <> 0 then
            if msy3->kind = cast( ubyte, Tko.SYM_PROC ) then
                dim as Tko.NodeId mpn3 = cast( Tko.NodeId, msy3->payload )
                if mpn3 <> Tko.NODE_NONE then
                    if c.ast->Kind( mpn3 ) = Tko.N_PROC then
                        isProp3 = (StmtOf( c, mpn3 )->op = _
                            cast( ushort, Tko.KW_PROPERTY ))
                    end if
                end if
            end if
        end if
        if isProp3 then
            dim as MirValue pgv2
            if LowerPropertyGet_( c, id, pgv2 ) then
                outv = pgv2
                return (outv.kind <> cast( ubyte, MV_NONE ))
            end if
        end if
    end if

    if IsStringType( c, c.info->TypeOf_( id ) ) then
        outv = LowerAddr( c, id )
        if outv.kind <> cast( ubyte, MV_NONE ) then return true
    end if

    '' A STRING RVALUE FROM THE INTRINSIC FAMILY -- 'mid( s, 1 )', 'trim', 'ucase',
    '' 'hex', 'space' -- whose callee is no symbol at all, so the branch above types it
    '' as a string and then asks a CALL for an address. Its result already IS a
    '' descriptor pointer, which is what every caller here wants.
    dim as MirValue srv2
    if LowerStrRvalue( c, id, srv2 ) then
        outv = srv2
        return true
    end if

    '' A 'string * N' BORROWS A DESCRIPTOR FROM ITS OWN ENTRY POINT, taking the TAGGED
    '' length -- 'fb_StrAllocTempDescF( A, -9223372036854775776ll )'. It is not the Z
    '' form, which strlen's a NUL-terminated buffer a fixed string does not have.
    dim as longint fdn
    if StrSwapKind_( c, c.info->TypeOf_( id ), fdn ) = 3 then
        dim as MirValue fa = LowerAddr( c, id )
        if fa.kind <> cast( ubyte, MV_NONE ) then
            dim as FB.Array( of ulong ) fta
            fta.Push( cast( ulong, fa.kind ) ) : fta.Push( cast( ulong, fa.id ) )
            PushStrLen_( c, fta, fdn )
            outv = EmitRtl( c, RTL_STR_TEMPF, fta )
            if outv.kind <> cast( ubyte, MV_NONE ) then return true
        end if
    end if

    '' A ZSTRING * N has no descriptor -- it is a char array -- so it borrows a
    '' temporary one over its own bytes, from the NO-LENGTH variant that works the
    '' length out from the terminator. That is what fbc emits for 'trim( z )':
    '' 'vr = fb_StrAllocTempDescZ( Z )' and then the trim on vr.
    dim as longint zn
    if StrSwapKind_( c, c.info->TypeOf_( id ), zn ) = 1 then
        dim as MirValue za = LowerAddr( c, id )
        if za.kind <> cast( ubyte, MV_NONE ) then
            dim as FB.Array( of ulong ) ta
            ta.Push( cast( ulong, za.kind ) ) : ta.Push( cast( ulong, za.id ) )
            outv = EmitRtl( c, RTL_STR_TEMPZ_NOLEN, ta )
            if outv.kind <> cast( ubyte, MV_NONE ) then return true
        end if
    end if
    '' A CONCATENATION, before any type test: a concat IS string-typed, so the
    '' IsStringType branch above would claim it and ask for an address it has not got.
    dim as MirValue ccv
    if ConcatToTemp_( c, id, ccv ) then
        outv = ccv
        return true
    end if

    '' A UDT WITH 'operator cast' TO A STRING. Tried before the general fallback: the
    '' conversion is what makes the operand a string at all, and without it 'trim( u )'
    '' declined outright.
    dim as boolean ucRaw = false
    dim as MirValue ucv
    if UserCastToStr_( c, id, ucv, ucRaw ) then
        if ucRaw = false then
            outv = ucv
            return true
        end if
        '' A BARE char* borrows a temporary descriptor, exactly as a 'zstring * N'
        '' variable does -- and from the NO-LENGTH entry point, because a converted
        '' result carries no declared length to pass.
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, ucv.kind ) ) : ta.Push( cast( ulong, ucv.id ) )
        outv = EmitRtl( c, RTL_STR_TEMPZ_NOLEN, ta )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' AN IIF, whatever its arms look like: everything that asks for a descriptor is
    '' already in a string context, and the arm types cannot answer it -- Check
    '' computes no type for an intrinsic call, so 'iif( c, hex( 1 ), hex( 2 ) )' looks
    '' like an iif over nothing and declined the statement around it.
    dim as Tko.NodeId iC, iT, iE
    if IsIifCall_( c, id, iC, iT, iE ) then
        return LowerStringIif_( c, iC, iT, iE, outv )
    end if
    return LowerStrRvalue( c, id, outv )
end function

end namespace
