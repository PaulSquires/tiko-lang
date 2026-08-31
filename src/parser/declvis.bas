'' declvis.bas -- an ACCESS SECTION reaching into a nested aggregate.
''
'' Split out of decl.bas at the 1500-line lint cap and included from it, inside its own
'' namespace. Nothing in it changed in the move.


'' An access section reaches into a nested anonymous TYPE or UNION -- measured: a
'' field of a union written under 'private:' is an illegal member access from outside.
'' The nested body parses with its own section state, so the label is applied here
'' instead, and only to members that carry none of their own.
private sub ApplyVisibility _
    ( byref p as Tko.ParserState, byval n as Tko.NodeId, byval vis as ushort )

    if (vis = 0) orelse (n = Tko.NODE_NONE) then return
    if p.ast->nodes[cast( long, n )].kind <> Tko.N_TYPE then return

    dim as Tko.StmtPayload ptr tp = _
        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )]

    for i as long = 0 to tp->count - 1
        dim as Tko.NodeId m = cast( Tko.NodeId, p.ast->children[tp->first + i] )
        if m = Tko.NODE_NONE then continue for
        dim as Tko.NodeKind mk = p.ast->nodes[cast( long, m )].kind
        if mk = Tko.N_TYPE then
            ApplyVisibility( p, m, vis )
        '' N_CONST AND N_VAR TOO. A 'const' or a 'static' inside a type body is a
        '' MEMBER, and 'T.MYCONST' from outside is fbc error 202 exactly as a private
        '' field is -- visibility/private-const-public-plainaccess.bas writes it. Only
        '' fields and procedures were marked, so those declarations came through public.
        '' N_ENUM TOO: a nested enum under 'private:' is a private member, and
        '' 'Test.first.one' from outside is fbc error 202 --
        '' structs/obj_access_const.bas writes exactly that.
        elseif (mk = Tko.N_FIELD) orelse (mk = Tko.N_PROC) orelse _
               (mk = Tko.N_CONST) orelse (mk = Tko.N_VAR) orelse (mk = Tko.N_ENUM) then
            dim as Tko.StmtPayload ptr mp = _
                @p.ast->stmts[cast( long, p.ast->nodes[cast( long, m )].data )]
            dim as ushort had = mp->extra and _
                                (Tko.PF_MEMB_PRIVATE or Tko.PF_MEMB_PROTECTED)
            if had = 0 then mp->extra or= vis
        end if
    next
end sub
