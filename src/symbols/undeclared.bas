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
    case "assert", "assertwarn", "clear", "deallocate", "dylibfree", "pcopy", "stop", _
         "system", "reset"
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

'' THE IMPORT A NAME WAS MEANT FOR: '#import "std/strings"' binds 'strings' alone, and
'' 'std.replace' was a bare TKO0743 with nothing to say why. The first import with a path
'' segment spelled nm (lower-cased) that is not its alias, as an index into
'' syms.importPaths, or -1.
private function ImportSegmentOf_( byref syms as Tko.SymbolTable, byref nm as string ) as long
    for k as long = 0 to syms.importPaths.Count - 1
        dim as string p = Tko.Text.LowerAscii( syms.importPaths[k] ) & "/"
        dim as long st = 1
        do
            dim as long sl = instr( st, p, "/" )
            if sl = 0 then exit do
            dim as string seg = mid( p, st, sl - st )
            if (seg = nm) andalso (seg <> syms.importAliases[k]) then return k
            st = sl + 1
        loop
    next
    return -1
end function

'' AN ALIAS ANOTHER FILE OF THE MODULE IMPORTED (M22): the index of that import in
'' syms.importAliases, or -1. Only a unit whose aliases are per file has any.
private function ImportedElsewhere_( byref syms as Tko.SymbolTable, byref nm as string ) as long
    if syms.aliasPairSym.Count = 0 then return -1
    for k as long = 0 to syms.importAliases.Count - 1
        if syms.importAliases[k] = nm then return k
    next
    return -1
end function

sub ReportUndeclared _
    ( byref ast as Tko.AstArena, byref names as Tko.Interner, _
      byref src as Tko.SourceManager, byref diags as Tko.DiagnosticEngine, _
      byref info as Tko.SemanticInfo, byref rst as Tko.Resolve.Stats, _
      byref reserved as FB.Array( of ulong ), byref syms as Tko.SymbolTable, _
      byval isRtl as RtlNameFn )

    dim as long total = ast.Count( )
    dim as FB.Array( of ubyte ) skip
    for i as long = 0 to total
        skip.Push( 0 )
    next
    '' '#assert' LINES, as file and line pairs.
    dim as FB.Array( of ulong ) ppAssert
    '' Every generic type's parameters, as file, header line and folded name -- see N_TYPE.
    dim as FB.Array( of ulong ) genHdr

    for i as long = 1 to total
        dim as Tko.NodeId n = cast( Tko.NodeId, i )
        if ast.Kind( n ) = Tko.N_TYPE then
            '' A GENERIC TYPE'S BASE CLAUSE NAMES ITS OWN PARAMETERS -- 'type D( of T ) extends
            '' B( of T )' -- and is resolved from OUTSIDE the type, where no template scope
            '' says T is a parameter. fb/comptr.bi's ComQIPtr is that line, and every com
            '' suite includes it. By LOCATION, because an instantiation re-parses the type:
            '' the reference reported is a fresh node, but on the same header line.
            dim as Tko.StmtPayload ptr gtp = @ast.stmts[cast( long, ast.nodes[i].data )]
            if (gtp->b <> Tko.NODE_NONE) andalso (ast.Kind( gtp->b ) = Tko.N_BLOCK) then
                dim as Tko.ListPayload ptr gpl = @ast.lists[cast( long, ast.nodes[cast( long, gtp->b )].data )]
                dim as Tko.DecodedLoc hl = src.Decode( ast.Loc( n ) )
                for k as long = 0 to gpl->count - 1
                    dim as Tko.NodeId pn = cast( Tko.NodeId, ast.children[gpl->first + k] )
                    if ast.Kind( pn ) = Tko.N_IDENT then
                        genHdr.Push( cast( ulong, hl.file ) ) : genHdr.Push( cast( ulong, hl.physLine ) )
                        genHdr.Push( cast( ulong, names.Fold( ast.idents[cast( long, ast.nodes[cast( long, pn )].data )].name ) ) )
                    end if
                next
            end if
        end if
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
        case Tko.N_TYPEDEF
            '' A TYPEDEF'S TARGET MAY NAME WHAT NOTHING DECLARES -- that is a FORWARD type,
            '' opaque until declared: 'type P as Foo ptr' compiles under fbc, and the Windows
            '' headers are full of them. Only a plain name, though: a QUALIFIED or GENERIC
            '' target, 'type X as FB.Foo' or 'as FB.Array( of Cell )', is fbc's error 3.
            '' Measured: in every other position an undeclared name is an error -- a DIM, a
            '' field, a parameter, a result, an EXTERN, a local -- pointer or not.
            dim as Tko.NodeId ta = ast.stmts[cast( long, ast.nodes[i].data )].a
            '' ...through its 'ptr' and 'const' wrappers, each a nameless typeref around it.
            for wd as long = 1 to 16
                if (ta < 1) orelse (cast( long, ta ) > total) then exit for
                if ast.Kind( ta ) <> Tko.N_TYPEREF then exit for
                if ast.stmts[cast( long, ast.nodes[cast( long, ta )].data )].name <> Tko.INTERN_NONE then exit for
                ta = ast.stmts[cast( long, ast.nodes[cast( long, ta )].data )].a
            next
            if (ta > 0) andalso (cast( long, ta ) <= total) then
                if ast.Kind( ta ) = Tko.N_TYPEREF then
                    dim as Tko.StmtPayload ptr tap = @ast.stmts[cast( long, ast.nodes[cast( long, ta )].data )]
                    if (tap->ownerName = Tko.INTERN_NONE) andalso (tap->count = 0) then skip[cast( long, ta )] = 1
                end if
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
        '' ...BUT ONLY A RUNTIME PROCEDURE THAT EXISTS. Every fb_ name was let through, so
        '' 'u = fb_StrRemove( u, "_" )' -- the ALIAS of fb/string.bi's FB.Remove, not a
        '' name anything declares -- bound nothing, and lowering declined the statement
        '' with an internal compiler error (TKO0994). Measured, fbc says 42 for it, and
        '' for 'fb_NoSuchThing( 1 )', while 'fb_StrLen' and 'fb_ArrayRedimEx' are
        '' predeclared. The test is the runtime table lowering calls through.
        if left( nm, 3 ) = "fb_" then
            if isRtl = 0 then continue for
            if isRtl( nm ) then continue for
        end if
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
        dim as string modOf = syms.HiddenModuleOf( rawNm )
        if len( modOf ) > 0 then
            diags.Report( Tko.TKO0860, Tko.PointRange( ast.Loc( id ) ), names.Spelling( rawNm ), modOf )
            continue for
        end if
        diags.Report( d, Tko.PointRange( ast.Loc( id ) ), names.Spelling( rawNm ) )
        if d = Tko.TKO0743 then
            dim as long ik = ImportSegmentOf_( syms, nm )
            if ik >= 0 then
                diags.AddNote( Tko.TKO0907, Tko.PointRange( cast( Tko.SourceLoc, syms.importLocs[ik] ) ), _
                               syms.importAliases[ik], syms.importPaths[ik] )
            end if
            ik = ImportedElsewhere_( syms, nm )
            if ik >= 0 then
                diags.AddNote( Tko.TKO0940, Tko.PointRange( cast( Tko.SourceLoc, syms.importLocs[ik] ) ), _
                               syms.importAliases[ik] )
            end if
        end if
    next

    '' A TYPE NAME NOTHING DECLARES -- 'dim as Foo a', fbc's 14; 'type X as Foo', its 71;
    '' a parameter, its 59; 'type CellArray as FB.Array( of Cell )' with no Array declared.
    '' tiko accepted every one in silence: the declaration got no type and whatever
    '' used it lowered to nothing, or to 'local void'. Resolve notes the reference when
    '' its lookup gives up, outside a template; it is reported only if nothing has typed
    '' it by now, never from the prelude, once per line, and not beside a name already
    '' reported on that line.
    for i as long = 0 to rst.unresolvedTypes.Count - 1
        dim as Tko.NodeId id = cast( Tko.NodeId, rst.unresolvedTypes[i] )
        if (id < 1) orelse (cast( long, id ) > total) then continue for
        if skip[cast( long, id )] = 1 then continue for
        if ast.Kind( id ) <> Tko.N_TYPEREF then continue for
        if info.TypeOf_( id ) <> Tko.TYPE_NONE then continue for
        if info.RefOf( id ) <> Tko.SYMBOL_NONE then continue for
        if src.IsBuiltin( ast.Loc( id ) ) then continue for
        dim as Tko.StmtPayload ptr tp = @ast.stmts[cast( long, ast.nodes[cast( long, id )].data )]
        if tp->name = Tko.INTERN_NONE then continue for
        dim as string tn = names.Spelling( tp->name )
        '' A NAME THE COMPILER MADE is never the user's to have declared: a lambda's closure
        '' type, '__tko_closure_...', is what an unsupported capture leaves behind.
        if left( lcase( tn ), 6 ) = "__tko_" then continue for
        if tp->ownerName <> Tko.INTERN_NONE then tn = names.Spelling( tp->ownerName ) & "." & tn
        dim as Tko.DecodedLoc dl = src.Decode( ast.Loc( id ) )
        dim as boolean seen = false
        if tp->ownerName = Tko.INTERN_NONE then
            dim as ulong fnm = cast( ulong, names.Fold( tp->name ) )
            for k as long = 0 to genHdr.Count - 3 step 3
                if (genHdr[k] = cast( ulong, dl.file )) andalso (genHdr[k + 1] = cast( ulong, dl.physLine )) _
                   andalso (genHdr[k + 2] = fnm) then seen = true
            next
        end if
        for k as long = 0 to done.Count - 2 step 2
            if (done[k] = cast( ulong, dl.file )) andalso _
               (done[k + 1] = cast( ulong, dl.physLine )) then seen = true
        next
        if seen then continue for
        done.Push( cast( ulong, dl.file ) )
        done.Push( cast( ulong, dl.physLine ) )
        diags.Report( Tko.TKO0808, Tko.PointRange( ast.Loc( id ) ), tn )
        dim as long dot = instr( tn, "." )
        if dot > 1 then
            dim as long ik = ImportedElsewhere_( syms, Tko.Text.LowerAscii( left( tn, dot - 1 ) ) )
            if ik >= 0 then
                diags.AddNote( Tko.TKO0940, Tko.PointRange( cast( Tko.SourceLoc, syms.importLocs[ik] ) ), _
                               syms.importAliases[ik] )
            end if
        end if
    next
end sub
