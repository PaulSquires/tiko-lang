'' lowerudtlit.bas -- the anonymous UDT literal and the field-list initialiser.
''
'' 'type<P>( 5, 6 )', 'type( 5, 6 )' and the bare '( 5, 6 )' are ONE construct with
'' three spellings. Measured: fbc emits the same field stores and the same tail memset
'' for all of them, so they share one lowering here and differ only in where the TYPE
'' comes from -- the written one, the declaration's, or the context's.
''
'' Split out of lowersub.bas at the 1500-line cap. Nothing moved with it changed.

#include once "lowerctx.bi"

namespace Tko.Mir

'' Defined in lowerterm.bas and lowerarr.bas, which are compiled after this file.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long
declare sub FlattenInitLeaves_ _
    ( byref c as Ctx, byval init as Tko.NodeId, _
      byref outv as FB.Array( of ulong ) )

using Tko

'' THE LEAF VALUES of an initialiser, in order, with nested lists opened out. fbc
'' accepts a field list written either way -- 'type<Outer>( type<P>( 1, 2 ), 3 )' and
'' 'type<Outer>( 1, 2, 3 )' both give stores at 0, 4 and 8 -- so a nested list is
'' punctuation here, exactly as it is on the field side.
private function FlattenInitValues_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as FB.Array( of ulong ), _
      byval depth as long ) as boolean

    if depth > 8 then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        select case c.ast->Kind( e )
        case Tko.N_TUPLE, Tko.N_INITIALIZER
            '' A nested field list, or the '{ ... }' an ARRAY FIELD takes.
            if FlattenInitValues_( c, e, outv, depth + 1 ) = false then return false
        case else
            outv.Push( cast( ulong, e ) )
        end select
    next
    return true
end function

'' Defined below, and used above it: FreeBASIC needs the forward declaration.
declare function FlattenUdtFields_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval base_ as long, _
      byref offs as FB.Array( of ulong ), byref tys as FB.Array( of ulong ), _
      byval depth as long, byref fts as FB.Array( of ulong ) ) as boolean

'' 'type<P>( 5, 6 )' AS A VALUE, not as an initialiser -- an argument, a parameter
'' default, anything that is not the right-hand side of a declaration. fbc builds a
'' TEMPORARY and field-initialises it, exactly as it does for a declaration:
''
''     struct $1P TMP$5$0;  *(uint32*)&TMP$5$0 = 5u;  ...  Q( TMP$5$0 );
''
'' Returns the temp's SLOT, or -1. Split from the value and address entry points below
'' because a byref argument needs the address and a byval one needs the load, and
'' building the object twice for the two of them would be wrong as well as wasteful.
function UdtLiteralSlot_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as long

    if c.ast->Kind( id ) <> Tko.N_TUPLE then return -1
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    '' A TARGET IS THE WRITTEN FORM -- 'type<P>( 5, 6 )'. A BARE '( 1, 2 )' is the
    '' tuple feature, and it reaches here too now that Check gives one the synthetic UDT
    '' its elements key: fbc builds exactly the same temporary for it, field by field,
    '' which is what makes 'let (a, b) = (1, 2)' one evaluation rather than two.
    '' Anything still untyped is answered by the TYPE_NONE test below.
    if lp->target <> Tko.NODE_NONE then
        if c.ast->Kind( lp->target ) <> Tko.N_TYPEREF then return -1
    end if

    dim as Tko.TypeId lt = c.info->TypeOf_( id )
    if lt = Tko.TYPE_NONE then return -1
    if c.types->Kind( lt ) <> Tko.TK_UDT then return -1

    dim as long slot = NewTempLocal( c, MT_AGG, SizeOfType( c, lt ) )
    if slot < 0 then return -1

    '' THE TEMPORARY IS CONSTRUCTED FIRST, exactly as a NAMED local of the same type is.
    '' NewTempLocal only reserves bytes; a STRING field's descriptor in them is whatever
    '' the stack held, and the field store below assigns THROUGH it. Measured on
    ''
    ''     dim as string s1 = "x", s2 = "y"
    ''     (s1, s2) = (s2, s1)
    ''
    '' -- tiko exited 0xC0000374 (heap corruption) because fb_StrAssign freed a garbage
    '' pointer read out of the temp; fbc-modern prints "yx" and exits 0. fbc reaches the
    '' same place by emitting fb_StrInit for the temp's fields instead of fb_StrAssign
    '' (its -r output for the program above), which is fb_StrAssign over a ZEROED
    '' descriptor -- so zeroing here, through the same synthesised constructor a local
    '' gets, is that store and nothing more. Costs nothing for a tuple of scalars:
    '' TypeNeedsInit_ is false and no call is emitted.
    ''
    '' NOT FOR THE EMPTY FORM. 'type<A>( )' IS a constructor call and
    '' LowerUdtParenInit_ emits it below; constructing here as well put TWO
    '' '_ZN1AC1Ev( @$tmp4 )' calls in tests/diagnostics/abstract-expression's dump where
    '' fbc emits one.
    if (lp->count > 0) andalso TypeNeedsInit_( c, lt ) then
        dim as MirValue cselfv
        cselfv.kind = cast( ubyte, MV_LOCAL )
        cselfv.ty = cast( ubyte, MT_PTR )
        cselfv.id = slot
        CallImplicitCtor_( c, lt, cselfv )
    end if

    if LowerUdtParenInit_( c, slot, lt, id ) = false then return -1

    '' ...AND DESTROYED AT THE END OF THE STATEMENT, which nothing here did. A tuple
    '' literal whose halves have destructors is an object like any other temporary:
    '' measured, 'function Value( ) as (Counted, long)' returning
    '' '( Counted( this.i ), this.i )' ran two constructors and NO destructor, so a
    '' for-each over four elements leaked eight objects and the corpus's
    '' 'ctors = dtors' failed by exactly that.
    ''
    '' One registration, here, rather than at the call sites: the narrow one that
    '' used to sit in the constructor-argument path below was this same rule seen
    '' through one case, and having both would destroy the temporary twice.
    if TypeNeedsDtor_( c, lt ) then
        c.udtTemps.Push( cast( ulong, slot ) )
        c.udtTempTypes.Push( cast( ulong, lt ) )
    end if
    return slot
end function

'' AN UPCAST COPIES THE BASE SUBOBJECT, NOT THE WHOLE DERIVED VALUE.
''
'' 'dim as parent p = c' over a 'child' loaded ALL SIXTEEN BYTES of the child and
'' stored them into the eight-byte parent slot:
''
''     %t68 = load [16 x i8], ptr %s9
''     store [8 x i8] %t68, ptr %s8
''
'' -- which clang refuses outright, so the module did not build. The base subobject is
'' at offset 0 (that is what EXTENDS is: a field named 'base' declared first), so the
'' copy is the DESTINATION's size taken from the source's ADDRESS.
''
'' Fifteen of icescan's codegen failures are this one shape, across udt-upcast-1/2/3
'' and udt-init-5/6/7/8.
''
'' Answers false when this is not an upcast at all, which is every ordinary
'' initialiser -- so it must be cheap to say no.
'' Is 'baseT' a base of 'derivedT' -- walked, not assumed? Two unrelated UDTs of
'' different sizes are a type error, not an upcast, and the same question decides
'' whether an initialiser or an assignment is a BASE SLICE.
function IsBaseOf_ _
    ( byref c as Ctx, byval baseT as Tko.TypeId, byval derivedT as Tko.TypeId ) as boolean

    if (baseT = Tko.TYPE_NONE) orelse (derivedT = Tko.TYPE_NONE) then return false
    dim as Tko.TypeId bu = c.types->Unqualify( baseT )
    dim as Tko.TypeId walk = c.types->Unqualify( derivedT )
    if bu = walk then return false
    dim as long guard = 0
    while (walk <> Tko.TYPE_NONE) andalso (guard < 64)
        guard += 1
        dim as Tko.TypeId nb = c.types->BaseOf( walk )
        if nb = Tko.TYPE_NONE then exit while
        if c.types->Unqualify( nb ) = bu then return true
        walk = nb
    wend
    return false
end function

function UpcastAggInit_ _
    ( byref c as Ctx, byval srcNode as Tko.NodeId, byval dstT as Tko.TypeId, _
      byref outv as MirValue ) as boolean

    if (srcNode = Tko.NODE_NONE) orelse (dstT = Tko.TYPE_NONE) then return false
    dim as Tko.TypeId du = c.types->Unqualify( dstT )
    if c.types->Kind( du ) <> Tko.TK_UDT then return false
    dim as Tko.TypeId st = c.info->TypeOf_( srcNode )
    if st = Tko.TYPE_NONE then return false
    dim as Tko.TypeId su = c.types->Unqualify( st )
    if c.types->Kind( su ) = Tko.TK_REFERENCE then
        su = c.types->Unqualify( c.types->Inner( su ) )
    end if
    if c.types->Kind( su ) <> Tko.TK_UDT then return false
    if su = du then return false
    '' THE DESTINATION MUST BE A BASE OF THE SOURCE, walked rather than assumed: two
    '' unrelated UDTs of different sizes are a type error, not an upcast.
    if IsBaseOf_( c, du, su ) = false then return false
    dim as long dsz = SizeOfType( c, du )
    if dsz <= 0 then return false
    dim as MirValue sa = LowerAddr( c, srcNode )
    if sa.kind = cast( ubyte, MV_NONE ) then return false
    outv = LowerExprLoad( c, sa, MT_AGG, dsz )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

function LowerUdtLiteralValue_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as long slot = UdtLiteralSlot_( c, id )
    if slot < 0 then return false
    dim as MirValue addr
    addr.kind = cast( ubyte, MV_LOCAL )
    addr.ty = cast( ubyte, MT_PTR )
    addr.id = slot
    outv = LowerExprLoad( c, addr, MT_AGG )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

function LowerUdtLiteralAddr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as long slot = UdtLiteralSlot_( c, id )
    if slot < 0 then return false
    outv.kind = cast( ubyte, MV_LOCAL )
    outv.ty = cast( ubyte, MT_PTR )
    outv.id = slot
    return true
end function

'' Does T hold, at byte offset OFF (nested fields included), a whole field of type WANT?
'' A string-first UDT field flattens to a STRING LEAF at its own offset, and only this
'' tells 'kv.value' (the whole Ent) from a string value meant for that leaf.
private function UdtFieldAt_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval off as long, _
      byval want as Tko.TypeId, byval depth as long ) as boolean
    if depth > 8 then return false
    dim as long ui = c.udts->Find( t )
    if ui < 0 then return false
    for i as long = 0 to c.udts->udts[ui].count - 1
        dim as Tko.UdtField ptr fld = @c.udts->fields[c.udts->udts[ui].first + i]
        if (fld->offset > off) orelse (c.types->Kind( fld->type_ ) <> Tko.TK_UDT) then continue for
        if (fld->offset = off) andalso (c.types->Unqualify( fld->type_ ) = want) then return true
        if UdtFieldAt_( c, fld->type_, off - fld->offset, want, depth + 1 ) then return true
    next
    return false
end function

'' The destination is a SLOT or, for an ARRAY ELEMENT, an ADDRESS -- selfv. An element
'' of a brace initialiser has no slot of its own, and building the object in a
'' temporary of ITS OWN inferred type instead is how '{ ( 7, 8, 9 ) }' over a
'' 'type mt: as byte a, b: as integer c' came to write TWENTY-FOUR bytes of i64 fields
'' into a SIXTEEN-byte element, clobbering the element after it. See the caller.
function LowerUdtParenInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId, byval selfv as MirValue ptr ) as boolean

    if (slot < 0) andalso (selfv = 0) then return false
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    select case c.ast->Kind( init )
    case Tko.N_TUPLE, Tko.N_PAREN
    case else
        return false
    end select

    dim as long ui = c.udts->Find( t )
    if ui < 0 then return false

    '' THE DESTINATION, once: the slot's address, or the one the caller handed over.
    dim as MirValue self_
    if selfv <> 0 then
        self_ = *selfv
    else
        self_.kind = cast( ubyte, MV_LOCAL )
        self_.ty = cast( ubyte, MT_PTR )
        self_.id = slot
    end if
    dim as long selfSlot = slot
    dim as MirValue ptr selfAddr = 0
    if selfv <> 0 then
        selfSlot = -1
        selfAddr = @self_
    end if

    '' A SINGLE ELEMENT OF THE TYPE ITSELF IS NOT A FIELD LIST. 'dim as Decimal a =
    '' ( ( x - y ) / z )' has to be written with those outer parentheses -- fbc cannot
    '' parse the operator otherwise, and fb/fintvm.bi says so in a comment beside every
    '' one -- so the parens are punctuation, not an initialiser. Reading them as one
    '' meant storing a whole Decimal into its first FIELD, which is a type error the
    '' void-result rule then declined; before that rule it would have stored something.
    dim as Tko.ListPayload ptr pl0 = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]

    '' 'type<T>( )' WITH NO ARGUMENTS IS THE DEFAULT CONSTRUCTOR, on a temporary.
    ''
    '' Measured: fbc emits '_ZN1CC1Ev( &TMP$2$0 )' and then reads out of TMP, and it
    '' REJECTS the empty form over a type that has no constructor -- error 9, expected
    '' expression -- so there is no zeroing case to model beside it.
    ''
    '' The field-list walk below had nothing to iterate and returned as though it had
    '' done the work, so '(type<ClassUdt>( )).i' and 'x = type<ClassUdt>( )' produced
    '' no construction at all: 479 statements in structs/temp-var-dtors.bas, whose
    '' whole subject is counting the constructor calls a temporary makes.
    if pl0->count = 0 then
        dim as Tko.SymbolId zct = StructorWithArity( c, StructorOf( c, t, "__ctor" ), 0 )
        if zct <> Tko.SYMBOL_NONE then
            EmitStructorCall( c, zct, selfSlot, selfAddr )
            return true
        end if
        dim as MirValue za = self_
        if TypeNeedsInit_( c, t ) then
            CallImplicitCtor_( c, t, za )
            return true
        end if
        return false
    end if
    if pl0->count = 1 then
        dim as Tko.NodeId only_ = cast( Tko.NodeId, c.ast->children[pl0->first] )
        dim as Tko.TypeId ot = c.info->TypeOf_( only_ )
        if ot <> Tko.TYPE_NONE then
            if c.types->Unqualify( ot ) = c.types->Unqualify( t ) then
                '' ...UNLESS IT IS A WRITTEN TYPE LITERAL, which is a COPY.
                ''
                '' 'dim x2 as t1 = type<t1>( y )' is measured as
                '' '__builtin_memcpy( &X2$0, &Y$0, 4 )', and the same for the three
                '' parenthesised spellings structs/anon-param writes beside it. The
                '' guard below is for a BARE '( expr )' -- punctuation around an
                '' operator, which fb/fintvm.bi needs -- and that one still declines.
                if (c.ast->nodes[cast( long, init )].flags and _
                    Tko.NF_TYPE_LITERAL) <> 0 then
                    dim as MirValue cdst = self_
                    '' The whole overload chain -- see CopyCtorOf_.
                    dim as Tko.SymbolId lcc = CopyCtorOf_( c, t )
                    dim as MirValue csrc = LowerAddr( c, only_ )
                    if csrc.kind = cast( ubyte, MV_NONE ) then return false
                    if lcc <> Tko.SYMBOL_NONE then
                        dim as FB.Array( of ulong ) largs
                        largs.Push( cast( ulong, csrc.kind ) )
                        largs.Push( cast( ulong, csrc.id ) )
                        EmitStructorCall( c, lcc, -1, @cdst, @largs )
                        return true
                    end if
                    if NeedsLetBody_( c, t ) then
                        CallImplicitCopy_( c, t, cdst, csrc )
                        return true
                    end if
                    dim as MirValue whole = LowerExprLoad( c, csrc, MT_AGG )
                    if whole.kind = cast( ubyte, MV_NONE ) then return false
                    StoreThrough( c, cdst, whole )
                    return true
                end if
                return false
            elseif c.types->BaseDistance( ot, t ) > 0 then
                '' AN UPCAST SLICE: the literal names a DERIVED type and the
                '' destination is one of its bases. Measured over a t2 extends t1,
                '' both with destructors, for
                '' 'dim as t1 u1 = type<t1>( type<t2>( 1, 2 ) )':
                ''
                ''     struct $2T2 TMP$4$1;
                ''     *(int64*)&TMP$4$1 = 1ll;
                ''     *(int64*)((uint8*)&TMP$4$1 + 8ll) = 2ll;
                ''     __builtin_memcpy( &U1$1, &TMP$4$1, 8 );
                ''     _ZN2T2D1Ev( &TMP$4$1 );
                ''
                '' -- one temporary of the SOURCE type, a copy of exactly
                '' sizeof( DESTINATION ) bytes out of it, and the temporary
                '' destructed straight after. The size is why this needed a call:
                '' M_STORE of an MT_AGG carries no length, so the base-slice
                '' assignment elsewhere works only because its source is already
                '' the smaller type. memcpy carries one.
                ''
                '' Without the type-literal flag this is a bare '( expr )' again --
                '' punctuation, not an initialiser -- so it declines with the
                '' same-type case above.
                if (c.ast->nodes[cast( long, init )].flags and _
                    Tko.NF_TYPE_LITERAL) = 0 then return false
                dim as long dsz = SizeOfType( c, t )
                if dsz <= 0 then return false
                dim as MirValue ssrc = LowerAddr( c, only_ )
                if ssrc.kind = cast( ubyte, MV_NONE ) then return false
                '' THE TEMPORARY IS DESTRUCTED, and this file's whole subject is
                '' counting that: udt-upcast-4.bas asserts the per-level dtor
                '' counts after every one of these. Nothing else registers it --
                '' UdtLiteralSlot_ builds the object and leaves the release to
                '' whoever asked for it -- so the slice does it here, and the
                '' end-of-statement flush puts the call exactly where fbc's is.
                '' ONLY WHEN THE SOURCE IS ITSELF A LITERAL. Written over a
                '' VARIABLE -- 'dim as t1 u1 = type<t1>( v )' -- LowerAddr hands
                '' back V'S OWN SLOT, and registering that would destruct the
                '' user's variable here and AGAIN at scope end. Measured: fbc
                '' emits 'memcpy( &U1, &V, 8 )' with no destructor beside it and
                '' the single '_ZN2T2D1Ev( &V$1 )' at the end of the scope.
                dim as boolean srcIsLit = false
                if c.ast->Kind( only_ ) = Tko.N_TUPLE then
                    srcIsLit = ((c.ast->nodes[cast( long, only_ )].flags and _
                                 Tko.NF_TYPE_LITERAL) <> 0)
                end if
                '' REGISTERED IN UdtLiteralSlot_ NOW, for every tuple literal rather
                '' than this one shape. 'srcIsLit' is kept because the comment above
                '' is still the reason a NAMED variable must not be registered.
                dim as boolean srcIsLocal = (ssrc.kind = cast( ubyte, MV_LOCAL ))
                if srcIsLit andalso srcIsLocal then
                end if
                dim as FB.Array( of ulong ) mca
                mca.Push( cast( ulong, self_.kind ) )
                mca.Push( cast( ulong, self_.id ) )
                mca.Push( cast( ulong, ssrc.kind ) )
                mca.Push( cast( ulong, ssrc.id ) )
                dim as MirValue nb = ConstInt( c, dsz, MT_I64 )
                mca.Push( cast( ulong, nb.kind ) )
                mca.Push( cast( ulong, nb.id ) )
                EmitRtl( c, RTL_MEM_COPY, mca )
                return true
            end if
        end if
    end if

    '' A TYPE WITH A CONSTRUCTOR IS CONSTRUCTED, not written field by field.
    ''
    '' Measured, over a T declaring 'constructor( byval n as long )' and a U declaring
    '' none:
    ''
    ''     dim as T x = type<T>( 7 )      _ZN1TC1Ei( &X$0, 7 )
    ''     dim as U y = type<U>( 1, 2 )   *(int32*)&Y$0 = 1; *(int32*)(&Y$0+4) = 2
    ''
    '' -- so the field walk below is the NO-CONSTRUCTOR case only. Reaching it over a
    '' type that has one wrote the arguments straight into the fields and never called
    '' the constructor: 'f( type<T>( 123 ) )' set T.v and skipped whatever else the
    '' constructor does, silently, in a statement that lowered and verified. The
    '' zero-argument form above already knew this; the N-argument form did not.
    ''
    '' The overload is picked by ARITY, which is what 'T( args )' -- the other spelling
    '' of the same construction -- already does, so the two agree. That is not full
    '' overload resolution and neither path claims to be.
    '' PICKED BY THE ARGUMENT TYPES, with arity as the fallback.
    ''
    '' "The overload is picked by ARITY" was true and it was wrong, and the comment
    '' above says so without saying what it cost. Measured on fbc:
    ''
    ''     type LV
    ''         declare constructor( byval v as boolean )
    ''         declare constructor( byref v as string )
    ''     end type
    ''     take( LV( s ) )        '' s is a STRING -- fbc prints 3
    ''
    '' Both constructors take one argument, so the chain head won and tiko called the
    '' BOOLEAN one, coercing a string descriptor with a 'sext'. It lowered, it
    '' verified, and the emitter only choked on it because the coercion had no width.
    '' fb/logger.bi's 'LogValue( v.Message( ) )' is the same shape over nine
    '' constructors.
    ''
    '' PickCtor is the cost model overload resolution itself uses. An argument Check
    '' could not type has no cost, so that case keeps the arity answer rather than
    '' guessing at one.
    dim as Tko.SymbolId lct = Tko.SYMBOL_NONE
    if (t <> Tko.TYPE_NONE) andalso (c.types->Kind( t ) = Tko.TK_UDT) then
        dim as FB.Array( of ulong ) lcArgT
        dim as boolean allTyped = true
        for i as long = 0 to pl0->count - 1
            dim as Tko.NodeId an = cast( Tko.NodeId, c.ast->children[pl0->first + i] )
            dim as Tko.TypeId at = c.info->TypeOf_( an )
            if at = Tko.TYPE_NONE then
                allTyped = false
                exit for
            end if
            lcArgT.Push( cast( ulong, at ) )
        next
        if allTyped then
            lct = PickCtor( c, StructorOf( c, t, "__ctor" ), lcArgT )
        end if
    end if
    if lct = Tko.SYMBOL_NONE then lct = CtorOf_( c, t, pl0->count )
    if lct <> Tko.SYMBOL_NONE then
        dim as FB.Array( of ulong ) lca
        if PushCtorArgs_( c, lct, pl0->first, pl0->count, lca ) then
            EmitStructorCall( c, lct, selfSlot, selfAddr, @lca )
            return true
        end if
        return false
    end if

    '' THE FIELDS, FLATTENED. 'dim as Outer x = ( ( 1, 2 ), 3 )' emits the same three
    '' stores at 0, 4 and 8 that a flat type would: nesting exists in the parser and
    '' nowhere else, so a nested UDT field contributes its OWN leaves here rather than
    '' one aggregate slot.
    dim as FB.Array( of ulong ) fOff
    dim as FB.Array( of ulong ) fTy
    '' The FRONTEND type of each leaf, beside its MIR one: a var-length STRING leaf is
    '' written by a runtime call and not by a store, and only this tells one.
    dim as FB.Array( of ulong ) fFt
    if FlattenUdtFields_( c, t, 0, fOff, fTy, 0, fFt ) = false then return false
    dim as long fCount = fOff.Count
    if fCount <= 0 then return false

    dim as FB.Array( of ulong ) vNode
    if FlattenInitValues_( c, init, vNode, 0 ) = false then return false
    dim as long vCount = vNode.Count
    if vCount <= 0 then return false
    '' MORE VALUES THAN FIELDS is not this construct -- it declines rather than
    '' writing past the last one.
    if vCount > fCount then return false

    dim as MirValue base_ = self_

    '' EVERY VALUE LOWERED BEFORE ANYTHING IS STORED. A value that will not lower means
    '' the whole initialiser declines, and emitting the earlier stores first would leave
    '' a half-initialised object behind with a decline beside it.
    '' A LEAF CURSOR, NOT AN INDEX, because ONE VALUE CAN COVER SEVERAL LEAVES.
    '' Measured: 'dim y1 as T3 = ( x1, 31, 301 )' over a T3 that EXTENDS T1 is
    '' '__builtin_memcpy( &Y1, &X1, 4 )' for the base and scalar stores for the rest.
    '' Pairing value i with leaf i instead coerced a whole object into an i32 slot -- a
    '' SIGN-EXTENDED AGGREGATE -- and wrote every field after it one place early.
    dim as FB.Array( of ulong ) vals
    dim as FB.Array( of ulong ) vOff
    dim as long cur = 0
    '' A STRING LEAF is recorded by its NODE and written at the store site, because it
    '' takes fb_StrInit rather than a store and there is no value to hold here.
    dim as FB.Array( of ulong ) sNode
    dim as FB.Array( of ulong ) sOff
    '' ...AND ITS FLAVOUR. The store has only a field ADDRESS to write through, which
    '' names no type, so a USTRING leaf was stored as a narrow one: 'return (kv.key,
    '' kv.value)' in fb/map.bi emitted fb_UStrAssignToA, and every key a Map's Pairs( )
    '' produced came out as UTF-16 read from narrow bytes. tracks walks five such maps.
    dim as FB.Array( of ulong ) sFt
    '' A WHOLE-OBJECT LEAF WHOSE TYPE OWNS A STRING is recorded the same way and copied
    '' by its assignment, not by a store, for the same reason: there is no value to hold.
    dim as FB.Array( of ulong ) cNode
    dim as FB.Array( of ulong ) cOff
    dim as FB.Array( of ulong ) cTy
    for i as long = 0 to vCount - 1
        dim as Tko.NodeId e = cast( Tko.NodeId, vNode[i] )
        if cur >= fCount then return false
        dim as MirType fmt = cast( MirType, fTy[cur] )
        '' ...UNLESS THE VALUE IS THE WHOLE UDT FIELD that leaf opens. 'return (kv.key,
        '' kv.value)' over a Map( of ustring, Ent ) fed the Ent to the string store, which
        '' declined; every Pairs( ) value came out empty. The deep copy below takes it.
        dim as boolean wholeUdt = false
        scope
            dim as Tko.TypeId wt = c.info->TypeOf_( e )
            if wt <> Tko.TYPE_NONE then
                wt = c.types->Unqualify( wt )
                if c.types->Kind( wt ) = Tko.TK_UDT then wholeUdt = UdtFieldAt_( c, t, cast( long, fOff[cur] ), wt, 0 )
            end if
        end scope
        if (wholeUdt = false) andalso IsStringType( c, cast( Tko.TypeId, fFt[cur] ) ) then
            sNode.Push( cast( ulong, e ) )
            sOff.Push( fOff[cur] )
            sFt.Push( fFt[cur] )
            cur += 1
            continue for
        end if

        '' AN AGGREGATE ELEMENT THAT OWNS A STRING IS ASSIGNED, NOT LOADED AND STORED.
        '' M_STORE of an MT_AGG is a bitwise copy, so the element and the destination
        '' field ended up holding ONE string pointer and both freed it. Measured on
        ''
        ''     dim inner as (long, string) = (1, "n")
        ''     dim s1 as ((long, string), long) = (inner, 3)
        ''
        '' -- tiko exited 0xC0000374 (heap corruption) at scope end where fbc-modern
        '' exits 0, and it is why tests/vendor/fbc-tests/tuple/equality.bas died. fbc
        '' reaches the deep copy through the tuple's copy constructor:
        ''
        ''     __builtin_memcpy( &TMP$4$0, &INNER$0, 32 );
        ''     _ZN8FBTUPLE2I8FBTUPLE2Ii8FBSTRINGEiEC1ERKS3_( &S1$0, &TMP$4$0 );
        ''
        '' -- whose body is an fb_StrAssign per string field, which is what
        '' CallImplicitCopy_ emits. Only when NeedsLetBody_ says the type owns
        '' something: a tuple of scalars keeps the single store it always had.
        ''
        '' A DYNAMIC ARRAY IS THE SAME BUG and the same fix. The note in
        '' tests/mir/src/tuple-dynarray-elem.bas reads fbc's memcpy of the element into
        '' its TEMPORARY as the whole copy; the deep one is the copy constructor that
        '' follows it, and tiko elides the temporary, so the shallow store landed in the
        '' real object. Measured on that file's 'return (k, d)' with the array actually
        '' REDIMmed: before this, 0xC0000374 at scope end -- 'd' and the tuple freeing
        '' one buffer -- against fbc's exit 0. An empty array hides it, which is why the
        '' file as written passed either way.
        dim as Tko.TypeId et = c.info->TypeOf_( e )
        if et <> Tko.TYPE_NONE then
            '' A TYPE WITH A DESTRUCTOR TAKES THE SAME ROUTE. NeedsLetBody_ asks
            '' whether the type OWNS something -- a string, a dynamic array -- and a
            '' counted type owns nothing, so 'Counted( 1 )' was lowered to a value,
            '' stored a field at a time, and the temporary it was built in was never
            '' destroyed. Measured: one constructor and no destructor per element.
            dim as boolean cDeep = false
            if c.types->Kind( et ) = Tko.TK_UDT then
                cDeep = NeedsLetBody_( c, et ) orelse TypeNeedsDtor_( c, et )
            end if
            if cDeep then
                dim as long esz = SizeOfType( c, et )
                if esz <= 0 then return false
                dim as long estop = cast( long, fOff[cur] ) + esz
                dim as long espan = 0
                while (cur + espan < fCount) andalso _
                      (cast( long, fOff[cur + espan] ) < estop)
                    espan += 1
                wend
                if espan < 1 then return false
                cNode.Push( cast( ulong, e ) )
                cOff.Push( fOff[cur] )
                cTy.Push( cast( ulong, et ) )
                cur += espan
                continue for
            end if
        end if

        dim as MirValue v = LowerExpr( c, e )
        if v.kind = cast( ubyte, MV_NONE ) then return false
        dim as long span = 1
        if v.ty = cast( ubyte, MT_AGG ) then
            '' THE RUN OF LEAVES THIS OBJECT COVERS, measured by its own size. A value
            '' that does not span a whole number of leaves declines rather than being
            '' written across a field boundary.
            dim as Tko.TypeId vt = c.info->TypeOf_( e )
            if vt = Tko.TYPE_NONE then return false
            '' SizeOfType, not TypeContext.Layout: a UDT's size lives in the UDT
            '' store, and Layout answers 0 for one. That zero made every aggregate
            '' value decline here, which looked exactly like the guard working.
            dim as long vsz = SizeOfType( c, vt )
            if vsz <= 0 then return false
            dim as long stop_ = cast( long, fOff[cur] ) + vsz
            span = 0
            while (cur + span < fCount) andalso (cast( long, fOff[cur + span] ) < stop_)
                span += 1
            wend
            if span < 1 then return false
        else
            v = CoerceTy( c, v, fmt, c.info->TypeOf_( e ))
            if v.kind = cast( ubyte, MV_NONE ) then return false
        end if
        '' COERCED TO THE FIELD'S TYPE, which this never did. The values are the
        '' ones the ELEMENTS have; the fields' types are the DESTINATION's, and for
        '' a tuple literal the two routinely differ. Measured:
        '' 'takesDD( (4, 5) )' against 'byval p as (double, double)' stored two
        '' INTEGER bit patterns into two doubles and printed 1.97e-323 and
        '' 2.47e-323 where fbc prints 4 and 5.
        ''
        '' A WHOLE-OBJECT value spanning several leaves is left alone: it is copied
        '' by the aggregate paths above, and 'coercing' one to a leaf's scalar type
        '' is the sign-extended-aggregate bug this file already records.
        if (span = 1) andalso (cast( MirType, v.ty ) <> MT_AGG) then
            dim as MirType lmt = cast( MirType, fTy[cur] )
            if (lmt <> MT_VOID) andalso (lmt <> MT_AGG) then
                dim as Tko.TypeId lft = cast( Tko.TypeId, fFt[cur] )
                dim as MirValue cvv = CoerceTy( c, v, lmt, lft )
                if cvv.kind <> cast( ubyte, MV_NONE ) then v = cvv
            end if
        end if
        vOff.Push( cast( ulong, fOff[cur] ) )
        vals.Push( cast( ulong, v.kind ) )
        vals.Push( cast( ulong, v.id ) )
        vals.Push( cast( ulong, v.ty ) )
        cur += span
    next

    '' OVER THE VALUES ACTUALLY RECORDED, not over the value COUNT: a string leaf is
    '' held aside and records nothing here, so counting the written values instead left
    '' the loop reading one entry past the end and emitting a store with no operand.
    for i as long = 0 to cast( long, vOff.Count ) - 1
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = base_
        fa.imm = cast( long, vOff[i] )
        dim as MirValue addr = Emit( c, fa )
        if addr.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue v
        v.kind = cast( ubyte, vals[i * 3] )
        v.id = cast( long, vals[i * 3 + 1] )
        v.ty = cast( ubyte, vals[i * 3 + 2] )
        dim as MirInst st
        st.op = cast( ushort, M_STORE )
        st.ty = cast( ubyte, MT_VOID )
        st.a = addr
        st.b = v
        Emit( c, st )
    next

    '' ...AND THE STRING LEAVES, after the scalar stores. Each is an fb_StrInit into a
    '' descriptor that has just been zeroed by the caller, which is what a declaration
    '' does. One that will not lower declines with the scalars already written -- the
    '' one place this file's "lower everything first" rule cannot hold, because the
    '' string assignment IS the lowering and it emits as it goes.
    for i as long = 0 to sNode.Count - 1
        dim as MirInst sfa
        sfa.op = cast( ushort, M_FIELD_ADDR )
        sfa.ty = cast( ubyte, MT_PTR )
        sfa.a = base_
        sfa.imm = cast( long, sOff[i] )
        dim as MirValue saddr = Emit( c, sfa )
        if saddr.kind = cast( ubyte, MV_NONE ) then return false
        dim as long sflav = iif( IsUStringType( c, cast( Tko.TypeId, sFt[i] ) ), 1, 0 )
        if LowerStringAssignTo( c, saddr, Tko.NODE_NONE, _
                                cast( Tko.NodeId, sNode[i] ), sflav ) = false then return false
    next

    '' ...AND THE WHOLE-OBJECT LEAVES, by assignment. See the note at the record site.
    for i as long = 0 to cast( long, cOff.Count ) - 1
        dim as MirInst cfa
        cfa.op = cast( ushort, M_FIELD_ADDR )
        cfa.ty = cast( ubyte, MT_PTR )
        cfa.a = base_
        cfa.imm = cast( long, cOff[i] )
        dim as MirValue cdstv = Emit( c, cfa )
        if cdstv.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue csrcv = LowerAddr( c, cast( Tko.NodeId, cNode[i] ) )
        if csrcv.kind = cast( ubyte, MV_NONE ) then return false
        '' THE USER'S OWN COPY CONSTRUCTOR FIRST. CallImplicitCopy_ always names
        '' '<T>C1ERKS_' and the synthesised body is not emitted for a type that
        '' declares its own -- so a type with a written copy constructor linked
        '' against a symbol nobody defines. Measured: 'undefined symbol:
        '' COUNTED::COUNTED(COUNTED const&)'.
        '' A WRITTEN 'operator let' FIRST OF ALL, because the destination field has
        '' already been CONSTRUCTED -- UdtLiteralSlot_ ran the type's implicit
        '' constructor over the whole object before any value reached it. Running a
        '' COPY CONSTRUCTOR over it as well constructs the same field twice and
        '' destroys it once, which is a leak of exactly one object per element and
        '' what the corpus's 'ctors = dtors' was still short by.
        dim as Tko.SymbolId ulet = StructorOf( c, cast( Tko.TypeId, cTy[i] ), "let" )
        if ulet <> Tko.SYMBOL_NONE then
            dim as FB.Array( of ulong ) ulargs
            ulargs.Push( cast( ulong, csrcv.kind ) )
            ulargs.Push( cast( ulong, csrcv.id ) )
            EmitStructorCall( c, ulet, -1, @cdstv, @ulargs )
            continue for
        end if

        dim as Tko.SymbolId ucc = CopyCtorOf_( c, cast( Tko.TypeId, cTy[i] ) )
        if ucc <> Tko.SYMBOL_NONE then
            dim as FB.Array( of ulong ) ccargs
            ccargs.Push( cast( ulong, csrcv.kind ) )
            ccargs.Push( cast( ulong, csrcv.id ) )
            EmitStructorCall( c, ucc, -1, @cdstv, @ccargs )
        else
            CallImplicitCopy_( c, cast( Tko.TypeId, cTy[i] ), cdstv, csrcv )
        end if
    next

    '' THE TAIL, zeroed AFTER the stores and only as far as it goes -- from the first
    '' field with no value to the end of the object. A UNION gets none: measured, and
    '' the one place the two shapes disagree.
    if cur < fCount then
        if IsUnionType_( c, t ) = false then
            dim as long tailOff = cast( long, fOff[cur] )
            dim as long tailLen = c.udts->udts[ui].size - tailOff
            if tailLen > 0 then
                dim as MirInst ta
                ta.op = cast( ushort, M_FIELD_ADDR )
                ta.ty = cast( ubyte, MT_PTR )
                ta.a = base_
                ta.imm = tailOff
                dim as MirValue taddr = Emit( c, ta )
                if taddr.kind <> cast( ubyte, MV_NONE ) then
                    dim as FB.Array( of ulong ) ma
                    ma.Push( cast( ulong, taddr.kind ) ) : ma.Push( cast( ulong, taddr.id ) )
                    ma.Push( cast( ulong, MV_CONST_INT ) ) : ma.Push( 0 )
                    ma.Push( cast( ulong, MV_CONST_INT ) ) : ma.Push( cast( ulong, tailLen ) )
                    EmitRtl( c, RTL_MEMSET, ma )
                end if
            end if
        end if
    end if
    return true
end function

'' Every LEAF field of a UDT, in declaration order, as (byte offset, MIR type).
''
'' A nested UDT contributes its own leaves rather than one aggregate slot, which is what
'' makes 'dim as Outer x = ( ( 1, 2 ), 3 )' three stores at 0, 4 and 8 -- fbc flattens
'' the initialiser completely and the parens are decoration.
''
'' Returns false rather than a partial list for anything that has no plain store: a
'' BITFIELD, whose address would be the whole packed unit, or a field type that lowers
'' to no MIR type at all.
function FlattenUdtFields_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval base_ as long, _
      byref offs as FB.Array( of ulong ), byref tys as FB.Array( of ulong ), _
      byval depth as long, byref fts as FB.Array( of ulong ) ) as boolean

    if depth > 8 then return false
    dim as long ui = c.udts->Find( t )
    if ui < 0 then return false
    dim as long f0 = c.udts->udts[ui].first
    dim as long n = c.udts->udts[ui].count
    if n <= 0 then return false
    for i as long = 0 to n - 1
        dim as Tko.UdtField ptr fld = @c.udts->fields[f0 + i]
        if fld->bitWidth <> 0 then return false
        dim as MirType fmt = LowerType( fld->type_, *c.types )
        if fmt = MT_AGG then
            '' A FIXED ARRAY FIELD CONTRIBUTES ITS ELEMENTS, one leaf each. Measured:
            '' 'as ubyte d4( 0 to 7 )' initialised from '{ &hC0, 0, ... }' is eight byte
            '' stores at offsets 8..15, not one aggregate store. Refusing it declined
            '' every GUID in fb/comptr.bi, which is how COM declares every IID.
            ''
            '' A DYNAMIC array is a descriptor rather than storage and has no elements
            '' to write here -- so it is ONE LEAF, its descriptor, and not a run of
            '' them. Refusing it refused the whole flatten, which took every type with
            '' a dynamic-array field anywhere in it: 'FB.Array( of T )' has one, so
            '' 'return (k, v)' out of a Map's tuple view declined, and so did every
            '' 'dim as (long, Array(of long)) t = ( k, a )' beside it.
            ''
            '' Measured: fbc copies such an element with ONE whole-object memcpy of the
            '' field -- the descriptor is copied, not the data -- which is what the
            '' aggregate store this leaf attracts already emits.
            if c.types->Kind( fld->type_ ) = Tko.TK_ARRAY then
                '' A FIXED-LENGTH STRING FIELD IS ONE LEAF, not N character ones.
                '' 'e as zstring * 5' is spelled as an array of the character
                '' builtin, so the element walk below turned it into five leaves --
                '' and the initialiser writes ONE value for it. Measured, fbc emits
                '' the whole field as a string in the image:
                ''
                ''   static struct $2U1 X$0 =
                ''     { (uint8)18u, (uint16)4386u, "1122",
                ''       { (uint8)17u, (uint8)34u, (uint8)51u } };
                dim as longint fsn
                dim as long fsk = StrSwapKind_( c, fld->type_, fsn )
                '' NOT 'string * N' (kind 3). Measured: fbc REFUSES a UDT holding one
                '' in any initialiser -- 'static y as U2 = ( 7, "ab" )' is error 7
                '' and the brace form is error 63 -- so folding it here would accept
                '' a program fbc rejects.
                dim as boolean fixStrLeaf = (fsk = 1) orelse (fsk = 2)
                if fixStrLeaf = false then fixStrLeaf = (fsk = 4)
                if fixStrLeaf then
                    offs.Push( cast( ulong, base_ + fld->offset ) )
                    tys.Push( cast( ulong, fmt ) )
                    fts.Push( cast( ulong, fld->type_ ) )
                    continue for
                end if
                if c.types->IsDynArray( fld->type_ ) then
                    offs.Push( cast( ulong, base_ + fld->offset ) )
                    tys.Push( cast( ulong, fmt ) )
                    fts.Push( cast( ulong, fld->type_ ) )
                    continue for
                end if
                dim as Tko.TypeId et = c.types->Inner( fld->type_ )
                dim as MirType emt = LowerType( et, *c.types )
                if (emt = MT_VOID) orelse (emt = MT_AGG) then return false
                dim as long esz = c.types->Layout( et ).size
                if esz <= 0 then return false
                dim as long total = c.types->Layout( fld->type_ ).size \ esz
                if total <= 0 then return false
                for k as long = 0 to total - 1
                    offs.Push( cast( ulong, base_ + fld->offset + k * esz ) )
                    tys.Push( cast( ulong, emt ) )
                    fts.Push( cast( ulong, et ) )
                next
                continue for
            end if
            '' A VAR-LENGTH STRING FIELD IS A LEAF, not a structure to walk into: its
            '' descriptor is an aggregate, but it is written by fb_StrInit and not by a
            '' store, so it is carried through with its FRONTEND type and the store site
            '' does the right thing with it. Refusing it declined every tuple and every
            '' UDT literal holding a string.
            if IsStringType( c, fld->type_ ) then
                offs.Push( cast( ulong, base_ + fld->offset ) )
                tys.Push( cast( ulong, fmt ) )
                fts.Push( cast( ulong, fld->type_ ) )
                continue for
            end if
            if c.types->Kind( fld->type_ ) <> Tko.TK_UDT then return false
            if FlattenUdtFields_( c, fld->type_, base_ + fld->offset, offs, tys, _
                                  depth + 1, fts ) = false then return false
        else
            if fmt = MT_VOID then return false
            offs.Push( cast( ulong, base_ + fld->offset ) )
            tys.Push( cast( ulong, fmt ) )
            fts.Push( cast( ulong, fld->type_ ) )
        end if
    next
    return true
end function

'' Whether a UDT was declared as a UNION. The flag lives on the declaring N_TYPE node,
'' which the type's symbol points at -- there is nothing in the layout that says so,
'' because a union's fields all sit at offset 0 and a one-field struct looks the same.
function IsUnionType_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    dim as Tko.InternId tn = c.types->NameOf( t )
    if tn = 0 then return false
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return false
    dim as Tko.NodeId n = cast( Tko.NodeId, s->payload )
    if n = Tko.NODE_NONE then return false
    if c.ast->Kind( n ) <> Tko.N_TYPE then return false
    return ((c.ast->nodes[cast( long, n )].flags and Tko.NF_IS_UNION) <> 0)
end function


'' ------------------------------------------------- the static byte image

'' AN AGGREGATE INITIALISER FOLDED TO THE BYTES OF ITS STORAGE.
''
'' A STATIC or SHARED aggregate is initialised WHERE IT IS DEFINED, not by stores.
'' Measured: 'static as GUID g = type<GUID>( &h00020400, 0, 0, { &hC0, ... } )' is
''
''     static struct $4GUID G$1 = { 132096u, (uint16)0u, (uint16)0u,
''                                  { (uint8)192u, ... (uint8)70u } };
''
'' -- a C static with an initialiser list and no code at all. The field values with
'' their offsets ARE a byte image of the object, which is what MirGlobal.initBytes has
'' been for since it was added.
''
'' Returns false unless EVERY leaf folds. A partial image would be worse than none: the
'' bytes that did fold would look initialised and the rest would be zero, with nothing
'' to say which was which.
'' THE BYTE IMAGE of a static array whose elements are FIXED-LENGTH STRINGS.
''
'' Each element is its own raw buffer -- no descriptor -- so the whole array is one image
'' and the leaves are laid out in row-major order, the same way a multi-dimensional scalar
'' array's are. Measured against fbc, and the three flavours differ only in the fill and
'' the width:
''
''   zstring * N    the bytes, then NUL to N
''   string  * N    the bytes, then SPACES to N -- it has no terminator, so its N bytes
''                  ARE its value and an unwritten one must read back as N blanks
''   wstring * N    each byte widened to two, then NUL pairs to N
''
'' Returns false for anything that is not one, which leaves the caller's own path alone.
private function FixStrArrayImage_ _
    ( byref c as Ctx, byval et as Tko.TypeId, byval init as Tko.NodeId, _
      byval size_ as long, byref outImg as string ) as boolean

    dim as longint fen
    dim as long fsk = StrSwapKind_( c, et, fen )
    if (fsk < 1) orelse (fsk > 4) then return false
    dim as long esz = SizeOfType( c, et )
    if esz <= 0 then return false
    dim as long cap = c.types->ElemCount( et )
    if cap <= 0 then return false
    dim as long total = size_ \ esz
    if total <= 0 then return false

    dim as FB.Array( of ulong ) leaves
    FlattenInitLeaves_( c, init, leaves )
    if leaves.Count = 0 then return false
    if cast( long, leaves.Count ) > total then return false

    dim as boolean wide = (fsk = 2) orelse (fsk = 4)
    dim as ubyte pad = iif( fsk = 3, 32, 0 )
    dim as long usable = iif( fsk = 3, cap, cap - 1 )
    if usable < 0 then usable = 0

    dim as string img
    for i as long = 0 to total - 1
        dim as string txt
        if i < cast( long, leaves.Count ) then
            if ConstStringTextOf_( c, cast( Tko.NodeId, leaves[i] ), txt ) = false then
                return false
            end if
        end if
        if len( txt ) > usable then txt = left( txt, usable )
        dim as string one
        for k as long = 0 to len( txt ) - 1
            one += chr( txt[k] )
            if wide then one += chr( 0 )
        next
        while len( one ) < esz
            one += chr( pad )
        wend
        img += one
    next
    if len( img ) <> size_ then return false
    outImg = img
    return true
end function

function FoldAggInit_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval init as Tko.NodeId, _
      byval size_ as long, byref outBytes as string ) as boolean

    if size_ <= 0 then return false
    if init = Tko.NODE_NONE then return false
    select case c.ast->Kind( init )
    case Tko.N_TUPLE, Tko.N_PAREN, Tko.N_INITIALIZER
    case else
        return false
    end select

    dim as FB.Array( of ulong ) fOff
    dim as FB.Array( of ulong ) fTy
    '' The FRONTEND type of each leaf, beside its MIR one: a var-length STRING leaf is
    '' written by a runtime call and not by a store, and only this tells one.
    dim as FB.Array( of ulong ) fFt
    '' A FIXED ARRAY OF SCALARS IS ITS OWN LEAF LIST -- 'static as long t( 0 to 3 ) =
    '' { 1, 2, 3, 4 }' is 'static int32 T$0[4] = { 1, 2, 3, 4 }', a byte image exactly
    '' as a static UDT is. FlattenUdtFields_ answers only for a UDT, so every constant
    '' table in fb/tuicore.bi, fb/tuiwidthtab.bi and fb/math.bi declined.
    if c.types->Kind( t ) = Tko.TK_ARRAY then
        if c.types->IsDynArray( t ) then return false
        dim as Tko.TypeId et = c.types->Inner( t )

        '' AN ARRAY OF FIXED-LENGTH STRINGS IS A BYTE IMAGE TOO -- measured, fbc emits
        '' 'static char ZARRAY$1[3][3][10] = { { "abc", "def" }, ... }' and nothing else.
        '' A fixed string lowers to MT_AGG, so the rejection below took every one of
        '' them; the SCALAR half of exactly this fold already lives in LowerGlobalInit,
        '' including the SPACE fill a 'string * N' takes where the others take zeros.
        if FixStrArrayImage_( c, et, init, size_, outBytes ) then return true

        dim as MirType emt = LowerType( et, *c.types )
        if emt = MT_VOID then return false

        '' AN ARRAY OF UDT IS A BYTE IMAGE TOO, one element's leaf list after another.
        '' Measured: 'static struct $2OD ARR$[2] = { { 1, 2 }, { 3, 4 } };' and
        '' 'static struct $6MYTYPE ARRAYTYPE$0[11] = { { 1ll, 2ll, { 3, 4, 5 }, 6 },
        '' ... };' -- a nested member included. Rejecting MT_AGG turned every one of
        '' them away, so a static table of UDT got NO initialiser bytes at all while a
        '' single static UDT beside it folded.
        if emt = MT_AGG then
            '' SizeOfType, not Layout( ).size: a UDT's size lives in the UDT store and
            '' Layout answers 0 for one -- which the scalar path below never noticed
            '' because it never had an aggregate element.
            dim as long usz = SizeOfType( c, et )
            if usz <= 0 then return false
            dim as long ucount = size_ \ usz
            if ucount <= 0 then return false
            for k as long = 0 to ucount - 1
                if FlattenUdtFields_( c, et, k * usz, fOff, fTy, 0, fFt ) = false then
                    return false
                end if
            next
        else
            dim as long esz = c.types->Layout( et ).size
            if esz <= 0 then return false
            dim as long total = size_ \ esz
            if total <= 0 then return false
            for k as long = 0 to total - 1
                fOff.Push( cast( ulong, k * esz ) )
                fTy.Push( cast( ulong, emt ) )
            next
        end if
    elseif FlattenUdtFields_( c, t, 0, fOff, fTy, 0, fFt ) = false then
        return false
    end if
    dim as FB.Array( of ulong ) vNode
    if FlattenInitValues_( c, init, vNode, 0 ) = false then return false
    if vNode.Count <= 0 then return false
    if vNode.Count > fOff.Count then return false

    '' Zero first: fbc's initialiser list leaves every unwritten byte zero, padding
    '' included, and a static's storage starts that way in any case.
    dim as string img = string( size_, chr( 0 ) )

    for i as long = 0 to vNode.Count - 1
        dim as Tko.NodeId e = cast( Tko.NodeId, vNode[i] )
        dim as MirType fmt = cast( MirType, fTy[i] )
        dim as long off = cast( long, fOff[i] )
        dim as longint bits = 0
        dim as long wid = 0

        '' A FIXED-LENGTH STRING LEAF IS ITS OWN BYTE IMAGE, written here rather
        '' than as an integer: 'zstring * 5' initialised from "1122" is four
        '' characters and a NUL, and 'string * N' pads with SPACES where the
        '' others pad with zeros -- the same rule FixStrArrayImage_ follows for an
        '' array of them.
        if (fmt = MT_AGG) andalso (i < cast( long, fFt.Count )) then
            dim as Tko.TypeId lft = cast( Tko.TypeId, fFt[i] )
            dim as longint lsn
            dim as long lsk = StrSwapKind_( c, lft, lsn )
            dim as boolean lIsFix = (lsk = 1) orelse (lsk = 2)
            if lIsFix = false then lIsFix = (lsk = 4)
            if lIsFix then
                dim as long lcap = cast( long, c.types->ElemCount( _
                    c.types->Unqualify( lft ) ) )
                if lcap <= 0 then return false
                dim as string ltx
                if ConstStringTextOf_( c, e, ltx ) = false then return false
                dim as boolean lwide = (lsk = 2) orelse (lsk = 4)
                dim as ubyte lpad = iif( lsk = 3, 32, 0 )
                dim as long lusable = iif( lsk = 3, lcap, lcap - 1 )
                if lusable < 0 then lusable = 0
                if len( ltx ) > lusable then ltx = left( ltx, lusable )
                dim as long lsz = c.types->Layout( c.types->Unqualify( lft ) ).size
                if (off < 0) orelse (off + lsz > size_) then return false
                dim as long w = 0
                for k as long = 0 to len( ltx ) - 1
                    if w >= lsz then exit for
                    img[off + w] = ltx[k]
                    w += 1
                    if lwide then
                        if w < lsz then
                            img[off + w] = 0
                            w += 1
                        end if
                    end if
                next
                while w < lsz
                    img[off + w] = lpad
                    w += 1
                wend
                continue for
            end if
        end if

        select case fmt
        case MT_I8  : wid = 1
        case MT_I16 : wid = 2
        case MT_I32 : wid = 4
        case MT_I64 : wid = 8
        case MT_PTR : wid = c.types->target.pointerBits \ 8
        case MT_F32
            wid = 4
            dim as double fv
            if Tko.Check.ConstFloatOf( *c.ast, e, fv ) = false then return false
            dim as single sv = cast( single, fv )
            bits = cast( longint, *cptr( ulong ptr, @sv ) )
        case MT_F64
            wid = 8
            dim as double dv
            if Tko.Check.ConstFloatOf( *c.ast, e, dv ) = false then return false
            bits = *cptr( longint ptr, @dv )
        case else
            return false
        end select

        if (fmt <> MT_F32) andalso (fmt <> MT_F64) then
            '' WITH THE SYMBOL TABLE. ConstOf answers 'unknown' for every identifier
            '' when it is handed none -- 'if syms = 0 then return CVNone_( )' -- so a
            '' NAMED CONSTANT in a static or shared initialiser did not fold and the
            '' whole image declined, while the same literal in the same slot did.
            '' fbc writes 'static int64 ARR$[2] = { 42ll, 2ll };'.
            dim as Tko.ScopeId fsc = c.info->ScopeOf( e )
            if fsc = Tko.SCOPE_NONE then fsc = c.procScope
            if fsc = Tko.SCOPE_NONE then fsc = c.modScope
            dim as Tko.Check.ConstVal cv = Tko.Check.ConstOf( _
                *c.ast, e, *c.srcMgr, *c.names, c.types->target.pointerBits, _
                c.syms, fsc )
            if cv.known = false then return false
            bits = cv.value
        end if

        if (off < 0) orelse (off + wid > size_) then return false
        '' 'wid', not 'width': WIDTH IS A KEYWORD -- the WIDTH statement -- so
            '' 'width = 4' parses as one and the declaration never happens.
            '' LITTLE-ENDIAN, which is the only byte order either target has.
        for k as long = 0 to wid - 1
            dim as ubyte bv = cast( ubyte, (bits shr (k * 8)) and &hFF )
            img[off + k] = bv
        next
    next

    outBytes = img
    return true
end function

end namespace
