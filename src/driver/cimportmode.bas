'' cimportmode.bas -- '-cimport' and '--cimport-probe'. See cimportmode.bi.
''
'' '-cimport <h> -cimport-out <f>' writes a binding and stops: the form to check a binding
'' into a repository, to read what the importer produced, or to diff it across an SDK
'' upgrade. The output is deterministic, so a diff means the header changed.

#include once "driver/cimportmode.bi"
#include once "codegen/target.bi"
#include once "cimport/import.bi"
#include once "cimport/probe.bi"
#include once "driver/cimportverify.bi"

namespace Tko.CImportDriver

function Asked( byref o as Tko.DriverOptions ) as boolean
    return (len( o.cimportProbe ) > 0) orelse (o.cimportHeaders.Count > 0)
end function

'' The file as bytes, LF and all -- the binding is LF-only on every host, and a text-mode
'' write would turn it CRLF on Windows and break byte-identity across machines.
private function WriteBytes_( byref path_ as string, byref text as string ) as boolean
    '' '-' IS STANDARD OUTPUT: to read a binding without a file, and how the tests see one.
    if path_ = "-" then
        print text;
        return true
    end if
    dim as long f = freefile( )
    if open( path_ for binary access write as #f ) <> 0 then return false
    if len( text ) then put #f, , text
    close #f
    return true
end function

'' The one hint that fixes each target's commonest failure: a header clang could not find.
private function NotFoundHint_( byref ctx as Tko.CompilerContext ) as string
    select case ctx.options.target
    case Tko.TARGET_WIN64_MSVC
        return "win64-msvc imports against the installed MSVC and Windows SDK headers; " & _
               "install Visual Studio Build Tools with the Windows SDK, or name the directory with -cinclude"
    case Tko.TARGET_WIN64
        return "win64 imports against MinGW-w64's headers; put its gcc on PATH, " & _
               "or set the sysroot with -csysroot"
    case else
        return "add the directory with -cinclude, or set the sysroot with -csysroot " & _
               "(a Linux target imported from another host needs one)"
    end select
end function

function Run( byref ctx as Tko.CompilerContext, byref clangExe as string ) as long
    dim as Tko.Codegen.TargetDescription td = Tko.Codegen.TargetFor( ctx.options.target )

    if len( ctx.options.cimportProbe ) then
        return Tko.CImport.CImportProbe( clangExe, ctx.options.cimportProbe, td.triple, _
                                         ctx.options.cIncludes )
    end if

    if len( ctx.options.cimportOut ) = 0 then
        ctx.diags.ReportGlobal( Tko.TKO0118 )
        return Tko.EXIT_CMDLINE
    end if

    dim as Tko.CImport.ClangApi api
    if Tko.CImport.ClangLoad( api, clangExe ) = false then
        ctx.diags.ReportGlobal( Tko.TKO0119, api.why )
        return Tko.EXIT_NO_TOOLCHAIN
    end if

    dim as Tko.CImport.CImportOptions io
    for i as long = 0 to ctx.options.cimportHeaders.Count - 1
        io.headers.Push( ctx.options.cimportHeaders[i] )
    next
    for i as long = 0 to ctx.options.cIncludes.Count - 1
        io.cincludes.Push( ctx.options.cIncludes[i] )
    next
    for i as long = 0 to ctx.options.cDefines.Count - 1
        io.cdefines.Push( ctx.options.cDefines[i] )
    next
    for i as long = 0 to ctx.options.cOpts.Count - 1
        io.copts.Push( ctx.options.cOpts[i] )
    next
    io.csysroot = ctx.options.cSysroot
    io.noMacros = ctx.options.cNoMacros
    io.targetName = Tko.TargetName( ctx.options.target )
    io.triple = td.triple
    io.isWindows = Tko.TargetIsWindows( ctx.options.target )
    io.clangExe = clangExe

    '' EVERY RECORD IS LAID OUT BY TIKO AND COMPARED WITH CLANG -- and one that differs is
    '' refused, with the difference in the ledger, and the header imported again: what held
    '' it by value goes with it, and the rest of the binding is still usable. SysV packs
    '' 'unsigned x : 3; unsigned y : 5; char c;' into four bytes, which FreeBASIC's
    '' bit-field containers cannot say. fbc-modern stops the import there (error 390).
    '' A round refuses at least one record, so the rounds end; the bound is a backstop.
    dim as Tko.CImport.CImportResult res
    dim as boolean imported
    for round as long = 1 to 16
        dim as Tko.CImport.CImportResult r1
        imported = Tko.CImport.CImportRun( api, io, r1 )
        res = r1
        if (imported = false) orelse ctx.options.cNoVerify then exit for
        dim as Tko.StrVec badName, badWhy
        if VerifyLayout( ctx, res.text, res.manifest, badName, badWhy ) = false then
            ctx.diags.ReportGlobal( Tko.TKO0122, ctx.options.cimportHeaders[0] )
            return Tko.EXIT_USER_ERROR
        end if
        if badName.Count = 0 then exit for
        for i as long = 0 to badName.Count - 1
            io.refuseName.Push( badName[i] )
            io.refuseWhy.Push( badWhy[i] )
        next
    next
    if imported = false then
        if res.rc = 3 then
            ctx.diags.ReportGlobal( Tko.TKO0119, res.why )
            return Tko.EXIT_NO_TOOLCHAIN
        end if
        '' fbc-modern's shape: the importer's words first, then clang's own text under a
        '' 'clang:' label so it is plainly somebody else's output, then the option that
        '' fixes it.
        ctx.diags.ReportGlobal( Tko.TKO0120, res.why )
        dim as Tko.SourceRange none_
        for i as long = 0 to res.clangDiags.Count - 1
            ctx.diags.AddNote( Tko.TKO0900, none_, "clang: " & res.clangDiags[i] )
        next
        if res.namedNotFound then
            ctx.diags.AddNote( Tko.TKO0900, none_, _
                "a header is found by the path given, then in each -cinclude directory" )
        end if
        if res.notFound then ctx.diags.AddNote( Tko.TKO0900, none_, NotFoundHint_( ctx ) )
        return Tko.EXIT_USER_ERROR
    end if

    if WriteBytes_( ctx.options.cimportOut, res.text ) = false then
        ctx.diags.ReportGlobal( Tko.TKO0121, ctx.options.cimportOut )
        return Tko.EXIT_USER_ERROR
    end if
    if len( ctx.options.cimportManifest ) then
        if WriteBytes_( ctx.options.cimportManifest, res.manifest ) = false then
            ctx.diags.ReportGlobal( Tko.TKO0121, ctx.options.cimportManifest )
            return Tko.EXIT_USER_ERROR
        end if
    end if
    return Tko.EXIT_OK
end function

end namespace
