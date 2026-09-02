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

'' Every parameter of a declaration, defaulted or not. Lives here, before the
'' latechecks include, because the array default-constructor test there needs it.
private function ParamCount_ ( byref c as Ctx, byval decl as NodeId ) as long
    if decl = NODE_NONE then return -1
    if c.ast->Kind( decl ) <> N_PROC then return -1
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    dim as long n = 0
    for i as long = 0 to sp->count - 1
        if c.ast->Kind( cast( NodeId, c.ast->children[sp->first + i] ) ) = N_PARAM then
            n += 1
        end if
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
#include once "symbols/latechecks.bas"
#include once "symbols/latesweeps.bas"


'' 'iif' RETURNS ONE TYPE, so its two arms may not disagree about what they are -- fbc
'' error 24, "Invalid data types". Measured:
''
''     iif( c, an_integer, a_string )        error 24
''     iif( c, @sub1, @sub2 )                error 24   two DIFFERENT procedure pointers
''     iif( c, an_integer_ptr, a_byte_ptr )  error 24   pointers must match EXACTLY
''     iif( c, a_long, a_double )            OK         numbers convert to each other
''     iif( c, an_integer, an_integer )      OK
''
'' NARROWED TO WHAT WAS MEASURED: the string/number divide and a pointer mismatch. Whether
'' a pointer may face a number here is not measured, so it is not asked.
private sub CheckIifArms_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 3 then return
    if lp->target = NODE_NONE then return
    if c.ast->Kind( lp->target ) <> N_IDENT then return
    '' A USER SYMBOL OF THAT NAME IS NOT THE INTRINSIC -- the same guard the string
    '' intrinsics needed, and for the same reason.
    if c.info->RefOf( lp->target ) <> SYMBOL_NONE then return
    dim as InternId nm = _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name
    if c.names->Fold( nm ) <> c.names->Fold( c.names->GetString( "iif" ) ) then return

    dim as TypeId ta = c.info->TypeOf_( cast( NodeId, c.ast->children[lp->first + 1] ) )
    dim as TypeId tb = c.info->TypeOf_( cast( NodeId, c.ast->children[lp->first + 2] ) )
    if (ta = TYPE_NONE) orelse (tb = TYPE_NONE) then return
    dim as TypeId ua = c.types->Unqualify( ta )
    dim as TypeId ub = c.types->Unqualify( tb )
    if ua = ub then return

    dim as boolean bad = false
    if IsStringyType_( c, ua ) <> IsStringyType_( c, ub ) then bad = true
    dim as boolean pa = (c.types->Kind( ua ) = TK_POINTER)
    dim as boolean pb = (c.types->Kind( ub ) = TK_POINTER)
    if pa andalso pb then bad = true
    '' A UDT ARM MUST MEET THE SAME UDT -- fbc error 24. Measured: two DIFFERENT types, a
    '' type and an integer, a type and a pointer, and even a BASE and its DERIVED are all
    '' refused, while two arms of the identical plain type are accepted (the 'ua = ub'
    '' return above).
    ''
    '' NOT MODELLED: fbc also refuses two arms of one type when that type has
    '' CONSTRUCTORS. That is a miss rather than a wrong answer, and guessing at it would
    '' refuse the plain case this measured as accepted.
    if (c.types->Kind( ua ) = TK_UDT) orelse (c.types->Kind( ub ) = TK_UDT) then
        bad = true
    end if
    if bad = false then return
    c.diags->Report( TKO0655, PointRange( c.ast->Loc( id ) ) )
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

private sub CheckBydescArgs_ _
    ( byref c as Ctx, byval id as NodeId, byval here as TypeId )
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
        '' PASSING A UDT BYVAL CALLS ITS COPY CONSTRUCTOR, so a private one is out of
        '' reach at the call site too -- fbc error 205. Only when 'byval' is WRITTEN:
        '' for a UDT the FreeBASIC default is byref, and byref copies nothing.
        if (c.ast->nodes[cast( long, prm )].flags and NF_BYVAL_WRITTEN) <> 0 then
            dim as TypeId ut = c.info->TypeOf_( arg )
            if ut <> TYPE_NONE then
                dim as TypeId uu = c.types->Unqualify( ut )
                if c.types->Kind( uu ) = TK_UDT then
                    CheckCopyStructor_( c, uu, here, c.ast->Loc( arg ), 0 )
                end if
            end if
        end if
        if (c.ast->nodes[cast( long, prm )].flags and NF_ARRAY) = 0 then continue for
        '' 'a( )' IS THE WHOLE-ARRAY SPELLING and is recognised by its SHAPE, not by its
        '' type: an empty subscript list over an array variable types as the ELEMENT
        '' here, so a type test alone refused dim/shared-array-1.bas and -2.bas, which
        '' fbc accepts.
        if WholeArraySpelling_( c, arg ) then
            '' A BYDESC PARAMETER TAKES AN ARRAY OF EXACTLY ITS ELEMENT TYPE -- fbc error
            '' 58, "Type mismatch". Measured: 'a() as P1' given a P2 array is refused, and
            '' so is 'a() as Base' given a DERIVED array -- there is no slicing through a
            '' descriptor. Only two UDT element types are compared; a builtin pair may
            '' convert, and is not measured here.
            dim as ListPayload ptr wl = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, arg )].data )]
            dim as Symbol ptr av = c.syms->SymbolAt( c.info->RefOf( wl->target ) )
            dim as StmtPayload ptr prp = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
            if (av <> 0) andalso (prp->a <> NODE_NONE) then
                dim as TypeId avt = c.types->Unqualify( av->type_ )
                dim as TypeId pel = c.types->Unqualify( c.info->TypeOf_( prp->a ) )
                if (c.types->Kind( avt ) = TK_ARRAY) andalso (pel <> TYPE_NONE) then
                    dim as TypeId ael = c.types->Unqualify( c.types->Inner( avt ) )
                    if (c.types->Kind( ael ) = TK_UDT) andalso _
                       (c.types->Kind( pel ) = TK_UDT) andalso (ael <> pel) then
                        c.diags->Report( TKO0687, PointRange( c.ast->Loc( arg ) ) )
                        return
                    end if
                end if
            end if
            continue for
        end if
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

    '' A DEFAULT THAT NAMES NOTHING -- fbc error 42, "Variable not declared". tiko-lang
    '' does not report an undeclared name anywhere yet; a parameter DEFAULT is a small,
    '' closed context where it can be asked safely, because the only things a default may
    '' legally name are constants and shared variables, and both bind a symbol.
    ''
    '' A BARE IDENT AND NOTHING ELSE. An unresolved CALL may be an intrinsic -- 'iif' and
    '' the string intrinsics bind no symbol either -- and reporting one would refuse files
    '' fbc accepts. A bare name that resolves to nothing has no such excuse.
    if c.ast->Kind( sp->b ) <> N_IDENT then return
    if c.info->RefOf( sp->b ) <> SYMBOL_NONE then return
    '' ...UNLESS IT HAS A TYPE, which means something did resolve it and only this pass
    '' cannot see what.
    if c.info->TypeOf_( sp->b ) <> TYPE_NONE then return
    '' '= any' IS THE KEYWORD, not a name. It means "no initial value" and the parser
    '' leaves it as an ident, so it resolved to nothing and read as undeclared --
    '' warnings/suffix-fb.bas writes it, and fbc compiles that file.
    dim as InternId dnm = _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, sp->b )].data )].name
    if c.names->Fold( dnm ) = c.names->Fold( c.names->GetString( "any" ) ) then return
    c.diags->Report( TKO0675, PointRange( c.ast->Loc( sp->b ) ), _
                     c.names->Spelling( dnm ) )
end sub

'' AN ARRAY IS INDEXED WITH AS MANY SUBSCRIPTS AS IT HAS DIMENSIONS -- fbc error 36,
'' "Wrong number of dimensions". Measured: 'a( 0 )' over 'a( 0 to 1, 0 to 1 )' is refused,
'' and so is a 'redim' that changes the count.
''
'' NONE AT ALL IS THE WHOLE-ARRAY SPELLING and is left alone; a DYNAMIC array records -1
'' for its rank and is not asked, because its shape is whatever the last redim made it.
private sub CheckSubscriptCount_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count = 0 then return
    if lp->target = NODE_NONE then return
    dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
    if ts = 0 then return
    '' A FIELD ARRAY IS THE SAME QUESTION: 'x.arr(0, 0)' over 'arr(any) as integer'.
    if (ts->kind <> cast( ubyte, SYM_VARIABLE )) andalso _
       (ts->kind <> cast( ubyte, SYM_FIELD )) then return
    if ts->type_ = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( ts->type_ )
    if c.types->Kind( u ) <> TK_ARRAY then return
    '' A FIXED-LENGTH STRING is an array of a character builtin, and 's( 0 )' over one is
    '' an ordinary character access rather than a rank mismatch.
    dim as TypeId el = c.types->Unqualify( c.types->Inner( u ) )
    if el <> TYPE_NONE then
        if c.types->Kind( el ) = TK_BUILTIN then
            select case c.types->BuiltinOf( el )
            case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
                return
            end select
        end if
    end if
    dim as long dims = c.types->types[cast( long, u )].dims
    '' A DYNAMIC ARRAY DECLARED WITH 'any' HAS A KNOWN RANK: 'a(any)' is one dimension
    '' and 'a(any, any)' two, recorded as -(rank + 1). Measured: 'a(0, 0)' over 'a(any)'
    '' is fbc error 36 exactly as over a fixed one, and 'a(0)' over 'a(any, any)' too.
    '' Only 'a()' -- rank 0, its shape whatever the last redim made it -- is not asked.
    if dims < 0 then dims = (-dims) - 1
    if dims <= 0 then return
    if lp->count = dims then return
    c.diags->Report( TKO0658, PointRange( c.ast->Loc( id ) ), _
                     c.names->Spelling( ts->name ) )
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

'' WHAT AN ASSIGNMENT MAY NOT WRITE INTO, beyond the bare constant name Resolve already
'' refuses. Measured:
''
''     0 = 1     error 24    a LITERAL has no storage to write into
''
'' NOT THE POINTER HALF. '*cptr( const integer ptr, pi ) = 123' is fbc's error 119 and is
'' still accepted here, because tiko-lang does not yet tell 'const integer ptr' -- a
'' pointer to a CONSTANT -- from 'integer const ptr', a CONSTANT pointer to a writable
'' integer. Both put TF_CONST on the pointee, so testing it refused five files fbc
'' accepts: 'type t as u const ptr' then '*p = 0', which is the const-POINTER spelling and
'' perfectly legal. The two spellings have to become two types before this can be asked.
private sub CheckAssignTarget_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->op = 0 then return
    if sp->a = NODE_NONE then return
    select case c.ast->Kind( sp->a )
    case N_IDENT
        '' 'foo = 1' OVER A BARE ENUM CONSTANT. Resolve refuses a bare CONST but an enum
        '' item reached this far, and the store went into the constant's slot.
        dim as Symbol ptr es = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
        if es = 0 then return
        if es->kind <> cast( ubyte, SYM_ENUMCONST ) then return
        c.diags->Report( TKO0617, PointRange( c.ast->Loc( sp->a ) ), _
                         c.names->Spelling( es->name ) )
    case N_INT_LIT, N_FLOAT_LIT, N_STRING_LIT, N_STRCAT
        c.diags->Report( TKO0652, PointRange( c.ast->Loc( sp->a ) ) )
        return
    case N_MEMBER
        '' 'ns.foo = 1' OVER A NAMESPACE CONSTANT. Resolve refuses the BARE name, which
        '' is all it can see -- a qualified one is not bound until Check -- so the
        '' qualified spelling reached lowering and stored into the constant's slot.
        dim as Symbol ptr ms = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
        if ms = 0 then return
        dim as SymbolKind mk = cast( SymbolKind, ms->kind )
        if (mk <> SYM_CONSTANT) andalso (mk <> SYM_ENUMCONST) then return
        c.diags->Report( TKO0617, PointRange( c.ast->Loc( sp->a ) ), _
                         c.names->Spelling( ms->name ) )
    end select
end sub

'' INSIDE A CONST METHOD, 'this' IS CONST -- so a FIELD CANNOT BE WRITTEN. fbc error 119,
'' the same "Cannot modify a constant" it gives for a named constant.
''
'' MEASURED, and all three spellings of the same write are refused while a READ is not:
''     const sub T.c( ) : i = 4        : end sub    error 119   the BARE field
''     const sub T.c( ) : this.i = 4   : end sub    error 119
''     const sub T.c( ) : with this : .i = 4 : ...  error 119   the WITH shorthand
''     const sub T.c( ) : print i      : end sub    OK
''
'' ONE TEST COVERS ALL THREE, because Check bound every one of them to the same FIELD
'' symbol -- the shape of the reference does not matter, only what it names.
private sub CheckConstThisWrite_ _
    ( byref c as Ctx, byval id as NodeId, byval here as TypeId, _
      byval constMethod as boolean, byval withThis as boolean )

    if constMethod = false then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->op = 0 then return
    if sp->a = NODE_NONE then return
    '' 'this = x' WRITES THE WHOLE OBJECT, which is the same refusal for the same reason
    '' and is fbc error 119 too. It names no field, so the symbol test below misses it.
    if IsThisBase_( c, sp->a ) then
        c.diags->Report( TKO0664, PointRange( c.ast->Loc( sp->a ) ), "this" )
        return
    end if
    '' IT MUST BE THIS OBJECT'S FIELD. 'it.p = ...' inside a const method writes a LOCAL
    '' of another type, which is ordinary and which fbc compiles -- and a test that asked
    '' only "is the target a field" refused it, and with it the whole iterator-protocol
    '' corpus file. Two things are demanded now: the reference is reached through THIS
    '' (bare, written out, or the shorthand inside 'with this'), and the field belongs to
    '' the type the method is a member of.
    dim as boolean throughThis = false
    select case c.ast->Kind( sp->a )
    case N_IDENT
        throughThis = true
    case N_MEMBER
        dim as BinaryPayload ptr amp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, sp->a )].data )]
        if amp->lhs = NODE_NONE then
            throughThis = withThis
        else
            throughThis = IsThisBase_( c, amp->lhs )
        end if
    end select
    if throughThis = false then return

    dim as Symbol ptr fs = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
    if fs = 0 then return
    if fs->kind <> cast( ubyte, SYM_FIELD ) then return
    if OwningType_( c, fs ) <> here then return
    c.diags->Report( TKO0664, PointRange( c.ast->Loc( sp->a ) ), _
                     c.names->Spelling( fs->name ) )
end sub

'' ...AND A NON-CONST METHOD CANNOT BE CALLED FROM ONE -- fbc error 276, "Const UDT cannot
'' invoke non-const method". Calling a method that is ITSELF const is the ordinary case and
'' is accepted, which is what makes this worth checking rather than assuming.
''
'' ONLY A METHOD OF THE ENCLOSING TYPE. A free procedure, or a method reached through some
'' other object, says nothing about THIS -- and refusing either would refuse files fbc
'' accepts. The owner comparison is what limits it.
private sub CheckConstThisCall_ _
    ( byref c as Ctx, byval id as NodeId, byval here as TypeId, _
      byval constMethod as boolean )

    if constMethod = false then return
    if here = TYPE_NONE then return
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->target = NODE_NONE then return

    '' THE CALLEE MUST BE NAMED BARE, or through 'this'. Anything else is another object.
    dim as NodeId callee = lp->target
    select case c.ast->Kind( callee )
    case N_IDENT
    case N_MEMBER
        dim as BinaryPayload ptr mp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, callee )].data )]
        if mp->lhs = NODE_NONE then return
        if IsThisBase_( c, mp->lhs ) = false then return
    case else
        return
    end select

    dim as Symbol ptr ps = c.syms->SymbolAt( c.info->RefOf( callee ) )
    if ps = 0 then return
    if ps->kind <> cast( ubyte, SYM_PROC ) then return
    if OwningType_( c, ps ) <> here then return
    dim as NodeId decl = cast( NodeId, ps->payload )
    if decl = NODE_NONE then return
    if c.ast->Kind( decl ) <> N_PROC then return
    dim as StmtPayload ptr dp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    '' A STATIC METHOD HAS NO 'this' at all, so its constness is not a question.
    if (dp->extra and PF_STATIC) <> 0 then return
    if (dp->extra and PF_CONST) <> 0 then return
    c.diags->Report( TKO0665, PointRange( c.ast->Loc( id ) ), _
                     c.names->Spelling( ps->name ) )
end sub

'' 'x.constructor( )' AND 'x.destructor( )' NAME A STRUCTOR EXPLICITLY -- which is legal
'' only when the type DECLARED one. fbc gives error 18, "Element not defined": the IMPLICIT
'' structor is not a member anything can name.
''
'' MEASURED both ways round, and through a pointer too: with a declared constructor
'' 'x.constructor( )' compiles, without one it does not, and 'p->constructor( )' behaves
'' exactly as the dot does.
private sub CheckExplicitStructor_ ( byref c as Ctx, byval id as NodeId )
    dim as BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    if mp->lhs = NODE_NONE then return
    if mp->rhs = NODE_NONE then return
    if c.ast->Kind( mp->rhs ) <> N_IDENT then return
    dim as string nm = c.names->Spelling( _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, mp->rhs )].data )].name )
    dim as string want = ""
    if nm = "constructor" then want = "__ctor"
    if nm = "destructor" then want = "__dtor"
    if len( want ) = 0 then return

    '' THE OBJECT'S TYPE, WITH POINTERS UNWRAPPED, because 'p->destructor( )' is the same
    '' question as 'x.destructor( )' and fbc answers it the same way.
    dim as TypeId ot = c.info->TypeOf_( mp->lhs )
    if ot = TYPE_NONE then return
    dim as long guard = 0
    while (c.types->Kind( c.types->Unqualify( ot ) ) = TK_POINTER) andalso (guard < 16)
        guard += 1
        ot = c.types->Inner( c.types->Unqualify( ot ) )
    wend
    ot = c.types->Unqualify( ot )
    if c.types->Kind( ot ) <> TK_UDT then return
    if StructorOf_( c, ot, want ) <> 0 then return
    c.diags->Report( TKO0666, PointRange( c.ast->Loc( mp->rhs ) ), nm )
end sub

'' A POINTER AND A FLOAT DO NOT CONVERT INTO EACH OTHER -- fbc error 181, "Invalid
'' assignment/conversion", in BOTH directions. An INTEGER does, which is what makes this a
'' rule about the float rather than about the pointer.
''
'' MEASURED:
''     dim p as byte ptr : dim f as single
''     f = p      error 181        n = p      OK    (n as integer)
''     p = f      error 181        p = 1      OK
''     p = 1.0    error 181        f = cast( single, cast( integer, p ) )   OK
private sub PtrFloatPair_ _
    ( byref c as Ctx, byval at as NodeId, byval lt as TypeId, byval rt as TypeId )

    if (lt = TYPE_NONE) orelse (rt = TYPE_NONE) then return
    dim as TypeId lu = c.types->Unqualify( lt )
    dim as TypeId ru = c.types->Unqualify( rt )

    dim as boolean lPtr = (c.types->Kind( lu ) = TK_POINTER)
    dim as boolean rPtr = (c.types->Kind( ru ) = TK_POINTER)
    dim as boolean lFlt = false
    dim as boolean rFlt = false
    if c.types->Kind( lu ) = TK_BUILTIN then
        select case c.types->BuiltinOf( lu )
        case TY_SINGLE, TY_DOUBLE : lFlt = true
        end select
    end if
    if c.types->Kind( ru ) = TK_BUILTIN then
        select case c.types->BuiltinOf( ru )
        case TY_SINGLE, TY_DOUBLE : rFlt = true
        end select
    end if

    dim as boolean bad = (lPtr andalso rFlt) orelse (lFlt andalso rPtr)
    if bad = false then return
    c.diags->Report( TKO0670, PointRange( c.ast->Loc( at ) ) )
end sub

#include once "symbols/assigncheck.bas"

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

#include once "symbols/proccheck.bas"

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
private sub CheckDelete_ ( byref c as Ctx, byval id as NodeId, byval here as TypeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->a = NODE_NONE then return
    dim as TypeId t = c.info->TypeOf_( sp->a )
    '' UNTYPED IS NOT AN ERROR: something earlier declined, and reporting would blame
    '' the wrong line.
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> TK_POINTER then
        c.diags->Report( TKO0629, PointRange( c.ast->Loc( sp->a ) ) )
        return
    end if
    '' 'delete p' CALLS THE POINTEE'S DESTRUCTOR, so a private one is out of reach here
    '' exactly as it is at a declaration.
    dim as TypeId pointee = c.types->Unqualify( c.types->Inner( u ) )
    if pointee = TYPE_NONE then return
    if c.types->Kind( pointee ) <> TK_UDT then return
    '' THE ENCLOSING TYPE, carried down by the walk: a private destructor is perfectly
    '' reachable from inside its own type, and passing TYPE_NONE here refused three
    '' files fbc accepts -- the '*-dtor-*-usage' trio, which delete from a method.
    CheckOneStructor_( c, pointee, "__dtor", here, c.ast->Loc( id ), 0 )
end sub

'' A DEFINITION MUST REPEAT THE DECLARATION'S 'byref' -- fbc error 20, "Type mismatch",
'' and it is symmetric: declaring BYREF and defining byval is refused, and so is the
'' reverse. Measured both ways, with 'both BYREF' accepted.
''
'' The symbol's payload is the DECLARATION node -- a definition joins its declare rather
'' than chaining beside it -- so the two nodes are both to hand here and nowhere else.
private sub CheckByrefResultAgrees_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return
    dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
    if s = 0 then return
    dim as NodeId decl = cast( NodeId, s->payload )
    if decl = NODE_NONE then return
    if decl = id then return
    if c.ast->Kind( decl ) <> N_PROC then return
    dim as ushort a2 = cast( ushort, c.ast->nodes[cast( long, decl )].flags and NF_BYREF )
    dim as ushort b2 = cast( ushort, c.ast->nodes[cast( long, id )].flags and NF_BYREF )
    if a2 = b2 then return
    c.diags->Report( TKO0651, PointRange( c.ast->Loc( id ) ), _
                     c.names->Spelling( sp->name ) )
end sub

'' A BYREF RESULT MUST BE ASSIGNED SOMETHING OF EXACTLY ITS TYPE -- fbc error 318, "Type
'' mismatch in byref function result assignment". A byref result hands back the storage
'' itself, so there is nowhere for a conversion to happen.
''
'' EXACTLY is the word. Measured, against 'function f( ) byref as integer':
''     static i as integer          OK
''     static i as double           error 318
''     static i as long             error 318   -- the SAME SIZE, and still refused
''     static i as const integer    error 318   -- the qualifier counts
''     ...and 'byref as const integer' takes the const one, so it is identity, not width.
private sub CheckByrefResultType_ _
    ( byref c as Ctx, byval id as NodeId, byval byrefResult as boolean, _
      byval resultType as TypeId )

    if byrefResult = false then return
    if c.info->AmbiguousOf( id ) <> AMB_RESULT then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return
    '' ONLY WHAT WAS MEASURED: a NAMED variable of a non-string scalar builtin, on both
    '' sides. The corpus scan reported no false rejection, and this suite's own MIR tests
    '' then found four -- every one of them a STRING:
    ''
    ''     operator U.cast( ) byref as const zstring : operator = this._data
    ''         'zstring * N' is an ARRAY of TY_ZSTRING, never identical to plain zstring
    ''     function refZ( ) byref as zstring : function = "also good"
    ''         a LITERAL, and fbc takes it
    ''     function refI( ) byref as integer : function = byval pi
    ''         not a name at all
    ''
    '' fbc's real rule here is wider than identity for those shapes and this pass cannot
    '' model it, so they are declined rather than guessed at. A CLEAN CORPUS SCAN IS NOT
    '' PROOF: 1222 files said nothing about any of the four.
    if c.ast->Kind( sp->b ) <> N_IDENT then return
    dim as TypeId rt = resultType
    dim as TypeId vt = c.info->TypeOf_( sp->b )
    if (rt = TYPE_NONE) orelse (vt = TYPE_NONE) then return
    if rt = vt then return
    '' A REFERENCE ON EITHER SIDE IS THE SAME TYPE. A byref parameter's type is spelled
    '' as one, and returning it is the ordinary way to pass storage through.
    if c.types->Kind( rt ) = TK_REFERENCE then rt = c.types->Inner( rt )
    if c.types->Kind( vt ) = TK_REFERENCE then vt = c.types->Inner( vt )
    if rt = vt then return

    '' CONST GOES ONE WAY ONLY, and the two directions are not symmetric -- measured:
    ''     byref as integer       <- const integer     error 318   dropping it
    ''     byref as const integer <- integer           OK          adding it
    '' So the unqualified types must be identical, and a const value additionally
    '' demands a const result. Comparing the qualified ids outright refused the second
    '' line, which is a file fbc accepts.
    '' Both sides a NON-STRING scalar builtin -- see the header.
    if c.types->Kind( c.types->Unqualify( rt ) ) <> TK_BUILTIN then return
    if c.types->Kind( c.types->Unqualify( vt ) ) <> TK_BUILTIN then return
    select case c.types->BuiltinOf( c.types->Unqualify( rt ) )
    case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        return
    end select
    select case c.types->BuiltinOf( c.types->Unqualify( vt ) )
    case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        return
    end select

    dim as boolean valueConst = c.types->IsConst( vt )
    dim as boolean resConst = c.types->IsConst( rt )
    if c.types->Unqualify( rt ) <> c.types->Unqualify( vt ) then
        c.diags->Report( TKO0667, PointRange( c.ast->Loc( sp->b ) ) )
        return
    end if
    if valueConst andalso (resConst = false) then
        c.diags->Report( TKO0667, PointRange( c.ast->Loc( sp->b ) ) )
    end if
end sub

'' A BYREF RESULT CANNOT RETURN A LOCAL -- fbc error 272, "Local symbols can't be
'' referenced". The caller is handed a reference, and the frame it points into is gone by
'' the time it is read. Measured, all three shapes:
''
''     function = x.i           x a local UDT              error 272
''     function = array( i )    array a local array        error 272
''     function = f1( )         a call's RESULT is a temp  error 272
''     function = g             g SHARED                   OK
''
'' THE BASE OF THE CHAIN IS WHAT MATTERS: 'x.i' is local because x is, and 'array( i )'
'' because array is. So the walk goes down to the head of the member and index chain, and
'' a CALL is refused outright unless it returns byref itself.
private sub CheckByrefResultValue_ _
    ( byref c as Ctx, byval id as NodeId, byval byrefResult as boolean )

    if byrefResult = false then return
    if c.info->AmbiguousOf( id ) <> AMB_RESULT then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return

    '' Down to the head of the chain.
    dim as NodeId head = sp->b
    dim as long guard = 0
    while guard < 64
        guard += 1
        dim as NodeKind hk = c.ast->Kind( head )
        if hk = N_MEMBER then
            head = c.ast->binaries[cast( long, c.ast->nodes[cast( long, head )].data )].lhs
        elseif hk = N_CALL then
            '' AN ARRAY SUBSCRIPT IS SPELLED LIKE A CALL. 'x.a(0)' over a FIELD array
            '' stopped the walk here: the branch below resolved the target 'x.a' to a
            '' SYM_FIELD, which is neither a proc nor a variable, and the statement was
            '' let through. Descending into the target continues to 'x' -- which is the
            '' local the rule is about. A real CALL still stops, and is judged below.
            dim as ListPayload ptr cl = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, head )].data )]
            dim as Symbol ptr cts = c.syms->SymbolAt( c.info->RefOf( cl->target ) )
            if cts = 0 then exit while
            if cts->kind <> cast( ubyte, SYM_FIELD ) then exit while
            head = cl->target
        elseif (hk = N_INDEX) orelse (hk = N_PAREN) then
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, head )].data )]
            if hk = N_PAREN then
                if lp->count <> 1 then exit while
                head = cast( NodeId, c.ast->children[lp->first] )
            else
                head = lp->target
            end if
        else
            exit while
        end if
    wend
    if head = NODE_NONE then return

    if c.ast->Kind( head ) = N_CALL then
        '' A CALL's result is a temporary -- unless the callee returns BYREF, in which
        '' case what comes back is already somebody else's storage.
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, head )].data )]
        dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
        if ts = 0 then return
        if ts->kind <> cast( ubyte, SYM_PROC ) then
            '' An INDEXING expression, not a call: fall through to the variable test.
            if ts->kind <> cast( ubyte, SYM_VARIABLE ) then return
            if (ts->flags and (SYMF_SHARED or SYMF_STATIC or SYMF_EXTERN or _
                               SYMF_COMMON)) <> 0 then return
            c.diags->Report( TKO0650, PointRange( c.ast->Loc( sp->b ) ) )
            return
        end if
        dim as NodeId cd = cast( NodeId, ts->payload )
        if (cd <> NODE_NONE) andalso (c.ast->Kind( cd ) = N_PROC) then
            if (c.ast->nodes[cast( long, cd )].flags and NF_BYREF) <> 0 then return
        end if
        c.diags->Report( TKO0650, PointRange( c.ast->Loc( sp->b ) ) )
        return
    end if

    if c.ast->Kind( head ) <> N_IDENT then return
    dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( head ) )
    if s = 0 then return
    if s->kind <> cast( ubyte, SYM_VARIABLE ) then return
    if (s->flags and (SYMF_SHARED or SYMF_STATIC or SYMF_EXTERN or _
                      SYMF_COMMON)) <> 0 then return
    c.diags->Report( TKO0650, PointRange( c.ast->Loc( sp->b ) ), _
                     c.names->Spelling( s->name ) )
end sub

private sub Walk_ _
    ( byref c as Ctx, byval id as NodeId, byval here as TypeId, _
      byval byrefResult as boolean = false, byval constMethod as boolean = false, _
      byval withThis as boolean = false, byval resultType as TypeId = TYPE_NONE )
    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    dim as TypeId inner = here
    dim as boolean innerByref = byrefResult
    '' INSIDE A CONST METHOD 'this' IS CONST, and everything that follows from that --
    '' a field cannot be written and a non-const method cannot be called -- is asked of
    '' the STATEMENTS, not of the declaration. So it is carried down, the same way the
    '' byref result is, rather than looked up again at each site.
    dim as boolean innerConst = constMethod
    '' 'with this : .f = 1 : end with' -- THE SHORTHAND NAMES NO BASE, so whether '.f' is
    '' a write through THIS depends on what the enclosing 'with' opened. Carried down for
    '' the same reason the constness is: the answer is not in the node.
    dim as boolean innerWith = withThis
    '' THE DECLARED RESULT TYPE, carried down because 'function = expr' names no symbol
    '' -- Check leaves the N_FUNCRESULT untyped, so the only handle on what the result
    '' was declared as is the procedure node the walk came through.
    dim as TypeId innerResult = resultType
    if k = N_WITH then
        dim as StmtPayload ptr wp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
        innerWith = IsThisBase_( c, wp->a )
    end if
    if k = N_PROC then innerWith = false
    if k = N_PROC then
        dim as StmtPayload ptr rpp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
        innerResult = c.info->TypeOf_( rpp->a )
    end if
    if k = N_PROC then
        inner = ProcOwner_( c, id )
        '' THE 'const' IS ON THE DECLARATION, NOT ON THE BODY. 'declare const sub proc3( )'
        '' inside the type, then 'sub T.proc3( )' outside it -- the definition does not
        '' repeat the word, so reading the body's own node found nothing and every const
        '' method looked ordinary. Resolve bound the definition to its declaration; that
        '' symbol's declaration node is the one that carries the modifier.
        dim as StmtPayload ptr cpp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
        innerConst = ((cpp->extra and PF_CONST) <> 0)
        if innerConst = false then
            dim as Symbol ptr dsym = c.syms->SymbolAt( c.info->RefOf( id ) )
            if dsym <> 0 then
                dim as NodeId ddecl = cast( NodeId, dsym->payload )
                if (ddecl <> NODE_NONE) andalso (ddecl <> id) then
                    if c.ast->Kind( ddecl ) = N_PROC then
                        dim as StmtPayload ptr dpp = _
                            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, ddecl )].data )]
                        innerConst = ((dpp->extra and PF_CONST) <> 0)
                    end if
                end if
            end if
        end if
        '' A BYREF RESULT changes what its body may return, and the flag is on the
        '' PROCEDURE node -- so it is carried down rather than looked up at each return.
        innerByref = ((c.ast->nodes[cast( long, id )].flags and NF_BYREF) <> 0)
    end if
    if k = N_AMBIGUOUS then CheckByrefResultValue_( c, id, innerByref )
    if k = N_AMBIGUOUS then CheckByrefResultType_( c, id, innerByref, innerResult )
    if k = N_MEMBER then CheckMember_( c, id, here )
    '' ...AND THE MEMBER NAMED WITHOUT A QUALIFIER. Inside a DERIVED type's method the
    '' bare name resolves to the base's member, and fbc refuses a private one with the
    '' same error 202 it gives for 'x.privateThing'. Eleven corpus files write it -- a
    '' constant, a static member variable, a field, a method and a static method, which
    '' are one rule here because CheckMember_ asks the question OF THE SYMBOL Check bound
    '' rather than of the syntax.
    ''
    '' THE IDENT AND NOTHING ELSE. Hooking N_CALL as well reported the same access twice,
    '' once for the call and once for the callee that names it. The operator-invoking
    '' shapes in this corpus directory -- 'n = t' through 'operator cast', 'delete p',
    '' 'for x as T', 'x += 1' -- bind no symbol onto their node at all, so hooking those
    '' kinds bought nothing and only widened what could go wrong.
    if k = N_IDENT then CheckMember_( c, id, here )
    if k = N_DELETE_STMT then CheckDelete_( c, id, here )
    if k = N_MEMBER then CheckDeref_( c, id )
    if k = N_BINARY then CheckProcPtrArith_( c, id )
    if k = N_AMBIGUOUS then CheckConcatAssign_( c, id )
    if k = N_AMBIGUOUS then CheckAssignTarget_( c, id )
    if k = N_AMBIGUOUS then CheckPtrFloatAssign_( c, id )
    if k = N_AMBIGUOUS then CheckPtrAssign_( c, id )
    if k = N_AMBIGUOUS then CheckConstUdtField_( c, id )
    if k = N_VAR_ITEM then CheckPtrFloatInit_( c, id )
    if k = N_VAR_ITEM then CheckPtrInit_( c, id )
    if k = N_AMBIGUOUS then CheckConstThisWrite_( c, id, here, innerConst, innerWith )
    if k = N_CALL then CheckConstThisCall_( c, id, here, innerConst )
    if k = N_MEMBER then CheckExplicitStructor_( c, id )
    if (k = N_CALL) orelse (k = N_INDEX) then CheckArraySubscript_( c, id )
    if (k = N_CALL) orelse (k = N_INDEX) then CheckSubscriptCount_( c, id )
    if k = N_PARAM then CheckParamDefault_( c, id )
    if k = N_CALL then CheckBydescArgs_( c, id, here )
    if k = N_CALL then CheckArgConversions_( c, id )
    if k = N_CALL then CheckBaseInitCount_( c, id, here )
    if k = N_CALL then CheckIifArms_( c, id )
    if k = N_INTRINSIC then CheckSwapOperands_( c, id )
    if k = N_PROC then CheckAbstractBody_( c, id )
    if k = N_PROC then CheckByrefResultAgrees_( c, id )
    if k = N_PROC then CheckModifierAgrees_( c, id )
    if k = N_PROC then CheckMemberOnlyOperator_( c, id )
    if k = N_BINARY then CheckBareArrayOperands_( c, id )
    if k = N_INTRINSIC then CheckBareArrayPrint_( c, id )
    if k = N_DEREF then CheckProcPtrDeref_( c, id )
    if k = N_INDEX then CheckIndexNeedsPointer_( c, id )

    '' EVERY SHAPE OF CHILD LIST, because a member access hides under all of them. The
    '' arena stores three, and a walk that knew only about statements missed every
    '' expression -- which is where member accesses actually live.
    select case NodeKindCategory( k )
    case NCAT_EXPR
        select case k
        case N_BINARY
            dim as BinaryPayload ptr bp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
            Walk_( c, bp->lhs, inner, innerByref, innerConst, innerWith, innerResult )
            Walk_( c, bp->rhs, inner, innerByref, innerConst, innerWith, innerResult )
            return
        case N_MEMBER
            dim as BinaryPayload ptr mp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
            '' ONLY THE BASE. The right-hand side is the member NAME, and Check bound it
            '' to the same symbol -- walking it would report the same access twice.
            Walk_( c, mp->lhs, inner, innerByref, innerConst, innerWith, innerResult )
            return
        case N_UNARY, N_ADDROF, N_DEREF
            dim as UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
            Walk_( c, up->operand, inner, innerByref, innerConst, innerWith, innerResult )
            return
        '' THE LIST KINDS, SPELLED OUT. 'data' is an index into ONE OF FOUR POOLS and
        '' the node kind is the only thing that says which -- the payload-pool mistake
        '' this codebase has now made eight times. Reading a CAST or a SIZEOF as a list
        '' indexed the list pool with a unary's offset and took the compiler down with
        '' an access violation, in 23 tests at once.
        case N_CALL, N_INDEX, N_PAREN, N_TUPLE, N_INITIALIZER, N_STRCAT
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
            Walk_( c, lp->target, inner, innerByref, innerConst, innerWith, innerResult )
            for i as long = 0 to lp->count - 1
                Walk_( c, cast( NodeId, c.ast->children[lp->first + i] ), inner, innerByref, innerConst, innerWith, innerResult )
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
            Walk_( c, cast( NodeId, c.ast->children[lp->first + i] ), inner, innerByref, innerConst, innerWith, innerResult )
        next
        return
    end if

    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    Walk_( c, sp->a, inner, innerByref, innerConst, innerWith, innerResult )
    Walk_( c, sp->b, inner, innerByref, innerConst, innerWith, innerResult )
    Walk_( c, sp->c, inner, innerByref, innerConst, innerWith, innerResult )
    for i as long = 0 to sp->count - 1
        Walk_( c, cast( NodeId, c.ast->children[sp->first + i] ), inner, innerByref, innerConst, innerWith, innerResult )
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

'' ...AND THE DECLARATIONS THE SYMBOL SWEEP CANNOT SEE. CheckStaticStringInits walks the
'' SYMBOL table and reads the initialiser off the symbol's own declaration item -- which
'' is the FIRST declaration of that name. Two shapes hang the initialiser somewhere else:
''
''     extern s as string        the symbol's item is the EXTERN, which has no initialiser
''     dim s as string = "foo"   ...and this one, which does, is not the symbol's item
''
''     type UDT : static s as string : end type    likewise: the symbol's item is inside
''     var UDT.s = "foo"                           the type, and the DEFINITION is here
''
'' So this sweeps the AST instead, and reports only when the item is NOT the symbol's own
'' -- otherwise every ordinary static string initialiser would be reported twice.
''
'' A QUALIFIED NAME IS ALWAYS STATIC STORAGE: it defines a type's static member or a
'' namespace's variable, and neither is a local.
private sub CheckQualifiedStringInits_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if ip->b = NODE_NONE then continue for

        '' A VAR-LEN STRING, whether written out or inferred from the initialiser.
        dim as TypeId t = TYPE_NONE
        if ip->a <> NODE_NONE then
            t = c.info->TypeOf_( ip->a )
        else
            t = c.info->TypeOf_( ip->b )
        end if
        if t = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( t )
        if c.types->Kind( u ) <> TK_BUILTIN then continue for
        if c.types->BuiltinOf( u ) <> TY_STRING then continue for

        dim as boolean qualified = _
            ((c.ast->nodes[n].flags and NF_QUALIFIED) <> 0)
        dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
        if qualified = false then
            if s = 0 then continue for
            '' NOT THE SYMBOL'S OWN ITEM -- see above; that one is already reported.
            if cast( NodeId, s->payload ) = id then continue for
            if (s->flags and (SYMF_SHARED or SYMF_STATIC or SYMF_EXTERN)) = 0 then
                if ScopeIsStatic_( c, s->parent ) = false then continue for
            end if
        else
            if s <> 0 then
                if cast( NodeId, s->payload ) = id then continue for
            end if
        end if
        c.diags->Report( TKO0628, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( ip->name ) )
    next
end sub

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
    CheckQualifiedStringInits_( c )
    CheckImplicitStructors_( c )
    CheckFixLenParams_( c )
    CheckNestedStatics_( c )
    CheckSharedInits_( c )
    CheckQualifiedInits_( c )
    CheckOutsideNamespace_( c )
    CheckConstBounds_( c )
    CheckReturnStyles_( c )
    CheckDuplicateOverloads_( c )
    CheckBitfieldWidths_( c )
    CheckArrayDeclShapes_( c )
    CheckRedimRank_( c )
    CheckByrefBinding_( c )
    CheckConstDeclTypes_( c )
    CheckBaseHasDefaultCtor_( c )
    CheckPrivateBaseStructor_( c )
    CheckExternInitAndDefaultCtor_( c )
    CheckDynArrayInUnion_( c )
    CheckVirtualNeedsObject_( c )
end sub


end namespace
