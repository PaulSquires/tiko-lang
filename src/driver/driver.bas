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
#include once "symbols/visibility.bi"
#include once "mir/lower.bi"
#include once "mir/dump.bi"
#include once "mir/verify.bi"
#include once "codegen/abi.bi"
#include once "codegen/toolchain.bi"
#include once "codegen/llvmemit.bi"
#include once "mir/rtl.bi"
#include once "types/udtlayout.bi"
#include once "types/vtable.bi"

namespace Tko

'' The context members are constructed in declaration order, so the source manager
'' can take the interner's address and the engine can take the manager's.
constructor CompilerContext( )
    '' Keywords are interned FIRST and nothing may intern before them: the keyword
    '' map is an array indexed by InternId and depends on ids 1..N being contiguous.
    Tko.Lex.InitKeywords( this.names, this.keywords )
    dim as Tko.TargetLayout tgt = Tko.DefaultTargetLayout( )
    this.types.Attach( @this.names, tgt )
    this.sources.Attach( @this.names )
    this.diags.Attach( @this.sources )
end constructor

end namespace

namespace Tko.Driver

'' The preprocessor's view of the command line: include paths and -d defines.
private function MakePpConfig( byref ctx as Tko.CompilerContext ) as Tko.PpConfig
    dim as Tko.PpConfig cfg
    cfg.includePaths = @ctx.options.includePaths
    cfg.defines = @ctx.options.defines
    cfg.targetIsWindows = Tko.TargetIsWindows( ctx.options.target )
    cfg.targetIs64 = Tko.TargetIs64( ctx.options.target )
    cfg.reportUnsupported = true
    return cfg
end function

private sub ApplyDiagPolicy _
    ( byref ctx as Tko.CompilerContext )

    ctx.diags.SetMaxErrors( ctx.options.maxErrors )
    ctx.diags.SetColorMode( ctx.options.colorMode )
    ctx.diags.SetFormat( ctx.options.diagFormat )
    ctx.diags.SetWarningsAsErrors( ctx.options.warningsAsErrors )

    for each nm as string in ctx.options.ignoredDiags
        ctx.diags.Ignore( Tko.DiagIdFromName( nm ) )
    next
end sub

private sub DumpSourceTable( byref ctx as Tko.CompilerContext )
    print "loaded "; ctx.sources.Count( ); " file(s)"
    for i as long = 1 to ctx.sources.Count( )
        dim as Tko.FileId id = cast( Tko.FileId, i )
        dim as Tko.SourceFile ptr f = ctx.sources.FileAt( id )
        print using "  [&] & bytes=& lines=& encoding=& hash=&"; _
            i; ctx.sources.PathOf( id ); f->text.Count; _
            ctx.sources.ContentLineCount( id ); Tko.Text.EncodingName( f->encoding ); _
            hex( f->contentHash, 8 )
    next
end sub

private sub ReportStats( byref ctx as Tko.CompilerContext )
    print "--- stats ---"
    print "files            "; ctx.sources.Count( )
    print "source bytes     "; ctx.sources.TotalBytes( )
    print "interned strings "; ctx.names.Count( )
    print "intern bytes     "; ctx.names.BytesUsed( )
    print "errors           "; ctx.diags.ErrorCount( )
    print "warnings         "; ctx.diags.WarningCount( )
end sub

'' THE REST OF THE BUILD: IR to an object, and an object to an executable.
''
'' Separated from the emission above only so that the pass pipeline reads as one thing
'' and the toolchain as another. Every failure here is reported to stderr; none of them
'' is a source diagnostic, because none of them is about the program being compiled.
''
'' RETURNS AN EXIT CODE, not a boolean. The distinction the codes make is the one a
'' caller acts on: EXIT_NO_TOOLCHAIN means this machine is not set up, and rerunning
'' will fail the same way, while EXIT_TOOL_FAILED means clang or the linker rejected
'' this particular build. Collapsing them to 'false' threw that away, and returning
'' the boolean at all was what let the whole failure be discarded at the call site.
''
'' COMPILES ONE MODULE AND STOPS THERE. It used to link as well, from inside the
'' per-source loop, which is why more than one input could never work: each input
'' overwrote the previous one's '.ll' and object and then tried to link it alone. The
'' link is now done once, after every module is an object -- see LinkAll.
private function BuildFromIr _
    ( byref ctx as Tko.CompilerContext, byref irText as string, _
      byref td as Tko.Codegen.TargetDescription, byref objPath as string ) as long

    dim as long eh = freefile
    open err for output as #eh

    dim as Tko.Codegen.ToolPaths tools = _
        Tko.Codegen.FindTools( "", ctx.options.libPaths )
    if tools.found = false then
        print #eh, "tiko: " & tools.why
        close #eh
        return Tko.EXIT_NO_TOOLCHAIN
    end if

    '' THE INTERMEDIATE IS NAMED AFTER THE OBJECT, which is per-module. Naming it
    '' after the OUTPUT was the bug: two inputs producing one output raced for one
    '' '.ll', and the comment here used to say that must not happen while the code
    '' made it happen.
    dim as string irPath = objPath & ".ll"

    dim as long fh = freefile
    '' The function form of OPEN inside an IF condition confuses the parser here --
    '' it is spelled as its own statement instead, which is clearer anyway.
    dim as long orc = open( irPath for output as #fh )
    if orc <> 0 then
        print #eh, "tiko: cannot write '" & irPath & "'"
        close #eh
        return Tko.EXIT_TOOL_FAILED
    end if
    print #fh, irText;
    close #fh

    dim as long rc = Tko.Codegen.CompileIr( tools, td, irPath, objPath, _
                                            ctx.options.keepTemps )
    if rc <> 0 then
        print #eh, "tiko: clang failed on '" & irPath & "' (exit " & str( rc ) & ")"
        close #eh
        return Tko.EXIT_TOOL_FAILED
    end if
    if ctx.options.compileOnly then
        close #eh
        return Tko.EXIT_OK
    end if

    close #eh
    return Tko.EXIT_OK
end function

'' THE LINK, ONCE, OVER EVERY OBJECT the build produced or was handed.
private function LinkAll _
    ( byref ctx as Tko.CompilerContext, byref objs as Tko.StrVec, _
      byref td as Tko.Codegen.TargetDescription, byref keep as Tko.StrVec ) as long

    dim as long eh = freefile
    open err for output as #eh

    dim as Tko.Codegen.ToolPaths tools = _
        Tko.Codegen.FindTools( "", ctx.options.libPaths )
    if tools.found = false then
        print #eh, "tiko: " & tools.why
        close #eh
        return Tko.EXIT_NO_TOOLCHAIN
    end if

    dim as long rc = Tko.Codegen.LinkExe( tools, td, objs, ctx.options.outputPath )
    if rc <> 0 then
        print #eh, "tiko: link failed (exit " & str( rc ) & ")"
        close #eh
        return Tko.EXIT_TOOL_FAILED
    end if

    '' ONLY WHAT THIS BUILD MADE. An object the user named on the command line is
    '' theirs and is not deleted, however temporary it looks.
    if ctx.options.keepTemps = false then
        for i as long = 0 to keep.Count - 1
            kill( keep[i] )
        next
    end if
    close #eh
    return Tko.EXIT_OK
end function

function Run( byref args as Tko.StrVec ) as long
    dim as Tko.CompilerContext ctx

    '' THE EXIT CODE OF A FAILURE THAT IS NOT A DIAGNOSTIC.
    ''
    '' The tail of this function returns EXIT_USER_ERROR when the diagnostic engine
    '' holds an error and EXIT_OK otherwise -- which is right for everything that IS
    '' about the program being compiled, and wrong for everything that is not. A
    '' clang that would not run, a link that failed, an ICE in emission: none of them
    '' raises a diagnostic, so all three used to exit 0 having written no output.
    '' Measured 2026-09-04: a win32 link failed, every runtime symbol undefined, and
    '' 'tiko ... ; echo $?' said 0. A build script cannot tell that from success.
    ''
    '' Set once, at the point of failure, and returned by the tail in preference to
    '' EXIT_OK. It does not override EXIT_USER_ERROR: a program that failed to
    '' compile is a user error first, and the toolchain never ran.
    dim as long toolExit = Tko.EXIT_OK

    dim as boolean cmdOk = Tko.Cmdline.Parse( args, ctx.options, ctx.diags )
    ApplyDiagPolicy( ctx )

    '' THE TARGET DECIDES THE LAYOUT, and it is only known now. The context is built
    '' before the command line is parsed -- the source manager needs the interner's
    '' address, and the diagnostic engine the manager's -- so the constructor takes the
    '' HOST's layout and this replaces it. Nothing has been laid out yet: builtin sizes
    '' are computed on demand from 'target' and no layout is cached.
    ctx.types.Attach( @ctx.names, Tko.TargetLayoutFor( ctx.options.target ) )

    if cmdOk = false then
        ctx.diags.Flush( )
        return Tko.EXIT_CMDLINE
    end if

    '' --version and --help answer and stop, even with other options present.
    if ctx.options.showVersion then
        print Tko.Cmdline.VersionText( );
        return Tko.EXIT_OK
    end if
    if ctx.options.showHelp then
        print Tko.Cmdline.HelpText( ctx.options.helpCategory );
        return Tko.EXIT_OK
    end if

    if ctx.options.inputs.IsEmpty( ) then
        ctx.diags.ReportGlobal( Tko.TKO0102 )
        ctx.diags.Flush( )
        return Tko.EXIT_CMDLINE
    end if

    '' ---- partition the inputs ---------------------------------------------
    ''
    '' AN OBJECT IS AN INPUT, NOT A SOURCE. Passing one used to send it through the
    '' lexer, which reported 'TKO0003: not valid UTF-8' and pointed at the COFF
    '' header -- an honest complaint about the wrong question. The suite's own build
    '' compiles every test to its own '.o' and then links the lot, so consuming
    '' objects is not a convenience, it is the whole of how fbc's makefile works.
    dim as Tko.StrVec objInputs
    dim as Tko.StrVec srcInputs
    for each inputPath as string in ctx.options.inputs
        if Tko.Text.LowerAscii( right( inputPath, 2 ) ) = ".o" then
            objInputs.Push( inputPath )
        else
            srcInputs.Push( inputPath )
        end if
    next

    '' ---- load every source ------------------------------------------------
    dim as double tLoadStart = timer
    for each inputPath as string in srcInputs
        dim as ustring why = ""
        dim as Tko.FileId id = ctx.sources.LoadFile( inputPath, why )

        if id = Tko.FILE_NONE then
            ctx.diags.ReportGlobal( Tko.TKO0001, inputPath, Tko.Text.UStringToUtf8( why ) )
            continue for
        end if

        dim as Tko.SourceFile ptr f = ctx.sources.FileAt( id )
        if f->text.Count = 0 then
            ctx.diags.ReportGlobal( Tko.TKO0002, ctx.sources.PathOf( id ) )
        elseif f->encoding = Tko.Text.ENC_BYTES then
            '' Point at the offending byte rather than blaming the whole file.
            dim as Tko.SourceLoc at = ctx.sources.LocFor( id, f->firstBadByte )
            ctx.diags.Report( Tko.TKO0003, Tko.PointRange( at ), ctx.sources.PathOf( id ) )
        end if

        if ctx.options.verbose then
            print "tiko-lang: loaded "; ctx.sources.PathOf( id ); _
                  " ("; f->text.Count; " bytes, "; _
                  Tko.Text.EncodingName( f->encoding ); ")"
        end if
    next

    dim as double tLoad = timer - tLoadStart

    '' ---- what this build can do -------------------------------------------
    '' HOISTED: a length test beside booleans in an 'orelse' chain is warning 38, which
    '' this project treats as a rule rather than as noise.
    dim as boolean wantsOutput = (len( ctx.options.outputPath ) > 0)
    if ctx.options.dumpTypes then
        print Tko.DumpTypes( ctx.types );
    elseif ctx.options.dumpSource then
        if ctx.diags.HasErrors( ) = false then DumpSourceTable( ctx )
    elseif ctx.options.lexOnly then
        '' The corpus gate: lex everything, report what came out, produce no dump.
        dim as longint tokens = 0, invalid = 0, bytes_ = 0
        dim as double tLexStart = timer
        for i as long = 1 to ctx.sources.Count( )
            dim as Tko.FileId id = cast( Tko.FileId, i )
            dim as Tko.Lex.Result r
            Tko.Lex.Run( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, r )
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
        '' FALSE: the stdcall-decorated inventory was win32's, and win32 is gone.
        print Tko.Mir.DumpRtl( false );

    elseif ctx.options.dumpSymbols orelse ctx.options.resolveOnly orelse _
           ctx.options.dumpMangle orelse ctx.options.checkOnly orelse _
           ctx.options.dumpIr orelse ctx.options.emitIr orelse _
           wantsOutput orelse _
           ctx.options.dumpUdt orelse _
           ctx.options.dumpVtable then
        '' ONE OBJECT PER SOURCE, and the link after all of them. Compiling AND
        '' LINKING inside this loop was the multi-module bug: every input overwrote
        '' the previous one's output and was then linked on its own, so a two-module
        '' program failed on whichever half went second -- with no diagnostic naming
        '' the input that had been discarded.
        dim as Tko.StrVec linkObjs
        dim as Tko.StrVec tempObjs
        for i as long = 0 to objInputs.Count - 1
            linkObjs.Push( objInputs[i] )
        next
        '' THE BOUND IS FROZEN. Count( ) grows as the preprocessor opens includes,
        '' and reading it each time round would compile every header as a unit.
        dim as long srcCount = ctx.sources.Count( )
        for i as long = 1 to srcCount
            dim as Tko.FileId id = cast( Tko.FileId, i )
            dim as Tko.PpResult pr
            dim as Tko.PpConfig cfg = MakePpConfig( ctx )
            dim as Tko.PpStream st
            Tko.PpOpen( st, ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, cfg, pr )

            dim as Tko.AstArena ast
            dim as Tko.ParserState p
            p.toks = @pr.tokens
            p.stream = @st
            p.litPool = @pr.literals
            p.ast = @ast
            p.src = @ctx.sources
            p.kw = @ctx.keywords
            p.names = @ctx.names
            p.diags = @ctx.diags
            p.pos = 0

            dim as Tko.NodeId root = Tko.Parse.Unit( p )
            Tko.PpClose( st )

            dim as Tko.SymbolTable syms
            syms.Attach( @ctx.names )
            dim as Tko.SemanticInfo info
            Tko.Collect.Run( ast, root, syms, ctx.names, ctx.types, ctx.diags, info )

            if ctx.options.dumpVtable then
                '' Matching an override needs the PARAMETER TYPES, so this runs after
                '' Resolve like the layout pass does.
                dim as Tko.Resolve.Stats rst
                Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                dim as Tko.VTables vt
                Tko.ComputeVTables( ast, syms, ctx.types, info, vt )
                print Tko.DumpVTables( ast, vt, ctx.types, ctx.names, syms, info );
            elseif ctx.options.dumpUdt then
                dim as Tko.Resolve.Stats rst
                Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                dim as Tko.UdtLayouts store
                Tko.ComputeUdtLayouts( syms, ctx.types, store )
                print Tko.DumpUdtLayouts( store, ctx.types, ctx.names, syms );
            elseif ctx.options.dumpIr orelse ctx.options.emitIr orelse _
                   wantsOutput then
                '' MIR needs the full frontend in front of it: resolve binds names,
                '' check gives every expression a type, and lowering reads both.
                dim as Tko.Resolve.Stats rst
                Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                dim as Tko.Check.Stats cst
                Tko.Check.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                               info, cst )
                '' AFTER Check: a member access needs its symbol, and only Check binds
                '' one -- a field means nothing until its base has a type.
                Tko.Vis.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, info )
                dim as Tko.Mir.MirModule mm
                dim as Tko.Mir.LowerStats lst
                dim as Tko.UdtLayouts udts
                Tko.ComputeUdtLayouts( syms, ctx.types, udts )
                '' Needs the layouts: an array of a UDT has no size before them.
                Tko.CheckArraySizes( syms, ctx.types, udts, ctx.names, ctx.diags )
                dim as Tko.VTables vts
                Tko.ComputeVTables( ast, syms, ctx.types, info, vts )
                '' Needs the vtables: a type is ABSTRACT exactly when one of its slots
                '' has no procedure, and nothing before this point knows that.
                Tko.CheckAbstractInstances( ast, syms, ctx.types, info, vts, ctx.names, ctx.diags )
                Tko.CheckOverridePromise( ast, vts, ctx.names, ctx.diags )
                Tko.CheckOverrideCompatible( ast, vts, ctx.names, ctx.diags )
                Tko.Mir.Lower( ast, root, syms, ctx.types, ctx.names, info, _
                               ctx.sources, udts, vts, mm, lst )
                '' THE ABI PASS, between lowering and emission (docs/plan/10 section
                '' 3). It rewrites signatures and call sites so the emitted IR carries
                '' no implicit ABI behaviour -- and it runs under '--dump-ir' too, so
                '' the MIR dump shows what will actually be passed rather than what the
                '' frontend meant. Seeing the ABI without reading LLVM is the point of
                '' having it as a separate pass at all.
                dim as Tko.Codegen.AbiStats abist
                dim as Tko.Codegen.TargetDescription abitgt = _
                    Tko.Codegen.TargetFor( ctx.options.target )
                Tko.Codegen.LowerModule( mm, ctx.names, abitgt, abist )

                '' '--emit-ir' RUNS THE SAME FRONTEND and prints the backend's
                '' output instead of MIR's. It is the escape hatch docs/plan/10 asks
                '' for, and it is the only way to see what the emitter produced
                '' without a working link.
                '' AN OUTPUT PATH MEANS BUILD. '--emit-ir' without one is the escape
                '' hatch that prints the module; with one, or with neither, the driver
                '' produces the file that was asked for. 'tiko foo.bas -o foo.exe' is
                '' the spelling that matters and it used to report "not implemented".
                dim as boolean doCodegen = ctx.options.emitIr orelse wantsOutput
                if doCodegen then
                    dim as Tko.Codegen.TargetDescription td = _
                        Tko.Codegen.TargetFor( ctx.options.target )
                    dim as Tko.Codegen.EmitResult er = _
                        Tko.Codegen.EmitLlvm( mm, ctx.names, td )
                    if er.ok then
                        '' AN OUTPUT PATH TURNS '--emit-ir' INTO A REAL BUILD: the IR
                        '' goes to a file beside it, clang makes the object, and the
                        '' link happens unless '-c' asked for the object alone. Without
                        '' one the IR goes to stdout, which is what the escape hatch
                        '' docs/plan/10 section 4 describes is for.
                        if len( ctx.options.outputPath ) > 0 then
                            '' The result IS the exit code. BuildFromIr reports its
                            '' own failure to stderr -- clang missing, clang failed,
                            '' the link failed -- and none of those is a diagnostic,
                            '' so discarding this returned 0 with nothing built.
                            '' THE OBJECT'S NAME. Under '-c' the user named it and
                            '' there is exactly one. Otherwise it is an intermediate,
                            '' named after the OUTPUT plus the module's index so two
                            '' sources cannot collide, and deleted after the link.
                            dim as string objPath = ctx.options.outputPath
                            if ctx.options.compileOnly = false then
                                objPath = ctx.options.outputPath & "." & str( i ) & ".o"
                                tempObjs.Push( objPath )
                            end if
                            toolExit = BuildFromIr( ctx, er.text, td, objPath )
                            if toolExit = Tko.EXIT_OK then linkObjs.Push( objPath )
                        else
                            print er.text;
                        end if
                    else
                        '' NOT A DIAGNOSTIC. A failure here is the compiler being
                        '' unable to emit something it accepted, which is an internal
                        '' fault and is reported as one -- and exits as one.
                        print "emit: ICE: " & er.ice
                        toolExit = Tko.EXIT_ICE
                    end if
                else
                    print Tko.Mir.DumpModule( mm, ctx.names );
                end if
                '' THE REPORT GOES TO STDERR UNDER '--emit-ir', because stdout is
                '' then a .ll FILE: a 'verify: ok' line in the middle of a module is
                '' not a comment, and clang rejects the whole thing. Under '--dump-ir'
                '' stdout is a report already and the two stay together.
                dim as boolean quiet = ctx.options.emitIr orelse wantsOutput
                '' The verifier is an ICE check, not a diagnostic: a failure means
                '' the compiler built something malformed.
                dim as Tko.Mir.VerifyResult vr = Tko.Mir.Verify( mm, ctx.names )
                if quiet then
                    '' STDERR, opened here rather than through the diagnostic engine:
                    '' this is not a diagnostic, it is the compiler reporting that it
                    '' built something malformed, and it must not land in the .ll.
                    if vr.failures > 0 then
                        dim as long eh = freefile
                        open err for output as #eh
                        print #eh, "verify: " & str( vr.failures ) & " FAILURES"
                        print #eh, vr.report;
                        close #eh
                    end if
                elseif vr.failures > 0 then
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
                '' THE WHOLE REPORT IS SUPPRESSED UNDER '--emit-ir', not just the
                '' summary line: stdout is a .ll file and EVERY line of this is a
                '' syntax error in it. Guarding the prints one at a time would be
                '' twenty chances to miss one, and one missed line makes the whole
                '' module unparseable -- which is exactly how it was found, as
                '' 'expected top-level entity' on an 'inside N_AMBIGUOUS 1' that had
                '' landed in the middle of the IR.
                if quiet = false then
                print sum_
                '' The breakdown of what did NOT lower, printed only when there is
                '' something to say. One 'skipped' total invites guessing at the next
                '' thing to implement; this is read off instead.
                for i as long = 0 to lst.skippedKind.Count - 1
                    if lst.skippedKind[i] = 0 then continue for
                    print "  unlowered " & _
                          Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
                          str( lst.skippedKind[i] )
                next
                '' Declines part-way THROUGH a statement, by what they were inside.
                for i as long = 0 to lst.innerKind.Count - 1
                    if lst.innerKind[i] = 0 then continue for
                    print "  inside " & _
                          Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
                          str( lst.innerKind[i] )
                next
                for i as long = 0 to lst.skippedIntrOp.Count - 1
                    print "  unlowered intrinsic " & _
                          Tko.TokenKindName( cast( Tko.TokenKind, lst.skippedIntrOp[i] ) ) & _
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
                if lst.ambAssign > 0 then
                    print "  amb assign " & str( lst.ambAssign )
                    if lst.ambAssignUntyped > 0 then
                        print "  amb-assign-untyped " & str( lst.ambAssignUntyped )
                    end if
                    for i as long = 0 to lst.ambAssignKinds.Count - 1
                        if lst.ambAssignKinds[i] = 0 then continue for
                        print "  amb-assign-kind " & str( i ) & " " & _
                              str( lst.ambAssignKinds[i] )
                    next
                    for i as long = 0 to lst.ambAssignValKinds.Count - 1
                        if lst.ambAssignValKinds[i] = 0 then continue for
                        print "  amb-assign-val " & _
                              Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
                              str( lst.ambAssignValKinds[i] )
                    next
                end if
                if lst.ambResultNoSlot > 0 then
                    print "  amb result-noslot " & str( lst.ambResultNoSlot )
                    for i as long = 0 to lst.resultNoSlotKinds.Count - 1
                        if lst.resultNoSlotKinds[i] = 0 then continue for
                        print "  result-noslot-kind " & str( i ) & " " & _
                              str( lst.resultNoSlotKinds[i] )
                    next
                end if
                if lst.varByref > 0 then print "  var byref " & str( lst.varByref )
                if lst.ambOther > 0 then print "  amb other " & str( lst.ambOther )
                '' Which LINE of the lowering gave up, which is the thing to go and read.
                for i as long = 0 to lst.skipSiteN.Count - 1
                    print "  skip-site " & _
                          ctx.names.Spelling( cast( Tko.InternId, lst.skipSiteFile[i] ) ) & _
                          ":" & str( lst.skipSiteLine[i] ) & " " & str( lst.skipSiteN[i] )
                next
                for i as long = 0 to lst.ambUnboundShape.Count - 1
                    if lst.ambUnboundShape[i] = 0 then continue for
                    print "  amb-unbound-shape " & _
                          Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
                          str( lst.ambUnboundShape[i] )
                next
                for i as long = 0 to lst.ambOtherShape.Count - 1
                    if lst.ambOtherShape[i] = 0 then continue for
                    print "  amb-other-shape " & _
                          Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
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
                          ctx.names.Spelling( cast( Tko.InternId, lst.ambMemberNames[i] ) )
                next
                for i as long = 0 to lst.ambUnboundNames.Count - 1
                    print "  amb-unbound-name " & _
                          ctx.names.Spelling( cast( Tko.InternId, lst.ambUnboundNames[i] ) )
                next
                end if
            elseif ctx.options.checkOnly then
                dim as Tko.Resolve.Stats rst
                Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                dim as Tko.Check.Stats cst
                Tko.Check.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                               info, cst )
                print Tko.Check.Dump( ast, ctx.sources, ctx.types, ctx.names, info, cst );
            elseif ctx.options.dumpMangle then
                '' Mangling needs the parameter TYPES, so it runs after Resolve --
                '' but the reference-binding report is not wanted here.
                dim as Tko.Resolve.Stats rst
                Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                print Tko.Mangle.Dump( ast, root, syms, ctx.names, ctx.types, info );
            elseif ctx.options.resolveOnly then
                dim as Tko.Resolve.Stats rst
                Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                                 ctx.sources, info, rst, @p )
                print Tko.Resolve.Dump( ast, syms, ctx.types, ctx.names, info, rst );
            else
                print Tko.Collect.Dump( syms, ctx.names, ctx.types, ctx.sources );
            end if
        next

        '' ---- the link, once, over every object --------------------------------
        ''
        '' NOT UNDER '-c', which asked for objects and nothing more, and not when the
        '' frontend already failed: linking half a program produces a second, louder
        '' failure that buries the first.
        '' HOISTED, each to its own boolean: a four-term 'andalso' chain mixing a
        '' flag with three comparisons is warning 38, which this file already treats
        '' as a rule rather than as noise.
        dim as boolean linkWanted = wantsOutput
        dim as boolean notCompileOnly = (ctx.options.compileOnly = false)
        dim as boolean toolsOk = (toolExit = Tko.EXIT_OK)
        dim as boolean frontendOk = (ctx.diags.HasErrors( ) = false)
        if linkWanted andalso notCompileOnly andalso toolsOk andalso frontendOk then
            if linkObjs.Count = 0 then
                ctx.diags.ReportGlobal( Tko.TKO0102 )
            else
                dim as Tko.Codegen.TargetDescription ltd = _
                    Tko.Codegen.TargetFor( ctx.options.target )
                toolExit = LinkAll( ctx, linkObjs, ltd, tempObjs )
            end if
        end if

    elseif ctx.options.dumpAst orelse ctx.options.parseOnly then
        dim as longint nodes = 0
        dim as double tParseStart = timer
        for i as long = 1 to ctx.sources.Count( )
            dim as Tko.FileId id = cast( Tko.FileId, i )
            '' PULL: the parser drives the preprocessor, rather than consuming a
            '' vector the preprocessor finished building first.
            dim as Tko.PpResult pr
            dim as Tko.PpConfig cfg = MakePpConfig( ctx )
            dim as Tko.PpStream st
            Tko.PpOpen( st, ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, cfg, pr )

            dim as Tko.AstArena ast
            dim as Tko.ParserState p
            p.toks = @pr.tokens
            p.stream = @st
            p.litPool = @pr.literals
            p.ast = @ast
            p.src = @ctx.sources
            p.kw = @ctx.keywords
            p.names = @ctx.names
            p.diags = @ctx.diags
            p.pos = 0

            dim as Tko.NodeId root = Tko.Parse.Unit( p )
            Tko.PpClose( st )
            nodes += ast.Count( )
            if ctx.options.dumpAst then
                print Tko.Parse.DumpTree( ast, ctx.sources, ctx.names, root );
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
            dim as Tko.FileId id = cast( Tko.FileId, i )
            dim as Tko.Lex.Result lr
            Tko.Lex.Run( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, lr )

            dim as Tko.AstArena ast
            dim as Tko.ParserState p
            p.toks = @lr.tokens
            p.litPool = @lr.literals
            p.ast = @ast
            p.src = @ctx.sources
            p.kw = @ctx.keywords
            p.names = @ctx.names
            p.diags = @ctx.diags
            p.pos = 0

            dim as long lineNo = 0
            while p.pos < lr.tokens.Count
                dim as Tko.TokenKind k = cast( Tko.TokenKind, lr.tokens[p.pos].kind )
                if k = Tko.TK_EOF then exit while
                if k = Tko.TK_EOL then
                    p.pos += 1
                    continue while
                end if
                lineNo += 1
                dim as Tko.NodeId n = Tko.Parse.OneExpression( p )
                print "--- expression "; lineNo
                print Tko.Parse.Dump( ast, ctx.sources, ctx.names, n );
                '' Resynchronise on the next line boundary.
                while p.pos < lr.tokens.Count
                    dim as Tko.TokenKind k2 = cast( Tko.TokenKind, lr.tokens[p.pos].kind )
                    if k2 = Tko.TK_EOF then exit while
                    p.pos += 1
                    if k2 = Tko.TK_EOL then exit while
                wend
            wend
            print "nodes: "; ast.Count( )
        next

    elseif ctx.options.ppOnly then
        dim as longint tokens = 0, includes = 0, expansions = 0
        dim as double tPpStart = timer
        for i as long = 1 to ctx.sources.Count( )
            dim as Tko.PpResult r
            dim as Tko.PpConfig cfg = MakePpConfig( ctx )
            Tko.PpRun( ctx.sources, cast( Tko.FileId, i ), ctx.names, ctx.keywords, _
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
            dim as Tko.FileId id = cast( Tko.FileId, i )
            if ctx.options.dumpPp then
                dim as Tko.PpResult r
                dim as Tko.PpConfig cfg = MakePpConfig( ctx )
                Tko.PpRun( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, cfg, r )
                print Tko.PpDump( ctx.sources, ctx.names, r );
            else
                dim as Tko.Lex.Result r
                Tko.Lex.Run( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, r )
                print Tko.Lex.Dump( ctx.sources, id, ctx.names, r );
            end if
        next
    elseif wantsOutput = false then
        '' Honest rather than silent: the pipeline genuinely stops here in this
        '' build, and each later phase replaces this branch with real work.
        ctx.diags.ReportGlobal( Tko.TKO0992, _
            "compilation -- this build implements the phase 2 skeleton only " & _
            "(source loading and diagnostics); try --dump-source" )
    end if

    ctx.diags.Flush( )
    if ctx.options.stats then ReportStats( ctx )

    if ctx.diags.HasErrors( ) then return Tko.EXIT_USER_ERROR
    if toolExit <> Tko.EXIT_OK then return toolExit
    return Tko.EXIT_OK
end function

end namespace
