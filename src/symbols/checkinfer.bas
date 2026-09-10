'' checkinfer.bas -- the INFERENCE REPAIR passes: an unused 'var' whose type is its
'' initialiser's, and a 'typeof' whose operand only Check can type.
''
'' Both run BEFORE the walk, for the same reason: every USE of the name is inside the
'' body, and the walk types those.
''
'' Split out of check.bas at the 1500-line cap and INCLUDED from it, inside the same
'' namespace. Nothing moved here changed in the move.


'' ---------------------------------------------------------------- the walk

'' A 'var' whose variable is never USED afterwards still needs a type: the lazy path
'' in TypeOf_ above fires on a use, and an unused one has none. The slot is allocated
'' regardless, and an untyped slot is 'void' in MIR.
''
'' A pass over the SYMBOLS rather than the nodes, and after every expression has been
'' typed, so the initialiser's type is already known whatever order the declaration
'' appeared in.
'' 'var byref ri = i' IS AN ALIAS, and its type has to come out a REFERENCE the same
'' way 'dim byref ri as integer = i' does -- Resolve wraps that one, but an INFERRED
'' type is not known until here. Without this the slot was an i64 while the
'' declaration stored an ADDRESS into it: 'stores ptr into a i64 slot', thirteen of
'' them in one corpus file, and every later read of the alias read the address as the
'' value. A reference to a reference is still one reference, so an initialiser that is
'' itself an alias is unwrapped first.
private function RefWrapIfAlias_ _
    ( byref c as Ctx, byval s as Tko.Symbol ptr, byval t as Tko.TypeId ) as Tko.TypeId

    if (s->flags and Tko.SYMF_BYREF) = 0 then return t
    if t = Tko.TYPE_NONE then return t
    if c.types->Kind( t ) = Tko.TK_REFERENCE then return t
    return c.types->Reference( t )
end function

'' A 'typeof' TYPEREF, REPAIRED -- including through POINTER LEVELS.
''
'' Resolve takes 'typeof( x )' from the SYMBOL, which is right for a declared
'' variable and empty for an inferred one, so
'' 'var foo = cast( integer, 0 ) : dim bar as typeof( foo )' left bar untyped and
'' its slot void. By the time this pass runs foo HAS its type.
''
'' THE POINTER FORM NEEDS THE SAME REPAIR. 'dim baz as typeof( foo ) ptr = @bar' is
'' the next line of the corpus test, and a pointer to nothing is what made
'' '*baz = &Hbaddf00d' an untyped target.
''
'' The symbol a bare name resolved to is recorded ON THE TYPEREF by Resolve: an
'' expression node inside a procedure has no recorded scope to look one up FROM.
'' Returns TYPE_NONE when this is not a typeof chain, or when it still cannot be
'' answered.
private function RepairTypeofRef_ _
    ( byref c as Ctx, byval tr as Tko.NodeId, byval depth as long ) as Tko.TypeId

    if tr = Tko.NODE_NONE then return Tko.TYPE_NONE
    if depth > 8 then return Tko.TYPE_NONE
    if c.ast->Kind( tr ) <> Tko.N_TYPEREF then return Tko.TYPE_NONE
    dim as Tko.StmtPayload ptr tp = StmtOf( c, tr )
    if (c.ast->nodes[cast( long, tr )].flags and Tko.NF_PTR) <> 0 then
        dim as Tko.TypeId inner = RepairTypeofRef_( c, tp->a, depth + 1 )
        if inner = Tko.TYPE_NONE then return Tko.TYPE_NONE
        return c.types->Pointer_( inner )
    end if
    if cast( Tko.TokenKind, tp->op ) <> Tko.KW_TYPEOF then return Tko.TYPE_NONE
    dim as Tko.TypeId tt = Tko.TYPE_NONE
    if tp->b <> Tko.NODE_NONE then
        tt = TypeOf_( c, tp->b )
    elseif tp->rawName <> 0 then
        dim as Tko.Symbol ptr tos = c.syms->SymbolAt( c.info->RefOf( tr ) )
        if tos <> 0 then tt = tos->type_
    end if
    if tt = Tko.TYPE_NONE then return Tko.TYPE_NONE
    '' A REFERENCE is transparent, as it is in an expression.
    if c.types->Kind( tt ) = Tko.TK_REFERENCE then tt = c.types->Inner( tt )
    return tt
end function

private sub InferUnusedVarTypes_( byref c as Ctx )
    '' 'to Count( )', not 'to Count( ) - 1'. SymbolTable.Count already returns
    '' 'symbols.Count - 1', so the valid ids are 1..Count( ) -- subtracting again
    '' skipped THE LAST SYMBOL IN THE TABLE. If that symbol was an unused inferred
    '' 'var' it stayed untyped and its slot lowered to void, so 'var a = 1' alone in a
    '' file failed while the same line with any declaration after it passed. Five
    '' corpus files, and the whole difference was where the variable happened to sit.
    for sid as long = 1 to c.syms->Count( )
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cast( Tko.SymbolId, sid ) )
        if s = 0 then continue for
        '' A CONSTANT too: 'const n1c as typeof( n1 ) = ( n1 )' is the shape the
        '' corpus writes, and a constant's type is bound the same way.
        dim as boolean inferrable = _
            (s->kind = cast( ubyte, Tko.SYM_VARIABLE )) orelse _
            (s->kind = cast( ubyte, Tko.SYM_CONSTANT ))
        '' A FIELD TOO, and for a sharper reason than a variable: a field left untyped
        '' makes ComputeUdtLayouts refuse the WHOLE UDT, which then vanishes from the
        '' type table with nothing said and every use of it declines. Thirty of the forty
        '' in pointers/procptr-low-level-delegate.bas are one field typed
        '' 'typeof( procptr( T.m ) )'.
        ''
        '' A BITFIELD is excluded: its payload is the WIDTH, not a node, and its type is
        '' spelled out anyway.
        if s->kind = cast( ubyte, Tko.SYM_FIELD ) then
            if (s->flags and Tko.SYMF_BITFIELD) = 0 then inferrable = true
        end if
        if inferrable = false then continue for
        '' A POINTER TO NOTHING NEEDS REPAIRING TOO. 'dim baz as typeof( foo ) ptr'
        '' over an inferred 'foo' resolves to a NON-NONE pointer whose pointee is
        '' missing, so the symbol looked typed and was skipped -- and '*baz = x' had
        '' an untyped target and declined.
        if s->type_ <> Tko.TYPE_NONE then
            dim as Tko.TypeId su = c.types->Unqualify( s->type_ )
            dim as boolean holed = false
            if c.types->Kind( su ) = Tko.TK_POINTER then
                holed = (c.types->Inner( su ) = Tko.TYPE_NONE)
            end if
            if holed = false then continue for
        end if
        if s->payload = 0 then continue for
        dim as Tko.NodeId item = cast( Tko.NodeId, s->payload )
        '' A field's declaration node is an N_FIELD; its typeref sits in the same payload
        '' slot a variable item keeps one in, so the walk below is shared.
        dim as boolean isField = (c.ast->Kind( item ) = Tko.N_FIELD)
        if (c.ast->Kind( item ) <> Tko.N_VAR_ITEM) andalso (isField = false) then
            continue for
        end if
        dim as Tko.StmtPayload ptr ip = StmtOf( c, item )

        '' 'dim x as typeof( EXPR )'. The declared type IS an expression's type, which
        '' only Check can say -- Resolve handles the bare-name form and leaves this
        '' one, so the symbol arrives here untyped and its slot lowered to 'void'.
        '' 44 of the corpus's remaining verifier failures are one file writing
        '' 'const n1c as typeof( n1 ) = ( n1 )' inside a macro, where n1 expands to a
        '' conversion call.
        if ip->a <> Tko.NODE_NONE then
            dim as Tko.TypeId rt2 = RepairTypeofRef_( c, ip->a, 0 )
            if rt2 <> Tko.TYPE_NONE then s->type_ = RefWrapIfAlias_( c, s, rt2 )
            continue for
        end if

        '' Inferred only. A 'dim as T x' whose T did not resolve stays untyped.
        if ip->b = Tko.NODE_NONE then continue for
        dim as Tko.TypeId vt = TypeOf_( c, ip->b )
        if c.ast->Kind( ip->b ) = Tko.N_STRING_LIT then
            vt = c.types->Builtin( Tko.TY_STRING )
        end if

        '' 'var s = *pz' OVER A 'zstring ptr' IS A STRING. Measured with fbc's own
        '' typeof: '*pz' is ZSTRING and 'var s = *pz' is STRING -- a var cannot hold an
        '' UNSIZED zstring, so it copies into a var-len one. The same is true of a
        '' SIZED source: 'var zf = zb' over a 'zstring * 8' is STRING too.
        ''
        '' Untyped, the symbol reached lowering with no type and the emitter met
        '' 'local void s4' -- 'ICE: an alloca of a void slot'. It reported 0 statements
        '' not lowered and passed the verifier; build/icescan.sh is what found it,
        '' because --dump-ir stops before codegen.
        ''
        '' THE WIDE TWIN IS NOT THE SAME RULE and is deliberately left alone here:
        '' 'var w = *pw' and 'var wf = wb' are both fbc ERROR 24, Invalid data types.
        '' Inferring WSTRING for them would accept two programs fbc refuses; they are
        '' an over-acceptance of tiko's own and want a diagnostic, not an inference.
        if vt <> Tko.TYPE_NONE then
            dim as Tko.TypeId vu = c.types->Unqualify( vt )
            dim as Tko.TypeId ve = vu
            if c.types->Kind( ve ) = Tko.TK_ARRAY then ve = c.types->Inner( ve )
            if ve <> Tko.TYPE_NONE then
                if c.types->Kind( ve ) = Tko.TK_BUILTIN then
                    if c.types->BuiltinOf( ve ) = Tko.TY_ZSTRING then
                        vt = c.types->Builtin( Tko.TY_STRING )
                    end if
                end if
            end if
        end if
        if vt <> Tko.TYPE_NONE then s->type_ = RefWrapIfAlias_( c, s, vt )
    next
end sub