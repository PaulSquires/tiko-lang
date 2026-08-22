'' driver.bas -- see driver.bi

#include once "driver/driver.bi"
#include once "driver/cmdline.bi"
#include once "support/text.bi"
#include once "pp/pp.bi"
#include once "parser/expr.bi"
#include once "parser/parser.bi"
#include once "symbols/collect.bi"
#include once "symbols/resolve.bi"
#include once "symbols/mangle.bi"
#include once "symbols/check.bi"
#include once "mir/lower.bi"
#include once "mir/dump.bi"
#include once "mir/verify.bi"
#include once "mir/rtl.bi"
#include once "types/udtlayout.bi"

namespace Fbx

'' The context members are constructed in declaration order, so the source manager
'' can take the interner's address and the engine can take the manager's.
constructor CompilerContext( )
    '' Keywords are interned FIRST and nothing may intern before them: the keyword
    '' map is an array indexed by InternId and depends on ids 1..N being contiguous.
    Fbx.Lex.InitKeywords( this.names, this.keywords )
    dim as Fbx.TargetLayout tgt = Fbx.DefaultTargetLayout( )
    this.types.Attach( @this.names, tgt )
    this.sources.Attach( @this.names )
    this.diags.Attach( @this.sources )
end constructor

end namespace

namespace Fbx.Driver

'' The preprocessor's view of the command line: include paths and -d defines.
private function MakePpConfig( byref ctx as Fbx.CompilerContext ) as Fbx.PpConfig
    dim as Fbx.PpConfig cfg
    cfg.includePaths = @ctx.options.includePaths
    cfg.defines = @ctx.options.defines
    cfg.targetIsWindows = Fbx.TargetIsWindows( ctx.options.target )
    cfg.targetIs64 = Fbx.TargetIs64( ctx.options.target )
    cfg.reportUnsupported = true
    return cfg
end function

private sub ApplyDiagPolicy _
    ( byref ctx as Fbx.CompilerContext )

    ctx.diags.SetMaxErrors( ctx.options.maxErrors )
    ctx.diags.SetColorMode( ctx.options.colorMode )
    ctx.diags.SetFormat( ctx.options.diagFormat )
    ctx.diags.SetWarningsAsErrors( ctx.options.warningsAsErrors )

    for each nm as string in ctx.options.ignoredDiags
        ctx.diags.Ignore( Fbx.DiagIdFromName( nm ) )
    next
end sub

private sub DumpSourceTable( byref ctx as Fbx.CompilerContext )
    print "loaded "; ctx.sources.Count( ); " file(s)"
    for i as long = 1 to ctx.sources.Count( )
        dim as Fbx.FileId id = cast( Fbx.FileId, i )
        dim as Fbx.SourceFile ptr f = ctx.sources.FileAt( id )
        print using "  [&] & bytes=& lines=& encoding=& hash=&"; _
            i; ctx.sources.PathOf( id ); f->text.Count; _
            ctx.sources.ContentLineCount( id ); Fbx.Text.EncodingName( f->encoding ); _
            hex( f->contentHash, 8 )
    next
end sub

private sub ReportStats( byref ctx as Fbx.CompilerContext )
    print "--- stats ---"
    print "files            "; ctx.sources.Count( )
    print "source bytes     "; ctx.sources.TotalBytes( )
    print "interned strings "; ctx.names.Count( )
    print "intern bytes     "; ctx.names.BytesUsed( )
    print "errors           "; ctx.diags.ErrorCount( )
    print "warnings         "; ctx.diags.WarningCount( )
end sub

function Run( byref args as Fbx.StrVec ) as long
    dim as Fbx.CompilerContext ctx

    dim as boolean cmdOk = Fbx.Cmdline.Parse( args, ctx.options, ctx.diags )
    ApplyDiagPolicy( ctx )

    '' THE TARGET DECIDES THE LAYOUT, and it is only known now. The context is built
    '' before the command line is parsed -- the source manager needs the interner's
    '' address, and the diagnostic engine the manager's -- so the constructor takes the
    '' HOST's layout and this replaces it. Nothing has been laid out yet: builtin sizes
    '' are computed on demand from 'target' and no layout is cached.
    ctx.types.Attach( @ctx.names, Fbx.TargetLayoutFor( ctx.options.target ) )

    if cmdOk = false then
        ctx.diags.Flush( )
        return Fbx.EXIT_CMDLINE
    end if

    '' --version and --help answer and stop, even with other options present.
    if ctx.options.showVersion then
        print Fbx.Cmdline.VersionText( );
        return Fbx.EXIT_OK
    end if
    if ctx.options.showHelp then
        print Fbx.Cmdline.HelpText( ctx.options.helpCategory );
        return Fbx.EXIT_OK
    end if

    if ctx.options.inputs.IsEmpty( ) then
        ctx.diags.ReportGlobal( Fbx.FBX0102 )
        ctx.diags.Flush( )
        return Fbx.EXIT_CMDLINE
    end if

    '' ---- load every input -------------------------------------------------
    dim as double tLoadStart = timer
    for each inputPath as string in ctx.options.inputs
        dim as ustring why = ""
        dim as Fbx.FileId id = ctx.sources.LoadFile( inputPath, why )

        if id = Fbx.FILE_NONE then
            ctx.diags.ReportGlobal( Fbx.FBX0001, inputPath, Fbx.Text.UStringToUtf8( why ) )
            continue for
        end if

        dim as Fbx.SourceFile ptr f = ctx.sources.FileAt( id )
        if f->text.Count = 0 then
            ctx.diags.ReportGlobal( Fbx.FBX0002, ctx.sources.PathOf( id ) )
        elseif f->encoding = Fbx.Text.ENC_BYTES then
            '' Point at the offending byte rather than blaming the whole file.
            dim as Fbx.SourceLoc at = ctx.sources.LocFor( id, f->firstBadByte )
            ctx.diags.Report( Fbx.FBX0003, Fbx.PointRange( at ), ctx.sources.PathOf( id ) )
        end if

        if ctx.options.verbose then
            print "fbx: loaded "; ctx.sources.PathOf( id ); _
                  " ("; f->text.Count; " bytes, "; _
                  Fbx.Text.EncodingName( f->encoding ); ")"
        end if
    next

    dim as double tLoad = timer - tLoadStart

    '' ---- what this build can do -------------------------------------------
    if ctx.options.dumpTypes then
        print Fbx.DumpTypes( ctx.types );
    elseif ctx.options.dumpSource then
        if ctx.diags.HasErrors( ) = false then DumpSourceTable( ctx )
    elseif ctx.options.lexOnly then
        '' The corpus gate: lex everything, report what came out, produce no dump.
        dim as longint tokens = 0, invalid = 0, bytes_ = 0
        dim as double tLexStart = timer
        for i as long = 1 to ctx.sources.Count( )
            dim as Fbx.FileId id = cast( Fbx.FileId, i )
            dim as Fbx.Lex.Result r
            Fbx.Lex.Run( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, r )
            tokens += r.tokens.Count
            invalid += r.invalidCount
            bytes_ += ctx.sources.FileAt( id )->text.Count
        next
        dim as double tLex = timer - tLexStart

        print "lexed "; ctx.sources.Count( ); " file(s), "; bytes_; " bytes, "; _
              tokens; " tokens, "; invalid; " invalid"

        if ctx.options.timePasses then
            dim as double mb = bytes_ / 1048576.0
            print using "  load  ##.### s  (##.# MB/s)"; tLoad; mb / iif( tLoad > 0, tLoad, 1 )
            print using "  lex   ##.### s  (##.# MB/s)"; tLex; mb / iif( tLex > 0, tLex, 1 )
        end if
    elseif ctx.options.dumpRtl then
        '' The inventory does not depend on any input, so it is answered before the
        '' sources are even looked at.
        print Fbx.Mir.DumpRtl( ctx.options.target = Fbx.TARGET_WIN32 );

    elseif ctx.options.dumpSymbols orelse ctx.options.resolveOnly orelse _
           ctx.options.dumpMangle orelse ctx.options.checkOnly orelse _
           ctx.options.dumpIr orelse ctx.options.dumpUdt then
        for i as long = 1 to ctx.sources.Count( )
            dim as Fbx.FileId id = cast( Fbx.FileId, i )
            dim as Fbx.PpResult pr
            dim as Fbx.PpConfig cfg = MakePpConfig( ctx )
            dim as Fbx.PpStream st
            Fbx.PpOpen( st, ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, cfg, pr )

            dim as Fbx.AstArena ast
            dim as Fbx.ParserState p
            p.toks = @pr.tokens
            p.stream = @st
            p.litPool = @pr.literals
            p.ast = @ast
            p.src = @ctx.sources
            p.names = @ctx.names
            p.diags = @ctx.diags
            p.pos = 0

            dim as Fbx.NodeId root = Fbx.Parse.Unit( p )
            Fbx.PpClose( st )

            dim as Fbx.SymbolTable syms
            syms.Attach( @ctx.names )
            dim as Fbx.SemanticInfo info
            Fbx.Collect.Run( ast, root, syms, ctx.names, ctx.types, ctx.diags, info )

            if ctx.options.dumpUdt then
                dim as Fbx.Resolve.Stats rst
                Fbx.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                dim as Fbx.UdtLayouts store
                Fbx.ComputeUdtLayouts( syms, ctx.types, store )
                print Fbx.DumpUdtLayouts( store, ctx.types, ctx.names, syms );
            elseif ctx.options.dumpIr then
                '' MIR needs the full frontend in front of it: resolve binds names,
                '' check gives every expression a type, and lowering reads both.
                dim as Fbx.Resolve.Stats rst
                Fbx.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                dim as Fbx.Check.Stats cst
                Fbx.Check.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                               info, cst )
                dim as Fbx.Mir.MirModule mm
                dim as Fbx.Mir.LowerStats lst
                dim as Fbx.UdtLayouts udts
                Fbx.ComputeUdtLayouts( syms, ctx.types, udts )
                Fbx.Mir.Lower( ast, root, syms, ctx.types, ctx.names, info, _
                               ctx.sources, udts, mm, lst )
                print Fbx.Mir.DumpModule( mm, ctx.names );
                '' The verifier is an ICE check, not a diagnostic: a failure means
                '' the compiler built something malformed.
                dim as Fbx.Mir.VerifyResult vr = Fbx.Mir.Verify( mm, ctx.names )
                if vr.failures > 0 then
                    print "verify: " & str( vr.failures ) & " FAILURES"
                    print vr.report;
                else
                    print "verify: ok"
                end if
                dim as string sum_ = "lowered: " & str( lst.functions ) & _
                      " functions, " & str( lst.blocks ) & " blocks, " & _
                      str( lst.insts ) & " insts, " & str( lst.skipped ) & _
                      " statements not lowered, " & str( lst.scopeImbalance ) & _
                      " scope imbalance"
                '' Only ever printed when non-zero: it means the label pre-scan and
                '' the lowering disagree about scope depth, which would make a goto
                '' emit the wrong cleanups. Silence here is the assertion holding.
                if lst.labelDepthMismatch > 0 then
                    sum_ += ", " & str( lst.labelDepthMismatch ) & _
                            " LABEL DEPTH MISMATCH"
                end if
                '' Also only when non-zero. A repaired block is well-formed IR
                '' standing in for a statement that did not lower, so the number is
                '' worth reading even though it is not itself a failure.
                if lst.blocksRepaired > 0 then
                    sum_ += ", " & str( lst.blocksRepaired ) & " blocks repaired"
                end if
                print sum_
                '' The breakdown of what did NOT lower, printed only when there is
                '' something to say. One 'skipped' total invites guessing at the next
                '' thing to implement; this is read off instead.
                for i as long = 0 to lst.skippedKind.Count - 1
                    if lst.skippedKind[i] = 0 then continue for
                    print "  unlowered " & _
                          Fbx.NodeKindName( cast( Fbx.NodeKind, i ) ) & " " & _
                          str( lst.skippedKind[i] )
                next
                '' Declines part-way THROUGH a statement, by what they were inside.
                for i as long = 0 to lst.innerKind.Count - 1
                    if lst.innerKind[i] = 0 then continue for
                    print "  inside " & _
                          Fbx.NodeKindName( cast( Fbx.NodeKind, i ) ) & " " & _
                          str( lst.innerKind[i] )
                next
                for i as long = 0 to lst.skippedIntrOp.Count - 1
                    print "  unlowered intrinsic " & _
                          Fbx.TokenKindName( cast( Fbx.TokenKind, lst.skippedIntrOp[i] ) ) & _
                          " " & str( lst.skippedIntrN[i] )
                next
                '' WHY the N_AMBIGUOUS statements declined -- the bucket that is 90% of
                '' the total, split into the halves that need different work.
                if lst.ambCallUnbound > 0 then
                    print "  amb call-unbound " & str( lst.ambCallUnbound )
                end if
                if lst.ambCallNoCode > 0 then
                    print "  amb call-nocode " & str( lst.ambCallNoCode )
                end if
                if lst.ambAssign > 0 then print "  amb assign " & str( lst.ambAssign )
                if lst.ambResultNoSlot > 0 then
                    print "  amb result-noslot " & str( lst.ambResultNoSlot )
                end if
                if lst.varByref > 0 then print "  var byref " & str( lst.varByref )
                if lst.ambOther > 0 then print "  amb other " & str( lst.ambOther )
                '' Which LINE of the lowering gave up, which is the thing to go and read.
                for i as long = 0 to lst.skipSiteN.Count - 1
                    print "  skip-site " & _
                          ctx.names.Spelling( cast( Fbx.InternId, lst.skipSiteFile[i] ) ) & _
                          ":" & str( lst.skipSiteLine[i] ) & " " & str( lst.skipSiteN[i] )
                next
                for i as long = 0 to lst.ambUnboundShape.Count - 1
                    if lst.ambUnboundShape[i] = 0 then continue for
                    print "  amb-unbound-shape " & _
                          Fbx.NodeKindName( cast( Fbx.NodeKind, i ) ) & " " & _
                          str( lst.ambUnboundShape[i] )
                next
                for i as long = 0 to lst.ambOtherShape.Count - 1
                    if lst.ambOtherShape[i] = 0 then continue for
                    print "  amb-other-shape " & _
                          Fbx.NodeKindName( cast( Fbx.NodeKind, i ) ) & " " & _
                          str( lst.ambOtherShape[i] )
                next
                for i as long = 0 to lst.ambOtherClass.Count - 1
                    if lst.ambOtherClass[i] = 0 then continue for
                    print "  amb-other-class " & str( i ) & " " & str( lst.ambOtherClass[i] )
                next
                if lst.ambMemberBaseTyped > 0 then
                    print "  amb member-base-typed " & str( lst.ambMemberBaseTyped )
                end if
                if lst.ambMemberBaseUntyped > 0 then
                    print "  amb member-base-untyped " & str( lst.ambMemberBaseUntyped )
                end if
                for i as long = 0 to lst.ambMemberNames.Count - 1
                    print "  amb-member-name " & _
                          ctx.names.Spelling( cast( Fbx.InternId, lst.ambMemberNames[i] ) )
                next
                for i as long = 0 to lst.ambUnboundNames.Count - 1
                    print "  amb-unbound-name " & _
                          ctx.names.Spelling( cast( Fbx.InternId, lst.ambUnboundNames[i] ) )
                next
            elseif ctx.options.checkOnly then
                dim as Fbx.Resolve.Stats rst
                Fbx.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                dim as Fbx.Check.Stats cst
                Fbx.Check.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                               info, cst )
                print Fbx.Check.Dump( ast, ctx.sources, ctx.types, ctx.names, info, cst );
            elseif ctx.options.dumpMangle then
                '' Mangling needs the parameter TYPES, so it runs after Resolve --
                '' but the reference-binding report is not wanted here.
                dim as Fbx.Resolve.Stats rst
                Fbx.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                print Fbx.Mangle.Dump( ast, root, syms, ctx.names, ctx.types, info );
            elseif ctx.options.resolveOnly then
                dim as Fbx.Resolve.Stats rst
                Fbx.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                print Fbx.Resolve.Dump( ast, syms, ctx.types, ctx.names, info, rst );
            else
                print Fbx.Collect.Dump( syms, ctx.names, ctx.types );
            end if
        next

    elseif ctx.options.dumpAst orelse ctx.options.parseOnly then
        dim as longint nodes = 0
        dim as double tParseStart = timer
        for i as long = 1 to ctx.sources.Count( )
            dim as Fbx.FileId id = cast( Fbx.FileId, i )
            '' PULL: the parser drives the preprocessor, rather than consuming a
            '' vector the preprocessor finished building first.
            dim as Fbx.PpResult pr
            dim as Fbx.PpConfig cfg = MakePpConfig( ctx )
            dim as Fbx.PpStream st
            Fbx.PpOpen( st, ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, cfg, pr )

            dim as Fbx.AstArena ast
            dim as Fbx.ParserState p
            p.toks = @pr.tokens
            p.stream = @st
            p.litPool = @pr.literals
            p.ast = @ast
            p.src = @ctx.sources
            p.names = @ctx.names
            p.diags = @ctx.diags
            p.pos = 0

            dim as Fbx.NodeId root = Fbx.Parse.Unit( p )
            Fbx.PpClose( st )
            nodes += ast.Count( )
            if ctx.options.dumpAst then
                print Fbx.Parse.DumpTree( ast, ctx.sources, ctx.names, root );
            end if
        next
        dim as double tParse = timer - tParseStart
        if ctx.options.parseOnly then
            '' Count INPUTS, not sources: the preprocessor creates virtual files for
            '' '##' pasting and they are not what the user asked about.
            print "parsed "; ctx.options.inputs.Count; " file(s), "; nodes; " nodes"
            if ctx.options.timePasses then
                print using "  parse ##.### s"; tParse
            end if
        end if

    elseif ctx.options.parseExpr then
        '' One expression per source line. This is the expression parser's test hook
        '' and the harness the precedence differential runs through.
        for i as long = 1 to ctx.sources.Count( )
            dim as Fbx.FileId id = cast( Fbx.FileId, i )
            dim as Fbx.Lex.Result lr
            Fbx.Lex.Run( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, lr )

            dim as Fbx.AstArena ast
            dim as Fbx.ParserState p
            p.toks = @lr.tokens
            p.litPool = @lr.literals
            p.ast = @ast
            p.src = @ctx.sources
            p.names = @ctx.names
            p.diags = @ctx.diags
            p.pos = 0

            dim as long lineNo = 0
            while p.pos < lr.tokens.Count
                dim as Fbx.TokenKind k = cast( Fbx.TokenKind, lr.tokens[p.pos].kind )
                if k = Fbx.TK_EOF then exit while
                if k = Fbx.TK_EOL then
                    p.pos += 1
                    continue while
                end if
                lineNo += 1
                dim as Fbx.NodeId n = Fbx.Parse.OneExpression( p )
                print "--- expression "; lineNo
                print Fbx.Parse.Dump( ast, ctx.sources, ctx.names, n );
                '' Resynchronise on the next line boundary.
                while p.pos < lr.tokens.Count
                    dim as Fbx.TokenKind k2 = cast( Fbx.TokenKind, lr.tokens[p.pos].kind )
                    if k2 = Fbx.TK_EOF then exit while
                    p.pos += 1
                    if k2 = Fbx.TK_EOL then exit while
                wend
            wend
            print "nodes: "; ast.Count( )
        next

    elseif ctx.options.ppOnly then
        dim as longint tokens = 0, includes = 0, expansions = 0
        dim as double tPpStart = timer
        for i as long = 1 to ctx.sources.Count( )
            dim as Fbx.PpResult r
            dim as Fbx.PpConfig cfg = MakePpConfig( ctx )
            Fbx.PpRun( ctx.sources, cast( Fbx.FileId, i ), ctx.names, ctx.keywords, _
                       ctx.diags, cfg, r )
            tokens += r.tokens.Count
            includes += r.includeCount
            expansions += r.expansionCount
        next
        dim as double tPp = timer - tPpStart
        print "preprocessed "; ctx.sources.Count( ); " file(s), "; tokens; " tokens, "; _
              includes; " includes, "; expansions; " expansions"
        if ctx.options.timePasses then
            print using "  pp    ##.### s"; tPp
        end if

    elseif ctx.options.dumpTokens then
        for i as long = 1 to ctx.sources.Count( )
            dim as Fbx.FileId id = cast( Fbx.FileId, i )
            if ctx.options.dumpPp then
                dim as Fbx.PpResult r
                dim as Fbx.PpConfig cfg = MakePpConfig( ctx )
                Fbx.PpRun( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, cfg, r )
                print Fbx.PpDump( ctx.sources, ctx.names, r );
            else
                dim as Fbx.Lex.Result r
                Fbx.Lex.Run( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, r )
                print Fbx.Lex.Dump( ctx.sources, id, ctx.names, r );
            end if
        next
    else
        '' Honest rather than silent: the pipeline genuinely stops here in this
        '' build, and each later phase replaces this branch with real work.
        ctx.diags.ReportGlobal( Fbx.FBX0992, _
            "compilation -- this build implements the phase 2 skeleton only " & _
            "(source loading and diagnostics); try --dump-source" )
    end if

    ctx.diags.Flush( )
    if ctx.options.stats then ReportStats( ctx )

    if ctx.diags.HasErrors( ) then return Fbx.EXIT_USER_ERROR
    return Fbx.EXIT_OK
end function

end namespace
