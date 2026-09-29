'' assigncheck.bas -- WHAT AN ASSIGNMENT OR INITIALISER MAY NOT CONVERT.
''
'' Split out of visibility.bas at the 1500-line lint cap and included from it, inside its
'' namespace, after the helpers it calls (DerivesFrom_, BaseOf_) and before Walk_.

#include once "symbols/tupleconv.bas"
#include once "symbols/ptrwarn.bas"

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
    '' A BUILTIN BASE IS NO HIERARCHY. 'type DW extends wstring' gives DW a base field of
    '' type WSTRING, and two such types are as unrelated as two plain ones. Measured on
    '' fbc-modern: 'Add( byref d as DW )' given a BS that also extends wstring binds a
    '' temporary built by DW's constructor and prints 'dw 7' -- the same as when neither
    '' extends anything. Counting WSTRING as a base refused AfxNova's 'this.Add( bs )' in
    '' DWSTRING.+= and DWSTRING.&= (TKO0698), which PsCalendar reached twice.
    if c.types->Kind( lp ) = TK_UDT then
        dim as TypeId lb = BaseOf_( c, lp )
        if lb <> TYPE_NONE then lHasBase = (c.types->Kind( c.types->Unqualify( lb ) ) = TK_UDT)
    end if
    if c.types->Kind( rp ) = TK_UDT then
        dim as TypeId rb = BaseOf_( c, rp )
        if rb <> TYPE_NONE then rHasBase = (c.types->Kind( c.types->Unqualify( rb ) ) = TK_UDT)
    end if
    if (lHasBase orelse rHasBase) = false then return false
    '' THE UPCAST IS THE LEGAL DIRECTION: the right-hand pointee derives from the left's.
    if DerivesFrom_( c, rp, lp ) then return false
    return true
end function

'' A POINTER CANNOT LOSE A POINTEE'S CONST -- fbc error 181. Measured across the whole
'' 'const/assign-<dest>-from-<source>' family, and the boundary is exact:
''
''     const ubyte ptr      -> ubyte ptr           error 181   the pointee loses const
''     ubyte const ptr      -> ubyte ptr           accepted    the const POINTER is copied
''     ubyte ptr            -> const ubyte ptr     accepted    const may be ADDED
''     ubyte ptr ptr        -> const ubyte ptr ptr accepted    ...at any depth
''     const ubyte ptr      -> any ptr             error 181   'any' is no escape
''     const ubyte ptr      -> const any ptr       accepted
''     ubyte ptr            -> byte ptr            accepted    the TYPE alone is not this
''     ubyte const ptr ptr  -> ubyte ptr ptr       error 181   the pointee IS a const ptr
''
'' So the two chains are walked in step from the FIRST POINTEE DOWN -- the top-level const
'' belongs to the value being copied and is not part of the question -- and the first
'' level where the source is const and the destination is not is the error. A differing
'' pointee TYPE is somebody else's rule (TKO0686); only constness is judged here.
private function ConstDropped_ _
    ( byref c as Ctx, byval dst as TypeId, byval src as TypeId ) as boolean

    if (dst = TYPE_NONE) orelse (src = TYPE_NONE) then return false
    dim as TypeId d = c.types->Unqualify( dst )
    dim as TypeId s = c.types->Unqualify( src )
    dim as long guard = 0
    while guard < 32
        guard += 1
        if c.types->Kind( d ) <> TK_POINTER then return false
        if c.types->Kind( s ) <> TK_POINTER then return false
        dim as TypeId dp = c.types->Inner( d )
        dim as TypeId sp = c.types->Inner( s )
        if (dp = TYPE_NONE) orelse (sp = TYPE_NONE) then return false
        if c.types->IsConst( sp ) andalso (c.types->IsConst( dp ) = false) then return true
        d = c.types->Unqualify( dp )
        s = c.types->Unqualify( sp )
    wend
    return false
end function

private sub CheckPtrAssign_ _
    ( byref c as Ctx, byval id as NodeId, byval resultType as TypeId = TYPE_NONE )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->op = 0 then return
    if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
    dim as TypeId lt = c.info->TypeOf_( sp->a )
    dim as TypeId rt = c.info->TypeOf_( sp->b )
    '' 'function = expr' -- Check leaves the result untyped; the walk carries its type.
    if (lt = TYPE_NONE) andalso (c.ast->Kind( sp->a ) = N_FUNCRESULT) then lt = resultType
    if (lt = TYPE_NONE) orelse (rt = TYPE_NONE) then return
    if sp->op = cast( ushort, TK_EQ ) then
        if TupleConvBad_( c, lt, sp->b, 0 ) then return  '' tupleconv.bas
    end if
    if ConstDropped_( c, lt, rt ) then
        c.diags->Report( TKO0747, PointRange( c.ast->Loc( id ) ) )
        return
    end if
    if PtrAssignBad_( c, lt, rt ) then
        c.diags->Report( TKO0686, PointRange( c.ast->Loc( id ) ) )
        return
    end if
    '' Only a plain '=': 'p += 1' is pointer arithmetic, not a conversion.
    if sp->op = cast( ushort, TK_EQ ) then PtrWarn_( c, id, lt, rt, sp->b )
end sub

private sub CheckPtrInit_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr ip = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (ip->a = NODE_NONE) orelse (ip->b = NODE_NONE) then return
    dim as TypeId lt = c.info->TypeOf_( ip->a )
    dim as TypeId rt = c.info->TypeOf_( ip->b )
    if (lt = TYPE_NONE) orelse (rt = TYPE_NONE) then return
    if TupleConvBad_( c, lt, ip->b, 0 ) then return  '' tupleconv.bas
    if ConstDropped_( c, lt, rt ) then
        c.diags->Report( TKO0747, PointRange( c.ast->Loc( id ) ) )
        return
    end if
    if PtrAssignBad_( c, lt, rt ) then
        c.diags->Report( TKO0686, PointRange( c.ast->Loc( id ) ) )
        return
    end if
    PtrWarn_( c, id, lt, rt, ip->b )
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


'' A FIELD OF A CONST VARIABLE CANNOT BE WRITTEN -- fbc error 119, the same "Cannot modify
'' a constant" it gives the variable itself. Measured: 'dim as const foo b = ( 3 )' then
'' 'b.x = 4' is refused and 'print b.x' is not. Resolve refuses the BARE const variable;
'' the member spelling reached here.
''
'' ...HOWEVER THE CONST OBJECT IS REACHED. Measured on fbc-modern 1.20, 2026-09-29, each 119:
''
''     cast( const UDT, x ).i = 5        const/cast-to-const-same-udt.bas, and -rttiudt.bas
''     pcx->i = 5     (*pcx).i = 5       pcx a 'const UDT ptr'
''     cx.a( 1 ) = 5                     an array FIELD of a const variable
''
'' and fine: 'cast( UDT, x ).i = 5', and 'cx.q->i = 5' through a pointer field of a const
'' object -- the pointee is not const. tiko judged only a const variable's own '.', so the
'' chain is walked one FIELD at a time: a '.' asks its object, a '->' its pointee.
private sub CheckConstUdtField_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->op = 0 then return
    dim as NodeId m = sp->a
    for guard as long = 0 to 31
        if m = NODE_NONE then return
        select case c.ast->Kind( m )
        case N_PAREN
            dim as ListPayload ptr pp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, m )].data )]
            if pp->count <> 1 then return
            m = cast( NodeId, c.ast->children[pp->first] )
            continue for
        case N_CALL
            '' 'cx.a( 1 )' -- a subscript of an array FIELD; a method call is not a target.
            m = c.ast->lists[cast( long, c.ast->nodes[cast( long, m )].data )].target
            if (m = NODE_NONE) orelse (c.ast->Kind( m ) <> N_MEMBER) then return
        case N_MEMBER
        case else
            return
        end select
        dim as Symbol ptr fs = c.syms->SymbolAt( c.info->RefOf( m ) )
        if fs = 0 then return
        if fs->kind <> cast( ubyte, SYM_FIELD ) then return
        if (fs->flags and SYMF_STATIC) <> 0 then return
        dim as NodeId lhs = c.ast->binaries[cast( long, c.ast->nodes[cast( long, m )].data )].lhs
        if lhs = NODE_NONE then return
        dim as TypeId lt = TYPE_NONE
        '' A VARIABLE'S OWN TYPE, where the walk may have seen a placeholder -- see above.
        dim as Symbol ptr vs = 0
        if c.ast->Kind( lhs ) = N_IDENT then vs = c.syms->SymbolAt( c.info->RefOf( lhs ) )
        if (vs <> 0) andalso (vs->kind = cast( ubyte, SYM_VARIABLE )) then
            lt = vs->type_
        else
            lt = c.info->TypeOf_( lhs )
        end if
        if lt = TYPE_NONE then return
        if c.types->Kind( lt ) = TK_REFERENCE then lt = c.types->Inner( lt )
        if (c.ast->nodes[cast( long, m )].flags and NF_ARROW) <> 0 then
            if c.types->Kind( c.types->Unqualify( lt ) ) <> TK_POINTER then return
            lt = c.types->Inner( c.types->Unqualify( lt ) )
            if c.types->IsConst( lt ) = false then return
        elseif c.types->IsConst( lt ) = false then
            m = lhs
            continue for
        end if
        if c.types->Kind( c.types->Unqualify( lt ) ) <> TK_UDT then return
        dim as string nm
        if vs <> 0 then nm = c.names->Spelling( vs->name )
        c.diags->Report( TKO0617, PointRange( c.ast->Loc( sp->a ) ), nm )
        return
    next
end sub

'' THE POINTER RULE, AT A CALL. Measured: 'byval p as D ptr' given a B pointer is fbc error
'' 24 -- the same downcast the assignment refuses -- while 'byval p as B ptr' given a D
'' pointer is accepted. And BY REFERENCE the value is the same question: 'byref x as D'
'' given a B is error 58, 'byref x as B' given a D is accepted. PtrAssignBad_ already
'' knows the pointer half; the byref half is the identical test over the pointees.

'' A UDT ARGUMENT OF AN UNRELATED UDT TYPE -- fbc's error 58, byval and byref alike. Measured
'' on fbc-modern 1.20, 2026-09-26, over 'byval p as A', 'byref p as A' and a plain 'p as A'
'' given a B with no relation to A: 'Type mismatch, at parameter 1'; and 'type<B>( 9 )' the
'' same. tiko passed B's bytes as an A and printed its field, or dropped the PRINT around a
'' function call. Accepted, and not judged here: the same type, a type DERIVED from the
'' parameter's, an argument whose type declares an 'operator cast' (fbc calls it), and a
'' parameter type with a constructor or a 'let' of its own, which may build one from the
'' argument. A tuple is its own rule.
private function UdtArgBad_ ( byref c as Ctx, byval pt as TypeId, byval at as TypeId ) as boolean
    dim as TypeId pu = c.types->Unqualify( pt )
    dim as TypeId au = c.types->Unqualify( at )
    if c.types->Kind( pu ) = TK_REFERENCE then pu = c.types->Unqualify( c.types->Inner( pu ) )
    if c.types->Kind( au ) = TK_REFERENCE then au = c.types->Unqualify( c.types->Inner( au ) )
    if (c.types->Kind( pu ) <> TK_UDT) orelse (c.types->Kind( au ) <> TK_UDT) then return false
    if pu = au then return false
    if TcTuple_( c, pu ) orelse TcTuple_( c, au ) then return false
    if DerivesFrom_( c, au, pu ) then return false
    if StructorOf_( c, au, "cast" ) <> 0 then return false
    if StructorOf_( c, pu, "__ctor" ) <> 0 then return false
    if StructorOf_( c, pu, "let" ) <> 0 then return false
    return true
end function
private sub CheckArgConversions_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->target = NODE_NONE then return
    '' A BUILTIN'S NAME OVERLOADED BY THE PROGRAM IS NOT THE CALLEE FOR A BUILTIN ARGUMENT.
    '' AfxNova declares 'Left OVERLOAD( byref as DWSTRING, n )' and calls 'LEFT( w, 1 )' over
    '' a 'byref as const wstring'; measured, fbc runs the builtin (scratchpad afx/ov.bas), and
    '' lowering takes it by spelling. Judging the argument against the user overload's byref
    '' parameter gave a false 181 (TKO0699). Check decides which of the two runs
    '' (IntrinsicCallType_) and UNBINDS the call when it is the builtin, so an unbound call is
    '' let through. A call Check left bound is the program's and is judged: 'hex( 255 )'
    '' inside a namespace declaring 'hex( byref as string )' is fbc's error 58.
    if (c.ast->Kind( lp->target ) = N_IDENT) andalso (lp->count >= 1) then
        dim as IdentPayload ptr tip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
        '' A SPELLING THE INTRINSIC TABLE TYPES -- hex and val as much as LEN and LEFT.
        dim as boolean builtinNm = _
            Tko.Check.IsTypedIntrinsicName( Text.LowerAscii( c.names->Spelling( tip->name ) ) )
        '' ...AND NOTHING BOUND TO THE CALL ITSELF means the builtin (or a user OPERATOR of
        '' that name) is what runs: the name's head symbol is just the first overload, and
        '' 'LEN( dwsOut )' judged against BSTRING's operator was a false TKO0698.
        if builtinNm andalso (c.info->RefOf( id ) = SYMBOL_NONE) then return
        '' ...AND A USER OPERATOR BOUND TO IT is picked by the argument's UDT where it runs
        '' (LowerLen), not by the chain head: 'LEN( dws )' beside BSTRING's OPERATOR LEN.
        if builtinNm then
            dim as Symbol ptr bops = c.syms->SymbolAt( c.info->RefOf( id ) )
            if bops <> 0 then
                if (bops->kind = cast( ubyte, SYM_PROC )) andalso (bops->payload <> 0) then
                    dim as NodeId bpn = cast( NodeId, bops->payload )
                    if c.ast->Kind( bpn ) = N_PROC then
                        if c.ast->stmts[cast( long, c.ast->nodes[cast( long, bpn )].data )].op = cast( ushort, KW_OPERATOR ) then return
                    end if
                end if
            end if
        end if
    end if
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
        if (c.ast->nodes[cast( long, prm )].flags and NF_ARRAY) <> 0 then continue for
        dim as StmtPayload ptr prp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
        if prp->a = NODE_NONE then continue for
        dim as TypeId pt = c.info->TypeOf_( prp->a )
        dim as TypeId at = c.info->TypeOf_( arg )
        if (pt = TYPE_NONE) orelse (at = TYPE_NONE) then continue for
        dim as boolean byvalWritten = _
            ((c.ast->nodes[cast( long, prm )].flags and NF_BYVAL_WRITTEN) <> 0)
        '' AN ARGUMENT IS AN ASSIGNMENT: 'c( @pp )' over 'byval x as integer ptr' with a
        '' 'const integer pp' hands over a 'const integer ptr' and is fbc's 181 too.
        if ConstDropped_( c, pt, at ) then
            c.diags->Report( TKO0747, PointRange( c.ast->Loc( arg ) ) )
            return
        end if
        dim as boolean bad = false
        if c.types->Kind( c.types->Unqualify( pt ) ) = TK_POINTER then
            bad = PtrAssignBad_( c, pt, at )
        elseif ((pp->extra and PF_GENERIC_PROC) = 0) andalso UdtArgBad_( c, pt, at ) then  '' a template's is TKO0809's
            bad = true
        elseif byvalWritten = false then
            '' BYREF: the two VALUE types, judged as if they were pointees -- and ONLY
            '' when both are UDTs, which is what was measured. 'fz( zz )' over 'byref z
            '' as zstring' with a 'zstring * 8' argument is an ordinary call, and this
            '' suite's own byval-to-byref test writes it.
            if (c.types->Kind( c.types->Unqualify( pt ) ) = TK_UDT) andalso _
               (c.types->Kind( c.types->Unqualify( at ) ) = TK_UDT) then
                bad = PtrAssignBad_( c, c.types->Pointer_( pt ), c.types->Pointer_( at ) )
            end if
            '' A FIXED USTRING for 'byref as wstring' or 'byref as zstring' is fbc's 58
            '' (fbc-modern 1.20, 2026-09-28): 'ustring * 8' is a UTF-8 buffer, and neither of
            '' those. A fixed wstring or zstring, a var-len ustring, and 'byref as ustring' or
            '' 'as string' all take it.
            dim as TypeId fe = Tko.Check.FixedStringElem( at, *c.types )
            if fe <> TYPE_NONE then
                if c.types->BuiltinOf( fe ) = TY_FIXUSTR then
                    dim as TypeId pb = c.types->Unqualify( pt )
                    if c.types->Kind( pb ) = TK_BUILTIN then
                        select case c.types->BuiltinOf( pb )
                        case TY_WSTRING, TY_ZSTRING : bad = true
                        end select
                    end if
                end if
            end if
        end if
        if bad then
            c.diags->Report( TKO0698, PointRange( c.ast->Loc( arg ) ) )
            return
        end if
        '' ...AND A POINTER OF ANOTHER KIND, which converts with fbc's warning 3 -- ptrwarn.bas. Not
        '' over an overload set: a candidate is chosen only where the types fit, and a call none
        '' fits is TKO0632 already -- fbc's 99, with no warning beside it.
        dim as boolean ovl = ((callee->flags and SYMF_OVERLOAD) <> 0) orelse (callee->nextOverload <> SYMBOL_NONE)
        if (ovl = false) andalso (c.types->Kind( c.types->Unqualify( pt ) ) = TK_POINTER) then PtrArgWarn_( c, arg, pt, at )

        '' A CONST VALUE CANNOT BIND TO A NON-CONST BYREF -- fbc error 181. Measured over
        '' a UDT and an integer: 'byref x as T' given a 'const T' is refused, while
        '' 'byref x as const T' takes it and so does 'byval'. A LITERAL binds to a
        '' temporary and is fine, so only a NAMED argument is judged.
        dim as TypeId pu = c.types->Unqualify( pt )
        if (byvalWritten = false) andalso (c.ast->Kind( arg ) = N_IDENT) then
            if c.types->IsConst( at ) andalso (c.types->IsConst( pt ) = false) then
                '' A POINTER COUNTS TOO: 'f( r )' over 'byref l as any ptr' with an 'any
                '' const ptr' argument binds the reference to a const pointer and drops
                '' its const -- fbc's 181, measured.
                dim as TypeKind pk = c.types->Kind( pu )
                if (pk = TK_UDT) orelse (pk = TK_BUILTIN) orelse (pk = TK_POINTER) then
                    c.diags->Report( TKO0699, PointRange( c.ast->Loc( arg ) ) )
                    return
                end if
            end if
        end if

        '' A NUMBER TO A BYREF STRING -- fbc error 58. Measured: 'byref z as zstring'
        '' given 0 is refused, so is 'byref s as string'; a string literal is the
        '' ordinary argument, and 'byval p as zstring ptr' given 0 is a null pointer.
        '' 'fz( byval 0 )' PASSES THE VALUE AS THE ADDRESS -- fbc's C is 'FZ( (char*)0ll )'
        '' -- and is the documented way to hand a byref parameter a null. An explicit
        '' 'byval' on the argument is not this rule.
        dim as boolean argByval = false
        if c.ast->Kind( arg ) = N_UNARY then
            dim as UnaryPayload ptr aup = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, arg )].data )]
            argByval = (cast( TokenKind, aup->op ) = KW_BYVAL)
        end if
        if (byvalWritten = false) andalso (argByval = false) andalso _
           (c.types->Kind( pu ) = TK_BUILTIN) then
            dim as boolean strParam = false
            select case c.types->BuiltinOf( pu )
            case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING : strParam = true
            end select
            dim as TypeId au = c.types->Unqualify( at )
            if strParam andalso (c.types->Kind( au ) = TK_BUILTIN) then
                select case c.types->BuiltinOf( au )
                case TY_BYTE, TY_UBYTE, TY_SHORT, TY_USHORT, TY_LONG, TY_ULONG, _
                     TY_INTEGER, TY_UINTEGER, TY_LONGINT, TY_ULONGINT, TY_SINGLE, TY_DOUBLE
                    c.diags->Report( TKO0698, PointRange( c.ast->Loc( arg ) ) )
                    return
                end select
            end if
        end if
    next
end sub

'' A STRING AND A NUMBER DO NOT CONVERT INTO EACH OTHER BY ASSIGNMENT -- fbc error 181, in
'' every direction measured: 's = 65', 's = b' over a byte, 's = n' over an integer,
'' 'b = s', 'n = s', 'd = s', 'n = z' over a fixed zstring, and '*p = s' through a byte
'' pointer. The initialiser form was already refused (TKO0634); this is the same question
'' one line later, and the corpus writes it with a dereference or a string index on one
'' side: 's = *p', 'l[5] = r'.
''
'' A UDT ON EITHER SIDE IS NOT THIS QUESTION -- a conversion operator may exist -- and
'' neither is a pointer: 'p = s' is a different mismatch.
private function CharAccess_ _
    ( byref c as Ctx, byval n as NodeId, byval u as TypeId ) as boolean
    if n = NODE_NONE then return false
    dim as NodeKind k = c.ast->Kind( n )
    if (k <> N_DEREF) andalso (k <> N_INDEX) then return false
    if c.types->Kind( u ) <> TK_BUILTIN then return false
    select case c.types->BuiltinOf( u )
    case TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        return true
    end select
    return false
end function

private sub CheckStringNumberAssign_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> TK_EQ then return
    if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
    '' A PROPERTY ON THE LEFT IS A CALL, and its setter may be OVERLOADED: structs/
    '' obj_property.bas declares 'property v( byval as integer )' and 'property v( byval
    '' as zstring ptr )' side by side, so 'b1.v = "2"' picks the second one while the
    '' property's READ type is an integer. Comparing the read type against the value
    '' refused a file fbc accepts; which overload runs is not modelled here.
    dim as Symbol ptr lps = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
    if (lps <> 0) andalso (lps->kind = cast( ubyte, SYM_PROC )) then return
    dim as TypeId lt = c.info->TypeOf_( sp->a )
    dim as TypeId rt = c.info->TypeOf_( sp->b )
    if (lt = TYPE_NONE) orelse (rt = TYPE_NONE) then return
    dim as TypeId lu = c.types->Unqualify( lt )
    dim as TypeId ru = c.types->Unqualify( rt )
    if c.types->Kind( lu ) = TK_REFERENCE then lu = c.types->Unqualify( c.types->Inner( lu ) )
    if c.types->Kind( ru ) = TK_REFERENCE then ru = c.types->Unqualify( c.types->Inner( ru ) )
    '' A FIXED STRING is an array of a character builtin: look through it to the element.
    if c.types->Kind( lu ) = TK_ARRAY then lu = c.types->Unqualify( c.types->Inner( lu ) )
    if c.types->Kind( ru ) = TK_ARRAY then ru = c.types->Unqualify( c.types->Inner( ru ) )
    if (c.types->Kind( lu ) <> TK_BUILTIN) orelse (c.types->Kind( ru ) <> TK_BUILTIN) then return
    dim as boolean lStr = IsStringyType_( c, lu )
    dim as boolean rStr = IsStringyType_( c, ru )
    '' A CHARACTER IS A NUMBER. '*pz' through a 'zstring ptr' and 'pz[1]' are one
    '' character each, and fbc takes an integer into one and one into an integer --
    '' three of this suite's own MIR tests write it. Their TYPE is the bare zstring, the
    '' same as a byref zstring parameter's, so the NODE decides: a dereference or an
    '' index over a zstring/wstring is a character, and a character is on the number
    '' side of this rule. That is also what makes 'l[5] = r' (character = string) and
    '' 'l = r[1]' (string = character) the refusals fbc measures them as.
    '' ...AND IT IS ALSO A STRING. '*pz = s' over a 'zstring ptr' copies the string in,
    '' which four more of this suite's MIR tests write. A dereferenced zstring takes
    '' BOTH, so an access through one is not judged at all, on either side; what remains
    '' is the plain scalar case, which is what the corpus files write with a byte pointer
    '' ('*p = s' over 'byte ptr' types as a BYTE and is refused as measured).
    if CharAccess_( c, sp->a, lu ) orelse CharAccess_( c, sp->b, ru ) then return
    if lStr = rStr then return
    dim as TypeId num = ru
    if rStr then num = lu
    select case c.types->BuiltinOf( num )
    case TY_BYTE, TY_UBYTE, TY_SHORT, TY_USHORT, TY_LONG, TY_ULONG, _
         TY_INTEGER, TY_UINTEGER, TY_LONGINT, TY_ULONGINT, TY_SINGLE, TY_DOUBLE
    case else
        return
    end select
    c.diags->Report( TKO0702, PointRange( c.ast->Loc( id ) ) )
end sub
