'' lowerproc.bas -- the two PROCEDURE lowerings: a user SUB/FUNCTION, and the
'' implicit main that module-level code goes into.
''
'' Split out of lower.bas when the result slot pushed that file past the 1,500-line
'' limit. They belong together: both build a MirFunction from nothing, both open the
'' entry block, and both own a zero-initialised result slot -- main's IS the process
'' exit code, and a function's is what 'function = expr' writes to.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' ------------------------------------------------------------------ the walk

sub LowerProc _
    ( byref c as Ctx, byval id as Fbx.NodeId )

    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->b = Fbx.NODE_NONE then return       '' a declaration, not a definition

    dim as Fbx.SymbolId sid = c.info->RefOf( id )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    dim as Fbx.TypeId rt = iif( s <> 0, s->type_, Fbx.TYPE_NONE )

    '' MIR carries the MANGLED name and never a source one.
    dim as Fbx.InternId nm = c.names->GetString( _
        Fbx.Mangle.ProcName( *c.ast, id, *c.syms, *c.names, *c.types, *c.info ) )

    '' A STRING-RETURNING FUNCTION RETURNS A POINTER. fbc's own C says so --
    '' 'FBSTRING* F( void )' -- because the value leaves through
    '' fb_StrAllocTempResult, not as the descriptor itself. Declaring it 'agg' would
    '' put a type on the function that its own 'ret' contradicts.
    dim as MirType declRet = LowerType( rt, *c.types )
    if rt <> Fbx.TYPE_NONE then
        if IsStringType( c, rt ) then declRet = MT_PTR
    end if
    dim as MirFunction ptr f = c.m->AddFunction( nm, declRet )
    f->isDefinition = true
    dim as MirFunction ptr savedF = c.f
    dim as long savedB = c.curBlock
    dim as Fbx.SymbolId savedSym = c.curProcSym
    c.f = f
    c.curProcSym = sid
    c.st->functions += 1

    '' An instance method takes THIS as parameter ZERO. It is never written in the
    '' source, so nothing else would count it -- and without it '@this' named a fresh
    '' uninitialised local while every CALL site dutifully passed a receiver into
    '' nothing.
    dim as Fbx.SymbolId thisSym = Fbx.SYMBOL_NONE
    if s <> 0 then
        if s->inner <> Fbx.SCOPE_NONE then
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
    if thisSym <> Fbx.SYMBOL_NONE then
        '' A CONSTRUCTOR, DESTRUCTOR, OPERATOR or PROPERTY is a member by construction
        '' and always has one. 'constructor ns.UDT( )' is qualified by a NAMESPACE and
        '' owned by a TYPE, so nothing about the qualifier decides it -- testing the
        '' enclosing scope's parent got that wrong and silently emptied ten corpus
        '' files' worth of constructors.
        dim as boolean isStructor = false
        select case cast( Fbx.TokenKind, sp->op )
        case Fbx.KW_CONSTRUCTOR, Fbx.KW_DESTRUCTOR, Fbx.KW_OPERATOR, Fbx.KW_PROPERTY
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
            dim as Fbx.Symbol ptr ts = c.syms->SymbolAt( thisSym )
            dim as boolean inType = false
            if ts <> 0 then
                dim as Fbx.ScopeId walk = ts->parent
                dim as long guard = 0
                while (walk <> Fbx.SCOPE_NONE) andalso (guard < 64)
                    dim as Fbx.SymScope ptr sc2 = c.syms->ScopeAt( walk )
                    if sc2 = 0 then exit while
                    if sc2->kind = cast( ubyte, Fbx.SCOPEK_TYPE ) then
                        inType = true
                        exit while
                    end if
                    walk = sc2->parent
                    guard += 1
                wend
            end if
            if inType = false then thisSym = Fbx.SYMBOL_NONE
        end if
    end if
    if thisSym <> Fbx.SYMBOL_NONE then f->paramCount += 1

    for i as long = 0 to sp->count - 1
        if c.ast->Kind( cast( Fbx.NodeId, c.ast->children[sp->first + i] ) ) = Fbx.N_PARAM then
            f->paramCount += 1
        end if
    next

    c.curBlock = NewBlock( c, "entry" )

    '' The result slot, zero-initialised, exactly as fbc's C does it. Only for a
    '' SCALAR result: a STRING or UDT return goes through a hidden pointer fbx does
    '' not model yet, and inventing a slot for one would miscompile silently rather
    '' than decline -- which is the failure mode this file has hit four times.
    dim as long savedRes = c.resultSlot
    dim as ubyte savedResTy = c.resultTy
    dim as Fbx.TypeId savedResType = c.resultType
    c.resultSlot = -1
    c.resultTy = cast( ubyte, MT_VOID )
    c.resultType = Fbx.TYPE_NONE

    dim as MirType rmt = LowerType( rt, *c.types )
    dim as boolean scalarResult = (rt <> Fbx.TYPE_NONE) andalso (rmt <> MT_VOID) andalso _
                                  (rmt <> MT_AGG)

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
    if (rt <> Fbx.TYPE_NONE) andalso (scalarResult = false) then
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
    dim as long pidx = 0
    if thisSym <> Fbx.SYMBOL_NONE then
        '' THIS is a POINTER TO the object -- the symbol carries that type, so the slot
        '' comes out a pointer and 'this.field' reaches through it like any other
        '' pointer base. It is what fbc's own C says: 'struct $1T* THIS$1'.
        dim as long tslot = LocalFor( c, thisSym )
        if tslot < 0 then tslot = 0
        dim as MirValue taddr
        taddr.kind = cast( ubyte, MV_LOCAL )
        taddr.ty = cast( ubyte, MT_PTR )
        taddr.id = tslot
        dim as MirValue tpv
        tpv.kind = cast( ubyte, MV_PARAM )
        tpv.ty = cast( ubyte, MT_PTR )
        tpv.id = 0
        dim as MirInst tins
        tins.op = cast( ushort, M_STORE )
        tins.ty = cast( ubyte, MT_VOID )
        tins.a = taddr
        tins.b = tpv
        Emit( c, tins )
        pidx = 1
    end if
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> Fbx.N_PARAM then continue for
        dim as Fbx.StmtPayload ptr pp = StmtOf( c, prm )
        dim as Fbx.SymbolId psid = _
            c.syms->LookupLocalTyped( c.info->ScopeOf( id ), pp->name, false )
        if psid <> Fbx.SYMBOL_NONE then
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

    dim as long scopeDepthIn = c.scopeMark.Count
    PushScope( c )
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
    if (c.resultSlot >= 0) andalso (c.resultTy = cast( ubyte, MT_AGG )) then
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
declare function ModuleHasCode( byref c as Ctx, byval id as Fbx.NodeId ) as boolean

sub LowerMainModule( byref c as Ctx, byval root as Fbx.NodeId )
    if root = Fbx.NODE_NONE then return
    if c.ast->Kind( root ) <> Fbx.N_MODULE then return

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
    dim as Fbx.ListPayload ptr mp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, root )].data )]
    for i as long = 0 to mp->count - 1
        ScanLabels( c, cast( Fbx.NodeId, c.ast->children[mp->first + i] ), _
                    scopeDepthIn + 1 )
    next
    for i as long = 0 to mp->count - 1
        LowerStmt( c, cast( Fbx.NodeId, c.ast->children[mp->first + i] ) )
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
function ModuleHasCode( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    if id = Fbx.NODE_NONE then return false
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    for i as long = 0 to lp->count - 1
        select case c.ast->Kind( cast( Fbx.NodeId, c.ast->children[lp->first + i] ) )
        case Fbx.N_PROC, Fbx.N_TYPE, Fbx.N_ENUM, Fbx.N_TYPEDEF, Fbx.N_NAMESPACE, _
             Fbx.N_EXTERN_BLOCK, Fbx.N_CONST, Fbx.N_FIELD, Fbx.N_PARAM
            '' A declaration; it does not put anything in main.
        case else
            return true
        end select
    next
    return false
end function

private sub WalkTop( byref c as Ctx, byval id as Fbx.NodeId )
    if id = Fbx.NODE_NONE then return
    select case c.ast->Kind( id )
    case Fbx.N_MODULE, Fbx.N_BLOCK
        dim as Fbx.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            WalkTop( c, cast( Fbx.NodeId, c.ast->children[lp->first + i] ) )
        next
    case Fbx.N_NAMESPACE, Fbx.N_EXTERN_BLOCK
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        for i as long = 0 to sp->count - 1
            WalkTop( c, cast( Fbx.NodeId, c.ast->children[sp->first + i] ) )
        next
    case Fbx.N_PROC
        LowerProc( c, id )
    end select
end sub

function Lower _
    ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref types as Fbx.TypeContext, _
      byref names as Fbx.Interner, byref info as Fbx.SemanticInfo, _
      byref src as Fbx.SourceManager, byref udts as Fbx.UdtLayouts, _
      byref m as MirModule, byref st as LowerStats ) as long

    dim as Ctx c
    c.srcMgr = @src
    c.udts = @udts
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
    LowerMainModule( c, root )
    return st.functions
end function

'' 'return expr' out of a STRING-RETURNING function. Returns false when this is not
'' one, so the ordinary RETURN carries on.
''
'' The value does not leave as a value: it is BUILT in the result descriptor and handed
'' to fb_StrAllocTempResult on the way out, which is what fbc emits. Returning the
'' expression directly would hand back a pointer to static text where the caller expects
'' a descriptor.
function LowerStringReturn( byref c as Ctx, byval valueE as Fbx.NodeId ) as boolean
    if c.resultSlot < 0 then return false
    if c.resultTy <> cast( ubyte, MT_AGG ) then return false

    if valueE <> Fbx.NODE_NONE then
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
