'' unit.bas -- compiling one translation unit: preprocess, parse, collect, resolve,
'' check, lower, emit. Moved out of Run in driver.bas on 2026-09-27, unchanged but for the
'' '#cmdline' restart, which now returns to Run rather than calling it from here. Two
'' reasons: driver.bas was at 1463 of its 1500 lines, and the module build of ADR 0017
'' compiles units that were never named on the command line, so the pass has to be
'' callable on its own.

#import "std/containers"
#include once "driver/unit.bi"
#include once "driver/modunit.bi"
#include once "driver/modresolve.bi"
#include once "symbols/modsym.bi"
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
#include once "driver/lowerreport.bi"
#include once "driver/tkiemit.bi"
#include once "driver/modiface.bi"
#include once "driver/modbuild.bi"
#include once "types/udtlayout.bi"
#include once "types/vtable.bi"
#include once "driver/scan.bi"
#include once "mir/rtl.bi"

namespace Tko.Driver

'' Is this fb_ name a runtime procedure? Check.ReportUndeclared's question, answered from
'' lowering's table -- a layer Check may not include.
function IsRtlName( byref nm as string ) as boolean
    return Tko.Mir.RtlByName( nm ) <> Tko.Mir.RTL_NONE
end function

'' WHICH SPELLING OF THE SIZED BUILTINS THIS UNIT'S OWN SOURCE WRITES (T34): 'int32',
'' 'float64' ... -- tiko's, prelude typedefs -- or fbc's 'long', 'double' ...; diagnostics then
'' name types the same way. 'dim as float64 ptr f = @n' over an int32 n warned about "a
'' 'double ptr' from a 'long ptr'", which the reader wrote neither of. Counted over the
'' unit's own files only -- the root, or a module's -- so a header written in fbc's names
'' does not outvote the program; a tie keeps fbc's names.
private function UnitSpellsSized_ _
    ( byref ctx as Tko.CompilerContext, byref ast as Tko.AstArena, byval rootId as Tko.FileId, _
      byref modFiles as Tko.IdVec ) as boolean
    dim as long sized = 0, legacy = 0
    for n as long = 1 to ast.Count( ) - 1
        if ast.Kind( cast( Tko.NodeId, n ) ) <> Tko.N_TYPEREF then continue for
        dim as Tko.StmtPayload ptr tp = @ast.stmts[cast( long, ast.nodes[n].data )]
        dim as long vote = 0
        select case cast( Tko.TokenKind, tp->op )
        case Tko.TK_IDENT
            select case lcase( ctx.names.Spelling( tp->name ) )
            case "int8", "uint8", "int16", "uint16", "int32", "uint32", "int64", "uint64", "float32", "float64"
                vote = 1
            end select
        case Tko.KW_BYTE, Tko.KW_UBYTE, Tko.KW_SHORT, Tko.KW_USHORT, Tko.KW_LONG, Tko.KW_ULONG, _
             Tko.KW_LONGINT, Tko.KW_ULONGINT, Tko.KW_SINGLE, Tko.KW_DOUBLE
            vote = -1
        end select
        if vote = 0 then continue for
        dim as Tko.FileId f = ctx.sources.Decode( ast.Loc( cast( Tko.NodeId, n ) ) ).file
        dim as boolean own = (f = rootId)
        if own = false then
            for k as long = 0 to modFiles.Count - 1
                if cast( Tko.FileId, modFiles[k] ) = f then own = true : exit for
            next
        end if
        if own = false then continue for
        if vote > 0 then sized += 1 else legacy += 1
    next
    return (sized > legacy)
end function

'' DOES UNIT i's TOP-LEVEL CODE BECOME 'main'? Decided once and asked twice: by the
'' preprocessor, for __FB_MAIN__ (T96), and by the lowering. The rules are below.
function IsMainUnit_ _
    ( byref ctx as Tko.CompilerContext, byval id as Tko.FileId, byval i as long ) as boolean
    dim as string modName = ModuleStem( ctx.sources.PathOf( id ) )
    if ctx.modFileCount > 0 then modName = ctx.modName
    dim as boolean isMain = false
    if len( ctx.options.mainModule ) > 0 then
        isMain = (Tko.Text.LowerAscii( modName ) = _
                  Tko.Text.LowerAscii( ctx.options.mainModule ))
    elseif ctx.options.compileOnly then
        isMain = false
    elseif ctx.options.outKind <> Tko.OUT_EXE then
        '' A LIBRARY AND A DLL HAVE NO MAIN MODULE unless one is NAMED.
        '' Measured, over a first module that has top-level code:
        ''
        ''     fbc -lib lc.bas lb.bas   static void fb_ctor__lc( void )
        ''                              __attribute__(( constructor ))
        ''     fbc -dll lc.bas          the same
        ''     fbc -lib -m lc lc.bas    int32 main( int32, char** )
        ''
        '' -- so the top-level code becomes a module CONSTRUCTOR, exactly as
        '' it does in any non-main module, and only -m brings a main back.
        '' tiko made the FIRST source the main module regardless, so every
        '' static library carried a main: linking one into a program is then
        '' 'lld-link: error: duplicate symbol: main', which is 77 of the
        '' corpus link failures build/linkscan.sh reports -- every file that
        '' links against a tiko-built libfbcunit.a.
        isMain = false
    else
        isMain = (i = 1)
    end if
    '' A MODULE IS NEVER MAIN: its top-level code is its initialiser (RFC-0006).
    if ctx.modFileCount > 0 then isMain = false
    return isMain
end function

private function ObjectFor_ _
    ( byref ctx as Tko.CompilerContext, byval id as Tko.FileId, byval i as long, _
      byval srcCount as long ) as string
    dim as string src = ctx.sources.PathOf( id )
    dim as string srcAbs = Tko.Modules.AbsPath( src )
    dim as string lone = ""
    for k as long = 0 to ctx.options.outputFor.Count - 2 step 2
        if len( ctx.options.outputFor[k] ) = 0 then
            lone = ctx.options.outputFor[k + 1]
        elseif Tko.Modules.AbsPath( ctx.options.outputFor[k] ) = srcAbs then
            return ctx.options.outputFor[k + 1]
        end if
    next
    if (len( lone ) > 0) andalso (i = srcCount) then return lone
    return StripExt_( src ) & ".o"
end function

function CompileUnit _
    ( byref ctx as Tko.CompilerContext, byval i as long, byval srcCount as long, _
      byval restartDepth as long, byval wantsOutput as boolean, _
      byref linkObjs as Tko.StrVec, byref tempObjs as Tko.StrVec, _
      byref toolExit as long, byref restartArgs as Tko.StrVec ) as boolean

    dim as Tko.FileId id = cast( Tko.FileId, i )
    dim as Tko.PpResult pr
    dim as Tko.PpConfig cfg = MakePpConfig( ctx )
    cfg.isMainModule = IsMainUnit_( ctx, id, i )
    cfg.cmdlineIgnored = (i > 1)
    '' A MODULE UNIT: every file of the module in this one engine, with the hermetic seed.
    dim as Tko.IdVec modFiles
    dim as Tko.StrVec noDefines
    if ctx.modFileCount > 0 then Tko.Modules.ModuleUnitConfig( ctx, cfg, modFiles, noDefines )
    if ctx.importsBuilt then Tko.Modules.InstallImports( ctx, cfg )
    dim as double tPh = timer
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
    p.recordDecls = (ctx.modFileCount > 0)
    p.ifaceChains = @ctx.ifaceChains
    '' The target's default convention, which the '...' rule needs. See
    '' ParserState.fbcallConv.
    p.fbcallConv = iif( Tko.TargetIsWindows( ctx.options.target ), _
                        Tko.CC_STDCALL, Tko.CC_CDECL )

    dim as Tko.NodeId root = Tko.Parse.Unit( p )
    ctx.types.spellSized = UnitSpellsSized_( ctx, ast, id, modFiles )
    '' The editor scan wants the unit's macros, and PpClose frees them.
    dim as Tko.MacroInfoVec scanMacros
    if ctx.scan <> 0 then Tko.PpSnapshotMacros( st, scanMacros )
    Tko.PpClose( st )
    ctx.timing.Add( Tko.PH_FRONT, tPh )

    '' '#cmdline' -- WHAT THE SOURCE ASKED TO BE COMPILED WITH. Collected from
    '' every module of this pass before any of it is acted on, because that is
    '' fbc's shape: two directives make ONE restart, and a '#cmdline' in the
    '' second file binds as hard as one in the first.
    ''
    '' Nothing else of this pass runs. Collect, Resolve, Check, Lower, the emit
    '' and every later module all belong to a pass whose options are already
    '' known to be the wrong ones, and their diagnostics would be wrong with
    '' them. None of it is flushed: the restart returns before the tail
    '' flushes, so pass one is silent exactly as fbc's is -- a file with both
    '' a syntax error and a '#cmdline' reports the error once.
    ''
    '' Only the FIRST module gets here with anything to say; the preprocessor
    '' warns (TKO0334) and collects nothing for any later one.
    dim as boolean restarting = (pr.cmdlineArgs.Count > 0) andalso (restartDepth = 0)
    if restarting then
        '' THE RESTART ITSELF IS Run's: it is a fresh Run( ) over the command line, which
        '' only Run has. The arguments go back to it, and nothing else of this pass runs.
        for k as long = 0 to pr.cmdlineArgs.Count - 1
            restartArgs.Push( pr.cmdlineArgs[k] )
        next
        return true
    end if

    '' PAST THE ERROR CAP NOTHING MORE OF THIS UNIT RUNS: its errors would go unheard, and
    '' nothing is built from a unit that failed. Asked again after each pass below.
    if ctx.diags.Stopped( ) then return false

    '' WHAT THE SOURCE ASKED TO LINK AGAINST. Harvested per module and
    '' accumulated, because the link happens once over all of them: a
    '' '#inclib' in the second file is as binding as one in the first.
    ''
    '' Only on the COMPILING path. The dump modes run the same open/parse
    '' pair and link nothing, so collecting there would build a list that
    '' is never read.
    ''
    '' Duplicates are not filtered. Naming a library twice is harmless to
    '' the linker, and filtering would have to decide whether two spellings
    '' of a name are one library -- which is the linker's question.
    for k as long = 0 to pr.incLibs.Count - 1
        ctx.options.pragmaLibs.Push( pr.incLibs[k] )
    next
    '' ...AND WHAT A 'declare ... lib "name"' ASKED FOR, which is the same
    '' request in the other spelling. The clause was parsed and the name
    '' discarded, so 'declare function SHCreateItemFromParsingName lib
    '' "shell32"' left an undefined symbol with shell32 sitting unused in
    '' the toolchain.
    for k as long = 0 to p.declLibs.Count - 1
        ctx.options.pragmaLibs.Push( _
            ctx.names.Spelling( cast( Tko.InternId, p.declLibs[k] ) ) )
    next
    for k as long = 0 to pr.libPaths.Count - 1
        ctx.options.pragmaLibPaths.Push( pr.libPaths[k] )
    next
    for k as long = 0 to pr.foreignLibFiles.Count - 1
        ctx.options.pragmaLibFiles.Push( pr.foreignLibFiles[k] )
    next
    '' What a module's cache entry depends on (modcache.bas).
    ctx.unitFilesRead.Clear( )
    for each f as ulong in pr.filesRead
        ctx.unitFilesRead.Push( f )
    next
    ctx.unitProbesMissed.Clear( )
    for each m_ as string in pr.probesMissed
        ctx.unitProbesMissed.Push( m_ )
    next
    ctx.unitThreadRtl = false
    ctx.unitUsesClock = pr.usesClock

    dim as Tko.SymbolTable syms
    syms.Attach( @ctx.names )
    dim as Tko.SemanticInfo info
    '' A MODULE UNIT, before Collect: its out-of-line members wait for their types.
    if ctx.modFileCount > 0 then Tko.ModSym.Begin( syms, ctx.modFiles, ctx.modChain )
    tPh = timer
    Tko.Collect.Run( ast, root, syms, ctx.names, ctx.types, ctx.diags, _
                     info, @ctx.sources )
    ctx.timing.Add( Tko.PH_COLLECT, tPh )
    '' MODULE CODE, and what it lets out (ADR 0017): before Resolve, whose generic
    '' instances copy their generic's marks.
    if ctx.modFileCount > 0 then Tko.ModSym.Mark( ast, syms, info, ctx.sources, ctx.diags )
    if ctx.importsBuilt then Tko.Modules.BindImports( ctx, ast, syms, info, pr.imports )

    '' '#pragma reserve NAME' TAKES A NAME OUT OF CIRCULATION -- fbc error 4 for
    '' anything that then declares it. The two halves of that fact meet HERE and
    '' nowhere else: the reserved names are the PREPROCESSOR's, and whether a
    '' name was declared is COLLECT's, and neither phase can see the other's.
    '' The engine that read the directive has already closed, which is why the
    '' list travels on the result.
    '' EVERY SYMBOL, not a lookup in the global scope: a module-level 'dim'
    '' lands in the FILE's scope and a 'sub' in its own, so asking SCOPE_GLOBAL
    '' found neither and the check silently never fired. The reserved list is a
    '' handful of names and the table is walked once.
    '' ...AND ANY USE OF ONE -- fbc 325, "Illegal use of reserved symbol".
    '' Every appearance, not just the 'sizeof( symbol )' the survey recorded:
    '' 'print foo', 'foo = 1' and 'dim as integer x = foo' are all 325.
    ''
    '' A DECLARATION IS NOT AN N_IDENT, so this cannot double-report with the
    '' declaration rule below: 'dim as integer foo' carries the name on an
    '' N_VAR_ITEM payload and creates no identifier node at all.
    '' ...EXCEPT THE SYMBOL '__FB_QUERY_SYMBOL__( q, sym )' ASKS ABOUT, which is not a use
    '' of it: fbc answers FB_SYMBCLASS_RESERVED, and its own fbc-int/query-symbol.bas
    '' asks. The names go on the table too, for the lowering that answers.
    dim as Tko.IdVec queried
    syms.reservedNames.Clear( )
    for each r as ulong in pr.reservedNames
        syms.reservedNames.Push( r )
    next
    if pr.reservedNames.Count > 0 then
        for n as long = 1 to ast.Count( )
            if ast.Kind( cast( Tko.NodeId, n ) ) <> Tko.N_CALL then continue for
            dim as Tko.ListPayload ptr cp = @ast.lists[cast( long, ast.nodes[n].data )]
            if (cp->count <> 2) orelse (cp->target = Tko.NODE_NONE) then continue for
            if ast.Kind( cp->target ) <> Tko.N_IDENT then continue for
            dim as Tko.InternId cn = ast.idents[cast( long, ast.nodes[cast( long, cp->target )].data )].name
            if Tko.Text.LowerAscii( ctx.names.Spelling( cn ) ) <> "__fb_query_symbol__" then continue for
            queried.Push( ast.children[cp->first + 1] )
        next
    end if
    for n as long = 1 to ast.Count( )
        dim as Tko.NodeId un = cast( Tko.NodeId, n )
        if ast.Kind( un ) <> Tko.N_IDENT then continue for
        dim as boolean asked = false
        for each q as ulong in queried
            if q = cast( ulong, n ) then asked = true
        next
        if asked then continue for
        dim as Tko.IdentPayload ptr uip = _
            @ast.idents[cast( long, ast.nodes[cast( long, un )].data )]
        for k as long = 0 to pr.reservedNames.Count - 1
            if uip->name <> cast( Tko.InternId, pr.reservedNames[k] ) then
                continue for
            end if
            ctx.diags.Report( Tko.TKO0770, Tko.PointRange( ast.Loc( un ) ), _
                              ctx.names.Spelling( uip->name ) )
            exit for
        next
    next

    for k as long = 0 to pr.reservedNames.Count - 1
        dim as Tko.InternId rnm = cast( Tko.InternId, pr.reservedNames[k] )
        for si as long = 1 to syms.Count( )
            dim as Tko.Symbol ptr rsym = syms.SymbolAt( cast( Tko.SymbolId, si ) )
            if rsym = 0 then continue for
            if rsym->name <> rnm then continue for
            ctx.diags.Report( Tko.TKO0769, Tko.PointRange( rsym->loc ), _
                              ctx.names.Spelling( rnm ) )
            exit for
        next
    next

    if ctx.diags.Stopped( ) then return false

    if ctx.scan <> 0 then
        '' THE EDITOR SCAN: the front end to Check, harvested -- no layout, no code.
        Tko.Scan.RunUnit( ctx, ast, root, syms, info, p, pr, scanMacros )
    elseif ctx.options.dumpVtable then
        '' Matching an override needs the PARAMETER TYPES, so this runs after
        '' Resolve like the layout pass does.
        dim as Tko.Resolve.Stats rst
        Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                         ctx.sources, info, rst, @p, ctx.options.maxInstDepth )
        dim as Tko.VTables vt
        Tko.ComputeVTables( ast, syms, ctx.types, info, vt )
        print Tko.DumpVTables( ast, vt, ctx.types, ctx.names, syms, info );
    elseif ctx.options.dumpUdt then
        dim as Tko.Resolve.Stats rst
        Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                         ctx.sources, info, rst, @p, ctx.options.maxInstDepth )
        dim as Tko.UdtLayouts store
        Tko.ComputeUdtLayouts( syms, ctx.types, store )
        print Tko.DumpUdtLayouts( store, ctx.types, ctx.names, syms );
    elseif ctx.options.dumpIr orelse ctx.options.emitIr orelse _
           ctx.options.emitAsm orelse wantsOutput then
        '' MIR needs the full frontend in front of it: resolve binds names,
        '' check gives every expression a type, and lowering reads both.
        dim as Tko.Resolve.Stats rst
        tPh = timer
        Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                         ctx.sources, info, rst, @p, ctx.options.maxInstDepth )
        ctx.timing.Add( Tko.PH_RESOLVE, tPh )
        if ctx.diags.Stopped( ) then return false
        dim as Tko.Check.Stats cst
        tPh = timer
        Tko.Check.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                       info, cst )
        if ctx.diags.Stopped( ) then return false
        '' A name nothing declared, once Check has had its say -- fbc's 42. Not
        '' in a unit whose '#lang' was refused: there it may be an implicit one.
        if pr.langRefused = false then
            Tko.Check.ReportUndeclared( ast, ctx.names, ctx.sources, ctx.diags, _
                                        info, rst, pr.reservedNames, syms, @IsRtlName )
        end if
        ctx.timing.Add( Tko.PH_CHECK, tPh )
        tPh = timer
        '' AFTER Check: a member access needs its symbol, and only Check binds
        '' one -- a field means nothing until its base has a type.
        Tko.Vis.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, info )
        '' A MODULE'S PUBLIC DECLARATIONS NAME ONLY WHAT AN IMPORTER CAN (TKO0868).
        if ctx.modFileCount > 0 then Tko.ModSym.CheckPublicTypes( syms, ctx.types, ctx.diags )
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
        if ctx.diags.Stopped( ) then return false
        '' A MODULE OF THE BUILD LEAVES ITS INTERFACE for what imports it (modiface.bas).
        dim as boolean publishes = (ctx.modFileCount > 0) andalso ctx.importsBuilt
        if publishes then publishes = (FrontendFailed_( ctx ) = false)
        if publishes then Tko.Modules.PublishInterface( ctx, pr, ast, syms, info )
        ctx.timing.Add( Tko.PH_SEMA, tPh )
        '' WHICH MODULE OWNS main. Three arms, and all three are fbc's,
        '' measured 2026-09-04:
        ''
        ''   '-m NAME'          that module is main. The name is matched
        ''                      against a basename, so '-m b' picks module b
        ''                      whatever path it came from.
        ''   no '-m', LINKING   the FIRST source is main. Reversing the input
        ''                      order moves main with it:
        ''                        fbc a.bas b.bas -> B ctor, then A as main
        ''                        fbc b.bas a.bas -> A ctor, then B as main
        ''   no '-m', '-c'      NO module is main. 'fbc -c mod.bas' emits a
        ''                      constructor and a .ctors entry and no 'main'
        ''                      at all -- which is what stops two separately
        ''                      compiled objects from each claiming it.
        ''
        '' That last arm is easy to miss and is the whole point of the
        '' feature: defaulting to "first source" under '-c' would put a main
        '' in every object and collide at the link, which is the bug '-m'
        '' exists to prevent.
        dim as string modName = ModuleStem( ctx.sources.PathOf( id ) )
        if ctx.modFileCount > 0 then modName = ctx.modName
        dim as boolean isMain = IsMainUnit_( ctx, id, i )
        tPh = timer
        Tko.Mir.Lower( ast, root, syms, ctx.types, ctx.names, info, _
                       ctx.sources, udts, vts, mm, lst, isMain, modName, _
                       ctx.options.errFlags, @ctx.diags, cast( long, id ) )
        ctx.timing.Add( Tko.PH_LOWER, tPh )
        '' THE THREAD-SAFE RUNTIME IS CHOSEN HERE, not on the command line
        '' alone -- see Tko.Mir.UsesThreadRtl for what fbc does and how it
        '' was measured. tiko-editor links no '-mt' and creates five threads:
        '' it got libfb.a, whose TLS context table is an ORDINARY GLOBAL and
        '' whose flag update has no mutex, so a worker's exit tore down the
        '' main thread's context and read its own FBTHREAD back as 1.
        ''
        '' STICKY ACROSS MODULES, never cleared: one module making a thread
        '' settles it for the whole link, exactly as an input object's own
        '' '-mt' does through ReadObjInfo.
        if Tko.Mir.UsesThreadRtl( mm, ctx.names, _
                ctx.types.target.pointerBits = 32 ) then
            ctx.options.threadSafe = true
            ctx.unitThreadRtl = true
        end if
        if ctx.types.target.wcharBytes <> 2 then mm.SplitUtf16Literals( ctx.names )
        '' WHO INITIALISES WHAT (RFC-0006): a module unit, its direct imports, in build
        '' order; a root of a build with modules, every module, in build order.
        if ctx.modFileCount > 0 then mm.modChain = ctx.modChain
        if ctx.importsBuilt then Tko.Modules.InitOrder( ctx, mm.modInits )
        '' THE ABI PASS, between lowering and emission (docs/plan/10 section
        '' 3). It rewrites signatures and call sites so the emitted IR carries
        '' no implicit ABI behaviour -- and it runs under '--dump-ir' too, so
        '' the MIR dump shows what will actually be passed rather than what the
        '' frontend meant. Seeing the ABI without reading LLVM is the point of
        '' having it as a separate pass at all.
        dim as Tko.Codegen.AbiStats abist
        dim as Tko.Codegen.TargetDescription abitgt = _
            Tko.Codegen.TargetFor( ctx.options.target )
        tPh = timer
        Tko.Codegen.LowerModule( mm, ctx.names, abitgt, abist )
        ctx.timing.Add( Tko.PH_ABI, tPh )

        '' '--emit-ir' RUNS THE SAME FRONTEND and prints the backend's
        '' output instead of MIR's. It is the escape hatch docs/plan/10 asks
        '' for, and it is the only way to see what the emitter produced
        '' without a working link.
        '' AN OUTPUT PATH MEANS BUILD. '--emit-ir' without one is the escape
        '' hatch that prints the module; with one, or with neither, the driver
        '' produces the file that was asked for. 'tiko foo.bas -o foo.exe' is
        '' the spelling that matters and it used to report "not implemented".
        dim as boolean doCodegen = ctx.options.emitIr orelse ctx.options.emitAsm orelse wantsOutput
        '' NOT AFTER AN ERROR. A compile that reported one produces no object
        '' either way -- the driver exits EXIT_USER_ERROR -- so running the
        '' emitter over a module the frontend already declined buys nothing
        '' and costs an ICE on top of the real diagnostic. Measured: 42 of the
        '' 48 "alloca of a void slot" failures the codegen scan reported are
        '' files that ALSO print a TKO error, '#lang "qb"' among them -- the
        '' void slot IS the declined declaration, and the message the user
        '' needs is the one above it.
        if FrontendFailed_( ctx ) then doCodegen = false
        '' THE VERIFIER RUNS BEFORE THE EMITTER, and a module it rejects, or one with a
        '' statement lowering declined, is NOT BUILT. Both used to be reported after the
        '' object and the link already existed -- a verify failure on stderr, a decline as
        '' a count under --dump-ir -- and the exit code was 0 either way, so the program
        '' ran without the statement. Five audits of this compiler found that path on
        '' their own (2026-10-03). The MIR dump and its report are unchanged.
        tPh = timer
        dim as Tko.Mir.VerifyResult vr = Tko.Mir.Verify( mm, ctx.names )
        ctx.timing.Add( Tko.PH_VERIFY, tPh )
        if doCodegen then
            if vr.failures > 0 then
                dim as long vnl = instr( vr.report, chr( 10 ) )
                dim as string vfirst = iif( vnl > 0, left( vr.report, vnl - 1 ), vr.report )
                toolExit = ToolFail_( ctx, Tko.EXIT_ICE, Tko.TKO0993, _
                    "the MIR verifier found " & str( vr.failures ) & " fault(s): " & vfirst )
                doCodegen = false
            elseif (lst.scopeImbalance > 0) orelse (lst.labelDepthMismatch > 0) then
                toolExit = ToolFail_( ctx, Tko.EXIT_ICE, Tko.TKO0993, _
                    "scopes opened and closed out of step -- " & str( lst.scopeImbalance ) & _
                    " imbalance(s), " & str( lst.labelDepthMismatch ) & " label mismatch(es)" )
                doCodegen = false
            elseif lst.skipped > 0 then
                '' '--allow-unlowered' makes it a WARNING and builds without the statement, as
                '' every build did before -- for a program that has to build while its
                '' declines are fixed. -Werror still stops it.
                dim as Tko.DiagId sid = Tko.TKO0994
                if ctx.options.allowUnlowered then sid = Tko.TKO0995
                dim as long sbefore = ctx.diags.ErrorCount( )
                for k as long = 0 to lst.skipLocs.Count - 1
                    ctx.diags.Report( sid, _
                        Tko.PointRange( cast( Tko.SourceLoc, lst.skipLocs[k] ) ), str( lst.skipped ) )
                next
                if lst.skipLocs.Count = 0 then ctx.diags.ReportGlobal( sid, str( lst.skipped ) )
                dim as long sadded = ctx.diags.ErrorCount( ) - sbefore
                ctx.diags.Flush( )
                if sadded > 0 then
                    ctx.toolErrors += sadded
                    if toolExit = Tko.EXIT_OK then toolExit = Tko.EXIT_ICE
                    doCodegen = false
                end if
            end if
        end if
        if doCodegen then
            dim as Tko.Codegen.TargetDescription td = _
                Tko.Codegen.TargetFor( ctx.options.target )
            '' '-g' DESCRIBES VARIABLES FROM THE FRONTEND, which is still alive here.
            dim as Tko.Codegen.DebugFrontend dfe
            dfe.types = @ctx.types : dfe.syms = @syms
            dfe.udts = @udts : dfe.names = @ctx.names
            tPh = timer
            dim as Tko.Codegen.EmitResult er = _
                Tko.Codegen.EmitLlvm( mm, ctx.names, td, @ctx.sources, _
                                      ctx.options.debugInfo, ctx.sources.AbsPathOf( id ), @dfe )
            ctx.timing.Add( Tko.PH_EMIT, tPh )
            if er.ok then
                '' '--emit-ir' AND '--emit-asm' WRITE THEIR FILE AND STOP --
                '' EmitStopFile_. Everything else with an output builds.
                ''
                '' THE TEST IS 'DOES THIS RUN BUILD', not 'is there an -o'.
                '' They stopped being the same thing when '-c' gained the
                '' right to name its own objects: with no -o the path is
                '' empty, and this gate sent a '-c' run down the print-to-
                '' stdout arm -- object never written, exit code 0.
                if ctx.options.emitIr orelse ctx.options.emitAsm then
                    dim as long ex = EmitStopFile_( ctx, er.text, td, id, i, srcCount )
                    if (ex <> Tko.EXIT_OK) andalso (toolExit = Tko.EXIT_OK) then toolExit = ex
                elseif wantsOutput then
                    '' The result IS the exit code. BuildFromIr reports its
                    '' own failure to stderr -- clang missing, clang failed,
                    '' the link failed -- and none of those is a diagnostic,
                    '' so discarding this returned 0 with nothing built.
                    '' THE OBJECT'S NAME. Under '-c' the user named it and
                    '' there is exactly one. Otherwise it is an intermediate,
                    '' named after the OUTPUT plus the module's index so two
                    '' sources cannot collide, and deleted after the link.
                    dim as string objPath = ctx.options.outputPath
                    '' '-c' OVER SEVERAL SOURCES: each its own object -- the '-o' that followed
                    '' it, else its stem; a lone '-o' given before every input is the LAST
                    '' source's, as fbc's is. All of them went to the one '-o' (audit F-47).
                    if ctx.options.compileOnly andalso (srcCount > 1) then
                        objPath = ObjectFor_( ctx, id, i, srcCount )
                    end if
                    if ctx.options.compileOnly = false then
                        objPath = ctx.options.outputPath & "." & str( i ) & ".o"
                        '' A STATIC LIBRARY'S MEMBERS ARE NAMED AFTER THEIR
                        '' SOURCES. An intermediate object's name is invisible
                        '' when it is linked and then deleted -- but an ARCHIVE
                        '' keeps it, as the member name, and 'ar t' on ours
                        '' listed 'libmylib.a.1.o' and 'libmylib.a.2.o' where
                        '' fbc lists 'thing.o' and 'other.o'. Measured on the
                        '' same two sources.
                        ''
                        '' The BASENAME is what ar stores, so two sources of the
                        '' same name in different directories give two members
                        '' of the same name -- which is exactly what fbc does
                        '' with them, and not a new failure mode.
                        if ctx.options.outKind = Tko.OUT_STATICLIB then
                            objPath = StripExt_( ctx.sources.PathOf( id ) ) & ".o"
                            '' ...AND A MODULE'S AFTER ITS CHAIN, beside the archive: its source
                            '' may be in the toolchain's pkg/, which is nobody's to write in.
                            if ctx.modFileCount > 0 then objPath = Tko.Modules.ArchiveMemberPath( ctx )
                        end if
                        tempObjs.Push( objPath )
                    elseif len( objPath ) = 0 then
                        '' '-c' WITH NO -o: EACH MODULE NAMES ITS OWN OBJECT,
                        '' as fbc does. One shared default would have been
                        '' worse than the error it replaced -- 'tiko -c a.bas
                        '' b.bas' would write b's object over a's and report
                        '' success, and a silent wrong answer beats a loud
                        '' wrong one only from the compiler's point of view.
                        objPath = StripExt_( ctx.sources.PathOf( id ) ) & ".o"
                        '' A MODULE'S OBJECT IS NAMED FOR THE MODULE, in the current directory.
                        if ctx.modFileCount > 0 then objPath = ctx.modName & ".o"
                    end if
                    '' '-c' OF A PROGRAM THAT IMPORTS: a module's object is its chain's,
                    '' beside the output, as for an archive -- not the root's -o.
                    dim as boolean modC = ctx.importsBuilt andalso ctx.options.compileOnly
                    if modC andalso (ctx.modFileCount > 0) then objPath = Tko.Modules.ArchiveMemberPath( ctx )
                    '' AN OBJECT KEPT FOR ANOTHER LINK SAYS WHAT IT NEEDS, in the
                    '' '.fbctinf' section fbc writes -- see codegen/objinfo.bi. A root's names
                    '' the objects of the modules it imports, which that link adds.
                    if ctx.options.compileOnly then
                        dim as Tko.StrVec noMods
                        dim as boolean records = modC andalso (ctx.modFileCount = 0)
                        er.text += Tko.Codegen.ObjInfoIr( ctx.options.libs, _
                            ctx.options.pragmaLibs, ctx.options.libPaths, _
                            ctx.options.pragmaLibPaths, _
                            ctx.options.pragmaLibFiles, ctx.options.threadSafe, _
                            iif( records, ctx.modObjPaths, noMods ) )
                    end if
                    '' THE FIRST FAILURE STAYS. Assigned straight to toolExit,
                    '' module 2 compiling cleanly reset module 1's clang failure
                    '' to OK -- and the link then ran without its object.
                    dim as long bx = BuildFromIr( ctx, er.text, td, objPath )
                    if bx = Tko.EXIT_OK then
                        linkObjs.Push( objPath )
                    elseif toolExit = Tko.EXIT_OK then
                        toolExit = bx
                    end if
                else
                    print er.text;
                end if
            else
                '' AN INTERNAL FAULT, and exits as one. The compiler could not
                '' emit something it accepted. It was 'emit: ICE:' on STDOUT --
                '' inside the .ll under --emit-ir -- and invisible to an editor.
                toolExit = ToolFail_( ctx, Tko.EXIT_ICE, Tko.TKO0993, er.ice )
            end if
        '' ONLY WHEN '--dump-ir' ASKED. This was a bare 'else', so a BUILD that
        '' reported an error fell into it and printed the whole module where the
        '' diagnostics belonged -- measured 2026-09-14 on tracks, eight minutes of
        '' string concatenation in DumpModule before the first error was shown.
        elseif ctx.options.dumpIr then
            print Tko.Mir.DumpModule( mm, ctx.names );
        end if
        '' THE REPORT GOES TO STDERR UNDER '--emit-ir', because stdout is
        '' then a .ll FILE: a 'verify: ok' line in the middle of a module is
        '' not a comment, and clang rejects the whole thing. Under '--dump-ir'
        '' stdout is a report already and the two stay together.
        dim as boolean quiet = ctx.options.emitIr orelse ctx.options.emitAsm orelse wantsOutput
        '' The verifier is an ICE check, not a diagnostic: a failure means
        '' the compiler built something malformed. It ran above, before the emitter.
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
        if quiet = false then Tko.Driver.PrintLowerReport( ctx, lst, sum_ )
    elseif ctx.options.checkOnly then
        dim as Tko.Resolve.Stats rst
        Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                         ctx.sources, info, rst, @p, ctx.options.maxInstDepth )
        dim as Tko.Check.Stats cst
        Tko.Check.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                       info, cst )
        if pr.langRefused = false then
            Tko.Check.ReportUndeclared( ast, ctx.names, ctx.sources, ctx.diags, _
                                        info, rst, pr.reservedNames, syms, @IsRtlName )
        end if
        if ctx.options.dumpDecisions then
            print Tko.Check.DumpDecisions( ast, ctx.sources, ctx.names, syms, info );
        else
            print Tko.Check.Dump( ast, ctx.sources, ctx.types, ctx.names, info, cst );
        end if
    elseif ctx.options.emitTki then
        '' A MODULE'S INTERFACE, written only from a unit that checked clean: an importer
        '' parses it, and an interface over a declaration the module got wrong would move
        '' the error somewhere nobody can fix it.
        dim as Tko.Resolve.Stats rst
        Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                         ctx.sources, info, rst, @p, ctx.options.maxInstDepth )
        dim as Tko.Check.Stats cst
        Tko.Check.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                       info, cst )
        Tko.ModSym.CheckPublicTypes( syms, ctx.types, ctx.diags )
        if pr.langRefused = false then
            Tko.Check.ReportUndeclared( ast, ctx.names, ctx.sources, ctx.diags, _
                                        info, rst, pr.reservedNames, syms, @IsRtlName )
        end if
        if FrontendFailed_( ctx ) = false then
            dim as Tko.StrVec noAliases, noSpaces
            print Tko.Modules.WriteInterface( ctx, pr.tokens, ast, syms, info, noAliases, _
                                              noSpaces, pr.modHeaders, @pr );
        end if
    elseif ctx.options.dumpMangle then
        '' Mangling needs the parameter TYPES, so it runs after Resolve --
        '' but the reference-binding report is not wanted here.
        dim as Tko.Resolve.Stats rst
        Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                         ctx.sources, info, rst, @p, ctx.options.maxInstDepth )
        print Tko.Mangle.Dump( ast, root, syms, ctx.names, ctx.types, info );
    elseif ctx.options.resolveOnly then
        dim as Tko.Resolve.Stats rst
        Tko.Resolve.Run( ast, root, syms, ctx.types, ctx.names, ctx.diags, _
                         ctx.sources, info, rst, @p, ctx.options.maxInstDepth )
        print Tko.Resolve.Dump( ast, syms, ctx.types, ctx.names, info, rst );
    else
        print Tko.Collect.Dump( syms, ctx.names, ctx.types, ctx.sources );
    end if
    return false
end function

end namespace
