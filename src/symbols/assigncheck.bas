'' assigncheck.bas -- WHAT AN ASSIGNMENT OR INITIALISER MAY NOT CONVERT.
''
'' Split out of visibility.bas at the 1500-line lint cap and included from it, inside its
'' namespace, after the helpers it calls (DerivesFrom_, BaseOf_) and before Walk_.

'' A DERIVED POINTER DOES NOT TAKE A BASE ONE -- fbc error 181. The conversion goes ONE
'' WAY: a base pointer takes a derived one (an upcast, which is always valid), and the
'' reverse is a downcast the compiler cannot check.
''
'' MEASURED, over 'B extends object', 'D extends B' and an unrelated 'Pod':
''     pb = pd   OK          the UPCAST                pd = pb   error 181
''     pa = pd   OK          'any ptr' takes any       pd = pa   OK
''     pd = pi   error 181   an integer pointer        pi = pd   error 181
''     pd = pp_  error 181   an unrelated type         pp_ = pd  error 181
''     b2 = d2   OK          the same one by VALUE     d2 = b2   error 181
''
'' AT LEAST ONE POINTEE MUST BE A UDT THAT ITSELF EXTENDS SOMETHING. That is the whole
'' difference between an ERROR and a WARNING in fbc, and the first draft got it wrong:
'' 'pudt1 = pudt2' over two PLAIN types, 'pudt1 = pi', and 'any ptr ptr = pudt' are all
'' merely warned about, and warnings/ptr-udt.bas, ptr-any.bas and ptr-dtype.bas -- which
'' fbc compiles -- write every one of them. Re-measured:
''     xp1 = xp2    OK (warning)   two plain types        xi2 = xp1   error 181
''     xp1 = xi1    OK (warning)   I1 is EXTENDED but has no base of its own
''     xi2 = xi1    error 181      I2 extends I1 -- the DOWNCAST
''     xppa = xpd   OK             the left pointee is itself a POINTER
'' So a pointee that is a pointer is not judged either, and neither is a procedure
'' pointer on the left.
private function PtrAssignBad_ _
    ( byref c as Ctx, byval lt as TypeId, byval rt as TypeId ) as boolean

    dim as TypeId lu = c.types->Unqualify( lt )
    dim as TypeId ru = c.types->Unqualify( rt )
    if c.types->Kind( lu ) <> TK_POINTER then return false
    if c.types->Kind( ru ) <> TK_POINTER then return false
    dim as TypeId lp = c.types->Unqualify( c.types->Inner( lu ) )
    dim as TypeId rp = c.types->Unqualify( c.types->Inner( ru ) )
    if (lp = TYPE_NONE) orelse (rp = TYPE_NONE) then return false
    if lp = rp then return false

    '' 'any ptr' CONVERTS BOTH WAYS and is how every allocator's result is spelled.
    if c.types->Kind( lp ) = TK_BUILTIN then
        if c.types->BuiltinOf( lp ) = TY_ANY then return false
    end if
    if c.types->Kind( rp ) = TK_BUILTIN then
        if c.types->BuiltinOf( rp ) = TY_ANY then return false
    end if

    if c.types->Kind( lp ) = TK_POINTER then return false
    if c.types->Kind( rp ) = TK_POINTER then return false
    dim as boolean lHasBase = false
    dim as boolean rHasBase = false
    if c.types->Kind( lp ) = TK_UDT then lHasBase = (BaseOf_( c, lp ) <> TYPE_NONE)
    if c.types->Kind( rp ) = TK_UDT then rHasBase = (BaseOf_( c, rp ) <> TYPE_NONE)
    if (lHasBase orelse rHasBase) = false then return false
    '' THE UPCAST IS THE LEGAL DIRECTION: the right-hand pointee derives from the left's.
    if DerivesFrom_( c, rp, lp ) then return false
    return true
end function

private sub CheckPtrAssign_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->op = 0 then return
    if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
    dim as TypeId lt = c.info->TypeOf_( sp->a )
    dim as TypeId rt = c.info->TypeOf_( sp->b )
    if (lt = TYPE_NONE) orelse (rt = TYPE_NONE) then return
    if PtrAssignBad_( c, lt, rt ) = false then return
    c.diags->Report( TKO0686, PointRange( c.ast->Loc( id ) ) )
end sub

private sub CheckPtrInit_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr ip = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (ip->a = NODE_NONE) orelse (ip->b = NODE_NONE) then return
    dim as TypeId lt = c.info->TypeOf_( ip->a )
    dim as TypeId rt = c.info->TypeOf_( ip->b )
    if (lt = TYPE_NONE) orelse (rt = TYPE_NONE) then return
    if PtrAssignBad_( c, lt, rt ) = false then return
    c.diags->Report( TKO0686, PointRange( c.ast->Loc( id ) ) )
end sub

private sub CheckPtrFloatAssign_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->op = 0 then return
    if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
    PtrFloatPair_( c, id, c.info->TypeOf_( sp->a ), c.info->TypeOf_( sp->b ) )
end sub

'' ...AND AN INITIALISER, which is the same conversion written differently:
'' 'dim p as byte ptr = 1.0' is error 181 exactly as 'p = 1.0' is.
private sub CheckPtrFloatInit_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr ip = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (ip->a = NODE_NONE) orelse (ip->b = NODE_NONE) then return
    PtrFloatPair_( c, id, c.info->TypeOf_( ip->a ), c.info->TypeOf_( ip->b ) )
end sub


'' NOT HERE: assignment BY VALUE between UDTs, fbc's error 181 for 'derived = base' and
'' for two unrelated types. A draft that compared the two sides' types by identity
'' produced ELEVEN false rejections over the 1222 fbc-accepted files and broke four of
'' this suite's own MIR tests -- a tuple, a type literal and 'let( n ) = x' all carry a
'' type that is not the destination's and are all legal -- while closing not one corpus
'' file, because every corpus case declares a constructor and a constructor is a possible
'' conversion path this pass does not model. Measured and withdrawn.

'' 'base( 1, 2, 3, 4 )' HANDS THE PARENT MORE VALUES THAN IT HAS FIELDS -- fbc error 67,
'' "Too many expressions". Measured over a parent of three fields: three is accepted, two
'' is accepted (the rest default), four is refused. So only MORE is an error.
''
'' The parent is the enclosing type's base, and its field count is what the symbol table
'' holds for its scope: every SYM_FIELD there that is not the 'base' link and not static.
private sub CheckBaseInitCount_ _
    ( byref c as Ctx, byval id as NodeId, byval here as TypeId )

    if here = TYPE_NONE then return
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->target = NODE_NONE then return
    if c.ast->Kind( lp->target ) <> N_IDENT then return
    dim as InternId nm = _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name
    if c.names->Fold( nm ) <> c.names->Fold( c.baseName ) then return
    dim as TypeId base_ = BaseOf_( c, here )
    if base_ = TYPE_NONE then return
    '' A BASE WITH A CONSTRUCTOR takes ARGUMENTS, not field values, and that is a
    '' different count altogether.
    if StructorOf_( c, base_, "__ctor" ) <> 0 then return
    dim as ScopeId bsc = cast( ScopeId, c.types->DeclScopeOf( base_ ) )
    dim as InternId bn = c.types->NameOf( base_ )
    dim as SymbolId bsid = c.syms->LookupLocalTyped( bsc, bn, true )
    if bsid = SYMBOL_NONE then bsid = c.syms->LookupTyped( bsc, bn, true )
    dim as Symbol ptr bsym = c.syms->SymbolAt( bsid )
    if bsym = 0 then return
    if bsym->inner = SCOPE_NONE then return
    dim as long fields = 0
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr f = @c.syms->symbols[i]
        if f->parent <> bsym->inner then continue for
        if f->kind <> cast( ubyte, SYM_FIELD ) then continue for
        if f->name = c.baseName then continue for
        if (f->flags and SYMF_STATIC) <> 0 then continue for
        fields += 1
    next
    if lp->count <= fields then return
    c.diags->Report( TKO0693, PointRange( c.ast->Loc( id ) ) )
end sub

