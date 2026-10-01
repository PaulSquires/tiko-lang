'' visinst.bas -- the bodies of INSTANTIATED GENERIC PROCEDURES, walked like the program's.
''
'' Included from visibility.bas, after Walk_ and before Run.
''
'' An instantiation is re-parsed into fresh nodes that go on c.ast->extraTopLevel, not on
'' the module's statement list, so the walk from the root never reached one and every check
'' this pass makes was skipped inside it. fbc checks the instantiated body: fbc's own
'' generics/fail-container-noequals.bas calls 'IndexOf( v, x )' over a type with no
'' 'operator =', and fb/array.bi's 'if( a.items( k ) = v )' is error 20 -- measured on
'' fbc-modern 1.20, 2026-09-25. tiko reported the same comparison in plain code (TKO0720)
'' and, inside the instance, dropped the statement in silence. The TEMPLATE is still
'' walked from the root, where its operands have no types and nothing is concluded.
private sub WalkGenericInstances_ ( byref c as Ctx )
    '' c.ast->extraTopLevel is where an instantiation puts its re-parsed body, and the
    '' lambdas hoisted out of it (generic.bas); the instance's SYMBOL points at the body only
    '' later, so the list is what to walk.
    for i as long = 0 to c.ast->extraTopLevel.Count - 1
        dim as NodeId pn = cast( NodeId, c.ast->extraTopLevel[i] )
        if pn = NODE_NONE then continue for
        if c.ast->Kind( pn ) <> N_PROC then continue for
        '' INSIDE THE INSTANTIATION'S FRAME, so what this reports names the line that asked
        '' for it -- 'a > b' on a type with no '>' is reported here (T16, instframe.bas).
        dim as long fr = c.info->InstFrameOf( pn )
        c.diags->EnterInst( fr )
        Walk_( c, pn, TYPE_NONE )
        c.diags->LeaveInst( fr )
    next
end sub
