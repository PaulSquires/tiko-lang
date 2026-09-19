'' undeclared.bas -- A NAME NOTHING DECLARED: fbc's error 42, "Variable not declared".
''
'' Included from the end of checkdump.bas, inside the Check namespace.
''
'' 'a = b + c' with none of the three declared was accepted in silence: the statement
'' lowered to nothing, the program built and ran, and the only trace was "1 statements
'' not lowered" under --dump-ir. Measured on fbc-modern 1.20 and 1.10.1, a name nothing
'' declares is error 42 wherever a value is read or written -- the target of an
'' assignment, an operand, an argument, a callee, a subscripted name, a member access's
'' base, a WITH subject, a FOR counter, a file number, a CONST or ENUM initialiser, an
'' array bound.
''
'' THE CANDIDATES ARE RESOLVE'S: identifiers in expression position that bound no
'' symbol, were no keyword, named no generic parameter and sat in no generic template
'' (resolveunbound.bas). Not every one is undeclared -- which is why TKO0743 was
'' retired once, 2026-09-02 -- and what else can bind nothing was measured by running
'' this over the whole vendored corpus against fbc's verdict on every file:
''
''   - a BUILTIN that is not a keyword: 'hex', 'val' (IsTypedIntrinsicName), and the
''     procedures lowering claims by spelling, 'deallocate', 'clear' (BuiltinProcName_);
''   - fbc's RUNTIME, which it predeclares: 'procptr( fb_ArrayRedimEx )' compiles;
''   - what is not compiled or not a value: an 'assert' argument (a macro that expands
''     to nothing without -g), an '#assert' operand (a pre-processor expression, where
''     an unknown name is 0), 'offsetof''s field, an OPEN device, a generic's parameter
''     list;
''   - a name Check gave a TYPE, resolved by something Resolve cannot see;
''   - a parameter DEFAULT, which is TKO0675's, the older and narrower rule, and a name
''     '#pragma reserve' took, which is TKO0770's -- fbc's 325 and nothing else.
''
'' ONE PER LINE, because fbc reports one per statement and skips to the end of the line:
'' measured, 'a = b + c' is error 42 for 'a' alone, and 'print zz : print yy' for 'zz'.
''
'' 'procptr( zz )' is fbc's error 8, "Undefined symbol", rather than 42 (TKO0783). A name
'' declared BELOW its use is one of these too -- Resolve leaves it unbound (see
'' resolveunbound.bas) -- and a unit whose '#lang' was refused is not asked at all (the
'' driver), because in 'qb' or 'fblite' an undeclared name is an implicit variable.

'' The builtin PROCEDURES that reach here unbound: the prelude does not declare them and
'' lowering claims them by spelling (mir/lowerbuiltin.bas, mir/lowerintr.bas). Measured,
'' each of these compiles under fbc with nothing declaring it.
private function BuiltinProcName_( byref nm as string ) as boolean
    select case nm
    case "assert", "assertwarn", "clear", "deallocate", "dylibfree", "erfn", "ermn", _
         "getkey", "out", "pcopy", "pmap", "pointcoord", "screenlist", "setdate", _
         "settime", "stop", "system", "wait", "reset"
        return true
    end select
    return false
end function

'' What the pre-pass marks a node with: 1 to leave it alone, SKIP_PROCPTR to report it
'' as 'procptr''s operand.
const SKIP_PROCPTR as ubyte = 2

'' Mark every node in [lo, hi]. A call is built BOTTOM-UP IN SOURCE ORDER -- its target,
'' then each argument, then the call node -- so an argument's subtree is exactly the ids
'' after the previous one's root and up to its own.
private sub MarkRange_( byref skip as FB.Array( of ubyte ), byval lo as long, byval hi as long )
    if lo < 1 then lo = 1
    if hi > skip.Count - 1 then hi = skip.Count - 1
    for i as long = lo to hi
        skip[i] = 1
    next
end sub

private function IdentSpelled_ _
    ( byref ast as Tko.AstArena, byref names as Tko.Interner, byval n as Tko.NodeId ) as string
    if n = Tko.NODE_NONE then return ""
    if ast.Kind( n ) <> Tko.N_IDENT then return ""
    return Tko.Text.LowerAscii( names.Spelling( _
        ast.idents[cast( long, ast.nodes[cast( long, n )].data )].name ) )
end function

sub ReportUndeclared _
    ( byref ast as Tko.AstArena, byref names as Tko.Interner, _
      byref src as Tko.SourceManager, byref diags as Tko.DiagnosticEngine, _
      byref info as Tko.SemanticInfo, byref rst as Tko.Resolve.Stats, _
      byref reserved as FB.Array( of ulong ), byref syms as Tko.SymbolTable )

    dim as long total = ast.Count( )
    dim as FB.Array( of ubyte ) skip
    for i as long = 0 to total
        skip.Push( 0 )
    next
    '' '#assert' LINES, as file and line pairs.
    dim as FB.Array( of ulong ) ppAssert

    for i as long = 1 to total
        dim as Tko.NodeId n = cast( Tko.NodeId, i )
        select case ast.Kind( n )
        case Tko.N_PARAM
            dim as Tko.NodeId d = ast.stmts[cast( long, ast.nodes[i].data )].b
            if (d > 0) andalso (cast( long, d ) <= total) then skip[cast( long, d )] = 1
        case Tko.N_TYPE, Tko.N_PROC
            '' A generic's parameter list, '( of T, U )': in 'b' on a type, 'c' on a
            '' procedure. Each name DECLARES a parameter.
            dim as Tko.StmtPayload ptr sp = @ast.stmts[cast( long, ast.nodes[i].data )]
            dim as Tko.NodeId pl = iif( ast.Kind( n ) = Tko.N_TYPE, sp->b, sp->c )
            if pl <> Tko.NODE_NONE then
                if ast.Kind( pl ) = Tko.N_BLOCK then
                    dim as Tko.ListPayload ptr lp = @ast.lists[cast( long, ast.nodes[cast( long, pl )].data )]
                    for k as long = 0 to lp->count - 1
                        skip[cast( long, ast.children[lp->first + k] )] = 1
                    next
                end if
            end if
        case Tko.N_CALL
            dim as Tko.ListPayload ptr cp = @ast.lists[cast( long, ast.nodes[i].data )]
            dim as string cn = IdentSpelled_( ast, names, cp->target )
            if (cn = "assert") orelse (cn = "assertwarn") then
                MarkRange_( skip, cast( long, cp->target ), i )
            elseif (cn = "offsetof") andalso (cp->count >= 2) then
                MarkRange_( skip, cast( long, ast.children[cp->first] ) + 1, _
                            cast( long, ast.children[cp->first + cp->count - 1] ) )
            elseif (cn = "procptr") andalso (cp->count >= 1) then
                '' 'procptr( zz )' is fbc's error 8, "Undefined symbol", not 42.
                dim as Tko.NodeId pa = cast( Tko.NodeId, ast.children[cp->first] )
                if ast.Kind( pa ) = Tko.N_IDENT then skip[cast( long, pa )] = SKIP_PROCPTR
                '' ...AND ONE THAT BINDS HAS TO BIND A PROCEDURE. Measured: 'procptr( v )'
                '' over a variable, a procedure-pointer variable, a CONST, an enum
                '' constant, a TYPE or a namespace's variable is fbc's error 24, and over a
                '' field its 209. Asked here because this runs once, after Check has bound
                '' 'T.m' members.
                select case ast.Kind( pa )
                case Tko.N_INT_LIT, Tko.N_FLOAT_LIT, Tko.N_STRING_LIT, Tko.N_ADDROF
                    '' No name at all -- 'procptr( 1 )', 'procptr( @f )' -- is fbc's 8 too.
                    '' ('procptr( f( ) )' is not: fbc takes it, as the procedure f.)
                    diags.Report( Tko.TKO0791, Tko.PointRange( ast.Loc( pa ) ) )
                case Tko.N_IDENT, Tko.N_MEMBER
                    dim as Tko.Symbol ptr ps = syms.SymbolAt( info.RefOf( pa ) )
                    if ps <> 0 then
                        if ps->kind <> cast( ubyte, Tko.SYM_PROC ) then
                            diags.Report( Tko.TKO0785, Tko.PointRange( ast.Loc( pa ) ), _
                                          names.Spelling( ps->name ) )
                        end if
                    elseif (ast.Kind( pa ) = Tko.N_MEMBER) andalso (cp->count = 1) then
                        '' 'procptr( T.zz )' over a TYPE with no member zz: fbc's error 8.
                        '' Only with no second argument -- 'procptr( T.m, virtual )' and a
                        '' signature that selected nothing are Check's to leave unbound.
                        dim as Tko.BinaryPayload ptr mb = _
                            @ast.binaries[cast( long, ast.nodes[cast( long, pa )].data )]
                        dim as Tko.Symbol ptr ts = syms.SymbolAt( info.RefOf( mb->lhs ) )
                        dim as string mn = IdentSpelled_( ast, names, mb->rhs )
                        if (ts <> 0) andalso (len( mn ) > 0) then
                            if ts->kind = cast( ubyte, Tko.SYM_UDT ) then
                                diags.Report( Tko.TKO0739, Tko.PointRange( ast.Loc( pa ) ), _
                                              names.Spelling( ts->name ), mn )
                            end if
                        end if
                    end if
                end select
            end if
        case Tko.N_AMBIGUOUS
            '' The PAREN-LESS call statement, 'assert x = 1': 'a' is the callee.
            dim as Tko.StmtPayload ptr ap = @ast.stmts[cast( long, ast.nodes[i].data )]
            dim as string an = IdentSpelled_( ast, names, ap->a )
            if (ap->op = 0) andalso ((an = "assert") orelse (an = "assertwarn")) then
                MarkRange_( skip, cast( long, ap->a ), i )
            end if
        case Tko.N_INTRINSIC
            dim as Tko.StmtPayload ptr op = @ast.stmts[cast( long, ast.nodes[i].data )]
            if op->op = cast( ushort, Tko.KW_OPEN ) then
                select case IdentSpelled_( ast, names, op->a )
                case "cons", "err", "scrn", "pipe", "lpt", "com"
                    skip[cast( long, op->a )] = 1
                end select
            end if
        case Tko.N_ASSERT
            dim as Tko.DecodedLoc al = src.Decode( ast.Loc( n ) )
            ppAssert.Push( cast( ulong, al.file ) )
            ppAssert.Push( cast( ulong, al.physLine ) )
        end select
    next

    '' Every line reported, as file and line pairs -- an instantiation's body is walked
    '' apart from the rest and would otherwise name its line again.
    dim as FB.Array( of ulong ) done
    for i as long = 0 to rst.unresolvedIds.Count - 1
        dim as Tko.NodeId id = cast( Tko.NodeId, rst.unresolvedIds[i] )
        if (id < 1) orelse (cast( long, id ) > total) then continue for
        if skip[cast( long, id )] = 1 then continue for
        if info.RefOf( id ) <> Tko.SYMBOL_NONE then continue for
        if info.TypeOf_( id ) <> Tko.TYPE_NONE then continue for
        dim as Tko.InternId rawNm = ast.idents[cast( long, ast.nodes[cast( long, id )].data )].name
        dim as boolean isReserved = false
        for k as long = 0 to reserved.Count - 1
            if cast( Tko.InternId, reserved[k] ) = rawNm then isReserved = true
        next
        if isReserved then continue for
        dim as string nm = IdentSpelled_( ast, names, id )
        if len( nm ) = 0 then continue for
        if IsTypedIntrinsicName( nm ) orelse BuiltinProcName_( nm ) then continue for
        if left( nm, 3 ) = "fb_" then continue for
        dim as Tko.DecodedLoc dl = src.Decode( ast.Loc( id ) )
        dim as boolean seen = false
        for k as long = 0 to ppAssert.Count - 2 step 2
            if (ppAssert[k] = cast( ulong, dl.file )) andalso _
               (ppAssert[k + 1] = cast( ulong, dl.physLine )) then seen = true
        next
        for k as long = 0 to done.Count - 2 step 2
            if (done[k] = cast( ulong, dl.file )) andalso _
               (done[k + 1] = cast( ulong, dl.physLine )) then seen = true
        next
        if seen then continue for
        done.Push( cast( ulong, dl.file ) )
        done.Push( cast( ulong, dl.physLine ) )
        dim as Tko.DiagId d = Tko.TKO0743
        if skip[cast( long, id )] = SKIP_PROCPTR then d = Tko.TKO0783
        diags.Report( d, Tko.PointRange( ast.Loc( id ) ), names.Spelling( rawNm ) )
    next
end sub
