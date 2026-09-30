'' abstractcheck.bas -- AN ABSTRACT TYPE CANNOT BE INSTANTIATED.
''
'' fbc error 306, "UDT has unimplemented abstract methods". A type is ABSTRACT when it
'' declares an abstract method and nothing has implemented it -- and that is exactly what
'' the vtable already knows: an ABSTRACT SLOT IS NULL, and an override fills it. So this
'' asks no question of its own; it runs after ComputeVTables and looks for a null slot.
''
'' That is what makes the three shapes fall out together, which a "does this type declare
'' 'abstract'" test gets wrong:
''
''     type A extends object : declare abstract sub f1( ) : end type
''     dim x as A                                             DIRECT
''     type B extends A : end type       : dim x as B         INHERITED  -- B declares none
''     type B extends A : declare sub f1( ) ...               PARTIAL    -- one of two
''
'' WHERE IT IS REPORTED. Over the SYMBOL TABLE rather than the AST, because every site
'' that matters is a symbol with a type on it: a variable, a field and a procedure's
'' return type. Measured, all three are fbc errors. Parameters need a second pass over the
'' AST -- see below. NOT COVERED: 'new A', 'type<A>( )' and 'A( )'. Each names its type in
'' an EXPRESSION, where no symbol carries it, and fbc refuses all three.
''
'' A POINTER OR REFERENCE TO AN ABSTRACT TYPE IS THE WHOLE POINT of one, so only the type
'' itself counts: 'dim p as A ptr' and 'byref x as A' are both accepted by fbc, and a
'' check that unwrapped pointers would refuse the only way an abstract type is ever used.

#include once "types/vtable.bi"
#include once "diag/diagids.bi"

namespace Tko

private function AbstractSlot_ _
    ( byref types as TypeContext, byref store as VTables, _
      byval t as TypeId ) as boolean

    dim as long vi = store.Find( t )
    if vi < 0 then return false
    dim as VtInfo ptr v = @store.types_[vi]
    for i as long = 0 to v->count - 1
        dim as VtSlot ptr sl = @store.slots[v->first + i]
        if sl->proc_ = SYMBOL_NONE then return true
    next
    return false
end function

'' The declared type as written, with NO unwrapping: see the header.
private function AbstractHere_ _
    ( byref types as TypeContext, byref store as VTables, _
      byval t as TypeId ) as boolean

    if t = TYPE_NONE then return false
    dim as TypeId u = types.Unqualify( t )
    '' An ARRAY of an abstract type is as impossible as one of them, and fbc says so.
    dim as long guard = 0
    while (types.Kind( u ) = TK_ARRAY) andalso (guard < 16)
        guard += 1
        u = types.Unqualify( types.Inner( u ) )
    wend
    if types.Kind( u ) <> TK_UDT then return false
    return AbstractSlot_( types, store, u )
end function

sub CheckAbstractInstances _
    ( byref ast as AstArena, byref syms as SymbolTable, byref types as TypeContext, _
      byref info as SemanticInfo, byref store as VTables, byref names as Interner, _
      byref diags as DiagnosticEngine )

    for i as long = 0 to syms.symbols.Count - 1
        dim as Symbol ptr s = @syms.symbols[i]
        dim as SymbolKind k = cast( SymbolKind, s->kind )
        dim as boolean holdsOne = (k = SYM_VARIABLE) orelse (k = SYM_FIELD)
        '' A PROCEDURE'S TYPE IS ITS RETURN TYPE, and returning an abstract type BY VALUE
        '' is the same impossibility as declaring one.
        ''
        '' A PARAMETER IS NOT REACHED FROM HERE. Its 'payload' is the PARAMETER INDEX,
        '' not a node -- the same payload-pool rule the rest of this compiler keeps
        '' tripping over -- so there is no declaration to read a modifier off. The AST
        '' pass below handles it instead.
        if (holdsOne = false) andalso (k <> SYM_PROC) then continue for
        '' THE 'base' FIELD IS THE EXTENDS, not an instantiation. A type that inherits an
        '' unimplemented abstract IS ITSELF ABSTRACT, and refusing its base field
        '' reported the derivation as well as every use of it -- two errors where fbc
        '' has one, on the line of the 'type' rather than the 'dim'.
        if (k = SYM_FIELD) andalso (s->name = store.baseName) then continue for
        '' A BYREF parameter is a reference, and a reference to an abstract type is
        '' legal -- it is how one is passed at all.
        '' 'function f( ) BYREF as A' RETURNS A REFERENCE, which is legal and is how an
        '' abstract type is used at all -- virtual.bas and fb/comptr.bi both write it.
        '' The byref-ness is on the DECLARATION NODE (NF_BYREF), not on the symbol and
        '' not as a TK_REFERENCE on its type, so neither a flag test nor unwrapping the
        '' type would have found it.
        if k = SYM_PROC then
            dim as NodeId decl = cast( NodeId, s->payload )
            if decl = NODE_NONE then continue for
            if ast.Kind( decl ) <> N_PROC then continue for
            if (ast.nodes[cast( long, decl )].flags and NF_BYREF) <> 0 then continue for
        end if
        if AbstractHere_( types, store, s->type_ ) = false then continue for
        diags.Report( TKO0620, PointRange( s->loc ), names.Spelling( s->name ) )
    next

    '' AND THE PARAMETERS, over the AST, because a parameter's symbol carries its INDEX
    '' where a variable carries its declaration.
    ''
    '' ONLY WHEN IT WRITES 'byval'. For a UDT the FreeBASIC default is BYREF, and passing
    '' an abstract type by reference is the ordinary way to pass one -- so the test is on
    '' NF_BYVAL_WRITTEN, which the parser records for exactly this reason: the absence of
    '' NF_BYREF does not mean byval.
    for n as long = 0 to ast.Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if ast.Kind( id ) <> N_PARAM then continue for
        if (ast.nodes[n].flags and NF_BYVAL_WRITTEN) = 0 then continue for
        '' THE TYPEREF'S OWN TYPE, not the parameter symbol's. A parameter binds no
        '' symbol back onto its node, and its symbol's payload is an index -- the
        '' typeref is the only handle on what was written.
        dim as StmtPayload ptr pp = _
            @ast.stmts[cast( long, ast.nodes[n].data )]
        if AbstractHere_( types, store, info.TypeOf_( pp->a ) ) = false then continue for
        diags.Report( TKO0620, PointRange( ast.Loc( id ) ), names.Spelling( pp->name ) )
    next

    '' ...AND THE EXPRESSIONS THAT NAME A TYPE WITHOUT DECLARING ANYTHING. The header
    '' listed these as not covered; they are now. 'new A' and 'type<A>( )' each build a
    '' VALUE of the named type, and fbc refuses both for the same reason it refuses
    '' 'dim x as A' -- there is nothing to put in the null slot.
    ''
    '' BOTH ARE LIST NODES WITH A 'target', and the target is the TYPEREF -- which is the
    '' handle wanted here. An N_NEW's own type is 'A ptr', and a pointer to an abstract
    '' type is legal, so reading the node's type instead would have found nothing.
    ''
    '' PLACEMENT NEW IS THE SAME NODE and the same rule: 'new( buf ) A' still constructs
    '' an A, it only chooses where.
    for n as long = 0 to ast.Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        dim as NodeKind nk = ast.Kind( id )
        dim as boolean builds = (nk = N_NEW)
        if nk = N_TUPLE then
            builds = ((ast.nodes[n].flags and NF_TYPE_LITERAL) <> 0)
        end if
        if builds = false then continue for
        dim as ListPayload ptr lp = @ast.lists[cast( long, ast.nodes[n].data )]
        '' A BARE 'type( )' NAMES NO TYPE. It takes one from the parameter it is being
        '' passed to, so the only handle is the type Check gave the node itself --
        '' 'foo( type( ) )' over a 'byref x as A' is still constructing an A.
        dim as TypeId tt
        if lp->target = NODE_NONE then
            if nk <> N_TUPLE then continue for
            tt = info.TypeOf_( id )
        else
            tt = info.TypeOf_( lp->target )
        end if
        if AbstractHere_( types, store, tt ) = false then continue for
        diags.Report( TKO0620, PointRange( ast.Loc( id ) ), _
                      names.Spelling( types.NameOf( types.Unqualify( tt ) ) ) )
    next

    '' ...AND A BARE 'type( )' PASSED TO A PARAMETER, whose type Check did not give the node:
    '' 'foo( type( ) )' over 'byref x as A' constructs an A (virtual/abstract-object-11,
    '' fbc's 306). The parameter's own type reference answers it.
    for n as long = 0 to ast.Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if ast.Kind( id ) <> N_CALL then continue for
        dim as ListPayload ptr cp = @ast.lists[cast( long, ast.nodes[n].data )]
        if cp->target = NODE_NONE then continue for
        dim as Symbol ptr ps = syms.SymbolAt( info.RefOf( id ) )
        if ps = 0 then ps = syms.SymbolAt( info.RefOf( cp->target ) )
        if (ps = 0) orelse (ps->kind <> cast( ubyte, SYM_PROC )) then continue for
        dim as NodeId pd = cast( NodeId, ps->payload )
        if (pd = NODE_NONE) orelse (ast.Kind( pd ) <> N_PROC) then continue for
        dim as StmtPayload ptr pdp = @ast.stmts[cast( long, ast.nodes[cast( long, pd )].data )]
        dim as long ai = 0
        for pi_ as long = 0 to pdp->count - 1
            dim as NodeId pn = cast( NodeId, ast.children[pdp->first + pi_] )
            if (pn = NODE_NONE) orelse (ast.Kind( pn ) <> N_PARAM) then continue for
            if ai >= cp->count then exit for
            dim as NodeId arg = cast( NodeId, ast.children[cp->first + ai] )
            ai += 1
            if (arg = NODE_NONE) orelse (ast.Kind( arg ) <> N_TUPLE) then continue for
            if (ast.nodes[cast( long, arg )].flags and NF_TYPE_LITERAL) = 0 then continue for
            if ast.lists[cast( long, ast.nodes[cast( long, arg )].data )].target <> NODE_NONE then continue for
            if info.TypeOf_( arg ) <> TYPE_NONE then continue for
            dim as NodeId pta = ast.stmts[cast( long, ast.nodes[cast( long, pn )].data )].a
            if pta = NODE_NONE then continue for
            dim as TypeId pt = types.Unqualify( info.TypeOf_( pta ) )
            if types.Kind( pt ) = TK_REFERENCE then pt = types.Unqualify( types.Inner( pt ) )
            if AbstractHere_( types, store, pt ) = false then continue for
            diags.Report( TKO0620, PointRange( ast.Loc( arg ) ), names.Spelling( types.NameOf( pt ) ) )
        next
    next

    '' 'A( )' -- A CONSTRUCTED TEMPORARY, which is an ordinary CALL node whose callee
    '' happens to name a TYPE rather than a procedure. Its own type is the A, so unlike
    '' 'new A' the node carries what is wanted directly.
    ''
    '' THE CALLEE MUST RESOLVE TO A UDT SYMBOL. A function RETURNING an abstract type by
    '' reference is legal and is how one is used at all, so a test on the call's type
    '' alone would have refused every such call.
    for n as long = 0 to ast.Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if ast.Kind( id ) <> N_CALL then continue for
        dim as ListPayload ptr cp = @ast.lists[cast( long, ast.nodes[n].data )]
        if cp->target = NODE_NONE then continue for
        dim as Symbol ptr cs = syms.SymbolAt( info.RefOf( cp->target ) )
        if cs = 0 then continue for
        '' ...OR TO A TYPEDEF FOR ONE. 'type A2 as A : A2( )' constructs the same A,
        '' and fbc refuses it on the same line number.
        dim as boolean namesType = _
            (cs->kind = cast( ubyte, SYM_UDT )) orelse _
            (cs->kind = cast( ubyte, SYM_TYPEDEF ))
        if namesType = false then continue for
        dim as TypeId ct = info.TypeOf_( id )
        if AbstractHere_( types, store, ct ) = false then continue for
        diags.Report( TKO0620, PointRange( ast.Loc( id ) ), _
                      names.Spelling( types.NameOf( types.Unqualify( ct ) ) ) )
    next
end sub

'' 'override' IS A PROMISE -- fbc error 223, "Not overriding any virtual method".
''
'' Checked against what the builder already worked out: 'overrode' holds every
'' declaration that FILLED an inherited slot, so a declaration that says 'override' and is
'' not in it overrode nothing. The parser used to consume the word with the rest of the
'' trailing modifiers, so a broken promise said nothing at all.
''
'' fbc raises 223 for four different reasons that all come out the same way here: the name
'' matches nothing, the PARAMETERS differ so the match fails, the base method is not
'' virtual, or the type has no base at all.
sub CheckOverridePromise _
    ( byref ast as AstArena, byref store as VTables, byref names as Interner, _
      byref diags as DiagnosticEngine )

    for n as long = 0 to ast.Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if ast.Kind( id ) <> N_PROC then continue for
        dim as StmtPayload ptr sp = @ast.stmts[cast( long, ast.nodes[n].data )]
        if (sp->extra and PF_OVERRIDE) = 0 then continue for
        dim as boolean found = false
        for i as long = 0 to store.overrode.Count - 1
            if store.overrode[i] = cast( ulong, id ) then
                found = true
                exit for
            end if
        next
        if found then continue for
        for i as long = 0 to store.patternOnly.Count - 1
            if store.patternOnly[i] = cast( ulong, id ) then
                found = true
                exit for
            end if
        next
        if found then continue for
        diags.Report( TKO0621, PointRange( ast.Loc( id ) ), names.Spelling( sp->name ) )
    next
end sub

'' ...AND A MATCH THAT IS NOT COMPATIBLE. The builder recorded WHY while matching; each
'' reason is its own fbc error number, and its own message here, because the fix differs.
sub CheckOverrideCompatible _
    ( byref ast as AstArena, byref store as VTables, byref names as Interner, _
      byref diags as DiagnosticEngine )

    for i as long = 0 to store.mismatches.Count - 1
        dim as VtMismatch ptr m = @store.mismatches[i]
        if m->decl = NODE_NONE then continue for
        '' fbc 227 IS REPORTED AGAINST A TYPE, not a procedure -- there is no
        '' declaration to point at, which is the complaint itself. Its name comes from
        '' the N_TYPE's own payload.
        if cast( VtMismatchKind, m->kind ) = VTM_IMPL_DTOR_CC then
            if ast.Kind( m->decl ) <> N_TYPE then continue for
            dim as StmtPayload ptr tsp = _
                @ast.stmts[cast( long, ast.nodes[cast( long, m->decl )].data )]
            diags.Report( TKO0768, PointRange( ast.Loc( m->decl ) ), _
                          names.Spelling( tsp->name ) )
            continue for
        end if
        if ast.Kind( m->decl ) <> N_PROC then continue for
        dim as StmtPayload ptr sp = _
            @ast.stmts[cast( long, ast.nodes[cast( long, m->decl )].data )]
        dim as DiagId d = TKO0622
        select case cast( VtMismatchKind, m->kind )
        case VTM_CONST : d = TKO0623
        case VTM_BYREF : d = TKO0624
        case VTM_RANK  : d = TKO0740
        case VTM_CALLCONV : d = TKO0767
        end select
        diags.Report( d, PointRange( ast.Loc( m->decl ) ), names.Spelling( sp->name ) )
    next
end sub

end namespace
