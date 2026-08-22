'' lowerstore.bas -- where a variable's storage lives.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The subject is
'' one question -- frame slot or module storage -- and getting it wrong is not a
'' performance matter: a DIM SHARED that lands in a frame gives every procedure its own
'' private copy, and assignments to it are silently invisible to everyone else.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' THE BYTE SIZE OF A TYPE, for anything that has to reserve storage.
''
'' TypeContext.Layout does not know about UDTs -- their sizes live in the separate
'' layout table -- so it returns 0 for a UDT and, worse, 0 for an ARRAY OF UDT, because
'' its array case multiplies the element's Layout by the element count.
''
'' Both places that reserve storage worked around the first half by asking the UDT
'' table directly, and neither handled the second. So
''
''     dim as P pa(0 to 2)
''
'' reserved ZERO BYTES and then indexed into it: 'pa(1).x = 5' emitted a store at
'' offset 8 of a 0-byte slot. No diagnostic, no verify failure, correct-looking MIR,
'' and stack corruption at run time for every UDT array in the corpus.
''
'' One function now, recursive so an array of arrays of UDT works too.
function SizeOfType( byref c as Ctx, byval t as Fbx.TypeId ) as long
    if t = Fbx.TYPE_NONE then return 0
    dim as long ui = c.udts->Find( t )
    if ui >= 0 then return c.udts->udts[ui].size
    if c.types->Kind( t ) = Fbx.TK_ARRAY then
        '' A DYNAMIC array's storage is its DESCRIPTOR, not its elements -- the
        '' elements live wherever the runtime put them.
        if c.types->IsDynArray( t ) then return DescBytesFor( c, c.types->DynRank( t ) )
        dim as long es = SizeOfType( c, c.types->Inner( t ) )
        dim as long n = c.types->types[cast( long, t )].elems
        if n > 0 then return es * n
        return es
    end if
    return c.types->Layout( t ).size
end function


function LocalFor _
    ( byref c as Ctx, byval sid as Fbx.SymbolId ) as long

    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return -1
    '' By SYMBOL. Keying on the spelling merged two sibling-scope declarations of one
    '' name into a single slot, which then kept the FIRST declaration's MIR type --
    '' 974 of the corpus's verifier failures, and behind them a larger number of
    '' SILENT ones, because a 'dim as T x = e' initialiser coerces to the slot's type
    '' and so stores the wrong width cleanly, with nothing to report.
    ''
    '' GlobalFor below has carried a comment describing exactly this bug, fixed on its
    '' own table, since before this one existed.
    for i as long = 0 to c.f->locals.Count - 1
        if c.f->locals[i].sym = cast( ulong, sid ) then return i
    next
    dim as MirLocal l
    l.sym = cast( ulong, sid )
    '' The DUMP addresses a slot by name, so two slots of one spelling need telling
    '' apart there as well, exactly as a static local does.
    l.name = s->name
    for i as long = 0 to c.f->locals.Count - 1
        if c.f->locals[i].name = s->name then
            l.name = c.names->GetString( _
                c.names->Spelling( s->name ) & "$" & str( c.f->locals.Count ) )
            exit for
        end if
    next
    l.frontendType = s->type_
    l.ty = cast( ubyte, LowerType( s->type_, *c.types ) )
    '' A BYDESC ARRAY PARAMETER'S SLOT HOLDS A POINTER, not a descriptor. fbc's own
    '' signature says so -- 'void P( struct $7FBARRAYI1RE* ROWS$1 )' -- and giving it
    '' the descriptor's own 72 bytes described a local the caller never passed.
    if s->kind = cast( ubyte, Fbx.SYM_PARAMETER ) then
        if c.types->IsDynArray( s->type_ ) then
            l.ty = cast( ubyte, MT_PTR )
        end if
    end if
    '' An aggregate slot needs its SIZE: 'agg' says nothing about how many bytes to
    '' reserve, and the layout pass is the only thing that knows.
    l.size = SizeOfType( c, s->type_ )
    c.f->locals.Push( l )

    '' The alloca goes in the ENTRY block, which is a verifier rule and also what
    '' lets LLVM's mem2reg promote the slot.
    dim as long saved = c.curBlock
    c.curBlock = 0
    dim as MirInst ins
    ins.op = cast( ushort, M_ALLOCA )
    ins.ty = cast( ubyte, MT_PTR )
    ins.imm = c.f->locals.Count - 1
    Emit( c, ins )
    c.curBlock = saved
    return c.f->locals.Count - 1
end function

'' Whether a symbol is DIM SHARED, and so lives in module storage rather than a frame.
function IsSharedVar( byref c as Ctx, byval sid as Fbx.SymbolId ) as boolean
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    return ((s->flags and Fbx.SYMF_SHARED) <> 0)
end function

'' A STATIC local: procedure scope, but MODULE lifetime.
''
'' fbc emits it as a function-scoped C static, so it keeps its value across calls and is
'' initialised once rather than on entry:
''
''     void P( void ) { static int32 N$1 = 5;  N$1 = N$1 + 1; }
''
'' As a frame slot it would be reinitialised every call, which is the entire behaviour
'' the keyword exists to provide.
function IsStaticLocal( byref c as Ctx, byval sid as Fbx.SymbolId ) as boolean
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if (s->flags and Fbx.SYMF_SHARED) <> 0 then return false
    return ((s->flags and Fbx.SYMF_STATIC) <> 0)
end function

'' The storage name for a static local, which must be unique PER PROCEDURE.
''
'' fbc names both of these N$1 and relies on C function scoping to keep them apart:
''
''     void P( void ) { static int32 N$1; ... }
''     void Q( void ) { static int32 N$1; ... }
''
'' MIR globals are one flat table with no such scoping, so the two would silently merge
'' into one variable -- P and Q sharing a counter, which is exactly the class of bug
'' DIM SHARED had in reverse. The procedure name is therefore part of the storage name.
private function StaticName( byref c as Ctx, byval sid as Fbx.SymbolId ) as Fbx.InternId
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    dim as string owner = "?"
    if c.f <> 0 then owner = c.names->Spelling( c.f->name )
    return c.names->GetString( owner & "$" & c.names->Spelling( s->name ) )
end function

'' The global slot for a DIM SHARED variable, created on first reference.
''
'' This exists because LocalFor matches by NAME WITHIN THE CURRENT FUNCTION, so a shared
'' variable used by two procedures got two unrelated frame slots, and a SUB assigning it
'' updated nothing anyone else could see. Storage has to be per MODULE, not per frame.
declare function UniqueGlobalName _
    ( byref c as Ctx, byval nm as Fbx.InternId ) as Fbx.InternId

function GlobalFor( byref c as Ctx, byval sid as Fbx.SymbolId ) as long
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return -1

    '' Keyed by SYMBOL, not by spelling. Two statics called 'n' in sibling scopes of one
    '' procedure are two declarations and therefore two symbols; keying on the name
    '' merged them into a single variable that both scopes incremented.
    for i as long = 0 to c.gvarSym.Count - 1
        if c.gvarSym[i] = cast( ulong, sid ) then return c.gvarSlot[i]
    next

    dim as Fbx.InternId nm = s->name
    if IsStaticLocal( c, sid ) then nm = StaticName( c, sid )
    dim as long sz = SizeOfType( c, s->type_ )
    '' The storage NAME must still be unique, because it is what a linker and a golden
    '' diff see. A collision here means two distinct symbols wanted the same spelling,
    '' so the later one is suffixed rather than silently sharing.
    nm = UniqueGlobalName( c, nm )

    dim as long g = c.m->AddVarGlobal( nm, LowerType( s->type_, *c.types ), s->type_, sz )
    c.gvarSym.Push( cast( ulong, sid ) )
    c.gvarSlot.Push( g )
    return g
end function

'' A module-global name not already taken by a DIFFERENT symbol.
private function UniqueGlobalName _
    ( byref c as Ctx, byval nm as Fbx.InternId ) as Fbx.InternId

    dim as boolean taken = false
    for i as long = 0 to c.m->globals.Count - 1
        if c.m->globals[i].isVar andalso (c.m->globals[i].name = nm) then taken = true
    next
    if taken = false then return nm

    dim as string base_ = c.names->Spelling( nm )
    for n as long = 2 to 1000
        dim as Fbx.InternId cand = c.names->GetString( base_ & "$" & str( n ) )
        dim as boolean used = false
        for i as long = 0 to c.m->globals.Count - 1
            if c.m->globals[i].isVar andalso (c.m->globals[i].name = cand) then used = true
        next
        if used = false then return cand
    next
    return nm
end function

'' The ADDRESS of a variable, wherever its storage lives.
'' The ctor or dtor of a type, or SYMBOL_NONE. They live in the type's scope under a
'' synthetic name, because neither has a name of its own in the source.
function StructorOf _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref which as string ) as Fbx.SymbolId

    if t = Fbx.TYPE_NONE then return Fbx.SYMBOL_NONE
    if c.types->Kind( t ) <> Fbx.TK_UDT then return Fbx.SYMBOL_NONE
    dim as Fbx.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Fbx.SYMBOL_NONE
    dim as Fbx.ScopeId ds = cast( Fbx.ScopeId, c.types->DeclScopeOf( t ) )
    '' The UDT, so the TYPE-name class.
    dim as Fbx.SymbolId ts = c.syms->LookupTyped( ds, tn, true )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Fbx.SYMBOL_NONE
    if s->inner = Fbx.SCOPE_NONE then return Fbx.SYMBOL_NONE
    return c.syms->LookupLocal( s->inner, _
        c.names->Fold( c.names->GetString( which ) ) )
end function

'' The overload in a chain that takes exactly 'want' parameters. A default
'' constructor and a destructor are the zero-parameter ones -- taking the head of the
'' chain instead picked whichever overload happened to be first.
function StructorWithArity _
    ( byref c as Ctx, byval first_ as Fbx.SymbolId, byval want as long ) as Fbx.SymbolId

    dim as Fbx.SymbolId cur = first_
    while cur <> Fbx.SYMBOL_NONE
        dim as Fbx.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
        if (pn <> Fbx.NODE_NONE) andalso (c.ast->Kind( pn ) = Fbx.N_PROC) then
            dim as Fbx.StmtPayload ptr pp = StmtOf( c, pn )
            dim as long np = 0
            for i as long = 0 to pp->count - 1
                dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) = Fbx.N_PARAM then np += 1
            next
            if np = want then return cur
        end if
        cur = s->nextOverload
    wend
    return Fbx.SYMBOL_NONE
end function

'' A call to a structor with the slot's address as the implicit THIS. The receiver is
'' the first argument, per the ABI, which is also how the mangled name reads.
sub EmitStructorCall _
    ( byref c as Ctx, byval sym as Fbx.SymbolId, byval slot as long, _
      byval selfVal as MirValue ptr = 0, byval args as FB.Array( of ulong ) ptr = 0 )

    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
    if pn = Fbx.NODE_NONE then return
    if c.ast->Kind( pn ) <> Fbx.N_PROC then return

    '' A NEGATIVE slot means 'the receiver is already a value' -- DELETE has a POINTER
    '' in hand, not a local whose address is the receiver. Passed through 'selfVal'
    '' rather than by widening every caller.
    dim as MirValue self_
    if selfVal <> 0 then self_ = *selfVal
    if slot >= 0 then
        self_.kind = cast( ubyte, MV_LOCAL )
        self_.ty = cast( ubyte, MT_PTR )
        self_.id = slot
    end if
    if self_.kind = cast( ubyte, MV_NONE ) then return

    dim as long first = c.m->argPool.Count \ 2
    c.m->argPool.Push( cast( ulong, self_.kind ) )
    c.m->argPool.Push( cast( ulong, self_.id ) )
    '' CONSTRUCTOR ARGUMENTS, after the receiver: 'new C( x )' is
    '' '_ZN1CC1Ei( TMP, X )'. Every existing caller passes none, and a structor
    '' with none is the overwhelming majority -- which is why they were not
    '' modelled at all, and 'new C( g )' emitted the call with its argument
    '' simply MISSING.
    dim as long nargs = 1
    if args <> 0 then
        for i as long = 0 to args->Count - 1
            c.m->argPool.Push( (*args)[i] )
        next
        nargs += args->Count \ 2
    end if

    dim as Fbx.InternId nm = c.names->GetString( _
        Fbx.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
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
        decl->paramCount = nargs
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, MT_VOID )
    ins.first = first
    ins.count = nargs
    ins.callee = fidx
    Emit( c, ins )
end sub

sub EmitDtorCall _
    ( byref c as Ctx, byval sym as Fbx.SymbolId, byval slot as long )
    EmitStructorCall( c, sym, slot )
end sub

'' CALL A MEMBER ON A RECEIVER whose address is already in hand, with no call node in
'' the AST to lower from.
''
'' EmitStructorCall does this for constructors and destructors and hard-codes a VOID
'' result; the iterator protocol needs the same thing for functions that return
'' something. Same shape, one more parameter.
'' The same, with ARGUMENTS after the receiver. EmitMemberCall takes none, which is
'' right for the iterator protocol it was written for and wrong for 'operator []'.
function EmitMemberCallArgs_ _
    ( byref c as Ctx, byval sym as Fbx.SymbolId, byref self_ as MirValue, _
      byval rt as MirType, byval args as FB.Array( of ulong ) ptr ) as MirValue

    dim as MirValue none_
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return none_
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
    if pn = Fbx.NODE_NONE then return none_
    if c.ast->Kind( pn ) <> Fbx.N_PROC then return none_
    if self_.kind = cast( ubyte, MV_NONE ) then return none_

    dim as long first = c.m->argPool.Count \ 2
    c.m->argPool.Push( cast( ulong, self_.kind ) )
    c.m->argPool.Push( cast( ulong, self_.id ) )
    dim as long nargs = 1
    if args <> 0 then
        for i as long = 0 to args->Count - 1
            c.m->argPool.Push( (*args)[i] )
        next
        nargs += args->Count \ 2
    end if

    dim as Fbx.InternId nm = c.names->GetString( _
        Fbx.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, rt )
        decl->isDefinition = false
        decl->paramCount = nargs
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, rt )
    ins.first = first
    ins.count = nargs
    ins.callee = fidx
    return Emit( c, ins )
end function

function EmitMemberCall _
    ( byref c as Ctx, byval sym as Fbx.SymbolId, byref self_ as MirValue, _
      byval rt as MirType ) as MirValue

    dim as MirValue none_
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return none_
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
    if pn = Fbx.NODE_NONE then return none_
    if c.ast->Kind( pn ) <> Fbx.N_PROC then return none_
    if self_.kind = cast( ubyte, MV_NONE ) then return none_

    dim as long first = c.m->argPool.Count \ 2
    c.m->argPool.Push( cast( ulong, self_.kind ) )
    c.m->argPool.Push( cast( ulong, self_.id ) )

    dim as Fbx.InternId nm = c.names->GetString( _
        Fbx.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, rt )
        decl->isDefinition = false
        decl->paramCount = 1
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, rt )
    ins.first = first
    ins.count = 1
    ins.callee = fidx
    return Emit( c, ins )
end function

'' The paren-less STATEMENT form: 'W 1, 2'. The callee is the statement's own 'a' and
'' the arguments are its children, so nothing about it looks like a call node -- which
'' is why it was 19,629 declines, nearly a third of everything left, while reading as
'' ordinary FreeBASIC.
function LowerStmtCall _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue

    dim as MirValue v
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->a = Fbx.NODE_NONE then return v
    return LowerCallParts( c, sp->a, c.info->RefOf( sp->a ), _
                           sp->first, sp->count, MT_VOID )
end function

'' The implicit THIS for a call through 'obj.M( )' or 'p->M( )', or MV_NONE when the
'' callee is not an instance method.
''
'' 'obj.M' passes the receiver's ADDRESS; 'p->M' passes the pointer itself, which is
'' already an address. A STATIC member takes no receiver, and neither does anything
'' declared outside a type.
function ReceiverOf _
    ( byref c as Ctx, byval target as Fbx.NodeId, _
      byval callee as Fbx.SymbolId ) as MirValue

    dim as MirValue v
    if target = Fbx.NODE_NONE then return v

    dim as Fbx.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return v
    dim as Fbx.SymScope ptr owner = c.syms->ScopeAt( cs->parent )
    if owner = 0 then return v
    if owner->kind <> cast( ubyte, Fbx.SCOPEK_TYPE ) then return v
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, cs->payload )
    if (pn <> Fbx.NODE_NONE) andalso (c.ast->Kind( pn ) = Fbx.N_PROC) then
        if (StmtOf( c, pn )->extra and Fbx.PF_STATIC) <> 0 then return v
    end if

    '' An UNQUALIFIED call to a sibling member -- 'M( )' inside another method of the
    '' same type -- has no base written, and its receiver is the enclosing method's own
    '' THIS. Without this it lowered to 'call void _ZN1T1MEv()': a member call with no
    '' member, and no decline to say so.
    if c.ast->Kind( target ) <> Fbx.N_MEMBER then
        if c.curProcSym = Fbx.SYMBOL_NONE then return v
        dim as Fbx.Symbol ptr me = c.syms->SymbolAt( c.curProcSym )
        if me = 0 then return v
        if me->inner = Fbx.SCOPE_NONE then return v
        dim as Fbx.SymbolId tsid = c.syms->LookupLocal( me->inner, _
            c.names->Fold( c.names->GetString( "this" ) ) )
        if tsid = Fbx.SYMBOL_NONE then return v
        '' THIS holds a pointer, so the receiver is its VALUE. Passing the slot's own
        '' address would hand the callee a pointer to a pointer.
        dim as MirValue ta = AddrOfVar( c, tsid )
        if ta.kind = cast( ubyte, MV_NONE ) then return v
        return LowerExprLoad( c, ta, MT_PTR )
    end if

    '' Decided by the base's TYPE, not by whether '->' was written: FreeBASIC accepts a
    '' dot on a pointer too, and '(*p).M( )' is a value whose address is the pointer.
    '' A pointer base is ALREADY an address; anything else needs one taking.
    dim as Fbx.BinaryPayload ptr mb = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, target )].data )]
    dim as Fbx.TypeId bt = c.info->TypeOf_( mb->lhs )
    if bt <> Fbx.TYPE_NONE then
        if c.types->Kind( bt ) = Fbx.TK_POINTER then return LowerExpr( c, mb->lhs )
    end if
    return LowerAddr( c, mb->lhs )
end function

'' A DIM SHARED or STATIC initialiser, which is a compile-time value rather than a store
'' on entry. A non-constant one cannot become a static one and declines.
sub InitSharedGlobal _
    ( byref c as Ctx, byval sid as Fbx.SymbolId, byval init as Fbx.NodeId )

    dim as long g = GlobalFor( c, sid )
    if (g < 0) orelse (init = Fbx.NODE_NONE) then return
    dim as Fbx.Check.ConstVal cv = Fbx.Check.ConstOf( _
        *c.ast, init, *c.srcMgr, *c.names, c.types->target.pointerBits )
    if cv.known = false then
        SkipHere( c )
        return
    end if
    c.m->globals[g].initInt = cv.value
    c.m->globals[g].hasInit = true
end sub

'' IS PARAMETER 'idx' OF 'callee' DECLARED BYREF? The argument is then its ADDRESS,
'' not its value: the callee's slot holds an address and every read goes through it.
''
'' Passing the value instead is what made the byref model incoherent from both ends. It
'' "worked" for a parameter only read and written inside the callee, because both
'' halves agreed about the local copy -- and could never propagate an out-parameter,
'' which is the entire point of byref.
function ParamIsByref _
    ( byref c as Ctx, byval callee as Fbx.SymbolId, byval idx as long ) as boolean

    dim as Fbx.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, cs->payload )
    if pn = Fbx.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Fbx.N_PROC then return false
    dim as Fbx.StmtPayload ptr psp = StmtOf( c, pn )
    if idx >= psp->count then return false
    dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[psp->first + idx] )
    if c.ast->Kind( prm ) <> Fbx.N_PARAM then return false
    return ((c.ast->nodes[cast( long, prm )].flags and Fbx.NF_BYREF) <> 0)
end function

function AddrOfVar( byref c as Ctx, byval sid as Fbx.SymbolId ) as MirValue
    dim as MirValue v

    '' A CONSTANT HAS NO ADDRESS. 'const PI = 3.5' emits no variable, so asking for one
    '' invented a slot and loaded it uninitialised -- 'd = PI' stored garbage, silently
    '' and without declining. Constants fold in LowerPredeclared; one that will not fold
    '' has to decline here rather than be given storage it never had.
    dim as Fbx.Symbol ptr cs = c.syms->SymbolAt( sid )
    if cs <> 0 then
        if cs->kind = cast( ubyte, Fbx.SYM_CONSTANT ) then return v
        '' A REFERENCE has no storage of its own -- it aliases something else, through
        '' an indirection that is not implemented. Its DECLARATION already declines;
        '' without this every USE still resolved to a slot aliasing nothing, so
        '' 'rb = 5 : print a' gave 1 where fbc gives 5.
        if (cs->flags and Fbx.SYMF_BYREF) <> 0 then return v
        '' A PROCEDURE HAS NO STORAGE EITHER. '@mysub' fell through to LocalFor, which
        '' minted a FRAME SLOT named after the procedure -- so 'p = @mysub' stored the
        '' address of a fresh stack slot and 'p()' called into stack garbage:
        ''
        ''     local void mysub          <-- a stack slot for a PROCEDURE
        ''     %5 = alloca ptr mysub
        ''     store @p, @mysub
        ''     call.ind void %6()
        ''
        '' The VERIFIER WAVES THAT THROUGH, because the destination is a well-typed
        '' pointer -- it is the source that is nonsense. Every '@proc' and every
        '' procptr assignment in the corpus was miscompiled this way.
        ''
        '' A procedure's address is an M_FUNC_ADDR over the function table, which
        '' FuncAddrOf already builds for procptr; this is the same thing reached by
        '' the other spelling.
        if cs->kind = cast( ubyte, Fbx.SYM_PROC ) then return FuncAddrOf( c, sid )
    end if
    dim as boolean inModule = IsSharedVar( c, sid )
    if IsStaticLocal( c, sid ) then inModule = true
    if inModule then
        dim as long g = GlobalFor( c, sid )
        if g < 0 then return v
        v.kind = cast( ubyte, MV_GLOBAL )
        v.ty = cast( ubyte, MT_PTR )
        v.id = g
        return v
    end if
    dim as long lslot = LocalFor( c, sid )
    if lslot < 0 then return v
    v.kind = cast( ubyte, MV_LOCAL )
    v.ty = cast( ubyte, MT_PTR )
    v.id = lslot

    '' A BYREF PARAMETER'S SLOT HOLDS AN ADDRESS, NOT THE VALUE. Its address as a
    '' variable is therefore what the slot CONTAINS, not where the slot is -- one load,
    '' here, and every read, every write and every '@' of the parameter is right,
    '' because all of them go through this function.
    ''
    '' Without it the model was incoherent in three of its four halves: a read of the
    '' parameter yielded the ADDRESS, a write CLOBBERED the address, and only the
    '' declared slot type said 'reference' at all. It verified, because a store of a
    '' pointer into a ptr slot is well-typed; it just meant something else.
    ''
    '' Measured cost of the incoherence: 21,806 of the corpus's unlowered statements
    '' were one macro -- fbcunit's CU_ASSERT_ -- called with a BYREF argument, and the
    '' identical call with a byval one lowered.
    if cs <> 0 then
        if cs->type_ <> Fbx.TYPE_NONE then
            if c.types->Kind( cs->type_ ) = Fbx.TK_REFERENCE then
                return LowerExprLoad( c, v, MT_PTR )
            end if

            '' A BYDESC ARRAY PARAMETER'S SLOT HOLDS THE DESCRIPTOR'S ADDRESS, exactly
            '' as a byref parameter's holds its referent's -- fbc's own signature says
            '' so: 'void P( struct $7FBARRAYI1RE* ROWS$1 )'. One load, here, and
            '' indexing, REDIM and ERASE are all right at once, because every one of
            '' them asks this function for the descriptor.
            ''
            '' Without it the slot was a 72-byte descriptor BY VALUE with the incoming
            '' pointer stored over its first field -- so 'a( 0 ) = 1' loaded the
            '' descriptor's own address where the DATA pointer belongs and wrote through
            '' it, corrupting the descriptor. It lowered and it verified.
            if cs->kind = cast( ubyte, Fbx.SYM_PARAMETER ) then
                if c.types->IsDynArray( cs->type_ ) then
                    return LowerExprLoad( c, v, MT_PTR )
                end if
            end if
        end if
    end if
    return v
end function

end namespace
