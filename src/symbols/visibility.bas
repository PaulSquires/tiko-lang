'' visibility.bas -- 'private:' AND 'protected:' INSIDE A TYPE.
''
'' fbc error 202, "Illegal member access". A PRIVATE member may be named only from inside
'' its own type's procedures; a PROTECTED one from those and from a DERIVED type's.
''
'' A PASS OF ITS OWN, after Check, and that is the whole reason it exists at all. The
'' question needs two things at once: WHICH MEMBER -- which only Check knows, because a
'' field means nothing until its base has a type -- and WHICH PROCEDURE ENCLOSES THE USE,
'' which Check does not track and Resolve cannot answer for a field. Walking the tree once
'' more, carrying the enclosing procedure down, gets both.
''
'' A DEFINITION CARRIES NO VISIBILITY. 'sub T.f( )' is written outside the type body, so
'' only the DECLARE inside it records 'private'. That is why Collect ORs the flag onto the
'' symbol rather than assigning it: the definition would otherwise clear what the
'' declaration said.
''
'' NOT SYMF_PRIVATE, which is module linkage and an unrelated question: a private MODULE
'' procedure is visible to its whole file, and a private MEMBER only inside its own type.

#include once "symbols/visibility.bi"
#include once "diag/diagids.bi"

namespace Tko.Vis

type Ctx
    as AstArena ptr         ast
    as SymbolTable ptr      syms
    as TypeContext ptr      types
    as Interner ptr         names
    as DiagnosticEngine ptr diags
    as SemanticInfo ptr     info
    as InternId             baseName
end type

'' The TYPE a symbol was declared in, or TYPE_NONE. A member's scope is the type's own.
private function OwningType_ _
    ( byref c as Ctx, byval s as Symbol ptr ) as TypeId

    if s = 0 then return TYPE_NONE
    dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
    if sc = 0 then return TYPE_NONE
    if sc->kind <> cast( ubyte, SCOPEK_TYPE ) then return TYPE_NONE
    dim as Symbol ptr owner = c.syms->SymbolAt( sc->owner )
    if owner = 0 then return TYPE_NONE
    if owner->kind <> cast( ubyte, SYM_UDT ) then return TYPE_NONE
    return owner->type_
end function

'' 'extends' is a FIELD NAMED 'base' at offset 0 -- the same fact vtable.bas leans on --
'' so the base type is that field's type.
private function BaseOf_ ( byref c as Ctx, byval t as TypeId ) as TypeId
    if t = TYPE_NONE then return TYPE_NONE
    if c.types->Kind( t ) <> TK_UDT then return TYPE_NONE
    dim as InternId tn = c.types->NameOf( t )
    if tn = 0 then return TYPE_NONE
    dim as ScopeId ds = cast( ScopeId, c.types->DeclScopeOf( t ) )
    dim as SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return TYPE_NONE
    if s->inner = SCOPE_NONE then return TYPE_NONE
    dim as SymbolId bf = c.syms->LookupLocal( s->inner, c.baseName )
    if bf = SYMBOL_NONE then return TYPE_NONE
    dim as Symbol ptr b = c.syms->SymbolAt( bf )
    if b = 0 then return TYPE_NONE
    if b->kind <> cast( ubyte, SYM_FIELD ) then return TYPE_NONE
    return b->type_
end function

private function DerivesFrom_ _
    ( byref c as Ctx, byval derived as TypeId, byval base_ as TypeId ) as boolean

    dim as TypeId cur = derived
    dim as long guard = 0
    while (cur <> TYPE_NONE) andalso (guard < 64)
        guard += 1
        if cur = base_ then return true
        cur = BaseOf_( c, cur )
    wend
    return false
end function

'' The type whose procedures this node sits inside, or TYPE_NONE at module level.
private function ProcOwner_ ( byref c as Ctx, byval id as NodeId ) as TypeId
    dim as SymbolId psid = c.info->RefOf( id )
    if psid = SYMBOL_NONE then return TYPE_NONE
    return OwningType_( c, c.syms->SymbolAt( psid ) )
end function

private sub CheckMember_ _
    ( byref c as Ctx, byval id as NodeId, byval here as TypeId )

    dim as SymbolId sid = c.info->RefOf( id )
    if sid = SYMBOL_NONE then return
    dim as Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return
    dim as boolean isPriv = ((s->flags and SYMF_MEMB_PRIVATE) <> 0)
    dim as boolean isProt = ((s->flags and SYMF_MEMB_PROTECTED) <> 0)
    if (isPriv = false) andalso (isProt = false) then return

    dim as TypeId owner = OwningType_( c, s )
    if owner = TYPE_NONE then return
    '' UNKNOWN CONTEXT IS NOT AN ERROR. If the enclosing procedure could not be resolved
    '' to a type, saying nothing is the honest answer: the alternative refuses legal code
    '' on a lookup this pass got wrong.
    if here = TYPE_NONE then
        c.diags->Report( TKO0625, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( s->name ) )
        return
    end if
    if isPriv then
        if here <> owner then
            c.diags->Report( TKO0625, PointRange( c.ast->Loc( id ) ), _
                             c.names->Spelling( s->name ) )
        end if
        return
    end if
    '' PROTECTED reaches down the derivation chain and no further.
    if DerivesFrom_( c, here, owner ) = false then
        c.diags->Report( TKO0625, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( s->name ) )
    end if
end sub

'' '.' AND '->' ARE NOT INTERCHANGEABLE. Measured, over 'x as UDT', 'p as UDT ptr' and
'' 'pp as UDT ptr ptr':
''
''     x.i        OK        p.i        error 265   a DOT through a pointer
''     p->i       OK        x->i       error 28    an ARROW through a value
''     (*p).i     OK        pp->i      error 24    the pointee is not a UDT
''     (*pp)->i   OK        (*pp).i    error 265
''
'' 'this' IS EXEMPT FROM THE DOT RULE. tiko-lang types it as a POINTER because that is
'' what the ABI passes -- fbc's own C spells the receiver 'struct $1T*' -- so 'this.i'
'' looks exactly like a dot through a pointer and is the commonest line in any method.
''
'' AN ARROW THROUGH A UDT IS NOT REPORTED, only through a builtin: a type may overload
'' 'operator ->', and that question is not measured here.
private function IsThisBase_ ( byref c as Ctx, byval n as NodeId ) as boolean
    if n = NODE_NONE then return false
    if c.ast->Kind( n ) <> N_IDENT then return false
    dim as InternId nm = _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )].name
    return c.names->Fold( nm ) = c.names->Fold( c.names->GetString( "this" ) )
end function

private sub CheckDeref_ ( byref c as Ctx, byval id as NodeId )
    dim as BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as TokenKind op = cast( TokenKind, mp->op )
    if (op <> TK_DOT) andalso (op <> TK_ARROW) then return
    if mp->lhs = NODE_NONE then return
    dim as TypeId bt = c.info->TypeOf_( mp->lhs )
    '' UNTYPED IS NOT AN ERROR: a namespace-qualified name has no type at all, and an
    '' expression that declined earlier would be blamed for someone else's mistake.
    if bt = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( bt )
    dim as boolean isPtr = (c.types->Kind( u ) = TK_POINTER)

    if op = TK_DOT then
        if isPtr = false then return
        if IsThisBase_( c, mp->lhs ) then return
        c.diags->Report( TKO0630, PointRange( c.ast->Loc( id ) ) )
        return
    end if

    if isPtr = false then
        if c.types->Kind( u ) <> TK_BUILTIN then return
        c.diags->Report( TKO0631, PointRange( c.ast->Loc( id ) ) )
        return
    end if
    dim as TypeId pointee = c.types->Unqualify( c.types->Inner( u ) )
    if pointee = TYPE_NONE then return
    if c.types->Kind( pointee ) = TK_UDT then return
    c.diags->Report( TKO0631, PointRange( c.ast->Loc( id ) ) )
end sub

'' A PRIVATE CONSTRUCTOR OR DESTRUCTOR IS REACHED BY DECLARING THE TYPE -- fbc's error
'' 204, "The default constructor has no public access", and 206 for the destructor.
''
'' No member access is written anywhere: 'dim as T x' CALLS T's default constructor and
'' its destructor, and if either is private the declaration is refused. The corpus names
'' the shapes '<vis>-<member>-<from>-<what>', and the <from> half is the ordinary member
'' rule -- 'private-ctor-protected-local' is an error because a DERIVED type cannot reach
'' a PRIVATE constructor, while 'protected-ctor-protected-local' is fine.
''
'' A POINTER IS NOT A DECLARATION OF ONE. 'dim as T ptr p' constructs nothing; only 'new T'
'' does, and that names its type in an expression where no symbol carries it.
private function StructorOf_ _
    ( byref c as Ctx, byval udt as TypeId, byref nm as string ) as Symbol ptr

    if udt = TYPE_NONE then return 0
    if c.types->Kind( udt ) <> TK_UDT then return 0
    dim as InternId tn = c.types->NameOf( udt )
    if tn = 0 then return 0
    dim as ScopeId ds = cast( ScopeId, c.types->DeclScopeOf( udt ) )
    dim as SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return 0
    if s->inner = SCOPE_NONE then return 0
    return c.syms->SymbolAt( c.syms->LookupLocal( s->inner, _
                                                  c.names->Fold( c.names->GetString( nm ) ) ) )
end function

'' The type whose procedures this SCOPE sits inside, or TYPE_NONE at module level.
private function EnclosingTypeOf_ _
    ( byref c as Ctx, byval scope_ as ScopeId ) as TypeId

    dim as ScopeId cur = scope_
    dim as long guard = 0
    while (cur <> SCOPE_NONE) andalso (guard < 1000)
        guard += 1
        dim as SymScope ptr sc = c.syms->ScopeAt( cur )
        if sc = 0 then return TYPE_NONE
        if sc->kind = cast( ubyte, SCOPEK_TYPE ) then
            dim as Symbol ptr owner = c.syms->SymbolAt( sc->owner )
            if owner = 0 then return TYPE_NONE
            return owner->type_
        end if
        if sc->kind = cast( ubyte, SCOPEK_PROC ) then
            dim as Symbol ptr pr = c.syms->SymbolAt( sc->owner )
            if pr = 0 then return TYPE_NONE
            dim as SymScope ptr ps = c.syms->ScopeAt( pr->parent )
            if ps = 0 then return TYPE_NONE
            if ps->kind <> cast( ubyte, SCOPEK_TYPE ) then return TYPE_NONE
            dim as Symbol ptr owner2 = c.syms->SymbolAt( ps->owner )
            if owner2 = 0 then return TYPE_NONE
            return owner2->type_
        end if
        cur = sc->parent
    wend
    return TYPE_NONE
end function

'' How many parameters this declaration REQUIRES -- a defaulted one is not required, and
'' neither is an ellipsis. A constructor that requires none is a DEFAULT constructor, and
'' it is the one a bare 'dim as T x' calls.
private function RequiredParams_ ( byref c as Ctx, byval decl as NodeId ) as long
    if decl = NODE_NONE then return -1
    if c.ast->Kind( decl ) <> N_PROC then return -1
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    dim as long n = 0
    for i as long = 0 to sp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        dim as StmtPayload ptr psp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
        if psp->op = cast( ushort, TK_ELLIPSIS ) then continue for
        if psp->b <> NODE_NONE then continue for
        n += 1
    next
    return n
end function

private function StructorReachable_ _
    ( byref c as Ctx, byval st as Symbol ptr, byval udt as TypeId, _
      byval here as TypeId ) as boolean

    dim as boolean isPriv = ((st->flags and SYMF_MEMB_PRIVATE) <> 0)
    dim as boolean isProt = ((st->flags and SYMF_MEMB_PROTECTED) <> 0)
    if (isPriv = false) andalso (isProt = false) then return true
    if here = TYPE_NONE then return false
    if isPriv then return (here = udt)
    return DerivesFrom_( c, here, udt )
end function

'' THE WHOLE OVERLOAD CHAIN, not its head. fb/comptr.bi's ComInit declares a PRIVATE copy
'' constructor first and a PUBLIC default one after it -- "they exist to be rejected", its
'' own comment says -- and reading only the head refused 'dim as ComInit co', which fbc
'' accepts. What a bare declaration calls is the constructor that REQUIRES NO ARGUMENT,
'' and the type is fine if any such constructor is reachable.
private sub CheckOneStructor_ _
    ( byref c as Ctx, byval udt as TypeId, byref nm as string, _
      byval here as TypeId, byval at as SourceLoc, byval vnm as InternId )

    dim as Symbol ptr st = StructorOf_( c, udt, nm )
    if st = 0 then return
    dim as boolean sawDefault = false
    dim as Symbol ptr walk = st
    dim as long guard = 0
    while (walk <> 0) andalso (guard < 1000)
        guard += 1
        dim as long req = RequiredParams_( c, cast( NodeId, walk->payload ) )
        '' A DESTRUCTOR takes none by definition, and one whose declaration cannot be
        '' read at all is counted rather than skipped: not knowing is not permission.
        if (req = 0) orelse (req = -1) then
            sawDefault = true
            if StructorReachable_( c, walk, udt, here ) then return
        end if
        walk = c.syms->SymbolAt( walk->nextOverload )
    wend
    if sawDefault = false then return
    c.diags->Report( TKO0633, PointRange( at ), c.names->Spelling( vnm ) )
end sub

'' A FIXED-LENGTH STRING HAS NO PARAMETER FORM AT ALL -- fbc's error 324, "Fixed-length
'' string combined with BYREF (not supported)", and error 59 for the byval spelling.
'' Measured, and the surprise is the third row: writing NEITHER modifier is refused too,
'' so this is not a rule about byref.
''
''     sub f( z as zstring * 10 )          error 324
''     sub f( byref z as zstring * 10 )    error 324
''     sub f( byval z as zstring * 10 )    error 59
''     sub f( byref z as string * 10 )     error 324
''     sub f( byref z as zstring )         OK      -- no length, so not one
'' A STATIC MEMBER VARIABLE IS ONLY ALLOWED IN A TOP-LEVEL UDT -- fbc error 264, "Static
'' member variable in nested UDT". Measured, and "nested" means INSIDE A PROCEDURE and
'' nothing else: a type declared inside another TYPE takes one, and so does a top-level
'' type.
private sub CheckNestedStatics_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        '' A STATIC MEMBER IS AN N_VAR, not an N_FIELD -- it has storage of its own and
        '' no place in the layout -- so its symbol is a VARIABLE living in the TYPE's
        '' scope. Testing SYM_FIELD alone found none of them.
        dim as SymbolKind mk = cast( SymbolKind, s->kind )
        if (mk <> SYM_FIELD) andalso (mk <> SYM_VARIABLE) then continue for
        if (s->flags and (SYMF_STATIC or SYMF_SHARED)) = 0 then continue for
        dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
        if sc = 0 then continue for
        if sc->kind <> cast( ubyte, SCOPEK_TYPE ) then continue for
        '' The type's OWN declaring scope is what decides, not the field's.
        dim as Symbol ptr owner = c.syms->SymbolAt( sc->owner )
        if owner = 0 then continue for
        dim as boolean inProc = false
        dim as ScopeId cur = owner->parent
        dim as long guard = 0
        while (cur <> SCOPE_NONE) andalso (guard < 1000)
            guard += 1
            dim as SymScope ptr ps = c.syms->ScopeAt( cur )
            if ps = 0 then exit while
            if ps->kind = cast( ubyte, SCOPEK_PROC ) then
                inProc = true
                exit while
            end if
            cur = ps->parent
        wend
        if inProc = false then continue for
        c.diags->Report( TKO0638, PointRange( s->loc ), c.names->Spelling( s->name ) )
    next
end sub

private sub CheckFixLenParams_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        dim as SymbolKind sk = cast( SymbolKind, s->kind )
        '' A PARAMETER, a BYREF VARIABLE and a RESULT TYPE are the same refusal: none of
        '' the three has storage of its own for a fixed-length string to live in.
        '' Measured -- 'dim byref z as zstring * 10 = "hi"' and
        '' 'function f( ) as zstring * 10' are both refused, byref result or not.
        dim as boolean interesting = (sk = SYM_PARAMETER) orelse (sk = SYM_PROC)
        if (interesting = false) andalso (sk = SYM_VARIABLE) then
            interesting = ((s->flags and SYMF_BYREF) <> 0)
        end if
        if interesting = false then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( s->type_ )
        '' A REFERENCE parameter carries the reference; the fixed string is inside it.
        if c.types->Kind( u ) = TK_REFERENCE then
            u = c.types->Unqualify( c.types->Inner( u ) )
        end if
        '' A FIXED-LENGTH string is an ARRAY of a character builtin -- that is what
        '' distinguishes it from the plain 'zstring' a byref parameter may take.
        if c.types->Kind( u ) <> TK_ARRAY then continue for
        dim as TypeId el = c.types->Unqualify( c.types->Inner( u ) )
        if el = TYPE_NONE then continue for
        if c.types->Kind( el ) <> TK_BUILTIN then continue for
        '' TY_STRING IS EXCLUDED, and that is the whole difference between a
        '' fixed-length string and an ARRAY OF STRINGS. 'string * N' is an array of
        '' TY_FIXSTR and 'zstring * N' one of TY_ZSTRING, while 'buf( ) as T' with T
        '' instantiated as a string is an array of TY_STRING -- fb/sort.bi's
        '' SortMergeBy writes one, and refusing it turned generics/container-sort.bas,
        '' which fbc accepts, into an error.
        select case c.types->BuiltinOf( el )
        case TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        case else
            continue for
        end select
        c.diags->Report( TKO0636, PointRange( s->loc ), c.names->Spelling( s->name ) )
    next
end sub

'' A SHARED VARIABLE'S INITIALISER RUNS BEFORE ANY FRAME EXISTS, so it may not name one
'' that is not shared -- fbc error 272, "Local symbols can't be referenced". Measured:
''
''     static as integer i
''     dim shared as integer ptr pi = @i     error 272
''
'' 'static' STORAGE IS NOT ENOUGH: that variable outlives the frame, and fbc still calls
'' it local. What the initialiser may name is a SHARED one, so the test is on SYMF_SHARED
'' of what is referenced and not on "does it have automatic storage".
private sub CheckSharedRef_ ( byref c as Ctx, byval id as NodeId, byval vnm as InternId )
    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    if k = N_IDENT then
        dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
        if s = 0 then return
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then return
        if (s->flags and (SYMF_SHARED or SYMF_EXTERN or SYMF_COMMON)) <> 0 then return
        c.diags->Report( TKO0640, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( s->name ) )
        return
    end if
    '' The same narrow set of shapes CheckAutoRef_ walks, for the same reason.
    select case k
    case N_BINARY
        dim as BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        CheckSharedRef_( c, bp->lhs, vnm )
        CheckSharedRef_( c, bp->rhs, vnm )
    case N_UNARY, N_ADDROF, N_DEREF
        dim as UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        CheckSharedRef_( c, up->operand, vnm )
    case N_PAREN, N_TUPLE, N_INITIALIZER
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            CheckSharedRef_( c, cast( NodeId, c.ast->children[lp->first + i] ), vnm )
        next
    end select
end sub

'' A BYREF BINDING NEEDS SOMETHING WITH AN ADDRESS, and it needs one at all. Measured:
''
''     dim byref i as integer = 1          error 24     a literal has no address
''     var byref i = f( )                  error 24     nor does a call's RESULT
''     dim byref i as integer = g + 1      error 3      nor an arithmetic expression
''     dim byref i as integer              error 320    and it may not be left unbound
''     dim byref i as integer = g          OK
''     dim byref i as integer = g( 0 )     OK           an element has one
''
'' ONLY THE SHAPES THAT CERTAINLY HAVE NO ADDRESS are reported -- a literal and a call to
'' a PROCEDURE. An indexing expression looks exactly like a call and is an lvalue, which
'' is what the target's symbol kind tells apart.
'' AN ABSTRACT METHOD HAS NO BODY -- fbc error 224, "Implemented body for an ABSTRACT
'' method". The declaration says there is nothing to call.
''
'' OVER THE AST, not the symbol table: the DEFINITION joins its DECLARE, and the symbol's
'' payload stays the DECLARATION node -- which has no body, so the symbol sweep saw none.
private sub CheckAbstractBody_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (sp->extra and PF_ABSTRACT) = 0 then return
    if sp->b = NODE_NONE then return
    c.diags->Report( TKO0646, PointRange( c.ast->Loc( id ) ), _
                     c.names->Spelling( sp->name ) )
end sub

'' 'virtual' NEEDS A VTABLE, and only a type that extends OBJECT has one -- fbc error
'' 221, "Method declared VIRTUAL, but UDT does not extend OBJECT". 'abstract' implies
'' virtual and is the same refusal.
''
'' AND AN ABSTRACT METHOD HAS NO BODY -- fbc error 224, "Implemented body for an ABSTRACT
'' method". The declaration says there is nothing to call.
private function ExtendsObject_ ( byref c as Ctx, byval t as TypeId ) as boolean
    dim as InternId objNm = c.names->Fold( c.names->GetString( "object" ) )
    dim as TypeId cur = t
    dim as long guard = 0
    while (cur <> TYPE_NONE) andalso (guard < 64)
        guard += 1
        if c.names->Fold( c.types->NameOf( cur ) ) = objNm then return true
        cur = BaseOf_( c, cur )
    wend
    return false
end function

private sub CheckVirtualNeedsObject_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_PROC ) then continue for
        dim as NodeId decl = cast( NodeId, s->payload )
        if decl = NODE_NONE then continue for
        if c.ast->Kind( decl ) <> N_PROC then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
        dim as boolean isAbstract = ((sp->extra and PF_ABSTRACT) <> 0)
        dim as boolean isVirtual = ((sp->extra and PF_VIRTUAL) <> 0) orelse isAbstract
        if isVirtual = false then continue for
        '' 'operator new' AND ITS THREE SIBLINGS ARE IMPLICITLY STATIC, so neither
        '' modifier may be written on them -- fbc error 233, "This operator is implicitly
        '' STATIC and cannot be VIRTUAL or ABSTRACT". They allocate the object; there is
        '' no receiver yet to dispatch through.
        dim as string opnm = Text.LowerAscii( c.names->Spelling( s->name ) )
        dim as boolean allocOp = (opnm = "new") orelse (opnm = "delete") orelse _
                                 (opnm = "new[]") orelse (opnm = "delete[]")
        if allocOp then
            c.diags->Report( TKO0647, PointRange( c.ast->Loc( decl ) ) )
            continue for
        end if
        dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
        if sc = 0 then continue for
        if sc->kind <> cast( ubyte, SCOPEK_TYPE ) then continue for
        dim as Symbol ptr owner = c.syms->SymbolAt( sc->owner )
        if owner = 0 then continue for
        if owner->type_ = TYPE_NONE then continue for
        if ExtendsObject_( c, owner->type_ ) then continue for
        c.diags->Report( TKO0645, PointRange( c.ast->Loc( decl ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

private sub CheckByrefBinding_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if (s->flags and SYMF_BYREF) = 0 then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then
            c.diags->Report( TKO0644, PointRange( s->loc ), c.names->Spelling( s->name ) )
            continue for
        end if
        dim as NodeId init = ip->b
        dim as boolean noAddress = false
        select case c.ast->Kind( init )
        '' A STRING LITERAL IS NOT IN THIS SET. It lives in the data segment and has an
        '' address of its own -- 'var byref i = "abc"' and 'dim byref rz as zstring =
        '' "foo"' are both accepted, and counting them refused two files fbc takes.
        case N_INT_LIT, N_FLOAT_LIT
            noAddress = true
        case N_CALL
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]
            dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
            if ts <> 0 then
                noAddress = (ts->kind = cast( ubyte, SYM_PROC ))
                '' ...UNLESS IT RETURNS BYREF. That result IS a reference, and binding
                '' one to it is the whole point -- 'dim byref as long r = o.Value( )' in
                '' generics/container-optional.bas is exactly that.
                if noAddress then
                    dim as NodeId cd = cast( NodeId, ts->payload )
                    if (cd <> NODE_NONE) andalso (c.ast->Kind( cd ) = N_PROC) then
                        if (c.ast->nodes[cast( long, cd )].flags and NF_BYREF) <> 0 then
                            noAddress = false
                        end if
                    end if
                end if
            end if
        end select
        if noAddress = false then continue for
        c.diags->Report( TKO0643, PointRange( c.ast->Loc( init ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

private sub CheckSharedInits_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if (s->flags and SYMF_SHARED) = 0 then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        CheckSharedRef_( c, ip->b, s->name )
    next
end sub

private sub CheckImplicitStructors_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        dim as SymbolKind k = cast( SymbolKind, s->kind )
        if (k <> SYM_VARIABLE) andalso (k <> SYM_FIELD) then continue for
        if s->type_ = TYPE_NONE then continue for
        '' An ARRAY of them constructs every element; a POINTER constructs nothing.
        dim as TypeId u = c.types->Unqualify( s->type_ )
        dim as long guard = 0
        while (c.types->Kind( u ) = TK_ARRAY) andalso (guard < 16)
            guard += 1
            u = c.types->Unqualify( c.types->Inner( u ) )
        wend
        if c.types->Kind( u ) <> TK_UDT then continue for
        '' THE BASE FIELD IS THE 'extends', not a declaration of one: a derived type
        '' constructs its base whatever the base's constructor says.
        if (k = SYM_FIELD) andalso (s->name = c.baseName) then continue for
        dim as TypeId here = EnclosingTypeOf_( c, s->parent )
        CheckOneStructor_( c, u, "__ctor", here, s->loc, s->name )
        CheckOneStructor_( c, u, "__dtor", here, s->loc, s->name )
    next
end sub

'' A 'bydesc' PARAMETER TAKES THE WHOLE ARRAY -- fbc error 58, "Type mismatch".
'' Measured:
''
''     sub f( a( ) as integer ) : f( a( 0 ) )    error 58    an ELEMENT is not an array
''     sub f( a( ) as integer ) : f( a( ) )      OK
''     sub f( byval i as integer ) : f( a( 0 ) ) OK          an ordinary parameter
''
'' What it is passed is a DESCRIPTOR, and an element has none.
'' 'swap' EXCHANGES TWO STORAGE LOCATIONS, so neither operand may be a literal or a
'' constant. Measured, and fbc has a separate error for each:
''
''     dim as integer a : swap a, 0        error 24    Invalid data types
''     const a = "a" : swap a, s           error 119   Cannot modify a constant
private sub CheckSwapOperands_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_SWAP then return
    '' THE TWO OPERANDS ARE 'a' AND 'b', not a child list: 'swap' takes exactly two and
    '' the parser writes them into the payload's own slots.
    for i as long = 0 to 1
        dim as NodeId a2 = sp->a
        if i = 1 then a2 = sp->b
        if a2 = NODE_NONE then continue for
        select case c.ast->Kind( a2 )
        case N_INT_LIT, N_FLOAT_LIT, N_STRING_LIT, N_STRCAT
            c.diags->Report( TKO0642, PointRange( c.ast->Loc( a2 ) ) )
            return
        case N_IDENT
            dim as Symbol ptr s2 = c.syms->SymbolAt( c.info->RefOf( a2 ) )
            if s2 = 0 then continue for
            dim as SymbolKind sk2 = cast( SymbolKind, s2->kind )
            if (sk2 <> SYM_CONSTANT) andalso (sk2 <> SYM_ENUMCONST) then continue for
            c.diags->Report( TKO0642, PointRange( c.ast->Loc( a2 ) ) )
            return
        end select
    next
end sub

'' 'a( )' -- an EMPTY subscript list over an array variable, which is how a whole array
'' is written at a call.
private function WholeArraySpelling_ ( byref c as Ctx, byval n as NodeId ) as boolean
    if n = NODE_NONE then return false
    dim as NodeKind k = c.ast->Kind( n )
    if (k <> N_CALL) andalso (k <> N_INDEX) then return false
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
    if lp->count <> 0 then return false
    dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
    if ts = 0 then return false
    return ts->kind = cast( ubyte, SYM_VARIABLE )
end function

private sub CheckBydescArgs_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->target = NODE_NONE then return
    dim as Symbol ptr callee = c.syms->SymbolAt( c.info->RefOf( id ) )
    if callee = 0 then callee = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
    if callee = 0 then return
    if callee->kind <> cast( ubyte, SYM_PROC ) then return
    dim as NodeId decl = cast( NodeId, callee->payload )
    if decl = NODE_NONE then return
    if c.ast->Kind( decl ) <> N_PROC then return
    dim as StmtPayload ptr pp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    dim as long ai = 0
    for i as long = 0 to pp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        if ai >= lp->count then exit for
        dim as NodeId arg = cast( NodeId, c.ast->children[lp->first + ai] )
        ai += 1
        if (c.ast->nodes[cast( long, prm )].flags and NF_ARRAY) = 0 then continue for
        '' 'a( )' IS THE WHOLE-ARRAY SPELLING and is recognised by its SHAPE, not by its
        '' type: an empty subscript list over an array variable types as the ELEMENT
        '' here, so a type test alone refused dim/shared-array-1.bas and -2.bas, which
        '' fbc accepts.
        if WholeArraySpelling_( c, arg ) then continue for
        dim as TypeId at2 = c.info->TypeOf_( arg )
        '' UNTYPED IS NOT AN ERROR: something earlier declined, and blaming this
        '' argument would point at the wrong line.
        if at2 = TYPE_NONE then continue for
        if c.types->Kind( c.types->Unqualify( at2 ) ) = TK_ARRAY then continue for
        c.diags->Report( TKO0641, PointRange( c.ast->Loc( arg ) ) )
        return
    next
end sub

'' A PARAMETER DEFAULT CANNOT NAME A LOCAL -- fbc error 272, "Local symbols can't be
'' referenced". The default is evaluated at the CALL SITE, where the declaring frame does
'' not exist. Measured, and the second row is the one a scope test gets wrong:
''
''     dim shared g as integer : sub f( byval p as integer = g )     OK
''     dim localI as integer   : sub f( byval p as integer = localI ) error 272
''     const K = 5             : sub f( byval p as integer = K )     OK
''     sub f( byval p as integer = 5 )                               OK
''
'' -- a module-level 'dim' WITHOUT 'shared' still has automatic storage in fbc's model:
'' it lives in main's frame. So what decides is the SYMBOL's storage, not where it sits.
private sub CheckAutoRef_ ( byref c as Ctx, byval id as NodeId )
    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    if k = N_IDENT then
        dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
        if s = 0 then return
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then return
        if (s->flags and (SYMF_SHARED or SYMF_STATIC or SYMF_EXTERN or _
                          SYMF_COMMON)) <> 0 then return
        c.diags->Report( TKO0640, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( s->name ) )
        return
    end if
    '' Only the shapes a constant-ish default is built from; anything else stops, for
    '' the payload-pool reason spelled out in Walk_.
    select case k
    case N_BINARY
        dim as BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        CheckAutoRef_( c, bp->lhs )
        CheckAutoRef_( c, bp->rhs )
    case N_UNARY, N_ADDROF, N_DEREF
        dim as UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        CheckAutoRef_( c, up->operand )
    case N_PAREN, N_CALL, N_INDEX, N_TUPLE, N_INITIALIZER
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            CheckAutoRef_( c, cast( NodeId, c.ast->children[lp->first + i] ) )
        next
    end select
end sub

private sub CheckParamDefault_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return
    CheckAutoRef_( c, sp->b )
end sub

'' AN ARRAY IS NOT A SUBSCRIPT -- fbc error 73, "Array access, index expected".
'' 'print a1( a2 )' over two arrays is refused; 'a1( i )' over an integer is the ordinary
'' access.
''
'' ONLY WHEN THE TARGET IS A VARIABLE. The same node shape is a CALL, and passing a whole
'' array to a 'bydesc' parameter -- 'f( a( ) )' -- is exactly how one is passed.
private sub CheckArraySubscript_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->target = NODE_NONE then return
    dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
    if ts = 0 then return
    if ts->kind <> cast( ubyte, SYM_VARIABLE ) then return
    for i as long = 0 to lp->count - 1
        dim as NodeId a2 = cast( NodeId, c.ast->children[lp->first + i] )
        dim as TypeId at2 = c.info->TypeOf_( a2 )
        if at2 = TYPE_NONE then continue for
        if c.types->Kind( c.types->Unqualify( at2 ) ) <> TK_ARRAY then continue for
        c.diags->Report( TKO0637, PointRange( c.ast->Loc( a2 ) ) )
        return
    next
end sub

'' '&=' CONCATENATES, so its target must be a STRING -- fbc error 20, "Type mismatch".
'' Measured: 'i &= 1' over an integer and 'd &= 1' over a double are both refused, while
'' 's &= "a"' is the ordinary use and 'i += 1' is a different operator entirely.
private sub CheckConcatAssign_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> TK_AMPEQ then return
    if sp->a = NODE_NONE then return
    dim as TypeId t = c.info->TypeOf_( sp->a )
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    '' A FIXED-LENGTH string is an ARRAY of a character builtin; unwrap to its element,
    '' which is what makes 'fs &= "a"' as ordinary as the var-len form.
    dim as long guard = 0
    while (c.types->Kind( u ) = TK_ARRAY) andalso (guard < 16)
        guard += 1
        u = c.types->Unqualify( c.types->Inner( u ) )
    wend
    if c.types->Kind( u ) <> TK_BUILTIN then return
    select case c.types->BuiltinOf( u )
    case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        return
    end select
    c.diags->Report( TKO0635, PointRange( c.ast->Loc( id ) ) )
end sub

'' A PROCEDURE POINTER IS NOT AN ADDRESS TO DO ARITHMETIC ON, and it does not
'' DEREFERENCE either -- fbc calls both error 20, "Type mismatch". Measured:
''
''     p + 1              error 20        p as sub ptr
''     @sub1 - @sub2      error 20
''     p += 1             error 20
''     *p = 1             error 20
''     dim as integer i = *p             error 20
''
'' A pointer to DATA does all three; what makes a procedure pointer different is that
'' there is no element size to scale by and nothing at the far end to read.
private function IsProcPtr_ ( byref c as Ctx, byval t as TypeId ) as boolean
    if t = TYPE_NONE then return false
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> TK_POINTER then return false
    dim as TypeId inner_ = c.types->Unqualify( c.types->Inner( u ) )
    if inner_ = TYPE_NONE then return false
    return c.types->Kind( inner_ ) = TK_PROC
end function

private sub CheckProcPtrArith_ ( byref c as Ctx, byval id as NodeId )
    dim as BinaryPayload ptr bp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as TokenKind op = cast( TokenKind, bp->op )
    '' ARITHMETIC ONLY. A comparison between two procedure pointers is ordinary and fbc
    '' accepts it -- that is how a callback is tested against null.
    select case op
    case TK_PLUS, TK_MINUS, TK_STAR, TK_SLASH, TK_BACKSLASH
    case else
        return
    end select
    if IsProcPtr_( c, c.info->TypeOf_( bp->lhs ) ) orelse _
       IsProcPtr_( c, c.info->TypeOf_( bp->rhs ) ) then
        c.diags->Report( TKO0634, PointRange( c.ast->Loc( id ) ) )
    end if
end sub

private sub CheckProcPtrDeref_ ( byref c as Ctx, byval id as NodeId )
    dim as UnaryPayload ptr up = _
        @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    if IsProcPtr_( c, c.info->TypeOf_( up->operand ) ) then
        c.diags->Report( TKO0634, PointRange( c.ast->Loc( id ) ) )
    end if
end sub

'' 'delete' TAKES A POINTER -- fbc error 28, "Expected pointer". Measured over an
'' integer and a single alike; a pointer of any pointee is accepted.
''
'' Checked here rather than in lowering, which merely DECLINED: a declined statement is
'' counted as not-lowered and says nothing, so 'delete a' over an integer compiled clean.
private sub CheckDelete_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->a = NODE_NONE then return
    dim as TypeId t = c.info->TypeOf_( sp->a )
    '' UNTYPED IS NOT AN ERROR: something earlier declined, and reporting would blame
    '' the wrong line.
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_POINTER then return
    c.diags->Report( TKO0629, PointRange( c.ast->Loc( sp->a ) ) )
end sub

private sub Walk_ ( byref c as Ctx, byval id as NodeId, byval here as TypeId )
    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    dim as TypeId inner = here
    if k = N_PROC then inner = ProcOwner_( c, id )
    if k = N_MEMBER then CheckMember_( c, id, here )
    if k = N_DELETE_STMT then CheckDelete_( c, id )
    if k = N_MEMBER then CheckDeref_( c, id )
    if k = N_BINARY then CheckProcPtrArith_( c, id )
    if k = N_AMBIGUOUS then CheckConcatAssign_( c, id )
    if (k = N_CALL) orelse (k = N_INDEX) then CheckArraySubscript_( c, id )
    if k = N_PARAM then CheckParamDefault_( c, id )
    if k = N_CALL then CheckBydescArgs_( c, id )
    if k = N_INTRINSIC then CheckSwapOperands_( c, id )
    if k = N_PROC then CheckAbstractBody_( c, id )
    if k = N_DEREF then CheckProcPtrDeref_( c, id )

    '' EVERY SHAPE OF CHILD LIST, because a member access hides under all of them. The
    '' arena stores three, and a walk that knew only about statements missed every
    '' expression -- which is where member accesses actually live.
    select case NodeKindCategory( k )
    case NCAT_EXPR
        select case k
        case N_BINARY
            dim as BinaryPayload ptr bp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
            Walk_( c, bp->lhs, inner )
            Walk_( c, bp->rhs, inner )
            return
        case N_MEMBER
            dim as BinaryPayload ptr mp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
            '' ONLY THE BASE. The right-hand side is the member NAME, and Check bound it
            '' to the same symbol -- walking it would report the same access twice.
            Walk_( c, mp->lhs, inner )
            return
        case N_UNARY, N_ADDROF, N_DEREF
            dim as UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
            Walk_( c, up->operand, inner )
            return
        '' THE LIST KINDS, SPELLED OUT. 'data' is an index into ONE OF FOUR POOLS and
        '' the node kind is the only thing that says which -- the payload-pool mistake
        '' this codebase has now made eight times. Reading a CAST or a SIZEOF as a list
        '' indexed the list pool with a unary's offset and took the compiler down with
        '' an access violation, in 23 tests at once.
        case N_CALL, N_INDEX, N_PAREN, N_TUPLE, N_INITIALIZER, N_STRCAT
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
            Walk_( c, lp->target, inner )
            for i as long = 0 to lp->count - 1
                Walk_( c, cast( NodeId, c.ast->children[lp->first + i] ), inner )
            next
            return
        case else
            '' EVERYTHING ELSE STOPS HERE -- a literal, an identifier, and also 'new T',
            '' a closure and the intrinsic-shaped expressions. Guessing which pool one of
            '' those indexes is how the crash above happened, and a member access inside
            '' a 'new' going unchecked is a miss rather than a wrong answer.
            return
        end select
    case NCAT_TYPE
        return
    end select

    if (k = N_MODULE) orelse (k = N_BLOCK) then
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            Walk_( c, cast( NodeId, c.ast->children[lp->first + i] ), inner )
        next
        return
    end if

    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    Walk_( c, sp->a, inner )
    Walk_( c, sp->b, inner )
    Walk_( c, sp->c, inner )
    for i as long = 0 to sp->count - 1
        Walk_( c, cast( NodeId, c.ast->children[sp->first + i] ), inner )
    next
end sub

'' A VAR-LEN STRING WITH STATIC STORAGE CANNOT BE INITIALISED -- fbc error 87,
'' "Var-len strings cannot be initialized". A static string's storage is written by the
'' LOADER, and a var-len string is a descriptor whose data has to be allocated at run
'' time; there is nothing for an initialiser to write.
''
'' IT IS THE STORAGE THAT DECIDES, NOT THE SCOPE, and a scope test gets it backwards both
'' ways. Measured:
''
''     dim shared s as string = "foo"           error 87
''     static s as string = "foo"               error 87    inside a sub
''     var shared s = "foo"                     error 87
''     namespace ns : dim s as string = "foo"   error 87    a NAMESPACE is static storage
''     extern s as string : dim s as ... = ...  error 87    the extern makes it shared
''     dim s as string = "foo"                  OK          at MODULE level
''     dim s as string = "foo"                  OK          inside a sub
''     dim shared z as zstring * 8 = "foo"      OK          a FIXED string is not one
''
'' OVER THE SYMBOL TABLE, after the walk, because half of these are 'var' -- the type is
'' INFERRED from the initialiser and does not exist while the declaration is being walked.
private function ScopeIsStatic_ _
    ( byref c as Ctx, byval scope_ as ScopeId ) as boolean

    dim as ScopeId cur = scope_
    dim as long guard = 0
    while (cur <> SCOPE_NONE) andalso (guard < 1000)
        guard += 1
        dim as SymScope ptr sc = c.syms->ScopeAt( cur )
        if sc = 0 then return false
        '' A NAMESPACE gives its variables static storage; a plain MODULE does not.
        if sc->kind = cast( ubyte, SCOPEK_NAMESPACE ) then return true
        if sc->kind = cast( ubyte, SCOPEK_TYPE ) then return true
        if sc->kind = cast( ubyte, SCOPEK_PROC ) then return false
        cur = sc->parent
    wend
    return false
end function

private sub CheckStaticStringInits( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( s->type_ )
        '' A FIXED string is an ARRAY of a character builtin and is NOT this: it has
        '' storage of its own, and the loader can fill it.
        if c.types->Kind( u ) <> TK_BUILTIN then continue for
        if c.types->BuiltinOf( u ) <> TY_STRING then continue for

        dim as boolean flagged = ((s->flags and (SYMF_SHARED or _
            SYMF_STATIC or SYMF_EXTERN)) <> 0)
        if flagged = false then
            if ScopeIsStatic_( c, s->parent ) = false then continue for
        end if

        '' The declaration item, which is where the initialiser hangs.
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        c.diags->Report( TKO0628, PointRange( c.ast->Loc( item ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

sub Run _
    ( byref ast as AstArena, byval root as NodeId, byref syms as SymbolTable, _
      byref types as TypeContext, byref names as Interner, _
      byref diags as DiagnosticEngine, byref info as SemanticInfo )

    dim as Ctx c
    c.ast = @ast
    c.syms = @syms
    c.types = @types
    c.names = @names
    c.diags = @diags
    c.info = @info
    c.baseName = names.GetString( "base" )
    Walk_( c, root, TYPE_NONE )
    '' The OTHER thing that needs Check to have finished: half the shapes are 'var', and
    '' an inferred type does not exist until Check has run.
    CheckStaticStringInits( c )
    CheckImplicitStructors_( c )
    CheckFixLenParams_( c )
    CheckNestedStatics_( c )
    CheckSharedInits_( c )
    CheckByrefBinding_( c )
    CheckVirtualNeedsObject_( c )
end sub


end namespace
