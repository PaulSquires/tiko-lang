'' resolvestmt.bas -- checks one STATEMENT needs its scope for, made once per statement from
'' Resolve's WalkStmt, which has that scope in hand.
''
'' Included from resolveintr.bas, inside Resolve's namespace, after resolvertl.bas.

'' A 'defer' DIRECTLY AT MODULE LEVEL IS fbc's ERROR 348, "DEFER is not allowed at module
'' level" -- and directly in a NAMESPACE, which is module level too. Measured on
'' fbc-modern 1.20, 2026-09-25:
''
''     defer print "d" : print "a"               at module level        348
''     namespace N : defer print "d"             in a namespace          348
''     scope / if / for / do / while / select    a block at module level accepted
''     sub S( ) : defer print "d"                in a procedure          accepted
''
'' tiko accepted the first two. At module level it ran the deferred statement when the
'' program ended; in a namespace it never ran it at all. A block opens its own scope
'' (Collect), so the statement's scope says which case this is.
private sub DeferAtModule_ ( byref c as Ctx, byval id as Tko.NodeId, byval here as Tko.ScopeId )
    if c.ast->Kind( id ) <> Tko.N_DEFER then return
    dim as Tko.SymScope ptr ss = c.syms->ScopeAt( here )
    if ss = 0 then return
    select case ss->kind
    case Tko.SCOPEK_GLOBAL, Tko.SCOPEK_MODULE, Tko.SCOPEK_NAMESPACE
        c.diags->Report( Tko.TKO0814, Tko.PointRange( c.ast->Loc( id ) ) )
    end select
end sub

sub StatementChecks_ ( byref c as Ctx, byval id as Tko.NodeId, byval here as Tko.ScopeId )
    RtlNameClash_( c, id, here )
    DeferAtModule_( c, id, here )
end sub
