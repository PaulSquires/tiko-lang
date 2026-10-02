'' tmpllocal.bas -- IS A SYMBOL A LOCAL OF A GENERIC TEMPLATE'S OWN BODY? (T43)
''
'' Included from latechecks.bas, above the call-target check that asks it, in the same
'' namespace and over the same Ctx.
''
'' Inside a template a lambda over T is not hoisted until an instantiation re-parses the
'' body, so 'var f = function( byval x as T, byval y as T ) as boolean ...' types as a
'' pointer to its RESULT, and 'f( a, b )' looked like a call through something that is not
'' a procedure -- TKO0772, even with nothing instantiating the generic. fbc-modern 1.20
'' compiles it and prints 'true' (2026-10-02), and the instance's own 'f' is a procedure
'' pointer, so the call is judged there.

'' Is this symbol declared in a generic TEMPLATE's own body -- a generic procedure's, or a
'' member's of a generic type -- rather than an instance's? Resolve's InTemplate_ asks the
'' same of a scope; this one is here because that file is not included above.
private function LocalInTemplate_ ( byref c as Ctx, byval s as Symbol ptr ) as boolean
    if s = 0 then return false
    dim as ScopeId sc = s->parent
    for d as long = 0 to 255
        if sc = SCOPE_NONE then return false
        dim as SymScope ptr ss = c.syms->ScopeAt( sc )
        if ss = 0 then return false
        dim as Symbol ptr os = c.syms->SymbolAt( ss->owner )
        if os <> 0 then
            if (os->flags and SYMF_GENERIC_INST) <> 0 then return false
            if os->kind = cast( ubyte, SYM_UDT ) then
                if instr( c.names->Spelling( os->name ), "<" ) > 0 then return false
            end if
            dim as NodeId dn = cast( NodeId, os->payload )
            if (dn > 0) andalso (cast( long, dn ) <= c.ast->Count( )) then
                dim as StmtPayload ptr op = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, dn )].data )]
                if (c.ast->Kind( dn ) = N_TYPE) andalso (os->kind = cast( ubyte, SYM_UDT )) then
                    if op->b <> NODE_NONE then return true
                elseif (c.ast->Kind( dn ) = N_PROC) andalso (os->kind = cast( ubyte, SYM_PROC )) then
                    if (op->extra and PF_GENERIC_PROC) <> 0 then return true
                end if
            end if
        end if
        sc = ss->parent
    next
    return false
end function
