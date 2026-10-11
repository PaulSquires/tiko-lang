'' plan.bas -- see plan.bi.

#import "std/containers"
#import "std/fs"
#include once "build/plan.bi"
#include once "driver/cmdline.bi"
#include once "driver/modresolve.bi"

namespace Tko.Build

function Rel( byref dir_ as string, byref p as string ) as string
    if len( p ) = 0 then return p
    dim as boolean absolute = (left( p, 1 ) = "/") orelse (left( p, 1 ) = "\") orelse (mid( p, 2, 1 ) = ":")
    if absolute orelse (len( dir_ ) = 0) orelse (dir_ = ".") then return p
    return dir_ & "/" & p
end function

function BaseName( byref p as string ) as string
    for i as long = len( p ) to 1 step -1
        dim as string ch = mid( p, i, 1 )
        if (ch = "/") orelse (ch = "\") then return mid( p, i + 1 )
    next
    return p
end function

'' The path less its extension, the directory kept.
function Stem( byref p as string ) as string
    for i as long = len( p ) to 1 step -1
        dim as string ch = mid( p, i, 1 )
        if (ch = "/") orelse (ch = "\") then exit for
        if ch = "." then return left( p, i - 1 )
    next
    return p
end function

function FindManifestDir( ) as string
    dim as string d = "."
    for depth as long = 0 to 63
        if Tko.Modules.HasManifest( d ) then return d
        dim as string up = iif( d = ".", "..", d & "/.." )
        '' THE ROOT is its own parent.
        if Tko.Modules.AbsPath( up ) = Tko.Modules.AbsPath( d ) then exit for
        d = up
    next
    return ""
end function

'' An array value as the manifest keeps it: elements joined by LF.
private sub SplitLf_( byref v as string, byref outv as Tko.StrVec )
    dim as long st = 1
    while st <= len( v )
        dim as long e = instr( st, v, chr( 10 ) )
        if e = 0 then e = len( v ) + 1
        dim as string one_ = mid( v, st, e - st )
        if len( one_ ) > 0 then outv.Push( one_ )
        st = e + 1
    wend
end sub

private function Builtin_( byref n as string ) as boolean
    return (n = "debug") orelse (n = "release")
end function

function ProfileExists( byref m as Tko.Modules.Manifest, byref name_ as string ) as boolean
    if Builtin_( name_ ) then return true
    for each x as string in m.profileNames
        if x = name_ then return true
    next
    return false
end function

sub ProfileNames( byref m as Tko.Modules.Manifest, byref outv as Tko.StrVec )
    outv.Push( "debug" )
    outv.Push( "release" )
    for each x as string in m.profileNames
        if Builtin_( x ) = false then outv.Push( x )
    next
end sub

private function ProfileList_( byref m as Tko.Modules.Manifest ) as string
    dim as Tko.StrVec names
    ProfileNames( m, names )
    dim as string r = ""
    for each x as string in names
        if len( r ) > 0 then r &= ", "
        r &= x
    next
    return r
end function

function ProfileFlags _
    ( byref m as Tko.Modules.Manifest, byref name_ as string, byref flags as Tko.StrVec, _
      byref diags as Tko.DiagnosticEngine ) as boolean

    if ProfileExists( m, name_ ) = false then
        diags.ReportGlobal( Tko.TKO0163, name_, ProfileList_( m ) )
        return false
    end if
    '' THE CHAIN, child first: name_, what it inherits, what that inherits...
    dim as Tko.StrVec chain
    dim as string cur = name_
    do
        for each c as string in chain
            if c = cur then
                dim as string path_ = ""
                for each x as string in chain
                    path_ &= x & " -> "
                next
                diags.ReportGlobal( Tko.TKO0164, name_, path_ & cur )
                return false
            end if
        next
        chain.Push( cur )
        dim as string parent = ""
        for k as long = 0 to m.prfName.Count - 1
            if (m.prfName[k] = cur) andalso (m.prfKey[k] = "inherits") then parent = m.prfVal[k]
        next
        if len( parent ) = 0 then exit do
        if ProfileExists( m, parent ) = false then
            diags.ReportGlobal( Tko.TKO0163, parent, ProfileList_( m ) )
            return false
        end if
        cur = parent
    loop

    '' ...APPLIED ANCESTOR FIRST: a built-in's own values, then the manifest's keys for it.
    dim as long dbg = -1, opt = -1
    dim as string errs = chr( 1 ), opts = chr( 1 )
    for i as long = chain.Count - 1 to 0 step -1
        dim as string pn = chain[i]
        if pn = "debug" then dbg = 1 : errs = "exx" : opt = 0
        if pn = "release" then dbg = 0 : errs = "" : opt = 2
        for k as long = 0 to m.prfName.Count - 1
            if m.prfName[k] <> pn then continue for
            select case m.prfKey[k]
            case "debug"   : dbg = iif( m.prfVal[k] = "true", 1, 0 )
            case "opt"     : opt = valint( m.prfVal[k] )
            case "errors"  : errs = m.prfVal[k]
            case "options" : opts = m.prfVal[k]
            end select
        next
    next
    if dbg = 1 then flags.Push( "-g" )
    if (errs <> chr( 1 )) andalso (len( errs ) > 0) then flags.Push( "-" & errs )
    if opt >= 0 then flags.Push( "-O" & opt )
    if opts <> chr( 1 ) then SplitLf_( opts, flags )
    return true
end function

'' The file name the classic driver gives an output of this kind, by its own rule: a
'' throwaway input named after the target, parsed, asked.
private function DefaultName_ _
    ( byref tname as string, byref kind as string, byref tgt as string, _
      byref diags as Tko.DiagnosticEngine ) as string

    dim as Tko.StrVec d
    d.Push( tname & ".bas" )
    if kind = "dll" then d.Push( "-dll" )
    if kind = "lib" then d.Push( "-lib" )
    if len( tgt ) > 0 then d.Push( "-target" ) : d.Push( tgt )
    dim as Tko.DriverOptions o
    if Tko.Cmdline.Parse( d, o, diags ) = false then return ""
    return BaseName( Tko.Driver.DefaultOutput( o ) )
end function

private function TargetKey_ _
    ( byref m as Tko.Modules.Manifest, byref tname as string, byref key as string ) as string
    dim as string v = ""
    for k as long = 0 to m.tgtName.Count - 1
        if (m.tgtName[k] = tname) andalso (m.tgtKey[k] = key) then v = m.tgtVal[k]
    next
    return v
end function

function TargetOutput _
    ( byref a as BuildArgs, byref m as Tko.Modules.Manifest, byref mdir as string, _
      byref tname as string, byref profile as string, byref diags as Tko.DiagnosticEngine ) as string

    dim as string out_ = TargetKey_( m, tname, "output" )
    if len( out_ ) > 0 then return Rel( mdir, out_ )
    dim as string kind = TargetKey_( m, tname, "kind" )
    if len( kind ) = 0 then kind = "exe"
    dim as string nm = DefaultName_( tname, kind, a.target, diags )
    if len( nm ) = 0 then return ""
    return Rel( mdir, "out/" & profile & "/" & nm )
end function

'' A root or resource must be a FILE: a module directory is reached through #import (TKO0161),
'' and anything else that is not there is TKO0162.
private function CheckInput_ _
    ( byref tname as string, byref p as string, byref diags as Tko.DiagnosticEngine ) as boolean
    if fs.IsDir( p ) then
        diags.ReportGlobal( Tko.TKO0161, tname, p )
        return false
    end if
    if fs.IsFile( p ) = false then
        diags.ReportGlobal( Tko.TKO0162, tname, p )
        return false
    end if
    return true
end function

private sub Tail_( byref a as BuildArgs, byref p as TargetPlan )
    if len( a.target ) > 0 then p.dargs.Push( "-target" ) : p.dargs.Push( a.target )
    if len( p.artifact ) > 0 then p.dargs.Push( "-o" ) : p.dargs.Push( p.artifact )
    if len( a.diagFile ) > 0 then p.dargs.Push( "--diagnostics-file" ) : p.dargs.Push( a.diagFile )
    if a.verbose then p.dargs.Push( "-v" )
end sub

function PlanTarget _
    ( byref a as BuildArgs, byref m as Tko.Modules.Manifest, byref mdir as string, _
      byref tname as string, byref profile as string, byref p as TargetPlan, _
      byref diags as Tko.DiagnosticEngine ) as boolean

    p.name = tname
    p.profile = profile
    p.kind = "exe"
    dim as string main_, subsys
    dim as Tko.StrVec sources, libs, libpaths, topts
    for k as long = 0 to m.tgtName.Count - 1
        if m.tgtName[k] <> tname then continue for
        dim as string v = m.tgtVal[k]
        select case m.tgtKey[k]
        case "main"      : main_ = v
        case "kind"      : p.kind = v
        case "subsystem" : subsys = v
        case "sources"   : SplitLf_( v, sources )
        case "resources" : SplitLf_( v, p.resources )
        case "libs"      : SplitLf_( v, libs )
        case "libpaths"  : SplitLf_( v, libpaths )
        case "options"   : SplitLf_( v, topts )
        case "define"    : p.defines.Push( v )
        end select
    next
    if len( main_ ) = 0 then
        diags.ReportGlobal( Tko.TKO0144, Rel( mdir, "tiko.toml" ) & ": [target." & tname & "] needs 'main'" )
        return false
    end if
    dim as boolean ok = true
    p.roots.Push( Rel( mdir, main_ ) )
    for each s as string in sources
        p.roots.Push( Rel( mdir, s ) )
    next
    for each r as string in p.roots
        if CheckInput_( tname, r, diags ) = false then ok = false
    next
    for i as long = 0 to p.resources.Count - 1
        p.resources[i] = Rel( mdir, p.resources[i] )
        if CheckInput_( tname, p.resources[i], diags ) = false then ok = false
    next
    if ProfileFlags( m, profile, p.flags, diags ) = false then ok = false
    if ok = false then return false
    for each x as string in topts
        p.flags.Push( x )
    next
    for each x as string in a.extra
        p.flags.Push( x )
    next
    p.artifact = TargetOutput( a, m, mdir, tname, profile, diags )
    if len( p.artifact ) = 0 then return false

    for each x as string in p.flags
        p.dargs.Push( x )
    next
    for each x as string in p.roots
        p.dargs.Push( x )
    next
    for each x as string in p.resources
        p.dargs.Push( x )
    next
    if p.kind = "dll" then p.dargs.Push( "-dll" )
    if p.kind = "lib" then p.dargs.Push( "-lib" )
    if len( subsys ) > 0 then p.dargs.Push( "-s" ) : p.dargs.Push( subsys )
    for each x as string in libs
        p.dargs.Push( "-l" ) : p.dargs.Push( x )
    next
    for each x as string in libpaths
        p.dargs.Push( "-p" ) : p.dargs.Push( Rel( mdir, x ) )
    next
    for each x as string in p.defines
        p.dargs.Push( "-d" ) : p.dargs.Push( x )
    next
    Tail_( a, p )
    return true
end function

function PlanImplicit _
    ( byref a as BuildArgs, byref m as Tko.Modules.Manifest, byref p as TargetPlan, _
      byref diags as Tko.DiagnosticEngine ) as boolean

    p.name = BaseName( Stem( a.words[0] ) )
    p.profile = iif( a.hasProfile, a.profile, "" )
    p.kind = "exe"
    if a.hasProfile then
        if ProfileFlags( m, a.profile, p.flags, diags ) = false then return false
    end if
    for each x as string in a.extra
        p.flags.Push( x )
        if x = "-dll" then p.kind = "dll"
        if x = "-lib" then p.kind = "lib"
    next
    for each x as string in a.words
        if lcase( right( x, 3 ) ) = ".rc" then p.resources.Push( x ) else p.roots.Push( x )
    next
    for each x as string in p.flags
        p.dargs.Push( x )
    next
    for each x as string in a.words
        p.dargs.Push( x )
    next
    '' THE OUTPUT the classic driver would write: -o, or its own default for these arguments.
    p.artifact = a.outPath
    if len( p.artifact ) = 0 then
        dim as Tko.StrVec d
        for each x as string in p.dargs
            d.Push( x )
        next
        if len( a.target ) > 0 then d.Push( "-target" ) : d.Push( a.target )
        dim as Tko.DriverOptions o
        if Tko.Cmdline.Parse( d, o, diags ) = false then return false
        p.artifact = Tko.Driver.DefaultOutput( o )
    end if
    Tail_( a, p )
    return true
end function

end namespace
