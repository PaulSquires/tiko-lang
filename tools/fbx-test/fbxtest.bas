'' fbxtest.bas -- the fbx test runner.
''
''     bin/fbx-test [suite...] [--accept] [--filter <pat>] [--fbx <path>] [-v]
''
'' A test is a file under tests/ whose first lines carry directives in comments:
''
''     '' TEST: cli                 kind of test (see below)
''     '' ARGS: --dump-source %s    argument vector; %s is this file's path
''     '' EXPECT-EXIT: 0            required exit code
''     '' GOLDEN: expected/foo.out  golden output, relative to the test's directory
''     '' EXPECT-OUT: some text     required substring of the output (repeatable)
''     '' EXPECT-NOT: other text    forbidden substring (repeatable)
''     '' EXPECT-MAX-DIAG: 3        at most N ': error FBX' lines -- the recovery gate
''
'' Kinds:
''     cli     run fbx with ARGS and check exit code, golden and substrings
''     skip    parsed and reported as skipped -- a placeholder for a later phase
''
'' --accept rewrites GOLDEN files. It is the only sanctioned way to update them, and
'' the resulting diff is reviewed like code (docs/plan/13 section 3).
''
'' Output is deterministic: tests run in sorted path order regardless of anything.

#include once "fb/array.bi"
#include once "fb/filesystem.bi"
#include once "fb/sort.bi"

using FB

const RUNNER_VERSION as string = "0.1.0"

type TestCase
    as string path            '' the test file
    as string dir_            '' its directory
    as string kind
    as string args
    as long   expectExit
    as boolean haveExpectExit
    as string golden          '' relative to dir_, or "" for none
    as long   maxDiag
    as boolean haveMaxDiag
    as Array( of string ) expectOut
    as Array( of string ) expectNot
    as Array( of string ) env      '' NAME=value, set for this test's run only
end type

type Options
    as Array( of string ) suites
    as string filter
    as string fbxPath
    as boolean accept
    as boolean verbose
end type

'' ---------------------------------------------------------------- small helpers

function Trim_( byval s as string ) as string
    return trim( s, any !" \t\r\n" )
end function

function StartsWith( byval s as string, byval prefix as string ) as boolean
    if len( s ) < len( prefix ) then return false
    return (left( s, len( prefix ) ) = prefix)
end function

function ReadTextFile( byval path as string ) as string
    dim as FsResultUStr r = ReadAllText( path )
    if r.IsOk( ) = false then return ""
    return r.Value( )
end function

sub WriteTextFile( byval path as string, byval content as string )
    WriteAllText( path, content )
end sub

'' Normalise line endings so a golden written on one platform matches on the other.
function NormalizeEol( byval s as string ) as string
    dim as string outp = ""
    dim as long n = len( s )
    for i as long = 0 to n - 1
        if s[i] <> 13 then outp += chr( s[i] )
    next
    return outp
end function

'' Normalise a 'skip-site <file>:<line>' to 'skip-site <file>:LINE'.
''
'' Those lines name a source position INSIDE THE COMPILER, so every golden that
'' contains one breaks whenever the file above it grows by a line. That cost four
'' unrelated commits before anyone counted it. What the golden is actually asserting is
'' WHICH FILE gave up and HOW OFTEN -- the line number is a navigation aid in a sweep,
'' not a fact worth pinning.
''
'' Applied to both sides, so a golden written before this still matches.
function NormalizeSkipSites( byval s as string ) as string
    dim as string outp = ""
    dim as long n = len( s )
    dim as long i = 0
    while i < n
        '' '.bas:' followed by digits is the only shape this touches.
        if (i + 4 < n) andalso (s[i] = 46) then            '' '.'
            if mid( s, i + 1, 5 ) = ".bas:" then
                dim as long j = i + 5
                dim as long d = 0
                while (j < n) andalso (s[j] >= 48) andalso (s[j] <= 57)
                    j += 1
                    d += 1
                wend
                if d > 0 then
                    outp += ".bas:LINE"
                    i = j
                    continue while
                end if
            end if
        end if
        outp += chr( s[i] )
        i += 1
    wend
    return outp
end function

'' ------------------------------------------------------------------- discovery

sub CollectTests( byval root as string, byref found as Array( of string ) )
    '' The walk iterator yields a DirEntryResult, NOT a DirEntry. Binding it as
    '' 'for each e as DirEntry' compiles and then segfaults, so the element type is
    '' left inferred and unwrapped explicitly.
    for each entry in WalkDir( root )
        if entry.IsOk( ) = false then continue for
        dim as string sp = entry.Value( ).Path( )
        if lcase( right( sp, 5 ) ) = ".test" then found.Push( sp )
    next
end sub

'' ------------------------------------------------------------------- directives

function ParseTest( byval path as string, byref tc as TestCase ) as boolean
    dim as string text = ReadTextFile( path )
    if len( text ) = 0 then return false

    tc.path = path
    tc.kind = ""
    tc.args = ""
    tc.expectExit = 0
    tc.haveExpectExit = false
    tc.golden = ""
    tc.maxDiag = 0
    tc.haveMaxDiag = false
    tc.env.Clear( )

    dim as long slash = 0
    for i as long = len( path ) to 1 step -1
        dim as ubyte c = path[i - 1]
        dim as boolean isSep = (c = asc( "/" )) orelse (c = asc( "\" ))
        if isSep then
            slash = i
            exit for
        end if
    next
    tc.dir_ = left( path, slash )

    dim as string acc = NormalizeEol( text )
    dim as long start = 1
    while start <= len( acc )
        dim as long nl = instr( start, acc, chr( 10 ) )
        dim as string ln
        if nl = 0 then
            ln = mid( acc, start )
            start = len( acc ) + 1
        else
            ln = mid( acc, start, nl - start )
            start = nl + 1
        end if

        ln = Trim_( ln )
        if StartsWith( ln, "''" ) = false then continue while
        ln = Trim_( mid( ln, 3 ) )

        if StartsWith( ln, "TEST:" ) then
            tc.kind = Trim_( mid( ln, 6 ) )
        elseif StartsWith( ln, "ARGS:" ) then
            tc.args = Trim_( mid( ln, 6 ) )
        elseif StartsWith( ln, "EXPECT-EXIT:" ) then
            tc.expectExit = valint( Trim_( mid( ln, 13 ) ) )
            tc.haveExpectExit = true
        elseif StartsWith( ln, "GOLDEN:" ) then
            tc.golden = Trim_( mid( ln, 8 ) )
        elseif StartsWith( ln, "EXPECT-OUT:" ) then
            tc.expectOut.Push( Trim_( mid( ln, 12 ) ) )
        elseif StartsWith( ln, "EXPECT-MAX-DIAG:" ) then
            tc.maxDiag = valint( Trim_( mid( ln, 17 ) ) )
            tc.haveMaxDiag = true
        elseif StartsWith( ln, "EXPECT-NOT:" ) then
            tc.expectNot.Push( Trim_( mid( ln, 12 ) ) )
        elseif StartsWith( ln, "ENV:" ) then
            tc.env.Push( Trim_( mid( ln, 5 ) ) )
        end if
    wend

    return (len( tc.kind ) > 0)
end function

'' --------------------------------------------------------------------- running

'' Runs fbx and captures stdout+stderr together. This uses a shell redirection,
'' which the COMPILER itself is forbidden to do (docs/plan/14 section 7) -- the
'' prohibition is about untrusted input reaching a command line, and here every
'' component comes from a checked-in test file.
'' cmd.exe strips the outer quotes when a quoted command is combined with
'' redirection, so paths are converted to the native separator and quoted only when
'' they actually contain a space.
function NativePath( byval p as string ) as string
    dim as string r = p
    #ifdef __FB_WIN32__
        for i as long = 0 to len( r ) - 1
            if r[i] = asc( "/" ) then r[i] = asc( "\\" )
        next
    #endif
    if instr( r, " " ) > 0 then return """" & r & """"
    return r
end function

function RunFbx _
    ( byval fbxPath as string, byval args as string, byref outText as string ) as long

    dim as string tmp = "build/.fbxtest.out"
    '' --color=never goes FIRST: appended last, a trailing value-taking option in
    '' the test's own ARGS would swallow it as its value.
    dim as string cmd = NativePath( fbxPath ) & " --color=never " & args & _
                        " > " & NativePath( tmp ) & " 2>&1"
    dim as long rc = shell( cmd )
    outText = NormalizeEol( ReadTextFile( tmp ) )
    Kill( tmp )
    return rc
end function

type Failure
    as string test
    as string why
end type

function RunOne _
    ( byref tc as TestCase, byref opts as Options, byref why as string ) as boolean

    why = ""

    if tc.kind = "skip" then return true

    if tc.kind <> "cli" then
        why = "unknown TEST kind '" & tc.kind & "'"
        return false
    end if

    dim as string args = tc.args
    dim as long at = instr( args, "%s" )
    while at > 0
        args = left( args, at - 1 ) & tc.path & mid( args, at + 2 )
        at = instr( args, "%s" )
    wend

    '' The variable is set for this run and cleared straight after, so a test that
    '' needs an environment cannot leak it into the next one. Order matters: fbx reads
    '' it at startup, so it must be in place before the shell( ) and gone before the
    '' following test builds its own command.
    for each e_ as string in tc.env
        setenviron e_
    next

    dim as string outText = ""
    dim as long rc = RunFbx( opts.fbxPath, args, outText )

    for each e_ as string in tc.env
        dim as long eq = instr( e_, "=" )
        if eq > 0 then setenviron left( e_, eq )
    next

    if tc.haveExpectExit andalso (rc <> tc.expectExit) then
        why = "exit code " & rc & ", expected " & tc.expectExit
        return false
    end if

    for each want as string in tc.expectOut
        if instr( outText, want ) = 0 then
            why = "output does not contain: " & want
            return false
        end if
    next

    for each bad as string in tc.expectNot
        if instr( outText, bad ) > 0 then
            why = "output unexpectedly contains: " & bad
            return false
        end if
    next

    if tc.haveMaxDiag then
        '' The plan's recovery criterion: a broken file yields a few useful messages,
        '' not a cascade (docs/plan/04 section 8).
        dim as long count = 0
        dim as long at = instr( outText, ": error FBX" )
        while at > 0
            count += 1
            at = instr( at + 1, outText, ": error FBX" )
        wend
        if count > tc.maxDiag then
            why = "produced " & count & " diagnostics, at most " & tc.maxDiag & " allowed"
            return false
        end if
    end if

    if len( tc.golden ) > 0 then
        dim as string gpath = tc.dir_ & tc.golden
        if opts.accept then
            WriteTextFile( gpath, outText )
        else
            dim as string want = NormalizeEol( ReadTextFile( gpath ) )
            if NormalizeSkipSites( want ) <> NormalizeSkipSites( outText ) then
                why = "golden mismatch against " & gpath
                return false
            end if
        end if
    end if

    return true
end function

'' ------------------------------------------------------------------------ main

dim as Options opts
opts.fbxPath = "bin/fbx.exe"
#ifndef __FB_WIN32__
    opts.fbxPath = "bin/fbx"
#endif
opts.accept = false
opts.verbose = false
opts.filter = ""

dim as long argi = 1
while len( command( argi ) ) > 0
    dim as string a = command( argi )
    select case a
    case "--accept" : opts.accept = true
    case "-v"       : opts.verbose = true
    case "--filter" : argi += 1 : opts.filter = command( argi )
    case "--fbx"    : argi += 1 : opts.fbxPath = command( argi )
    case else
        if StartsWith( a, "-" ) then
            print "fbx-test: unknown option '" & a & "'"
            end 2
        end if
        opts.suites.Push( a )
    end select
    argi += 1
wend

if opts.suites.IsEmpty( ) then opts.suites.Push( "tests" )

dim as Array( of string ) files
for each suite as string in opts.suites
    CollectTests( suite, files )
next
Sort( files )

dim as long passed = 0, failed = 0, skipped = 0
dim as Array( of Failure ) failures

for each path as string in files
    if len( opts.filter ) > 0 then
        if instr( path, opts.filter ) = 0 then continue for
    end if

    dim as TestCase tc
    if ParseTest( path, tc ) = false then
        skipped += 1
        continue for
    end if

    if tc.kind = "skip" then
        skipped += 1
        if opts.verbose then print "SKIP " & path
        continue for
    end if

    dim as string why = ""
    if RunOne( tc, opts, why ) then
        passed += 1
        if opts.verbose then print "PASS " & path
    else
        failed += 1
        dim as Failure f
        f.test = path
        f.why = why
        failures.Push( f )
        print "FAIL " & path & ": " & why
    end if
next

print
print "fbx-test " & RUNNER_VERSION & ": " & passed & " passed, " & _
      failed & " failed, " & skipped & " skipped"

if failed > 0 then end 1
end 0
