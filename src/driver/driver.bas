'' driver.bas -- see driver.bi

#include once "driver/driver.bi"
#include once "driver/cmdline.bi"
#include once "driver/diagout.bi"
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
#include once "codegen/objinfo.bi"
#include once "codegen/llvmemit.bi"
#include once "mir/rtl.bi"
#include once "driver/cimportmode.bi"
#include once "driver/lowerreport.bi"
#include once "driver/cinclude.bi"
#include once "driver/unit.bi"
#include once "driver/modgraph.bi"
#include once "driver/modunit.bi"
#include once "fb/filesystem.bi"
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
    this.toolErrors = 0
end constructor

'' THE CACHED TOKEN VECTORS OUTLIVE EVERY ENGINE, so they are freed here rather than in
'' PpClose. One Lex.Result per file that was lexed, whichever unit lexed it first.
destructor CompilerContext( )
    for each p as any ptr in this.ppLexed
        if p <> 0 then delete cast( Tko.Lex.Result ptr, p )
    next
    Tko.CImportDriver.FreeSession( this.cinclude )
end destructor

end namespace

namespace Tko.Driver

'' The preprocessor's view of the command line: include paths and -d defines.
'' A MODULE'S NAME: the basename with no directory and no extension. fbc matches
'' '-m' against exactly this, and against the OBJECT rather than the source -- but the
'' two agree for every invocation the suite's makefile makes ('%.o : %.bas'), and
'' taking it from the source is what lets a module know its own name before an object
'' path exists.
'' THE MODULE NAME: the basename with the extension off. What '-m' is matched
'' against, and therefore what decides which module owns main.
''
'' THE BACKSLASH ARM WAS DEAD. It read 'ch = "\\"', and FreeBASIC does no escape
'' processing without a '!' prefix -- so that literal is TWO characters and could
'' never equal a one-character 'ch'. Probed rather than reasoned about: len( "\\" )
'' is 2, and it compares unequal to "\". A backslash path therefore kept its whole
'' directory, so 'tiko C:\dir\a.bas C:\dir\b.bas -m b' compared "C:\dir\b" against
'' "b", matched nothing, gave main to no module, and failed at the link with
'' 'undefined reference to WinMain'. The same line with forward slashes built and
'' ran, which is what made it look like a linker problem rather than a parsing one.
''
'' It survived because every test path in this tree is written with forward slashes:
'' the suite drives tiko from bash, and Windows accepts both. Only a path typed at
'' cmd.exe reaches this arm.
function ModuleStem( byref path_ as string ) as string
    dim as string r = path_
    for i as long = len( r ) to 1 step -1
        dim as string ch = mid( r, i, 1 )
        if (ch = "/") orelse (ch = "\") then
            r = mid( r, i + 1 )
            exit for
        end if
    next
    dim as long dot = instrrev( r, "." )
    if dot > 1 then r = left( r, dot - 1 )
    return r
end function

'' THE OUTPUT NAME WHEN NONE WAS GIVEN. 'tiko test.bas' used to answer
''
''     error TKO0992: not implemented in this build: compilation -- this build
''     implements the phase 2 skeleton only
''
'' which was untrue and had been for a long time: the condition behind that
'' message was never 'the compiler cannot do this', it was 'len( outputPath ) = 0'.
'' The phase-2 text simply outlived the phase. Anyone who typed the obvious thing
'' was told the compiler was a stub.
''
'' fbc names the output after the FIRST INPUT MODULE, and that is measured rather
'' than assumed: 'fbc prog.bas' writes prog.exe, 'fbc -c prog.bas' writes prog.o,
'' 'fbc prog.bas second.bas' writes prog.exe, and 'fbc sub/deep.bas' writes
'' sub/deep.exe -- the DIRECTORY IS KEPT, only the extension is replaced. fbc.bas
'' does it in two steps, mainname = first module with the extension stripped and
'' then outname = mainname + '.exe' on Windows targets only; on Linux nothing is
'' appended. Both steps are reproduced here.
function StripExt_( byref path_ as string ) as string
    '' The last dot, but only after the last separator: 'a.b/c' has no extension,
    '' and a leading dot is the whole name rather than an empty one.
    dim as long cut = 0
    for i as long = len( path_ ) to 1 step -1
        dim as string ch = mid( path_, i, 1 )
        if (ch = "/") orelse (ch = "\") then exit for
        if (ch = ".") andalso (cut = 0) then cut = i
    next
    if cut > 1 then return left( path_, cut - 1 )
    return path_
end function

'' THE EXTENSION THE OUTPUT KIND ASKS FOR. Measured against fbc: '-dll thing.bas'
'' writes thing.dll, '-lib thing.bas' writes libthing.a, and a plain build writes
'' thing.exe on Windows and 'thing' on Linux.
''
'' A STATIC LIBRARY IS PREFIXED as well as suffixed -- libthing.a, not thing.a --
'' which is the convention every linker's '-l' search is built around.
private function OutputSuffix_( byref o as Tko.DriverOptions ) as string
    select case o.outKind
    case Tko.OUT_DLL
        if Tko.TargetIsWindows( o.target ) then return ".dll"
        return ".so"
    case Tko.OUT_STATICLIB
        return ".a"
    end select
    if Tko.TargetIsWindows( o.target ) then return ".exe"
    return ""
end function

private function DefaultOutputPath_( byref o as Tko.DriverOptions ) as string
    '' NOT UNDER '-c'. There is no single output then -- fbc writes one object per
    '' module, named after that module -- so the name is settled per module at the
    '' emit instead, and this returns nothing rather than a name that would be wrong
    '' for every module after the first.
    ''
    '' Getting this wrong was silent, which is the point of the note: an earlier cut
    '' appended '.exe' regardless, so 'tiko -c prog.bas' wrote a COFF OBJECT into a
    '' file called prog.exe and exited 0. It looked like a build.
    if o.compileOnly then return ""
    if o.inputs.Count = 0 then return ""
    dim as string stem = StripExt_( o.inputs[0] )
    if len( stem ) = 0 then return ""
    '' A STATIC LIBRARY GAINS THE 'lib' PREFIX, and it goes on the BASENAME rather
    '' than the path: 'sub/thing.bas' becomes sub/libthing.a, not libsub/thing.a.
    ''
    '' SO DOES A SHARED LIBRARY OFF WINDOWS. Measured: 'fbc -dll sub/dl.bas' on Linux
    '' writes sub/libdl.so, while on Windows it writes dl.dll. An explicit -o is taken
    '' as given in both cases -- 'fbc -dll dl.bas -x out/custom.so' writes custom.so.
    dim as boolean prefixed = (o.outKind = Tko.OUT_STATICLIB) orelse _
        ((o.outKind = Tko.OUT_DLL) andalso (Tko.TargetIsWindows( o.target ) = false))
    if prefixed then
        dim as long cut = 0
        for i as long = len( stem ) to 1 step -1
            dim as string ch = mid( stem, i, 1 )
            if (ch = "/") orelse (ch = "\") then
                cut = i
                exit for
            end if
        next
        return left( stem, cut ) & "lib" & mid( stem, cut + 1 ) & OutputSuffix_( o )
    end if
    return stem & OutputSuffix_( o )
end function

'' WHETHER SOME OTHER MODE WAS ASKED FOR. The list is long and it is written out
'' rather than derived, because there is no property of an option that separates
'' these from '--keep-temps' or '--stats': OPTCAT_DEVEL holds both the modes and
'' the modifiers. Every name here appears in the if/elseif chain below, which is
'' the invariant -- a mode added there and not here would start silently building
'' an executable as a side effect of a dump.
''
'' That is not hypothetical. '--dump-ir' and '--parse-only' reach the same branch
'' as a real build, and inside it 'doCodegen' is 'emitIr orelse wantsOutput'; had
'' the default been applied unconditionally, every corpus run would have started
'' emitting objects and linking them.
private function AnotherModeWasAsked_( byref o as Tko.DriverOptions ) as boolean
    if o.dumpTypes orelse o.dumpSource orelse o.lexOnly orelse o.dumpRtl then return true
    if o.dumpSymbols orelse o.resolveOnly orelse o.dumpMangle orelse o.checkOnly then return true
    if o.dumpIr orelse o.emitIr orelse o.emitAsm orelse o.dumpUdt then return true
    if o.dumpVtable orelse o.ppOnly orelse o.dumpTokens orelse o.dumpAst then return true
    if o.parseExpr orelse o.parseOnly orelse o.printGraph then return true
    return false
end function

'' THE LIBRARY SEARCH PATH, ASSEMBLED IN fbc's ORDER. Measured against fbc 1.20.0:
'' '-p cmdlinedir' with '#libpath "pragmadir"' in the source emits
''
''     -L "cmdlinedir" -L "pragmadir" -L "<compiler's own lib>" -L "."
''
'' so the command line is searched first, the source's pragmas next, and the
'' compiler's own directories last. Built here rather than kept as one list because
'' the middle one is not known until the parse has run.
private function AssembledLibPaths_( byref ctx as Tko.CompilerContext ) as Tko.StrVec
    dim as Tko.StrVec r
    for i as long = 0 to ctx.options.libPaths.Count - 1
        r.Push( ctx.options.libPaths[i] )
    next
    for i as long = 0 to ctx.options.pragmaLibPaths.Count - 1
        r.Push( ctx.options.pragmaLibPaths[i] )
    next
    for i as long = 0 to ctx.options.defaultLibPaths.Count - 1
        r.Push( ctx.options.defaultLibPaths[i] )
    next
    return r
end function

'' THE TOOLS, AND WHETHER TO SHOW THEM. Every build path looked them up the same way;
'' '-v' is the one setting they all need and FindTools cannot see the options.
private function Tools_( byref ctx as Tko.CompilerContext ) as Tko.Codegen.ToolPaths
    dim as Tko.Codegen.ToolPaths t = _
        Tko.Codegen.FindTools( "", AssembledLibPaths_( ctx ) )
    t.verbose = ctx.options.verbose
    return t
end function

function MakePpConfig( byref ctx as Tko.CompilerContext ) as Tko.PpConfig
    dim as Tko.PpConfig cfg
    cfg.includePaths = @ctx.options.includePaths
    cfg.defines = @ctx.options.defines
    cfg.targetIsWindows = Tko.TargetIsWindows( ctx.options.target )
    cfg.targetIs64 = Tko.TargetIs64( ctx.options.target )
    cfg.targetIsMsvc = (ctx.options.target = Tko.TARGET_WIN64_MSVC)
    cfg.threadSafe = ctx.options.threadSafe
    cfg.errLevel = ctx.options.errLevel
    cfg.debugInfo = ctx.options.debugInfo
    cfg.outKind = iif( ctx.options.compileOnly, 3, _
        iif( ctx.options.outKind = Tko.OUT_DLL, 1, iif( ctx.options.outKind = Tko.OUT_STATICLIB, 2, 0 ) ) )
    cfg.reportUnsupported = true
    cfg.sharedLits = @ctx.ppLits
    cfg.sharedLexed = @ctx.ppLexed
    Tko.CImportDriver.ConfigureHook( cfg, ctx )
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

'' THE AST'S FOOTPRINT, for the budget in docs/plan/14-engineering-standards.md §4:
'' arena bytes per token. Counted as elements times element size over the arrays the
'' arena is made of -- USED, not reserved, because a growable array's slack is an
'' allocation policy and the budget is about the representation.
private function AstBytes_( byref a as Tko.AstArena ) as longint
    dim as longint pools = a.children.Count + a.tokenRanges.Count + _
                           a.extraTopLevel.Count + a.callTypeArgs.Count + _
                           a.structorPrio.Count
    return a.nodes.Count    * sizeof( Tko.AstNode ) + _
           a.unaries.Count  * sizeof( Tko.UnaryPayload ) + _
           a.binaries.Count * sizeof( Tko.BinaryPayload ) + _
           a.literals.Count * sizeof( Tko.LiteralPayload ) + _
           a.idents.Count   * sizeof( Tko.IdentPayload ) + _
           a.lists.Count    * sizeof( Tko.ListPayload ) + _
           a.stmts.Count    * sizeof( Tko.StmtPayload ) + _
           pools * sizeof( ulong )
end function

'' A TOOLCHAIN FAILURE IS A DIAGNOSTIC WITHOUT A LOCATION that still exits with the TOOL's
'' code. It was a bare 'tiko: ...' line on stderr, which nothing reading diagnostics could
'' see -- an editor reported a failed link as a build with no errors. Counted in
'' toolErrors so FrontendFailed_ can still tell 'the program is wrong' (exit 1) from 'the
'' machine failed' (3, 4, 5). Flushed at once, so the line still sits beside clang's or
'' lld's own stderr the way the 'tiko:' line did. Measured as a difference, not assumed
'' to be one: a -Wno- of the id reports nothing and must count nothing.
function ToolFail_ _
    ( byref ctx as Tko.CompilerContext, byval code as long, byval id as Tko.DiagId, _
      byref a0 as string = "", byref a1 as string = "", byref a2 as string = "" ) as long

    dim as long before = ctx.diags.ErrorCount( )
    ctx.diags.ReportGlobal( id, a0, a1, a2 )
    ctx.toolErrors += ctx.diags.ErrorCount( ) - before
    ctx.diags.Flush( )
    return code
end function

'' DID THE PROGRAM FAIL, as opposed to the toolchain? Everything that gates on 'the
'' frontend reported an error' asks this, never HasErrors( ): a clang failure in module 1
'' must not stop module 2 being compiled, any more than it did before it was a diagnostic.
function FrontendFailed_( byref ctx as Tko.CompilerContext ) as boolean
    return ctx.diags.ErrorCount( ) > ctx.toolErrors
end function

'' THE REST OF THE BUILD: IR to an object, and an object to an executable.
''
'' Separated from the emission above only so that the pass pipeline reads as one thing
'' and the toolchain as another. Every failure here is a LOCATION-LESS diagnostic through
'' ToolFail_ -- none of them is about the program being compiled, so none has a line to
'' point at, but an editor reading --diagnostics-file still has to see it.
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
'' WHAT CLANG ACTUALLY WROTE. The object format is not something tiko selects: it
'' follows from the triple CompileIr passes ('-target x86_64-pc-windows-msvc' ->
'' COFF, 'x86_64-pc-linux-gnu' -> ELF), while TargetDescription.objFormat is a
'' SEPARATE field that decides the shape of the link line. Nothing made the two
'' agree; they sat side by side in target.bas and were assumed to match.
''
'' A disagreement is not loud. objFormat picks between the '-B'/import-library
'' branch and the '-lm -lpthread -ltinfo' one, so a target whose triple said ELF
'' while its objFormat said COFF would get a MinGW link line for an ELF object and
'' fail somewhere well downstream of the mistake.
''
'' Four bytes settle it. ELF starts 7F 'E' 'L' 'F'; a COFF object starts with its
'' machine word, 0x8664 little-endian for x86-64, or FF FF for the bigobj header
'' clang emits when a module has more sections than the short form can count.
''
'' ONLY A DEFINITE MISMATCH IS AN ERROR. Anything unrecognised is left alone --
'' '-flto' would put LLVM bitcode here, which is neither of these and is not wrong.
private function ObjectLooksElf_( byref path_ as string, byref known as boolean ) as boolean
    known = false
    dim as long fh = freefile
    if open( path_ for binary access read as #fh ) <> 0 then return false
    dim as ubyte b(0 to 3)
    dim as longint n = 4
    get #fh, 1, b(0), n
    close #fh
    if n < 4 then return false
    if (b(0) = &h7F) andalso (b(1) = asc( "E" )) andalso _
       (b(2) = asc( "L" )) andalso (b(3) = asc( "F" )) then
        known = true
        return true
    end if
    if (b(0) = &h64) andalso (b(1) = &h86) then
        known = true
        return false
    end if
    if (b(0) = &hFF) andalso (b(1) = &hFF) then
        known = true
        return false
    end if
    return false
end function

'' '--emit-ir' AND '--emit-asm' WRITE THEIR FILE AND STOP -- docs/plan/10 section 4: "writes
'' the .ll and stops; --emit-asm runs clang -S". What they did was build: with an -o, both
'' compiled and LINKED, so 'tiko --emit-ir x.bas -o x.ll' wrote an EXECUTABLE named x.ll, and
'' '--emit-asm' never produced assembly at all. Now:
''
''     --emit-ir               the module on stdout, as before -- the escape hatch the tests read
''     --emit-ir -o x.ll       the module in x.ll
''     --emit-asm [-o x.s]     clang -S into x.s, or <source>.s
''
'' fbc's '-r' is the same shape: 'fbc -gen llvm -r x.bas -o x.ll' writes the IR there. With
'' several modules and one -o, each is '<-o stem>.<n>.ll', as their intermediate objects are.
function EmitStopFile_ _
    ( byref ctx as Tko.CompilerContext, byref irText as string, _
      byref td as Tko.Codegen.TargetDescription, byval id as Tko.FileId, _
      byval i as long, byval srcCount as long ) as long

    dim as string ext = iif( ctx.options.emitAsm, ".s", ".ll" )
    dim as string outp = ctx.options.outputPath
    if len( outp ) = 0 then
        if ctx.options.emitAsm = false then
            print irText;
            return Tko.EXIT_OK
        end if
        outp = StripExt_( ctx.sources.PathOf( id ) ) & ext
    elseif srcCount > 1 then
        outp = StripExt_( outp ) & "." & str( i ) & ext
    end if
    dim as string irPath = outp
    if ctx.options.emitAsm then irPath = outp & ".ll"
    dim as long fh = freefile
    dim as long orc = open( irPath for output as #fh )
    if orc <> 0 then return ToolFail_( ctx, Tko.EXIT_TOOL_FAILED, Tko.TKO0112, irPath )
    print #fh, irText;
    close #fh
    if ctx.options.emitAsm = false then return Tko.EXIT_OK

    dim as Tko.Codegen.ToolPaths tools = Tools_( ctx )
    if tools.found = false then
        return ToolFail_( ctx, Tko.EXIT_NO_TOOLCHAIN, Tko.TKO0111, tools.why )
    end if
    tools.optLevel = ctx.options.optLevel
    dim as long rc = Tko.Codegen.CompileIrAsm( tools, td, irPath, outp, ctx.options.keepTemps )
    if rc <> 0 then return ToolFail_( ctx, Tko.EXIT_TOOL_FAILED, Tko.TKO0113, irPath, str( rc ) )
    return Tko.EXIT_OK
end function

function BuildFromIr _
    ( byref ctx as Tko.CompilerContext, byref irText as string, _
      byref td as Tko.Codegen.TargetDescription, byref objPath as string ) as long

    dim as Tko.Codegen.ToolPaths tools = _
        Tools_( ctx )
    if tools.found = false then
        return ToolFail_( ctx, Tko.EXIT_NO_TOOLCHAIN, Tko.TKO0111, tools.why )
    end if
    '' THE OPTIMISATION LEVEL -- see ToolPaths.optLevel. The link does not need it; the
    '' compile of each module's IR is where clang optimises.
    tools.optLevel = ctx.options.optLevel
    '' A SHARED LIBRARY'S MODULES ARE COMPILED AS PIC on ELF -- see CompileIr. The link
    '' sets this again; the compile needs it first.
    tools.buildDll = (ctx.options.outKind = Tko.OUT_DLL)

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
        return ToolFail_( ctx, Tko.EXIT_TOOL_FAILED, Tko.TKO0112, irPath )
    end if
    print #fh, irText;
    close #fh

    dim as long rc = Tko.Codegen.CompileIr( tools, td, irPath, objPath, _
                                            ctx.options.keepTemps )
    if rc <> 0 then
        return ToolFail_( ctx, Tko.EXIT_TOOL_FAILED, Tko.TKO0113, irPath, str( rc ) )
    end if

    dim as boolean fmtKnown = false
    dim as boolean isElf = ObjectLooksElf_( objPath, fmtKnown )
    if fmtKnown then
        dim as boolean wantElf = (td.objFormat = Tko.Codegen.OBJ_ELF)
        if isElf <> wantElf then
            '' The object format and the triple are one fact -- the other format is
            '' implied, so the message names the one found and the triple that disagrees.
            dim as string got_ = iif( isElf, "ELF", "COFF" )
            return ToolFail_( ctx, Tko.EXIT_TOOL_FAILED, Tko.TKO0114, objPath, got_, td.triple )
        end if
    end if

    return Tko.EXIT_OK
end function

'' '-lib': the objects into an archive, and no link at all.
private function ArchiveAll _
    ( byref ctx as Tko.CompilerContext, byref objs as Tko.StrVec, _
      byref keep as Tko.StrVec ) as long

    dim as Tko.Codegen.ToolPaths tools = _
        Tools_( ctx )
    if tools.found = false then
        return ToolFail_( ctx, Tko.EXIT_NO_TOOLCHAIN, Tko.TKO0111, tools.why )
    end if

    dim as long rc = Tko.Codegen.ArchiveLib( tools, objs, ctx.options.outputPath )
    if rc <> 0 then
        return ToolFail_( ctx, Tko.EXIT_TOOL_FAILED, Tko.TKO0115, str( rc ) )
    end if

    '' The same rule the link follows: only what THIS build made is removed.
    if ctx.options.keepTemps = false then
        for i as long = 0 to keep.Count - 1
            kill( keep[i] )
        next
    end if

    return Tko.EXIT_OK
end function

'' THE LINK, ONCE, OVER EVERY OBJECT the build produced or was handed.
private function LinkAll _
    ( byref ctx as Tko.CompilerContext, byref objs as Tko.StrVec, _
      byref td as Tko.Codegen.TargetDescription, byref keep as Tko.StrVec ) as long

    dim as Tko.Codegen.ToolPaths tools = _
        Tools_( ctx )
    if tools.found = false then
        return ToolFail_( ctx, Tko.EXIT_NO_TOOLCHAIN, Tko.TKO0111, tools.why )
    end if

    '' THE LIBRARIES THE PROGRAM ASKED FOR, in the same order as the paths: '-l'
    '' first, then '#inclib'. fbc emits both as -l<name> ahead of its own runtime,
    '' measured -- a user library may call INTO libfb, and an archive is searched
    '' once, where it appears.
    for i as long = 0 to ctx.options.libs.Count - 1
        tools.libs.Push( ctx.options.libs[i] )
    next
    for i as long = 0 to ctx.options.pragmaLibs.Count - 1
        tools.libs.Push( ctx.options.pragmaLibs[i] )
    next
    for i as long = 0 to ctx.options.pragmaLibFiles.Count - 1
        tools.libFiles.Push( ctx.options.pragmaLibFiles[i] )
    next

    '' fbc's RULE, read and then measured: strip unless '-g'. This is also the
    '' first effect '-g' has ever had -- OPT_DEBUG set a field that nothing read.
    '' It does NOT yet make the compiler emit debug information; that is Phase 11.
    tools.stripSymbols = (ctx.options.debugInfo = false)
    tools.threadSafe = ctx.options.threadSafe
    tools.guiSubsystem = ctx.options.guiSubsystem

    '' THE IMPORT LIBRARY'S NAME FOLLOWS THE OUTPUT, not the source. Measured:
    '' 'fbc -dll thing.bas -x custom.dll' writes libcustom.dll.a. So it is built
    '' from outputPath -- directory kept, extension replaced, 'lib' on the basename.
    ''
    '' WINDOWS ONLY. An ELF shared library has no import library: the .so is what
    '' a program links against, and fbc writes nothing beside it on Linux.
    if ctx.options.outKind = Tko.OUT_DLL then tools.buildDll = true
    if (ctx.options.outKind = Tko.OUT_DLL) andalso Tko.TargetIsWindows( ctx.options.target ) then
        dim as string stem = StripExt_( ctx.options.outputPath )
        dim as long cut = 0
        for i as long = len( stem ) to 1 step -1
            dim as string ch = mid( stem, i, 1 )
            if (ch = "/") orelse (ch = "\") then
                cut = i
                exit for
            end if
        next
        tools.implibPath = left( stem, cut ) & "lib" & mid( stem, cut + 1 ) & ".dll.a"
    end if

    dim as long rc = Tko.Codegen.LinkExe( tools, td, objs, ctx.options.outputPath )
    if rc <> 0 then
        return ToolFail_( ctx, Tko.EXIT_TOOL_FAILED, Tko.TKO0116, str( rc ) )
    end if

    '' ONLY WHAT THIS BUILD MADE. An object the user named on the command line is
    '' theirs and is not deleted, however temporary it looks.
    if ctx.options.keepTemps = false then
        for i as long = 0 to keep.Count - 1
            kill( keep[i] )
        next
    end if
    return Tko.EXIT_OK
end function

'' THE RESTART: the same compiler, run again, with what the source asked for appended
'' to what the user asked for. Appended and not prepended, because fbc lets the source
'' WIN -- measured: '-s gui' on the command line with '#cmdline "-s console"' in the
'' file produces a console subsystem.
''
'' A fresh Run( ) is the whole mechanism. Its context, its diagnostic engine and its
'' option set are locals, so pass one leaves nothing behind; and because the words go
'' through Cmdline.Parse like any others, a '#cmdline' naming a '.rc' becomes an input
'' file and one naming an option tiko does not have becomes its usual error.
private function RestartWith_ _
    ( byref args as Tko.StrVec, byref injected as Tko.StrVec, _
      byval depth as long ) as long

    dim as Tko.StrVec again
    for i as long = 0 to args.Count - 1
        again.Push( args[i] )
    next
    for i as long = 0 to injected.Count - 1
        again.Push( injected[i] )
    next
    return Run( again, depth + 1 )
end function

function Run _
    ( byref args as Tko.StrVec, byval restartDepth as long = 0 ) as long

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
    '' Before the command-line check, so a bad option still reaches the file -- Parse
    '' reads the whole line whatever it finds, so the path is known either way.
    if Tko.DiagOut.Start( ctx ) = false then cmdOk = false

    '' THE TARGET DECIDES THE LAYOUT, and it is only known now. The context is built
    '' before the command line is parsed -- the source manager needs the interner's
    '' address, and the diagnostic engine the manager's -- so the constructor takes the
    '' HOST's layout and this replaces it. Nothing has been laid out yet: builtin sizes
    '' are computed on demand from 'target' and no layout is cached.
    ctx.types.Attach( @ctx.names, Tko.TargetLayoutFor( ctx.options.target ) )

    if cmdOk = false then
        return Tko.DiagOut.Finish( ctx, Tko.EXIT_CMDLINE )
    end if

    '' --version and --help answer and stop, even with other options present.
    if ctx.options.showVersion then
        print Tko.Cmdline.VersionText( );
        return Tko.DiagOut.Finish( ctx, Tko.EXIT_OK )
    end if
    if ctx.options.showHelp then
        print Tko.Cmdline.HelpText( ctx.options.helpCategory );
        return Tko.DiagOut.Finish( ctx, Tko.EXIT_OK )
    end if

    '' C HEADER IMPORT takes C headers, not a .bas -- see src/driver/cimportmode.bas.
    if Tko.CImportDriver.Asked( ctx.options ) then
        dim as Tko.Codegen.ToolPaths ptl = Tools_( ctx )
        return Tko.DiagOut.Finish( ctx, Tko.CImportDriver.Run( ctx, ptl.clangExe ) )
    end if

    if ctx.options.inputs.IsEmpty( ) then
        ctx.diags.ReportGlobal( Tko.TKO0102 )
        return Tko.DiagOut.Finish( ctx, Tko.EXIT_CMDLINE )
    end if

    '' ---- partition the inputs ---------------------------------------------
    ''
    '' AN OBJECT IS AN INPUT, NOT A SOURCE. Passing one used to send it through the
    '' lexer, which reported 'TKO0003: not valid UTF-8' and pointed at the COFF
    '' header -- an honest complaint about the wrong question. The suite's own build
    '' compiles every test to its own '.o' and then links the lot, so consuming
    '' objects is not a convenience, it is the whole of how fbc's makefile works.
    '' A '.rc' IS A THIRD KIND, and it used to be the second: a resource script went
    '' to the lexer as FreeBASIC. It did not even fail -- 'STRINGTABLE BEGIN 101,
    '' "text" END' is identifiers and a literal, which parse as statements -- so the
    '' program built, the resource was absent, and nothing said so.
    dim as Tko.StrVec objInputs
    dim as Tko.StrVec srcInputs
    dim as Tko.StrVec rcInputs
    '' ...AND A DIRECTORY IS A MODULE (ADR 0017): its files are compiled as one unit.
    dim as Tko.StrVec modDirs
    for each inputPath as string in ctx.options.inputs
        if FB.IsDir( inputPath ) then
            modDirs.Push( inputPath )
            continue for
        end if
        dim as string ext2 = Tko.Text.LowerAscii( right( inputPath, 2 ) )
        dim as string ext3 = Tko.Text.LowerAscii( right( inputPath, 3 ) )
        if ext2 = ".o" then
            objInputs.Push( inputPath )
        elseif ext3 = ".rc" then
            rcInputs.Push( inputPath )
        else
            srcInputs.Push( inputPath )
        end if
    next

    '' ---- a module directory: ONE module unit (ADR 0017, phase P2) ------------
    '' On its own, and never linked: a program that imports modules is phase P3's, so until
    '' then 'tiko -c <dir>' and the dump and emit modes are what a module directory is for.
    if modDirs.Count > 0 then
        dim as boolean alone = (modDirs.Count = 1) andalso (srcInputs.Count = 0)
        if alone then alone = (objInputs.Count = 0) andalso (rcInputs.Count = 0)
        dim as boolean links = (ctx.options.compileOnly = false)
        if links then links = (AnotherModeWasAsked_( ctx.options ) = false)
        if (alone = false) orelse links then
            ctx.diags.ReportGlobal( Tko.TKO0992, _
                "a module directory with other inputs or linked (phase P3); use 'tiko -c <dir>'" )
            return Tko.DiagOut.Finish( ctx, Tko.EXIT_USER_ERROR )
        end if
        if Tko.Modules.PrepareModuleUnit( ctx, modDirs[0], srcInputs ) = false then
            return Tko.DiagOut.Finish( ctx, Tko.EXIT_USER_ERROR )
        end if
    end if

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

    '' ---- the build graph, printed and nothing else -------------------------
    '' The roots are the sources just loaded; every module file the graph reaches is
    '' loaded after them, so the count is taken now (ADR 0017, src/driver/modgraph.bas).
    if ctx.options.printGraph then
        dim as long grc = Tko.Modules.PrintGraph( ctx, ctx.sources.Count( ) )
        ctx.diags.Flush( )
        return Tko.DiagOut.Finish( ctx, grc )
    end if

    '' ---- what this build can do -------------------------------------------
    '' HOISTED: a length test beside booleans in an 'orelse' chain is warning 38, which
    '' this project treats as a rule rather than as noise.
    '' THE DEFAULT, APPLIED HERE and not in the command line, because it must not
    '' fire when a dump was asked for -- and only the chain below knows that.
    if len( ctx.options.outputPath ) = 0 then
        if AnotherModeWasAsked_( ctx.options ) = false then
            ctx.options.outputPath = DefaultOutputPath_( ctx.options )
        end if
    end if

    '' 'PRODUCES BUILD OUTPUT', which is not the same as 'has an -o'. Under '-c'
    '' with no -o there is no single output path -- each module names its own
    '' object, as fbc's does -- so the old test read false and the run fell through
    '' to the error below. The link is gated separately on 'notCompileOnly'.
    dim as boolean hasOutPath = (len( ctx.options.outputPath ) > 0)
    dim as boolean wantsOutput = hasOutPath orelse ctx.options.compileOnly
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
            print using "  load  ##.### s  (#####.# MB/s)"; tLoad; mb / iif( tLoad > 0, tLoad, 1 )
            print using "  lex   ##.### s  (#####.# MB/s)"; tLex; mb / iif( tLex > 0, tLex, 1 )
        end if
    elseif ctx.options.dumpRtl then
        '' The inventory does not depend on any input, so it is answered before the
        '' sources are even looked at.
        '' FALSE: the stdcall-decorated inventory was win32's, and win32 is gone.
        print Tko.Mir.DumpRtl( false );

    elseif ctx.options.dumpSymbols orelse ctx.options.resolveOnly orelse _
           ctx.options.dumpMangle orelse ctx.options.checkOnly orelse _
           ctx.options.dumpIr orelse ctx.options.emitIr orelse ctx.options.emitAsm orelse _
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
            '' ...AND WHAT IT ASKS THE LINK FOR -- its '.fbctinf', as fbc reads it. See
            '' codegen/objinfo.bi; ApexWealth's network object named winhttp only there.
            Tko.Codegen.ReadObjInfo( objInputs[i], ctx.options.pragmaLibs, _
                                     ctx.options.pragmaLibPaths, _
                                     ctx.options.pragmaLibFiles, ctx.options.threadSafe )
        next

        '' EVERY '.rc' BECOMES A '.res' AND JOINS THE LINK. lld-link consumes a
        '' .res directly, so there is no object in between; fbc asks GoRC for a COFF
        '' object instead and arrives at the same .rsrc section.
        ''
        '' WINDOWS ONLY, and said rather than ignored: there is nothing to link a
        '' resource into on ELF, and a '.rc' handed to a Linux build is a mistake.
        for i as long = 0 to rcInputs.Count - 1
            if Tko.TargetIsWindows( ctx.options.target ) = false then
                ctx.diags.ReportGlobal( Tko.TKO0108, rcInputs[i] )
                continue for
            end if
            dim as Tko.Codegen.ToolPaths rt_ = _
                Tools_( ctx )
            if rt_.found = false then
                ctx.diags.ReportGlobal( Tko.TKO0109, rt_.why )
                exit for
            end if
            dim as string resPath = StripExt_( rcInputs[i] ) & ".res"
            dim as long rrc = Tko.Codegen.CompileRc( rt_, rcInputs[i], resPath )
            if rrc <> 0 then
                ctx.diags.ReportGlobal( Tko.TKO0110, rcInputs[i], str( rrc ) )
            else
                linkObjs.Push( resPath )
                '' Ours to delete: the '.rc' was the user's, the '.res' was not.
                tempObjs.Push( resPath )
            end if
        next
        '' THE BOUND IS FROZEN. Count( ) grows as the preprocessor opens includes,
        '' and reading it each time round would compile every header as a unit.
        dim as long srcCount = ctx.sources.Count( )
        '' A MODULE UNIT IS ONE UNIT, however many files it has: the engine reads them all.
        if ctx.modFileCount > 0 then srcCount = 1
        dim as double tFrontStart = timer
        for i as long = 1 to srcCount
            '' ONE UNIT, compiled by CompileUnit in unit.bas -- moved there unchanged on
            '' 2026-09-27, so that the module build of ADR 0017 can compile a unit it did
            '' not read from the command line. A '#cmdline' restart comes back here, because
            '' a restart is a fresh Run( ) and only Run has the arguments to restart with.
            dim as Tko.StrVec restartArgs
            if CompileUnit( ctx, i, srcCount, restartDepth, wantsOutput, _
                            linkObjs, tempObjs, toolExit, restartArgs ) then
                return RestartWith_( args, restartArgs, restartDepth )
            end if
        next

        '' THE FRONTEND'S OWN TIME, so the budget in docs/plan/14 section 4 can be read
        '' off a single file rather than wall-clocked with the process start-up
        '' subtracted -- over 2,709 files that subtraction is larger than the signal.
        if ctx.options.timePasses andalso ctx.options.checkOnly then
            print using "  front ##.### s"; timer - tFrontStart
        end if

        '' ---- the link, once, over every object --------------------------------
        ''
        '' NOT UNDER '-c', which asked for objects and nothing more, and not when the
        '' frontend already failed: linking half a program produces a second, louder
        '' failure that buries the first.
        '' HOISTED, each to its own boolean: a four-term 'andalso' chain mixing a
        '' flag with three comparisons is warning 38, which this file already treats
        '' as a rule rather than as noise.
        '' ...and never under '--emit-ir' or '--emit-asm', which stop at their file.
        dim as boolean emitStops = ctx.options.emitIr orelse ctx.options.emitAsm
        dim as boolean linkWanted = wantsOutput andalso (emitStops = false)
        dim as boolean notCompileOnly = (ctx.options.compileOnly = false)
        dim as boolean toolsOk = (toolExit = Tko.EXIT_OK)
        dim as boolean frontendOk = (FrontendFailed_( ctx ) = false)
        if linkWanted andalso notCompileOnly andalso toolsOk andalso frontendOk then
            if linkObjs.Count = 0 then
                ctx.diags.ReportGlobal( Tko.TKO0102 )
            else
                dim as Tko.Codegen.TargetDescription ltd = _
                    Tko.Codegen.TargetFor( ctx.options.target )
                '' '-lib' DOES NOT LINK. An archive is collected, not linked: its
                '' unresolved symbols stay unresolved until something links against
                '' it, so running the linker here would demand a main and a runtime
                '' that a library has no business carrying. Routed before LinkAll
                '' rather than inside it, because the two share nothing but their
                '' inputs -- lld-link answered '-lib' with 'subsystem must be
                '' defined', which is it asking which kind of PROGRAM this is.
                if ctx.options.outKind = Tko.OUT_STATICLIB then
                    toolExit = ArchiveAll( ctx, linkObjs, tempObjs )
                else
                    toolExit = LinkAll( ctx, linkObjs, ltd, tempObjs )
                end if
            end if
        end if

    elseif ctx.options.dumpAst orelse ctx.options.parseOnly then
        dim as longint nodes = 0
        dim as longint astBytes = 0
        dim as longint toks = 0
        dim as double tParseStart = timer
        for i as long = 1 to ctx.sources.Count( )
            dim as Tko.FileId id = cast( Tko.FileId, i )
            '' PULL: the parser drives the preprocessor, rather than consuming a
            '' vector the preprocessor finished building first.
            dim as Tko.PpResult pr
            dim as Tko.PpConfig cfg = MakePpConfig( ctx )
            cfg.cmdlineIgnored = (i > 1)
            dim as Tko.PpStream st
            Tko.PpOpen( st, ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, cfg, pr )

            dim as Tko.AstArena ast
            dim as Tko.ParserState p
            p.toks = @pr.tokens
            p.stream = @st
            p.litPool = @ctx.ppLits
            p.ast = @ast
            p.src = @ctx.sources
            p.kw = @ctx.keywords
            p.names = @ctx.names
            p.diags = @ctx.diags
            p.pos = 0
            '' The target's default convention, which the '...' rule needs. See
            '' ParserState.fbcallConv.
            p.fbcallConv = iif( Tko.TargetIsWindows( ctx.options.target ), _
                                Tko.CC_STDCALL, Tko.CC_CDECL )

            dim as Tko.NodeId root = Tko.Parse.Unit( p )
            Tko.PpClose( st )

            '' '#cmdline' RESTARTS THESE MODES TOO. '--parse-only' and '--dump-ast'
            '' answer 'what does tiko make of this file', and the honest answer is
            '' the one the compile would reach: a '#cmdline "-d FOO"' decides which
            '' branches exist, so a dump of the pass that had not read it yet would
            '' show a tree the compiler never builds.
            dim as boolean dumpRestarting = _
                (pr.cmdlineArgs.Count > 0) andalso (restartDepth = 0)
            if dumpRestarting then _
                return RestartWith_( args, pr.cmdlineArgs, restartDepth )

            nodes += ast.Count( )
            astBytes += AstBytes_( ast )
            toks += pr.tokens.Count
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
            if ctx.options.stats then
                print "  ast   "; astBytes; " bytes, "; toks; " tokens, "; _
                      csng( astBytes / iif( toks > 0, toks, 1 ) ); " bytes/token"
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
            cfg.cmdlineIgnored = (i > 1)
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
                cfg.cmdlineIgnored = (i > 1)
                Tko.PpRun( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, cfg, r )
                print Tko.PpDump( ctx.sources, ctx.names, r );
            else
                dim as Tko.Lex.Result r
                Tko.Lex.Run( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, r )
                print Tko.Lex.Dump( ctx.sources, id, ctx.names, r );
            end if
        next
    elseif wantsOutput = false then
        '' UNREACHABLE FOR A NORMAL BUILD, and kept anyway. Every path that has an
        '' input and no mode flag now has an output name too, so what is left here is
        '' the case where there was nothing to name one after. TKO0102 catches the
        '' empty command line before this, which leaves inputs that all failed to
        '' load -- already diagnosed, and worth a closing line rather than silence.
        ''
        '' What this used to say was that the compiler implemented 'the phase 2
        '' skeleton only'. It was the message for 'no -o', and it survived every
        '' phase that made it false.
        ctx.diags.ReportGlobal( Tko.TKO0992, _
            "compilation -- no output could be named from the inputs given" )
    end if

    ctx.diags.Flush( )
    if ctx.options.stats then ReportStats( ctx )

    '' THE PROGRAM FIRST: a program that failed to compile is a user error, and the
    '' toolchain never ran. A toolchain failure is an error in the engine too, now, so
    '' this asks FrontendFailed_ rather than HasErrors.
    dim as long rc = Tko.EXIT_OK
    if FrontendFailed_( ctx ) then
        rc = Tko.EXIT_USER_ERROR
    elseif toolExit <> Tko.EXIT_OK then
        rc = toolExit
    end if
    return Tko.DiagOut.Finish( ctx, rc )
end function

end namespace
