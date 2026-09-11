'' lowerctor.bas -- constructor selection for a DIM initialiser.
''
'' Split out of lower.bas, which is at its size limit.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long



'' 'dim as T x = T( 5 )'. The initialiser parses as a CALL on the type's name, so it
'' is recognised by the callee naming the variable's own UDT rather than by any
'' special syntax. Returns false when this is not a constructor call.
'' ONE CONSTRUCTOR ARGUMENT, converted the way the parameter needs rather than the way
'' the expression came. Two of the three cases are not a Coerce:
''
''   byval p as zstring ptr   <- a STRING passes its DATA POINTER, '*(char**)&S'
''   byref s as string        <- a DESCRIPTOR, which a literal or an rvalue has not got
''
'' Shared by both constructor paths, because 'dim u as U = str( t )' and
'' 'dim u as U = U( str( t ) )' differ only in spelling.
private function CtorArgValue_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outv as MirValue ) as boolean

    if argNode = Tko.NODE_NONE then return false
    dim as Tko.TypeId at = c.info->TypeOf_( argNode )

    if pt <> Tko.TYPE_NONE then
        dim as Tko.TypeId u = c.types->Unqualify( pt )
        if c.types->Kind( u ) = Tko.TK_POINTER then
            dim as Tko.TypeId pin = c.types->Unqualify( c.types->Inner( u ) )
            if c.types->Kind( pin ) = Tko.TK_BUILTIN then
                '' AN ARGUMENT WITH NO TYPE IS STILL TRIED. Check computes no type
                '' for an 'iif' call -- an arm may be an intrinsic with no type
                '' either -- so 'dim a as U = iif( c, wstr( "a" ), u2 )' asked
                '' LowerExpr for a value a wide iif does not have, and declined.
                '' WideOperand_ and ZstrDataOf_ are both STRUCTURAL about iif, which
                '' is what makes asking them safe here: the PARAMETER already says
                '' which width is wanted.
                dim as boolean untyped = (at = Tko.TYPE_NONE)
                '' A FIXED-LENGTH STRING ARGUMENT COUNTS AS ONE. 'zstring * 50' is
                '' an ARRAY of the character builtin, so IsStringType says no to it
                '' -- and 'dim a as uzstr_t = iif( expr, t1, t2 )' over two of them
                '' then fell through to LowerExpr, which an iif has no value for.
                '' udt-zstring/iif.bas is four statements of it.
                dim as longint askn
                dim as long ask = StrSwapKind_( c, at, askn )
                dim as boolean narrowArg = IsStringType( c, at )
                if narrowArg then narrowArg = (IsUStringType( c, at ) = false)
                if narrowArg = false then narrowArg = (ask = 1) orelse (ask = 3)
                dim as boolean wideArg = IsWideString_( c, at )
                if wideArg = false then wideArg = (ask = 2) orelse (ask = 4)
                if c.types->BuiltinOf( pin ) = Tko.TY_ZSTRING then
                    if narrowArg then return ZstrDataOf_( c, argNode, outv )
                    if untyped then
                        if ZstrDataOf_( c, argNode, outv ) then return true
                    end if
                end if
                if c.types->BuiltinOf( pin ) = Tko.TY_WSTRING then
                    if wideArg then return WideOperand_( c, argNode, outv )
                    if untyped then
                        if WideOperand_( c, argNode, outv ) then return true
                    end if
                end if
            end if
        end if
        if IsStringType( c, u ) then
            if StrDescriptorOf_( c, argNode, outv ) then return true
        end if

        '' A BYREF UDT PARAMETER TAKES AN ADDRESS. The parameter's type IS a
        '' reference, and lowering one gives MT_PTR -- so the tail below 'coerced'
        '' the loaded aggregate to a pointer instead of taking the object's address.
        '' Measured: 'WeakPtr( of T )( sp )' over a 'byref rhs as SharedPtr( of T )'
        '' emitted 'ptr %t945' where %t945 is 'load [8 x i8]', and clang refused it.
        ''
        '' STRINGS FIRST, because a byref string parameter wants the DESCRIPTOR that
        '' StrDescriptorOf_ above knows how to find, not a plain address.
        if c.types->Kind( u ) = Tko.TK_REFERENCE then
            dim as Tko.TypeId rin = c.types->Unqualify( c.types->Inner( u ) )
            if c.types->Kind( rin ) = Tko.TK_UDT then
                dim as MirValue ra = LowerAddr( c, argNode )
                if ra.kind <> cast( ubyte, MV_NONE ) then
                    outv = ra
                    return true
                end if
            end if
        end if
    end if

    outv = LowerExpr( c, argNode )
    if outv.kind = cast( ubyte, MV_NONE ) then return false
    if pt <> Tko.TYPE_NONE then
        dim as MirType pmt = LowerType( pt, *c.types )
        if (pmt <> MT_VOID) andalso (pmt <> MT_AGG) then
            outv = CoerceTy( c, outv, pmt, pt)
        end if
    end if
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' A CHARACTER-POINTER CONVERTING CONSTRUCTOR, chosen by the initialiser's WIDTH.
''
'' Two shapes need it and neither can be picked by TYPE. An 'iif' has no type at
'' all -- Check computes none, deliberately, because an arm may be an intrinsic
'' with no type either -- and a FIXED-LENGTH string argument has one the overload
'' costing cannot convert to a pointer, so 'dim u4 as uzstr_t = wstr( u1 )' found
'' no constructor while 'chr( 12 )' beside it did.
''
'' Measured, fbc calls the converting constructor with the wide temporary:
'' '_ZN14UZSTRING_FIXEDC1EPKw( &U4$0, (uint16*)TMP$3$0 )'.
''
'' THE WIDTH DECIDES WHICH ONE. A type like the corpus's UZSTRING_FIXED declares
'' BOTH -- over 'const zstring const ptr' and over the wstring twin -- and taking
'' the first arity-1 constructor picked the narrow one for a wide argument, which
'' then had no value to build.
private function CharPtrCtorInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init_ as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean

    '' ...AND SO HAS ANY UNBOUND CALL. 'dim u4 as uzstr_t = wstr( u1 )' is the
    '' same shape as the iif this branch was written for: Check computes no
    '' type for the callee, so there is nothing to pick a constructor by, and
    '' the CONSTRUCTOR is again what supplies the missing width. Measured, fbc
    '' calls the converting constructor with the wide temporary:
    '' '_ZN14UZSTRING_FIXEDC1EPKw( &U4$0, (uint16*)TMP$3$0 )'.
    ''
    '' The iif test is gone rather than widened: what the branch actually needs
    '' is a one-argument constructor over a character POINTER and an argument
    '' CtorArgValue_ can build, and both are tested below.
    '' THE WIDTH DECIDES WHICH ONE. A type like the corpus's UZSTRING_FIXED
    '' declares BOTH -- 'constructor( byval rhs as const zstring const ptr )'
    '' and the wstring twin -- and taking the first arity-1 constructor picked
    '' the narrow one for a wide argument, which then had no value to build.
    dim as boolean wantWide = TermIsWide_( c, init_ )
    dim as Tko.SymbolId sc = Tko.SYMBOL_NONE
    dim as Tko.TypeId spt = Tko.TYPE_NONE
    dim as Tko.SymbolId sccur = StructorOf( c, t, "__ctor" )
    dim as Tko.SymbolId scfall = Tko.SYMBOL_NONE
    dim as Tko.TypeId sptfall = Tko.TYPE_NONE
    while sccur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr scs = c.syms->SymbolAt( sccur )
        if scs = 0 then exit while
        if ParamCountOf( c, sccur ) = 1 then
            dim as Tko.TypeId cpt = ParamTypeAt( c, sccur, 0 )
            if cpt <> Tko.TYPE_NONE then
                dim as Tko.TypeId cu2 = c.types->Unqualify( cpt )
                if c.types->Kind( cu2 ) = Tko.TK_POINTER then
                    dim as Tko.TypeId cin = _
                        c.types->Unqualify( c.types->Inner( cu2 ) )
                    if c.types->Kind( cin ) = Tko.TK_BUILTIN then
                        dim as Tko.BuiltinType cb = c.types->BuiltinOf( cin )
                        dim as boolean isW = (cb = Tko.TY_WSTRING)
                        dim as boolean isZ = (cb = Tko.TY_ZSTRING)
                        if isW orelse isZ then
                            if scfall = Tko.SYMBOL_NONE then
                                scfall = sccur
                                sptfall = cpt
                            end if
                            if isW = wantWide then
                                sc = sccur
                                spt = cpt
                                exit while
                            end if
                        end if
                    end if
                end if
            end if
        end if
        sccur = scs->nextOverload
    wend
    if sc = Tko.SYMBOL_NONE then
        sc = scfall
        spt = sptfall
    end if
    if sc = Tko.SYMBOL_NONE then return false
    if spt = Tko.TYPE_NONE then return false
    dim as MirValue iav
    if CtorArgValue_( c, init_, spt, iav ) = false then return false
    dim as FB.Array( of ulong ) iargs
    iargs.Push( cast( ulong, iav.kind ) )
    iargs.Push( cast( ulong, iav.id ) )
    EmitStructorCall( c, sc, slot, selfv, @iargs )
    return true
end function

'' 'dim u as U = s' -- A CONVERTING CONSTRUCTOR, chosen by the initialiser's type.
''
'' Only the explicit 'dim u as U = U( s )' spelling was handled, so this one fell
'' through to the DEFAULT constructor and the initialiser was DROPPED: the object was
'' built empty, no store, no decline, no diagnostic. fbc emits
'' '_ZN1UC1EPKc( &U1, *(char**)&S )'.
'' The destination is a SLOT or, for an ARRAY ELEMENT, an address -- selfv. An element
'' of a brace initialiser has no slot of its own.
function LowerConvCtorInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init_ as Tko.NodeId, byval selfv as MirValue ptr ) as boolean

    if init_ = Tko.NODE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    '' AN ARRAY INITIALISER -- 'dim x as T = a( )' over 'constructor T( array( ) as
    '' integer )'. The argument is a DESCRIPTOR and its type is the ARRAY's, not the
    '' element's, so it is taken from the name inside the empty call rather than from
    '' the call node. structs/udt-array-ops-1.bas is 24 statements of this one shape.
    dim as MirValue adv
    dim as boolean fromArray = ArrayDescArg_( c, init_, true, adv )
    dim as Tko.TypeId it = c.info->TypeOf_( init_ )
    if fromArray then
        dim as Tko.ListPayload ptr alp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, init_ )].data )]
        it = c.info->TypeOf_( alp->target )
    end if
    '' AN 'iif' HAS NO TYPE AT ALL -- Check computes none for one, deliberately,
    '' because an arm may be an intrinsic with no type either and every wide and
    '' narrow path is STRUCTURAL about it instead. So 'dim a as U = iif( c,
    '' wstr( "a" ), u2 )' arrived here with nothing to pick a constructor by.
    ''
    '' The CONSTRUCTOR is what supplies the missing type: a one-argument converting
    '' constructor over a zstring or wstring POINTER names the width, and
    '' CtorArgValue_ is structural about iif in both. udt-wstring/iif.bas and
    '' udt-zstring/iif.bas write nothing else.
    if it = Tko.TYPE_NONE then
        return CharPtrCtorInit_( c, slot, t, init_, selfv )
    end if
    '' The same type is a COPY, which the caller has already handled -- and a paren
    '' initialiser list is field stores, not a conversion.
    if c.types->Unqualify( it ) = c.types->Unqualify( t ) then return false

    dim as Tko.SymbolId ctors = StructorOf( c, t, "__ctor" )
    if ctors = Tko.SYMBOL_NONE then return false
    dim as FB.Array( of ulong ) argT
    argT.Push( cast( ulong, it ) )
    dim as Tko.SymbolId pick = PickCtor( c, ctors, argT )
    '' ...AND A FIXED-LENGTH STRING ARGUMENT HAS A TYPE THE COSTING CANNOT CONVERT
    '' to a character POINTER, so 'dim u4 as uzstr_t = wstr( u1 )' found no
    '' constructor while 'chr( 12 )' beside it did. Same answer as the untyped case
    '' above, and the same code.
    if pick = Tko.SYMBOL_NONE then
        return CharPtrCtorInit_( c, slot, t, init_, selfv )
    end if
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ps->payload )
    if pn = Tko.NODE_NONE then return false

    '' The parameter's type, for the conversion the argument needs.
    dim as Tko.TypeId pt = Tko.TYPE_NONE
    dim as boolean ptByref = false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        pt = c.info->TypeOf_( StmtOf( c, prm )->a )
        ptByref = ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
        exit for
    next

    dim as MirValue av
    '' A BYREF UDT PARAMETER TAKES AN ADDRESS, and the ARGUMENT'S OWN TYPE says so:
    '' the parameter's does NOT, because a reference is transparent to Check and
    '' TypeOf_ answers with the referent. So this asked CtorArgValue_ for a value,
    '' got the loaded aggregate, and 'coerced' it to the pointer the signature
    '' wanted. Measured: 'dim as WeakPtr( of Probe ) w = a' over a
    '' 'byref rhs as SharedPtr( of Probe )' emitted 'ptr %t945' with %t945 defined
    '' as 'load [8 x i8]', and clang refused the module.
    dim as boolean tookAddr = false
    if (fromArray = false) andalso ptByref then
        dim as Tko.TypeId iu = c.types->Unqualify( it )
        if c.types->Kind( iu ) = Tko.TK_UDT then
            dim as MirValue ra = LowerAddr( c, init_ )
            if ra.kind <> cast( ubyte, MV_NONE ) then
                av = ra
                tookAddr = true
            end if
        end if
    end if
    if tookAddr then
    elseif fromArray then
        av = adv
    elseif CtorArgValue_( c, init_, pt, av ) = false then
        return false
    end if
    dim as FB.Array( of ulong ) cargs
    cargs.Push( cast( ulong, av.kind ) )
    cargs.Push( cast( ulong, av.id ) )
    EmitStructorCall( c, pick, slot, selfv, @cargs )
    return true
end function

'' 'x = 5' OVER A TYPE DECLARING 'operator let( byval i as integer )'.
''
'' The same-type assignment operator is handled in lowerassign.bas, which tests that
'' both sides name ONE type -- 'operator let' takes its own type by reference there.
'' A CONVERTING let takes something else entirely, so that test can never reach it and
'' the statement fell through to the ordinary store: the scalar was coerced to the
'' UDT's own MirType and stored, which is not a narrowing but a nonsense --
'' '%t6 = trunc i64 5 to [0 x i8]', IR that verified here and that clang rejects with
'' 'invalid cast opcode for cast from i64 to [0 x i8]'.
''
'' Measured, fbc calls the operator with the scalar byval and constructs nothing:
''
''     struct $1V X$0;
''     __builtin_memset( &X$0, 0, 8ll );
''     _ZN1VaSEu7INTEGER( &X$0, 5ll );
''
'' The OVERLOAD is picked by the argument's type and the argument is converted the way
'' the PARAMETER asks -- the same two rules, and the same two helpers, that
'' LowerConvCtorInit_ above uses for 'dim as T x = 5'. The shape is settled before
'' LowerAddr, because an address emitted for an overload that does not exist is dead.
function LowerUserLetConv_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval t as Tko.TypeId, _
      byval value as Tko.NodeId ) as boolean

    if value = Tko.NODE_NONE then return false
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.TypeId vt = c.info->TypeOf_( value )
    if vt = Tko.TYPE_NONE then return false
    '' The same type is the COPY the caller has already handled.
    if c.types->Unqualify( vt ) = c.types->Unqualify( t ) then return false

    dim as Tko.SymbolId lets = StructorOf( c, t, "let" )
    if lets = Tko.SYMBOL_NONE then return false
    dim as FB.Array( of ulong ) argT
    argT.Push( cast( ulong, vt ) )
    dim as Tko.SymbolId pick = PickCtor( c, lets, argT )
    if pick = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ps->payload )
    if pn = Tko.NODE_NONE then return false

    '' The parameter's type, for the conversion the argument needs.
    dim as Tko.TypeId pt = Tko.TYPE_NONE
    dim as boolean ulByref = false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    if pp = 0 then return false
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        pt = c.info->TypeOf_( StmtOf( c, prm )->a )
        ulByref = ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
        exit for
    next

    dim as MirValue da = LowerAddr( c, target )
    if da.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue av
    '' A BYREF UDT PARAMETER TAKES AN ADDRESS -- see LowerConvCtorInit_ for the
    '' same trap: the parameter's TYPE does not say byref, because a reference is
    '' transparent to Check, so only the N_PARAM's own flag can. Measured:
    '' 'w = a' over 'operator let( byref rhs as SharedPtr( of Probe ) )' passed the
    '' loaded aggregate where the signature wants a pointer.
    dim as boolean ulTook = false
    if ulByref then
        dim as Tko.TypeId vu = c.types->Unqualify( c.info->TypeOf_( value ) )
        if c.types->Kind( vu ) = Tko.TK_UDT then
            dim as MirValue ura = LowerAddr( c, value )
            if ura.kind <> cast( ubyte, MV_NONE ) then
                av = ura
                ulTook = true
            end if
        end if
    end if
    if (ulTook = false) andalso (CtorArgValue_( c, value, pt, av ) = false) then
        return false
    end if
    dim as FB.Array( of ulong ) largs
    largs.Push( cast( ulong, av.kind ) )
    largs.Push( cast( ulong, av.id ) )
    EmitStructorCall( c, pick, -1, @da, @largs )
    return true
end function


function LowerCtorInit _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init_ as Tko.NodeId, byval selfv as MirValue ptr ) as boolean

    if init_ = Tko.NODE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false

    '' TWO SPELLINGS, one meaning. 'dim as T x = T( 123 )' is an N_CALL naming the type;
    '' 'dim as T x = type<T>( 123 )' is the anonymous literal, an N_TUPLE. When the type
    '' HAS A CONSTRUCTOR both are a constructor call -- measured, fbc emits
    '' '_ZN7CTORUDTC1Ei( &A$0, 123 )' for either.
    ''
    '' Without the second shape here the literal fell through to the field-list path,
    '' which built a temporary and passed ITS ADDRESS as the constructor's argument:
    '' '_ZN7CTORUDTC1Ei( @a, @$tmp2 )' where 123 belonged. It lowered and it verified.
    dim as boolean isLiteral = false
    if c.ast->Kind( init_ ) = Tko.N_TUPLE then
        if (c.ast->nodes[cast( long, init_ )].flags and Tko.NF_TYPE_LITERAL) = 0 then
            return false
        end if
        isLiteral = true
    elseif c.ast->Kind( init_ ) <> Tko.N_CALL then
        return false
    end if

    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init_ )].data )]
    if isLiteral = false then
        if cp->target = Tko.NODE_NONE then return false
        if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
        dim as Tko.IdentPayload ptr ip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
        '' A GENERIC IS NAMED BY ITS TEMPLATE AT THE CALL AND BY ITS INSTANTIATION
        '' IN THE TYPE: 'Box( of long )( 7 )' spells the callee 'Box' while the
        '' declared type is 'Box<6>', so a name comparison alone said no and the
        '' whole thing fell through to the copy path -- which built a temporary,
        '' constructed into that and copied the bytes out, leaving the temporary's
        '' own destructor unrun. Resolve records the instantiation on the callee, so
        '' the TYPE answers where the name cannot.
        if ip->name <> c.types->NameOf( t ) then
            '' ...and ONLY when the callee NAMES A TYPE. Comparing the target's type
            '' alone accepted a FUNCTION whose result happens to be this type, and the
            '' argument values are lowered before the overload is picked -- so it
            '' emitted them, found no constructor, and left them behind as dead
            '' instructions. TypeCtorTypeOf_ asks the callee's SYMBOL, which is what
            '' tells a type name from a function returning one.
            if TypeCtorTypeOf_( c, init_ ) <> c.types->Unqualify( t ) then return false
        end if
    end if

    dim as Tko.SymbolId ctors = StructorOf( c, t, "__ctor" )
    if ctors = Tko.SYMBOL_NONE then return false

    '' Argument VALUES first, then the pick: the types are needed to choose, and the
    '' values must be evaluated in source order regardless of which overload wins.
    dim as FB.Array( of ulong ) argT
    dim as FB.Array( of ulong ) argKind
    dim as FB.Array( of ulong ) argId
    '' AN ARRAY ARGUMENT TAKES A DESCRIPTOR. Measured: fbc builds a static one for a
    '' fixed-length array and passes its address --
    ''
    ''   static struct $8FBARRAY1Iu7INTEGERE tmp$2$ = { GARR, GARR, 32, ... };
    ''   _ZN2C1C1ER7FBARRAYIu7INTEGERE( &B, (struct ...*)&tmp$2$ );
    ''
    '' -- and this lowered 'garr( )' as an ordinary expression instead, which produced
    '' nothing and was PUSHED ANYWAY: 'dim as C1 b = C1( garr( ) )' came out as
    '' 'call void _ZN2C1C1ER7FBARRAYIu7INTEGERE(@b, _)', a constructor call with a
    '' hole where its only argument belongs, with no decline to say so. It verified.
    ''
    '' The shape answers for itself, which is what lets this run before the overload is
    '' picked: 'garr( )' is an empty call over a name whose type is an ARRAY, and
    '' nothing else is.
    dim as FB.Array( of ulong ) argDesc
    '' ...AND THE NODES THEY CAME FROM, because a byval STRING parameter needs the
    '' argument again once the overload is known: see the temporary below.
    dim as FB.Array( of ulong ) argNode
    for i as long = 0 to cp->count - 1
        dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[cp->first + i] )
        argNode.Push( cast( ulong, a ) )
        dim as MirValue adv
        if ArrayDescArg_( c, a, true, adv ) then
            argT.Push( cast( ulong, c.info->TypeOf_( a ) ) )
            argKind.Push( cast( ulong, adv.kind ) )
            argId.Push( cast( ulong, adv.id ) )
            argDesc.Push( 1 )
            continue for
        end if
        dim as MirValue av = LowerExpr( c, a )
        '' NOTHING TO PASS IS NOT AN ARGUMENT. Pushing it anyway put a hole in the
        '' call and counted the statement as fully lowered.
        if av.kind = cast( ubyte, MV_NONE ) then return false
        argT.Push( cast( ulong, c.info->TypeOf_( a ) ) )
        argKind.Push( cast( ulong, av.kind ) )
        argId.Push( cast( ulong, av.id ) )
        argDesc.Push( 0 )
    next

    dim as Tko.SymbolId pick = PickCtor( c, ctors, argT )
    if pick = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ps->payload )
    if pn = Tko.NODE_NONE then return false

    '' Arguments are coerced to the chosen overload's PARAMETER types: MIR has no
    '' implicit conversions, and the overload was selected knowing a conversion would
    '' be needed, so it has to be written down.
    dim as Tko.StmtPayload ptr cpp = StmtOf( c, pn )
    '' The caller-built string descriptors, deleted after the call returns.
    dim as FB.Array( of ulong ) strTmp
    dim as FB.Array( of ulong ) strTmpTy
    dim as long ai2 = 0
    for i as long = 0 to cpp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[cpp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if ai2 >= argT.Count then exit for
        if argDesc[ai2] <> 0 then
            ai2 += 1
            continue for
        end if
        dim as MirValue av
        av.kind = cast( ubyte, argKind[ai2] )
        av.ty = cast( ubyte, LowerType( cast( Tko.TypeId, argT[ai2] ), *c.types ) )
        av.id = argId[ai2]
        dim as Tko.StmtPayload ptr sp3 = StmtOf( c, prm )
        dim as Tko.TypeId pty = c.info->TypeOf_( sp3->a )

        '' A BYREF PARAMETER TAKES AN ADDRESS, and this passed the loaded VALUE.
        '' Measured: 'WeakPtr( of T )( sp )' over a
        '' 'byref rhs as SharedPtr( of T )' emitted
        '' 'call ... (ptr %s41, ptr %t945)' where %t945 is 'load [8 x i8]' -- an
        '' aggregate where a pointer belongs, and clang refused the module.
        ''
        '' The ordinary call path has taken addresses for byref parameters since it
        '' existed; the constructor path coerced every argument to the parameter's
        '' MIR type instead, and for a reference that type is a POINTER -- so the
        '' aggregate was 'converted' to one rather than having its address taken.
        if ParamIsByref( c, pick, ai2 ) then
            dim as MirValue ba = LowerAddr( c, cast( Tko.NodeId, argNode[ai2] ) )
            if ba.kind <> cast( ubyte, MV_NONE ) then
                argKind[ai2] = cast( ulong, ba.kind )
                argId[ai2] = cast( ulong, ba.id )
                argT[ai2] = cast( ulong, pty )
                ai2 += 1
                continue for
            end if
        end if

        '' A BYVAL VAR-LENGTH STRING PARAMETER TAKES A DESCRIPTOR THE CALLER BUILDS,
        '' and this path passed the argument's raw operand instead: for
        '' 'Res( of string )( "abc" )' that is the address of the LITERAL, where an
        '' FBSTRING* belongs, so the constructor read a descriptor out of the text.
        '' It linked, it verified, and 's.v' came back empty.
        ''
        '' The rule and the entry point are the ordinary call path's -- see
        '' ParamIsIndirectStr_ and ByvalStrTemp_ in lowercall.bas, and HANDOFF 6b for
        '' the measurement. Only the constructor path had never been given them.
        if ParamIsIndirectStr_( c, pick, ai2 ) then
            dim as MirValue sa
            dim as long sslot = -1
            if ByvalStrTemp_( c, cast( Tko.NodeId, argNode[ai2] ), pty, sa, sslot ) then
                argKind[ai2] = cast( ulong, sa.kind )
                argId[ai2] = cast( ulong, sa.id )
                argT[ai2] = cast( ulong, pty )
                strTmp.Push( cast( ulong, sslot ) )
                strTmpTy.Push( cast( ulong, pty ) )
                ai2 += 1
                continue for
            end if
        end if

        dim as MirValue cv = Coerce( c, av, LowerType( pty, *c.types ) )
        argKind[ai2] = cv.kind
        argId[ai2] = cv.id
        '' ...AND THE RECORDED TYPE MOVES WITH THE VALUE. The declaration emitted
        '' below is built from 'argT', so coercing the value and leaving the type
        '' behind wrote a prototype that disagrees with the definition. Measured:
        '' 'Res( of long )( 7 )' put
        ''
        ''     declare void _ZN6RES<6>C1Ei(ptr, i64)
        ''     func    void _ZN6RES<6>C1Ei(ptr, i32)
        ''
        '' in one module, and clang refused it: "'%t3' defined with type 'i32' but
        '' expected 'i64'". The literal is INTEGER and the parameter is T = LONG, so
        '' the two only disagree when a generic's parameter is narrower than the
        '' argument -- which is why it took a generic to show.
        if pty <> Tko.TYPE_NONE then argT[ai2] = cast( ulong, pty )
        ai2 += 1
    next

    '' EVERY PARAMETER PAST THE WRITTEN ARGUMENTS TAKES ITS DEFAULT, now that a
    '' constructor with a defaulted tail can be picked at all. Without this the
    '' call would go out one argument short and the callee would read the slot.
    dim as long dseen = 0
    for i as long = 0 to cpp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[cpp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if dseen >= argT.Count then
            dim as Tko.StmtPayload ptr dsp = StmtOf( c, prm )
            if dsp->b = Tko.NODE_NONE then return false
            dim as MirValue dv = LowerExpr( c, dsp->b )
            if dv.kind = cast( ubyte, MV_NONE ) then return false
            dim as Tko.TypeId dt = c.info->TypeOf_( dsp->a )
            dv = CoerceTy( c, dv, LowerType( dt, *c.types ), dt)
            if dv.kind = cast( ubyte, MV_NONE ) then return false
            argT.Push( cast( ulong, dt ) )
            argKind.Push( cast( ulong, dv.kind ) )
            argId.Push( cast( ulong, dv.id ) )
            argDesc.Push( 0 )
        end if
        dseen += 1
    next

    '' THE RECEIVER, which is a local slot in every case but one: a STATIC LOCAL lives
    '' in module storage, so its address is a global and there is no slot to name.
    dim as long first = c.m->argPool.Count \ 2
    if selfv <> 0 then
        c.m->argPool.Push( cast( ulong, selfv->kind ) )
        c.m->argPool.Push( cast( ulong, selfv->id ) )
    else
        c.m->argPool.Push( cast( ulong, MV_LOCAL ) )
        c.m->argPool.Push( cast( ulong, slot ) )
    end if
    for i as long = 0 to argT.Count - 1
        c.m->argPool.Push( argKind[i] )
        c.m->argPool.Push( argId[i] )
    next

    dim as Tko.InternId nm = c.names->GetString( _
        Tko.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, MT_VOID )
        decl->isDefinition = false
        '' THIS, then the constructor's own arguments in their lowered types -- the
        '' same types the argument values below are coerced to.
        decl->AddParam( MT_PTR )
        for ai as long = 0 to argT.Count - 1
            dim as Tko.TypeId at_ = cast( Tko.TypeId, argT[ai] )
            decl->AddParam( LowerType( at_, *c.types ), _
                            cast( ulong, SizeOfType( c, at_ ) ), _
                            ClassifyEightbytes( c, at_ ) )
        next
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, MT_VOID )
    ins.first = first
    ins.count = argT.Count + 1
    ins.callee = fidx
    Emit( c, ins )

    '' ...AND RELEASED, in reverse, which is the order the ordinary call path uses
    '' when there is more than one.
    for k as long = strTmp.Count - 1 to 0 step -1
        dim as MirValue sd
        sd.kind = cast( ubyte, MV_LOCAL )
        sd.ty = cast( ubyte, MT_PTR )
        sd.id = cast( long, strTmp[k] )
        dim as FB.Array( of ulong ) dargs
        dargs.Push( cast( ulong, sd.kind ) ) : dargs.Push( cast( ulong, sd.id ) )
        EmitRtl( c, StrRtlFor_( c, cast( Tko.TypeId, strTmpTy[k] ), RTL_STR_DELETE ), _
                 dargs )
    next
    return true
end function

'' Construct a 'T( args )' into a slot that already exists. Shared by the expression
'' form above and by 'return T( ... )', which constructs into the RESULT slot and needs
'' no temporary at all.
function EmitTypeCtorInto_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval slot as long, _
      byval cp as Tko.ListPayload ptr ) as boolean

    '' PICKED BY THE ARGUMENT TYPES, with arity as the fallback.
    ''
    '' Arity alone answers only when one overload has that arity. Measured on fbc:
    ''
    ''     type LV
    ''         declare constructor( byval v as boolean )
    ''         declare constructor( byref v as string )
    ''     end type
    ''     take( LV( s ) )        '' s is a STRING -- fbc prints 3
    ''
    '' Both take one argument, the chain head is the BOOLEAN one, and tiko called it --
    '' coercing a string descriptor with a 'sext'. It lowered and it verified; the
    '' emitter only choked because the coercion had no width to report.
    '' fb/logger.bi's 'LogValue( v.Message( ) )' is the same shape over nine
    '' constructors, and is one of the corpus's codegen failures.
    ''
    '' PickCtor is the cost model overload resolution itself uses. An argument Check
    '' could not type has no cost, so that case keeps the arity answer rather than
    '' inventing one.
    dim as Tko.SymbolId ctor = Tko.SYMBOL_NONE
    if (t <> Tko.TYPE_NONE) andalso (cp->count > 0) then
        if c.types->Kind( t ) = Tko.TK_UDT then
            dim as FB.Array( of ulong ) ctArgT
            dim as boolean ctTyped = true
            for i as long = 0 to cp->count - 1
                dim as Tko.NodeId an = cast( Tko.NodeId, c.ast->children[cp->first + i] )
                dim as Tko.TypeId at3 = c.info->TypeOf_( an )
                if at3 = Tko.TYPE_NONE then
                    ctTyped = false
                    exit for
                end if
                ctArgT.Push( cast( ulong, at3 ) )
            next
            if ctTyped then
                ctor = PickCtor( c, StructorOf( c, t, "__ctor" ), ctArgT )
            end if
        end if
    end if
    if ctor = Tko.SYMBOL_NONE then
        ctor = StructorWithArity( c, StructorOf( c, t, "__ctor" ), cp->count )
    end if

    '' 'UDT( )' WITH NO WRITTEN CONSTRUCTOR runs the SYNTHESISED one. fbc accepts the
    '' empty spelling exactly when the type has a constructor at all, and measurably so:
    ''
    ''   type Q : a as integer     : b as integer : end type   Q( ) is fbc's error 42,
    ''                                                         "Variable not declared"
    ''   type Q : a as integer = 5 : b as integer : end type   Q( ) is accepted
    ''   type Q : a as integer     : s as string  : end type   Q( ) is accepted
    ''
    '' -- a field initialiser or a string field gives it one, and that is the whole
    '' rule. This asked only for a WRITTEN constructor, so 'UDT( ).getI( )' built a
    '' temporary, never constructed it, and the member call then emitted with NO
    '' RECEIVER: three of structs/anon-access's verifier failures. The same member on a
    '' constructor that takes arguments -- 'P( 3 ).getv( )' -- worked all along, which
    '' is what kept it looking like a member-call problem rather than an empty-list one.
    if ctor = Tko.SYMBOL_NONE then
        if cp->count <> 0 then return false
        if TypeNeedsInit_( c, t ) = false then return false
        dim as MirValue sa
        sa.kind = cast( ubyte, MV_LOCAL )
        sa.ty = cast( ubyte, MT_PTR )
        sa.id = slot
        CallImplicitCtor_( c, t, sa )
        return true
    end if

    '' THE ARGUMENTS, coerced to the constructor's own parameter types: 'TimeSpan( 0 )'
    '' passes an INTEGER literal to a 'byval as longint', and handing the runtime the
    '' narrow value would put half a quantity in a 64-bit slot.
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( ctor )
    if cs = 0 then return false
    dim as Tko.NodeId cn = cast( Tko.NodeId, cs->payload )
    if cn = Tko.NODE_NONE then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, cn )

    dim as FB.Array( of ulong ) args
    if PushCtorArgs_( c, ctor, cp->first, cp->count, args ) = false then return false

    EmitStructorCall( c, ctor, slot, 0, @args )
    return true
end function

'' THE ARGUMENTS OF A CONSTRUCTOR CALL, coerced to the constructor's own parameters.
'' Shared with 'new T( ... )', which pushed every argument as a plain expression and so
'' had none of this: an ARRAY argument produced nothing and was pushed anyway.
function PushCtorArgs_ _
    ( byref c as Ctx, byval ctor as Tko.SymbolId, byval first_ as long, _
      byval count as long, byref args as FB.Array( of ulong ) ) as boolean

    dim as Tko.Symbol ptr cs2 = c.syms->SymbolAt( ctor )
    if cs2 = 0 then return false
    dim as Tko.NodeId cn2 = cast( Tko.NodeId, cs2->payload )
    if cn2 = Tko.NODE_NONE then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, cn2 )

    dim as long pi = 0
    for i as long = 0 to count - 1
        dim as Tko.NodeId ae = cast( Tko.NodeId, c.ast->children[first_ + i] )

        '' AN ARRAY ARGUMENT TAKES A DESCRIPTOR, in a constructor call as much as in
        '' any other. Measured: fbc builds a static descriptor for a fixed-length
        '' array and passes its address --
        ''
        ''   static struct $8FBARRAY1Iu7INTEGERE tmp$2$ = { GARR, GARR, 32, ... };
        ''   _ZN2C1C1ER7FBARRAYIu7INTEGERE( &B, (struct ...*)&tmp$2$ );
        ''
        '' -- and this loop lowered 'garr( )' as an ORDINARY expression instead, which
        '' produced nothing and was pushed anyway: a constructor call with a hole where
        '' its only argument belongs. It verified.
        dim as MirValue adv
        if ArrayDescArg_( c, ae, ParamIsArray( c, ctor, pi ), adv ) then
            args.Push( cast( ulong, adv.kind ) ) : args.Push( cast( ulong, adv.id ) )
            pi += 1
            continue for
        end if

        '' The matching parameter, counted over N_PARAM children only. FOUND FIRST,
        '' because what to lower depends on it: 'byref s as string' wants a
        '' DESCRIPTOR and a plain LowerExpr hands back the 24-byte value.
        '' 'call _ZN2LVC1ER8FBSTRING(ptr %s2, ptr %t7)' with %t7 defined as
        '' '[24 x i8]' is what that produced -- clang's own words.
        dim as Tko.TypeId pt = Tko.TYPE_NONE
        dim as boolean ptByref = false
        dim as long seen = 0
        for k as long = 0 to pp->count - 1
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + k] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            if seen = pi then
                pt = c.info->TypeOf_( StmtOf( c, prm )->a )
                ptByref = ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
                exit for
            end if
            seen += 1
        next
        '' A REFERENCE IS TRANSPARENT TO TypeOf_, so the typeref above answers with the
        '' REFERENT and CtorArgValue_'s byref-UDT arm never fired through this path.
        '' 'new T( v )' over 'constructor( byref o as T )' passed the LOADED AGGREGATE
        '' where the signature wants an address: clang's '%t7 defined with type
        '' [4 x i8] but expected ptr'. LowerUdtInitCtor_ already asks the N_PARAM's own
        '' flag for the same reason; this is that rule, in the other constructor path.
        if ptByref andalso (pt <> Tko.TYPE_NONE) then
            if c.types->Kind( c.types->Unqualify( pt ) ) <> Tko.TK_REFERENCE then
                pt = c.types->Reference( pt )
            end if
        end if
        pi += 1
        '' CtorArgValue_ IS THE SHARED RULE, and this loop had its own: the string,
        '' zstring-pointer and wide cases it knows were all reached through the other
        '' constructor path and not through this one.
        dim as MirValue av
        if CtorArgValue_( c, ae, pt, av ) = false then return false
        if av.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    next

    '' EVERY PARAMETER PAST THE WRITTEN ARGUMENTS TAKES ITS DEFAULT. fbc fills
    '' them at the call -- measured, 'A( 5 )' over
    '' 'constructor( byval c as long, byval os as long = 0 )' is
    '' '_ZN1AC1Eii( &A, 5, 0 )' -- and without this the call went out ONE ARGUMENT
    '' SHORT, which the callee then read off the stack.
    dim as long seen2 = 0
    for k as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + k] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen2 >= pi then
            dim as Tko.StmtPayload ptr dp = StmtOf( c, prm )
            if dp->b = Tko.NODE_NONE then return false
            dim as MirValue dv = LowerExpr( c, dp->b )
            if dv.kind = cast( ubyte, MV_NONE ) then return false
            dim as Tko.TypeId dt = c.info->TypeOf_( dp->a )
            if dt <> Tko.TYPE_NONE then
                dv = CoerceTy( c, dv, LowerType( dt, *c.types ), dt )
                if dv.kind = cast( ubyte, MV_NONE ) then return false
            end if
            args.Push( cast( ulong, dv.kind ) ) : args.Push( cast( ulong, dv.id ) )
        end if
        seen2 += 1
    next
    return true
end function

'' 'base( n )' inside a constructor -- THE BASE-CLASS CONSTRUCTOR CALL.
''
'' Measured: 'base( n )' in C's constructor is '_ZN1PC1Eu7INTEGER( (struct P*)THIS, n )'
'' -- a direct constructor call on the base subobject, and the implicit default base
'' construction is NOT emitted beside it.
''
'' 'extends P' is modelled as a FIELD NAMED 'base' at offset 0, which is what makes
'' this ordinary: the receiver is that field's address and the type to construct is
'' that field's type. 'base.i' and 'base.M( )' already went through the member path
'' for the same reason; only the constructor form had nowhere to go, and it declined
'' in 43 corpus lines.
''
'' Returns false when the call is not this shape, so an ordinary call to something
'' that happens to be spelled 'base' is unaffected.
'' 'base( ... )' WHERE THE BASE DECLARES NO CONSTRUCTOR IS A FIELD-WISE INITIALISER,
'' not a call -- there is nothing to call.
''
'' Measured against fbc, at the very top of the derived constructor's body:
''
''   base( 1, 2, 3 )   *(int64*)THIS=1; *(THIS+8)=2; *(THIS+16)=3;
''   base( 123 )       *(int64*)THIS=123; memset( THIS+8, 0, 16 );   -- the supplied
''                     values go to the LEADING base fields and THE REST OF THE BASE
''                     SUBOBJECT IS ZEROED
''   base( p0 )        memcpy( (P*)THIS, P0, 16 )   -- one argument of the base's own
''                     type is a whole-subobject copy
''
'' The base subobject sits at offset 0, which is the same fact single inheritance rests
'' on everywhere else in this file.
private function LowerBaseFieldInit_ _
    ( byref c as Ctx, byval selfAddr as MirValue, byval bt as Tko.TypeId, _
      byval first_ as long, byval count as long ) as boolean

    dim as long bsz = SizeOfType( c, bt )
    if bsz <= 0 then return false
    dim as long bui = c.udts->Find( bt )
    if bui < 0 then return false

    '' A SINGLE ARGUMENT OF THE BASE'S OWN TYPE IS A COPY of the whole subobject.
    if count = 1 then
        dim as Tko.NodeId only_ = cast( Tko.NodeId, c.ast->children[first_] )
        dim as Tko.TypeId ot2 = c.types->Unqualify( c.info->TypeOf_( only_ ) )
        if ot2 = c.types->Unqualify( bt ) then
            dim as MirValue src = LowerAddr( c, only_ )
            if src.kind = cast( ubyte, MV_NONE ) then return false
            '' WITH THE BASE'S SIZE. 'src' is a computed address -- for
            '' 'constructor C3( byref p0 as P )' doing 'base( p0 )' it is the
            '' pointer loaded out of the reference -- and a temp has no storage for
            '' the emitter to size an aggregate from. It loaded '[0 x i8]' and
            '' stored nothing: the program printed two stack addresses where fbc
            '' prints 9 and 8.
            dim as MirValue whole = LowerExprLoad( c, src, MT_AGG, bsz )
            if whole.kind = cast( ubyte, MV_NONE ) then return false
            StoreThrough( c, selfAddr, whole )
            return true
        end if
    end if

    '' THE LEADING FIELDS, one value each, in declaration order.
    dim as long f0 = c.udts->udts[bui].first
    dim as long nf = c.udts->udts[bui].count
    if count > nf then return false
    dim as long tailOff = bsz
    for i as long = 0 to count - 1
        dim as Tko.UdtField ptr fld = @c.udts->fields[f0 + i]
        dim as MirType fmt = LowerType( fld->type_, *c.types )
        if (fmt = MT_VOID) orelse (fmt = MT_AGG) then return false
        dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[first_ + i] )
        dim as MirValue av = LowerExpr( c, a )
        if av.kind = cast( ubyte, MV_NONE ) then return false
        av = CoerceTy( c, av, fmt, c.info->TypeOf_( a ))
        if av.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = selfAddr
        fa.imm = fld->offset
        dim as MirValue faddr = Emit( c, fa )
        if faddr.kind = cast( ubyte, MV_NONE ) then return false
        StoreThrough( c, faddr, av )
        if i = count - 1 then tailOff = fld->offset + SizeOfType( c, fld->type_ )
    next

    '' ...AND THE REST OF THE SUBOBJECT ZEROED. Measured: fbc emits the memset even
    '' where the derived constructor writes those bytes again a line later.
    if (count > 0) andalso (tailOff < bsz) then
        dim as MirInst ta
        ta.op = cast( ushort, M_FIELD_ADDR )
        ta.ty = cast( ubyte, MT_PTR )
        ta.a = selfAddr
        ta.imm = tailOff
        dim as MirValue taddr = Emit( c, ta )
        if taddr.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) za
        za.Push( cast( ulong, taddr.kind ) ) : za.Push( cast( ulong, taddr.id ) )
        za.Push( cast( ulong, MV_CONST_INT ) ) : za.Push( 0 )
        za.Push( cast( ulong, MV_CONST_INT ) ) : za.Push( cast( ulong, bsz - tailOff ) )
        EmitRtl( c, RTL_MEMSET, za )
    end if
    return true
end function

function LowerBaseCtorCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr tip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    '' 'base( ... )' AND 'constructor( ... )' ARE THE SAME STATEMENT WITH A DIFFERENT
    '' RECEIVER: one initialises the base subobject, the other DELEGATES to another
    '' constructor of this same type over the whole of 'this'. Measured on fbc, which
    '' emits a plain '_ZN1QC1Ev( THIS )' for the delegating form -- and emits NO
    '' PROLOGUE at all in the delegating constructor, because the one it calls does it.
    dim as string ctorWord = Tko.Text.LowerAscii( c.names->Spelling( tip->name ) )
    dim as boolean delegating = (ctorWord = "constructor")
    if (ctorWord <> "base") andalso (delegating = false) then return false

    '' The receiver's own type, through 'this'. Nothing outside a method has one, and
    '' a method whose type does not extend anything has no 'base' field.
    if c.curProcSym = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr me_ = c.syms->SymbolAt( c.curProcSym )
    if me_ = 0 then return false
    if me_->inner = Tko.SCOPE_NONE then return false
    dim as Tko.SymbolId tsid = c.syms->LookupLocal( me_->inner, _
        c.names->Fold( c.names->GetString( "this" ) ) )
    if tsid = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr ts = c.syms->SymbolAt( tsid )
    if ts = 0 then return false
    if ts->type_ = Tko.TYPE_NONE then return false
    if c.types->Kind( ts->type_ ) <> Tko.TK_POINTER then return false
    dim as Tko.TypeId ot = c.types->Inner( ts->type_ )
    if ot = Tko.TYPE_NONE then return false

    dim as Tko.SymbolId bsid = Tko.SYMBOL_NONE
    dim as Tko.TypeId bt = ot
    if delegating = false then
        bsid = UdtMemberNamed_( c, ot, "base" )
        if bsid = Tko.SYMBOL_NONE then return false
        dim as Tko.Symbol ptr bs = c.syms->SymbolAt( bsid )
        if bs = 0 then return false
        if bs->kind <> cast( ubyte, Tko.SYM_FIELD ) then return false
        bt = bs->type_
        if bt = Tko.TYPE_NONE then return false
    end if
    if c.types->Kind( bt ) <> Tko.TK_UDT then return false

    dim as Tko.SymbolId ctors = StructorOf( c, bt, "__ctor" )
    '' A DELEGATING CALL WITH NOTHING TO DELEGATE TO is not the field-by-field path
    '' below -- that one exists because a BASE with no constructor is still initialised.
    '' 'constructor( )' naming a type that declares none is an error the checker owes,
    '' and inventing an initialisation for it would be a guess.
    if delegating andalso (ctors = Tko.SYMBOL_NONE) then return false
    if ctors = Tko.SYMBOL_NONE then
        '' A BASE WITH NO CONSTRUCTOR IS INITIALISED FIELD BY FIELD, not called. This
        '' returned false the moment there was nothing to pick, so the statement fell
        '' through to an ordinary call of a procedure named 'base' and declined -- seven
        '' corpus statements, in the four files whose whole subject is base initialisers.
        dim as MirValue frecv = AddrOfThisField( c, bsid )
        if frecv.kind = cast( ubyte, MV_NONE ) then return false
        return LowerBaseFieldInit_( c, frecv, bt, cp->first, cp->count )
    end if

    '' Argument VALUES first, then the pick: the types are needed to choose, and the
    '' values must be evaluated in source order whichever overload wins.
    dim as FB.Array( of ulong ) argT
    dim as FB.Array( of ulong ) argKind
    dim as FB.Array( of ulong ) argId
    for i as long = 0 to cp->count - 1
        dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[cp->first + i] )
        dim as MirValue av = LowerExpr( c, a )
        if av.kind = cast( ubyte, MV_NONE ) then return false
        argT.Push( cast( ulong, c.info->TypeOf_( a ) ) )
        argKind.Push( cast( ulong, av.kind ) )
        argId.Push( cast( ulong, av.id ) )
    next

    dim as Tko.SymbolId pick = PickCtor( c, ctors, argT )
    if pick = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ps->payload )
    if pn = Tko.NODE_NONE then return false

    '' Coerced to the chosen overload's PARAMETER types: MIR has no implicit
    '' conversions, and the overload was picked knowing a conversion would be needed.
    dim as Tko.StmtPayload ptr cpp = StmtOf( c, pn )
    dim as long ai = 0
    dim as FB.Array( of ulong ) cargs
    for i as long = 0 to cpp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[cpp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if ai >= argT.Count then exit for
        dim as MirValue av
        av.kind = cast( ubyte, argKind[ai] )
        av.ty = cast( ubyte, LowerType( cast( Tko.TypeId, argT[ai] ), *c.types ) )
        av.id = argId[ai]
        dim as Tko.TypeId pt = c.info->TypeOf_( StmtOf( c, prm )->a )
        dim as MirValue cv = CoerceTy( c, av, LowerType( pt, *c.types ), pt )
        if cv.kind = cast( ubyte, MV_NONE ) then return false
        cargs.Push( cast( ulong, cv.kind ) ) : cargs.Push( cast( ulong, cv.id ) )
        ai += 1
    next
    if ai <> cast( long, argT.Count ) then return false

    dim as MirValue recv
    if delegating then
        '' THIS holds a pointer, so the receiver is its VALUE -- the whole object, at
        '' offset zero -- where the base form takes the address of a field inside it.
        dim as MirValue ta = AddrOfVar( c, tsid )
        if ta.kind = cast( ubyte, MV_NONE ) then return false
        recv = LowerExprLoad( c, ta, MT_PTR )
    else
        recv = AddrOfThisField( c, bsid )
    end if
    if recv.kind = cast( ubyte, MV_NONE ) then return false
    EmitStructorCall( c, pick, -1, @recv, @cargs )
    return true
end function


declare function EmitStaticDtorThunk_ _
    ( byref c as Ctx, byval g as long, byval t as Tko.TypeId ) as long

'' A STATIC LOCAL OBJECT, constructed LAZILY the first time control reaches it.
''
'' Measured from what fbc emits for 'static as T a = T( 1 )' inside a procedure:
''
''     static int64 LABEL$9$1;                   the guard, module storage, zeroed
''     if( LABEL$9$1 != 0ll) goto label$10;
''     LABEL$9$1 = 1ll;
''     _ZN1TC1Ei( &tmp$6, 1 );                   the constructor, at the DECLARATION
''     atexit( (void*)&LABEL$8 );                and the destructor, registered
''     label$10:;
''
'' -- with a SEPARATE guard, thunk and atexit call for every such declaration, at the
'' point of the declaration and inside whatever branch encloses it: a static inside an
'' IF is not constructed until that branch runs. The thunk is a void() of its own that
'' calls the destructor on the storage, and atexit runs them in reverse registration
'' order, which is reverse construction order.
''
'' There is NO atexit and no thunk when the type has no destructor, and no guard at all
'' when it has neither constructor nor destructor: 'static as long n = 7' is a plain
'' static with a compile-time initialiser, which InitSharedGlobal already emits.
''
'' Without this the storage existed and nothing ever ran on it, so 'static as T s' over
'' a type holding a string left the descriptor uninitialised for the life of the
'' program -- the same crash DIM SHARED had before the module initialiser, and it
'' counted as lowered.
function LowerStaticLocalInit_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval init_ as Tko.NodeId ) as boolean

    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    dim as Tko.TypeId t = s->type_
    if t = Tko.TYPE_NONE then return false

    dim as Tko.SymbolId ctors = Tko.SYMBOL_NONE
    dim as Tko.SymbolId dtor = Tko.SYMBOL_NONE
    dim as boolean wantsC = false
    dim as boolean wantsD = false
    dim as boolean isUdt = (c.types->Kind( t ) = Tko.TK_UDT)
    if isUdt then
        ctors = StructorOf( c, t, "__ctor" )
        dtor = StructorWithArity( c, StructorOf( c, t, "__dtor" ), 0 )
        wantsC = (ctors <> Tko.SYMBOL_NONE) orelse TypeNeedsInit_( c, t )
        wantsD = (dtor <> Tko.SYMBOL_NONE) orelse TypeNeedsDtor_( c, t )
    else
        wantsC = ArrayElemNeedsInit_( c, t )
        wantsD = ArrayElemNeedsDtor_( c, t )
        '' ...AND AN INITIALISER LIST OVER A UDT ELEMENT WANTS CONSTRUCTING TOO, even
        '' when the element needs no DEFAULT construction. 'static as bar b1(0 to 4) =
        '' { bar(1), ... }' over a bar whose only constructor takes an argument answered
        '' 'nothing to do' here and fell to the byte-image fold, which cannot fold a
        '' constructor call and declined. Measured, fbc emits no image at all -- a
        '' run-once guard and one ctor call per element:
        ''
        ''     _ZN3BARC1Eu7INTEGER( (struct $3BAR*)B1$1, 1ll );
        ''     _ZN3BARC1Eu7INTEGER( (struct $3BAR*)((uint8*)B1$1 + 8ll), 2ll );
        ''
        '' and run, it prints ' 1 2 5' on both calls.
        if (wantsC = false) andalso (init_ <> Tko.NODE_NONE) then
            if c.types->Kind( t ) = Tko.TK_ARRAY then
                dim as Tko.TypeId el0 = c.types->Unqualify( c.types->Inner( t ) )
                if c.types->Kind( el0 ) = Tko.TK_UDT then
                    if StructorOf( c, el0, "__ctor" ) <> Tko.SYMBOL_NONE then
                        wantsC = true
                    end if
                end if
            end if
        end if
    end if
    if (wantsC = false) andalso (wantsD = false) then return false

    dim as long g = GlobalFor( c, sid )
    if g < 0 then return false
    dim as MirValue ga
    ga.kind = cast( ubyte, MV_GLOBAL )
    ga.ty = cast( ubyte, MT_PTR )
    ga.id = g

    '' THE GUARD, one per declaration and named after the storage it guards. fbc gives
    '' it a label's name, which is unique per declaration for the same reason.
    dim as Tko.InternId gnm = _
        c.names->GetString( c.names->Spelling( c.m->globals[g].name ) & "$init" )
    dim as long gg = c.m->AddVarGlobal( gnm, MT_I64, Tko.TYPE_NONE, 8 )
    dim as MirValue gaddr
    gaddr.kind = cast( ubyte, MV_GLOBAL )
    gaddr.ty = cast( ubyte, MT_PTR )
    gaddr.id = gg

    dim as MirValue gv = LowerExprLoad( c, gaddr, MT_I64 )
    if gv.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirInst tst
    tst.op = cast( ushort, M_ICMP_NE )
    tst.ty = cast( ubyte, MT_I32 )
    tst.a = gv
    tst.b = ConstInt( c, 0, MT_I64 )
    dim as MirValue done_ = Emit( c, tst )
    if done_.kind = cast( ubyte, MV_NONE ) then return false

    dim as long initB = NewBlock( c, "static.init" )
    dim as long skipB = NewBlock( c, "static.done" )
    Terminate( c, MTERM_CONDBR, skipB, initB, done_ )

    c.curBlock = initB
    StoreThrough( c, gaddr, ConstInt( c, 1, MT_I64 ) )

    '' THE CONSTRUCTOR. 'static as T a = T( 1 )' selects one by its arguments exactly
    '' as a local does; everything else takes the no-argument one, or the synthesised
    '' one for a type that needs initialising and declares none.
    dim as boolean constructed = false
    if isUdt andalso (init_ <> Tko.NODE_NONE) then
        constructed = LowerCtorInit( c, -1, t, init_, @ga )
    end if
    if constructed = false then
        if isUdt then
            dim as Tko.SymbolId ct = StructorWithArity( c, ctors, 0 )
            if ct <> Tko.SYMBOL_NONE then
                dim as FB.Array( of ulong ) none1
                EmitStructorCall( c, ct, -1, @ga, @none1 )
                constructed = true
            elseif TypeNeedsInit_( c, t ) then
                CallImplicitCtor_( c, t, ga )
                constructed = true
            end if
        elseif wantsC then
            '' THE LIST FIRST, when there is one: it names each element's own
            '' constructor arguments, and default-constructing over it would throw
            '' them away.
            dim as boolean listed = false
            if init_ <> Tko.NODE_NONE then
                listed = LowerUdtArrayInit_( c, -1, t, init_, @ga )
            end if
            if listed = false then EmitArrayElemsAt_( c, ga, t, true )
            constructed = true
        end if
    end if

    '' THE DESTRUCTOR, through a thunk of its own -- atexit takes a void() and the
    '' destructor takes the object, so there is nothing to register directly.
    if wantsD then
        dim as long thunk = EmitStaticDtorThunk_( c, g, t )
        if thunk >= 0 then
            dim as MirInst fa
            fa.op = cast( ushort, M_FUNC_ADDR )
            fa.ty = cast( ubyte, MT_PTR )
            fa.callee = cast( ulong, thunk )
            dim as MirValue fv = Emit( c, fa )
            if fv.kind <> cast( ubyte, MV_NONE ) then
                dim as FB.Array( of ulong ) aargs
                aargs.Push( cast( ulong, fv.kind ) )
                aargs.Push( cast( ulong, fv.id ) )
                EmitRtl( c, RTL_ATEXIT, aargs )
            end if
        end if
    end if

    Terminate( c, MTERM_BR, skipB, -1, NoVal( ) )
    c.curBlock = skipB
    return constructed orelse wantsD
end function

'' The thunk atexit is handed: a void() that destroys ONE static, built beside the
'' procedure that declared it rather than inside it.
private function EmitStaticDtorThunk_ _
    ( byref c as Ctx, byval g as long, byval t as Tko.TypeId ) as long

    dim as Tko.InternId nm = _
        c.names->GetString( c.names->Spelling( c.m->globals[g].name ) & "$dtor" )
    dim as MirFunction ptr f = c.m->AddFunction( nm, MT_VOID )
    f->isDefinition = true
    dim as long idx = c.m->functions.Count - 1

    dim as MirFunction ptr savedF = c.f
    dim as long savedB = c.curBlock
    c.f = f
    c.st->functions += 1
    c.curBlock = NewBlock( c, "entry" )

    dim as MirValue ga
    ga.kind = cast( ubyte, MV_GLOBAL )
    ga.ty = cast( ubyte, MT_PTR )
    ga.id = g

    if c.types->Kind( t ) = Tko.TK_UDT then
        dim as Tko.SymbolId dt = StructorWithArity( c, StructorOf( c, t, "__dtor" ), 0 )
        if dt <> Tko.SYMBOL_NONE then
            dim as FB.Array( of ulong ) none2
            EmitStructorCall( c, dt, -1, @ga, @none2 )
        elseif TypeNeedsDtor_( c, t ) then
            CallImplicitDtor_( c, t, ga )
        end if
    else
        EmitArrayElemsAt_( c, ga, t, false )
    end if

    Terminate( c, MTERM_RET, -1, -1, NoVal( ) )
    c.f = savedF
    c.curBlock = savedB
    return idx
end function

end namespace
