'' lowerproc.bas -- the two PROCEDURE lowerings: a user SUB/FUNCTION, and the
'' implicit main that module-level code goes into.
''
'' Split out of lower.bas when the result slot pushed that file past the 1,500-line
'' limit. They belong together: both build a MirFunction from nothing, both open the
'' entry block, and both own a zero-initialised result slot -- main's IS the process
'' exit code, and a function's is what 'function = expr' writes to.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

'' ------------------------------------------------------------------ the walk

'' True for a member definition whose OWNER IS A GENERIC -- the template itself, not an
'' instantiation of it. The owner is reached through the procedure's scope rather than
'' through its ownerName, because an instantiation's members are qualified by the
'' structural name and the two must not be confused.
private function IsGenericMemberBody_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as boolean

    dim as Tko.ScopeId ps = c.info->ScopeOf( id )
    if ps = Tko.SCOPE_NONE then return false
    dim as Tko.SymScope ptr sc = c.syms->ScopeAt( ps )
    if sc = 0 then return false
    dim as Tko.SymScope ptr owner = c.syms->ScopeAt( sc->parent )
    if owner = 0 then return false
    dim as Tko.Symbol ptr os = c.syms->SymbolAt( owner->owner )
    if os = 0 then return false
    if os->kind <> cast( ubyte, Tko.SYM_UDT ) then return false
    dim as Tko.NodeId tn = cast( Tko.NodeId, os->payload )
    if tn = Tko.NODE_NONE then return false
    if c.ast->Kind( tn ) <> Tko.N_TYPE then return false
    dim as Tko.StmtPayload ptr tp = StmtOf( c, tn )
    '' 'b' holds the type PARAMETERS. A plain UDT has none.
    if tp->b = Tko.NODE_NONE then return false
    '' AN INSTANTIATION SHARES THE GENERIC'S NODE as its payload, so the node alone
    '' does not tell them apart -- the NAME does: the generic is declared under its
    '' source spelling, an instantiation under the structural key.
    return (os->name = tp->name)
end function

'' Does this constructor body WRITE 'base( ... )'? A top-level statement of the body
'' only -- fbc rejects the call anywhere else, and looking deeper would suppress the
'' implicit construction for a 'base( )' the language never let run there.
private function BodyCallsBase_( byref c as Ctx, byval body as Tko.NodeId ) as boolean
    if body = Tko.NODE_NONE then return false
    if c.ast->Kind( body ) <> Tko.N_BLOCK then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, body )].data )]
    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId st = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( st ) <> Tko.N_AMBIGUOUS then continue for
        dim as Tko.NodeId e = StmtOf( c, st )->a
        if e = Tko.NODE_NONE then continue for
        if c.ast->Kind( e ) <> Tko.N_CALL then continue for
        dim as Tko.ListPayload ptr cp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
        if cp->target = Tko.NODE_NONE then continue for
        if c.ast->Kind( cp->target ) <> Tko.N_IDENT then continue for
        dim as Tko.IdentPayload ptr tip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
        if Tko.Text.LowerAscii( c.names->Spelling( tip->name ) ) = "base" then return true
    next
    return false
end function

sub LowerProc _
    ( byref c as Ctx, byval id as Tko.NodeId )

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->b = Tko.NODE_NONE then return       '' a declaration, not a definition

    '' A GENERIC'S OWN MEMBER BODY IS NOT CODE. 'sub Box.Put( byval x as T )' has no
    '' meaning until T is something: its parameter is void, its fields have no offsets,
    '' and lowering it produced a function that stored into nothing and returned
    '' nothing. fbc emits no such function either -- an uninstantiated generic reaches
    '' its output not at all. The INSTANTIATIONS are separate nodes and are lowered.
    if IsGenericMemberBody_( c, id ) then return

    '' A GENERIC PROCEDURE is not code either, for the same reason and one step worse:
    '' tiko-lang does not even keep its type parameters, so nothing can instantiate it. Its
    '' body used to lower with every 'as T' standing for nothing -- 'local agg r size 0'
    '' beside stores into void slots -- and it counted as fully lowered. Declining says
    '' what is actually true.
    '' SILENTLY, exactly as the generic member body above. A template is NOT CODE, so
    '' not emitting it is the RIGHT answer and not a decline -- fbc emits nothing for
    '' one either. Counting it said 8,096 things were owed that were not: a template
    '' nobody instantiates needs no instantiation, and one that is instantiated shows
    '' up as the instantiation. What a MISSING instantiation looks like is a CALL that
    '' bound to nothing, and that is counted where it happens.
    if (sp->extra and Tko.PF_GENERIC_PROC) <> 0 then return

    dim as Tko.SymbolId sid = c.info->RefOf( id )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    dim as Tko.TypeId rt = iif( s <> 0, s->type_, Tko.TYPE_NONE )

    '' MIR carries the MANGLED name and never a source one.
    dim as Tko.InternId nm = c.names->GetString( _
        Tko.Mangle.ProcName( *c.ast, id, *c.syms, *c.names, *c.types, *c.info ) )

    '' A STRING-RETURNING FUNCTION RETURNS A POINTER. fbc's own C says so --
    '' 'FBSTRING* F( void )' -- because the value leaves through
    '' fb_StrAllocTempResult, not as the descriptor itself. Declaring it 'agg' would
    '' put a type on the function that its own 'ret' contradicts.
    dim as MirType declRet = LowerType( rt, *c.types )
    if rt <> Tko.TYPE_NONE then
        if IsStringType( c, rt ) then declRet = MT_PTR
        '' A UDT RETURNED THROUGH THE HIDDEN POINTER returns THAT POINTER, which is
        '' what fbc's own C says: 'struct T* F( struct T* tmp )'. Declaring it 'agg'
        '' would put a type on the function that its own 'ret' contradicts.
        if UsesSretReturn( c, rt ) then declRet = MT_PTR
        '' A BYREF RETURN IS A POINTER, which is what a reference IS at the ABI:
        '' fbc writes 'struct INNER* F( void )' for 'function f( ) byref as Inner'.
        '' Declared 'agg', the function returned the object by the hidden-pointer
        '' convention while every CALL to it read a pointer -- and 'operator ->', which
        '' is byref by construction, is the shape that made it visible.
        if (c.ast->nodes[cast( long, id )].flags and Tko.NF_BYREF) <> 0 then
            declRet = MT_PTR
        end if
    end if
    dim as MirFunction ptr f = c.m->AddFunction( nm, declRet )
    f->isDefinition = true
    dim as MirFunction ptr savedF = c.f
    dim as long savedB = c.curBlock
    dim as Tko.SymbolId savedSym = c.curProcSym
    c.f = f
    c.curProcSym = sid
    c.st->functions += 1

    '' An instance method takes THIS as parameter ZERO. It is never written in the
    '' source, so nothing else would count it -- and without it '@this' named a fresh
    '' uninitialised local while every CALL site dutifully passed a receiver into
    '' nothing.
    dim as Tko.SymbolId thisSym = Tko.SYMBOL_NONE
    if s <> 0 then
        if s->inner <> Tko.SCOPE_NONE then
            thisSym = c.syms->LookupLocal( s->inner, _
                c.names->Fold( c.names->GetString( "this" ) ) )
        end if
    end if

    '' A NAMESPACE-QUALIFIED PROCEDURE HAS NO RECEIVER. 'private function
    '' procA.f1( ) as integer' defines a free function in a namespace, not a method,
    '' and fbc gives it no 'this' at all -- but Collect declares one for every
    '' qualified definition, because at that point it cannot tell a namespace from a
    '' type. So the function took a parameter nothing passed, spilled it into an
    '' untyped local, and 17 stores in one corpus file went into a 'void' slot.
    ''
    '' Decided here rather than in Collect: only by now is the owner's KIND known.
    if thisSym <> Tko.SYMBOL_NONE then
        '' A CONSTRUCTOR, DESTRUCTOR, OPERATOR or PROPERTY is a member by construction
        '' and always has one. 'constructor ns.UDT( )' is qualified by a NAMESPACE and
        '' owned by a TYPE, so nothing about the qualifier decides it -- testing the
        '' enclosing scope's parent got that wrong and silently emptied ten corpus
        '' files' worth of constructors.
        dim as boolean isStructor = false
        select case cast( Tko.TokenKind, sp->op )
        case Tko.KW_CONSTRUCTOR, Tko.KW_DESTRUCTOR, Tko.KW_OPERATOR, Tko.KW_PROPERTY
            isStructor = true
        end select

        if isStructor = false then
            '' Otherwise: a receiver exists only if a TYPE scope encloses the
            '' procedure. 'private function procA.f1( ) as integer' inside 'namespace
            '' procA' is a FREE FUNCTION, and fbc gives it no 'this' -- but Collect
            '' declares one for every qualified definition, because at that point it
            '' cannot tell a namespace from a type. The function then took a parameter
            '' nothing passed and spilled it into an untyped local: 17 stores into a
            '' 'void' slot in one file.
            dim as Tko.Symbol ptr ts = c.syms->SymbolAt( thisSym )
            dim as boolean inType = false
            if ts <> 0 then
                dim as Tko.ScopeId walk = ts->parent
                dim as long guard = 0
                while (walk <> Tko.SCOPE_NONE) andalso (guard < 64)
                    dim as Tko.SymScope ptr sc2 = c.syms->ScopeAt( walk )
                    if sc2 = 0 then exit while
                    if sc2->kind = cast( ubyte, Tko.SCOPEK_TYPE ) then
                        inType = true
                        exit while
                    end if
                    walk = sc2->parent
                    guard += 1
                wend
            end if
            if inType = false then thisSym = Tko.SYMBOL_NONE
        end if
    end if
    '' THE HIDDEN RESULT POINTER IS A PARAMETER. Counted here so the declaration and
    '' every call site agree on the arity -- on win32 fbc EXCLUDES it from the stdcall
    '' '@N' but the callee still pops it, so the two numbers are genuinely different
    '' things and only this one is the argument count.
    if UsesSretReturn( c, rt ) then f->paramCount += 1
    if thisSym <> Tko.SYMBOL_NONE then f->paramCount += 1

    for i as long = 0 to sp->count - 1
        if c.ast->Kind( cast( Tko.NodeId, c.ast->children[sp->first + i] ) ) = Tko.N_PARAM then
            f->paramCount += 1
        end if
    next

    c.curBlock = NewBlock( c, "entry" )

    '' The result slot, zero-initialised, exactly as fbc's C does it. Only for a
    '' SCALAR result: a STRING or UDT return goes through a hidden pointer tiko-lang does
    '' not model yet, and inventing a slot for one would miscompile silently rather
    '' than decline -- which is the failure mode this file has hit four times.
    dim as long savedRes = c.resultSlot
    dim as ubyte savedResTy = c.resultTy
    dim as Tko.TypeId savedResType = c.resultType
    dim as long savedSret = c.sretParam
    dim as boolean savedUdtRes = c.udtResult
    c.udtResult = false
    c.resultSlot = -1
    c.resultTy = cast( ubyte, MT_VOID )
    c.resultType = Tko.TYPE_NONE
    c.sretParam = -1

    dim as MirType rmt = LowerType( rt, *c.types )
    dim as boolean scalarResult = (rt <> Tko.TYPE_NONE) andalso (rmt <> MT_VOID) andalso _
                                  (rmt <> MT_AGG)

    '' A UDT RESULT WITH A DESTRUCTOR OR A COPY CONSTRUCTOR travels through an
    '' EXPLICIT HIDDEN POINTER: parameter 0, holding the caller's storage, and the
    '' function returns that same pointer. Measured, and the rule is about TRIVIALITY,
    '' not size -- a one-byte type with a destructor is sret and a sixteen-byte POD is
    '' not. See docs/internals/phase-6-udt-return.md.
    ''
    '' There is NO result local in this case: the hidden pointer IS the result object,
    '' so 'function = expr' writes straight through it.
    dim as boolean sretResult = false
    if (rt <> Tko.TYPE_NONE) andalso (scalarResult = false) then
        sretResult = UsesSretReturn( c, rt )
    end if

    '' A STRING RESULT is an aggregate, but not one that needs a hidden pointer: fbc
    '' builds it in a LOCAL DESCRIPTOR and returns what fb_StrAllocTempResult gives
    '' back for it.
    ''
    ''     FBSTRING fb$result;  memset( &fb$result, 0, 24 );
    ''     fb_StrInit( &fb$result, -1, "hi", 3, 0 );
    ''     return fb_StrAllocTempResult( &fb$result );
    ''
    '' So the slot IS a descriptor and 'function = expr' is an ordinary string
    '' assignment into it -- which is why this one can be modelled where the UDT
    '' return, whose value really does come back through a hidden pointer, cannot.
    dim as boolean stringResult = false
    if (rt <> Tko.TYPE_NONE) andalso (scalarResult = false) then
        stringResult = IsStringType( c, rt )
    end if
    if stringResult then
        c.resultSlot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
        c.resultTy = cast( ubyte, MT_AGG )
        c.resultType = rt
        dim as MirValue sa
        sa.kind = cast( ubyte, MV_LOCAL )
        sa.ty = cast( ubyte, MT_PTR )
        sa.id = c.resultSlot
        '' The descriptor must be ZEROED before anything registers a delete for it,
        '' exactly as a string local is.
        ZeroStrDescriptor( c, sa )
    end if

    if sretResult then
        '' The hidden pointer is parameter 0, BEFORE 'this'. Its slot is an ordinary
        '' local holding the pointer, exactly as 'this' is.
        c.sretParam = NewTempLocal( c, MT_PTR, c.types->target.pointerBits \ 8 )
        c.resultTy = cast( ubyte, MT_AGG )
        c.resultType = rt
        dim as MirValue sa
        sa.kind = cast( ubyte, MV_LOCAL )
        sa.ty = cast( ubyte, MT_PTR )
        sa.id = c.sretParam
        dim as MirValue spv
        spv.kind = cast( ubyte, MV_PARAM )
        spv.ty = cast( ubyte, MT_PTR )
        spv.id = 0
        dim as MirInst sins
        sins.op = cast( ushort, M_STORE )
        sins.ty = cast( ubyte, MT_VOID )
        sins.a = sa
        sins.b = spv
        Emit( c, sins )
    end if

    '' A TRIVIAL UDT RESULT -- no destructor, no copy constructor -- is returned BY
    '' VALUE. fbc emits a named 'fb$result' local, zeroed at entry, and returns it:
    ''
    ''     struct BIG MKB1( void ) { struct BIG fb$result$1; memset(...); ...
    ''                               return fb$result$1; }
    ''
    '' MIR says the same thing. An aggregate VALUE is already a first-class thing in
    '' this IR -- 'y = x' over a UDT is a whole-aggregate load and store -- so
    '' returning one needs no new shape, and WHICH REGISTER OR MEMORY it travels in is
    '' the backend's decision. That is the same division of labour fbc has with gcc:
    '' fbc's frontend never names a register either.
    '' Hoisted to a boolean local: FreeBASIC warns 38 on a mixed boolean/non-boolean
    '' chain, and the house rule is to name the condition rather than silence it.
    dim as boolean haveRet = (rt <> Tko.TYPE_NONE)
    dim as boolean udtByValue = false
    if haveRet andalso (scalarResult = false) andalso (sretResult = false) then
        udtByValue = (c.types->Kind( rt ) = Tko.TK_UDT)
        '' A 'cva_list' RESULT IS THE SAME SHAPE and needs the same slot. It is a
        '' BUILTIN rather than a UDT, so the kind test alone said no to it and
        '' 'function = args' declined in four places in one corpus file. fbc gives it
        '' the same named result local everything else here gets:
        ''
        ''     __builtin_va_list fb$result$1;  __builtin_memset( &fb$result$1, 0, 8 );
        ''     fb$result$1 = ARGS$1;  return fb$result$1;
        ''
        '' Only cva_list is added, not 'anything that lowers to MT_AGG': a STRING
        '' result is also an aggregate and is handled above, by a path that zeroes the
        '' descriptor and registers its cleanup.
        if udtByValue = false then
            if c.types->Kind( rt ) = Tko.TK_BUILTIN then
                udtByValue = (c.types->BuiltinOf( rt ) = Tko.TY_CVA_LIST)
            end if
        end if
    end if
    if udtByValue then
        c.resultSlot = NewTempLocal( c, MT_AGG, SizeOfType( c, rt ) )
        c.resultTy = cast( ubyte, MT_AGG )
        c.resultType = rt
        c.udtResult = true
    end if

    if scalarResult then
        c.resultSlot = NewTempLocal( c, rmt, c.types->Layout( rt ).size )
        c.resultTy = cast( ubyte, rmt )
        c.resultType = rt
        dim as MirValue ra
        ra.kind = cast( ubyte, MV_LOCAL )
        ra.ty = cast( ubyte, MT_PTR )
        ra.id = c.resultSlot
        dim as MirInst zi
        zi.op = cast( ushort, M_STORE )
        zi.ty = cast( ubyte, MT_VOID )
        zi.a = ra
        zi.b = ZeroOf( c, rmt )
        Emit( c, zi )
    end if

    '' A parameter is a slot like any other local, written once on entry. That is
    '' what makes 'byval' parameters assignable, which FreeBASIC allows, and it is
    '' the shape mem2reg expects.
    '' THE HIDDEN POINTER CONSUMES ARGUMENT SLOT 0, so 'this' and every visible
    '' parameter shift up by one. Measured in fbc's own assembly: for a method with a
    '' hidden pointer, RCX is the pointer and RDX is 'this', and a later double lands
    '' in XMM3 rather than XMM1.
    dim as long pidx = 0
    if c.sretParam >= 0 then pidx = 1
    if thisSym <> Tko.SYMBOL_NONE then
        '' THIS is a POINTER TO the object -- the symbol carries that type, so the slot
        '' comes out a pointer and 'this.field' reaches through it like any other
        '' pointer base. It is what fbc's own C says: 'struct $1T* THIS$1'.
        dim as long tslot = LocalFor( c, thisSym )
        if tslot < 0 then tslot = 0
        '' AN UNTYPED 'this' gets a VOID slot, and storing the receiver into it is
        '' malformed. That happens when the structor's owner does not name a type here
        '' -- which is now TKO0323 -- so the error is already reported and the store
        '' would only add a verify failure on top of it.
        dim as boolean thisTyped = true
        if tslot < c.f->locals.Count then
            thisTyped = (c.f->locals[tslot].ty <> cast( ubyte, MT_VOID ))
        end if
        if thisTyped = false then
            pidx += 1
            thisSym = Tko.SYMBOL_NONE
        end if
    end if
    if thisSym <> Tko.SYMBOL_NONE then
        dim as long tslot = LocalFor( c, thisSym )
        if tslot < 0 then tslot = 0
        dim as MirValue taddr
        taddr.kind = cast( ubyte, MV_LOCAL )
        taddr.ty = cast( ubyte, MT_PTR )
        taddr.id = tslot
        dim as MirValue tpv
        tpv.kind = cast( ubyte, MV_PARAM )
        tpv.ty = cast( ubyte, MT_PTR )
        tpv.id = pidx
        dim as MirInst tins
        tins.op = cast( ushort, M_STORE )
        tins.ty = cast( ubyte, MT_VOID )
        tins.a = taddr
        tins.b = tpv
        Emit( c, tins )
        pidx += 1
    end if
    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        dim as Tko.StmtPayload ptr pp = StmtOf( c, prm )
        dim as Tko.SymbolId psid = _
            c.syms->LookupLocalTyped( c.info->ScopeOf( id ), pp->name, false )
        if psid <> Tko.SYMBOL_NONE then
            dim as long slot = LocalFor( c, psid )
            if slot >= 0 then
                dim as MirValue addr
                addr.kind = cast( ubyte, MV_LOCAL )
                addr.ty = cast( ubyte, MT_PTR )
                addr.id = slot
                dim as MirValue pv
                pv.kind = cast( ubyte, MV_PARAM )
                pv.ty = c.f->locals[slot].ty
                pv.id = pidx
                dim as MirInst ins
                ins.op = cast( ushort, M_STORE )
                ins.ty = cast( ubyte, MT_VOID )
                ins.a = addr
                ins.b = pv
                Emit( c, ins )
            end if
        end if
        pidx += 1
    next

    '' Labels are per-function: the same name in two procedures is two labels.
    while c.labelName.Count > 0
        c.labelName.Pop( ) : c.labelBlock.Pop( ) : c.labelDepth.Pop( )
    wend

    '' THE IMPLICIT PROLOGUE OF A CONSTRUCTOR, and the vptr of a destructor.
    ''
    '' Measured: fbc PREPENDS the whole synthesised prologue to a written constructor
    '' rather than using one instead of the other -- the base call, then the fields in
    '' declaration order, then the vptr -- and prepends the vptr store to a written
    '' destructor. Whose epilogue is appended after the body, below.
    ''
    '' So a written 'constructor B( )' still constructs A, and still zeroes its own
    '' string fields before its first statement can assign through one.
    dim as Tko.TypeId structorType = Tko.TYPE_NONE
    dim as boolean inCtor = false
    if (thisSym <> Tko.SYMBOL_NONE) andalso (s <> 0) then
        dim as Tko.InternId ctorNm = c.names->Fold( c.names->GetString( "__ctor" ) )
        dim as Tko.InternId dtorNm = c.names->Fold( c.names->GetString( "__dtor" ) )
        if (s->name = ctorNm) orelse (s->name = dtorNm) then
            inCtor = (s->name = ctorNm)
            dim as Tko.SymScope ptr ownerSc = c.syms->ScopeAt( s->parent )
            if ownerSc <> 0 then
                dim as Tko.Symbol ptr ownerSym = c.syms->SymbolAt( ownerSc->owner )
                if ownerSym <> 0 then structorType = ownerSym->type_
            end if
        end if
    end if

    '' ASKED BEFORE ANYTHING IS EMITTED. Loading 'this' and then finding there is
    '' nothing to do left a dead load in the prologue of every structor of every
    '' ordinary UDT -- the same mistake, twice, in the same function.
    dim as boolean wantsPrologue = false
    if structorType <> Tko.TYPE_NONE then
        if inCtor then
            wantsPrologue = NeedsCtorBody_( c, structorType )
        elseif c.vts <> 0 then
            wantsPrologue = (c.vts->Find( structorType ) >= 0)
        end if
    end if

    if wantsPrologue then
        dim as MirValue ta = AddrOfVar( c, thisSym )
        if ta.kind <> cast( ubyte, MV_NONE ) then
            dim as MirValue tv = LowerExprLoad( c, ta, MT_PTR )
            if inCtor then
                EmitCtorPrologue_( c, structorType, tv, BodyCallsBase_( c, sp->b ) )
            else
                '' THE VPTR FIRST in a destructor, so its body -- and anything it calls
                '' -- sees this type's own table rather than the derived one.
                StoreVptr_( c, structorType, tv )
            end if
        end if
    end if

    dim as long scopeDepthIn = c.scopeMark.Count
    PushScope( c )

    '' THE IMPLICIT EPILOGUE OF A DESTRUCTOR -- the fields in REVERSE declaration order,
    '' then the base's destructor -- IS A CLEANUP ACTION, not something appended after
    '' the body.
    ''
    '' A 'return' inside a destructor leaves through the cleanup path, so appending it
    '' meant such a destructor released NOTHING. Registered FIRST, so reverse
    '' registration order runs it LAST: after every local the body declares, which is
    '' the order fbc emits.
    dim as boolean wantsEpilogue = false
    if (structorType <> Tko.TYPE_NONE) andalso (inCtor = false) then
        wantsEpilogue = NeedsDtorBody_( c, structorType )
    end if
    if wantsEpilogue then
        '' The slot holds THIS, which is a pointer, so the action LOADS it rather than
        '' taking its address.
        dim as long tslot = LocalFor( c, thisSym )
        if tslot >= 0 then
            c.cleanupNode.Push( CLEANUP_DTOR_EPILOGUE )
            c.cleanupSlot.Push( tslot )
            c.cleanupType.Push( cast( ulong, structorType ) )
        end if
    end if

    '' Depths are recorded relative to the scope just opened for the body, which is the
    '' depth a label written directly in the procedure sees.
    ScanLabels( c, sp->b, scopeDepthIn + 1 )
    LowerBlock( c, sp->b )
    CloseScope( c )
    '' Every scope opened must have been closed. An imbalance means some exit path
    '' skipped a scope's cleanup, which is the bug class this whole model exists to
    '' prevent, so it is checked rather than assumed.
    if c.scopeMark.Count <> scopeDepthIn then
        c.st->scopeImbalance += 1
    end if
    '' A function whose last block has no terminator falls off the end; FreeBASIC
    '' allows that and returns the result variable, so an explicit RET closes it.
    '' A STRING result leaves through the runtime, not as a load of the slot.
    if c.udtResult andalso (c.resultSlot >= 0) then
        '' By value: the result local's VALUE, exactly as fbc returns fb$result.
        dim as MirValue ura
        ura.kind = cast( ubyte, MV_LOCAL )
        ura.ty = cast( ubyte, MT_PTR )
        ura.id = c.resultSlot
        Terminate( c, MTERM_RET, -1, -1, LowerExprLoad( c, ura, MT_AGG ) )
    elseif c.sretParam >= 0 then
        '' A UDT returned through the hidden pointer returns THAT POINTER, whether the
        '' function fell off the end or not: fbc emits 'return tmp$2$1' at the exit
        '' label either way.
        dim as MirValue spa2
        spa2.kind = cast( ubyte, MV_LOCAL )
        spa2.ty = cast( ubyte, MT_PTR )
        spa2.id = c.sretParam
        Terminate( c, MTERM_RET, -1, -1, LowerExprLoad( c, spa2, MT_PTR ) )
    elseif (c.resultSlot >= 0) andalso (c.resultTy = cast( ubyte, MT_AGG )) then
        dim as MirValue ra2
        ra2.kind = cast( ubyte, MV_LOCAL )
        ra2.ty = cast( ubyte, MT_PTR )
        ra2.id = c.resultSlot
        dim as FB.Array( of ulong ) rargs
        rargs.Push( cast( ulong, ra2.kind ) ) : rargs.Push( cast( ulong, ra2.id ) )
        dim as MirValue rv2 = EmitRtl( c, RTL_STR_TEMP_RESULT, rargs )
        Terminate( c, MTERM_RET, -1, -1, rv2 )
    else
        Terminate( c, MTERM_RET, -1, -1, LoadResult( c ) )
    end if

    '' EVERY block must have a terminator, not just the last one. A block created for
    '' a label the lowering never reached -- a forward GOTO into a statement that was
    '' DECLINED -- is left open and nothing else closes it, and a block with no
    '' terminator is not IR at all.
    ''
    '' Measured: 9 such blocks across the corpus, in files whose GOTO jumps into a WITH
    '' or a SELECT CASE over a string. The repair is a fallthrough to the next block in
    '' order, which is what an EMPTY label body degenerates to, rather than a RET, which
    '' would invent an early exit from a procedure that has none.
    ''
    '' Counted, not silent: a repair here always means something above declined, and a
    '' number that only ever goes down is worth being able to read.
    for bi as long = 0 to c.f->blocks.Count - 1
        if c.f->blocks[bi].term <> cast( ubyte, MTERM_NONE ) then continue for
        c.st->blocksRepaired += 1
        if bi + 1 < c.f->blocks.Count then
            c.f->blocks[bi].term = cast( ubyte, MTERM_BR )
            c.f->blocks[bi].target = bi + 1
        else
            c.f->blocks[bi].term = cast( ubyte, MTERM_RET )
        end if
    next


    c.f = savedF
    c.curProcSym = savedSym
    c.curBlock = savedB
    c.udtResult = savedUdtRes
    c.sretParam = savedSret
    c.resultSlot = savedRes
    c.resultTy = savedResTy
    c.resultType = savedResType
end sub


'' The implicit main, into which module-level code is lowered.
''
'' MEASURED from fbc's own C intermediate for the main translation unit ('fbc -r -m'),
'' not assumed:
''
''     int32 main( int32 argc, char** argv ) {
''         int32 fb$result$0;
''         __builtin_memset( &fb$result$0, 0, 4 );
''         fb_Init( argc, argv, 0 );
''         ... module-level body ...
''         fb_StrDelete( &S$0 );          <- cleanups, BEFORE fb_End
''         fb_End( 0 );
''         return fb$result$0;
''     }
''
'' Two things that shape the lowering and would be easy to get wrong the other way:
''
'' The result slot is ZERO-INITIALISED and returned. It is the process exit code, which
'' 'END n' writes; falling off the end must yield 0, so the store is unconditional.
''
'' Module-level 'dim' becomes a LOCAL of main, not a global. That looks surprising for
'' a variable declared at file scope, but a module-level DIM without SHARED is visible
'' only at module level, so a local is exactly right -- and it is what makes the string
'' cleanup above run at all.
declare function ModuleHasCode( byref c as Ctx, byval id as Tko.NodeId ) as boolean

'' 'function = expr' inside a UDT function that returns through the HIDDEN POINTER.
''
'' There is no result local: the pointer IS the result object, so the value is copied
'' straight through it. Measured -- fbc emits '__builtin_memcpy( tmp$2$1, &T$1, 4 )'.
''
'' fbc uses the type's 'operator let' where it has one. tiko-lang does not, here or in an
'' ordinary UDT assignment: both are a whole-aggregate load and store. That is one
'' behaviour, consistently wrong for a type with a user LET, rather than two.
function LowerSretResult( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean
    if c.sretParam < 0 then return false
    if valueE = Tko.NODE_NONE then return false

    '' The VALUE first, the address only as a fallback: 'function = F( )' has no
    '' address to take, and a call result is already an aggregate value here.
    dim as MirValue val = LowerExpr( c, valueE )
    if val.kind = cast( ubyte, MV_NONE ) then
        dim as MirValue src = LowerAddr( c, valueE )
        if src.kind = cast( ubyte, MV_NONE ) then return false
        val = LowerExprLoad( c, src, MT_AGG )
    end if
    if val.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirValue sa
    sa.kind = cast( ubyte, MV_LOCAL )
    sa.ty = cast( ubyte, MT_PTR )
    sa.id = c.sretParam
    dim as MirValue dst = LowerExprLoad( c, sa, MT_PTR )
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirInst st
    st.op = cast( ushort, M_STORE )
    st.ty = cast( ubyte, MT_VOID )
    st.a = dst
    st.b = val
    Emit( c, st )
    return true
end function


sub LowerMainModule( byref c as Ctx, byval root as Tko.NodeId )
    if root = Tko.NODE_NONE then return
    if c.ast->Kind( root ) <> Tko.N_MODULE then return

    '' Nothing to run means no main at all, rather than an empty one: a module compiled
    '' as a library has no entry point and emitting one would collide at link time.
    if ModuleHasCode( c, root ) = false then return

    dim as MirFunction ptr f = c.m->AddFunction( c.names->GetString( "main" ), MT_I32 )
    f->isDefinition = true
    f->paramCount = 2                     '' argc, argv
    dim as MirFunction ptr savedF = c.f
    dim as long savedB = c.curBlock
    c.f = f
    c.st->functions += 1
    c.curBlock = NewBlock( c, "entry" )

    dim as long resSlot = NewTempLocal( c, MT_I32, 4 )
    dim as MirValue resAddr
    resAddr.kind = cast( ubyte, MV_LOCAL )
    resAddr.ty = cast( ubyte, MT_PTR )
    resAddr.id = resSlot
    dim as MirInst z
    z.op = cast( ushort, M_STORE )
    z.ty = cast( ubyte, MT_VOID )
    z.a = resAddr
    z.b = ConstInt( c, 0, MT_I32 )
    Emit( c, z )

    dim as MirValue argcv, argvv
    argcv.kind = cast( ubyte, MV_PARAM )
    argcv.ty = cast( ubyte, MT_I32 )
    argcv.id = 0
    argvv.kind = cast( ubyte, MV_PARAM )
    argvv.ty = cast( ubyte, MT_PTR )
    argvv.id = 1
    dim as FB.Array( of ulong ) ia
    ia.Push( cast( ulong, argcv.kind ) ) : ia.Push( cast( ulong, argcv.id ) )
    ia.Push( cast( ulong, argvv.kind ) ) : ia.Push( cast( ulong, argvv.id ) )
    dim as MirValue zero_ = ConstInt( c, 0, MT_I32 )
    ia.Push( cast( ulong, zero_.kind ) ) : ia.Push( cast( ulong, zero_.id ) )
    EmitRtl( c, RTL_INIT, ia )

    while c.labelName.Count > 0
        c.labelName.Pop( ) : c.labelBlock.Pop( ) : c.labelDepth.Pop( )
    wend

    '' The implicit restore, immediately after fb_Init and before the module body --
    '' which is where fbc puts it. Emitted only when this module actually has a DATA
    '' statement; a main module with READ but no DATA gets none at all.
    EmitImplicitRestore( c )

    dim as long scopeDepthIn = c.scopeMark.Count
    PushScope( c )
    '' The children are walked directly rather than through LowerBlock. N_MODULE is a
    '' LIST node, so handing it to a routine that reads a statement payload would read
    '' the wrong pool -- the mistake this file has made three times already.
    dim as Tko.ListPayload ptr mp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, root )].data )]
    for i as long = 0 to mp->count - 1
        ScanLabels( c, cast( Tko.NodeId, c.ast->children[mp->first + i] ), _
                    scopeDepthIn + 1 )
    next
    for i as long = 0 to mp->count - 1
        LowerStmt( c, cast( Tko.NodeId, c.ast->children[mp->first + i] ) )
    next
    CloseScope( c )
    if c.scopeMark.Count <> scopeDepthIn then
        c.st->scopeImbalance += 1
    end if

    '' fb_End comes AFTER the scope's cleanups: the measurement shows fb_StrDelete
    '' preceding it, so shutting the runtime down before releasing its strings would
    '' invert the order fbc actually emits.
    dim as FB.Array( of ulong ) ea
    dim as MirValue zend = ConstInt( c, 0, MT_I32 )
    ea.Push( cast( ulong, zend.kind ) ) : ea.Push( cast( ulong, zend.id ) )
    EmitRtl( c, RTL_END, ea )

    dim as MirValue rv = LowerExprLoad( c, resAddr, MT_I32 )
    Terminate( c, MTERM_RET, -1, -1, rv )

    '' The same repair the procedure path makes, for the same reason: module-level
    '' code is where the GOTO-into-a-declined-WITH files put their broken block.
    for bi as long = 0 to c.f->blocks.Count - 1
        if c.f->blocks[bi].term <> cast( ubyte, MTERM_NONE ) then continue for
        c.st->blocksRepaired += 1
        if bi + 1 < c.f->blocks.Count then
            c.f->blocks[bi].term = cast( ubyte, MTERM_BR )
            c.f->blocks[bi].target = bi + 1
        else
            c.f->blocks[bi].term = cast( ubyte, MTERM_RET )
        end if
    next

    c.f = savedF
    c.curBlock = savedB
end sub

'' Whether a module has anything to run, as opposed to only declarations.
function ModuleHasCode( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    if id = Tko.NODE_NONE then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    for i as long = 0 to lp->count - 1
        select case c.ast->Kind( cast( Tko.NodeId, c.ast->children[lp->first + i] ) )
        case Tko.N_PROC, Tko.N_TYPE, Tko.N_ENUM, Tko.N_TYPEDEF, Tko.N_NAMESPACE, _
             Tko.N_EXTERN_BLOCK, Tko.N_CONST, Tko.N_FIELD, Tko.N_PARAM
            '' A declaration; it does not put anything in main.
        case else
            return true
        end select
    next
    return false
end function

private sub WalkTop( byref c as Ctx, byval id as Tko.NodeId )
    if id = Tko.NODE_NONE then return
    select case c.ast->Kind( id )
    case Tko.N_MODULE, Tko.N_BLOCK
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            WalkTop( c, cast( Tko.NodeId, c.ast->children[lp->first + i] ) )
        next
    case Tko.N_NAMESPACE, Tko.N_EXTERN_BLOCK
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        for i as long = 0 to sp->count - 1
            WalkTop( c, cast( Tko.NodeId, c.ast->children[sp->first + i] ) )
        next
    case Tko.N_PROC
        LowerProc( c, id )
    end select
end sub

function Lower _
    ( byref ast as Tko.AstArena, byval root as Tko.NodeId, _
      byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byref info as Tko.SemanticInfo, _
      byref src as Tko.SourceManager, byref udts as Tko.UdtLayouts, _
      byref vts as Tko.VTables, _
      byref m as MirModule, byref st as LowerStats ) as long

    dim as Ctx c
    c.srcMgr = @src
    c.udts = @udts
    c.vts = @vts
    c.ast = @ast
    c.syms = @syms
    c.types = @types
    c.names = @names
    c.info = @info
    c.m = @m
    c.st = @st
    c.curBlock = -1

    '' DATA FIRST, before anything is lowered. Two reasons, and both are measured:
    '' 'restore lbl' may name a label that appears LATER in the file, and the block
    '' chain has to exist before the implicit restore at the top of main can point at
    '' its head.
    c.dataHead = CollectDataBlocks( c, root )

    WalkTop( c, root )
    '' THE INSTANTIATED GENERIC MEMBERS. They are procedures like any other, but they
    '' were created after the unit's root block was closed, so nothing reaches them
    '' from root -- they would be collected, resolved and typed, and then silently not
    '' emitted, which reads at a call site as a call into a name with no code.
    for i as long = 0 to ast.extraTopLevel.Count - 1
        WalkTop( c, cast( Tko.NodeId, ast.extraTopLevel[i] ) )
    next
    LowerMainModule( c, root )
    '' THE SYNTHESISED STRUCTORS, after every written one exists to be called by them
    '' and before the tables, whose destructor slot may name one.
    '' THE MODULE INITIALISER, before the structors it calls are written.
    EmitModuleInit_( c )
    EmitImplicitStructors( c )
    '' THE TABLES LAST. A slot names a FUNCTION, and naming one that was never lowered
    '' would put a reference to a symbol with no code in the module.
    EmitVTableGlobals( c )
    return st.functions
end function

'' 'return expr' out of a STRING-RETURNING function. Returns false when this is not
'' one, so the ordinary RETURN carries on.
''
'' The value does not leave as a value: it is BUILT in the result descriptor and handed
'' to fb_StrAllocTempResult on the way out, which is what fbc emits. Returning the
'' expression directly would hand back a pointer to static text where the caller expects
'' a descriptor.
function LowerStringReturn( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean
    if c.resultSlot < 0 then return false
    if c.resultTy <> cast( ubyte, MT_AGG ) then return false
    '' AND THE RESULT MUST ACTUALLY BE A STRING. MT_AGG alone stopped being enough the
    '' moment a by-value UDT result got an aggregate slot too: every 'return <udt>'
    '' came through here, tried a string assignment into it, and then emitted
    '' fb_StrAllocTempResult ON A UDT. Not a decline -- a string runtime call on an
    '' object, which lowers cleanly and verifies.
    if IsStringType( c, c.resultType ) = false then return false

    if valueE <> Tko.NODE_NONE then
        if LowerStringAssignToSlot( c, c.resultSlot, valueE ) = false then SkipHere( c )
    end if
    '' A RETURN leaves every open scope, so their actions run before the terminator.
    EmitCleanupsTo( c, 0 )

    dim as MirValue rsa
    rsa.kind = cast( ubyte, MV_LOCAL )
    rsa.ty = cast( ubyte, MT_PTR )
    rsa.id = c.resultSlot
    dim as FB.Array( of ulong ) rr
    rr.Push( cast( ulong, rsa.kind ) ) : rr.Push( cast( ulong, rsa.id ) )
    Terminate( c, MTERM_RET, -1, -1, EmitRtl( c, RTL_STR_TEMP_RESULT, rr ) )
    c.curBlock = -1
    return true
end function

end namespace
