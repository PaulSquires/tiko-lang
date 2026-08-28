'' lowerstore.bas -- where a variable's storage lives.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The subject is
'' one question -- frame slot or module storage -- and getting it wrong is not a
'' performance matter: a DIM SHARED that lands in a frame gives every procedure its own
'' private copy, and assignments to it are silently invisible to everyone else.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

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
function SizeOfType( byref c as Ctx, byval t as Tko.TypeId ) as long
    if t = Tko.TYPE_NONE then return 0
    dim as long ui = c.udts->Find( t )
    if ui >= 0 then return c.udts->udts[ui].size
    if c.types->Kind( t ) = Tko.TK_ARRAY then
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
    ( byref c as Ctx, byval sid as Tko.SymbolId ) as long

    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
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
    dim as boolean indirectUdtParam = false
    l.frontendType = s->type_
    l.ty = cast( ubyte, LowerType( s->type_, *c.types ) )
    '' A BYDESC ARRAY PARAMETER'S SLOT HOLDS A POINTER, not a descriptor. fbc's own
    '' signature says so -- 'void P( struct $7FBARRAYI1RE* ROWS$1 )' -- and giving it
    '' the descriptor's own 72 bytes described a local the caller never passed.
    if s->kind = cast( ubyte, Tko.SYM_PARAMETER ) then
        if c.types->IsDynArray( s->type_ ) then
            l.ty = cast( ubyte, MT_PTR )
        end if
        '' AND SO DOES A BYVAL NON-TRIVIAL UDT PARAMETER. fbc passes one as a POINTER
        '' to a copy the CALLER built -- 'void T3( struct $2S1* V$1 )' -- so the slot
        '' holds that address and not the object.
        '' ...and a byval VAR-LENGTH STRING parameter, whose descriptor the caller
        '' builds and owns: 'void TAKEBYVALSTRING( FBSTRING* )'.
        dim as boolean indirectHere = ByvalUdtIndirect_( c, s->type_ )
        indirectHere = indirectHere orelse ByvalStrIndirect_( c, s->type_ )
        if indirectHere then
            l.ty = cast( ubyte, MT_PTR )
            indirectUdtParam = true
        end if
    end if
    '' An aggregate slot needs its SIZE: 'agg' says nothing about how many bytes to
    '' reserve, and the layout pass is the only thing that knows.
    l.size = SizeOfType( c, s->type_ )
    '' ...and the slot is then a POINTER'S worth of storage, not the object's.
    if indirectUdtParam then l.size = c.types->target.pointerBits \ 8
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
function IsSharedVar( byref c as Ctx, byval sid as Tko.SymbolId ) as boolean
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    return ((s->flags and Tko.SYMF_SHARED) <> 0)
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
function IsStaticLocal( byref c as Ctx, byval sid as Tko.SymbolId ) as boolean
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if (s->flags and Tko.SYMF_SHARED) <> 0 then return false
    return ((s->flags and Tko.SYMF_STATIC) <> 0)
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
private function StaticName( byref c as Ctx, byval sid as Tko.SymbolId ) as Tko.InternId
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
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
    ( byref c as Ctx, byval nm as Tko.InternId ) as Tko.InternId

function GlobalFor( byref c as Ctx, byval sid as Tko.SymbolId ) as long
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return -1

    '' Keyed by SYMBOL, not by spelling. Two statics called 'n' in sibling scopes of one
    '' procedure are two declarations and therefore two symbols; keying on the name
    '' merged them into a single variable that both scopes incremented.
    for i as long = 0 to c.gvarSym.Count - 1
        if c.gvarSym[i] = cast( ulong, sid ) then return c.gvarSlot[i]
    next

    dim as Tko.InternId nm = s->name
    if IsStaticLocal( c, sid ) then
        '' A STATIC MEMBER IS NOT A STATIC LOCAL. 'static x as integer' inside a type
        '' is one object for the whole program, named after the TYPE -- measured,
        '' '_ZN1T8COUNTER$E' -- while a static LOCAL is named per procedure. Naming a
        '' member the local way gave it whichever member function first touched it,
        '' so two translation units would not agree on the symbol.
        dim as Tko.SymScope ptr ps = c.syms->ScopeAt( s->parent )
        dim as boolean memberStatic = false
        if ps <> 0 then memberStatic = (ps->kind = cast( ubyte, Tko.SCOPEK_TYPE ))
        if memberStatic then
            dim as string smn = Tko.Mangle.StaticMemberName( _
                *c.syms, s->parent, *c.names, c.names->Spelling( s->name ) )
            if len( smn ) > 0 then
                nm = c.names->GetString( smn )
            else
                nm = StaticName( c, sid )
            end if
        else
            nm = StaticName( c, sid )
        end if
    end if
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
    ( byref c as Ctx, byval nm as Tko.InternId ) as Tko.InternId

    dim as boolean taken = false
    for i as long = 0 to c.m->globals.Count - 1
        if c.m->globals[i].isVar andalso (c.m->globals[i].name = nm) then taken = true
    next
    if taken = false then return nm

    dim as string base_ = c.names->Spelling( nm )
    for n as long = 2 to 1000
        dim as Tko.InternId cand = c.names->GetString( base_ & "$" & str( n ) )
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
'' Pick the constructor overload for a set of argument types, using the same cost
'' model overload resolution uses -- the one fitted to 1,274 measured fbc choices.
'' Constructors chain like any other overload set precisely because they were given a
'' synthetic name, so nothing here is special-cased.
function PickCtor _
    ( byref c as Ctx, byval first_ as Tko.SymbolId, _
      byref argT as FB.Array( of ulong ) ) as Tko.SymbolId

    dim as Tko.SymbolId best = Tko.SYMBOL_NONE
    dim as long bestCost = Tko.Check.CONV_NONE
    dim as long ties = 0
    dim as Tko.SymbolId cur = first_

    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
            dim as long np = 0
            for i as long = 0 to pp->count - 1
                dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) = Tko.N_PARAM then np += 1
            next
            '' A CONSTRUCTOR WITH DEFAULTED TRAILING PARAMETERS IS VIABLE FOR THE
            '' SHORTER CALL. 'constructor( byval c as long, byval os as long = 0 )'
            '' answers 'A( 5 )' -- measured, fbc emits '_ZN1AC1Eii( &A1, 5, 0 )'
            '' for it -- and an exact-arity test alone found no constructor at
            '' all, so 'dim as A a1 = A( 5 )' fell to default-construct-then-copy:
            '' the DEFAULT constructor ran over a1 and a temporary's bytes were
            '' written on top of it. Two constructors on one object where fbc
            '' runs one.
            dim as boolean arityOk = (np = argT.Count)
            if (arityOk = false) andalso (np > argT.Count) then
                arityOk = true
                dim as long sd = 0
                for i as long = 0 to pp->count - 1
                    dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                    if sd >= argT.Count then
                        if StmtOf( c, prm )->b = Tko.NODE_NONE then
                            arityOk = false
                            exit for
                        end if
                    end if
                    sd += 1
                next
            end if
            if arityOk then
                dim as long total = 0
                dim as long ai = 0
                dim as boolean viable = true
                for i as long = 0 to pp->count - 1
                    dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                    '' The defaulted tail costs nothing: there is no argument to convert.
                    if ai >= argT.Count then exit for
                    dim as Tko.StmtPayload ptr sp2 = StmtOf( c, prm )
                    '' AN ARRAY PARAMETER IS MATCHED BY ITS ELEMENT TYPE. Its declared
                    '' type IS the element -- the array-ness is the parameter node's
                    '' flag -- so 'constructor T( array( ) as integer )' was costed as
                    '' though it took one INTEGER, the whole array argument was
                    '' unconvertible, and 'dim x as T = a( )' found no constructor at
                    '' all. structs/udt-array-ops-1.bas is 24 statements of it.
                    dim as Tko.TypeId at2 = cast( Tko.TypeId, argT[ai] )
                    dim as Tko.TypeId pt2 = c.info->TypeOf_( sp2->a )
                    dim as long cost = 0
                    if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_ARRAY) <> 0 then
                        dim as Tko.TypeId ae = at2
                        if ae <> Tko.TYPE_NONE then
                            if c.types->Kind( ae ) = Tko.TK_ARRAY then
                                ae = c.types->Inner( ae )
                            end if
                        end if
                        cost = Tko.Check.ConversionCost( ae, pt2, *c.types )
                    else
                        cost = Tko.Check.ConversionCost( at2, pt2, *c.types )
                    end if
                    ai += 1
                    if cost >= Tko.Check.CONV_NONE then
                        viable = false
                        exit for
                    end if
                    total += cost
                next
                if viable then
                    if total < bestCost then
                        bestCost = total
                        best = cur
                        ties = 0
                    elseif total = bestCost then
                        ties += 1
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend

    '' A tie is an ambiguous call, not a silent pick.
    if ties > 0 then return Tko.SYMBOL_NONE
    return best
end function

function StructorOf _
    ( byref c as Ctx, byval t as Tko.TypeId, byref which as string ) as Tko.SymbolId

    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    if c.types->Kind( t ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( t ) )
    '' The UDT, so the TYPE-name class.
    dim as Tko.SymbolId ts = c.syms->LookupTyped( ds, tn, true )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Tko.SYMBOL_NONE
    if s->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    return c.syms->LookupLocal( s->inner, _
        c.names->Fold( c.names->GetString( which ) ) )
end function

'' The overload in a chain that takes exactly 'want' parameters. A default
'' constructor and a destructor are the zero-parameter ones -- taking the head of the
'' chain instead picked whichever overload happened to be first.
function StructorWithArity _
    ( byref c as Ctx, byval first_ as Tko.SymbolId, byval want as long ) as Tko.SymbolId

    dim as Tko.SymbolId defaulted = Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur = first_
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
            dim as long np = 0
            for i as long = 0 to pp->count - 1
                dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) = Tko.N_PARAM then np += 1
            next
            if np = want then return cur
            '' ...OR TAKES MORE, WITH A DEFAULT FOR EVERY ONE PAST 'want'. An exact
            '' match is preferred, so this is only remembered and returned if the
            '' walk finds nothing better.
            ''
            '' 'declare constructor( byval c as long, byval os as long = 0 )'
            '' called as 'A( 5 )' found NO constructor at all and the declaration
            '' declined -- while the same defaults on an ordinary SUB worked, which
            '' is why this looked like a UDT problem. fbc fills the default at the
            '' call: measured, '_ZN1EC1EiR8FBSTRINGi( &A$0, 1, &TMP, 0 )'.
            if (np > want) andalso (defaulted = Tko.SYMBOL_NONE) then
                dim as long seen = 0
                dim as boolean allDef = true
                for i as long = 0 to pp->count - 1
                    dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                    if seen >= want then
                        if StmtOf( c, prm )->b = Tko.NODE_NONE then allDef = false
                    end if
                    seen += 1
                next
                if allDef then defaulted = cur
            end if
        end if
        cur = s->nextOverload
    wend
    return defaulted
end function

'' A call to a structor with the slot's address as the implicit THIS. The receiver is
'' the first argument, per the ABI, which is also how the mangled name reads.
sub EmitStructorCall _
    ( byref c as Ctx, byval sym as Tko.SymbolId, byval slot as long, _
      byval selfVal as MirValue ptr = 0, byval args as FB.Array( of ulong ) ptr = 0 )

    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return
    if c.ast->Kind( pn ) <> Tko.N_PROC then return

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
    ( byref c as Ctx, byval sym as Tko.SymbolId, byval slot as long )
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
'' A DIRECT CALL to a known procedure with a ready argument list -- no receiver, no
'' overload work. What a user-defined GLOBAL operator needs: Check chose the symbol and
'' the caller has already produced the operands the way the parameters want them.
function EmitDirectCall_ _
    ( byref c as Ctx, byval sym as Tko.SymbolId, byval rt as MirType, _
      byref args as FB.Array( of ulong ) ) as MirValue

    dim as MirValue none_
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return none_
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return none_
    if c.ast->Kind( pn ) <> Tko.N_PROC then return none_

    dim as long first = c.m->argPool.Count \ 2
    for i as long = 0 to args.Count - 1
        c.m->argPool.Push( args[i] )
    next
    dim as long nargs = args.Count \ 2

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

function EmitMemberCallArgs_ _
    ( byref c as Ctx, byval sym as Tko.SymbolId, byref self_ as MirValue, _
      byval rt as MirType, byval args as FB.Array( of ulong ) ptr ) as MirValue

    dim as MirValue none_
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return none_
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return none_
    if c.ast->Kind( pn ) <> Tko.N_PROC then return none_
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
    ( byref c as Ctx, byval sym as Tko.SymbolId, byref self_ as MirValue, _
      byval rt as MirType ) as MirValue
    return EmitMemberCallArgs_( c, sym, self_, rt, 0 )
end function

'' The paren-less STATEMENT form: 'W 1, 2'. The callee is the statement's own 'a' and
'' the arguments are its children, so nothing about it looks like a call node -- which
'' is why it was 19,629 declines, nearly a third of everything left, while reading as
'' ordinary FreeBASIC.
function LowerStmtCall _
    ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue

    dim as MirValue v
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->a = Tko.NODE_NONE then return v
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
    ( byref c as Ctx, byval target as Tko.NodeId, _
      byval callee as Tko.SymbolId ) as MirValue

    dim as MirValue v
    if target = Tko.NODE_NONE then return v

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return v
    dim as Tko.SymScope ptr owner = c.syms->ScopeAt( cs->parent )
    if owner = 0 then return v
    if owner->kind <> cast( ubyte, Tko.SCOPEK_TYPE ) then return v
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
        if (StmtOf( c, pn )->extra and Tko.PF_STATIC) <> 0 then return v
    end if

    '' An UNQUALIFIED call to a sibling member -- 'M( )' inside another method of the
    '' same type -- has no base written, and its receiver is the enclosing method's own
    '' THIS. Without this it lowered to 'call void _ZN1T1MEv()': a member call with no
    '' member, and no decline to say so.
    if c.ast->Kind( target ) <> Tko.N_MEMBER then
        if c.curProcSym = Tko.SYMBOL_NONE then return v
        dim as Tko.Symbol ptr me = c.syms->SymbolAt( c.curProcSym )
        if me = 0 then return v
        if me->inner = Tko.SCOPE_NONE then return v
        dim as Tko.SymbolId tsid = c.syms->LookupLocal( me->inner, _
            c.names->Fold( c.names->GetString( "this" ) ) )
        if tsid = Tko.SYMBOL_NONE then return v
        '' THIS holds a pointer, so the receiver is its VALUE. Passing the slot's own
        '' address would hand the callee a pointer to a pointer.
        dim as MirValue ta = AddrOfVar( c, tsid )
        if ta.kind = cast( ubyte, MV_NONE ) then return v
        return LowerExprLoad( c, ta, MT_PTR )
    end if

    '' Decided by the base's TYPE, not by whether '->' was written: FreeBASIC accepts a
    '' dot on a pointer too, and '(*p).M( )' is a value whose address is the pointer.
    '' A pointer base is ALREADY an address; anything else needs one taking.
    dim as Tko.BinaryPayload ptr mb = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, target )].data )]
    dim as Tko.TypeId bt = c.info->TypeOf_( mb->lhs )
    if bt <> Tko.TYPE_NONE then
        if c.types->Kind( bt ) = Tko.TK_POINTER then return LowerExpr( c, mb->lhs )
    end if

    '' 'p->M( )' OVER A UDT: the receiver is what that UDT's 'operator ->' hands back,
    '' not the handle itself. Measured -- fbc emits 'vr = _ZptR6HOLDER( &H )' and then
    '' '_ZN5INNER4BUMPEi( vr, 3 )'. Check resolves the method in the arrow's result
    '' type, so the CALLEE was already right; the receiver was the HANDLE, so every
    '' method called through a smart pointer ran against the wrong object. It lowered,
    '' it verified, and the mangled name said the method was found.
    dim as Tko.TypeId ubt = c.types->Unqualify( bt )
    if ((c.ast->nodes[cast( long, target )].flags and Tko.NF_ARROW) <> 0) andalso _
       (c.types->Kind( ubt ) = Tko.TK_UDT) then
        dim as Tko.SymbolId aop = Tko.Check.ArrowOperatorFor( _
            *c.types, *c.syms, *c.names, *c.ast, *c.info, ubt )
        if aop <> Tko.SYMBOL_NONE then
            dim as MirValue hself = LowerAddr( c, mb->lhs )
            if hself.kind <> cast( ubyte, MV_NONE ) then
                dim as FB.Array( of ulong ) aargs
                aargs.Push( cast( ulong, hself.kind ) )
                aargs.Push( cast( ulong, hself.id ) )
                dim as MirValue av = EmitDirectCall_( c, aop, MT_PTR, aargs )
                if av.kind <> cast( ubyte, MV_NONE ) then return av
            end if
            return v
        end if
    end if
    return LowerAddr( c, mb->lhs )
end function


'' '@x' AS A STATIC INITIALISER: the address of another global, or of a procedure.
''
'' Only what is genuinely fixed at load time is taken. '@localVar' is not -- a local
'' has no address until its frame exists -- and neither is '@this.field'. What is left
'' is a SHARED or STATIC variable, whose global this returns, and a PROCEDURE, which is
'' named rather than indexed because it may live in another module.
''
'' '@array( 2 )' is the array's global plus a byte offset, and the offset is folded
'' here rather than emitted as arithmetic: a relocation is address-plus-constant and
'' nothing else. Only the ZERO-BASED spelling is taken -- 'dim a(1 to 3)' would need
'' its lower bound subtracted, and getting that wrong points the pointer at the wrong
'' element with nothing to say so, so a non-zero lower bound declines instead.
'' A STATIC ARRAY OF POINTERS INITIALISED FROM ADDRESSES -- one relocation per
'' ELEMENT, which is what a pointer TABLE already is here. Measured:
''
''   dim shared a(0 to ...) as const zstring ptr = { @"a1", @"a2" }
''   static as function( as long ) as long f( ... ) = { @bar, @baz }
''
'' are 'static char* A$[2] = { "a1", "a2" }' and
'' 'static tmp$5 F$[2] = { &BAR, &BAZ }' to fbc. A MIR global carries ONE
'' relocation, so neither could be expressed and both declined -- and the byte
'' image the aggregate path builds cannot hold an address at all.
''
'' The WORDS go in the pointer pool a vtable already uses. Nothing else about the
'' global changes: it is still a VAR, still writable, and the words are its initial
'' value rather than a table of their own.
declare sub FlattenInitLeaves_ _
    ( byref c as Ctx, byval init as Tko.NodeId, _
      byref outv as FB.Array( of ulong ) )

private function GlobalPtrArrayInit_ _
    ( byref c as Ctx, byval g as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId ) as boolean

    if init = Tko.NODE_NONE then return false
    if c.ast->Kind( init ) <> Tko.N_INITIALIZER then return false
    dim as Tko.TypeId at = c.types->Unqualify( t )
    if c.types->Kind( at ) <> Tko.TK_ARRAY then return false
    if c.types->IsDynArray( at ) then return false
    dim as Tko.TypeId et = c.types->Unqualify( c.types->Inner( at ) )
    '' POINTER-SIZED ELEMENTS ONLY. A procedure type is already a pointer in
    '' FreeBASIC, so both spellings arrive here.
    if LowerType( et, *c.types ) <> MT_PTR then return false
    dim as long total = c.types->ElemCount( at )
    if total <= 0 then return false

    dim as FB.Array( of ulong ) leaves
    FlattenInitLeaves_( c, init, leaves )
    if cast( long, leaves.Count ) <> total then return false

    '' EVERY WORD MUST BE ONE, or none of them is: a half-filled table would be a
    '' global whose remaining elements are silently zero.
    dim as FB.Array( of long )  kinds
    dim as FB.Array( of ulong ) refs
    for k as long = 0 to total - 1
        dim as Tko.NodeId e = Unparen_( c, cast( Tko.NodeId, leaves[k] ) )
        if c.ast->Kind( e ) = Tko.N_ADDROF then
            dim as Tko.UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, e )].data )]
            dim as Tko.NodeId opnd = Unparen_( c, up->operand )
            '' '@"a1"' IS THE LITERAL'S OWN GLOBAL, which is where a string literal
            '' already lives.
            if c.ast->Kind( opnd ) = Tko.N_STRING_LIT then
                kinds.Push( 1 )
                refs.Push( cast( ulong, c.m->AddStringLiteral( _
                    StringLitText_( c, opnd ), *c.names ) ) )
                continue for
            end if
            if c.ast->Kind( opnd ) <> Tko.N_IDENT then return false
            dim as Tko.SymbolId osid = c.info->RefOf( opnd )
            dim as Tko.Symbol ptr sy = c.syms->SymbolAt( osid )
            if sy = 0 then return false
            if sy->kind = cast( ubyte, Tko.SYM_PROC ) then
                dim as Tko.NodeId pn = cast( Tko.NodeId, sy->payload )
                if pn = Tko.NODE_NONE then return false
                if c.ast->Kind( pn ) <> Tko.N_PROC then return false
                kinds.Push( 2 )
                refs.Push( cast( ulong, c.names->GetString( _
                    Tko.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, _
                                         *c.types, *c.info ) ) ) )
                continue for
            end if
            dim as long og = GlobalFor( c, osid )
            if og < 0 then return false
            kinds.Push( 1 )
            refs.Push( cast( ulong, og ) )
            continue for
        end if
        '' A NULL WORD is the only non-address a pointer table may hold.
        dim as Tko.Check.ConstVal zv = Tko.Check.ConstOf( _
            *c.ast, e, *c.srcMgr, *c.names, c.types->target.pointerBits, c.syms, _
            Tko.SCOPE_GLOBAL )
        if zv.known = false then return false
        if zv.value <> 0 then return false
        kinds.Push( 0 )
        refs.Push( 0 )
    next

    '' Pushed only once every word is known, so a global is never left holding a
    '' partial table.
    c.m->globals[g].ptrFirst = c.m->ptrKinds.Count
    for k as long = 0 to total - 1
        select case kinds[k]
        case 0 : c.m->PushPtrNull( g )
        case 1 : c.m->PushPtrGlobal( g, cast( long, refs[k] ) )
        case else : c.m->PushPtrFunc( g, cast( Tko.InternId, refs[k] ) )
        end select
    next
    c.m->globals[g].hasInit = true
    return true
end function

'' A PROCEDURE NAMED DIRECTLY as a static pointer's initialiser -- what
'' 'procptr( f )' hands over, with no '@' around it.
private function GlobalRelocProc_ _
    ( byref c as Ctx, byval g as long, byval fn as Tko.NodeId ) as boolean

    if fn = Tko.NODE_NONE then return false
    if c.ast->Kind( fn ) <> Tko.N_IDENT then return false
    dim as Tko.Symbol ptr fs = c.syms->SymbolAt( c.info->RefOf( fn ) )
    if fs = 0 then return false
    if fs->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, fs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    c.m->globals[g].initRelocFn = c.names->GetString( _
        Tko.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    c.m->globals[g].hasInit = true
    return true
end function

private function GlobalRelocInit_ _
    ( byref c as Ctx, byval g as long, byval init as Tko.NodeId ) as boolean

    if init = Tko.NODE_NONE then return false
    '' 'procptr( f )' IS '@f', and 'cptr( T, @f )' IS '@f' -- measured, fbc emits
    '' 'static void* F$1 = (void*)&S' for all three spellings. Only the bare '@f'
    '' was recognised, so the other two produced a static pointer with NO
    '' initialiser, which reads NULL. dim/static-const-init.bas writes four.
    dim as long unwrapN = 0
    while unwrapN < 8
        if c.ast->Kind( init ) <> Tko.N_CALL then exit while
        dim as Tko.ListPayload ptr wcp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]
        if wcp->target = Tko.NODE_NONE then exit while
        if c.ast->Kind( wcp->target ) <> Tko.N_IDENT then exit while
        dim as Tko.IdentPayload ptr wip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, wcp->target )].data )]
        dim as string wnm2 = Tko.Text.LowerAscii( c.names->Spelling( wip->name ) )
        if ((wnm2 = "cptr") orelse (wnm2 = "cast")) andalso (wcp->count = 2) then
            init = cast( Tko.NodeId, c.ast->children[wcp->first + 1] )
        elseif (wnm2 = "procptr") andalso (wcp->count = 1) then
            '' 'procptr( f )' names the procedure directly, with no '@' around it,
            '' so the operand IS what the address-of path below wants.
            dim as Tko.NodeId pfn = cast( Tko.NodeId, c.ast->children[wcp->first] )
            return GlobalRelocProc_( c, g, pfn )
        else
            exit while
        end if
        unwrapN += 1
    wend
    if c.ast->Kind( init ) <> Tko.N_ADDROF then return false
    dim as Tko.UnaryPayload ptr up = _
        @c.ast->unaries[cast( long, c.ast->nodes[cast( long, init )].data )]
    dim as Tko.NodeId a = up->operand
    if a = Tko.NODE_NONE then return false

    '' '@array( n )' -- the element's offset from the array's own address.
    dim as longint off = 0
    if c.ast->Kind( a ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr acp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, a )].data )]
        if acp->count <> 1 then return false
        if acp->target = Tko.NODE_NONE then return false
        dim as Tko.TypeId aat = c.info->TypeOf_( acp->target )
        if c.types->Kind( aat ) <> Tko.TK_ARRAY then return false
        if c.types->IsDynArray( aat ) then return false
        if c.types->types[cast( long, aat )].dims <> 1 then return false
        '' DIMENSIONS ARE ZERO-BASED HERE: ArrayBound indexes the bound pool as
        '' 'dim_ * 2', so the first dimension is 0 and asking for 1 walked off the
        '' end of a one-dimensional array's pair and answered 'not known'.
        dim as boolean lbKnown = false
        if c.types->ArrayBound( aat, 0, false, lbKnown ) <> 0 then return false
        if lbKnown = false then return false
        dim as Tko.NodeId ixn = cast( Tko.NodeId, c.ast->children[acp->first] )
        dim as Tko.Check.ConstVal ixv = Tko.Check.ConstOf( _
            *c.ast, ixn, *c.srcMgr, *c.names, c.types->target.pointerBits )
        if ixv.known = false then return false
        dim as Tko.TypeId ael = c.types->Inner( aat )
        dim as long esz = SizeOfType( c, ael )
        if esz <= 0 then return false
        '' THE ARRAY'S OWN LOWER BOUND, so 'dim a(1 to 3)' indexes from its base.
        off = ixv.value * esz
        a = acp->target
    end if

    if c.ast->Kind( a ) <> Tko.N_IDENT then return false
    dim as Tko.SymbolId sid = c.info->RefOf( a )
    if sid = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr sy = c.syms->SymbolAt( sid )
    if sy = 0 then return false

    '' A PROCEDURE'S ADDRESS is its NAME.
    if sy->kind = cast( ubyte, Tko.SYM_PROC ) then
        if off <> 0 then return false
        dim as Tko.NodeId pn = cast( Tko.NodeId, sy->payload )
        if pn = Tko.NODE_NONE then return false
        if c.ast->Kind( pn ) <> Tko.N_PROC then return false
        c.m->globals[g].initRelocFn = c.names->GetString( _
            Tko.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
        c.m->globals[g].hasInit = true
        return true
    end if

    if sy->kind <> cast( ubyte, Tko.SYM_VARIABLE ) then return false
    '' A LOCAL HAS NO ADDRESS UNTIL ITS FRAME EXISTS, so only what actually has
    '' module storage is taken: a SHARED variable, or a STATIC LOCAL -- which is the
    '' same test GlobalFor itself uses to decide it has one.
    dim as boolean isGlobalVar = ((sy->flags and Tko.SYMF_SHARED) <> 0)
    isGlobalVar = isGlobalVar orelse IsStaticLocal( c, sid )
    if isGlobalVar = false then return false

    dim as long tg = GlobalFor( c, sid )
    if tg < 0 then return false
    c.m->globals[g].initReloc = tg
    c.m->globals[g].initRelocOff = off
    c.m->globals[g].hasInit = true
    return true
end function

'' THE SCOPE AN INITIALISER'S NAMES ARE LOOKED UP IN: the DECLARING variable's own.
'' Resolve records no scope against an initialiser's nodes -- ScopeOf comes back 0 for
'' every one of them -- and the declaring scope is what a 'static' inside a procedure
'' needs, where SCOPE_GLOBAL would miss the procedure's own constants.
private function VarScopeOf_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId ) as Tko.ScopeId
    dim as Tko.Symbol ptr vs = c.syms->SymbolAt( sid )
    if vs = 0 then return Tko.SCOPE_GLOBAL
    if vs->parent = Tko.SCOPE_NONE then return Tko.SCOPE_GLOBAL
    return vs->parent
end function

'' A DIM SHARED or STATIC initialiser, which is a compile-time value rather than a store
'' on entry. A non-constant one cannot become a static one and declines.
sub InitSharedGlobal _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval init as Tko.NodeId )

    dim as long g = GlobalFor( c, sid )

    '' A MODULE-LIFETIME OBJECT IS STILL CONSTRUCTED. 'dim shared as T g' over a type
    '' holding a string left the descriptor uninitialised for the whole program, and
    '' the first assignment through it freed whatever was in the image at that address.
    ''
    '' ONLY SHARED. A STATIC local is constructed LAZILY by fbc -- a guard flag and an
    '' atexit thunk, measured -- and putting one in the module initialiser would run it
    '' before the procedure it belongs to was ever called.
    if (g >= 0) andalso IsSharedVar( c, sid ) then
        dim as Tko.Symbol ptr gs = c.syms->SymbolAt( sid )
        if gs <> 0 then
            dim as boolean wants = false
            if c.types->Kind( gs->type_ ) = Tko.TK_UDT then
                wants = TypeNeedsInit_( c, gs->type_ ) orelse TypeNeedsDtor_( c, gs->type_ )
            else
                wants = ArrayElemNeedsInit_( c, gs->type_ ) orelse _
                        ArrayElemNeedsDtor_( c, gs->type_ )
            end if
            if wants then
                dim as boolean already = false
                for i as long = 0 to c.modInitGlobal.Count - 1
                    if c.modInitGlobal[i] = g then already = true
                next
                if already = false then
                    c.modInitGlobal.Push( g )
                    c.modInitType.Push( cast( ulong, gs->type_ ) )
                end if
            end if
        end if
    end if
    if (g < 0) orelse (init = Tko.NODE_NONE) then return

    '' A FLOATING initialiser first, because the integer folder cannot carry one:
    '' ConstVal holds a longint, so 'dim shared as double d = 1.5' had no value at all
    '' and declined. The MIR global has had a float slot all along.
    dim as MirType gt = cast( MirType, c.m->globals[g].ty )
    if (gt = MT_F32) orelse (gt = MT_F64) then
        dim as double fd
        if Tko.Check.ConstFloatOf( *c.ast, init, fd ) then
            c.m->globals[g].initFlt = fd
            c.m->globals[g].hasInit = true
            return
        end if
    end if

    '' AN AGGREGATE IS A BYTE IMAGE, not a number. A static or shared UDT is
    '' initialised WHERE IT IS DEFINED -- fbc emits 'static struct $4GUID G$1 = { ... }'
    '' and no code at all -- so the field values with their offsets are exactly the
    '' bytes of its storage. The integer folder below cannot carry one and every one of
    '' them declined, which is how fb/comptr.bi declares every IID.
    '' A FIXED-LENGTH STRING GLOBAL IS A BYTE IMAGE TOO, and its padding is not the
    '' same in all four flavours. Measured:
    ''
    ''   zstring * 8 = "abc"        char Z$[8] = "abc"
    ''   wstring * 8 = wstr("abc")  uint16 W$[8] = { L'a', L'b', L'c' }
    ''   ustring * 8 = "abc"        uint16 U$[8] = "abc"
    ''   string  * 8 = "abc"        uint8 S$[8] = "abc     "
    ''
    '' -- the three terminated flavours ZERO-fill and 'string * N' SPACE-fills, which
    '' is what makes it the odd one out here as well as in its length tag.
    ''
    '' AND THEY TRUNCATE DIFFERENTLY. Measured at N = 4 with a seven-character source:
    '' 'zstring * 4' keeps "abc" and 'string * 4' keeps "abcd" -- N-1 usable
    '' characters against N, the same capacity difference the length tag records.
    dim as longint fsn
    dim as long fsk = StrSwapKind_( c, c.m->globals[g].frontendType, fsn )
    '' 'wstr( "abc" )' IS A LITERAL TOO where a wide destination is concerned: fbc
    '' folds it to the same '{ L'a', L'b', L'c' }' image a bare literal would give,
    '' and it is how every wide fixed-length global in the corpus is written.
    dim as Tko.NodeId flit = init
    if c.ast->Kind( flit ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr wlp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, flit )].data )]
        if (wlp->count = 1) andalso IsWstrCall_( c, flit ) then
            dim as Tko.NodeId wa = cast( Tko.NodeId, c.ast->children[wlp->first] )
            if c.ast->Kind( wa ) = Tko.N_STRING_LIT then flit = wa
        end if
    end if
    if (fsk >= 1) andalso (fsk <= 4) andalso (c.ast->Kind( flit ) = Tko.N_STRING_LIT) then
        dim as string ftxt = StringLitText_( c, flit )
        '' N, from the type's own element count -- StrSwapKind_ answers the ENCODED
        '' length tag, which is not a count.
        dim as long cap = 0
        dim as Tko.TypeId fst = c.types->Unqualify( c.m->globals[g].frontendType )
        if c.types->Kind( fst ) = Tko.TK_ARRAY then cap = c.types->ElemCount( fst )
        if cap > 0 then
            dim as string fimg
            dim as long usable = iif( fsk = 3, cap, cap - 1 )
            if usable < 0 then usable = 0
            if len( ftxt ) > usable then ftxt = left( ftxt, usable )
            dim as boolean wide = (fsk = 2) orelse (fsk = 4)
            for i as long = 0 to len( ftxt ) - 1
                fimg += chr( ftxt[i] )
                if wide then fimg += chr( 0 )
            next
            dim as ubyte pad = iif( fsk = 3, 32, 0 )
            while len( fimg ) < c.m->globals[g].size
                fimg += chr( pad )
            wend
            if len( fimg ) = c.m->globals[g].size then
                c.m->globals[g].initBytes = fimg
                c.m->globals[g].hasInit = true
                return
            end if
        end if
    end if

    if gt = MT_AGG then
        '' TRIED BEFORE THE BYTE IMAGE: an address is not a byte image, and the
        '' fold below would refuse each word one at a time.
        if GlobalPtrArrayInit_( c, g, c.m->globals[g].frontendType, init ) then
            return
        end if
        dim as string img
        if FoldAggInit_( c, c.m->globals[g].frontendType, init, _
                         c.m->globals[g].size, img ) then
            c.m->globals[g].initBytes = img
            c.m->globals[g].hasInit = true
            return
        end if
        SkipHere( c )
        return
    end if

    '' AN ADDRESS IS NOT A CONSTANT, and it is what a static POINTER is usually given:
    '' 'static pi as integer ptr = @i' and 'static pf as function( ) as integer = @foo'
    '' are RELOCATIONS -- fbc emits 'static int32* PI$1 = (int32*)&I$1;' -- and ConstOf
    '' cannot answer for one, so every such declaration declined. Seven of the thirteen
    '' in functions/return-byref.bas are this shape.
    if GlobalRelocInit_( c, g, init ) then return

    '' WITH THE SYMBOL TABLE, so a NAMED constant folds. Without it an identifier
    '' was simply not constant here, and 'dim shared b as boolean = true' got NO
    '' initialiser at all -- the global then read FALSE, which is not a decline but
    '' a wrong VALUE, and it verified. fbc emits 'static boolean B$ = (boolean)1'.
    '' fbcunit.bas declares three of its own flags that way.
    dim as Tko.Check.ConstVal cv = Tko.Check.ConstOf( _
        *c.ast, init, *c.srcMgr, *c.names, c.types->target.pointerBits, c.syms, _
        VarScopeOf_( c, sid ) )
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
'' The declared TYPE of parameter 'idx', or nothing. Needed beside ParamIsByref
'' because a BYREF STRING parameter takes a DESCRIPTOR, which is not what taking the
'' address of the argument expression gives for a literal.
'' How many parameters the callee declares. A call may write fewer -- every one after
'' the last written must take its DEFAULT, and a call that writes none at all to a
'' procedure with five is still a five-argument call.
'' The result variable's value, or nothing when the procedure has no slot -- a SUB, or
'' a result type the slot does not cover. Callers pass it straight to Terminate, which
'' treats MV_NONE as 'return no value'.
function LoadResult( byref c as Ctx ) as MirValue
    if c.resultSlot < 0 then return NoVal( )
    dim as MirValue addr
    addr.kind = cast( ubyte, MV_LOCAL )
    addr.ty = cast( ubyte, MT_PTR )
    addr.id = c.resultSlot
    return LowerExprLoad( c, addr, cast( MirType, c.resultTy ) )
end function

function LowerExprLoad _
    ( byref c as Ctx, byref addr as MirValue, byval t as MirType ) as MirValue
    dim as MirInst ins
    ins.op = cast( ushort, M_LOAD )
    ins.ty = cast( ubyte, t )
    ins.a = addr
    return Emit( c, ins )
end function

function ParamCountOf( byref c as Ctx, byval callee as Tko.SymbolId ) as long
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return 0
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return 0
    if c.ast->Kind( pn ) <> Tko.N_PROC then return 0
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    dim as long n = 0
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) = Tko.N_PARAM then n += 1
    next
    return n
end function

'' A VARIADIC procedure has no parameter list to run past: what is written is what is
'' passed, and there are no defaults beyond it.
function IsVariadicProc( byref c as Ctx, byval callee as Tko.SymbolId ) as boolean
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    '' The ellipsis is an N_PARAM the parser MARKED with TK_ELLIPSIS in 'op'. It has no
    '' name and no typeref, which is the only other thing that would tell it from an
    '' unnamed parameter -- and relying on an absence is how this was missed the first
    '' time.
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if StmtOf( c, prm )->op = cast( ushort, Tko.TK_ELLIPSIS ) then return true
    next
    return false
end function

'' The DEFAULT VALUE expression of parameter 'idx', or nothing. Parsed onto the
'' N_PARAM as 'b' and, until now, never read.
function ParamDefaultAt _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as Tko.NodeId

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return Tko.NODE_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return Tko.NODE_NONE
    if c.ast->Kind( pn ) <> Tko.N_PROC then return Tko.NODE_NONE
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    dim as long seen = 0
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then return StmtOf( c, prm )->b
        seen += 1
    next
    return Tko.NODE_NONE
end function

function ParamTypeAt _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as Tko.TypeId

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return Tko.TYPE_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( pn ) <> Tko.N_PROC then return Tko.TYPE_NONE
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    dim as long seen = 0
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then return c.info->TypeOf_( StmtOf( c, prm )->a )
        seen += 1
    next
    return Tko.TYPE_NONE
end function

function ParamIsByref _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    '' COUNTING PARAMETERS, not children. An N_PROC's children are not all
    '' N_PARAM -- a BLOCK sits among them -- so indexing straight by 'idx' read
    '' whatever was in that slot and answered NO for a byref parameter whenever
    '' the list did not start at child zero. ParamTypeAt and ParamIsArray beside
    '' this one both walk; this one did not.
    dim as long seen = 0
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then
            return ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
        end if
        seen += 1
    next
    return false
end function

'' Is parameter 'idx' declared as an ARRAY -- 'sub Q( a( ) as long )'? Its TYPE is the
'' ELEMENT's, so the type cannot answer this; the empty subscript is a FLAG on the
'' N_PARAM and that is the only record of it.
function ParamIsArray _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    dim as long seen = 0
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then
            return ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_ARRAY) <> 0)
        end if
        seen += 1
    next
    return false
end function

'' THE DECLARATION OF AN ALIAS: store the referent's ADDRESS into the alias's storage.
''
'' 'dim byref rb as integer = a' is 'int64* RB$0; RB$0 = &A$0;' to fbc. The alias owns
'' nothing -- no construction, no cleanup, no initialiser store -- because the thing it
'' names was declared somewhere else. Everything after this point falls out of the type
'' being a REFERENCE: the slot lowers to a pointer and AddrOfVar loads it, so every
'' read, write and '@' goes through the indirection.
''
'' A SHARED or STATIC alias is module storage holding an address, and fbc initialises it
'' STATICALLY -- 'int64* RG$ = &G$;'. A MIR global carries an integer, a float or a byte
'' image, none of which is a relocation, so the address is stored where the declaration
'' is instead. Same value either way: the referent is module storage too, so its address
'' does not change between passes.
function BindAliasStorage _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval init_ as Tko.NodeId, _
      byval inModule as boolean ) as boolean

    if init_ = Tko.NODE_NONE then return false
    '' THE SLOT HAS TO BE A POINTER, or this stores an address into something that is
    '' not one. Two shapes reach here without a reference type: an alias whose element
    '' type never resolved -- 'dim byref as cva_list r = args', where the slot is VOID
    '' -- and a REDECLARATION already reported as an error, where the first declaration
    '' won and it is a plain integer. Both were verify failures, and both are honest
    '' declines: there is no alias storage to bind.
    dim as Tko.Symbol ptr asym = c.syms->SymbolAt( sid )
    if asym = 0 then return false
    if asym->type_ = Tko.TYPE_NONE then return false
    if c.types->Kind( asym->type_ ) <> Tko.TK_REFERENCE then return false
    dim as MirValue dst
    if inModule then
        dim as long g = GlobalFor( c, sid )
        if g < 0 then return false
        dst.kind = cast( ubyte, MV_GLOBAL )
        dst.ty = cast( ubyte, MT_PTR )
        dst.id = g
    else
        dim as long slot = LocalFor( c, sid )
        if slot < 0 then return false
        dst.kind = cast( ubyte, MV_LOCAL )
        dst.ty = cast( ubyte, MT_PTR )
        dst.id = slot
    end if

    dim as MirValue ra = LowerAddr( c, init_ )
    if ra.kind = cast( ubyte, MV_NONE ) then return false
    StoreThrough( c, dst, Coerce( c, ra, MT_PTR ) )
    return true
end function

function AddrOfVar( byref c as Ctx, byval sid as Tko.SymbolId ) as MirValue
    dim as MirValue v

    '' A CONSTANT HAS NO ADDRESS. 'const PI = 3.5' emits no variable, so asking for one
    '' invented a slot and loaded it uninitialised -- 'd = PI' stored garbage, silently
    '' and without declining. Constants fold in LowerPredeclared; one that will not fold
    '' has to decline here rather than be given storage it never had.
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( sid )
    if cs <> 0 then
        if cs->kind = cast( ubyte, Tko.SYM_CONSTANT ) then return v
        '' A REFERENCE DOES have storage now -- a slot holding the address it aliases,
        '' the same shape a byref parameter has -- and the load that turns that slot
        '' into the referent's address is at the end of this function, where every
        '' read, write and '@' goes through it.
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
        if cs->kind = cast( ubyte, Tko.SYM_PROC ) then return FuncAddrOf( c, sid )
    end if
    dim as boolean inModule = IsSharedVar( c, sid )
    if IsStaticLocal( c, sid ) then inModule = true
    if inModule then
        dim as long g = GlobalFor( c, sid )
        if g < 0 then return v
        v.kind = cast( ubyte, MV_GLOBAL )
        v.ty = cast( ubyte, MT_PTR )
        v.id = g
        '' A SHARED OR STATIC ALIAS holds an address like any other reference, and the
        '' load belongs here too -- this path returns before the one at the end of the
        '' function. Without it 'sb = 3' stored an i64 into a pointer slot, which the
        '' verifier caught: the store was clobbering the alias rather than the referent.
        if cs <> 0 then
            if cs->type_ <> Tko.TYPE_NONE then
                if c.types->Kind( cs->type_ ) = Tko.TK_REFERENCE then
                    return LowerExprLoad( c, v, MT_PTR )
                end if
            end if
        end if
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
        if cs->type_ <> Tko.TYPE_NONE then
            if c.types->Kind( cs->type_ ) = Tko.TK_REFERENCE then
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
            if cs->kind = cast( ubyte, Tko.SYM_PARAMETER ) then
                if c.types->IsDynArray( cs->type_ ) then
                    return LowerExprLoad( c, v, MT_PTR )
                end if
                '' A BYVAL NON-TRIVIAL UDT PARAMETER'S SLOT HOLDS AN ADDRESS TOO --
                '' the caller built the copy and passed a pointer to it -- so every
                '' read, write and '@' of the parameter goes through this one load.
                dim as boolean indirectP = ByvalUdtIndirect_( c, cs->type_ )
                indirectP = indirectP orelse ByvalStrIndirect_( c, cs->type_ )
                if indirectP then
                    return LowerExprLoad( c, v, MT_PTR )
                end if
            end if
        end if
    end if
    return v
end function

end namespace
